import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../data/wallet_repository.dart';
import '../domain/dashboard_enums.dart';
import '../domain/dashboard_models.dart';
import '../models/dashboard_mock_data.dart';
import '../widgets/dashboard_charts.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/state_feedback_widgets.dart';
import '../widgets/transaction_detail_modal.dart';

/// Screen 5: Wallet & Incentives Command Center.
/// Features explicit distinction between Operational Expense Balance vs Employee Incentives & Earnings,
/// filterable transaction audit ledger, incentive category breakdown, and financial progression charts.
class DashboardWalletPage extends StatefulWidget {
  final String userName;

  const DashboardWalletPage({
    super.key,
    this.userName = 'Vikram Malhotra',
  });

  @override
  State<DashboardWalletPage> createState() => _DashboardWalletPageState();
}

class _DashboardWalletPageState extends State<DashboardWalletPage> {
  final WalletRepository _repository = WalletRepository.instance;
  final ScrollController _scrollController = ScrollController();

  DashboardDateFilter _dateFilter = DashboardDateFilter.thisMonth;
  DashboardScopeFilter _scopeFilter = DashboardScopeFilter.myWork;

  bool _isLoading = true;
  WalletSummary? _summary;
  List<WalletTransaction> _transactions = [];
  List<IncentiveBreakdownItem> _incentives = [];

  String _searchQuery = '';
  TransactionCategory? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final savedOffset = _scrollController.hasClients ? _scrollController.offset : null;
    setState(() => _isLoading = true);
    final summary = await _repository.getWalletSummary(dateFilter: _dateFilter);
    final txns = await _repository.getTransactions(
      category: _selectedCategory,
      searchQuery: _searchQuery,
    );
    final incentives = await _repository.getIncentiveBreakdowns();

    if (mounted) {
      setState(() {
        _summary = summary;
        _transactions = txns;
        _incentives = incentives;
        _isLoading = false;
      });
      if (savedOffset != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted && _scrollController.hasClients) {
            final target = savedOffset.clamp(0.0, _scrollController.position.maxScrollExtent);
            _scrollController.jumpTo(target);
          }
        });
      }
    }
  }

  void _openPayoutDialog() {
    final amountCtrl = TextEditingController();
    String bankAccount = 'HDFC Bank •••• 4821 (Verified)';

    showDialog(
      context: context,
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return AlertDialog(
          backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: AppRadius.md),
          titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          contentPadding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.account_balance_rounded, size: 20, color: Color(0xFF10B981)),
              ),
              const SizedBox(width: 12),
              Text(
                'Request Bank Payout',
                style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ],
          ),
          content: SizedBox(
            width: 420,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurfaceSubtle : const Color(0xFFF8FAFC),
                    borderRadius: AppRadius.sm,
                    border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Available Balance',
                        style: GoogleFonts.inter(fontSize: 12, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                      ),
                      Text(
                        '₹${_summary?.currentBalance.toStringAsFixed(2) ?? '0.00'}',
                        style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w800, color: const Color(0xFF10B981)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Text('Destination Account', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(
                  bankAccount,
                  style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF64748B)),
                ),
                const SizedBox(height: 14),
                Text('Withdrawal Amount (₹)', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                TextField(
                  controller: amountCtrl,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  style: GoogleFonts.inter(fontSize: 12),
                  decoration: InputDecoration(
                    hintText: 'e.g. 5000',
                    hintStyle: GoogleFonts.inter(fontSize: 12),
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    border: OutlineInputBorder(borderRadius: AppRadius.sm),
                  ),
                ),
              ],
            ),
          ),
          actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel', style: GoogleFonts.inter(fontSize: 12)),
            ),
            ElevatedButton(
              onPressed: () async {
                final amt = double.tryParse(amountCtrl.text.trim()) ?? 0.0;
                if (amt > 0 && amt <= (_summary?.currentBalance ?? 0)) {
                  await _repository.requestPayout(amount: amt, bankAccount: bankAccount);
                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                  _loadData();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF10B981),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
              ),
              child: Text('Confirm Transfer', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700)),
            ),
          ],
        );
      },
    );
  }

  void _openExpenseClaimDialog() {
    final titleCtrl = TextEditingController();
    final amountCtrl = TextEditingController();
    final projectCtrl = TextEditingController(text: 'DLF Phase 5 Villa');
    TransactionCategory category = TransactionCategory.pettyCash;

    showDialog(
      context: context,
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
              shape: RoundedRectangleBorder(borderRadius: AppRadius.md),
              titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              contentPadding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
              title: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.receipt_long_rounded, size: 20, color: AppColors.primary),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Submit Expense Voucher',
                    style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              content: SizedBox(
                width: 420,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Claim reimbursement for site hardware, sample printing, or petty cash expense.',
                      style: GoogleFonts.inter(fontSize: 12, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                    ),
                    const SizedBox(height: 14),
                    Text('Expense Title', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    TextField(
                      controller: titleCtrl,
                      style: GoogleFonts.inter(fontSize: 12),
                      decoration: InputDecoration(
                        hintText: 'e.g. Architectural blueprints plotting',
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        border: OutlineInputBorder(borderRadius: AppRadius.sm),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Category', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600)),
                              const SizedBox(height: 4),
                              Container(
                                height: 38,
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                decoration: BoxDecoration(
                                  color: isDark ? AppColors.darkSurfaceSubtle : const Color(0xFFF8FAFC),
                                  borderRadius: AppRadius.sm,
                                  border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<TransactionCategory>(
                                    value: category,
                                    isExpanded: true,
                                    dropdownColor: isDark ? AppColors.darkSurfaceElevated : Colors.white,
                                    items: [TransactionCategory.pettyCash, TransactionCategory.siteExpense, TransactionCategory.travel].map((c) {
                                      return DropdownMenuItem(value: c, child: Text(c.label, style: GoogleFonts.inter(fontSize: 11.5)));
                                    }).toList(),
                                    onChanged: (val) {
                                      if (val != null) setDialogState(() => category = val);
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Amount (₹)', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600)),
                              const SizedBox(height: 4),
                              TextField(
                                controller: amountCtrl,
                                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                style: GoogleFonts.inter(fontSize: 12),
                                decoration: InputDecoration(
                                  hintText: 'e.g. 1250',
                                  isDense: true,
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                  border: OutlineInputBorder(borderRadius: AppRadius.sm),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel', style: GoogleFonts.inter(fontSize: 12)),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final amt = double.tryParse(amountCtrl.text.trim()) ?? 0.0;
                    if (amt > 0 && titleCtrl.text.trim().isNotEmpty) {
                      await _repository.submitExpenseClaim(
                        title: titleCtrl.text.trim(),
                        category: category,
                        amount: amt,
                        projectName: projectCtrl.text.trim(),
                        description: 'Field operation voucher',
                      );
                      if (context.mounted) {
                        Navigator.pop(context);
                      }
                      _loadData();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
                  ),
                  child: Text('Submit Claim', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700)),
                ),
              ],
            );
          },
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
          controller: _scrollController,
          key: const PageStorageKey('dashboard_wallet_scroll'),
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 12 : 20,
            vertical: 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Common Header
              DashboardHeader(
                title: 'Wallet & Incentives Ledger',
                subtitle: 'Manage operational expense balance, verified reimbursement & performance incentives',
                icon: Icons.account_balance_wallet_rounded,
                userName: widget.userName,
                activeDateFilter: _dateFilter,
                activeScopeFilter: _scopeFilter,
                onDateFilterChanged: (f) {
                  setState(() => _dateFilter = f);
                  _loadData();
                },
                onScopeFilterChanged: (s) {
                  setState(() => _scopeFilter = s);
                  _loadData();
                },
                onRefresh: _loadData,
                primaryAction: Wrap(
                  spacing: 8,
                  children: [
                    OutlinedButton.icon(
                      onPressed: _openExpenseClaimDialog,
                      icon: const Icon(Icons.receipt_long_rounded, size: 15),
                      label: Text(
                        'Claim Expense',
                        style: GoogleFonts.inter(fontSize: 11.5, fontWeight: FontWeight.w600),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: _openPayoutDialog,
                      icon: const Icon(Icons.currency_rupee_rounded, size: 15),
                      label: Text(
                        'Request Payout',
                        style: GoogleFonts.inter(fontSize: 11.5, fontWeight: FontWeight.w700),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF10B981),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                        shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
                      ),
                    ),
                  ],
                ),
              ),

              // Non-disruptive inline indicator right below header
              DashboardInlineLoadingIndicator(isLoading: _isLoading && _summary != null),

              if (_isLoading && _summary == null) ...[
                const DashboardSkeletonLoader(height: 120),
                const SizedBox(height: 16),
                const DashboardSkeletonLoader(height: 140),
                const SizedBox(height: 16),
                const DashboardSkeletonLoader(height: 280),
              ] else if (_summary != null) ...[
                // 2. Operational Wallet Balance Card & Scope Notice
                _buildWalletBalanceHero(isDark, isMobile),
                const SizedBox(height: 18),

                // 3. Dedicated Employee Incentives Section & Rules
                _buildIncentiveBreakdownSection(isDark, isMobile, isTablet),
                const SizedBox(height: 18),

                // 4. Financial Charts Row (Progression & Stream Breakdown)
                _buildFinancialChartsRow(isDark, isMobile, isTablet),
                const SizedBox(height: 20),

                // 5. Filterable Operational Transaction Ledger with Localized Loading
                LocalizedLoadingOverlay(
                  isLoading: _isLoading && _summary != null,
                  message: 'Filtering ledger...',
                  child: _buildTransactionLedgerSection(isDark, isMobile),
                ),
                const SizedBox(height: 24),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // SECTION: WALLET BALANCE HERO CARD
  // ===========================================================================
  Widget _buildWalletBalanceHero(bool isDark, bool isMobile) {
    final s = _summary!;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: AppRadius.md,
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildBalanceAmount(s, isDark),
                const SizedBox(height: 14),
                Divider(height: 1, color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                const SizedBox(height: 14),
                _buildBalanceBreakdown(s, isDark),
              ],
            )
          : Row(
              children: [
                Expanded(flex: 5, child: _buildBalanceAmount(s, isDark)),
                Container(width: 1, height: 70, color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                const SizedBox(width: 20),
                Expanded(flex: 5, child: _buildBalanceBreakdown(s, isDark)),
              ],
            ),
    );
  }

  Widget _buildBalanceAmount(WalletSummary s, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFF10B981).withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.account_balance_wallet_rounded, size: 16, color: Color(0xFF10B981)),
            ),
            const SizedBox(width: 8),
            Text(
              'Operational Expense Wallet Balance',
              style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              '₹${s.currentBalance.toStringAsFixed(2)}',
              style: GoogleFonts.inter(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF10B981),
              ),
            ),
            const SizedBox(width: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFF10B981).withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                '↑ ₹2,350 this month',
                style: GoogleFonts.inter(fontSize: 10.5, fontWeight: FontWeight.w700, color: const Color(0xFF10B981)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'Linked Account: ${s.linkedAccount} (Verified)',
          style: GoogleFonts.inter(fontSize: 11, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
        ),
      ],
    );
  }

  Widget _buildBalanceBreakdown(WalletSummary s, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildStatItem('Total Disbursed', '₹${s.totalSpent.toStringAsFixed(0)}', const Color(0xFF6366F1), isDark),
        _buildStatItem('Pending Claims', '₹${s.pendingReimbursement.toStringAsFixed(0)}', const Color(0xFFF59E0B), isDark),
        _buildStatItem('Approved Payouts', '₹${s.approvedReimbursement.toStringAsFixed(0)}', const Color(0xFF10B981), isDark),
      ],
    );
  }

  Widget _buildStatItem(String label, String value, Color color, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.inter(fontSize: 10.5, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
        const SizedBox(height: 2),
        Text(value, style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w800, color: color)),
      ],
    );
  }

  // ===========================================================================
  // SECTION: INCENTIVES & CATEGORY BREAKDOWN
  // ===========================================================================
  Widget _buildIncentiveBreakdownSection(bool isDark, bool isMobile, bool isTablet) {
    final totalIncentives = _incentives.fold<double>(0.0, (acc, i) => acc + i.amount);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: AppRadius.md,
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.military_tech_rounded, size: 18, color: Color(0xFFF59E0B)),
                  const SizedBox(width: 8),
                  Text(
                    'Employee Performance Incentives (Sep 2026)',
                    style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              Text(
                'Total Earned: ₹${totalIncentives.toInt()}',
                style: GoogleFonts.inter(fontSize: 12.5, fontWeight: FontWeight.w800, color: const Color(0xFF10B981)),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // 3 KPI Strip
          Row(
            children: [
              Expanded(child: _buildIncentiveKpiBox('Earned This Month', '₹18,500', const Color(0xFF10B981), isDark)),
              const SizedBox(width: 10),
              Expanded(child: _buildIncentiveKpiBox('Pending Approval', '₹4,200', const Color(0xFFF59E0B), isDark)),
              const SizedBox(width: 10),
              Expanded(child: _buildIncentiveKpiBox('Paid to Bank', '₹14,300', const Color(0xFF6366F1), isDark)),
            ],
          ),
          const SizedBox(height: 14),

          // Incentive Rule Breakdown List
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _incentives.length,
            separatorBuilder: (_, _) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final inc = _incentives[index];
              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurfaceSubtle : const Color(0xFFF8FAFC),
                  borderRadius: AppRadius.sm,
                  border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                ),
                child: Row(
                  children: [
                    Icon(inc.icon, size: 18, color: const Color(0xFFF59E0B)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                inc.title,
                                style: GoogleFonts.inter(fontSize: 12.5, fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF10B981).withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(3),
                                ),
                                child: Text(
                                  inc.status.toUpperCase(),
                                  style: GoogleFonts.inter(fontSize: 8.5, fontWeight: FontWeight.w800, color: const Color(0xFF10B981)),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            inc.rule,
                            style: GoogleFonts.inter(fontSize: 11, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '₹${inc.amount.toInt()}',
                      style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w800, color: isDark ? Colors.white : const Color(0xFF0F172A)),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildIncentiveKpiBox(String title, String val, Color color, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurfaceSubtle : const Color(0xFFF1F5F9),
        borderRadius: AppRadius.sm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: GoogleFonts.inter(fontSize: 10, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
          const SizedBox(height: 2),
          Text(val, style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w800, color: color)),
        ],
      ),
    );
  }

  // ===========================================================================
  // SECTION: FINANCIAL CHARTS ROW
  // ===========================================================================
  Widget _buildFinancialChartsRow(bool isDark, bool isMobile, bool isTablet) {
    const barChart = DashboardIncentiveProgressionBarChart(
      monthlyIncentives: DashboardMockData.sixMonthIncentiveProgression,
    );

    const donutChart = DashboardEarningsDonutChart(
      salary: 45000,
      incentives: 18500,
      travel: 4850,
    );

    if (isMobile || isTablet) {
      return Column(
        children: [
          barChart,
          const SizedBox(height: 14),
          donutChart,
        ],
      );
    }

    return Row(
      children: [
        Expanded(flex: 6, child: barChart),
        const SizedBox(width: 14),
        Expanded(flex: 4, child: donutChart),
      ],
    );
  }

  // ===========================================================================
  // SECTION: TRANSACTION LEDGER
  // ===========================================================================
  Widget _buildTransactionLedgerSection(bool isDark, bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: AppRadius.md,
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Operational Expense & Payout Ledger',
                style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700),
              ),
              Text(
                '${_transactions.length} Transactions',
                style: GoogleFonts.inter(fontSize: 11.5, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Search & Category Filter Pills
          Row(
            children: [
              Expanded(
                flex: 4,
                child: TextField(
                  onChanged: (val) {
                    _searchQuery = val;
                    _loadData();
                  },
                  style: GoogleFonts.inter(fontSize: 12),
                  decoration: InputDecoration(
                    hintText: 'Search voucher, ref #, project...',
                    hintStyle: GoogleFonts.inter(fontSize: 12, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                    prefixIcon: const Icon(Icons.search_rounded, size: 16),
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    border: OutlineInputBorder(borderRadius: AppRadius.sm),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 6,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: FilterChip(
                          label: const Text('All'),
                          selected: _selectedCategory == null,
                          showCheckmark: false,
                          labelStyle: GoogleFonts.inter(fontSize: 11),
                          onSelected: (_) {
                            setState(() => _selectedCategory = null);
                            _loadData();
                          },
                        ),
                      ),
                      ...TransactionCategory.values.map((cat) {
                        final isSel = _selectedCategory == cat;
                        return Padding(
                          padding: const EdgeInsets.only(right: 6),
                          child: FilterChip(
                            label: Text(cat.label),
                            selected: isSel,
                            showCheckmark: false,
                            labelStyle: GoogleFonts.inter(
                              fontSize: 11,
                              color: isSel ? Colors.white : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                            ),
                            selectedColor: cat.color,
                            onSelected: (_) {
                              setState(() => _selectedCategory = isSel ? null : cat);
                              _loadData();
                            },
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          if (isMobile) ...[
            ..._transactions.map((t) {
              return InkWell(
                onTap: () => TransactionDetailModal.show(context, transaction: t),
                borderRadius: AppRadius.sm,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurfaceSubtle : const Color(0xFFF8FAFC),
                    borderRadius: AppRadius.sm,
                    border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                  ),
                  child: Row(
                    children: [
                      Icon(t.category.icon, size: 20, color: t.category.color),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(t.title, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700)),
                            Text('${t.referenceId} • ${t.date}', style: GoogleFonts.inter(fontSize: 10.5, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
                          ],
                        ),
                      ),
                      Text(
                        '${t.isCredit ? '+' : '-'} ₹${t.amount.toStringAsFixed(2)}',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: t.isCredit ? const Color(0xFF10B981) : (isDark ? Colors.white : const Color(0xFF0F172A)),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ] else ...[
            Table(
              columnWidths: const {
                0: FlexColumnWidth(1.6),
                1: FlexColumnWidth(3.2),
                2: FlexColumnWidth(2.2),
                3: FlexColumnWidth(1.8),
                4: FlexColumnWidth(1.6),
                5: FlexColumnWidth(1.4),
              },
              children: [
                TableRow(
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurfaceSubtle : const Color(0xFFF1F5F9),
                    borderRadius: AppRadius.xs,
                  ),
                  children: [
                    _tableHeader('Ref ID', isDark),
                    _tableHeader('Description', isDark),
                    _tableHeader('Category', isDark),
                    _tableHeader('Date', isDark),
                    _tableHeader('Amount (₹)', isDark),
                    _tableHeader('Status', isDark),
                  ],
                ),
                ..._transactions.map((t) {
                  return TableRow(
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder, width: 0.8)),
                    ),
                    children: [
                      InkWell(
                        onTap: () => TransactionDetailModal.show(context, transaction: t),
                        child: _tableCell(t.referenceId, isDark, isBold: true, color: AppColors.primary),
                      ),
                      _tableCell(t.title, isDark),
                      _tableCell(t.category.label, isDark),
                      _tableCell(t.date, isDark),
                      _tableCell(
                        '${t.isCredit ? '+' : '-'} ₹${t.amount.toStringAsFixed(2)}',
                        isDark,
                        isBold: true,
                        color: t.isCredit ? const Color(0xFF10B981) : (isDark ? Colors.white : const Color(0xFF0F172A)),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                            decoration: BoxDecoration(
                              color: t.status == 'settled'
                                  ? const Color(0xFF10B981).withValues(alpha: 0.15)
                                  : const Color(0xFFF59E0B).withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              t.status.toUpperCase(),
                              style: GoogleFonts.inter(
                                fontSize: 9.5,
                                fontWeight: FontWeight.w700,
                                color: t.status == 'settled' ? const Color(0xFF10B981) : const Color(0xFFF59E0B),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _tableHeader(String title, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      child: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
        ),
      ),
    );
  }

  Widget _tableCell(String text, bool isDark, {bool isBold = false, Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 8),
      child: Text(
        text,
        style: GoogleFonts.inter(
          fontSize: 11.5,
          fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
          color: color ?? (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
        ),
      ),
    );
  }
}
