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

// ============================================================================
// 5. REVENUE & SALES TREND MULTI-LINE CHART
// ============================================================================
class ReportRevenueSalesTrendLineChart extends StatelessWidget {
  final List<RevenueSalesTrendPoint> points;

  const ReportRevenueSalesTrendLineChart({
    super.key,
    required this.points,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final spotsRevenue = points.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value.revenue)).toList();
    final spotsTarget = points.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value.target)).toList();
    final spotsPrevious = points.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value.previousRevenue)).toList();

    return SizedBox(
      height: 240,
      child: LineChart(
        LineChartData(
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (_) => isDark ? const Color(0xFF0F172A) : Colors.white,
              getTooltipItems: (touchedSpots) {
                return touchedSpots.map((spot) {
                  final idx = spot.spotIndex;
                  final pt = points[idx];
                  if (spot.barIndex == 0) {
                    return LineTooltipItem(
                      '${pt.dateLabel}\nRevenue: ₹${spot.y.toStringAsFixed(1)}L',
                      GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: const Color(0xFF6366F1)),
                    );
                  } else if (spot.barIndex == 1) {
                    return LineTooltipItem(
                      'Target: ₹${spot.y.toStringAsFixed(1)}L',
                      GoogleFonts.inter(fontSize: 10.5, fontWeight: FontWeight.w600, color: const Color(0xFF10B981)),
                    );
                  } else {
                    return LineTooltipItem(
                      'Prev Period: ₹${spot.y.toStringAsFixed(1)}L',
                      GoogleFonts.inter(fontSize: 10, color: isDark ? Colors.white60 : Colors.black54),
                    );
                  }
                }).toList();
              },
            ),
          ),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 40,
            getDrawingHorizontalLine: (_) => FlLine(
              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
              strokeWidth: 1,
            ),
          ),
          titlesData: FlTitlesData(
            show: true,
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 34,
                interval: 40,
                getTitlesWidget: (val, meta) => Text(
                  '₹${val.toInt()}L',
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
                  final idx = val.toInt();
                  if (idx >= 0 && idx < points.length) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        points[idx].dateLabel,
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          minY: 80,
          maxY: 200,
          lineBarsData: [
            LineChartBarData(
              spots: spotsRevenue,
              isCurved: true,
              color: const Color(0xFF6366F1),
              barWidth: 2.5,
              dotData: const FlDotData(show: true),
              belowBarData: BarAreaData(
                show: true,
                color: const Color(0xFF6366F1).withValues(alpha: isDark ? 0.2 : 0.08),
              ),
            ),
            LineChartBarData(
              spots: spotsTarget,
              isCurved: true,
              color: const Color(0xFF10B981),
              barWidth: 1.8,
              dashArray: [5, 4],
              dotData: const FlDotData(show: false),
            ),
            LineChartBarData(
              spots: spotsPrevious,
              isCurved: true,
              color: isDark ? const Color(0xFF475569) : const Color(0xFF94A3B8),
              barWidth: 1.5,
              dotData: const FlDotData(show: false),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// 6. PROJECT HEALTH DONUT CHART
// ============================================================================
class ReportProjectHealthDonutChart extends StatelessWidget {
  final ProjectHealthDistribution distribution;

  const ReportProjectHealthDonutChart({
    super.key,
    required this.distribution,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final total = distribution.total;

    return Row(
      children: [
        Expanded(
          flex: 5,
          child: SizedBox(
            height: 160,
            child: PieChart(
              PieChartData(
                sectionsSpace: 2,
                centerSpaceRadius: 32,
                sections: [
                  PieChartSectionData(value: distribution.onTrack.toDouble(), color: const Color(0xFF10B981), radius: 20, showTitle: false),
                  PieChartSectionData(value: distribution.atRisk.toDouble(), color: const Color(0xFFF59E0B), radius: 20, showTitle: false),
                  PieChartSectionData(value: distribution.delayed.toDouble(), color: const Color(0xFFEF4444), radius: 20, showTitle: false),
                  PieChartSectionData(value: distribution.critical.toDouble(), color: const Color(0xFF7F1D1D), radius: 20, showTitle: false),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          flex: 6,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _item('On Track', distribution.onTrack, total, const Color(0xFF10B981), isDark),
              const SizedBox(height: 5),
              _item('At Risk', distribution.atRisk, total, const Color(0xFFF59E0B), isDark),
              const SizedBox(height: 5),
              _item('Delayed', distribution.delayed, total, const Color(0xFFEF4444), isDark),
              const SizedBox(height: 5),
              _item('Critical', distribution.critical, total, const Color(0xFF7F1D1D), isDark),
            ],
          ),
        ),
      ],
    );
  }

  Widget _item(String label, int count, int total, Color color, bool isDark) {
    final pct = total > 0 ? ((count / total) * 100).toStringAsFixed(0) : '0';
    return Row(
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 11,
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
            ),
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
// 7. SALES AGING HORIZONTAL BAR CHART
// ============================================================================
class ReportSalesAgingBarChart extends StatelessWidget {
  final List<SalesAgingBucket> buckets;

  const ReportSalesAgingBarChart({
    super.key,
    required this.buckets,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: buckets.map((b) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Flexible(
                          child: Text(
                            b.ageRange,
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: isDark ? Colors.white : AppColors.lightTextPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (b.isStale) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEF4444).withValues(alpha: 0.15),
                              borderRadius: AppRadius.xs,
                            ),
                            child: Text(
                              'STALE',
                              style: GoogleFonts.inter(fontSize: 8.5, fontWeight: FontWeight.w700, color: const Color(0xFFEF4444)),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${b.dealCount} deals • ₹${b.pipelineValueLakhs.toStringAsFixed(1)}L',
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: b.color,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              ClipRRect(
                borderRadius: BorderRadius.circular(3),
                child: LinearProgressIndicator(
                  value: (b.dealCount / 100).clamp(0.05, 1.0),
                  backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
                  valueColor: AlwaysStoppedAnimation<Color>(b.color),
                  minHeight: 6,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

// ============================================================================
// 10. FINANCE REVENUE VS EXPENSE TREND MULTI-LINE CHART (SCREEN 06)
// ============================================================================
class ReportFinanceRevExpTrendChart extends StatelessWidget {
  final List<FinanceRevenueExpenseTrendPoint> points;
  final String granularity;
  final ValueChanged<String>? onGranularityChanged;

  const ReportFinanceRevExpTrendChart({
    super.key,
    required this.points,
    this.granularity = 'Monthly',
    this.onGranularityChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
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
          LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 620;

              final titleContent = Row(
                children: [
                  const Icon(Icons.analytics_rounded, size: 16, color: Color(0xFF10B981)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Revenue vs Expense & Profitability Trend',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: isDark ? Colors.white : AppColors.lightTextPrimary,
                          ),
                        ),
                        Text(
                          'Gross Inflows, Operational Outflows and Net Margin over reporting periods',
                          style: GoogleFonts.inter(
                            fontSize: 10.5,
                            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );

              Widget? selectorContent;
              if (onGranularityChanged != null) {
                selectorContent = Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                    borderRadius: AppRadius.sm,
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: ['Daily', 'Weekly', 'Monthly', 'Quarterly'].map((g) {
                        final isSelected = granularity == g;
                        return InkWell(
                          onTap: () => onGranularityChanged!(g),
                          borderRadius: AppRadius.xs,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: isSelected ? (isDark ? AppColors.primary : Colors.white) : Colors.transparent,
                              borderRadius: AppRadius.xs,
                              boxShadow: isSelected && !isDark ? [
                                BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 2, offset: const Offset(0, 1))
                              ] : null,
                            ),
                            child: Text(
                              g,
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                color: isSelected
                                    ? (isDark ? Colors.white : AppColors.primary)
                                    : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                );
              }

              if (isNarrow) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    titleContent,
                    if (selectorContent != null) ...[
                      const SizedBox(height: 10),
                      selectorContent,
                    ],
                  ],
                );
              }

              return Row(
                children: [
                  Expanded(child: titleContent),
                  if (selectorContent != null) ...[
                    const SizedBox(width: 12),
                    selectorContent,
                  ],
                ],
              );
            },
          ),
          const SizedBox(height: 12),
          // Legend
          Wrap(
            spacing: 14,
            runSpacing: 6,
            children: [
              _buildLegend(const Color(0xFF10B981), 'Revenue (Lakhs)', isDark),
              _buildLegend(const Color(0xFFEF4444), 'Expenses (Lakhs)', isDark),
              _buildLegend(const Color(0xFF6366F1), 'Net Profit (Lakhs)', isDark),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 220,
            child: LineChart(
              LineChartData(
                minY: 0,
                maxY: 220,
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipColor: (_) => isDark ? const Color(0xFF0F172A) : Colors.white,
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((spot) {
                        final idx = spot.spotIndex;
                        final p = idx < points.length ? points[idx] : null;
                        final label = spot.barIndex == 0 ? 'Rev' : (spot.barIndex == 1 ? 'Exp' : 'Profit');
                        final color = spot.barIndex == 0 ? const Color(0xFF10B981) : (spot.barIndex == 1 ? const Color(0xFFEF4444) : const Color(0xFF6366F1));
                        return LineTooltipItem(
                          '${p?.periodLabel ?? ''} $label: ₹${spot.y.toStringAsFixed(1)}L',
                          GoogleFonts.jetBrainsMono(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w600,
                            color: color,
                          ),
                        );
                      }).toList();
                    },
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (val) => FlLine(
                    color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                    strokeWidth: 1,
                  ),
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 38,
                      getTitlesWidget: (val, meta) {
                        if (val % 50 != 0) return const SizedBox.shrink();
                        return Text(
                          '₹${val.toInt()}L',
                          style: GoogleFonts.inter(
                            fontSize: 9.5,
                            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                          ),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (val, meta) {
                        final idx = val.toInt();
                        if (idx >= 0 && idx < points.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(
                              points[idx].periodLabel,
                              style: GoogleFonts.inter(
                                fontSize: 9.5,
                                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                              ),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  // Revenue
                  LineChartBarData(
                    spots: points.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value.revenue)).toList(),
                    isCurved: true,
                    color: const Color(0xFF10B981),
                    barWidth: 2.5,
                    dotData: const FlDotData(show: true),
                    belowBarData: BarAreaData(
                      show: true,
                      color: const Color(0xFF10B981).withValues(alpha: isDark ? 0.12 : 0.06),
                    ),
                  ),
                  // Expenses
                  LineChartBarData(
                    spots: points.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value.expenses)).toList(),
                    isCurved: true,
                    color: const Color(0xFFEF4444),
                    barWidth: 2,
                    dotData: const FlDotData(show: false),
                  ),
                  // Net Profit
                  LineChartBarData(
                    spots: points.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value.netProfit)).toList(),
                    isCurved: true,
                    color: const Color(0xFF6366F1),
                    barWidth: 2,
                    dashArray: [4, 4],
                    dotData: const FlDotData(show: false),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegend(Color color, String label, bool isDark) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// 11. RECEIVABLES AGING HORIZONTAL BAR CHART (SCREEN 06)
// ============================================================================
class ReportReceivablesAgingBarChart extends StatelessWidget {
  final List<FinanceAgingBucket> buckets;
  final ValueChanged<FinanceAgingBucket>? onBucketTap;

  const ReportReceivablesAgingBarChart({
    super.key,
    required this.buckets,
    this.onBucketTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: buckets.map((b) {
        return InkWell(
          onTap: onBucketTap != null ? () => onBucketTap!(b) : null,
          borderRadius: AppRadius.sm,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        b.label,
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white : AppColors.lightTextPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        '₹${(b.amount / 100000).toStringAsFixed(1)}L (${b.percentage.toStringAsFixed(1)}%) • ${b.invoiceCount} Inv',
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w600,
                          color: b.color,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: (b.percentage / 100).clamp(0.02, 1.0),
                    backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
                    valueColor: AlwaysStoppedAnimation<Color>(b.color),
                    minHeight: 8,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ============================================================================
// 12. HR HEADCOUNT TREND BAR CHART (SCREEN 07)
// ============================================================================
class ReportHrHeadcountBarChart extends StatelessWidget {
  final List<HrHeadcountTrendPoint> trend;

  const ReportHrHeadcountBarChart({super.key, required this.trend});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      height: 200,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: 200,
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              getTooltipColor: (_) => isDark ? const Color(0xFF0F172A) : Colors.white,
            ),
          ),
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 28,
                getTitlesWidget: (val, meta) {
                  if (val % 50 != 0) return const SizedBox.shrink();
                  return Text(
                    '${val.toInt()}',
                    style: GoogleFonts.inter(
                      fontSize: 9.5,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    ),
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (val, meta) {
                  final idx = val.toInt();
                  if (idx >= 0 && idx < trend.length) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        trend[idx].monthLabel,
                        style: GoogleFonts.inter(
                          fontSize: 9.5,
                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            getDrawingHorizontalLine: (val) => FlLine(
              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
              strokeWidth: 1,
            ),
          ),
          borderData: FlBorderData(show: false),
          barGroups: trend.asMap().entries.map((e) {
            return BarChartGroupData(
              x: e.key,
              barRods: [
                BarChartRodData(
                  toY: e.value.closingHeadcount.toDouble(),
                  color: const Color(0xFF6366F1),
                  width: 14,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(3)),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}

// ============================================================================
// 13. SERVICE WORKLOAD TREND CHART (SCREEN 08)
// ============================================================================
class ReportServiceWorkloadChart extends StatelessWidget {
  final List<ServiceWorkloadTrendPoint> points;

  const ReportServiceWorkloadChart({super.key, required this.points});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      height: 200,
      child: LineChart(
        LineChartData(
          minY: 0,
          maxY: 400,
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (_) => isDark ? const Color(0xFF0F172A) : Colors.white,
            ),
          ),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            getDrawingHorizontalLine: (val) => FlLine(
              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
              strokeWidth: 1,
            ),
          ),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 32,
                getTitlesWidget: (val, meta) {
                  if (val % 100 != 0) return const SizedBox.shrink();
                  return Text(
                    '${val.toInt()}',
                    style: GoogleFonts.inter(
                      fontSize: 9.5,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    ),
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (val, meta) {
                  final idx = val.toInt();
                  if (idx >= 0 && idx < points.length) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        points[idx].periodLabel,
                        style: GoogleFonts.inter(
                          fontSize: 9.5,
                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            // Completed
            LineChartBarData(
              spots: points.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value.completed.toDouble())).toList(),
              isCurved: true,
              color: const Color(0xFF10B981),
              barWidth: 2.5,
              dotData: const FlDotData(show: true),
            ),
            // In Progress
            LineChartBarData(
              spots: points.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value.inProgress.toDouble())).toList(),
              isCurved: true,
              color: const Color(0xFFF59E0B),
              barWidth: 2,
              dotData: const FlDotData(show: false),
            ),
            // Overdue
            LineChartBarData(
              spots: points.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value.overdue.toDouble())).toList(),
              isCurved: true,
              color: const Color(0xFFEF4444),
              barWidth: 1.8,
              dashArray: [3, 3],
              dotData: const FlDotData(show: false),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// 14. CUSTOMER 5-STAR RATING DISTRIBUTION CHART (SCREEN 09)
// ============================================================================
class ReportCustomerRatingBarChart extends StatelessWidget {
  final List<FeedbackRatingBreakdown> ratings;

  const ReportCustomerRatingBarChart({super.key, required this.ratings});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: ratings.map((r) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              SizedBox(
                width: 50,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${r.stars}',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : AppColors.lightTextPrimary,
                      ),
                    ),
                    const SizedBox(width: 3),
                    const Icon(Icons.star_rounded, size: 14, color: Color(0xFFF59E0B)),
                  ],
                ),
              ),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: (r.percentage / 100).clamp(0.01, 1.0),
                    backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
                    valueColor: AlwaysStoppedAnimation<Color>(r.color),
                    minHeight: 7,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
                width: 65,
                child: Text(
                  '${r.count} (${r.percentage.toStringAsFixed(0)}%)',
                  textAlign: TextAlign.end,
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

// ============================================================================
// 15. GOALS STATUS DONUT PIE CHART (SCREEN 10)
// ============================================================================
class ReportGoalStatusDonutChart extends StatelessWidget {
  final List<GoalStatusDistributionItem> distribution;

  const ReportGoalStatusDonutChart({super.key, required this.distribution});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: [
        SizedBox(
          width: 110,
          height: 110,
          child: PieChart(
            PieChartData(
              sectionsSpace: 2,
              centerSpaceRadius: 32,
              sections: distribution.map((d) {
                return PieChartSectionData(
                  color: d.color,
                  value: d.count.toDouble(),
                  title: '',
                  radius: 16,
                );
              }).toList(),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: distribution.map((d) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 2.5),
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(color: d.color, shape: BoxShape.circle),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        d.status,
                        style: GoogleFonts.inter(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w500,
                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        ),
                      ),
                    ),
                    Text(
                      '${d.count} (${d.percentage.toStringAsFixed(0)}%)',
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : AppColors.lightTextPrimary,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
