import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notifications = [
      NotificationItem(
        icon: Icons.music_note_rounded,
        title: 'New song available',
        subtitle: 'Dular Re by Rahul Murmu is now available.',
        time: '10 min ago',
        isUnread: true,
      ),
      NotificationItem(
        icon: Icons.person_rounded,
        title: 'Artist update',
        subtitle: 'Pankaj Murmu uploaded a new song.',
        time: '1 hour ago',
        isUnread: true,
      ),
      NotificationItem(
        icon: Icons.playlist_play_rounded,
        title: 'Playlist updated',
        subtitle: 'Santhali Hits has been updated with new songs.',
        time: '3 hours ago',
        isUnread: false,
      ),
      NotificationItem(
        icon: Icons.workspace_premium_rounded,
        title: 'SERENG Premium',
        subtitle: 'Enjoy ad-free music and premium features.',
        time: 'Yesterday',
        isUnread: false,
      ),
      NotificationItem(
        icon: Icons.favorite_rounded,
        title: 'Your music matters',
        subtitle: 'Keep discovering and supporting your favorite artists.',
        time: 'Yesterday',
        isUnread: false,
      ),
    ];

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
          'Notifications',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text(
              'Read all',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),

      body: notifications.isEmpty
          ? const EmptyNotifications()
          : ListView(
              padding: const EdgeInsets.fromLTRB(
                16,
                10,
                16,
                30,
              ),
              children: [
                const Text(
                  'Recent',
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 14),

                ...notifications.map(
                  (notification) => NotificationTile(
                    notification: notification,
                  ),
                ),
              ],
            ),
    );
  }
}

class NotificationItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final String time;
  final bool isUnread;

  const NotificationItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.isUnread,
  });
}

class NotificationTile extends StatelessWidget {
  final NotificationItem notification;

  const NotificationTile({
    super.key,
    required this.notification,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: notification.isUnread
            ? const Color(0xFF18181F)
            : const Color(0xFF141419),
        borderRadius: BorderRadius.circular(16),
        border: notification.isUnread
            ? Border.all(
                color: Colors.white12,
              )
            : null,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF7C3AED),
                  Color(0xFFEC4899),
                ],
              ),
            ),
            child: Icon(
              notification.icon,
              color: Colors.white,
              size: 24,
            ),
          ),

          const SizedBox(width: 13),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        notification.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),

                    if (notification.isUnread)
                      Container(
                        width: 7,
                        height: 7,
                        margin: const EdgeInsets.only(
                          top: 5,
                          left: 8,
                        ),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 5),

                Text(
                  notification.subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 12,
                    height: 1.35,
                  ),
                ),

                const SizedBox(height: 7),

                Text(
                  notification.time,
                  style: const TextStyle(
                    color: Colors.white30,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 5),

          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.more_vert,
              color: Colors.white38,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}

class EmptyNotifications extends StatelessWidget {
  const EmptyNotifications({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 85,
              height: 85,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF18181F),
              ),
              child: const Icon(
                Icons.notifications_none_rounded,
                size: 42,
                color: Colors.white38,
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'No notifications',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'You are all caught up.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white54,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
