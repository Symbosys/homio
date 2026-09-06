import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../models/reports_models.dart';

// ============================================================================
// 1. SOCIAL MEDIA REACH & CHANNEL GROWTH BAR CHART
// ============================================================================
class ReportSocialGrowthBarChart extends StatelessWidget {
  const ReportSocialGrowthBarChart({super.key});

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
        children: [
          Row(
            children: [
              const Icon(Icons.share_rounded, size: 16, color: Color(0xFFEC4899)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Social Reach & Channel Engagement',
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
                  color: const Color(0xFFEC4899).withValues(alpha: isDark ? 0.2 : 0.1),
                  borderRadius: AppRadius.full,
                ),
                child: Text(
                  '+28.4% MoM',
                  style: GoogleFonts.inter(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFFEC4899),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Expanded(
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 120,
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (_) => isDark ? const Color(0xFF0F172A) : Colors.white,
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 28,
                      interval: 30,
                      getTitlesWidget: (val, meta) => Text(
                        '${val.toInt()}k',
                        style: GoogleFonts.inter(
                          fontSize: 9.5,
                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        ),
                      ),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (val, meta) {
                        const platforms = ['Instagram', 'YouTube', 'Pinterest', 'LinkedIn'];
                        final text = (val.toInt() >= 0 && val.toInt() < platforms.length)
                            ? platforms[val.toInt()]
                            : '';
                        return Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            text,
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 30,
                  getDrawingHorizontalLine: (val) => FlLine(
                    color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                    strokeWidth: 1,
                  ),
                ),
                borderData: FlBorderData(show: false),
                barGroups: [
                  _makeBar(0, 98, const Color(0xFFE1306C)), // Instagram
                  _makeBar(1, 64, const Color(0xFFFF0000)), // YouTube
                  _makeBar(2, 42, const Color(0xFFE60023)), // Pinterest
                  _makeBar(3, 28, const Color(0xFF0A66C2)), // LinkedIn
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  BarChartGroupData _makeBar(int x, double y, Color color) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: color,
          width: 22,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
        ),
      ],
    );
  }
}

// ============================================================================
// 2. SALES OBJECTIONS & DECLINING REASONS HORIZONTAL / GROUPED BAR CHART
// ============================================================================
class ReportObjectionsBarChart extends StatelessWidget {
  final List<SalesObjectionItem> objections;

  const ReportObjectionsBarChart({
    super.key,
    required this.objections,
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
        children: [
          Row(
            children: [
              const Icon(Icons.pie_chart_outline_rounded, size: 16, color: Color(0xFFEF4444)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Primary Client Objections & Drop-offs',
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
                  color: const Color(0xFFEF4444).withValues(alpha: isDark ? 0.2 : 0.1),
                  borderRadius: AppRadius.full,
                ),
                child: Text(
                  '169 Inquiries',
                  style: GoogleFonts.inter(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFFEF4444),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: objections.length,
              separatorBuilder: (_, _) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final obj = objections[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            obj.objectionName,
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: isDark ? Colors.white : AppColors.lightTextPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          '${obj.count} (${obj.percentage.toStringAsFixed(1)}%)',
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w700,
                            color: obj.color,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Stack(
                      children: [
                        Container(
                          height: 5,
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                        FractionallySizedBox(
                          widthFactor: (obj.percentage / 100.0).clamp(0.02, 1.0),
                          child: Container(
                            height: 5,
                            decoration: BoxDecoration(
                              color: obj.color,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// 3. EXECUTION PROJECTS BY STAGE DONUT CHART
// ============================================================================
class ReportExecutionStageDonutChart extends StatelessWidget {
  final int civil;
  final int woodwork;
  final int electrical;
  final int finishing;
  final int handover;

  const ReportExecutionStageDonutChart({
    super.key,
    this.civil = 6,
    this.woodwork = 11,
    this.electrical = 4,
    this.finishing = 5,
    this.handover = 2,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final total = civil + woodwork + electrical + finishing + handover;

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
        children: [
          Row(
            children: [
              const Icon(Icons.donut_large_rounded, size: 16, color: Color(0xFF3B82F6)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Sites By Execution Stage',
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
                  color: const Color(0xFF3B82F6).withValues(alpha: isDark ? 0.2 : 0.1),
                  borderRadius: AppRadius.full,
                ),
                child: Text(
                  '$total Active Sites',
                  style: GoogleFonts.inter(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF3B82F6),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  flex: 5,
                  child: PieChart(
                    PieChartData(
                      sectionsSpace: 2,
                      centerSpaceRadius: 36,
                      sections: [
                        PieChartSectionData(value: woodwork.toDouble(), color: const Color(0xFF3B82F6), radius: 24, showTitle: false),
                        PieChartSectionData(value: civil.toDouble(), color: const Color(0xFF10B981), radius: 24, showTitle: false),
                        PieChartSectionData(value: finishing.toDouble(), color: const Color(0xFFF59E0B), radius: 24, showTitle: false),
                        PieChartSectionData(value: electrical.toDouble(), color: const Color(0xFF8B5CF6), radius: 24, showTitle: false),
                        PieChartSectionData(value: handover.toDouble(), color: const Color(0xFF06B6D4), radius: 24, showTitle: false),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 6,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _legendRow('Woodwork', woodwork, total, const Color(0xFF3B82F6), isDark),
                      const SizedBox(height: 4),
                      _legendRow('Civil / POP', civil, total, const Color(0xFF10B981), isDark),
                      const SizedBox(height: 4),
                      _legendRow('Finishing', finishing, total, const Color(0xFFF59E0B), isDark),
                      const SizedBox(height: 4),
                      _legendRow('Electrical', electrical, total, const Color(0xFF8B5CF6), isDark),
                      const SizedBox(height: 4),
                      _legendRow('Handover', handover, total, const Color(0xFF06B6D4), isDark),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _legendRow(String label, int count, int total, Color color, bool isDark) {
    final pct = ((count / total) * 100).toStringAsFixed(0);
    return Row(
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 10.5,
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Text(
          '$count ($pct%)',
          style: GoogleFonts.jetBrainsMono(
            fontSize: 10.5,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white : AppColors.lightTextPrimary,
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// 4. FINANCIAL OUTFLOW DONUT CHART
// ============================================================================
class ReportFinancialOutflowDonutChart extends StatelessWidget {
  final double material; // in Lakhs
  final double labour;
  final double design;
  final double consulting;

  const ReportFinancialOutflowDonutChart({
    super.key,
    this.material = 42.8,
    this.labour = 18.4,
    this.design = 6.2,
    this.consulting = 3.1,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final total = material + labour + design + consulting;

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
        children: [
          Row(
            children: [
              const Icon(Icons.payments_rounded, size: 16, color: Color(0xFF10B981)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Expense & Disbursement Allocation',
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
                ),
                child: Text(
                  '₹${total.toStringAsFixed(1)}L Outflow',
                  style: GoogleFonts.inter(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF10B981),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  flex: 5,
                  child: PieChart(
                    PieChartData(
                      sectionsSpace: 2,
                      centerSpaceRadius: 36,
                      sections: [
                        PieChartSectionData(value: material, color: const Color(0xFF3B82F6), radius: 24, showTitle: false),
                        PieChartSectionData(value: labour, color: const Color(0xFF10B981), radius: 24, showTitle: false),
                        PieChartSectionData(value: design, color: const Color(0xFF8B5CF6), radius: 24, showTitle: false),
                        PieChartSectionData(value: consulting, color: const Color(0xFFF59E0B), radius: 24, showTitle: false),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 6,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _legendItem('Material', material, total, const Color(0xFF3B82F6), isDark),
                      const SizedBox(height: 4),
                      _legendItem('Labour & Trade', labour, total, const Color(0xFF10B981), isDark),
                      const SizedBox(height: 4),
                      _legendItem('Design Fees', design, total, const Color(0xFF8B5CF6), isDark),
                      const SizedBox(height: 4),
                      _legendItem('Consulting/Vastu', consulting, total, const Color(0xFFF59E0B), isDark),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _legendItem(String label, double amount, double total, Color color, bool isDark) {
    final pct = ((amount / total) * 100).toStringAsFixed(1);
    return Row(
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 10.5,
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Text(
          '₹${amount.toStringAsFixed(1)}L ($pct%)',
          style: GoogleFonts.jetBrainsMono(
            fontSize: 10.5,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white : AppColors.lightTextPrimary,
          ),
        ),
      ],
    );
  }
}
