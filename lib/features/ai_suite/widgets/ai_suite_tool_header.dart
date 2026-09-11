import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'compact_ai_suite_actions.dart';

class AiSuiteToolHeader extends StatelessWidget {
  final String title;
  final TabBar tabBar;
  final Widget? trailing;

  const AiSuiteToolHeader({
    super.key,
    required this.title,
    required this.tabBar,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 720;

        if (isDesktop) {
          return Container(
            height: 46,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF111827) : Colors.white,
              border: Border(
                bottom: BorderSide(
                  color: isDark ? const Color(0xFF1F2937) : const Color(0xFFE2E8F0),
                ),
              ),
            ),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: Text(
                    title,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                ),
                const SizedBox(height: 20, child: VerticalDivider(width: 1, thickness: 1)),
                Expanded(child: tabBar),
                trailing ?? const CompactAiSuiteActions(),
              ],
            ),
          );
        } else {
          return Container(
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF111827) : Colors.white,
              border: Border(
                bottom: BorderSide(
                  color: isDark ? const Color(0xFF1F2937) : const Color(0xFFE2E8F0),
                ),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: 38,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          title,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: isDark ? Colors.white : const Color(0xFF0F172A),
                          ),
                        ),
                      ),
                      const Spacer(),
                      trailing ?? const CompactAiSuiteActions(),
                    ],
                  ),
                ),
                SizedBox(
                  height: 38,
                  child: tabBar,
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
