import 'package:flutter/material.dart';

class PlaylistDetailScreen extends StatelessWidget {
  final String playlistName;
  final String description;

  const PlaylistDetailScreen({
    super.key,
    this.playlistName = 'Santhali Hits',
    this.description = 'Best Santhali songs collection',
  });

  @override
  Widget build(BuildContext context) {
    final songs = [
      {
        'title': 'Dular Re',
        'artist': 'Rahul Murmu',
      },
      {
        'title': 'Baha Bonga',
        'artist': 'Pankaj Murmu',
      },
      {
        'title': 'Dular Gate',
        'artist': 'Stephan Tudu',
      },
      {
        'title': 'Amge Mon',
        'artist': 'Stephan Tudu',
      },
      {
        'title': 'Sari Sari',
        'artist': 'Rahul Murmu',
      },
      {
        'title': 'Johar Re',
        'artist': 'Pankaj Murmu',
      },
    ];

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
          'Playlist',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),

      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 30),
        children: [
          // Playlist cover
          Center(
            child: Container(
              width: 210,
              height: 210,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF7C3AED),
                    Color(0xFFEC4899),
                  ],
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black54,
                    blurRadius: 25,
                    offset: Offset(0, 12),
                  ),
                ],
              ),
              child: const Icon(
                Icons.queue_music_rounded,
                size: 90,
                color: Colors.white,
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Playlist name
          Text(
            playlistName,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 27,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 14,
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            '6 songs • SERENG',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white38,
              fontSize: 12,
            ),
          ),

          const SizedBox(height: 24),

          // Action buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.shuffle),
                  label: const Text('Shuffle'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(
                      color: Colors.white24,
                    ),
                    minimumSize: const Size(0, 52),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.play_arrow_rounded),
                  label: const Text('Play All'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    minimumSize: const Size(0, 52),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 30),

          const Text(
            'Songs',
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 14),

          // Song list
          ...List.generate(
            songs.length,
            (index) {
              final song = songs[index];

              return PlaylistSongTile(
                number: '${index + 1}'.padLeft(2, '0'),
                title: song['title']!,
                artist: song['artist']!,
              );
            },
          ),
        ],
      ),
    );
  }
}

class PlaylistSongTile extends StatelessWidget {
  final String number;
  final String title;
  final String artist;

  const PlaylistSongTile({
    super.key,
    required this.number,
    required this.title,
    required this.artist,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 9),
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 9,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF141419),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 32,
            child: Text(
              number,
              style: const TextStyle(
                color: Colors.white38,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF27272A),
                  Color(0xFF3F3F46),
                ],
              ),
            ),
            child: const Icon(
              Icons.music_note_rounded,
              color: Colors.white70,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  artist,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.play_circle_outline,
              size: 30,
            ),
          ),

          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.more_vert,
              color: Colors.white54,
              size: 22,
            ),
          ),
        ],
      ),
    );
  }
}
