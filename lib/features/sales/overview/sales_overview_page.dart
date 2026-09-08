import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../dashboard/widgets/state_feedback_widgets.dart';
import '../domain/sales_domain_models.dart';
import '../data/sales_repository.dart';
import '../widgets/crm_header.dart';
import '../widgets/crm_charts.dart';
import '../widgets/create_lead_dialog.dart';

/// CRM & Sales Overview — Executive Sales Command Center
class SalesOverviewPage extends StatefulWidget {
  final String userName;
  final String userRole;

  const SalesOverviewPage({
    super.key,
    this.userName = 'Rajesh Patel',
    this.userRole = 'Senior Deal Closer & Design Lead',
  });

  @override
  State<SalesOverviewPage> createState() => _SalesOverviewPageState();
}

class _SalesOverviewPageState extends State<SalesOverviewPage> {
  final SalesRepository _repository = SalesRepository.instance;
  final ScrollController _scrollController = ScrollController();

  CrmDateRangeFilter _dateFilter = CrmDateRangeFilter.thisMonth;
  CrmScopeFilter _scopeFilter = CrmScopeFilter.myWork;
  String _selectedLeadList = 'Interior Client Funnel';

  bool _isLoading = true;
  SalesOverviewSummary? _summary;

  @override
  void initState() {
    super.initState();
    _loadOverviewData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadOverviewData() async {
    final savedOffset = _scrollController.hasClients ? _scrollController.offset : null;
    setState(() => _isLoading = true);

    final data = await _repository.getOverviewSummary(
      dateFilter: _dateFilter.label,
      scopeFilter: _scopeFilter.label,
      funnelId: _selectedLeadList,
    );

    if (mounted) {
      setState(() {
        _summary = data;
        _isLoading = false;
      });

      if (savedOffset != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted && _scrollController.hasClients) {
            final target = savedOffset.clamp(0.0, _scrollController.position.maxScrollExtent);
            _scrollController.jumpTo(target);
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 768;
    final isTablet = width >= 768 && width < 1100;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          controller: _scrollController,
          key: const PageStorageKey('sales_overview_scroll'),
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 12 : 20,
            vertical: 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Common Enterprise CRM Header
              CrmHeader(
                title: 'CRM & Sales',
                subtitle: 'Monitor pipeline performance, team activity and conversion',
                icon: Icons.insights_rounded,
                activeDateFilter: _dateFilter,
                activeScopeFilter: _scopeFilter,
                activeLeadList: _selectedLeadList,
                leadListOptions: const [
                  'Interior Client Funnel',
                  'Job Applicant Funnel',
                  'Vendor Partnership Funnel',
                ],
                onDateFilterChanged: (d) {
                  setState(() => _dateFilter = d);
                  _loadOverviewData();
                },
                onScopeFilterChanged: (s) {
                  setState(() => _scopeFilter = s);
                  _loadOverviewData();
                },
                onLeadListChanged: (l) {
                  setState(() => _selectedLeadList = l);
                  _loadOverviewData();
                },
                onRefresh: _loadOverviewData,
                primaryAction: ElevatedButton.icon(
                  onPressed: () {
                    CreateLeadDialog.show(
                      context,
                      onLeadCreated: (lead) {
                        _loadOverviewData();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Lead #${lead.id} created successfully!'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                    );
                  },
                  icon: const Icon(Icons.person_add_alt_1_rounded, size: 16),
                  label: Text('+ Create Lead', style: GoogleFonts.inter(fontSize: 11.5, fontWeight: FontWeight.w700)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                    shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
                  ),
                ),
              ),

              // Non-disruptive inline loading indicator
              DashboardInlineLoadingIndicator(isLoading: _isLoading && _summary != null),

              if (_isLoading && _summary == null) ...[
                const DashboardSkeletonLoader(height: 100),
                const SizedBox(height: 16),
                const DashboardSkeletonLoader(height: 140),
                const SizedBox(height: 16),
                const DashboardSkeletonLoader(height: 280),
              ] else if (_summary != null) ...[
                // 2. Sales KPI Cards Strip
                _buildKpiStrip(_summary!, isDark, isMobile, isTablet),
                const SizedBox(height: 18),

                // 3. Monthly Sales Target Widget
                _buildMonthlyTargetWidget(_summary!, isDark, isMobile),
                const SizedBox(height: 18),

                // 4. Funnel Chart & Pipeline Distribution Row
                if (isMobile) ...[
                  CrmFunnelChart(funnelCounts: _summary!.funnelCounts),
                  const SizedBox(height: 16),
                  CrmPipelineDistributionChart(distributionCounts: _summary!.distributionCounts),
                ] else ...[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 6,
                        child: CrmFunnelChart(funnelCounts: _summary!.funnelCounts),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        flex: 6,
                        child: CrmPipelineDistributionChart(distributionCounts: _summary!.distributionCounts),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 18),

                // 5. Trend Line Chart (Leads vs Bookings)
                const CrmLeadsVsBookingsLineChart(),
                const SizedBox(height: 18),

                // 6. Sales Team Performance Ranking Table
                _buildTeamPerformanceSection(_summary!, isDark, isMobile),
                const SizedBox(height: 18),

                // 7. Recent Sales Activity Stream
                _buildRecentActivitySection(_summary!, isDark, isMobile),
                const SizedBox(height: 24),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildKpiStrip(SalesOverviewSummary s, bool isDark, bool isMobile, bool isTablet) {
    final cards = [
      _kpiCard(
        title: 'New Leads',
        value: '${s.newLeads}',
        badgeText: '+${s.newLeadsGrowthPercent}%',
        badgeColor: const Color(0xFF10B981),
        subtext: 'vs previous period',
        icon: Icons.person_add_outlined,
        iconColor: const Color(0xFF3B82F6),
        isDark: isDark,
      ),
      _kpiCard(
        title: "Today's Follow-ups",
        value: '${s.todayFollowups}',
        badgeText: '${s.pendingFollowups} Pending',
        badgeColor: const Color(0xFFF59E0B),
        subtext: 'High priority SLA queue',
        icon: Icons.phone_callback_outlined,
        iconColor: const Color(0xFFF59E0B),
        isDark: isDark,
      ),
      _kpiCard(
        title: 'Meetings Scheduled',
        value: '${s.meetingsScheduled}',
        badgeText: '${s.meetingsCompleted} Done',
        badgeColor: const Color(0xFF0EA5E9),
        subtext: 'Site visits & design centers',
        icon: Icons.calendar_month_outlined,
        iconColor: const Color(0xFF0EA5E9),
        isDark: isDark,
      ),
      _kpiCard(
        title: 'Closed Bookings',
        value: '${s.bookingsClosed}',
        badgeText: '₹${s.bookingValueLakhs}L',
        badgeColor: const Color(0xFF10B981),
        subtext: 'Avg ticket: ₹8.1L',
        icon: Icons.check_circle_outline_rounded,
        iconColor: const Color(0xFF10B981),
        isDark: isDark,
      ),
      _kpiCard(
        title: 'Conversion Rate',
        value: '${s.conversionRate}%',
        badgeText: '+2.1% MoM',
        badgeColor: const Color(0xFF10B981),
        subtext: 'Enquiry to booking closure',
        icon: Icons.trending_up_rounded,
        iconColor: const Color(0xFF8B5CF6),
        isDark: isDark,
      ),
    ];

    if (isMobile) {
      return Column(
        children: cards.map((c) => Padding(padding: const EdgeInsets.only(bottom: 10), child: c)).toList(),
      );
    }

    if (isTablet) {
      return Column(
        children: [
          Row(children: [Expanded(child: cards[0]), const SizedBox(width: 10), Expanded(child: cards[1])]),
          const SizedBox(height: 10),
          Row(children: [Expanded(child: cards[2]), const SizedBox(width: 10), Expanded(child: cards[3])]),
          const SizedBox(height: 10),
          cards[4],
        ],
      );
    }

    return Row(
      children: cards.map((c) => Expanded(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 4), child: c))).toList(),
    );
  }

  Widget _kpiCard({
    required String title,
    required String value,
    required String badgeText,
    required Color badgeColor,
    required String subtext,
    required IconData icon,
    required Color iconColor,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: AppRadius.md,
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder, width: 0.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.inter(fontSize: 11.5, fontWeight: FontWeight.w600, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: badgeColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  badgeText,
                  style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: badgeColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(icon, size: 20, color: iconColor),
              const SizedBox(width: 8),
              Text(
                value,
                style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.w800),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            subtext,
            style: GoogleFonts.inter(fontSize: 10.5, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthlyTargetWidget(SalesOverviewSummary s, bool isDark, bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: AppRadius.md,
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder, width: 0.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.track_changes_rounded, size: 18, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Text(
                    'Monthly Booking Target Performance',
                    style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '${s.targetAchievementPercent}% Achieved',
                  style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: const Color(0xFF10B981)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: (s.targetAchievementPercent / 100.0).clamp(0.0, 1.0),
              minHeight: 10,
              backgroundColor: isDark ? AppColors.darkSurfaceSubtle : const Color(0xFFF1F5F9),
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF10B981)),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _targetColumn('Monthly Target', '₹${s.monthlyBookingTargetCr.toStringAsFixed(2)} Cr', isDark),
              _targetColumn('Actual Closed', '₹${s.actualBookingLakhs} L', isDark, color: const Color(0xFF10B981)),
              _targetColumn('Remaining Target', '₹${s.remainingTargetLakhs} L', isDark, color: const Color(0xFFEF4444)),
              if (!isMobile)
                _targetColumn('Target Ratio', '18 / 28 Projects', isDark, color: AppColors.primary),
            ],
          ),
        ],
      ),
    );
  }

  Widget _targetColumn(String label, String value, bool isDark, {Color? color}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.inter(fontSize: 11, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
        const SizedBox(height: 2),
        Text(value, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: color)),
      ],
    );
  }

  Widget _buildTeamPerformanceSection(SalesOverviewSummary s, bool isDark, bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: AppRadius.md,
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder, width: 0.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Sales Team Performance Leaderboard', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700)),
              Text('4 Senior Deal Closers', style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF64748B))),
            ],
          ),
          const SizedBox(height: 14),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowHeight: 38,
              dataRowMinHeight: 44,
              dataRowMaxHeight: 48,
              columns: const [
                DataColumn(label: Text('# Rank')),
                DataColumn(label: Text('Salesperson')),
                DataColumn(label: Text('Leads Assigned')),
                DataColumn(label: Text('Calls / Talk Time')),
                DataColumn(label: Text('Meetings')),
                DataColumn(label: Text('Bookings')),
                DataColumn(label: Text('Revenue')),
                DataColumn(label: Text('Conversion %')),
              ],
              rows: s.teamRankings.map((m) {
                return DataRow(cells: [
                  DataCell(Text('#${m.rank}', style: GoogleFonts.inter(fontWeight: FontWeight.w700, color: AppColors.primary))),
                  DataCell(Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(m.employeeName, style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 12)),
                      Text(m.role, style: GoogleFonts.inter(fontSize: 10, color: const Color(0xFF64748B))),
                    ],
                  )),
                  DataCell(Text('${m.leadsAssigned}')),
                  DataCell(Text('${m.callsCompleted} (${m.talkTimeMinutes}m)')),
                  DataCell(Text('${m.meetingsHosted}')),
                  DataCell(Text('${m.bookingsClosed}')),
                  DataCell(Text('₹${m.revenueGeneratedLakhs}L', style: GoogleFonts.inter(fontWeight: FontWeight.w700, color: const Color(0xFF10B981)))),
                  DataCell(Text('${m.conversionRate}%')),
                ]);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivitySection(SalesOverviewSummary s, bool isDark, bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: AppRadius.md,
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder, width: 0.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Live CRM Activity Feed', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          for (final act in s.recentActivities) ...[
            InkWell(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Inspecting activity: ${act.action}'), behavior: SnackBarBehavior.floating),
                );
              },
              borderRadius: AppRadius.sm,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(color: act.iconColor.withValues(alpha: 0.12), shape: BoxShape.circle),
                      child: Icon(act.icon, size: 16, color: act.iconColor),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(act.action, style: GoogleFonts.inter(fontSize: 12.5, fontWeight: FontWeight.w700)),
                              Text(
                                '${act.timestamp.hour}:${act.timestamp.minute.toString().padLeft(2, '0')}',
                                style: GoogleFonts.inter(fontSize: 10.5, color: const Color(0xFF64748B)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(act.details, style: GoogleFonts.inter(fontSize: 11.5)),
                          const SizedBox(height: 2),
                          Text('By: ${act.employeeName} (${act.source})', style: GoogleFonts.inter(fontSize: 10.5, color: const Color(0xFF94A3B8))),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Divider(height: 1, color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
          ],
        ],
      ),
    );
  }
}
