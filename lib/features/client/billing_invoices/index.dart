import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/responsive/breakpoints.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../shared/client_models.dart';
import '../shared/customer_shared_widgets.dart';

/// Screen 2: BILLING & PAYMENTS
/// Connected client-side financial command center:
/// - Total Contract Commercials (Paid, Due, Pending, Retention)
/// - Milestone Tranche Schedule with Instant Checkout Gateway (UPI, NetBanking, Cards)
/// - GST Tax Invoices Viewer & Downloader
/// - Official Payment Receipts Ledger
/// - 100% Dark & Light mode compatible
class ClientBillingInvoicesPage extends StatefulWidget {
  const ClientBillingInvoicesPage({super.key});

  @override
  State<ClientBillingInvoicesPage> createState() => _ClientBillingInvoicesPageState();
}

class _ClientBillingInvoicesPageState extends State<ClientBillingInvoicesPage> {
  int _activeSubTab = 0; // 0 = Tranches, 1 = Tax Invoices, 2 = Receipts Ledger

  @override
  void initState() {
    super.initState();
    ClientDataRepository.stateVersionNotifier.addListener(_onDataChanged);
  }

  @override
  void dispose() {
    ClientDataRepository.stateVersionNotifier.removeListener(_onDataChanged);
    super.dispose();
  }

  void _onDataChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final tranches = ClientDataRepository.paymentTranches;
    final invoices = ClientDataRepository.invoices;
    final receipts = ClientDataRepository.paymentReceipts;

    // Financial calculations
    final totalProjectValue = 1850000.0;
    final totalPaid = tranches.where((t) => t.isPaid).fold<double>(0, (sum, t) => sum + t.totalAmount);
    final pendingBalance = totalProjectValue - totalPaid;
    final nextDueTranche = tranches.firstWhere(
      (t) => t.isDueNow || t.isOverdue,
      orElse: () => tranches.first,
    );

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Financial Overview Hero Card
            _buildFinancialHeroCard(
              totalValue: totalProjectValue,
              paid: totalPaid,
              pending: pendingBalance,
              nextDueTranche: nextDueTranche,
            ),

            const SizedBox(height: 16),

            // Zero Hidden Markup Guarantee Banner
            _buildTransparencyBanner(isDark),

            const SizedBox(height: 16),

            // Segmented Tabs Header
            _buildSubTabBar(
              isDark: isDark,
              tranchesCount: tranches.length,
              invoicesCount: invoices.length,
              receiptsCount: receipts.length,
            ),

            const SizedBox(height: 16),

            // Sub-tab view
            if (_activeSubTab == 0) ...[
              _buildTranchesList(tranches, isDark),
            ] else if (_activeSubTab == 1) ...[
              _buildInvoicesList(invoices, isDark),
            ] else ...[
              _buildReceiptsLedger(receipts, isDark),
            ],

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // FINANCIAL OVERVIEW HERO
  // ===========================================================================

  Widget _buildFinancialHeroCard({
    required double totalValue,
    required double paid,
    required double pending,
    required CustomerPaymentTranche nextDueTranche,
  }) {
    final isDesktop = Breakpoints.isDesktop(context);
    final paidPct = (paid / totalValue).clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: AppRadius.lg,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 16,
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
                child: const Icon(Icons.account_balance_wallet_rounded, color: Color(0xFF10B981), size: 20),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Contract Commercials',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Fixed Turnkey Contract • Certified Milestone Billing',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: Colors.white60,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: AppRadius.full,
                ),
                child: Text(
                  '18% GST Input Credit Included',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.white70,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Metrics Grid
          if (isDesktop) ...[
            Row(
              children: [
                Expanded(child: _buildHeroMetric('TOTAL VALUE', '₹18,50,000', Colors.white, 'Approved Turnkey Scope')),
                _buildHeroDivider(),
                Expanded(child: _buildHeroMetric('PAID TO DATE', '₹${paid.toInt()}', const Color(0xFF10B981), '${(paidPct * 100).toStringAsFixed(1)}% of total')),
                _buildHeroDivider(),
                Expanded(child: _buildHeroMetric('PENDING BALANCE', '₹${pending.toInt()}', const Color(0xFFF59E0B), 'Locked by Milestones')),
                _buildHeroDivider(),
                Expanded(
                  child: _buildHeroMetric(
                    'NEXT DUE',
                    '₹${nextDueTranche.totalAmount.toInt()}',
                    const Color(0xFF38BDF8),
                    nextDueTranche.dueDate,
                    showAction: nextDueTranche.isDueNow,
                    onAction: () => _openCheckout(nextDueTranche),
                  ),
                ),
              ],
            ),
          ] else ...[
            Column(
              children: [
                Row(
                  children: [
                    Expanded(child: _buildHeroMetric('TOTAL VALUE', '₹18,50,000', Colors.white, 'Approved Turnkey Scope')),
                    const SizedBox(width: 12),
                    Expanded(child: _buildHeroMetric('PAID TO DATE', '₹${paid.toInt()}', const Color(0xFF10B981), '${(paidPct * 100).toStringAsFixed(1)}%')),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(child: _buildHeroMetric('PENDING BALANCE', '₹${pending.toInt()}', const Color(0xFFF59E0B), 'Locked by Milestones')),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildHeroMetric(
                        'NEXT DUE',
                        '₹${nextDueTranche.totalAmount.toInt()}',
                        const Color(0xFF38BDF8),
                        nextDueTranche.dueDate,
                        showAction: nextDueTranche.isDueNow,
                        onAction: () => _openCheckout(nextDueTranche),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],

          const SizedBox(height: 18),

          // Visual Progress Bar
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Financial Completion: ${(paidPct * 100).toStringAsFixed(1)}%',
                    style: GoogleFonts.inter(fontSize: 11.5, fontWeight: FontWeight.w600, color: Colors.white70),
                  ),
                  Text(
                    'Pending Work Retention: ₹${pending.toInt()}',
                    style: GoogleFonts.inter(fontSize: 11.5, color: Colors.white54),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: AppRadius.full,
                child: SizedBox(
                  height: 8,
                  child: LinearProgressIndicator(
                    value: paidPct,
                    backgroundColor: Colors.white.withValues(alpha: 0.12),
                    valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF10B981)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeroMetric(
    String label,
    String value,
    Color valueColor,
    String subtitle, {
    bool showAction = false,
    VoidCallback? onAction,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: Colors.white54,
            letterSpacing: 0.6,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 19,
            fontWeight: FontWeight.w900,
            color: valueColor,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          subtitle,
          style: GoogleFonts.inter(
            fontSize: 11,
            color: Colors.white60,
          ),
        ),
        if (showAction && onAction != null) ...[
          const SizedBox(height: 6),
          InkWell(
            onTap: onAction,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFF38BDF8).withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: const Color(0xFF38BDF8).withValues(alpha: 0.4)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Pay Now',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF38BDF8),
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.arrow_forward_rounded, size: 12, color: Color(0xFF38BDF8)),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildHeroDivider() {
    return Container(
      width: 1,
      height: 48,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      color: Colors.white.withValues(alpha: 0.1),
    );
  }

  // ===========================================================================
  // TRANSPARENCY BANNER
  // ===========================================================================

  Widget _buildTransparencyBanner(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E3A8A).withValues(alpha: 0.25) : const Color(0xFFEFF6FF),
        borderRadius: AppRadius.md,
        border: Border.all(
          color: isDark ? const Color(0xFF2563EB).withValues(alpha: 0.4) : const Color(0xFFBFDBFE),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.verified_user_rounded, color: Color(0xFF3B82F6), size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'HOMIO Zero Hidden Markup Guarantee',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: isDark ? const Color(0xFF93C5FD) : const Color(0xFF1E3A8A),
                  ),
                ),
                Text(
                  'All project billing follows strict certified stage sign-offs. You only pay for verified milestones with full GST tax input credits.',
                  style: GoogleFonts.inter(
                    fontSize: 11.5,
                    color: isDark ? const Color(0xFFBFDBFE) : const Color(0xFF3B82F6),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // SUB TABS BAR
  // ===========================================================================

  Widget _buildSubTabBar({
    required bool isDark,
    required int tranchesCount,
    required int invoicesCount,
    required int receiptsCount,
  }) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: AppRadius.md,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : Colors.grey.shade200,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildSubTabItem(0, 'Milestone Tranches ($tranchesCount)', Icons.timeline_rounded, isDark),
          ),
          Expanded(
            child: _buildSubTabItem(1, 'Tax Invoices ($invoicesCount)', Icons.receipt_long_rounded, isDark),
          ),
          Expanded(
            child: _buildSubTabItem(2, 'Receipts Ledger ($receiptsCount)', Icons.verified_rounded, isDark),
          ),
        ],
      ),
    );
  }

  Widget _buildSubTabItem(int index, String label, IconData icon, bool isDark) {
    final isSelected = _activeSubTab == index;
    return InkWell(
      onTap: () => setState(() => _activeSubTab = index),
      borderRadius: AppRadius.md,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: AppRadius.md,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected
                  ? Colors.white
                  : (isDark ? AppColors.darkTextSecondary : Colors.grey.shade600),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 12.5,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected
                    ? Colors.white
                    : (isDark ? AppColors.darkTextSecondary : Colors.grey.shade700),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // TRANCHES LIST
  // ===========================================================================

  Widget _buildTranchesList(List<CustomerPaymentTranche> tranches, bool isDark) {
    return Column(
      children: tranches.map((tranche) => _buildTrancheCard(tranche, isDark)).toList(),
    );
  }

  Widget _buildTrancheCard(CustomerPaymentTranche tranche, bool isDark) {
    final isPaid = tranche.isPaid;
    final isDue = tranche.isDueNow || tranche.isOverdue;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: AppRadius.lg,
        border: Border.all(
          color: isDue
              ? const Color(0xFFF59E0B)
              : (isDark ? AppColors.darkBorder : Colors.grey.shade200),
          width: isDue ? 1.5 : 1.0,
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
            // Top Row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Stage Number Badge
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: isPaid
                        ? const Color(0xFF10B981).withValues(alpha: isDark ? 0.2 : 0.12)
                        : (isDue
                            ? const Color(0xFFF59E0B).withValues(alpha: isDark ? 0.2 : 0.12)
                            : (isDark ? AppColors.darkSurfaceElevated : Colors.grey.shade100)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '#${tranche.stageNumber}',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: isPaid
                          ? const Color(0xFF10B981)
                          : (isDue ? const Color(0xFFF59E0B) : (isDark ? AppColors.darkTextMuted : Colors.grey.shade600)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tranche.stageTitle,
                        style: GoogleFonts.inter(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w700,
                          color: isDark ? AppColors.darkTextPrimary : Colors.grey.shade900,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        tranche.description,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: isDark ? AppColors.darkTextSecondary : Colors.grey.shade600,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildTrancheStatusPill(tranche.status, isDark),
              ],
            ),

            const SizedBox(height: 14),
            Divider(
              height: 1,
              color: isDark ? AppColors.darkBorder : Colors.grey.shade200,
            ),
            const SizedBox(height: 12),

            // Bottom Row: Financials and Action
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          '₹${tranche.totalAmount.toInt()}',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            color: isDark ? Colors.white : Colors.grey.shade900,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '(Base ₹${tranche.amount.toInt()} + 18% GST)',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: isDark ? AppColors.darkTextMuted : Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      isPaid
                          ? 'Paid on ${tranche.paidDate} • Ref: ${tranche.transactionRef}'
                          : 'Due Date: ${tranche.dueDate}',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: isPaid
                            ? const Color(0xFF10B981)
                            : (isDark ? AppColors.darkTextSecondary : Colors.grey.shade600),
                      ),
                    ),
                  ],
                ),

                if (isDue) ...[
                  ElevatedButton.icon(
                    onPressed: () => _openCheckout(tranche),
                    icon: const Icon(Icons.credit_card_rounded, size: 16),
                    label: const Text('Pay Now'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF10B981),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      shape: RoundedAppRadius.md,
                      elevation: 0,
                    ),
                  ),
                ] else if (isPaid) ...[
                  OutlinedButton.icon(
                    onPressed: () {
                      final invoice = ClientDataRepository.invoices.firstWhere(
                        (i) => i.invoiceNumber == tranche.invoiceNumber,
                        orElse: () => ClientDataRepository.invoices.first,
                      );
                      CustomerInvoiceViewerModal.show(context, invoice: invoice);
                    },
                    icon: const Icon(Icons.receipt_outlined, size: 16),
                    label: const Text('View Invoice'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: isDark ? AppColors.darkTextPrimary : Colors.grey.shade800,
                      side: BorderSide(
                        color: isDark ? AppColors.darkBorder : Colors.grey.shade300,
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      shape: RoundedAppRadius.md,
                    ),
                  ),
                ] else ...[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkSurfaceElevated : Colors.grey.shade100,
                      borderRadius: AppRadius.sm,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.lock_outline_rounded,
                          size: 14,
                          color: isDark ? AppColors.darkTextMuted : Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Stage Locked',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: isDark ? AppColors.darkTextMuted : Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrancheStatusPill(PaymentTrancheStatus status, bool isDark) {
    Color bg;
    Color fg;
    String label;

    switch (status) {
      case PaymentTrancheStatus.paid:
        bg = isDark ? const Color(0xFF064E3B).withValues(alpha: 0.4) : const Color(0xFFECFDF5);
        fg = const Color(0xFF34D399);
        label = 'PAID';
        break;
      case PaymentTrancheStatus.dueNow:
        bg = isDark ? const Color(0xFF78350F).withValues(alpha: 0.4) : const Color(0xFFFEF3C7);
        fg = const Color(0xFFFBBF24);
        label = 'DUE NOW';
        break;
      case PaymentTrancheStatus.overdue:
        bg = isDark ? const Color(0xFF7F1D1D).withValues(alpha: 0.4) : const Color(0xFFFEF2F2);
        fg = const Color(0xFFF87171);
        label = 'OVERDUE';
        break;
      case PaymentTrancheStatus.upcoming:
        bg = isDark ? AppColors.darkSurfaceElevated : Colors.grey.shade100;
        fg = isDark ? AppColors.darkTextMuted : Colors.grey.shade600;
        label = 'UPCOMING';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: fg,
        ),
      ),
    );
  }

  void _openCheckout(CustomerPaymentTranche tranche) {
    CustomerPaymentCheckoutModal.show(
      context,
      tranche: tranche,
      onPaid: () {
        setState(() {});
      },
    );
  }

  // ===========================================================================
  // TAX INVOICES LIST
  // ===========================================================================

  Widget _buildInvoicesList(List<CustomerInvoice> invoices, bool isDark) {
    return Column(
      children: invoices.map((inv) => _buildInvoiceCard(inv, isDark)).toList(),
    );
  }

  Widget _buildInvoiceCard(CustomerInvoice invoice, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: AppRadius.lg,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : Colors.grey.shade200,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF6366F1).withValues(alpha: isDark ? 0.2 : 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.picture_as_pdf_rounded, color: Color(0xFF818CF8), size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        invoice.invoiceNumber,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF818CF8),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: invoice.isPaid
                              ? (isDark ? const Color(0xFF064E3B).withValues(alpha: 0.4) : const Color(0xFFECFDF5))
                              : (isDark ? const Color(0xFF78350F).withValues(alpha: 0.4) : const Color(0xFFFEF3C7)),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          invoice.isPaid ? 'PAID' : 'PAYMENT DUE',
                          style: GoogleFonts.inter(
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            color: invoice.isPaid ? const Color(0xFF34D399) : const Color(0xFFFBBF24),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    invoice.title,
                    style: GoogleFonts.inter(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.darkTextPrimary : Colors.grey.shade900,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Issued: ${invoice.issueDate} • Taxable: ₹${invoice.taxableAmount.toInt()} + GST: ₹${invoice.gstAmount.toInt()}',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: isDark ? AppColors.darkTextMuted : Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '₹${invoice.totalAmount.toInt()}',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: isDark ? Colors.white : Colors.grey.shade900,
                  ),
                ),
                const SizedBox(height: 6),
                ElevatedButton.icon(
                  onPressed: () {
                    CustomerInvoiceViewerModal.show(context, invoice: invoice);
                  },
                  icon: const Icon(Icons.visibility_outlined, size: 14),
                  label: const Text('View'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    shape: RoundedAppRadius.md,
                    elevation: 0,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // PAYMENT RECEIPTS LEDGER
  // ===========================================================================

  Widget _buildReceiptsLedger(List<CustomerPaymentReceipt> receipts, bool isDark) {
    return Container(
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
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Icon(Icons.verified_rounded, color: Color(0xFF10B981), size: 20),
                const SizedBox(width: 8),
                Text(
                  'Official Project Payment Receipts',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppColors.darkTextPrimary : Colors.black,
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 1,
            color: isDark ? AppColors.darkBorder : Colors.grey.shade200,
          ),
          ...receipts.map((receipt) => _buildReceiptRow(receipt, isDark)),
        ],
      ),
    );
  }

  Widget _buildReceiptRow(CustomerPaymentReceipt receipt, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: isDark ? AppColors.darkBorder : Colors.grey.shade100,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF10B981).withValues(alpha: isDark ? 0.2 : 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check_rounded, color: Color(0xFF10B981), size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  receipt.trancheTitle,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.darkTextPrimary : Colors.grey.shade900,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${receipt.receiptId} • Paid via ${receipt.paymentMethod} on ${receipt.paidDate}',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: isDark ? AppColors.darkTextMuted : Colors.grey.shade500,
                  ),
                ),
                Text(
                  'Bank UTR: ${receipt.transactionRef}',
                  style: GoogleFonts.inter(
                    fontSize: 10.5,
                    color: isDark ? AppColors.darkTextSecondary : Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '₹${receipt.amount.toInt()}',
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: isDark ? const Color(0xFF34D399) : const Color(0xFF047857),
                ),
              ),
              const SizedBox(height: 4),
              InkWell(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Downloading Receipt ${receipt.receiptId}.pdf...'),
                      backgroundColor: const Color(0xFF047857),
                    ),
                  );
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.download_rounded, size: 13, color: Color(0xFF3B82F6)),
                    const SizedBox(width: 3),
                    Text(
                      'Download PDF',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF3B82F6),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
