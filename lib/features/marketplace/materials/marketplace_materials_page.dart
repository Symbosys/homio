import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_radius.dart';
import '../data/marketplace_repository.dart';
import '../domain/marketplace_domain_models.dart';
import '../domain/marketplace_enums.dart';
import '../widgets/marketplace_attention_panel.dart';
import '../widgets/marketplace_data_table.dart';
import '../widgets/marketplace_filter_bar.dart';
import '../widgets/marketplace_header.dart';
import '../widgets/marketplace_metric_card.dart';
import '../widgets/marketplace_status_badge.dart';
import '../widgets/material_product_form_dialog.dart';

class MarketplaceMaterialsPage extends StatefulWidget {
  const MarketplaceMaterialsPage({super.key});

  @override
  State<MarketplaceMaterialsPage> createState() => _MarketplaceMaterialsPageState();
}

class _MarketplaceMaterialsPageState extends State<MarketplaceMaterialsPage> {
  final _repo = MarketplaceRepository();
  final _searchCtrl = TextEditingController();

  String _searchQuery = '';
  String _selectedCategory = 'all';
  String _selectedBrand = 'all';
  String _selectedStatus = 'all';
  int _currentPage = 1;
  static const int _pageSize = 10;

  @override
  void initState() {
    super.initState();
    _repo.addListener(_onRepoChanged);
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _repo.removeListener(_onRepoChanged);
    super.dispose();
  }

  void _onRepoChanged() {
    if (mounted) setState(() {});
  }

  List<MaterialProductEntity> get _filteredMaterials {
    return _repo.materials.where((m) {
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final matchTitle = m.name.toLowerCase().contains(q);
        final matchSku = m.sku.toLowerCase().contains(q);
        final matchBrand = m.brandName.toLowerCase().contains(q);
        final matchDesc = m.shortDescription.toLowerCase().contains(q);
        if (!matchTitle && !matchSku && !matchBrand && !matchDesc) return false;
      }
      if (_selectedCategory != 'all' && m.categoryName.toLowerCase() != _selectedCategory.toLowerCase()) {
        return false;
      }
      if (_selectedBrand != 'all' && m.brandName.toLowerCase() != _selectedBrand.toLowerCase()) {
        return false;
      }
      if (_selectedStatus != 'all' && m.publicationStatus.name.toLowerCase() != _selectedStatus.toLowerCase()) {
        return false;
      }
      return true;
    }).toList();
  }

  void _openCreateDialog() {
    MaterialProductFormDialog.show(context);
  }

  void _openEditDialog(MaterialProductEntity material) {
    MaterialProductFormDialog.show(context, materialToEdit: material);
  }

  void _showSupplierDetails(MaterialProductEntity material) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF131722) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.lg),
        title: Row(
          children: [
            const Icon(Icons.business_rounded, color: AppColors.primary, size: 20),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                'Supplier Linkage: ${material.name}',
                style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Associated Direct Suppliers & Wholesale Contracts:', style: GoogleFonts.plusJakartaSans(fontSize: 12, color: AppColors.lightTextMuted)),
            const SizedBox(height: AppSpacing.md),
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF161F30) : const Color(0xFFF8FAFC),
                borderRadius: AppRadius.sm,
                border: Border.all(color: isDark ? const Color(0xFF262D40) : const Color(0xFFE2E8F0)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(material.primarySupplier.vendorName, style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w700)),
                            const SizedBox(width: AppSpacing.xs),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.success.withValues(alpha: 0.15),
                                borderRadius: AppRadius.xs,
                              ),
                              child: Text('PRIMARY', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700, color: AppColors.success, fontSize: 10)),
                            ),
                          ],
                        ),
                        Text('Vendor ID: ${material.primarySupplier.vendorId} • Cost Price: ₹${material.primarySupplier.supplierPrice.toStringAsFixed(0)}/${material.unitOfMeasure.label}', style: GoogleFonts.plusJakartaSans(fontSize: 11, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B))),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('${material.primarySupplier.leadTimeDays} Days SLA', style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.info)),
                      Text('${material.primarySupplier.minimumOrderQty} ${material.unitOfMeasure.label} MOQ', style: GoogleFonts.plusJakartaSans(fontSize: 11, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B))),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('Close', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600, color: AppColors.primary)),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(MaterialProductEntity material) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF131722) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.lg),
        title: Text('Delete Material SKU', style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.error)),
        content: Text(
          'Are you sure you want to delete "${material.name}" (${material.sku})? Active purchase orders will retain catalog history.',
          style: GoogleFonts.plusJakartaSans(fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('Cancel', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600, color: AppColors.lightTextMuted)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () {
              Navigator.of(ctx).pop();
              _repo.deleteMaterial(material.id);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Material SKU "${material.name}" deleted.'),
                  backgroundColor: AppColors.error,
                ),
              );
            },
            child: Text('Delete', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600, color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isDesktop = MediaQuery.of(context).size.width >= 1024;
    final allMaterials = _repo.materials;
    final activeCount = allMaterials.where((m) => m.publicationStatus == ProductPublicationStatus.published).length;
    final totalVendors = allMaterials.fold<int>(0, (sum, m) => sum + 1 + m.alternateSuppliers.length);

    final filtered = _filteredMaterials;
    final totalPages = (filtered.length / _pageSize).ceil().clamp(1, 999);
    final startIndex = (_currentPage - 1) * _pageSize;
    final paginatedItems = filtered.skip(startIndex).take(_pageSize).toList();

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            MarketplaceHeader(
              title: 'Direct Wholesale Materials Procurement',
              subtitle: 'Manage cement, TMT steel rebar, electricals, plumbing, sanitaryware & direct supplier allocations',
              icon: Icons.inventory_2_rounded,
              actions: [
                OutlinedButton.icon(
                  onPressed: () => setState(() {}),
                  icon: Icon(Icons.refresh_rounded, size: 16, color: isDark ? Colors.white : AppColors.lightTextPrimary),
                  label: Text('Refresh', style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w600, color: isDark ? Colors.white : AppColors.lightTextPrimary)),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
                    side: BorderSide(color: isDark ? const Color(0xFF262D40) : const Color(0xFFE2E8F0)),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                ElevatedButton.icon(
                  onPressed: _openCreateDialog,
                  icon: const Icon(Icons.add_box_outlined, size: 18, color: Colors.white),
                  label: Text('Add Material SKU', style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),

            // Attention Notice
            MarketplaceAttentionPanel(
              alerts: [
                MarketplaceAlertItem(
                  title: 'Wholesale Tiered Pricing Active',
                  description: 'Site project orders exceeding minimum quantities automatically receive discounted contractor procurement rates.',
                  count: activeCount,
                  icon: Icons.inventory_2_outlined,
                  severityColor: AppColors.info,
                  actionLabel: 'Vendor SLAs',
                  onAction: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Standard vendor dispatch SLA configured to 2-5 business days.'),
                        backgroundColor: AppColors.info,
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),

            // Metrics Grid
            LayoutBuilder(
              builder: (ctx, constraints) {
                final crossAxisCount = isDesktop ? 4 : (constraints.maxWidth > 600 ? 2 : 1);
                return GridView.count(
                  crossAxisCount: crossAxisCount,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: AppSpacing.md,
                  mainAxisSpacing: AppSpacing.md,
                  childAspectRatio: isDesktop ? 2.3 : 2.6,
                  children: [
                    MarketplaceMetricCard(
                      title: 'Material SKUs',
                      value: '${allMaterials.length}',
                      subtitle: '$activeCount live for contractor POs',
                      icon: Icons.inventory_2_outlined,
                      accentColor: AppColors.primary,
                    ),
                    MarketplaceMetricCard(
                      title: 'Direct Supplier Links',
                      value: '$totalVendors',
                      subtitle: 'Active certified vendor contracts',
                      icon: Icons.business_outlined,
                      accentColor: AppColors.success,
                    ),
                    MarketplaceMetricCard(
                      title: 'Avg Fulfillment SLA',
                      value: '2.4 Days',
                      subtitle: 'Direct site delivery window',
                      icon: Icons.local_shipping_outlined,
                      accentColor: AppColors.info,
                    ),
                    MarketplaceMetricCard(
                      title: 'Procurement GMV',
                      value: '₹1,240,000',
                      subtitle: 'Current quarter materials volume',
                      icon: Icons.account_balance_wallet_outlined,
                      accentColor: AppColors.warning,
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: AppSpacing.xl),

            // Filter Bar
            MarketplaceFilterBar(
              searchController: _searchCtrl,
              searchHint: 'Search materials by title, SKU, brand, specs...',
              onSearchChanged: (val) => setState(() {
                _searchQuery = val;
                _currentPage = 1;
              }),
              totalCount: filtered.length,
              entityLabel: 'Materials',
              onClear: () => setState(() {
                _searchCtrl.clear();
                _searchQuery = '';
                _selectedCategory = 'all';
                _selectedBrand = 'all';
                _selectedStatus = 'all';
                _currentPage = 1;
              }),
              filterDropdowns: [
                DropdownButton<String>(
                  value: _selectedCategory,
                  underline: const SizedBox.shrink(),
                  dropdownColor: isDark ? const Color(0xFF131722) : Colors.white,
                  items: [
                    const DropdownMenuItem(value: 'all', child: Text('All Categories')),
                    ..._repo.categories
                        .where((c) => c.marketplaceType == MarketplaceType.materials)
                        .map((c) => DropdownMenuItem(value: c.name.toLowerCase(), child: Text(c.name))),
                  ],
                  onChanged: (val) => setState(() {
                    _selectedCategory = val ?? 'all';
                    _currentPage = 1;
                  }),
                ),
                DropdownButton<String>(
                  value: _selectedBrand,
                  underline: const SizedBox.shrink(),
                  dropdownColor: isDark ? const Color(0xFF131722) : Colors.white,
                  items: [
                    const DropdownMenuItem(value: 'all', child: Text('All Brands')),
                    ..._repo.brands.map((b) => DropdownMenuItem(value: b.name.toLowerCase(), child: Text(b.name))),
                  ],
                  onChanged: (val) => setState(() {
                    _selectedBrand = val ?? 'all';
                    _currentPage = 1;
                  }),
                ),
                DropdownButton<String>(
                  value: _selectedStatus,
                  underline: const SizedBox.shrink(),
                  dropdownColor: isDark ? const Color(0xFF131722) : Colors.white,
                  items: const [
                    DropdownMenuItem(value: 'all', child: Text('All Statuses')),
                    DropdownMenuItem(value: 'published', child: Text('Published')),
                    DropdownMenuItem(value: 'draft', child: Text('Draft')),
                    DropdownMenuItem(value: 'archived', child: Text('Archived')),
                  ],
                  onChanged: (val) => setState(() {
                    _selectedStatus = val ?? 'all';
                    _currentPage = 1;
                  }),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),

            // Materials Table
            MarketplaceDataTable(
              columns: const [
                DataColumn(label: Text('MATERIAL / SKU')),
                DataColumn(label: Text('CATEGORY')),
                DataColumn(label: Text('BRAND')),
                DataColumn(label: Text('UNIT PRICE & MOQ')),
                DataColumn(label: Text('PRIMARY SUPPLIER')),
                DataColumn(label: Text('STATUS')),
                DataColumn(label: Text('ACTIONS')),
              ],
              rows: paginatedItems.map((item) {
                return DataRow(
                  cells: [
                    // Material / SKU
                    DataCell(
                      Row(
                        children: [
                          Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              borderRadius: AppRadius.sm,
                            ),
                            child: const Icon(Icons.handyman_outlined, color: AppColors.primary, size: 20),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                item.name.length > 28 ? '${item.name.substring(0, 26)}...' : item.name,
                                style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w600),
                              ),
                              Text(
                                '${item.sku} • Grade: ${item.grade}',
                                style: GoogleFonts.plusJakartaSans(fontSize: 11, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Category
                    DataCell(
                      Text(item.categoryName, style: GoogleFonts.plusJakartaSans(fontSize: 12)),
                    ),

                    // Brand
                    DataCell(
                      Text(item.brandName, style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w600)),
                    ),

                    // Unit Price & MOQ
                    DataCell(
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('₹${item.wholesalePrice.toStringAsFixed(0)} / ${item.unitOfMeasure.label}', style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w700)),
                          Text('MOQ: ${item.minOrderQuantity} ${item.unitOfMeasure.label}', style: GoogleFonts.plusJakartaSans(fontSize: 11, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B))),
                        ],
                      ),
                    ),

                    // Primary Supplier
                    DataCell(
                      InkWell(
                        onTap: () => _showSupplierDetails(item),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.business_rounded, size: 14, color: AppColors.primary),
                            const SizedBox(width: 4),
                            Text(
                              item.primarySupplier.vendorName,
                              style: GoogleFonts.plusJakartaSans(fontSize: 12, color: AppColors.primary, decoration: TextDecoration.underline),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Status
                    DataCell(
                      MarketplaceStatusBadge.publication(item.publicationStatus),
                    ),

                    // Actions
                    DataCell(
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.business_center_outlined, size: 18, color: AppColors.primary),
                            tooltip: 'View Supplier Contract',
                            onPressed: () => _showSupplierDetails(item),
                          ),
                          IconButton(
                            icon: Icon(Icons.edit_outlined, size: 18, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                            tooltip: 'Edit Material SKU',
                            onPressed: () => _openEditDialog(item),
                          ),
                          PopupMenuButton<String>(
                            icon: Icon(Icons.more_vert_rounded, size: 18, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                            onSelected: (val) {
                              if (val == 'toggle_status') {
                                final newStatus = item.publicationStatus == ProductPublicationStatus.published
                                    ? ProductPublicationStatus.archived
                                    : ProductPublicationStatus.published;
                                _repo.updateMaterialStatus(item.id, newStatus);
                              } else if (val == 'delete') {
                                _confirmDelete(item);
                              }
                            },
                            itemBuilder: (ctx) => [
                              PopupMenuItem(
                                value: 'toggle_status',
                                child: Text(item.publicationStatus == ProductPublicationStatus.published ? 'Archive SKU' : 'Publish SKU'),
                              ),
                              const PopupMenuItem(
                                value: 'delete',
                                child: Text('Delete SKU', style: TextStyle(color: AppColors.error)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),

            // Pagination strip
            const SizedBox(height: AppSpacing.md),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Showing ${filtered.isEmpty ? 0 : startIndex + 1} to ${(startIndex + _pageSize).clamp(0, filtered.length)} of ${filtered.length} materials',
                  style: GoogleFonts.plusJakartaSans(fontSize: 12, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left_rounded),
                      onPressed: _currentPage > 1 ? () => setState(() => _currentPage--) : null,
                    ),
                    Text('$_currentPage / $totalPages', style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w600)),
                    IconButton(
                      icon: const Icon(Icons.chevron_right_rounded),
                      onPressed: _currentPage < totalPages ? () => setState(() => _currentPage++) : null,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
