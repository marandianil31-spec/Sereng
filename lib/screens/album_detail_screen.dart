import 'package:flutter/material.dart';

import 'music_player_screen.dart';

class AlbumDetailScreen extends StatelessWidget {
  final String albumName;
  final String artistName;

  const AlbumDetailScreen({
    super.key,
    required this.albumName,
    required this.artistName,
  });

  final List<Map<String, String>> songs = const [
    {
      'title': 'Dular Re',
      'duration': '3:42',
      'audioUrl': '',
    },
    {
      'title': 'Baha Bonga',
      'duration': '4:05',
      'audioUrl': '',
    },
    {
      'title': 'Amge Mon',
      'duration': '3:51',
      'audioUrl': '',
    },
    {
      'title': 'Johar Re',
      'duration': '4:12',
      'audioUrl': '',
    },
    {
      'title': 'Sari Sari',
      'duration': '3:36',
      'audioUrl': '',
    },
    {
      'title': 'Dular Gate',
      'duration': '4:20',
      'audioUrl': '',
    },
  ];

  void openPlayer(
    BuildContext context,
    String title,
    String audioUrl,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MusicPlayerScreen(
          songTitle: title,
          artistName: artistName,
          audioUrl: audioUrl,
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
        title: const Text('Album Details'),
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),

        children: [
          Container(
            height: 220,

            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),

              gradient: const LinearGradient(
                colors: [
                  Color(0xFF7C3AED),
                  Color(0xFFEC4899),
                ],
              ),
            ),

            child: const Icon(
              Icons.album_rounded,
              size: 100,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 20),

          Text(
            albumName,
            textAlign: TextAlign.center,

            style: const TextStyle(
              fontSize: 27,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            artistName,
            textAlign: TextAlign.center,

            style: const TextStyle(
              color: Colors.white54,
            ),
          ),

          const SizedBox(height: 25),

          const Text(
            'Songs',

            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          ...songs.map(
            (song) => ListTile(
              contentPadding: EdgeInsets.zero,

              leading: Container(
                width: 50,
                height: 50,

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color(0xFF24242D),
                ),

                child: const Icon(
                  Icons.music_note,
                ),
              ),

              title: Text(
                song['title'] ?? 'Unknown Song',
              ),

              subtitle: Text(
                song['duration'] ?? '',
              ),

              trailing: IconButton(
                onPressed: () {
                  openPlayer(
                    context,
                    song['title'] ?? 'Unknown Song',
                    song['audioUrl'] ?? '',
                  );
                },

                icon: const Icon(
                  Icons.play_circle_fill,
                  size: 32,
                ),
              ),

              onTap: () {
                openPlayer(
                  context,
                  song['title'] ?? 'Unknown Song',
                  song['audioUrl'] ?? '',
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
