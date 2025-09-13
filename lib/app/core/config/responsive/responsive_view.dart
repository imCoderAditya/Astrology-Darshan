import 'package:flutter/material.dart';

/// A reusable responsive widget for Flutter apps (web, desktop, mobile).
/// Use this as a wrapper to provide different layouts for mobile, tablet, and desktop.
/// Example usage:
/// ResponsiveView(
///   mobile: MobileHome(),
///   tablet: TabletHome(),
///   desktop: DesktopHome(),
/// )
class ResponsiveView extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  static const int mobileBreakpoint = 600;
  static const int tabletBreakpoint = 1024;

  const ResponsiveView({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    if (width < mobileBreakpoint) {
      return mobile;
    } else if (width < tabletBreakpoint) {
      return tablet ?? mobile;
    } else {
      return desktop ?? tablet ?? mobile;
    }
  }
}