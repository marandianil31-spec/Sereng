import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class MusicPlayerScreen extends StatefulWidget {
  final String songTitle;
  final String artistName;
  final String? audioUrl;

  const MusicPlayerScreen({
    super.key,
    this.songTitle = 'Sereng Song',
    this.artistName = 'Unknown Artist',
    this.audioUrl,
  });

  @override
  State<MusicPlayerScreen> createState() => _MusicPlayerScreenState();
}

class _MusicPlayerScreenState extends State<MusicPlayerScreen> {
  final AudioPlayer _player = AudioPlayer();

  bool isLiked = false;
  bool isLoading = false;

  // Temporary test MP3.
  // Later we will replace this with the SERENG CDN URL.
  static const String testAudioUrl =
      'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3';

  @override
  void initState() {
    super.initState();

    _player.playerStateStream.listen((state) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  String get audioUrl => widget.audioUrl ?? testAudioUrl;

  Future<void> _playPause() async {
    try {
      if (_player.playing) {
        await _player.pause();
        return;
      }

      setState(() {
        isLoading = true;
      });

      if (_player.processingState == ProcessingState.idle) {
        await _player.setUrl(audioUrl);
      }

      await _player.play();

      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Song play nahi ho saka: $e'),
          ),
        );
      }
    }
  }

  Future<void> _seekForward() async {
    final position = _player.position;
    final duration = _player.duration;

    if (duration == null) return;

    final newPosition = position + const Duration(seconds: 10);

    await _player.seek(
      newPosition < duration ? newPosition : duration,
    );
  }

  Future<void> _seekBackward() async {
    final position = _player.position;

    final newPosition = position - const Duration(seconds: 10);

    await _player.seek(
      newPosition > Duration.zero ? newPosition : Duration.zero,
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;

    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF101010),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_down),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Now Playing',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const Spacer(),

              // Album artwork
              Container(
                width: 280,
                height: 280,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF6A11CB),
                      Color(0xFF2575FC),
                    ],
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black54,
                      blurRadius: 25,
                      offset: Offset(0, 15),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.music_note_rounded,
                  size: 110,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 40),

              // Song information
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
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          widget.artistName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white60,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),

                  IconButton(
                    onPressed: () {
                      setState(() {
                        isLiked = !isLiked;
                      });
                    },
                    icon: Icon(
                      isLiked
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      color: isLiked ? Colors.redAccent : Colors.white,
                      size: 30,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Progress
              StreamBuilder<Duration>(
                stream: _player.positionStream,
                builder: (context, snapshot) {
                  final position = snapshot.data ?? Duration.zero;
                  final duration = _player.duration ?? Duration.zero;

                  double value = 0;

                  if (duration.inMilliseconds > 0) {
                    value =
                        position.inMilliseconds /
                        duration.inMilliseconds;

                    if (value > 1) {
                      value = 1;
                    }

                    if (value < 0) {
                      value = 0;
                    }
                  }

                  return Column(
                    children: [
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: Colors.white,
                          inactiveTrackColor: Colors.white24,
                          thumbColor: Colors.white,
                          overlayColor: Colors.white12,
                          trackHeight: 4,
                        ),
                        child: Slider(
                          value: value,
                          min: 0,
                          max: 1,
                          onChanged: duration.inMilliseconds == 0
                              ? null
                              : (newValue) {
                                  final newPosition = Duration(
                                    milliseconds:
                                        (duration.inMilliseconds *
                                                newValue)
                                            .round(),
                                  );

                                  _player.seek(newPosition);
                                },
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _formatDuration(position),
                              style: const TextStyle(
                                color: Colors.white54,
                              ),
                            ),
                            Text(
                              _formatDuration(duration),
                              style: const TextStyle(
                                color: Colors.white54,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 20),

              // Player controls
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.shuffle_rounded,
                      color: Colors.white70,
                    ),
                  ),

                  IconButton(
                    onPressed: _seekBackward,
                    icon: const Icon(
                      Icons.replay_10_rounded,
                      color: Colors.white,
                      size: 36,
                    ),
                  ),

                  Container(
                    width: 72,
                    height: 72,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: isLoading
                        ? const Padding(
                            padding: EdgeInsets.all(20),
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                              color: Colors.black,
                            ),
                          )
                        : IconButton(
                            onPressed: _playPause,
                            icon: Icon(
                              _player.playing
                                  ? Icons.pause_rounded
                                  : Icons.play_arrow_rounded,
                              color: Colors.black,
                              size: 40,
                            ),
                          ),
                  ),

                  IconButton(
                    onPressed: _seekForward,
                    icon: const Icon(
                      Icons.forward_10_rounded,
                      color: Colors.white,
                      size: 36,
                    ),
                  ),

                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.repeat_rounded,
                      color: Colors.white70,
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
