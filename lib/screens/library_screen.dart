
import 'liked_songs_screen.dart';
import 'package:flutter/material.dart';
import 'music_player_screen.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0B0F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B0B0F),
        elevation: 0,
        title: const Text(
          'Your Library',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 30),
        children: [
          const Text(
            'Your Music',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            'Everything you love',
            style: TextStyle(
              fontSize: 27,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 24),

          // Library shortcuts
          Row(
            children: [
              Expanded(
                child: LibraryCard(
                  icon: Icons.favorite,
                  title: 'Liked Songs',
                  subtitle: '24 songs',
                  onTap: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const LikedSongsScreen(),
              ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: LibraryCard(
                  icon: Icons.download,
                  title: 'Downloads',
                  subtitle: '12 songs',
                  onTap: () {},
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: LibraryCard(
                  icon: Icons.history,
                  title: 'Recently Played',
                  subtitle: '18 songs',
                  onTap: () {},
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: LibraryCard(
                  icon: Icons.queue_music,
                  title: 'Playlists',
                  subtitle: '5 playlists',
                  onTap: () {},
                ),
              ),
            ],
          ),

          const SizedBox(height: 30),

          // Playlists
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Your Playlists',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Create'),
              ),
            ],
          ),

          const SizedBox(height: 12),

          const PlaylistTile(
            title: 'My Favorites',
            subtitle: '24 songs',
            icon: Icons.favorite,
          ),

          const PlaylistTile(
            title: 'Santhali Hits',
            subtitle: '18 songs',
            icon: Icons.music_note,
          ),

          const PlaylistTile(
            title: 'Night Vibes',
            subtitle: '12 songs',
            icon: Icons.nightlight_round,
          ),

          const SizedBox(height: 25),

          const Text(
            'Recently Played',
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          const LibrarySongTile(
            title: 'Dular Re',
            artist: 'Rahul Murmu',
          ),

          const LibrarySongTile(
            title: 'Baha Bonga',
            artist: 'Pankaj Murmu',
          ),

          const LibrarySongTile(
            title: 'Dular Gate',
            artist: 'Stephan Tudu',
          ),
        ],
      ),
    );
  }
}

class LibraryCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const LibraryCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        height: 105,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: const Color(0xFF141419),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 30,
              color: Colors.white70,
            ),
            const SizedBox(height: 9),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              subtitle,
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PlaylistTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const PlaylistTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 9),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFF141419),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF7C3AED),
                  Color(0xFFEC4899),
                ],
              ),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 27,
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.white54,
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
    );
  }
}

class LibrarySongTile extends StatelessWidget {
  final String title;
  final String artist;

  const LibrarySongTile({
    super.key,
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
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color(0xFF27272A),
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
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  artist,
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MusicPlayerScreen(
                    songTitle: title,
                    artistName: artist,
                  ),
                ),
              );
            },
            icon: const Icon(
              Icons.play_circle_outline,
              size: 30,
            ),
          ),
        ],
      ),
    );
  }
}
