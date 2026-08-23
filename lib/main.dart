import 'package:flutter/material.dart';

void main() {
  runApp(const SerengApp());
}

class SerengApp extends StatelessWidget {
  const SerengApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SERENG',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0B0B0F),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0B0F),

      appBar: AppBar(
        backgroundColor: const Color(0xFF0B0B0F),
        elevation: 0,
        title: const Text(
          'SERENG',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none),
          ),
        ],
      ),

      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 100),
        children: [
          const Text(
            'Good evening',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 15,
            ),
          ),

          const SizedBox(height: 4),

          const Text(
            'Listen to your vibe',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 22),

          // Featured
          Container(
            height: 190,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF7C3AED),
                  Color(0xFFEC4899),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'FEATURED PLAYLIST',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Night Vibes',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Relax • Focus • Repeat',
                          style: TextStyle(
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 38,
                          child: ElevatedButton.icon(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.play_arrow,
                              size: 20,
                            ),
                            label: const Text('Play Now'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.album,
                    size: 90,
                    color: Colors.white24,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 28),

          const SectionTitle(title: 'Recently Played'),

          const SizedBox(height: 14),

          SizedBox(
            height: 190,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: const [
                MusicCard(
                  title: 'Midnight',
                  artist: 'Sereng Artist',
                  icon: Icons.nightlight_round,
                ),
                MusicCard(
                  title: 'Dreamscape',
                  artist: 'Luna',
                  icon: Icons.cloud,
                ),
                MusicCard(
                  title: 'Ocean Eyes',
                  artist: 'Wave',
                  icon: Icons.water,
                ),
              ],
            ),
          ),

          const SizedBox(height: 28),

          const SectionTitle(title: 'Popular Songs'),

          const SizedBox(height: 12),

          const SongTile(
            title: 'Blinding Lights',
            artist: 'The Weeknd',
            number: '01',
          ),
          const SongTile(
            title: 'Starboy',
            artist: 'The Weeknd',
            number: '02',
          ),
          const SongTile(
            title: 'Stay',
            artist: 'Justin Bieber',
            number: '03',
          ),
          const SongTile(
            title: 'Perfect',
            artist: 'Ed Sheeran',
            number: '04',
          ),
        ],
      ),

      bottomNavigationBar: NavigationBar(
        backgroundColor: const Color(0xFF111116),
        selectedIndex: 0,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.explore_outlined),
            selectedIcon: Icon(Icons.explore),
            label: 'Explore',
          ),
          NavigationDestination(
            icon: Icon(Icons.library_music_outlined),
            selectedIcon: Icon(Icons.library_music),
            label: 'Library',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Text(
          'See all',
          style: TextStyle(
            color: Colors.white54,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}

class MusicCard extends StatelessWidget {
  final String title;
  final String artist;
  final IconData icon;

  const MusicCard({
    super.key,
    required this.title,
    required this.artist,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 145,
      margin: const EdgeInsets.only(right: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 140,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF27272A),
                  Color(0xFF18181B),
                ],
              ),
            ),
            child: Center(
              child: Icon(
                icon,
                size: 58,
                color: Colors.white54,
              ),
            ),
          ),
          const SizedBox(height: 9),
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
    );
  }
}

class SongTile extends StatelessWidget {
  final String title;
  final String artist;
  final String number;

  const SongTile({
    super.key,
    required this.title,
    required this.artist,
    required this.number,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
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
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color(0xFF27272A),
            ),
            child: const Icon(
              Icons.music_note,
              color: Colors.white54,
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
            onPressed: () {},
            icon: const Icon(Icons.play_circle_outline),
          ),
        ],
      ),
    );
  }
}
