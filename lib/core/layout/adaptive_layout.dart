import 'package:flutter/material.dart';

/// Screen breakpoint classifications across Web, Desktop, Laptop, Tablet, and Mobile.
enum ScreenType {
  mobile,
  tablet,
  laptop,
  desktop,
}

/// Adaptive layout utility class for responsive UI branching.
class AdaptiveLayout {
  static ScreenType getScreenType(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= 1280) return ScreenType.desktop;
    if (width >= 1024) return ScreenType.laptop;
    if (width >= 768) return ScreenType.tablet;
    return ScreenType.mobile;
  }

  static bool isDesktop(BuildContext context) {
    final type = getScreenType(context);
    return type == ScreenType.desktop || type == ScreenType.laptop;
  }

  static bool isMobile(BuildContext context) {
    return getScreenType(context) == ScreenType.mobile;
  }

  static bool isTablet(BuildContext context) {
    return getScreenType(context) == ScreenType.tablet;
  }
}
