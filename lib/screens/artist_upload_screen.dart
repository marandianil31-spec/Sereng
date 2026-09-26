import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class ArtistUploadScreen extends StatefulWidget {
  const ArtistUploadScreen({super.key});

  @override
  State<ArtistUploadScreen> createState() =>
      _ArtistUploadScreenState();
}

class _ArtistUploadScreenState
    extends State<ArtistUploadScreen> {
  final TextEditingController artistController =
      TextEditingController();

  final TextEditingController songController =
      TextEditingController();

  final TextEditingController albumController =
      TextEditingController();

  final TextEditingController descriptionController =
      TextEditingController();

  String selectedGenre = 'Santhali';

  File? coverImage;
  String? coverFileName;

  File? audioFile;
  String? audioFileName;

  bool isSubmitting = false;

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

  // ======================================================
  // COVER IMAGE PICKER
  // ======================================================

  Future<void> pickCoverImage() async {
    if (isSubmitting) return;

    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (!mounted) return;

      if (result == null || result.files.isEmpty) {
        return;
      }

      final path = result.files.single.path;

      if (path == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Image select nahi ho saki.',
            ),
          ),
        );
        return;
      }

      setState(() {
        coverImage = File(path);
        coverFileName = result.files.single.name;
      });
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Image select karne mein error: $e',
          ),
        ),
      );
    }
  }

  // ======================================================
  // AUDIO FILE PICKER
  // ======================================================

  Future<void> pickAudioFile() async {
    if (isSubmitting) return;

    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: [
          'mp3',
          'wav',
          'm4a',
          'aac',
          'flac',
          'ogg',
        ],
        allowMultiple: false,
      );

      if (!mounted) return;

      if (result == null || result.files.isEmpty) {
        return;
      }

      final path = result.files.single.path;

      if (path == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Audio select nahi ho saka.',
            ),
          ),
        );
        return;
      }

      setState(() {
        audioFile = File(path);
        audioFileName = result.files.single.name;
      });
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Audio select karne mein error: $e',
          ),
        ),
      );
    }
  }

  // ======================================================
  // SUBMIT SONG TO FIREBASE
  // ======================================================

  Future<void> submitSong() async {
    if (isSubmitting) return;

    final String artist =
        artistController.text.trim();

    final String song =
        songController.text.trim();

    final String album =
        albumController.text.trim();

    final String description =
        descriptionController.text.trim();

    // Artist validation
    if (artist.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Artist name enter kijiye.',
          ),
        ),
      );
      return;
    }

    // Song validation
    if (song.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Song title enter kijiye.',
          ),
        ),
      );
      return;
    }

    // Cover validation
    if (coverImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Cover image select kijiye.',
          ),
        ),
      );
      return;
    }

    // Audio validation
    if (audioFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Audio file select kijiye.',
          ),
        ),
      );
      return;
    }

    // Firebase Auth user
    final User? user =
        FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please login karke dobara try kijiye.',
          ),
        ),
      );
      return;
    }

    setState(() {
      isSubmitting = true;
    });

    try {
      // Unique ID
      final String songId =
          DateTime.now()
              .millisecondsSinceEpoch
              .toString();

      final String basePath =
          'artists/${user.uid}/songs/$songId';

      // ==================================================
      // COVER UPLOAD
      // ==================================================

      final Reference coverReference =
          FirebaseStorage.instance
              .ref()
              .child('$basePath/cover.jpg');

      await coverReference.putFile(
        coverImage!,
        SettableMetadata(
          contentType: 'image/jpeg',
        ),
      );

      final String coverUrl =
          await coverReference.getDownloadURL();

      // ==================================================
      // AUDIO UPLOAD
      // ==================================================

      final String audioExtension =
          audioFileName != null &&
                  audioFileName!.contains('.')
              ? audioFileName!
                  .split('.')
                  .last
                  .toLowerCase()
              : 'mp3';

      final Reference audioReference =
          FirebaseStorage.instance
              .ref()
              .child(
                '$basePath/audio.$audioExtension',
              );

      await audioReference.putFile(
        audioFile!,
        SettableMetadata(
          contentType:
              _getAudioContentType(
            audioExtension,
          ),
        ),
      );

      final String audioUrl =
          await audioReference.getDownloadURL();

      // ==================================================
      // FIRESTORE SONG DOCUMENT
      // ==================================================

      await FirebaseFirestore.instance
          .collection('songs')
          .doc(songId)
          .set({
        'songId': songId,
        'songTitle': song,
        'artistName': artist,
        'albumName': album,
        'genre': selectedGenre,
        'description': description,
        'coverUrl': coverUrl,
        'audioUrl': audioUrl,
        'artistUid': user.uid,
        'artistEmail': user.email,
        'status': 'pending',
        'isApproved': false,
        'createdAt':
            FieldValue.serverTimestamp(),
      });

      if (!mounted) return;

      setState(() {
        isSubmitting = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Song successfully submitted for approval.',
          ),
          duration: Duration(seconds: 3),
        ),
      );

      await Future.delayed(
        const Duration(milliseconds: 900),
      );

      if (!mounted) return;

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isSubmitting = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Upload failed: $e',
          ),
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }

  // ======================================================
  // AUDIO CONTENT TYPE
  // ======================================================

  String _getAudioContentType(
    String extension,
  ) {
    switch (extension) {
      case 'mp3':
        return 'audio/mpeg';

      case 'wav':
        return 'audio/wav';

      case 'm4a':
        return 'audio/mp4';

      case 'aac':
        return 'audio/aac';

      case 'flac':
        return 'audio/flac';

      case 'ogg':
        return 'audio/ogg';

      default:
        return 'audio/mpeg';
    }
  }

  // ======================================================
  // BUILD
  // ======================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFF0B0B0F),

      appBar: AppBar(
        backgroundColor:
            const Color(0xFF0B0B0F),
        elevation: 0,

        leading: IconButton(
          onPressed: isSubmitting
              ? null
              : () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back,
          ),
        ),

        title: const Text(
          'Upload Music',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          16,
          10,
          16,
          35,
        ),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [
            // ==================================================
            // HEADER
            // ==================================================

            Container(
              width: double.infinity,

              padding:
                  const EdgeInsets.all(20),

              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.circular(20),

                gradient:
                    const LinearGradient(
                  colors: [
                    Color(0xFF7C3AED),
                    Color(0xFFEC4899),
                  ],
                ),
              ),

              child: const Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

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
                      fontWeight:
                          FontWeight.bold,
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

            // ==================================================
            // SONG INFORMATION
            // ==================================================

            const Text(
              'Song Information',
              style: TextStyle(
                fontSize: 20,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            _label('Artist Name'),

            _input(
              controller:
                  artistController,
              hint:
                  'Enter artist name',
              icon:
                  Icons.person_outline,
            ),

            const SizedBox(height: 17),

            _label('Song Title'),

            _input(
              controller:
                  songController,
              hint:
                  'Enter song title',
              icon:
                  Icons.music_note_outlined,
            ),

            const SizedBox(height: 17),

            _label('Album Name'),

            _input(
              controller:
                  albumController,
              hint:
                  'Enter album name',
              icon:
                  Icons.album_outlined,
            ),

            const SizedBox(height: 17),

            _label('Genre'),

            Container(
              decoration:
                  BoxDecoration(
                color:
                    const Color(0xFF18181F),
                borderRadius:
                    BorderRadius.circular(15),
              ),

              child:
                  DropdownButtonFormField<
                      String>(
                initialValue:
                    selectedGenre,

                dropdownColor:
                    const Color(
                        0xFF18181F),

                decoration:
                    const InputDecoration(
                  prefixIcon:
                      Icon(
                    Icons.category_outlined,
                    color:
                        Colors.white54,
                  ),
                  border:
                      InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                ),

                items:
                    genres.map(
                  (genre) {
                    return DropdownMenuItem<
                        String>(
                      value: genre,
                      child:
                          Text(genre),
                    );
                  },
                ).toList(),

                onChanged:
                    isSubmitting
                        ? null
                        : (value) {
                            if (value ==
                                null) {
                              return;
                            }

                            setState(() {
                              selectedGenre =
                                  value;
                            });
                          },
              ),
            ),

            const SizedBox(height: 25),

            // ==================================================
            // COVER IMAGE
            // ==================================================

            const Text(
              'Cover Image',
              style: TextStyle(
                fontSize: 20,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            InkWell(
              onTap:
                  pickCoverImage,

              borderRadius:
                  BorderRadius.circular(18),

              child: Container(
                width:
                    double.infinity,

                height: 190,

                decoration:
                    BoxDecoration(
                  color:
                      const Color(
                          0xFF141419),

                  borderRadius:
                      BorderRadius.circular(
                          18),

                  border:
                      Border.all(
                    color:
                        Colors.white12,
                  ),
                ),

                child:
                    coverImage == null
                        ? const Column(
                            mainAxisAlignment:
                                MainAxisAlignment
                                    .center,

                            children: [
                              Icon(
                                Icons
                                    .add_photo_alternate_outlined,
                                size: 45,
                                color:
                                    Colors.white54,
                              ),

                              SizedBox(
                                  height: 10),

                              Text(
                                'Add Cover Image',
                                style:
                                    TextStyle(
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),

                              SizedBox(
                                  height: 5),

                              Text(
                                'JPG or PNG',
                                style:
                                    TextStyle(
                                  color:
                                      Colors.white38,
                                  fontSize:
                                      12,
                                ),
                              ),
                            ],
                          )
                        : ClipRRect(
                            borderRadius:
                                BorderRadius.circular(
                                    18),

                            child:
                                Stack(
                              fit:
                                  StackFit.expand,

                              children: [
                                Image.file(
                                  coverImage!,
                                  fit:
                                      BoxFit.cover,
                                ),

                                Container(
                                  alignment:
                                      Alignment
                                          .bottomCenter,

                                  padding:
                                      const EdgeInsets
                                          .all(12),

                                  decoration:
                                      const BoxDecoration(
                                    gradient:
                                        LinearGradient(
                                      begin:
                                          Alignment
                                              .topCenter,
                                      end:
                                          Alignment
                                              .bottomCenter,
                                      colors: [
                                        Colors
                                            .transparent,
                                        Colors
                                            .black87,
                                      ],
                                    ),
                                  ),

                                  child:
                                      Text(
                                    coverFileName ??
                                        '',
                                    maxLines: 1,
                                    overflow:
                                        TextOverflow
                                            .ellipsis,
                                    style:
                                        const TextStyle(
                                      fontWeight:
                                          FontWeight
                                              .bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
              ),
            ),

            const SizedBox(height: 25),

            // ==================================================
            // AUDIO FILE
            // ==================================================

            const Text(
              'Audio File',
              style: TextStyle(
                fontSize: 20,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            InkWell(
              onTap:
                  pickAudioFile,

              borderRadius:
                  BorderRadius.circular(18),

              child: Container(
                width:
                    double.infinity,

                padding:
                    const EdgeInsets.all(20),

                decoration:
                    BoxDecoration(
                  color:
                      const Color(
                          0xFF141419),

                  borderRadius:
                      BorderRadius.circular(
                          18),

                  border:
                      Border.all(
                    color:
                        Colors.white12,
                  ),
                ),

                child: Row(
                  children: [
                    Icon(
                      audioFile == null
                          ? Icons
                              .audio_file_outlined
                          : Icons
                              .check_circle_rounded,

                      size: 40,

                      color:
                          audioFile == null
                              ? Colors.white54
                              : Colors.greenAccent,
                    ),

                    const SizedBox(
                        width: 15),

                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,

                        children: [
                          Text(
                            audioFileName ??
                                'Select Audio File',

                            maxLines: 2,

                            overflow:
                                TextOverflow
                                    .ellipsis,

                            style:
                                const TextStyle(
                              fontWeight:
                                  FontWeight
                                      .bold,
                            ),
                          ),

                          const SizedBox(
                              height: 5),

                          Text(
                            audioFile == null
                                ? 'MP3, WAV, M4A or supported audio'
                                : 'Audio selected successfully',

                            style:
                                const TextStyle(
                              color:
                                  Colors.white38,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const Icon(
                      Icons.chevron_right,
                      color:
                          Colors.white38,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 25),

            // ==================================================
            // DESCRIPTION
            // ==================================================

            const Text(
              'Description',
              style: TextStyle(
                fontSize: 20,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            TextField(
              controller:
                  descriptionController,

              maxLines: 5,

              enabled:
                  !isSubmitting,

              style:
                  const TextStyle(
                color: Colors.white,
              ),

              decoration:
                  InputDecoration(
                hintText:
                    'Tell listeners about this song...',

                hintStyle:
                    const TextStyle(
                  color:
                      Colors.white38,
                ),

                filled: true,

                fillColor:
                    const Color(
                        0xFF18181F),

                border:
                    OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(
                          15),

                  borderSide:
                      BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 25),

            // ==================================================
            // APPROVAL NOTICE
            // ==================================================

            Container(
              padding:
                  const EdgeInsets.all(15),

              decoration:
                  BoxDecoration(
                color:
                    const Color(
                        0xFF141419),

                borderRadius:
                    BorderRadius.circular(
                        15),
              ),

              child: const Row(
                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,

                children: [
                  Icon(
                    Icons.info_outline,
                    color:
                        Colors.white54,
                  ),

                  SizedBox(
                      width: 12),

                  Expanded(
                    child: Text(
                      'Your music will be reviewed before it becomes available on SERENG.',

                      style:
                          TextStyle(
                        color:
                            Colors.white54,
                        fontSize:
                            12,
                        height:
                            1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // ==================================================
            // SUBMIT BUTTON
            // ==================================================

            SizedBox(
              width:
                  double.infinity,

              height: 54,

              child:
                  ElevatedButton.icon(
                onPressed:
                    isSubmitting
                        ? null
                        : submitSong,

                icon:
                    isSubmitting
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child:
                                CircularProgressIndicator(
                              strokeWidth:
                                  2,
                              color:
                                  Colors.black,
                            ),
                          )
                        : const Icon(
                            Icons
                                .upload_rounded,
                          ),

                label:
                    Text(
                  isSubmitting
                      ? 'Uploading...'
                      : 'Submit for Approval',

                  style:
                      const TextStyle(
                    fontSize:
                        16,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                style:
                    ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.white,

                  foregroundColor:
                      Colors.black,

                  disabledBackgroundColor:
                      Colors.white70,

                  disabledForegroundColor:
                      Colors.black54,

                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(
                            15),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ======================================================
  // LABEL
  // ======================================================

  Widget _label(String text) {
    return Padding(
      padding:
          const EdgeInsets.only(
        bottom: 8,
      ),
      child: Text(
        text,
        style:
            const TextStyle(
          fontWeight:
              FontWeight.w600,
        ),
      ),
    );
  }

  // ======================================================
  // TEXT INPUT
  // ======================================================

  Widget _input({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
  }) {
    return TextField(
      controller:
          controller,

      enabled:
          !isSubmitting,

      style:
          const TextStyle(
        color: Colors.white,
      ),

      decoration:
          InputDecoration(
        hintText:
            hint,

        hintStyle:
            const TextStyle(
          color:
              Colors.white38,
        ),

        prefixIcon:
            Icon(
          icon,
          color:
              Colors.white54,
        ),

        filled:
            true,

        fillColor:
            const Color(
                0xFF18181F),

        border:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(
                  15),

          borderSide:
              BorderSide.none,
        ),
      ),
    );
  }
}
