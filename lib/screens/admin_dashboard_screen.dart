import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  CollectionReference<Map<String, dynamic>>
      get songsCollection =>
          FirebaseFirestore.instance.collection('songs');

  Future<void> approveSong(
    BuildContext context,
    String songId,
  ) async {
    try {
      await songsCollection.doc(songId).update({
        'status': 'approved',
        'isApproved': true,
        'approvedAt': FieldValue.serverTimestamp(),
      });

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Song approved successfully.',
          ),
        ),
      );
    } catch (e) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Approve failed: $e',
          ),
        ),
      );
    }
  }

  Future<void> rejectSong(
    BuildContext context,
    String songId,
  ) async {
    try {
      await songsCollection.doc(songId).update({
        'status': 'rejected',
        'isApproved': false,
        'rejectedAt': FieldValue.serverTimestamp(),
      });

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Song rejected.',
          ),
        ),
      );
    } catch (e) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Reject failed: $e',
          ),
        ),
      );
    }
  }

  void showSongDetails(
    BuildContext context,
    QueryDocumentSnapshot<Map<String, dynamic>>
        document,
  ) {
    final data = document.data();

    final String title =
        data['songTitle']?.toString() ??
            'Unknown Song';

    final String artist =
        data['artistName']?.toString() ??
            'Unknown Artist';

    final String album =
        data['albumName']?.toString() ??
            'No Album';

    final String genre =
        data['genre']?.toString() ??
            'Unknown';

    final String description =
        data['description']?.toString() ??
            '';

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF141419),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25),
        ),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              20,
              20,
              20,
              25,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 45,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius:
                          BorderRadius.circular(10),
                    ),
                  ),
                ),

                const SizedBox(height: 22),

                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 7),

                Text(
                  artist,
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 20),

                _DetailRow(
                  title: 'Album',
                  value: album,
                ),

                _DetailRow(
                  title: 'Genre',
                  value: genre,
                ),

                if (description.isNotEmpty)
                  Padding(
                    padding:
                        const EdgeInsets.only(
                      top: 10,
                    ),
                    child: Text(
                      description,
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 13,
                        height: 1.5,
                      ),
                    ),
                  ),

                const SizedBox(height: 20),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.pop(
                            sheetContext,
                          );

                          rejectSong(
                            context,
                            document.id,
                          );
                        },
                        icon: const Icon(
                          Icons.close_rounded,
                        ),
                        label:
                            const Text('Reject'),
                        style:
                            OutlinedButton.styleFrom(
                          foregroundColor:
                              Colors.white,
                          side:
                              const BorderSide(
                            color: Colors.white24,
                          ),
                          minimumSize:
                              const Size(0, 50),
                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(
                                    14),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(
                            sheetContext,
                          );

                          approveSong(
                            context,
                            document.id,
                          );
                        },
                        icon: const Icon(
                          Icons.check_rounded,
                        ),
                        label:
                            const Text('Approve'),
                        style:
                            ElevatedButton.styleFrom(
                          backgroundColor:
                              Colors.white,
                          foregroundColor:
                              Colors.black,
                          minimumSize:
                              const Size(0, 50),
                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(
                                    14),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFF0B0B0F),

      appBar: AppBar(
        backgroundColor:
            const Color(0xFF0B0B0F),
        elevation: 0,

        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_rounded,
          ),
        ),

        title: const Text(
          'Admin Dashboard',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),

        actions: [
          IconButton(
            onPressed: () {
              // StreamBuilder automatically refreshes.
            },
            icon: const Icon(
              Icons.refresh_rounded,
            ),
          ),
        ],
      ),

      body: StreamBuilder<
          QuerySnapshot<Map<String, dynamic>>>(
        stream: songsCollection
            .where(
              'status',
              isEqualTo: 'pending',
            )
            .snapshots(),

        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child:
                  CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding:
                    const EdgeInsets.all(25),
                child: Column(
                  mainAxisSize:
                      MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 55,
                      color: Colors.white54,
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      'Unable to load songs',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${snapshot.error}',
                      textAlign:
                          TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          final documents =
              snapshot.data?.docs ?? [];

          if (documents.isEmpty) {
            return const Center(
              child: Column(
                mainAxisSize:
                    MainAxisSize.min,
                children: [
                  Icon(
                    Icons
                        .playlist_add_check_rounded,
                    size: 70,
                    color: Colors.white30,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No pending songs',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 7),
                  Text(
                    'New artist submissions will appear here.',
                    textAlign:
                        TextAlign.center,
                    style: TextStyle(
                      color: Colors.white54,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView(
            padding:
                const EdgeInsets.fromLTRB(
              16,
              15,
              16,
              30,
            ),
            children: [
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(20),
                  gradient:
                      const LinearGradient(
                    colors: [
                      Color(0xFF7C3AED),
                      Color(0xFFEC4899),
                    ],
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.admin_panel_settings_rounded,
                      size: 42,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,
                        children: [
                          const Text(
                            'Pending Submissions',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                              height: 4),
                          Text(
                            '${documents.length} song${documents.length == 1 ? '' : 's'} waiting for review',
                            style:
                                const TextStyle(
                              color:
                                  Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              const Text(
                'Songs',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),

              const SizedBox(height: 14),

              ...documents.map(
                (document) {
                  return _PendingSongCard(
                    document: document,
                    onTap: () {
                      showSongDetails(
                        context,
                        document,
                      );
                    },
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

class _PendingSongCard extends StatelessWidget {
  final QueryDocumentSnapshot<
      Map<String, dynamic>> document;

  final VoidCallback onTap;

  const _PendingSongCard({
    required this.document,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final data = document.data();

    final String title =
        data['songTitle']?.toString() ??
            'Unknown Song';

    final String artist =
        data['artistName']?.toString() ??
            'Unknown Artist';

    final String genre =
        data['genre']?.toString() ??
            'Unknown';

    final String coverUrl =
        data['coverUrl']?.toString() ?? '';

    return Container(
      margin:
          const EdgeInsets.only(bottom: 12),

      padding:
          const EdgeInsets.all(11),

      decoration: BoxDecoration(
        color:
            const Color(0xFF141419),
        borderRadius:
            BorderRadius.circular(17),
      ),

      child: Row(
        children: [
          // Cover
          Container(
            width: 65,
            height: 65,
            decoration: BoxDecoration(
              color:
                  const Color(0xFF292231),
              borderRadius:
                  BorderRadius.circular(12),
            ),
            clipBehavior:
                Clip.antiAlias,

            child: coverUrl.isEmpty
                ? const Icon(
                    Icons.music_note_rounded,
                    color: Colors.white70,
                    size: 30,
                  )
                : Image.network(
                    coverUrl,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (
                      context,
                      error,
                      stackTrace,
                    ) {
                      return const Icon(
                        Icons
                            .music_note_rounded,
                        color:
                            Colors.white70,
                        size: 30,
                      );
                    },
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
                  maxLines: 1,
                  overflow:
                      TextOverflow.ellipsis,
                  style:
                      const TextStyle(
                    fontWeight:
                        FontWeight.bold,
                    fontSize: 15,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  artist,
                  maxLines: 1,
                  overflow:
                      TextOverflow.ellipsis,
                  style:
                      const TextStyle(
                    color: Colors.white54,
                    fontSize: 12,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  genre,
                  style:
                      const TextStyle(
                    color: Colors.white38,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 5),

          IconButton(
            onPressed: onTap,
            tooltip: 'Review',
            icon: const Icon(
              Icons.chevron_right_rounded,
              size: 30,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String title;
  final String value;

  const _DetailRow({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(bottom: 9),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style:
                  const TextStyle(
                color: Colors.white54,
                fontSize: 13,
              ),
            ),
          ),
          Text(
            value,
            style:
                const TextStyle(
              fontWeight:
                  FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
