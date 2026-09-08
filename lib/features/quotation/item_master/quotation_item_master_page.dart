import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../models/quotation_models.dart';
import '../models/quotation_mock_data.dart';
import '../widgets/empty_state.dart';
import '../widgets/item_master_form_modal.dart';
import '../widgets/quotation_header.dart';
import '../widgets/quotation_metric_card.dart';
import '../widgets/rate_card_manager.dart';

/// Screen 3: Centralized Item & Rate Master Catalogue Management (PRD Section 30).
/// Features: 3 Sub-tabs (Catalogue Items, Named Rate Cards, Rate Change Audit Trail).
class QuotationItemMasterPage extends StatefulWidget {
  const QuotationItemMasterPage({super.key});

  @override
  State<QuotationItemMasterPage> createState() => _QuotationItemMasterPageState();
}

class _QuotationItemMasterPageState extends State<QuotationItemMasterPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late List<ItemMasterEntry> _items;
  late List<RateCard> _rateCards;
  late List<RateHistoryEntry> _history;

  String _searchQuery = '';
  ItemCategory? _selectedCategory;
  UnitOfMeasurement? _selectedUom;
  bool? _activeFilter;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _items = List.from(QuotationMockData.masterItems);
    _rateCards = List.from(QuotationMockData.rateCards);
    _history = List.from(QuotationMockData.rateHistory);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<ItemMasterEntry> get _filteredItems {
    return _items.where((item) {
      if (_selectedCategory != null && item.category != _selectedCategory) return false;
      if (_selectedUom != null && item.uom != _selectedUom) return false;
      if (_activeFilter != null && item.isActive != _activeFilter) return false;

      if (_searchQuery.trim().isNotEmpty) {
        final q = _searchQuery.toLowerCase().trim();
        final matchesName = item.name.toLowerCase().contains(q);
        final matchesSku = item.sku.toLowerCase().contains(q);
        final matchesSpecs = item.technicalSpecs.toLowerCase().contains(q);
        final matchesCategory = item.category.label.toLowerCase().contains(q);
        final matchesBrands = item.approvedBrands.any((b) => b.toLowerCase().contains(q));
        final matchesTags = item.tags.any((t) => t.toLowerCase().contains(q));

        if (!matchesName && !matchesSku && !matchesSpecs && !matchesCategory && !matchesBrands && !matchesTags) {
          return false;
        }
      }
      return true;
    }).toList();
  }

  void _openAddEditModal(BuildContext context, {ItemMasterEntry? item}) {
    showDialog(
      context: context,
      builder: (ctx) => ItemMasterFormModal(
        initialItem: item,
        onSave: (saved) {
          setState(() {
            final idx = _items.indexWhere((i) => i.id == saved.id);
            if (idx != -1) {
              // Log rate history if rate changed
              if (_items[idx].baseCostRate != saved.baseCostRate) {
                _history.insert(
                  0,
                  RateHistoryEntry(
                    id: 'RH-${DateTime.now().millisecondsSinceEpoch}',
                    itemMasterId: saved.id,
                    itemName: saved.name,
                    oldBaseRate: _items[idx].baseCostRate,
                    newBaseRate: saved.baseCostRate,
                    oldSellingRate: _items[idx].sellingRate,
                    newSellingRate: saved.sellingRate,
                    changedBy: 'Arun Varma (Pricing Lead)',
                    changeReason: 'Catalogue manual rate adjustment',
                    changedAt: DateTime.now(),
                  ),
                );
              }
              _items[idx] = saved;
            } else {
              _items.insert(0, saved);
            }
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${saved.name} saved successfully'),
              backgroundColor: AppColors.success,
            ),
          );
        },
      ),
    );
  }

  void _duplicateItem(ItemMasterEntry item) {
    final newItem = item.copyWith(
      id: 'ITM-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      sku: '${item.sku}-CPY',
      name: '${item.name} (Copy)',
    );
    setState(() {
      _items.insert(0, newItem);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Item duplicated as ${newItem.name}'), backgroundColor: AppColors.primary),
    );
  }

  void _toggleItemActive(ItemMasterEntry item, bool val) {
    final idx = _items.indexWhere((i) => i.id == item.id);
    if (idx != -1) {
      setState(() {
        _items[idx] = item.copyWith(isActive: val);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // KPI Metrics
    final totalCount = _items.length;
    final activeCount = _items.where((i) => i.isActive).length;
    final avgMargin = _items.isEmpty ? 0.0 : _items.fold(0.0, (sum, i) => sum + i.marginPercent) / totalCount;
    final categoriesCount = ItemCategory.values.length;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Standard Header with Breadcrumbs & Action
            QuotationHeader(
              title: 'Centralized Item & Rate Master Catalogue',
              subtitle: 'Multi-tier pricing cards, standard architectural specifications, margins & brand approvals',
              icon: Icons.inventory_2_rounded,
              breadcrumbs: const ['Homio CRM', 'Commercials', 'Rate Master'],
              primaryAction: FilledButton.icon(
                onPressed: () => _openAddEditModal(context),
                icon: const Icon(Icons.add_box_rounded, size: 16),
                label: const Text('Add Catalogue Item'),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
                ),
              ),
              onRefresh: () {
                setState(() {
                  _items = List.from(QuotationMockData.masterItems);
                  _rateCards = List.from(QuotationMockData.rateCards);
                  _history = List.from(QuotationMockData.rateHistory);
                });
              },
            ),
            const SizedBox(height: 12),

            // KPI Metrics Row
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  SizedBox(
                    width: 170,
                    child: QuotationMetricCard(
                      title: 'TOTAL ITEMS',
                      value: '$totalCount',
                      subtitle: '$activeCount active for quotation',
                      icon: Icons.category_rounded,
                      accentColor: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                    width: 170,
                    child: QuotationMetricCard(
                      title: 'ACTIVE ITEMS',
                      value: '$activeCount',
                      subtitle: '${((activeCount / totalCount) * 100).toInt()}% catalog ready',
                      icon: Icons.check_circle_rounded,
                      accentColor: AppColors.success,
                    ),
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                    width: 170,
                    child: QuotationMetricCard(
                      title: 'AVERAGE MARGIN',
                      value: '${avgMargin.toStringAsFixed(1)}%',
                      subtitle: 'Commercial target: 25%',
                      icon: Icons.trending_up_rounded,
                      accentColor: AppColors.secondary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                    width: 170,
                    child: QuotationMetricCard(
                      title: 'CATEGORIES',
                      value: '$categoriesCount Groups',
                      subtitle: 'Full architectural scope',
                      icon: Icons.account_tree_rounded,
                      accentColor: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // Subtabs Navigation
            Container(
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                borderRadius: AppRadius.md,
                border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder, width: 0.8),
              ),
              child: TabBar(
                controller: _tabController,
                indicatorColor: AppColors.primary,
                labelColor: AppColors.primary,
                unselectedLabelColor: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                labelStyle: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700),
                tabs: const [
                  Tab(text: 'Catalogue Items & Rates'),
                  Tab(text: 'Named Rate Cards'),
                  Tab(text: 'Rate Change Audit Trail'),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Subtab Content Views
            SizedBox(
              height: 700,
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildCatalogueItemsTab(isDark),
                  _buildRateCardsTab(isDark),
                  _buildRateHistoryTab(isDark),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Subtab 1: Catalogue Items Table
  Widget _buildCatalogueItemsTab(bool isDark) {
    final items = _filteredItems;

    return Column(
      children: [
        // Search & Category Chips Filter
        Container(
          padding: const EdgeInsets.all(12),
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
                        hintText: 'Search items by SKU, name, technical spec, approved brand...',
                        prefixIcon: const Icon(Icons.search_rounded, size: 18),
                        filled: true,
                        fillColor: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                        border: OutlineInputBorder(borderRadius: AppRadius.sm, borderSide: BorderSide.none),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  DropdownButton<ItemCategory?>(
                    value: _selectedCategory,
                    underline: const SizedBox.shrink(),
                    hint: const Text('Category', style: TextStyle(fontSize: 12)),
                    items: [
                      const DropdownMenuItem(value: null, child: Text('All Categories')),
                      ...ItemCategory.values.map((c) => DropdownMenuItem(value: c, child: Text(c.label))),
                    ],
                    onChanged: (val) => setState(() => _selectedCategory = val),
                  ),
                  const SizedBox(width: 10),
                  DropdownButton<UnitOfMeasurement?>(
                    value: _selectedUom,
                    underline: const SizedBox.shrink(),
                    hint: const Text('Unit (UOM)', style: TextStyle(fontSize: 12)),
                    items: [
                      const DropdownMenuItem(value: null, child: Text('All Units')),
                      ...UnitOfMeasurement.values.map((u) => DropdownMenuItem(value: u, child: Text('${u.symbol} (${u.label})'))),
                    ],
                    onChanged: (val) => setState(() => _selectedUom = val),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Items Table
        Expanded(
          child: items.isEmpty
              ? QuotationEmptyState(
                  icon: Icons.inventory_2_rounded,
                  title: 'No catalogue items found',
                  description: 'No master items match your selected filter criteria.',
                  actionLabel: 'Add Catalogue Item',
                  onAction: () => _openAddEditModal(context),
                )
              : Container(
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                    borderRadius: AppRadius.md,
                    border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder, width: 0.8),
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SingleChildScrollView(
                      child: DataTable(
                        headingRowColor: WidgetStateProperty.all(isDark ? AppColors.darkSurfaceElevated : Colors.grey.shade50),
                        dataRowMinHeight: 56,
                        dataRowMaxHeight: 68,
                        columns: const [
                          DataColumn(label: Text('Item SKU & Name')),
                          DataColumn(label: Text('Category')),
                          DataColumn(label: Text('Unit')),
                          DataColumn(label: Text('Base Cost (₹)'), numeric: true),
                          DataColumn(label: Text('Margin %'), numeric: true),
                          DataColumn(label: Text('Selling Rate (₹)'), numeric: true),
                          DataColumn(label: Text('Approved Brands')),
                          DataColumn(label: Text('Active')),
                          DataColumn(label: Text('Actions')),
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
                                        width: 42,
                                        height: 42,
                                        fit: BoxFit.cover,
                                        errorBuilder: (ctx, err, stack) => Container(width: 42, height: 42, color: Colors.grey.shade300, child: const Icon(Icons.image_not_supported_rounded, size: 16)),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(item.name, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600)),
                                        Text(item.sku.isNotEmpty ? item.sku : 'SKU: N/A', style: GoogleFonts.inter(fontSize: 10, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              DataCell(
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: AppRadius.sm),
                                  child: Text(item.category.label, style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.primary)),
                                ),
                              ),
                              DataCell(Text(item.uom.symbol, style: GoogleFonts.inter(fontSize: 11))),
                              DataCell(Text('₹${item.baseCostRate.toStringAsFixed(0)}', style: GoogleFonts.inter(fontSize: 12))),
                              DataCell(Text('+${item.marginPercent.toStringAsFixed(1)}%', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.success))),
                              DataCell(Text('₹${item.sellingRate.toStringAsFixed(0)}', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.primary))),
                              DataCell(
                                Text(item.approvedBrands.take(2).join(', '), style: GoogleFonts.inter(fontSize: 11, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
                              ),
                              DataCell(
                                Switch(
                                  value: item.isActive,
                                  onChanged: (val) => _toggleItemActive(item, val),
                                  activeThumbColor: AppColors.primary,
                                ),
                              ),
                              DataCell(
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit_rounded, size: 16),
                                      tooltip: 'Edit Item',
                                      onPressed: () => _openAddEditModal(context, item: item),
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(),
                                    ),
                                    const SizedBox(width: 8),
                                    IconButton(
                                      icon: const Icon(Icons.content_copy_rounded, size: 16),
                                      tooltip: 'Duplicate Item',
                                      onPressed: () => _duplicateItem(item),
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(),
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
                ),
        ),
      ],
    );
  }

  // Subtab 2: Named Rate Cards
  Widget _buildRateCardsTab(bool isDark) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RateCardManager(
            rateCards: _rateCards,
            onEditRateCard: (card) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Editing item rate overrides for ${card.name}...'), backgroundColor: AppColors.primary),
              );
            },
            onSelectRateCard: (card) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${card.name} set as default active rate card.'), backgroundColor: AppColors.success),
              );
            },
          ),
        ],
      ),
    );
  }

  // Subtab 3: Rate History Audit Trail
  Widget _buildRateHistoryTab(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: AppRadius.md,
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder, width: 0.8),
      ),
      child: _history.isEmpty
          ? Center(child: Text('No rate changes recorded yet.', style: GoogleFonts.inter(fontSize: 12)))
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _history.length,
              separatorBuilder: (ctx, idx) => const Divider(height: 16),
              itemBuilder: (context, index) {
                final h = _history[index];
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), shape: BoxShape.circle),
                      child: Icon(Icons.history_rounded, size: 16, color: AppColors.primary),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(h.itemName, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700)),
                              Text('${h.changedAt.day}/${h.changedAt.month}/${h.changedAt.year}', style: GoogleFonts.inter(fontSize: 11, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text('Base Rate: ₹${h.oldBaseRate.toStringAsFixed(0)} → ₹${h.newBaseRate.toStringAsFixed(0)}  |  Selling: ₹${h.oldSellingRate.toStringAsFixed(0)} → ₹${h.newSellingRate.toStringAsFixed(0)}', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primary)),
                          const SizedBox(height: 2),
                          Text('Reason: ${h.changeReason}', style: GoogleFonts.inter(fontSize: 11, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
                          const SizedBox(height: 2),
                          Text('Author: ${h.changedBy}', style: GoogleFonts.inter(fontSize: 10, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
    );
  }
}
