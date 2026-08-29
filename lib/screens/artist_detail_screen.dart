import 'package:flutter/material.dart';

class ArtistDetailScreen extends StatefulWidget {
  const ArtistDetailScreen({super.key});

  @override
  State<ArtistDetailScreen> createState() =>
      _ArtistDetailScreenState();
}

class _ArtistDetailScreenState
    extends State<ArtistDetailScreen> {
  bool isFollowing = false;

  final List<Map<String, String>> songs = const [
    {
      'title': 'Dular Re',
      'plays': '1.2M plays',
    },
    {
      'title': 'Baha Bonga',
      'plays': '980K plays',
    },
    {
      'title': 'Dular Gate',
      'plays': '745K plays',
    },
    {
      'title': 'Amge Mon',
      'plays': '620K plays',
    },
    {
      'title': 'Johar Re',
      'plays': '510K plays',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0B0F),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: const Color(0xFF0B0B0F),
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back),
            ),
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.more_vert),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF3B1B5A),
                      Color(0xFF17121D),
                      Color(0xFF0B0B0F),
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: 125,
                        height: 125,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFF7C3AED),
                              Color(0xFFEC4899),
                            ],
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black54,
                              blurRadius: 20,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.person,
                          size: 65,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.center,
                        children: const [
                          Text(
                            'Rahul Murmu',
                            style: TextStyle(
                              fontSize: 27,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 7),
                          Icon(
                            Icons.verified,
                            size: 20,
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        'Santhali Artist',
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                16,
                20,
                16,
                30,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 48,
                          child: ElevatedButton.icon(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.play_arrow_rounded,
                            ),
                            label: const Text(
                              'Play',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(14),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: SizedBox(
                          height: 48,
                          child: OutlinedButton.icon(
                            onPressed: () {
                              setState(() {
                                isFollowing = !isFollowing;
                              });
                            },
                            icon: Icon(
                              isFollowing
                                  ? Icons.check
                                  : Icons.person_add_outlined,
                            ),
                            label: Text(
                              isFollowing
                                  ? 'Following'
                                  : 'Follow',
                            ),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white,
                              side: const BorderSide(
                                color: Colors.white24,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(14),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),

                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceAround,
                    children: const [
                      ArtistStat(
                        value: '1.8M',
                        label: 'Monthly Listeners',
                      ),
                      ArtistStat(
                        value: '42',
                        label: 'Songs',
                      ),
                      ArtistStat(
                        value: '12',
                        label: 'Albums',
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  const Text(
                    'Popular Songs',
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 14),

                  ...List.generate(
                    songs.length,
                    (index) {
                      final song = songs[index];

                      return ArtistSongTile(
                        number: '${index + 1}',
                        title: song['title']!,
                        plays: song['plays']!,
                      );
                    },
                  ),

                  const SizedBox(height: 25),

                  const Text(
                    'Albums',
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 14),

                  SizedBox(
                    height: 190,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: const [
                        AlbumCard(
                          title: 'Dular Re',
                          year: '2026',
                        ),
                        AlbumCard(
                          title: 'Baha Bonga',
                          year: '2025',
                        ),
                        AlbumCard(
                          title: 'Amge Mon',
                          year: '2025',
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  const Text(
                    'About Artist',
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    'Rahul Murmu is a Santhali music artist '
                    'creating songs inspired by culture, '
                    'love and everyday life.',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ArtistStat extends StatelessWidget {
  final String value;
  final String label;

  const ArtistStat({
    super.key,
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
            fontSize: 19,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white54,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}

class ArtistSongTile extends StatelessWidget {
  final String number;
  final String title;
  final String plays;

  const ArtistSongTile({
    super.key,
    required this.number,
    required this.title,
    required this.plays,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
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
          SizedBox(
            width: 30,
            child: Text(
              number,
              style: const TextStyle(
                color: Colors.white38,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF7C3AED),
                  Color(0xFFEC4899),
                ],
              ),
            ),
            child: const Icon(
              Icons.music_note_rounded,
              color: Colors.white,
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
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  plays,
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),

          IconButton(
            onPressed: () {},
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

class AlbumCard extends StatelessWidget {
  final String title;
  final String year;

  const AlbumCard({
    super.key,
    required this.title,
    required this.year,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 145,
      margin: const EdgeInsets.only(right: 14),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Container(
            height: 140,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF7C3AED),
                  Color(0xFFEC4899),
                ],
              ),
            ),
            child: const Center(
              child: Icon(
                Icons.album_rounded,
                size: 60,
                color: Colors.white70,
              ),
            ),
          ),

          const SizedBox(height: 8),

          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 3),

          Text(
            year,
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
