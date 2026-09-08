import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../models/operations_models.dart';

class VendorComparisonWorkspace extends StatelessWidget {
  final List<VendorQuotation> quotations;
  final String rfqTitle;
  final ValueChanged<VendorQuotation>? onSelectVendor;

  const VendorComparisonWorkspace({
    super.key,
    required this.quotations,
    required this.rfqTitle,
    this.onSelectVendor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (quotations.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.compare_arrows_rounded,
                  size: 48,
                  color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted),
              const SizedBox(height: 12),
              Text(
                'No Vendor Quotations to Compare',
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              Text(
                'Send RFQs and record vendor bids to unlock side-by-side evaluation.',
                style: TextStyle(
                    color: isDark ? AppColors.darkSubtext : AppColors.lightTextSecondary),
              ),
            ],
          ),
        ),
      );
    }

    // Find recommended quotation
    final recommended = quotations.firstWhere(
      (q) => q.status == VendorQuotationStatus.recommended,
      orElse: () => quotations.first,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isDark ? AppColors.primary.withValues(alpha: 0.2) : AppColors.primaryMuted,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.compare_arrows_rounded,
                  color: AppColors.primary, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Vendor Comparison Workspace',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.3,
                    ),
                  ),
                  Text(
                    rfqTitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Recommendation Panel
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF0D251B) : const Color(0xFFF0FDF4),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.success.withValues(alpha: 0.4), width: 1.2),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.thumb_up_alt_rounded,
                    color: AppColors.success, size: 20),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'RECOMMENDED VENDOR: ',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: AppColors.success,
                            letterSpacing: 0.5,
                          ),
                        ),
                        Text(
                          recommended.vendorName,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.success,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'Rating: ${recommended.scorecard.overallRating} ★',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      recommended.recommendationRationale ??
                          '✓ Superior quality rating • Best warranty coverage • Consistent on-time delivery track record',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: isDark ? const Color(0xFF86EFAC) : const Color(0xFF166534),
                      ),
                    ),
                  ],
                ),
              ),
              if (onSelectVendor != null)
                FilledButton.icon(
                  onPressed: () => onSelectVendor!(recommended),
                  icon: const Icon(Icons.check_rounded, size: 16),
                  label: const Text('Select Recommended'),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.success,
                    foregroundColor: Colors.white,
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Side-by-side Matrix
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              ),
            ),
            child: DataTable(
              headingRowColor: WidgetStateProperty.all(
                isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
              ),
              columnSpacing: 28,
              horizontalMargin: 20,
              columns: [
                const DataColumn(
                  label: Text(
                    'CRITERIA',
                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12),
                  ),
                ),
                ...quotations.map((q) {
                  final isRec = q.id == recommended.id;
                  return DataColumn(
                    label: Row(
                      children: [
                        Text(
                          q.vendorName,
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 13,
                            color: isRec ? AppColors.primary : null,
                          ),
                        ),
                        if (isRec) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'BEST',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  );
                }),
              ],
              rows: [
                _buildRow(
                  label: 'RATE SCORE',
                  icon: Icons.currency_rupee_rounded,
                  values: quotations.map((q) => '${q.scorecard.rateScore} / 10').toList(),
                  highlightMax: true,
                ),
                _buildRow(
                  label: 'QUALITY COMPLIANCE',
                  icon: Icons.verified_rounded,
                  values: quotations.map((q) => '${q.scorecard.qualityScore} / 10').toList(),
                  highlightMax: true,
                ),
                _buildRow(
                  label: 'TRUST & RELIABILITY',
                  icon: Icons.handshake_rounded,
                  values: quotations.map((q) => '${q.scorecard.trustScore} / 10').toList(),
                  highlightMax: true,
                ),
                _buildRow(
                  label: 'TIMELINE / LEAD TIME',
                  icon: Icons.speed_rounded,
                  values: quotations.map((q) => q.deliveryTimeline).toList(),
                ),
                _buildRow(
                  label: 'WARRANTY COVERAGE',
                  icon: Icons.security_rounded,
                  values: quotations.map((q) => q.warrantyPeriod).toList(),
                ),
                _buildRow(
                  label: 'VENDOR REPUTATION',
                  icon: Icons.star_rounded,
                  values: quotations.map((q) => '${q.scorecard.overallRating} ★ / 5').toList(),
                ),
                _buildRow(
                  label: 'COMMERCIAL TERMS',
                  icon: Icons.payment_rounded,
                  values: quotations.map((q) => q.paymentTerms).toList(),
                ),
                // Total Quote Value (Bold & Colored)
                DataRow(
                  color: WidgetStateProperty.all(
                    isDark ? AppColors.primary.withValues(alpha: 0.1) : AppColors.primaryMuted,
                  ),
                  cells: [
                    const DataCell(
                      Row(
                        children: [
                          Icon(Icons.account_balance_wallet_rounded,
                              size: 16, color: AppColors.primary),
                          SizedBox(width: 8),
                          Text(
                            'TOTAL QUOTE VALUE',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 12,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ...quotations.map(
                      (q) => DataCell(
                        Text(
                          '₹${q.grandTotal.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 14,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                // Actions Row
                DataRow(
                  cells: [
                    const DataCell(
                      Text('ACTION', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11)),
                    ),
                    ...quotations.map(
                      (q) => DataCell(
                        onSelectVendor != null
                            ? OutlinedButton.icon(
                                onPressed: () => onSelectVendor!(q),
                                icon: const Icon(Icons.check_circle_outline, size: 14),
                                label: const Text('Select Vendor', style: TextStyle(fontSize: 11)),
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                  minimumSize: Size.zero,
                                ),
                              )
                            : const SizedBox.shrink(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  DataRow _buildRow({
    required String label,
    required IconData icon,
    required List<String> values,
    bool highlightMax = false,
  }) {
    return DataRow(
      cells: [
        DataCell(
          Row(
            children: [
              Icon(icon, size: 14, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 11),
              ),
            ],
          ),
        ),
        ...values.map(
          (v) => DataCell(
            Text(
              v,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );
  }
}
