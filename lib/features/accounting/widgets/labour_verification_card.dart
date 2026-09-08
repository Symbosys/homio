// Homio CRM — 5-Point Labour & Contractor Payment Verification Card

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../models/accounting_models.dart';

class LabourVerificationCard extends StatelessWidget {
  final LabourPaymentRecord record;
  final VoidCallback? onApprovePm;

  const LabourVerificationCard({
    super.key,
    required this.record,
    this.onApprovePm,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '5-POINT SITE VERIFICATION AUDIT',
                style: theme.textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.6,
                  color: isDark ? AppColors.darkSubtext : AppColors.lightTextSecondary,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: record.paymentEligible
                      ? AppColors.success.withValues(alpha: 0.12)
                      : AppColors.warning.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  record.paymentEligible ? 'ELIGIBLE FOR DISBURSEMENT' : 'VERIFICATION INCOMPLETE',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: record.paymentEligible ? AppColors.success : AppColors.warning,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // 5 Verification Checkpoints
          _buildCheckItem(context, 'Work Order Formally Assigned', record.workAssigned, Icons.assignment_turned_in_rounded),
          _buildCheckItem(context, 'Work Execution Completed (${record.completionPercentage.toStringAsFixed(0)}%)', record.workCompleted, Icons.construction_rounded),
          _buildCheckItem(context, 'Site Physical QA Passed (No Snags)', record.siteVerified, Icons.verified_user_rounded),
          _buildCheckItem(context, 'Project Manager Sign-off Approved', record.pmApproved, Icons.how_to_reg_rounded),
          _buildCheckItem(context, 'Finance Disbursement Clearance', record.paymentEligible, Icons.account_balance_wallet_rounded),

          if (record.supervisorVerificationNotes != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurfaceElevated : AppColors.lightSurfaceSubtle,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.info_outline_rounded, size: 14, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Supervisor Note: ${record.supervisorVerificationNotes}',
                      style: const TextStyle(fontSize: 11, fontStyle: FontStyle.italic),
                    ),
                  ),
                ],
              ),
            ),
          ],

          if (!record.pmApproved && onApprovePm != null) ...[
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: onApprovePm,
                icon: const Icon(Icons.check_circle_outline_rounded, size: 16),
                label: const Text('Grant PM Approval & Authorize Disbursement', style: TextStyle(fontSize: 12)),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCheckItem(BuildContext context, String title, bool isPassed, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            isPassed ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
            color: isPassed ? AppColors.success : Colors.grey,
            size: 18,
          ),
          const SizedBox(width: 10),
          Icon(icon, size: 14, color: isPassed ? AppColors.primary : Colors.grey),
          const SizedBox(width: 6),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isPassed ? FontWeight.w600 : FontWeight.w400,
              color: isPassed ? null : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
