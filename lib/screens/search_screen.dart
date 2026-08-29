import 'package:flutter/material.dart';
import 'music_player_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();

  final List<SearchSong> songs = const [
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
      title: 'Midnight',
      artist: 'Sereng Artist',
    ),
    SearchSong(
      title: 'Dreamscape',
      artist: 'Luna',
    ),
  ];

  List<SearchSong> get filteredSongs {
    final query = searchController.text.trim().toLowerCase();

    if (query.isEmpty) {
      return songs;
    }

    return songs.where((song) {
      return song.title.toLowerCase().contains(query) ||
          song.artist.toLowerCase().contains(query);
    }).toList();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void openPlayer(SearchSong song) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MusicPlayerScreen(
          songTitle: song.title,
          artistName: song.artist,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final results = filteredSongs;

    return Scaffold(
      backgroundColor: const Color(0xFF0B0B0F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B0B0F),
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text(
          'Search',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          // Search field
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 18),
            child: TextField(
              controller: searchController,
              autofocus: true,
              onChanged: (_) {
                setState(() {});
              },
              style: const TextStyle(
                color: Colors.white,
              ),
              decoration: InputDecoration(
                hintText: 'Songs, artists, albums...',
                hintStyle: const TextStyle(
                  color: Colors.white54,
                ),
                prefixIcon: const Icon(
                  Icons.search,
                  color: Colors.white70,
                ),
                suffixIcon: searchController.text.isNotEmpty
                    ? IconButton(
                        onPressed: () {
                          searchController.clear();
                          setState(() {});
                        },
                        icon: const Icon(
                          Icons.clear,
                          color: Colors.white54,
                        ),
                      )
                    : null,
                filled: true,
                fillColor: const Color(0xFF18181F),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          Expanded(
            child: results.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 65,
                          color: Colors.white38,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'No music found',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Try another song or artist',
                          style: TextStyle(
                            color: Colors.white54,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView(
                    padding: const EdgeInsets.fromLTRB(
                      16,
                      0,
                      16,
                      30,
                    ),
                    children: [
                      Text(
                        searchController.text.trim().isEmpty
                            ? 'Popular Music'
                            : 'Search Results',
                        style: const TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),

                      ...results.map(
                        (song) => SearchSongTile(
                          song: song,
                          onPlay: () => openPlayer(song),
                        ),
                      ),
                    ],
                  ),
          ),
        ],
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
  final SearchSong song;
  final VoidCallback onPlay;

  const SearchSongTile({
    super.key,
    required this.song,
    required this.onPlay,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 9),
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
          // Album image placeholder
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(11),
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
              size: 27,
            ),
          ),

          const SizedBox(width: 13),

          // Song information
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  song.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  song.artist,
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

          // Play
          IconButton(
            onPressed: onPlay,
            icon: const Icon(
              Icons.play_circle_outline,
              size: 31,
            ),
          ),

          // More options
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.more_vert,
              color: Colors.white54,
            ),
          ),
        ],
      ),
    );
  }
}
