import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_radius.dart';

class MarketplaceHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final String? badgeText;
  final Color? badgeColor;
  final List<Widget> actions;
  final ValueChanged<String>? onSearch;
  final String? searchPlaceholder;

  const MarketplaceHeader({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.badgeText,
    this.badgeColor,
    this.actions = const [],
    this.onSearch,
    this.searchPlaceholder,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF131722) : Colors.white,
        borderRadius: AppRadius.lg,
        border: Border.all(
          color: isDark ? const Color(0xFF262D40) : const Color(0xFFE2E8F0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Top row: Info metadata strip
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: AppRadius.sm,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.business_rounded, size: 12, color: AppColors.primary),
                    const SizedBox(width: 4),
                    Text(
                      'HOMIO HQ • MARKETPLACE OPERATIONS',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '• Live Sync Active',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF10B981),
                ),
              ),
              const Spacer(),
              Text(
                'Admin: Super User (RBAC: All Operations)',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),

          // Main Header Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      (badgeColor ?? AppColors.primary),
                      (badgeColor ?? AppColors.primary).withValues(alpha: 0.7),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: AppRadius.md,
                ),
                child: Icon(icon, color: Colors.white, size: 22),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            title,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.3,
                              color: isDark ? Colors.white : const Color(0xFF0F172A),
                            ),
                          ),
                        ),
                        if (badgeText != null) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: (badgeColor ?? AppColors.primary).withValues(alpha: 0.12),
                              borderRadius: AppRadius.sm,
                              border: Border.all(
                                color: (badgeColor ?? AppColors.primary).withValues(alpha: 0.3),
                              ),
                            ),
                            child: Text(
                              badgeText!,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w700,
                                color: badgeColor ?? AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w400,
                        color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
              if (actions.isNotEmpty) ...[
                const SizedBox(width: AppSpacing.md),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  alignment: WrapAlignment.end,
                  children: actions,
                ),
              ],
            ],
          ),

          // Search bar row if provided
          if (onSearch != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Container(
              height: 38,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF0B0E14) : const Color(0xFFF8FAFC),
                borderRadius: AppRadius.md,
                border: Border.all(
                  color: isDark ? const Color(0xFF262D40) : const Color(0xFFCBD5E1),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Icon(Icons.search_rounded, size: 18, color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      onChanged: onSearch,
                      style: GoogleFonts.plusJakartaSans(fontSize: 12.5, color: isDark ? Colors.white : const Color(0xFF0F172A)),
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                        hintText: searchPlaceholder ?? 'Global search across marketplace products, properties, orders & SKUs...',
                        hintStyle: GoogleFonts.plusJakartaSans(
                          fontSize: 12.5,
                          color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
