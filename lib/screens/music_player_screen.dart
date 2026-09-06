import 'package:flutter/material.dart';

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
  bool isPlaying = false;
  bool isFavorite = false;
  double currentProgress = 0.5;

  final Duration totalDuration = const Duration(
    minutes: 6,
    seconds: 12,
  );

  Duration get currentDuration {
    return Duration(
      seconds: (totalDuration.inSeconds * currentProgress).round(),
    );
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');

    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds.remainder(60);

    return '$minutes:${twoDigits(seconds)}';
  }

  void previousSong() {
    // Future: Previous song logic
    setState(() {
      currentProgress = 0;
    });
  }

  void nextSong() {
    // Future: Next song logic
    setState(() {
      currentProgress = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final maxDuration =
        totalDuration.inSeconds > 0 ? totalDuration.inSeconds : 1;

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
                        fontSize: 28,
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
                      color:
                          isFavorite ? Colors.redAccent : Colors.white,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              // Progress Slider
              Slider(
                value: currentProgress * maxDuration,
                min: 0,
                max: maxDuration.toDouble(),
                activeColor: Colors.white,
                inactiveColor: Colors.white24,
                onChanged: (value) {
                  setState(() {
                    currentProgress = value / maxDuration;
                  });
                },
              ),

              // Time
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      formatDuration(currentDuration),
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      formatDuration(totalDuration),
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // Music Controls
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceEvenly,
                children: [
                  // Shuffle
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.shuffle_rounded,
                      size: 30,
                    ),
                  ),

                  // Previous Song
                  IconButton(
                    onPressed: previousSong,
                    icon: const Icon(
                      Icons.skip_previous_rounded,
                      size: 42,
                    ),
                  ),

                  // Play / Pause
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isPlaying = !isPlaying;
                      });
                    },
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
                  ),

                  // Next Song
                  IconButton(
                    onPressed: nextSong,
                    icon: const Icon(
                      Icons.skip_next_rounded,
                      size: 42,
                    ),
                  ),

                  // Repeat
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.repeat_rounded,
                      size: 30,
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
