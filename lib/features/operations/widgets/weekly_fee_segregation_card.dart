import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../models/operations_models.dart';

class WeeklyFeeSegregationCard extends StatelessWidget {
  final WeeklyFee fee;
  final VoidCallback? onGeneratePaymentRequest;
  final VoidCallback? onSendWhatsApp;

  const WeeklyFeeSegregationCard({
    super.key,
    required this.fee,
    this.onGeneratePaymentRequest,
    this.onSendWhatsApp,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
              border: Border(
                bottom: BorderSide(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                ),
              ),
            ),
            child: Row(
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
                      child: const Icon(Icons.account_balance_wallet_rounded,
                          size: 16, color: AppColors.primary),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          fee.weekPeriod,
                          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
                        ),
                        Text(
                          '${fee.projectName} • ${fee.customerName}',
                          style: TextStyle(
                            fontSize: 11,
                            color: isDark ? AppColors.darkSubtext : AppColors.lightTextSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    if (onSendWhatsApp != null)
                      OutlinedButton.icon(
                        onPressed: onSendWhatsApp,
                        icon: const Icon(Icons.send_to_mobile_rounded, size: 14),
                        label: Text(
                          fee.whatsappStatus == 'Delivered'
                              ? 'WhatsApp Delivered'
                              : 'Send WhatsApp',
                          style: const TextStyle(fontSize: 11),
                        ),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          minimumSize: Size.zero,
                        ),
                      ),
                    const SizedBox(width: 8),
                    if (onGeneratePaymentRequest != null)
                      FilledButton.icon(
                        onPressed: onGeneratePaymentRequest,
                        icon: const Icon(Icons.link_rounded, size: 14),
                        label: const Text('Payment Request', style: TextStyle(fontSize: 11)),
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          minimumSize: Size.zero,
                          backgroundColor: AppColors.primary,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // 3-Way Segregated Grid
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Material Bills
                    Expanded(
                      child: _buildCategoryColumn(
                        title: '1. MATERIAL EXPENDITURE',
                        amount: fee.materialAmount,
                        color: const Color(0xFF3B82F6),
                        icon: Icons.inventory_2_outlined,
                        notes: fee.materialNotes,
                        bills: fee.materialBills,
                        isDark: isDark,
                      ),
                    ),
                    const SizedBox(width: 16),
                    // 2. Labour Wages
                    Expanded(
                      child: _buildCategoryColumn(
                        title: '2. LABOUR & CONTRACTOR WAGES',
                        amount: fee.labourAmount,
                        color: const Color(0xFF10B981),
                        icon: Icons.engineering_outlined,
                        notes: fee.labourNotes,
                        bills: fee.labourBills,
                        isDark: isDark,
                      ),
                    ),
                    const SizedBox(width: 16),
                    // 3. Supervision & Consulting Fees
                    Expanded(
                      child: _buildCategoryColumn(
                        title: '3. PROJECT CONSULTING & FEES',
                        amount: fee.feesTotal,
                        color: const Color(0xFF8B5CF6),
                        icon: Icons.assignment_turned_in_outlined,
                        notes: fee.feeNotes,
                        bills: [
                          FeeBillItem(
                            billNumber: 'FEE-SUP-01',
                            billDate: fee.feeDate,
                            recipientName: 'Supervision Retainer',
                            description: 'Architectural Site Oversight',
                            amount: fee.supervisionFees,
                            isPaid: true,
                          ),
                          FeeBillItem(
                            billNumber: 'FEE-CON-01',
                            billDate: fee.feeDate,
                            recipientName: 'Consulting Retainer',
                            description: 'Turnkey Operations Management',
                            amount: fee.consultingFees,
                            isPaid: true,
                          ),
                        ],
                        isDark: isDark,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Live Auto-Calculated Summary Box (Client requirement specifically mandates auto-calculated amounts)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurfaceSubtle : const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildSummaryItem(
                              'Material',
                              '₹${fee.materialAmount.toStringAsFixed(0)}',
                              isDark,
                            ),
                            const Text('+', style: TextStyle(fontWeight: FontWeight.w700)),
                            _buildSummaryItem(
                              'Labour',
                              '₹${fee.labourAmount.toStringAsFixed(0)}',
                              isDark,
                            ),
                            const Text('+', style: TextStyle(fontWeight: FontWeight.w700)),
                            _buildSummaryItem(
                              'Consulting Fees',
                              '₹${fee.feesTotal.toStringAsFixed(0)}',
                              isDark,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 36,
                        width: 1,
                        color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                      ),
                      // Total & Due
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text(
                                'TOTAL WEEKLY CHARGE',
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              Text(
                                '₹${fee.totalAmount.toStringAsFixed(0)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 16,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text(
                                'NET DUES REMAINING',
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.5,
                                  color: AppColors.error,
                                ),
                              ),
                              Text(
                                '₹${fee.dueAmount.toStringAsFixed(0)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 16,
                                  color: AppColors.error,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
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

  Widget _buildCategoryColumn({
    required String title,
    required double amount,
    required Color color,
    required IconData icon,
    required String notes,
    required List<FeeBillItem> bills,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? color.withValues(alpha: 0.08) : color.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: color),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: color,
                    letterSpacing: 0.4,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            '₹${amount.toStringAsFixed(0)}',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            notes,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 11,
              color: isDark ? AppColors.darkSubtext : AppColors.lightTextSecondary,
            ),
          ),
          const Divider(height: 16),
          Text(
            'Itemized Bills (${bills.length})',
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          ...bills.take(3).map((bill) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      '${bill.billNumber}: ${bill.description}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 11),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '₹${bill.amount.toStringAsFixed(0)}',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: bill.isPaid ? AppColors.success : AppColors.error,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, bool isDark) {
    return Column(
      children: [
        Text(
          label.toUpperCase(),
          style: TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w700,
            color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
        ),
      ],
    );
  }
}
