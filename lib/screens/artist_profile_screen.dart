import 'package:flutter/material.dart';

import 'music_player_screen.dart';
import 'album_detail_screen.dart';

class ArtistProfileScreen extends StatefulWidget {
  const ArtistProfileScreen({super.key});

  @override
  State<ArtistProfileScreen> createState() =>
      _ArtistProfileScreenState();
}

class _ArtistProfileScreenState
    extends State<ArtistProfileScreen> {
  bool isFollowing = false;

  final List<Map<String, String>> songs = [
    {
      'title': 'Johar Re',
      'subtitle': 'Popular Song',
    },
    {
      'title': 'Adivasi Beats',
      'subtitle': 'Latest Release',
    },
    {
      'title': 'Sarna Song',
      'subtitle': 'Popular Song',
    },
    {
      'title': 'New Santhali Song',
      'subtitle': 'Single',
    },
    {
      'title': 'Disom Re',
      'subtitle': 'Album Track',
    },
  ];

  final List<Map<String, String>> albums = [
    {
      'title': 'Johar',
      'year': '2026',
    },
    {
      'title': 'Adivasi Beats',
      'year': '2025',
    },
    {
      'title': 'Sarna',
      'year': '2025',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0B0F),

      body: SafeArea(
        child: CustomScrollView(
          slivers: [

            // APP BAR
            SliverAppBar(
              backgroundColor:
                  const Color(0xFF0B0B0F),

              elevation: 0,

              pinned: true,

              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },

                icon: const Icon(
                  Icons.arrow_back_rounded,
                ),
              ),

              title: const Text(
                'Artist',

                style: TextStyle(
                  fontWeight:
                      FontWeight.bold,
                ),
              ),

              actions: [
                IconButton(
                  onPressed: () {},

                  icon: const Icon(
                    Icons.more_vert_rounded,
                  ),
                ),
              ],
            ),

            // ARTIST PROFILE
            SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets.fromLTRB(
                  20,
                  15,
                  20,
                  10,
                ),

                child: Column(
                  children: [

                    // ARTIST IMAGE
                    Container(
                      width: 125,
                      height: 125,

                      decoration:
                          BoxDecoration(
                        shape: BoxShape.circle,

                        color:
                            const Color(
                          0xFF24202D,
                        ),

                        border: Border.all(
                          color:
                              Colors.white12,

                          width: 2,
                        ),
                      ),

                      child: const Icon(
                        Icons.person_rounded,

                        size: 70,

                        color:
                            Colors.white54,
                      ),
                    ),

                    const SizedBox(
                      height: 16,
                    ),

                    // ARTIST NAME
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment
                              .center,

                      children: [

                        const Text(
                          'SERENG Artist',

                          style:
                              TextStyle(
                            fontSize: 25,

                            fontWeight:
                                FontWeight
                                    .bold,
                          ),
                        ),

                        const SizedBox(
                          width: 6,
                        ),

                        Container(
                          width: 20,
                          height: 20,

                          decoration:
                              const BoxDecoration(
                            shape:
                                BoxShape.circle,

                            color:
                                Colors.white,
                          ),

                          child:
                              const Icon(
                            Icons.check,

                            size: 14,

                            color:
                                Colors.black,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(
                      height: 7,
                    ),

                    const Text(
                      'Santhali Music Artist',

                      style: TextStyle(
                        color:
                            Colors.white54,

                        fontSize: 13,
                      ),
                    ),

                    const SizedBox(
                      height: 14,
                    ),

                    // STATS
                    const Row(
                      mainAxisAlignment:
                          MainAxisAlignment
                              .center,

                      children: [

                        _StatItem(
                          value: '12.5K',
                          label:
                              'Followers',
                        ),

                        SizedBox(
                          width: 35,
                        ),

                        _StatItem(
                          value: '38',
                          label:
                              'Songs',
                        ),

                        SizedBox(
                          width: 35,
                        ),

                        _StatItem(
                          value: '6',
                          label:
                              'Albums',
                        ),
                      ],
                    ),

                    const SizedBox(
                      height: 18,
                    ),

                    // FOLLOW BUTTON
                    Row(
                      children: [

                        Expanded(
                          child: SizedBox(
                            height: 46,

                            child:
                                ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  isFollowing =
                                      !isFollowing;
                                });
                              },

                              style:
                                  ElevatedButton
                                      .styleFrom(
                                backgroundColor:
                                    isFollowing
                                        ? const Color(
                                            0xFF24202D,
                                          )
                                        : Colors.white,

                                foregroundColor:
                                    isFollowing
                                        ? Colors.white
                                        : Colors.black,

                                elevation: 0,

                                shape:
                                    RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius
                                          .circular(
                                    14,
                                  ),
                                ),
                              ),

                              child: Text(
                                isFollowing
                                    ? 'Following'
                                    : 'Follow',

                                style:
                                    const TextStyle(
                                  fontWeight:
                                      FontWeight
                                          .bold,
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(
                          width: 10,
                        ),

                        Container(
                          height: 46,
                          width: 46,

                          decoration:
                              BoxDecoration(
                            color:
                                const Color(
                              0xFF141419,
                            ),

                            borderRadius:
                                BorderRadius
                                    .circular(
                              14,
                            ),
                          ),

                          child: IconButton(
                            onPressed: () {},

                            icon:
                                const Icon(
                              Icons
                                  .share_rounded,

                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // POPULAR SONGS TITLE
            const SliverToBoxAdapter(
              child: Padding(
                padding:
                    EdgeInsets.fromLTRB(
                  18,
                  22,
                  18,
                  12,
                ),

                child: Text(
                  'Popular Songs',

                  style: TextStyle(
                    fontSize: 21,

                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ),
            ),

            // POPULAR SONGS
            SliverList(
              delegate:
                  SliverChildBuilderDelegate(
                (context, index) {
                  final song =
                      songs[index];

                  return Container(
                    margin:
                        const EdgeInsets.fromLTRB(
                      14,
                      0,
                      14,
                      8,
                    ),

                    padding:
                        const EdgeInsets.all(
                      9,
                    ),

                    decoration:
                        BoxDecoration(
                      color:
                          const Color(
                        0xFF141419,
                      ),

                      borderRadius:
                          BorderRadius.circular(
                        14,
                      ),
                    ),

                    child: Row(
                      children: [

                        // SONG NUMBER
                        Text(
                          '${index + 1}',

                          style:
                              const TextStyle(
                            color:
                                Colors.white38,

                            fontSize: 13,
                          ),
                        ),

                        const SizedBox(
                          width: 12,
                        ),

                        // SONG ICON
                        Container(
                          width: 52,
                          height: 52,

                          decoration:
                              BoxDecoration(
                            color:
                                const Color(
                              0xFF292231,
                            ),

                            borderRadius:
                                BorderRadius
                                    .circular(
                              10,
                            ),
                          ),

                          child:
                              const Icon(
                            Icons
                                .music_note_rounded,

                            color:
                                Colors.white70,
                          ),
                        ),

                        const SizedBox(
                          width: 12,
                        ),

                        // SONG DETAILS
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,

                            children: [

                              Text(
                                song['title']!,

                                maxLines: 1,

                                overflow:
                                    TextOverflow
                                        .ellipsis,

                                style:
                                    const TextStyle(
                                  fontWeight:
                                      FontWeight
                                          .bold,
                                ),
                              ),

                              const SizedBox(
                                height: 4,
                              ),

                              Text(
                                song['subtitle']!,

                                style:
                                    const TextStyle(
                                  color:
                                      Colors
                                          .white54,

                                  fontSize: 11,
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
                                  songTitle:
                                      song['title']!,

                                  artistName:
                                      'SERENG Artist',
                                ),
                              ),
                            );
                          },

                          icon: const Icon(
                            Icons
                                .play_circle_fill_rounded,

                            size: 28,
                          ),
                        ),

                        // MORE BUTTON
                        IconButton(
                          onPressed: () {},

                          icon:
                              const Icon(
                            Icons
                                .more_vert_rounded,

                            color:
                                Colors.white54,
                          ),
                        ),
                      ],
                    ),
                  );
                },

                childCount:
                    songs.length,
              ),
            ),

            // ALBUMS TITLE
            const SliverToBoxAdapter(
              child: Padding(
                padding:
                    EdgeInsets.fromLTRB(
                  18,
                  25,
                  18,
                  12,
                ),

                child: Text(
                  'Albums',

                  style: TextStyle(
                    fontSize: 21,

                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ),
            ),

            // ALBUM LIST
            SliverToBoxAdapter(
              child: SizedBox(
                height: 175,

                child:
                    ListView.builder(
                  padding:
                      const EdgeInsets
                          .symmetric(
                    horizontal: 16,
                  ),

                  scrollDirection:
                      Axis.horizontal,

                  itemCount:
                      albums.length,

                  itemBuilder:
                      (context, index) {
                    final album =
                        albums[index];

                    // CLICKABLE ALBUM
                    return GestureDetector(
                      onTap: () {

                        Navigator.push(
                          context,

                          MaterialPageRoute(
                            builder: (_) =>
                                AlbumDetailScreen(
                              albumName:
                                  album[
                                      'title']!,

                              artistName:
                                  'SERENG Artist',
                            ),
                          ),
                        );
                      },

                      child: Container(
                        width: 145,

                        margin:
                            const EdgeInsets
                                .only(
                          right: 12,
                        ),

                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,

                          children: [

                            // ALBUM COVER
                            Container(
                              width: 145,
                              height: 125,

                              decoration:
                                  BoxDecoration(
                                color:
                                    const Color(
                                  0xFF24202D,
                                ),

                                borderRadius:
                                    BorderRadius
                                        .circular(
                                  14,
                                ),
                              ),

                              child:
                                  const Icon(
                                Icons
                                    .album_rounded,

                                size: 55,

                                color:
                                    Colors.white54,
                              ),
                            ),

                            const SizedBox(
                              height: 8,
                            ),

                            // ALBUM NAME
                            Text(
                              album['title']!,

                              maxLines: 1,

                              overflow:
                                  TextOverflow
                                      .ellipsis,

                              style:
                                  const TextStyle(
                                fontWeight:
                                    FontWeight
                                        .bold,
                                    fontSize: 16,
          ),
        ),

        const SizedBox(
          height: 3,
        ),

        Text(
          label,

          style:
              const TextStyle(
            color:
                Colors.white54,

            fontSize: 11,
          ),
        ),
      ],
    );
  }
                        }
