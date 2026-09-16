import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0B0F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B0B0F),
        elevation: 0,
        title: const Text(
          'About SERENG',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 25, 20, 35),
        children: [
          Center(
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: const Color(0xFF292231),
                borderRadius: BorderRadius.circular(25),
              ),
              child: const Icon(
                Icons.music_note_rounded,
                size: 55,
                color: Colors.white,
              ),
            ),
          ),

          const SizedBox(height: 20),

          const Center(
            child: Text(
              'SERENG',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 6),

          const Center(
            child: Text(
              'Music for everyone',
              style: TextStyle(
                color: Colors.white54,
                fontSize: 14,
              ),
            ),
          ),

          const SizedBox(height: 30),

          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF141419),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'About SERENG',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'SERENG is a music streaming platform designed '
                  'to help listeners discover songs and support '
                  'artists.',
                  style: TextStyle(
                    color: Colors.white60,
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          _infoTile(
            icon: Icons.music_note_rounded,
            title: 'Music',
            subtitle: 'Discover and enjoy your favorite songs.',
          ),

          _infoTile(
            icon: Icons.person_rounded,
            title: 'Artists',
            subtitle: 'Discover and support talented artists.',
          ),

          _infoTile(
            icon: Icons.favorite_rounded,
            title: 'Your Library',
            subtitle: 'Keep your favorite music in one place.',
          ),

          const SizedBox(height: 25),

          const Center(
            child: Text(
              'Version 1.0.0',
              style: TextStyle(
                color: Colors.white38,
                fontSize: 12,
              ),
            ),
          ),

          const SizedBox(height: 8),

          const Center(
            child: Text(
              '© SERENG',
              style: TextStyle(
                color: Colors.white30,
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _infoTile({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF141419),
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 5,
        ),
        leading: Container(
          width: 45,
          height: 45,
          decoration: BoxDecoration(
            color: const Color(0xFF292231),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: Colors.white70,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            color: Colors.white54,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
