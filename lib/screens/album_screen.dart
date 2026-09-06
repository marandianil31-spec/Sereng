import 'package:flutter/material.dart';

import 'music_player_screen.dart';
import 'album_detail_screen.dart';

class AlbumScreen extends StatelessWidget {
  final String albumName;
  final String artistName;

  const AlbumScreen({
    super.key,
    this.albumName = 'Santhali Hits',
    this.artistName = 'Sereng Artists',
  });

  final List<AlbumSong> songs = const [
    AlbumSong(
      title: 'Dular Re',
      duration: '3:42',
    ),
    AlbumSong(
      title: 'Baha Bonga',
      duration: '4:10',
    ),
    AlbumSong(
      title: 'Dular Gate',
      duration: '3:55',
    ),
    AlbumSong(
      title: 'Amge Mon',
      duration: '4:02',
    ),
    AlbumSong(
      title: 'Johar Re',
      duration: '3:28',
    ),
  ];

  void openPlayer(
    BuildContext context,
    AlbumSong song,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MusicPlayerScreen(
          songTitle: song.title,
          artistName: artistName,
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
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text(
          'Album',
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
          // Album Cover
          Center(
            child: Container(
              width: 220,
              height: 220,
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
                Icons.album_rounded,
                size: 100,
                color: Colors.white70,
              ),
            ),
          ),

          const SizedBox(height: 25),

          // Album Name
          Text(
            albumName,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 27,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 7),

          // Artist
          Text(
            artistName,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white60,
              fontSize: 15,
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            '2026 • 5 Songs • SERENG',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white38,
              fontSize: 12,
            ),
          ),

          const SizedBox(height: 25),

          // Shuffle + Play All
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    if (songs.isEmpty) return;

                    openPlayer(
                      context,
                      songs.first,
                    );
                  },
                  icon: const Icon(
                    Icons.shuffle_rounded,
                  ),
                  label: const Text('Shuffle'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(
                      color: Colors.white24,
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    if (songs.isEmpty) return;

                    openPlayer(
                      context,
                      songs.first,
                    );
                  },
                  icon: const Icon(
                    Icons.play_arrow_rounded,
                  ),
                  label: const Text('Play All'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                    ),
                  ),
                ),
              ),
            ],
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

          ...songs.asMap().entries.map(
            (entry) {
              final index = entry.key;
              final song = entry.value;

              return AlbumSongTile(
                number: index + 1,
                song: song,
                onPlay: () {
                  openPlayer(
                    context,
                    song,
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class AlbumSong {
  final String title;
  final String duration;

  const AlbumSong({
    required this.title,
    required this.duration,
  });
}

class AlbumSongTile extends StatelessWidget {
  final int number;
  final AlbumSong song;
  final VoidCallback onPlay;

  const AlbumSongTile({
    super.key,
    required this.number,
    required this.song,
    required this.onPlay,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF15151B),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 30,
            child: Text(
              '$number',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white38,
                fontSize: 13,
              ),
            ),
          ),

          const SizedBox(width: 10),

          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color(0xFF24242D),
            ),
            child: const Icon(
              Icons.music_note_rounded,
              color: Colors.white54,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  song.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  song.duration,
                  style: const TextStyle(
                    color: Colors.white38,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          IconButton(
            onPressed: onPlay,
            icon: const Icon(
              Icons.play_circle_fill_rounded,
              size: 34,
            ),
          ),
        ],
      ),
    );
  }
}
