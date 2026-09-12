import 'package:flutter/material.dart';
import '../models/marketplace_enums.dart';
import '../models/property_models.dart';
import '../services/marketplace_service.dart';
import '../widgets/marketplace_scaffold.dart';
import '../widgets/marketplace_header.dart';
import '../widgets/marketplace_filter_bar.dart';
import '../widgets/empty_marketplace_state.dart';
import 'widgets/property_card.dart';
import 'widgets/property_detail_sheet.dart';

/// Verified Properties & Luxury Rentals catalog page
class ClientMarketplacePropertiesPage extends StatefulWidget {
  const ClientMarketplacePropertiesPage({super.key});

  @override
  State<ClientMarketplacePropertiesPage> createState() => _ClientMarketplacePropertiesPageState();
}

class _ClientMarketplacePropertiesPageState extends State<ClientMarketplacePropertiesPage> {
  final TextEditingController _searchController = TextEditingController();
  PropertyListingType _selectedListingType = PropertyListingType.all;
  String _searchQuery = '';
  String _selectedSort = 'Featured';

  final List<String> _sortOptions = ['Featured', 'Price: Low to High', 'Price: High to Low', 'Carpet Area'];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<PropertyItem> _filterProperties(List<PropertyItem> all) {
    return all.where((item) {
      final matchesType = _selectedListingType == PropertyListingType.all || item.listingType == _selectedListingType;
      final matchesSearch = _searchQuery.isEmpty ||
          item.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.locality.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.city.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.category.label.toLowerCase().contains(_searchQuery.toLowerCase());

      return matchesType && matchesSearch;
    }).toList()
      ..sort((a, b) {
        if (_selectedSort == 'Price: Low to High') return a.price.compareTo(b.price);
        if (_selectedSort == 'Price: High to Low') return b.price.compareTo(a.price);
        if (_selectedSort == 'Carpet Area') return b.carpetAreaSqFt.compareTo(a.carpetAreaSqFt);
        return (b.isHomioVerified ? 1 : 0).compareTo(a.isHomioVerified ? 1 : 0);
      });
  }

  @override
  Widget build(BuildContext context) {
    return MarketplaceScaffold(
      activeCategory: MarketplaceCategory.properties,
      title: 'Properties & Rentals',
      subtitle: '100% RERA verified penthouses, luxury apartments, duplexes & commercial lofts',
      body: ListenableBuilder(
        listenable: MarketplaceService(),
        builder: (context, _) {
          final allItems = MarketplaceService().properties;
          final filteredItems = _filterProperties(allItems);

          return LayoutBuilder(
            builder: (context, constraints) {
              final crossAxisCount = constraints.maxWidth > 1150
                  ? 3
                  : (constraints.maxWidth > 720 ? 2 : 1);

              return CustomScrollView(
                slivers: [
                  // Header
                  SliverToBoxAdapter(
                    child: MarketplaceHeader(
                      title: 'Verified Properties & Rentals',
                      subtitle: 'Zero broker commission luxury real estate with direct title-holder unlocks & legal compliance audits',
                      badgeText: '100% RERA Vetted',
                      badgeColor: const Color(0xFFF59E0B),
                      searchController: _searchController,
                      onSearchChanged: (val) => setState(() => _searchQuery = val.trim()),
                      onClearSearch: () {
                        _searchController.clear();
                        setState(() => _searchQuery = '');
                      },
                      searchHint: 'Search Indiranagar, Whitefield, Jubilee Hills, penthouses...',
                    ),
                  ),

                  // Filter Bar
                  SliverToBoxAdapter(
                    child: MarketplaceFilterBar<PropertyListingType>(
                      categories: PropertyListingType.values,
                      selectedCategory: _selectedListingType,
                      onCategoryChanged: (type) => setState(() => _selectedListingType = type),
                      labelExtractor: (type) => type.label,
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
                        title: 'No properties found',
                        message: 'Try modifying your search criteria or switching to all listings.',
                        onResetFilters: () {
                          _searchController.clear();
                          setState(() {
                            _selectedListingType = PropertyListingType.all;
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
                          childAspectRatio: 0.88,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final property = filteredItems[index];
                            return PropertyCard(
                              property: property,
                              onTap: () => PropertyDetailSheet.show(context, property),
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
