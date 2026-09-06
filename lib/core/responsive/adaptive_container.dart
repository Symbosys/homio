import 'package:flutter/material.dart';
import 'breakpoints.dart';
import 'responsive_builder.dart';

/// Container that applies consistent max-width boundaries and fluid horizontal gutters.
class AdaptiveContainer extends StatelessWidget {
  const AdaptiveContainer({
    super.key,
    required this.child,
    this.maxWidth = Breakpoints.maxContentWidth,
    this.padding,
    this.alignment = Alignment.center,
  });

  final Widget child;
  final double maxWidth;
  final EdgeInsetsGeometry? padding;
  final AlignmentGeometry alignment;

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = context.responsiveValue<double>(
      compact: 16.0,
      medium: 24.0,
      expanded: 32.0,
      large: 40.0,
    );

    return Align(
      alignment: alignment,
      child: Container(
        constraints: BoxConstraints(maxWidth: maxWidth),
        padding: padding ?? EdgeInsets.symmetric(horizontal: horizontalPadding),
        child: child,
      ),
    );
  }
}
