import 'package:flutter/material.dart';

class RecentlyPlayedScreen extends StatefulWidget {
  const RecentlyPlayedScreen({super.key});

  @override
  State<RecentlyPlayedScreen> createState() =>
      _RecentlyPlayedScreenState();
}

class _RecentlyPlayedScreenState
    extends State<RecentlyPlayedScreen> {
  final List<Map<String, String>> recentlyPlayed = [
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

  void clearHistory() {
    setState(() {
      recentlyPlayed.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0B0F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B0B0F),
        elevation: 0,
        title: const Text(
          'Recently Played',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          if (recentlyPlayed.isNotEmpty)
            TextButton(
              onPressed: clearHistory,
              child: const Text(
                'Clear',
                style: TextStyle(
                  color: Colors.white70,
                ),
              ),
            ),
        ],
      ),
      body: recentlyPlayed.isEmpty
          ? const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.history_rounded,
                    size: 70,
                    color: Colors.white30,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No recently played songs',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 7),
                  Text(
                    'Songs you play will appear here',
                    style: TextStyle(
                      color: Colors.white54,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(
                12,
                10,
                12,
                20,
              ),
              itemCount: recentlyPlayed.length,
              itemBuilder: (context, index) {
                final song = recentlyPlayed[index];

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
                        width: 58,
                        height: 58,
                        decoration: BoxDecoration(
                          color: const Color(0xFF292231),
                          borderRadius:
                              BorderRadius.circular(11),
                        ),
                        child: const Icon(
                          Icons.music_note_rounded,
                          size: 28,
                          color: Colors.white70,
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
                              overflow:
                                  TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              song['artist']!,
                              maxLines: 1,
                              overflow:
                                  TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white54,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        tooltip: 'Play',
                        onPressed: () {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(
                            SnackBar(
                              content: Text(
                                'Playing ${song['title']}',
                              ),
                              duration:
                                  const Duration(seconds: 1),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.play_circle_fill_rounded,
                          size: 34,
                          color: Colors.white,
                        ),
                      ),
                      IconButton(
                        tooltip: 'Remove',
                        onPressed: () {
                          setState(() {
                            recentlyPlayed.removeAt(index);
                          });
                        },
                        icon: const Icon(
                          Icons.close_rounded,
                          color: Colors.white54,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
