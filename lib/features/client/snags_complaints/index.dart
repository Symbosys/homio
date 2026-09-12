import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/responsive/breakpoints.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../shared/client_models.dart';

/// Screen 4: COMPLAINTS / SUPPORT HUB
/// Connected client-side defect resolution & warranty protection:
/// - Guaranteed 48-Hour SLA Resolution Commitment
/// - Live Ticket Status (Open, In Progress, Resolved, Reopened)
/// - Assigned Site Supervisor Direct Contact
/// - Step-by-Step Resolution Timeline & Message Thread
/// - 5-Star Resolution Rating & Reopen Flow
/// - Raise New Snag Form with Photo Proof
/// - 100% Dark & Light mode compatible
class ClientSnagsComplaintsPage extends StatefulWidget {
  const ClientSnagsComplaintsPage({super.key});

  @override
  State<ClientSnagsComplaintsPage> createState() =>
      _ClientSnagsComplaintsPageState();
}

class _ClientSnagsComplaintsPageState extends State<ClientSnagsComplaintsPage> {
  int _activeStatusFilter = 0; // 0 = All, 1 = Active, 2 = Resolved
  String _selectedCategory = 'All';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  final List<String> _categories = [
    'All',
    'Execution & Workmanship',
    'Design & Aesthetics',
    'Materials & Specs',
    'Timeline & Delivery',
  ];

  @override
  void initState() {
    super.initState();
    ClientDataRepository.stateVersionNotifier.addListener(_onDataChanged);
  }

  @override
  void dispose() {
    ClientDataRepository.stateVersionNotifier.removeListener(_onDataChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onDataChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final allComplaints = ClientDataRepository.complaints;

    // Filter tickets
    final filteredComplaints = allComplaints.where((c) {
      final matchesStatus = _activeStatusFilter == 0 ||
          (_activeStatusFilter == 1 && c.isOpen) ||
          (_activeStatusFilter == 2 && c.isResolved);
      final matchesCat = _selectedCategory == 'All' ||
          c.category.toLowerCase().contains(_selectedCategory.toLowerCase());
      final matchesSearch = _searchQuery.isEmpty ||
          c.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          c.id.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          c.description.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesStatus && matchesCat && matchesSearch;
    }).toList();

    final openCount = allComplaints.where((c) => c.isOpen).length;
    final resolvedCount = allComplaints.where((c) => c.isResolved).length;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // 48-Hour SLA Guarantee Hero Card
            _buildSlaHeroCard(
              activeCount: openCount,
              resolvedCount: resolvedCount,
              isDark: isDark,
            ),

            const SizedBox(height: 16),

            // Filter & Search Header
            _buildFilterBar(
              totalCount: allComplaints.length,
              activeCount: openCount,
              resolvedCount: resolvedCount,
              isDark: isDark,
            ),

            const SizedBox(height: 16),

            // Tickets List
            if (filteredComplaints.isEmpty) ...[
              _buildEmptyState(isDark),
            ] else ...[
              ...filteredComplaints.map((c) => _buildComplaintCard(c, isDark)),
            ],

            const SizedBox(height: 48),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showRaiseComplaintModal(isDark),
        backgroundColor: const Color(0xFFEF4444),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_alert_rounded, size: 20),
        label: Text(
          'Raise New Snag / Issue',
          style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 13),
        ),
      ),
    );
  }

  // ===========================================================================
  // 48-HOUR SLA HERO CARD
  // ===========================================================================

  Widget _buildSlaHeroCard({
    required int activeCount,
    required int resolvedCount,
    required bool isDark,
  }) {
    final isDesktop = Breakpoints.isDesktop(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1E1B4B), Color(0xFF312E81)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: AppRadius.lg,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : Colors.transparent,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.shield_rounded, color: Color(0xFF34D399), size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'HOMIO 48-Hour Resolution SLA Commitment',
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Direct Site Supervisor Dispatch • Verified Closure Audits',
                      style: GoogleFonts.inter(
                        fontSize: 11.5,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: 0.2),
                  borderRadius: AppRadius.full,
                  border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.4)),
                ),
                child: Text(
                  '99.2% SLA On-Time',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF34D399),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          if (isDesktop) ...[
            Row(
              children: [
                Expanded(child: _buildHeroMetric('ACTIVE TICKETS', '$activeCount Open', activeCount > 0 ? const Color(0xFFF87171) : Colors.white70, 'Under supervisor inspection')),
                _buildHeroDivider(),
                Expanded(child: _buildHeroMetric('RESOLVED TICKETS', '$resolvedCount Closed', const Color(0xFF34D399), 'Customer signed-off')),
                _buildHeroDivider(),
                Expanded(child: _buildHeroMetric('GUARANTEED SLA', '48 Hours', const Color(0xFF38BDF8), 'Maximum turn-around time')),
                _buildHeroDivider(),
                Expanded(child: _buildHeroMetric('WARRANTY COVERAGE', '10 Years', const Color(0xFFFBBF24), 'Comprehensive structural warranty')),
              ],
            ),
          ] else ...[
            Row(
              children: [
                Expanded(child: _buildHeroMetric('ACTIVE', '$activeCount Open', activeCount > 0 ? const Color(0xFFF87171) : Colors.white70, 'Under review')),
                const SizedBox(width: 8),
                Expanded(child: _buildHeroMetric('RESOLVED', '$resolvedCount Closed', const Color(0xFF34D399), 'Verified')),
                const SizedBox(width: 8),
                Expanded(child: _buildHeroMetric('SLA', '48 Hours', const Color(0xFF38BDF8), 'Guaranteed')),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildHeroMetric(String label, String value, Color color, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: Colors.white54,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w900,
            color: color,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          subtitle,
          style: GoogleFonts.inter(
            fontSize: 11,
            color: Colors.white60,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildHeroDivider() {
    return Container(
      width: 1,
      height: 40,
      margin: const EdgeInsets.symmetric(horizontal: 14),
      color: Colors.white.withValues(alpha: 0.12),
    );
  }

  // ===========================================================================
  // FILTER BAR
  // ===========================================================================

  Widget _buildFilterBar({
    required int totalCount,
    required int activeCount,
    required int resolvedCount,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: AppRadius.lg,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : Colors.grey.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sub-Tab Switcher
          Row(
            children: [
              _buildStatusTab(0, 'All Tickets ($totalCount)', isDark),
              const SizedBox(width: 8),
              _buildStatusTab(1, 'Active ($activeCount)', isDark, badgeColor: const Color(0xFFEF4444)),
              const SizedBox(width: 8),
              _buildStatusTab(2, 'Resolved ($resolvedCount)', isDark, badgeColor: const Color(0xFF10B981)),
            ],
          ),

          const SizedBox(height: 12),

          // Search & Category Row
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  style: TextStyle(
                    color: isDark ? AppColors.darkTextPrimary : Colors.black,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Search tickets by defect, room, or ID (e.g. CMP-2026)...',
                    hintStyle: GoogleFonts.inter(
                      fontSize: 12.5,
                      color: isDark ? AppColors.darkTextMuted : Colors.grey.shade400,
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      size: 20,
                      color: isDark ? AppColors.darkTextMuted : Colors.grey,
                    ),
                    filled: true,
                    fillColor: isDark ? AppColors.darkSurfaceElevated : const Color(0xFFF8FAFC),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    border: OutlineInputBorder(
                      borderRadius: AppRadius.md,
                      borderSide: BorderSide(
                        color: isDark ? AppColors.darkBorder : Colors.grey.shade200,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: AppRadius.md,
                      borderSide: BorderSide(
                        color: isDark ? AppColors.darkBorder : Colors.grey.shade200,
                      ),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: AppRadius.md,
                      borderSide: BorderSide(color: AppColors.primary),
                    ),
                  ),
                  onChanged: (val) => setState(() => _searchQuery = val),
                ),
              ),
              const SizedBox(width: 12),
              // Category Dropdown
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurfaceElevated : const Color(0xFFF8FAFC),
                  borderRadius: AppRadius.md,
                  border: Border.all(
                    color: isDark ? AppColors.darkBorder : Colors.grey.shade200,
                  ),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedCategory,
                    dropdownColor: isDark ? AppColors.darkSurfaceElevated : Colors.white,
                    icon: Icon(
                      Icons.arrow_drop_down,
                      color: isDark ? AppColors.darkTextMuted : Colors.grey,
                    ),
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.darkTextPrimary : Colors.grey.shade800,
                    ),
                    items: _categories.map((c) {
                      return DropdownMenuItem(value: c, child: Text(c));
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedCategory = val);
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusTab(int index, String label, bool isDark, {Color? badgeColor}) {
    final isSelected = _activeStatusFilter == index;
    return InkWell(
      onTap: () => setState(() => _activeStatusFilter = index),
      borderRadius: AppRadius.md,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary
              : (isDark ? AppColors.darkSurfaceElevated : Colors.grey.shade100),
          borderRadius: AppRadius.md,
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12.5,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected
                ? Colors.white
                : (isDark ? AppColors.darkTextSecondary : Colors.grey.shade700),
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // COMPLAINT CARD
  // ===========================================================================

  Widget _buildComplaintCard(CustomerComplaint complaint, bool isDark) {
    final isOpen = complaint.isOpen;
    final isPriorityHigh = complaint.priority == 'High' || complaint.priority == 'Critical';

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: AppRadius.lg,
        border: Border.all(
          color: isOpen
              ? (isPriorityHigh ? const Color(0xFFEF4444) : const Color(0xFFF59E0B))
              : (isDark ? AppColors.darkBorder : Colors.grey.shade200),
          width: isOpen ? 1.5 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: ID, Tags, Status Badge
            Row(
              children: [
                Text(
                  complaint.id,
                  style: GoogleFonts.inter(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF818CF8),
                  ),
                ),
                const SizedBox(width: 8),
                if (complaint.relatedRoom != null) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkSurfaceElevated : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      complaint.relatedRoom!,
                      style: GoogleFonts.inter(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppColors.darkTextSecondary : Colors.grey.shade700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                ],
                _buildPriorityBadge(complaint.priority, isDark),
                const Spacer(),
                _buildStatusBadge(complaint.status, isDark),
              ],
            ),

            const SizedBox(height: 10),

            // Title
            Text(
              complaint.title,
              style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: isDark ? AppColors.darkTextPrimary : Colors.grey.shade900,
              ),
            ),

            const SizedBox(height: 4),

            // Description
            Text(
              complaint.description,
              style: GoogleFonts.inter(
                fontSize: 12.5,
                color: isDark ? AppColors.darkTextSecondary : Colors.grey.shade600,
                height: 1.4,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 12),

            // Assigned Supervisor & Meta Strip
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurfaceSubtle : const Color(0xFFF8FAFC),
                borderRadius: AppRadius.md,
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : Colors.grey.shade200,
                ),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 12,
                    backgroundColor: const Color(0xFF10B981),
                    child: Text(
                      complaint.assignedContactName.split(' ').map((e) => e[0]).take(2).join(),
                      style: const TextStyle(fontSize: 9, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${complaint.assignedContactName} (${complaint.assignedContactRole})',
                          style: GoogleFonts.inter(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w700,
                            color: isDark ? AppColors.darkTextPrimary : Colors.grey.shade900,
                          ),
                        ),
                        Text(
                          'Logged on ${complaint.createdDate} • Last updated: ${complaint.lastUpdated}',
                          style: GoogleFonts.inter(
                            fontSize: 10.5,
                            color: isDark ? AppColors.darkTextMuted : Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isOpen) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF78350F).withValues(alpha: 0.4)
                            : const Color(0xFFFEF3C7),
                        borderRadius: BorderRadius.circular(AppRadius.xsVal),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.timer_outlined,
                            size: 12,
                            color: isDark ? const Color(0xFFFBBF24) : const Color(0xFFB45309),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'SLA: 48h active',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: isDark ? const Color(0xFFFBBF24) : const Color(0xFFB45309),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // If Resolved: Resolution Notes & Rating
            if (complaint.isResolved && complaint.resolutionNotes != null) ...[
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF064E3B).withValues(alpha: 0.3)
                      : const Color(0xFFECFDF5),
                  borderRadius: AppRadius.md,
                  border: Border.all(
                    color: isDark ? const Color(0xFF047857) : const Color(0xFFA7F3D0),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.check_circle_rounded, color: Color(0xFF10B981), size: 16),
                        const SizedBox(width: 6),
                        Text(
                          'Resolution Signed-Off (${complaint.resolvedDate})',
                          style: GoogleFonts.inter(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w700,
                            color: isDark ? const Color(0xFF34D399) : const Color(0xFF065F46),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      complaint.resolutionNotes!,
                      style: GoogleFonts.inter(
                        fontSize: 11.5,
                        color: isDark ? Colors.white70 : const Color(0xFF047857),
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 14),
            Divider(
              height: 1,
              color: isDark ? AppColors.darkBorder : Colors.grey.shade200,
            ),
            const SizedBox(height: 12),

            // Actions Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    if (complaint.attachments.isNotEmpty) ...[
                      Icon(
                        Icons.attachment_rounded,
                        size: 14,
                        color: isDark ? AppColors.darkTextMuted : Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${complaint.attachments.length} Photo Proof',
                        style: GoogleFonts.inter(
                          fontSize: 11.5,
                          color: isDark ? AppColors.darkTextMuted : Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(width: 12),
                    ],
                    Icon(
                      Icons.forum_outlined,
                      size: 14,
                      color: isDark ? AppColors.darkTextMuted : Colors.grey,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${complaint.messages.length} Messages',
                      style: GoogleFonts.inter(
                        fontSize: 11.5,
                        color: isDark ? AppColors.darkTextMuted : Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),

                Row(
                  children: [
                    if (complaint.isResolved) ...[
                      OutlinedButton.icon(
                        onPressed: () => _showReopenDialog(complaint, isDark),
                        icon: const Icon(Icons.replay_rounded, size: 14),
                        label: const Text('Reopen'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: isDark ? const Color(0xFFF87171) : Colors.red.shade700,
                          side: BorderSide(
                            color: isDark ? const Color(0xFFEF4444).withValues(alpha: 0.5) : Colors.red.shade300,
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          shape: RoundedAppRadius.md,
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                    ElevatedButton.icon(
                      onPressed: () => _openTicketDetailModal(complaint, isDark),
                      icon: const Icon(Icons.timeline_rounded, size: 14),
                      label: Text(isOpen ? 'Track & Reply' : 'View Audit Log'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        shape: RoundedAppRadius.md,
                        elevation: 0,
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

  Widget _buildPriorityBadge(String priority, bool isDark) {
    Color bg;
    Color fg;

    switch (priority.toLowerCase()) {
      case 'critical':
      case 'high':
        bg = isDark ? const Color(0xFF7F1D1D).withValues(alpha: 0.4) : const Color(0xFFFEE2E2);
        fg = const Color(0xFFF87171);
        break;
      case 'medium':
        bg = isDark ? const Color(0xFF78350F).withValues(alpha: 0.4) : const Color(0xFFFEF3C7);
        fg = const Color(0xFFFBBF24);
        break;
      default:
        bg = isDark ? AppColors.darkSurfaceElevated : Colors.grey.shade100;
        fg = isDark ? AppColors.darkTextSecondary : Colors.grey.shade700;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        '$priority Priority',
        style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: fg),
      ),
    );
  }

  Widget _buildStatusBadge(String status, bool isDark) {
    Color bg;
    Color fg;

    switch (status.toLowerCase()) {
      case 'resolved':
        bg = isDark ? const Color(0xFF064E3B).withValues(alpha: 0.4) : const Color(0xFFECFDF5);
        fg = const Color(0xFF34D399);
        break;
      case 'in progress':
      case 'under review':
        bg = isDark ? const Color(0xFF1E3A8A).withValues(alpha: 0.4) : const Color(0xFFEFF6FF);
        fg = const Color(0xFF60A5FA);
        break;
      case 'open':
        bg = isDark ? const Color(0xFF7F1D1D).withValues(alpha: 0.4) : const Color(0xFFFEF2F2);
        fg = const Color(0xFFF87171);
        break;
      case 'reopened':
        bg = isDark ? const Color(0xFF78350F).withValues(alpha: 0.4) : const Color(0xFFFFFBEB);
        fg = const Color(0xFFFBBF24);
        break;
      default:
        bg = isDark ? AppColors.darkSurfaceElevated : Colors.grey.shade100;
        fg = isDark ? AppColors.darkTextSecondary : Colors.grey.shade800;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        status.toUpperCase(),
        style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w800, color: fg),
      ),
    );
  }

  // ===========================================================================
  // TICKET DETAIL MODAL (TIMELINE & IN-TICKET MESSAGING)
  // ===========================================================================

  void _openTicketDetailModal(CustomerComplaint complaint, bool isDark) {
    final msgCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (dialogCtx, setDialogState) {
            return Dialog(
              backgroundColor: isDark ? AppColors.darkCard : Colors.white,
              shape: RoundedRectangleBorder(borderRadius: AppRadius.lg),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 620, maxHeight: 720),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Header
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.support_agent_rounded, color: AppColors.primary, size: 20),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  complaint.title,
                                  style: GoogleFonts.inter(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                    color: isDark ? AppColors.darkTextPrimary : Colors.black,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  '${complaint.id} • Assigned to ${complaint.assignedContactName}',
                                  style: GoogleFonts.inter(
                                    fontSize: 11.5,
                                    color: isDark ? AppColors.darkTextMuted : Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.close,
                              color: isDark ? AppColors.darkTextMuted : Colors.grey,
                            ),
                            onPressed: () => Navigator.pop(dialogCtx),
                          ),
                        ],
                      ),

                      Divider(
                        height: 20,
                        color: isDark ? AppColors.darkBorder : Colors.grey.shade200,
                      ),

                      // Content: Timeline and Messages
                      Expanded(
                        child: ListView(
                          children: [
                            // Step-by-Step Resolution Timeline
                            Text(
                              'SLA Resolution Audit Log',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: isDark ? AppColors.darkTextPrimary : Colors.black,
                              ),
                            ),
                            const SizedBox(height: 10),
                            ...complaint.activityLog.map((act) => _buildTimelineTile(act, isDark)),

                            const SizedBox(height: 16),
                            Divider(height: 1, color: isDark ? AppColors.darkBorder : Colors.grey.shade200),
                            const SizedBox(height: 14),

                            // Messages Thread
                            Text(
                              'Supervisor Discussion Thread',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: isDark ? AppColors.darkTextPrimary : Colors.black,
                              ),
                            ),
                            const SizedBox(height: 10),

                            if (complaint.messages.isEmpty) ...[
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: isDark ? AppColors.darkSurfaceSubtle : Colors.grey.shade50,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  'No messages in thread yet. Type below to query the assigned supervisor.',
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    color: isDark ? AppColors.darkTextMuted : Colors.grey.shade500,
                                  ),
                                ),
                              ),
                            ] else ...[
                              ...complaint.messages.map((m) => _buildMessageRow(m, isDark)),
                            ],
                          ],
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Message Composer
                      if (complaint.isOpen) ...[
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: msgCtrl,
                                style: TextStyle(color: isDark ? AppColors.darkTextPrimary : Colors.black),
                                decoration: InputDecoration(
                                  hintText: 'Type query for supervisor Amit Verma...',
                                  hintStyle: GoogleFonts.inter(
                                    fontSize: 12,
                                    color: isDark ? AppColors.darkTextMuted : Colors.grey.shade400,
                                  ),
                                  filled: true,
                                  fillColor: isDark ? AppColors.darkSurfaceElevated : Colors.grey.shade50,
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  border: OutlineInputBorder(
                                    borderRadius: AppRadius.md,
                                    borderSide: BorderSide(
                                      color: isDark ? AppColors.darkBorder : Colors.grey.shade300,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            CircleAvatar(
                              backgroundColor: AppColors.primary,
                              child: IconButton(
                                icon: const Icon(Icons.send_rounded, size: 16, color: Colors.white),
                                onPressed: () {
                                  if (msgCtrl.text.trim().isEmpty) return;
                                  ClientDataRepository.sendComplaintMessage(
                                    complaint.id,
                                    msgCtrl.text.trim(),
                                  );
                                  msgCtrl.clear();
                                  setDialogState(() {});
                                  setState(() {});
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildTimelineTile(ComplaintActivityItem act, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 4),
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
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
                    Text(
                      act.action,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.darkTextPrimary : Colors.grey.shade900,
                      ),
                    ),
                    Text(
                      act.timestamp,
                      style: GoogleFonts.inter(
                        fontSize: 10.5,
                        color: isDark ? AppColors.darkTextMuted : Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
                Text(
                  '${act.actor}: ${act.note}',
                  style: GoogleFonts.inter(
                    fontSize: 11.5,
                    color: isDark ? AppColors.darkTextSecondary : Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageRow(ComplaintMessageItem msg, bool isDark) {
    final isClient = msg.isClient;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isClient
            ? AppColors.primary.withValues(alpha: isDark ? 0.2 : 0.08)
            : (isDark ? AppColors.darkSurfaceElevated : Colors.grey.shade100),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${msg.author} (${msg.role})',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: isDark ? const Color(0xFF818CF8) : AppColors.primary,
                ),
              ),
              Text(
                msg.timestamp,
                style: GoogleFonts.inter(
                  fontSize: 10,
                  color: isDark ? AppColors.darkTextMuted : Colors.grey.shade500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            msg.text,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: isDark ? AppColors.darkTextPrimary : Colors.grey.shade800,
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // RAISE COMPLAINT MODAL
  // ===========================================================================

  void _showRaiseComplaintModal(bool isDark) {
    final titleCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    String selectedCategory = 'Execution & Workmanship';
    String selectedPriority = 'Medium';
    String selectedRoom = 'Modular Kitchen';

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: isDark ? AppColors.darkCard : Colors.white,
          title: Text(
            'Raise New Snag / Issue',
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w800,
              fontSize: 16,
              color: isDark ? AppColors.darkTextPrimary : Colors.black,
            ),
          ),
          content: SingleChildScrollView(
            child: SizedBox(
              width: 440,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E3A8A).withValues(alpha: 0.3) : const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Your defect report will immediately notify on-site supervisor Amit Verma under the guaranteed 48-hour SLA.',
                      style: GoogleFonts.inter(
                        fontSize: 11.5,
                        color: isDark ? const Color(0xFF93C5FD) : const Color(0xFF1D4ED8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: titleCtrl,
                    style: TextStyle(color: isDark ? AppColors.darkTextPrimary : Colors.black),
                    decoration: InputDecoration(
                      labelText: 'Issue Title *',
                      labelStyle: TextStyle(color: isDark ? AppColors.darkTextSecondary : Colors.grey.shade700),
                      hintText: 'e.g. Wardrobe sliding door bottom track misaligned',
                      hintStyle: TextStyle(color: isDark ? AppColors.darkTextMuted : Colors.grey.shade400),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          initialValue: selectedRoom,
                          dropdownColor: isDark ? AppColors.darkSurfaceElevated : Colors.white,
                          style: TextStyle(color: isDark ? AppColors.darkTextPrimary : Colors.black, fontSize: 12),
                          decoration: InputDecoration(
                            labelText: 'Room',
                            labelStyle: TextStyle(color: isDark ? AppColors.darkTextSecondary : Colors.grey.shade700),
                            border: const OutlineInputBorder(),
                          ),
                          items: ['Modular Kitchen', 'Living Room', 'Master Bedroom', 'Balcony Deck', 'Bathroom']
                              .map((r) => DropdownMenuItem(value: r, child: Text(r, style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextPrimary : Colors.black))))
                              .toList(),
                          onChanged: (val) => selectedRoom = val ?? selectedRoom,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          initialValue: selectedPriority,
                          dropdownColor: isDark ? AppColors.darkSurfaceElevated : Colors.white,
                          style: TextStyle(color: isDark ? AppColors.darkTextPrimary : Colors.black, fontSize: 12),
                          decoration: InputDecoration(
                            labelText: 'Priority',
                            labelStyle: TextStyle(color: isDark ? AppColors.darkTextSecondary : Colors.grey.shade700),
                            border: const OutlineInputBorder(),
                          ),
                          items: ['High', 'Medium', 'Low']
                              .map((p) => DropdownMenuItem(value: p, child: Text(p, style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextPrimary : Colors.black))))
                              .toList(),
                          onChanged: (val) => selectedPriority = val ?? selectedPriority,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: descCtrl,
                    maxLines: 3,
                    style: TextStyle(color: isDark ? AppColors.darkTextPrimary : Colors.black),
                    decoration: InputDecoration(
                      labelText: 'Detailed Description *',
                      labelStyle: TextStyle(color: isDark ? AppColors.darkTextSecondary : Colors.grey.shade700),
                      hintText: 'Describe what requires correction or inspection on site...',
                      hintStyle: TextStyle(color: isDark ? AppColors.darkTextMuted : Colors.grey.shade400),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Simulated site photo attached: defect_snag_photo_1.jpg')),
                      );
                    },
                    icon: const Icon(Icons.add_a_photo_outlined, size: 16),
                    label: const Text('Attach Photo Proof'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: isDark ? AppColors.darkTextPrimary : Colors.grey.shade800,
                      side: BorderSide(
                        color: isDark ? AppColors.darkBorder : Colors.grey.shade300,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(
                'Cancel',
                style: TextStyle(color: isDark ? AppColors.darkTextSecondary : Colors.grey.shade700),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (titleCtrl.text.trim().isEmpty || descCtrl.text.trim().isEmpty) return;
                ClientDataRepository.raiseComplaint(
                  title: titleCtrl.text.trim(),
                  category: selectedCategory,
                  description: descCtrl.text.trim(),
                  priority: selectedPriority,
                  relatedRoom: selectedRoom,
                  relatedStage: '05 Execution',
                );
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Support ticket raised! Assigned to site supervisor Amit Verma.'),
                    backgroundColor: Color(0xFF047857),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEF4444),
                foregroundColor: Colors.white,
              ),
              child: const Text('Submit Ticket'),
            ),
          ],
        );
      },
    );
  }

  void _showReopenDialog(CustomerComplaint complaint, bool isDark) {
    final reasonCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: isDark ? AppColors.darkCard : Colors.white,
          title: Text(
            'Reopen Ticket ${complaint.id}',
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w800,
              fontSize: 16,
              color: isDark ? AppColors.darkTextPrimary : Colors.black,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Please explain why the resolution was unsatisfactory so our team can re-inspect the site.',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: isDark ? AppColors.darkTextSecondary : Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: reasonCtrl,
                maxLines: 2,
                style: TextStyle(color: isDark ? AppColors.darkTextPrimary : Colors.black),
                decoration: InputDecoration(
                  labelText: 'Reason for Reopening',
                  labelStyle: TextStyle(color: isDark ? AppColors.darkTextSecondary : Colors.grey.shade700),
                  border: const OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(
                'Cancel',
                style: TextStyle(color: isDark ? AppColors.darkTextSecondary : Colors.grey.shade700),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (reasonCtrl.text.trim().isEmpty) return;
                ClientDataRepository.reopenComplaint(complaint.id, reasonCtrl.text.trim());
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Ticket reopened. Supervisor re-dispatched.'),
                    backgroundColor: Color(0xFFD97706),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD97706),
                foregroundColor: Colors.white,
              ),
              child: const Text('Reopen Ticket'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(32),
      alignment: Alignment.center,
      child: Column(
        children: [
          const Icon(Icons.check_circle_outline_rounded, size: 48, color: Color(0xFF10B981)),
          const SizedBox(height: 12),
          Text(
            'No issues or snags matching this filter.',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: isDark ? AppColors.darkTextPrimary : Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'All project execution is currently operating in accordance with quality standards.',
            style: GoogleFonts.inter(
              fontSize: 12,
              color: isDark ? AppColors.darkTextMuted : Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }
}
