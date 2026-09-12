import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/marketplace_enums.dart';
import '../models/digital_product_models.dart';
import '../services/marketplace_service.dart';
import '../services/cart_service.dart';
import '../widgets/marketplace_scaffold.dart';
import '../widgets/marketplace_header.dart';
import '../widgets/marketplace_filter_bar.dart';
import '../widgets/product_card.dart';
import '../widgets/empty_marketplace_state.dart';
import 'widgets/digital_product_detail_sheet.dart';

/// Digital Products & Assets catalog page
class ClientMarketplaceDigitalProductsPage extends StatefulWidget {
  const ClientMarketplaceDigitalProductsPage({super.key});

  @override
  State<ClientMarketplaceDigitalProductsPage> createState() => _ClientMarketplaceDigitalProductsPageState();
}

class _ClientMarketplaceDigitalProductsPageState extends State<ClientMarketplaceDigitalProductsPage> {
  final TextEditingController _searchController = TextEditingController();
  DigitalProductCategory _selectedCategory = DigitalProductCategory.all;
  String _searchQuery = '';
  String _selectedSort = 'Recommended';

  final List<String> _sortOptions = ['Recommended', 'Price: Low to High', 'Price: High to Low', 'Top Rated'];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<DigitalProductItem> _filterProducts(List<DigitalProductItem> all) {
    return all.where((item) {
      final matchesCategory = _selectedCategory == DigitalProductCategory.all || item.category == _selectedCategory;
      final matchesSearch = _searchQuery.isEmpty ||
          item.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.subtitle.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.tags.any((t) => t.toLowerCase().contains(_searchQuery.toLowerCase()));

      return matchesCategory && matchesSearch;
    }).toList()
      ..sort((a, b) {
        if (_selectedSort == 'Price: Low to High') return a.price.compareTo(b.price);
        if (_selectedSort == 'Price: High to Low') return b.price.compareTo(a.price);
        if (_selectedSort == 'Top Rated') return b.rating.compareTo(a.rating);
        return b.downloadCount.compareTo(a.downloadCount);
      });
  }

  @override
  Widget build(BuildContext context) {
    return MarketplaceScaffold(
      activeCategory: MarketplaceCategory.digitalProducts,
      title: 'Digital Products Store',
      subtitle: 'Architectural blueprints, Revit BIM templates, Vastu handbooks & BOQs',
      body: ListenableBuilder(
        listenable: MarketplaceService(),
        builder: (context, _) {
          final allItems = MarketplaceService().digitalProducts;
          final filteredItems = _filterProducts(allItems);

          return LayoutBuilder(
            builder: (context, constraints) {
              final crossAxisCount = constraints.maxWidth > 1200
                  ? 4
                  : (constraints.maxWidth > 840 ? 3 : (constraints.maxWidth > 550 ? 2 : 1));

              return CustomScrollView(
                slivers: [
                  // Header with search
                  SliverToBoxAdapter(
                    child: MarketplaceHeader(
                      title: 'Digital Products & Architectural Assets',
                      subtitle: 'Production-ready blueprints, Revit BIM families, Vastu guides & BOQ models with instant download',
                      badgeText: 'Instant Vault Delivery',
                      badgeColor: const Color(0xFF10B981),
                      searchController: _searchController,
                      onSearchChanged: (val) => setState(() => _searchQuery = val.trim()),
                      onClearSearch: () {
                        _searchController.clear();
                        setState(() => _searchQuery = '');
                      },
                      searchHint: 'Search Vastu, Revit, CAD DWG, shaders or BOQ sheets...',
                    ),
                  ),

                  // Filter Bar
                  SliverToBoxAdapter(
                    child: MarketplaceFilterBar<DigitalProductCategory>(
                      categories: DigitalProductCategory.values,
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

                  // Product Grid / Empty State
                  if (filteredItems.isEmpty)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: EmptyMarketplaceState(
                        title: 'No digital products found',
                        message: 'We couldn\'t find any files matching your search query or filter.',
                        onResetFilters: () {
                          _searchController.clear();
                          setState(() {
                            _selectedCategory = DigitalProductCategory.all;
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
                            return ProductCard(
                              id: item.id,
                              title: item.title,
                              subtitle: item.category.label,
                              imageUrl: item.previewImages.first,
                              price: item.price,
                              originalPrice: item.originalPrice,
                              rating: item.rating,
                              reviewCount: item.reviewCount,
                              tag: item.fileFormat,
                              tagColor: const Color(0xFF10B981),
                              actionLabel: 'Details',
                              actionIcon: Icons.info_outline_rounded,
                              onTap: () => DigitalProductDetailSheet.show(context, item),
                              onAddToCart: () {
                                CartService().addItem(
                                  productId: item.id,
                                  title: item.title,
                                  imageUrl: item.previewImages.first,
                                  unitPrice: item.price,
                                  category: MarketplaceCategory.digitalProducts,
                                  variant: item.fileFormat,
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: const Color(0xFF10B981),
                                    content: Text(
                                      'Added to cart: ${item.title}',
                                      style: GoogleFonts.plusJakartaSans(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              },
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
