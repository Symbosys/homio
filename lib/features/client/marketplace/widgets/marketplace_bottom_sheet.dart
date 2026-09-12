import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';

/// Reusable modal sheet wrapper with handle, header, scrollable body and bottom actions
class MarketplaceBottomSheet extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? headerTag;
  final Widget body;
  final Widget? bottomBar;
  final double maxHeightFactor;

  const MarketplaceBottomSheet({
    super.key,
    required this.title,
    this.subtitle,
    this.headerTag,
    required this.body,
    this.bottomBar,
    this.maxHeightFactor = 0.90,
  });

  static void show({
    required BuildContext context,
    required String title,
    String? subtitle,
    Widget? headerTag,
    required Widget body,
    Widget? bottomBar,
    double maxHeightFactor = 0.90,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => MarketplaceBottomSheet(
        title: title,
        subtitle: subtitle,
        headerTag: headerTag,
        body: body,
        bottomBar: bottomBar,
        maxHeightFactor: maxHeightFactor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final textMuted = isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * maxHeightFactor,
      ),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border.all(color: border),
      ),
      child: Column(
        children: [
          // Drag handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (headerTag != null) ...[
                        headerTag!,
                        const SizedBox(height: 4),
                      ],
                      Text(
                        title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: textPrimary,
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          subtitle!,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            color: textMuted,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close_rounded),
                ),
              ],
            ),
          ),
          Divider(color: border, height: 1),

          // Scrollable Body
          Expanded(child: body),

          // Sticky Bottom Bar
          if (bottomBar != null) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: surface,
                border: Border(top: BorderSide(color: border)),
              ),
              child: SafeArea(top: false, child: bottomBar!),
            ),
          ],
        ],
      ),
    );
  }
}
