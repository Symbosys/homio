import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../models/execution_models.dart';

/// Interactive Commercial Billing Cards for Fixed Consulting, Percentage-of-Cost, and Turnkey models.
class CommercialBillingCard extends StatelessWidget {
  final ProjectMaster project;
  final void Function(String milestoneName, double amount)? onTriggerInvoice;
  final void Function(String milestoneName, double amount)? onRecordPayment;

  const CommercialBillingCard({
    super.key,
    required this.project,
    this.onTriggerInvoice,
    this.onRecordPayment,
  });

  @override
  Widget build(BuildContext context) {
    switch (project.contractModel) {
      case ContractModel.fixedConsulting:
        return _buildFixedConsultingView(context);
      case ContractModel.percentageModel:
        return _buildPercentageModelView(context);
      case ContractModel.turnkeyContract:
        return _buildTurnkeyModelView(context);
    }
  }

  // Model 1: Fixed Consulting Model
  Widget _buildFixedConsultingView(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    const materialActuals = 1845000.0;
    const labourActuals = 920000.0;
    final fixedFee = project.totalContractValue * 0.15; // e.g. 15% fixed fee
    final feeBilled = fixedFee * 0.8;
    final feeReceived = fixedFee * 0.7;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: AppRadius.md,
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder, width: 0.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildModelBadge(ContractModel.fixedConsulting),
          const SizedBox(height: 12),
          Text(
            'Material & Labour Billed at Actuals + Fixed Lumsum Consulting Fee',
            style: GoogleFonts.inter(fontSize: 12, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
          ),
          const Divider(height: 24),

          Row(
            children: [
              Expanded(child: _buildMetricTile(isDark, 'Material (At Actuals)', '₹${materialActuals.toStringAsFixed(0)}', AppColors.primary)),
              Expanded(child: _buildMetricTile(isDark, 'Labour (At Actuals)', '₹${labourActuals.toStringAsFixed(0)}', AppColors.secondary)),
              Expanded(child: _buildMetricTile(isDark, 'Fixed Professional Fee', '₹${fixedFee.toStringAsFixed(0)}', AppColors.success)),
            ],
          ),
          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
              borderRadius: AppRadius.sm,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Consulting Fee Billed: ₹${feeBilled.toStringAsFixed(0)}', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600)),
                Text('Fee Collected: ₹${feeReceived.toStringAsFixed(0)}', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.success)),
                Text('Fee Dues: ₹${(feeBilled - feeReceived).toStringAsFixed(0)}', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.error)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Model 2: Percentage-of-Cost Consulting Model
  Widget _buildPercentageModelView(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    const materialSpend = 1420000.0;
    const labourSpend = 680000.0;
    const baseSpend = materialSpend + labourSpend;
    const agreedPercentage = 15.0; // 15%
    final dynamicFee = baseSpend * (agreedPercentage / 100.0);
    const feesPaid = 280000.0;
    final pendingFees = dynamicFee - feesPaid;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: AppRadius.md,
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder, width: 0.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildModelBadge(ContractModel.percentageModel),
          const SizedBox(height: 12),
          Text(
            'Dynamic Fee Calculation: (Verified Material Spend + Verified Labour Spend) × 15%',
            style: GoogleFonts.inter(fontSize: 12, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
          ),
          const Divider(height: 24),

          Row(
            children: [
              Expanded(child: _buildMetricTile(isDark, 'Verified Material Spend', '₹${materialSpend.toStringAsFixed(0)}', AppColors.primary)),
              Expanded(child: _buildMetricTile(isDark, 'Verified Labour Spend', '₹${labourSpend.toStringAsFixed(0)}', AppColors.secondary)),
              Expanded(child: _buildMetricTile(isDark, 'Total Base Project Spend', '₹${baseSpend.toStringAsFixed(0)}', Colors.grey)),
            ],
          ),
          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: isDark ? 0.15 : 0.08),
              borderRadius: AppRadius.sm,
              border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Dynamic Consulting Fee (15% of ₹${(baseSpend / 100000).toStringAsFixed(1)}L)', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700)),
                    Text('Total Earned to Date based on site spend', style: GoogleFonts.inter(fontSize: 10, color: Colors.grey)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('₹${dynamicFee.toStringAsFixed(0)}', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w900, color: AppColors.primary)),
                    Text('Pending Dues: ₹${pendingFees.toStringAsFixed(0)}', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.error)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Model 3: Turnkey Contract Model (5 Milestones: 10%-20%-25%-35%-10%)
  Widget _buildTurnkeyModelView(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final total = project.totalContractValue;

    final stages = [
      {'name': 'Stage 1: Advance Token on Booking', 'pct': 10, 'amount': total * 0.10, 'status': 'PAID'},
      {'name': 'Stage 2: 2D/3D Design Freeze Sign-off', 'pct': 20, 'amount': total * 0.20, 'status': 'PAID'},
      {'name': 'Stage 3: Civil & Core MEP Completion', 'pct': 25, 'amount': total * 0.25, 'status': 'DUE FOR APPROVAL'},
      {'name': 'Stage 4: Woodwork & Carcass Delivery', 'pct': 35, 'amount': total * 0.35, 'status': 'UPCOMING'},
      {'name': 'Stage 5: Final Handover & QC Snags', 'pct': 10, 'amount': total * 0.10, 'status': 'UPCOMING'},
    ];

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: AppRadius.md,
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder, width: 0.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildModelBadge(ContractModel.turnkeyContract),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Fixed Turnkey Contract: ₹${total.toStringAsFixed(0)}',
                style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.primary),
              ),
              Text(
                'Paid: ₹${project.totalPaid.toStringAsFixed(0)} | Dues: ₹${project.pendingDues.toStringAsFixed(0)}',
                style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: project.pendingDues > 0 ? AppColors.error : AppColors.success),
              ),
            ],
          ),
          const Divider(height: 24),

          Text('Work Stage Payment Milestone Schedule (PRD Section 8.5):', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700)),
          const SizedBox(height: 10),

          ...stages.map((stg) {
            final isPaid = stg['status'] == 'PAID';
            final isDue = stg['status'] == 'DUE FOR APPROVAL';

            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                borderRadius: AppRadius.sm,
                border: Border.all(
                  color: isPaid
                      ? AppColors.success.withValues(alpha: 0.3)
                      : isDue
                          ? AppColors.warning.withValues(alpha: 0.4)
                          : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        isPaid
                            ? Icons.check_circle_rounded
                            : isDue
                                ? Icons.pending_actions_rounded
                                : Icons.circle_outlined,
                        size: 16,
                        color: isPaid
                            ? AppColors.success
                            : isDue
                                ? AppColors.warning
                                : Colors.grey,
                      ),
                      const SizedBox(width: 8),
                      Text(stg['name'] as String, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600)),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        '${stg['pct']}% (₹${(stg['amount'] as double).toStringAsFixed(0)})',
                        style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: isPaid
                              ? AppColors.success.withValues(alpha: 0.15)
                              : isDue
                                  ? AppColors.warning.withValues(alpha: 0.15)
                                  : Colors.grey.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: Text(
                          stg['status'] as String,
                          style: GoogleFonts.inter(
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                            color: isPaid
                                ? AppColors.success
                                : isDue
                                    ? AppColors.warning
                                    : Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildModelBadge(ContractModel model) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(model.icon, size: 14, color: AppColors.primary),
          const SizedBox(width: 6),
          Text(model.title, style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.primary)),
        ],
      ),
    );
  }

  Widget _buildMetricTile(bool isDark, String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.inter(fontSize: 10, color: Colors.grey)),
        const SizedBox(height: 2),
        Text(value, style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w800, color: color)),
      ],
    );
  }
}
