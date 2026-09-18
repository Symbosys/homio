import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../platform_admin/data/models/platform_marketplace_category_model.dart';
import '../../data/models/org_marketplace_models.dart';
import '../queries/org_marketplace_queries.dart';
import '../dialogs/org_digital_product_dialog.dart';
import '../dialogs/org_home_decor_dialog.dart';
import '../dialogs/org_property_dialog.dart';
import '../dialogs/org_material_dialog.dart';
import '../dialogs/org_product_detail_sheet.dart';

class MarketplaceDynamicHubPage extends StatefulWidget {
  final String? initialCategorySlug;

  const MarketplaceDynamicHubPage({
    super.key,
    this.initialCategorySlug,
  });

  @override
  State<MarketplaceDynamicHubPage> createState() => _MarketplaceDynamicHubPageState();
}

class _MarketplaceDynamicHubPageState extends State<MarketplaceDynamicHubPage> {
  final _queries = OrgMarketplaceQueries();
  String? _selectedCategorySlug;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _selectedCategorySlug = widget.initialCategorySlug;
  }

  @override
  void didUpdateWidget(covariant MarketplaceDynamicHubPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialCategorySlug != null && widget.initialCategorySlug != _selectedCategorySlug) {
      setState(() {
        _selectedCategorySlug = widget.initialCategorySlug;
      });
    }
  }

  void _onCategorySelected(PlatformMarketplaceCategoryModel category) {
    setState(() {
      _selectedCategorySlug = category.slug;
      _searchQuery = '';
    });

    // Update URL query parameter
    final currentUri = GoRouterState.of(context).uri;
    final newQuery = Map<String, dynamic>.from(currentUri.queryParameters);
    newQuery['category'] = category.slug;
    final newUri = currentUri.replace(queryParameters: newQuery);
    context.go(newUri.toString());
  }

  void _openAddProductDialog(PlatformMarketplaceCategoryModel category) {
    switch (category.marketplaceType) {
      case 'DIGITAL_ASSET':
        OrgDigitalProductDialog.show(context, category: category);
        break;
      case 'HOME_DECOR':
        OrgHomeDecorDialog.show(context, category: category);
        break;
      case 'PROPERTIES':
        OrgPropertyDialog.show(context, category: category);
        break;
      case 'MATERIALS':
      case 'OTHER':
      default:
        OrgMaterialDialog.show(context, category: category);
        break;
    }
  }

  void _handleRequestSellerApproval(PlatformMarketplaceCategoryModel category) async {
    final mutation = _queries.getRegisterCategoryIntentMutation();
    await mutation.mutate(category.id);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final categoriesQuery = _queries.getCategoriesQuery();
    final sellerCategoriesQuery = _queries.getSellerCategoriesQuery();

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      body: QueryBuilder(
        query: categoriesQuery,
        builder: (context, state) {
          final categories = state.data ?? <PlatformMarketplaceCategoryModel>[];
          if (state.data == null && state.error == null) {
            return const Center(child: CircularProgressIndicator());
          }

          if (categories.isEmpty) {
            return _buildEmptyCategoriesView(isDark);
          }

          // Pick active category
          PlatformMarketplaceCategoryModel activeCategory;
          if (_selectedCategorySlug != null) {
            activeCategory = categories.firstWhere(
              (c) => c.slug == _selectedCategorySlug || c.id == _selectedCategorySlug,
              orElse: () => categories.first,
            );
          } else {
            activeCategory = categories.first;
            _selectedCategorySlug = activeCategory.slug;
          }

          return QueryBuilder(
            query: sellerCategoriesQuery,
            builder: (context, sellerState) {
              final sellerCategories = sellerState.data ?? <OrgSellerCategoryModel>[];
              final sellerEntry = sellerCategories.firstWhere(
                (s) => s.categoryId == activeCategory.id,
                orElse: () => OrgSellerCategoryModel(
                  id: '',
                  organizationId: '',
                  categoryId: activeCategory.id,
                  isApproved: true,
                ),
              );

              return SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    _buildTopHeader(isDark, activeCategory, sellerEntry),
                    const SizedBox(height: AppSpacing.lg),

                    // Dynamic Category Tabs Bar
                    _buildDynamicCategoryTabs(isDark, categories, activeCategory),
                    const SizedBox(height: AppSpacing.xl),

                    // Seller Approval Banner (if not approved)
                    if (!sellerEntry.isApproved)
                      _buildSellerApprovalBanner(isDark, activeCategory, sellerEntry),

                    // Dynamic Catalog & Workspace
                    _buildDynamicWorkspace(isDark, activeCategory, sellerEntry),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildTopHeader(
    bool isDark,
    PlatformMarketplaceCategoryModel activeCategory,
    OrgSellerCategoryModel sellerEntry,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Marketplace Operations',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getVerticalColor(activeCategory.marketplaceType).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: _getVerticalColor(activeCategory.marketplaceType).withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _getVerticalIcon(activeCategory.marketplaceType),
                        size: 14,
                        color: _getVerticalColor(activeCategory.marketplaceType),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        activeCategory.marketplaceType.replaceAll('_', ' '),
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: _getVerticalColor(activeCategory.marketplaceType),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Manage catalog, inventory, pricing, and listings for ${activeCategory.name}.',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
              ),
            ),
          ],
        ),

        // Add Product Button
        ElevatedButton.icon(
          onPressed: () => _openAddProductDialog(activeCategory),
          icon: const Icon(Icons.add_rounded, size: 18),
          label: Text(
            'Add ${activeCategory.name} Item',
            style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600, fontSize: 13),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: _getVerticalColor(activeCategory.marketplaceType),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            elevation: 0,
          ),
        ),
      ],
    );
  }

  Widget _buildDynamicCategoryTabs(
    bool isDark,
    List<PlatformMarketplaceCategoryModel> categories,
    PlatformMarketplaceCategoryModel activeCategory,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: categories.map((cat) {
            final isSelected = cat.id == activeCategory.id;
            final verticalColor = _getVerticalColor(cat.marketplaceType);

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => _onCategorySelected(cat),
                  borderRadius: BorderRadius.circular(10),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? verticalColor.withValues(alpha: isDark ? 0.25 : 0.12)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSelected
                            ? verticalColor
                            : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                        width: isSelected ? 1.5 : 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (cat.imageUrl != null && cat.imageUrl!.isNotEmpty)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: Image.network(
                              cat.imageUrl!,
                              width: 22,
                              height: 22,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Icon(
                                _getVerticalIcon(cat.marketplaceType),
                                size: 18,
                                color: isSelected
                                    ? verticalColor
                                    : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                              ),
                            ),
                          )
                        else
                          Icon(
                            _getVerticalIcon(cat.marketplaceType),
                            size: 18,
                            color: isSelected
                                ? verticalColor
                                : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                          ),
                        const SizedBox(width: 8),
                        Text(
                          cat.name,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                            color: isSelected
                                ? (isDark ? Colors.white : verticalColor)
                                : (isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569)),
                          ),
                        ),
                        if (cat.marketplaceType != 'GENERAL') ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? verticalColor.withValues(alpha: 0.2)
                                  : (isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9)),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              _getShortType(cat.marketplaceType),
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: isSelected
                                    ? verticalColor
                                    : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildSellerApprovalBanner(
    bool isDark,
    PlatformMarketplaceCategoryModel category,
    OrgSellerCategoryModel sellerEntry,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.lg),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: const Color(0xFFF59E0B).withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF59E0B).withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline_rounded, color: Color(0xFFF59E0B), size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Seller Approval Status: Pending Approval',
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    color: isDark ? Colors.white : const Color(0xFFB45309),
                  ),
                ),
                Text(
                  'You have not yet enrolled to sell under ${category.name}. Click "Apply to Sell" to request platform approval.',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF78350F),
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () => _handleRequestSellerApproval(category),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF59E0B),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            ),
            child: const Text('Apply to Sell'),
          ),
        ],
      ),
    );
  }

  Widget _buildDynamicWorkspace(
    bool isDark,
    PlatformMarketplaceCategoryModel category,
    OrgSellerCategoryModel sellerEntry,
  ) {
    switch (category.marketplaceType) {
      case 'DIGITAL_ASSET':
        return _buildDigitalAssetCatalogView(isDark, category);
      case 'HOME_DECOR':
        return _buildHomeDecorCatalogView(isDark, category);
      case 'PROPERTIES':
        return _buildPropertyCatalogView(isDark, category);
      case 'MATERIALS':
      case 'OTHER':
      default:
        return _buildMaterialCatalogView(isDark, category);
    }
  }

  // ==========================================
  // DIGITAL ASSETS VIEW
  // ==========================================
  Widget _buildDigitalAssetCatalogView(bool isDark, PlatformMarketplaceCategoryModel category) {
    final query = _queries.getDigitalProductsQuery(categoryId: category.id);

    return QueryBuilder(
      query: query,
      builder: (context, state) {
        final products = state.data ?? <OrgDigitalProductModel>[];
        final filtered = products.where((p) {
          if (_searchQuery.isEmpty) return true;
          return p.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              p.fileFormat.toLowerCase().contains(_searchQuery.toLowerCase());
        }).toList();

        final totalCount = products.length;
        final activeCount = products.where((p) => p.status == 'PUBLISHED' || p.status == 'ACTIVE').length;
        final totalSales = products.fold<int>(0, (sum, p) => sum + p.totalSalesCount);
        final totalValue = products.fold<double>(0, (sum, p) => sum + p.sellingPrice);

        return Column(
          children: [
            // KPI Bar
            _buildKpiGrid(
              isDark,
              [
                _KpiData('Total Handbooks / Assets', '$totalCount', Icons.menu_book_rounded, const Color(0xFF6366F1)),
                _KpiData('Active in Store', '$activeCount', Icons.check_circle_rounded, const Color(0xFF10B981)),
                _KpiData('Total Sales & Downloads', '$totalSales', Icons.download_rounded, const Color(0xFF06B6D4)),
                _KpiData('Catalog Value Index', '₹${totalValue.toStringAsFixed(0)}', Icons.payments_rounded, const Color(0xFF8B5CF6)),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),

            // Search Bar & Table
            _buildSearchAndTableContainer(
              isDark: isDark,
              searchHint: 'Search digital guides, handbooks, format...',
              count: filtered.length,
              child: _buildDigitalTable(isDark, category, filtered),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDigitalTable(
    bool isDark,
    PlatformMarketplaceCategoryModel category,
    List<OrgDigitalProductModel> items,
  ) {
    if (items.isEmpty) {
      return _buildEmptyTableView(isDark, 'No digital assets added yet in ${category.name}.');
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingRowColor: WidgetStateProperty.all(isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9)),
        columns: const [
          DataColumn(label: Text('Preview')),
          DataColumn(label: Text('Guide / Asset Title')),
          DataColumn(label: Text('Format')),
          DataColumn(label: Text('Size')),
          DataColumn(label: Text('Selling Price')),
          DataColumn(label: Text('Downloads')),
          DataColumn(label: Text('Status')),
          DataColumn(label: Text('Actions')),
        ],
        rows: items.map((item) {
          final isPublished = item.status == 'PUBLISHED' || item.status == 'ACTIVE';

          return DataRow(
            cells: [
              DataCell(
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: item.coverImageUrl != null && item.coverImageUrl!.isNotEmpty
                      ? Image.network(
                          item.coverImageUrl!,
                          width: 44,
                          height: 44,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => const Icon(Icons.picture_as_pdf_rounded, size: 28, color: Color(0xFF6366F1)),
                        )
                      : const Icon(Icons.picture_as_pdf_rounded, size: 28, color: Color(0xFF6366F1)),
                ),
              ),
              DataCell(
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(item.name, style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600)),
                    if (item.sku.isNotEmpty)
                      Text(
                        'SKU: ${item.sku}',
                        style: GoogleFonts.plusJakartaSans(fontSize: 11, color: Colors.grey),
                      ),
                  ],
                ),
              ),
              DataCell(
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6366F1).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(item.fileFormat, style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w600, color: const Color(0xFF6366F1))),
                ),
              ),
              DataCell(Text(item.fileSize ?? 'N/A')),
              DataCell(Text(item.sellingPrice > 0 ? '₹${item.sellingPrice.toStringAsFixed(0)}' : 'Free', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700))),
              DataCell(Text('${item.totalSalesCount}')),
              DataCell(
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: isPublished
                        ? const Color(0xFF10B981).withValues(alpha: 0.12)
                        : Colors.grey.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    isPublished ? 'Published' : 'Draft',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: isPublished ? const Color(0xFF10B981) : Colors.grey,
                    ),
                  ),
                ),
              ),
              DataCell(
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.visibility_outlined, size: 18),
                      tooltip: 'View Full Specs',
                      onPressed: () => OrgProductDetailSheet.showDigital(context, category: category, product: item),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit_outlined, size: 18),
                      tooltip: 'Edit Asset',
                      onPressed: () => OrgDigitalProductDialog.show(context, category: category, product: item),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline_rounded, size: 18, color: Colors.red),
                      tooltip: 'Delete',
                      onPressed: () => _confirmDelete(
                        title: 'Delete Digital Asset',
                        message: 'Are you sure you want to remove "${item.name}"?',
                        onConfirm: () async {
                          final mut = _queries.getDeleteDigitalProductMutation();
                          await mut.mutate(item.id);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  // ==========================================
  // HOME DECOR VIEW
  // ==========================================
  Widget _buildHomeDecorCatalogView(bool isDark, PlatformMarketplaceCategoryModel category) {
    final query = _queries.getHomeDecorQuery(categoryId: category.id);

    return QueryBuilder(
      query: query,
      builder: (context, state) {
        final products = state.data ?? <OrgHomeDecorProductModel>[];
        final filtered = products.where((p) {
          if (_searchQuery.isEmpty) return true;
          return p.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              p.sku.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              (p.brandName != null && p.brandName!.toLowerCase().contains(_searchQuery.toLowerCase()));
        }).toList();

        final totalCount = products.length;
        final inStockCount = products.where((p) => p.inStock && p.stockCount > 0).length;
        final totalStockUnits = products.fold<int>(0, (sum, p) => sum + p.stockCount);
        final activeCount = products.where((p) => p.status == 'PUBLISHED' || p.status == 'ACTIVE').length;

        return Column(
          children: [
            // KPI Bar
            _buildKpiGrid(
              isDark,
              [
                _KpiData('Total Decor Products', '$totalCount', Icons.chair_rounded, const Color(0xFFEC4899)),
                _KpiData('In Stock Listings', '$inStockCount', Icons.inventory_rounded, const Color(0xFF10B981)),
                _KpiData('Units in Inventory', '$totalStockUnits', Icons.warehouse_rounded, const Color(0xFFF59E0B)),
                _KpiData('Published Active', '$activeCount', Icons.storefront_rounded, const Color(0xFF8B5CF6)),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),

            // Search Bar & Table
            _buildSearchAndTableContainer(
              isDark: isDark,
              searchHint: 'Search furniture, lighting, SKU, brand...',
              count: filtered.length,
              child: _buildHomeDecorTable(isDark, category, filtered),
            ),
          ],
        );
      },
    );
  }

  Widget _buildHomeDecorTable(
    bool isDark,
    PlatformMarketplaceCategoryModel category,
    List<OrgHomeDecorProductModel> items,
  ) {
    if (items.isEmpty) {
      return _buildEmptyTableView(isDark, 'No home decor products found in ${category.name}.');
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingRowColor: WidgetStateProperty.all(isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9)),
        columns: const [
          DataColumn(label: Text('Photo')),
          DataColumn(label: Text('Product & SKU')),
          DataColumn(label: Text('Brand / Specs')),
          DataColumn(label: Text('Retail Price')),
          DataColumn(label: Text('Offer Price')),
          DataColumn(label: Text('Stock')),
          DataColumn(label: Text('Status')),
          DataColumn(label: Text('Actions')),
        ],
        rows: items.map((item) {
          return DataRow(
            cells: [
              DataCell(
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: item.coverImageUrl != null && item.coverImageUrl!.isNotEmpty
                      ? Image.network(
                          item.coverImageUrl!,
                          width: 44,
                          height: 44,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => const Icon(Icons.chair_rounded, size: 28, color: Color(0xFFEC4899)),
                        )
                      : const Icon(Icons.chair_rounded, size: 28, color: Color(0xFFEC4899)),
                ),
              ),
              DataCell(
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(item.name, style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600)),
                    if (item.sku.isNotEmpty)
                      Text('SKU: ${item.sku}', style: GoogleFonts.plusJakartaSans(fontSize: 11, color: Colors.grey)),
                  ],
                ),
              ),
              DataCell(
                Text(
                  [item.brandName, item.material, item.dimensions].where((e) => e != null && e.isNotEmpty).join(' • '),
                  style: GoogleFonts.plusJakartaSans(fontSize: 12),
                ),
              ),
              DataCell(Text('₹${item.mrp.toStringAsFixed(0)}', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600))),
              DataCell(
                Text(
                  item.sellingPrice > 0 ? '₹${item.sellingPrice.toStringAsFixed(0)}' : '-',
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF10B981),
                  ),
                ),
              ),
              DataCell(
                Text(
                  '${item.stockCount} pcs',
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w600,
                    color: item.stockCount <= 5 ? Colors.red : null,
                  ),
                ),
              ),
              DataCell(
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: item.inStock
                        ? const Color(0xFF10B981).withValues(alpha: 0.12)
                        : Colors.red.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    item.inStock ? 'In Stock' : 'Out of Stock',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: item.inStock ? const Color(0xFF10B981) : Colors.red,
                    ),
                  ),
                ),
              ),
              DataCell(
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.visibility_outlined, size: 18),
                      tooltip: 'View Full Specs',
                      onPressed: () => OrgProductDetailSheet.showHomeDecor(context, category: category, product: item),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit_outlined, size: 18),
                      tooltip: 'Edit Product',
                      onPressed: () => OrgHomeDecorDialog.show(context, category: category, product: item),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline_rounded, size: 18, color: Colors.red),
                      tooltip: 'Delete',
                      onPressed: () => _confirmDelete(
                        title: 'Delete Home Decor Item',
                        message: 'Are you sure you want to delete "${item.name}"?',
                        onConfirm: () async {
                          final mut = _queries.getDeleteHomeDecorMutation();
                          await mut.mutate(item.id);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  // ==========================================
  // PROPERTIES VIEW
  // ==========================================
  Widget _buildPropertyCatalogView(bool isDark, PlatformMarketplaceCategoryModel category) {
    final query = _queries.getPropertiesQuery(categoryId: category.id);

    return QueryBuilder(
      query: query,
      builder: (context, state) {
        final properties = state.data ?? <OrgPropertyListingModel>[];
        final filtered = properties.where((p) {
          if (_searchQuery.isEmpty) return true;
          return p.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              p.city.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              p.propertyType.toLowerCase().contains(_searchQuery.toLowerCase());
        }).toList();

        final totalCount = properties.length;
        final availableCount = properties.where((p) => p.status == 'AVAILABLE' || p.status == 'ACTIVE').length;
        final verifiedCount = properties.where((p) => p.verificationStatus == 'VERIFIED').length;
        final featuredCount = properties.where((p) => p.isFeatured).length;

        return Column(
          children: [
            // KPI Bar
            _buildKpiGrid(
              isDark,
              [
                _KpiData('Total Properties', '$totalCount', Icons.real_estate_agent_rounded, const Color(0xFF10B981)),
                _KpiData('Available for Sale / Rent', '$availableCount', Icons.home_work_rounded, const Color(0xFF06B6D4)),
                _KpiData('Platform Verified', '$verifiedCount', Icons.verified_rounded, const Color(0xFF6366F1)),
                _KpiData('Featured Spotlight', '$featuredCount', Icons.star_rounded, const Color(0xFFF59E0B)),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),

            // Search Bar & Table
            _buildSearchAndTableContainer(
              isDark: isDark,
              searchHint: 'Search property title, city, BHK, type...',
              count: filtered.length,
              child: _buildPropertyTable(isDark, category, filtered),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPropertyTable(
    bool isDark,
    PlatformMarketplaceCategoryModel category,
    List<OrgPropertyListingModel> items,
  ) {
    if (items.isEmpty) {
      return _buildEmptyTableView(isDark, 'No property listings added yet in ${category.name}.');
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingRowColor: WidgetStateProperty.all(isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9)),
        columns: const [
          DataColumn(label: Text('Photo')),
          DataColumn(label: Text('Listing Title')),
          DataColumn(label: Text('Type / Model')),
          DataColumn(label: Text('Location')),
          DataColumn(label: Text('Specs (BHK / Area)')),
          DataColumn(label: Text('Price')),
          DataColumn(label: Text('Verification')),
          DataColumn(label: Text('Actions')),
        ],
        rows: items.map((item) {
          final isVerified = item.verificationStatus == 'VERIFIED';

          return DataRow(
            cells: [
              DataCell(
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: item.coverImageUrl != null && item.coverImageUrl!.isNotEmpty
                      ? Image.network(
                          item.coverImageUrl!,
                          width: 44,
                          height: 44,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => const Icon(Icons.apartment_rounded, size: 28, color: Color(0xFF10B981)),
                        )
                      : const Icon(Icons.apartment_rounded, size: 28, color: Color(0xFF10B981)),
                ),
              ),
              DataCell(
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(item.title, style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600)),
                    if (item.isFeatured)
                      Text('★ FEATURED', style: GoogleFonts.plusJakartaSans(fontSize: 10, fontWeight: FontWeight.w700, color: const Color(0xFFF59E0B))),
                  ],
                ),
              ),
              DataCell(
                Text('${item.propertyType} (${item.intent})', style: GoogleFonts.plusJakartaSans(fontSize: 12)),
              ),
              DataCell(Text([item.locality, item.city].where((e) => e.isNotEmpty).join(', '))),
              DataCell(Text('${item.bhk} • ${item.carpetAreaSqft} sqft')),
              DataCell(Text('₹${item.price.toStringAsFixed(0)}', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700))),
              DataCell(
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: isVerified
                        ? const Color(0xFF10B981).withValues(alpha: 0.12)
                        : const Color(0xFFF59E0B).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    isVerified ? '✓ Verified' : 'Pending Verification',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: isVerified ? const Color(0xFF10B981) : const Color(0xFFF59E0B),
                    ),
                  ),
                ),
              ),
              DataCell(
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.visibility_outlined, size: 18),
                      tooltip: 'View Full Specs',
                      onPressed: () => OrgProductDetailSheet.showProperty(context, category: category, product: item),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit_outlined, size: 18),
                      tooltip: 'Edit Property',
                      onPressed: () => OrgPropertyDialog.show(context, category: category, property: item),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline_rounded, size: 18, color: Colors.red),
                      tooltip: 'Delete',
                      onPressed: () => _confirmDelete(
                        title: 'Delete Property Listing',
                        message: 'Are you sure you want to delete "${item.title}"?',
                        onConfirm: () async {
                          final mut = _queries.getDeletePropertyMutation();
                          await mut.mutate(item.id);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  // ==========================================
  // MATERIALS VIEW
  // ==========================================
  Widget _buildMaterialCatalogView(bool isDark, PlatformMarketplaceCategoryModel category) {
    final query = _queries.getMaterialsQuery(categoryId: category.id);

    return QueryBuilder(
      query: query,
      builder: (context, state) {
        final materials = state.data ?? <OrgMaterialProductModel>[];
        final filtered = materials.where((m) {
          if (_searchQuery.isEmpty) return true;
          return m.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              m.sku.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              m.unitOfMeasure.toLowerCase().contains(_searchQuery.toLowerCase());
        }).toList();

        final totalCount = materials.length;
        final inStockCount = materials.where((m) => m.stockAvailableUnits > 0).length;
        final activeCount = materials.where((m) => m.status == 'PUBLISHED' || m.status == 'ACTIVE').length;

        return Column(
          children: [
            // KPI Bar
            _buildKpiGrid(
              isDark,
              [
                _KpiData('Total Materials Listed', '$totalCount', Icons.inventory_2_rounded, const Color(0xFFF59E0B)),
                _KpiData('In Stock Materials', '$inStockCount', Icons.check_box_rounded, const Color(0xFF10B981)),
                _KpiData('Active in B2B Index', '$activeCount', Icons.layers_rounded, const Color(0xFF6366F1)),
                _KpiData('Wholesale Standard', 'Live Pricing', Icons.price_check_rounded, const Color(0xFF06B6D4)),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),

            // Search Bar & Table
            _buildSearchAndTableContainer(
              isDark: isDark,
              searchHint: 'Search cement, steel, bricks, tiles, unit...',
              count: filtered.length,
              child: _buildMaterialTable(isDark, category, filtered),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMaterialTable(
    bool isDark,
    PlatformMarketplaceCategoryModel category,
    List<OrgMaterialProductModel> items,
  ) {
    if (items.isEmpty) {
      return _buildEmptyTableView(isDark, 'No wholesale materials added yet in ${category.name}.');
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingRowColor: WidgetStateProperty.all(isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9)),
        columns: const [
          DataColumn(label: Text('Image')),
          DataColumn(label: Text('Material Name & SKU')),
          DataColumn(label: Text('Unit')),
          DataColumn(label: Text('Wholesale Price')),
          DataColumn(label: Text('Min Order')),
          DataColumn(label: Text('Stock')),
          DataColumn(label: Text('Status')),
          DataColumn(label: Text('Actions')),
        ],
        rows: items.map((item) {
          final inStock = item.stockAvailableUnits > 0;

          return DataRow(
            cells: [
              DataCell(
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: item.coverImageUrl != null && item.coverImageUrl!.isNotEmpty
                      ? Image.network(
                          item.coverImageUrl!,
                          width: 44,
                          height: 44,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => const Icon(Icons.inventory_2_rounded, size: 28, color: Color(0xFFF59E0B)),
                        )
                      : const Icon(Icons.inventory_2_rounded, size: 28, color: Color(0xFFF59E0B)),
                ),
              ),
              DataCell(
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(item.name, style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600)),
                    if (item.sku.isNotEmpty)
                      Text('SKU: ${item.sku}', style: GoogleFonts.plusJakartaSans(fontSize: 11, color: Colors.grey)),
                  ],
                ),
              ),
              DataCell(
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF59E0B).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(item.unitOfMeasure, style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w600, color: const Color(0xFFF59E0B))),
                ),
              ),
              DataCell(Text('₹${item.wholesalePrice.toStringAsFixed(2)} / ${item.unitOfMeasure}', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700))),
              DataCell(Text('${item.minOrderQuantity} ${item.unitOfMeasure}')),
              DataCell(Text('${item.stockAvailableUnits} units')),
              DataCell(
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: inStock
                        ? const Color(0xFF10B981).withValues(alpha: 0.12)
                        : Colors.red.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    inStock ? 'In Stock' : 'Out of Stock',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: inStock ? const Color(0xFF10B981) : Colors.red,
                    ),
                  ),
                ),
              ),
              DataCell(
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.visibility_outlined, size: 18),
                      tooltip: 'View Full Specs',
                      onPressed: () => OrgProductDetailSheet.showMaterial(context, category: category, product: item),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit_outlined, size: 18),
                      tooltip: 'Edit Material',
                      onPressed: () => OrgMaterialDialog.show(context, category: category, material: item),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline_rounded, size: 18, color: Colors.red),
                      tooltip: 'Delete',
                      onPressed: () => _confirmDelete(
                        title: 'Delete Construction Material',
                        message: 'Are you sure you want to delete "${item.name}"?',
                        onConfirm: () async {
                          final mut = _queries.getDeleteMaterialMutation();
                          await mut.mutate(item.id);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  // ==========================================
  // SHARED UI HELPERS
  // ==========================================
  Widget _buildKpiGrid(bool isDark, List<_KpiData> items) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossCount = constraints.maxWidth > 1000
            ? 4
            : constraints.maxWidth > 600
                ? 2
                : 1;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossCount,
            crossAxisSpacing: AppSpacing.md,
            mainAxisSpacing: AppSpacing.md,
            childAspectRatio: 2.5,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final kpi = items[index];
            return Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: kpi.color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(kpi.icon, color: kpi.color, size: 24),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          kpi.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          kpi.value,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: isDark ? Colors.white : const Color(0xFF0F172A),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSearchAndTableContainer({
    required bool isDark,
    required String searchHint,
    required int count,
    required Widget child,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Filter Bar
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: searchHint,
                      prefixIcon: const Icon(Icons.search_rounded, size: 20),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                        ),
                      ),
                    ),
                    onChanged: (val) => setState(() => _searchQuery = val),
                  ),
                ),
                const SizedBox(width: 14),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '$count Items',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Child Table
          child,
        ],
      ),
    );
  }

  Widget _buildEmptyTableView(bool isDark, String message) {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.inventory_2_outlined, size: 48, color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8)),
            const SizedBox(height: 12),
            Text(
              message,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyCategoriesView(bool isDark) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.category_outlined, size: 56, color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8)),
            const SizedBox(height: 16),
            Text(
              'No Platform Categories Found',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Marketplace master categories are initialized and maintained by the Platform Admin.',
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete({
    required String title,
    required String message,
    required VoidCallback onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title, style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700, fontSize: 16)),
        content: Text(message, style: GoogleFonts.plusJakartaSans(fontSize: 13)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              onConfirm();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Color _getVerticalColor(String vertical) {
    switch (vertical) {
      case 'DIGITAL_ASSET':
        return const Color(0xFF6366F1);
      case 'HOME_DECOR':
        return const Color(0xFFEC4899);
      case 'PROPERTIES':
        return const Color(0xFF10B981);
      case 'MATERIALS':
        return const Color(0xFFF59E0B);
      default:
        return const Color(0xFF8B5CF6);
    }
  }

  IconData _getVerticalIcon(String vertical) {
    switch (vertical) {
      case 'DIGITAL_ASSET':
        return Icons.menu_book_rounded;
      case 'HOME_DECOR':
        return Icons.chair_rounded;
      case 'PROPERTIES':
        return Icons.real_estate_agent_rounded;
      case 'MATERIALS':
        return Icons.inventory_2_rounded;
      default:
        return Icons.category_rounded;
    }
  }

  String _getShortType(String type) {
    switch (type) {
      case 'DIGITAL_ASSET':
        return 'Digital';
      case 'HOME_DECOR':
        return 'Decor';
      case 'PROPERTIES':
        return 'Property';
      case 'MATERIALS':
        return 'Materials';
      default:
        return type;
    }
  }
}

class _KpiData {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  _KpiData(this.title, this.value, this.icon, this.color);
}
