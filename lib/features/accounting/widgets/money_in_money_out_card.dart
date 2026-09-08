// Homio CRM — Money In / Money Out Comparative Financial Card

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class MoneyInMoneyOutCard extends StatelessWidget {
  final double totalIn;
  final double customerCollections;
  final double consultingFees;
  final double supervisionFees;
  final double otherRevenue;

  final double totalOut;
  final double materialPurchases;
  final double labourPayments;
  final double designCosts;
  final double operationalExpenses;
  final double commissionsPaid;

  const MoneyInMoneyOutCard({
    super.key,
    required this.totalIn,
    required this.customerCollections,
    required this.consultingFees,
    required this.supervisionFees,
    this.otherRevenue = 0.0,
    required this.totalOut,
    required this.materialPurchases,
    required this.labourPayments,
    required this.designCosts,
    required this.operationalExpenses,
    required this.commissionsPaid,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final netCashflow = totalIn - totalOut;
    final isPositive = netCashflow >= 0;

    return Container(
      padding: const EdgeInsets.all(20),
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
                'MONEY IN VS MONEY OUT (CASH FLOW VISIBILITY)',
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.6,
                  color: isDark ? AppColors.darkSubtext : AppColors.lightTextSecondary,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: (isPositive ? AppColors.success : AppColors.error).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isPositive ? Icons.trending_up_rounded : Icons.trending_down_rounded,
                      size: 14,
                      color: isPositive ? AppColors.success : AppColors.error,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      'Net Operational: ₹${netCashflow.abs().toStringAsFixed(0)}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: isPositive ? AppColors.success : AppColors.error,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 650;
              return Flex(
                direction: isNarrow ? Axis.vertical : Axis.horizontal,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Money In Column
                  Expanded(
                    flex: isNarrow ? 0 : 1,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.success.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: AppColors.success.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'MONEY IN (REVENUE)',
                                style: TextStyle(
                                  color: AppColors.success,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 12,
                                  letterSpacing: 0.4,
                                ),
                              ),
                              Text(
                                '₹${totalIn.toStringAsFixed(0)}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.success,
                                ),
                              ),
                            ],
                          ),
                          const Divider(height: 20),
                          _buildLineItem(context, 'Customer Collections', customerCollections),
                          _buildLineItem(context, 'Design & Consulting Fees', consultingFees),
                          _buildLineItem(context, 'Site Supervision Fees', supervisionFees),
                          if (otherRevenue > 0)
                            _buildLineItem(context, 'Other Inflows', otherRevenue),
                        ],
                      ),
                    ),
                  ),
                  if (!isNarrow) const SizedBox(width: 16) else const SizedBox(height: 16),

                  // Money Out Column
                  Expanded(
                    flex: isNarrow ? 0 : 1,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.error.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: AppColors.error.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'MONEY OUT (DISBURSEMENTS)',
                                style: TextStyle(
                                  color: AppColors.error,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 12,
                                  letterSpacing: 0.4,
                                ),
                              ),
                              Text(
                                '₹${totalOut.toStringAsFixed(0)}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.error,
                                ),
                              ),
                            ],
                          ),
                          const Divider(height: 20),
                          _buildLineItem(context, 'Material Vendor Purchases', materialPurchases),
                          _buildLineItem(context, 'Labour Contractor Payments', labourPayments),
                          _buildLineItem(context, 'Design Milestone Costs', designCosts),
                          _buildLineItem(context, 'Operational Site Expenses', operationalExpenses),
                          _buildLineItem(context, 'Commercial Commissions', commissionsPaid),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLineItem(BuildContext context, String title, double amount) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: isDark ? AppColors.darkSubtext : AppColors.lightTextSecondary,
            ),
          ),
          Text(
            '₹${amount.toStringAsFixed(0)}',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
