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

  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  @override
  void initState() {
    super.initState();

    _player.durationStream.listen((newDuration) {
      if (newDuration != null) {
        setState(() {
          duration = newDuration;
        });
      }
    });

    _player.positionStream.listen((newPosition) {
      setState(() {
        position = newPosition;
      });
    });

    _player.playerStateStream.listen((state) {
      setState(() {
        isPlaying = state.playing;
      });
    });
  }

  Future<void> _togglePlay() async {
    if (isPlaying) {
      await _player.pause();
    } else {
      // Temporary demo audio URL
      await _player.setUrl(
        'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
      );

      await _player.play();
    }
  }

  Future<void> _seekBackward() async {
    final newPosition = position - const Duration(seconds: 10);

    await _player.seek(
      newPosition < Duration.zero ? Duration.zero : newPosition,
    );
  }

  Future<void> _seekForward() async {
    final newPosition = position + const Duration(seconds: 10);

    await _player.seek(
      newPosition > duration ? duration : newPosition,
    );
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');

    final minutes = duration.inMinutes;
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return '$minutes:$seconds';
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final maxDuration =
        duration.inMilliseconds.toDouble() > 0
            ? duration.inMilliseconds.toDouble()
            : 1.0;

    final currentPosition =
        position.inMilliseconds.toDouble()
            .clamp(0.0, maxDuration);

    return Scaffold(
      backgroundColor: const Color(0xFF0B0B0F),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            children: [
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

              Container(
                width: double.infinity,
                aspectRatio: 1,
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
                ),
                child: const Icon(
                  Icons.music_note_rounded,
                  size: 120,
                  color: Colors.white70,
                ),
              ),

              const SizedBox(height: 45),

              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.songTitle,
                          style: const TextStyle(
                            fontSize: 27,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.artistName,
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 17,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.favorite_border_rounded,
                      size: 32,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              Slider(
                value: currentPosition,
                min: 0,
                max: maxDuration,
                onChanged: (value) {
                  _player.seek(
                    Duration(
                      milliseconds: value.toInt(),
                    ),
                  );
                },
              ),

              Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    formatDuration(position),
                    style: const TextStyle(
                      color: Colors.white54,
                    ),
                  ),
                  Text(
                    formatDuration(duration),
                    style: const TextStyle(
                      color: Colors.white54,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.shuffle_rounded,
                      size: 28,
                    ),
                  ),

                  IconButton(
                    onPressed: _seekBackward,
                    icon: const Icon(
                      Icons.replay_10_rounded,
                      size: 36,
                    ),
                  ),

                  Container(
                    width: 82,
                    height: 82,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: IconButton(
                      onPressed: _togglePlay,
                      icon: Icon(
                        isPlaying
                            ? Icons.pause_rounded
                            : Icons.play_arrow_rounded,
                        size: 48,
                        color: Colors.black,
                      ),
                    ),
                  ),

                  IconButton(
                    onPressed: _seekForward,
                    icon: const Icon(
                      Icons.forward_10_rounded,
                      size: 36,
                    ),
                  ),

                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.repeat_rounded,
                      size: 28,
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
