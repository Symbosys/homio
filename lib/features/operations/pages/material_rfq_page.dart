import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/responsive/breakpoints.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../models/operations_mock_data.dart';
import '../models/operations_models.dart';

class MaterialRfqPage extends StatefulWidget {
  const MaterialRfqPage({super.key});

  @override
  State<MaterialRfqPage> createState() => _MaterialRfqPageState();
}

class _MaterialRfqPageState extends State<MaterialRfqPage> {
  String _searchQuery = '';
  IndentStatus? _statusFilter;
  IndentUrgency? _urgencyFilter;
  late List<MaterialRequisitionIndent> _indents;

  @override
  void initState() {
    super.initState();
    _indents = List.from(OperationsMockData.indents);
  }

  List<MaterialRequisitionIndent> get _filteredIndents {
    return _indents.where((indent) {
      if (_statusFilter != null && indent.status != _statusFilter) return false;
      if (_urgencyFilter != null && indent.urgency != _urgencyFilter) return false;
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final match = indent.itemName.toLowerCase().contains(q) ||
            indent.projectTitle.toLowerCase().contains(q) ||
            indent.clientName.toLowerCase().contains(q) ||
            indent.siteSupervisor.toLowerCase().contains(q);
        if (!match) return false;
      }
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isMobile = MediaQuery.of(context).size.width < 768;

    final totalIndents = _indents.length;
    final bidsPending = _indents.where((i) => i.status == IndentStatus.pendingRfq).length;
    final evaluating = _indents.where((i) => i.status == IndentStatus.bidsReceived).length;
    final approvedDispatched = _indents.where((i) => i.status == IndentStatus.approved || i.status == IndentStatus.dispatched).length;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 16 : 28,
          vertical: 24,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: Breakpoints.maxContentWidth),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Header Banner
                _buildHeader(context, isDark, isMobile),

                const SizedBox(height: 20),

                // 2. Metrics Bar
                _buildMetricsBar(isDark, isMobile, totalIndents, bidsPending, evaluating, approvedDispatched),

                const SizedBox(height: 24),

                // 3. Search & Filter Bar
                _buildFilterBar(isDark, isMobile),

                const SizedBox(height: 20),

                // 4. Indents List & Bidding Matrix
                if (_filteredIndents.isEmpty)
                  _buildEmptyState(isDark)
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _filteredIndents.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 20),
                    itemBuilder: (context, index) {
                      return _buildIndentCard(context, _filteredIndents[index], isDark, isMobile);
                    },
                  ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark, bool isMobile) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 18 : 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF1E1435), const Color(0xFF131127), const Color(0xFF0F172A)]
              : [const Color(0xFFFAF5FF), const Color(0xFFF3E8FF), Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: AppRadius.lg,
        border: Border.all(
          color: const Color(0xFF8B5CF6).withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFF8B5CF6).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFF8B5CF6).withValues(alpha: 0.4)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.local_shipping_rounded, size: 14, color: Color(0xFF8B5CF6)),
                    const SizedBox(width: 6),
                    Text(
                      'MODULE 11: OPERATIONS & PROCUREMENT',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF8B5CF6),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
              FilledButton.icon(
                onPressed: () => _showNewIndentDialog(context),
                icon: const Icon(Icons.add_rounded, size: 16),
                label: Text(
                  'Raise Material Indent',
                  style: GoogleFonts.plusJakartaSans(fontSize: 12.5, fontWeight: FontWeight.w700),
                ),
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF8B5CF6),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            'Material Requisitions & Multi-Vendor RFQ Bidding',
            style: GoogleFonts.plusJakartaSans(
              fontSize: isMobile ? 20 : 24,
              fontWeight: FontWeight.w800,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Live site supervisor indents, side-by-side vendor quotation comparison, 1-click PO issuance, and automated client payment link generation.',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricsBar(bool isDark, bool isMobile, int total, int pending, int evaluating, int approved) {
    final metrics = [
      (label: 'Total Active Indents', count: '$total', icon: Icons.assignment_rounded, color: const Color(0xFF6366F1)),
      (label: 'Pending Vendor Bids', count: '$pending', icon: Icons.pending_actions_rounded, color: const Color(0xFFF59E0B)),
      (label: 'Bids Under Review', count: '$evaluating', icon: Icons.balance_rounded, color: const Color(0xFF0EA5E9)),
      (label: 'Approved & Dispatched', count: '$approved', icon: Icons.task_alt_rounded, color: const Color(0xFF10B981)),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 700;
        final cardWidth = isWide ? (constraints.maxWidth - 36) / 4 : (constraints.maxWidth - 12) / 2;

        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: metrics.map((m) {
            return SizedBox(
              width: cardWidth,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : Colors.white,
                  borderRadius: AppRadius.md,
                  border: Border.all(
                    color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: m.color.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(m.icon, size: 20, color: m.color),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            m.label,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            m.count,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: isDark ? Colors.white : const Color(0xFF0F172A),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildFilterBar(bool isDark, bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: AppRadius.md,
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        crossAxisAlignment: WrapCrossAlignment.center,
        alignment: WrapAlignment.spaceBetween,
        children: [
          // Search Box
          SizedBox(
            width: isMobile ? double.infinity : 320,
            height: 40,
            child: TextField(
              onChanged: (val) => setState(() => _searchQuery = val),
              decoration: InputDecoration(
                hintText: 'Search material, project, supervisor...',
                hintStyle: GoogleFonts.plusJakartaSans(fontSize: 12.5),
                prefixIcon: const Icon(Icons.search_rounded, size: 18),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                filled: true,
                fillColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1)),
                ),
              ),
            ),
          ),

          // Filters
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              // Urgency Filter
              DropdownButton<IndentUrgency?>(
                value: _urgencyFilter,
                underline: const SizedBox(),
                hint: Text('All Urgencies', style: GoogleFonts.plusJakartaSans(fontSize: 12.5)),
                dropdownColor: isDark ? const Color(0xFF1E293B) : Colors.white,
                items: [
                  DropdownMenuItem(
                    value: null,
                    child: Text('All Urgencies', style: GoogleFonts.plusJakartaSans(fontSize: 12.5)),
                  ),
                  DropdownMenuItem(
                    value: IndentUrgency.urgent,
                    child: Text('🚨 Urgent Only', style: GoogleFonts.plusJakartaSans(fontSize: 12.5, color: const Color(0xFFEF4444))),
                  ),
                  DropdownMenuItem(
                    value: IndentUrgency.standard,
                    child: Text('Standard', style: GoogleFonts.plusJakartaSans(fontSize: 12.5)),
                  ),
                ],
                onChanged: (val) => setState(() => _urgencyFilter = val),
              ),

              // Status Filter
              DropdownButton<IndentStatus?>(
                value: _statusFilter,
                underline: const SizedBox(),
                hint: Text('All Statuses', style: GoogleFonts.plusJakartaSans(fontSize: 12.5)),
                dropdownColor: isDark ? const Color(0xFF1E293B) : Colors.white,
                items: [
                  DropdownMenuItem(
                    value: null,
                    child: Text('All Statuses', style: GoogleFonts.plusJakartaSans(fontSize: 12.5)),
                  ),
                  DropdownMenuItem(
                    value: IndentStatus.pendingRfq,
                    child: Text('Pending RFQ', style: GoogleFonts.plusJakartaSans(fontSize: 12.5)),
                  ),
                  DropdownMenuItem(
                    value: IndentStatus.bidsReceived,
                    child: Text('Bids Received', style: GoogleFonts.plusJakartaSans(fontSize: 12.5)),
                  ),
                  DropdownMenuItem(
                    value: IndentStatus.approved,
                    child: Text('Bid Approved', style: GoogleFonts.plusJakartaSans(fontSize: 12.5)),
                  ),
                  DropdownMenuItem(
                    value: IndentStatus.dispatched,
                    child: Text('Dispatched', style: GoogleFonts.plusJakartaSans(fontSize: 12.5)),
                  ),
                ],
                onChanged: (val) => setState(() => _statusFilter = val),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIndentCard(BuildContext context, MaterialRequisitionIndent indent, bool isDark, bool isMobile) {
    final isUrgent = indent.urgency == IndentUrgency.urgent;

    Color statusColor;
    String statusLabel;
    switch (indent.status) {
      case IndentStatus.pendingRfq:
        statusColor = const Color(0xFFF59E0B);
        statusLabel = 'PENDING RFQ BROADCAST';
        break;
      case IndentStatus.bidsReceived:
        statusColor = const Color(0xFF0EA5E9);
        statusLabel = '${indent.bids.length} BIDS RECEIVED';
        break;
      case IndentStatus.approved:
        statusColor = const Color(0xFF10B981);
        statusLabel = 'BID APPROVED • PO ISSUED';
        break;
      case IndentStatus.dispatched:
        statusColor = const Color(0xFF8B5CF6);
        statusLabel = 'DISPATCHED TO SITE';
        break;
    }

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: AppRadius.lg,
        border: Border.all(
          color: isUrgent
              ? const Color(0xFFEF4444).withValues(alpha: 0.5)
              : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
          width: isUrgent ? 1.5 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Bar of Indent
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B).withValues(alpha: 0.5) : const Color(0xFFF8FAFC),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              border: Border(bottom: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder)),
            ),
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 12,
              runSpacing: 8,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: isUrgent ? const Color(0xFFEF4444).withValues(alpha: 0.15) : const Color(0xFF64748B).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        indent.id,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: isUrgent ? const Color(0xFFEF4444) : (isDark ? Colors.white70 : const Color(0xFF475569)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (isUrgent)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEF4444).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: const Color(0xFFEF4444).withValues(alpha: 0.5)),
                        ),
                        child: Text(
                          'URGENT SITE NEED',
                          style: GoogleFonts.plusJakartaSans(fontSize: 9.5, fontWeight: FontWeight.w800, color: const Color(0xFFEF4444)),
                        ),
                      ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: statusColor.withValues(alpha: 0.4)),
                  ),
                  child: Text(
                    statusLabel,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w800,
                      color: statusColor,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Body: Indent Details
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            indent.itemName,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: isDark ? Colors.white : const Color(0xFF0F172A),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Wrap(
                            spacing: 16,
                            runSpacing: 4,
                            children: [
                              _buildMetaItem(Icons.domain_rounded, indent.projectTitle, isDark),
                              _buildMetaItem(Icons.person_rounded, 'Client: ${indent.clientName}', isDark),
                              _buildMetaItem(Icons.engineering_rounded, 'Supervisor: ${indent.siteSupervisor}', isDark),
                              _buildMetaItem(Icons.event_available_rounded, 'Required: ${_formatDate(indent.requiredDate)}', isDark),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF6366F1).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${indent.quantity.toInt()} ${indent.unit}',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: const Color(0xFF6366F1),
                            ),
                          ),
                          Text(
                            'Quantity',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                if (indent.notes != null) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.info_outline_rounded, size: 14, color: Color(0xFF64748B)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            indent.notes!,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: 20),

                // Bidding Matrix Section
                _buildBiddingMatrix(context, indent, isDark, isMobile),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetaItem(IconData icon, String text, bool isDark) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: const Color(0xFF94A3B8)),
        const SizedBox(width: 4),
        Text(
          text,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
          ),
        ),
      ],
    );
  }

  Widget _buildBiddingMatrix(BuildContext context, MaterialRequisitionIndent indent, bool isDark, bool isMobile) {
    if (indent.bids.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1B4B).withValues(alpha: 0.3) : const Color(0xFFF5F3FF),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFF8B5CF6).withValues(alpha: 0.25)),
        ),
        child: Row(
          children: [
            const Icon(Icons.outbox_rounded, size: 24, color: Color(0xFF8B5CF6)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'No vendor quotations received yet.',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                  Text(
                    'Broadcast RFQ to verified suppliers to receive competitive quotes.',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11.5,
                      color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                    ),
                  ),
                ],
              ),
            ),
            FilledButton.icon(
              onPressed: () => _showBroadcastRfqDialog(context, indent),
              icon: const Icon(Icons.send_rounded, size: 14),
              label: Text('Broadcast RFQ', style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700)),
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF8B5CF6),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Side-by-Side Vendor Quotation Bids',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155),
              ),
            ),
            if (indent.status == IndentStatus.bidsReceived)
              OutlinedButton.icon(
                onPressed: () => _showBroadcastRfqDialog(context, indent),
                icon: const Icon(Icons.add_rounded, size: 14),
                label: Text('Invite More Vendors', style: GoogleFonts.plusJakartaSans(fontSize: 11.5)),
                style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4)),
              ),
          ],
        ),
        const SizedBox(height: 10),

        // Multi-Vendor Cards Carousel/Grid
        LayoutBuilder(
          builder: (context, constraints) {
            final isMultiCol = constraints.maxWidth > 600;
            final cardWidth = isMultiCol ? (constraints.maxWidth - (indent.bids.length - 1) * 12) / indent.bids.length : double.infinity;

            return Wrap(
              spacing: 12,
              runSpacing: 12,
              children: indent.bids.map((bid) {
                final isApproved = indent.approvedBidId == bid.id;

                return SizedBox(
                  width: cardWidth,
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isApproved
                          ? (isDark ? const Color(0xFF064E3B).withValues(alpha: 0.3) : const Color(0xFFECFDF5))
                          : (isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC)),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isApproved
                            ? const Color(0xFF10B981)
                            : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                        width: isApproved ? 1.5 : 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Vendor Name + Rating
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                bid.vendorName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w800,
                                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF59E0B).withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.star_rounded, size: 12, color: Color(0xFFF59E0B)),
                                  const SizedBox(width: 2),
                                  Text(
                                    bid.vendorRating.toString(),
                                    style: GoogleFonts.plusJakartaSans(fontSize: 10, fontWeight: FontWeight.w800, color: const Color(0xFFF59E0B)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // Price
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              '₹${bid.totalPrice.toInt()}',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 17,
                                fontWeight: FontWeight.w900,
                                color: isApproved ? const Color(0xFF10B981) : (isDark ? Colors.white : const Color(0xFF0F172A)),
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '(₹${bid.unitPrice.toInt()}/${indent.unit})',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 10.5,
                                color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // Highlights
                        _buildBidFeature(Icons.local_shipping_outlined, 'Delivery: ${bid.deliveryDays} Days', isDark),
                        _buildBidFeature(Icons.verified_outlined, bid.qualityGrade, isDark),
                        _buildBidFeature(Icons.shield_outlined, 'Warranty: ${bid.warrantyMonths ~/ 12} Years', isDark),
                        _buildBidFeature(Icons.payment_outlined, bid.paymentTerms, isDark),

                        const SizedBox(height: 12),

                        // Action Button
                        if (isApproved)
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              color: const Color(0xFF10B981),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.check_circle_rounded, size: 14, color: Colors.white),
                                const SizedBox(width: 6),
                                Text(
                                  'APPROVED BID',
                                  style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w800, color: Colors.white),
                                ),
                              ],
                            ),
                          )
                        else
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              onPressed: () => _approveBid(indent, bid),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: const Color(0xFF10B981),
                                side: const BorderSide(color: Color(0xFF10B981)),
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                              ),
                              child: Text(
                                'Approve This Bid',
                                style: GoogleFonts.plusJakartaSans(fontSize: 11.5, fontWeight: FontWeight.w700),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),

        // If Approved: Show Payment Link Action
        if (indent.clientPaymentUrl != null) ...[
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF10B981).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.link_rounded, size: 18, color: Color(0xFF10B981)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Client Payment Link: ${indent.clientPaymentUrl}',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isDark ? const Color(0xFFA7F3D0) : const Color(0xFF065F46),
                    ),
                  ),
                ),
                FilledButton.icon(
                  onPressed: () => _dispatchPaymentLink(indent),
                  icon: const Icon(Icons.share_rounded, size: 13),
                  label: Text('Send via WhatsApp', style: GoogleFonts.plusJakartaSans(fontSize: 11.5)),
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF10B981),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildBidFeature(IconData icon, String text, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(icon, size: 12, color: const Color(0xFF94A3B8)),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(40),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: AppRadius.md,
      ),
      child: Column(
        children: [
          const Icon(Icons.search_off_rounded, size: 48, color: Color(0xFF94A3B8)),
          const SizedBox(height: 12),
          Text(
            'No matching material indents found.',
            style: GoogleFonts.plusJakartaSans(fontSize: 15, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Text(
            'Try resetting your search query or status filters.',
            style: GoogleFonts.plusJakartaSans(fontSize: 13, color: const Color(0xFF94A3B8)),
          ),
        ],
      ),
    );
  }

  void _approveBid(MaterialRequisitionIndent indent, VendorBid bid) {
    setState(() {
      final index = _indents.indexWhere((i) => i.id == indent.id);
      if (index != -1) {
        final updated = indent.copyWith(
          approvedBidId: bid.id,
          status: IndentStatus.approved,
          clientPaymentUrl: 'https://pay.homio.in/inv/${indent.id}',
        );
        _indents[index] = updated;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Bid by ${bid.vendorName} approved! Client payment link generated.'),
        backgroundColor: const Color(0xFF10B981),
      ),
    );
  }

  void _dispatchPaymentLink(MaterialRequisitionIndent indent) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Payment link for ${indent.itemName} dispatched to ${indent.clientName} via WhatsApp!'),
        backgroundColor: const Color(0xFF10B981),
      ),
    );
  }

  void _showBroadcastRfqDialog(BuildContext context, MaterialRequisitionIndent indent) {
    final vendors = [
      'Century Wholesale Hub, DLF Phase 2',
      'Austin Plywood Regional Depot, Delhi',
      'Greenply Metro Timber Mart, Gurugram',
      'Hafele Direct Corporate Channel, Okhla',
      'Saint-Gobain Glass Direct, Mumbai',
      'Asian Paints Wholesale Depot',
    ];
    final selected = <String>{vendors.first, vendors[1]};

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: Text('Broadcast RFQ for ${indent.id}', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800)),
              content: SizedBox(
                width: 480,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Select verified distributors to request competitive price quotations from:'),
                    const SizedBox(height: 12),
                    ...vendors.map((v) {
                      final isChecked = selected.contains(v);
                      return CheckboxListTile(
                        dense: true,
                        value: isChecked,
                        title: Text(v, style: GoogleFonts.plusJakartaSans(fontSize: 12.5)),
                        onChanged: (val) {
                          setDialogState(() {
                            if (val == true) {
                              selected.add(v);
                            } else {
                              selected.remove(v);
                            }
                          });
                        },
                      );
                    }),
                  ],
                ),
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
                FilledButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('RFQ broadcast to ${selected.length} vendors! Bids expected within 24h.')),
                    );
                  },
                  child: const Text('Dispatch RFQs'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showNewIndentDialog(BuildContext context) {
    final itemCtrl = TextEditingController();
    final qtyCtrl = TextEditingController();
    final unitCtrl = TextEditingController(text: 'Sheets (8x4)');
    final projectCtrl = TextEditingController(text: 'DLF Magnolias #402');
    final clientCtrl = TextEditingController(text: 'Rajeev Singhania');
    final supCtrl = TextEditingController(text: 'Rajesh Verma');
    IndentUrgency selectedUrgency = IndentUrgency.standard;

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: Text('Raise New Material Indent', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800)),
              content: SizedBox(
                width: 480,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: itemCtrl,
                        decoration: const InputDecoration(labelText: 'Material Specification / Item Name'),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: qtyCtrl,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(labelText: 'Quantity'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              controller: unitCtrl,
                              decoration: const InputDecoration(labelText: 'Unit'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: projectCtrl,
                        decoration: const InputDecoration(labelText: 'Project Name'),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: clientCtrl,
                              decoration: const InputDecoration(labelText: 'Client Name'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              controller: supCtrl,
                              decoration: const InputDecoration(labelText: 'Site Supervisor'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Text('Urgency: ', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600)),
                          const SizedBox(width: 8),
                          ChoiceChip(
                            label: const Text('Standard'),
                            selected: selectedUrgency == IndentUrgency.standard,
                            onSelected: (s) {
                              if (s) setDialogState(() => selectedUrgency = IndentUrgency.standard);
                            },
                          ),
                          const SizedBox(width: 8),
                          ChoiceChip(
                            label: const Text('🚨 Urgent'),
                            selected: selectedUrgency == IndentUrgency.urgent,
                            selectedColor: const Color(0xFFEF4444).withValues(alpha: 0.2),
                            onSelected: (s) {
                              if (s) setDialogState(() => selectedUrgency = IndentUrgency.urgent);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
                FilledButton(
                  onPressed: () {
                    if (itemCtrl.text.isNotEmpty && qtyCtrl.text.isNotEmpty) {
                      setState(() {
                        _indents.insert(
                          0,
                          MaterialRequisitionIndent(
                            id: 'IND-${8824 + _indents.length}',
                            projectTitle: projectCtrl.text,
                            clientName: clientCtrl.text,
                            siteSupervisor: supCtrl.text,
                            itemName: itemCtrl.text,
                            quantity: double.tryParse(qtyCtrl.text) ?? 1,
                            unit: unitCtrl.text,
                            requiredDate: DateTime.now().add(const Duration(days: 3)),
                            urgency: selectedUrgency,
                            status: IndentStatus.pendingRfq,
                            bids: [],
                          ),
                        );
                      });
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Material Indent raised successfully!')),
                      );
                    }
                  },
                  child: const Text('Create Indent'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  String _formatDate(DateTime dt) {
    return '${dt.day}/${dt.month}/${dt.year}';
  }
}
