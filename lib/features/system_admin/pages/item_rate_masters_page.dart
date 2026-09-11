import 'package:flutter/material.dart';
import '../../../core/responsive/breakpoints.dart';
import '../../../core/theme/app_colors.dart';
import '../models/admin_models.dart';
import '../models/admin_mock_data.dart';
import '../widgets/admin_shared_widgets.dart';

class ItemRateMastersPage extends StatefulWidget {
  const ItemRateMastersPage({super.key});

  @override
  State<ItemRateMastersPage> createState() => _ItemRateMastersPageState();
}

class _ItemRateMastersPageState extends State<ItemRateMastersPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // State
  List<RateMasterItem> _items = [];
  RateMasterItem? _selectedItemDetail;
  bool _isCreateItemModalOpen = false;

  // Filters & Search
  String _searchQuery = '';
  String? _selectedCategoryFilter;
  RateUnitBasis? _selectedUnitFilter;
  bool? _statusFilter;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _items = List.from(AdminMockData.rateItems);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<RateMasterItem> get _filteredItems {
    return _items.where((itm) {
      if (_selectedCategoryFilter != null && itm.category != _selectedCategoryFilter) {
        return false;
      }
      if (_selectedUnitFilter != null && itm.unit != _selectedUnitFilter) {
        return false;
      }
      if (_statusFilter != null && itm.isActive != _statusFilter) {
        return false;
      }
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final match = itm.itemName.toLowerCase().contains(q) ||
            itm.itemCode.toLowerCase().contains(q) ||
            itm.brand.toLowerCase().contains(q) ||
            itm.subCategory.toLowerCase().contains(q);
        if (!match) return false;
      }
      return true;
    }).toList();
  }

  List<RateHistoryEntry> get _allRateHistoryEntries {
    final list = <RateHistoryEntry>[];
    for (final itm in _items) {
      list.addAll(itm.rateHistory);
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isMobile = Breakpoints.isMobile(context);

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Header
                AdminHeader(
                  title: 'Item & Rate Masters',
                  description: 'Manage standard commercial catalog, technical specifications, material-labor rates, and scheduled quotation pricing.',
                  icon: Icons.table_chart_rounded,
                  breadcrumbs: const ['Homio Administration', 'Platform Configuration', 'Item / Rate Masters'],
                  actions: [
                    OutlinedButton.icon(
                      onPressed: () => _exportRateCard(),
                      icon: const Icon(Icons.file_download_outlined, size: 16),
                      label: const Text('Export Master BOQ', style: TextStyle(fontSize: 13)),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => setState(() => _isCreateItemModalOpen = true),
                      icon: const Icon(Icons.add_shopping_cart_rounded, size: 16),
                      label: const Text('New Catalog Item', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ],
                ),

                // 2. Metrics Summary
                AdminSummaryCards(
                  metrics: [
                    AdminMetricItem(
                      label: 'Master Catalog Items',
                      value: '${_items.length}',
                      subtitle: '7 Category Clusters',
                      icon: Icons.inventory_2_outlined,
                      color: AppColors.primary,
                    ),
                    AdminMetricItem(
                      label: 'Average Gross Margin',
                      value: '26.8%',
                      subtitle: 'Target: 25% - 30%',
                      icon: Icons.trending_up_rounded,
                      color: AppColors.success,
                      trendText: '+1.4%',
                      isPositiveTrend: true,
                    ),
                    AdminMetricItem(
                      label: 'Active Quotations Linked',
                      value: '609 Live Proposals',
                      subtitle: 'Immutable historical rates',
                      icon: Icons.fact_check_outlined,
                      color: AppColors.secondary,
                    ),
                    AdminMetricItem(
                      label: 'Scheduled Rate Changes',
                      value: '1 Upcoming',
                      subtitle: 'Q4 Tariff Escalations',
                      icon: Icons.schedule_rounded,
                      color: AppColors.warning,
                    ),
                  ],
                ),

                // 3. Navigation Tabs
                Container(
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                    border: Border(
                      bottom: BorderSide(
                        color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                      ),
                    ),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    onTap: (index) => setState(() {}),
                    labelColor: AppColors.primary,
                    unselectedLabelColor: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                    indicatorColor: AppColors.primary,
                    indicatorWeight: 2.5,
                    labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                    tabs: const [
                      Tab(icon: Icon(Icons.list_alt_rounded, size: 18), text: 'Commercial Rate Catalogue'),
                      Tab(icon: Icon(Icons.history_rounded, size: 18), text: 'Rate Change History & Audit Logs'),
                    ],
                  ),
                ),

                // 4. Tab Views
                if (_tabController.index == 0)
                  _buildCatalogueTab(isDark, isMobile),
                if (_tabController.index == 1)
                  _buildRateHistoryTab(isDark),
              ],
            ),
          ),

          // Detail Drawer
          if (_selectedItemDetail != null)
            Positioned(
              top: 0,
              bottom: 0,
              right: 0,
              child: _buildItemDetailDrawer(isDark),
            ),

          // Create Item Modal
          if (_isCreateItemModalOpen)
            _buildCreateItemModal(isDark),
        ],
      ),
    );
  }

  // ==========================================================================
  // TAB 1: COMMERCIAL CATALOGUE
  // ==========================================================================
  Widget _buildCatalogueTab(bool isDark, bool isMobile) {
    final list = _filteredItems;

    return Column(
      children: [
        // Filter Bar
        AdminFilterBar(
          searchQuery: _searchQuery,
          onSearchChanged: (q) => setState(() => _searchQuery = q),
          searchHint: 'Search catalog by SKU, item name, brand, subcategory...',
          filterControls: [
            DropdownButton<String?>(
              value: _selectedCategoryFilter,
              hint: const Text('Category', style: TextStyle(fontSize: 12)),
              underline: const SizedBox(),
              items: [
                const DropdownMenuItem(value: null, child: Text('All Categories', style: TextStyle(fontSize: 12))),
                for (final cat in _items.map((e) => e.category).toSet())
                  DropdownMenuItem(value: cat, child: Text(cat, style: const TextStyle(fontSize: 12))),
              ],
              onChanged: (val) => setState(() => _selectedCategoryFilter = val),
            ),
            DropdownButton<RateUnitBasis?>(
              value: _selectedUnitFilter,
              hint: const Text('Unit', style: TextStyle(fontSize: 12)),
              underline: const SizedBox(),
              items: [
                const DropdownMenuItem(value: null, child: Text('All Units', style: TextStyle(fontSize: 12))),
                for (final u in RateUnitBasis.values)
                  DropdownMenuItem(value: u, child: Text(u.label, style: const TextStyle(fontSize: 12))),
              ],
              onChanged: (val) => setState(() => _selectedUnitFilter = val),
            ),
          ],
        ),

        // Table
        Container(
          margin: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                    headingRowColor: WidgetStateProperty.all(
                      isDark ? AppColors.darkBackground : AppColors.lightSurfaceSubtle,
                    ),
                    dataRowMinHeight: 52,
                    dataRowMaxHeight: 62,
                    columns: const [
                      DataColumn(label: Text('Item & Specifications', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12))),
                      DataColumn(label: Text('SKU / Code', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12))),
                      DataColumn(label: Text('Category & Brand', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12))),
                      DataColumn(label: Text('Unit Basis', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12))),
                      DataColumn(label: Text('Base Cost (Mat + Lab)', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12))),
                      DataColumn(label: Text('Selling Rate', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12))),
                      DataColumn(label: Text('Gross Margin', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12))),
                      DataColumn(label: Text('Live Usages', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12))),
                      DataColumn(label: Text('Actions', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12))),
                    ],
                    rows: list.map((item) {
                      return DataRow(
                        cells: [
                          // Item Name & Image
                          DataCell(
                            InkWell(
                              onTap: () => setState(() => _selectedItemDetail = item),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      item.imageUrl,
                                      width: 44,
                                      height: 44,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) => Container(
                                        width: 44,
                                        height: 44,
                                        color: AppColors.primary.withValues(alpha: 0.1),
                                        child: const Icon(Icons.image_outlined, size: 20, color: AppColors.primary),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  ConstrainedBox(
                                    constraints: const BoxConstraints(maxWidth: 240),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          item.itemName,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                                        ),
                                        Text(
                                          item.shortDescription,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(fontSize: 11, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // SKU
                          DataCell(
                            Text(item.itemCode, style: const TextStyle(fontSize: 11, fontFamily: 'monospace', fontWeight: FontWeight.bold)),
                          ),
                          // Category & Brand
                          DataCell(
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(item.category, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                                Text(item.brand, style: TextStyle(fontSize: 11, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
                              ],
                            ),
                          ),
                          // Unit Basis
                          DataCell(
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: isDark ? AppColors.darkBackground : AppColors.lightSurfaceSubtle,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(item.unit.label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                            ),
                          ),
                          // Base Cost
                          DataCell(
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('₹${item.totalBaseCost.toStringAsFixed(0)}', style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold)),
                                Text('₹${item.baseMaterialCost.toStringAsFixed(0)} mat + ₹${item.baseLaborCost.toStringAsFixed(0)} lab', style: TextStyle(fontSize: 10, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
                              ],
                            ),
                          ),
                          // Selling Rate
                          DataCell(
                            Text('₹${item.sellingRate.toStringAsFixed(0)}', style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, color: AppColors.primary)),
                          ),
                          // Margin
                          DataCell(
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2.5),
                              decoration: BoxDecoration(
                                color: AppColors.success.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text('${item.grossMarginPercentage.toStringAsFixed(1)}%', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.success)),
                            ),
                          ),
                          // Usages
                          DataCell(
                            Tooltip(
                              message: 'Referenced in ${item.quotationReferencesCount} quotations and ${item.activeCataloguesCount} active catalogues.',
                              child: Text('${item.quotationReferencesCount} quotes', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                            ),
                          ),
                          // Actions
                          DataCell(
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.visibility_outlined, size: 18),
                                  tooltip: 'View Full Spec Sheet & Pricing Breakdown',
                                  onPressed: () => setState(() => _selectedItemDetail = item),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.price_change_outlined, size: 18, color: AppColors.primary),
                                  tooltip: 'Update Rate (Preserves Historical Quotes)',
                                  onPressed: () => _showUpdateRateDialog(item),
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
        // removed extra bracket
      ],
    );
  }

  // ==========================================================================
  // TAB 2: RATE CHANGE AUDIT LOG
  // ==========================================================================
  Widget _buildRateHistoryTab(bool isDark) {
    final logs = _allRateHistoryEntries;

    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Commercial Rate Audit Trail', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)),
          Text('Historical record of pricing revisions. Note: Historical quotations strictly retain the rates active at proposal creation.', style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: logs.length,
              itemBuilder: (context, index) {
                final entry = logs[index];
                final item = _items.firstWhere((i) => i.id == entry.itemId);

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                  ),
                  color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.currency_rupee_rounded, color: AppColors.primary, size: 20),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.itemName, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Text('₹${entry.previousRate.toStringAsFixed(0)}', style: TextStyle(fontSize: 12, decoration: TextDecoration.lineThrough, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
                                  const SizedBox(width: 6),
                                  const Icon(Icons.arrow_forward_rounded, size: 14, color: AppColors.success),
                                  const SizedBox(width: 6),
                                  Text('₹${entry.newRate.toStringAsFixed(0)}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.success)),
                                  const SizedBox(width: 14),
                                  Text('Effective: ${entry.effectiveDate.day}/${entry.effectiveDate.month}/${entry.effectiveDate.year}', style: TextStyle(fontSize: 11, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text('Reason: ${entry.reason}', style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            AdminStatusBadge(label: entry.status, color: AppColors.success),
                            const SizedBox(height: 6),
                            Text('By ${entry.changedBy}', style: TextStyle(fontSize: 11, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  // ==========================================================================
  // ITEM DETAIL DRAWER
  // ==========================================================================
  Widget _buildItemDetailDrawer(bool isDark) {
    final item = _selectedItemDetail!;

    return AdminDrawerLayout(
      title: item.itemName,
      subtitle: '${item.itemCode} • ${item.category} (${item.brand})',
      onClose: () => setState(() => _selectedItemDetail = null),
      footerActions: [
        OutlinedButton(
          onPressed: () {
            setState(() => _selectedItemDetail = null);
            _showUpdateRateDialog(item);
          },
          child: const Text('Schedule Rate Revision'),
        ),
      ],
      child: DefaultTabController(
        length: 4,
        child: Column(
          children: [
            TabBar(
              labelColor: AppColors.primary,
              unselectedLabelColor: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
              indicatorColor: AppColors.primary,
              labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              tabs: const [
                Tab(text: 'Overview & Pricing'),
                Tab(text: 'Technical Specs'),
                Tab(text: 'Rate History'),
                Tab(text: 'Live Usages (609)'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  // Overview & Pricing Tab
                  ListView(
                    padding: const EdgeInsets.all(20),
                    children: [
                      _buildDrawerRow('Selling Rate', '₹${item.sellingRate.toStringAsFixed(0)} / ${item.unit.label}', isDark, isHighlighted: true),
                      _buildDrawerRow('Base Material Cost', '₹${item.baseMaterialCost.toStringAsFixed(0)}', isDark),
                      _buildDrawerRow('Contractor Labor Rate', '₹${item.baseLaborCost.toStringAsFixed(0)}', isDark),
                      _buildDrawerRow('Total Internal Base Cost', '₹${item.totalBaseCost.toStringAsFixed(0)}', isDark),
                      _buildDrawerRow('Active Gross Margin', '${item.grossMarginPercentage.toStringAsFixed(1)}% (${item.marginType.label})', isDark),
                      _buildDrawerRow('Tax GST Rate', '${item.taxGstPercent.toStringAsFixed(0)}% (Standard Construction Tax)', isDark),
                      _buildDrawerRow('Discount Eligibility', item.discountEligible ? 'Eligible (Up to 7% with VP approval)' : 'Strict Zero Discount Floor', isDark),
                      const Divider(height: 24),
                      Text('Detailed Description', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)),
                      const SizedBox(height: 6),
                      Text(item.detailedDescription, style: TextStyle(fontSize: 12.5, height: 1.4, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
                    ],
                  ),
                  // Technical Specs Tab
                  ListView(
                    padding: const EdgeInsets.all(20),
                    children: [
                      _buildDrawerRow('Material', item.specs.material, isDark),
                      _buildDrawerRow('Core Material', item.specs.coreMaterial, isDark),
                      _buildDrawerRow('Surface Finish', item.specs.finish, isDark),
                      _buildDrawerRow('Thickness', item.specs.thickness, isDark),
                      _buildDrawerRow('Dimensions Matrix', item.specs.dimensions, isDark),
                      _buildDrawerRow('Hardware Compatibility', item.specs.hardware, isDark),
                      _buildDrawerRow('Manufacturer Brand', item.specs.brand, isDark),
                      _buildDrawerRow('Certification Grade', item.specs.grade, isDark),
                      _buildDrawerRow('Color / Shade', item.specs.color, isDark),
                      _buildDrawerRow('Warranty Coverage', item.specs.warrantyPeriod, isDark),
                      _buildDrawerRow('Technical Execution Notes', item.specs.technicalNotes, isDark),
                    ],
                  ),
                  // Rate History Tab
                  ListView(
                    padding: const EdgeInsets.all(20),
                    children: [
                      for (final h in item.rateHistory)
                        Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.darkBackground : AppColors.lightSurfaceSubtle,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Revised to ₹${h.newRate.toStringAsFixed(0)} (from ₹${h.previousRate.toStringAsFixed(0)})', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                              Text('Effective: ${h.effectiveDate.day}/${h.effectiveDate.month}/${h.effectiveDate.year} • By ${h.changedBy}', style: TextStyle(fontSize: 11, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
                              Text('Reason: ${h.reason}', style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
                            ],
                          ),
                        ),
                      if (item.rateHistory.isEmpty)
                        Text('No prior rate changes recorded. Currently at initial baseline launch pricing.', style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
                    ],
                  ),
                  // Live Usages Tab
                  ListView(
                    padding: const EdgeInsets.all(20),
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
                        ),
                        child: const Text(
                          'Operational Immutable Rule:\nWhen pricing changes occur, all 609 existing historical quotations retain the exact rate stamped at the time of quotation generation.',
                          style: TextStyle(fontSize: 12, height: 1.35, color: AppColors.primary, fontWeight: FontWeight.w600),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text('Active Quotation Proposals (Latest 5)', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)),
                      const SizedBox(height: 8),
                      _buildUsageItem('HOM-QTE-8924', 'Ananya Roy (3BHK HSR Layout)', '₹2,350/sq.ft. applied', 'Sent 2d ago'),
                      _buildUsageItem('HOM-QTE-8919', 'Rohan Mehra (Villa 14, Prestige Golfshire)', '₹2,350/sq.ft. applied', 'Approved'),
                      _buildUsageItem('HOM-QTE-8890', 'Deepika Padukone Flat (Worli)', '₹2,150/sq.ft. applied (Historical)', 'Signed Advance'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerRow(String label, String value, bool isDark, {bool isHighlighted = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 170,
            child: Text(label, style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: isHighlighted ? 15 : 12.5,
                fontWeight: isHighlighted ? FontWeight.bold : FontWeight.w600,
                color: isHighlighted ? AppColors.primary : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUsageItem(String code, String client, String rate, String status) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.lightSurfaceSubtle,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(code, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              Text(client, style: const TextStyle(fontSize: 11, color: Colors.grey)),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(rate, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primary)),
              Text(status, style: const TextStyle(fontSize: 10, color: AppColors.success)),
            ],
          ),
        ],
      ),
    );
  }

  void _showUpdateRateDialog(RateMasterItem item) {
    final newRateCtrl = TextEditingController(text: '${item.sellingRate + 100}');
    final reasonCtrl = TextEditingController(text: 'Scheduled quarterly vendor raw material cost escalation');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Schedule Rate Revision: ${item.itemName}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Current Selling Rate: ₹${item.sellingRate.toStringAsFixed(0)} / ${item.unit.label}', style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            TextField(controller: newRateCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'New Selling Rate (₹) *', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            TextField(controller: reasonCtrl, decoration: const InputDecoration(labelText: 'Reason for Price Change *', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            const Text(
              '⚠️ Immutable Protection Note: Prior quotations will NOT be altered. Only future quotations created after the effective date will apply this rate.',
              style: TextStyle(fontSize: 11, color: AppColors.warning, height: 1.3),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final newRate = double.tryParse(newRateCtrl.text);
              if (newRate != null) {
                setState(() {
                  final idx = _items.indexWhere((i) => i.id == item.id);
                  if (idx != -1) {
                    final newHistory = List<RateHistoryEntry>.from(_items[idx].rateHistory)
                      ..add(
                        RateHistoryEntry(
                          id: 'rh_${DateTime.now().millisecondsSinceEpoch}',
                          itemId: item.id,
                          previousRate: item.sellingRate,
                          newRate: newRate,
                          effectiveDate: DateTime.now(),
                          changedBy: 'Pooja Agarwal (CA)',
                          reason: reasonCtrl.text,
                          status: 'Applied',
                        ),
                      );
                    _items[idx] = _items[idx].copyWith(
                      sellingRate: newRate,
                      rateHistory: newHistory,
                      lastUpdated: DateTime.now(),
                    );
                    if (_selectedItemDetail?.id == item.id) {
                      _selectedItemDetail = _items[idx];
                    }
                  }
                });
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Rate updated to ₹${newRate.toStringAsFixed(0)} successfully.'), backgroundColor: AppColors.success),
                );
              }
            },
            child: const Text('Confirm & Apply Rate'),
          ),
        ],
      ),
    );
  }

  Widget _buildCreateItemModal(bool isDark) {
    final nameCtrl = TextEditingController();
    final skuCtrl = TextEditingController(text: 'WD-NEW-01');
    final catCtrl = TextEditingController(text: 'Modular Woodwork');
    final brandCtrl = TextEditingController(text: 'CenturyPly / Hafele');
    final matCostCtrl = TextEditingController(text: '1200');
    final labCostCtrl = TextEditingController(text: '350');
    final sellRateCtrl = TextEditingController(text: '2100');

    return Container(
      color: Colors.black.withValues(alpha: 0.5),
      alignment: Alignment.center,
      child: Material(
        color: Colors.transparent,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: 680,
            maxHeight: MediaQuery.of(context).size.height * 0.9,
          ),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 25)],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Add New Commercial Catalog Item', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)),
                  IconButton(onPressed: () => setState(() => _isCreateItemModalOpen = false), icon: const Icon(Icons.close_rounded)),
                ],
              ),
              const Divider(),
              Expanded(
                child: ListView(
                  children: [
                    TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Item Name *', border: OutlineInputBorder())),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(child: TextField(controller: skuCtrl, decoration: const InputDecoration(labelText: 'SKU / Code *', border: OutlineInputBorder()))),
                        const SizedBox(width: 12),
                        Expanded(child: TextField(controller: catCtrl, decoration: const InputDecoration(labelText: 'Category *', border: OutlineInputBorder()))),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextField(controller: brandCtrl, decoration: const InputDecoration(labelText: 'Preferred Brand / Manufacturer', border: OutlineInputBorder())),
                    const SizedBox(height: 16),
                    Text('Commercial Pricing Foundation', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(child: TextField(controller: matCostCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Material Base Cost (₹) *', border: OutlineInputBorder()))),
                        const SizedBox(width: 12),
                        Expanded(child: TextField(controller: labCostCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Labor Rate (₹) *', border: OutlineInputBorder()))),
                        const SizedBox(width: 12),
                        Expanded(child: TextField(controller: sellRateCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Selling Rate (₹) *', border: OutlineInputBorder()))),
                      ],
                    ),
                  ],
                ),
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(onPressed: () => setState(() => _isCreateItemModalOpen = false), child: const Text('Cancel')),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () {
                      if (nameCtrl.text.isEmpty) return;
                      final matCost = double.tryParse(matCostCtrl.text) ?? 1000;
                      final labCost = double.tryParse(labCostCtrl.text) ?? 300;
                      final sellRate = double.tryParse(sellRateCtrl.text) ?? 1800;

                      final newItem = RateMasterItem(
                        id: 'itm_${DateTime.now().millisecondsSinceEpoch}',
                        itemCode: skuCtrl.text,
                        itemName: nameCtrl.text,
                        category: catCtrl.text,
                        subCategory: 'Custom Built',
                        brand: brandCtrl.text,
                        modelVariant: 'Standard Tier 1',
                        shortDescription: 'Configured catalog master item.',
                        detailedDescription: 'Commercial item for quotation estimation.',
                        imageUrl: 'https://images.unsplash.com/photo-1556911220-e15b29be8c8f?w=300',
                        unit: RateUnitBasis.sqFt,
                        specs: const TechSpecifications(
                          material: 'Engineered Wood & Laminate',
                          coreMaterial: 'IS:710 Marine Hardwood',
                          finish: 'Matte Finish',
                          thickness: '18mm',
                          dimensions: 'Custom',
                          hardware: 'Hafele Soft-Close',
                          brand: 'CenturyPly',
                          grade: 'First Quality',
                          color: 'Custom Choice',
                          warrantyPeriod: '10 Years',
                          technicalNotes: 'Standard site preparation required',
                        ),
                        baseMaterialCost: matCost,
                        baseLaborCost: labCost,
                        sellingRate: sellRate,
                        marginValue: 25.0,
                        effectiveFrom: DateTime.now(),
                        lastUpdated: DateTime.now(),
                      );

                      setState(() {
                        _items.insert(0, newItem);
                        _isCreateItemModalOpen = false;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Item created and added to quotation backend.'), backgroundColor: AppColors.success),
                      );
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
                    child: const Text('Save & Publish to BOQ'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _exportRateCard() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Master BOQ Rate Card exported to Excel with material/labor breakdown.')),
    );
  }
}
