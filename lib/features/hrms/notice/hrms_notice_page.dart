import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/responsive/breakpoints.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_radius.dart';
import '../data/hrms_repository.dart';
import '../domain/hrms_enums.dart';
import '../domain/hrms_domain_models.dart';
import '../widgets/hrms_header.dart';
import '../widgets/hrms_metric_card.dart';
import '../widgets/clearance_checklist_widget.dart';
import '../widgets/resignation_dialog.dart';

class HrmsNoticePage extends StatefulWidget {
  const HrmsNoticePage({super.key});

  @override
  State<HrmsNoticePage> createState() => _HrmsNoticePageState();
}

class _HrmsNoticePageState extends State<HrmsNoticePage> {
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

    final resignations = _repo.resignations;
    final activeNoticeCount = _repo.employees.where((e) => e.status == EmployeeStatus.noticePeriod).length;
    final pendingClearances = _repo.clearances.where((c) => c.status == ClearanceStatus.pending).length;
    final completedHandovers = _repo.handoverChecklists.where((h) => h.isCompleted).length;

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
                  title: 'Resignations & Notice Period Governance',
                  subtitle: 'Official separation processing, notice duration countdown, departmental no-dues signoffs & asset handovers',
                  icon: Icons.exit_to_app_rounded,
                  badgeText: '$activeNoticeCount ACTIVE NOTICE CASE',
                  badgeColor: const Color(0xFF8B5CF6),
                  actions: [
                    ElevatedButton.icon(
                      onPressed: () => ResignationDialog.show(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8B5CF6),
                        foregroundColor: Colors.white,
                        visualDensity: VisualDensity.compact,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      ),
                      icon: const Icon(Icons.person_remove_outlined, size: 16),
                      label: Text('Initiate Separation', style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),

                // Metrics
                _buildMetrics(context, activeNoticeCount, pendingClearances, completedHandovers, isCompact),
                const SizedBox(height: AppSpacing.lg),

                // Active Notice Period Dossier
                if (resignations.isNotEmpty) ...[
                  Text(
                    'Active Notice Period Separation Workflow',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.3,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  _buildActiveResignationCard(resignations.first, isDark),
                  const SizedBox(height: AppSpacing.md),
                  ClearanceChecklistWidget(resignationId: resignations.first.id),
                ] else
                  Container(
                    padding: const EdgeInsets.all(32),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF131722) : Colors.white,
                      borderRadius: AppRadius.lg,
                    ),
                    child: Text('No active notice period workflows currently.', style: GoogleFonts.plusJakartaSans(color: Colors.grey)),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMetrics(BuildContext context, int noticeCount, int pendingClearances, int completedHandovers, bool isCompact) {
    final cards = [
      HrmsMetricCard(
        title: 'Serving Notice Period',
        value: '$noticeCount Personnel',
        subtitle: 'Official LWD: Sep 15, 2026',
        icon: Icons.timer_outlined,
        accentColor: const Color(0xFF8B5CF6),
      ),
      HrmsMetricCard(
        title: 'Pending Clearances',
        value: '$pendingClearances Signoffs',
        subtitle: 'IT & HR Signoff Required',
        icon: Icons.pending_actions_rounded,
        accentColor: const Color(0xFFF59E0B),
      ),
      HrmsMetricCard(
        title: 'Handovers Completed',
        value: '$completedHandovers / ${_repo.handoverChecklists.length} Tasks',
        subtitle: 'Assets & Files Assigned',
        icon: Icons.fact_check_rounded,
        accentColor: const Color(0xFF10B981),
      ),
      HrmsMetricCard(
        title: 'Corporate Policy Status',
        value: '30 Days Standard',
        subtitle: 'Notice Period Adherence',
        icon: Icons.policy_rounded,
        accentColor: const Color(0xFF3B82F6),
      ),
    ];

    if (isCompact) {
      return Column(children: cards.map((c) => Padding(padding: const EdgeInsets.only(bottom: 8), child: c)).toList());
    }
    return Row(children: cards.map((c) => Expanded(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 4), child: c))).toList());
  }

  Widget _buildActiveResignationCard(Resignation res, bool isDark) {
    final daysRemaining = res.remainingNoticeDays;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF131722) : Colors.white,
        borderRadius: AppRadius.lg,
        border: Border.all(color: const Color(0xFF8B5CF6).withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF8B5CF6).withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: const Color(0xFF8B5CF6).withValues(alpha: 0.2),
                    child: const Icon(Icons.person_outline, color: Color(0xFF8B5CF6), size: 24),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${res.employeeName} (${res.employeeCode})',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                        ),
                      ),
                      Text(
                        'Department: ${res.departmentName} • Notice Policy: ${res.noticePeriodDays} Days',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF8B5CF6).withValues(alpha: 0.15),
                  borderRadius: AppRadius.full,
                  border: Border.all(color: const Color(0xFF8B5CF6).withValues(alpha: 0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.hourglass_empty, size: 14, color: Color(0xFF8B5CF6)),
                    const SizedBox(width: 4),
                    Text(
                      '$daysRemaining Days Notice Remaining',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF8B5CF6),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          const Divider(height: 1),
          const SizedBox(height: AppSpacing.md),

          Row(
            children: [
              Expanded(
                child: _infoColumn('Submission Date', '${res.submissionDate.day}/${res.submissionDate.month}/${res.submissionDate.year}', isDark),
              ),
              Expanded(
                child: _infoColumn('Official Last Working Day', '${res.officialLastWorkingDate.day}/${res.officialLastWorkingDate.month}/${res.officialLastWorkingDate.year}', isDark, highlight: true),
              ),
              Expanded(
                child: _infoColumn('Reason Category', res.reasonCategory, isDark),
              ),
              Expanded(
                child: _infoColumn('Rehire Status', res.isEligibleForRehire ? 'Eligible for Rehire' : 'Ineligible', isDark),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Statement: "${res.reason}"',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontStyle: FontStyle.italic,
              color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoColumn(String title, String val, bool isDark, {bool highlight = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: GoogleFonts.plusJakartaSans(fontSize: 10, color: const Color(0xFF94A3B8))),
        const SizedBox(height: 2),
        Text(
          val,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: highlight ? const Color(0xFF8B5CF6) : (isDark ? Colors.white : const Color(0xFF0F172A)),
          ),
        ),
      ],
    );
  }
}
