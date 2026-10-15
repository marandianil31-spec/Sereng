import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalMusicScreen extends StatefulWidget {
  const LocalMusicScreen({super.key});

  @override
  State<LocalMusicScreen> createState() => _LocalMusicScreenState();
}

class _LocalMusicScreenState extends State<LocalMusicScreen> {
  static const MethodChannel _channel =
      MethodChannel('sereng/local_music');

  final AudioPlayer _player = AudioPlayer();
  final TextEditingController _searchController =
      TextEditingController();

  List<Map<String, dynamic>> songs = [];
  List<Map<String, dynamic>> filteredSongs = [];
  Set<String> favorites = {};

  int currentIndex = -1;

  bool loading = true;
  bool isPlaying = false;
  bool shuffleEnabled = false;
  bool repeatEnabled = false;
  bool showFavoritesOnly = false;

  Duration position = Duration.zero;
  Duration duration = Duration.zero;

  @override
  void initState() {
    super.initState();

    _loadFavorites();
    loadSongs();

    _player.positionStream.listen((value) {
      if (!mounted) return;
      setState(() => position = value);
    });

    _player.durationStream.listen((value) {
      if (!mounted) return;
      setState(() => duration = value ?? Duration.zero);
    });

    _player.playerStateStream.listen((state) {
      if (!mounted) return;

      setState(() => isPlaying = state.playing);

      if (state.processingState == ProcessingState.completed) {
        if (repeatEnabled && currentIndex >= 0) {
          playSong(currentIndex);
        } else {
          playNext();
        }
      }
    });
  }

  String songId(Map<String, dynamic> song) {
    return song['id']?.toString() ??
        song['uri']?.toString() ??
        song['title']?.toString() ??
        '';
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();

    if (!mounted) return;

    setState(() {
      favorites =
          (prefs.getStringList('sereng_favorites') ?? []).toSet();
    });
  }

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setStringList(
      'sereng_favorites',
      favorites.toList(),
    );
  }

  Future<void> toggleFavorite(Map<String, dynamic> song) async {
    final id = songId(song);

    setState(() {
      if (favorites.contains(id)) {
        favorites.remove(id);
      } else {
        favorites.add(id);
      }

      _filterSongs(_searchController.text);
    });

    await _saveFavorites();
  }

  Future<void> loadSongs() async {
    setState(() {
      loading = true;
    });

    try {
      final result =
          await _channel.invokeListMethod<dynamic>('getSongs');

      final loaded = (result ?? [])
          .map((item => Map<String, dynamic>.from(item as Map)))
          .toList();

      if (!mounted) return;

      setState(() {
        songs = loaded;
        loading = false;
        _filterSongs(_searchController.text);
      });
    } catch (e) {
      if (!mounted) return;

      setState(() => loading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Songs load nahi hue. Music permission check karein.',
          ),
        ),
      );
    }
  }

  void _filterSongs(String query) {
    final q = query.toLowerCase().trim();

    filteredSongs = songs.where((song) {
      final title = (song['title'] ?? '').toString().toLowerCase();
      final artist = (song['artist'] ?? '').toString().toLowerCase();
      final album = (song['album'] ?? '').toString().toLowerCase();

      final matchesSearch = title.contains(q) ||
          artist.contains(q) ||
          album.contains(q);

      final matchesFavorite =
          !showFavoritesOnly || favorites.contains(songId(song));

      return matchesSearch && matchesFavorite;
    }).toList();
  }

  void searchSongs(String query) {
    setState(() => _filterSongs(query));
  }

  Future<void> playSong(int index) async {
    if (index < 0 || index >= songs.length) return;

    final song = songs[index];
    final uri = song['uri']?.toString();

    if (uri == null || uri.isEmpty) {
      _showMessage('Song URI nahi mila.');
      return;
    }

    try {
      await _player.setAudioSource(
        AudioSource.uri(Uri.parse(uri)),
      );

      if (!mounted) return;

      setState(() {
        currentIndex = index;
        position = Duration.zero;
        duration = Duration.zero;
      });

      await _player.play();
    } catch (e) {
      _showMessage('Song play nahi hua. Dusra song try karein.');
    }
  }

  Future<void> togglePlayback() async {
    if (currentIndex == -1) {
      if (songs.isNotEmpty) {
        await playSong(songs.indexOf(filteredSongs.first));
      }
      return;
    }

    if (_player.playing) {
      await _player.pause();
    } else {
      await _player.play();
    }
  }

  Future<void> playNext() async {
    if (songs.isEmpty) return;

    if (shuffleEnabled && songs.length > 1) {
      final choices = List<int>.generate(songs.length, (i) => i)
        ..remove(currentIndex);

      choices.shuffle();

      await playSong(choices.first);
      return;
    }

    if (currentIndex + 1 < songs.length) {
      await playSong(currentIndex + 1);
    } else if (repeatEnabled) {
      await playSong(0);
    } else {
      await _player.pause();
    }
  }

  Future<void> playPrevious() async {
    if (songs.isEmpty) return;

    if (position.inSeconds > 3) {
      await _player.seek(Duration.zero);
      return;
    }

    if (currentIndex > 0) {
      await playSong(currentIndex - 1);
    } else {
      await playSong(songs.length - 1);
    }
  }

  String formatTime(Duration value) {
    final hours = value.inHours;
    final minutes = value.inMinutes.remainder(60);
    final seconds = value.inSeconds.remainder(60);

    if (hours > 0) {
      return '$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }

    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Widget _artwork({double size = 52}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF673AB7),
            Color(0xFF00BCD4),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Icon(
        Icons.music_note_rounded,
        color: Colors.white,
        size: size * 0.55,
      ),
    );
  }

  Widget _buildPlayer() {
    if (currentIndex < 0 || currentIndex >= songs.length) {
      return const SizedBox.shrink();
    }

    final song = songs[currentIndex];

    return Container(
      margin: const EdgeInsets.fromLTRB(12, 8, 12, 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF20202C),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              _artwork(size: 56),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      song['title']?.toString() ?? 'Unknown Song',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      song['artist']?.toString() ?? 'Unknown Artist',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white60,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => toggleFavorite(song),
                icon: Icon(
                  favorites.contains(songId(song))
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: Colors.pinkAccent,
                ),
              ),
            ],
          ),
          Slider(
            value: duration.inMilliseconds > 0
                ? position.inMilliseconds
                    .clamp(0, duration.inMilliseconds)
                    .toDouble()
                : 0,
            max: duration.inMilliseconds > 0
                ? duration.inMilliseconds.toDouble()
                : 1,
            onChanged: duration.inMilliseconds > 0
                ? (value) => _player.seek(
                      Duration(milliseconds: value.toInt()),
                    )
                : null,
            activeColor: const Color(0xFF00E5FF),
            inactiveColor: Colors.white24,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                formatTime(position),
                style: const TextStyle(
                  color: Colors.white60,
                  fontSize: 11,
                ),
              ),
              Text(
                formatTime(duration),
                style: const TextStyle(
                  color: Colors.white60,
                  fontSize: 11,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                tooltip: 'Shuffle',
                onPressed: () {
                  setState(() => shuffleEnabled = !shuffleEnabled);
                },
                icon: Icon(
                  Icons.shuffle,
                  color: shuffleEnabled
                      ? const Color(0xFF00E5FF)
                      : Colors.white54,
                ),
              ),
              IconButton(
                tooltip: 'Previous',
                onPressed: playPrevious,
                icon: const Icon(
                  Icons.skip_previous_rounded,
                  color: Colors.white,
                  size: 36,
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                  color: Color(0xFF00E5FF),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  onPressed: togglePlayback,
                  icon: Icon(
                    isPlaying
                        ? Icons.pause_rounded
                        : Icons.play_arrow_rounded,
                    color: Colors.black,
                    size: 30,
                  ),
                ),
              ),
              IconButton(
                tooltip: 'Next',
                onPressed: playNext,
                icon: const Icon(
                  Icons.skip_next_rounded,
                  color: Colors.white,
                  size: 36,
                ),
              ),
              IconButton(
                tooltip: 'Repeat',
                onPressed: () {
                  setState(() => repeatEnabled = !repeatEnabled);
                },
                icon: Icon(
                  Icons.repeat,
                  color: repeatEnabled
                      ? const Color(0xFF00E5FF)
                      : Colors.white54,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF101018),
      appBar: AppBar(
        backgroundColor: const Color(0xFF101018),
        foregroundColor: Colors.white,
        title: const Text(
          'Local Music',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            tooltip: 'Favorites',
            onPressed: () {
              setState(() {
                showFavoritesOnly = !showFavoritesOnly;
                _filterSongs(_searchController.text);
              });
            },
            icon: Icon(
              showFavoritesOnly ? Icons.favorite : Icons.favorite_border,
              color: showFavoritesOnly
                  ? Colors.pinkAccent
                  : Colors.white,
            ),
          ),
          IconButton(
            tooltip: 'Refresh',
            onPressed: loadSongs,
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: TextField(
              controller: _searchController,
              onChanged: searchSongs,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search songs, artists, albums...',
                hintStyle: const TextStyle(color: Colors.white54),
                prefixIcon: const Icon(
                  Icons.search,
                  color: Colors.white54,
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        onPressed: () {
                          _searchController.clear();
                          searchSongs('');
                        },
                        icon: const Icon(
                          Icons.close,
                          color: Colors.white54,
                        ),
                      )
                    : null,
                filled: true,
                fillColor: const Color(0xFF20202C),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Row(
              children: [
                const Icon(
                  Icons.library_music,
                  color: Color(0xFF00E5FF),
                ),
                const SizedBox(width: 8),
                Text(
                  '${filteredSongs.length} songs',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Text(
                  '${favorites.length} favorites',
                  style: const TextStyle(
                    color: Colors.pinkAccent,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: loading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF00E5FF),
                    ),
                  )
                : filteredSongs.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.music_off_rounded,
                              color: Colors.white38,
                              size: 60,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              showFavoritesOnly
                                  ? 'No favorite songs yet'
                                  : 'No songs found',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextButton.icon(
                              onPressed: loadSongs,
                              icon: const Icon(Icons.refresh),
                              label: const Text('Refresh'),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.only(bottom: 8),
                        itemCount: filteredSongs.length,
                        itemBuilder: (context, index) {
                          final song = filteredSongs[index];
                          final actualIndex = songs.indexOf(song);
                          final isCurrent = actualIndex == currentIndex;
                          final isFavorite =
                              favorites.contains(songId(song));

                          final milliseconds = int.tryParse(
                                song['duration']?.toString() ?? '',
                              ) ??
                              0;

                          return ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 4,
                            ),
                            leading: _artwork(),
                            title: Text(
                              song['title']?.toString() ?? 'Unknown Song',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: isCurrent
                                    ? const Color(0xFF00E5FF)
                                    : Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: Text(
                              '${song['artist'] ?? 'Unknown Artist'} • ${formatTime(Duration(milliseconds: milliseconds))}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white54,
                                fontSize: 12,
                              ),
                            ),
                            trailing: IconButton(
                              onPressed: () => toggleFavorite(song),
                              icon: Icon(
                                isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: isFavorite
                                    ? Colors.pinkAccent
                                    : Colors.white54,
                              ),
                            ),
                            onTap: () => playSong(actualIndex),
                          );
                        },
                      ),
          ),
          _buildPlayer(),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _player.dispose();
    super.dispose();
  }
}
