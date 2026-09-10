import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_radius.dart';
import '../data/marketplace_repository.dart';
import '../domain/marketplace_domain_models.dart';
import '../domain/marketplace_enums.dart';
import '../widgets/digital_product_detail_modal.dart';
import '../widgets/digital_product_form_dialog.dart';
import '../widgets/marketplace_attention_panel.dart';
import '../widgets/marketplace_data_table.dart';
import '../widgets/marketplace_filter_bar.dart';
import '../widgets/marketplace_header.dart';
import '../widgets/marketplace_metric_card.dart';
import '../widgets/marketplace_status_badge.dart';

class MarketplaceDigitalPage extends StatefulWidget {
  const MarketplaceDigitalPage({super.key});

  @override
  State<MarketplaceDigitalPage> createState() => _MarketplaceDigitalPageState();
}

class _MarketplaceDigitalPageState extends State<MarketplaceDigitalPage> {
  final _repo = MarketplaceRepository();
  final _searchCtrl = TextEditingController();

  String _searchQuery = '';
  String _selectedCategory = 'all';
  String _selectedStatus = 'all';
  String _selectedFormat = 'all';
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

  List<DigitalProductEntity> get _filteredProducts {
    return _repo.digitalProducts.where((item) {
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final matchTitle = item.name.toLowerCase().contains(q);
        final matchSku = item.sku.toLowerCase().contains(q);
        final matchDesc = item.shortDescription.toLowerCase().contains(q);
        if (!matchTitle && !matchSku && !matchDesc) return false;
      }
      if (_selectedCategory != 'all' && item.categoryName.toLowerCase() != _selectedCategory.toLowerCase()) {
        return false;
      }
      if (_selectedStatus != 'all' && item.publicationStatus.name.toLowerCase() != _selectedStatus.toLowerCase()) {
        return false;
      }
      if (_selectedFormat != 'all' && item.fileFormat.name.toLowerCase() != _selectedFormat.toLowerCase()) {
        return false;
      }
      return true;
    }).toList();
  }

  void _openCreateDialog() {
    DigitalProductFormDialog.show(context);
  }

  void _openEditDialog(DigitalProductEntity product) {
    DigitalProductFormDialog.show(context, productToEdit: product);
  }

  void _openDetailModal(DigitalProductEntity product) {
    DigitalProductDetailModal.show(context, product);
  }

  void _confirmDelete(DigitalProductEntity product) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF131722) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.lg),
        title: Text('Delete Digital Asset', style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.error)),
        content: Text(
          'Are you sure you want to delete "${product.name}" (${product.sku})? This action cannot be undone.',
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
              _repo.deleteDigitalProduct(product.id);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Digital asset "${product.name}" deleted.'),
                  backgroundColor: AppColors.error,
                ),
              );
            },
            child: Text('Delete Asset', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600, color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isDesktop = MediaQuery.of(context).size.width >= 1024;
    final allProducts = _repo.digitalProducts;
    final activeCount = allProducts.where((p) => p.publicationStatus == ProductPublicationStatus.published).length;
    final totalDownloads = allProducts.fold<int>(0, (sum, p) => sum + p.totalDownloads);
    final grossRevenue = allProducts.fold<double>(0.0, (sum, p) => sum + (p.sellingPrice * p.totalDownloads));

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
            // Top Header
            MarketplaceHeader(
              title: 'Digital Store Operations',
              subtitle: 'Manage CAD drawings, Revit BIM models, structural designs, budget sheets & digital licenses',
              icon: Icons.folder_zip_outlined,
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
                  icon: const Icon(Icons.cloud_upload_outlined, size: 18, color: Colors.white),
                  label: Text('Upload Digital Asset', style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),

            // Operational Attention Panel
            MarketplaceAttentionPanel(
              alerts: [
                MarketplaceAlertItem(
                  title: 'Digital Asset Operations Notice',
                  description: 'Digital assets require secure signed URLs with 48-hour expiration. All downloads are watermarked with customer license ID.',
                  count: activeCount,
                  icon: Icons.security_rounded,
                  severityColor: AppColors.info,
                  actionLabel: 'Configure Link Rules',
                  onAction: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Link expiry and license parameters can be tuned in Marketplace Management > Rules & SLAs.'),
                        backgroundColor: AppColors.info,
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),

            // Metric KPIs Bar
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
                      title: 'Total Digital SKUs',
                      value: '${allProducts.length}',
                      subtitle: 'CAD, BIM & Estimation assets',
                      icon: Icons.folder_zip_outlined,
                      accentColor: AppColors.primary,
                    ),
                    MarketplaceMetricCard(
                      title: 'Active Published',
                      value: '$activeCount',
                      subtitle: '${((activeCount / (allProducts.isEmpty ? 1 : allProducts.length)) * 100).toStringAsFixed(0)}% catalog live',
                      icon: Icons.check_circle_outline_rounded,
                      accentColor: AppColors.success,
                    ),
                    MarketplaceMetricCard(
                      title: 'Total Downloads',
                      value: '$totalDownloads',
                      subtitle: 'Fulfilled digital deliveries',
                      icon: Icons.file_download_outlined,
                      accentColor: AppColors.info,
                    ),
                    MarketplaceMetricCard(
                      title: 'Digital Gross Revenue',
                      value: '₹${grossRevenue.toStringAsFixed(0)}',
                      subtitle: 'Total licensing sales volume',
                      icon: Icons.payments_outlined,
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
              searchHint: 'Search digital products by title, SKU, format...',
              onSearchChanged: (val) => setState(() {
                _searchQuery = val;
                _currentPage = 1;
              }),
              totalCount: filtered.length,
              entityLabel: 'Digital Assets',
              onClear: () => setState(() {
                _searchCtrl.clear();
                _searchQuery = '';
                _selectedCategory = 'all';
                _selectedStatus = 'all';
                _selectedFormat = 'all';
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
                        .where((c) => c.marketplaceType == MarketplaceType.digital)
                        .map((c) => DropdownMenuItem(value: c.name.toLowerCase(), child: Text(c.name))),
                  ],
                  onChanged: (val) => setState(() {
                    _selectedCategory = val ?? 'all';
                    _currentPage = 1;
                  }),
                ),
                DropdownButton<String>(
                  value: _selectedFormat,
                  underline: const SizedBox.shrink(),
                  dropdownColor: isDark ? const Color(0xFF131722) : Colors.white,
                  items: const [
                    DropdownMenuItem(value: 'all', child: Text('All Formats')),
                    DropdownMenuItem(value: 'dwg', child: Text('AutoCAD DWG')),
                    DropdownMenuItem(value: 'fbx', child: Text('3D FBX Model')),
                    DropdownMenuItem(value: 'pdf', child: Text('Architectural PDF')),
                    DropdownMenuItem(value: 'zip', child: Text('ZIP Package')),
                  ],
                  onChanged: (val) => setState(() {
                    _selectedFormat = val ?? 'all';
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

            // Data Table
            MarketplaceDataTable(
              columns: const [
                DataColumn(label: Text('ASSET / SKU')),
                DataColumn(label: Text('CATEGORY')),
                DataColumn(label: Text('FORMAT')),
                DataColumn(label: Text('PRICE & GST')),
                DataColumn(label: Text('LICENSE')),
                DataColumn(label: Text('DOWNLOADS')),
                DataColumn(label: Text('STATUS')),
                DataColumn(label: Text('ACTIONS')),
              ],
              rows: paginatedItems.map((item) {
                return DataRow(
                  cells: [
                    // Asset / SKU
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
                            child: Icon(
                              _getFileFormatIcon(item.fileFormat),
                              color: AppColors.primary,
                              size: 20,
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
                                '${item.sku} • v${item.version}',
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

                    // Format
                    DataCell(
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF161F30) : const Color(0xFFF1F5F9),
                          borderRadius: AppRadius.sm,
                          border: Border.all(color: isDark ? const Color(0xFF262D40) : const Color(0xFFE2E8F0)),
                        ),
                        child: Text(
                          item.fileFormat.label,
                          style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),

                    // Price & GST
                    DataCell(
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('₹${item.sellingPrice.toStringAsFixed(0)}', style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w700)),
                          Text('+${item.taxRate.toStringAsFixed(0)}% GST', style: GoogleFonts.plusJakartaSans(fontSize: 11, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B))),
                        ],
                      ),
                    ),

                    // License
                    DataCell(
                      Text(item.licenseInfo, style: GoogleFonts.plusJakartaSans(fontSize: 12, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B))),
                    ),

                    // Downloads
                    DataCell(
                      Text(
                        '${item.totalDownloads} / ${item.maxDownloads}',
                        style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w600),
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
                            icon: const Icon(Icons.visibility_outlined, size: 18, color: AppColors.primary),
                            tooltip: 'View Asset Dossier',
                            onPressed: () => _openDetailModal(item),
                          ),
                          IconButton(
                            icon: Icon(Icons.edit_outlined, size: 18, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                            tooltip: 'Edit Asset Details',
                            onPressed: () => _openEditDialog(item),
                          ),
                          PopupMenuButton<String>(
                            icon: Icon(Icons.more_vert_rounded, size: 18, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                            onSelected: (val) {
                              if (val == 'toggle_status') {
                                final newStatus = item.publicationStatus == ProductPublicationStatus.published
                                    ? ProductPublicationStatus.archived
                                    : ProductPublicationStatus.published;
                                _repo.updateDigitalProductStatus(item.id, newStatus);
                              } else if (val == 'delete') {
                                _confirmDelete(item);
                              }
                            },
                            itemBuilder: (ctx) => [
                              PopupMenuItem(
                                value: 'toggle_status',
                                child: Text(item.publicationStatus == ProductPublicationStatus.published ? 'Archive Asset' : 'Publish Asset'),
                              ),
                              const PopupMenuItem(
                                value: 'delete',
                                child: Text('Delete Asset', style: TextStyle(color: AppColors.error)),
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
                  'Showing ${filtered.isEmpty ? 0 : startIndex + 1} to ${(startIndex + _pageSize).clamp(0, filtered.length)} of ${filtered.length} assets',
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

  IconData _getFileFormatIcon(DigitalFileFormat format) {
    switch (format) {
      case DigitalFileFormat.dwg:
        return Icons.architecture_rounded;
      case DigitalFileFormat.fbx:
        return Icons.view_in_ar_rounded;
      case DigitalFileFormat.pdf:
        return Icons.picture_as_pdf_outlined;
      case DigitalFileFormat.epub:
        return Icons.menu_book_rounded;
      case DigitalFileFormat.zip:
        return Icons.folder_zip_outlined;
    }
  }
}
