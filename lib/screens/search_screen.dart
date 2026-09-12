import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'music_player_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController =
      TextEditingController();

  String searchText = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = searchText.toLowerCase().trim();

    return Scaffold(
      backgroundColor: const Color(0xFF0B0B0F),

      appBar: AppBar(
        backgroundColor: const Color(0xFF0B0B0F),
        elevation: 0,

        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        title: const Text(
          'Search',
          style: TextStyle(
            fontSize: 23,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.fromLTRB(
          16,
          8,
          16,
          20,
        ),

        child: Column(
          children: [

            // SEARCH FIELD

            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF18181F),
                borderRadius:
                    BorderRadius.circular(16),
              ),

              child: TextField(
                controller: _searchController,
                autofocus: true,

                style: const TextStyle(
                  color: Colors.white,
                ),

                onChanged: (value) {
                  setState(() {
                    searchText = value;
                  });
                },

                decoration: InputDecoration(
                  hintText:
                      'Songs, artists, albums...',

                  hintStyle:
                      const TextStyle(
                    color: Colors.white38,
                  ),

                  prefixIcon: const Icon(
                    Icons.search,
                    color: Colors.white60,
                  ),

                  suffixIcon:
                      searchText.isNotEmpty
                          ? IconButton(
                              icon: const Icon(
                                Icons.clear,
                                color:
                                    Colors.white54,
                              ),

                              onPressed: () {
                                _searchController
                                    .clear();

                                setState(() {
                                  searchText = '';
                                });
                              },
                            )
                          : null,

                  border:
                      InputBorder.none,

                  contentPadding:
                      const EdgeInsets
                          .symmetric(
                    vertical: 16,
                    horizontal: 10,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 25),

            // EMPTY SEARCH

            if (searchText.isEmpty)
              const Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment:
                        MainAxisAlignment.center,

                    children: [
                      Icon(
                        Icons.search_rounded,
                        size: 70,
                        color: Colors.white24,
                      ),

                      SizedBox(height: 18),

                      Text(
                        'Search for music',

                        style: TextStyle(
                          fontSize: 22,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: 7),

                      Text(
                        'Find songs and artists you love',

                        style: TextStyle(
                          color:
                              Colors.white54,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              )

            // FIRESTORE SEARCH

            else
              Expanded(
                child:
                    StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore
                      .instance
                      .collection('songs')
                      .where(
                        'approved',
                        isEqualTo: true,
                      )
                      .snapshots(),

                  builder: (
                    context,
                    snapshot,
                  ) {
                    if (snapshot.hasError) {
                      return const Center(
                        child: Text(
                          'Something went wrong',
                        ),
                      );
                    }

                    if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(
                        child:
                            CircularProgressIndicator(),
                      );
                    }

                    if (!snapshot.hasData ||
                        snapshot.data!.docs.isEmpty) {
                      return const Center(
                        child: Text(
                          'No songs available',
                        ),
                      );
                    }

                    final songs =
                        snapshot.data!.docs;

                    // FILTER SONGS

                    final filteredSongs =
                        songs.where((doc) {
                      final song =
                          doc.data()
                              as Map<
                                  String,
                                  dynamic>;

                      final title =
                          (song['title'] ?? '')
                              .toString()
                              .toLowerCase();

                      final artist =
                          (song['artist'] ?? '')
                              .toString()
                              .toLowerCase();

                      return title.contains(
                            query,
                          ) ||
                          artist.contains(
                            query,
                          );
                    }).toList();

                    // NO RESULT

                    if (filteredSongs.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment:
                              MainAxisAlignment
                                  .center,

                          children: [
                            const Icon(
                              Icons
                                  .music_off_rounded,
                              size: 65,
                              color:
                                  Colors.white24,
                            ),

                            const SizedBox(
                              height: 18,
                            ),

                            const Text(
                              'No results found',

                              style: TextStyle(
                                fontSize: 21,
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),

                            const SizedBox(
                              height: 7,
                            ),

                            Text(
                              'No music found for "$searchText"',

                              textAlign:
                                  TextAlign.center,

                              style:
                                  const TextStyle(
                                color:
                                    Colors.white54,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount:
                          filteredSongs.length,

                      itemBuilder:
                          (context, index) {
                        final song =
                            filteredSongs[index]
                                    .data()
                                as Map<
                                    String,
                                    dynamic>;

                        final title =
                            song['title'] ??
                                'Unknown Song';

                        final artist =
                            song['artist'] ??
                                'Unknown Artist';

                        final audioUrl =
                            song['audioUrl'] ??
                                '';

                        return SearchSongTile(
                          title:
                              title.toString(),

                          artist:
                              artist.toString(),

                          audioUrl:
                              audioUrl.toString(),
                        );
                      },
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}


// SONG TILE

class SearchSongTile extends StatelessWidget {
  final String title;
  final String artist;
  final String audioUrl;

  const SearchSongTile({
    super.key,
    required this.title,
    required this.artist,
    required this.audioUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:
          const EdgeInsets.only(
        bottom: 10,
      ),

      padding:
          const EdgeInsets.all(10),

      decoration: BoxDecoration(
        color:
            const Color(0xFF141419),

        borderRadius:
            BorderRadius.circular(15),
      ),

      child: Row(
        children: [

          // SONG ICON

          Container(
            width: 55,
            height: 55,

            decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.circular(12),

              gradient:
                  const LinearGradient(
                colors: [
                  Color(0xFF7C3AED),
                  Color(0xFFEC4899),
                ],
              ),
            ),

            child: const Icon(
              Icons.music_note_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),

          const SizedBox(width: 13),

          // SONG DETAILS

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
                    fontSize: 15,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(
                  height: 5,
                ),

                Text(
                  artist,

                  maxLines: 1,

                  overflow:
                      TextOverflow.ellipsis,

                  style:
                      const TextStyle(
                    color:
                        Colors.white54,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          // PLAY BUTTON

          IconButton(
            onPressed: () {
              Navigator.push(
                context,

                MaterialPageRoute(
                  builder: (_) =>
                      MusicPlayerScreen(
                    songTitle: title,
                    artistName: artist,
                    audioUrl: audioUrl,
                  ),
                ),
              );
            },

            icon: const Icon(
              Icons
                  .play_circle_fill_rounded,
              size: 34,
            ),
          ),
        ],
      ),
    );
  }
}
