import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';

class LocalMusicScreen extends StatefulWidget {
  const LocalMusicScreen({super.key});

  @override
  State<LocalMusicScreen> createState() =>
      _LocalMusicScreenState();
}

class _LocalMusicScreenState extends State<LocalMusicScreen> {
  static const MethodChannel _channel =
      MethodChannel('sereng/local_music');

  final AudioPlayer _player = AudioPlayer();
  final TextEditingController _searchController =
      TextEditingController();

  List<Map<String, dynamic>> songs = [];

  bool loading = true;
  bool isPlaying = false;

  String? errorMessage;
  String? currentUri;
  String? currentTitle;

  int currentIndex = -1;

  @override
  void initState() {
    super.initState();

    _player.playerStateStream.listen((state) {
      if (!mounted) return;

      setState(() {
        isPlaying = state.playing;
      });

      if (state.processingState == ProcessingState.completed) {
        playNext();
      }
    });

    loadSongs();
  }

  // ==========================================
  // LOAD SONGS FROM ANDROID MEDIASTORE
  // ==========================================

  Future<void> loadSongs() async {
    if (!mounted) return;

    setState(() {
      loading = true;
      errorMessage = null;
    });

    try {
      final List<dynamic>? result =
          await _channel.invokeListMethod<dynamic>('getSongs');

      if (!mounted) return;

      final List<Map<String, dynamic>> loadedSongs =
          (result ?? [])
              .map(
                (song) => Map<String, dynamic>.from(song as Map),
              )
              .where(
                (song) =>
                    song['uri'] != null &&
                    song['title'] != null,
              )
              .toList();

      setState(() {
        songs = loadedSongs;
        loading = false;
      });
    } on PlatformException catch (e) {
      if (!mounted) return;

      setState(() {
        loading = false;
        errorMessage =
            'Music scan failed: ${e.message ?? e.code}';
      });
    } on MissingPluginException {
      if (!mounted) return;

      setState(() {
        loading = false;
        errorMessage =
            'Music service is not connected. Build and install the latest APK.';
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        loading = false;
        errorMessage = 'Unable to load songs: $e';
      });
    }
  }

  // ==========================================
  // PLAY SONG
  // ==========================================

  Future<void> playSong(int index) async {
    if (index < 0 || index >= songs.length) return;

    final song = songs[index];
    final uri = song['uri']?.toString();

    if (uri == null || uri.isEmpty) {
      showMessage('Song URI is unavailable.');
      return;
    }

    try {
      await _player.stop();

      await _player.setAudioSource(
        AudioSource.uri(Uri.parse(uri)),
      );

      if (!mounted) return;

      setState(() {
        currentIndex = index;
        currentUri = uri;
        currentTitle = song['title']?.toString() ?? 'Unknown Song';
      });

      await _player.play();
    } catch (e) {
      showMessage('Unable to play this song.');
      debugPrint('LOCAL PLAY ERROR: $e');
    }
  }

  // ==========================================
  // PLAY / PAUSE
  // ==========================================

  Future<void> togglePlayback() async {
    try {
      if (_player.playing) {
        await _player.pause();
      } else if (currentUri != null) {
        await _player.play();
      } else if (songs.isNotEmpty) {
        await playSong(0);
      }
    } catch (e) {
      debugPrint('PLAYBACK ERROR: $e');
      showMessage('Playback failed.');
    }
  }

  // ==========================================
  // NEXT SONG
  // ==========================================

  Future<void> playNext() async {
    if (songs.isEmpty) return;

    final nextIndex = currentIndex + 1;

    if (nextIndex < songs.length) {
      await playSong(nextIndex);
    } else {
      showMessage('You have reached the last song.');
    }
  }

  // ==========================================
  // PREVIOUS SONG
  // ==========================================

  Future<void> playPrevious() async {
    if (songs.isEmpty) return;

    if (currentIndex > 0) {
      await playSong(currentIndex - 1);
    } else {
      showMessage('This is the first song.');
    }
  }

  // ==========================================
  // SEARCH
  // ==========================================

  List<Map<String, dynamic>> get filteredSongs {
    final query = _searchController.text.trim().toLowerCase();

    if (query.isEmpty) return songs;

    return songs.where((song) {
      final title = (song['title'] ?? '')
          .toString()
          .toLowerCase();

      final artist = (song['artist'] ?? '')
          .toString()
          .toLowerCase();

      return title.contains(query) || artist.contains(query);
    }).toList();
  }

  // ==========================================
  // MESSAGE
  // ==========================================

  void showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  // ==========================================
  // DISPOSE
  // ==========================================

  @override
  void dispose() {
    _searchController.dispose();
    _player.dispose();
    super.dispose();
  }

  // ==========================================
  // UI
  // ==========================================

  @override
  Widget build(BuildContext context) {
    final visibleSongs = filteredSongs;

    return Scaffold(
      backgroundColor: const Color(0xFF0B0B0F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B0B0F),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Local Music',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: loading ? null : loadSongs,
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Refresh songs',
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _searchController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Search songs or artists...',
                  hintStyle: const TextStyle(
                    color: Colors.white54,
                  ),
                  prefixIcon: const Icon(
                    Icons.search_rounded,
                    color: Colors.white70,
                  ),
                  filled: true,
                  fillColor: const Color(0xFF19191F),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (_) => setState(() {}),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 4,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '${visibleSongs.length} songs',
                  style: const TextStyle(
                    color: Colors.white60,
                    fontSize: 14,
                  ),
                ),
              ),
            ),

            Expanded(
              child: _buildSongList(visibleSongs),
            ),

            if (currentTitle != null)
              _buildMiniPlayer(),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // SONG LIST
  // ==========================================

  Widget _buildSongList(List<Map<String, dynamic>> visibleSongs) {
    if (loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline,
                size: 56,
                color: Colors.orangeAccent,
              ),
              const SizedBox(height: 12),
              Text(
                errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: loadSongs,
                icon: const Icon(Icons.refresh),
                label: const Text('Try Again'),
              ),
            ],
          ),
        ),
      );
    }

    if (visibleSongs.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.music_off_rounded,
                size: 64,
                color: Colors.white38,
              ),
              const SizedBox(height: 12),
              const Text(
                'No songs found',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Make sure music access is allowed and your songs appear in the phone media library.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white54),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
      itemCount: visibleSongs.length,
      itemBuilder: (context, index) {
        final song = visibleSongs[index];

        final originalIndex = songs.indexOf(song);

        final title =
            song['title']?.toString() ?? 'Unknown Song';

        final artist =
            song['artist']?.toString() ?? 'Unknown Artist';

        final selected = currentIndex == originalIndex;

        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: selected
                ? const Color(0xFF292231)
                : const Color(0xFF141419),
            borderRadius: BorderRadius.circular(15),
          ),
          child: ListTile(
            leading: const CircleAvatar(
              backgroundColor: Color(0xFF393044),
              child: Icon(
                Icons.music_note_rounded,
                color: Colors.white,
              ),
            ),
            title: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              artist,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white54),
            ),
            trailing: IconButton(
              onPressed: () => playSong(originalIndex),
              icon: Icon(
                selected && isPlaying
                    ? Icons.graphic_eq_rounded
                    : Icons.play_circle_fill_rounded,
                color: Colors.white,
                size: 34,
              ),
            ),
            onTap: () => playSong(originalIndex),
          ),
        );
      },
    );
  }

  // ==========================================
  // MINI PLAYER
  // ==========================================

  Widget _buildMiniPlayer() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFF201B27),
        border: Border(
          top: BorderSide(color: Colors.white12),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.music_note_rounded,
            color: Colors.white,
            size: 30,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              currentTitle ?? 'Playing music',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          IconButton(
            onPressed: playPrevious,
            icon: const Icon(
              Icons.skip_previous_rounded,
              color: Colors.white,
            ),
          ),
          IconButton(
            onPressed: togglePlayback,
            icon: Icon(
              isPlaying
                  ? Icons.pause_circle_filled_rounded
                  : Icons.play_circle_fill_rounded,
              color: Colors.white,
              size: 34,
            ),
          ),
          IconButton(
            onPressed: playNext,
            icon: const Icon(
              Icons.skip_next_rounded,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
