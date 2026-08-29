import 'package:flutter/material.dart';

class DownloadsScreen extends StatelessWidget {
  const DownloadsScreen({super.key});

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
          'Downloads',
          style: TextStyle(
            fontSize: 22,
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
          // Storage information
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF7C3AED),
                  Color(0xFFEC4899),
                ],
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 55,
                  height: 55,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.download_rounded,
                    color: Colors.white,
                    size: 30,
                  ),
                ),

                const SizedBox(width: 15),

                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Offline Music',
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        '12 songs • 186 MB',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),

                const Icon(
                  Icons.chevron_right,
                  color: Colors.white70,
                ),
              ],
            ),
          ),

          const SizedBox(height: 28),

          // Storage
          const Text(
            'Storage',
            style: TextStyle(
              color: Colors.white54,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF141419),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Downloaded',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '186 MB',
                      style: TextStyle(
                        color: Colors.white54,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: const LinearProgressIndicator(
                    value: 0.28,
                    minHeight: 7,
                    backgroundColor: Colors.white12,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color(0xFF9C6BFF),
                    ),
                  ),
                ),

                const SizedBox(height: 9),

                const Text(
                  '28% of download storage used',
                  style: TextStyle(
                    color: Colors.white38,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 28),

          const Text(
            'Downloaded Songs',
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 14),

          const DownloadSongTile(
            title: 'Dular Re',
            artist: 'Rahul Murmu',
            duration: '4:12',
          ),

          const DownloadSongTile(
            title: 'Baha Bonga',
            artist: 'Pankaj Murmu',
            duration: '3:48',
          ),

          const DownloadSongTile(
            title: 'Dular Gate',
            artist: 'Stephan Tudu',
            duration: '4:05',
          ),

          const DownloadSongTile(
            title: 'Amge Mon',
            artist: 'Stephan Tudu',
            duration: '3:36',
          ),

          const DownloadSongTile(
            title: 'Night Vibes',
            artist: 'Sereng Artist',
            duration: '4:20',
          ),

          const SizedBox(height: 25),

          // Clear downloads
          SizedBox(
            width: double.infinity,
            height: 52,
            child: OutlinedButton.icon(
              onPressed: () {
                _showClearDialog(context);
              },
              icon: const Icon(
                Icons.delete_outline,
                color: Colors.redAccent,
              ),
              label: const Text(
                'Clear All Downloads',
                style: TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(
                  color: Colors.redAccent,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          const Center(
            child: Text(
              'Downloaded songs can be played offline.',
              style: TextStyle(
                color: Colors.white30,
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showClearDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: const Color(0xFF18181F),
          title: const Text('Clear downloads?'),
          content: const Text(
            'All downloaded songs will be removed from this device.',
            style: TextStyle(
              color: Colors.white60,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Download system will be connected later.',
                    ),
                  ),
                );
              },
              child: const Text('Clear'),
            ),
          ],
        );
      },
    );
  }
}

class DownloadSongTile extends StatelessWidget {
  final String title;
  final String artist;
  final String duration;

  const DownloadSongTile({
    super.key,
    required this.title,
    required this.artist,
    required this.duration,
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
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  artist,
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  duration,
                  style: const TextStyle(
                    color: Colors.white30,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),

          const Icon(
            Icons.download_done_rounded,
            color: Colors.white54,
          ),

          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.play_circle_outline,
              size: 29,
            ),
          ),
        ],
      ),
    );
  }
}
