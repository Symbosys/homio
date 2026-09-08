import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class ProcurementContextBar extends StatelessWidget {
  final String projectName;
  final String siteAddress;
  final String clientName;
  final String projectManager;
  final String projectStatus;
  final String procurementStatus;
  final VoidCallback? onViewProject;
  final VoidCallback? onViewCustomerSummary;

  const ProcurementContextBar({
    super.key,
    required this.projectName,
    required this.siteAddress,
    required this.clientName,
    this.projectManager = 'Amit Kumar',
    this.projectStatus = 'Execution',
    this.procurementStatus = 'Active Requests',
    this.onViewProject,
    this.onViewCustomerSummary,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF131B2E) : const Color(0xFFF1F5FD),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isDark
              ? AppColors.primary.withValues(alpha: 0.3)
              : AppColors.primary.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Icon(Icons.corporate_fare_rounded,
                size: 16, color: AppColors.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Wrap(
              spacing: 16,
              runSpacing: 4,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                _buildField(
                  label: 'Project',
                  value: projectName,
                  bold: true,
                  subvalue: siteAddress,
                  isDark: isDark,
                  theme: theme,
                ),
                _buildField(
                  label: 'Client',
                  value: clientName,
                  isDark: isDark,
                  theme: theme,
                ),
                _buildField(
                  label: 'Project Manager',
                  value: projectManager,
                  isDark: isDark,
                  theme: theme,
                ),
                _buildField(
                  label: 'Project Stage',
                  value: projectStatus,
                  pillColor: AppColors.info,
                  isDark: isDark,
                  theme: theme,
                ),
                _buildField(
                  label: 'Procurement Pulse',
                  value: procurementStatus,
                  pillColor: AppColors.success,
                  isDark: isDark,
                  theme: theme,
                ),
              ],
            ),
          ),
          if (onViewCustomerSummary != null) ...[
            const SizedBox(width: 8),
            OutlinedButton.icon(
              onPressed: onViewCustomerSummary,
              icon: const Icon(Icons.account_balance_wallet_outlined, size: 14),
              label: const Text('Customer 360°', style: TextStyle(fontSize: 12)),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildField({
    required String label,
    required String value,
    String? subvalue,
    bool bold = false,
    Color? pillColor,
    required bool isDark,
    required ThemeData theme,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label.toUpperCase(),
          style: TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
            color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted,
          ),
        ),
        const SizedBox(height: 1),
        if (pillColor != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: pillColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              value,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: pillColor,
              ),
            ),
          )
        else
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: bold ? FontWeight.w700 : FontWeight.w600,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                ),
              ),
              if (subvalue != null) ...[
                const SizedBox(width: 4),
                Text(
                  '($subvalue)',
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted,
                  ),
                ),
              ],
            ],
          ),
      ],
    );
  }
}
