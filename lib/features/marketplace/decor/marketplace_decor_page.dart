import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_radius.dart';
import '../data/marketplace_repository.dart';
import '../domain/marketplace_domain_models.dart';
import '../domain/marketplace_enums.dart';
import '../widgets/affiliate_performance_modal.dart';
import '../widgets/decor_product_form_dialog.dart';
import '../widgets/marketplace_attention_panel.dart';
import '../widgets/marketplace_data_table.dart';
import '../widgets/marketplace_filter_bar.dart';
import '../widgets/marketplace_header.dart';
import '../widgets/marketplace_metric_card.dart';
import '../widgets/marketplace_status_badge.dart';

class MarketplaceDecorPage extends StatefulWidget {
  const MarketplaceDecorPage({super.key});

  @override
  State<MarketplaceDecorPage> createState() => _MarketplaceDecorPageState();
}

class _MarketplaceDecorPageState extends State<MarketplaceDecorPage> {
  final _repo = MarketplaceRepository();
  final _searchCtrl = TextEditingController();

  String _searchQuery = '';
  String _selectedCategory = 'all';
  String _selectedBrand = 'all';
  String _selectedPartner = 'all';
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

  List<HomeDecorProductEntity> get _filteredProducts {
    return _repo.homeDecorProducts.where((item) {
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final matchTitle = item.name.toLowerCase().contains(q);
        final matchBrand = item.brandName.toLowerCase().contains(q);
        final matchSku = item.sku.toLowerCase().contains(q);
        if (!matchTitle && !matchBrand && !matchSku) return false;
      }
      if (_selectedCategory != 'all' && item.categoryName.toLowerCase() != _selectedCategory.toLowerCase()) {
        return false;
      }
      if (_selectedBrand != 'all' && item.brandName.toLowerCase() != _selectedBrand.toLowerCase()) {
        return false;
      }
      if (_selectedPartner != 'all' && item.affiliatePartner.name.toLowerCase() != _selectedPartner.toLowerCase()) {
        return false;
      }
      if (_selectedStatus != 'all' && item.publicationStatus.name.toLowerCase() != _selectedStatus.toLowerCase()) {
        return false;
      }
      return true;
    }).toList();
  }

  void _openCreateDialog() {
    DecorProductFormDialog.show(context);
  }

  void _openEditDialog(HomeDecorProductEntity product) {
    DecorProductFormDialog.show(context, productToEdit: product);
  }

  void _openPerformanceModal() {
    AffiliatePerformanceModal.show(context);
  }

  void _confirmDelete(HomeDecorProductEntity product) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF131722) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.lg),
        title: Text('Delete Decor Product', style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.error)),
        content: Text(
          'Are you sure you want to delete "${product.name}"? Associated affiliate tracking stats will remain archived in reporting.',
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
              _repo.deleteDecorProduct(product.id);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Product "${product.name}" removed from catalog.'),
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
    final allProducts = _repo.homeDecorProducts;
    final totalClicks = allProducts.fold<int>(0, (sum, p) => sum + p.affiliateClicksCount);
    final totalCommission = allProducts.fold<double>(0.0, (sum, p) => sum + p.estimatedCommissionEarned);
    final affiliateCount = allProducts.where((p) => p.isAffiliateEnabled).length;

    final filtered = _filteredProducts;
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
              title: 'Home Decor & Affiliate Operations',
              subtitle: 'Curate furniture, lighting, rugs, acoustic panels, affiliate deep-links & direct vendor inventory',
              icon: Icons.chair_outlined,
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
                  icon: const Icon(Icons.add_shopping_cart_rounded, size: 18, color: Colors.white),
                  label: Text('Add Decor Product', style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white)),
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
                  title: 'Affiliate Attribution Tracking Active',
                  description: 'Outbound clicks are tracked with Homio SubID parameters. Commission reconciliations with Pepperfry, Urban Ladder, and Amazon run on the 1st of every month.',
                  count: affiliateCount,
                  icon: Icons.hub_outlined,
                  severityColor: AppColors.info,
                  actionLabel: 'Reconciliation Log',
                  onAction: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Affiliate partner payout reconciliation report generated.'),
                        backgroundColor: AppColors.info,
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),

            // KPI Grid
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
                      title: 'Decor Catalog Size',
                      value: '${allProducts.length}',
                      subtitle: '$affiliateCount affiliate • ${allProducts.length - affiliateCount} direct',
                      icon: Icons.chair_outlined,
                      accentColor: AppColors.primary,
                    ),
                    MarketplaceMetricCard(
                      title: 'Outbound Clicks',
                      value: '$totalClicks',
                      subtitle: 'Total customer redirection events',
                      icon: Icons.touch_app_outlined,
                      accentColor: AppColors.info,
                    ),
                    MarketplaceMetricCard(
                      title: 'Affiliate Commission',
                      value: '₹${totalCommission.toStringAsFixed(0)}',
                      subtitle: 'Accrued partner earnings',
                      icon: Icons.monetization_on_outlined,
                      accentColor: AppColors.success,
                    ),
                    MarketplaceMetricCard(
                      title: 'Direct Decor GMV',
                      value: '₹342,000',
                      subtitle: 'Fulfilled via Homio warehouse',
                      icon: Icons.shopping_bag_outlined,
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
              searchHint: 'Search decor by product name, brand, SKU...',
              onSearchChanged: (val) => setState(() {
                _searchQuery = val;
                _currentPage = 1;
              }),
              totalCount: filtered.length,
              entityLabel: 'Decor Products',
              onClear: () => setState(() {
                _searchCtrl.clear();
                _searchQuery = '';
                _selectedCategory = 'all';
                _selectedBrand = 'all';
                _selectedPartner = 'all';
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
                        .where((c) => c.marketplaceType == MarketplaceType.homeDecor)
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

            // Table
            MarketplaceDataTable(
              columns: const [
                DataColumn(label: Text('PRODUCT / BRAND')),
                DataColumn(label: Text('CATEGORY')),
                DataColumn(label: Text('SOURCING MODEL')),
                DataColumn(label: Text('PARTNER & REV SHARE')),
                DataColumn(label: Text('PRICE & MRP')),
                DataColumn(label: Text('CLICKS & REVENUE')),
                DataColumn(label: Text('STATUS')),
                DataColumn(label: Text('ACTIONS')),
              ],
              rows: paginatedItems.map((item) {
                return DataRow(
                  cells: [
                    // Product & Brand
                    DataCell(
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: AppRadius.sm,
                            child: Image.network(
                              item.coverImageUrl,
                              width: 44,
                              height: 44,
                              fit: BoxFit.cover,
                              errorBuilder: (ctx, err, stack) => Container(
                                width: 44,
                                height: 44,
                                color: AppColors.primary.withValues(alpha: 0.1),
                                child: const Icon(Icons.chair_outlined, color: AppColors.primary, size: 20),
                              ),
                            ),
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
                                '${item.brandName} • SKU: ${item.sku}',
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

                    // Sourcing Model
                    DataCell(
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: item.isAffiliateEnabled ? AppColors.info.withValues(alpha: 0.1) : AppColors.success.withValues(alpha: 0.1),
                          borderRadius: AppRadius.sm,
                          border: Border.all(
                            color: item.isAffiliateEnabled ? AppColors.info.withValues(alpha: 0.3) : AppColors.success.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Text(
                          item.isAffiliateEnabled ? 'Affiliate Link' : 'Direct Stock',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: item.isAffiliateEnabled ? AppColors.info : AppColors.success,
                          ),
                        ),
                      ),
                    ),

                    // Partner & Rev Share
                    DataCell(
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            item.affiliatePartner.label,
                            style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w600),
                          ),
                          Text(
                            item.isAffiliateEnabled ? '${item.commissionRate.toStringAsFixed(1)}% rev share' : 'Direct margin',
                            style: GoogleFonts.plusJakartaSans(fontSize: 11, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                          ),
                        ],
                      ),
                    ),

                    // Price & MRP
                    DataCell(
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('₹${item.customerPrice.toStringAsFixed(0)}', style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w700)),
                          Text(
                            'MRP: ₹${item.mrp.toStringAsFixed(0)}',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              decoration: TextDecoration.lineThrough,
                              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Clicks & Commission
                    DataCell(
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('${item.affiliateClicksCount} clicks', style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w600)),
                          Text('₹${item.estimatedCommissionEarned.toStringAsFixed(0)} earned', style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.success, fontWeight: FontWeight.w600)),
                        ],
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
                            icon: const Icon(Icons.analytics_outlined, size: 18, color: AppColors.primary),
                            tooltip: 'Affiliate Click Performance',
                            onPressed: _openPerformanceModal,
                          ),
                          IconButton(
                            icon: Icon(Icons.edit_outlined, size: 18, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                            tooltip: 'Edit Decor Details',
                            onPressed: () => _openEditDialog(item),
                          ),
                          PopupMenuButton<String>(
                            icon: Icon(Icons.more_vert_rounded, size: 18, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                            onSelected: (val) {
                              if (val == 'toggle_status') {
                                final newStatus = item.publicationStatus == ProductPublicationStatus.published
                                    ? ProductPublicationStatus.archived
                                    : ProductPublicationStatus.published;
                                _repo.updateDecorProductStatus(item.id, newStatus);
                              } else if (val == 'delete') {
                                _confirmDelete(item);
                              }
                            },
                            itemBuilder: (ctx) => [
                              PopupMenuItem(
                                value: 'toggle_status',
                                child: Text(item.publicationStatus == ProductPublicationStatus.published ? 'Archive Product' : 'Publish Product'),
                              ),
                              const PopupMenuItem(
                                value: 'delete',
                                child: Text('Delete Product', style: TextStyle(color: AppColors.error)),
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
                  'Showing ${filtered.isEmpty ? 0 : startIndex + 1} to ${(startIndex + _pageSize).clamp(0, filtered.length)} of ${filtered.length} products',
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
