import 'package:flutter/material.dart';

import 'music_player_screen.dart';
import 'liked_songs_screen.dart';
import 'downloads_screen.dart';
import 'recently_played_screen.dart';
import 'playlist_screen.dart';

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
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Library search coming soon'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
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

          // ====================================================
          // ROW 1
          // ====================================================
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
                        builder: (context) =>
                            const LikedSongsScreen(),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: LibraryCard(
                  icon: Icons.download,
                  title: 'Downloads',
                  subtitle: '12 songs',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const DownloadsScreen(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // ====================================================
          // ROW 2
          // ====================================================
          Row(
            children: [
              Expanded(
                child: LibraryCard(
                  icon: Icons.history,
                  title: 'Recently Played',
                  subtitle: '18 songs',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const RecentlyPlayedScreen(),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: LibraryCard(
                  icon: Icons.queue_music,
                  title: 'Playlists',
                  subtitle: '5 playlists',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const PlaylistScreen(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 30),

          // ====================================================
          // PLAYLISTS HEADER
          // ====================================================
          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Your Playlists',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                ),
              ),

              TextButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const PlaylistScreen(
                        playlistName: 'New Playlist',
                      ),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.add,
                  size: 18,
                ),
                label: const Text('Create'),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // ====================================================
          // PLAYLIST 1
          // ====================================================
          PlaylistTile(
            title: 'My Favorites',
            subtitle: '24 songs',
            icon: Icons.favorite,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const PlaylistScreen(
                    playlistName: 'My Favorites',
                  ),
                ),
              );
            },
          ),

          // ====================================================
          // PLAYLIST 2
          // ====================================================
          PlaylistTile(
            title: 'Santhali Hits',
            subtitle: '18 songs',
            icon: Icons.music_note,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const PlaylistScreen(
                    playlistName: 'Santhali Hits',
                  ),
                ),
              );
            },
          ),

          // ====================================================
          // PLAYLIST 3
          // ====================================================
          PlaylistTile(
            title: 'Night Vibes',
            subtitle: '12 songs',
            icon: Icons.nightlight_round,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const PlaylistScreen(
                    playlistName: 'Night Vibes',
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 25),

          // ====================================================
          // RECENTLY PLAYED
          // ====================================================
          const Text(
            'Recently Played',
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          LibrarySongTile(
            title: 'Dular Re',
            artist: 'Rahul Murmu',
          ),

          LibrarySongTile(
            title: 'Baha Bonga',
            artist: 'Pankaj Murmu',
          ),

          LibrarySongTile(
            title: 'Dular Gate',
            artist: 'Stephan Tudu',
          ),

          LibrarySongTile(
            title: 'Johar Re',
            artist: 'SERENG Artist',
          ),
        ],
      ),
    );
  }
}

// ============================================================
// LIBRARY CARD
// ============================================================

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
          crossAxisAlignment:
              CrossAxisAlignment.start,
          mainAxisAlignment:
              MainAxisAlignment.center,
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

// ============================================================
// PLAYLIST TILE
// ============================================================

class PlaylistTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const PlaylistTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 9),
      decoration: BoxDecoration(
        color: const Color(0xFF141419),
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 4,
        ),
        onTap: onTap,

        leading: Container(
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

        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),

        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            subtitle,
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 12,
            ),
          ),
        ),

        trailing: const Icon(
          Icons.chevron_right,
          color: Colors.white38,
        ),
      ),
    );
  }
}

// ============================================================
// LIBRARY SONG TILE
// ============================================================

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
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow:
                      TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  artist,
                  maxLines: 1,
                  overflow:
                      TextOverflow.ellipsis,
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
                  builder: (context) =>
                      MusicPlayerScreen(
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
