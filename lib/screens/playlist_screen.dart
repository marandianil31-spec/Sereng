import 'package:flutter/material.dart';
import 'music_player_screen.dart';

class PlaylistScreen extends StatelessWidget {
  final String playlistName;

  const PlaylistScreen({
    super.key,
    this.playlistName = 'Santhali Hits',
  });

  final List<PlaylistSong> songs = const [
    PlaylistSong(
      title: 'Dular Re',
      artist: 'Rahul Murmu',
      duration: '3:42',
    ),
    PlaylistSong(
      title: 'Baha Bonga',
      artist: 'Pankaj Murmu',
      duration: '4:10',
    ),
    PlaylistSong(
      title: 'Dular Gate',
      artist: 'Stephan Tudu',
      duration: '3:55',
    ),
    PlaylistSong(
      title: 'Amge Mon',
      artist: 'Stephan Tudu',
      duration: '4:02',
    ),
    PlaylistSong(
      title: 'Midnight',
      artist: 'Sereng Artist',
      duration: '3:28',
    ),
  ];

  void openPlayer(
    BuildContext context,
    PlaylistSong song,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MusicPlayerScreen(
          songTitle: song.title,
          artistName: song.artist,
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
        padding: const EdgeInsets.fromLTRB(
          16,
          10,
          16,
          30,
        ),
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
                    offset: Offset(0, 15),
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

          const SizedBox(height: 25),

          // Playlist information
          Text(
            playlistName,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 27,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 7),

          const Text(
            'A collection of your favorite songs',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white54,
              fontSize: 14,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            '${songs.length} songs',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white38,
              fontSize: 12,
            ),
          ),

          const SizedBox(height: 22),

          // Action buttons
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

          // Songs
          ...songs.asMap().entries.map(
            (entry) {
              final index = entry.key;
              final song = entry.value;

              return PlaylistSongTile(
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

class PlaylistSong {
  final String title;
  final String artist;
  final String duration;

  const PlaylistSong({
    required this.title,
    required this.artist,
    required this.duration,
  });
}

class PlaylistSongTile extends StatelessWidget {
  final String number;
  final PlaylistSong song;
  final VoidCallback onPlay;

  const PlaylistSongTile({
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
                  song.artist,
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

          Text(
            song.duration,
            style: const TextStyle(
              color: Colors.white38,
              fontSize: 11,
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
