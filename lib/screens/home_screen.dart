import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'search_screen.dart';
import 'notifications_screen.dart';
import 'music_player_screen.dart';
import 'artist_profile_screen.dart';
import 'playlist_screen.dart';
import 'local_music_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void openLocalMusic(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const LocalMusicScreen(),
      ),
    );
  }

  void openPlaylist(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const PlaylistScreen(
          playlistName: 'Santhali Hits',
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
                  builder: (_) =>
                      const NotificationsScreen(),
                ),
              );
            },
            icon: const Icon(
              Icons.notifications_none_rounded,
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          16,
          8,
          16,
          35,
        ),
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

          const SizedBox(height: 20),

          // ==================================================
          // ONLINE / LOCAL MUSIC
          // ==================================================

          Row(
            children: [
              Expanded(
                child: _MusicModeButton(
                  icon: Icons.cloud_rounded,
                  title: 'Online Music',
                  subtitle: 'SERENG Songs',
                  selected: true,
                  onTap: () {},
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _MusicModeButton(
                  icon: Icons.phone_android_rounded,
                  title: 'Local Music',
                  subtitle: 'Phone Songs',
                  selected: false,
                  onTap: () {
                    openLocalMusic(context);
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 22),

          // ==================================================
          // FEATURED PLAYLIST
          // ==================================================

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
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    mainAxisAlignment:
                        MainAxisAlignment.center,
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
                          openPlaylist(context);
                        },
                        icon: const Icon(
                          Icons.play_arrow,
                        ),
                        label: const Text(
                          'Play Now',
                        ),
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

          // ==================================================
          // ONLINE SONGS
          // ==================================================

          const Text(
            'Online Songs',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('songs')
                .where(
                  'isApproved',
                  isEqualTo: true,
                )
                .snapshots(),
            builder: (
              context,
              snapshot,
            ) {
              if (snapshot.hasError) {
                return const Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    'Unable to load songs.',
                    style: TextStyle(
                      color: Colors.white54,
                    ),
                  ),
                );
              }

              if (snapshot.connectionState ==
                  ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.all(30),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              if (!snapshot.hasData ||
                  snapshot.data!.docs.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Icon(
                        Icons.music_off_rounded,
                        size: 45,
                        color: Colors.white30,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'No approved songs yet',
                        style: TextStyle(
                          color: Colors.white54,
                        ),
                      ),
                    ],
                  ),
                );
              }

              final songs = snapshot.data!.docs;

              return ListView.builder(
                shrinkWrap: true,
                physics:
                    const NeverScrollableScrollPhysics(),
                itemCount: songs.length,
                itemBuilder: (
                  context,
                  index,
                ) {
                  final data =
                      songs[index].data()
                          as Map<String, dynamic>;

                  final String title =
                      data['songTitle']
                              ?.toString() ??
                          'Unknown Song';

                  final String artist =
                      data['artistName']
                              ?.toString() ??
                          'Unknown Artist';

                  final String audioUrl =
                      data['audioUrl']
                              ?.toString() ??
                          '';

                  final String coverUrl =
                      data['coverUrl']
                              ?.toString() ??
                          '';

                  return HomeSongTile(
                    title: title,
                    artist: artist,
                    audioUrl: audioUrl,
                    coverUrl: coverUrl,
                  );
                },
              );
            },
          ),

          const SizedBox(height: 25),

          // ==================================================
          // POPULAR ARTISTS
          // ==================================================

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
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ======================================================
// MUSIC MODE BUTTON
// ======================================================

class _MusicModeButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  const _MusicModeButton({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: selected
                ? const Color(0xFF211936)
                : const Color(0xFF15151B),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: selected
                  ? const Color(0xFF7C3AED)
                  : const Color(0xFF24242D),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: selected
                      ? const Color(0xFF7C3AED)
                      : const Color(0xFF292231),
                  borderRadius:
                      BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 22,
                ),
              ),
              const SizedBox(width: 10),
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
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow:
                          TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ======================================================
// SECTION TITLE
// ======================================================

class HomeSectionTitle extends StatelessWidget {
  final String title;

  const HomeSectionTitle({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

// ======================================================
// SONG TILE
// ======================================================

class HomeSongTile extends StatelessWidget {
  final String title;
  final String artist;
  final String audioUrl;
  final String coverUrl;

  const HomeSongTile({
    super.key,
    required this.title,
    required this.artist,
    required this.audioUrl,
    required this.coverUrl,
  });

  void openPlayer(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MusicPlayerScreen(
          songTitle: title,
          artistName: artist,
          audioUrl: audioUrl,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        openPlayer(context);
      },
      child: Container(
        margin: const EdgeInsets.only(
          bottom: 10,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFF15151B),
          borderRadius:
              BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: const Color(0xFF24242D),
                borderRadius:
                    BorderRadius.circular(10),
              ),
              child: coverUrl.isNotEmpty
                  ? Image.network(
                      coverUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (
                        context,
                        error,
                        stackTrace,
                      ) {
                        return const Icon(
                          Icons.music_note,
                          color: Colors.white70,
                        );
                      },
                    )
                  : const Icon(
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
                  const SizedBox(height: 4),
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
                openPlayer(context);
              },
              icon: const Icon(
                Icons.play_circle_fill_rounded,
                size: 32,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ======================================================
// ARTIST CARD
// ======================================================

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
            builder: (_) => ArtistProfileScreen(
              artistName: name,
            ),
          ),
        );
      },
      child: Container(
        width: 110,
        margin: const EdgeInsets.only(
          right: 12,
        ),
        child: Column(
          children: [
            Container(
              width: 78,
              height: 78,
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
                Icons.person,
                size: 38,
                color: Colors.white,
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
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
