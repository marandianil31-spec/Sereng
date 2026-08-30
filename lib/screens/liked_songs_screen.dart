import 'package:flutter/material.dart';

class LikedSongsScreen extends StatefulWidget {
  const LikedSongsScreen({super.key});

  @override
  State<LikedSongsScreen> createState() => _LikedSongsScreenState();
}

class _LikedSongsScreenState extends State<LikedSongsScreen> {
  final List<Map<String, String>> likedSongs = [
    {
      'title': 'Johar Re',
      'artist': 'SERENG Artist',
    },
    {
      'title': 'Adivasi Beats',
      'artist': 'Santhali Artist',
    },
    {
      'title': 'Sarna Song',
      'artist': 'SERENG Artist',
    },
    {
      'title': 'New Santhali Song',
      'artist': 'Featured Artist',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0B0F),

      appBar: AppBar(
        backgroundColor: const Color(0xFF0B0B0F),
        elevation: 0,
        title: const Text(
          'Liked Songs',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: likedSongs.isEmpty
          ? const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.favorite_border_rounded,
                    size: 70,
                    color: Colors.white30,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No liked songs yet',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 7),
                  Text(
                    'Songs you like will appear here',
                    style: TextStyle(
                      color: Colors.white54,
                    ),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    18,
                    12,
                    18,
                    16,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${likedSongs.length} liked songs',
                          style: const TextStyle(
                            color: Colors.white60,
                            fontSize: 14,
                          ),
                        ),
                      ),

                      IconButton(
                        tooltip: 'Shuffle',
                        onPressed: () {},
                        icon: const Icon(
                          Icons.shuffle_rounded,
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(width: 4),

                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.play_arrow_rounded,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                    ),
                    itemCount: likedSongs.length,
                    itemBuilder: (context, index) {
                      final song = likedSongs[index];

                      return Container(
                        margin: const EdgeInsets.only(
                          bottom: 8,
                        ),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF141419),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                color: const Color(0xFF292231),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.music_note_rounded,
                                color: Colors.white70,
                                size: 28,
                              ),
                            ),

                            const SizedBox(width: 13),

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
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  const SizedBox(height: 5),

                                  Text(
                                    song['artist']!,
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

                            IconButton(
                              onPressed: () {
                                setState(() {
                                  likedSongs.removeAt(index);
                                });
                              },
                              icon: const Icon(
                                Icons.favorite_rounded,
                                color: Colors.white,
                              ),
                            ),

                            IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.more_vert_rounded,
                                color: Colors.white54,
                              ),
                            ),
                          ],
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
