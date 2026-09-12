import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../app/router/route_names.dart';
import '../../../../core/responsive/breakpoints.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../shared/client_models.dart';
import '../shared/customer_shared_widgets.dart';

/// My Quotation & Proposals Module for HOMIO Customer Portal.
/// Designed as a high-end, trustworthy proposal and document viewer
/// with room-wise costing, BOQ specifications, payment milestones,
/// and complete 1-click digital acceptance & change request workflows.
class ClientQuotationsPage extends StatefulWidget {
  const ClientQuotationsPage({super.key});

  @override
  State<ClientQuotationsPage> createState() => _ClientQuotationsPageState();
}

class _ClientQuotationsPageState extends State<ClientQuotationsPage> {
  late CustomerQuotation _quotation;
  final Set<String> _expandedBoqRooms = {'Living Room', 'Modular Kitchen'};

  @override
  void initState() {
    super.initState();
    _quotation = ClientDataRepository.primaryQuotation;
  }

  void _handleAcceptance() {
    setState(() {
      _quotation = _quotation.copyWith(
        status: 'Accepted',
        acceptedTimestamp: 'Accepted on 12 Sep 2026, 11:32 AM',
      );
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Quotation #HOM-2026-0184 Accepted! Next: Proceed to Booking.'),
        backgroundColor: Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _handleRequestChanges() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Change Request submitted. Your Design Consultant will call you.'),
        backgroundColor: Color(0xFF3B82F6),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _toggleRoomBoq(String room) {
    setState(() {
      if (_expandedBoqRooms.contains(room)) {
        _expandedBoqRooms.remove(room);
      } else {
        _expandedBoqRooms.add(room);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= Breakpoints.medium;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0B0F19) : const Color(0xFFF8FAFC),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: isDesktop ? AppSpacing.xl : AppSpacing.md,
          vertical: isDesktop ? AppSpacing.xl : AppSpacing.md,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. TOP HEADER & PROPOSAL METADATA
                _buildProposalHeader(context, isDark, isDesktop),
                const SizedBox(height: 16),

                // 2. EXPIRY ALERT BANNER (IF AWAITING ACCEPTANCE)
                if (_quotation.status == 'Awaiting Acceptance') ...[
                  _buildExpiryBanner(isDark),
                  const SizedBox(height: 16),
                ],

                // 3. ACCEPTED CONFIRMATION BANNER (IF ACCEPTED)
                if (_quotation.status == 'Accepted') ...[
                  _buildAcceptedBanner(isDark),
                  const SizedBox(height: 16),
                ],

                // 4. EXECUTIVE SUMMARY & SCOPE
                _buildExecutiveSummaryCard(isDark),
                const SizedBox(height: 16),

                // 5. ROOM-WISE COST BREAKDOWN
                _buildRoomWiseCostingCard(isDark, isDesktop),
                const SizedBox(height: 16),

                // 6. DETAILED BILL OF QUANTITIES (BOQ) ACCORDIONS
                _buildBoqSection(isDark),
                const SizedBox(height: 16),

                // 7. COMMERCIALS & TOTAL COST SUMMARY
                _buildCommercialsSummaryCard(isDark),
                const SizedBox(height: 16),

                // 8. MILESTONE PAYMENT SCHEDULE
                _buildPaymentScheduleCard(isDark),
                const SizedBox(height: 16),

                // 9. 10-YEAR WARRANTY & TERMS
                _buildWarrantyAndTermsCard(isDark),
                const SizedBox(height: 24),

                // 10. PRIMARY ACTION AREA (ON DESKTOP)
                if (isDesktop) _buildDesktopActionBar(context, isDark),

                // Safe space for mobile sticky bar + bottom nav
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: isDesktop ? null : _buildMobileStickyActionBar(context, isDark),
    );
  }

  // ============================================================================
  // 1. TOP PROPOSAL HEADER
  // ============================================================================
  Widget _buildProposalHeader(BuildContext context, bool isDark, bool isDesktop) {
    return Container(
      padding: EdgeInsets.all(isDesktop ? AppSpacing.lg : AppSpacing.md),
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
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.receipt_long_rounded, color: Color(0xFF10B981), size: 20),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'HOMIO COMMERCIAL PROPOSAL',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF10B981),
                          letterSpacing: 0.5,
                        ),
                      ),
                      Text(
                        'Quotation #${_quotation.id}',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: isDesktop ? 18 : 16,
                          fontWeight: FontWeight.w800,
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              CustomerStatusBadge(status: _quotation.status),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(height: 1, thickness: 1),
          const SizedBox(height: 12),

          // Proposal Metadata Grid
          Wrap(
            spacing: 24,
            runSpacing: 10,
            children: [
              _buildHeaderMeta('Issue Date', _quotation.date, isDark),
              _buildHeaderMeta('Valid Until', '${_quotation.validUntil} (5 days left)', isDark, isHighlight: true),
              _buildHeaderMeta('Prepared For', _quotation.clientName, isDark),
              _buildHeaderMeta('Site Address', _quotation.clientAddress, isDark),
              _buildHeaderMeta('Lead Designer', _quotation.designerName, isDark),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderMeta(String label, String value, bool isDark, {bool isHighlight = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 11,
            color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12.5,
            fontWeight: FontWeight.w700,
            color: isHighlight
                ? const Color(0xFF3B82F6)
                : (isDark ? Colors.white : const Color(0xFF0F172A)),
          ),
        ),
      ],
    );
  }

  // ============================================================================
  // 2. EXPIRY BANNER
  // ============================================================================
  Widget _buildExpiryBanner(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF59E0B).withValues(alpha: 0.1),
        borderRadius: AppRadius.md,
        border: Border.all(color: const Color(0xFFF59E0B).withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.timer_rounded, size: 18, color: Color(0xFFF59E0B)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'This quotation is price-locked and valid for 5 days until 30 September 2026.',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: isDark ? const Color(0xFFFCD34D) : const Color(0xFFB45309),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================================
  // 3. ACCEPTED BANNER
  // ============================================================================
  Widget _buildAcceptedBanner(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF10B981).withValues(alpha: 0.12),
        borderRadius: AppRadius.md,
        border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Color(0xFF10B981),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check_rounded, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Quotation Accepted & Locked',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF059669),
                  ),
                ),
                Text(
                  _quotation.acceptedTimestamp ?? 'Accepted on 12 Sep 2026',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    color: isDark ? const Color(0xFFA7F3D0) : const Color(0xFF065F46),
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF10B981),
              foregroundColor: Colors.white,
              shape: RoundedAppRadius.md,
              elevation: 0,
            ),
            onPressed: () => context.goNamed(RouteNames.clientProjects),
            child: Text(
              'Proceed to Booking',
              style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700, fontSize: 12.5),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================================
  // 4. EXECUTIVE SUMMARY
  // ============================================================================
  Widget _buildExecutiveSummaryCard(bool isDark) {
    return CustomerDetailSectionCard(
      title: 'Executive Summary & Project Scope',
      icon: Icons.article_rounded,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _quotation.executiveSummary,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              height: 1.5,
              color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
              borderRadius: AppRadius.md,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Turnkey Scope Summary:',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF4F46E5),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _quotation.projectScope,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    height: 1.45,
                    color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569),
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
  // 5. ROOM-WISE COSTING BREAKDOWN
  // ============================================================================
  Widget _buildRoomWiseCostingCard(bool isDark, bool isDesktop) {
    return CustomerDetailSectionCard(
      title: 'Room-Wise Cost Breakdown',
      icon: Icons.pie_chart_rounded,
      trailing: Text(
        'Subtotal: ₹11,80,000',
        style: GoogleFonts.plusJakartaSans(
          fontSize: 13,
          fontWeight: FontWeight.w800,
          color: const Color(0xFF10B981),
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isNarrow = constraints.maxWidth < 600;

          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isNarrow ? 2 : (isDesktop ? 3 : 2),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: isNarrow ? 2.0 : 2.4,
            ),
            itemCount: _quotation.roomCosts.length,
            itemBuilder: (context, i) {
              final r = _quotation.roomCosts[i];
              return Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B).withValues(alpha: 0.6) : const Color(0xFFF8FAFC),
                  borderRadius: AppRadius.md,
                  border: Border.all(
                    color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4F46E5).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Icon(r.icon, size: 16, color: const Color(0xFF4F46E5)),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            r.roomName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w600,
                              color: isDark ? AppColors.darkSubtext : AppColors.lightTextSecondary,
                            ),
                          ),
                          Text(
                            '₹${r.amount.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w800,
                              color: isDark ? Colors.white : const Color(0xFF0F172A),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  // ============================================================================
  // 6. DETAILED BOQ ACCORDIONS (MOBILE-FRIENDLY CARDS)
  // ============================================================================
  Widget _buildBoqSection(bool isDark) {
    // Group boq items by room
    final rooms = ['Living Room', 'Modular Kitchen', 'Master Bedroom'];

    return CustomerDetailSectionCard(
      title: 'Bill of Quantities (BOQ) & Specifications',
      icon: Icons.format_list_bulleted_rounded,
      child: Column(
        children: rooms.map((room) {
          final items = _quotation.boqItems.where((b) => b.room == room).toList();
          final isExpanded = _expandedBoqRooms.contains(room);

          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B).withValues(alpha: 0.4) : const Color(0xFFF8FAFC),
              borderRadius: AppRadius.md,
              border: Border.all(
                color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
              ),
            ),
            child: Column(
              children: [
                // Header Toggle
                InkWell(
                  onTap: () => _toggleRoomBoq(room),
                  borderRadius: AppRadius.md,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                              size: 18,
                              color: const Color(0xFF4F46E5),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              room,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w700,
                                color: isDark ? Colors.white : const Color(0xFF0F172A),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '(${items.length} items)',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11.5,
                                color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          'View Items',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF4F46E5),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Expanded BOQ Items List
                if (isExpanded) ...[
                  const Divider(height: 1, thickness: 1),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: items.map((item) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF111827) : Colors.white,
                            borderRadius: AppRadius.md,
                            border: Border.all(
                              color: isDark ? const Color(0xFF1F2937) : const Color(0xFFE2E8F0),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      item.name,
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    '₹${item.amount.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 13.5,
                                      fontWeight: FontWeight.w800,
                                      color: const Color(0xFF10B981),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                item.description,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 11.5,
                                  color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 12,
                                runSpacing: 4,
                                children: [
                                  _buildBoqPill('Brand: ${item.brand}', isDark),
                                  _buildBoqPill('Material: ${item.material}', isDark),
                                  _buildBoqPill('Finish: ${item.finish}', isDark),
                                  _buildBoqPill('Qty: ${item.quantity} ${item.unit}', isDark),
                                ],
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildBoqPill(String label, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 10.5,
          fontWeight: FontWeight.w600,
          color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155),
        ),
      ),
    );
  }

  // ============================================================================
  // 7. COMMERCIALS & TOTAL SUMMARY
  // ============================================================================
  Widget _buildCommercialsSummaryCard(bool isDark) {
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
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(Icons.calculate_rounded, size: 16, color: Color(0xFF10B981)),
              const SizedBox(width: 8),
              Text(
                'Financial & Tax Breakdown',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          _buildSummaryRow('Subtotal (All Rooms & Execution)', '₹11,80,000', isDark),
          const SizedBox(height: 6),
          _buildSummaryRow('Festive Season Savings Discount', '-₹50,000', isDark, isGreen: true),
          const SizedBox(height: 6),
          _buildSummaryRow('Applicable GST (Taxes & Compliance)', '₹1,50,000', isDark),
          const SizedBox(height: 12),
          const Divider(height: 1, thickness: 1),
          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'GRAND TOTAL (NET PAYABLE)',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.3,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
              Text(
                '₹12,80,000',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF10B981),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, bool isDark, {bool isGreen = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12.5,
            color: isDark ? AppColors.darkSubtext : AppColors.lightTextSecondary,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: isGreen ? const Color(0xFF10B981) : (isDark ? Colors.white : const Color(0xFF0F172A)),
          ),
        ),
      ],
    );
  }

  // ============================================================================
  // 8. PAYMENT MILESTONE SCHEDULE
  // ============================================================================
  Widget _buildPaymentScheduleCard(bool isDark) {
    return CustomerDetailSectionCard(
      title: 'Payment Milestones & Triggers',
      icon: Icons.payments_rounded,
      child: Column(
        children: _quotation.paymentSchedule.map((pm) {
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B).withValues(alpha: 0.5) : const Color(0xFFF8FAFC),
              borderRadius: AppRadius.md,
              border: Border.all(
                color: pm.isPaid
                    ? const Color(0xFF10B981).withValues(alpha: 0.3)
                    : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: pm.isPaid
                        ? const Color(0xFF10B981).withValues(alpha: 0.15)
                        : const Color(0xFF64748B).withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    pm.isPaid ? Icons.check_circle_rounded : Icons.hourglass_top_rounded,
                    size: 16,
                    color: pm.isPaid ? const Color(0xFF10B981) : const Color(0xFF64748B),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            pm.title,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: isDark ? Colors.white : const Color(0xFF0F172A),
                            ),
                          ),
                          Text(
                            '₹${pm.amount.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w800,
                              color: pm.isPaid ? const Color(0xFF10B981) : (isDark ? Colors.white : const Color(0xFF0F172A)),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Trigger: ${pm.triggerCondition}',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11.5,
                          color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted,
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
    );
  }

  // ============================================================================
  // 9. WARRANTY & TERMS
  // ============================================================================
  Widget _buildWarrantyAndTermsCard(bool isDark) {
    return CustomerDetailSectionCard(
      title: 'Warranty & Commercial Terms',
      icon: Icons.verified_user_rounded,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF10B981).withValues(alpha: 0.1),
              borderRadius: AppRadius.md,
            ),
            child: Row(
              children: [
                const Icon(Icons.shield_rounded, size: 20, color: Color(0xFF10B981)),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    _quotation.warrantyInfo,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF059669),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          ..._quotation.terms.map((t) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('• ', style: TextStyle(fontWeight: FontWeight.bold)),
                  Expanded(
                    child: Text(
                      t,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11.5,
                        color: isDark ? AppColors.darkSubtext : AppColors.lightTextSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  // ============================================================================
  // 10. ACTION BARS (DESKTOP & MOBILE STICKY)
  // ============================================================================
  Widget _buildDesktopActionBar(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF111827) : Colors.white,
        borderRadius: AppRadius.lg,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  shape: RoundedAppRadius.md,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Downloading Quotation PDF...')),
                  );
                },
                icon: const Icon(Icons.download_rounded, size: 16),
                label: Text('Download PDF', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600)),
              ),
              const SizedBox(width: 10),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  shape: RoundedAppRadius.md,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Proposal link copied to clipboard.')),
                  );
                },
                icon: const Icon(Icons.share_rounded, size: 16),
                label: Text('Share', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600)),
              ),
            ],
          ),
          Row(
            children: [
              if (_quotation.status == 'Awaiting Acceptance') ...[
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    shape: RoundedAppRadius.md,
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                  ),
                  onPressed: () {
                    RequestChangesModal.show(
                      context,
                      quotation: _quotation,
                      onSubmit: _handleRequestChanges,
                    );
                  },
                  child: Text('Request Changes', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700)),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF10B981),
                    foregroundColor: Colors.white,
                    shape: RoundedAppRadius.md,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
                  ),
                  onPressed: () {
                    QuotationAcceptanceModal.show(
                      context,
                      quotation: _quotation,
                      onAccepted: _handleAcceptance,
                    );
                  },
                  icon: const Icon(Icons.verified_rounded, size: 16),
                  label: Text('Accept Quotation', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700, fontSize: 13.5)),
                ),
              ] else if (_quotation.status == 'Accepted') ...[
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4F46E5),
                    foregroundColor: Colors.white,
                    shape: RoundedAppRadius.md,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
                  ),
                  onPressed: () => context.goNamed(RouteNames.clientProjects),
                  icon: const Icon(Icons.arrow_forward_rounded, size: 16),
                  label: Text('Proceed to Booking', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700)),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMobileStickyActionBar(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Net Amount',
                    style: GoogleFonts.plusJakartaSans(fontSize: 10.5, color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted),
                  ),
                  Text(
                    '₹12,80,000',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF10B981),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            if (_quotation.status == 'Awaiting Acceptance') ...[
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  shape: RoundedAppRadius.md,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
                onPressed: () {
                  RequestChangesModal.show(
                    context,
                    quotation: _quotation,
                    onSubmit: _handleRequestChanges,
                  );
                },
                child: Text('Changes', style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700)),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF10B981),
                  foregroundColor: Colors.white,
                  shape: RoundedAppRadius.md,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
                onPressed: () {
                  QuotationAcceptanceModal.show(
                    context,
                    quotation: _quotation,
                    onAccepted: _handleAcceptance,
                  );
                },
                child: Text('Accept', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700, fontSize: 13)),
              ),
            ] else ...[
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4F46E5),
                  foregroundColor: Colors.white,
                  shape: RoundedAppRadius.md,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                ),
                onPressed: () => context.goNamed(RouteNames.clientProjects),
                child: Text('Booking', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700)),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
