import 'package:flutter/material.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
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
        title: const Text(
          'Help & Support',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 30),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF141419),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.support_agent_rounded,
                  size: 42,
                  color: Colors.white,
                ),
                SizedBox(height: 14),
                Text(
                  'How can we help?',
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 7),
                Text(
                  'Find answers or contact SERENG support.',
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 22),

          const Text(
            'Support',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          _supportTile(
            context,
            icon: Icons.question_answer_rounded,
            title: 'Frequently Asked Questions',
            subtitle: 'Find answers to common questions',
            onTap: () {
              _showMessage(
                context,
                'FAQ section coming soon',
              );
            },
          ),

          _supportTile(
            context,
            icon: Icons.bug_report_rounded,
            title: 'Report a Problem',
            subtitle: 'Tell us about an issue',
            onTap: () {
              _showMessage(
                context,
                'Report feature coming soon',
              );
            },
          ),

          _supportTile(
            context,
            icon: Icons.email_rounded,
            title: 'Contact Support',
            subtitle: 'Get help from our support team',
            onTap: () {
              _showMessage(
                context,
                'Support contact coming soon',
              );
            },
          ),

          _supportTile(
            context,
            icon: Icons.feedback_rounded,
            title: 'Send Feedback',
            subtitle: 'Share your suggestions with us',
            onTap: () {
              _showMessage(
                context,
                'Feedback feature coming soon',
              );
            },
          ),

          const SizedBox(height: 22),

          const Text(
            'Popular Questions',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          _faqTile(
            context,
            'How do I change my profile?',
            'Open Profile and select Edit Profile.',
          ),

          _faqTile(
            context,
            'How do I create a playlist?',
            'Open a song and use the Add to Playlist option.',
          ),

          _faqTile(
            context,
            'How do I become a premium member?',
            'Open Premium from the app menu and choose a plan.',
          ),

          _faqTile(
            context,
            'Where can I find my downloaded songs?',
            'Open Library and select Downloads.',
          ),

          const SizedBox(height: 25),

          Center(
            child: Text(
              'SERENG Music • Help & Support',
              style: TextStyle(
                color: Colors.white38,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _supportTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
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
          width: 46,
          height: 46,
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
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            subtitle,
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 12,
            ),
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

  Widget _faqTile(
    BuildContext context,
    String question,
    String answer,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF141419),
        borderRadius: BorderRadius.circular(14),
      ),
      child: ExpansionTile(
        iconColor: Colors.white70,
        collapsedIconColor: Colors.white38,
        title: Text(
          question,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        childrenPadding: const EdgeInsets.fromLTRB(
          16,
          0,
          16,
          16,
        ),
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              answer,
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 13,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
