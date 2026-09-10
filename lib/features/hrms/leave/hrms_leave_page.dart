import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/responsive/breakpoints.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_radius.dart';
import '../data/hrms_repository.dart';
import '../domain/hrms_domain_models.dart';
import '../domain/hrms_enums.dart';
import '../widgets/hrms_header.dart';
import '../widgets/hrms_metric_card.dart';
import '../widgets/hrms_data_table.dart';
import '../widgets/hrms_filter_bar.dart';
import '../widgets/hrms_status_badge.dart';
import '../widgets/leave_application_dialog.dart';

class HrmsLeavePage extends StatefulWidget {
  const HrmsLeavePage({super.key});

  @override
  State<HrmsLeavePage> createState() => _HrmsLeavePageState();
}

class _HrmsLeavePageState extends State<HrmsLeavePage> {
  final _repo = HrmsRepository();

  String _statusFilter = 'all';
  String _searchQuery = '';
  int _currentPage = 1;
  static const int _pageSize = 8;

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

  List<LeaveApplication> get _filteredApplications {
    return _repo.leaveApplications.where((l) {
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        if (!l.employeeName.toLowerCase().contains(q) &&
            !l.employeeCode.toLowerCase().contains(q) &&
            !l.reason.toLowerCase().contains(q)) {
          return false;
        }
      }
      if (_statusFilter == 'pending' && l.status != ApprovalStatus.pending) return false;
      if (_statusFilter == 'approved' && l.status != ApprovalStatus.approved) return false;
      if (_statusFilter == 'penalty' && !l.isStrictPenaltyTriggered) return false;
      return true;
    }).toList();
  }

  void _openPolicyConfigDialog() {
    final policy = _repo.policyConfig;
    bool doubleSalaryEnabled = policy.doubleSalaryDeductionEnabled;
    double multiplier = policy.unauthorizedAbsenceMultiplier;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) {
          final isDark = Theme.of(context).brightness == Brightness.dark;

          return Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 540),
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF131722) : Colors.white,
                borderRadius: AppRadius.lg,
                border: Border.all(color: isDark ? Colors.white12 : Colors.black12),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.tune, color: AppColors.primary, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'Corporate Leave & Penalty Policy Engine',
                            style: GoogleFonts.plusJakartaSans(fontSize: 15, fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                      IconButton(onPressed: () => Navigator.of(ctx).pop(), icon: const Icon(Icons.close, size: 20)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Corporate rules governing unapproved absences, salary penalty multipliers, and notice grace periods. These settings apply globally across all Homio departments.',
                    style: GoogleFonts.plusJakartaSans(fontSize: 11, color: const Color(0xFF94A3B8)),
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Policy Switch 1
                  SwitchListTile(
                    value: doubleSalaryEnabled,
                    activeThumbColor: const Color(0xFFEF4444),
                    onChanged: (v) => setModalState(() => doubleSalaryEnabled = v),
                    title: Text(
                      'Double Salary Deduction Rule',
                      style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w700),
                    ),
                    subtitle: Text(
                      'When enabled, unapproved absences taken despite managerial rejection trigger an automated multiplier deduction.',
                      style: GoogleFonts.plusJakartaSans(fontSize: 11, color: const Color(0xFF94A3B8)),
                    ),
                    contentPadding: EdgeInsets.zero,
                  ),
                  const SizedBox(height: AppSpacing.sm),

                  // Multiplier Dropdown
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Unauthorized Absence Multiplier:',
                        style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF1B202E) : const Color(0xFFF8FAFC),
                          borderRadius: AppRadius.md,
                          border: Border.all(color: isDark ? Colors.white12 : Colors.black12),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<double>(
                            value: multiplier,
                            dropdownColor: isDark ? const Color(0xFF1A1F2C) : Colors.white,
                            items: const [
                              DropdownMenuItem(value: 1.0, child: Text('1.0x (Standard Loss of Pay)')),
                              DropdownMenuItem(value: 1.5, child: Text('1.5x (1.5 Days Base Wage)')),
                              DropdownMenuItem(value: 2.0, child: Text('2.0x (Double Salary Deduction)')),
                              DropdownMenuItem(value: 3.0, child: Text('3.0x (Triple Day Penalty)')),
                            ],
                            onChanged: (v) => setModalState(() => multiplier = v!),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
                      const SizedBox(width: AppSpacing.sm),
                      ElevatedButton(
                        onPressed: () {
                          _repo.updatePolicyConfig(
                            policy.copyWith(
                              doubleSalaryDeductionEnabled: doubleSalaryEnabled,
                              unauthorizedAbsenceMultiplier: multiplier,
                            ),
                          );
                          Navigator.of(ctx).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('HR Policy Config Updated! Multiplier set to ${multiplier}x'),
                              backgroundColor: const Color(0xFF10B981),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
                        child: const Text('Save Policy Settings'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _rejectWithPenaltyWarning(LeaveApplication app) {
    final reasonCtrl = TextEditingController(text: 'Rejected due to critical project milestone. Unauthorized absence will trigger double salary penalty.');

    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500),
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF131722) : Colors.white,
            borderRadius: AppRadius.lg,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.gavel, color: Color(0xFFEF4444), size: 20),
                  const SizedBox(width: 8),
                  Text('Reject Leave Application', style: GoogleFonts.plusJakartaSans(fontSize: 15, fontWeight: FontWeight.w700, color: const Color(0xFFEF4444))),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Rejecting this leave will invoke the corporate penalty policy. If ${app.employeeName} takes this leave unapproved, a ${_repo.policyConfig.unauthorizedAbsenceMultiplier.toInt()}x daily salary deduction (${app.totalDays * _repo.policyConfig.unauthorizedAbsenceMultiplier} days base pay) will automatically be deducted in payroll.',
                style: GoogleFonts.plusJakartaSans(fontSize: 11, color: const Color(0xFF94A3B8)),
              ),
              const SizedBox(height: AppSpacing.sm),
              TextField(
                controller: reasonCtrl,
                maxLines: 2,
                style: GoogleFonts.plusJakartaSans(fontSize: 12),
                decoration: const InputDecoration(labelText: 'Rejection Reason / Operational Remarks'),
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
                  const SizedBox(width: AppSpacing.sm),
                  ElevatedButton(
                    onPressed: () {
                      _repo.updateLeaveStatus(
                        id: app.id,
                        status: ApprovalStatus.rejected,
                        reviewerName: 'Lead Manager',
                        remarks: reasonCtrl.text.trim(),
                      );
                      Navigator.of(ctx).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Leave rejected. Double deduction penalty active if absence occurs.'),
                          backgroundColor: const Color(0xFFEF4444),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFEF4444), foregroundColor: Colors.white),
                    child: const Text('Confirm Rejection & Invoke Policy'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isCompact = MediaQuery.of(context).size.width < 768;

    final applications = _filteredApplications;
    final totalRecords = applications.length;
    final totalPages = (totalRecords / _pageSize).ceil().clamp(1, 99);
    final startIndex = (_currentPage - 1) * _pageSize;
    final paged = applications.skip(startIndex).take(_pageSize).toList();

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
                // Header
                HrmsHeader(
                  title: 'Leave Applications & Strict Policy Penalties',
                  subtitle: 'Leave quota management, managerial approvals, and automated double salary deduction for unapproved absences',
                  icon: Icons.event_busy_rounded,
                  badgeText: 'POLICY RULES ENGINE ACTIVE',
                  badgeColor: const Color(0xFFEF4444),
                  actions: [
                    OutlinedButton.icon(
                      onPressed: _openPolicyConfigDialog,
                      style: OutlinedButton.styleFrom(
                        visualDensity: VisualDensity.compact,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      icon: const Icon(Icons.tune, size: 16),
                      label: Text('Policy Rules Config', style: GoogleFonts.plusJakartaSans(fontSize: 12)),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => LeaveApplicationDialog.show(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        visualDensity: VisualDensity.compact,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      ),
                      icon: const Icon(Icons.add, size: 16),
                      label: Text('Apply for Leave', style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),

                // Metrics
                _buildMetrics(context, isCompact),
                const SizedBox(height: AppSpacing.md),

                // Filter Bar
                HrmsFilterBar(
                  searchHint: 'Search leave requests by employee name, code, or reason...',
                  selectedFilter: _statusFilter,
                  onSearchChanged: (q) => setState(() {
                    _searchQuery = q;
                    _currentPage = 1;
                  }),
                  filterOptions: [
                    FilterOption(label: 'All Applications', value: 'all', count: _repo.leaveApplications.length),
                    FilterOption(label: 'Pending Review', value: 'pending', count: _repo.leaveApplications.where((l) => l.status == ApprovalStatus.pending).length),
                    FilterOption(label: 'Approved', value: 'approved', count: _repo.leaveApplications.where((l) => l.status == ApprovalStatus.approved).length),
                    FilterOption(label: 'Penalty Triggered', value: 'penalty', count: _repo.leaveApplications.where((l) => l.isStrictPenaltyTriggered).length),
                  ],
                  onFilterSelected: (val) => setState(() {
                    _statusFilter = val;
                    _currentPage = 1;
                  }),
                ),
                const SizedBox(height: AppSpacing.sm),

                // Table
                _buildLeaveTable(paged, totalRecords, totalPages, isDark),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMetrics(BuildContext context, bool isCompact) {
    final all = _repo.leaveApplications;
    final pendingCount = all.where((l) => l.status == ApprovalStatus.pending).length;
    final approvedDays = all.where((l) => l.status == ApprovalStatus.approved).fold<double>(0.0, (s, l) => s + l.totalDays);
    final penaltyIncidents = all.where((l) => l.isStrictPenaltyTriggered).length;
    final policy = _repo.policyConfig;

    final cards = [
      HrmsMetricCard(
        title: 'Pending Requests',
        value: '$pendingCount Requests',
        subtitle: 'Awaiting Sign-off',
        icon: Icons.timelapse,
        accentColor: const Color(0xFFF59E0B),
      ),
      HrmsMetricCard(
        title: 'Approved Days (Aug)',
        value: '$approvedDays Days',
        subtitle: 'Within Leave Quota',
        icon: Icons.check_circle_outline,
        accentColor: const Color(0xFF10B981),
      ),
      HrmsMetricCard(
        title: 'Policy Penalties Triggered',
        value: '$penaltyIncidents Incident',
        subtitle: 'Double Wage Deduction',
        icon: Icons.gavel_rounded,
        accentColor: const Color(0xFFEF4444),
      ),
      HrmsMetricCard(
        title: 'Deduction Multiplier',
        value: '${policy.unauthorizedAbsenceMultiplier}x Rate',
        subtitle: policy.doubleSalaryDeductionEnabled ? 'Policy Active' : 'Policy Paused',
        icon: Icons.shield_outlined,
        accentColor: const Color(0xFF8B5CF6),
      ),
    ];

    if (isCompact) {
      return Column(children: cards.map((c) => Padding(padding: const EdgeInsets.only(bottom: 8), child: c)).toList());
    }
    return Row(children: cards.map((c) => Expanded(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 4), child: c))).toList());
  }

  Widget _buildLeaveTable(List<LeaveApplication> applications, int totalRecords, int totalPages, bool isDark) {
    return HrmsDataTable(
      columns: const [
        HrmsDataColumn(title: 'EMPLOYEE & DEPT'),
        HrmsDataColumn(title: 'LEAVE TYPE'),
        HrmsDataColumn(title: 'DATES & DURATION'),
        HrmsDataColumn(title: 'REASON & REVIEW REMARKS'),
        HrmsDataColumn(title: 'POLICY PENALTY STATUS'),
        HrmsDataColumn(title: 'ACTIONS', alignment: Alignment.centerRight),
      ],
      currentPage: _currentPage,
      totalPages: totalPages,
      totalRecords: totalRecords,
      onPageChanged: (p) => setState(() => _currentPage = p),
      rows: applications.map((app) {
        return [
          // Employee
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(app.employeeName, style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700, color: isDark ? Colors.white : const Color(0xFF0F172A))),
              Text('${app.employeeCode} • ${app.departmentName}', style: GoogleFonts.plusJakartaSans(fontSize: 10, color: const Color(0xFF94A3B8))),
            ],
          ),

          // Leave Type Badge
          HrmsStatusBadge.leave(app.leaveType),

          // Dates & Duration
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${app.startDate.day}/${app.startDate.month} → ${app.endDate.day}/${app.endDate.month}',
                style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w600),
              ),
              Text(
                '${app.totalDays} day(s)${app.isHalfDay ? " (Half-day)" : ""}',
                style: GoogleFonts.plusJakartaSans(fontSize: 10, color: const Color(0xFF94A3B8)),
              ),
            ],
          ),

          // Reason & Remarks
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                app.reason,
                style: GoogleFonts.plusJakartaSans(fontSize: 11, color: isDark ? Colors.white70 : const Color(0xFF334155)),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (app.reviewRemarks != null)
                Text(
                  'Review: ${app.reviewRemarks}',
                  style: GoogleFonts.plusJakartaSans(fontSize: 10, color: const Color(0xFFEF4444)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
            ],
          ),

          // Policy Penalty Status
          if (app.isStrictPenaltyTriggered)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFEF4444).withValues(alpha: 0.12),
                borderRadius: AppRadius.sm,
                border: Border.all(color: const Color(0xFFEF4444).withValues(alpha: 0.3)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.gavel, size: 12, color: Color(0xFFEF4444)),
                  const SizedBox(width: 4),
                  Text(
                    '${app.penaltyDeductionDays.toInt()} Days Pay Deducted (2x Rule)',
                    style: GoogleFonts.plusJakartaSans(fontSize: 10, fontWeight: FontWeight.w700, color: const Color(0xFFEF4444)),
                  ),
                ],
              ),
            )
          else
            HrmsStatusBadge.approval(app.status),

          // Action
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (app.status == ApprovalStatus.pending) ...[
                ElevatedButton(
                  onPressed: () {
                    _repo.updateLeaveStatus(
                      id: app.id,
                      status: ApprovalStatus.approved,
                      reviewerName: 'Approving Manager',
                      remarks: 'Approved.',
                    );
                    setState(() {});
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF10B981),
                    foregroundColor: Colors.white,
                    visualDensity: VisualDensity.compact,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                  ),
                  child: Text('Approve', style: GoogleFonts.plusJakartaSans(fontSize: 11)),
                ),
                const SizedBox(width: 4),
                OutlinedButton(
                  onPressed: () => _rejectWithPenaltyWarning(app),
                  style: OutlinedButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                  ),
                  child: Text('Reject', style: GoogleFonts.plusJakartaSans(fontSize: 11, color: const Color(0xFFEF4444))),
                ),
              ] else
                Text(
                  'Signed by ${app.reviewedBy ?? "Admin"}',
                  style: GoogleFonts.plusJakartaSans(fontSize: 11, color: const Color(0xFF94A3B8)),
                ),
            ],
          ),
        ];
      }).toList(),
    );
  }
}
