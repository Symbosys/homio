import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_radius.dart';
import '../domain/hrms_domain_models.dart';

class HrmsTimeline extends StatelessWidget {
  final List<EmployeeActivity> activities;

  const HrmsTimeline({
    super.key,
    required this.activities,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (activities.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Text(
            'No recent activity logs recorded.',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
            ),
          ),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: activities.length,
      separatorBuilder: (ctx, idx) => const SizedBox(height: AppSpacing.sm),
      itemBuilder: (context, index) {
        final act = activities[index];
        final iconData = _getIconData(act.iconName);
        final color = _getColor(act.activityType);

        return Container(
          padding: const EdgeInsets.all(AppSpacing.sm),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF181D2A) : const Color(0xFFF8FAFC),
            borderRadius: AppRadius.md,
            border: Border.all(
              color: isDark ? Colors.white.withValues(alpha: 0.04) : Colors.black.withValues(alpha: 0.04),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: isDark ? 0.2 : 0.1),
                  borderRadius: AppRadius.sm,
                ),
                child: Icon(iconData, size: 16, color: color),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          act.title,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white : const Color(0xFF0F172A),
                          ),
                        ),
                        Text(
                          _formatTime(act.timestamp),
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      act.description,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  IconData _getIconData(String name) {
    switch (name) {
      case 'fingerprint':
        return Icons.fingerprint;
      case 'directions_bike':
        return Icons.directions_bike;
      case 'warning_amber':
        return Icons.warning_amber;
      case 'payments':
        return Icons.payments_outlined;
      case 'alarm':
        return Icons.alarm;
      case 'event_busy':
        return Icons.event_busy;
      case 'person_add':
        return Icons.person_add_outlined;
      default:
        return Icons.info_outline;
    }
  }

  Color _getColor(String type) {
    switch (type) {
      case 'attendance':
        return const Color(0xFF10B981);
      case 'travel':
        return const Color(0xFF3B82F6);
      case 'payroll':
        return const Color(0xFF8B5CF6);
      case 'leave':
        return const Color(0xFFF59E0B);
      default:
        return const Color(0xFF06B6D4);
    }
  }

  String _formatTime(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    } else {
      return '${dt.day}/${dt.month}';
    }
  }
}
