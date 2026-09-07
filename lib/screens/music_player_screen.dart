import 'dart:math';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class MusicPlayerScreen extends StatefulWidget {
  final String songTitle;
  final String artistName;

  const MusicPlayerScreen({
    super.key,
    required this.songTitle,
    required this.artistName,
  });

  @override
  State<MusicPlayerScreen> createState() =>
      _MusicPlayerScreenState();
}

class _MusicPlayerScreenState extends State<MusicPlayerScreen> {
  final AudioPlayer _player = AudioPlayer();

  bool isFavorite = false;
  bool isShuffle = false;
  bool isRepeat = false;

  int currentSongIndex = 0;

  final String firebaseSongUrl =
      'https://firebasestorage.googleapis.com/v0/b/sereng-31dfd.firebasestorage.app/o/Nawa%20Nawam%20Juwan%20Akana%20Santali%20New%20Video%20%20Full%20Video%20%20Birsa%20Hansdah%20Rupali%20Tudu%20Bunty%20Studio.mp3?alt=media&token=302b6433-0aaa-4ef0-b047-5d0c7973b0ff';

  late List<Map<String, String>> songs;

  @override
  void initState() {
    super.initState();

    songs = [
      {
        'title': widget.songTitle,
        'artist': widget.artistName,
      },
      {
        'title': 'Johar Re',
        'artist': 'Santhali Artist',
      },
      {
        'title': 'Baha Bonga',
        'artist': 'SERENG Artist',
      },
      {
        'title': 'Amge Mon',
        'artist': 'Santhali Artist',
      },
      {
        'title': 'Dular Gate',
        'artist': 'SERENG Artist',
      },
    ];

    _loadSong();
    _listenToSongCompletion();
  }

  Future<void> _loadSong() async {
    try {
      await _player.setUrl(firebaseSongUrl);
    } catch (e) {
      debugPrint('Song load error: $e');
    }
  }

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

  Future<void> _changeSong(int index) async {
    setState(() {
      currentSongIndex = index;
      isFavorite = false;
    });

    try {
      await _player.stop();

      await _player.setUrl(firebaseSongUrl);

      await _player.play();
    } catch (e) {
      debugPrint('Change song error: $e');
    }
  }

  void previousSong() {
    int previousIndex;

    if (currentSongIndex > 0) {
      previousIndex = currentSongIndex - 1;
    } else {
      previousIndex = songs.length - 1;
    }

    _changeSong(previousIndex);
  }

  void nextSong() {
    int nextIndex;

    if (isShuffle) {
      nextIndex = Random().nextInt(songs.length);

      if (songs.length > 1) {
        while (nextIndex == currentSongIndex) {
          nextIndex = Random().nextInt(songs.length);
        }
      }
    } else {
      if (currentSongIndex < songs.length - 1) {
        nextIndex = currentSongIndex + 1;
      } else {
        nextIndex = 0;
      }
    }

    _changeSong(nextIndex);
  }

  Future<void> togglePlay() async {
    if (_player.playing) {
      await _player.pause();
    } else {
      await _player.play();
    }
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) =>
        n.toString().padLeft(2, '0');

    final minutes = duration.inMinutes;
    final seconds =
        duration.inSeconds.remainder(60);

    return '$minutes:${twoDigits(seconds)}';
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentSong = songs[currentSongIndex];

    return Scaffold(
      backgroundColor: const Color(0xFF0B0B0F),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            children: [
              // Top Bar
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 32,
                    ),
                  ),

                  const Expanded(
                    child: Text(
                      'Now Playing',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(width: 48),
                ],
              ),

              const Spacer(),

              // Album Cover
              AspectRatio(
                aspectRatio: 1,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(28),
                    gradient:
                        const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF7C3AED),
                        Color(0xFF2563EB),
                      ],
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black45,
                        blurRadius: 25,
                        offset: Offset(0, 12),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.music_note_rounded,
                      size: 120,
                      color: Colors.white70,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 45),

              // Song Details
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          currentSong['title']!,
                          maxLines: 1,
                          overflow:
                              TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 8),

                        Text(
                          currentSong['artist']!,
                          style: const TextStyle(
                            fontSize: 17,
                            color: Colors.white54,
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
                          : Icons.favorite_border,
                      size: 34,
                      color: isFavorite
                          ? Colors.redAccent
                          : Colors.white,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Progress Bar
              StreamBuilder<Duration?>(
                stream: _player.durationStream,
                builder:
                    (context, durationSnapshot) {
                  final duration =
                      durationSnapshot.data ??
                          Duration.zero;

                  return StreamBuilder<Duration>(
                    stream:
                        _player.positionStream,
                    builder:
                        (context,
                            positionSnapshot) {
                      var position =
                          positionSnapshot.data ??
                              Duration.zero;

                      if (position >
                          duration) {
                        position = duration;
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
                              _player.seek(
                                Duration(
                                  milliseconds:
                                      value.round(),
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

              const SizedBox(height: 25),

              // Controls
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceEvenly,
                children: [
                  // Shuffle
                  IconButton(
                    onPressed: () {
                      setState(() {
                        isShuffle = !isShuffle;
                      });
                    },
                    icon: Icon(
                      Icons.shuffle_rounded,
                      size: 30,
                      color: isShuffle
                          ? Colors.deepPurpleAccent
                          : Colors.white,
                    ),
                  ),

                  // Previous
                  IconButton(
                    onPressed: previousSong,
                    icon: const Icon(
                      Icons.skip_previous_rounded,
                      size: 42,
                    ),
                  ),

                  // Play Pause
                  StreamBuilder<bool>(
                    stream:
                        _player.playingStream,
                    builder:
                        (context, snapshot) {
                      final isPlaying =
                          snapshot.data ?? false;

                      return GestureDetector(
                        onTap: togglePlay,
                        child: Container(
                          width: 88,
                          height: 88,
                          decoration:
                              const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: Icon(
                            isPlaying
                                ? Icons.pause_rounded
                                : Icons
                                    .play_arrow_rounded,
                            size: 55,
                            color: Colors.black,
                          ),
                        ),
                      );
                    },
                  ),

                  // Next
                  IconButton(
                    onPressed: nextSong,
                    icon: const Icon(
                      Icons.skip_next_rounded,
                      size: 42,
                    ),
                  ),

                  // Repeat
                  IconButton(
                    onPressed: () {
                      setState(() {
                        isRepeat = !isRepeat;
                      });
                    },
                    icon: Icon(
                      Icons.repeat_rounded,
                      size: 30,
                      color: isRepeat
                          ? Colors.deepPurpleAccent
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
