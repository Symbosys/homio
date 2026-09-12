import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/responsive/breakpoints.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../shared/client_models.dart';
import '../shared/customer_shared_widgets.dart';

/// Screen 3: STAGES & WORK APPROVALS (/client/approvals)
/// Central control center for project stage tracking and formal client digital sign-offs.
/// Visually partitions "Action Required Approvals" from the "7-Stage Journey",
/// allowing clients to review 3D renders, workshop joinery specs, confirm approvals,
/// or submit structured change requests with instant repository synchronization.
class ClientStageWorkApprovalsPage extends StatefulWidget {
  const ClientStageWorkApprovalsPage({super.key});

  @override
  State<ClientStageWorkApprovalsPage> createState() => _ClientStageWorkApprovalsPageState();
}

class _ClientStageWorkApprovalsPageState extends State<ClientStageWorkApprovalsPage> {
  String _approvalFilter = 'Pending'; // 'All', 'Pending', 'Approved'
  int? _expandedStageIndex = 4; // Stage 5 Execution expanded by default

  @override
  void initState() {
    super.initState();
    ClientDataRepository.stateVersionNotifier.addListener(_onStateChanged);
  }

  @override
  void dispose() {
    ClientDataRepository.stateVersionNotifier.removeListener(_onStateChanged);
    super.dispose();
  }

  void _onStateChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= Breakpoints.medium;
    final isTablet = screenWidth >= 640 && screenWidth < Breakpoints.medium;

    final allApprovals = ClientDataRepository.approvalPackages;
    final pendingCount = allApprovals.where((a) => a.isPending).length;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0B0F19) : const Color(0xFFF8FAFC),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(
          horizontal: isDesktop ? AppSpacing.xl : (isTablet ? AppSpacing.lg : AppSpacing.md),
          vertical: isDesktop ? AppSpacing.xl : AppSpacing.md,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1240),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. SHARED PROJECT CONTEXT HEADER & SUB-NAVIGATION
                const CustomerProjectContextBar(activeTab: 'approvals'),
                const SizedBox(height: 16),

                // 2. ACTION REQUIRED URGENCY BANNER
                _buildActionRequiredBanner(context, isDark, pendingCount),
                const SizedBox(height: 20),

                // 3. PENDING WORK APPROVALS SECTION
                _buildApprovalsSection(context, isDark, isDesktop, allApprovals),
                const SizedBox(height: 32),

                // 4. MASTER 7-STAGE PROJECT ROADMAP & MILESTONES
                _buildStagesRoadmapSection(context, isDark, isDesktop),

                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================================
  // 1. ACTION REQUIRED BANNER
  // ============================================================================
  Widget _buildActionRequiredBanner(BuildContext context, bool isDark, int pendingCount) {
    if (pendingCount == 0) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF10B981).withValues(alpha: 0.1),
          borderRadius: AppRadius.md,
          border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.25)),
        ),
        child: Row(
          children: [
            const Icon(Icons.verified_rounded, color: Color(0xFF10B981), size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'You\'re all caught up! No approvals or milestone sign-offs are pending your action.',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF059669),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF451A03).withValues(alpha: 0.4) : const Color(0xFFFFFBEB),
        borderRadius: AppRadius.lg,
        border: Border.all(
          color: const Color(0xFFF59E0B).withValues(alpha: 0.4),
          width: 1.2,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFF59E0B).withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.pending_actions_rounded, color: Color(0xFFD97706), size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'ACTION REQUIRED: APPROVALS PENDING',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                        color: const Color(0xFFD97706),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEF4444).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '$pendingCount Action Items',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFFEF4444),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Your design & stage approvals directly authorize procurement and on-site carpentry fabrication.',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12.5,
                    color: isDark ? const Color(0xFFFDE68A) : const Color(0xFF92400E),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================================
  // 2. APPROVALS SECTION
  // ============================================================================
  Widget _buildApprovalsSection(
    BuildContext context,
    bool isDark,
    bool isDesktop,
    List<CustomerApprovalItem> allApprovals,
  ) {
    var filtered = allApprovals;
    if (_approvalFilter == 'Pending') {
      filtered = allApprovals.where((a) => a.isPending).toList();
    } else if (_approvalFilter == 'Approved') {
      filtered = allApprovals.where((a) => a.isApproved).toList();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Section Header with Filter Chips
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Icons.rule_folder_rounded, size: 18, color: Color(0xFF4F46E5)),
                const SizedBox(width: 8),
                Text(
                  'Work Approvals & Design Sign-Offs',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                _buildFilterChip('Pending', isDark),
                const SizedBox(width: 6),
                _buildFilterChip('Approved', isDark),
                const SizedBox(width: 6),
                _buildFilterChip('All', isDark),
              ],
            ),
          ],
        ),
        const SizedBox(height: 14),

        if (filtered.isEmpty)
          CustomerEmptyState(
            icon: Icons.check_circle_outline_rounded,
            title: 'No Items Found',
            message: 'There are no approvals matching "$_approvalFilter" status currently.',
          )
        else
          Column(
            children: filtered.map((item) {
              return _buildApprovalCard(context, item, isDark, isDesktop);
            }).toList(),
          ),
      ],
    );
  }

  Widget _buildFilterChip(String label, bool isDark) {
    final isSelected = _approvalFilter == label;
    return InkWell(
      onTap: () => setState(() => _approvalFilter = label),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF4F46E5)
              : (isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9)),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 11.5,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
            color: isSelected ? Colors.white : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
          ),
        ),
      ),
    );
  }

  // ============================================================================
  // APPROVAL CARD
  // ============================================================================
  Widget _buildApprovalCard(BuildContext context, CustomerApprovalItem item, bool isDark, bool isDesktop) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF111827) : Colors.white,
        borderRadius: AppRadius.lg,
        border: Border.all(
          color: item.isPending
              ? const Color(0xFFF59E0B).withValues(alpha: 0.5)
              : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
          width: item.isPending ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: item.isPending ? const Color(0xFFF59E0B).withValues(alpha: 0.08) : Colors.black.withValues(alpha: 0.02),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: Category Tag + Version + Status Badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4F46E5).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        item.category.toUpperCase(),
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF4F46E5),
                          letterSpacing: 0.4,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        item.version,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white70 : const Color(0xFF334155),
                        ),
                      ),
                    ),
                  ],
                ),
                CustomerStatusBadge(status: item.status, isSmall: true),
              ],
            ),
            const SizedBox(height: 10),

            // Title & Subtitle
            Text(
              item.title,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              item.subtitle,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12.5,
                height: 1.4,
                color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155),
              ),
            ),
            const SizedBox(height: 12),

            // Specs Summary Chips
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: item.specifications.take(3).map((s) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E293B).withValues(alpha: 0.5) : const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.check, size: 12, color: Color(0xFF10B981)),
                      const SizedBox(width: 4),
                      Text(
                        s,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 14),
            const Divider(height: 1, thickness: 1),
            const SizedBox(height: 10),

            // Bottom Actions Bar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Submitted by ${item.submittedBy}',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white70 : const Color(0xFF334155),
                      ),
                    ),
                    if (item.deadline != null && item.isPending)
                      Text(
                        item.deadline!,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFFD97706),
                        ),
                      ),
                  ],
                ),
                Row(
                  children: [
                    if (item.isApproved)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981).withValues(alpha: 0.12),
                          borderRadius: AppRadius.md,
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.verified_rounded, size: 14, color: Color(0xFF10B981)),
                            const SizedBox(width: 6),
                            Text(
                              'Certified Sign-Off',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF059669),
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4F46E5),
                          foregroundColor: Colors.white,
                          shape: RoundedAppRadius.md,
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                        ),
                        onPressed: () {
                          DesignApprovalReviewModal.show(
                            context,
                            approval: item,
                            onApproved: () => setState(() {}),
                            onChangesRequested: () => setState(() {}),
                          );
                        },
                        icon: const Icon(Icons.visibility_rounded, size: 15),
                        label: Text(
                          'Review & Sign-Off',
                          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700, fontSize: 12.5),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================================
  // 3. MASTER 7-STAGE ROADMAP
  // ============================================================================
  Widget _buildStagesRoadmapSection(BuildContext context, bool isDark, bool isDesktop) {
    final stages = [
      (
        '01 Planning & Site Survey',
        'Completed on 15 Aug 2026',
        1.0,
        'Completed',
        'Laser distance survey, builder MEP duct verification, and civil structural analysis completed.',
        ['3D Laser Survey Pack.pdf', 'Civil Feasibility Report.pdf'],
        ['Initial survey completed', 'Shaft elevations verified', 'Clearances certified'],
      ),
      (
        '02 Design & Blueprints',
        'Completed on 05 Sep 2026',
        1.0,
        'Completed',
        'Complete 3D spatial layout, Scandinavian moodboards, and electrical/lighting drawings certified.',
        ['Living_Room_Render_v3.jpg', 'Master_Bedroom_Elevation.pdf'],
        ['Living room concept approved', 'Kitchen modular plan signed', 'Ceiling heights confirmed'],
      ),
      (
        '03 Client Commercial Sign-Off',
        'Completed on 08 Sep 2026',
        1.0,
        'Completed',
        'Detailed itemized BOQ for ₹12,80,000 accepted. Booking token and material procurement released.',
        ['HOM-2026-0184_BOQ.pdf', 'Warranty_Certificate.pdf'],
        ['BOQ rates locked for 30 days', 'Token advance acknowledged', '10-Yr warranty bound'],
      ),
      (
        '04 Procurement & Finishes',
        'Completed on 09 Sep 2026',
        1.0,
        'Completed',
        'Greenply 710 BWP plywood intake, Häfele hardware batching, and Italian marble Tenax epoxy test cured.',
        ['Material_Gate_Pass.pdf', 'Greenply_Test_Report.pdf'],
        ['Plywood moisture tested at 8.2%', 'Statuario polish grade A approved', 'Hardware batch verified'],
      ),
      (
        '05 Execution & Fabrication',
        'Active (72% complete)',
        0.72,
        'In Progress',
        'Heavy-duty concealed electrical conduit pulling, Finolex cabling, and Saint-Gobain false ceiling framing.',
        ['Electrical_Circuit_Schedule.pdf', 'False_Ceiling_Section.pdf'],
        ['Concealed conduits embedded in brickwork', 'FR copper wires pulled', 'Ceiling laser leveled'],
      ),
      (
        '06 Inspection & Snags',
        'Scheduled for 15 Nov 2026',
        0.0,
        'Upcoming',
        'Comprehensive 140-point quality audit, circuit load testing, cabinet alignment, and snag log resolution.',
        ['QA_140_Checklist_Template.pdf'],
        ['Laser plumb alignment test', 'Plumbing drainage slope test', 'Surface paint lux meter audit'],
      ),
      (
        '07 Handover & Warranty',
        'Target: 25 Nov 2026',
        0.0,
        'Upcoming',
        'Deep chemical sanitization, ceremonial key handover box, and 10-Year warranty digital certificate delivery.',
        ['Warranty_Dossier_Template.pdf'],
        ['Deep sanitization treatment', 'Ceremonial welcome box', 'Appliance serial number registry'],
      ),
    ];

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF111827) : Colors.white,
        borderRadius: AppRadius.lg,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
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
                  const Icon(Icons.timeline_rounded, size: 18, color: Color(0xFF4F46E5)),
                  const SizedBox(width: 8),
                  Text(
                    'Full Project Stage Journey (7 Stages)',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),
              Text(
                'Stage 5 Active',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF4F46E5),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Stage Accordion List
          Column(
            children: stages.asMap().entries.map((entry) {
              final idx = entry.key;
              final stg = entry.value;
              final isExpanded = _expandedStageIndex == idx;
              final isDone = stg.$3 == 1.0;
              final isActive = stg.$3 > 0 && stg.$3 < 1.0;

              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B).withValues(alpha: 0.5) : const Color(0xFFF8FAFC),
                  borderRadius: AppRadius.md,
                  border: Border.all(
                    color: isActive
                        ? const Color(0xFF4F46E5).withValues(alpha: 0.4)
                        : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                  ),
                ),
                child: Column(
                  children: [
                    // Stage Header
                    InkWell(
                      onTap: () {
                        setState(() {
                          _expandedStageIndex = isExpanded ? null : idx;
                        });
                      },
                      borderRadius: AppRadius.md,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        child: Row(
                          children: [
                            Icon(
                              isDone
                                  ? Icons.check_circle_rounded
                                  : (isActive ? Icons.timelapse_rounded : Icons.radio_button_unchecked_rounded),
                              size: 18,
                              color: isDone
                                  ? const Color(0xFF10B981)
                                  : (isActive ? const Color(0xFF4F46E5) : const Color(0xFF94A3B8)),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    stg.$1,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 13.5,
                                      fontWeight: FontWeight.w800,
                                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    stg.$2,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 11,
                                      color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            CustomerStatusBadge(status: stg.$4, isSmall: true),
                            const SizedBox(width: 8),
                            Icon(
                              isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                              size: 20,
                              color: isDark ? Colors.white60 : Colors.black45,
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Expanded Details
                    if (isExpanded) ...[
                      const Divider(height: 1, thickness: 1),
                      Padding(
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              stg.$5,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12.5,
                                height: 1.4,
                                color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155),
                              ),
                            ),
                            const SizedBox(height: 12),

                            // Milestones Checklist
                            Text(
                              'Stage Deliverables & Verification:',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                color: isDark ? Colors.white70 : const Color(0xFF475569),
                              ),
                            ),
                            const SizedBox(height: 6),
                            ...stg.$7.map((m) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: Row(
                                  children: [
                                    Icon(
                                      isDone ? Icons.check_rounded : Icons.arrow_right_rounded,
                                      size: 14,
                                      color: isDone ? const Color(0xFF10B981) : const Color(0xFF4F46E5),
                                    ),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        m,
                                        style: GoogleFonts.plusJakartaSans(fontSize: 12),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),

                            if (stg.$6.isNotEmpty) ...[
                              const SizedBox(height: 10),
                              Text(
                                'Associated Official Documents:',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                  color: isDark ? Colors.white70 : const Color(0xFF475569),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Wrap(
                                spacing: 8,
                                runSpacing: 6,
                                children: stg.$6.map((doc) {
                                  return Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: isDark ? const Color(0xFF0F172A) : Colors.white,
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1)),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(Icons.description_outlined, size: 12, color: Color(0xFF3B82F6)),
                                        const SizedBox(width: 6),
                                        Text(
                                          doc,
                                          style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
