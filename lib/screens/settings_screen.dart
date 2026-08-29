import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool notifications = true;
  bool autoplay = true;
  bool wifiOnlyDownload = true;

  String selectedLanguage = 'English';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0B0F),

      appBar: AppBar(
        backgroundColor: const Color(0xFF0B0B0F),
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text(
          'Settings',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 30),
        children: [
          const Text(
            'Preferences',
            style: TextStyle(
              color: Colors.white54,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          _settingTile(
            icon: Icons.notifications_none,
            title: 'Notifications',
            subtitle: 'New releases and updates',
            trailing: Switch(
              value: notifications,
              onChanged: (value) {
                setState(() {
                  notifications = value;
                });
              },
            ),
          ),

          _settingTile(
            icon: Icons.play_circle_outline,
            title: 'Autoplay',
            subtitle: 'Automatically play the next song',
            trailing: Switch(
              value: autoplay,
              onChanged: (value) {
                setState(() {
                  autoplay = value;
                });
              },
            ),
          ),

          _settingTile(
            icon: Icons.wifi,
            title: 'Download over Wi-Fi only',
            subtitle: 'Save mobile data',
            trailing: Switch(
              value: wifiOnlyDownload,
              onChanged: (value) {
                setState(() {
                  wifiOnlyDownload = value;
                });
              },
            ),
          ),

          const SizedBox(height: 25),

          const Text(
            'Language',
            style: TextStyle(
              color: Colors.white54,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          _settingTile(
            icon: Icons.language,
            title: 'App Language',
            subtitle: selectedLanguage,
            trailing: const Icon(
              Icons.chevron_right,
              color: Colors.white38,
            ),
            onTap: _showLanguageDialog,
          ),

          const SizedBox(height: 25),

          const Text(
            'Account & Privacy',
            style: TextStyle(
              color: Colors.white54,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          _settingTile(
            icon: Icons.person_outline,
            title: 'Account',
            subtitle: 'Manage your SERENG account',
            trailing: const Icon(
              Icons.chevron_right,
              color: Colors.white38,
            ),
            onTap: () {},
          ),

          _settingTile(
            icon: Icons.lock_outline,
            title: 'Privacy',
            subtitle: 'Privacy and security settings',
            trailing: const Icon(
              Icons.chevron_right,
              color: Colors.white38,
            ),
            onTap: () {},
          ),

          const SizedBox(height: 25),

          const Text(
            'About',
            style: TextStyle(
              color: Colors.white54,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          _settingTile(
            icon: Icons.description_outlined,
            title: 'Terms & Conditions',
            subtitle: 'Read SERENG terms',
            trailing: const Icon(
              Icons.chevron_right,
              color: Colors.white38,
            ),
            onTap: () {},
          ),

          _settingTile(
            icon: Icons.policy_outlined,
            title: 'Privacy Policy',
            subtitle: 'Read our privacy policy',
            trailing: const Icon(
              Icons.chevron_right,
              color: Colors.white38,
            ),
            onTap: () {},
          ),

          _settingTile(
            icon: Icons.info_outline,
            title: 'About SERENG',
            subtitle: 'Version 1.0.0',
            trailing: const Icon(
              Icons.chevron_right,
              color: Colors.white38,
            ),
            onTap: () {},
          ),

          const SizedBox(height: 25),

          // Logout
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF141419),
              borderRadius: BorderRadius.circular(15),
            ),
            child: ListTile(
              onTap: _showLogoutDialog,
              leading: const Icon(
                Icons.logout,
                color: Colors.redAccent,
              ),
              title: const Text(
                'Logout',
                style: TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: const Text(
                'Sign out from this device',
                style: TextStyle(
                  color: Colors.white38,
                  fontSize: 12,
                ),
              ),
            ),
          ),

          const SizedBox(height: 30),

          const Center(
            child: Text(
              'SERENG',
              style: TextStyle(
                color: Colors.white24,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
          ),

          const SizedBox(height: 5),

          const Center(
            child: Text(
              'Made for music lovers',
              style: TextStyle(
                color: Colors.white24,
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _settingTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Widget trailing,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF141419),
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 3,
        ),
        leading: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: const Color(0xFF202027),
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
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 3),
          child: Text(
            subtitle,
            style: const TextStyle(
              color: Colors.white38,
              fontSize: 11,
            ),
          ),
        ),
        trailing: trailing,
      ),
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF18181F),
          title: const Text('Select Language'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _languageOption('English'),
              _languageOption('Hindi'),
              _languageOption('Ol Chiki'),
              _languageOption('Roman Santhali'),
            ],
          ),
        );
      },
    );
  }

  Widget _languageOption(String language) {
    return ListTile(
      title: Text(language),
      trailing: selectedLanguage == language
          ? const Icon(
              Icons.check,
              color: Colors.white,
            )
          : null,
      onTap: () {
        setState(() {
          selectedLanguage = language;
        });

        Navigator.pop(context);
      },
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF18181F),
          title: const Text('Logout?'),
          content: const Text(
            'Are you sure you want to logout?',
            style: TextStyle(
              color: Colors.white60,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);

                ScaffoldMessenger.of(this.context).showSnackBar(
                  const SnackBar(
                    content: Text('Logout will be connected later.'),
                  ),
                );
              },
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }
}
