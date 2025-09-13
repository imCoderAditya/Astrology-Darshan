// ignore_for_file: unused_local_variable

import 'package:astrology/app/core/config/theme/app_colors.dart';
import 'package:astrology/app/core/config/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationView extends StatefulWidget {
  const NotificationView({super.key});

  @override
  State<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  // Example notification data
  final List<Map<String, dynamic>> _notifications =
      [
        {
          'id': '1',
          'type': 'promotion',
          'title': 'New Moon Special Offer!',
          'body': 'Get 20% off on all consultations this week.',
          'time': '2 hours ago',
          'read': false,
        },
        {
          'id': '2',
          'type': 'order',
          'title': 'Order #AST20250729 Confirmed',
          'body': 'Your order for "Cosmic Guide" has been processed.',
          'time': '4 hours ago',
          'read': false,
        },
        {
          'id': '3',
          'type': 'reminder',
          'title': 'Upcoming Consultation',
          'body': 'Your session with Astrologer Luna is in 30 minutes.',
          'time': 'Today, 10:00 AM',
          'read': true,
        },
        {
          'id': '4',
          'type': 'system',
          'title': 'App Update Available',
          'body': 'Version 2.1 is now available with new features.',
          'time': 'Yesterday, 5:00 PM',
          'read': true,
        },
        {
          'id': '5',
          'type': 'promotion',
          'title': 'Exclusive Horoscope for You!',
          'body': 'Check out your personalized daily horoscope.',
          'time': '2 days ago',
          'read': true,
        },
      ].obs; // Using .obs for reactive list

  void _markAsRead(String id) {
    final index = _notifications.indexWhere((notif) => notif['id'] == id);
    if (index != -1) {
      _notifications[index]['read'] = true;
    }
  }

  void _deleteNotification(String id) {
    _notifications.removeWhere((notif) => notif['id'] == id);

    Get.snackbar(
      "Deleted",
      "Notification removed",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.red.withOpacity(0.8),
      colorText: AppColors.white,
    );
  }

  IconData _getNotificationIcon(String type) {
    switch (type) {
      case 'promotion':
        return Icons.campaign;
      case 'order':
        return Icons.shopping_bag;
      case 'reminder':
        return Icons.notifications_active;
      case 'system':
        return Icons.info;
      default:
        return Icons.notifications;
    }
  }

  Color _getIconColor(String type) {
    switch (type) {
      case 'promotion':
        return AppColors.accentColor;
      case 'order':
        return AppColors.primaryColor;
      case 'reminder':
        return AppColors.secondaryPrimary;
      case 'system':
        return AppColors.lightTextSecondary; // Or a neutral color
      default:
        return AppColors.primaryColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    final Color backgroundColor = isDark ? AppColors.darkBackground : AppColors.lightBackground;
    final Color cardColor = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final Color textColor = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final Color secondaryTextColor = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final Color dividerColor = isDark ? AppColors.darkDivider : AppColors.lightDivider;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          'Notifications',
          style: AppTextStyles.headlineMedium().copyWith(color: isDark ? AppColors.darkTextPrimary : AppColors.white),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primaryColor,
        flexibleSpace:
            isDark
                ? null
                : Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: AppColors.headerGradientColors,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
        elevation: 0,
        actions: [
          Obx(() {
            final unreadCount = _notifications.where((n) => !n['read']).length;
            if (unreadCount > 0) {
              return TextButton(
                onPressed: () {
                  for (var notif in _notifications) {
                    notif['read'] = true;
                  }

                  Get.snackbar(
                    "All Read",
                    "All notifications marked as read.",
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: AppColors.sucessPrimary,
                    colorText: AppColors.white,
                  );
                },
                child: Text(
                  'Mark All Read',
                  style: AppTextStyles.button.copyWith(color: AppColors.white, fontSize: 14),
                ),
              );
            }
            return const SizedBox.shrink(); // Hide button if no unread
          }),
        ],
      ),
      body: Obx(() {
        // Obx listens to changes in _notifications
        if (_notifications.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.notifications_off, size: 80, color: secondaryTextColor.withOpacity(0.5)),
                const SizedBox(height: 16),
                Text("No New Notifications", style: AppTextStyles.headlineMedium().copyWith(color: secondaryTextColor)),
                Text("You're all caught up!", style: AppTextStyles.body().copyWith(color: secondaryTextColor)),
              ],
            ),
          );
        }

        final todayNotifications =
            _notifications.where((n) => n['time'].contains('Today') || n['time'].contains('ago')).toList();
        final earlierNotifications =
            _notifications.where((n) => !n['time'].contains('Today') && !n['time'].contains('ago')).toList();

        return ListView(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          children: [
            if (todayNotifications.isNotEmpty) ...[
              _buildSectionTitle("Today", textColor),
              ...todayNotifications.map(
                (notif) => _buildNotificationItem(
                  notif: notif,
                  onTap: () => _markAsRead(notif['id']),
                  onDismissed: () => _deleteNotification(notif['id']),
                  cardColor: cardColor,
                  textColor: textColor,
                  secondaryTextColor: secondaryTextColor,
                ),
              ),
              if (earlierNotifications.isNotEmpty) const SizedBox(height: 20),
            ],
            if (earlierNotifications.isNotEmpty) ...[
              _buildSectionTitle("Earlier", textColor),
              ...earlierNotifications.map(
                (notif) => _buildNotificationItem(
                  notif: notif,
                  onTap: () => _markAsRead(notif['id']),
                  onDismissed: () => _deleteNotification(notif['id']),
                  cardColor: cardColor,
                  textColor: textColor,
                  secondaryTextColor: secondaryTextColor,
                ),
              ),
            ],
          ],
        );
      }),
    );
  }

  Widget _buildSectionTitle(String title, Color color) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 15, 16, 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title.toUpperCase(),
          style: AppTextStyles.caption().copyWith(
            fontWeight: FontWeight.w700,
            color: color.withOpacity(0.85),
            letterSpacing: 1.0,
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationItem({
    required Map<String, dynamic> notif,
    required VoidCallback onTap,
    required Function() onDismissed,
    required Color cardColor,
    required Color textColor,
    required Color secondaryTextColor,
  }) {
    final bool isRead = notif['read'];
    final IconData icon = _getNotificationIcon(notif['type']);
    final Color iconColor = _getIconColor(notif['type']);

    return Dismissible(
      key: Key(notif['id']),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        color: AppColors.red, // Swipe background color
        child: Icon(Icons.delete_forever, color: AppColors.white, size: 30),
      ),
      onDismissed: (direction) => onDismissed(),
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          color: isRead ? cardColor.withOpacity(0.8) : cardColor, // Slightly faded for read notifications
          elevation: isRead ? 2 : 5, // Less elevation for read
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side:
                isRead
                    ? BorderSide.none
                    : BorderSide(color: AppColors.primaryColor.withOpacity(0.5), width: 1.5), // Border for unread
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(isRead ? 0.08 : 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: iconColor, size: 26),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notif['title'],
                        style: AppTextStyles.body().copyWith(
                          color: textColor,
                          fontWeight: isRead ? FontWeight.normal : FontWeight.bold, // Bold for unread title
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        notif['body'],
                        style: AppTextStyles.caption().copyWith(
                          color: secondaryTextColor.withOpacity(isRead ? 0.7 : 1.0), // Faded for read body
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        notif['time'],
                        style: AppTextStyles.small().copyWith(color: secondaryTextColor.withOpacity(0.6)),
                      ),
                    ],
                  ),
                ),
                if (!isRead) // Unread indicator
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, top: 4.0),
                    child: CircleAvatar(
                      radius: 4,
                      backgroundColor: AppColors.accentColor, // Accent color dot
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
