import 'package:flutter/material.dart';

import 'search_screen.dart';
import 'notifications_screen.dart';
import 'recently_played_screen.dart';
import 'music_player_screen.dart';
import 'artist_profile_screen.dart';
import 'album_screen.dart';

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
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const SearchScreen(),
                ),
              );
            },
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const NotificationsScreen(),
                ),
              );
            },
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
            'Listen to your vibe.',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 22),

          // Featured Playlist
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
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Santhali Hits',
                        style: TextStyle(
                          fontSize: 27,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        'Best songs for your mood',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const AlbumScreen(
                                albumName: 'Santhali Hits',
                                artistName: 'Sereng Artists',
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.play_arrow),
                        label: const Text('Play Now'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.music_note_rounded,
                  size: 80,
                  color: Colors.white24,
                ),
              ],
            ),
          ),

          const SizedBox(height: 28),

          HomeSectionTitle(
            title: 'Recently Played',
            onSeeAll: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const RecentlyPlayedScreen(),
                ),
              );
            },
          ),

          const SizedBox(height: 12),

          const HomeSongTile(
            title: 'Santhali Melody',
            artist: 'SERENG Artist',
          ),
          const HomeSongTile(
            title: 'Adivasi Song',
            artist: 'SERENG Artist',
          ),

          const SizedBox(height: 18),

          const HomeSectionTitle(
            title: 'Trending Songs',
          ),

          const SizedBox(height: 12),

          const HomeSongTile(
            title: 'Johar Re',
            artist: 'Santhali Artist',
          ),
          const HomeSongTile(
            title: 'Nawa Geet',
            artist: 'SERENG Artist',
          ),
          const HomeSongTile(
            title: 'Ayo Re',
            artist: 'Santhali Artist',
          ),

          const SizedBox(height: 18),

          const HomeSectionTitle(
            title: 'Popular Artists',
          ),

          const SizedBox(height: 14),

          SizedBox(
            height: 125,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: const [
                HomeArtistCard(
                  name: 'Santhali Artist',
                ),
                HomeArtistCard(
                  name: 'SERENG Artist',
                ),
                HomeArtistCard(
                  name: 'New Artist',
                ),
                HomeArtistCard(
                  name: 'Adivasi Artist',
                ),
              ],
            ),
          ),

          const SizedBox(height: 25),

          const HomeSectionTitle(
            title: 'New Releases',
          ),

          const SizedBox(height: 12),

          const NewReleaseCard(
            title: 'New Santhali Song',
            artist: 'SERENG Artist',
          ),
          const NewReleaseCard(
            title: 'Nawa Release',
            artist: 'Santhali Artist',
          ),
        ],
      ),
    );
  }
}

class HomeSectionTitle extends StatelessWidget {
  final String title;
  final VoidCallback? onSeeAll;

  const HomeSectionTitle({
    super.key,
    required this.title,
    this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (onSeeAll != null)
          TextButton(
            onPressed: onSeeAll,
            child: const Text('See all'),
          ),
      ],
    );
  }
}

class HomeSongTile extends StatelessWidget {
  final String title;
  final String artist;

  const HomeSongTile({
    super.key,
    required this.title,
    required this.artist,
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
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: const Color(0xFF24242D),
              borderRadius: BorderRadius.circular(10),
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
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MusicPlayerScreen(
                    songTitle: title,
                    artistName: artist,
                  ),
                ),
              );
            },
            icon: const Icon(
              Icons.play_circle_fill_rounded,
              size: 32,
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
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const ArtistProfileScreen(),
          ),
        );
      },
      child: Container(
        width: 105,
        margin: const EdgeInsets.only(right: 14),
        child: Column(
          children: [
            Container(
              width: 82,
              height: 82,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF24242D),
              ),
              child: const Icon(
                Icons.person,
                size: 42,
                color: Colors.white54,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
              ),
            ),
          ],
        ),
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
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AlbumScreen(
              albumName: title,
              artistName: artist,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF15151B),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 65,
              height: 65,
              decoration: BoxDecoration(
                color: const Color(0xFF24242D),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.album,
                size: 32,
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
                  const SizedBox(height: 5),
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
                    builder: (_) => AlbumScreen(
                      albumName: title,
                      artistName: artist,
                    ),
                  ),
                );
              },
              icon: const Icon(
                Icons.play_circle_fill_rounded,
                size: 34,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
