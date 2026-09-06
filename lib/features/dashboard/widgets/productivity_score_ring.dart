import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../models/dashboard_models.dart';

/// Compact Radial Productivity Gauge Ring & Metric Breakdown
class ProductivityScoreRing extends StatelessWidget {
  final ProductivityScoreData scoreData;

  const ProductivityScoreRing({
    super.key,
    required this.scoreData,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 260,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: AppRadius.md,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Section Header
          Row(
            children: [
              const Icon(Icons.speed_rounded, size: 16, color: Color(0xFF10B981)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Productivity & Velocity Engine',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : AppColors.lightTextPrimary,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: isDark ? 0.2 : 0.1),
                  borderRadius: AppRadius.full,
                  border: Border.all(
                    color: const Color(0xFF10B981).withValues(alpha: isDark ? 0.4 : 0.3),
                  ),
                ),
                child: Text(
                  scoreData.grade,
                  style: GoogleFonts.inter(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w700,
                    color: isDark ? const Color(0xFF34D399) : const Color(0xFF059669),
                  ),
                ),
              ),
            ],
          ),

          // Ring Gauge + Stats Row
          Row(
            children: [
              // Radial Gauge Ring
              SizedBox(
                width: 90,
                height: 90,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 80,
                      height: 80,
                      child: CircularProgressIndicator(
                        value: scoreData.score / 100.0,
                        strokeWidth: 8,
                        backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
                        valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF10B981)),
                        strokeCap: StrokeCap.round,
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${scoreData.score.toStringAsFixed(1)}%',
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: isDark ? Colors.white : AppColors.lightTextPrimary,
                          ),
                        ),
                        Text(
                          '+${scoreData.scoreChange}% today',
                          style: GoogleFonts.inter(
                            fontSize: 8.5,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF10B981),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),

              // Breakdown Counters
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildBreakdownItem(
                      label: 'Task Completion',
                      value: '${scoreData.tasksCompleted}/${scoreData.totalTasks}',
                      ratio: scoreData.totalTasks > 0 ? scoreData.tasksCompleted / scoreData.totalTasks : 0,
                      color: const Color(0xFF6366F1),
                      isDark: isDark,
                    ),
                    const SizedBox(height: 10),
                    _buildBreakdownItem(
                      label: 'Followup Clearance',
                      value: '${scoreData.followupsCompleted}/${scoreData.totalFollowups}',
                      ratio: scoreData.totalFollowups > 0 ? scoreData.followupsCompleted / scoreData.totalFollowups : 0,
                      color: const Color(0xFFF59E0B),
                      isDark: isDark,
                    ),
                    const SizedBox(height: 10),
                    _buildBreakdownItem(
                      label: 'Site Meetings Done',
                      value: '${scoreData.siteMeetingsDone} Completed',
                      ratio: 1.0,
                      color: const Color(0xFF0EA5E9),
                      isDark: isDark,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }

  Widget _buildBreakdownItem({
    required String label,
    required String value,
    required double ratio,
    required Color color,
    required bool isDark,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 10.5,
                fontWeight: FontWeight.w500,
                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              ),
            ),
            Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : AppColors.lightTextPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 3),
        ClipRRect(
          borderRadius: BorderRadius.circular(2),
          child: LinearProgressIndicator(
            value: ratio.clamp(0.0, 1.0),
            minHeight: 4,
            backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}
