import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../models/dashboard_mock_data.dart';
import '../models/dashboard_models.dart';
import '../widgets/compact_data_table.dart';
import '../widgets/dashboard_charts.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/dashboard_metric_card.dart';

/// My Earnings & Wallet dashboard with balance breakdown,
/// 6-month incentive progression bar chart, stream donut chart, and transaction ledger.
class DashboardWalletPage extends StatefulWidget {
  const DashboardWalletPage({super.key});

  @override
  State<DashboardWalletPage> createState() => _DashboardWalletPageState();
}

class _DashboardWalletPageState extends State<DashboardWalletPage> {
  DashboardDateFilter _dateFilter = DashboardDateFilter.month;
  final List<WalletTransaction> _transactions = List.from(DashboardMockData.walletTransactions);

  void _openWithdrawDialog() {
    final amountController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return AlertDialog(
          backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: AppRadius.md),
          title: Row(
            children: [
              const Icon(Icons.account_balance_wallet, size: 16, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                'Request Bank Payout',
                style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700),
              ),
            ],
          ),
          content: SizedBox(
            width: 380,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Available Withdrawable Balance: ₹42,500',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF10B981),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Linked Account: HDFC Bank •••• 4821 (Verified)',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                ),
                const SizedBox(height: 12),
                Text('Withdrawal Amount (₹)', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  style: GoogleFonts.inter(fontSize: 12),
                  decoration: InputDecoration(
                    hintText: 'Enter amount e.g. 25000',
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    border: OutlineInputBorder(borderRadius: AppRadius.sm),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel', style: GoogleFonts.inter(fontSize: 12)),
            ),
            ElevatedButton(
              onPressed: () {
                final amt = double.tryParse(amountController.text.trim()) ?? 0;
                if (amt > 0) {
                  setState(() {
                    _transactions.insert(
                      0,
                      WalletTransaction(
                        id: 'TXN-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
                        title: 'Bank Withdrawal Request',
                        category: 'Payout',
                        date: 'Just now',
                        amount: amt,
                        isCredit: false,
                        status: 'processing',
                      ),
                    );
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Payout request of ₹${amt.toStringAsFixed(0)} queued for processing', style: GoogleFonts.inter(fontSize: 12)),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
              ),
              child: Text('Confirm Transfer', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 768;
    final isTablet = width >= 768 && width < 1100;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 12 : 20,
            vertical: 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              DashboardHeader(
                title: 'My Earnings & Incentive Wallet',
                subtitle: 'Performance commission breakdown, salary credits, fuel reimbursements & escrow',
                icon: Icons.account_balance_wallet_outlined,
                activeFilter: _dateFilter,
                onFilterChanged: (val) => setState(() => _dateFilter = val),
                primaryAction: ElevatedButton.icon(
                  onPressed: _openWithdrawDialog,
                  icon: const Icon(Icons.arrow_outward, size: 14),
                  label: Text(
                    'Request Payout',
                    style: GoogleFonts.inter(fontSize: 11.5, fontWeight: FontWeight.w600),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                    shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
                  ),
                ),
              ),

              // Wallet Balance Hero Card
              _buildWalletHeroCard(isDark, isMobile),
              const SizedBox(height: 18),

              // 4 Compensation KPI Metrics
              _buildKpis(isMobile, isTablet),
              const SizedBox(height: 18),

              // Charts Row: 6-Month Incentive Progression Bar Chart & Earnings Stream Donut Chart
              _buildChartsRow(isDark, isMobile, isTablet),
              const SizedBox(height: 18),

              // Transactions Ledger Table
              _buildTransactionsTable(isDark),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWalletHeroCard(bool isDark, bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF1E293B), const Color(0xFF0F172A)]
              : [const Color(0xFF1E3A8A), const Color(0xFF1E40AF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: AppRadius.md,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildBalanceAmount(),
                const SizedBox(height: 16),
                _buildEscrowAndLifetime(),
                const SizedBox(height: 16),
                _buildHeroActionButton(),
              ],
            )
          : Row(
              children: [
                Expanded(flex: 5, child: _buildBalanceAmount()),
                Container(width: 1, height: 60, color: Colors.white.withValues(alpha: 0.15)),
                const SizedBox(width: 24),
                Expanded(flex: 5, child: _buildEscrowAndLifetime()),
                const SizedBox(width: 24),
                _buildHeroActionButton(),
              ],
            ),
    );
  }

  Widget _buildBalanceAmount() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.wallet, size: 14, color: Color(0xFF93C5FD)),
            const SizedBox(width: 6),
            Text(
              'WITHDRAWABLE WALLET BALANCE',
              style: GoogleFonts.inter(
                fontSize: 10.5,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF93C5FD),
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          '₹42,500.00',
          style: GoogleFonts.jetBrainsMono(
            fontSize: 26,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          'Ready for instant direct bank transfer',
          style: GoogleFonts.inter(fontSize: 10.5, color: const Color(0xFFBFDBFE)),
        ),
      ],
    );
  }

  Widget _buildEscrowAndLifetime() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Incentives In Escrow',
                style: GoogleFonts.inter(fontSize: 10.5, color: const Color(0xFF93C5FD)),
              ),
              const SizedBox(height: 4),
              Text(
                '₹18,200',
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Releases on milestone signoff',
                style: GoogleFonts.inter(fontSize: 10, color: const Color(0xFF94A3B8)),
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Lifetime Earnings (YTD)',
                style: GoogleFonts.inter(fontSize: 10.5, color: const Color(0xFF93C5FD)),
              ),
              const SizedBox(height: 4),
              Text(
                '₹3,85,000',
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '14.2% higher vs last year',
                style: GoogleFonts.inter(fontSize: 10, color: const Color(0xFF34D399)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeroActionButton() {
    return ElevatedButton.icon(
      onPressed: _openWithdrawDialog,
      icon: const Icon(Icons.arrow_forward, size: 14),
      label: Text(
        'Withdraw Now',
        style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1E3A8A),
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
        shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
      ),
    );
  }

  Widget _buildKpis(bool isMobile, bool isTablet) {
    final kpis = DashboardMockData.walletKpis;
    final crossAxisCount = isMobile ? 1 : (isTablet ? 2 : 4);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisExtent: 118,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: kpis.length,
      itemBuilder: (context, index) {
        return DashboardMetricCard(metric: kpis[index]);
      },
    );
  }

  Widget _buildChartsRow(bool isDark, bool isMobile, bool isTablet) {
    if (isMobile || isTablet) {
      return Column(
        children: [
          DashboardIncentiveProgressionBarChart(monthlyIncentives: DashboardMockData.sixMonthIncentiveProgression),
          const SizedBox(height: 16),
          DashboardEarningsDonutChart(salary: 65000, incentives: 28500, travel: 4860),
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 6,
          child: DashboardIncentiveProgressionBarChart(monthlyIncentives: DashboardMockData.sixMonthIncentiveProgression),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 4,
          child: DashboardEarningsDonutChart(salary: 65000, incentives: 28500, travel: 4860),
        ),
      ],
    );
  }

  Widget _buildTransactionsTable(bool isDark) {
    return CompactTableCard(
      title: 'Earnings & Payout Ledger',
      subtitle: 'Complete settlement breakdown with tax compliance and transaction references',
      trailing: OutlinedButton.icon(
        onPressed: () {},
        icon: const Icon(Icons.file_download_outlined, size: 13),
        label: Text('Tax Slip (Form 16)', style: GoogleFonts.inter(fontSize: 11)),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          visualDensity: VisualDensity.compact,
          side: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final tableWidth = math.max(constraints.maxWidth, 880.0);

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: tableWidth,
              child: Table(
                columnWidths: const {
                  0: FlexColumnWidth(1.4), // TXN ID
                  1: FlexColumnWidth(3.4), // DESCRIPTION
                  2: FlexColumnWidth(1.8), // CATEGORY
                  3: FlexColumnWidth(1.4), // DATE
                  4: FlexColumnWidth(1.4), // AMOUNT
                  5: FlexColumnWidth(1.3), // STATUS
                  6: FlexColumnWidth(0.9), // RECEIPT
                },
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: [
                  TableRow(
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E293B).withValues(alpha: 0.5) : const Color(0xFFF8FAFC),
                      border: Border(
                        bottom: BorderSide(
                          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                          width: 1,
                        ),
                      ),
                    ),
                    children: [
                      _buildHeaderCell('TXN ID', isDark),
                      _buildHeaderCell('DESCRIPTION', isDark),
                      _buildHeaderCell('CATEGORY', isDark),
                      _buildHeaderCell('DATE', isDark),
                      _buildHeaderCell('AMOUNT', isDark),
                      _buildHeaderCell('STATUS', isDark),
                      _buildHeaderCell('RECEIPT', isDark, align: TextAlign.center),
                    ],
                  ),
                  ..._transactions.map((tx) {
                    return TableRow(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: isDark ? AppColors.darkBorder.withValues(alpha: 0.5) : AppColors.lightBorder.withValues(alpha: 0.8),
                            width: 0.8,
                          ),
                        ),
                      ),
                      children: [
                        // TXN ID
                        _buildDataCell(
                          Text(
                            tx.id,
                            style: GoogleFonts.jetBrainsMono(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: isDark ? const Color(0xFF93C5FD) : const Color(0xFF2563EB),
                            ),
                          ),
                        ),
                        // DESCRIPTION
                        _buildDataCell(
                          Text(
                            tx.title,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: isDark ? Colors.white : AppColors.lightTextPrimary,
                            ),
                          ),
                        ),
                        // CATEGORY
                        _buildDataCell(
                          Text(
                            tx.category,
                            style: GoogleFonts.inter(
                              fontSize: 11.5,
                              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                            ),
                          ),
                        ),
                        // DATE
                        _buildDataCell(
                          Text(
                            tx.date,
                            style: GoogleFonts.inter(
                              fontSize: 11.5,
                              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                            ),
                          ),
                        ),
                        // AMOUNT
                        _buildDataCell(
                          Text(
                            '${tx.isCredit ? '+' : '-'}₹${tx.amount.toStringAsFixed(0)}',
                            style: GoogleFonts.jetBrainsMono(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: tx.isCredit ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                            ),
                          ),
                        ),
                        // STATUS
                        _buildDataCell(
                          DashboardBadge(label: tx.status.toUpperCase(), color: tx.statusColor),
                        ),
                        // RECEIPT
                        _buildDataCell(
                          Center(
                            child: IconButton(
                              icon: const Icon(Icons.download_for_offline_outlined, size: 16),
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Downloading payout statement for ${tx.id}', style: GoogleFonts.inter(fontSize: 11.5)),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              },
                              tooltip: 'Download Invoice',
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                        ),
                      ],
                    );
                  }),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeaderCell(String text, bool isDark, {TextAlign align = TextAlign.start}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Text(
        text,
        textAlign: align,
        style: GoogleFonts.inter(
          fontSize: 10.5,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.3,
          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
        ),
      ),
    );
  }

  Widget _buildDataCell(Widget content, {EdgeInsetsGeometry? padding}) {
    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      child: content,
    );
  }
}
