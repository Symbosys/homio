import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../data/dashboard_repository.dart';
import '../domain/dashboard_enums.dart';
import '../domain/dashboard_models.dart';
import '../widgets/dashboard_charts.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/priority_alert_hub.dart';
import '../widgets/productivity_score_ring.dart';
import '../widgets/state_feedback_widgets.dart';
import '../widgets/task_detail_drawer.dart';

/// Screen 1: Dashboard Overview — Central Operations Command Center for HOMIO CRM.
/// Aggregates real-time KPIs, productivity velocity, earnings, wallet, attendance status,
/// lead pipeline pulse, critical SLA alerts, and field operations telemetry.
class DashboardOverviewPage extends StatefulWidget {
  final String userName;
  final String userRole;

  const DashboardOverviewPage({
    super.key,
    this.userName = 'Vikram Malhotra',
    this.userRole = 'Super Admin',
  });

  @override
  State<DashboardOverviewPage> createState() => _DashboardOverviewPageState();
}

class _DashboardOverviewPageState extends State<DashboardOverviewPage> {
  final DashboardRepository _repository = DashboardRepository.instance;
  final ScrollController _scrollController = ScrollController();

  DashboardDateFilter _dateFilter = DashboardDateFilter.today;
  DashboardScopeFilter _scopeFilter = DashboardScopeFilter.myWork;

  bool _isLoading = true;
  String? _errorMessage;
  DashboardSummary? _summary;
  DateTime _lastUpdated = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadDashboardData() async {
    final savedOffset = _scrollController.hasClients ? _scrollController.offset : null;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final data = await _repository.getSummary(
        dateFilter: _dateFilter,
        scopeFilter: _scopeFilter,
      );
      if (mounted) {
        setState(() {
          _summary = data;
          _isLoading = false;
          _lastUpdated = DateTime.now();
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
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  void _onDateFilterChanged(DashboardDateFilter filter) {
    setState(() => _dateFilter = filter);
    _loadDashboardData();
  }

  void _onScopeFilterChanged(DashboardScopeFilter filter) {
    setState(() => _scopeFilter = filter);
    _loadDashboardData();
  }

  String _formatLastUpdated() {
    final diff = DateTime.now().difference(_lastUpdated);
    if (diff.inSeconds < 45) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    return '${diff.inHours}h ago';
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
          key: const PageStorageKey('dashboard_overview_scroll'),
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 12 : 20,
            vertical: 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Common Enterprise Header
              DashboardHeader(
                title: 'HOMIO Operations Dashboard',
                subtitle: 'Good morning, ${widget.userName} 👋 — Central command & telemetry overview',
                icon: Icons.dashboard_outlined,
                userName: widget.userName,
                activeDateFilter: _dateFilter,
                activeScopeFilter: _scopeFilter,
                onDateFilterChanged: _onDateFilterChanged,
                onScopeFilterChanged: _onScopeFilterChanged,
                onRefresh: _loadDashboardData,
                lastUpdatedText: _formatLastUpdated(),
                primaryAction: ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Exporting executive operations report (PDF / XLSX)...',
                          style: GoogleFonts.inter(fontSize: 12),
                        ),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  icon: const Icon(Icons.file_download_outlined, size: 14),
                  label: Text(
                    'Export Telemetry',
                    style: GoogleFonts.inter(fontSize: 11.5, fontWeight: FontWeight.w600),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                    shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
                  ),
                ),
              ),

              // Non-disruptive inline indicator right below header
              DashboardInlineLoadingIndicator(isLoading: _isLoading && _summary != null),

              // Initial Loading / Error / Content states
              if (_isLoading && _summary == null) ...[
                const DashboardSkeletonLoader(height: 120),
                const SizedBox(height: 16),
                const DashboardSkeletonLoader(height: 140),
                const SizedBox(height: 16),
                const DashboardSkeletonLoader(height: 280),
              ] else if (_errorMessage != null && _summary == null) ...[
                DashboardErrorState(
                  message: _errorMessage!,
                  onRetry: _loadDashboardData,
                ),
              ] else if (_summary != null) ...[
                // 2. High-Priority Alert Hub
                PriorityAlertHub(
                  alerts: _summary!.alerts,
                ),

                // 3. Four Core Operational KPI Cards
                _buildFourCoreKpis(isDark, isMobile, isTablet),
                const SizedBox(height: 18),

                // 4. Productivity Velocity & Trend Row
                _buildProductivitySection(isDark, isMobile, isTablet),
                const SizedBox(height: 18),

                // 5. Sales Lead Pipeline Pulse & Task Center Row
                _buildPipelineAndTaskCenter(isDark, isMobile, isTablet),
                const SizedBox(height: 18),

                // 6. Field Visits, Mileage & Travel Activity Section
                _buildFieldActivitySection(isDark, isMobile, isTablet),
                const SizedBox(height: 24),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // SECTION: FOUR CORE OPERATIONAL KPIS
  // ===========================================================================
  Widget _buildFourCoreKpis(bool isDark, bool isMobile, bool isTablet) {
    final p = _summary!.productivity;
    final e = _summary!.earnings;
    final w = _summary!.wallet;
    final a = _summary!.attendance;

    if (isMobile) {
      return Column(
        children: [
          _buildProductivityKpiCard(p, isDark),
          const SizedBox(height: 12),
          _buildEarningsKpiCard(e, isDark),
          const SizedBox(height: 12),
          _buildWalletKpiCard(w, isDark),
          const SizedBox(height: 12),
          _buildAttendanceKpiCard(a, isDark),
        ],
      );
    }

    if (isTablet) {
      return Column(
        children: [
          Row(
            children: [
              Expanded(child: _buildProductivityKpiCard(p, isDark)),
              const SizedBox(width: 12),
              Expanded(child: _buildEarningsKpiCard(e, isDark)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildWalletKpiCard(w, isDark)),
              const SizedBox(width: 12),
              Expanded(child: _buildAttendanceKpiCard(a, isDark)),
            ],
          ),
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _buildProductivityKpiCard(p, isDark)),
        const SizedBox(width: 12),
        Expanded(child: _buildEarningsKpiCard(e, isDark)),
        const SizedBox(width: 12),
        Expanded(child: _buildWalletKpiCard(w, isDark)),
        const SizedBox(width: 12),
        Expanded(child: _buildAttendanceKpiCard(a, isDark)),
      ],
    );
  }

  // 1. Productivity Score Card
  Widget _buildProductivityKpiCard(ProductivityMetrics p, bool isDark) {
    return _buildCardWrapper(
      isDark: isDark,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Productivity Score',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.arrow_upward_rounded, size: 11, color: Color(0xFF10B981)),
                    Text(
                      '${p.scoreChange}%',
                      style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: const Color(0xFF10B981)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '${p.score.toInt()}%',
                style: GoogleFonts.inter(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF6366F1),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  p.performanceBadge,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _buildSubMetric(
                  label: 'Tasks',
                  value: '${p.tasksCompleted} / ${p.totalTasks}',
                  isDark: isDark,
                ),
              ),
              Expanded(
                child: _buildSubMetric(
                  label: 'Follow-ups',
                  value: '${p.followupsCompleted} / ${p.totalFollowups}',
                  isDark: isDark,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 2. Earnings Card
  Widget _buildEarningsKpiCard(EarningsSummary e, bool isDark) {
    return _buildCardWrapper(
      isDark: isDark,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'My Earnings',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                ),
              ),
              Text(
                'Net Projected',
                style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF10B981),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '₹${e.netProjected.toStringAsFixed(0)}',
                style: GoogleFonts.inter(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
              const SizedBox(width: 6),
              Text(
                'this month',
                style: GoogleFonts.inter(
                  fontSize: 10.5,
                  color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _buildSubMetric(
                  label: 'Base + Inc',
                  value: '₹${(e.baseSalary + e.earnedIncentives).toInt()}',
                  isDark: isDark,
                ),
              ),
              Expanded(
                child: _buildSubMetric(
                  label: 'Deductions',
                  value: '-₹${e.salaryDeductions.toInt()}',
                  isDark: isDark,
                  valueColor: const Color(0xFFEF4444),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 3. Wallet Card
  Widget _buildWalletKpiCard(WalletSummary w, bool isDark) {
    return _buildCardWrapper(
      isDark: isDark,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'My Wallet',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                ),
              ),
              InkWell(
                onTap: () => context.go(RouteNames.dashboardWallet),
                child: Text(
                  'View Wallet →',
                  style: GoogleFonts.inter(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '₹${w.currentBalance.toStringAsFixed(0)}',
                style: GoogleFonts.inter(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
              const SizedBox(width: 6),
              Text(
                'available',
                style: GoogleFonts.inter(
                  fontSize: 10.5,
                  color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _buildSubMetric(
                  label: 'Total Spent',
                  value: '₹${w.totalSpent.toInt()}',
                  isDark: isDark,
                ),
              ),
              Expanded(
                child: _buildSubMetric(
                  label: 'Pending Claim',
                  value: '₹${w.pendingReimbursement.toInt()}',
                  isDark: isDark,
                  valueColor: const Color(0xFFF59E0B),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 4. Attendance & Work Card
  Widget _buildAttendanceKpiCard(AttendanceSummary a, bool isDark) {
    return _buildCardWrapper(
      isDark: isDark,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Attendance & Work',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 7,
                    height: 7,
                    decoration: BoxDecoration(
                      color: a.isClockedIn ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    a.isClockedIn ? 'Checked In' : 'Not Checked In',
                    style: GoogleFonts.inter(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w600,
                      color: a.isClockedIn ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '${a.presentDays} Days',
                style: GoogleFonts.inter(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${a.totalWorkingHours} hrs logged',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _buildSubMetric(
                  label: 'Punch Time',
                  value: a.clockInTime != null ? '09:14 AM' : 'Not logged',
                  isDark: isDark,
                ),
              ),
              Expanded(
                child: _buildSubMetric(
                  label: 'Daily Avg',
                  value: '${a.avgDailyHours} hrs',
                  isDark: isDark,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // SECTION: PRODUCTIVITY VELOCITY & TREND
  // ===========================================================================
  Widget _buildProductivitySection(bool isDark, bool isMobile, bool isTablet) {
    final ringScore = ProductivityScoreData(
      score: _summary!.productivity.score,
      grade: _summary!.productivity.performanceBadge,
      tasksCompleted: _summary!.productivity.tasksCompleted,
      totalTasks: _summary!.productivity.totalTasks,
      followupsCompleted: _summary!.productivity.followupsCompleted,
      totalFollowups: _summary!.productivity.totalFollowups,
      siteMeetingsDone: _summary!.leadPulse.meetingsScheduled,
      scoreChange: _summary!.productivity.scoreChange,
    );

    const chartWidget = DashboardVelocityLineChart();

    if (isMobile || isTablet) {
      return Column(
        children: [
          ProductivityScoreRing(scoreData: ringScore),
          const SizedBox(height: 14),
          chartWidget,
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 4,
          child: ProductivityScoreRing(scoreData: ringScore),
        ),
        const SizedBox(width: 14),
        Expanded(
          flex: 6,
          child: chartWidget,
        ),
      ],
    );
  }

  // ===========================================================================
  // SECTION: SALES PIPELINE PULSE & ACTIONABLE TASK CENTER
  // ===========================================================================
  Widget _buildPipelineAndTaskCenter(bool isDark, bool isMobile, bool isTablet) {
    final lp = _summary!.leadPulse;
    final tasks = _summary!.topTasks;

    final pipelineWidget = Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: AppRadius.md,
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.hub_outlined, size: 18, color: Color(0xFF0EA5E9)),
                  const SizedBox(width: 8),
                  Text(
                    'Lead & Pipeline Pulse',
                    style: GoogleFonts.inter(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : AppColors.lightTextPrimary,
                    ),
                  ),
                ],
              ),
              Text(
                'Conversion: 21.4%',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF10B981),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // 4 Funnel metrics
          Row(
            children: [
              Expanded(
                child: _buildPulseTile(
                  label: 'New Leads',
                  count: lp.newLeadsAssigned,
                  color: const Color(0xFF6366F1),
                  isDark: isDark,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildPulseTile(
                  label: 'Follow-ups',
                  count: lp.followupsPending,
                  color: const Color(0xFFF59E0B),
                  isDark: isDark,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildPulseTile(
                  label: 'Meetings',
                  count: lp.meetingsScheduled,
                  color: const Color(0xFF0EA5E9),
                  isDark: isDark,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildPulseTile(
                  label: 'Bookings',
                  count: lp.bookingsClosed,
                  color: const Color(0xFF10B981),
                  isDark: isDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Pipeline donut chart
          const DashboardWorkloadDonutChart(),
        ],
      ),
    );

    final taskCenterWidget = Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: AppRadius.md,
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.check_circle_outline_rounded, size: 18, color: Color(0xFF10B981)),
                  const SizedBox(width: 8),
                  Text(
                    "Today's Task & Follow-up Center",
                    style: GoogleFonts.inter(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : AppColors.lightTextPrimary,
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: () => context.go(RouteNames.dashboardTasks),
                child: Text(
                  'Manage Tasks (${tasks.length}) →',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Quick Task Counter Strip
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurfaceSubtle : const Color(0xFFF8FAFC),
              borderRadius: AppRadius.sm,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildMiniCount('Today Tasks', '8', const Color(0xFF6366F1), isDark),
                _buildDivider(isDark),
                _buildMiniCount('Pending Calls', '9', const Color(0xFFF59E0B), isDark),
                _buildDivider(isDark),
                _buildMiniCount('Due Today', '5', const Color(0xFF0EA5E9), isDark),
                _buildDivider(isDark),
                _buildMiniCount('Overdue', '2', const Color(0xFFEF4444), isDark),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Clickable task items
          ...tasks.take(3).map((task) {
            return InkWell(
              onTap: () {
                TaskDetailDrawer.show(context, task: task);
              },
              borderRadius: AppRadius.sm,
              child: Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurfaceSubtle : const Color(0xFFF8FAFC),
                  borderRadius: AppRadius.sm,
                  border: Border.all(
                    color: task.priority == TaskPriority.urgent
                        ? const Color(0xFFEF4444).withValues(alpha: 0.3)
                        : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      task.priority.icon,
                      size: 14,
                      color: task.priority.color,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            task.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                            ),
                          ),
                          Text(
                            '${task.clientName} • Due ${task.dueTime}',
                            style: GoogleFonts.inter(
                              fontSize: 10.5,
                              color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right_rounded, size: 16, color: Color(0xFF94A3B8)),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );

    if (isMobile || isTablet) {
      return Column(
        children: [
          pipelineWidget,
          const SizedBox(height: 14),
          taskCenterWidget,
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 5, child: pipelineWidget),
        const SizedBox(width: 14),
        Expanded(flex: 5, child: taskCenterWidget),
      ],
    );
  }

  // ===========================================================================
  // SECTION: FIELD VISITS & MILEAGE ACTIVITY
  // ===========================================================================
  Widget _buildFieldActivitySection(bool isDark, bool isMobile, bool isTablet) {
    final tr = _summary!.travel;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: AppRadius.md,
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.commute_rounded, size: 18, color: Color(0xFF2563EB)),
                  const SizedBox(width: 8),
                  Text(
                    'Field Activity & Travel Telemetry',
                    style: GoogleFonts.inter(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : AppColors.lightTextPrimary,
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: () => context.go(RouteNames.dashboardTravel),
                child: Text(
                  'View Travel Hub →',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // 3 Metric Cards + Weekly Travel Bar Chart
          if (isMobile) ...[
            _buildFieldStatTile('Site Visits', '${tr.totalVisits}', 'completed', isDark),
            const SizedBox(height: 8),
            _buildFieldStatTile('Distance Travelled', '${tr.totalDistanceKm} KM', 'odometer synced', isDark),
            const SizedBox(height: 8),
            _buildFieldStatTile('Pending Reimbursement', '₹${tr.pendingReimbursement.toInt()}', 'at ₹12/KM', isDark),
            const SizedBox(height: 14),
            const DashboardWeeklyTaskBarChart(),
          ] else ...[
            Row(
              children: [
                Expanded(child: _buildFieldStatTile('Site Visits', '${tr.totalVisits}', 'completed', isDark)),
                const SizedBox(width: 10),
                Expanded(child: _buildFieldStatTile('Distance Travelled', '${tr.totalDistanceKm} KM', 'odometer synced', isDark)),
                const SizedBox(width: 10),
                Expanded(child: _buildFieldStatTile('Pending Reimbursement', '₹${tr.pendingReimbursement.toInt()}', 'at ₹12/KM', isDark)),
              ],
            ),
            const SizedBox(height: 14),
            const DashboardWeeklyTaskBarChart(),
          ],
        ],
      ),
    );
  }

  // ===========================================================================
  // HELPER WIDGETS
  // ===========================================================================
  Widget _buildCardWrapper({required bool isDark, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: AppRadius.md,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          width: 0.8,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildSubMetric({
    required String label,
    required String value,
    required bool isDark,
    Color? valueColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 10,
            color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
          ),
        ),
        const SizedBox(height: 1),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: valueColor ?? (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
          ),
        ),
      ],
    );
  }

  Widget _buildPulseTile({
    required String label,
    required int count,
    required Color color,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: isDark ? 0.15 : 0.08),
        borderRadius: AppRadius.sm,
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Text(
            count.toString().padLeft(2, '0'),
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 10.5,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniCount(String label, String value, Color color, bool isDark) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 9.5,
            color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider(bool isDark) {
    return Container(
      width: 1,
      height: 20,
      color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
    );
  }

  Widget _buildFieldStatTile(String label, String value, String sub, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurfaceSubtle : const Color(0xFFF8FAFC),
        borderRadius: AppRadius.sm,
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(fontSize: 11, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
          ),
          Text(
            sub,
            style: GoogleFonts.inter(
              fontSize: 10,
              color: const Color(0xFF2563EB),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
