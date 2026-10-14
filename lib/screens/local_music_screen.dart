import 'dart:async';
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
  static const MethodChannel _channel = MethodChannel('sereng/local_music');
  final AudioPlayer _player = AudioPlayer();
  final TextEditingController _searchController = TextEditingController();

  List<Map<String, dynamic>> songs = [];
  List<Map<String, dynamic>> filteredSongs = [];
  Set<String> favorites = {};
  bool loading = true;
  bool isPlaying = false;
  bool shuffleEnabled = false;
  bool repeatEnabled = false;
  bool showFavoritesOnly = false;
  int currentIndex = -1;
  Duration position = Duration.zero;
  Duration duration = Duration.zero;
  String? errorMessage;
  StreamSubscription<Duration>? _positionSubscription;
  StreamSubscription<Duration?>? _durationSubscription;
  StreamSubscription<PlayerState>? _playerStateSubscription;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
    loadSongs();
    _positionSubscription = _player.positionStream.listen((value) {
      if (mounted) setState(() => position = value);
    });
    _durationSubscription = _player.durationStream.listen((value) {
      if (mounted) setState(() => duration = value ?? Duration.zero);
    });
    _playerStateSubscription = _player.playerStateStream.listen((state) {
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

  String _songId(Map<String, dynamic> song) =>
      (song['id'] ?? song['uri'] ?? song['title'] ?? '').toString();

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() => favorites = (prefs.getStringList('sereng_favorites') ?? []).toSet());
  }

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('sereng_favorites', favorites.toList());
  }

  Future<void> loadSongs() async {
    setState(() { loading = true; errorMessage = null; });
    try {
      final result = await _channel.invokeListMethod<dynamic>('getSongs');
      final loaded = (result ?? [])
          .map((item) => Map<String, dynamic>.from(item as Map))
          .toList();
      if (!mounted) return;
      setState(() { songs = loaded; loading = false; });
      _applyFilter(_searchController.text);
    } on PlatformException catch (e) {
      if (!mounted) return;
      setState(() { loading = false; errorMessage = e.message ?? 'Music load nahi hua.'; });
    } catch (_) {
      if (!mounted) return;
      setState(() { loading = false; errorMessage = 'Music load nahi hua. Permission check karein.'; });
    }
  }

  Future<void> playSong(int index) async {
    if (index < 0 || index >= songs.length) return;
    final uri = songs[index]['uri']?.toString();
    if (uri == null || uri.isEmpty) { _message('Song ka URI nahi mila.'); return; }
    try {
      await _player.setAudioSource(AudioSource.uri(Uri.parse(uri)));
      if (!mounted) return;
      setState(() { currentIndex = index; position = Duration.zero; duration = Duration.zero; });
      await _player.play();
    } catch (_) {
      _message('Song play nahi hua. Dusra song try karein.');
    }
  }

  Future<void> togglePlayback() async {
    if (currentIndex == -1) {
      if (filteredSongs.isNotEmpty) await playSong(songs.indexOf(filteredSongs.first));
    } else if (_player.playing) {
      await _player.pause();
    } else {
      await _player.play();
    }
  }

  Future<void> playNext() async {
    if (songs.isEmpty) return;
    if (shuffleEnabled && songs.length > 1) {
      final choices = List<int>.generate(songs.length, (i) => i)..remove(currentIndex);
      choices.shuffle();
      await playSong(choices.first);
    } else if (currentIndex + 1 < songs.length) {
      await playSong(currentIndex + 1);
    } else if (repeatEnabled) {
      await playSong(0);
    } else {
      await _player.pause();
    }
  }

  Future<void> playPrevious() async {
    if (songs.isEmpty) return;
    if (position.inSeconds > 3) { await _player.seek(Duration.zero); return; }
    await playSong(currentIndex > 0 ? currentIndex - 1 : songs.length - 1);
  }

  Future<void> toggleFavorite(Map<String, dynamic> song) async {
    final id = _songId(song);
    if (id.isEmpty) return;
    setState(() { favorites.contains(id) ? favorites.remove(id) : favorites.add(id); });
    await _saveFavorites();
    _applyFilter(_searchController.text);
  }

  void _applyFilter(String query) {
    final q = query.trim().toLowerCase();
    setState(() {
      filteredSongs = songs.where((song) {
        final matchesQuery = (song['title'] ?? '').toString().toLowerCase().contains(q) ||
            (song['artist'] ?? '').toString().toLowerCase().contains(q) ||
            (song['album'] ?? '').toString().toLowerCase().contains(q);
        return matchesQuery && (!showFavoritesOnly || favorites.contains(_songId(song)));
      }).toList();
    });
  }

  String formatDuration(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return h > 0 ? '$h:$m:$s' : '${d.inMinutes}:$s';
  }

  void _message(String text) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  Widget _artwork({double size = 52}) => Container(
    width: size, height: size,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      gradient: const LinearGradient(colors: [Color(0xFF673AB7), Color(0xFF00BCD4)]),
    ),
    child: Icon(Icons.music_note_rounded, color: Colors.white, size: size * .55),
  );

  Widget _playerPanel() {
    if (currentIndex < 0 || currentIndex >= songs.length) return const SizedBox.shrink();
    final song = songs[currentIndex];
    final totalMs = duration.inMilliseconds;
    final currentMs = position.inMilliseconds.clamp(0, totalMs > 0 ? totalMs : 0);
    return Container(
      margin: const EdgeInsets.all(12), padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: const Color(0xFF20202C), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white10)),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Row(children: [
          _artwork(size: 54), const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text((song['title'] ?? 'Unknown Song').toString(), maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text((song['artist'] ?? 'Unknown Artist').toString(), maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white60, fontSize: 12)),
          ])),
          IconButton(onPressed: () => toggleFavorite(song), icon: Icon(favorites.contains(_songId(song)) ? Icons.favorite : Icons.favorite_border, color: Colors.pinkAccent)),
        ]),
        Slider(value: totalMs > 0 ? currentMs.toDouble() : 0, max: totalMs > 0 ? totalMs.toDouble() : 1,
          onChanged: totalMs > 0 ? (v) => _player.seek(Duration(milliseconds: v.toInt())) : null,
          activeColor: const Color(0xFF00E5FF), inactiveColor: Colors.white24),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(formatDuration(position), style: const TextStyle(color: Colors.white60, fontSize: 11)),
          Text(formatDuration(duration), style: const TextStyle(color: Colors.white60, fontSize: 11)),
        ]),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          IconButton(tooltip: 'Shuffle', onPressed: () => setState(() => shuffleEnabled = !shuffleEnabled), icon: Icon(Icons.shuffle, color: shuffleEnabled ? const Color(0xFF00E5FF) : Colors.white54)),
          IconButton(tooltip: 'Previous', onPressed: playPrevious, icon: const Icon(Icons.skip_previous_rounded, color: Colors.white, size: 36)),
          Container(decoration: const BoxDecoration(color: Color(0xFF00BCD4), shape: BoxShape.circle), child: IconButton(onPressed: togglePlayback, icon: Icon(isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded, color: Colors.black, size: 32))),
          IconButton(tooltip: 'Next', onPressed: playNext, icon: const Icon(Icons.skip_next_rounded, color: Colors.white, size: 36)),
          IconButton(tooltip: 'Repeat', onPressed: () => setState(() => repeatEnabled = !repeatEnabled), icon: Icon(Icons.repeat, color: repeatEnabled ? const Color(0xFF00E5FF) : Colors.white54)),
        ]),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF101018),
      appBar: AppBar(backgroundColor: const Color(0xFF101018), foregroundColor: Colors.white,
        title: const Text('Local Music', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [IconButton(tooltip: 'Favorites', onPressed: () { setState(() => showFavoritesOnly = !showFavoritesOnly); _applyFilter(_searchController.text); }, icon: Icon(showFavoritesOnly ? Icons.favorite : Icons.favorite_border, color: showFavoritesOnly ? Colors.pinkAccent : Colors.white)), IconButton(tooltip: 'Refresh', onPressed: loadSongs, icon: const Icon(Icons.refresh_rounded))]),
      body: Column(children: [
        Padding(padding: const EdgeInsets.fromLTRB(16, 8, 16, 12), child: TextField(
          controller: _searchController, onChanged: _applyFilter, style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(hintText: 'Search songs, artists, albums...', hintStyle: const TextStyle(color: Colors.white54), prefixIcon: const Icon(Icons.search, color: Colors.white54),
            suffixIcon: _searchController.text.isNotEmpty ? IconButton(onPressed: () { _searchController.clear(); _applyFilter(''); }, icon: const Icon(Icons.close, color: Colors.white54)) : null,
            filled: true, fillColor: const Color(0xFF20202C), border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none)),
        )),
        Padding(padding: const EdgeInsets.symmetric(horizontal: 18), child: Row(children: [const Icon(Icons.library_music, color: Color(0xFF00E5FF), size: 20), const SizedBox(width: 8), Text('${filteredSongs.length} songs', style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.w600)), const Spacer(), Text('${favorites.length} favorites', style: const TextStyle(color: Colors.pinkAccent, fontSize: 12))])),
        const SizedBox(height: 8),
        Expanded(child: loading ? const Center(child: CircularProgressIndicator(color: Color(0xFF00E5FF))) : errorMessage != null
          ? Center(child: Padding(padding: const EdgeInsets.all(24), child: Column(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.error_outline, color: Colors.redAccent, size: 44), const SizedBox(height: 12), Text(errorMessage!, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white70)), const SizedBox(height: 12), ElevatedButton(onPressed: loadSongs, child: const Text('Try Again'))])))
          : filteredSongs.isEmpty ? Center(child: Column(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.music_off_rounded, color: Colors.white38, size: 64), const SizedBox(height: 12), Text(showFavoritesOnly ? 'No favorites yet' : 'No songs found', style: const TextStyle(color: Colors.white70, fontSize: 16)), const SizedBox(height: 8), TextButton.icon(onPressed: showFavoritesOnly ? () { setState(() => showFavoritesOnly = false); _applyFilter(_searchController.text); } : loadSongs, icon: const Icon(Icons.refresh), label: Text(showFavoritesOnly ? 'Show all songs' : 'Refresh'))]))
          : ListView.builder(padding: const EdgeInsets.only(bottom: 8), itemCount: filteredSongs.length, itemBuilder: (context, index) {
            final song = filteredSongs[index]; final actualIndex = songs.indexOf(song); final isCurrent = actualIndex == currentIndex;
            final ms = int.tryParse(song['duration']?.toString() ?? '') ?? 0;
            return ListTile(contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4), leading: _artwork(),
              title: Text((song['title'] ?? 'Unknown Song').toString(), maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: isCurrent ? const Color(0xFF00E5FF) : Colors.white, fontWeight: FontWeight.w600)),
              subtitle: Text('${song['artist'] ?? 'Unknown Artist'} • ${formatDuration(Duration(milliseconds: ms))}', maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white54, fontSize: 12)),
              trailing: Icon(favorites.contains(_songId(song)) ? Icons.favorite : (isCurrent && isPlaying ? Icons.equalizer : Icons.play_circle_outline), color: favorites.contains(_songId(song)) ? Colors.pinkAccent : (isCurrent ? const Color(0xFF00E5FF) : Colors.white54)),
              onTap: () => playSong(actualIndex));
          })),
        _playerPanel(),
      ]),
    );
  }

  @override
  void dispose() {
    _positionSubscription?.cancel(); _durationSubscription?.cancel(); _playerStateSubscription?.cancel();
    _searchController.dispose(); _player.dispose(); super.dispose();
  }
}
