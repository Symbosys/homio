import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/responsive/breakpoints.dart';
import '../../../core/theme/app_colors.dart';
import '../models/hrms_models.dart';
import '../models/hrms_mock_data.dart';

class PayrollSlipsPage extends StatefulWidget {
  const PayrollSlipsPage({super.key});

  @override
  State<PayrollSlipsPage> createState() => _PayrollSlipsPageState();
}

class _PayrollSlipsPageState extends State<PayrollSlipsPage> {
  final List<PayrollRecord> _payrolls = List.from(hrmsMockPayrolls);

  String _searchQuery = '';
  String _selectedMonth = 'August 2026';
  PayrollStatus? _filterStatus;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width >= Breakpoints.medium;

    final filteredPayrolls = _payrolls.where((p) {
      final matchesSearch = p.employeeName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          p.employeeCode.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesMonth = p.month == _selectedMonth;
      final matchesStatus = _filterStatus == null || p.status == _filterStatus;

      return matchesSearch && matchesMonth && matchesStatus;
    }).toList();

    // Summary calculations
    final totalBase = filteredPayrolls.fold<double>(0, (sum, p) => sum + p.baseSalary);
    final totalIncentives = filteredPayrolls.fold<double>(0, (sum, p) => sum + p.incentives);
    final totalTravel = filteredPayrolls.fold<double>(0, (sum, p) => sum + p.travelReimbursement);
    final totalDeductions = filteredPayrolls.fold<double>(0, (sum, p) => sum + p.totalDeductions);
    final totalNet = filteredPayrolls.fold<double>(0, (sum, p) => sum + p.netSalary);

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isDesktop ? 24 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(isDark, isDesktop),
            const SizedBox(height: 20),
            _buildPayrollFormulaBanner(isDark),
            const SizedBox(height: 20),
            _buildKpiMetrics(isDark, totalBase, totalIncentives, totalTravel, totalDeductions, totalNet, width),
            const SizedBox(height: 24),
            _buildPayrollTableCard(isDark, filteredPayrolls),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDark, bool isDesktop) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.gold.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.gold.withValues(alpha: 0.3)),
                  ),
                  child: const Icon(Icons.receipt_long_rounded, color: AppColors.gold, size: 22),
                ),
                const SizedBox(width: 14),
                Text(
                  'Automated Monthly Payroll & Slips',
                  style: TextStyle(
                    fontSize: isDesktop ? 24 : 20,
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppColors.pureWhite : AppColors.deepNavy,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              'Automated salary computation with password-protected PDF payslips and statutory deductions.',
              style: TextStyle(
                fontSize: 13,
                color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted,
              ),
            ),
          ],
        ),
        ElevatedButton.icon(
          onPressed: () => _disburseBatch(context),
          icon: const Icon(Icons.send_rounded, size: 16),
          label: const Text('Disburse Batch Payroll'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.gold,
            foregroundColor: AppColors.deepNavy,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
          ),
        ),
      ],
    );
  }

  Widget _buildPayrollFormulaBanner(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCardBg : AppColors.pureWhite,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.gold.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.calculate_rounded, color: AppColors.gold, size: 18),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'PAYROLL COMPUTATION EQUATION (PRD SECTION 13.5)',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 0.5, color: AppColors.gold),
                ),
                const SizedBox(height: 3),
                RichText(
                  text: TextSpan(
                    style: TextStyle(fontSize: 12.5, color: isDark ? AppColors.pureWhite : AppColors.deepNavy),
                    children: const [
                      TextSpan(text: 'Net Salary = (', style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(text: 'Base Salary', style: TextStyle(color: Color(0xFF3B82F6), fontWeight: FontWeight.bold)),
                      TextSpan(text: ' + '),
                      TextSpan(text: 'Incentives/Commissions', style: TextStyle(color: Color(0xFF10B981), fontWeight: FontWeight.bold)),
                      TextSpan(text: ' + '),
                      TextSpan(text: 'Travel Mileage', style: TextStyle(color: Color(0xFF8B5CF6), fontWeight: FontWeight.bold)),
                      TextSpan(text: ') - ('),
                      TextSpan(text: 'PF & TDS', style: TextStyle(color: Color(0xFFF59E0B), fontWeight: FontWeight.bold)),
                      TextSpan(text: ' + '),
                      TextSpan(text: 'Double Leave Penalties', style: TextStyle(color: Color(0xFFEF4444), fontWeight: FontWeight.bold)),
                      TextSpan(text: ')'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKpiMetrics(
    bool isDark,
    double base,
    double incentives,
    double travel,
    double deductions,
    double net,
    double width,
  ) {
    final cards = [
      _buildMetricCard(
        isDark: isDark,
        title: 'Total Base Payroll',
        value: '₹${NumberFormat('#,##,###').format(base)}',
        sub: 'Gross monthly commitments',
        icon: Icons.account_balance_wallet_rounded,
        color: const Color(0xFF3B82F6),
      ),
      _buildMetricCard(
        isDark: isDark,
        title: 'Additions (Bonus+Travel)',
        value: '₹${NumberFormat('#,##,###').format(incentives + travel)}',
        sub: 'Incentives & GPS claims',
        icon: Icons.trending_up_rounded,
        color: const Color(0xFF10B981),
      ),
      _buildMetricCard(
        isDark: isDark,
        title: 'Total Deductions',
        value: '₹${NumberFormat('#,##,###').format(deductions)}',
        sub: 'PF, TDS & 2X Penalties',
        icon: Icons.content_cut_rounded,
        color: const Color(0xFFEF4444),
      ),
      _buildMetricCard(
        isDark: isDark,
        title: 'Net Disbursed Pool',
        value: '₹${NumberFormat('#,##,###').format(net)}',
        sub: 'Cleared for direct bank NEFT',
        icon: Icons.payments_rounded,
        color: AppColors.gold,
      ),
    ];

    if (width < Breakpoints.compact) {
      return Column(
        children: cards.map((c) => Padding(padding: const EdgeInsets.only(bottom: 12), child: c)).toList(),
      );
    }

    return Row(
      children: cards.map((c) => Expanded(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 6), child: c))).toList(),
    );
  }

  Widget _buildMetricCard({
    required bool isDark,
    required String title,
    required String value,
    required String sub,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCardBg : AppColors.pureWhite,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppColors.pureWhite : AppColors.deepNavy,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  sub,
                  style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPayrollTableCard(bool isDark, List<PayrollRecord> records) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCardBg : AppColors.pureWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Payroll Ledger & Payslip Generation',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.pureWhite : AppColors.deepNavy,
                ),
              ),
              DropdownButton<String>(
                value: _selectedMonth,
                dropdownColor: isDark ? AppColors.darkCardBg : AppColors.pureWhite,
                underline: const SizedBox(),
                items: const [
                  DropdownMenuItem(value: 'August 2026', child: Text('August 2026')),
                  DropdownMenuItem(value: 'July 2026', child: Text('July 2026')),
                  DropdownMenuItem(value: 'June 2026', child: Text('June 2026')),
                ],
                onChanged: (val) => setState(() => _selectedMonth = val ?? 'August 2026'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            onChanged: (val) => setState(() => _searchQuery = val),
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search_rounded, size: 18),
              hintText: 'Search by employee name or code...',
              filled: true,
              fillColor: isDark ? AppColors.darkSurface : AppColors.lightBackground,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            ),
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 8),
          if (records.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Center(
                child: Column(
                  children: [
                    Icon(Icons.receipt_rounded, size: 36, color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted),
                    const SizedBox(height: 10),
                    Text(
                      'No payroll records found for the selected filter.',
                      style: TextStyle(color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted),
                    ),
                  ],
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: records.length,
              separatorBuilder: (_, _) => const Divider(height: 24),
              itemBuilder: (context, index) {
                final rec = records[index];
                return _buildPayrollRow(isDark, rec);
              },
            ),
        ],
      ),
    );
  }

  Widget _buildPayrollRow(bool isDark, PayrollRecord rec) {
    final hasPenalties = rec.doublePenaltyDeduction > 0;

    return Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: AppColors.gold.withValues(alpha: 0.15),
          child: Text(
            rec.employeeName.substring(0, 2).toUpperCase(),
            style: const TextStyle(color: AppColors.gold, fontWeight: FontWeight.bold, fontSize: 13),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                rec.employeeName,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.pureWhite : AppColors.deepNavy,
                ),
              ),
              const SizedBox(height: 3),
              Row(
                children: [
                  Text(
                    rec.employeeCode,
                    style: TextStyle(
                      fontSize: 11,
                      fontFamily: 'monospace',
                      color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Base: ₹${NumberFormat('#,##,###').format(rec.baseSalary)}',
                    style: TextStyle(
                      fontSize: 11.5,
                      color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '+ ₹${NumberFormat('#,##,###').format(rec.incentives + rec.travelReimbursement)}',
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF10B981)),
              ),
              Text(
                'Bonus & Mileage',
                style: TextStyle(fontSize: 10.5, color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '- ₹${NumberFormat('#,##,###').format(rec.totalDeductions)}',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: hasPenalties ? const Color(0xFFEF4444) : const Color(0xFFF59E0B),
                ),
              ),
              Text(
                hasPenalties ? 'PF, TDS & 2X Pen.' : 'PF & TDS',
                style: TextStyle(fontSize: 10.5, color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '₹${NumberFormat('#,##,###').format(rec.netSalary)}',
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.gold),
              ),
              _buildStatusBadge(rec.status),
            ],
          ),
        ),
        const SizedBox(width: 14),
        ElevatedButton.icon(
          onPressed: () => _showPayslipModal(isDark, rec),
          icon: const Icon(Icons.description_rounded, size: 14),
          label: const Text('Payslip'),
          style: ElevatedButton.styleFrom(
            backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightBackground,
            foregroundColor: isDark ? AppColors.pureWhite : AppColors.deepNavy,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusBadge(PayrollStatus status) {
    Color color;
    String label;

    switch (status) {
      case PayrollStatus.draft:
        color = const Color(0xFF64748B);
        label = 'Draft';
        break;
      case PayrollStatus.processed:
        color = const Color(0xFF3B82F6);
        label = 'Processed';
        break;
      case PayrollStatus.approved:
        color = const Color(0xFFF59E0B);
        label = 'Approved';
        break;
      case PayrollStatus.disbursed:
        color = const Color(0xFF10B981);
        label = 'Disbursed';
        break;
      case PayrollStatus.onHold:
        color = const Color(0xFFEF4444);
        label = 'On Hold';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: color),
      ),
    );
  }

  void _showPayslipModal(bool isDark, PayrollRecord rec) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? AppColors.darkCardBg : AppColors.pureWhite,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Payslip: ${rec.month}',
                  style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? AppColors.pureWhite : AppColors.deepNavy),
                ),
                Text(
                  '${rec.employeeName} (${rec.employeeCode})',
                  style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.gold.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                'PDF Password: ${rec.pdfPasswordHint}',
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.gold),
              ),
            ),
          ],
        ),
        content: SizedBox(
          width: 500,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurface : AppColors.lightBackground,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('HOMIO INTERIORS & ARCHITECTURE PVT LTD', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                      Text(DateFormat('dd MMM yyyy').format(DateTime.now()), style: const TextStyle(fontSize: 10)),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                const Text('EARNINGS & ADDITIONS', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Color(0xFF10B981))),
                const Divider(),
                _buildPayslipLine('Basic Salary', rec.baseSalary, isPositive: true, isDark: isDark),
                _buildPayslipLine('Performance Commission / Bonus', rec.incentives, isPositive: true, isDark: isDark),
                _buildPayslipLine('GPS Travel Mileage Reimbursement', rec.travelReimbursement, isPositive: true, isDark: isDark),
                const SizedBox(height: 14),
                const Text('DEDUCTIONS & STATUTORY', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Color(0xFFEF4444))),
                const Divider(),
                _buildPayslipLine('Provident Fund (PF Employer & Employee)', rec.pfDeduction, isPositive: false, isDark: isDark),
                _buildPayslipLine('Tax Deducted at Source (TDS)', rec.tdsDeduction, isPositive: false, isDark: isDark),
                if (rec.doublePenaltyDeduction > 0)
                  _buildPayslipLine('Double Leave Penalty (2X Base Deduction)', rec.doublePenaltyDeduction, isPositive: false, isDark: isDark, isHighlight: true),
                const Divider(thickness: 2),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('NET DISBURSABLE SALARY', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800)),
                      Text(
                        '₹${NumberFormat('#,##,###').format(rec.netSalary)}',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppColors.gold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close')),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Downloading encrypted PDF payslip for ${rec.employeeName}... Password: ${rec.pdfPasswordHint}'),
                  backgroundColor: AppColors.gold,
                ),
              );
            },
            icon: const Icon(Icons.download_rounded, size: 14),
            label: const Text('Download PDF'),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.gold, foregroundColor: AppColors.deepNavy),
          ),
        ],
      ),
    );
  }

  Widget _buildPayslipLine(String title, double amount, {required bool isPositive, required bool isDark, bool isHighlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: isHighlight ? FontWeight.bold : FontWeight.normal,
              color: isHighlight ? const Color(0xFFEF4444) : (isDark ? AppColors.pureWhite : AppColors.deepNavy),
            ),
          ),
          Text(
            '${isPositive ? "+" : "-"} ₹${NumberFormat('#,##,###').format(amount)}',
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
              color: isHighlight
                  ? const Color(0xFFEF4444)
                  : (isPositive ? const Color(0xFF10B981) : (isDark ? AppColors.darkSubtext : AppColors.lightTextMuted)),
            ),
          ),
        ],
      ),
    );
  }

  void _disburseBatch(BuildContext context) {
    setState(() {
      for (int i = 0; i < _payrolls.length; i++) {
        if (_payrolls[i].status == PayrollStatus.processed || _payrolls[i].status == PayrollStatus.draft || _payrolls[i].status == PayrollStatus.approved) {
          _payrolls[i] = _payrolls[i].copyWith(paymentStatus: PayrollStatus.disbursed);
        }
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('All pending payroll records have been marked as Disbursed via direct NEFT.'),
        backgroundColor: Color(0xFF10B981),
      ),
    );
  }
}
