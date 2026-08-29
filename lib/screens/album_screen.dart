import 'package:flutter/material.dart';
import 'music_player_screen.dart';

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

  void openPlayer(BuildContext context, AlbumSong song) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MusicPlayerScreen(
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
          onPressed: () => Navigator.pop(context),
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
        padding: const EdgeInsets.fromLTRB(
          16,
          10,
          16,
          30,
        ),
        children: [
          const SizedBox(height: 8),

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
                    offset: Offset(0, 15),
                  ),
                ],
              ),
              child: const Icon(
                Icons.album_rounded,
                size: 100,
                color: Colors.white,
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Album name
          Text(
            albumName,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 7),

          Text(
            artistName,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 15,
            ),
          ),

          const SizedBox(height: 7),

          const Text(
            '2026 • 5 Songs • SERENG',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white38,
              fontSize: 12,
            ),
          ),

          const SizedBox(height: 22),

          // Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.shuffle),
                  label: const Text('Shuffle'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(0, 50),
                    foregroundColor: Colors.white,
                    side: const BorderSide(
                      color: Colors.white24,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    if (songs.isNotEmpty) {
                      openPlayer(context, songs.first);
                    }
                  },
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Play All'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(0, 50),
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
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

          const SizedBox(height: 12),

          ...songs.asMap().entries.map(
            (entry) {
              final index = entry.key;
              final song = entry.value;

              return AlbumSongTile(
                number: '${index + 1}'.padLeft(2, '0'),
                song: song,
                onPlay: () {
                  openPlayer(context, song);
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
  final String number;
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
              borderRadius: BorderRadius.circular(11),
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF27272A),
                  Color(0xFF3F3F46),
                ],
              ),
            ),
            child: const Icon(
              Icons.music_note,
              color: Colors.white70,
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
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  song.duration,
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          IconButton(
            onPressed: onPlay,
            icon: const Icon(
              Icons.play_circle_outline,
              size: 30,
            ),
          ),

          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.more_vert,
              color: Colors.white38,
            ),
          ),
        ],
      ),
    );
  }
}
