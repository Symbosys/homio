import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../models/quotation_models.dart';
import '../models/quotation_mock_data.dart';
import '../widgets/quotation_header.dart';
import '../widgets/quotation_metric_card.dart';
import '../widgets/item_master_form_modal.dart';

/// Screen 2: Centralized Item & Rate Master Catalogue Management (PRD Section 9.1 & 17.2).
class QuotationItemMasterPage extends StatefulWidget {
  const QuotationItemMasterPage({super.key});

  @override
  State<QuotationItemMasterPage> createState() => _QuotationItemMasterPageState();
}

class _QuotationItemMasterPageState extends State<QuotationItemMasterPage> {
  late List<ItemMasterEntry> _items;
  String _searchQuery = '';
  ItemCategory? _selectedCategory;
  UnitOfMeasurement? _selectedUom;

  @override
  void initState() {
    super.initState();
    _items = List.from(QuotationMockData.masterItems);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isMobile = MediaQuery.of(context).size.width < 768;

    final filteredItems = _items.where((item) {
      final matchesCat = _selectedCategory == null || item.category == _selectedCategory;
      final matchesUom = _selectedUom == null || item.uom == _selectedUom;
      final matchesSearch = _searchQuery.isEmpty ||
          item.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.technicalSpecs.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.approvedBrands.any((b) => b.toLowerCase().contains(_searchQuery.toLowerCase()));
      return matchesCat && matchesUom && matchesSearch;
    }).toList();

    // Metrics calculations
    final totalItems = _items.length;
    final avgMargin = _items.isEmpty ? 0.0 : _items.fold(0.0, (sum, i) => sum + i.marginPercent) / totalItems;
    final activeCount = _items.where((i) => i.isActive).length;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            QuotationHeader(
              title: 'Centralized Item & Rate Master Catalogue',
              subtitle: 'Architectural specifications, base costing, dynamic markup cards & approved brands',
              icon: Icons.inventory_2_rounded,
              primaryAction: ElevatedButton.icon(
                onPressed: () => _openAddEditModal(context),
                icon: const Icon(Icons.add_box_rounded, size: 16),
                label: const Text('Add Catalogue Item'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
                  textStyle: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ),
              onRefresh: () {
                setState(() => _items = List.from(QuotationMockData.masterItems));
              },
            ),

            // KPI Metrics Row
            LayoutBuilder(
              builder: (context, constraints) {
                final isNarrow = constraints.maxWidth < 640;
                final isMedium = constraints.maxWidth < 1024;
                final crossAxisCount = isNarrow ? 2 : (isMedium ? 2 : 4);

                return GridView.count(
                  crossAxisCount: crossAxisCount,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: isNarrow ? 1.6 : 2.2,
                  children: [
                    QuotationMetricCard(
                      title: 'TOTAL CATALOGUE ITEMS',
                      value: '$totalItems Items',
                      subtitle: '$activeCount active for quotation',
                      icon: Icons.category_rounded,
                      accentColor: AppColors.primary,
                      changePercent: '+12.4%',
                    ),
                    QuotationMetricCard(
                      title: 'AVERAGE PROFIT MARGIN',
                      value: '${avgMargin.toStringAsFixed(1)}%',
                      subtitle: 'Across all trade categories',
                      icon: Icons.trending_up_rounded,
                      accentColor: AppColors.success,
                      changePercent: '+2.1%',
                    ),
                    QuotationMetricCard(
                      title: 'ARCHITECTURAL TRADES',
                      value: '${ItemCategory.values.length} Disciplines',
                      subtitle: 'Civil, Woodwork, Modular, MEP',
                      icon: Icons.architecture_rounded,
                      accentColor: AppColors.secondary,
                    ),
                    QuotationMetricCard(
                      title: 'RATE CARD INTEGRITY',
                      value: '100% Synced',
                      subtitle: 'Directly linked to quotation engine',
                      icon: Icons.verified_rounded,
                      accentColor: AppColors.accent,
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 16),

            // Search & Filter Controls
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                borderRadius: AppRadius.md,
                border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder, width: 0.8),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          onChanged: (val) => setState(() => _searchQuery = val),
                          decoration: InputDecoration(
                            hintText: 'Search items by name, specification, brand (Century, Hafele, Kajaria)...',
                            prefixIcon: const Icon(Icons.search_rounded, size: 18),
                            filled: true,
                            fillColor: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                            border: OutlineInputBorder(borderRadius: AppRadius.sm, borderSide: BorderSide.none),
                            contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                          ),
                        ),
                      ),
                      if (!isMobile) ...[
                        const SizedBox(width: 12),
                        _buildUomFilterDropdown(isDark),
                      ],
                    ],
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
            const SizedBox(height: 16),

            // Master Items Table or Mobile List
            if (filteredItems.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(48),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                  borderRadius: AppRadius.md,
                ),
                child: Center(
                  child: Column(
                    children: [
                      Icon(Icons.inventory_2_outlined, size: 48, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                      const SizedBox(height: 12),
                      Text('No catalogue items match your filters.', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 6),
                      Text('Try adjusting your search keywords or category filters.', style: GoogleFonts.inter(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                ),
              )
            else if (isMobile)
              _buildMobileCardList(isDark, filteredItems)
            else
              _buildDesktopTable(isDark, filteredItems),
          ],
        ),
      ),
    );
  }

  Widget _buildUomFilterDropdown(bool isDark) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
        borderRadius: AppRadius.sm,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<UnitOfMeasurement?>(
          value: _selectedUom,
          hint: Text('Filter by UOM', style: GoogleFonts.inter(fontSize: 12)),
          icon: const Icon(Icons.tune_rounded, size: 16),
          style: GoogleFonts.inter(fontSize: 12, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
          dropdownColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          items: [
            const DropdownMenuItem(value: null, child: Text('All Units')),
            ...UnitOfMeasurement.values.map((u) => DropdownMenuItem(value: u, child: Text('${u.symbol} (${u.label})'))),
          ],
          onChanged: (val) => setState(() => _selectedUom = val),
        ),
      ),
    );
  }

  Widget _buildDesktopTable(bool isDark, List<ItemMasterEntry> items) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: AppRadius.md,
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder, width: 0.8),
      ),
      child: ClipRRect(
        borderRadius: AppRadius.md,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columnSpacing: 24,
            horizontalMargin: 16,
            headingRowHeight: 44,
            dataRowMinHeight: 64,
            dataRowMaxHeight: 72,
            headingRowColor: WidgetStateProperty.all(isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle),
            headingTextStyle: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
            ),
            columns: const [
              DataColumn(label: Text('ITEM CODE & NAME')),
              DataColumn(label: Text('CATEGORY')),
              DataColumn(label: Text('SPECIFICATION & BRANDS')),
              DataColumn(label: Text('UOM')),
              DataColumn(label: Text('BASE COST')),
              DataColumn(label: Text('MARGIN')),
              DataColumn(label: Text('SELLING RATE')),
              DataColumn(label: Text('STATUS')),
              DataColumn(label: Text('ACTIONS')),
            ],
            rows: items.map((item) {
              return DataRow(
                cells: [
                  DataCell(
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: AppRadius.sm,
                          child: Image.network(
                            item.imageUrl,
                            width: 44,
                            height: 44,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) => Container(
                              width: 44,
                              height: 44,
                              color: Colors.grey.withValues(alpha: 0.2),
                              child: const Icon(Icons.image_not_supported_rounded, size: 20),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              item.name,
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                              ),
                            ),
                            Text(
                              item.id,
                              style: GoogleFonts.inter(fontSize: 10, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  DataCell(
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        item.category.label,
                        style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.primary),
                      ),
                    ),
                  ),
                  DataCell(
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 260),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            item.technicalSpecs,
                            style: GoogleFonts.inter(fontSize: 11, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            'Brands: ${item.approvedBrands.join(", ")}',
                            style: GoogleFonts.inter(fontSize: 10, color: AppColors.secondaryLight, fontWeight: FontWeight.w500),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                  DataCell(
                    Text(
                      item.uom.symbol,
                      style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700),
                    ),
                  ),
                  DataCell(
                    Text(
                      '₹${item.baseCostRate.toStringAsFixed(0)}',
                      style: GoogleFonts.inter(fontSize: 12, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                    ),
                  ),
                  DataCell(
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.success.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '${item.marginPercent.toStringAsFixed(0)}%',
                        style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.success),
                      ),
                    ),
                  ),
                  DataCell(
                    Text(
                      '₹${item.sellingRate.toStringAsFixed(0)}',
                      style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.success),
                    ),
                  ),
                  DataCell(
                    Switch(
                      value: item.isActive,
                      activeThumbColor: AppColors.primary,
                      onChanged: (val) {
                        _toggleItemActive(item, val);
                      },
                    ),
                  ),
                  DataCell(
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit_note_rounded, size: 18, color: AppColors.primary),
                          onPressed: () => _openAddEditModal(context, item: item),
                          tooltip: 'Edit Item',
                          splashRadius: 16,
                        ),
                        IconButton(
                          icon: const Icon(Icons.copy_rounded, size: 16),
                          onPressed: () => _duplicateItem(item),
                          tooltip: 'Duplicate Item',
                          splashRadius: 16,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildMobileCardList(bool isDark, List<ItemMasterEntry> items) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (context, idx) {
        final item = items[idx];
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
            borderRadius: AppRadius.md,
            border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder, width: 0.8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: AppRadius.sm,
                    child: Image.network(
                      item.imageUrl,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => Container(width: 50, height: 50, color: Colors.grey.withValues(alpha: 0.2)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.name, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700)),
                        Text('${item.category.label} • ${item.uom.symbol}', style: GoogleFonts.inter(fontSize: 11, color: Colors.grey)),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit_note_rounded, size: 20, color: AppColors.primary),
                    onPressed: () => _openAddEditModal(context, item: item),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(item.technicalSpecs, style: GoogleFonts.inter(fontSize: 11, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Cost: ₹${item.baseCostRate.toStringAsFixed(0)} (+${item.marginPercent.toStringAsFixed(0)}%)', style: GoogleFonts.inter(fontSize: 11)),
                  Text(
                    '₹${item.sellingRate.toStringAsFixed(0)} / ${item.uom.symbol}',
                    style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.success),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _openAddEditModal(BuildContext context, {ItemMasterEntry? item}) {
    showDialog(
      context: context,
      builder: (ctx) => ItemMasterFormModal(
        initialItem: item,
        onSave: (savedItem) {
          setState(() {
            final idx = _items.indexWhere((i) => i.id == savedItem.id);
            if (idx >= 0) {
              _items[idx] = savedItem;
            } else {
              _items.insert(0, savedItem);
            }
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${savedItem.name} saved in Catalogue!'),
              backgroundColor: AppColors.success,
            ),
          );
        },
      ),
    );
  }

  void _duplicateItem(ItemMasterEntry item) {
    final duplicated = item.copyWith(
      id: 'ITM-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      name: '${item.name} (Copy)',
    );
    setState(() => _items.insert(0, duplicated));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Duplicated ${item.name}'), backgroundColor: AppColors.primary),
    );
  }

  void _toggleItemActive(ItemMasterEntry item, bool val) {
    final idx = _items.indexOf(item);
    if (idx >= 0) {
      setState(() => _items[idx] = item.copyWith(isActive: val));
    }
  }
}
