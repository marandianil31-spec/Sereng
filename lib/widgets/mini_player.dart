import 'package:flutter/material.dart';
import '../services/music_player_service.dart';
import '../screens/full_player_screen.dart';

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    final music = MusicPlayerService.instance;

    return AnimatedBuilder(
      animation: music,
      builder: (context, child) {
        final song = music.currentSong;

        if (song == null) {
          return const SizedBox.shrink();
        }

        final duration = music.duration.inMilliseconds;
        final position = music.position.inMilliseconds;

        return Container(
          margin: const EdgeInsets.fromLTRB(10, 4, 10, 6),
          decoration: BoxDecoration(
            color: const Color(0xFF242432),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const FullPlayerScreen(),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFF673AB7),
                              Color(0xFF00BCD4),
                            ],
                          ),
                        ),
                        child: const Icon(
                          Icons.music_note_rounded,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              song['title']?.toString() ??
                                  'Unknown Song',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              song['artist']?.toString() ??
                                  'Unknown Artist',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white60,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        tooltip: 'Play or pause',
                        onPressed: music.togglePlayPause,
                        icon: Icon(
                          music.isPlaying
                              ? Icons.pause_rounded
                              : Icons.play_arrow_rounded,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      IconButton(
                        tooltip: 'Next song',
                        onPressed: music.playNext,
                        icon: const Icon(
                          Icons.skip_next_rounded,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (duration > 0)
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(14),
                  ),
                  child: LinearProgressIndicator(
                    value: (position / duration).clamp(0.0, 1.0),
                    minHeight: 2,
                    backgroundColor: Colors.white12,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Color(0xFF00E5FF),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
