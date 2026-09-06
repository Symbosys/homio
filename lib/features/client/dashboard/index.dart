import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/responsive/breakpoints.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';

// ============================================================================
// 1. DATA MODELS FOR CLIENT ANALYTICS DASHBOARD
// ============================================================================

enum ProjectHealthStatus {
  onSchedule('ON SCHEDULE', Color(0xFF10B981), Icons.verified_rounded),
  delayed('DELAYED', Color(0xFFEF4444), Icons.warning_amber_rounded),
  aheadOfSchedule('AHEAD OF SCHEDULE', Color(0xFF3B82F6), Icons.trending_up_rounded);

  final String label;
  final Color color;
  final IconData icon;
  const ProjectHealthStatus(this.label, this.color, this.icon);
}

class ClientDashboardProject {
  final String id;
  final String title;
  final String subtitle;
  final String location;
  final double totalBudget;
  final double spentAmount;
  final double balanceAmount;
  final double progressPercent;
  final ProjectHealthStatus healthStatus;
  final int daysRemaining;
  final String targetCompletionDate;
  final String primaryPmName;
  final String primaryPmPhone;
  final String activeStageName;

  const ClientDashboardProject({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.location,
    required this.totalBudget,
    required this.spentAmount,
    required this.balanceAmount,
    required this.progressPercent,
    required this.healthStatus,
    required this.daysRemaining,
    required this.targetCompletionDate,
    required this.primaryPmName,
    required this.primaryPmPhone,
    required this.activeStageName,
  });
}

class SpendDataPoint {
  final int monthIndex;
  final String label;
  final double plannedSpend; // In Lakhs (e.g. 5.0 = ₹5 Lakhs)
  final double actualSpend;  // In Lakhs
  final String milestoneName;

  const SpendDataPoint({
    required this.monthIndex,
    required this.label,
    required this.plannedSpend,
    required this.actualSpend,
    required this.milestoneName,
  });
}

class ExpenseCategory {
  final String name;
  final double amount; // In Lakhs
  final double percentage;
  final Color color;
  final IconData icon;
  final String description;

  const ExpenseCategory({
    required this.name,
    required this.amount,
    required this.percentage,
    required this.color,
    required this.icon,
    required this.description,
  });
}

class MilestoneVelocityItem {
  final String stageCode;
  final String stageName;
  final int plannedDays;
  final int actualDays;
  final double progressPercent;
  final String statusLabel;
  final Color statusColor;

  const MilestoneVelocityItem({
    required this.stageCode,
    required this.stageName,
    required this.plannedDays,
    required this.actualDays,
    required this.progressPercent,
    required this.statusLabel,
    required this.statusColor,
  });
}

class QualityInspectionScore {
  final String dimension;
  final double score; // 0 to 100
  final Color color;
  final IconData icon;
  final String note;

  const QualityInspectionScore({
    required this.dimension,
    required this.score,
    required this.color,
    required this.icon,
    required this.note,
  });
}

enum ApprovalItemStatus { pending, approved, revisionRequested }

class ClientApprovalItem {
  final String id;
  final String title;
  final String category;
  final String requestedDate;
  final String dueDate;
  final String costImpact;
  final ApprovalItemStatus status;
  final String? approvedTimestamp;

  const ClientApprovalItem({
    required this.id,
    required this.title,
    required this.category,
    required this.requestedDate,
    required this.dueDate,
    required this.costImpact,
    required this.status,
    this.approvedTimestamp,
  });

  ClientApprovalItem copyWith({
    ApprovalItemStatus? status,
    String? approvedTimestamp,
  }) {
    return ClientApprovalItem(
      id: id,
      title: title,
      category: category,
      requestedDate: requestedDate,
      dueDate: dueDate,
      costImpact: costImpact,
      status: status ?? this.status,
      approvedTimestamp: approvedTimestamp ?? this.approvedTimestamp,
    );
  }
}

enum PaymentStageStatus { paid, dueNow, upcoming }

class PaymentScheduleItem {
  final int milestoneNumber;
  final String title;
  final double amount; // in Lakhs
  final String invoiceNumber;
  final String date;
  final PaymentStageStatus status;

  const PaymentScheduleItem({
    required this.milestoneNumber,
    required this.title,
    required this.amount,
    required this.invoiceNumber,
    required this.date,
    required this.status,
  });
}

class LiveAuditItem {
  final String title;
  final String time;
  final String author;
  final String role;
  final IconData icon;
  final Color iconColor;

  const LiveAuditItem({
    required this.title,
    required this.time,
    required this.author,
    required this.role,
    required this.icon,
    required this.iconColor,
  });
}

// ============================================================================
// 2. MOCK DATASET (VILLA 402 - LUXURY TURNKEY)
// ============================================================================

class ClientDashboardMockData {
  static const project = ClientDashboardProject(
    id: 'proj_villa_402',
    title: 'Villa 402 - 3BHK Turnkey Interior',
    subtitle: 'Luxury Contemporary Residence • 2,850 sq.ft',
    location: 'DLF Phase 5, Golf Course Rd, Gurugram',
    totalBudget: 38.00, // ₹38.0 Lakhs
    spentAmount: 28.40, // ₹28.4 Lakhs
    balanceAmount: 9.60, // ₹9.6 Lakhs
    progressPercent: 72.4,
    healthStatus: ProjectHealthStatus.onSchedule,
    daysRemaining: 71,
    targetCompletionDate: '15 Nov 2026',
    primaryPmName: 'Arjun Verma',
    primaryPmPhone: '+91 98112 34567',
    activeStageName: 'False Ceiling & Modular Woodwork',
  );

  static const List<SpendDataPoint> spendTimeline = [
    SpendDataPoint(
      monthIndex: 0,
      label: 'Jun',
      plannedSpend: 5.0,
      actualSpend: 5.0,
      milestoneName: 'Mobilization & Civil Demolition',
    ),
    SpendDataPoint(
      monthIndex: 1,
      label: 'Jul',
      plannedSpend: 11.5,
      actualSpend: 11.0,
      milestoneName: 'Masonry & Wall Plastering',
    ),
    SpendDataPoint(
      monthIndex: 2,
      label: 'Aug',
      plannedSpend: 18.5,
      actualSpend: 19.2,
      milestoneName: 'Electrical & Plumbing Rough-in',
    ),
    SpendDataPoint(
      monthIndex: 3,
      label: 'Sep',
      plannedSpend: 26.0,
      actualSpend: 28.4,
      milestoneName: 'False Ceiling & POP Framing',
    ),
    SpendDataPoint(
      monthIndex: 4,
      label: 'Oct',
      plannedSpend: 33.5,
      actualSpend: 28.4, // Forecasted
      milestoneName: 'Modular Kitchen & Wardrobes (Est.)',
    ),
    SpendDataPoint(
      monthIndex: 5,
      label: 'Nov',
      plannedSpend: 38.0,
      actualSpend: 28.4, // Forecasted
      milestoneName: 'Final Finishes, Deep Clean & Handover',
    ),
  ];

  static const List<ExpenseCategory> expenseBreakdown = [
    ExpenseCategory(
      name: 'Custom Carpentry & Woodwork',
      amount: 12.16,
      percentage: 32.0,
      color: Color(0xFF6366F1), // Indigo
      icon: Icons.chair_rounded,
      description: 'HDMR carcass, Merino laminates, Blum hinges',
    ),
    ExpenseCategory(
      name: 'Civil & Masonry Works',
      amount: 10.64,
      percentage: 28.0,
      color: Color(0xFF3B82F6), // Blue
      icon: Icons.foundation_rounded,
      description: 'Demolition, partition walls, Italian marble screed',
    ),
    ExpenseCategory(
      name: 'Electrical & Smart Automation',
      amount: 6.84,
      percentage: 18.0,
      color: Color(0xFF10B981), // Emerald
      icon: Icons.bolt_rounded,
      description: 'Finolex FRLS wiring, Lutron smart lighting',
    ),
    ExpenseCategory(
      name: 'Premium Paints & Textures',
      amount: 4.56,
      percentage: 12.0,
      color: Color(0xFFF59E0B), // Amber
      icon: Icons.format_paint_rounded,
      description: 'Asian Paints Royale Aspire PU & Lime plaster',
    ),
    ExpenseCategory(
      name: 'Fixtures, Hardware & Decor',
      amount: 3.80,
      percentage: 10.0,
      color: Color(0xFFEC4899), // Pink
      icon: Icons.bathtub_rounded,
      description: 'Kohler matte black faucets, Hafele architectural locks',
    ),
  ];

  static const List<MilestoneVelocityItem> milestoneVelocities = [
    MilestoneVelocityItem(
      stageCode: 'S1',
      stageName: 'Concept & 3D Renders',
      plannedDays: 18,
      actualDays: 15,
      progressPercent: 100.0,
      statusLabel: 'Completed',
      statusColor: Color(0xFF10B981),
    ),
    MilestoneVelocityItem(
      stageCode: 'S2',
      stageName: 'Civil & Masonry',
      plannedDays: 30,
      actualDays: 28,
      progressPercent: 100.0,
      statusLabel: 'Completed',
      statusColor: Color(0xFF10B981),
    ),
    MilestoneVelocityItem(
      stageCode: 'S3',
      stageName: 'Plumbing & Electrical',
      plannedDays: 24,
      actualDays: 25,
      progressPercent: 100.0,
      statusLabel: 'Completed',
      statusColor: Color(0xFF10B981),
    ),
    MilestoneVelocityItem(
      stageCode: 'S4',
      stageName: 'False Ceiling & POP',
      plannedDays: 20,
      actualDays: 18,
      progressPercent: 100.0,
      statusLabel: 'Completed',
      statusColor: Color(0xFF10B981),
    ),
    MilestoneVelocityItem(
      stageCode: 'S5',
      stageName: 'Carpentry & Wardrobes',
      plannedDays: 35,
      actualDays: 22,
      progressPercent: 68.0,
      statusLabel: 'In Progress (Active)',
      statusColor: Color(0xFF3B82F6),
    ),
    MilestoneVelocityItem(
      stageCode: 'S6',
      stageName: 'Finishes & Handover',
      plannedDays: 15,
      actualDays: 0,
      progressPercent: 0.0,
      statusLabel: 'Upcoming',
      statusColor: Color(0xFF94A3B8),
    ),
  ];

  static const List<QualityInspectionScore> qualityScores = [
    QualityInspectionScore(
      dimension: 'Structural & Civil Integrity',
      score: 99.4,
      color: Color(0xFF10B981),
      icon: Icons.verified_user_rounded,
      note: 'Zero cracks, perfect water leveling on floor screed',
    ),
    QualityInspectionScore(
      dimension: 'Material Spec Compliance',
      score: 98.6,
      color: Color(0xFF6366F1),
      icon: Icons.check_circle_outline_rounded,
      note: '100% CenturyPly Club Prime & Finolex certified batch',
    ),
    QualityInspectionScore(
      dimension: 'Joinery & Surface Detailing',
      score: 95.0,
      color: Color(0xFFF59E0B),
      icon: Icons.carpenter_rounded,
      note: 'Flush millimeter reveals on acoustic false ceiling',
    ),
    QualityInspectionScore(
      dimension: 'Timeline & Milestone Adherence',
      score: 96.8,
      color: Color(0xFF3B82F6),
      icon: Icons.alarm_on_rounded,
      note: 'Overall project executing 5 days ahead of baseline schedule',
    ),
  ];

  static const List<PaymentScheduleItem> paymentSchedule = [
    PaymentScheduleItem(
      milestoneNumber: 1,
      title: 'Booking Deposit & 3D Render Sign-off',
      amount: 5.00,
      invoiceNumber: 'INV-2026-081',
      date: '10 Jun 2026',
      status: PaymentStageStatus.paid,
    ),
    PaymentScheduleItem(
      milestoneNumber: 2,
      title: 'Civil Demolition & Wall Masonry',
      amount: 6.50,
      invoiceNumber: 'INV-2026-114',
      date: '02 Jul 2026',
      status: PaymentStageStatus.paid,
    ),
    PaymentScheduleItem(
      milestoneNumber: 3,
      title: 'Electrical & Plumbing Rough-in',
      amount: 7.50,
      invoiceNumber: 'INV-2026-189',
      date: '28 Jul 2026',
      status: PaymentStageStatus.paid,
    ),
    PaymentScheduleItem(
      milestoneNumber: 4,
      title: 'False Ceiling & Gypsum Framing',
      amount: 9.40,
      invoiceNumber: 'INV-2026-240',
      date: '20 Aug 2026',
      status: PaymentStageStatus.paid,
    ),
    PaymentScheduleItem(
      milestoneNumber: 5,
      title: 'Modular Kitchen & Wardrobe Carcass Delivery',
      amount: 6.00,
      invoiceNumber: 'INV-2026-302',
      date: 'Due Today (05 Sep)',
      status: PaymentStageStatus.dueNow,
    ),
    PaymentScheduleItem(
      milestoneNumber: 6,
      title: 'Final Snagging, Deep Clean & Handover',
      amount: 3.60,
      invoiceNumber: 'INV-2026-PEND',
      date: '15 Nov 2026',
      status: PaymentStageStatus.upcoming,
    ),
  ];

  static const List<ClientApprovalItem> pendingApprovals = [
    ClientApprovalItem(
      id: 'appr_01',
      title: 'Italian Botticino Marble Slab Selection (Living Area)',
      category: 'Flooring Material',
      requestedDate: '03 Sep 2026',
      dueDate: '08 Sep 2026',
      costImpact: 'Included in Contract',
      status: ApprovalItemStatus.pending,
    ),
    ClientApprovalItem(
      id: 'appr_02',
      title: 'Master Bedroom Smoked Oak Veneer & Fluted Panel Detail',
      category: 'Carpentry Finish',
      requestedDate: '04 Sep 2026',
      dueDate: '09 Sep 2026',
      costImpact: '+₹15,000 (Upgrade Requested)',
      status: ApprovalItemStatus.pending,
    ),
  ];

  static const List<LiveAuditItem> liveAudits = [
    LiveAuditItem(
      title: 'False ceiling perimeter LED channel inspection passed 100%',
      time: '2 hours ago',
      author: 'Vikram Singh',
      role: 'Site Supervisor',
      icon: Icons.check_circle_rounded,
      iconColor: Color(0xFF10B981),
    ),
    LiveAuditItem(
      title: '4K Site Walkthrough Video uploaded for Master Bedroom',
      time: '5 hours ago',
      author: 'Vikram Singh',
      role: 'Site Supervisor',
      icon: Icons.videocam_rounded,
      iconColor: Color(0xFF3B82F6),
    ),
    LiveAuditItem(
      title: 'Invoice INV-2026-240 for ₹9.40L marked as PAID via RTGS',
      time: 'Yesterday, 4:30 PM',
      author: 'Homio Accounts',
      role: 'Finance Desk',
      icon: Icons.receipt_rounded,
      iconColor: Color(0xFF6366F1),
    ),
    LiveAuditItem(
      title: 'Stage 4: False Ceiling & POP marked as 100% Completed',
      time: '3 days ago',
      author: 'Arjun Verma',
      role: 'Project Manager',
      icon: Icons.flag_rounded,
      iconColor: Color(0xFF10B981),
    ),
  ];
}

// ============================================================================
// 3. CLIENT DASHBOARD MAIN PAGE (SINGLE-FILE IMPLEMENTATION)
// ============================================================================

class ClientDashboardPage extends StatefulWidget {
  const ClientDashboardPage({super.key});

  @override
  State<ClientDashboardPage> createState() => _ClientDashboardPageState();
}

class _ClientDashboardPageState extends State<ClientDashboardPage> {
  int _selectedSpendTimelineIndex = 3; // Sep selected by default
  int _touchedPieIndex = -1;
  int _touchedBarIndex = -1;
  String _selectedSpendFilter = 'All-Time';
  late List<ClientApprovalItem> _approvalItems;

  @override
  void initState() {
    super.initState();
    _approvalItems = List.from(ClientDashboardMockData.pendingApprovals);
  }

  void _handleApprove(String id) {
    setState(() {
      _approvalItems = _approvalItems.map((item) {
        if (item.id == id) {
          return item.copyWith(
            status: ApprovalItemStatus.approved,
            approvedTimestamp: 'Signed: ${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}',
          );
        }
        return item;
      }).toList();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Specification Approved & Digitally Certified with Homio Audit Stamp!'),
        backgroundColor: Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _handleRequestChanges(String id) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Change Request dispatched to Project Manager Arjun Verma.'),
        backgroundColor: Color(0xFFF59E0B),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= Breakpoints.medium;
    final project = ClientDashboardMockData.project;
    final pendingCount = _approvalItems.where((i) => i.status == ApprovalItemStatus.pending).length;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0B0F19) : const Color(0xFFF8FAFC),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(
          horizontal: isDesktop ? 28.0 : 16.0,
          vertical: 20.0,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1440),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Hero Project Health & Overview Banner
                _buildHeroHeader(project, isDark, isDesktop),

                const SizedBox(height: 20),

                // 2. Executive KPI & Statistic Metrics Grid (6 Tiles with Mini fl_chart Sparklines)
                _buildKpiMetricsGrid(project, pendingCount, isDark, screenWidth),

                const SizedBox(height: 24),

                // 3. Primary Charts Row: Spend Area Chart + Expense Allocation Donut Chart
                if (isDesktop)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Spend Area Chart (60% width)
                      Expanded(
                        flex: 6,
                        child: _buildSpendAreaChartCard(isDark),
                      ),
                      const SizedBox(width: 20),
                      // Expense Donut Pie Chart (40% width)
                      Expanded(
                        flex: 4,
                        child: _buildExpenseDonutChartCard(isDark),
                      ),
                    ],
                  )
                else ...[
                  _buildSpendAreaChartCard(isDark),
                  const SizedBox(height: 20),
                  _buildExpenseDonutChartCard(isDark),
                ],

                const SizedBox(height: 24),

                // 4. Secondary Analytics Row: Milestone Velocity Grouped Bar Chart + Quality Scorecard
                if (isDesktop)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Milestone Velocity Grouped Bar Chart (60% width)
                      Expanded(
                        flex: 6,
                        child: _buildMilestoneVelocityCard(isDark),
                      ),
                      const SizedBox(width: 20),
                      // Quality & Compliance Index (40% width)
                      Expanded(
                        flex: 4,
                        child: _buildQualityRadarCard(isDark),
                      ),
                    ],
                  )
                else ...[
                  _buildMilestoneVelocityCard(isDark),
                  const SizedBox(height: 20),
                  _buildQualityRadarCard(isDark),
                ],

                const SizedBox(height: 24),

                // 5. Financial Milestone Invoicing & Payment Schedule Ledger (100% Full-Width Screen Expansion)
                _buildFinancialLedgerCard(isDark, isDesktop),

                const SizedBox(height: 24),

                // 6. Actionable Decisions (Pending Approvals) & Live Activity Feed
                if (isDesktop)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 6,
                        child: _buildPendingApprovalsCard(isDark),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        flex: 4,
                        child: _buildLiveActivityCard(isDark),
                      ),
                    ],
                  )
                else ...[
                  _buildPendingApprovalsCard(isDark),
                  const SizedBox(height: 20),
                  _buildLiveActivityCard(isDark),
                ],

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ==========================================================================
  // SECTION 1: HERO HEADER
  // ==========================================================================
  Widget _buildHeroHeader(ClientDashboardProject project, bool isDark, bool isDesktop) {
    return Container(
      padding: EdgeInsets.all(isDesktop ? 22.0 : 16.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [const Color(0xFF1E1B4B), const Color(0xFF0F172A)]
              : [const Color(0xFFEEF2FF), Colors.white],
        ),
        borderRadius: AppRadius.lg,
        border: Border.all(
          color: isDark ? const Color(0xFF312E81).withValues(alpha: 0.6) : const Color(0xFFE2E8F0),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6366F1).withValues(alpha: isDark ? 0.15 : 0.06),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: isDesktop
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Left Column: Status Pills, Title, Subtitle, Location
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Status Pills Row
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: project.healthStatus.color.withValues(alpha: 0.15),
                              borderRadius: AppRadius.full,
                              border: Border.all(color: project.healthStatus.color.withValues(alpha: 0.4)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(project.healthStatus.icon, size: 13, color: project.healthStatus.color),
                                const SizedBox(width: 5),
                                Text(
                                  project.healthStatus.label,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w700,
                                    color: project.healthStatus.color,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                            decoration: BoxDecoration(
                              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
                              borderRadius: AppRadius.full,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.timer_outlined, size: 13, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                                const SizedBox(width: 4),
                                Text(
                                  '${project.daysRemaining}d to Handover',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w600,
                                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // Title
                      Text(
                        project.title,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 4),

                      // Location & Subtitle
                      Row(
                        children: [
                          Icon(Icons.location_on_outlined, size: 14, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                          const SizedBox(width: 4),
                          Text(
                            project.location,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 24),

                // Right Column: Action Buttons
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    OutlinedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Calling Project Manager: ${project.primaryPmName} (${project.primaryPmPhone})'),
                            backgroundColor: const Color(0xFF10B981),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      icon: const Icon(Icons.phone_in_talk_rounded, size: 15),
                      label: Text('Call PM: ${project.primaryPmName}'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: isDark ? Colors.white : const Color(0xFF0F172A),
                        side: BorderSide(
                          color: isDark ? const Color(0xFF475569) : const Color(0xFFCBD5E1),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        textStyle: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Exporting Client Executive Analytics Report (PDF)...'),
                            backgroundColor: Color(0xFF6366F1),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      icon: const Icon(Icons.download_rounded, size: 15, color: Colors.white),
                      label: const Text('Export Analytics'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6366F1),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        textStyle: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 8,
                  runSpacing: 6,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: project.healthStatus.color.withValues(alpha: 0.15),
                        borderRadius: AppRadius.full,
                        border: Border.all(color: project.healthStatus.color.withValues(alpha: 0.4)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(project.healthStatus.icon, size: 13, color: project.healthStatus.color),
                          const SizedBox(width: 5),
                          Text(
                            project.healthStatus.label,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w700,
                              color: project.healthStatus.color,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
                        borderRadius: AppRadius.full,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.timer_outlined, size: 13, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                          const SizedBox(width: 4),
                          Text(
                            '${project.daysRemaining}d to Handover',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w600,
                              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  project.title,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                    letterSpacing: -0.4,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.location_on_outlined, size: 13, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        project.location,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w500,
                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Calling Project Manager: ${project.primaryPmName}'),
                              backgroundColor: const Color(0xFF10B981),
                            ),
                          );
                        },
                        icon: const Icon(Icons.phone_in_talk_rounded, size: 14),
                        label: Text('Call PM', style: GoogleFonts.plusJakartaSans(fontSize: 11)),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.download_rounded, size: 14, color: Colors.white),
                        label: Text('Export', style: GoogleFonts.plusJakartaSans(fontSize: 11, color: Colors.white)),
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6366F1)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
    );
  }

  // ==========================================================================
  // SECTION 2: 6 EXECUTIVE KPI METRIC CARDS WITH fl_chart SPARKLINE
  // ==========================================================================
  Widget _buildKpiMetricsGrid(
    ClientDashboardProject project,
    int pendingCount,
    bool isDark,
    double screenWidth,
  ) {
    final kpis = [
      _KpiCardData(
        title: 'OVERALL COMPLETION',
        value: '${project.progressPercent}%',
        subtitle: '+4.2% this week',
        icon: Icons.pie_chart_outline_rounded,
        color: const Color(0xFF6366F1),
        sparklineSpots: const [FlSpot(0, 45), FlSpot(1, 52), FlSpot(2, 58), FlSpot(3, 64), FlSpot(4, 68.2), FlSpot(5, 72.4)],
        badgeText: 'Stage 5/6',
      ),
      _KpiCardData(
        title: 'EXECUTION VELOCITY',
        value: '94.8%',
        subtitle: '5 days ahead',
        icon: Icons.speed_rounded,
        color: const Color(0xFF10B981),
        sparklineSpots: const [FlSpot(0, 88), FlSpot(1, 90.5), FlSpot(2, 91), FlSpot(3, 93), FlSpot(4, 93.8), FlSpot(5, 94.8)],
        badgeText: 'A+ Grade',
      ),
      _KpiCardData(
        title: 'CUMULATIVE SPENT',
        value: '₹${project.spentAmount.toStringAsFixed(1)}L',
        subtitle: 'of ₹${project.totalBudget.toStringAsFixed(1)}L total',
        icon: Icons.account_balance_wallet_outlined,
        color: const Color(0xFF3B82F6),
        sparklineSpots: const [FlSpot(0, 5), FlSpot(1, 11), FlSpot(2, 19.2), FlSpot(3, 24), FlSpot(4, 26.5), FlSpot(5, 28.4)],
        badgeText: '74.7% Paid',
      ),
      _KpiCardData(
        title: 'QUALITY AUDIT SCORE',
        value: '99.2%',
        subtitle: '48/48 checklist passed',
        icon: Icons.shield_outlined,
        color: const Color(0xFF8B5CF6),
        sparklineSpots: const [FlSpot(0, 96), FlSpot(1, 97.5), FlSpot(2, 98), FlSpot(3, 98.5), FlSpot(4, 99), FlSpot(5, 99.2)],
        badgeText: 'Zero Defects',
      ),
      _KpiCardData(
        title: 'PENDING SIGN-OFFS',
        value: '$pendingCount Items',
        subtitle: pendingCount > 0 ? 'Action required' : 'All clear',
        icon: Icons.assignment_late_outlined,
        color: pendingCount > 0 ? const Color(0xFFEF4444) : const Color(0xFF10B981),
        sparklineSpots: [const FlSpot(0, 4), const FlSpot(1, 3), const FlSpot(2, 3), const FlSpot(3, 2), const FlSpot(4, 2), FlSpot(5, pendingCount.toDouble())],
        badgeText: pendingCount > 0 ? 'Urgent' : 'Up to Date',
      ),
      _KpiCardData(
        title: 'BALANCE DUE',
        value: '₹${project.balanceAmount.toStringAsFixed(1)}L',
        subtitle: 'Next: ₹6.0L Due Now',
        icon: Icons.payments_outlined,
        color: const Color(0xFFF59E0B),
        sparklineSpots: const [FlSpot(0, 33), FlSpot(1, 27), FlSpot(2, 18.8), FlSpot(3, 14), FlSpot(4, 11.5), FlSpot(5, 9.6)],
        badgeText: '2 Stages Left',
      ),
    ];

    int crossAxisCount = 6;
    if (screenWidth < 650) {
      crossAxisCount = 2;
    } else if (screenWidth < 1100) {
      crossAxisCount = 3;
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = (constraints.maxWidth - (crossAxisCount - 1) * 12) / crossAxisCount;
        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: kpis.map((kpi) {
            return SizedBox(
              width: cardWidth,
              child: _buildSingleKpiCard(kpi, isDark),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildSingleKpiCard(_KpiCardData kpi, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: AppRadius.md,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withValues(alpha: 0.2) : const Color(0xFF0F172A).withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row: Icon + Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: kpi.color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(kpi.icon, size: 14, color: kpi.color),
              ),
              const SizedBox(width: 4),
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  decoration: BoxDecoration(
                    color: kpi.color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    kpi.badgeText,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 8.5,
                      fontWeight: FontWeight.w700,
                      color: kpi.color,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Title
          Text(
            kpi.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 9.5,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.4,
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
            ),
          ),
          const SizedBox(height: 2),

          // Value + fl_chart Mini LineChart Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Text(
                  kpi.value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                    letterSpacing: -0.3,
                  ),
                ),
              ),
              SizedBox(
                width: 44,
                height: 22,
                child: LineChart(
                  LineChartData(
                    gridData: const FlGridData(show: false),
                    titlesData: const FlTitlesData(show: false),
                    borderData: FlBorderData(show: false),
                    lineTouchData: const LineTouchData(enabled: false),
                    lineBarsData: [
                      LineChartBarData(
                        spots: kpi.sparklineSpots,
                        isCurved: true,
                        color: kpi.color,
                        barWidth: 2,
                        isStrokeCapRound: true,
                        dotData: const FlDotData(show: false),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),

          // Subtitle
          Text(
            kpi.subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 10.5,
              fontWeight: FontWeight.w500,
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================================
  // SECTION 3: CUMULATIVE SPEND AREA CHART CARD (fl_chart INTERACTIVE)
  // ==========================================================================
  Widget _buildSpendAreaChartCard(bool isDark) {
    final points = ClientDashboardMockData.spendTimeline;
    final activePoint = points[_selectedSpendTimelineIndex];

    final actualSpots = [
      const FlSpot(0, 5.0),
      const FlSpot(1, 11.0),
      const FlSpot(2, 19.2),
      const FlSpot(3, 28.4),
    ];

    final plannedSpots = [
      const FlSpot(0, 5.0),
      const FlSpot(1, 11.5),
      const FlSpot(2, 18.5),
      const FlSpot(3, 26.0),
      const FlSpot(4, 33.5),
      const FlSpot(5, 38.0),
    ];

    final projectedSpots = [
      const FlSpot(3, 28.4),
      const FlSpot(4, 33.5),
      const FlSpot(5, 38.0),
    ];

    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: AppRadius.lg,
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withValues(alpha: 0.2) : const Color(0xFF0F172A).withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Title + Timeline filter chips
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 12,
            runSpacing: 8,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'BUDGET BURN-DOWN & CUMULATIVE SPEND',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.6,
                      color: const Color(0xFF6366F1),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Planned Cumulative Budget vs. Actual Invoiced Spend',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),

              // Filter Toggles
              Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: ['Monthly', 'Phase', 'All-Time'].map((filter) {
                    final isSelected = _selectedSpendFilter == filter;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedSpendFilter = filter),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? (isDark ? const Color(0xFF334155) : Colors.white)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(6),
                          boxShadow: isSelected
                              ? [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4)]
                              : null,
                        ),
                        child: Text(
                          filter,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                            color: isSelected
                                ? (isDark ? Colors.white : const Color(0xFF0F172A))
                                : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Chart Legends
          Wrap(
            spacing: 16,
            runSpacing: 6,
            children: [
              _buildChartLegend(
                color: const Color(0xFF10B981),
                label: 'Actual Spend (Recorded: ₹28.40L)',
                isDark: isDark,
              ),
              _buildChartLegend(
                color: const Color(0xFF6366F1),
                label: 'Planned Baseline (Target: ₹38.00L)',
                isDark: isDark,
              ),
              _buildChartLegend(
                color: const Color(0xFFF59E0B),
                label: 'Forecast Projected (Oct-Nov)',
                isDark: isDark,
              ),
            ],
          ),

          const SizedBox(height: 18),

          // High-Performance Interactive LineChart with Hover Tooltips
          SizedBox(
            height: 220,
            width: double.infinity,
            child: LineChart(
              LineChartData(
                minX: 0,
                maxX: 5,
                minY: 0,
                maxY: 42,
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 10,
                  getDrawingHorizontalLine: (val) {
                    return FlLine(
                      color: isDark ? const Color(0xFF334155).withValues(alpha: 0.5) : const Color(0xFFE2E8F0),
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 10,
                      reservedSize: 38,
                      getTitlesWidget: (value, meta) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 6.0),
                          child: Text(
                            '₹${value.toInt()}L',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      reservedSize: 26,
                      getTitlesWidget: (value, meta) {
                        final idx = value.toInt();
                        if (idx >= 0 && idx < points.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 6.0),
                            child: Text(
                              points[idx].label,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w600,
                                color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
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
                lineTouchData: LineTouchData(
                  enabled: true,
                  handleBuiltInTouches: true,
                  touchCallback: (FlTouchEvent event, LineTouchResponse? touchResponse) {
                    if (touchResponse != null && touchResponse.lineBarSpots != null && touchResponse.lineBarSpots!.isNotEmpty) {
                      final spot = touchResponse.lineBarSpots!.first;
                      final newIdx = spot.spotIndex.clamp(0, points.length - 1);
                      if (newIdx != _selectedSpendTimelineIndex) {
                        setState(() => _selectedSpendTimelineIndex = newIdx);
                      }
                    }
                  },
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipColor: (touchedSpot) => isDark ? const Color(0xFF0F172A) : Colors.white,
                    tooltipPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((spot) {
                        final idx = spot.spotIndex;
                        final p = points[idx];
                        if (spot.barIndex == 0) {
                          return LineTooltipItem(
                            '${p.label} 2026\nActual Spend: ₹${spot.y.toStringAsFixed(1)}L',
                            GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF10B981),
                            ),
                          );
                        } else {
                          return LineTooltipItem(
                            'Planned: ₹${spot.y.toStringAsFixed(1)}L',
                            GoogleFonts.plusJakartaSans(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF6366F1),
                            ),
                          );
                        }
                      }).toList();
                    },
                  ),
                ),
                lineBarsData: [
                  // 1. Actual Spend (Emerald with Gradient Area Fill)
                  LineChartBarData(
                    spots: actualSpots,
                    isCurved: true,
                    curveSmoothness: 0.35,
                    color: const Color(0xFF10B981),
                    barWidth: 3.5,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        final isSelected = index == _selectedSpendTimelineIndex;
                        return FlDotCirclePainter(
                          radius: isSelected ? 6.5 : 4.0,
                          color: const Color(0xFF10B981),
                          strokeWidth: 2,
                          strokeColor: Colors.white,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          const Color(0xFF10B981).withValues(alpha: isDark ? 0.35 : 0.22),
                          const Color(0xFF10B981).withValues(alpha: 0.0),
                        ],
                      ),
                    ),
                  ),

                  // 2. Planned Target Curve (Indigo Tint)
                  LineChartBarData(
                    spots: plannedSpots,
                    isCurved: true,
                    curveSmoothness: 0.35,
                    color: const Color(0xFF6366F1).withValues(alpha: 0.45),
                    barWidth: 2,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                  ),

                  // 3. Projected Extension (Dashed Amber)
                  LineChartBarData(
                    spots: projectedSpots,
                    isCurved: true,
                    curveSmoothness: 0.35,
                    color: const Color(0xFFF59E0B).withValues(alpha: 0.75),
                    barWidth: 2,
                    dashArray: [5, 5],
                    dotData: const FlDotData(show: false),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 14),

          // Dynamic Inspector Card for Selected Month
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
              borderRadius: AppRadius.md,
              border: Border.all(
                color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(Icons.insights_rounded, size: 16, color: Color(0xFF10B981)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${activePoint.label} 2026 Milestone: ${activePoint.milestoneName}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                        ),
                      ),
                      Text(
                        'Actual Cumulative: ₹${activePoint.actualSpend.toStringAsFixed(1)}L  •  Planned Target: ₹${activePoint.plannedSpend.toStringAsFixed(1)}L  •  Variance: ${(activePoint.actualSpend - activePoint.plannedSpend >= 0 ? '+' : '')}${(activePoint.actualSpend - activePoint.plannedSpend).toStringAsFixed(1)}L',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        ),
                      ),
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

  Widget _buildChartLegend({
    required Color color,
    required String label,
    required bool isDark,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 14,
          height: 3,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
            ),
          ),
        ),
      ],
    );
  }

  // ==========================================================================
  // SECTION 4: EXPENSE BREAKDOWN DONUT/PIE CHART CARD (fl_chart INTERACTIVE)
  // ==========================================================================
  Widget _buildExpenseDonutChartCard(bool isDark) {
    final categories = ClientDashboardMockData.expenseBreakdown;

    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: AppRadius.lg,
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withValues(alpha: 0.2) : const Color(0xFF0F172A).withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            'BUDGET ALLOCATION BY TRADE',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.6,
              color: const Color(0xFF6366F1),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'Expense Distribution Across 5 Categories',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13.5,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
          ),

          const SizedBox(height: 16),

          // Interactive fl_chart Donut PieChart
          Center(
            child: SizedBox(
              width: 190,
              height: 190,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  PieChart(
                    PieChartData(
                      pieTouchData: PieTouchData(
                        touchCallback: (FlTouchEvent event, pieTouchResponse) {
                          setState(() {
                            if (!event.isInterestedForInteractions ||
                                pieTouchResponse == null ||
                                pieTouchResponse.touchedSection == null) {
                              _touchedPieIndex = -1;
                              return;
                            }
                            _touchedPieIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                          });
                        },
                      ),
                      borderData: FlBorderData(show: false),
                      sectionsSpace: 3,
                      centerSpaceRadius: 52,
                      sections: categories.asMap().entries.map((entry) {
                        final i = entry.key;
                        final cat = entry.value;
                        final isTouched = i == _touchedPieIndex;
                        final radius = isTouched ? 36.0 : 28.0;
                        return PieChartSectionData(
                          color: cat.color,
                          value: cat.percentage,
                          title: '',
                          radius: radius,
                          badgePositionPercentageOffset: 0.98,
                        );
                      }).toList(),
                    ),
                  ),

                  // Center Cutout Total
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'TOTAL BUDGET',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.6,
                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        ),
                      ),
                      Text(
                        '₹38.0L',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                          letterSpacing: -0.4,
                        ),
                      ),
                      Text(
                        'Turnkey Scope',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 9.5,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF10B981),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Interactive Slices Legend List
          Column(
            children: categories.asMap().entries.map((entry) {
              final idx = entry.key;
              final cat = entry.value;
              final isSelected = _touchedPieIndex == idx;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _touchedPieIndex = (_touchedPieIndex == idx) ? -1 : idx;
                  });
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 6),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                  decoration: BoxDecoration(
                    color: isSelected ? cat.color.withValues(alpha: isDark ? 0.18 : 0.10) : Colors.transparent,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: isSelected ? cat.color.withValues(alpha: 0.4) : Colors.transparent,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: cat.color,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          cat.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11.5,
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                            color: isDark ? Colors.white : const Color(0xFF0F172A),
                          ),
                        ),
                      ),
                      Text(
                        '₹${cat.amount.toStringAsFixed(2)}L (${cat.percentage.toInt()}%)',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // ==========================================================================
  // SECTION 5: MILESTONE VELOCITY GROUPED BAR CHART CARD (fl_chart)
  // ==========================================================================
  Widget _buildMilestoneVelocityCard(bool isDark) {
    final items = ClientDashboardMockData.milestoneVelocities;

    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: AppRadius.lg,
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withValues(alpha: 0.2) : const Color(0xFF0F172A).withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header + Velocity Badge
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 12,
            runSpacing: 6,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'MILESTONE EXECUTION VELOCITY',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.6,
                      color: const Color(0xFF6366F1),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Planned Days vs. Actual Duration (Days)',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '⚡ 8.5% Ahead of Schedule',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF10B981),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Legends
          Wrap(
            spacing: 16,
            runSpacing: 6,
            children: [
              _buildChartLegend(
                color: const Color(0xFF6366F1).withValues(alpha: 0.45),
                label: 'Planned Target (Days)',
                isDark: isDark,
              ),
              _buildChartLegend(
                color: const Color(0xFF10B981),
                label: 'Completed Phase (Actual)',
                isDark: isDark,
              ),
              _buildChartLegend(
                color: const Color(0xFF3B82F6),
                label: 'Active Ongoing Phase',
                isDark: isDark,
              ),
            ],
          ),

          const SizedBox(height: 18),

          // Interactive fl_chart Grouped BarChart
          SizedBox(
            height: 190,
            width: double.infinity,
            child: BarChart(
              BarChartData(
                maxY: 42,
                barTouchData: BarTouchData(
                  enabled: true,
                  touchCallback: (event, response) {
                    if (response != null && response.spot != null) {
                      setState(() {
                        _touchedBarIndex = response.spot!.touchedBarGroupIndex;
                      });
                    }
                  },
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (group) => isDark ? const Color(0xFF0F172A) : Colors.white,
                    tooltipPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      final item = items[groupIndex];
                      final isPlanned = rodIndex == 0;
                      return BarTooltipItem(
                        '${item.stageName}\n${isPlanned ? "Planned: ${item.plannedDays}d" : "Actual: ${item.actualDays}d"}',
                        GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: isPlanned ? const Color(0xFF6366F1) : const Color(0xFF10B981),
                        ),
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 10,
                      reservedSize: 32,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '${value.toInt()}d',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                          ),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 26,
                      getTitlesWidget: (value, meta) {
                        final idx = value.toInt();
                        if (idx >= 0 && idx < items.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 6.0),
                            child: Text(
                              items[idx].stageCode,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: isDark ? Colors.white : const Color(0xFF0F172A),
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
                  horizontalInterval: 10,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: isDark ? const Color(0xFF334155).withValues(alpha: 0.5) : const Color(0xFFE2E8F0),
                    strokeWidth: 1,
                  ),
                ),
                borderData: FlBorderData(show: false),
                barGroups: items.asMap().entries.map((entry) {
                  final i = entry.key;
                  final item = entry.value;
                  final isTouched = i == _touchedBarIndex;

                  return BarChartGroupData(
                    x: i,
                    barsSpace: 5,
                    barRods: [
                      // Rod 1: Planned Target Days
                      BarChartRodData(
                        toY: item.plannedDays.toDouble(),
                        color: const Color(0xFF6366F1).withValues(alpha: 0.45),
                        width: isTouched ? 12 : 10,
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(3)),
                      ),
                      // Rod 2: Actual Duration Days
                      BarChartRodData(
                        toY: item.actualDays.toDouble(),
                        color: item.statusColor,
                        width: isTouched ? 12 : 10,
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(3)),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Footnote index of stages
          Wrap(
            spacing: 12,
            runSpacing: 4,
            children: items.map((it) {
              return Text(
                '${it.stageCode}: ${it.stageName}',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 9.5,
                  fontWeight: FontWeight.w500,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // ==========================================================================
  // SECTION 6: QUALITY & COMPLIANCE INDEX (4-PILLAR AUDIT)
  // ==========================================================================
  Widget _buildQualityRadarCard(bool isDark) {
    final scores = ClientDashboardMockData.qualityScores;

    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: AppRadius.lg,
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withValues(alpha: 0.2) : const Color(0xFF0F172A).withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 12,
            runSpacing: 6,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'QUALITY & COMPLIANCE INDEX',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.6,
                      color: const Color(0xFF6366F1),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '4-Pillar Quality Audit Metrics',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF6366F1).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'A+ Rating (96.8 / 100)',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF6366F1),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // 4 Score Progress Tiles
          Column(
            children: scores.map((item) {
              return Container(
                margin: const EdgeInsets.only(bottom: 10.0),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B).withValues(alpha: 0.4) : const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isDark ? const Color(0xFF334155).withValues(alpha: 0.5) : const Color(0xFFE2E8F0),
                  ),
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
                              Icon(item.icon, size: 14, color: item.color),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  item.dimension,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w700,
                                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${item.score.toStringAsFixed(1)}%',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: item.color,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: item.score / 100.0,
                        backgroundColor: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                        valueColor: AlwaysStoppedAnimation<Color>(item.color),
                        minHeight: 5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.note,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      ),
                    ),
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
  // SECTION 7: FINANCIAL INVOICING & PAYMENT SCHEDULE LEDGER (100% FULL-WIDTH)
  // ==========================================================================
  Widget _buildFinancialLedgerCard(bool isDark, bool isDesktop) {
    final schedule = ClientDashboardMockData.paymentSchedule;

    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: AppRadius.lg,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withValues(alpha: 0.2) : const Color(0xFF0F172A).withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 12,
            runSpacing: 8,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'FINANCIAL MILESTONE LEDGER & INVOICES',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.6,
                      color: const Color(0xFF6366F1),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Contract Value: ₹38.00 Lakhs  •  Paid: ₹28.40 Lakhs (74.7%)  •  Due: ₹6.00 Lakhs',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),

              // Pay via UPI CTA
              ElevatedButton.icon(
                onPressed: () {
                  _showPaymentModal(context, isDark);
                },
                icon: const Icon(Icons.qr_code_2_rounded, size: 16, color: Colors.white),
                label: const Text('Pay ₹6.00L via UPI / NetBanking'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF10B981),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  textStyle: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Horizontal Progress Bar
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Row(
                  children: [
                    // Paid portion (74.7%)
                    Flexible(
                      flex: 747,
                      child: Container(height: 10, color: const Color(0xFF10B981)),
                    ),
                    // Due now portion (15.8%)
                    Flexible(
                      flex: 158,
                      child: Container(height: 10, color: const Color(0xFFF59E0B)),
                    ),
                    // Upcoming balance (9.5%)
                    Flexible(
                      flex: 95,
                      child: Container(
                        height: 10,
                        color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 16,
                runSpacing: 4,
                children: [
                  _buildLedgerStatusLegend(const Color(0xFF10B981), 'Paid: ₹28.40L (74.7%)', isDark),
                  _buildLedgerStatusLegend(const Color(0xFFF59E0B), 'Due Now: ₹6.00L (15.8%)', isDark),
                  _buildLedgerStatusLegend(isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8), 'Upcoming: ₹3.60L (9.5%)', isDark),
                ],
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Full-Width Clean Ledger Table (Expands to 100% width across the card on all viewports)
          LayoutBuilder(
            builder: (context, constraints) {
              final double tableWidth = constraints.maxWidth < 820 ? 820.0 : constraints.maxWidth;
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: tableWidth,
                  child: Container(
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF0F172A).withValues(alpha: 0.3) : Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isDark ? const Color(0xFF334155).withValues(alpha: 0.5) : const Color(0xFFE2E8F0),
                        width: 1,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Header Row (100% full width spanning across the whole card)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 13,
                                  child: Text(
                                    'STAGE #',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w800,
                                      color: const Color(0xFF6366F1),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 28,
                                  child: Text(
                                    'MILESTONE DELIVERABLE',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w800,
                                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 15,
                                  child: Text(
                                    'AMOUNT',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w800,
                                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 15,
                                  child: Text(
                                    'INVOICE REF',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w800,
                                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 12,
                                  child: Text(
                                    'STATUS',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w800,
                                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 17,
                                  child: Text(
                                    'ACTION',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w800,
                                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Data Rows
                          ...schedule.asMap().entries.map((entry) {
                            final idx = entry.key;
                            final item = entry.value;
                            final isLast = idx == schedule.length - 1;

                            Color statusColor;
                            String statusText;
                            if (item.status == PaymentStageStatus.paid) {
                              statusColor = const Color(0xFF10B981);
                              statusText = 'PAID';
                            } else if (item.status == PaymentStageStatus.dueNow) {
                              statusColor = const Color(0xFFF59E0B);
                              statusText = 'DUE NOW';
                            } else {
                              statusColor = const Color(0xFF94A3B8);
                              statusText = 'UPCOMING';
                            }

                            return Container(
                              decoration: BoxDecoration(
                                border: isLast
                                    ? null
                                    : Border(
                                        bottom: BorderSide(
                                          color: isDark
                                              ? const Color(0xFF334155).withValues(alpha: 0.35)
                                              : const Color(0xFFF1F5F9),
                                          width: 1,
                                        ),
                                      ),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 13,
                                    child: Text(
                                      'Milestone ${item.milestoneNumber}',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 28,
                                    child: Text(
                                      item.title,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 15,
                                    child: Text(
                                      '₹${item.amount.toStringAsFixed(2)} Lakhs',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 15,
                                    child: Text(
                                      item.invoiceNumber,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 11.5,
                                        color: const Color(0xFF6366F1),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 12,
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: statusColor.withValues(alpha: 0.12),
                                          borderRadius: BorderRadius.circular(4),
                                          border: Border.all(color: statusColor.withValues(alpha: 0.3)),
                                        ),
                                        child: Text(
                                          statusText,
                                          style: GoogleFonts.plusJakartaSans(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w800,
                                            color: statusColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 17,
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: item.status == PaymentStageStatus.paid
                                          ? InkWell(
                                              onTap: () {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(
                                                    content: Text('Downloading official GST Tax Invoice ${item.invoiceNumber}...'),
                                                    backgroundColor: const Color(0xFF6366F1),
                                                    behavior: SnackBarBehavior.floating,
                                                  ),
                                                );
                                              },
                                              child: FittedBox(
                                                fit: BoxFit.scaleDown,
                                                alignment: Alignment.centerLeft,
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    const Icon(Icons.receipt_long_rounded, size: 13, color: Color(0xFF6366F1)),
                                                    const SizedBox(width: 4),
                                                    Text(
                                                      'Download PDF',
                                                      style: GoogleFonts.plusJakartaSans(
                                                        fontSize: 11,
                                                        fontWeight: FontWeight.w700,
                                                        color: const Color(0xFF6366F1),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                          : item.status == PaymentStageStatus.dueNow
                                              ? FittedBox(
                                                  fit: BoxFit.scaleDown,
                                                  alignment: Alignment.centerLeft,
                                                  child: ElevatedButton(
                                                    onPressed: () => _showPaymentModal(context, isDark),
                                                    style: ElevatedButton.styleFrom(
                                                      backgroundColor: const Color(0xFF10B981),
                                                      foregroundColor: Colors.white,
                                                      elevation: 0,
                                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                                      textStyle: GoogleFonts.plusJakartaSans(
                                                        fontSize: 10.5,
                                                        fontWeight: FontWeight.w700,
                                                      ),
                                                    ),
                                                    child: const Text('Pay ₹6.0L'),
                                                  ),
                                                )
                                              : Text(
                                                  '-',
                                                  style: GoogleFonts.plusJakartaSans(color: Colors.grey),
                                                ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLedgerStatusLegend(Color color, String text, bool isDark) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 5),
        Text(
          text,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 10.5,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
          ),
        ),
      ],
    );
  }

  // ==========================================================================
  // SECTION 8: PENDING APPROVALS CARD (DIGITAL SIGN-OFF)
  // ==========================================================================
  Widget _buildPendingApprovalsCard(bool isDark) {
    final pendingItems = _approvalItems;

    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: AppRadius.lg,
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withValues(alpha: 0.2) : const Color(0xFF0F172A).withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header + Urgent Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'PENDING DIGITAL APPROVALS',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.6,
                        color: const Color(0xFFEF4444),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Client Sign-off Required for Milestone Execution',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFEF4444).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '${pendingItems.where((i) => i.status == ApprovalItemStatus.pending).length} Urgent',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFFEF4444),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // List of Approval Cards
          Column(
            children: pendingItems.map((item) {
              final isApproved = item.status == ApprovalItemStatus.approved;

              return Container(
                margin: const EdgeInsets.only(bottom: 12.0),
                padding: const EdgeInsets.all(14.0),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B).withValues(alpha: 0.5) : const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isApproved
                        ? const Color(0xFF10B981).withValues(alpha: 0.4)
                        : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: isApproved
                                ? const Color(0xFF10B981).withValues(alpha: 0.15)
                                : const Color(0xFF6366F1).withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            isApproved ? Icons.verified_rounded : Icons.draw_rounded,
                            size: 16,
                            color: isApproved ? const Color(0xFF10B981) : const Color(0xFF6366F1),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.title,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w700,
                                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                'Category: ${item.category} • Cost Impact: ${item.costImpact} • Due by: ${item.dueDate}',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    if (isApproved)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981).withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.verified_user_rounded, size: 14, color: Color(0xFF10B981)),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                'Digitally Signed by Rohit Sharma • Certified',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF10B981),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      Align(
                        alignment: Alignment.centerRight,
                        child: Wrap(
                          alignment: WrapAlignment.end,
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            OutlinedButton.icon(
                              onPressed: () => _handleRequestChanges(item.id),
                              icon: const Icon(Icons.chat_bubble_outline_rounded, size: 13),
                              label: const Text('Request Changes'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                side: BorderSide(color: isDark ? const Color(0xFF475569) : const Color(0xFFCBD5E1)),
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                textStyle: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w600),
                              ),
                            ),
                            ElevatedButton.icon(
                              onPressed: () => _handleApprove(item.id),
                              icon: const Icon(Icons.check_circle_rounded, size: 14, color: Colors.white),
                              label: const Text('Approve & Sign'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF10B981),
                                foregroundColor: Colors.white,
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                textStyle: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w700),
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
        ],
      ),
    );
  }

  // ==========================================================================
  // SECTION 9: LIVE ACTIVITY & AUDIT FEED STREAM
  // ==========================================================================
  Widget _buildLiveActivityCard(bool isDark) {
    final audits = ClientDashboardMockData.liveAudits;

    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: AppRadius.lg,
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withValues(alpha: 0.2) : const Color(0xFF0F172A).withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'LIVE SITE AUDIT STREAM',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.6,
              color: const Color(0xFF6366F1),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'Real-time Supervisor & QA Updates',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13.5,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
          ),

          const SizedBox(height: 16),

          // Audit Stream Items
          Column(
            children: audits.map((audit) {
              return Container(
                margin: const EdgeInsets.only(bottom: 12.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: audit.iconColor.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(audit.icon, size: 14, color: audit.iconColor),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            audit.title,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: isDark ? Colors.white : const Color(0xFF0F172A),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${audit.author} (${audit.role}) • ${audit.time}',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w500,
                              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
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
        ],
      ),
    );
  }

  // ==========================================================================
  // PAYMENT MODAL DIALOG
  // ==========================================================================
  void _showPaymentModal(BuildContext context, bool isDark) {
    showDialog(
      context: context,
      builder: (ctx) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 460),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(0xFF10B981).withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.account_balance_wallet_rounded, color: Color(0xFF10B981), size: 18),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Milestone 5 Payment',
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(ctx),
                        icon: const Icon(Icons.close_rounded, size: 18),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Invoice Deliverable',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
                                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Modular Kitchen & Wardrobes',
                                textAlign: TextAlign.end,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.plusJakartaSans(fontSize: 11.5, fontWeight: FontWeight.w700),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Invoice Number',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
                                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'INV-2026-302',
                              style: GoogleFonts.plusJakartaSans(fontSize: 11.5, fontWeight: FontWeight.w700, color: const Color(0xFF6366F1)),
                            ),
                          ],
                        ),
                        const Divider(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                'Amount Payable (Incl. GST)',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '₹6,00,000.00',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF10B981),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Payment of ₹6,00,000.00 initiated via Razorpay Gateway...'),
                            backgroundColor: Color(0xFF10B981),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      icon: const Icon(Icons.lock_outline_rounded, size: 16, color: Colors.white),
                      label: const Text('Proceed to Secure Payment Gateway'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF10B981),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        textStyle: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// ============================================================================
// HELPER MODELS FOR KPI CARDS
// ============================================================================

class _KpiCardData {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color color;
  final List<FlSpot> sparklineSpots;
  final String badgeText;

  const _KpiCardData({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.sparklineSpots,
    required this.badgeText,
  });
}
