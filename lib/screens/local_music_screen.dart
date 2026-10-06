import 'package:flutter/material.dart';
import 'package:on_audio_query_pluse/on_audio_query.dart';
import 'package:just_audio/just_audio.dart';

class LocalMusicScreen extends StatefulWidget {
  const LocalMusicScreen({super.key});

  @override
  State<LocalMusicScreen> createState() => _LocalMusicScreenState();
}

class _LocalMusicScreenState extends State<LocalMusicScreen> {
  final OnAudioQuery _audioQuery = OnAudioQuery();
  final AudioPlayer _player = AudioPlayer();

  List<SongModel> songs = [];
  bool loading = true;
  int? playingId;

  @override
  void initState() {
    super.initState();
    loadSongs();
  }

  Future<void> loadSongs() async {
    setState(() {
      loading = true;
    });

    final permission =
        await _audioQuery.permissionsRequest();

    if (!permission) {
      setState(() {
        loading = false;
      });
      return;
    }

    final result = await _audioQuery.querySongs(
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
  }

  Future<void> playSong(SongModel song) async {
    final uri = song.uri;

    if (uri == null || uri.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('This song cannot be played.'),
        ),
      );
      return;
    }

    try {
      await _player.setAudioSource(
        AudioSource.uri(Uri.parse(uri)),
      );

      await _player.play();

      if (!mounted) return;

      setState(() {
        playingId = song.id;
      });
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unable to play this song.'),
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
          : songs.isEmpty
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(30),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.music_off_rounded,
                          size: 70,
                          color: Colors.white30,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'No local songs found',
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Add music to your phone and refresh.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white54,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: songs.length,
                  itemBuilder: (context, index) {
                    final song = songs[index];

                    final isPlaying =
                        playingId == song.id;

                    final artist =
                        song.artist?.isNotEmpty == true
                            ? song.artist!
                            : 'Unknown Artist';

                    return Container(
                      margin:
                          const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF141419),
                        borderRadius:
                            BorderRadius.circular(15),
                      ),
                      child: ListTile(
                        contentPadding:
                            const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        leading: Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            color:
                                const Color(0xFF292231),
                            borderRadius:
                                BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.music_note_rounded,
                            color: Colors.white70,
                          ),
                        ),
                        title: Text(
                          song.title,
                          maxLines: 1,
                          overflow:
                              TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
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
                            if (isPlaying) {
                              stopSong();
                            } else {
                              playSong(song);
                            }
                          },
                          icon: Icon(
                            isPlaying
                                ? Icons.pause_circle_filled
                                : Icons.play_circle_fill,
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
