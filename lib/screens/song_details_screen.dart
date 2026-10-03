import 'package:flutter/material.dart';

import 'lyrics_screen.dart';
import 'music_player_screen.dart';
import 'album_detail_screen.dart';
import 'playlist_screen.dart';

class SongDetailsScreen extends StatefulWidget {
  final String songTitle;
  final String artistName;
  final String audioUrl;

  const SongDetailsScreen({
    super.key,
    this.songTitle = 'Johar Re',
    this.artistName = 'SERENG Artist',
    this.audioUrl = '',
  });

  @override
  State<SongDetailsScreen> createState() =>
      _SongDetailsScreenState();
}

class _SongDetailsScreenState
    extends State<SongDetailsScreen> {
  bool isLiked = false;

  void openPlayer() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MusicPlayerScreen(
          songTitle: widget.songTitle,
          artistName: widget.artistName,
          audioUrl: widget.audioUrl,
        ),
      ),
    );
  }

  void openLyrics() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => LyricsScreen(
          songTitle: widget.songTitle,
          artistName: widget.artistName,
        ),
      ),
    );
  }

  void openAlbum() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AlbumDetailScreen(
          albumName: 'Johar',
          artistName: widget.artistName,
        ),
      ),
    );
  }

  void openPlaylist() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const PlaylistScreen(
          playlistName: 'Santhali Hits',
        ),
      ),
    );
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0B0F),

      appBar: AppBar(
        backgroundColor: const Color(0xFF0B0B0F),
        elevation: 0,

        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_rounded,
          ),
        ),

        title: const Text(
          'Song Details',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),

        actions: [
          IconButton(
            onPressed: () {
              showMessage('More options');
            },
            icon: const Icon(
              Icons.more_vert_rounded,
            ),
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          20,
          15,
          20,
          35,
        ),
        child: Column(
          children: [
            // SONG COVER
            Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF7C3AED),
                    Color(0xFFEC4899),
                  ],
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black54,
                    blurRadius: 30,
                    offset: Offset(0, 15),
                  ),
                ],
              ),
              child: const Icon(
                Icons.music_note_rounded,
                size: 100,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 25),

            // TITLE
            Text(
              widget.songTitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 27,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 7),

            Text(
              widget.artistName,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 14,
              ),
            ),

            const SizedBox(height: 22),

            // ACTIONS
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.center,
              children: [
                IconButton(
                  tooltip: 'Like',
                  onPressed: () {
                    setState(() {
                      isLiked = !isLiked;
                    });

                    showMessage(
                      isLiked
                          ? 'Song liked'
                          : 'Song removed from liked songs',
                    );
                  },
                  icon: Icon(
                    isLiked
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    size: 28,
                    color: isLiked
                        ? Colors.white
                        : Colors.white70,
                  ),
                ),

                const SizedBox(width: 15),

                IconButton(
                  tooltip: 'Download',
                  onPressed: () {
                    showMessage(
                      'Download system will be connected later.',
                    );
                  },
                  icon: const Icon(
                    Icons.download_outlined,
                    size: 28,
                    color: Colors.white70,
                  ),
                ),

                const SizedBox(width: 15),

                IconButton(
                  tooltip: 'Playlist',
                  onPressed: openPlaylist,
                  icon: const Icon(
                    Icons.playlist_add_rounded,
                    size: 30,
                    color: Colors.white70,
                  ),
                ),

                const SizedBox(width: 15),

                IconButton(
                  tooltip: 'Share',
                  onPressed: () {
                    showMessage(
                      'Share system will be connected later.',
                    );
                  },
                  icon: const Icon(
                    Icons.share_rounded,
                    size: 27,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // PLAY SONG
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton.icon(
                onPressed: openPlayer,
                icon: const Icon(
                  Icons.play_arrow_rounded,
                  size: 27,
                ),
                label: const Text(
                  'Play Song',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 25),

            // ALBUM
            GestureDetector(
              onTap: openAlbum,
              child: _InfoCard(
                icon: Icons.album_rounded,
                title: 'Album',
                value: 'Johar',
                showArrow: true,
              ),
            ),

            _InfoCard(
              icon: Icons.category_rounded,
              title: 'Genre',
              value: 'Santhali',
            ),

            _InfoCard(
              icon: Icons.calendar_month_rounded,
              title: 'Release Date',
              value: '2026',
            ),

            _InfoCard(
              icon: Icons.access_time_rounded,
              title: 'Duration',
              value: '3:42',
            ),

            const SizedBox(height: 20),

            // ABOUT
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFF141419),
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    'About this song',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 9),
                  Text(
                    'Enjoy this Santhali track on SERENG. '
                    'You can listen, download, like, share '
                    'and add this song to your playlist.',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 13,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // LYRICS
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: openLyrics,
                icon: const Icon(
                  Icons.lyrics_rounded,
                ),
                label: const Text(
                  'View Lyrics',
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(
                    color: Colors.white24,
                  ),
                  padding:
                      const EdgeInsets.symmetric(
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(15),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final bool showArrow;

  const _InfoCard({
    required this.icon,
    required this.title,
    required this.value,
    this.showArrow = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 9),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF141419),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Container(
            width: 43,
            height: 43,
            decoration: BoxDecoration(
              color: const Color(0xFF24202D),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: Colors.white70,
              size: 21,
            ),
          ),

          const SizedBox(width: 13),

          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 13,
              ),
            ),
          ),

          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),

          if (showArrow) ...[
            const SizedBox(width: 8),
            const Icon(
              Icons.chevron_right_rounded,
              color: Colors.white38,
              size: 20,
            ),
          ],
        ],
      ),
    );
  }
}
