import 'package:flutter/material.dart';

class QueueScreen extends StatefulWidget {
  const QueueScreen({super.key});

  @override
  State<QueueScreen> createState() => _QueueScreenState();
}

class _QueueScreenState extends State<QueueScreen> {
  final List<Map<String, String>> queue = [
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
          'Queue',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          if (queue.isNotEmpty)
            TextButton(
              onPressed: () {
                setState(() {
                  queue.clear();
                });
              },
              child: const Text(
                'Clear',
                style: TextStyle(
                  color: Colors.white70,
                ),
              ),
            ),
        ],
      ),
      body: queue.isEmpty
          ? const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.queue_music_rounded,
                    size: 65,
                    color: Colors.white30,
                  ),
                  SizedBox(height: 15),
                  Text(
                    'Your queue is empty',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Add songs to play them next',
                    style: TextStyle(
                      color: Colors.white54,
                    ),
                  ),
                ],
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(18, 8, 18, 12),
                  child: Text(
                    'Up Next',
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: ReorderableListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: queue.length,
                    onReorderItem:
                      setState(() {
                        if (newIndex > oldIndex) {
                          newIndex -= 1;
                        }

                        final item = queue.removeAt(oldIndex);
                        queue.insert(newIndex, item);
                      });
                    },
                    itemBuilder: (context, index) {
                      final song = queue[index];

                      return Container(
                        key: ValueKey(
                          '${song['title']}_$index',
                        ),
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF141419),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.drag_handle_rounded,
                              color: Colors.white30,
                            ),
                            const SizedBox(width: 8),
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
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    song['artist']!,
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
                                setState(() {
                                  queue.removeAt(index);
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
                ),
              ],
            ),
    );
  }
}
