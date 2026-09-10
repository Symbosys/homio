import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_radius.dart';

class MarketplaceAlertItem {
  final String title;
  final String description;
  final int count;
  final IconData icon;
  final Color severityColor;
  final String actionLabel;
  final VoidCallback onAction;

  const MarketplaceAlertItem({
    required this.title,
    required this.description,
    required this.count,
    required this.icon,
    required this.severityColor,
    required this.actionLabel,
    required this.onAction,
  });
}

class MarketplaceAttentionPanel extends StatelessWidget {
  final List<MarketplaceAlertItem> alerts;

  const MarketplaceAttentionPanel({
    super.key,
    required this.alerts,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (alerts.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF131722) : Colors.white,
          borderRadius: AppRadius.md,
          border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Color(0xFF10B981), size: 18),
            const SizedBox(width: 10),
            Text(
              'Zero critical operational bottlenecks. All orders, approvals & verifications are on schedule.',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF10B981),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1215) : const Color(0xFFFFF1F2),
        borderRadius: AppRadius.md,
        border: Border.all(
          color: const Color(0xFFEF4444).withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFFEF4444).withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.warning_amber_rounded, color: Color(0xFFEF4444), size: 18),
              ),
              const SizedBox(width: 10),
              Text(
                'Marketplace Attention Required (${alerts.length} Pending Operational Actions)',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.2,
                  color: const Color(0xFFEF4444),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: alerts.map((alert) {
              return Container(
                constraints: const BoxConstraints(minWidth: 260, maxWidth: 360),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF131722) : Colors.white,
                  borderRadius: AppRadius.sm,
                  border: Border.all(color: alert.severityColor.withValues(alpha: 0.35)),
                ),
                child: Row(
                  children: [
                    Icon(alert.icon, size: 16, color: alert.severityColor),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                                decoration: BoxDecoration(
                                  color: alert.severityColor.withValues(alpha: 0.15),
                                  borderRadius: AppRadius.sm,
                                ),
                                child: Text(
                                  '${alert.count}',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w800,
                                    color: alert.severityColor,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Flexible(
                                child: Text(
                                  alert.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w700,
                                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            alert.description,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 10.5,
                              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 6),
                    ElevatedButton(
                      onPressed: alert.onAction,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: alert.severityColor,
                        foregroundColor: Colors.white,
                        visualDensity: VisualDensity.compact,
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        elevation: 0,
                      ),
                      child: Text(
                        alert.actionLabel,
                        style: GoogleFonts.plusJakartaSans(fontSize: 10.5, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
