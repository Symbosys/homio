import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../models/operations_models.dart';

class DesignVerificationPanel extends StatelessWidget {
  final DesignPaymentRequest request;
  final VoidCallback? onOpenDrive;
  final VoidCallback? onVerifyApproval;

  const DesignVerificationPanel({
    super.key,
    required this.request,
    this.onOpenDrive,
    this.onVerifyApproval,
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
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(Icons.fact_check_rounded,
                        size: 16, color: AppColors.primary),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Milestone Work Verification & Deliverables',
                    style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              if (onOpenDrive != null)
                OutlinedButton.icon(
                  onPressed: onOpenDrive,
                  icon: const Icon(Icons.cloud_download_outlined, size: 14),
                  label: const Text('Open Project Drive', style: TextStyle(fontSize: 11)),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    minimumSize: Size.zero,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),

          // Counters Row
          Row(
            children: [
              Expanded(
                child: _buildMetricCard(
                  label: 'Files Submitted',
                  value: '${request.filesSubmittedCount}',
                  icon: Icons.upload_file_rounded,
                  color: AppColors.info,
                  isDark: isDark,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMetricCard(
                  label: 'Files Approved',
                  value: '${request.filesApprovedCount}',
                  icon: Icons.check_circle_rounded,
                  color: AppColors.success,
                  isDark: isDark,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMetricCard(
                  label: 'Pending / Revisions',
                  value: '${request.filesPendingCount}',
                  icon: Icons.hourglass_top_rounded,
                  color: request.filesPendingCount > 0 ? AppColors.warning : AppColors.success,
                  isDark: isDark,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMetricCard(
                  label: 'Completion %',
                  value: '${request.deliverablesCompletedPercent}%',
                  icon: Icons.donut_large_rounded,
                  color: AppColors.primary,
                  isDark: isDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Details grid
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                _buildDetailRow('Client Sign-off Status', request.clientApprovalStatus, isDark),
                const SizedBox(height: 8),
                _buildDetailRow('Site PM Handover Status', request.executionHandoverStatus, isDark),
                const SizedBox(height: 8),
                _buildDetailRow('Revision Cycle Count', '${request.revisionCount} Revisions Completed', isDark),
                const SizedBox(height: 8),
                _buildDetailRow('Technical Verification Notes', request.verificationNotes, isDark),
                const SizedBox(height: 8),
                _buildDetailRow('Supervisor Feedback', request.supervisorFeedback, isDark),
              ],
            ),
          ),
          if (onVerifyApproval != null) ...[
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton.icon(
                onPressed: onVerifyApproval,
                icon: const Icon(Icons.verified_rounded, size: 16),
                label: const Text('Sign-off Deliverables & Approve Payment'),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.success,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMetricCard({
    required String label,
    required String value,
    required IconData icon,
    required Color color,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? color.withValues(alpha: 0.1) : color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label.toUpperCase(),
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                  color: color,
                  letterSpacing: 0.4,
                ),
              ),
              Icon(icon, size: 14, color: color),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, bool isDark) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 170,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }
}
