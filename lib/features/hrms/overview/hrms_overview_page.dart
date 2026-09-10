import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/responsive/breakpoints.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_radius.dart';
import '../data/hrms_repository.dart';
import '../widgets/hrms_header.dart';
import '../widgets/hrms_metric_card.dart';
import '../widgets/hrms_charts.dart';
import '../widgets/hrms_map_widget.dart';
import '../widgets/hrms_timeline.dart';
import '../widgets/attendance_punch_widget.dart';
import '../widgets/employee_registration_dialog.dart';
import '../widgets/leave_application_dialog.dart';
import '../widgets/travel_log_dialog.dart';

class HrmsOverviewPage extends StatefulWidget {
  const HrmsOverviewPage({super.key});

  @override
  State<HrmsOverviewPage> createState() => _HrmsOverviewPageState();
}

class _HrmsOverviewPageState extends State<HrmsOverviewPage> {
  final _repo = HrmsRepository();

  @override
  void initState() {
    super.initState();
    _repo.addListener(_onRepoChanged);
  }

  @override
  void dispose() {
    _repo.removeListener(_onRepoChanged);
    super.dispose();
  }

  void _onRepoChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isCompact = MediaQuery.of(context).size.width < 768;
    final isMedium = MediaQuery.of(context).size.width < 1100;

    final stats = _repo.getDashboardStats();
    final departments = _repo.departments;
    final activities = _repo.activities;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0B0E14) : const Color(0xFFF1F5F9),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isCompact ? AppSpacing.md : AppSpacing.lg),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: Breakpoints.maxContentWidth),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Executive Header with Quick Action Launchers
                HrmsHeader(
                  title: 'HRMS Executive Command Center',
                  subtitle: 'Centralized Workforce Lifecycle, GPS Geofenced Attendance, Policy Penalties & Payroll',
                  icon: Icons.shield_outlined,
                  badgeText: 'HOMIO ENTERPRISE',
                  badgeColor: AppColors.primary,
                  actions: [
                    OutlinedButton.icon(
                      onPressed: () => LeaveApplicationDialog.show(context),
                      style: OutlinedButton.styleFrom(
                        visualDensity: VisualDensity.compact,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      icon: const Icon(Icons.event_busy, size: 16),
                      label: Text('Apply Leave', style: GoogleFonts.plusJakartaSans(fontSize: 12)),
                    ),
                    OutlinedButton.icon(
                      onPressed: () => TravelLogDialog.show(context),
                      style: OutlinedButton.styleFrom(
                        visualDensity: VisualDensity.compact,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      icon: const Icon(Icons.add_road, size: 16),
                      label: Text('Log Travel', style: GoogleFonts.plusJakartaSans(fontSize: 12)),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => EmployeeRegistrationDialog.show(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        visualDensity: VisualDensity.compact,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      ),
                      icon: const Icon(Icons.person_add_alt_1, size: 16),
                      label: Text('Onboard Employee', style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),

                // 2. High-Impact KPI Metric Grid
                _buildMetricsGrid(context, stats, isCompact),
                const SizedBox(height: AppSpacing.md),

                // 3. Middle Section: Live Geofence Terminal + Radar Map + Visual Analytics
                if (isMedium) ...[
                  AttendancePunchWidget(onPunchCompleted: () => setState(() {})),
                  const SizedBox(height: AppSpacing.md),
                  const HrmsMapWidget(
                    locationTitle: 'Homio Global HQ - BKC Geofence (Active)',
                    centerLat: 19.0657,
                    centerLng: 72.8687,
                    radiusMeters: 180.0,
                    isInside: true,
                    height: 240,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  const AttendanceTrendBarChart(),
                  const SizedBox(height: AppSpacing.md),
                  DepartmentDistributionDonutChart(departments: departments),
                ] else ...[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Left Column: Interactive Terminal & Geofence Map
                      Expanded(
                        flex: 6,
                        child: Column(
                          children: [
                            AttendancePunchWidget(onPunchCompleted: () => setState(() {})),
                            const SizedBox(height: AppSpacing.md),
                            const HrmsMapWidget(
                              locationTitle: 'Homio Global HQ - BKC Geofence (Active)',
                              centerLat: 19.0657,
                              centerLng: 72.8687,
                              radiusMeters: 180.0,
                              isInside: true,
                              height: 220,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),

                      // Right Column: Charts & Workforce Distribution
                      Expanded(
                        flex: 5,
                        child: Column(
                          children: [
                            const AttendanceTrendBarChart(),
                            const SizedBox(height: AppSpacing.md),
                            DepartmentDistributionDonutChart(departments: departments),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: AppSpacing.md),

                // 4. Bottom Row: Urgent Attention & Policy Queue vs Activity Timeline
                if (isMedium) ...[
                  _buildUrgentAttentionQueue(isDark),
                  const SizedBox(height: AppSpacing.md),
                  _buildActivityCard(activities, isDark),
                ] else ...[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 6,
                        child: _buildUrgentAttentionQueue(isDark),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        flex: 5,
                        child: _buildActivityCard(activities, isDark),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMetricsGrid(BuildContext context, dynamic stats, bool isCompact) {
    final cards = [
      HrmsMetricCard(
        title: 'Total Headcount',
        value: '${stats.totalHeadcount} Staff',
        subtitle: '${stats.activeEmployees} Active • ${stats.onProbation} Probation',
        icon: Icons.groups_rounded,
        accentColor: const Color(0xFF3B82F6),
        trend: '+2 New',
        isTrendPositive: true,
      ),
      HrmsMetricCard(
        title: "Today's Attendance",
        value: '${stats.presentToday} Present',
        subtitle: '${stats.lateToday} Late • ${stats.absentToday} On Leave',
        icon: Icons.fingerprint,
        accentColor: const Color(0xFF10B981),
        trend: '91.6%',
        isTrendPositive: true,
      ),
      HrmsMetricCard(
        title: 'Monthly Payroll Budget',
        value: '₹14.85 L',
        subtitle: '₹13.80L Disbursed (August)',
        icon: Icons.payments_rounded,
        accentColor: const Color(0xFF8B5CF6),
        trend: '100% Paid',
        isTrendPositive: true,
      ),
      HrmsMetricCard(
        title: 'Actionable Approvals',
        value: '${stats.pendingLeaveRequests + stats.pendingTravelClaims + stats.pendingClearanceCount} Pending',
        subtitle: '${stats.pendingLeaveRequests} Leaves • ${stats.pendingClearanceCount} Clearances',
        icon: Icons.notifications_active_rounded,
        accentColor: const Color(0xFFF59E0B),
        trend: 'Requires Action',
        isTrendPositive: false,
      ),
    ];

    if (isCompact) {
      return Column(
        children: cards.map((c) => Padding(padding: const EdgeInsets.only(bottom: 8), child: c)).toList(),
      );
    }

    return Row(
      children: cards.map((c) => Expanded(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 4), child: c))).toList(),
    );
  }

  Widget _buildUrgentAttentionQueue(bool isDark) {
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
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEF4444).withValues(alpha: 0.12),
                      borderRadius: AppRadius.sm,
                    ),
                    child: const Icon(Icons.warning_amber_rounded, size: 18, color: Color(0xFFEF4444)),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Urgent Compliance & Policy Queue',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFEF4444).withValues(alpha: 0.12),
                  borderRadius: AppRadius.full,
                ),
                child: Text(
                  '3 Priority Alerts',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFFEF4444),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // Item 1: Double Salary Deduction Rule Triggered
          _buildAlertTile(
            title: 'Policy Double Salary Deduction Applied',
            description: 'Rohan Deshmukh took unapproved absence on critical concrete pour date. 2.0x daily rate deduction (₹2,800) queued for payroll cycle.',
            tag: 'STRICT DEDUCTION',
            tagColor: const Color(0xFFEF4444),
            icon: Icons.gavel_rounded,
            isDark: isDark,
          ),
          const SizedBox(height: 8),

          // Item 2: Outside Geofence Boundary Breach
          _buildAlertTile(
            title: 'Geofence Proximity Warning: 210m Outside Hub',
            description: 'Rohan Deshmukh clock-in flagged from outer circle parking lot. Requires site manager verification.',
            tag: 'BOUNDARY WARNING',
            tagColor: const Color(0xFFF59E0B),
            icon: Icons.location_off_rounded,
            isDark: isDark,
          ),
          const SizedBox(height: 8),

          // Item 3: Resignation Clearance Pending
          _buildAlertTile(
            title: 'Exit Clearance: IT Hardware Return Pending',
            description: 'Rohan Deshmukh (Last Working Day: Sep 15). Bosch laser meter & factory SIM return pending with IT Lead.',
            tag: 'NO-DUES PENDING',
            tagColor: const Color(0xFF8B5CF6),
            icon: Icons.devices_other_rounded,
            isDark: isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildAlertTile({
    required String title,
    required String description,
    required String tag,
    required Color tagColor,
    required IconData icon,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: tagColor.withValues(alpha: isDark ? 0.08 : 0.04),
        borderRadius: AppRadius.md,
        border: Border.all(color: tagColor.withValues(alpha: 0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: tagColor),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: tagColor.withValues(alpha: 0.15),
                        borderRadius: AppRadius.sm,
                      ),
                      child: Text(
                        tag,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: tagColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  description,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityCard(List<dynamic> activities, bool isDark) {
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
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.12),
                      borderRadius: AppRadius.sm,
                    ),
                    child: const Icon(Icons.history_toggle_off_rounded, size: 18, color: AppColors.primary),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Real-Time Workforce Activity Feed',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),
              Text(
                'Live GPS Sync',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  color: const Color(0xFF10B981),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          HrmsTimeline(activities: activities.cast()),
        ],
      ),
    );
  }
}
