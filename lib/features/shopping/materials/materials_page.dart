import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../models/shopping_models.dart';
import '../models/shopping_mock_data.dart';
import '../widgets/material_order_modal.dart';
import '../widgets/admin_add_material_modal.dart';

/// Wholesale Construction Materials & Live Price Index Hub
class MaterialsPage extends StatefulWidget {
  const MaterialsPage({super.key});

  @override
  State<MaterialsPage> createState() => _MaterialsPageState();
}

class _MaterialsPageState extends State<MaterialsPage> {
  MaterialCategory? _selectedCategory;
  String _searchQuery = '';
  final TextEditingController _searchCtrl = TextEditingController();
  final NumberFormat _currencyFormat = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<MaterialItem> get _filteredMaterials {
    return ShoppingMockData.materials.where((m) {
      if (_selectedCategory != null && m.category != _selectedCategory) return false;
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        final matchTitle = m.name.toLowerCase().contains(query);
        final matchBrand = m.brand.toLowerCase().contains(query);
        final matchCity = m.supplierCity.toLowerCase().contains(query);
        if (!matchTitle && !matchBrand && !matchCity) return false;
      }
      return true;
    }).toList();
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

  void _openOrderModal(MaterialItem item) {
    showDialog(
      context: context,
      builder: (ctx) => MaterialOrderModal(
        item: item,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = AppColors.getSurface(context);
    final borderColor = AppColors.getBorder(context);
    final textPrimary = AppColors.getTextPrimary(context);
    final textMuted = AppColors.getTextMuted(context);

    final materials = _filteredMaterials;
    final totalSkus = ShoppingMockData.materials.length;
    final inStockCount = ShoppingMockData.materials.where((m) => m.status == ListingStatus.active).length;

    return Scaffold(
      backgroundColor: AppColors.getBackground(context),
      body: CustomScrollView(
        slivers: [
          // Header / Banner
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              decoration: BoxDecoration(
                color: surfaceColor,
                border: Border(bottom: BorderSide(color: borderColor)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF3B82F6).withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.inventory_2_rounded, color: Color(0xFF3B82F6), size: 26),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Wholesale Construction Materials & Live Price Index',
                                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: textPrimary),
                                ),
                                const SizedBox(width: 10),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF10B981).withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Text(
                                    'B2B Live Index',
                                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF10B981)),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Procure high-grade raw materials directly at certified wholesale mill rates with transparent bulk discount tiers.',
                              style: TextStyle(fontSize: 13, color: textMuted),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () => _openAdminAddMaterialModal(),
                        icon: const Icon(Icons.add_rounded, size: 18),
                        label: const Text('Add Material SKU', style: TextStyle(fontWeight: FontWeight.w700)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3B82F6),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          elevation: 0,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Metrics Cards
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final isMobile = constraints.maxWidth < 650;
                      return isMobile
                          ? Column(
                              children: [
                                _buildMetricCard('Total Catalog SKUs', '$totalSkus Materials', Icons.category_rounded, const Color(0xFF3B82F6)),
                                const SizedBox(height: 10),
                                _buildMetricCard('Ready Stock Hubs', '$inStockCount Active Mills', Icons.verified_rounded, const Color(0xFF10B981)),
                                const SizedBox(height: 10),
                                _buildMetricCard('Avg Wholesale Savings', '31.8% vs Retail MRP', Icons.trending_down_rounded, const Color(0xFFF59E0B)),
                                const SizedBox(height: 10),
                                _buildMetricCard('Verified Fulfilment', '99.4% SLA on time', Icons.local_shipping_rounded, const Color(0xFF8B5CF6)),
                              ],
                            )
                          : Row(
                              children: [
                                Expanded(child: _buildMetricCard('Total Catalog SKUs', '$totalSkus Materials', Icons.category_rounded, const Color(0xFF3B82F6))),
                                const SizedBox(width: 14),
                                Expanded(child: _buildMetricCard('Ready Stock Hubs', '$inStockCount Active Mills', Icons.verified_rounded, const Color(0xFF10B981))),
                                const SizedBox(width: 14),
                                Expanded(child: _buildMetricCard('Avg Wholesale Savings', '31.8% vs Retail MRP', Icons.trending_down_rounded, const Color(0xFFF59E0B))),
                                const SizedBox(width: 14),
                                Expanded(child: _buildMetricCard('Verified Fulfilment', '99.4% SLA on time', Icons.local_shipping_rounded, const Color(0xFF8B5CF6))),
                              ],
                            );
                    },
                  ),
                ],
              ),
            ),
          ),

          // Filters & Search Bar
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              color: isDark ? AppColors.darkCard : AppColors.lightCard,
              child: Column(
                children: [
                  Row(
                    children: [
                      // Search input
                      Expanded(
                        child: TextField(
                          controller: _searchCtrl,
                          onChanged: (v) => setState(() => _searchQuery = v),
                          style: TextStyle(fontSize: 13, color: textPrimary),
                          decoration: InputDecoration(
                            hintText: 'Search materials by name, brand (CenturyPly, Greenlam...), or city...',
                            hintStyle: TextStyle(fontSize: 13, color: textMuted),
                            prefixIcon: Icon(Icons.search_rounded, size: 20, color: textMuted),
                            suffixIcon: _searchQuery.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.clear_rounded, size: 18),
                                    onPressed: () {
                                      _searchCtrl.clear();
                                      setState(() => _searchQuery = '');
                                    },
                                  )
                                : null,
                            filled: true,
                            fillColor: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: borderColor)),
                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: borderColor)),
                            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFF3B82F6), width: 1.5)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Category Pills
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildCategoryChip(null, 'All Materials (${ShoppingMockData.materials.length})'),
                        ...MaterialCategory.values.map((cat) {
                          final count = ShoppingMockData.materials.where((m) => m.category == cat).length;
                          return _buildCategoryChip(cat, '${cat.label} ($count)');
                        }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Material Items Grid
          materials.isEmpty
              ? SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.inventory_2_outlined, size: 56, color: textMuted),
                        const SizedBox(height: 14),
                        Text(
                          'No materials found for your search',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: textPrimary),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Try searching for another brand, category, or clear your query.',
                          style: TextStyle(fontSize: 13, color: textMuted),
                        ),
                      ],
                    ),
                  ),
                )
              : SliverPadding(
                  padding: const EdgeInsets.all(24),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 440,
                      mainAxisExtent: 420,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final item = materials[index];
                        return _buildMaterialCard(item);
                      },
                      childCount: materials.length,
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(String label, String value, IconData icon, Color color) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.getBorder(context)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(fontSize: 11, color: AppColors.getTextMuted(context), fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.getTextPrimary(context))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(MaterialCategory? cat, String label) {
    final isSelected = _selectedCategory == cat;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        selected: isSelected,
        label: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected ? Colors.white : AppColors.getTextPrimary(context),
          ),
        ),
        backgroundColor: Theme.of(context).brightness == Brightness.dark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
        selectedColor: const Color(0xFF3B82F6),
        checkmarkColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: isSelected ? const Color(0xFF3B82F6) : AppColors.getBorder(context),
          ),
        ),
        onSelected: (selected) {
          setState(() {
            _selectedCategory = selected ? cat : null;
          });
        },
      ),
    );
  }

  Widget _buildMaterialCard(MaterialItem item) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = AppColors.getSurface(context);
    final borderColor = AppColors.getBorder(context);
    final textPrimary = AppColors.getTextPrimary(context);
    final textMuted = AppColors.getTextMuted(context);

    final savingsPercent = (((item.retailMrp - item.wholesalePrice) / item.retailMrp) * 100).round();

    return Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image banner & Tags
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(13)),
                child: Image.network(
                  item.imageUrl,
                  height: 140,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (ctx, _, _) => Container(
                    height: 140,
                    color: isDark ? Colors.grey[800] : Colors.grey[200],
                    child: Center(
                      child: Icon(Icons.inventory_2_rounded, size: 40, color: textMuted),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.75),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    item.brand,
                    style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '$savingsPercent% OFF MRP',
                    style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w800),
                  ),
                ),
              ),
            ],
          ),

          // Card Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    item.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: textPrimary),
                  ),
                  const SizedBox(height: 6),

                  // Specs line / Key Features
                  Text(
                    item.keyFeatures.isNotEmpty ? item.keyFeatures.first : item.stockAvailable,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 11, color: textMuted, fontWeight: FontWeight.w500),
                  ),
                  const Spacer(),

                  // Pricing row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        _currencyFormat.format(item.wholesalePrice),
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF10B981)),
                      ),
                      Text(
                        ' / ${item.tradeUnit}',
                        style: TextStyle(fontSize: 11, color: textMuted, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _currencyFormat.format(item.retailMrp),
                        style: TextStyle(
                          fontSize: 12,
                          color: textMuted,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),

                  // MOQ & City
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'MOQ: ${item.minOrderQuantity} Units',
                        style: TextStyle(fontSize: 11, color: textMuted, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        '📍 ${item.supplierCity}',
                        style: TextStyle(fontSize: 11, color: textMuted),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _openOrderModal(item),
                          icon: const Icon(Icons.shopping_cart_checkout_rounded, size: 14),
                          label: const Text('Bulk Order', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF3B82F6),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            elevation: 0,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      OutlinedButton(
                        onPressed: () => _openAdminAddMaterialModal(item),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          side: BorderSide(color: borderColor),
                        ),
                        child: Icon(Icons.edit_rounded, size: 16, color: textMuted),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
