import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../models/reports_mock_data.dart';
import '../models/reports_models.dart';
import '../widgets/reports_charts.dart';
import '../widgets/reports_common_widgets.dart';
import '../widgets/reports_controls_bar.dart';
import '../widgets/reports_drilldown_modal.dart';
import '../widgets/reports_export_dialog.dart';
import '../widgets/reports_filter_drawer.dart';

/// Screen 1: Executive Overview Analytics Screen.
/// Provides C-Suite and Management leadership with high-level visibility across
/// Revenue, Sales Velocity, Project Delivery Health, Escrow Collections, Marketing Acquisition,
/// and Operational Attention-Required Alerts.
class ReportsExecutiveOverviewPage extends StatefulWidget {
  const ReportsExecutiveOverviewPage({super.key});

  @override
  State<ReportsExecutiveOverviewPage> createState() => _ReportsExecutiveOverviewPageState();
}

class _ReportsExecutiveOverviewPageState extends State<ReportsExecutiveOverviewPage> {
  ReportFilterState _filterState = const ReportFilterState();
  String _trendGranularity = 'Monthly'; // 'Weekly', 'Monthly'
  bool _isLoading = false;

  void _handleRefresh() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 400));
    if (mounted) setState(() => _isLoading = false);
  }

  void _handleExport() {
    ReportsExportDialog.show(
      context,
      reportTitle: 'Executive Overview BI Report',
      dateRangeLabel: _filterState.dateFilter.label,
    );
  }

  void _handleOpenFilters() {
    ReportsFilterDrawer.show(
      context,
      initialFilter: _filterState,
      onApply: (updated) => setState(() => _filterState = updated),
    );
  }

  void _openDrilldown(String title, String category, String metricValue, List<Map<String, dynamic>> records) {
    ReportsDrilldownModal.show(
      context,
      title: title,
      category: category,
      metricValue: metricValue,
      records: records,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = width < 768;
    final isTablet = width >= 768 && width < 1100;
    final isLargeDesktop = width >= 1440;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 12 : 20,
            vertical: 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Global Unified Controls Toolbar
              ReportsControlsBar(
                title: 'Executive Overview',
                subtitle: 'Business performance, operational health, financial indicators, and key management insights',
                icon: Icons.dashboard_customize_rounded,
                filterState: _filterState,
                onFilterChanged: (val) => setState(() => _filterState = val),
                onOpenFilterDrawer: _handleOpenFilters,
                onRefresh: _handleRefresh,
                onExport: _handleExport,
                onSaveView: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Saved current executive dashboard view preset'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),

              if (_isLoading) ...[
                const SizedBox(height: 20),
                const ReportLoadingSkeleton(height: 140),
                const SizedBox(height: 18),
                const ReportLoadingSkeleton(height: 300),
              ] else ...[
                // 1. Executive High-Priority KPI Section
                _buildKpisSection(isMobile, isTablet, isLargeDesktop),
                const SizedBox(height: 18),

                // 2. Revenue & Sales Trend Section
                _buildRevenueSalesTrend(isDark, isMobile),
                const SizedBox(height: 18),

                // 3. Sales Pipeline Snapshot & Project Health (Side by side on desktop, stacked on mobile/tablet)
                if (isMobile || isTablet) ...[
                  _buildPipelineSnapshot(isDark),
                  const SizedBox(height: 18),
                  _buildProjectHealthSection(isDark),
                ] else ...[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 7, child: _buildPipelineSnapshot(isDark)),
                      const SizedBox(width: 16),
                      Expanded(flex: 5, child: _buildProjectHealthSection(isDark)),
                    ],
                  ),
                ],
                const SizedBox(height: 18),

                // 4. Financial Snapshot & Management Alerts
                if (isMobile || isTablet) ...[
                  _buildFinancialSnapshot(isDark),
                  const SizedBox(height: 18),
                  _buildManagementAlerts(isDark),
                ] else ...[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 6, child: _buildFinancialSnapshot(isDark)),
                      const SizedBox(width: 16),
                      Expanded(flex: 6, child: _buildManagementAlerts(isDark)),
                    ],
                  ),
                ],
                const SizedBox(height: 24),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================================================
  // 1. EXECUTIVE KPI GRID
  // ==========================================================================
  Widget _buildKpisSection(bool isMobile, bool isTablet, bool isLargeDesktop) {
    final kpis = ReportsMockData.executiveKpis;
    final crossAxisCount = isMobile ? 1 : (isTablet ? 2 : (isLargeDesktop ? 6 : 3));

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        mainAxisExtent: 132,
      ),
      itemCount: kpis.length,
      itemBuilder: (context, index) {
        final k = kpis[index];
        return EnterpriseKpiCard(
          title: k.title,
          value: k.value,
          previousValue: k.previousValue,
          growthPercent: k.growthPercent,
          isPositive: k.isPositive,
          targetText: k.target,
          targetProgress: k.targetAchievementPercent / 100.0,
          icon: k.icon,
          color: k.color,
          subtitle: 'vs ${k.previousValue} (${_filterState.comparisonPeriod.label})',
          onTap: () {
            _openDrilldown(
              k.title,
              k.category,
              k.value,
              [
                {'id': 'TRX-101', 'title': 'DLF Magnolias Milestone 4', 'subtitle': 'Client: Rahul Khurana • Paid via RTGS', 'amount': '₹4.2L', 'status': 'Cleared', 'statusColor': const Color(0xFF10B981)},
                {'id': 'TRX-102', 'title': 'Prestige Falcon City Booking Advance', 'subtitle': 'Client: Sanjay Dutt • 10% Escrow', 'amount': '₹1.8L', 'status': 'Cleared', 'statusColor': const Color(0xFF10B981)},
                {'id': 'TRX-103', 'title': 'Godrej Woods Phase 2 Token', 'subtitle': 'Client: Meenakshi Iyer • Escrow Released', 'amount': '₹2.5L', 'status': 'Pending Verification', 'statusColor': const Color(0xFFF59E0B)},
                {'id': 'TRX-104', 'title': 'Oberoi Sky City Modular Woodwork', 'subtitle': 'Client: Rajesh Khanna • Bank Transfer', 'amount': '₹3.4L', 'status': 'Cleared', 'statusColor': const Color(0xFF10B981)},
              ],
            );
          },
        );
      },
    );
  }

  // ==========================================================================
  // 2. REVENUE & SALES TREND
  // ==========================================================================
  Widget _buildRevenueSalesTrend(bool isDark, bool isMobile) {
    final points = _trendGranularity == 'Monthly'
        ? ReportsMockData.revenueSalesTrendMonthly
        : ReportsMockData.revenueSalesTrendWeekly;

    return ReportSectionContainer(
      title: 'Revenue & Sales Velocity Trends',
      subtitle: 'Comparative revenue trajectory, monthly quota targets, and previous period performance',
      icon: Icons.trending_up_rounded,
      iconColor: const Color(0xFF6366F1),
      trailing: Wrap(
        spacing: 6,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          // Legend badges
          _buildLegendChip('Revenue (Actual)', const Color(0xFF6366F1), isDark),
          _buildLegendChip('Target Line', const Color(0xFF10B981), isDark, isDashed: true),
          _buildLegendChip('Prev Period', isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8), isDark),
          const SizedBox(width: 4),

          // Granularity switch
          Container(
            height: 28,
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurfaceElevated : const Color(0xFFF1F5F9),
              borderRadius: AppRadius.sm,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: ['Weekly', 'Monthly'].map((gran) {
                final isSelected = _trendGranularity == gran;
                return GestureDetector(
                  onTap: () => setState(() => _trendGranularity = gran),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary : Colors.transparent,
                      borderRadius: AppRadius.xs,
                    ),
                    child: Text(
                      gran,
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: isSelected ? Colors.white : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
      child: ReportRevenueSalesTrendLineChart(points: points),
    );
  }

  Widget _buildLegendChip(String label, Color color, bool isDark, {bool isDashed = false}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: isDashed ? 2 : 3,
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2)),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 10,
            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
          ),
        ),
      ],
    );
  }

  // ==========================================================================
  // 3. SALES PIPELINE SNAPSHOT
  // ==========================================================================
  Widget _buildPipelineSnapshot(bool isDark) {
    final stages = ReportsMockData.executivePipelineStages;

    return ReportSectionContainer(
      title: 'Sales Pipeline Snapshot',
      subtitle: 'Active opportunities, stage-to-stage conversion, and weighted gross value',
      icon: Icons.account_tree_outlined,
      iconColor: const Color(0xFF3B82F6),
      trailing: Text(
        '₹14.7 Cr Total Pipeline',
        style: GoogleFonts.jetBrainsMono(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: const Color(0xFF3B82F6),
        ),
      ),
      child: Column(
        children: stages.map((stage) {
          return InkWell(
            onTap: () {
              _openDrilldown(
                '${stage.stageName} Opportunities',
                'Sales Pipeline',
                '${stage.opportunityCount} Deals • ₹${stage.pipelineValueLakhs.toStringAsFixed(1)}L',
                [
                  {'id': 'OPP-501', 'title': 'DLF Cybercity Luxury 3BHK', 'subtitle': 'Owner: Aarav Singhania • Token token advance pending', 'amount': '₹12.4L', 'status': stage.stageName, 'statusColor': stage.color},
                  {'id': 'OPP-502', 'title': 'Whitefield Prestige Villa Turnkey', 'subtitle': 'Owner: Pooja Hegde • 3D concepts presented', 'amount': '₹16.8L', 'status': stage.stageName, 'statusColor': stage.color},
                  {'id': 'OPP-503', 'title': 'Indiranagar Penthouse Modular Kitchen', 'subtitle': 'Owner: Rohan Deshmukh • Quote revision requested', 'amount': '₹8.5L', 'status': stage.stageName, 'statusColor': stage.color},
                ],
              );
            },
            borderRadius: AppRadius.sm,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(color: stage.color, shape: BoxShape.circle),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                stage.stageName,
                                style: GoogleFonts.inter(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w600,
                                  color: isDark ? Colors.white : AppColors.lightTextPrimary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${stage.opportunityCount} deals • ₹${stage.pipelineValueLakhs.toStringAsFixed(1)}L (${stage.stageToStageConversion.toStringAsFixed(0)}%)',
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: stage.color,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(3),
                    child: LinearProgressIndicator(
                      value: (stage.conversionRate / 100.0).clamp(0.04, 1.0),
                      backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
                      valueColor: AlwaysStoppedAnimation<Color>(stage.color),
                      minHeight: 5,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ==========================================================================
  // 4. PROJECT HEALTH DASHBOARD
  // ==========================================================================
  Widget _buildProjectHealthSection(bool isDark) {
    const distribution = ReportsMockData.executionHealthDistribution;
    final projects = ReportsMockData.executiveProjectHealthList;

    return ReportSectionContainer(
      title: 'Active Projects Health',
      subtitle: 'Execution status, milestone progress, and budget compliance tracking',
      icon: Icons.construction_rounded,
      iconColor: const Color(0xFF10B981),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Donut distribution
          const ReportProjectHealthDonutChart(distribution: distribution),
          const SizedBox(height: 14),
          const Divider(height: 1),
          const SizedBox(height: 10),

          // Project Mini List
          Text(
            'Critical Active Sites',
            style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Column(
            children: projects.map((p) {
              return Container(
                margin: const EdgeInsets.only(bottom: 6),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurfaceElevated : const Color(0xFFF8FAFC),
                  borderRadius: AppRadius.sm,
                  border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            p.projectName,
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: isDark ? Colors.white : AppColors.lightTextPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            'PM: ${p.projectManager} • Target: ${p.expectedCompletion}',
                            style: GoogleFonts.inter(
                              fontSize: 9.5,
                              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    ReportStatusBadge(label: p.scheduleStatus, color: p.statusColor),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // ==========================================================================
  // 5. FINANCIAL SNAPSHOT
  // ==========================================================================
  Widget _buildFinancialSnapshot(bool isDark) {
    final items = ReportsMockData.financialSnapshotItems;

    return ReportSectionContainer(
      title: 'Operational Financial Health',
      subtitle: 'Gross revenue, material COGS, vendor payables, and net escrow float',
      icon: Icons.account_balance_wallet_outlined,
      iconColor: const Color(0xFF0D9488),
      child: Column(
        children: items.map((item) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.category,
                        style: GoogleFonts.inter(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white : AppColors.lightTextPrimary,
                        ),
                      ),
                      Text(
                        item.note,
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '₹${item.currentLakhs.toStringAsFixed(1)}L',
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : AppColors.lightTextPrimary,
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          item.isPositive ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
                          size: 10,
                          color: item.isPositive ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                        ),
                        Text(
                          '${item.changePercent.abs().toStringAsFixed(1)}%',
                          style: GoogleFonts.inter(
                            fontSize: 9.5,
                            fontWeight: FontWeight.w600,
                            color: item.isPositive ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  // ==========================================================================
  // 6. MANAGEMENT ALERTS ("ATTENTION REQUIRED")
  // ==========================================================================
  Widget _buildManagementAlerts(bool isDark) {
    final alerts = ReportsMockData.managementAlerts;

    return ReportSectionContainer(
      title: 'Attention Required (Operational Triage)',
      subtitle: 'Critical project delays, high-value stuck deals, and collection escalations',
      icon: Icons.notification_important_outlined,
      iconColor: const Color(0xFFEF4444),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: const Color(0xFFEF4444).withValues(alpha: 0.15),
          borderRadius: AppRadius.full,
        ),
        child: Text(
          '${alerts.length} Active Alerts',
          style: GoogleFonts.inter(
            fontSize: 9.5,
            fontWeight: FontWeight.w700,
            color: const Color(0xFFEF4444),
          ),
        ),
      ),
      child: Column(
        children: alerts.map((a) {
          final isCritical = a.severity == 'Critical';
          final badgeColor = isCritical
              ? const Color(0xFFEF4444)
              : (a.severity == 'Warning' ? const Color(0xFFF59E0B) : const Color(0xFF3B82F6));

          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurfaceElevated : const Color(0xFFF8FAFC),
              borderRadius: AppRadius.sm,
              border: Border.all(
                color: isCritical
                    ? const Color(0xFFEF4444).withValues(alpha: 0.4)
                    : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ReportStatusBadge(label: a.severity.toUpperCase(), color: badgeColor),
                    Text(
                      a.date,
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  a.title,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : AppColors.lightTextPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  a.description,
                  style: GoogleFonts.inter(
                    fontSize: 10.5,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: isDark ? 0.15 : 0.06),
                    borderRadius: AppRadius.xs,
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.bolt_rounded, size: 12, color: AppColors.primary),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          'Action: ${a.recommendedAction}',
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
