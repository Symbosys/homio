import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_radius.dart';
import '../domain/hrms_domain_models.dart';

// 1. Weekly Attendance Bar Chart (Present, Late, Absent)
class AttendanceTrendBarChart extends StatelessWidget {
  final String title;

  const AttendanceTrendBarChart({
    super.key,
    this.title = 'Weekly Attendance & Punctuality Trend',
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    // Mock values: present, late, absent
    final data = [
      (present: 14.0, late: 1.0, absent: 0.0),
      (present: 13.0, late: 2.0, absent: 0.0),
      (present: 14.0, late: 0.0, absent: 1.0),
      (present: 12.0, late: 2.0, absent: 1.0),
      (present: 13.0, late: 1.0, absent: 1.0),
      (present: 11.0, late: 3.0, absent: 1.0),
    ];

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
              Row(
                children: [
                  const Icon(Icons.bar_chart_rounded, size: 18, color: Color(0xFF10B981)),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  _legendItem('On-Time', const Color(0xFF10B981), isDark),
                  const SizedBox(width: 10),
                  _legendItem('Late', const Color(0xFFFB923C), isDark),
                  const SizedBox(width: 10),
                  _legendItem('Absent', const Color(0xFFEF4444), isDark),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          SizedBox(
            height: 180,
            child: BarChart(
              BarChartData(
                maxY: 16,
                alignment: BarChartAlignment.spaceAround,
                barTouchData: BarTouchData(enabled: true),
                titlesData: FlTitlesData(
                  show: true,
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 24,
                      interval: 4,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 10,
                            color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                          ),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final idx = value.toInt();
                        if (idx >= 0 && idx < days.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(
                              days[idx],
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                              ),
                            ),
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 4,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.04),
                    strokeWidth: 1,
                  ),
                ),
                borderData: FlBorderData(show: false),
                barGroups: data.asMap().entries.map((entry) {
                  final i = entry.key;
                  final d = entry.value;
                  return BarChartGroupData(
                    x: i,
                    barsSpace: 3,
                    barRods: [
                      BarChartRodData(
                        toY: d.present,
                        color: const Color(0xFF10B981),
                        width: 9,
                        borderRadius: BorderRadius.circular(3),
                      ),
                      BarChartRodData(
                        toY: d.late,
                        color: const Color(0xFFFB923C),
                        width: 9,
                        borderRadius: BorderRadius.circular(3),
                      ),
                      BarChartRodData(
                        toY: d.absent,
                        color: const Color(0xFFEF4444),
                        width: 9,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _legendItem(String label, Color color, bool isDark) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 7,
          height: 7,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
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

// 2. Department Headcount Donut Chart
class DepartmentDistributionDonutChart extends StatelessWidget {
  final List<Department> departments;

  const DepartmentDistributionDonutChart({
    super.key,
    required this.departments,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final colors = [
      const Color(0xFF3B82F6), // blue
      const Color(0xFF10B981), // emerald
      const Color(0xFF8B5CF6), // purple
      const Color(0xFFF59E0B), // amber
      const Color(0xFF06B6D4), // cyan
    ];

    final total = departments.fold<int>(0, (sum, d) => sum + d.totalEmployees);

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
            children: [
              const Icon(Icons.pie_chart_rounded, size: 18, color: Color(0xFF3B82F6)),
              const SizedBox(width: 8),
              Text(
                'Headcount by Department',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              SizedBox(
                width: 120,
                height: 120,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    PieChart(
                      PieChartData(
                        sectionsSpace: 2,
                        centerSpaceRadius: 36,
                        sections: departments.asMap().entries.map((entry) {
                          final i = entry.key;
                          final dept = entry.value;
                          final color = colors[i % colors.length];
                          return PieChartSectionData(
                            value: dept.totalEmployees.toDouble(),
                            color: color,
                            radius: 18,
                            showTitle: false,
                          );
                        }).toList(),
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '$total',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: isDark ? Colors.white : const Color(0xFF0F172A),
                          ),
                        ),
                        Text(
                          'Staff',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 10,
                            color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: departments.asMap().entries.map((entry) {
                    final i = entry.key;
                    final dept = entry.value;
                    final color = colors[i % colors.length];
                    final pct = total > 0 ? (dept.totalEmployees / total * 100).toStringAsFixed(0) : '0';

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3),
                      child: Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              dept.name,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
                                color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            '${dept.totalEmployees} ($pct%)',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: isDark ? Colors.white70 : const Color(0xFF1E293B),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// 3. Monthly Payroll Expense Bar Chart
class PayrollExpenseChart extends StatelessWidget {
  const PayrollExpenseChart({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final months = ['Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep (Est)'];
    final amounts = [12.8, 13.2, 13.9, 14.3, 14.85, 15.2]; // in Lacs

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
              Row(
                children: [
                  const Icon(Icons.receipt_long_rounded, size: 18, color: Color(0xFF8B5CF6)),
                  const SizedBox(width: 8),
                  Text(
                    'Monthly Payroll Liability (INR Lacs)',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),
              Text(
                'FY 2026-27',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          SizedBox(
            height: 160,
            child: BarChart(
              BarChartData(
                maxY: 18,
                alignment: BarChartAlignment.spaceAround,
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 28,
                      interval: 6,
                      getTitlesWidget: (v, _) => Text(
                        '₹${v.toInt()}L',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 9.5,
                          color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                        ),
                      ),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (val, _) {
                        final idx = val.toInt();
                        if (idx >= 0 && idx < months.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(
                              months[idx],
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                              ),
                            ),
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 6,
                  getDrawingHorizontalLine: (v) => FlLine(
                    color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.04),
                    strokeWidth: 1,
                  ),
                ),
                borderData: FlBorderData(show: false),
                barGroups: amounts.asMap().entries.map((e) {
                  final isEst = e.key == amounts.length - 1;
                  return BarChartGroupData(
                    x: e.key,
                    barRods: [
                      BarChartRodData(
                        toY: e.value,
                        color: isEst ? const Color(0xFF8B5CF6).withValues(alpha: 0.4) : const Color(0xFF8B5CF6),
                        width: 18,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
