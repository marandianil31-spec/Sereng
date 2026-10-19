import 'package:flutter/material.dart';
import '../services/music_player_service.dart';

class FullPlayerScreen extends StatelessWidget {
  const FullPlayerScreen({super.key});

  String _formatTime(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds.remainder(60);
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final music = MusicPlayerService.instance;

    return AnimatedBuilder(
      animation: music,
      builder: (context, child) {
        final song = music.currentSong;

        if (song == null) {
          return Scaffold(
            backgroundColor: const Color(0xFF101018),
            appBar: AppBar(
              backgroundColor: const Color(0xFF101018),
              foregroundColor: Colors.white,
              title: const Text('Music Player'),
            ),
            body: const Center(
              child: Text(
                'Select a song to play',
                style: TextStyle(color: Colors.white70),
              ),
            ),
          );
        }

        return Scaffold(
          backgroundColor: const Color(0xFF101018),
          appBar: AppBar(
            backgroundColor: const Color(0xFF101018),
            foregroundColor: Colors.white,
            elevation: 0,
            title: const Text(
              'NOW PLAYING',
              style: TextStyle(
                fontSize: 14,
                letterSpacing: 2,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const Spacer(),

                  Container(
                    width: 270,
                    height: 270,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32),
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF673AB7),
                          Color(0xFF00BCD4),
                          Color(0xFFEC407A),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF00BCD4)
                              .withValues(alpha: 0.20),
                          blurRadius: 35,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.music_note_rounded,
                      size: 150,
                      color: Colors.white,
                    ),
                  ),

                  const Spacer(),

                  Text(
                    song['title']?.toString() ?? 'Unknown Song',
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    song['artist']?.toString() ?? 'Unknown Artist',
                    style: const TextStyle(
                      color: Colors.white60,
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 24),

                  Slider(
                    value: music.duration.inMilliseconds > 0
                        ? music.position.inMilliseconds
                            .clamp(0, music.duration.inMilliseconds)
                            .toDouble()
                        : 0,
                    max: music.duration.inMilliseconds > 0
                        ? music.duration.inMilliseconds.toDouble()
                        : 1,
                    activeColor: const Color(0xFF00E5FF),
                    inactiveColor: Colors.white24,
                    onChanged: music.duration.inMilliseconds > 0
                        ? (value) {
                            music.seek(
                              Duration(
                                milliseconds: value.toInt(),
                              ),
                            );
                          }
                        : null,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _formatTime(music.position),
                        style: const TextStyle(
                          color: Colors.white60,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        _formatTime(music.duration),
                        style: const TextStyle(
                          color: Colors.white60,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        onPressed: music.toggleShuffle,
                        icon: Icon(
                          Icons.shuffle,
                          color: music.shuffleEnabled
                              ? const Color(0xFF00E5FF)
                              : Colors.white60,
                        ),
                      ),

                      IconButton(
                        onPressed: music.playPrevious,
                        icon: const Icon(
                          Icons.skip_previous_rounded,
                          size: 42,
                          color: Colors.white,
                        ),
                      ),

                      Container(
                        decoration: const BoxDecoration(
                          color: Color(0xFF00E5FF),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          onPressed: music.togglePlayPause,
                          icon: Icon(
                            music.isPlaying
                                ? Icons.pause_rounded
                                : Icons.play_arrow_rounded,
                            color: Colors.black,
                            size: 38,
                          ),
                        ),
                      ),

                      IconButton(
                        onPressed: music.playNext,
                        icon: const Icon(
                          Icons.skip_next_rounded,
                          size: 42,
                          color: Colors.white,
                        ),
                      ),

                      IconButton(
                        onPressed: music.toggleRepeat,
                        icon: Icon(
                          Icons.repeat,
                          color: music.repeatEnabled
                              ? const Color(0xFF00E5FF)
                              : Colors.white60,
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
      },
    );
  }
}
