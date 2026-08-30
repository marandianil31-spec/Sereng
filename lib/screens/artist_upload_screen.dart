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

  String selectedGenre = 'Santhali';

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

  void submitSong() {
    if (artistController.text.trim().isEmpty ||
        songController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please enter artist name and song title.',
          ),
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Song submitted for approval.',
        ),
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
          onPressed: () => Navigator.pop(context),
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
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                ),
                items: genres.map((genre) {
                  return DropdownMenuItem<String>(
                    value: genre,
                    child: Text(genre),
                  );
                }).toList(),
                onChanged: (value) {
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
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Image picker will be connected later.',
                    ),
                  ),
                );
              },
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
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
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
                      'JPG or PNG',
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
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Audio picker will be connected later.',
                    ),
                  ),
                );
              },
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
                child: const Row(
                  children: [
                    Icon(
                      Icons.audio_file_outlined,
                      size: 40,
                      color: Colors.white54,
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Select Audio File',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'MP3, WAV or supported audio',
                            style: TextStyle(
                              color: Colors.white38,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
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
              style: const TextStyle(
                color: Colors.white,
              ),
              decoration: InputDecoration(
                hintText:
                    'Tell listeners about this song...',
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

            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton.icon(
                onPressed: submitSong,
                icon: const Icon(Icons.upload_rounded),
                label: const Text(
                  'Submit for Approval',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(15),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _input({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      style: const TextStyle(
        color: Colors.white,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          color: Colors.white38,
        ),
        prefixIcon: Icon(
          icon,
          color: Colors.white54,
        ),
        filled: true,
        fillColor: const Color(0xFF18181F),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
