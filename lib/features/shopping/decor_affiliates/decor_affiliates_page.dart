import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../models/shopping_models.dart';
import '../models/shopping_mock_data.dart';
import '../widgets/shopping_header.dart';
import '../widgets/decor_item_card.dart';
import '../widgets/material_order_modal.dart';
import '../widgets/admin_add_decor_item_modal.dart';
import '../widgets/admin_add_material_modal.dart';

class DecorAffiliatesPage extends StatefulWidget {
  const DecorAffiliatesPage({super.key});

  @override
  State<DecorAffiliatesPage> createState() => _DecorAffiliatesPageState();
}

class _DecorAffiliatesPageState extends State<DecorAffiliatesPage> {
  int _selectedViewIndex = 0; // 0: Curated Decor (Affiliates), 1: Wholesale Materials (Direct RFQ)
  String _searchQuery = '';
  DecorCategory? _selectedDecorCat;
  MaterialCategory? _selectedMatCat;

  List<DecorItem> get _decorItems => ShoppingMockData.decorItems;
  List<MaterialItem> get _materials => ShoppingMockData.materials;

  void _openAdminAddDecorModal([DecorItem? item]) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AdminAddDecorItemModal(
        initialItem: item,
        onSuccess: () => setState(() {}),
      ),
    );
  }

  void _openAdminAddMaterialModal([MaterialItem? item]) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AdminAddMaterialModal(
        initialMaterial: item,
        onSuccess: () => setState(() {}),
      ),
    );
  }

  void _deleteDecorItem(DecorItem item) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.delete_outline_rounded, color: Color(0xFFEF4444)),
            SizedBox(width: 10),
            Text('Delete Decor Item', style: TextStyle(fontWeight: FontWeight.w700)),
          ],
        ),
        content: Text('Are you sure you want to remove "${item.title}" from the curated directory?'),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFEF4444), foregroundColor: Colors.white),
            onPressed: () {
              ShoppingMockData.deleteDecorItem(item.id);
              Navigator.of(ctx).pop();
              setState(() {});
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Decor item "${item.title}" deleted.')),
              );
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _deleteMaterialItem(MaterialItem item) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.delete_outline_rounded, color: Color(0xFFEF4444)),
            SizedBox(width: 10),
            Text('Delete Material SKU', style: TextStyle(fontWeight: FontWeight.w700)),
          ],
        ),
        content: Text('Are you sure you want to remove "${item.name}" from wholesale catalog?'),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFEF4444), foregroundColor: Colors.white),
            onPressed: () {
              ShoppingMockData.deleteMaterial(item.id);
              Navigator.of(ctx).pop();
              setState(() {});
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Material SKU "${item.name}" deleted.')),
              );
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = AppColors.getSurface(context);
    final backgroundColor = AppColors.getBackground(context);
    final borderColor = AppColors.getBorder(context);
    final textPrimaryColor = AppColors.getTextPrimary(context);
    final textSecondaryColor = AppColors.getTextSecondary(context);

    final isDecorView = _selectedViewIndex == 0;

    // Filter Decor
    final filteredDecor = _decorItems.where((d) {
      if (_selectedDecorCat != null && d.category != _selectedDecorCat) return false;
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        if (!d.title.toLowerCase().contains(q) && !d.brand.toLowerCase().contains(q) && !d.affiliatePartner.toLowerCase().contains(q)) {
          return false;
        }
      }
      return true;
    }).toList();

    // Filter Materials
    final filteredMaterials = _materials.where((m) {
      if (_selectedMatCat != null && m.category != _selectedMatCat) return false;
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        if (!m.name.toLowerCase().contains(q) && !m.brand.toLowerCase().contains(q) && !m.supplierName.toLowerCase().contains(q)) {
          return false;
        }
      }
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            ShoppingHeader(
              title: 'Curated Home Decor & Wholesale Material Catalogue',
              subtitle: 'Monetized affiliate product showcases and direct distributor procurement for turnkey interior execution.',
              activeTab: 'Home Decor & Materials',
              trailing: Wrap(
                spacing: 12,
                runSpacing: 8,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  SegmentedButton<int>(
                    segments: const [
                      ButtonSegment<int>(
                        value: 0,
                        label: Text('Decor Affiliates'),
                        icon: Icon(Icons.chair_rounded, size: 16),
                      ),
                      ButtonSegment<int>(
                        value: 1,
                        label: Text('Wholesale Materials'),
                        icon: Icon(Icons.layers_rounded, size: 16),
                      ),
                    ],
                    selected: {_selectedViewIndex},
                    onSelectionChanged: (set) => setState(() => _selectedViewIndex = set.first),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => isDecorView ? _openAdminAddDecorModal() : _openAdminAddMaterialModal(),
                    icon: const Icon(Icons.add_rounded, size: 18),
                    label: Text(
                      isDecorView ? 'List Decor Item' : 'Add Material SKU',
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDecorView ? const Color(0xFF8B5CF6) : AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // KPI Cards
                  Row(
                    children: [
                      _buildMetricCard(
                        title: 'Affiliate Partner Network',
                        value: '5 Verified Brands',
                        subtitle: 'West Elm, Pepperfry, Amazon',
                        icon: Icons.store_mall_directory_rounded,
                        color: const Color(0xFF8B5CF6),
                        surfaceColor: surfaceColor,
                        borderColor: borderColor,
                        textPrimary: textPrimaryColor,
                        textSecondary: textSecondaryColor,
                      ),
                      const SizedBox(width: 16),
                      _buildMetricCard(
                        title: 'Direct Wholesale Materials',
                        value: '${_materials.length}+ Master Items',
                        subtitle: 'Marine Ply, GVT Tiles, Hettich',
                        icon: Icons.inventory_2_rounded,
                        color: const Color(0xFF3B82F6),
                        surfaceColor: surfaceColor,
                        borderColor: borderColor,
                        textPrimary: textPrimaryColor,
                        textSecondary: textSecondaryColor,
                      ),
                      const SizedBox(width: 16),
                      _buildMetricCard(
                        title: 'Average Contractor Savings',
                        value: '26.5% Below MRP',
                        subtitle: 'Direct Depot Bulk Pricing',
                        icon: Icons.savings_rounded,
                        color: const Color(0xFF10B981),
                        surfaceColor: surfaceColor,
                        borderColor: borderColor,
                        textPrimary: textPrimaryColor,
                        textSecondary: textSecondaryColor,
                      ),
                      const SizedBox(width: 16),
                      _buildMetricCard(
                        title: 'Affiliate Commission Rate',
                        value: '8% - 12%',
                        subtitle: 'Tracked Referral Links',
                        icon: Icons.trending_up_rounded,
                        color: const Color(0xFFF59E0B),
                        surfaceColor: surfaceColor,
                        borderColor: borderColor,
                        textPrimary: textPrimaryColor,
                        textSecondary: textSecondaryColor,
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Search & Category Filters
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: surfaceColor,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: borderColor),
                    ),
                    child: Column(
                      children: [
                        TextField(
                          onChanged: (val) => setState(() => _searchQuery = val),
                          decoration: InputDecoration(
                            hintText: isDecorView
                                ? 'Search decor items by name, brand (West Elm, Artemide), or partner...'
                                : 'Search materials by brand (CenturyPly, Kajaria, Hettich, Asian Paints)...',
                            prefixIcon: const Icon(Icons.search, size: 18),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: borderColor),
                            ),
                            filled: true,
                            fillColor: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          ),
                        ),
                        const SizedBox(height: 12),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: isDecorView
                                ? [
                                    _buildCategoryChip(
                                      label: 'All Decor (${_decorItems.length})',
                                      isSelected: _selectedDecorCat == null,
                                      onSelected: () => setState(() => _selectedDecorCat = null),
                                    ),
                                    ...DecorCategory.values.map((cat) {
                                      final count = _decorItems.where((d) => d.category == cat).length;
                                      return Padding(
                                        padding: const EdgeInsets.only(left: 8),
                                        child: _buildCategoryChip(
                                          label: '${cat.label} ($count)',
                                          icon: cat.icon,
                                          isSelected: _selectedDecorCat == cat,
                                          onSelected: () => setState(() => _selectedDecorCat = cat),
                                        ),
                                      );
                                    }),
                                  ]
                                : [
                                    _buildCategoryChip(
                                      label: 'All Wholesale Materials (${_materials.length})',
                                      isSelected: _selectedMatCat == null,
                                      onSelected: () => setState(() => _selectedMatCat = null),
                                    ),
                                    ...MaterialCategory.values.map((cat) {
                                      final count = _materials.where((m) => m.category == cat).length;
                                      return Padding(
                                        padding: const EdgeInsets.only(left: 8),
                                        child: _buildCategoryChip(
                                          label: '${cat.label} ($count)',
                                          icon: cat.icon,
                                          isSelected: _selectedMatCat == cat,
                                          onSelected: () => setState(() => _selectedMatCat = cat),
                                        ),
                                      );
                                    }),
                                  ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Content Grid
                  if (isDecorView) ...[
                    if (filteredDecor.isEmpty)
                      _buildEmptyState(textPrimaryColor, textSecondaryColor, true)
                    else
                      _buildGrid(
                        itemCount: filteredDecor.length,
                        itemBuilder: (ctx, idx) {
                          final item = filteredDecor[idx];
                          return DecorItemCard.decor(
                            item: item,
                            onAction: () => _openAffiliateRedirectDialog(context, item),
                            onEdit: () => _openAdminAddDecorModal(item),
                            onDelete: () => _deleteDecorItem(item),
                          );
                        },
                      ),
                  ] else ...[
                    if (filteredMaterials.isEmpty)
                      _buildEmptyState(textPrimaryColor, textSecondaryColor, false)
                    else
                      _buildGrid(
                        itemCount: filteredMaterials.length,
                        itemBuilder: (ctx, idx) {
                          final item = filteredMaterials[idx];
                          return DecorItemCard.material(
                            item: item,
                            onAction: () => _openMaterialOrderModal(context, item),
                            onEdit: () => _openAdminAddMaterialModal(item),
                            onDelete: () => _deleteMaterialItem(item),
                          );
                        },
                      ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGrid({
    required int itemCount,
    required Widget Function(BuildContext, int) itemBuilder,
  }) {
    return LayoutBuilder(
      builder: (ctx, constraints) {
        final crossAxisCount = constraints.maxWidth > 1200
            ? 3
            : constraints.maxWidth > 800
                ? 2
                : 1;
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: itemCount,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            mainAxisExtent: 380,
          ),
          itemBuilder: itemBuilder,
        );
      },
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
    required Color surfaceColor,
    required Color borderColor,
    required Color textPrimary,
    required Color textSecondary,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontSize: 11, color: textSecondary, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 2),
                  Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: textPrimary)),
                  Text(subtitle, style: TextStyle(fontSize: 10, color: textSecondary)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChip({
    required String label,
    IconData? icon,
    required bool isSelected,
    required VoidCallback onSelected,
  }) {
    return ChoiceChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[Icon(icon, size: 14), const SizedBox(width: 4)],
          Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
        ],
      ),
      selected: isSelected,
      onSelected: (_) => onSelected(),
      selectedColor: AppColors.primary,
      labelStyle: TextStyle(color: isSelected ? Colors.white : null),
    );
  }

  Widget _buildEmptyState(Color textPrimary, Color textSecondary, bool isDecor) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          children: [
            Icon(Icons.inventory_2_outlined, size: 48, color: textSecondary),
            const SizedBox(height: 12),
            Text('No items found matching your criteria.', style: TextStyle(color: textPrimary, fontWeight: FontWeight.w600)),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => isDecor ? _openAdminAddDecorModal() : _openAdminAddMaterialModal(),
              icon: const Icon(Icons.add_rounded, size: 16),
              label: Text(isDecor ? 'List First Decor Item' : 'Add Material SKU'),
              style: ElevatedButton.styleFrom(
                backgroundColor: isDecor ? const Color(0xFF8B5CF6) : AppColors.primary,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openAffiliateRedirectDialog(BuildContext context, DecorItem item) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.open_in_new_rounded, color: Color(0xFF8B5CF6)),
            const SizedBox(width: 10),
            const Text('Partner Store Redirection', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('You are being redirected to ${item.affiliatePartner} with tracked Homio partner referral credentials:'),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF8B5CF6).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Affiliate Link: ${item.affiliateUrl}',
                style: const TextStyle(fontSize: 11, fontFamily: 'monospace'),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Homio CRM earns an estimated ${item.commissionPercent}% commission on qualifying purchases.',
              style: const TextStyle(fontSize: 11, color: Color(0xFF10B981), fontWeight: FontWeight.w600),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Opening ${item.affiliatePartner} in new tab...')),
              );
            },
            child: const Text('Continue to Partner Site'),
          ),
        ],
      ),
    );
  }

  void _openMaterialOrderModal(BuildContext context, MaterialItem item) {
    showDialog(
      context: context,
      builder: (ctx) => MaterialOrderModal(item: item),
    );
  }
}
