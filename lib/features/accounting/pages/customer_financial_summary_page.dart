import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/responsive/breakpoints.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../models/accounting_mock_data.dart';
import '../models/accounting_models.dart';

class CustomerFinancialSummaryPage extends StatefulWidget {
  const CustomerFinancialSummaryPage({super.key});

  @override
  State<CustomerFinancialSummaryPage> createState() => _CustomerFinancialSummaryPageState();
}

class _CustomerFinancialSummaryPageState extends State<CustomerFinancialSummaryPage> {
  late List<CustomerFinancialSummary> _summaries;
  FinancialHealth? _healthFilter;

  @override
  void initState() {
    super.initState();
    _summaries = List.from(AccountingMockData.customerSummaries);
  }

  List<CustomerFinancialSummary> get _filteredSummaries {
    if (_healthFilter == null) return _summaries;
    return _summaries.where((s) => s.health == _healthFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isMobile = MediaQuery.of(context).size.width < 768;

    final totalInvoiced = _summaries.fold<double>(0, (sum, s) => sum + s.totalInvoiced);
    final totalCollected = _summaries.fold<double>(0, (sum, s) => sum + s.totalCollected);
    final totalDues = _summaries.fold<double>(0, (sum, s) => sum + s.totalOutstandingDues);
    final totalMaterial = _summaries.fold<double>(0, (sum, s) => sum + s.totalMaterial);
    final totalLabour = _summaries.fold<double>(0, (sum, s) => sum + s.totalLabour);
    final totalFees = _summaries.fold<double>(0, (sum, s) => sum + s.totalFees);

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

                // 2. High-Level Financial Health KPIs
                _buildKpiMetricsBar(isDark, isMobile, totalInvoiced, totalCollected, totalDues, totalMaterial, totalLabour, totalFees),

                const SizedBox(height: 24),

                // 3. Filter Bar
                _buildFilterBar(isDark),

                const SizedBox(height: 16),

                // 4. Customer Financial Cards
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _filteredSummaries.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    return _buildCustomerCard(context, _filteredSummaries[index], isDark, isMobile);
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
                const Icon(Icons.summarize_rounded, size: 14, color: Color(0xFF8B5CF6)),
                const SizedBox(width: 6),
                Text(
                  'MODULE 10: ACCOUNTING & CLIENT LEDGERS',
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
          const SizedBox(height: 14),
          Text(
            'Customer Financial Summary & Project Health',
            style: GoogleFonts.plusJakartaSans(
              fontSize: isMobile ? 20 : 24,
              fontWeight: FontWeight.w800,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Real-time financial overview per client: Material payments, labour disbursements, consulting fees, total collections cleared, and outstanding milestone dues.',
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

  Widget _buildKpiMetricsBar(
    bool isDark,
    bool isMobile,
    double invoiced,
    double collected,
    double dues,
    double material,
    double labour,
    double fees,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 900;
        final cardWidth = isWide ? (constraints.maxWidth - 36) / 4 : (constraints.maxWidth - 12) / 2;

        final items = [
          (label: 'Total Invoiced to Date', value: '₹${(invoiced / 100000).toStringAsFixed(2)} L', sub: 'Across active clients', color: const Color(0xFF6366F1), icon: Icons.receipt_long_rounded),
          (label: 'Collections Cleared', value: '₹${(collected / 100000).toStringAsFixed(2)} L', sub: '${((collected / invoiced) * 100).toInt()}% recovery rate', color: const Color(0xFF10B981), icon: Icons.check_circle_rounded),
          (label: 'Outstanding Client Dues', value: '₹${(dues / 100000).toStringAsFixed(2)} L', sub: 'Pending realization', color: const Color(0xFFEF4444), icon: Icons.pending_actions_rounded),
          (label: 'Retained Firm Fees', value: '₹${(fees / 100000).toStringAsFixed(2)} L', sub: 'Consulting & Supervision', color: const Color(0xFF8B5CF6), icon: Icons.account_balance_rounded),
        ];

        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: items.map((item) {
            return SizedBox(
              width: cardWidth,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : Colors.white,
                  borderRadius: AppRadius.md,
                  border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: item.color.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(item.icon, size: 22, color: item.color),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.label,
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
                            item.value,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: isDark ? Colors.white : const Color(0xFF0F172A),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            item.sub,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: item.color,
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

  Widget _buildFilterBar(bool isDark) {
    return Row(
      children: [
        Text(
          'Filter by Health: ',
          style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w700),
        ),
        const SizedBox(width: 8),
        _buildChip('All Accounts (${_summaries.length})', null, isDark),
        const SizedBox(width: 6),
        _buildChip('Healthy', FinancialHealth.healthy, isDark),
        const SizedBox(width: 6),
        _buildChip('Warning', FinancialHealth.warning, isDark),
        const SizedBox(width: 6),
        _buildChip('Critical Dues', FinancialHealth.critical, isDark),
      ],
    );
  }

  Widget _buildChip(String label, FinancialHealth? health, bool isDark) {
    final isSelected = _healthFilter == health;
    return InkWell(
      onTap: () => setState(() => _healthFilter = health),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF8B5CF6)
              : (isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9)),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFF8B5CF6) : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 11.5,
            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
            color: isSelected ? Colors.white : (isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569)),
          ),
        ),
      ),
    );
  }

  Widget _buildCustomerCard(BuildContext context, CustomerFinancialSummary s, bool isDark, bool isMobile) {
    Color healthColor;
    String healthText;
    switch (s.health) {
      case FinancialHealth.healthy:
        healthColor = const Color(0xFF10B981);
        healthText = 'FINANCIALLY HEALTHY';
        break;
      case FinancialHealth.warning:
        healthColor = const Color(0xFFF59E0B);
        healthText = 'PARTIAL DUES PENDING';
        break;
      case FinancialHealth.critical:
        healthColor = const Color(0xFFEF4444);
        healthText = 'CRITICAL OVERDUE';
        break;
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: AppRadius.lg,
        border: Border.all(
          color: s.health == FinancialHealth.critical
              ? const Color(0xFFEF4444).withValues(alpha: 0.5)
              : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
          width: s.health == FinancialHealth.critical ? 1.5 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          s.projectTitle,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: isDark ? Colors.white : const Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFF6366F1).withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            s.contractModel,
                            style: GoogleFonts.plusJakartaSans(fontSize: 10, fontWeight: FontWeight.w700, color: const Color(0xFF6366F1)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Client: ${s.clientName} (${s.clientPhone}) • ${s.totalBillsCount} Total Vouchers',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: healthColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: healthColor.withValues(alpha: 0.4)),
                ),
                child: Text(
                  healthText,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w800,
                    color: healthColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 3-Pillar Financial Matrix: Material, Labour, Fees
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 650;
              final colWidth = isWide ? (constraints.maxWidth - 24) / 3 : double.infinity;

              return Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _buildFinancialPillar(
                    title: 'Material Purchases',
                    icon: Icons.inventory_2_outlined,
                    color: const Color(0xFF3B82F6),
                    paid: s.materialPaid,
                    unpaid: s.materialUnpaid,
                    width: colWidth,
                    isDark: isDark,
                  ),
                  _buildFinancialPillar(
                    title: 'Labour Disbursements',
                    icon: Icons.handyman_outlined,
                    color: const Color(0xFFF59E0B),
                    paid: s.labourPaid,
                    unpaid: s.labourUnpaid,
                    width: colWidth,
                    isDark: isDark,
                  ),
                  _buildFinancialPillar(
                    title: 'Supervision & Design Fees',
                    icon: Icons.architecture_outlined,
                    color: const Color(0xFF8B5CF6),
                    paid: s.feesPaid,
                    unpaid: s.feesUnpaid,
                    width: colWidth,
                    isDark: isDark,
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 16),

          // Bottom Summary Strip & Drilldown Action
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Wrap(
                  spacing: 16,
                  children: [
                    Text(
                      'Total Contract: ₹${(s.totalContractValue / 100000).toStringAsFixed(2)} L',
                      style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700),
                    ),
                    Text(
                      'Cleared: ₹${(s.totalCollected / 100000).toStringAsFixed(2)} L',
                      style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w800, color: const Color(0xFF10B981)),
                    ),
                    if (s.totalOutstandingDues > 0)
                      Text(
                        'Dues: ₹${(s.totalOutstandingDues / 100000).toStringAsFixed(2)} L',
                        style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w800, color: const Color(0xFFEF4444)),
                      ),
                  ],
                ),
                OutlinedButton.icon(
                  onPressed: () => _showDetailedDossier(context, s),
                  icon: const Icon(Icons.remove_red_eye_rounded, size: 14),
                  label: Text('Inspect Dossier', style: GoogleFonts.plusJakartaSans(fontSize: 11.5, fontWeight: FontWeight.w700)),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    side: BorderSide(color: isDark ? const Color(0xFF64748B) : const Color(0xFFCBD5E1)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFinancialPillar({
    required String title,
    required IconData icon,
    required Color color,
    required double paid,
    required double unpaid,
    required double width,
    required bool isDark,
  }) {
    final total = paid + unpaid;

    return SizedBox(
      width: width,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withValues(alpha: 0.25)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 15, color: color),
                const SizedBox(width: 6),
                Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white70 : const Color(0xFF334155),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '₹${(total / 1000).toInt()} K',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 15,
                fontWeight: FontWeight.w900,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Paid: ₹${(paid / 1000).toInt()}K',
                  style: GoogleFonts.plusJakartaSans(fontSize: 10.5, fontWeight: FontWeight.w700, color: const Color(0xFF10B981)),
                ),
                Text(
                  'Unpaid: ₹${(unpaid / 1000).toInt()}K',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    color: unpaid > 0 ? const Color(0xFFEF4444) : (isDark ? Colors.white38 : Colors.black38),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showDetailedDossier(BuildContext context, CustomerFinancialSummary s) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text('${s.clientName} - Financial Dossier', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800)),
          content: SizedBox(
            width: 520,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Project: ${s.projectTitle}'),
                  Text('Contract: ${s.contractModel} (Total: ₹${s.totalContractValue.toInt()})'),
                  const Divider(height: 24),
                  _buildDossierRow('Material Spend (Total)', '₹${s.totalMaterial.toInt()}'),
                  _buildDossierRow('  - Paid Material Invoices', '₹${s.materialPaid.toInt()}', isGood: true),
                  _buildDossierRow('  - Unpaid Material Dues', '₹${s.materialUnpaid.toInt()}', isBad: s.materialUnpaid > 0),
                  const SizedBox(height: 8),
                  _buildDossierRow('Labour Disbursements (Total)', '₹${s.totalLabour.toInt()}'),
                  _buildDossierRow('  - Paid Labour Vouchers', '₹${s.labourPaid.toInt()}', isGood: true),
                  _buildDossierRow('  - Unpaid Labour Dues', '₹${s.labourUnpaid.toInt()}', isBad: s.labourUnpaid > 0),
                  const SizedBox(height: 8),
                  _buildDossierRow('Supervision Fees (Total)', '₹${s.totalFees.toInt()}'),
                  _buildDossierRow('  - Fees Realized & Collected', '₹${s.feesPaid.toInt()}', isGood: true),
                  _buildDossierRow('  - Overdue Fee Balance', '₹${s.feesUnpaid.toInt()}', isBad: s.feesUnpaid > 0),
                  const Divider(height: 24),
                  _buildDossierRow('Total Collected so Far', '₹${s.totalCollected.toInt()}', isBold: true, isGood: true),
                  _buildDossierRow('Total Outstanding Dues', '₹${s.totalOutstandingDues.toInt()}', isBold: true, isBad: s.totalOutstandingDues > 0),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close')),
            FilledButton.icon(
              onPressed: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Exported financial ledger PDF for ${s.clientName}!')),
                );
              },
              icon: const Icon(Icons.download_rounded, size: 14),
              label: const Text('Export Statement'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDossierRow(String label, String value, {bool isBold = false, bool isGood = false, bool isBad = false}) {
    Color? color;
    if (isGood) color = const Color(0xFF10B981);
    if (isBad) color = const Color(0xFFEF4444);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.plusJakartaSans(fontSize: 12.5, fontWeight: isBold ? FontWeight.w800 : FontWeight.w500)),
          Text(value, style: GoogleFonts.plusJakartaSans(fontSize: 12.5, fontWeight: isBold ? FontWeight.w800 : FontWeight.w700, color: color)),
        ],
      ),
    );
  }
}
