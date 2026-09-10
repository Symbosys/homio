import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_radius.dart';
import '../domain/hrms_domain_models.dart';
import 'hrms_status_badge.dart';

class PayslipDetailModal extends StatelessWidget {
  final PayrollRecord record;

  const PayslipDetailModal({super.key, required this.record});

  static void show(BuildContext context, PayrollRecord record) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 780, maxHeight: 720),
          child: PayslipDetailModal(record: record),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF131722) : Colors.white,
        borderRadius: AppRadius.lg,
        border: Border.all(
          color: isDark ? Colors.white.withValues(alpha: 0.08) : Colors.black.withValues(alpha: 0.06),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1B202E) : const Color(0xFFF8FAFC),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.lgVal)),
              border: Border(bottom: BorderSide(color: isDark ? Colors.white10 : Colors.black12)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981).withValues(alpha: 0.12),
                        borderRadius: AppRadius.sm,
                      ),
                      child: const Icon(Icons.receipt_long, size: 18, color: Color(0xFF10B981)),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Official Salary Slip • Homio CRM',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Downloading Payslip PDF for ${record.employeeName}...'),
                            backgroundColor: const Color(0xFF10B981),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        visualDensity: VisualDensity.compact,
                      ),
                      icon: const Icon(Icons.download, size: 14),
                      label: Text('Download PDF', style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w600)),
                    ),
                    const SizedBox(width: 6),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close, size: 18),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Printable Slip Sheet
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Corporate Title & Metadata
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'HOMIO INTERIORS & ARCHITECTURE PVT LTD',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.5,
                              color: isDark ? Colors.white : const Color(0xFF0F172A),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Level 12, Horizon Cyber Tower, G Block BKC, Mumbai 400051\nGSTIN: 27AABCH8829K1Z4 • PAN: AABCH8829K',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 10,
                              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.12),
                              borderRadius: AppRadius.sm,
                            ),
                            child: Text(
                              'PAYSLIP - AUGUST 2026',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          HrmsStatusBadge.payroll(record.paymentStatus),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  const Divider(height: 1),
                  const SizedBox(height: AppSpacing.md),

                  // Employee Details Grid
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF181D2A) : const Color(0xFFF8FAFC),
                      borderRadius: AppRadius.md,
                      border: Border.all(color: isDark ? Colors.white.withValues(alpha: 0.04) : Colors.black.withValues(alpha: 0.04)),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(child: _metaCol('Employee Name', record.employeeName, isDark)),
                            Expanded(child: _metaCol('Employee Code', record.employeeCode, isDark)),
                            Expanded(child: _metaCol('Designation', record.designation, isDark)),
                            Expanded(child: _metaCol('Department', record.departmentName, isDark)),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Row(
                          children: [
                            Expanded(child: _metaCol('Working Days', '${record.workingDays}', isDark)),
                            Expanded(child: _metaCol('Days Present', '${record.presentDays}', isDark)),
                            Expanded(child: _metaCol('Paid Leaves', '${record.paidLeaveDays}', isDark)),
                            Expanded(
                              child: _metaCol(
                                'Deduction Days',
                                record.penaltyDeductionDays > 0 ? '${record.penaltyDeductionDays} (Double Penalty)' : '0',
                                isDark,
                                color: record.penaltyDeductionDays > 0 ? const Color(0xFFEF4444) : null,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Earnings vs Deductions Table
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Earnings
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: isDark ? Colors.white12 : Colors.black12),
                            borderRadius: AppRadius.md,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                color: const Color(0xFF10B981).withValues(alpha: 0.12),
                                child: Text('EARNINGS & ALLOWANCES', style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w700, color: const Color(0xFF10B981))),
                              ),
                              _slipRow('Basic Salary (50%)', '₹${record.baseSalary.toInt()}', isDark),
                              _slipRow('House Rent Allowance (HRA)', '₹${record.hra.toInt()}', isDark),
                              _slipRow('Special Allowance', '₹${record.specialAllowance.toInt()}', isDark),
                              if (record.travelReimbursement > 0)
                                _slipRow('Field GPS Mileage Allowance', '₹${record.travelReimbursement.toInt()}', isDark),
                              if (record.incentivesTotal > 0)
                                _slipRow('Performance & Sales Incentive', '₹${record.incentivesTotal.toInt()}', isDark),
                              const Divider(height: 1),
                              _slipRow('GROSS EARNINGS', '₹${record.grossEarnings.toInt()}', isDark, isBold: true),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),

                      // Deductions
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: isDark ? Colors.white12 : Colors.black12),
                            borderRadius: AppRadius.md,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                color: const Color(0xFFEF4444).withValues(alpha: 0.12),
                                child: Text('DEDUCTIONS & RECOVERIES', style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w700, color: const Color(0xFFEF4444))),
                              ),
                              _slipRow('Provident Fund (Employee PF)', '₹${record.pfDeduction.toInt()}', isDark),
                              _slipRow('Professional Tax (PT)', '₹${record.professionalTax.toInt()}', isDark),
                              if (record.policyPenaltyDeduction > 0)
                                _slipRow(
                                  'Policy Double Salary Deduction',
                                  '₹${record.policyPenaltyDeduction.toInt()}',
                                  isDark,
                                  highlightColor: const Color(0xFFEF4444),
                                ),
                              if (record.otherDeductions > 0)
                                _slipRow('Other Statutory Recoveries', '₹${record.otherDeductions.toInt()}', isDark),
                              const Divider(height: 1),
                              _slipRow('TOTAL DEDUCTIONS', '₹${record.totalDeductions.toInt()}', isDark, isBold: true),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Net Payable Banner
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF10B981).withValues(alpha: isDark ? 0.25 : 0.12),
                          const Color(0xFF059669).withValues(alpha: isDark ? 0.15 : 0.06),
                        ],
                      ),
                      borderRadius: AppRadius.md,
                      border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'NET PAYABLE AMOUNT (DISBURSED)',
                              style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w700, color: const Color(0xFF10B981)),
                            ),
                            Text(
                              '${record.paymentMethod} • Ref: ${record.paymentReference}',
                              style: GoogleFonts.plusJakartaSans(fontSize: 11, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                            ),
                          ],
                        ),
                        Text(
                          '₹${record.netPay.toInt()}',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.5,
                            color: const Color(0xFF10B981),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _metaCol(String title, String val, bool isDark, {Color? color}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: GoogleFonts.plusJakartaSans(fontSize: 10, color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8))),
        const SizedBox(height: 2),
        Text(
          val,
          style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w600, color: color ?? (isDark ? Colors.white : const Color(0xFF0F172A))),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _slipRow(String label, String amount, bool isDark, {bool isBold = false, Color? highlightColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
                color: highlightColor ?? (isDark ? Colors.white70 : const Color(0xFF334155)),
              ),
            ),
          ),
          Text(
            amount,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: isBold ? FontWeight.w800 : FontWeight.w600,
              color: highlightColor ?? (isDark ? Colors.white : const Color(0xFF0F172A)),
            ),
          ),
        ],
      ),
    );
  }
}
