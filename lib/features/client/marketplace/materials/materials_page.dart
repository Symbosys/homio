import 'package:flutter/material.dart';
import '../models/marketplace_enums.dart';
import '../models/material_models.dart';
import '../services/marketplace_service.dart';
import '../widgets/marketplace_scaffold.dart';
import '../widgets/marketplace_header.dart';
import '../widgets/marketplace_filter_bar.dart';
import '../widgets/product_card.dart';
import '../widgets/empty_marketplace_state.dart';
import 'widgets/trade_pricing_toggle.dart';
import 'widgets/material_detail_sheet.dart';

/// Construction & Interior Finish Materials catalog page with B2B Trade Pricing
class ClientMarketplaceMaterialsPage extends StatefulWidget {
  const ClientMarketplaceMaterialsPage({super.key});

  @override
  State<ClientMarketplaceMaterialsPage> createState() => _ClientMarketplaceMaterialsPageState();
}

class _ClientMarketplaceMaterialsPageState extends State<ClientMarketplaceMaterialsPage> {
  final TextEditingController _searchController = TextEditingController();
  MaterialCategory _selectedCategory = MaterialCategory.all;
  String _searchQuery = '';
  String _selectedSort = 'Recommended';
  bool _isTradePricingEnabled = true;

  final List<String> _sortOptions = ['Recommended', 'Price: Low to High', 'Price: High to Low', 'Lead Time'];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<MaterialItem> _filterMaterials(List<MaterialItem> all) {
    return all.where((item) {
      final matchesCategory = _selectedCategory == MaterialCategory.all || item.category == _selectedCategory;
      final matchesSearch = _searchQuery.isEmpty ||
          item.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.brand.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.manufacturer.toLowerCase().contains(_searchQuery.toLowerCase());

      return matchesCategory && matchesSearch;
    }).toList()
      ..sort((a, b) {
        final priceA = _isTradePricingEnabled ? a.tradePrice : a.retailPrice;
        final priceB = _isTradePricingEnabled ? b.tradePrice : b.retailPrice;

        if (_selectedSort == 'Price: Low to High') return priceA.compareTo(priceB);
        if (_selectedSort == 'Price: High to Low') return priceB.compareTo(priceA);
        if (_selectedSort == 'Lead Time') return a.leadTimeDays.compareTo(b.leadTimeDays);
        return (b.isVerifiedTradeGrade ? 1 : 0).compareTo(a.isVerifiedTradeGrade ? 1 : 0);
      });
  }

  @override
  Widget build(BuildContext context) {
    return MarketplaceScaffold(
      activeCategory: MarketplaceCategory.materials,
      title: 'Construction & Interior Materials',
      subtitle: 'Direct factory pricing for cement, vitrified tiles, plywood, switches & sanitaryware',
      body: ListenableBuilder(
        listenable: MarketplaceService(),
        builder: (context, _) {
          final allItems = MarketplaceService().materials;
          final filteredItems = _filterMaterials(allItems);

          return LayoutBuilder(
            builder: (context, constraints) {
              final crossAxisCount = constraints.maxWidth > 1200
                  ? 4
                  : (constraints.maxWidth > 840 ? 3 : (constraints.maxWidth > 550 ? 2 : 1));

              return CustomScrollView(
                slivers: [
                  // Header with Trade Pricing Switcher in actionButtons
                  SliverToBoxAdapter(
                    child: MarketplaceHeader(
                      title: 'Construction & Interior Materials Depot',
                      subtitle: 'Direct manufacturer supply chain with certified test reports, MOQ volume tiers and site delivery',
                      badgeText: _isTradePricingEnabled ? 'B2B Trade Pricing Active' : 'Retail Pricing',
                      badgeColor: const Color(0xFF3B82F6),
                      searchController: _searchController,
                      onSearchChanged: (val) => setState(() => _searchQuery = val.trim()),
                      onClearSearch: () {
                        _searchController.clear();
                        setState(() => _searchQuery = '');
                      },
                      searchHint: 'Search UltraTech cement, Kajaria tiles, Asian Paints, switches...',
                      actionButtons: [
                        TradePricingToggle(
                          isTradePricingEnabled: _isTradePricingEnabled,
                          onToggle: (val) => setState(() => _isTradePricingEnabled = val),
                        ),
                      ],
                    ),
                  ),

                  // Filter Bar
                  SliverToBoxAdapter(
                    child: MarketplaceFilterBar<MaterialCategory>(
                      categories: MaterialCategory.values,
                      selectedCategory: _selectedCategory,
                      onCategoryChanged: (cat) => setState(() => _selectedCategory = cat),
                      labelExtractor: (cat) => cat.label,
                      selectedSort: _selectedSort,
                      sortOptions: _sortOptions,
                      onSortChanged: (val) {
                        if (val != null) setState(() => _selectedSort = val);
                      },
                      totalCount: filteredItems.length,
                    ),
                  ),

                  // Grid or Empty State
                  if (filteredItems.isEmpty)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: EmptyMarketplaceState(
                        title: 'No materials found',
                        message: 'Try adjusting your material categories or keyword search.',
                        onResetFilters: () {
                          _searchController.clear();
                          setState(() {
                            _selectedCategory = MaterialCategory.all;
                            _searchQuery = '';
                          });
                        },
                      ),
                    )
                  else
                    SliverPadding(
                      padding: const EdgeInsets.all(20),
                      sliver: SliverGrid(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 0.72,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final item = filteredItems[index];
                            final effectivePrice = _isTradePricingEnabled ? item.tradePrice : item.retailPrice;
                            final originalPrice = _isTradePricingEnabled ? item.retailPrice : null;

                            return ProductCard(
                              id: item.id,
                              title: item.title,
                              subtitle: '${item.brand} • MOQ ${item.minimumOrderQuantity} ${item.unit.symbol}',
                              imageUrl: item.imageUrls.first,
                              price: effectivePrice,
                              originalPrice: originalPrice,
                              tag: _isTradePricingEnabled ? 'Trade ${item.tradeDiscountPercent}% Off' : 'Retail',
                              tagColor: const Color(0xFF3B82F6),
                              actionLabel: 'View Specs & MOQ',
                              actionIcon: Icons.tune_rounded,
                              onTap: () => MaterialDetailSheet.show(
                                context: context,
                                material: item,
                                isTradePricingEnabled: _isTradePricingEnabled,
                              ),
                            );
                          },
                          childCount: filteredItems.length,
                        ),
                      ),
                    ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
