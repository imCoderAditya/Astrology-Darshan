// ignore_for_file: deprecated_member_use

import 'package:astrology/app/core/config/theme/app_colors.dart';
import 'package:astrology/app/core/config/theme/app_text_styles.dart';
import 'package:astrology/app/modules/profile/controllers/profile_controller.dart';
import 'package:astrology/app/routes/app_pages.dart';
import 'package:astrology/app/services/storage/local_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    final Color background =
        isDark ? AppColors.darkBackground : AppColors.lightBackground;
    final Color cardColor =
        isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final Color textColor =
        isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final Color secondaryTextColor =
        isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final Color dividerColor =
        isDark ? AppColors.darkDivider : AppColors.lightDivider;

    return GetBuilder<ProfileController>(
      init: ProfileController(),
      builder: (controller) {
        final profile = controller.profileModel.value?.data;

        return Scaffold(
          backgroundColor: background,
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 220.0, // Slightly taller for more impact
                floating: false,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  titlePadding: const EdgeInsets.only(bottom: 16.0),
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: AppColors.headerGradientColors,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      // Optional: Add a subtle background pattern or texture here
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),
                        // Profile picture with a subtle border and animation
                        TweenAnimationBuilder<double>(
                          tween: Tween<double>(begin: 0.0, end: 1.0),
                          duration: const Duration(milliseconds: 700),
                          builder: (context, value, child) {
                            return Transform.scale(
                              scale: value,
                              child: CircleAvatar(
                                radius: 45, // Larger avatar
                                backgroundColor: AppColors.white.withOpacity(
                                  0.8,
                                ), // Softer white border
                                child: CircleAvatar(
                                  radius:
                                      42, // Slightly smaller inner for border effect
                                  backgroundImage: NetworkImage(
                                    profile?.profilePicture ?? "",
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 12), // More spacing
                        Text(
                          "${profile?.firstName ?? ""} ${profile?.lastName ?? ""} ${profile?.customerId ?? ""}",
                          style: AppTextStyles.headlineMedium().copyWith(
                            color: AppColors.white,
                            shadows: [
                              Shadow(
                                blurRadius: 3.0, // Stronger shadow
                                color: Colors.black.withOpacity(0.4),
                                offset: const Offset(1, 1),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          profile?.email ?? "",
                          style: AppTextStyles.caption().copyWith(
                            color: AppColors.white.withOpacity(
                              0.9,
                            ), // Slightly less transparent
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SliverList(
                delegate: SliverChildListDelegate([
                  const SizedBox(height: 25), // More space from header
                  // User Info Card - with subtle depth and animation
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                    ), // Slightly more horizontal padding
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(
                          20,
                        ), // More rounded corners
                        boxShadow: [
                          BoxShadow(
                            color:
                                isDark
                                    ? Colors.black.withOpacity(0.5)
                                    : Colors.grey.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 10, // Increased blur for softer shadow
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 25,
                          vertical: 25,
                        ), // Increased padding
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildInfoRow(
                              Icons.phone_android,
                              "Phone Number",
                              "+91 ${profile?.phoneNumber ?? ""}",
                              textColor,
                              secondaryTextColor,
                            ),
                            Divider(
                              color: dividerColor.withOpacity(0.6),
                              height: 35,
                              thickness: 1,
                            ), // Thicker divider
                            _buildInfoRow(
                              Icons.location_on,
                              "Current Location",
                              profile?.placeOfBirth ?? "",
                              textColor,
                              secondaryTextColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 35), // More space
                  // Account Settings Section
                  _buildSectionTitle("Account Settings", textColor),
                  _buildSettingsTile(
                    Icons.lock_outline,
                    "Change Password",
                    textColor: textColor,
                    onTap:
                        () => Get.snackbar(
                          "Action",
                          "Change Password Tapped",
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: AppColors.primaryColor,
                          colorText: AppColors.white,
                        ),
                  ),
                  _buildSettingsTile(
                    Icons.notifications_none,
                    "Notifications",
                    textColor: textColor,
                    trailing: Switch(
                      value: true,
                      onChanged: (bool value) {
                        Get.snackbar(
                          "Notifications",
                          "Notifications Toggled: $value",
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: AppColors.sucessPrimary,
                          colorText: AppColors.white,
                        );
                      },
                      activeColor:
                          AppColors.accentColor, // Use accent for switch
                      inactiveThumbColor: secondaryTextColor,
                      inactiveTrackColor: dividerColor,
                    ),
                    onTap:
                        () => Get.snackbar(
                          "Action",
                          "Notifications Settings Tapped",
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: AppColors.primaryColor,
                          colorText: AppColors.white,
                        ),
                  ),
                  // _buildSettingsTile(
                  //   Icons.language,
                  //   "Language",
                  //   textColor: textColor,
                  //   trailing: Text("English", style: AppTextStyles.body().copyWith(color: secondaryTextColor)),
                  //   onTap:
                  //       () => Get.snackbar(
                  //         "Action",
                  //         "Language Settings Tapped",
                  //         snackPosition: SnackPosition.BOTTOM,
                  //         backgroundColor: AppColors.primaryColor,
                  //         colorText: AppColors.white,
                  //       ),
                  // ),
                  _buildSettingsTile(
                    Icons.security,
                    "Privacy Policy",
                    textColor: textColor,
                    onTap:
                        () => Get.snackbar(
                          "Action",
                          "Privacy Policy Tapped",
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: AppColors.primaryColor,
                          colorText: AppColors.white,
                        ),
                  ),

                  const SizedBox(height: 25),

                  // App Section
                  _buildSectionTitle("App Information", textColor),
                  _buildSettingsTile(
                    Icons.info_outline,
                    "About App",
                    textColor: textColor,
                    onTap:
                        () => Get.snackbar(
                          "Action",
                          "About App Tapped",
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: AppColors.primaryColor,
                          colorText: AppColors.white,
                        ),
                  ),
                  _buildSettingsTile(
                    Icons.star_rate_rounded, // Nicer icon for Rate Us
                    "Rate Us",
                    textColor: textColor,
                    onTap:
                        () => Get.snackbar(
                          "Action",
                          "Rate Us Tapped",
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: AppColors.primaryColor,
                          colorText: AppColors.white,
                        ),
                  ),

                  const SizedBox(height: 35),

                  // Logout Button (red and prominent with animation)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: TweenAnimationBuilder<double>(
                      tween: Tween<double>(begin: 0.0, end: 1.0),
                      duration: const Duration(milliseconds: 800),
                      curve: Curves.easeOutBack, // Bouncy effect
                      builder: (context, value, child) {
                        return Transform.scale(
                          scale: value,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              showAttractiveLogoutDialog(
                                isDark,
                                cardColor,
                                textColor,
                                secondaryTextColor,
                              );
                            },
                            icon: Icon(Icons.logout, color: AppColors.white),
                            label: Text(
                              "Logout",
                              style: AppTextStyles.button.copyWith(
                                color: AppColors.white,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.accentColor,
                              minimumSize: const Size(
                                double.infinity,
                                55,
                              ), // Taller button
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  15,
                                ), // More rounded corners
                              ),
                              elevation: 8, // Higher elevation
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 40),
                ]),
              ),
            ],
          ),
        );
      },
    );
  }

  // --- Helper Widgets (Further Refined) ---

  Widget _buildInfoRow(
    IconData icon,
    String label,
    String value,
    Color textColor,
    Color secondaryTextColor,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 8.0,
      ), // Padding within the info row
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: AppColors.accentColor,
            size: 26,
          ), // Use accent color for info icons, slightly larger
          const SizedBox(width: 18), // More space
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyles.caption().copyWith(
                  color: secondaryTextColor,
                ),
              ),
              const SizedBox(height: 4), // More spacing between label and value
              Text(
                value,
                style: AppTextStyles.body().copyWith(
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ), // Slightly bolder value
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, Color color) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        25,
        20,
        20,
        10,
      ), // More spacing, and align with cards
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title.toUpperCase(),
          style: AppTextStyles.caption().copyWith(
            fontWeight: FontWeight.w700,
            color: color.withOpacity(0.85), // Slightly more opaque
            letterSpacing: 1.0, // Increased letter spacing
            fontSize: 15, // Slightly larger font size for section title
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsTile(
    IconData icon,
    String title, {
    required Color textColor,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return Card(
      color:
          Theme.of(Get.context!).brightness == Brightness.dark
              ? AppColors.darkSurface
              : AppColors.lightSurface,
      margin: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 8,
      ), // More vertical margin for separation
      elevation: 4, // More elevation for each tile
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ), // More rounded corners
      child: InkWell(
        // Use InkWell for tap feedback
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 12,
          ), // Increased padding within tile
          child: Row(
            children: [
              Icon(
                icon,
                color: AppColors.primaryColor,
                size: 24,
              ), // Consistent primary color for icons, slightly larger
              const SizedBox(width: 20), // More spacing
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.body().copyWith(
                    color: textColor,
                    fontWeight: FontWeight.w500,
                  ), // Slightly bolder title
                ),
              ),
              trailing ??
                  Icon(
                    Icons.chevron_right,
                    color: textColor.withOpacity(0.6),
                    size: 24,
                  ), // Larger chevron
            ],
          ),
        ),
      ),
    );
  }
}

// Assume you have access to isDark, cardColor, textColor, secondaryTextColor
// from the surrounding context, like in your ProfileView.

void showAttractiveLogoutDialog(
  bool isDark,
  Color cardColor,
  Color textColor,
  Color secondaryTextColor,
) {
  Get.defaultDialog(
    // New: Added a custom dialog content for more control
    content: Column(
      mainAxisSize: MainAxisSize.min, // Make column only take needed space
      children: [
        // Optional: Icon at the top for visual emphasis
        Icon(
          Icons.logout,
          color: AppColors.red, // Use red for logout icon
          size: 60,
        ),
        const SizedBox(height: 16),
        Text(
          "Logout Confirmation", // More descriptive title for user
          style: AppTextStyles.headlineMedium().copyWith(color: textColor),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Text(
          "Are you absolutely sure you want to log out from your account?", // More engaging message
          style: AppTextStyles.body().copyWith(color: secondaryTextColor),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24), // More space before buttons
        Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceEvenly, // Distribute buttons evenly
          children: [
            // Cancel Button (Ghost/Outlined Style)
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  Get.back(); // Close dialog
                },
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: AppColors.primaryColor,
                    width: 1.5,
                  ), // Primary color border
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ), // Rounded corners
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: Text(
                  "Stay Logged In", // More reassuring text
                  style: AppTextStyles.button.copyWith(
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16), // Space between buttons
            // Confirm Button (Filled Red Style)
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  Get.back(); // Close dialog
                  LocalStorageService.logout().then((value) {
                    Get.offAllNamed(Routes.LOGIN);
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.red, // Strong red for confirmation
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ), // Rounded corners
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  elevation: 5, // Subtle shadow for pop
                ),
                child: Text(
                  "Logout Now", // Clear call to action
                  style: AppTextStyles.button.copyWith(color: AppColors.white),
                ),
              ),
            ),
          ],
        ),
      ],
    ),
    // Dialog's overall styling
    backgroundColor: cardColor,

    // No need for direct title/middleText/textConfirm/textCancel as we use content
    title: "", // Title and middleText are now handled within the content widget
    middleText: "",
  );
}

// How you would call this in your ProfileView's logout button:
/*
onPressed: () {
  showAttractiveLogoutDialog(isDark, cardColor, textColor, secondaryTextColor);
},
*/
