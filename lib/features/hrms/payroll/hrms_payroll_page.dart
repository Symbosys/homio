import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/responsive/breakpoints.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../data/hrms_repository.dart';
import '../domain/hrms_domain_models.dart';
import '../widgets/hrms_header.dart';
import '../widgets/hrms_metric_card.dart';
import '../widgets/hrms_data_table.dart';
import '../widgets/hrms_filter_bar.dart';
import '../widgets/hrms_status_badge.dart';
import '../widgets/hrms_charts.dart';
import '../widgets/payslip_detail_modal.dart';

class HrmsPayrollPage extends StatefulWidget {
  const HrmsPayrollPage({super.key});

  @override
  State<HrmsPayrollPage> createState() => _HrmsPayrollPageState();
}

class _HrmsPayrollPageState extends State<HrmsPayrollPage> {
  final _repo = HrmsRepository();

  String _searchQuery = '';
  String _selectedPeriodId = 'pay_period_2026_08';
  int _currentPage = 1;
  static const int _pageSize = 8;

  @override
  void initState() {
    super.initState();
    _repo.addListener(_onRepoChanged);
  }

  @override
  void dispose() {
    _repo.removeListener(_onRepoChanged);
    super.dispose();
  }

  void _onRepoChanged() {
    if (mounted) setState(() {});
  }

  List<PayrollRecord> get _filteredRecords {
    return _repo.payrollRecords.where((r) {
      if (r.payrollPeriodId != _selectedPeriodId) return false;
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        if (!r.employeeName.toLowerCase().contains(q) &&
            !r.employeeCode.toLowerCase().contains(q) &&
            !r.departmentName.toLowerCase().contains(q)) {
          return false;
        }
      }
      return true;
    }).toList();
  }

  void _runPayrollCycle() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Execute Corporate Payroll Run', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700)),
        content: Text(
          'This will execute salary calculations for all 15 employees for August 2026:\n'
          '• Sync attendance cut-offs & late arrival penalties\n'
          '• Apply double salary deductions for unapproved absences\n'
          '• Consolidate approved field GPS travel mileage reimbursements\n'
          '• Calculate statutory PF & Professional Tax deductions\n'
          '• Generate bank CMS direct disbursal batch file',
          style: GoogleFonts.plusJakartaSans(fontSize: 12),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Payroll processed successfully! Bank CMS batch generated.'),
                  backgroundColor: Color(0xFF10B981),
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
            child: const Text('Confirm & Process Disbursal'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isCompact = MediaQuery.of(context).size.width < 768;

    final records = _filteredRecords;
    final totalRecords = records.length;
    final totalPages = (totalRecords / _pageSize).ceil().clamp(1, 99);
    final startIndex = (_currentPage - 1) * _pageSize;
    final paged = records.skip(startIndex).take(_pageSize).toList();

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
                  title: 'Monthly Payroll Processing & PDF Slips',
                  subtitle: 'Base salary calculations, statutory PF/Tax deductions, GPS mileage credits & policy penalty settlements',
                  icon: Icons.receipt_long_rounded,
                  badgeText: 'AUGUST 2026 DISBURSED',
                  badgeColor: const Color(0xFF10B981),
                  actions: [
                    OutlinedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Exporting HDFC/ICICI Corporate CMS Disbursal File (CSV)...')),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        visualDensity: VisualDensity.compact,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      icon: const Icon(Icons.file_download_outlined, size: 16),
                      label: Text('Export CMS Batch', style: GoogleFonts.plusJakartaSans(fontSize: 12)),
                    ),
                    ElevatedButton.icon(
                      onPressed: _runPayrollCycle,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF10B981),
                        foregroundColor: Colors.white,
                        visualDensity: VisualDensity.compact,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      ),
                      icon: const Icon(Icons.play_arrow_rounded, size: 16),
                      label: Text('Run Payroll Cycle', style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),

                // Metrics
                _buildMetrics(context, isCompact),
                const SizedBox(height: AppSpacing.md),

                // Chart Banner
                const PayrollExpenseChart(),
                const SizedBox(height: AppSpacing.md),

                // Filter Bar & Cycle Selector
                HrmsFilterBar(
                  searchHint: 'Search payroll records by employee, code, or department...',
                  selectedFilter: _selectedPeriodId,
                  onSearchChanged: (q) => setState(() {
                    _searchQuery = q;
                    _currentPage = 1;
                  }),
                  filterOptions: _repo.payrollPeriods.map((p) {
                    return FilterOption(label: p.name, value: p.id, count: p.totalEmployees);
                  }).toList(),
                  onFilterSelected: (val) => setState(() {
                    _selectedPeriodId = val;
                    _currentPage = 1;
                  }),
                ),
                const SizedBox(height: AppSpacing.sm),

                // Table
                _buildPayrollTable(paged, totalRecords, totalPages, isDark),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMetrics(BuildContext context, bool isCompact) {
    final cards = [
      const HrmsMetricCard(
        title: 'Gross Salary Cost',
        value: '₹14.85 Lacs',
        subtitle: '15 Active Personnel',
        icon: Icons.payments_outlined,
        accentColor: Color(0xFF3B82F6),
      ),
      const HrmsMetricCard(
        title: 'Statutory & Policy Deductions',
        value: '₹1.04 Lacs',
        subtitle: 'PF, PT & Penalty Deductions',
        icon: Icons.receipt_outlined,
        accentColor: Color(0xFFEF4444),
      ),
      const HrmsMetricCard(
        title: 'Net Disbursed Payout',
        value: '₹13.80 Lacs',
        subtitle: 'NEFT Direct Disbursal Cleared',
        icon: Icons.check_circle_outline,
        accentColor: Color(0xFF10B981),
      ),
      const HrmsMetricCard(
        title: 'Disbursal Compliance',
        value: '100% Cleared',
        subtitle: 'Bank Ref: CMS-TXN-882910',
        icon: Icons.verified_outlined,
        accentColor: Color(0xFF8B5CF6),
      ),
    ];

    if (isCompact) {
      return Column(children: cards.map((c) => Padding(padding: const EdgeInsets.only(bottom: 8), child: c)).toList());
    }
    return Row(children: cards.map((c) => Expanded(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 4), child: c))).toList());
  }

  Widget _buildPayrollTable(List<PayrollRecord> records, int totalRecords, int totalPages, bool isDark) {
    return HrmsDataTable(
      columns: const [
        HrmsDataColumn(title: 'EMPLOYEE & ROLE'),
        HrmsDataColumn(title: 'DAYS (PRES / DEDUCT)'),
        HrmsDataColumn(title: 'GROSS EARNINGS'),
        HrmsDataColumn(title: 'TOTAL DEDUCTIONS'),
        HrmsDataColumn(title: 'NET DISBURSED PAY'),
        HrmsDataColumn(title: 'PAYSLIP SLIP', alignment: Alignment.centerRight),
      ],
      currentPage: _currentPage,
      totalPages: totalPages,
      totalRecords: totalRecords,
      onPageChanged: (p) => setState(() => _currentPage = p),
      rows: records.map((r) {
        return [
          // Employee
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(r.employeeName, style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700, color: isDark ? Colors.white : const Color(0xFF0F172A))),
              Text('${r.employeeCode} • ${r.departmentName}', style: GoogleFonts.plusJakartaSans(fontSize: 10, color: const Color(0xFF94A3B8))),
            ],
          ),

          // Working Days
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('${r.presentDays} / ${r.workingDays} Days', style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w600)),
              if (r.penaltyDeductionDays > 0)
                Text('${r.penaltyDeductionDays}d Double Penalty', style: GoogleFonts.plusJakartaSans(fontSize: 10, fontWeight: FontWeight.w700, color: const Color(0xFFEF4444)))
              else
                Text('${r.paidLeaveDays}d Paid Leave', style: GoogleFonts.plusJakartaSans(fontSize: 10, color: const Color(0xFF94A3B8))),
            ],
          ),

          // Gross Earnings
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('₹${r.grossEarnings.toInt()}', style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700)),
              if (r.incentivesTotal > 0 || r.travelReimbursement > 0)
                Text(
                  '+₹${(r.incentivesTotal + r.travelReimbursement).toInt()} Variable',
                  style: GoogleFonts.plusJakartaSans(fontSize: 9.5, color: const Color(0xFF10B981), fontWeight: FontWeight.w600),
                ),
            ],
          ),

          // Deductions
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('- ₹${r.totalDeductions.toInt()}', style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700, color: const Color(0xFFEF4444))),
              if (r.policyPenaltyDeduction > 0)
                Text('Incl ₹${r.policyPenaltyDeduction.toInt()} Penalty', style: GoogleFonts.plusJakartaSans(fontSize: 9.5, color: const Color(0xFFEF4444))),
            ],
          ),

          // Net Pay
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('₹${r.netPay.toInt()}', style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w900, color: const Color(0xFF10B981))),
              HrmsStatusBadge.payroll(r.paymentStatus),
            ],
          ),

          // Actions
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton.icon(
                onPressed: () => PayslipDetailModal.show(context, r),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDark ? const Color(0xFF1B202E) : const Color(0xFFF1F5F9),
                  foregroundColor: isDark ? Colors.white : const Color(0xFF0F172A),
                  elevation: 0,
                  visualDensity: VisualDensity.compact,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                ),
                icon: const Icon(Icons.receipt_long, size: 14),
                label: Text('View Slip', style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
        ];
      }).toList(),
    );
  }
}
