import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class ArtistUploadScreen extends StatefulWidget {
  const ArtistUploadScreen({super.key});

  @override
  State<ArtistUploadScreen> createState() => _ArtistUploadScreenState();
}

class _ArtistUploadScreenState extends State<ArtistUploadScreen> {
  final artistController = TextEditingController();
  final songController = TextEditingController();
  final albumController = TextEditingController();
  final descriptionController = TextEditingController();

  final FirebaseStorage _storage = FirebaseStorage.instance;
  final DatabaseReference _database =
      FirebaseDatabase.instance.ref();

  String selectedGenre = 'Santhali';

  PlatformFile? selectedAudio;
  PlatformFile? selectedCover;

  bool isUploading = false;
  double uploadProgress = 0;

  final List<String> genres = [
    'Santhali',
    'Hindi',
    'Bengali',
    'English',
    'Other',
  ];

  @override
  void dispose() {
    artistController.dispose();
    songController.dispose();
    albumController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> pickAudio() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: [
          'mp3',
          'wav',
          'm4a',
          'aac',
          'ogg',
        ],
      );

      if (result == null || result.files.isEmpty) {
        return;
      }

      final file = result.files.first;

      if (file.path == null) {
        _showMessage('Audio file access nahi ho saka.');
        return;
      }

      setState(() {
        selectedAudio = file;
      });
    } catch (e) {
      _showMessage('Audio select nahi ho saka.');
    }
  }

  Future<void> pickCover() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: [
          'jpg',
          'jpeg',
          'png',
          'webp',
        ],
      );

      if (result == null || result.files.isEmpty) {
        return;
      }

      final file = result.files.first;

      if (file.path == null) {
        _showMessage('Cover image access nahi ho saka.');
        return;
      }

      setState(() {
        selectedCover = file;
      });
    } catch (e) {
      _showMessage('Cover image select nahi ho saka.');
    }
  }

  Future<String> _uploadFile({
    required File file,
    required String path,
    required void Function(double progress) onProgress,
  }) async {
    final reference = _storage.ref().child(path);

    final uploadTask = reference.putFile(file);

    uploadTask.snapshotEvents.listen((snapshot) {
      if (snapshot.totalBytes > 0) {
        final progress =
            snapshot.bytesTransferred / snapshot.totalBytes;

        onProgress(progress);
      }
    });

    final snapshot = await uploadTask;

    return await snapshot.ref.getDownloadURL();
  }

  Future<void> submitSong() async {
    final artistName = artistController.text.trim();
    final songTitle = songController.text.trim();
    final albumName = albumController.text.trim();
    final description = descriptionController.text.trim();

    if (artistName.isEmpty) {
      _showMessage('Artist name enter karein.');
      return;
    }

    if (songTitle.isEmpty) {
      _showMessage('Song title enter karein.');
      return;
    }

    if (selectedAudio == null) {
      _showMessage('Pehle audio file select karein.');
      return;
    }

    if (selectedCover == null) {
      _showMessage('Pehle cover image select karein.');
      return;
    }

    final audioPath = selectedAudio!.path;
    final coverPath = selectedCover!.path;

    if (audioPath == null || coverPath == null) {
      _showMessage('Selected file access nahi ho saka.');
      return;
    }

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      _showMessage(
        'Upload karne ke liye pehle login karein.',
      );
      return;
    }

    setState(() {
      isUploading = true;
      uploadProgress = 0;
    });

    try {
      final songId =
          _database.child('pending_songs').push().key;

      if (songId == null) {
        throw Exception('Song ID create nahi hua.');
      }

      final audioFile = File(audioPath);
      final coverFile = File(coverPath);

      final audioUrl = await _uploadFile(
        file: audioFile,
        path: 'songs/$songId/audio/${selectedAudio!.name}',
        onProgress: (progress) {
          if (mounted) {
            setState(() {
              uploadProgress = progress * 0.8;
            });
          }
        },
      );

      final coverUrl = await _uploadFile(
        file: coverFile,
        path: 'songs/$songId/cover/${selectedCover!.name}',
        onProgress: (progress) {
          if (mounted) {
            setState(() {
              uploadProgress = 0.8 + (progress * 0.2);
            });
          }
        },
      );

      await _database
          .child('pending_songs')
          .child(songId)
          .set({
        'songId': songId,
        'artistId': user.uid,
        'artistName': artistName,
        'songTitle': songTitle,
        'albumName': albumName,
        'genre': selectedGenre,
        'description': description,
        'audioUrl': audioUrl,
        'coverUrl': coverUrl,
        'status': 'pending',
        'createdAt': ServerValue.timestamp,
      });

      if (!mounted) return;

      setState(() {
        isUploading = false;
        uploadProgress = 1;
      });

      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: const Color(0xFF18181F),
            title: const Text(
              'Upload Successful',
              style: TextStyle(color: Colors.white),
            ),
            content: const Text(
              'Aapka song successfully upload ho gaya hai '
              'aur approval ke liye bhej diya gaya hai.',
              style: TextStyle(color: Colors.white70),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );

      if (!mounted) return;

      artistController.clear();
      songController.clear();
      albumController.clear();
      descriptionController.clear();

      setState(() {
        selectedAudio = null;
        selectedCover = null;
        selectedGenre = 'Santhali';
        uploadProgress = 0;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isUploading = false;
      });

      _showMessage(
        'Upload failed. Firebase settings/rules check karein.',
      );
    }
  }

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0B0F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B0B0F),
        elevation: 0,
        leading: IconButton(
          onPressed: isUploading
              ? null
              : () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text(
          'Upload Music',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 35),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF7C3AED),
                    Color(0xFFEC4899),
                  ],
                ),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.cloud_upload_rounded,
                    size: 42,
                    color: Colors.white,
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Share your music',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Upload your original music to SERENG.',
                    style: TextStyle(
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            const Text(
              'Song Information',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            _label('Artist Name'),
            _input(
              controller: artistController,
              hint: 'Enter artist name',
              icon: Icons.person_outline,
            ),

            const SizedBox(height: 17),

            _label('Song Title'),
            _input(
              controller: songController,
              hint: 'Enter song title',
              icon: Icons.music_note_outlined,
            ),

            const SizedBox(height: 17),

            _label('Album Name'),
            _input(
              controller: albumController,
              hint: 'Enter album name',
              icon: Icons.album_outlined,
            ),

            const SizedBox(height: 17),

            _label('Genre'),

            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF18181F),
                borderRadius: BorderRadius.circular(15),
              ),
              child: DropdownButtonFormField<String>(
                initialValue: selectedGenre,
                dropdownColor: const Color(0xFF18181F),
                decoration: const InputDecoration(
                  prefixIcon: Icon(
                    Icons.category_outlined,
                    color: Colors.white54,
                  ),
                  border: InputBorder.none,
                ),
                items: genres.map((genre) {
                  return DropdownMenuItem<String>(
                    value: genre,
                    child: Text(genre),
                  );
                }).toList(),
                onChanged: isUploading
                    ? null
                    : (value) {
                        if (value != null) {
                          setState(() {
                            selectedGenre = value;
                          });
                        }
                      },
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              'Cover Image',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            InkWell(
              onTap: isUploading ? null : pickCover,
              borderRadius: BorderRadius.circular(18),
              child: Container(
                width: double.infinity,
                height: 160,
                decoration: BoxDecoration(
                  color: const Color(0xFF141419),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: Colors.white12,
                  ),
                ),
                child: selectedCover == null
                    ? const Column(
                        mainAxisAlignment:
                            MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_photo_alternate_outlined,
                            size: 45,
                            color: Colors.white54,
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Add Cover Image',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'JPG, PNG or WEBP',
                            style: TextStyle(
                              color: Colors.white38,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      )
                    : Column(
                        mainAxisAlignment:
                            MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.check_circle_rounded,
                            size: 45,
                            color: Colors.greenAccent,
                          ),
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                            ),
                            child: Text(
                              selectedCover!.name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),
                          const Text(
                            'Tap to change',
                            style: TextStyle(
                              color: Colors.white38,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              'Audio File',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            InkWell(
              onTap: isUploading ? null : pickAudio,
              borderRadius: BorderRadius.circular(18),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF141419),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: Colors.white12,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      selectedAudio == null
                          ? Icons.audio_file_outlined
                          : Icons.check_circle_rounded,
                      size: 40,
                      color: selectedAudio == null
                          ? Colors.white54
                          : Colors.greenAccent,
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            selectedAudio == null
                                ? 'Select Audio File'
                                : selectedAudio!.name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          const Text(
                            'MP3, WAV, M4A, AAC or OGG',
                            style: TextStyle(
                              color: Colors.white38,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right,
                      color: Colors.white38,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              'Description',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: descriptionController,
              maxLines: 5,
              enabled: !isUploading,
              style: const TextStyle(
                color: Colors.white,
              ),
              decoration: InputDecoration(
                hintText: 'Tell listeners about this song...',
                hintStyle: const TextStyle(
                  color: Colors.white38,
                ),
                filled: true,
                fillColor: const Color(0xFF18181F),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 25),

            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: const Color(0xFF141419),
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Row(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Colors.white54,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Your music will be reviewed before it '
                      'becomes available on SERENG.',
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            if (isUploading) ...[
              Text(
                'Uploading ${(uploadProgress * 100).round()}%',
                style: const TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: uploadProgress,
                minHeight: 6,
                borderRadius: BorderRadius.circular(10)
