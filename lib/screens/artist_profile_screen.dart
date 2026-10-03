import 'package:flutter/material.dart';

import 'music_player_screen.dart';
import 'album_detail_screen.dart';

class ArtistProfileScreen extends StatefulWidget {
  final String artistName;

  const ArtistProfileScreen({
    super.key,
    this.artistName = 'SERENG Artist',
  });

  @override
  State<ArtistProfileScreen> createState() =>
      _ArtistProfileScreenState();
}

class _ArtistProfileScreenState
    extends State<ArtistProfileScreen> {
  bool isFollowing = false;

  final List<Map<String, String>> songs = [
    {'title': 'Johar Re', 'subtitle': 'Popular Song'},
    {'title': 'Adivasi Beats', 'subtitle': 'Latest Release'},
    {'title': 'Sarna Song', 'subtitle': 'Popular Song'},
    {'title': 'New Santhali Song', 'subtitle': 'Single'},
    {'title': 'Disom Re', 'subtitle': 'Album Track'},
  ];

  final List<Map<String, String>> albums = [
    {'title': 'Johar', 'year': '2026'},
    {'title': 'Adivasi Beats', 'year': '2025'},
    {'title': 'Sarna', 'year': '2025'},
  ];

  void playSong(BuildContext context, String title) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MusicPlayerScreen(
          songTitle: title,
          artistName: widget.artistName,
        ),
      ),
    );
  }

  void openAlbum(
    BuildContext context,
    String albumName,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AlbumDetailScreen(
          albumName: albumName,
          artistName: widget.artistName,
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
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: const Text(
          'Artist',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert_rounded),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 35),
        children: [
          const SizedBox(height: 10),

          Center(
            child: Container(
              width: 125,
              height: 125,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF24202D),
                border: Border.all(
                  color: Colors.white12,
                  width: 2,
                ),
              ),
              child: const Icon(
                Icons.person_rounded,
                size: 70,
                color: Colors.white54,
              ),
            ),
          ),

          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  widget.artistName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              const Icon(
                Icons.verified_rounded,
                size: 20,
              ),
            ],
          ),

          const SizedBox(height: 7),

          const Text(
            'Santhali Music Artist',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white54,
              fontSize: 13,
            ),
          ),

          const SizedBox(height: 15),

          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _StatItem(value: '12.5K', label: 'Followers'),
              SizedBox(width: 35),
              _StatItem(value: '38', label: 'Songs'),
              SizedBox(width: 35),
              _StatItem(value: '6', label: 'Albums'),
            ],
          ),

          const SizedBox(height: 18),

          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 46,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isFollowing = !isFollowing;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isFollowing
                          ? const Color(0xFF24202D)
                          : Colors.white,
                      foregroundColor: isFollowing
                          ? Colors.white
                          : Colors.black,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text(
                      isFollowing ? 'Following' : 'Follow',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Container(
                height: 46,
                width: 46,
                decoration: BoxDecoration(
                  color: const Color(0xFF141419),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.share_rounded),
                ),
              ),
            ],
          ),

          const SizedBox(height: 28),

          const Text(
            'Popular Songs',
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 14),

          ...songs.asMap().entries.map((entry) {
            final index = entry.key;
            final song = entry.value;

            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(9),
              decoration: BoxDecoration(
                color: const Color(0xFF141419),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 22,
                    child: Text(
                      '${index + 1}',
                      style: const TextStyle(
                        color: Colors.white38,
                      ),
                    ),
                  ),
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: const Color(0xFF292231),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.music_note_rounded,
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
                          song['title']!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          song['subtitle']!,
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      playSong(context, song['title']!);
                    },
                    icon: const Icon(
                      Icons.play_circle_fill_rounded,
                      size: 30,
                    ),
                  ),
                ],
              ),
            );
          }),

          const SizedBox(height: 20),

          const Text(
            'Albums',
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 14),

          SizedBox(
            height: 185,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: albums.length,
              itemBuilder: (context, index) {
                final album = albums[index];

                return GestureDetector(
                  onTap: () {
                    openAlbum(
                      context,
                      album['title']!,
                    );
                  },
                  child: Container(
                    width: 145,
                    margin: const EdgeInsets.only(right: 12),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 145,
                          height: 125,
                          decoration: BoxDecoration(
                            color: const Color(0xFF24202D),
                            borderRadius:
                                BorderRadius.circular(14),
                          ),
                          child: const Icon(
                            Icons.album_rounded,
                            size: 55,
                            color: Colors.white54,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          album['title']!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          album['year']!,
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;

  const _StatItem({
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white54,
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}
