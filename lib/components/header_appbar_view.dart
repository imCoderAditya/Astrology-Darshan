import 'package:astrology/app/core/config/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:badges/badges.dart' as badges;

class HeaderAppBarView extends StatelessWidget {
  final VoidCallback onLeadingTap;
  final String title;
  final VoidCallback? onFilterTap;
  final List<Color>? backgroundGradient;
  final Color shadowColor;
  final List<Widget>? action;
  final IconData? icon;
  final bool isBadges;
  final int? tototItem;
  final IconData? leadingIcon;

  const HeaderAppBarView({
    super.key,
    required this.onLeadingTap,
    required this.title,
    this.onFilterTap,
    this.action,
    this.backgroundGradient,
    this.shadowColor = const Color(0xFF1976D2),
    this.icon,
    this.leadingIcon,
    this.isBadges = false,
    this.tototItem,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      alignment: Alignment.bottomCenter,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors:
              backgroundGradient ??
              [AppColors.primaryColor, AppColors.accentColor],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: shadowColor.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          // Leading Icon
          GestureDetector(
            onTap: onLeadingTap,
            child: Container(
              padding: EdgeInsets.all(5.h),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(leadingIcon ?? Icons.menu, color: Colors.white),
            ),
          ),

          // Title
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 0.5,
              ),
            ),
          ),

          // Filter Icon (optional) - Maintaining exact original functionality
          if (action != null && action!.isNotEmpty)
            Row(children: action ?? [])
          else if (isBadges == true)
            GestureDetector(
              onTap: onFilterTap,
              child: badges.Badge(
                position: badges.BadgePosition.topEnd(top: -10, end: -10),
                showBadge: tototItem != null && tototItem != 0,
                badgeContent: Text(
                  "${tototItem ?? 0}",
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: 0.2,
                  ),
                ),
                badgeAnimation: badges.BadgeAnimation.scale(
                  animationDuration: Duration(milliseconds: 500),
                  curve: Curves.elasticOut,
                ),
                badgeStyle: badges.BadgeStyle(
                  shape: badges.BadgeShape.circle,
                  badgeColor: Colors.white,
                  padding: EdgeInsets.all(5.w),
                  borderGradient: badges.BadgeGradient.linear(
                    colors: [Colors.red, Colors.black],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.white, width: 1),
                  badgeGradient: badges.BadgeGradient.linear(
                    colors: [AppColors.primaryColor, AppColors.accentColor],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  elevation: 8,
                ),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withValues(alpha: 0.25),
                        Colors.white.withValues(alpha: 0.15),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.3),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    icon ?? Icons.filter_list,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
              ),
            )
          else
            GestureDetector(
              onTap: onFilterTap,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withValues(alpha: 0.25),
                      Colors.white.withValues(alpha: 0.15),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.3),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  icon ?? Icons.filter_list,
                  color: Colors.white,
                  size: 22,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
