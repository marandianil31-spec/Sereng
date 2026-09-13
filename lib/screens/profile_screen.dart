import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'settings_screen.dart';
import 'edit_profile_screen.dart';
import 'liked_songs_screen.dart';
import 'notifications_screen.dart';
import 'downloads_screen.dart';
import 'help_support_screen.dart';
import 'login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
  }

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
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),

        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const SettingsScreen(),
                ),
              );
            },
            icon: const Icon(
              Icons.settings_outlined,
            ),
          ),
        ],
      ),

      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          16,
          10,
          16,
          30,
        ),

        children: [
          const SizedBox(height: 10),

          // PROFILE HEADER
          Center(
            child: Column(
              children: [
                Container(
                  width: 92,
                  height: 92,

                  decoration: BoxDecoration(
                    shape: BoxShape.circle,

                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF7C3AED),
                        Color(0xFFEC4899),
                      ],
                    ),

                    border: Border.all(
                      color: Colors.white24,
                      width: 2,
                    ),
                  ),

                  child: const Icon(
                    Icons.person,
                    size: 50,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 14),

                const Text(
                  'Sereng User',

                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 5),

                const Text(
                  'Music lover',

                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 14),

                OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            const EditProfileScreen(),
                      ),
                    );
                  },

                  child: const Text(
                    'Edit Profile',
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          // STATISTICS
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 18,
            ),

            decoration: BoxDecoration(
              color: const Color(0xFF141419),
              borderRadius: BorderRadius.circular(18),
            ),

            child: const Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceAround,

              children: [
                ProfileStat(
                  value: '24',
                  label: 'Liked',
                ),

                ProfileStat(
                  value: '5',
                  label: 'Playlists',
                ),

                ProfileStat(
                  value: '18',
                  label: 'Played',
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          const Text(
            'Account',

            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          // EDIT PROFILE
          ProfileMenuTile(
            icon: Icons.person_outline,
            title: 'Edit Profile',
            subtitle: 'Change your name and profile',

            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      const EditProfileScreen(),
                ),
              );
            },
          ),

          // LIKED SONGS
          ProfileMenuTile(
            icon: Icons.favorite_border,
            title: 'Liked Songs',
            subtitle: 'Your favorite music',

            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      const LikedSongsScreen(),
                ),
              );
            },
          ),

          // NOTIFICATIONS
          ProfileMenuTile(
            icon: Icons.notifications_none,
            title: 'Notifications',
            subtitle: 'Manage notifications',

            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      const NotificationsScreen(),
                ),
              );
            },
          ),

          // DOWNLOADS
          ProfileMenuTile(
            icon: Icons.download_outlined,
            title: 'Downloads',
            subtitle: 'Manage downloaded songs',

            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      const DownloadsScreen(),
                ),
              );
            },
          ),

          const SizedBox(height: 25),

          const Text(
            'Settings',

            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          // LANGUAGE
          ProfileMenuTile(
            icon: Icons.language,
            title: 'Language',
            subtitle: 'English',

            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      const SettingsScreen(),
                ),
              );
            },
          ),

          // APPEARANCE
          ProfileMenuTile(
            icon: Icons.dark_mode_outlined,
            title: 'Appearance',
            subtitle: 'Dark mode',

            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      const SettingsScreen(),
                ),
              );
            },
          ),

          // HELP SUPPORT
          ProfileMenuTile(
            icon: Icons.help_outline,
            title: 'Help & Support',
            subtitle: 'Get help with Sereng',

            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      const HelpSupportScreen(),
                ),
              );
            },
          ),

          // ABOUT
          ProfileMenuTile(
            icon: Icons.info_outline,
            title: 'About Sereng',
            subtitle: 'App information',

            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      const SettingsScreen(),
                ),
              );
            },
          ),

          const SizedBox(height: 25),

          // LOGOUT
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF141419),
              borderRadius: BorderRadius.circular(14),
            ),

            child: ListTile(
              leading: const Icon(
                Icons.logout,
                color: Colors.redAccent,
              ),

              title: const Text(
                'Log Out',

                style: TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),

              onTap: () async {
                await _logout(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}


// PROFILE STAT

class ProfileStat extends StatelessWidget {
  final String value;
  final String label;

  const ProfileStat({
    super.key,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,

          style: const TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 4),

        Text(
          label,

          style: const TextStyle(
            color: Colors.white54,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}


// PROFILE MENU TILE

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
      margin: const EdgeInsets.only(
        bottom: 9,
      ),

      decoration: BoxDecoration(
        color: const Color(0xFF141419),
        borderRadius: BorderRadius.circular(14),
      ),

      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 3,
        ),

        leading: Container(
          width: 42,
          height: 42,

          decoration: BoxDecoration(
            color: const Color(0xFF27272A),
            borderRadius:
                BorderRadius.circular(11),
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
            fontSize: 11,
          ),
        ),

        trailing: const Icon(
          Icons.chevron_right,
          color: Colors.white38,
        ),

        onTap: onTap,
      ),
    );
  }
}
