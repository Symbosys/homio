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

/// Screen 3: Sales Analytics Screen.
/// Provides sales leaders and managers with full visibility into pipeline velocity,
/// stage conversion, pipeline aging buckets, sales team productivity leaderboards,
/// revenue forecasting vs quota, top deal tracking, and lost deal reason telemetry.
class ReportsSalesPage extends StatefulWidget {
  const ReportsSalesPage({super.key});

  @override
  State<ReportsSalesPage> createState() => _ReportsSalesPageState();
}

class _ReportsSalesPageState extends State<ReportsSalesPage> {
  ReportFilterState _filterState = const ReportFilterState();
  bool _isLoading = false;
  String _sortColumn = 'revenue'; // 'revenue', 'winRate', 'wonDeals'
  bool _isAscending = false;

  void _handleRefresh() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 400));
    if (mounted) setState(() => _isLoading = false);
  }

  void _handleExport() {
    ReportsExportDialog.show(
      context,
      reportTitle: 'Sales Performance & Quota Attainment Report',
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
              // Header Controls Bar
              ReportsControlsBar(
                title: 'Sales Analytics',
                subtitle: 'Analyze pipeline health, sales performance, conversions, revenue, and team productivity',
                icon: Icons.point_of_sale_rounded,
                filterState: _filterState,
                onFilterChanged: (val) => setState(() => _filterState = val),
                onOpenFilterDrawer: _handleOpenFilters,
                onRefresh: _handleRefresh,
                onExport: _handleExport,
              ),

              if (_isLoading) ...[
                const SizedBox(height: 20),
                const ReportLoadingSkeleton(height: 140),
                const SizedBox(height: 18),
                const ReportLoadingSkeleton(height: 320),
              ] else ...[
                // 1. Sales KPI Cards Grid (12 Metrics)
                _buildKpisSection(isMobile, isTablet, isLargeDesktop),
                const SizedBox(height: 18),

                // 2. Revenue Forecast vs Quota Target Banner
                _buildForecastBanner(isDark, isMobile),
                const SizedBox(height: 18),

                // 3. Pipeline Stages & Aging Analysis (Side-by-side on desktop)
                if (isMobile || isTablet) ...[
                  _buildPipelineStagesSection(isDark),
                  const SizedBox(height: 18),
                  _buildPipelineAgingSection(isDark),
                ] else ...[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 7, child: _buildPipelineStagesSection(isDark)),
                      const SizedBox(width: 16),
                      Expanded(flex: 5, child: _buildPipelineAgingSection(isDark)),
                    ],
                  ),
                ],
                const SizedBox(height: 18),

                // 4. Sales Team Performance Leaderboard Table
                _buildTeamPerformanceTable(isDark, isMobile),
                const SizedBox(height: 18),

                // 5. Top Deals & Lost Deal Analysis (Side-by-side on desktop)
                if (isMobile || isTablet) ...[
                  _buildTopDealsSection(isDark, isMobile),
                  const SizedBox(height: 18),
                  _buildLostDealsSection(isDark),
                ] else ...[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 7, child: _buildTopDealsSection(isDark, isMobile)),
                      const SizedBox(width: 16),
                      Expanded(flex: 5, child: _buildLostDealsSection(isDark)),
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
  // 1. SALES KPIS SECTION
  // ==========================================================================
  Widget _buildKpisSection(bool isMobile, bool isTablet, bool isLargeDesktop) {
    final kpis = ReportsMockData.salesKpis;
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
          growthPercent: 12.4,
          isPositive: k.isPositive,
          targetText: k.subtitle,
          targetProgress: k.targetProgress,
          icon: k.icon,
          color: k.color,
          onTap: () {
            _openDrilldown(
              k.title,
              'Sales Telemetry',
              k.value,
              [
                {'id': 'OPP-801', 'title': 'Rahul Khurana (DLF Magnolias)', 'subtitle': 'Owner: Aarav Singhania • Final Token Token Advance', 'amount': '₹18.5L', 'status': 'Won Deal', 'statusColor': const Color(0xFF10B981)},
                {'id': 'OPP-802', 'title': 'Sanjay Dutt (Prestige Falcon City)', 'subtitle': 'Owner: Pooja Hegde • 3D concepts signed', 'amount': '₹14.2L', 'status': 'In Proposal', 'statusColor': const Color(0xFF3B82F6)},
                {'id': 'OPP-803', 'title': 'Meenakshi Iyer (Godrej Woods)', 'subtitle': 'Owner: Rohan Deshmukh • Quote approved', 'amount': '₹8.8L', 'status': 'Qualified', 'statusColor': const Color(0xFF0EA5E9)},
              ],
            );
          },
        );
      },
    );
  }

  // ==========================================================================
  // 2. REVENUE FORECAST VS QUOTA TARGET BANNER
  // ==========================================================================
  Widget _buildForecastBanner(bool isDark, bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: AppRadius.md,
        border: Border.all(color: const Color(0xFF6366F1).withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    const Icon(Icons.track_changes_rounded, size: 16, color: Color(0xFF6366F1)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Monthly Revenue Quota Forecast (Commit vs Pipeline)',
                        style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: isDark ? Colors.white : AppColors.lightTextPrimary),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: 0.15),
                  borderRadius: AppRadius.full,
                ),
                child: Text(
                  '107% Quota Pacing',
                  style: GoogleFonts.inter(fontSize: 9.5, fontWeight: FontWeight.w700, color: const Color(0xFF10B981)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 16,
            runSpacing: 10,
            alignment: WrapAlignment.spaceBetween,
            children: [
              _buildForecastStat('Target Quota', '₹2.00 Cr', const Color(0xFF64748B), isDark),
              _buildForecastStat('Closed Won', '₹1.84 Cr', const Color(0xFF10B981), isDark),
              _buildForecastStat('Weighted Commit', '₹0.31 Cr', const Color(0xFF3B82F6), isDark),
              _buildForecastStat('Best Case', '₹2.45 Cr', const Color(0xFF8B5CF6), isDark),
              _buildForecastStat('Projected Surplus', '+₹0.15 Cr', const Color(0xFF10B981), isDark),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: Row(
              children: [
                Expanded(flex: 92, child: Container(height: 7, color: const Color(0xFF10B981))),
                Expanded(flex: 15, child: Container(height: 7, color: const Color(0xFF3B82F6))),
                Expanded(flex: 10, child: Container(height: 7, color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForecastStat(String label, String value, Color color, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.inter(fontSize: 10, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
        const SizedBox(height: 1),
        Text(value, style: GoogleFonts.jetBrainsMono(fontSize: 13, fontWeight: FontWeight.w700, color: color)),
      ],
    );
  }

  // ==========================================================================
  // 3. PIPELINE STAGES & AGING BREAKDOWN
  // ==========================================================================
  Widget _buildPipelineStagesSection(bool isDark) {
    final stages = ReportsMockData.executivePipelineStages;
    final isMobile = MediaQuery.sizeOf(context).width < 768;

    return ReportSectionContainer(
      title: 'Deal Pipeline Velocity & Conversion',
      subtitle: 'Conversion drop-off across qualification, design proposal, and contract negotiation',
      icon: Icons.filter_list_rounded,
      iconColor: const Color(0xFF3B82F6),
      child: Column(
        children: stages.map((s) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        s.stageName,
                        style: GoogleFonts.inter(fontSize: 11.5, fontWeight: FontWeight.w600, color: isDark ? Colors.white : AppColors.lightTextPrimary),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      isMobile
                          ? '${s.opportunityCount} deals • ₹${s.pipelineValueLakhs.toStringAsFixed(0)}L'
                          : '${s.opportunityCount} deals • ₹${s.pipelineValueLakhs}L (Avg ₹${s.avgDealValueLakhs}L)',
                      style: GoogleFonts.jetBrainsMono(fontSize: 10, fontWeight: FontWeight.w600, color: s.color),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: LinearProgressIndicator(
                    value: (s.conversionRate / 100.0).clamp(0.05, 1.0),
                    backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
                    valueColor: AlwaysStoppedAnimation<Color>(s.color),
                    minHeight: 5,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPipelineAgingSection(bool isDark) {
    final buckets = ReportsMockData.salesAgingBuckets;

    return ReportSectionContainer(
      title: 'Pipeline Aging & Stale Opportunity Tracker',
      subtitle: 'Opportunities grouped by days open with stale warning flags for deals >30 days',
      icon: Icons.hourglass_top_rounded,
      iconColor: const Color(0xFFF59E0B),
      child: ReportSalesAgingBarChart(buckets: buckets),
    );
  }

  // ==========================================================================
  // 4. SALES TEAM PERFORMANCE TABLE
  // ==========================================================================
  Widget _buildTeamPerformanceTable(bool isDark, bool isMobile) {
    var rankers = List<SalesTeamMemberMetric>.from(ReportsMockData.salesTeamPerformance);

    if (_sortColumn == 'revenue') {
      rankers.sort((a, b) => _isAscending ? a.revenueLakhs.compareTo(b.revenueLakhs) : b.revenueLakhs.compareTo(a.revenueLakhs));
    } else if (_sortColumn == 'winRate') {
      rankers.sort((a, b) => _isAscending ? a.winRate.compareTo(b.winRate) : b.winRate.compareTo(a.winRate));
    } else if (_sortColumn == 'wonDeals') {
      rankers.sort((a, b) => _isAscending ? a.wonDeals.compareTo(b.wonDeals) : b.wonDeals.compareTo(a.wonDeals));
    }

    return ReportSectionContainer(
      title: 'Sales Consultant Performance Leaderboard',
      subtitle: 'Attributed closed revenue, quota achievement %, win rate, average sales cycle, and pipeline value',
      icon: Icons.emoji_events_outlined,
      iconColor: const Color(0xFF10B981),
      trailing: ElevatedButton.icon(
        onPressed: _handleExport,
        icon: const Icon(Icons.download_rounded, size: 13),
        label: Text('Export Leaderboard', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600)),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
        ),
      ),
      child: isMobile
          ? Column(children: rankers.map((r) => _buildMobileTeamCard(r, isDark)).toList())
          : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingRowHeight: 36,
                dataRowMinHeight: 44,
                dataRowMaxHeight: 48,
                columnSpacing: 18,
                horizontalMargin: 8,
                columns: [
                  DataColumn(label: Text('Rank', style: _headerStyle(isDark))),
                  DataColumn(label: Text('Consultant', style: _headerStyle(isDark))),
                  DataColumn(label: Text('Team', style: _headerStyle(isDark))),
                  DataColumn(label: Text('Assigned', style: _headerStyle(isDark))),
                  DataColumn(label: Text('Opps', style: _headerStyle(isDark))),
                  DataColumn(
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Won Deals', style: _headerStyle(isDark)),
                        const Icon(Icons.unfold_more_rounded, size: 12),
                      ],
                    ),
                    onSort: (colIndex, ascending) {
                      setState(() {
                        _sortColumn = 'wonDeals';
                        _isAscending = !_isAscending;
                      });
                    },
                  ),
                  DataColumn(
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Revenue', style: _headerStyle(isDark)),
                        const Icon(Icons.unfold_more_rounded, size: 12),
                      ],
                    ),
                    onSort: (colIndex, ascending) {
                      setState(() {
                        _sortColumn = 'revenue';
                        _isAscending = !_isAscending;
                      });
                    },
                  ),
                  DataColumn(
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Win Rate', style: _headerStyle(isDark)),
                        const Icon(Icons.unfold_more_rounded, size: 12),
                      ],
                    ),
                    onSort: (colIndex, ascending) {
                      setState(() {
                        _sortColumn = 'winRate';
                        _isAscending = !_isAscending;
                      });
                    },
                  ),
                  DataColumn(label: Text('Target Quota', style: _headerStyle(isDark))),
                  DataColumn(label: Text('Achievement %', style: _headerStyle(isDark))),
                  DataColumn(label: Text('Cycle', style: _headerStyle(isDark))),
                ],
                rows: rankers.map((r) {
                  return DataRow(
                    cells: [
                      DataCell(
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: r.rank == 1
                                ? const Color(0xFFF59E0B).withValues(alpha: 0.18)
                                : (isDark ? AppColors.darkSurfaceElevated : const Color(0xFFF1F5F9)),
                            shape: BoxShape.circle,
                          ),
                          child: Text('#${r.rank}', style: GoogleFonts.jetBrainsMono(fontSize: 10.5, fontWeight: FontWeight.w700)),
                        ),
                      ),
                      DataCell(
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 12,
                              backgroundColor: AppColors.primary.withValues(alpha: 0.15),
                              child: Text(
                                r.salesperson.isNotEmpty ? r.salesperson[0] : 'S',
                                style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.primary),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(r.salesperson, style: GoogleFonts.inter(fontSize: 11.5, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                      DataCell(Text(r.team, style: GoogleFonts.inter(fontSize: 11))),
                      DataCell(Text('${r.leadsAssigned}', style: GoogleFonts.jetBrainsMono(fontSize: 11))),
                      DataCell(Text('${r.opportunities}', style: GoogleFonts.jetBrainsMono(fontSize: 11))),
                      DataCell(Text('${r.wonDeals}', style: GoogleFonts.jetBrainsMono(fontSize: 11, fontWeight: FontWeight.w700, color: const Color(0xFF10B981)))),
                      DataCell(Text('₹${r.revenueLakhs.toStringAsFixed(1)}L', style: GoogleFonts.jetBrainsMono(fontSize: 11.5, fontWeight: FontWeight.w700))),
                      DataCell(Text('${r.winRate.toStringAsFixed(1)}%', style: GoogleFonts.jetBrainsMono(fontSize: 11, color: const Color(0xFF3B82F6)))),
                      DataCell(Text('₹${r.targetLakhs}L', style: GoogleFonts.jetBrainsMono(fontSize: 11))),
                      DataCell(
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: r.achievementPercent >= 100
                                ? const Color(0xFF10B981).withValues(alpha: 0.15)
                                : const Color(0xFFF59E0B).withValues(alpha: 0.15),
                            borderRadius: AppRadius.full,
                          ),
                          child: Text(
                            '${r.achievementPercent.toStringAsFixed(1)}%',
                            style: GoogleFonts.jetBrainsMono(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: r.achievementPercent >= 100 ? const Color(0xFF10B981) : const Color(0xFFF59E0B),
                            ),
                          ),
                        ),
                      ),
                      DataCell(Text('${r.avgSalesCycleDays}d', style: GoogleFonts.jetBrainsMono(fontSize: 11))),
                    ],
                  );
                }).toList(),
              ),
            ),
    );
  }

  Widget _buildMobileTeamCard(SalesTeamMemberMetric r, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurfaceElevated : const Color(0xFFF8FAFC),
        borderRadius: AppRadius.sm,
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: AppColors.primary.withValues(alpha: 0.15),
            child: Text(
              r.salesperson.isNotEmpty ? r.salesperson[0] : 'S',
              style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        r.salesperson,
                        style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text('₹${r.revenueLakhs}L', style: GoogleFonts.jetBrainsMono(fontSize: 12, fontWeight: FontWeight.w700, color: const Color(0xFF10B981))),
                  ],
                ),
                Text('${r.team} • ${r.wonDeals} Won • ${r.winRate}% Win Rate', style: GoogleFonts.inter(fontSize: 10.5, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================================
  // 5. TOP DEALS & LOST DEALS
  // ==========================================================================
  Widget _buildTopDealsSection(bool isDark, bool isMobile) {
    final deals = ReportsMockData.topDeals;

    return ReportSectionContainer(
      title: 'Top High-Value Opportunities',
      subtitle: 'Largest deals currently progressing towards milestone execution',
      icon: Icons.diamond_outlined,
      iconColor: const Color(0xFFF59E0B),
      child: Column(
        children: deals.map((d) {
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(10),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              d.customer,
                              style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: isDark ? Colors.white : AppColors.lightTextPrimary),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text('₹${d.dealValueLakhs}L', style: GoogleFonts.jetBrainsMono(fontSize: 12, fontWeight: FontWeight.w700, color: const Color(0xFF10B981))),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(d.opportunity, style: GoogleFonts.inter(fontSize: 10.5, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
                      const SizedBox(height: 4),
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 6,
                        runSpacing: 4,
                        children: [
                          ReportStatusBadge(label: d.stage, color: d.stageColor),
                          Text(
                            'Owner: ${d.owner} • Close: ${d.expectedCloseDate} (${d.probabilityPercent}%)',
                            style: GoogleFonts.inter(fontSize: 10, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                          ),
                        ],
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

  Widget _buildLostDealsSection(bool isDark) {
    final reasons = ReportsMockData.lostDealReasons;

    return ReportSectionContainer(
      title: 'Lost Deal Reason Telemetry',
      subtitle: 'Primary reasons for lost opportunities to prevent sales churn',
      icon: Icons.cancel_outlined,
      iconColor: const Color(0xFFEF4444),
      child: Column(
        children: reasons.map((r) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        r.reason,
                        style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: isDark ? Colors.white : AppColors.lightTextPrimary),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      '${r.dealCount} deals • ₹${r.lostValueLakhs}L (${r.percentage}%)',
                      style: GoogleFonts.jetBrainsMono(fontSize: 10, fontWeight: FontWeight.w600, color: r.color),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: LinearProgressIndicator(
                    value: (r.percentage / 100.0).clamp(0.05, 1.0),
                    backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
                    valueColor: AlwaysStoppedAnimation<Color>(r.color),
                    minHeight: 5,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  TextStyle _headerStyle(bool isDark) {
    return GoogleFonts.inter(
      fontSize: 10.5,
      fontWeight: FontWeight.w700,
      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
    );
  }
}
