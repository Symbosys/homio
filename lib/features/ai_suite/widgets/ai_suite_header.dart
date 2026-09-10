import 'package:flutter/material.dart';

class AiSuiteHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? currentRoute;
  final VoidCallback? onRefresh;

  const AiSuiteHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.currentRoute,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}
