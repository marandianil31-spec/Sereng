import 'dart:async';

import 'package:flutter/material.dart';
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

  int? playingId;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    loadSongs();
  }

  // ==========================================
  // LOAD LOCAL SONGS
  // ==========================================

  Future<void> loadSongs() async {
    if (!mounted) return;

    setState(() {
      loading = true;
      permissionDenied = false;
      errorMessage = null;
    });

    try {
      debugPrint('LOCAL MUSIC: Checking permission...');

      // Check current permission status.
      final bool permission =
          await _audioQuery
              .permissionsStatus()
              .timeout(
                const Duration(seconds: 10),
              );

      debugPrint(
        'LOCAL MUSIC: Permission status = $permission',
      );

      bool hasPermission = permission;

      // Request permission if it has not been granted.
      if (!hasPermission) {
        debugPrint(
          'LOCAL MUSIC: Requesting permission...',
        );

        hasPermission =
            await _audioQuery
                .permissionsRequest(
                  retryRequest: true,
                )
                .timeout(
                  const Duration(seconds: 15),
                );

        debugPrint(
          'LOCAL MUSIC: Permission granted = $hasPermission',
        );
      }

      if (!mounted) return;

      if (!hasPermission) {
        setState(() {
          loading = false;
          permissionDenied = true;
        });
        return;
      }

      // Query songs from phone storage.
      debugPrint('LOCAL MUSIC: Querying songs...');

      final List<SongModel> result =
          await _audioQuery
              .querySongs(
                sortType: SongSortType.TITLE,
                orderType: OrderType.ASC_OR_SMALLER,
                uriType: UriType.EXTERNAL,
                ignoreCase: true,
              )
              .timeout(
                const Duration(seconds: 20),
              );

      debugPrint(
        'LOCAL MUSIC: Songs found = ${result.length}',
      );

      if (!mounted) return;

      setState(() {
        songs = result;
        loading = false;
        permissionDenied = false;
        errorMessage = null;
      });
    } on TimeoutException catch (e, stackTrace) {
      debugPrint('LOCAL MUSIC TIMEOUT: $e');
      debugPrintStack(stackTrace: stackTrace);

      if (!mounted) return;

      setState(() {
        loading = false;
        songs = [];
        errorMessage =
            'Music query timed out. Please try again.';
      });
    } catch (e, stackTrace) {
      debugPrint('LOCAL MUSIC ERROR: $e');
      debugPrintStack(stackTrace: stackTrace);

      if (!mounted) return;

      setState(() {
        loading = false;
        songs = [];
        errorMessage =
            'Unable to load music. Please try again.';
      });
    }
  }

  // ==========================================
  // PLAY SONG
  // ==========================================

  Future<void> playSong(SongModel song) async {
    final String? uri = song.uri;

    if (uri == null || uri.isEmpty) {
      showMessage('This song cannot be played.');
      return;
    }

    try {
      await _player.stop();

      await _player.setAudioSource(
        AudioSource.uri(
          Uri.parse(uri),
        ),
      );

      if (!mounted) return;

      setState(() {
        playingId = song.id;
        isPlaying = true;
      });

      await _player.play();

      if (!mounted) return;

      setState(() {
        playingId = null;
        isPlaying = false;
      });
    } catch (e, stackTrace) {
      debugPrint('LOCAL MUSIC PLAY ERROR: $e');
      debugPrintStack(stackTrace: stackTrace);

      if (!mounted) return;

      setState(() {
        playingId = null;
        isPlaying = false;
      });

      showMessage('Unable to play this song.');
    }
  }

  // ==========================================
  // STOP SONG
  // ==========================================

  Future<void> stopSong() async {
    try {
      await _player.stop();

      if (!mounted) return;

      setState(() {
        playingId = null;
        isPlaying = false;
      });
    } catch (e) {
      debugPrint('LOCAL MUSIC STOP ERROR: $e');
      showMessage('Unable to stop playback.');
    }
  }

  // ==========================================
  // SHOW MESSAGE
  // ==========================================

  void showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
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
        elevation: 0,
        title: const Text(
          'Local Music',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: loading ? null : loadSongs,
            tooltip: 'Refresh songs',
            icon: const Icon(
              Icons.refresh_rounded,
            ),
          ),
        ],
      ),

      body: loading
          ? const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text(
                    'Checking music access...',
                    style: TextStyle(
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            )
          : permissionDenied
              ? _PermissionDeniedView(
                  onRetry: loadSongs,
                )
              : errorMessage != null
                  ? _ErrorView(
                      message: errorMessage!,
                      onRetry: loadSongs,
                    )
                  : songs.isEmpty
                      ? _EmptyMusicView(
                          onRefresh: loadSongs,
                        )
                      : Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(
                                16,
                                12,
                                16,
                                4,
                              ),
                              child: Text(
                                '${songs.length} songs found',
                                style: const TextStyle(
                                  color: Colors.white60,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            Expanded(
                              child: ListView.builder(
                                padding:
                                    const EdgeInsets.all(12),
                                itemCount: songs.length,
                                itemBuilder:
                                    (context, index) {
                                  final SongModel song =
                                      songs[index];

                                  final bool selected =
                                      playingId == song.id;

                                  final String artist =
                                      song.artist
                                                  ?.isNotEmpty ==
                                              true
                                          ? song.artist!
                                          : 'Unknown Artist';

                                  return Container(
                                    margin:
                                        const EdgeInsets.only(
                                      bottom: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(
                                        0xFF141419,
                                      ),
                                      borderRadius:
                                          BorderRadius.circular(
                                        15,
                                      ),
                                    ),
                                    child: ListTile(
                                      contentPadding:
                                          const EdgeInsets
                                              .symmetric(
                                        horizontal: 12,
                                        vertical: 4,
                                      ),
                                      leading: Container(
                                        width: 52,
                                        height: 52,
                                        decoration:
                                            BoxDecoration(
                                          color: const Color(
                                            0xFF292231,
                                          ),
                                          borderRadius:
                                              BorderRadius
                                                  .circular(10),
                                        ),
                                        child: const Icon(
                                          Icons
                                              .music_note_rounded,
                                          color: Colors.white70,
                                        ),
                                      ),
                                      title: Text(
                                        song.title,
                                        maxLines: 1,
                                        overflow:
                                            TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontWeight:
                                              FontWeight.bold,
                                        ),
                                      ),
                                      subtitle: Text(
                                        artist,
                                        maxLines: 1,
                                        overflow:
                                            TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: Colors.white54,
                                          fontSize: 12,
                                        ),
                                      ),
                                      trailing: IconButton(
                                        onPressed: () {
                                          if (selected) {
                                            stopSong();
                                          } else {
                                            playSong(song);
                                          }
                                        },
                                        icon: Icon(
                                          selected
                                              ? Icons
                                                  .stop_circle_rounded
                                              : Icons
                                                  .play_circle_fill,
                                          size: 34,
                                        ),
                                      ),
                                      onTap: () {
                                        if (selected) {
                                          stopSong();
                                        } else {
                                          playSong(song);
                                        }
                                      },
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
    );
  }
}

// ==========================================
// PERMISSION DENIED VIEW
// ==========================================

class _PermissionDeniedView extends StatelessWidget {
  final VoidCallback onRetry;

  const _PermissionDeniedView({
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.perm_media_outlined,
              size: 70,
              color: Colors.white30,
            ),
            const SizedBox(height: 16),
            const Text(
              'Music permission required',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Allow music access so SERENG can display songs stored on your phone.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white54,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(
                Icons.refresh_rounded,
              ),
              label: const Text(
                'Allow & Try Again',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// EMPTY MUSIC VIEW
// ==========================================

class _EmptyMusicView extends StatelessWidget {
  final VoidCallback onRefresh;

  const _EmptyMusicView({
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.music_off_rounded,
              size: 70,
              color: Colors.white30,
            ),
            const SizedBox(height: 16),
            const Text(
              'No local songs found',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Make sure your phone contains MP3 or other audio files, then refresh.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white54,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: onRefresh,
              icon: const Icon(
                Icons.refresh_rounded,
              ),
              label: const Text(
                'Refresh Songs',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// ERROR VIEW
// ==========================================

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              size: 64,
              color: Colors.orangeAccent,
            ),
            const SizedBox(height: 16),
            const Text(
              'Unable to load music',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white54,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(
                Icons.refresh_rounded,
              ),
              label: const Text(
                'Try Again',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
