import 'package:flutter/material.dart';
import 'breakpoints.dart';

/// Extension on BuildContext for quick and reliable responsive queries.
extension ResponsiveContext on BuildContext {
  double get screenWidth => MediaQuery.sizeOf(this).width;
  double get screenHeight => MediaQuery.sizeOf(this).height;

  ScreenType get screenType {
    final width = screenWidth;
    if (width < Breakpoints.compact) return ScreenType.compact;
    if (width < Breakpoints.medium) return ScreenType.medium;
    if (width < Breakpoints.expanded) return ScreenType.expanded;
    return ScreenType.large;
  }

  bool get isCompact => screenWidth < Breakpoints.compact;
  bool get isMedium => screenWidth >= Breakpoints.compact && screenWidth < Breakpoints.medium;
  bool get isExpanded => screenWidth >= Breakpoints.medium && screenWidth < Breakpoints.expanded;
  bool get isLarge => screenWidth >= Breakpoints.expanded;
  bool get isDesktop => screenWidth >= Breakpoints.medium;

  T responsiveValue<T>({
    required T compact,
    T? medium,
    T? expanded,
    T? large,
  }) {
    final type = screenType;
    switch (type) {
      case ScreenType.compact:
        return compact;
      case ScreenType.medium:
        return medium ?? compact;
      case ScreenType.expanded:
        return expanded ?? medium ?? compact;
      case ScreenType.large:
        return large ?? expanded ?? medium ?? compact;
    }
  }
}

/// A declarative builder widget that selects an appropriate layout according to available constraints.
class ResponsiveLayout extends StatelessWidget {
  const ResponsiveLayout({
    super.key,
    required this.compact,
    this.medium,
    this.expanded,
    this.large,
  });

  final WidgetBuilder compact;
  final WidgetBuilder? medium;
  final WidgetBuilder? expanded;
  final WidgetBuilder? large;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        if (width >= Breakpoints.expanded && large != null) {
          return large!(context);
        }
        if (width >= Breakpoints.medium && expanded != null) {
          return expanded!(context);
        }
        if (width >= Breakpoints.compact && medium != null) {
          return medium!(context);
        }
        return compact(context);
      },
    );
  }
}
