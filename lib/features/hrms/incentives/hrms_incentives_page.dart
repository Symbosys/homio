import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/responsive/breakpoints.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_radius.dart';
import '../data/hrms_repository.dart';
import '../domain/hrms_domain_models.dart';
import '../domain/hrms_enums.dart';
import '../widgets/hrms_header.dart';
import '../widgets/hrms_metric_card.dart';
import '../widgets/hrms_data_table.dart';
import '../widgets/hrms_status_badge.dart';

class HrmsIncentivesPage extends StatefulWidget {
  const HrmsIncentivesPage({super.key});

  @override
  State<HrmsIncentivesPage> createState() => _HrmsIncentivesPageState();
}

class _HrmsIncentivesPageState extends State<HrmsIncentivesPage> with SingleTickerProviderStateMixin {
  final _repo = HrmsRepository();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _repo.addListener(_onRepoChanged);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _repo.removeListener(_onRepoChanged);
    super.dispose();
  }

  void _onRepoChanged() {
    if (mounted) setState(() {});
  }

  void _openAwardIncentiveDialog() {
    final titleCtrl = TextEditingController(text: 'Sales Commission: Luxury Villa Retainer');
    final amountCtrl = TextEditingController(text: '35000');
    final basisCtrl = TextEditingController(text: '1.5% of Client Advance (Deal Value: ₹25L)');
    String selectedEmpId = _repo.employees.first.id;
    IncentiveType selectedType = IncentiveType.salesCommission;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) {
          return Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              constraints: const BoxConstraints(maxWidth: 520),
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF131722) : Colors.white,
                borderRadius: AppRadius.lg,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Award Incentive / Commission', style: GoogleFonts.plusJakartaSans(fontSize: 15, fontWeight: FontWeight.w700)),
                  const SizedBox(height: AppSpacing.sm),
                  DropdownButtonFormField<String>(
                    initialValue: selectedEmpId,
                    decoration: const InputDecoration(labelText: 'Beneficiary Personnel'),
                    items: _repo.employees.map((e) => DropdownMenuItem(value: e.id, child: Text('${e.fullName} (${e.role})'))).toList(),
                    onChanged: (v) => selectedEmpId = v!,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  DropdownButtonFormField<IncentiveType>(
                    initialValue: selectedType,
                    decoration: const InputDecoration(labelText: 'Incentive Category'),
                    items: IncentiveType.values.map((t) => DropdownMenuItem(value: t, child: Text(t.label))).toList(),
                    onChanged: (v) => setModalState(() => selectedType = v!),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: 'Award Title')),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    children: [
                      Expanded(child: TextField(controller: amountCtrl, decoration: const InputDecoration(labelText: 'Amount (INR)'))),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(child: TextField(controller: basisCtrl, decoration: const InputDecoration(labelText: 'Calculation Basis'))),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
                      const SizedBox(width: AppSpacing.sm),
                      ElevatedButton(
                        onPressed: () {
                          final emp = _repo.getEmployeeById(selectedEmpId);
                          _repo.addIncentive(
                            Incentive(
                              id: 'inc_${DateTime.now().millisecondsSinceEpoch}',
                              employeeId: selectedEmpId,
                              employeeName: emp?.fullName ?? 'Personnel',
                              type: selectedType,
                              title: titleCtrl.text.trim(),
                              amount: double.tryParse(amountCtrl.text) ?? 35000.0,
                              calculationBasis: basisCtrl.text.trim(),
                              period: 'Current Month',
                              approvedBy: 'Sales Director',
                              isPaid: false,
                            ),
                          );
                          Navigator.of(ctx).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Incentive queued for payroll disbursal!')),
                          );
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF10B981), foregroundColor: Colors.white),
                        child: const Text('Award Incentive'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _openLogDeductionDialog() {
    final titleCtrl = TextEditingController(text: 'Asset Damage Recovery');
    final amountCtrl = TextEditingController(text: '1200');
    final reasonCtrl = TextEditingController(text: 'Site measuring laser meter screen replacement');
    String selectedEmpId = _repo.employees.first.id;

    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500),
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF131722) : Colors.white,
            borderRadius: AppRadius.lg,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Log Operational / Policy Deduction', style: GoogleFonts.plusJakartaSans(fontSize: 15, fontWeight: FontWeight.w700)),
              const SizedBox(height: AppSpacing.sm),
              DropdownButtonFormField<String>(
                initialValue: selectedEmpId,
                decoration: const InputDecoration(labelText: 'Personnel'),
                items: _repo.employees.map((e) => DropdownMenuItem(value: e.id, child: Text(e.fullName))).toList(),
                onChanged: (v) => selectedEmpId = v!,
              ),
              const SizedBox(height: AppSpacing.sm),
              TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: 'Deduction Title')),
              const SizedBox(height: AppSpacing.sm),
              TextField(controller: amountCtrl, decoration: const InputDecoration(labelText: 'Deduction Amount (INR)')),
              const SizedBox(height: AppSpacing.sm),
              TextField(controller: reasonCtrl, maxLines: 2, decoration: const InputDecoration(labelText: 'Reason & Justification')),
              const SizedBox(height: AppSpacing.md),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
                  const SizedBox(width: AppSpacing.sm),
                  ElevatedButton(
                    onPressed: () {
                      final emp = _repo.getEmployeeById(selectedEmpId);
                      _repo.addDeduction(
                        Deduction(
                          id: 'ded_${DateTime.now().millisecondsSinceEpoch}',
                          employeeId: selectedEmpId,
                          employeeName: emp?.fullName ?? 'Personnel',
                          type: DeductionType.assetDamage,
                          title: titleCtrl.text.trim(),
                          amount: double.tryParse(amountCtrl.text) ?? 1200.0,
                          reason: reasonCtrl.text.trim(),
                          period: 'Current Month',
                        ),
                      );
                      Navigator.of(ctx).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Deduction logged for payroll cycle.')),
                      );
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFEF4444), foregroundColor: Colors.white),
                    child: const Text('Confirm Deduction'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isCompact = MediaQuery.of(context).size.width < 768;

    final incentives = _repo.incentives;
    final deductions = _repo.deductions;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0B0E14) : const Color(0xFFF1F5F9),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isCompact ? AppSpacing.md : AppSpacing.lg),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: Breakpoints.maxContentWidth),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                HrmsHeader(
                  title: 'Incentives, Commissions & Policy Deductions',
                  subtitle: 'Variable pay calculation, deal commissions, project milestones, spot awards & penalty recoveries',
                  icon: Icons.paid_rounded,
                  badgeText: 'VARIABLE PAY SYSTEM',
                  badgeColor: const Color(0xFF10B981),
                  actions: [
                    OutlinedButton.icon(
                      onPressed: _openLogDeductionDialog,
                      style: OutlinedButton.styleFrom(
                        visualDensity: VisualDensity.compact,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      icon: const Icon(Icons.remove_circle_outline, size: 16, color: Color(0xFFEF4444)),
                      label: Text('Log Deduction', style: GoogleFonts.plusJakartaSans(fontSize: 12, color: const Color(0xFFEF4444))),
                    ),
                    ElevatedButton.icon(
                      onPressed: _openAwardIncentiveDialog,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF10B981),
                        foregroundColor: Colors.white,
                        visualDensity: VisualDensity.compact,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      ),
                      icon: const Icon(Icons.card_giftcard_rounded, size: 16),
                      label: Text('Award Incentive', style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),

                // Metrics
                _buildMetrics(context, incentives, deductions, isCompact),
                const SizedBox(height: AppSpacing.md),

                // Tab Switcher
                Container(
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF131722) : Colors.white,
                    borderRadius: AppRadius.lg,
                    border: Border.all(color: isDark ? Colors.white.withValues(alpha: 0.08) : Colors.black.withValues(alpha: 0.06)),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    labelColor: AppColors.primary,
                    unselectedLabelColor: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                    indicatorColor: AppColors.primary,
                    tabs: const [
                      Tab(icon: Icon(Icons.payments, size: 16), text: 'Variable Incentives & Commissions'),
                      Tab(icon: Icon(Icons.money_off, size: 16), text: 'Policy Deductions & Penalties'),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),

                // Tab Content
                SizedBox(
                  height: 520,
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      // Tab 1: Incentives Table
                      _buildIncentivesTable(incentives, isDark),

                      // Tab 2: Deductions Table
                      _buildDeductionsTable(deductions, isDark),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMetrics(BuildContext context, List<Incentive> incs, List<Deduction> deds, bool isCompact) {
    final totalIncentives = incs.fold<double>(0.0, (s, i) => s + i.amount);
    final totalDeductions = deds.fold<double>(0.0, (s, d) => s + d.amount);
    final pendingCount = incs.where((i) => !i.isPaid).length;

    final cards = [
      HrmsMetricCard(
        title: 'Incentives Queued / Paid',
        value: '₹${(totalIncentives / 1000).toStringAsFixed(0)}K Total',
        subtitle: '${incs.length} Awards Granted',
        icon: Icons.payments_rounded,
        accentColor: const Color(0xFF10B981),
      ),
      HrmsMetricCard(
        title: 'Pending Payout',
        value: '$pendingCount Awards',
        subtitle: 'Queued for Next Payroll Run',
        icon: Icons.hourglass_top_rounded,
        accentColor: const Color(0xFFF59E0B),
      ),
      HrmsMetricCard(
        title: 'Policy Deductions Total',
        value: '₹${(totalDeductions / 1000).toStringAsFixed(1)}K',
        subtitle: 'Double Penalty & Penalties',
        icon: Icons.remove_circle_outline_rounded,
        accentColor: const Color(0xFFEF4444),
      ),
      HrmsMetricCard(
        title: 'Net Variable Balance',
        value: '+ ₹${((totalIncentives - totalDeductions) / 1000).toStringAsFixed(0)}K',
        subtitle: 'Positive Net Benefit',
        icon: Icons.account_balance_wallet_rounded,
        accentColor: const Color(0xFF3B82F6),
      ),
    ];

    if (isCompact) {
      return Column(children: cards.map((c) => Padding(padding: const EdgeInsets.only(bottom: 8), child: c)).toList());
    }
    return Row(children: cards.map((c) => Expanded(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 4), child: c))).toList());
  }

  Widget _buildIncentivesTable(List<Incentive> incentives, bool isDark) {
    return HrmsDataTable(
      columns: const [
        HrmsDataColumn(title: 'BENEFICIARY PERSONNEL'),
        HrmsDataColumn(title: 'INCENTIVE TYPE & TITLE'),
        HrmsDataColumn(title: 'CALCULATION BASIS'),
        HrmsDataColumn(title: 'AWARD AMOUNT'),
        HrmsDataColumn(title: 'STATUS / PAID'),
      ],
      currentPage: 1,
      totalPages: 1,
      totalRecords: incentives.length,
      rows: incentives.map((i) {
        return [
          Text(i.employeeName, style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(i.title, style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w600, color: isDark ? Colors.white70 : const Color(0xFF334155))),
              Text(i.type.label, style: GoogleFonts.plusJakartaSans(fontSize: 10, color: i.type.color, fontWeight: FontWeight.w600)),
            ],
          ),
          Text(i.calculationBasis, style: GoogleFonts.plusJakartaSans(fontSize: 11, color: const Color(0xFF94A3B8))),
          Text('₹${i.amount.toInt()}', style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w800, color: const Color(0xFF10B981))),
          HrmsStatusBadge(label: i.isPaid ? 'Paid in Payroll' : 'Queued for Disbursal', color: i.isPaid ? const Color(0xFF10B981) : const Color(0xFFF59E0B)),
        ];
      }).toList(),
    );
  }

  Widget _buildDeductionsTable(List<Deduction> deductions, bool isDark) {
    return HrmsDataTable(
      columns: const [
        HrmsDataColumn(title: 'PERSONNEL'),
        HrmsDataColumn(title: 'DEDUCTION TYPE & TITLE'),
        HrmsDataColumn(title: 'REASON & POLICY BASIS'),
        HrmsDataColumn(title: 'DEDUCTION AMOUNT'),
        HrmsDataColumn(title: 'STATUS'),
      ],
      currentPage: 1,
      totalPages: 1,
      totalRecords: deductions.length,
      rows: deductions.map((d) {
        return [
          Text(d.employeeName, style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(d.title, style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w600, color: isDark ? Colors.white70 : const Color(0xFF334155))),
              Text(d.type.label, style: GoogleFonts.plusJakartaSans(fontSize: 10, color: const Color(0xFFEF4444), fontWeight: FontWeight.w600)),
            ],
          ),
          Text(d.reason, style: GoogleFonts.plusJakartaSans(fontSize: 11, color: const Color(0xFF94A3B8)), maxLines: 2, overflow: TextOverflow.ellipsis),
          Text('- ₹${d.amount.toInt()}', style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w800, color: const Color(0xFFEF4444))),
          HrmsStatusBadge(label: 'Applied in Payroll', color: const Color(0xFFEF4444)),
        ];
      }).toList(),
    );
  }
}
