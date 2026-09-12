import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/marketplace_enums.dart';
import '../models/home_decor_models.dart';
import '../services/marketplace_service.dart';
import '../services/cart_service.dart';
import '../widgets/marketplace_scaffold.dart';
import '../widgets/marketplace_header.dart';
import '../widgets/marketplace_filter_bar.dart';
import '../widgets/product_card.dart';
import '../widgets/empty_marketplace_state.dart';
import 'widgets/decor_detail_sheet.dart';

/// Curated Home Decor, Chandeliers & Accent Furniture catalog
class ClientMarketplaceHomeDecorPage extends StatefulWidget {
  const ClientMarketplaceHomeDecorPage({super.key});

  @override
  State<ClientMarketplaceHomeDecorPage> createState() => _ClientMarketplaceHomeDecorPageState();
}

class _ClientMarketplaceHomeDecorPageState extends State<ClientMarketplaceHomeDecorPage> {
  final TextEditingController _searchController = TextEditingController();
  HomeDecorCategory _selectedCategory = HomeDecorCategory.all;
  String _searchQuery = '';
  String _selectedSort = 'Featured';

  final List<String> _sortOptions = ['Featured', 'Price: Low to High', 'Price: High to Low', 'Customer Rating'];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<HomeDecorItem> _filterItems(List<HomeDecorItem> all) {
    return all.where((item) {
      final matchesCategory = _selectedCategory == HomeDecorCategory.all || item.category == _selectedCategory;
      final matchesSearch = _searchQuery.isEmpty ||
          item.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.brand.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.designStyle.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.material.toLowerCase().contains(_searchQuery.toLowerCase());

      return matchesCategory && matchesSearch;
    }).toList()
      ..sort((a, b) {
        if (_selectedSort == 'Price: Low to High') return a.price.compareTo(b.price);
        if (_selectedSort == 'Price: High to Low') return b.price.compareTo(a.price);
        if (_selectedSort == 'Customer Rating') return b.rating.compareTo(a.rating);
        return (b.isFeatured ? 1 : 0).compareTo(a.isFeatured ? 1 : 0);
      });
  }

  @override
  Widget build(BuildContext context) {
    return MarketplaceScaffold(
      activeCategory: MarketplaceCategory.homeDecor,
      title: 'Home Decor & Accent Furniture',
      subtitle: 'Curated designer chandeliers, Japandi lounge chairs, wool rugs & stonework',
      body: ListenableBuilder(
        listenable: MarketplaceService(),
        builder: (context, _) {
          final allItems = MarketplaceService().homeDecorItems;
          final filteredItems = _filterItems(allItems);

          return LayoutBuilder(
            builder: (context, constraints) {
              final crossAxisCount = constraints.maxWidth > 1200
                  ? 4
                  : (constraints.maxWidth > 840 ? 3 : (constraints.maxWidth > 550 ? 2 : 1));

              return CustomScrollView(
                slivers: [
                  // Header
                  SliverToBoxAdapter(
                    child: MarketplaceHeader(
                      title: 'Curated Home Decor & Living Accents',
                      subtitle: 'Architect-vetted lighting, custom teakwood furniture & handcrafted ceramics with direct & affiliate fulfillment',
                      badgeText: 'Curated Collection',
                      badgeColor: const Color(0xFF8B5CF6),
                      searchController: _searchController,
                      onSearchChanged: (val) => setState(() => _searchQuery = val.trim()),
                      onClearSearch: () {
                        _searchController.clear();
                        setState(() => _searchQuery = '');
                      },
                      searchHint: 'Search chandeliers, travertine tables, rugs, brass or boucle...',
                    ),
                  ),

                  // Filter Bar
                  SliverToBoxAdapter(
                    child: MarketplaceFilterBar<HomeDecorCategory>(
                      categories: HomeDecorCategory.values,
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
                        title: 'No decor pieces found',
                        message: 'Try modifying your search keywords or switching category filters.',
                        onResetFilters: () {
                          _searchController.clear();
                          setState(() {
                            _selectedCategory = HomeDecorCategory.all;
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
                              subtitle: item.brand,
                              imageUrl: item.imageUrls.first,
                              price: item.price,
                              originalPrice: item.originalPrice,
                              rating: item.rating,
                              reviewCount: item.reviewCount,
                              tag: item.isAffiliate ? item.affiliatePlatform.displayName : 'HOMIO Direct',
                              tagColor: item.isAffiliate ? const Color(0xFF8B5CF6) : const Color(0xFF10B981),
                              actionLabel: item.isAffiliate ? 'View Partner' : 'Details',
                              actionIcon: item.isAffiliate ? Icons.open_in_new_rounded : Icons.info_outline_rounded,
                              onTap: () => DecorDetailSheet.show(context, item),
                              onAddToCart: item.isAffiliate
                                  ? null
                                  : () {
                                      CartService().addItem(
                                        productId: item.id,
                                        title: item.title,
                                        imageUrl: item.imageUrls.first,
                                        unitPrice: item.price,
                                        category: MarketplaceCategory.homeDecor,
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
