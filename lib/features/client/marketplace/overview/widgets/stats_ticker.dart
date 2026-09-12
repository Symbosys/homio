import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/theme/app_colors.dart';

/// Trust and platform metrics row on Marketplace Overview
class StatsTicker extends StatelessWidget {
  const StatsTicker({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final textMuted = isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted;

    final stats = [
      (
        '100% Verified',
        'RERA & Title Checked',
        Icons.verified_user_rounded,
        const Color(0xFF10B981),
      ),
      (
        'Trade Pricing',
        'Direct from Factories',
        Icons.local_shipping_rounded,
        const Color(0xFF3B82F6),
      ),
      (
        'Guild Craftsmen',
        'Police & Skill Vetted',
        Icons.engineering_rounded,
        const Color(0xFF8B5CF6),
      ),
      (
        'Instant Vault',
        'Digital Assets & BOQs',
        Icons.cloud_download_rounded,
        const Color(0xFFF59E0B),
      ),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: border),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isNarrow = constraints.maxWidth < 680;
          if (isNarrow) {
            return Wrap(
              spacing: 16,
              runSpacing: 16,
              children: stats.map((s) => _buildStatItem(s, textPrimary, textMuted, border)).toList(),
            );
          }
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: stats.map((s) => _buildStatItem(s, textPrimary, textMuted, border)).toList(),
          );
        },
      ),
    );
  }

  Widget _buildStatItem(
    (String, String, IconData, Color) stat,
    Color textPrimary,
    Color textMuted,
    Color border,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: stat.$4.withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(stat.$3, size: 20, color: stat.$4),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              stat.$1,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: textPrimary,
              ),
            ),
            Text(
              stat.$2,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                color: textMuted,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
