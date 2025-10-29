import 'package:astrology/app/core/config/theme/app_colors.dart';
import 'package:astrology/app/core/config/theme/app_text_styles.dart';
import 'package:astrology/app/data/models/notification/notification_model.dart';
import 'package:astrology/app/modules/notification/controllers/notification_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationView extends StatefulWidget {
  const NotificationView({super.key});

  @override
  State<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  String _formatTime(DateTime? dateTime) {
    if (dateTime == null) return '';

    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }

  bool _isToday(DateTime? dateTime) {
    if (dateTime == null) return false;

    final now = DateTime.now();
    final difference = now.difference(dateTime);

    return difference.inHours < 24;
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    final Color backgroundColor =
        isDark ? AppColors.darkBackground : AppColors.lightBackground;
    final Color cardColor =
        isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final Color textColor =
        isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final Color secondaryTextColor =
        isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    return GetBuilder<NotificationController>(
      init: NotificationController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: backgroundColor,
          appBar: AppBar(
            iconTheme: IconThemeData(
              color: AppColors.white
            ),
            title: Text(
              'Notifications',
              style: AppTextStyles.headlineMedium().copyWith(
                color: isDark ? AppColors.darkTextPrimary : AppColors.white,
              ),
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
          ),
          body: Obx(() {
            if (controller.isLoading?.value == true) {
              return Center(child: CircularProgressIndicator());
            }
            NotificationModel? notificationModel =
                controller.notification.value;

            if (notificationModel?.data == null ||
                notificationModel!.data!.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.notifications_off,
                      size: 80,
                      color: secondaryTextColor.withOpacity(0.5),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "No New Notifications",
                      style: AppTextStyles.headlineMedium().copyWith(
                        color: secondaryTextColor,
                      ),
                    ),
                    Text(
                      "You're all caught up!",
                      style: AppTextStyles.body().copyWith(
                        color: secondaryTextColor,
                      ),
                    ),
                  ],
                ),
              );
            }

            final todayNotifications =
                notificationModel.data!
                    .where((notification) => _isToday(notification.createdAt))
                    .toList();

            final earlierNotifications =
                notificationModel.data!
                    .where((notification) => !_isToday(notification.createdAt))
                    .toList();

            return ListView(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              children: [
                if (todayNotifications.isNotEmpty) ...[
                  _buildSectionTitle("Today", textColor),
                  ...todayNotifications.map(
                    (notification) => _buildNotificationItem(
                      notification: notification,
                      cardColor: cardColor,
                      textColor: textColor,
                      secondaryTextColor: secondaryTextColor,
                    ),
                  ),
                  if (earlierNotifications.isNotEmpty)
                    const SizedBox(height: 20),
                ],
                if (earlierNotifications.isNotEmpty) ...[
                  _buildSectionTitle("Earlier", textColor),
                  ...earlierNotifications.map(
                    (notification) => _buildNotificationItem(
                      notification: notification,
                      isToday: false,
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
      },
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
    required Datum notification,
    required Color cardColor,
    required Color textColor,
    required Color secondaryTextColor,
   bool? isToday=true 
  }) {
    final bool isRead = notification.isRead ?? false;
    final bool isNew = notification.isNew ?? false;

    return Card(
      color: isRead ? cardColor.withOpacity(0.8) : cardColor,
      elevation: isRead ? 2 : 5,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side:
            isRead
                ? BorderSide.none
                : BorderSide(
                  color: AppColors.primaryColor.withOpacity(0.5),
                  width: 1.5,
                ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(isRead ? 0.08 : 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.notifications,
                color: AppColors.primaryColor,
                size: 26,
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.title ?? '',
                    style: AppTextStyles.body().copyWith(
                      color: textColor,
                      fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notification.message ?? '',
                    style: AppTextStyles.caption().copyWith(
                      color: secondaryTextColor.withOpacity(isRead ? 0.7 : 1.0),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _formatTime(notification.createdAt),
                    style: AppTextStyles.small().copyWith(
                      color: secondaryTextColor.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                if (!isRead)
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, top: 4.0),
                    child: CircleAvatar(
                      radius: 4,
                      backgroundColor: AppColors.accentColor,
                    ),
                  ),
                if (isNew && !isRead && isToday==true)
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, top: 8.0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'NEW',
                        style: AppTextStyles.small().copyWith(
                          color: AppColors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
