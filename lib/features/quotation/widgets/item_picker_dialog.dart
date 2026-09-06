import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../models/quotation_models.dart';
import '../models/quotation_mock_data.dart';

/// Modal dialog allowing the estimator/designer to pick an item from the master catalogue.
class ItemPickerDialog extends StatefulWidget {
  final ValueChanged<ItemMasterEntry> onItemSelected;

  const ItemPickerDialog({
    super.key,
    required this.onItemSelected,
  });

  @override
  State<ItemPickerDialog> createState() => _ItemPickerDialogState();
}

class _ItemPickerDialogState extends State<ItemPickerDialog> {
  String _searchQuery = '';
  ItemCategory? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final items = QuotationMockData.masterItems.where((item) {
      final matchesCat = _selectedCategory == null || item.category == _selectedCategory;
      final matchesSearch = _searchQuery.isEmpty ||
          item.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.technicalSpecs.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCat && matchesSearch;
    }).toList();

    return Dialog(
      backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.lg,
        side: BorderSide(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          width: 0.8,
        ),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 720, maxHeight: 680),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: AppRadius.sm,
                        ),
                        child: const Icon(Icons.inventory_2_rounded, size: 18, color: AppColors.primary),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Select from Item Master',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, size: 20),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            Divider(height: 1, color: isDark ? AppColors.darkBorder : AppColors.lightBorder),

            // Search & Category Filters
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(
                    onChanged: (val) => setState(() => _searchQuery = val),
                    decoration: InputDecoration(
                      hintText: 'Search items by name, specification, or brand...',
                      prefixIcon: const Icon(Icons.search_rounded, size: 18),
                      filled: true,
                      fillColor: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                      border: OutlineInputBorder(
                        borderRadius: AppRadius.sm,
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        FilterChip(
                          label: const Text('All Categories'),
                          selected: _selectedCategory == null,
                          onSelected: (_) => setState(() => _selectedCategory = null),
                          backgroundColor: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                          selectedColor: AppColors.primary.withValues(alpha: 0.2),
                          labelStyle: GoogleFonts.inter(fontSize: 11),
                        ),
                        const SizedBox(width: 6),
                        ...ItemCategory.values.map((cat) {
                          final isSel = _selectedCategory == cat;
                          return Padding(
                            padding: const EdgeInsets.only(right: 6),
                            child: FilterChip(
                              avatar: Icon(cat.icon, size: 14),
                              label: Text(cat.label),
                              selected: isSel,
                              onSelected: (_) => setState(() => _selectedCategory = isSel ? null : cat),
                              backgroundColor: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                              selectedColor: AppColors.primary.withValues(alpha: 0.2),
                              labelStyle: GoogleFonts.inter(fontSize: 11),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Divider(height: 1, color: isDark ? AppColors.darkBorder : AppColors.lightBorder),

            // Items List
            Expanded(
              child: items.isEmpty
                  ? Center(
                      child: Text(
                        'No matching items found',
                        style: GoogleFonts.inter(
                          color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                        ),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: items.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                            borderRadius: AppRadius.sm,
                            border: Border.all(
                              color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                              width: 0.8,
                            ),
                          ),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: AppRadius.sm,
                                child: Image.network(
                                  item.imageUrl,
                                  width: 56,
                                  height: 56,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, _, _) => Container(
                                    width: 56,
                                    height: 56,
                                    color: Colors.grey.withValues(alpha: 0.2),
                                    child: const Icon(Icons.image_not_supported_rounded, size: 24),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: AppColors.primary.withValues(alpha: 0.15),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: Text(
                                            item.category.label,
                                            style: GoogleFonts.inter(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.primary,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          'Unit: ${item.uom.symbol}',
                                          style: GoogleFonts.inter(
                                            fontSize: 10,
                                            color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      item.name,
                                      style: GoogleFonts.inter(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      item.technicalSpecs,
                                      style: GoogleFonts.inter(
                                        fontSize: 11,
                                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '₹${item.sellingRate.toStringAsFixed(0)} / ${item.uom.symbol}',
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.success,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  ElevatedButton(
                                    onPressed: () {
                                      widget.onItemSelected(item);
                                      Navigator.of(context).pop();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primary,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                      visualDensity: VisualDensity.compact,
                                      textStyle: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600),
                                    ),
                                    child: const Text('+ Add Item'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
