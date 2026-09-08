import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../models/shopping_models.dart';
import '../models/shopping_mock_data.dart';

/// Admin Modal to View Buyer Leads & ₹500 Unlock Transactions for a Property
class AdminPropertyLeadsModal extends StatelessWidget {
  final PropertyListing property;

  const AdminPropertyLeadsModal({
    super.key,
    required this.property,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = AppColors.getSurface(context);
    final borderColor = AppColors.getBorder(context);
    final textPrimary = AppColors.getTextPrimary(context);
    final textMuted = AppColors.getTextMuted(context);

    final leads = ShoppingMockData.getLeadsForProperty(property.id);
    final totalRevenue = leads.length * 500.0;
    final numFormat = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Container(
        width: 680,
        constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.85),
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.12),
              blurRadius: 32,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Column(
          children: [
            // Modal Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: borderColor)),
                color: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.monetization_on_rounded, color: Color(0xFF10B981), size: 22),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Buyer Unlocks & Lead Audit Trail',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: textPrimary),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Property: #${property.id} • ${property.title}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 12, color: textMuted),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(Icons.close_rounded, color: textMuted),
                    tooltip: 'Close',
                  ),
                ],
              ),
            ),

            // Metrics Strip
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              color: isDark ? AppColors.darkCard : AppColors.lightCard,
              child: Row(
                children: [
                  Expanded(
                    child: _buildMetricTile(
                      label: 'Total Client Unlocks',
                      value: '${leads.length} Buyers',
                      icon: Icons.people_alt_rounded,
                      color: AppColors.primary,
                      context: context,
                    ),
                  ),
                  Container(width: 1, height: 36, color: borderColor),
                  Expanded(
                    child: _buildMetricTile(
                      label: 'Gross Unlock Revenue',
                      value: numFormat.format(totalRevenue),
                      icon: Icons.account_balance_wallet_rounded,
                      color: const Color(0xFF10B981),
                      context: context,
                    ),
                  ),
                  Container(width: 1, height: 36, color: borderColor),
                  Expanded(
                    child: _buildMetricTile(
                      label: 'Direct Owner Phone',
                      value: property.ownerRealPhone,
                      icon: Icons.phone_rounded,
                      color: const Color(0xFF8B5CF6),
                      context: context,
                    ),
                  ),
                ],
              ),
            ),
            Divider(height: 1, color: borderColor),

            // Leads List
            Expanded(
              child: leads.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.lock_clock_rounded, size: 48, color: textMuted),
                          const SizedBox(height: 12),
                          Text(
                            'No Client Unlocks Yet',
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: textPrimary),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'When clients pay ₹500 to view this owner, their verified contact logs appear here.',
                            style: TextStyle(fontSize: 12, color: textMuted),
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.all(20),
                      itemCount: leads.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 12),
                      itemBuilder: (ctx, idx) {
                        final lead = leads[idx];
                        return Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: borderColor),
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 22,
                                backgroundColor: AppColors.primary.withValues(alpha: 0.15),
                                child: Text(
                                  lead.unlockedByName.isNotEmpty ? lead.unlockedByName[0].toUpperCase() : 'U',
                                  style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.primary, fontSize: 16),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          lead.unlockedByName,
                                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: textPrimary),
                                        ),
                                        const SizedBox(width: 8),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF10B981).withValues(alpha: 0.12),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: const Text(
                                            '₹500 PAID (Verified)',
                                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Color(0xFF10B981)),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Phone: ${lead.unlockedByPhone}  •  Txn: ${lead.transactionId}',
                                      style: TextStyle(fontSize: 12, color: textMuted),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'Unlocked on: ${DateFormat('dd MMM yyyy, hh:mm a').format(lead.unlockedAt)}',
                                      style: TextStyle(fontSize: 11, color: textMuted),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              OutlinedButton.icon(
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Dialing ${lead.unlockedByName} at ${lead.unlockedByPhone}...'),
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.call_rounded, size: 14),
                                label: const Text('Call Client', style: TextStyle(fontSize: 12)),
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),

            // Modal Footer
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: borderColor)),
                color: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'All transactions are audited under Homio Paywall Gateway.',
                    style: TextStyle(fontSize: 11, color: textMuted),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    ),
                    child: const Text('Close Audit'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricTile({
    required String label,
    required String value,
    required IconData icon,
    required Color color,
    required BuildContext context,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(fontSize: 10, color: AppColors.getTextMuted(context), fontWeight: FontWeight.w600)),
            Text(value, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.getTextPrimary(context))),
          ],
        ),
      ],
    );
  }
}
