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

  final List<SearchSong> allSongs = const [
    SearchSong(
      title: 'Dular Re',
      artist: 'Rahul Murmu',
    ),
    SearchSong(
      title: 'Baha Bonga',
      artist: 'Pankaj Murmu',
    ),
    SearchSong(
      title: 'Dular Gate',
      artist: 'Stephan Tudu',
    ),
    SearchSong(
      title: 'Amge Mon',
      artist: 'Stephan Tudu',
    ),
    SearchSong(
      title: 'Johar Re',
      artist: 'Rahul Murmu',
    ),
    SearchSong(
      title: 'Night Vibes',
      artist: 'Sereng Artist',
    ),
  ];

  String searchText = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredSongs = allSongs.where((song) {
      final query = searchText.toLowerCase().trim();

      if (query.isEmpty) {
        return false;
      }

      return song.title.toLowerCase().contains(query) ||
          song.artist.toLowerCase().contains(query);
    }).toList();

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
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
        child: Column(
          children: [
            // Search field
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF18181F),
                borderRadius: BorderRadius.circular(16),
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
                  hintText: 'Songs, artists, albums...',
                  hintStyle: const TextStyle(
                    color: Colors.white38,
                  ),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Colors.white60,
                  ),
                  suffixIcon: searchText.isNotEmpty
                      ? IconButton(
                          icon: const Icon(
                            Icons.clear,
                            color: Colors.white54,
                          ),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {
                              searchText = '';
                            });
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 10,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 25),

            if (searchText.isEmpty)
              const Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
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
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 7),
                      Text(
                        'Find songs and artists you love',
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else if (filteredSongs.isEmpty)
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.music_off_rounded,
                        size: 65,
                        color: Colors.white24,
                      ),
                      const SizedBox(height: 18),
                      const Text(
                        'No results found',
                        style: TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 7),
                      Text(
                        'No music found for "$searchText"',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  itemCount: filteredSongs.length,
                  itemBuilder: (context, index) {
                    final song = filteredSongs[index];

                    return SearchSongTile(
                      title: song.title,
                      artist: song.artist,
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

class SearchSong {
  final String title;
  final String artist;

  const SearchSong({
    required this.title,
    required this.artist,
  });
}

class SearchSongTile extends StatelessWidget {
  final String title;
  final String artist;

  const SearchSongTile({
    super.key,
    required this.title,
    required this.artist,
  });

  @override
  Widget build(BuildContext context) {
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
            width: 55,
            height: 55,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
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
              size: 28,
            ),
          ),

          const SizedBox(width: 13),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  artist,
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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MusicPlayerScreen(
                    songTitle: title,
                    artistName: artist,
                  ),
                ),
              );
            },
            icon: const Icon(
              Icons.play_circle_fill_rounded,
              size: 34,
            ),
          ),
        ],
      ),
    );
  }
}
