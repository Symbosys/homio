import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_radius.dart';
import '../domain/hrms_enums.dart';

class HrmsCalendarDay {
  final int day;
  final AttendanceStatus? status;
  final String? note;
  final bool isToday;
  final bool isCurrentMonth;

  const HrmsCalendarDay({
    required this.day,
    this.status,
    this.note,
    this.isToday = false,
    this.isCurrentMonth = true,
  });
}

class HrmsCalendar extends StatelessWidget {
  final String title;
  final int month;
  final int year;
  final Map<int, AttendanceStatus> attendanceMap;
  final ValueChanged<int>? onDaySelected;

  const HrmsCalendar({
    super.key,
    this.title = 'Monthly Attendance Calendar',
    required this.month,
    required this.year,
    this.attendanceMap = const {},
    this.onDaySelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final weekdays = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

    // Basic calculation for days in month
    final firstDay = DateTime(year, month, 1);
    final daysInMonth = DateTime(year, month + 1, 0).day;
    final startOffset = (firstDay.weekday - 1); // 0 for Monday

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF131722) : Colors.white,
        borderRadius: AppRadius.lg,
        border: Border.all(
          color: isDark ? Colors.white.withValues(alpha: 0.08) : Colors.black.withValues(alpha: 0.06),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.04),
                  borderRadius: AppRadius.sm,
                ),
                child: Text(
                  'Aug 2026',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // Weekday Headers
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: weekdays.map((w) {
              return SizedBox(
                width: 32,
                child: Text(
                  w,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: AppSpacing.sm),

          // Days Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 35, // 5 rows x 7
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 6,
              crossAxisSpacing: 6,
              childAspectRatio: 1.0,
            ),
            itemBuilder: (context, index) {
              final dayNumber = index - startOffset + 1;
              if (dayNumber < 1 || dayNumber > daysInMonth) {
                return const SizedBox();
              }

              final isToday = dayNumber == 10; // Simulated today
              final status = attendanceMap[dayNumber] ??
                  (index % 7 == 6
                      ? AttendanceStatus.weeklyOff
                      : (dayNumber > 10 ? null : AttendanceStatus.present));

              Color? dotColor = status?.color;
              if (status == null) {
                dotColor = null;
              }

              return InkWell(
                onTap: () => onDaySelected?.call(dayNumber),
                borderRadius: AppRadius.sm,
                child: Container(
                  decoration: BoxDecoration(
                    color: isToday
                        ? AppColors.primary.withValues(alpha: isDark ? 0.25 : 0.12)
                        : (isDark ? const Color(0xFF1A1F2C) : const Color(0xFFF8FAFC)),
                    borderRadius: AppRadius.sm,
                    border: Border.all(
                      color: isToday
                          ? AppColors.primary
                          : (isDark ? Colors.white.withValues(alpha: 0.04) : Colors.black.withValues(alpha: 0.04)),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$dayNumber',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: isToday ? FontWeight.w700 : FontWeight.w500,
                          color: isToday
                              ? AppColors.primary
                              : (isDark ? Colors.white : const Color(0xFF0F172A)),
                        ),
                      ),
                      if (dotColor != null) ...[
                        const SizedBox(height: 2),
                        Container(
                          width: 5,
                          height: 5,
                          decoration: BoxDecoration(
                            color: dotColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: AppSpacing.sm),

          // Legend
          Wrap(
            spacing: 12,
            runSpacing: 4,
            children: [
              _buildLegendItem('Present', const Color(0xFF10B981), isDark),
              _buildLegendItem('Late', const Color(0xFFFB923C), isDark),
              _buildLegendItem('Leave', const Color(0xFF06B6D4), isDark),
              _buildLegendItem('Off', const Color(0xFF94A3B8), isDark),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color, bool isDark) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 7,
          height: 7,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 10,
            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
          ),
        ),
      ],
    );
  }
}
