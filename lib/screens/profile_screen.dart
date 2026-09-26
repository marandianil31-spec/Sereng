import 'package:flutter/material.dart';

import 'settings_screen.dart';
import 'edit_profile_screen.dart';
import 'liked_songs_screen.dart';
import 'downloads_screen.dart';
import 'notifications_screen.dart';
import 'help_support_screen.dart';
import 'about_screen.dart';
import 'artist_upload_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0B0F),

      appBar: AppBar(
        backgroundColor: const Color(0xFF0B0B0F),
        elevation: 0,
        title: const Text(
          'Profile',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Settings',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const SettingsScreen(),
                ),
              );
            },
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),

      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 10, 18, 30),
        children: [
          const SizedBox(height: 10),

          // PROFILE HEADER
          Center(
            child: Column(
              children: [
                Container(
                  width: 90,
                  height: 90,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF292231),
                  ),
                  child: const Icon(
                    Icons.person_rounded,
                    size: 50,
                    color: Colors.white70,
                  ),
                ),

                const SizedBox(height: 14),

                const Text(
                  'SERENG User',
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 5),

                const Text(
                  'Music lover',
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 13,
                  ),
                ),

                const SizedBox(height: 18),

                SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const EditProfileScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.edit_outlined),
                    label: const Text('Edit Profile'),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 28),

          // YOUR MUSIC
          const Text(
            'Your Music',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          ProfileMenuTile(
            icon: Icons.favorite_rounded,
            title: 'Liked Songs',
            subtitle: 'Songs you have liked',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const LikedSongsScreen(),
                ),
              );
            },
          ),

          ProfileMenuTile(
            icon: Icons.download_rounded,
            title: 'Downloads',
            subtitle: 'Your downloaded music',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const DownloadsScreen(),
                ),
              );
            },
          ),

          ProfileMenuTile(
            icon: Icons.notifications_rounded,
            title: 'Notifications',
            subtitle: 'Latest updates from SERENG',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const NotificationsScreen(),
                ),
              );
            },
          ),

          // ARTIST STUDIO
          ProfileMenuTile(
            icon: Icons.music_note_rounded,
            title: 'Artist Studio',
            subtitle: 'Upload and manage your songs',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ArtistUploadScreen(),
                ),
              );
            },
          ),

          const SizedBox(height: 22),

          // SUPPORT
          const Text(
            'Support',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          ProfileMenuTile(
            icon: Icons.help_outline_rounded,
            title: 'Help & Support',
            subtitle: 'Get help with SERENG',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const HelpSupportScreen(),
                ),
              );
            },
          ),

          ProfileMenuTile(
            icon: Icons.info_outline_rounded,
            title: 'About SERENG',
            subtitle: 'Learn more about SERENG',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AboutScreen(),
                ),
              );
            },
          ),

          const SizedBox(height: 12),

          // LOGOUT
          ProfileMenuTile(
            icon: Icons.logout_rounded,
            title: 'Logout',
            subtitle: 'Sign out from this device',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Logout will be connected later',
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class ProfileMenuTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const ProfileMenuTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF141419),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 5,
        ),

        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: const Color(0xFF292231),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: Colors.white,
          ),
        ),

        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),

        subtitle: Text(
          subtitle,
          style: const TextStyle(
            color: Colors.white54,
            fontSize: 12,
          ),
        ),

        trailing: const Icon(
          Icons.chevron_right_rounded,
          color: Colors.white38,
        ),

        onTap: onTap,
      ),
    );
  }
}
