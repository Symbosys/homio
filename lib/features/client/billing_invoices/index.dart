import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/responsive/breakpoints.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';

// ============================================================================
// DOMAIN MODELS & ENUMS
// ============================================================================

enum TrancheStatus { paid, dueNow, upcoming }

class PaymentTranche {
  final String id;
  final int stageNumber;
  final String stageTitle;
  final String description;
  final String trancheAmount;
  final String gstAmount;
  final String totalAmount;
  final String dueDate;
  String? paidDate;
  TrancheStatus status;
  String? transactionRef;
  final String invoiceNumber;

  PaymentTranche({
    required this.id,
    required this.stageNumber,
    required this.stageTitle,
    required this.description,
    required this.trancheAmount,
    required this.gstAmount,
    required this.totalAmount,
    required this.dueDate,
    this.paidDate,
    required this.status,
    this.transactionRef,
    required this.invoiceNumber,
  });

  bool get isPaid => status == TrancheStatus.paid;
  bool get isDueNow => status == TrancheStatus.dueNow;
  bool get isUpcoming => status == TrancheStatus.upcoming;
}

class CostBreakdownItem {
  final String category;
  final String allocatedAmount;
  final String spentAmount;
  final double percentage;
  final IconData icon;
  final Color color;
  final String vendorNotes;

  const CostBreakdownItem({
    required this.category,
    required this.allocatedAmount,
    required this.spentAmount,
    required this.percentage,
    required this.icon,
    required this.color,
    required this.vendorNotes,
  });
}

class TaxInvoice {
  final String invoiceNumber;
  final String title;
  final String issueDate;
  final String taxableAmount;
  final String gstAmount;
  final String totalAmount;
  final bool isPaid;

  const TaxInvoice({
    required this.invoiceNumber,
    required this.title,
    required this.issueDate,
    required this.taxableAmount,
    required this.gstAmount,
    required this.totalAmount,
    required this.isPaid,
  });
}

// ============================================================================
// MAIN PAGE WIDGET: BILLING & INVOICES
// ============================================================================

class ClientBillingInvoicesPage extends StatefulWidget {
  const ClientBillingInvoicesPage({super.key});

  @override
  State<ClientBillingInvoicesPage> createState() => _ClientBillingInvoicesPageState();
}

class _ClientBillingInvoicesPageState extends State<ClientBillingInvoicesPage> {
  String _selectedTab = 'Milestone Tranches';

  // 1. Milestone Tranche Payment Schedule (conforming to docs/requirmenet.md: PAYMENTS - TURNKEY)
  late final List<PaymentTranche> _tranches = [
    PaymentTranche(
      id: 'tranche_5',
      stageNumber: 5,
      stageTitle: 'Stage 5: Modular Kitchen & Joinery Fabrication',
      description: 'Lower carcase, Häfele tandem boxes & anti-scratch quartz counter',
      trancheAmount: '₹7,50,000',
      gstAmount: '₹1,35,000',
      totalAmount: '₹8,85,000',
      dueDate: 'Due Today (Sep 05)',
      status: TrancheStatus.dueNow,
      invoiceNumber: 'INV-HOMIO-2026-0905',
    ),
    PaymentTranche(
      id: 'tranche_4_var',
      stageNumber: 4,
      stageTitle: 'Stage 4 Variation: Italian Statuario Polish Upgrade',
      description: 'Mirror diamond silicate polish enhancement across 1,450 sq.ft lounge',
      trancheAmount: '₹1,20,000',
      gstAmount: '₹21,600',
      totalAmount: '₹1,41,600',
      dueDate: 'Action Required',
      status: TrancheStatus.dueNow,
      invoiceNumber: 'INV-HOMIO-2026-0901',
    ),
    PaymentTranche(
      id: 'tranche_4',
      stageNumber: 4,
      stageTitle: 'Stage 4: Italian Marble Flooring & Wall Cladding',
      description: 'Statuario bookmatch layout and acoustic underlayment bonding',
      trancheAmount: '₹8,00,000',
      gstAmount: '₹1,44,000',
      totalAmount: '₹9,44,000',
      dueDate: 'Completed Aug 28, 2026',
      paidDate: 'Aug 28, 2026',
      status: TrancheStatus.paid,
      transactionRef: 'TXN-HDFC-882194021',
      invoiceNumber: 'INV-HOMIO-2026-0828',
    ),
    PaymentTranche(
      id: 'tranche_3',
      stageNumber: 3,
      stageTitle: 'Stage 3: Gypsum False Ceiling & Cove Lighting',
      description: 'Saint-Gobain channel framing and concealed magnetic track wiring',
      trancheAmount: '₹6,50,000',
      gstAmount: '₹1,17,000',
      totalAmount: '₹7,67,000',
      dueDate: 'Completed Aug 14, 2026',
      paidDate: 'Aug 14, 2026',
      status: TrancheStatus.paid,
      transactionRef: 'TXN-ICICI-661294812',
      invoiceNumber: 'INV-HOMIO-2026-0814',
    ),
    PaymentTranche(
      id: 'tranche_2',
      stageNumber: 2,
      stageTitle: 'Stage 2: Concealed MEP & HVAC Ducting',
      description: 'Multi-split VRV copper refrigeration and CPVC pressure lines',
      trancheAmount: '₹9,20,000',
      gstAmount: '₹1,65,600',
      totalAmount: '₹10,85,600',
      dueDate: 'Completed Jul 29, 2026',
      paidDate: 'Jul 29, 2026',
      status: TrancheStatus.paid,
      transactionRef: 'TXN-SBI-441920844',
      invoiceNumber: 'INV-HOMIO-2026-0729',
    ),
    PaymentTranche(
      id: 'tranche_1',
      stageNumber: 1,
      stageTitle: 'Stage 1: Civil Demolition & Core Masonry',
      description: 'Internal wall reconfiguration, debris clearance and polymer bonding',
      trancheAmount: '₹10,40,000',
      gstAmount: '₹1,87,200',
      totalAmount: '₹12,27,200',
      dueDate: 'Completed Jul 12, 2026',
      paidDate: 'Jul 12, 2026',
      status: TrancheStatus.paid,
      transactionRef: 'TXN-HDFC-119284712',
      invoiceNumber: 'INV-HOMIO-2026-0712',
    ),
    PaymentTranche(
      id: 'tranche_6',
      stageNumber: 6,
      stageTitle: 'Stage 6: Surface Priming & Luxury Paint Coating',
      description: 'Saint-Gobain gypsum plaster levelling and Asian Paints Royale Aspira',
      trancheAmount: '₹7,70,000',
      gstAmount: '₹1,38,600',
      totalAmount: '₹9,08,600',
      dueDate: 'Upcoming Stage Lock',
      status: TrancheStatus.upcoming,
      invoiceNumber: 'INV-HOMIO-2026-STAGE6',
    ),
    PaymentTranche(
      id: 'tranche_7',
      stageNumber: 7,
      stageTitle: 'Stage 7: Designer Electrical Fixtures & Sanitaryware',
      description: 'Bocci crystal pendants, magnetic track heads and Kohler fixtures',
      trancheAmount: '₹4,20,000',
      gstAmount: '₹75,600',
      totalAmount: '₹4,95,600',
      dueDate: 'Upcoming Stage Lock',
      status: TrancheStatus.upcoming,
      invoiceNumber: 'INV-HOMIO-2026-STAGE7',
    ),
    PaymentTranche(
      id: 'tranche_8',
      stageNumber: 8,
      stageTitle: 'Stage 8: Deep Cleaning, Snag Rectification & Final Handover',
      description: 'Industrial steam cleaning, air purification and official keys handover',
      trancheAmount: '₹2,80,000',
      gstAmount: '₹50,400',
      totalAmount: '₹3,30,400',
      dueDate: 'Upcoming Stage Lock',
      status: TrancheStatus.upcoming,
      invoiceNumber: 'INV-HOMIO-2026-STAGE8',
    ),
  ];

  // 2. Cost Summary Breakdown (conforming to docs/requirmenet.md: ACCOUNTING - MATERIAL, LABOUR, FEES)
  final List<CostBreakdownItem> _costCategories = const [
    CostBreakdownItem(
      category: 'Material Procurement (Saint-Gobain, Häfele, Statuario)',
      allocatedAmount: '₹26,50,000',
      spentAmount: '₹19,80,000',
      percentage: 0.747,
      icon: Icons.inventory_2_outlined,
      color: Color(0xFF6366F1),
      vendorNotes: '100% verified manufacturer invoices with warranty certificates archived.',
    ),
    CostBreakdownItem(
      category: 'Skilled Labour & Fabrication (Carpentry, Masons, Electricians)',
      allocatedAmount: '₹21,80,000',
      spentAmount: '₹16,40,000',
      percentage: 0.752,
      icon: Icons.engineering_outlined,
      color: Color(0xFF10B981),
      vendorNotes: 'Weekly labour muster clearance with biometric attendance logs.',
    ),
    CostBreakdownItem(
      category: 'Architectural Design & Site Supervision Fees',
      allocatedAmount: '₹9,70,000',
      spentAmount: '₹6,60,000',
      percentage: 0.680,
      icon: Icons.architecture_rounded,
      color: Color(0xFF0EA5E9),
      vendorNotes: 'Project Director Sameer Mehta & Senior Designer Pooja Hegde governance.',
    ),
  ];

  // 3. GST Tax Invoices (conforming to docs/requirmenet.md: BILLING & INVOICES)
  final List<TaxInvoice> _invoices = const [
    TaxInvoice(
      invoiceNumber: 'INV-HOMIO-2026-0905',
      title: 'Tax Invoice: Stage 5 Modular Kitchen Joinery Tranche',
      issueDate: 'Sep 05, 2026',
      taxableAmount: '₹7,50,000',
      gstAmount: '₹1,35,000 (18% IGST)',
      totalAmount: '₹8,85,000',
      isPaid: false,
    ),
    TaxInvoice(
      invoiceNumber: 'INV-HOMIO-2026-0901',
      title: 'Tax Invoice: Stage 4 Variation - Statuario Polish Grade-A',
      issueDate: 'Sep 01, 2026',
      taxableAmount: '₹1,20,000',
      gstAmount: '₹21,600 (18% IGST)',
      totalAmount: '₹1,41,600',
      isPaid: false,
    ),
    TaxInvoice(
      invoiceNumber: 'INV-HOMIO-2026-0828',
      title: 'Tax Invoice: Stage 4 Italian Marble Flooring Tranche',
      issueDate: 'Aug 28, 2026',
      taxableAmount: '₹8,00,000',
      gstAmount: '₹1,44,000 (18% IGST)',
      totalAmount: '₹9,44,000',
      isPaid: true,
    ),
    TaxInvoice(
      invoiceNumber: 'INV-HOMIO-2026-0814',
      title: 'Tax Invoice: Stage 3 Gypsum False Ceiling Tranche',
      issueDate: 'Aug 14, 2026',
      taxableAmount: '₹6,50,000',
      gstAmount: '₹1,17,000 (18% IGST)',
      totalAmount: '₹7,67,000',
      isPaid: true,
    ),
    TaxInvoice(
      invoiceNumber: 'INV-HOMIO-2026-0729',
      title: 'Tax Invoice: Stage 2 Concealed MEP & HVAC Ducting Tranche',
      issueDate: 'Jul 29, 2026',
      taxableAmount: '₹9,20,000',
      gstAmount: '₹1,65,600 (18% IGST)',
      totalAmount: '₹10,85,600',
      isPaid: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isMobile = screenWidth < Breakpoints.compact;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 16.0 : 28.0,
          vertical: 24.0,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: Breakpoints.maxContentWidth),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Executive Billing & Invoices Header
                _buildHeader(context, isDark, isMobile),

                const SizedBox(height: 20),

                // 2. Financial Metrics Strip
                _buildMetricStrip(context, isDark, isMobile),

                const SizedBox(height: 20),

                // 3. Navigation Sub-Tabs
                _buildSegmentedTabs(context, isDark, isMobile),

                const SizedBox(height: 20),

                // 4. Tab Content
                if (_selectedTab == 'Milestone Tranches')
                  _buildTranchesView(context, isDark, isMobile)
                else if (_selectedTab == 'Cost Summary & Ledger')
                  _buildCostSummaryView(context, isDark, isMobile)
                else
                  _buildInvoicesView(context, isDark, isMobile),

                const SizedBox(height: 24),

                // 5. Official Banking & GST Escrow Guarantee
                _buildEscrowGuaranteeBanner(context, isDark, isMobile),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ==========================================================================
  // 1. EXECUTIVE HEADER
  // ==========================================================================
  Widget _buildHeader(BuildContext context, bool isDark, bool isMobile) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    return Container(
      padding: EdgeInsets.all(isMobile ? 18.0 : 24.0),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: AppRadius.lg,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withValues(alpha: 0.25) : const Color(0xFF0F172A).withValues(alpha: 0.03),
            blurRadius: 14,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Project Context & GST Registration Pills
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 6,
            children: [
              Container(
                constraints: BoxConstraints(maxWidth: isMobile ? 260 : 380),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF6366F1).withValues(alpha: 0.1),
                  borderRadius: AppRadius.full,
                  border: Border.all(color: const Color(0xFF6366F1).withValues(alpha: 0.25)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.home_work_outlined, size: 13, color: Color(0xFF6366F1)),
                    const SizedBox(width: 5),
                    Flexible(
                      child: Text(
                        'Skyline Villa Penthouse 402, Worli • 4 BHK Luxury',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF6366F1),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                constraints: BoxConstraints(maxWidth: isMobile ? 260 : 380),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: 0.12),
                  borderRadius: AppRadius.full,
                  border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.verified_user_rounded, size: 12, color: Color(0xFF10B981)),
                    const SizedBox(width: 5),
                    Flexible(
                      child: Text(
                        'Turnkey Luxury Contract • GST Registered',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF10B981),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Title & CTAs
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 16,
            runSpacing: 12,
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: isMobile ? (screenWidth - 72) : 580),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Billing & Invoices',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: isMobile ? 22 : 26,
                        fontWeight: FontWeight.w800,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Stage milestone disbursements, transparent itemized ledger & verified GST tax receipts.',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              ElevatedButton.icon(
                onPressed: () {
                  final pending = _tranches.firstWhere((t) => t.isDueNow);
                  _showPaymentModal(context, pending, isDark);
                },
                icon: const Icon(Icons.account_balance_wallet_rounded, size: 15, color: Colors.white),
                label: Text(
                  'Make Milestone Payment',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF10B981),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  elevation: 0,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ==========================================================================
  // 2. FINANCIAL METRICS STRIP
  // ==========================================================================
  Widget _buildMetricStrip(BuildContext context, bool isDark, bool isMobile) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 750;

        final cards = [
          _buildMetricCard(
            context,
            isDark: isDark,
            icon: Icons.account_balance_rounded,
            iconColor: const Color(0xFF6366F1),
            title: 'Total Contract Value',
            value: '₹58,00,000',
            subtitle: '8 Stages + Approved Variations',
          ),
          _buildMetricCard(
            context,
            isDark: isDark,
            icon: Icons.check_circle_rounded,
            iconColor: const Color(0xFF10B981),
            title: 'Total Paid to Date',
            value: '₹42,80,000',
            subtitle: '73.8% Disbursed across 4 stages',
          ),
          _buildMetricCard(
            context,
            isDark: isDark,
            icon: Icons.pending_actions_rounded,
            iconColor: const Color(0xFFEF4444),
            title: 'Current Outstanding',
            value: '₹7,50,000',
            subtitle: 'Stage 5 Modular Kitchen Tranche',
          ),
          _buildMetricCard(
            context,
            isDark: isDark,
            icon: Icons.lock_clock_rounded,
            iconColor: const Color(0xFFF59E0B),
            title: 'Next Tranche Due',
            value: '₹7,70,000',
            subtitle: 'Stage 6 Painting & Priming',
          ),
        ];

        if (isNarrow) {
          return Column(
            children: cards.map((c) => Padding(padding: const EdgeInsets.only(bottom: 10), child: c)).toList(),
          );
        }

        return Row(
          children: [
            Expanded(child: cards[0]),
            const SizedBox(width: 12),
            Expanded(child: cards[1]),
            const SizedBox(width: 12),
            Expanded(child: cards[2]),
            const SizedBox(width: 12),
            Expanded(child: cards[3]),
          ],
        );
      },
    );
  }

  Widget _buildMetricCard(
    BuildContext context, {
    required bool isDark,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(14.0),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: AppRadius.lg,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 15, color: iconColor),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 10.5,
              fontWeight: FontWeight.w500,
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // ==========================================================================
  // 3. SEGMENTED NAVIGATION TABS
  // ==========================================================================
  Widget _buildSegmentedTabs(BuildContext context, bool isDark, bool isMobile) {
    final tabs = [
      ('Milestone Tranches', Icons.payment_rounded, '${_tranches.length} Milestones'),
      ('Cost Summary & Ledger', Icons.table_chart_outlined, 'Material, Labour, Fees'),
      ('GST Tax Invoices & Receipts', Icons.receipt_long_rounded, '${_invoices.length} Invoices'),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: tabs.map((t) {
          final isSelected = _selectedTab == t.$1;
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: InkWell(
              onTap: () {
                setState(() {
                  _selectedTab = t.$1;
                });
              },
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF6366F1) : (isDark ? AppColors.darkSurface : Colors.white),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF6366F1)
                        : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      t.$2,
                      size: 14,
                      color: isSelected
                          ? Colors.white
                          : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                    ),
                    const SizedBox(width: 7),
                    Text(
                      '${t.$1} (${t.$3})',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                        color: isSelected
                            ? Colors.white
                            : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ==========================================================================
  // 4A. MILESTONE TRANCHES VIEW
  // ==========================================================================
  Widget _buildTranchesView(BuildContext context, bool isDark, bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ..._tranches.map((tranche) => Padding(
              padding: const EdgeInsets.only(bottom: 14.0),
              child: _buildTrancheCard(context, tranche, isDark, isMobile),
            )),
      ],
    );
  }

  Widget _buildTrancheCard(
    BuildContext context,
    PaymentTranche tranche,
    bool isDark,
    bool isMobile,
  ) {
    final isDue = tranche.isDueNow;
    final isPaid = tranche.isPaid;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: AppRadius.lg,
        border: Border.all(
          color: isDue
              ? const Color(0xFFEF4444).withValues(alpha: 0.5)
              : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
          width: isDue ? 1.5 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: isDue
                ? const Color(0xFFEF4444).withValues(alpha: 0.08)
                : (isDark ? Colors.black.withValues(alpha: 0.2) : const Color(0xFF0F172A).withValues(alpha: 0.03)),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Top Details Strip
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Tags Row
                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 8,
                  runSpacing: 6,
                  children: [
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 8,
                      runSpacing: 4,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFF6366F1).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'Stage ${tranche.stageNumber}',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF6366F1),
                            ),
                          ),
                        ),
                        Text(
                          tranche.dueDate,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                          ),
                        ),
                      ],
                    ),

                    // Status Badge
                    if (isPaid)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981).withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.3)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.check_circle_rounded, size: 12, color: Color(0xFF10B981)),
                            const SizedBox(width: 4),
                            Text(
                              'Paid & Receipt Issued',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF10B981),
                              ),
                            ),
                          ],
                        ),
                      )
                    else if (isDue)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEF4444).withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: const Color(0xFFEF4444).withValues(alpha: 0.3)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.error_outline_rounded, size: 12, color: Color(0xFFEF4444)),
                            const SizedBox(width: 4),
                            Text(
                              'Action Required - Due Now',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFFEF4444),
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: (isDark ? Colors.white10 : Colors.black12),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.lock_outline_rounded, size: 12, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text(
                              'Upcoming Stage Lock',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 10),

                Text(
                  tranche.stageTitle,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  tranche.description,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                ),

                const SizedBox(height: 12),

                // Amount Breakdown Strip
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                    ),
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
                          const Icon(Icons.account_balance_wallet_outlined, size: 16, color: Color(0xFF10B981)),
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Base Tranche Amount',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 10.5,
                                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                ),
                              ),
                              Text(
                                tranche.trancheAmount,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.receipt_outlined, size: 16, color: Color(0xFF6366F1)),
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '18% GST Component',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 10.5,
                                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                ),
                              ),
                              Text(
                                tranche.gstAmount,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: isDark ? Colors.white70 : const Color(0xFF334155),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'Total: ${tranche.totalAmount}',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF10B981),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // Bottom Action Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 8,
              runSpacing: 8,
              children: [
                Text(
                  'Tax Invoice ID: ${tranche.invoiceNumber}',
                  style: GoogleFonts.robotoMono(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                ),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    if (isPaid) ...[
                      OutlinedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Downloading official payment receipt for ${tranche.stageTitle}...'),
                              backgroundColor: const Color(0xFF10B981),
                            ),
                          );
                        },
                        icon: const Icon(Icons.download_rounded, size: 14, color: Color(0xFF10B981)),
                        label: Text(
                          'Download Receipt',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF10B981),
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: const Color(0xFF10B981).withValues(alpha: 0.3)),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
                        ),
                      ),
                    ] else if (isDue) ...[
                      ElevatedButton.icon(
                        onPressed: () => _showPaymentModal(context, tranche, isDark),
                        icon: const Icon(Icons.payment_rounded, size: 14, color: Colors.white),
                        label: Text(
                          'Pay Now (${tranche.totalAmount})',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF10B981),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
                          elevation: 0,
                        ),
                      ),
                    ] else ...[
                      Text(
                        'Unlocks upon Stage 5 completion',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================================
  // 4B. COST SUMMARY & LEDGER VIEW (Per docs/requirmenet.md: ACCOUNTING)
  // ==========================================================================
  Widget _buildCostSummaryView(BuildContext context, bool isDark, bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildSectionHeader(
          'Project Financial Ledger Breakdown',
          'Itemized allocation across Material Procurement, Skilled Labour, and Architectural Supervision as per Homio Project Agreement',
          isDark,
        ),
        const SizedBox(height: 14),

        ..._costCategories.map((item) {
          return Container(
            margin: const EdgeInsets.only(bottom: 14.0),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : Colors.white,
              borderRadius: AppRadius.lg,
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
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
                        color: item.color.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(item.icon, size: 18, color: item.color),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.category,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w700,
                              color: isDark ? Colors.white : const Color(0xFF0F172A),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            item.vendorNotes,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: item.percentage,
                    backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
                    valueColor: AlwaysStoppedAnimation<Color>(item.color),
                    minHeight: 6,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Disbursed: ${item.spentAmount} of ${item.allocatedAmount}',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white70 : const Color(0xFF334155),
                      ),
                    ),
                    Text(
                      '${(item.percentage * 100).toInt()}% Utilized',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: item.color,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  // ==========================================================================
  // 4C. GST TAX INVOICES & RECEIPTS VIEW
  // ==========================================================================
  Widget _buildInvoicesView(BuildContext context, bool isDark, bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildSectionHeader(
          'Official GST Tax Invoices & Payment Certificates',
          'Downloadable compliance invoices with 18% GST breakdown, HSN/SAC codes, and Homio corporate seal',
          isDark,
        ),
        const SizedBox(height: 14),

        ..._invoices.map((inv) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12.0),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : Colors.white,
              borderRadius: AppRadius.lg,
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              ),
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
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEF4444).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'PDF',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFFEF4444),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          inv.title,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700,
                            color: isDark ? Colors.white : const Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${inv.invoiceNumber} • Issued ${inv.issueDate} • ${inv.gstAmount}',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      inv.totalAmount,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w800,
                        color: inv.isPaid ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                      ),
                    ),
                    const SizedBox(width: 12),
                    IconButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${inv.invoiceNumber} downloaded successfully!'),
                            backgroundColor: const Color(0xFF10B981),
                          ),
                        );
                      },
                      icon: const Icon(Icons.download_rounded, size: 18, color: Color(0xFF6366F1)),
                      tooltip: 'Download Tax Invoice PDF',
                    ),
                  ],
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildSectionHeader(String title, String subtitle, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14.5,
            fontWeight: FontWeight.w800,
            color: isDark ? Colors.white : const Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          subtitle,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 11.5,
            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
          ),
        ),
      ],
    );
  }

  // ==========================================================================
  // 5. OFFICIAL BANKING & ESCROW GUARANTEE BANNER
  // ==========================================================================
  Widget _buildEscrowGuaranteeBanner(BuildContext context, bool isDark, bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
        borderRadius: AppRadius.md,
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.shield_rounded, size: 20, color: Color(0xFF10B981)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Milestone Stage Escrow & Warranty Assurance',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w800,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'All client milestone payments are held in an escrow-protected project ledger and released to trades only after internal quality audit approval and client digital sign-off. Payments automatically generate 18% GST tax invoices with input tax credit eligibility.',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================================
  // PAYMENT MODAL DIALOG
  // ==========================================================================
  void _showPaymentModal(BuildContext context, PaymentTranche tranche, bool isDark) {
    String selectedMode = 'UPI QR & Instant App';

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (dialogCtx, setDialogState) {
            return Dialog(
              backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520),
                child: Padding(
                  padding: const EdgeInsets.all(22.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(0xFF10B981).withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.payment_rounded, color: Color(0xFF10B981), size: 18),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Milestone Payment: Stage ${tranche.stageNumber}',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                                    ),
                                  ),
                                  Text(
                                    tranche.stageTitle,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 11.5,
                                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close, size: 18),
                              onPressed: () => Navigator.of(ctx).pop(),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Amount Breakdown Box
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                            ),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Base Milestone Value:', style: GoogleFonts.plusJakartaSans(fontSize: 12)),
                                  Text(tranche.trancheAmount, style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700)),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('18% GST Component:', style: GoogleFonts.plusJakartaSans(fontSize: 12)),
                                  Text(tranche.gstAmount, style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700)),
                                ],
                              ),
                              const Divider(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Total Payable Amount:',
                                    style: GoogleFonts.plusJakartaSans(fontSize: 13.5, fontWeight: FontWeight.w800),
                                  ),
                                  Text(
                                    tranche.totalAmount,
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

                        const SizedBox(height: 16),

                        Text(
                          'Select Payment Method',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: isDark ? Colors.white : const Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 8),

                        Wrap(
                          spacing: 8,
                          runSpacing: 6,
                          children: [
                            'UPI QR & Instant App',
                            'Net Banking',
                            'Credit / Debit Card',
                            'NEFT / RTGS Bank Transfer',
                          ].map((mode) {
                            final isSel = selectedMode == mode;
                            return ChoiceChip(
                              label: Text(mode),
                              selected: isSel,
                              onSelected: (val) {
                                setDialogState(() => selectedMode = mode);
                              },
                              selectedColor: const Color(0xFF10B981),
                              backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                              labelStyle: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
                                fontWeight: isSel ? FontWeight.w700 : FontWeight.w500,
                                color: isSel ? Colors.white : (isDark ? Colors.white70 : const Color(0xFF334155)),
                              ),
                            );
                          }).toList(),
                        ),

                        const SizedBox(height: 14),

                        // Simulated UPI QR View
                        if (selectedMode == 'UPI QR & Instant App') ...[
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Icon(Icons.qr_code_2_rounded, size: 40, color: Color(0xFF0F172A)),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Instant UPI Payment VPA',
                                        style: GoogleFonts.plusJakartaSans(fontSize: 11.5, fontWeight: FontWeight.w700),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        'homio.penthouse402@icici',
                                        style: GoogleFonts.robotoMono(fontSize: 11, color: const Color(0xFF6366F1), fontWeight: FontWeight.w600),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        'Zero surcharge on GPay, PhonePe, BHIM & Paytm',
                                        style: GoogleFonts.plusJakartaSans(fontSize: 10, color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ] else if (selectedMode == 'NEFT / RTGS Bank Transfer') ...[
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Beneficiary: Homio Projects Private Limited', style: GoogleFonts.plusJakartaSans(fontSize: 11.5, fontWeight: FontWeight.w700)),
                                const SizedBox(height: 2),
                                Text('A/C Number: 001105024419 • Bank: ICICI Bank', style: GoogleFonts.robotoMono(fontSize: 11)),
                                const SizedBox(height: 2),
                                Text('IFSC Code: ICIC0000011 • Branch: Worli Branch', style: GoogleFonts.robotoMono(fontSize: 11)),
                              ],
                            ),
                          ),
                        ],

                        const SizedBox(height: 20),

                        Wrap(
                          alignment: WrapAlignment.end,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            TextButton(
                              onPressed: () => Navigator.of(ctx).pop(),
                              child: Text(
                                'Cancel',
                                style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(ctx).pop();
                                setState(() {
                                  tranche.status = TrancheStatus.paid;
                                  tranche.paidDate = 'Sep 05, 2026';
                                  tranche.transactionRef = 'TXN-UPI-${DateTime.now().millisecondsSinceEpoch}';
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Payment of ${tranche.totalAmount} verified successfully! Official receipt generated.'),
                                    backgroundColor: const Color(0xFF10B981),
                                    duration: const Duration(seconds: 3),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF10B981),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              child: Text(
                                'Authorize & Disburse Payment',
                                style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
