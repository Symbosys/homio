import 'package:flutter/widgets.dart';

/// Semantic breakpoint constants for multi-platform responsiveness.
abstract class Breakpoints {
  /// Handheld mobile devices and narrow windows (< 600px).
  static const double compact = 600.0;

  /// Tablets, large foldables, and medium windows (600px - 1024px).
  static const double medium = 1024.0;

  /// Standard desktop screens, laptops, and wide windows (1024px - 1440px).
  static const double expanded = 1440.0;

  /// Maximum content constraint for readable SaaS layout on wide & ultrawide screens.
  static const double maxContentWidth = 1240.0;

  /// Form card constraint for authentication and dialogs.
  static const double maxFormWidth = 460.0;

  /// Convenience helpers for widget layout checks
  static bool isMobile(BuildContext context) => MediaQuery.of(context).size.width < medium;
  static bool isCompact(BuildContext context) => MediaQuery.of(context).size.width < compact;
  static bool isTablet(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return w >= compact && w < medium;
  }
  static bool isDesktop(BuildContext context) => MediaQuery.of(context).size.width >= medium;
}

enum ScreenType {
  compact, // Mobile
  medium,  // Tablet
  expanded,// Laptop / Desktop
  large,   // Large display / Ultrawide
}
