import 'package:flutter/material.dart';
import 'music_player_screen.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0B0F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B0B0F),
        elevation: 0,
        title: const Text(
          'Explore',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 30),
        children: [
          const Text(
            'Discover',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            'Find your next favorite',
            style: TextStyle(
              fontSize: 27,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 22),

          // Search box
          Container(
            height: 52,
            decoration: BoxDecoration(
              color: const Color(0xFF18181F),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Row(
              children: [
                SizedBox(width: 16),
                Icon(
                  Icons.search,
                  color: Colors.white54,
                ),
                SizedBox(width: 12),
                Text(
                  'Search songs, artists, albums...',
                  style: TextStyle(
                    color: Colors.white54,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 28),

          const Text(
            'Browse by Mood',
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 14),

          SizedBox(
            height: 105,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: const [
                MoodCard(
                  title: 'Chill',
                  icon: Icons.nightlight_round,
                ),
                MoodCard(
                  title: 'Happy',
                  icon: Icons.sentiment_satisfied_alt,
                ),
                MoodCard(
                  title: 'Workout',
                  icon: Icons.fitness_center,
                ),
                MoodCard(
                  title: 'Romantic',
                  icon: Icons.favorite,
                ),
              ],
            ),
          ),

          const SizedBox(height: 28),

          const Text(
            'Trending Now',
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 14),

          const ExploreSongTile(
            title: 'Dular Re',
            artist: 'Rahul Murmu',
            number: '01',
          ),
          const ExploreSongTile(
            title: 'Baha Bonga',
            artist: 'Pankaj Murmu',
            number: '02',
          ),
          const ExploreSongTile(
            title: 'Dular Gate',
            artist: 'Stephan Tudu',
            number: '03',
          ),
          const ExploreSongTile(
            title: 'Amge Mon',
            artist: 'Stephan Tudu',
            number: '04',
          ),

          const SizedBox(height: 20),

          const Text(
            'Popular Artists',
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ArtistCircle(
                name: 'Rahul Murmu',
                icon: Icons.person,
              ),
              ArtistCircle(
                name: 'Pankaj Murmu',
                icon: Icons.person,
              ),
              ArtistCircle(
                name: 'Stephan Tudu',
                icon: Icons.person,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class MoodCard extends StatelessWidget {
  final String title;
  final IconData icon;

  const MoodCard({
    super.key,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF7C3AED),
            Color(0xFFEC4899),
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 32,
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class ExploreSongTile extends StatelessWidget {
  final String title;
  final String artist;
  final String number;

  const ExploreSongTile({
    super.key,
    required this.title,
    required this.artist,
    required this.number,
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
            width: 48,
            height: 48,
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

          // Play button
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

class ArtistCircle extends StatelessWidget {
  final String name;
  final IconData icon;

  const ArtistCircle({
    super.key,
    required this.name,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 95,
      child: Column(
        children: [
          Container(
            width: 65,
            height: 65,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF7C3AED),
                  Color(0xFFEC4899),
                ],
              ),
            ),
            child: Icon(
              icon,
              size: 34,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            name,
            textAlign: TextAlign.center,
            maxLines: 2,
            style: const TextStyle(
              fontSize: 11,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}
