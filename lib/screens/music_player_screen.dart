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
  State<MusicPlayerScreen> createState() => _MusicPlayerScreenState();
}

class _MusicPlayerScreenState extends State<MusicPlayerScreen> {
  final AudioPlayer _player = AudioPlayer();

  bool isFavorite = false;
  bool isShuffle = false;
  bool isRepeat = false;

  final String songUrl =
      'https://firebasestorage.googleapis.com/v0/b/sereng-31dfd.firebasestorage.app/o/Nawa%20Nawam%20Juwan%20Akana%20Santali%20New%20Video%20%20Full%20Video%20%20Birsa%20Hansdah%20Rupali%20Tudu%20Bunty%20Studio.mp3?alt=media&token=302b6433-0aaa-4ef0-b047-5d0c7973b0ff';

  @override
  void initState() {
    super.initState();
    _loadSong();
  }

  Future<void> _loadSong() async {
    try {
      await _player.setUrl(songUrl);
    } catch (e) {
      debugPrint('Song load error: $e');
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');

    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds.remainder(60);

    return '$minutes:${twoDigits(seconds)}';
  }

  void previousSong() {
    _player.seek(Duration.zero);
  }

  void nextSong() {
    _player.seek(Duration.zero);
  }

  Future<void> togglePlay() async {
    if (_player.playing) {
      await _player.pause();
    } else {
      await _player.play();
    }
  }

  @override
  Widget build(BuildContext context) {
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
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 32,
                      color: Colors.white,
                    ),
                  ),
                  const Expanded(
                    child: Text(
                      'Now Playing',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
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
                    borderRadius: BorderRadius.circular(28),
                    gradient: const LinearGradient(
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

              const SizedBox(height: 55),

              // Song Details
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.songTitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.artistName,
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white54,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        isFavorite = !isFavorite;
                      });
                    },
                    icon: Icon(
                      isFavorite
                          ? Icons.favorite
                          : Icons.favorite_border,
                      size: 36,
                      color: isFavorite
                          ? Colors.redAccent
                          : Colors.white,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              // Progress Bar + Time
              StreamBuilder<Duration?>(
                stream: _player.durationStream,
                builder: (context, durationSnapshot) {
                  final duration =
                      durationSnapshot.data ?? Duration.zero;

                  return StreamBuilder<Duration>(
                    stream: _player.positionStream,
                    builder: (context, positionSnapshot) {
                      var position =
                          positionSnapshot.data ?? Duration.zero;

                      if (position > duration) {
                        position = duration;
                      }

                      return Column(
                        children: [
                          Slider(
                            value: position.inMilliseconds
                                .toDouble(),
                            min: 0,
                            max: duration.inMilliseconds > 0
                                ? duration.inMilliseconds
                                    .toDouble()
                                : 1,
                            activeColor: Colors.white,
                            inactiveColor: Colors.white24,
                            onChanged: (value) {
                              _player.seek(
                                Duration(
                                  milliseconds: value.round(),
                                ),
                              );
                            },
                          ),

                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                            ),
                            child: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  formatDuration(position),
                                  style: const TextStyle(
                                    color: Colors.white54,
                                    fontSize: 15,
                                  ),
                                ),
                                Text(
                                  formatDuration(duration),
                                  style: const TextStyle(
                                    color: Colors.white54,
                                    fontSize: 15,
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

              const SizedBox(height: 28),

              // Music Controls
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
                          ? Colors.blueAccent
                          : Colors.white,
                    ),
                  ),

                  // Previous
                  IconButton(
                    onPressed: previousSong,
                    icon: const Icon(
                      Icons.skip_previous_rounded,
                      size: 42,
                      color: Colors.white,
                    ),
                  ),

                  // Play / Pause
                  StreamBuilder<bool>(
                    stream: _player.playingStream,
                    builder: (context, snapshot) {
                      final isPlaying =
                          snapshot.data ?? false;

                      return GestureDetector(
                        onTap: togglePlay,
                        child: Container(
                          width: 88,
                          height: 88,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: Icon(
                            isPlaying
                                ? Icons.pause_rounded
                                : Icons.play_arrow_rounded,
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
                      color: Colors.white,
                    ),
                  ),

                  // Repeat
                  IconButton(
                    onPressed: () async {
                      setState(() {
                        isRepeat = !isRepeat;
                      });

                      await _player.setLoopMode(
                        isRepeat
                            ? LoopMode.one
                            : LoopMode.off,
                      );
                    },
                    icon: Icon(
                      Icons.repeat_rounded,
                      size: 30,
                      color: isRepeat
                          ? Colors.blueAccent
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
