import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../models/quotation_models.dart';

/// BOQ Item Table for editing line items within a room.
class ItemTable extends StatelessWidget {
  final List<QuotationItem> items;
  final ValueChanged<List<QuotationItem>> onItemsChanged;
  final VoidCallback onAddItem;

  const ItemTable({
    super.key,
    required this.items,
    required this.onItemsChanged,
    required this.onAddItem,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: AppRadius.md,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          width: 0.8,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.inventory_2_rounded, size: 16, color: AppColors.primary),
                    const SizedBox(width: 8),
                    Text(
                      'Bill of Quantities (${items.length} items)',
                      style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                FilledButton.icon(
                  onPressed: onAddItem,
                  icon: const Icon(Icons.add_rounded, size: 14),
                  label: const Text('Add Item from Catalogue'),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          if (items.isEmpty)
            Padding(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: Text(
                  'No items in this room yet. Click above to add items from master catalogue.',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                  ),
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: items.length,
              separatorBuilder: (ctx, idx) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final item = items[index];

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Row(
                    children: [
                      // Item Name & Category
                      Expanded(
                        flex: 4,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.name,
                              style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              item.materialSpecs,
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Quantity input
                      SizedBox(
                        width: 70,
                        child: TextFormField(
                          initialValue: item.quantity.toStringAsFixed(1),
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600),
                          decoration: InputDecoration(
                            labelText: 'Qty',
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                            border: OutlineInputBorder(borderRadius: AppRadius.sm),
                          ),
                          onChanged: (val) {
                            final q = double.tryParse(val) ?? item.quantity;
                            final list = List<QuotationItem>.from(items);
                            list[index] = item.copyWith(quantity: q);
                            onItemsChanged(list);
                          },
                        ),
                      ),
                      const SizedBox(width: 6),

                      // UOM
                      SizedBox(
                        width: 45,
                        child: Text(
                          item.uom.symbol,
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),

                      // Rate input
                      SizedBox(
                        width: 80,
                        child: TextFormField(
                          initialValue: item.rate.toStringAsFixed(0),
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600),
                          decoration: InputDecoration(
                            labelText: 'Rate',
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                            border: OutlineInputBorder(borderRadius: AppRadius.sm),
                          ),
                          onChanged: (val) {
                            final r = double.tryParse(val) ?? item.rate;
                            final list = List<QuotationItem>.from(items);
                            list[index] = item.copyWith(rate: r);
                            onItemsChanged(list);
                          },
                        ),
                      ),
                      const SizedBox(width: 10),

                      // Total
                      SizedBox(
                        width: 85,
                        child: Text(
                          '₹${item.amount.toStringAsFixed(0)}',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                          textAlign: TextAlign.end,
                        ),
                      ),
                      const SizedBox(width: 6),

                      // Delete
                      IconButton(
                        icon: const Icon(Icons.close_rounded, size: 15, color: AppColors.error),
                        onPressed: () {
                          final list = List<QuotationItem>.from(items);
                          list.removeAt(index);
                          onItemsChanged(list);
                        },
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
