import 'dart:async';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:on_audio_query_pluse/on_audio_query.dart';
import 'package:just_audio/just_audio.dart';

class LocalMusicScreen extends StatefulWidget {
  const LocalMusicScreen({super.key});

  @override
  State<LocalMusicScreen> createState() =>
      _LocalMusicScreenState();
}

class _LocalMusicScreenState extends State<LocalMusicScreen> {
  final OnAudioQuery _audioQuery = OnAudioQuery();
  final AudioPlayer _player = AudioPlayer();

  List<SongModel> songs = [];

  bool loading = true;
  bool permissionDenied = false;
  bool isPlaying = false;
  bool isPickingFile = false;

  int? playingId;
  String? errorMessage;
  String? selectedFileName;

  @override
  void initState() {
    super.initState();

    _player.playerStateStream.listen((state) {
      if (!mounted) return;

      setState(() {
        isPlaying = state.playing;
      });
    });

    loadSongs();
  }

  // ==========================================
  // LOAD SONGS FROM PHONE MEDIA LIBRARY
  // ==========================================

  Future<void> loadSongs() async {
    if (!mounted) return;

    setState(() {
      loading = true;
      permissionDenied = false;
      errorMessage = null;
    });

    try {
      bool hasPermission = await _audioQuery
          .permissionsStatus()
          .timeout(const Duration(seconds: 8));

      if (!hasPermission) {
        hasPermission = await _audioQuery
            .permissionsRequest(retryRequest: true)
            .timeout(const Duration(seconds: 12));
      }

      if (!mounted) return;

      if (!hasPermission) {
        setState(() {
          loading = false;
          permissionDenied = true;
        });
        return;
      }

      final result = await _audioQuery
          .querySongs(
            sortType: SongSortType.TITLE,
            orderType: OrderType.ASC_OR_SMALLER,
            uriType: UriType.EXTERNAL,
            ignoreCase: true,
          )
          .timeout(const Duration(seconds: 20));

      if (!mounted) return;

      setState(() {
        songs = result;
        loading = false;
        errorMessage = null;
      });
    } on TimeoutException catch (e) {
      debugPrint('LOCAL MUSIC TIMEOUT: $e');

      if (!mounted) return;

      setState(() {
        loading = false;
        errorMessage =
            'Phone music scan timed out. Choose Music File to play an MP3.';
      });
    } catch (e, stackTrace) {
      debugPrint('LOCAL MUSIC ERROR: $e');
      debugPrintStack(stackTrace: stackTrace);

      if (!mounted) return;

      setState(() {
        loading = false;
        errorMessage =
            'Unable to scan songs. You can still choose a music file.';
      });
    }
  }

  // ==========================================
  // PICK MUSIC FROM PHONE
  // ==========================================

  Future<void> pickMusicFile() async {
    if (isPickingFile) return;

    try {
      setState(() {
        isPickingFile = true;
      });

      final result = await FilePicker.platform.pickFiles(
        type: FileType.audio,
        allowMultiple: false,
      );

      if (result == null || result.files.isEmpty) {
        return;
      }

      final file = result.files.single;
      final path = file.path;

      if (path == null || path.isEmpty) {
        showMessage(
          'Unable to access this file. Please select another.',
        );
        return;
      }

      await _player.stop();

      await _player.setFilePath(path);

      if (!mounted) return;

      setState(() {
        selectedFileName = file.name;
        playingId = null;
      });

      await _player.play();
    } catch (e, stackTrace) {
      debugPrint('PICK MUSIC ERROR: $e');
      debugPrintStack(stackTrace: stackTrace);

      if (!mounted) return;

      showMessage(
        'Unable to play this file. Please choose another MP3.',
      );
    } finally {
      if (mounted) {
        setState(() {
          isPickingFile = false;
        });
      }
    }
  }

  // ==========================================
  // PLAY SONG FROM MEDIA LIBRARY
  // ==========================================

  Future<void> playSong(SongModel song) async {
    try {
      final uri = song.uri;

      if (uri == null || uri.isEmpty) {
        showMessage('This song cannot be played.');
        return;
      }

      await _player.stop();

      await _player.setAudioSource(
        AudioSource.uri(Uri.parse(uri)),
      );

      if (!mounted) return;

      setState(() {
        playingId = song.id;
        selectedFileName = song.title;
      });

      await _player.play();
    } catch (e, stackTrace) {
      debugPrint('PLAY SONG ERROR: $e');
      debugPrintStack(stackTrace: stackTrace);

      if (!mounted) return;

      showMessage('Unable to play this song.');
    }
  }

  // ==========================================
  // PAUSE / RESUME
  // ==========================================

  Future<void> togglePlayback() async {
    try {
      if (_player.playing) {
        await _player.pause();
      } else {
        await _player.play();
      }
    } catch (e) {
      debugPrint('PLAYBACK ERROR: $e');
      showMessage('Unable to control playback.');
    }
  }

  // ==========================================
  // STOP MUSIC
  // ==========================================

  Future<void> stopSong() async {
    try {
      await _player.stop();

      if (!mounted) return;

      setState(() {
        playingId = null;
        selectedFileName = null;
      });
    } catch (e) {
      debugPrint('STOP ERROR: $e');
      showMessage('Unable to stop music.');
    }
  }

  // ==========================================
  // SHOW MESSAGE
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
    _player.dispose();
    super.dispose();
  }

  // ==========================================
  // MAIN UI
  // ==========================================

  @override
  Widget build(BuildContext context) {
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
            tooltip: 'Refresh songs',
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // CHOOSE FILE BUTTON
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: isPickingFile ? null : pickMusicFile,
                  icon: isPickingFile
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(Icons.folder_open_rounded),
                  label: Text(
                    isPickingFile
                        ? 'Opening files...'
                        : 'Choose Music File',
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: 15,
                    ),
                    backgroundColor: const Color(0xFF292231),
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ),

            // CURRENTLY SELECTED SONG
            if (selectedFileName != null)
              Container(
                margin: const EdgeInsets.fromLTRB(16, 4, 16, 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF19151F),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.music_note_rounded,
                      color: Colors.deepPurpleAccent,
                      size: 30,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        selectedFileName!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: togglePlayback,
                      icon: Icon(
                        isPlaying
                            ? Icons.pause_circle_filled_rounded
                            : Icons.play_circle_fill_rounded,
                        size: 34,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      onPressed: stopSong,
                      icon: const Icon(
                        Icons.stop_circle_rounded,
                        color: Colors.orangeAccent,
                        size: 30,
                      ),
                    ),
                  ],
                ),
              ),

            const Padding(
              padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Songs on your phone',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            Expanded(
              child: _buildSongList(),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // SONG LIST
  // ==========================================

  Widget _buildSongList() {
    if (loading) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 14),
            Text(
              'Scanning phone music...',
              style: TextStyle(color: Colors.white70),
            ),
          ],
        ),
      );
    }

    if (permissionDenied) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.perm_media_outlined,
                size: 64,
                color: Colors.white38,
              ),
              const SizedBox(height: 12),
              const Text(
                'Music permission required',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'You can allow music access or choose a file directly.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white54),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: loadSongs,
                child: const Text('Try Again'),
              ),
            ],
          ),
        ),
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
                Icons.error_outline_rounded,
                size: 60,
                color: Colors.orangeAccent,
              ),
              const SizedBox(height: 12),
              const Text(
                'Unable to scan music',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white54),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: loadSongs,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Try Again'),
              ),
            ],
          ),
        ),
      );
    }

    if (songs.isEmpty) {
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
                'Choose Music File to play an MP3 from Downloads or another folder.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white54),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: pickMusicFile,
                icon: const Icon(Icons.folder_open_rounded),
                label: const Text('Choose Music File'),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      itemCount: songs.length,
      itemBuilder: (context, index) {
        final song = songs[index];
        final bool selected = playingId == song.id;

        final String artist =
            song.artist?.isNotEmpty == true
                ? song.artist!
                : 'Unknown Artist';

        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: const Color(0xFF141419),
            borderRadius: BorderRadius.circular(15),
          ),
          child: ListTile(
            leading: const CircleAvatar(
              backgroundColor: Color(0xFF292231),
              child: Icon(
                Icons.music_note_rounded,
                color: Colors.white70,
              ),
            ),
            title: Text(
              song.title,
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
              onPressed: () {
                if (selected && isPlaying) {
                  togglePlayback();
                } else {
                  playSong(song);
                }
              },
              icon: Icon(
                selected && isPlaying
                    ? Icons.pause_circle_filled_rounded
                    : Icons.play_circle_fill_rounded,
                size: 34,
                color: Colors.white,
              ),
            ),
            onTap: () => playSong(song),
          ),
        );
      },
    );
  }
}
