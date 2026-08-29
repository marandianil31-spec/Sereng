import 'package:flutter/material.dart';

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
            icon: const Icon(Icons.notifications_none_rounded),
          ),
        ],
      ),

      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 35),
        children: [
          const Text(
            'Good evening',
            style: TextStyle(
              color: Colors.white54,
              fontSize: 14,
            ),
          ),

          const SizedBox(height: 5),

          const Text(
            'Listen to your vibe',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 22),

          // Featured playlist
          Container(
            height: 195,
            padding: const EdgeInsets.all(20),
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
            ),
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
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),

                      const SizedBox(height: 9),

                      const Text(
                        'Santhali Hits',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 5),

                      const Text(
                        'Best songs for your mood',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
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
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 13,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const Icon(
                  Icons.album_rounded,
                  size: 82,
                  color: Colors.white24,
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          const HomeSectionTitle(
            title: 'Recently Played',
          ),

          const SizedBox(height: 14),

          SizedBox(
            height: 180,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: const [
                HomeMusicCard(
                  title: 'Dular Re',
                  artist: 'Rahul Murmu',
                  icon: Icons.music_note_rounded,
                ),
                HomeMusicCard(
                  title: 'Baha Bonga',
                  artist: 'Pankaj Murmu',
                  icon: Icons.nightlight_round,
                ),
                HomeMusicCard(
                  title: 'Dular Gate',
                  artist: 'Stephan Tudu',
                  icon: Icons.favorite_rounded,
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          const HomeSectionTitle(
            title: 'Trending Songs',
          ),

          const SizedBox(height: 14),

          const HomeSongTile(
            number: '01',
            title: 'Dular Re',
            artist: 'Rahul Murmu',
          ),

          const HomeSongTile(
            number: '02',
            title: 'Baha Bonga',
            artist: 'Pankaj Murmu',
          ),

          const HomeSongTile(
            number: '03',
            title: 'Dular Gate',
            artist: 'Stephan Tudu',
          ),

          const HomeSongTile(
            number: '04',
            title: 'Amge Mon',
            artist: 'Stephan Tudu',
          ),

          const SizedBox(height: 28),

          const HomeSectionTitle(
            title: 'Popular Artists',
          ),

          const SizedBox(height: 16),

          SizedBox(
            height: 115,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: const [
                HomeArtistCard(
                  name: 'Rahul Murmu',
                ),
                HomeArtistCard(
                  name: 'Pankaj Murmu',
                ),
                HomeArtistCard(
                  name: 'Stephan Tudu',
                ),
                HomeArtistCard(
                  name: 'Luna',
                ),
              ],
            ),
          ),

          const SizedBox(height: 28),

          const HomeSectionTitle(
            title: 'New Releases',
          ),

          const SizedBox(height: 14),

          const NewReleaseCard(
            title: 'Amge Mon',
            artist: 'Stephan Tudu',
          ),

          const NewReleaseCard(
            title: 'Johar Re',
            artist: 'Rahul Murmu',
          ),
        ],
      ),
    );
  }
}

class HomeSectionTitle extends StatelessWidget {
  final String title;

  const HomeSectionTitle({
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
        TextButton(
          onPressed: () {},
          child: const Text(
            'See all',
            style: TextStyle(
              color: Colors.white54,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }
}

class HomeMusicCard extends StatelessWidget {
  final String title;
  final String artist;
  final IconData icon;

  const HomeMusicCard({
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
            height: 125,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF27272A),
                  Color(0xFF18181B),
                ],
              ),
            ),
            child: Center(
              child: Icon(
                icon,
                size: 55,
                color: Colors.white54,
              ),
            ),
          ),

          const SizedBox(height: 8),

          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 3),

          Text(
            artist,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white45,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

class HomeSongTile extends StatelessWidget {
  final String number;
  final String title;
  final String artist;

  const HomeSongTile({
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
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF7C3AED),
                  Color(0xFFEC4899),
                ],
              ),
            ),
            child: const Icon(
              Icons.music_note_rounded,
              color: Colors.white,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  title,
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
        ],
      ),
    );
  }
}

class HomeArtistCard extends StatelessWidget {
  final String name;

  const HomeArtistCard({
    super.key,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 95,
      margin: const EdgeInsets.only(right: 18),
      child: Column(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  Color(0xFF7C3AED),
                  Color(0xFFEC4899),
                ],
              ),
            ),
            child: const Icon(
              Icons.person_rounded,
              size: 35,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            name,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

class NewReleaseCard extends StatelessWidget {
  final String title;
  final String artist;

  const NewReleaseCard({
    super.key,
    required this.title,
    required this.artist,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFF141419),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Container(
            width: 62,
            height: 62,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: const LinearGradient(
                colors: [
                  Color(0xFFEC4899),
                  Color(0xFF7C3AED),
                ],
              ),
            ),
            child: const Icon(
              Icons.album_rounded,
              size: 30,
              color: Colors.white,
            ),
          ),

          const SizedBox(width: 13),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  artist,
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'New release',
                  style: TextStyle(
                    color: Colors.white30,
                    fontSize: 10,
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
        ],
      ),
    );
  }
}
