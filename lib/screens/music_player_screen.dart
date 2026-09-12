import 'dart:math';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import '../services/audio_player_service.dart';

class MusicPlayerScreen extends StatefulWidget {
  final String songTitle;
  final String artistName;
  final String audioUrl;

  const MusicPlayerScreen({
    super.key,
    required this.songTitle,
    required this.artistName,
    this.audioUrl = '',
  });

  @override
  State<MusicPlayerScreen> createState() =>
      _MusicPlayerScreenState();
}

class _MusicPlayerScreenState
    extends State<MusicPlayerScreen> {
  // Singleton AudioPlayerService
  final AudioPlayerService _audioService =
      AudioPlayerService.instance;

  AudioPlayer get _player =>
      _audioService.player;

  bool isFavorite = false;
  bool isShuffle = false;
  bool isRepeat = false;

  int currentSongIndex = 0;

  late List<Map<String, String>> songs;

  @override
  void initState() {
    super.initState();

    songs = [
      {
        'title': widget.songTitle,
        'artist': widget.artistName,
        'audioUrl': widget.audioUrl,
      },
    ];

    _loadSong();
    _listenToSongCompletion();
  }

  // LOAD SONG
  Future<void> _loadSong() async {
    try {
      if (widget.audioUrl.isEmpty) {
        debugPrint('Audio URL is empty');
        return;
      }

      // Song information service me save hogi
      // Isse Mini Player current song dikha sakega
      await _audioService.playSong(
        title: widget.songTitle,
        artist: widget.artistName,
        url: widget.audioUrl,
      );
    } catch (e) {
      debugPrint('Song load error: $e');
    }
  }

  // SONG COMPLETION
  void _listenToSongCompletion() {
    _player.playerStateStream.listen((state) {
      if (state.processingState ==
          ProcessingState.completed) {
        if (isRepeat) {
          _player.seek(Duration.zero);
          _player.play();
        } else {
          nextSong();
        }
      }
    });
  }

  // CHANGE SONG
  Future<void> _changeSong(int index) async {
    if (songs.isEmpty) return;

    setState(() {
      currentSongIndex = index;
      isFavorite = false;
    });

    final audioUrl =
        songs[index]['audioUrl'] ?? '';

    if (audioUrl.isEmpty) {
      debugPrint('Audio URL is empty');
      return;
    }

    try {
      await _audioService.playSong(
        title:
            songs[index]['title'] ??
                'Unknown Song',
        artist:
            songs[index]['artist'] ??
                'Unknown Artist',
        url: audioUrl,
      );
    } catch (e) {
      debugPrint('Change song error: $e');
    }
  }

  // PREVIOUS SONG
  void previousSong() {
    if (songs.length <= 1) {
      _audioService.seek(Duration.zero);
      return;
    }

    int previousIndex;

    if (currentSongIndex > 0) {
      previousIndex = currentSongIndex - 1;
    } else {
      previousIndex = songs.length - 1;
    }

    _changeSong(previousIndex);
  }

  // NEXT SONG
  void nextSong() {
    if (songs.length <= 1) {
      _audioService.seek(Duration.zero);
      return;
    }

    int nextIndex;

    if (isShuffle) {
      nextIndex = Random().nextInt(
        songs.length,
      );

      while (nextIndex ==
          currentSongIndex) {
        nextIndex = Random().nextInt(
          songs.length,
        );
      }
    } else {
      if (currentSongIndex <
          songs.length - 1) {
        nextIndex =
            currentSongIndex + 1;
      } else {
        nextIndex = 0;
      }
    }

    _changeSong(nextIndex);
  }

  // PLAY / PAUSE
  Future<void> togglePlay() async {
    try {
      if (_player.playing) {
        await _audioService.pause();
      } else {
        final currentUrl =
            songs[currentSongIndex]
                    ['audioUrl'] ??
                '';

        if (currentUrl.isEmpty) {
          debugPrint(
            'No audio URL available',
          );
          return;
        }

        await _audioService.resume();
      }
    } catch (e) {
      debugPrint('Play error: $e');
    }
  }

  // FORMAT TIME
  String formatDuration(
    Duration duration,
  ) {
    String twoDigits(int n) =>
        n.toString().padLeft(2, '0');

    final minutes =
        duration.inMinutes;

    final seconds =
        duration.inSeconds.remainder(60);

    return '$minutes:${twoDigits(seconds)}';
  }

  @override
  void dispose() {
    // Common player dispose nahi karenge,
    // taki screen close hone par music continue rahe.

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentSong =
        songs[currentSongIndex];

    return Scaffold(
      backgroundColor:
          const Color(0xFF0B0B0F),

      body: SafeArea(
        child: Padding(
          padding:
              const EdgeInsets.all(22),

          child: Column(
            children: [
              // TOP BAR

              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons
                          .keyboard_arrow_down_rounded,
                      size: 32,
                    ),
                  ),

                  const Expanded(
                    child: Text(
                      'Now Playing',
                      textAlign:
                          TextAlign.center,
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(
                    width: 48,
                  ),
                ],
              ),

              const Spacer(),

              // ALBUM COVER

              AspectRatio(
                aspectRatio: 1,

                child: Container(
                  width:
                      double.infinity,

                  decoration:
                      BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(
                      28,
                    ),

                    gradient:
                        const LinearGradient(
                      begin:
                          Alignment.topLeft,
                      end:
                          Alignment.bottomRight,
                      colors: [
                        Color(0xFF7C3AED),
                        Color(0xFF2563EB),
                      ],
                    ),

                    boxShadow: const [
                      BoxShadow(
                        color:
                            Colors.black45,
                        blurRadius: 25,
                        offset:
                            Offset(0, 12),
                      ),
                    ],
                  ),

                  child:
                      const Center(
                    child: Icon(
                      Icons
                          .music_note_rounded,
                      size: 120,
                      color:
                          Colors.white70,
                    ),
                  ),
                ),
              ),

              const SizedBox(
                height: 45,
              ),

              // SONG DETAILS

              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment
                              .start,

                      children: [
                        Text(
                          currentSong[
                                  'title'] ??
                              'Unknown Song',

                          maxLines: 1,

                          overflow:
                              TextOverflow
                                  .ellipsis,

                          style:
                              const TextStyle(
                            fontSize: 28,
                            fontWeight:
                                FontWeight
                                    .bold,
                          ),
                        ),

                        const SizedBox(
                          height: 8,
                        ),

                        Text(
                          currentSong[
                                  'artist'] ??
                              'Unknown Artist',

                          style:
                              const TextStyle(
                            fontSize: 17,
                            color:
                                Colors.white54,
                          ),
                        ),
                      ],
                    ),
                  ),

                  IconButton(
                    onPressed: () {
                      setState(() {
                        isFavorite =
                            !isFavorite;
                      });
                    },

                    icon: Icon(
                      isFavorite
                          ? Icons.favorite
                          : Icons
                              .favorite_border,

                      size: 34,

                      color: isFavorite
                          ? Colors.redAccent
                          : Colors.white,
                    ),
                  ),
                ],
              ),

              const SizedBox(
                height: 20,
              ),

              // PROGRESS BAR

              StreamBuilder<Duration?>(
                stream:
                    _player.durationStream,

                builder: (
                  context,
                  durationSnapshot,
                ) {
                  final duration =
                      durationSnapshot.data ??
                          Duration.zero;

                  return StreamBuilder<
                      Duration>(
                    stream:
                        _player.positionStream,

                    builder: (
                      context,
                      positionSnapshot,
                    ) {
                      var position =
                          positionSnapshot.data ??
                              Duration.zero;

                      if (position >
                          duration) {
                        position =
                            duration;
                      }

                      return Column(
                        children: [
                          Slider(
                            value: position
                                .inMilliseconds
                                .toDouble(),

                            min: 0,

                            max: duration
                                        .inMilliseconds >
                                    0
                                ? duration
                                    .inMilliseconds
                                    .toDouble()
                                : 1,

                            activeColor:
                                Colors.white,

                            inactiveColor:
                                Colors.white24,

                            onChanged:
                                (value) {
                              _audioService
                                  .seek(
                                Duration(
                                  milliseconds:
                                      value
                                          .round(),
                                ),
                              );
                            },
                          ),

                          Padding(
                            padding:
                                const EdgeInsets
                                    .symmetric(
                              horizontal: 12,
                            ),

                            child: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment
                                      .spaceBetween,

                              children: [
                                Text(
                                  formatDuration(
                                    position,
                                  ),

                                  style:
                                      const TextStyle(
                                    color:
                                        Colors.white54,
                                    fontSize: 14,
                                  ),
                                ),

                                Text(
                                  formatDuration(
                                    duration,
                                  ),

                                  style:
                                      const TextStyle(
                                    color:
                                        Colors.white54,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),

              const SizedBox(
                height: 25,
              ),

              // MUSIC CONTROLS

              Row(
                mainAxisAlignment:
                    MainAxisAlignment
                        .spaceEvenly,

                children: [
                  // SHUFFLE

                  IconButton(
                    onPressed: () {
                      setState(() {
                        isShuffle =
                            !isShuffle;
                      });
                    },

                    icon: Icon(
                      Icons.shuffle_rounded,

                      size: 30,

                      color: isShuffle
                          ? Colors
                              .deepPurpleAccent
                          : Colors.white,
                    ),
                  ),

                  // PREVIOUS

                  IconButton(
                    onPressed:
                        previousSong,

                    icon: const Icon(
                      Icons
                          .skip_previous_rounded,
                      size: 42,
                    ),
                  ),

                  // PLAY / PAUSE

                  StreamBuilder<bool>(
                    stream:
                        _player.playingStream,

                    builder: (
                      context,
                      snapshot,
                    ) {
                      final isPlaying =
                          snapshot.data ??
                              false;

                      return GestureDetector(
                        onTap:
                            togglePlay,

                        child: Container(
                          width: 88,
                          height: 88,

                          decoration:
                              const BoxDecoration(
                            shape:
                                BoxShape.circle,
                            color:
                                Colors.white,
                          ),

                          child: Icon(
                            isPlaying
                                ? Icons
                                    .pause_rounded
                                : Icons
                                    .play_arrow_rounded,

                            size: 55,

                            color:
                                Colors.black,
                          ),
                        ),
                      );
                    },
                  ),

                  // NEXT

                  IconButton(
                    onPressed:
                        nextSong,

                    icon: const Icon(
                      Icons
                          .skip_next_rounded,
                      size: 42,
                    ),
                  ),

                  // REPEAT

                  IconButton(
                    onPressed: () {
                      setState(() {
                        isRepeat =
                            !isRepeat;
                      });
                    },

                    icon: Icon(
                      Icons.repeat_rounded,

                      size: 30,

                      color: isRepeat
                          ? Colors
                              .deepPurpleAccent
                          : Colors.white,
                    ),
                  ),
                ],
              ),

              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
