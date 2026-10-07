import 'package:flutter/material.dart';
import 'package:on_audio_query_pluse/on_audio_query.dart';
import 'package:just_audio/just_audio.dart';

class LocalMusicScreen extends StatefulWidget {
  const LocalMusicScreen({super.key});

  @override
  State<LocalMusicScreen> createState() =>
      _LocalMusicScreenState();
}

class _LocalMusicScreenState
    extends State<LocalMusicScreen> {
  final OnAudioQuery _audioQuery = OnAudioQuery();
  final AudioPlayer _player = AudioPlayer();

  List<SongModel> songs = [];

  bool loading = true;
  bool permissionDenied = false;

  int? playingId;

  @override
  void initState() {
    super.initState();
    loadSongs();
  }

  Future<void> loadSongs() async {
    if (!mounted) return;

    setState(() {
      loading = true;
      permissionDenied = false;
    });

    try {
      // Request/check media permission.
      final bool permission =
          await _audioQuery.checkAndRequest(
        retryRequest: true,
      );

      if (!permission) {
        if (!mounted) return;

        setState(() {
          loading = false;
          permissionDenied = true;
        });

        return;
      }

      // Query songs from phone storage.
      final List<SongModel> result =
          await _audioQuery.querySongs(
        sortType: SongSortType.TITLE,
        orderType: OrderType.ASC_OR_SMALLER,
        uriType: UriType.EXTERNAL,
        ignoreCase: true,
      );

      if (!mounted) return;

      setState(() {
        songs = result;
        loading = false;
      });
    } catch (e) {
      debugPrint('Local music error: $e');

      if (!mounted) return;

      setState(() {
        loading = false;
        songs = [];
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Unable to access phone music.',
          ),
        ),
      );
    }
  }

  Future<void> playSong(
    SongModel song,
  ) async {
    final String? uri = song.uri;

    if (uri == null || uri.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'This song cannot be played.',
          ),
        ),
      );
      return;
    }

    try {
      await _player.stop();

      await _player.setAudioSource(
        AudioSource.uri(
          Uri.parse(uri),
        ),
      );

      await _player.play();

      if (!mounted) return;

      setState(() {
        playingId = song.id;
      });
    } catch (e) {
      debugPrint('Play error: $e');

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Unable to play this song.',
          ),
        ),
      );
    }
  }

  Future<void> stopSong() async {
    await _player.stop();

    if (!mounted) return;

    setState(() {
      playingId = null;
    });
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      backgroundColor:
          const Color(0xFF0B0B0F),

      appBar: AppBar(
        backgroundColor:
            const Color(0xFF0B0B0F),
        elevation: 0,

        title: const Text(
          'Local Music',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),

        actions: [
          IconButton(
            onPressed: loadSongs,
            icon: const Icon(
              Icons.refresh_rounded,
            ),
          ),
        ],
      ),

      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : permissionDenied
              ? _PermissionDeniedView(
                  onRetry: loadSongs,
                )
              : songs.isEmpty
                  ? _EmptyMusicView(
                      onRefresh: loadSongs,
                    )
                  : ListView.builder(
                      padding:
                          const EdgeInsets.all(12),
                      itemCount: songs.length,
                      itemBuilder:
                          (context, index) {
                        final SongModel song =
                            songs[index];

                        final bool isPlaying =
                            playingId ==
                                song.id;

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
                          decoration:
                              BoxDecoration(
                            color:
                                const Color(
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
                              child: const Icon(
                                Icons
                                    .music_note_rounded,
                                color:
                                    Colors.white70,
                              ),
                            ),

                            title: Text(
                              song.title,
                              maxLines: 1,
                              overflow:
                                  TextOverflow
                                      .ellipsis,
                              style:
                                  const TextStyle(
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),

                            subtitle: Text(
                              artist,
                              maxLines: 1,
                              overflow:
                                  TextOverflow
                                      .ellipsis,
                              style:
                                  const TextStyle(
                                color:
                                    Colors.white54,
                                fontSize: 12,
                              ),
                            ),

                            trailing:
                                IconButton(
                              onPressed: () {
                                if (isPlaying) {
                                  stopSong();
                                } else {
                                  playSong(song);
                                }
                              },
                              icon: Icon(
                                isPlaying
                                    ? Icons
                                        .pause_circle_filled
                                    : Icons
                                        .play_circle_fill,
                                size: 34,
                              ),
                            ),

                            onTap: () {
                              if (isPlaying) {
                                stopSong();
                              } else {
                                playSong(song);
                              }
                            },
                          ),
                        );
                      },
                    ),
    );
  }
}

// ======================================================
// PERMISSION DENIED
// ======================================================

class _PermissionDeniedView
    extends StatelessWidget {
  final VoidCallback onRetry;

  const _PermissionDeniedView({
    required this.onRetry,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Center(
      child: Padding(
        padding:
            const EdgeInsets.all(30),
        child: Column(
          mainAxisSize:
              MainAxisSize.min,
          children: [
            const Icon(
              Icons
                  .perm_media_outlined,
              size: 70,
              color: Colors.white30,
            ),

            const SizedBox(height: 16),

            const Text(
              'Music permission required',
              textAlign:
                  TextAlign.center,
              style: TextStyle(
                fontSize: 19,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Allow music access so SERENG can show songs stored on your phone.',
              textAlign:
                  TextAlign.center,
              style: TextStyle(
                color:
                    Colors.white54,
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

// ======================================================
// EMPTY MUSIC
// ======================================================

class _EmptyMusicView
    extends StatelessWidget {
  final VoidCallback onRefresh;

  const _EmptyMusicView({
    required this.onRefresh,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Center(
      child: Padding(
        padding:
            const EdgeInsets.all(30),
        child: Column(
          mainAxisSize:
              MainAxisSize.min,
          children: [
            const Icon(
              Icons.music_off_rounded,
              size: 70,
              color: Colors.white30,
            ),

            const SizedBox(height: 16),

            const Text(
              'No local songs found',
              style: TextStyle(
                fontSize: 19,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Put an MP3 or other audio file on your phone, then refresh.',
              textAlign:
                  TextAlign.center,
              style: TextStyle(
                color:
                    Colors.white54,
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
