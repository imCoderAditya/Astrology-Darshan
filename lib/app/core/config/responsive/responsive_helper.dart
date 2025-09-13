import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

enum DeviceScreenType { mobile, tablet, desktop }

class ResponsiveHelper {
  static const int mobileBreakpoint = 600;
  static const int tabletBreakpoint = 1024;

  static DeviceScreenType deviceType(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    if (width < mobileBreakpoint) {
      return DeviceScreenType.mobile;
    } else if (width < tabletBreakpoint) {
      return DeviceScreenType.tablet;
    } else {
      return DeviceScreenType.desktop;
    }
  }

  static bool isMobile(BuildContext context) =>
      deviceType(context) == DeviceScreenType.mobile;

  static bool isTablet() =>
      deviceType(Get.context!) == DeviceScreenType.tablet;

  static bool isDesktop(BuildContext context) =>
      deviceType(context) == DeviceScreenType.desktop;
}