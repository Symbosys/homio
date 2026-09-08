// Homio CRM — Screen 1: Accounting & Finance Overview Dashboard

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../models/accounting_models.dart';
import '../models/accounting_mock_data.dart';
import '../widgets/finance_page_header.dart';
import '../widgets/finance_kpi_card.dart';
import '../widgets/money_in_money_out_card.dart';
import '../widgets/finance_command_center.dart';

class AccountingOverviewPage extends StatefulWidget {
  const AccountingOverviewPage({super.key});

  @override
  State<AccountingOverviewPage> createState() => _AccountingOverviewPageState();
}

class _AccountingOverviewPageState extends State<AccountingOverviewPage> {
  String _trendTimeframe = 'Monthly';

  // Computed Financial Metrics from Realistic Datasets
  double get _totalInvoiced =>
      AccountingMockData.invoices.fold(0.0, (sum, inv) => sum + inv.grandTotal);
  double get _totalCollected =>
      AccountingMockData.customerPayments.fold(0.0, (sum, p) => sum + p.currentPayment);
  double get _totalOutstanding =>
      AccountingMockData.invoices.fold(0.0, (sum, inv) => sum + inv.outstandingAmount);
  double get _totalOverdue => AccountingMockData.invoices
      .where((inv) => inv.status == InvoiceStatus.overdue)
      .fold(0.0, (sum, inv) => sum + inv.outstandingAmount);
  double get _totalExpenses =>
      AccountingMockData.projectExpenses.fold(0.0, (sum, exp) => sum + exp.totalAmount);
  double get _totalVendorPayables =>
      AccountingMockData.vendorPayments.fold(0.0, (sum, vp) => sum + vp.outstandingAmount);
  double get _totalLabourPayables =>
      AccountingMockData.labourPayments.fold(0.0, (sum, lp) => sum + lp.outstandingAmount);
  double get _netPosition => _totalCollected - (_totalExpenses + _totalVendorPayables + _totalLabourPayables);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: Column(
        children: [
          // 1. Executive Finance Page Header
          FinancePageHeader(
            title: 'Accounting & Finance Overview',
            subtitle:
                'Executive financial command center across projects, collections, expenses, vendor/labour payables and net cash flow.',
            icon: Icons.account_balance_rounded,
            dateRangeLabel: 'FY 2026–27 (Q2)',
            onSelectDateRange: () {},
            onRefresh: () => setState(() {}),
            onExportPdf: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Generating Financial Executive Summary PDF...')),
              );
            },
            onExportExcel: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Exporting full P&L and Balance Sheet Excel...')),
              );
            },
          ),

          // 2. Scrollable Financial Control Center
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Needs Attention Command Center Strip
                  FinanceCommandCenter(
                    items: [
                      FinanceAttentionItem(
                        title: 'Overdue Invoices',
                        amount: '₹${_totalOverdue.toStringAsFixed(0)}',
                        count: '${AccountingMockData.overdueCollections.length} Overdue',
                        icon: Icons.warning_amber_rounded,
                        color: AppColors.error,
                        onTap: () {},
                      ),
                      FinanceAttentionItem(
                        title: 'Vendor Payables Due',
                        amount: '₹${_totalVendorPayables.toStringAsFixed(0)}',
                        count: '${AccountingMockData.vendorPayments.where((v) => v.outstandingAmount > 0).length} Due POs',
                        icon: Icons.store_mall_directory_rounded,
                        color: AppColors.warning,
                        onTap: () {},
                      ),
                      FinanceAttentionItem(
                        title: 'Labour Verification',
                        amount: '₹${_totalLabourPayables.toStringAsFixed(0)}',
                        count: '${AccountingMockData.labourPayments.where((l) => !l.pmApproved).length} Pending',
                        icon: Icons.engineering_rounded,
                        color: const Color(0xFF8B5CF6),
                        onTap: () {},
                      ),
                      FinanceAttentionItem(
                        title: 'Unreconciled Bank Credits',
                        amount: '₹1,20,000',
                        count: '${AccountingMockData.reconciliations.where((r) => !r.isReconciled).length} Entries',
                        icon: Icons.sync_problem_rounded,
                        color: const Color(0xFF06B6D4),
                        onTap: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // 8 Primary KPI Cards (Grid)
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final cols = constraints.maxWidth > 1100
                          ? 4
                          : (constraints.maxWidth > 650 ? 2 : 1);
                      return GridView.count(
                        crossAxisCount: cols,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisSpacing: 14,
                        mainAxisSpacing: 14,
                        childAspectRatio: 2.3,
                        children: [
                          FinanceKpiCard(
                            title: 'Total Invoiced',
                            value: '₹${_totalInvoiced.toStringAsFixed(0)}',
                            subtitle: '${AccountingMockData.invoices.length} Client Invoices Issued',
                            icon: Icons.receipt_long_outlined,
                            color: AppColors.primary,
                          ),
                          FinanceKpiCard(
                            title: 'Total Collected',
                            value: '₹${_totalCollected.toStringAsFixed(0)}',
                            subtitle: '${((_totalCollected / _totalInvoiced) * 100).toStringAsFixed(1)}% Realization Rate',
                            icon: Icons.check_circle_outline_rounded,
                            color: AppColors.success,
                          ),
                          FinanceKpiCard(
                            title: 'Total Outstanding',
                            value: '₹${_totalOutstanding.toStringAsFixed(0)}',
                            subtitle: 'Receivables within payment terms',
                            icon: Icons.hourglass_top_rounded,
                            color: AppColors.warning,
                          ),
                          FinanceKpiCard(
                            title: 'Overdue Dues',
                            value: '₹${_totalOverdue.toStringAsFixed(0)}',
                            subtitle: 'Past invoice due date',
                            icon: Icons.warning_amber_rounded,
                            color: AppColors.error,
                          ),
                          FinanceKpiCard(
                            title: 'Project Expenses',
                            value: '₹${_totalExpenses.toStringAsFixed(0)}',
                            subtitle: '${AccountingMockData.projectExpenses.length} Material & Site Vouchers',
                            icon: Icons.shopping_bag_outlined,
                            color: const Color(0xFF8B5CF6),
                          ),
                          FinanceKpiCard(
                            title: 'Vendor Payables',
                            value: '₹${_totalVendorPayables.toStringAsFixed(0)}',
                            subtitle: 'Pending PO release to suppliers',
                            icon: Icons.store_mall_directory_outlined,
                            color: const Color(0xFF0284C7),
                          ),
                          FinanceKpiCard(
                            title: 'Labour Payables',
                            value: '₹${_totalLabourPayables.toStringAsFixed(0)}',
                            subtitle: 'Contractor milestones & dues',
                            icon: Icons.engineering_outlined,
                            color: const Color(0xFFD97706),
                          ),
                          FinanceKpiCard(
                            title: 'Net Operational Position',
                            value: '₹${_netPosition.toStringAsFixed(0)}',
                            subtitle: 'Cleared cash minus liabilities',
                            icon: Icons.account_balance_wallet_outlined,
                            color: const Color(0xFF10B981),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 24),

                  // Collection Summary Visual Progress Bar
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                      borderRadius: BorderRadius.circular(12),
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
                            Text(
                              'COLLECTION LIFECYCLE SUMMARY',
                              style: theme.textTheme.labelMedium?.copyWith(
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.6,
                                color: isDark ? AppColors.darkSubtext : AppColors.lightTextSecondary,
                              ),
                            ),
                            Text(
                              'Target Realization: ₹${_totalInvoiced.toStringAsFixed(0)}',
                              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),

                        // Segmented Progress Bar
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: SizedBox(
                            height: 14,
                            child: Row(
                              children: [
                                Expanded(
                                  flex: (_totalCollected * 100 ~/ _totalInvoiced),
                                  child: Container(color: AppColors.success),
                                ),
                                Expanded(
                                  flex: ((_totalOutstanding - _totalOverdue) * 100 ~/ _totalInvoiced),
                                  child: Container(color: AppColors.warning),
                                ),
                                Expanded(
                                  flex: (_totalOverdue * 100 ~/ _totalInvoiced),
                                  child: Container(color: AppColors.error),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),

                        // Legend
                        Wrap(
                          spacing: 24,
                          runSpacing: 10,
                          children: [
                            _buildLegendItem('Cleared Collections', '₹${_totalCollected.toStringAsFixed(0)}', AppColors.success),
                            _buildLegendItem('Current Outstanding', '₹${(_totalOutstanding - _totalOverdue).toStringAsFixed(0)}', AppColors.warning),
                            _buildLegendItem('Overdue Escalations', '₹${_totalOverdue.toStringAsFixed(0)}', AppColors.error),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Money In / Money Out Card
                  MoneyInMoneyOutCard(
                    totalIn: _totalCollected + 350000 + 300000,
                    customerCollections: _totalCollected,
                    consultingFees: 350000,
                    supervisionFees: 300000,
                    otherRevenue: 0,
                    totalOut: _totalExpenses + _totalVendorPayables + _totalLabourPayables + 10091,
                    materialPurchases: 186695,
                    labourPayments: 66600,
                    designCosts: 53100,
                    operationalExpenses: _totalExpenses,
                    commissionsPaid: 18000,
                  ),
                  const SizedBox(height: 24),

                  // Collection Trend & Project Financial Health Row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Collection Trend Chart Box
                      Expanded(
                        flex: 3,
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                            borderRadius: BorderRadius.circular(12),
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
                                  Text(
                                    'COLLECTION TREND (2026)',
                                    style: theme.textTheme.labelMedium?.copyWith(
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 0.6,
                                      color: isDark ? AppColors.darkSubtext : AppColors.lightTextSecondary,
                                    ),
                                  ),
                                  SegmentedButton<String>(
                                    segments: const [
                                      ButtonSegment(value: 'Daily', label: Text('Daily', style: TextStyle(fontSize: 10))),
                                      ButtonSegment(value: 'Weekly', label: Text('Weekly', style: TextStyle(fontSize: 10))),
                                      ButtonSegment(value: 'Monthly', label: Text('Monthly', style: TextStyle(fontSize: 10))),
                                      ButtonSegment(value: 'Quarterly', label: Text('Quarterly', style: TextStyle(fontSize: 10))),
                                    ],
                                    selected: {_trendTimeframe},
                                    onSelectionChanged: (val) => setState(() => _trendTimeframe = val.first),
                                    style: const ButtonStyle(visualDensity: VisualDensity.compact),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),
                              // Bar visual representation
                              SizedBox(
                                height: 180,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    _buildBar(context, 'Apr', 0.45, '₹14L'),
                                    _buildBar(context, 'May', 0.65, '₹22L'),
                                    _buildBar(context, 'Jun', 0.55, '₹18L'),
                                    _buildBar(context, 'Jul', 0.85, '₹29L'),
                                    _buildBar(context, 'Aug', 0.70, '₹24L'),
                                    _buildBar(context, 'Sep', 0.92, '₹31L', isCurrent: true),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 24),

                      // Project Financial Health Quick Snapshot
                      Expanded(
                        flex: 2,
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'PROJECT FINANCIAL HEALTH & MARGINS',
                                style: theme.textTheme.labelMedium?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.6,
                                  color: isDark ? AppColors.darkSubtext : AppColors.lightTextSecondary,
                                ),
                              ),
                              const SizedBox(height: 16),
                              ...AccountingMockData.projectHealthSummaries.map((ph) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 14),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              ph.projectName,
                                              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: ph.health == FinancialHealth.healthy
                                                  ? AppColors.success.withValues(alpha: 0.12)
                                                  : (ph.health == FinancialHealth.warning
                                                      ? AppColors.warning.withValues(alpha: 0.12)
                                                      : AppColors.error.withValues(alpha: 0.12)),
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                            child: Text(
                                              '${ph.marginPercentage.toStringAsFixed(1)}% Margin',
                                              style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w800,
                                                color: ph.health == FinancialHealth.healthy
                                                    ? AppColors.success
                                                    : (ph.health == FinancialHealth.warning ? AppColors.warning : AppColors.error),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Value: ₹${ph.totalProjectValue.toStringAsFixed(0)}',
                                            style: TextStyle(fontSize: 11, color: isDark ? AppColors.darkSubtext : AppColors.lightTextSecondary),
                                          ),
                                          Text(
                                            'Collected: ₹${ph.collectedAmount.toStringAsFixed(0)}',
                                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.success),
                                          ),
                                        ],
                                      ),
                                      const Divider(height: 12),
                                    ],
                                  ),
                                );
                              }),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, String value, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 8),
        Text('$label: ', style: const TextStyle(fontSize: 12, color: Colors.grey)),
        Text(value, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: color)),
      ],
    );
  }

  Widget _buildBar(BuildContext context, String month, double factor, String label, {bool isCurrent = false}) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: isCurrent ? AppColors.primary : Colors.grey)),
        const SizedBox(height: 6),
        Container(
          width: 32,
          height: 130 * factor,
          decoration: BoxDecoration(
            color: isCurrent ? AppColors.primary : (isDark ? AppColors.primary.withValues(alpha: 0.4) : const Color(0xFFCBD5E1)),
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        const SizedBox(height: 8),
        Text(month, style: TextStyle(fontSize: 11, fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w500)),
      ],
    );
  }
}
