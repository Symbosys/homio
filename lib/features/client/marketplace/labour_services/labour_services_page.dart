import 'package:flutter/material.dart';
import '../models/marketplace_enums.dart';
import '../models/labour_models.dart';
import '../services/marketplace_service.dart';
import '../widgets/marketplace_scaffold.dart';
import '../widgets/marketplace_header.dart';
import '../widgets/marketplace_filter_bar.dart';
import '../widgets/empty_marketplace_state.dart';
import 'widgets/worker_card.dart';
import 'widgets/service_card.dart';
import 'widgets/hire_booking_dialog.dart';

/// Labour & On-Demand Craftsman Services catalog page
class ClientMarketplaceLabourServicesPage extends StatefulWidget {
  const ClientMarketplaceLabourServicesPage({super.key});

  @override
  State<ClientMarketplaceLabourServicesPage> createState() => _ClientMarketplaceLabourServicesPageState();
}

class _ClientMarketplaceLabourServicesPageState extends State<ClientMarketplaceLabourServicesPage> {
  final TextEditingController _searchController = TextEditingController();
  LabourTradeCategory _selectedTrade = LabourTradeCategory.all;
  String _searchQuery = '';
  int _tabIndex = 0; // 0 = Tradesmen, 1 = Fixed Packages

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<LabourWorkerProfile> _filterWorkers(List<LabourWorkerProfile> all) {
    return all.where((w) {
      final matchesTrade = _selectedTrade == LabourTradeCategory.all || w.trade == _selectedTrade;
      final matchesSearch = _searchQuery.isEmpty ||
          w.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          w.trade.label.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          w.city.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          w.locality.toLowerCase().contains(_searchQuery.toLowerCase());

      return matchesTrade && matchesSearch;
    }).toList();
  }

  List<LabourServicePackage> _filterPackages(List<LabourServicePackage> all) {
    return all.where((p) {
      final matchesTrade = _selectedTrade == LabourTradeCategory.all || p.trade == _selectedTrade;
      final matchesSearch = _searchQuery.isEmpty ||
          p.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          p.shortDescription.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          p.trade.label.toLowerCase().contains(_searchQuery.toLowerCase());

      return matchesTrade && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return MarketplaceScaffold(
      activeCategory: MarketplaceCategory.labourServices,
      title: 'Labour & On-Demand Services',
      subtitle: 'Verified master carpenters, licensed electricians, plumbers & fixed turnkey packages',
      body: ListenableBuilder(
        listenable: MarketplaceService(),
        builder: (context, _) {
          final service = MarketplaceService();
          final filteredWorkers = _filterWorkers(service.labourWorkers);
          final filteredPackages = _filterPackages(service.servicePackages);

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
                      title: 'On-Demand Skilled Guild Labour',
                      subtitle: 'Police verified, certified background checks & milestone guaranteed trade workmanship',
                      badgeText: 'Guild Certified',
                      badgeColor: const Color(0xFF06B6D4),
                      searchController: _searchController,
                      onSearchChanged: (val) => setState(() => _searchQuery = val.trim()),
                      onClearSearch: () {
                        _searchController.clear();
                        setState(() => _searchQuery = '');
                      },
                      searchHint: 'Search carpenters, plumbers, electricians, kitchen installation...',
                    ),
                  ),

                  // View Mode Segmented Bar
                  SliverToBoxAdapter(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      child: Row(
                        children: [
                          ChoiceChip(
                            label: Text('Verified Tradesmen (${filteredWorkers.length})'),
                            selected: _tabIndex == 0,
                            selectedColor: const Color(0xFF10B981).withValues(alpha: 0.2),
                            onSelected: (val) {
                              if (val) setState(() => _tabIndex = 0);
                            },
                          ),
                          const SizedBox(width: 10),
                          ChoiceChip(
                            label: Text('Turnkey Scope Packages (${filteredPackages.length})'),
                            selected: _tabIndex == 1,
                            selectedColor: const Color(0xFF10B981).withValues(alpha: 0.2),
                            onSelected: (val) {
                              if (val) setState(() => _tabIndex = 1);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Trade Category Filter Bar
                  SliverToBoxAdapter(
                    child: MarketplaceFilterBar<LabourTradeCategory>(
                      categories: LabourTradeCategory.values,
                      selectedCategory: _selectedTrade,
                      onCategoryChanged: (cat) => setState(() => _selectedTrade = cat),
                      labelExtractor: (cat) => cat.label,
                      totalCount: _tabIndex == 0 ? filteredWorkers.length : filteredPackages.length,
                    ),
                  ),

                  // Content Slivers
                  if (_tabIndex == 0)
                    ..._buildWorkersSlivers(filteredWorkers, crossAxisCount)
                  else
                    ..._buildPackagesSlivers(filteredPackages, crossAxisCount),
                ],
              );
            },
          );
        },
      ),
    );
  }

  List<Widget> _buildWorkersSlivers(List<LabourWorkerProfile> workers, int crossAxisCount) {
    if (workers.isEmpty) {
      return [
        SliverFillRemaining(
          hasScrollBody: false,
          child: EmptyMarketplaceState(
            title: 'No tradesmen found',
            message: 'No verified workers matched your trade filter or search query.',
            onResetFilters: () {
              _searchController.clear();
              setState(() {
                _selectedTrade = LabourTradeCategory.all;
                _searchQuery = '';
              });
            },
          ),
        ),
      ];
    }

    return [
      SliverPadding(
        padding: const EdgeInsets.all(20),
        sliver: SliverGrid(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.15,
          ),
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final worker = workers[index];
              return WorkerCard(
                worker: worker,
                onBook: () => HireBookingDialog.showForWorker(context, worker),
              );
            },
            childCount: workers.length,
          ),
        ),
      ),
    ];
  }

  List<Widget> _buildPackagesSlivers(List<LabourServicePackage> packages, int crossAxisCount) {
    if (packages.isEmpty) {
      return [
        SliverFillRemaining(
          hasScrollBody: false,
          child: EmptyMarketplaceState(
            title: 'No packages found',
            message: 'No standardized turnkey packages matched your trade filter or search query.',
            onResetFilters: () {
              _searchController.clear();
              setState(() {
                _selectedTrade = LabourTradeCategory.all;
                _searchQuery = '';
              });
            },
          ),
        ),
      ];
    }

    return [
      SliverPadding(
        padding: const EdgeInsets.all(20),
        sliver: SliverGrid(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.15,
          ),
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final package = packages[index];
              return ServiceCard(
                package: package,
                onBook: () => HireBookingDialog.showForPackage(context, package),
              );
            },
            childCount: packages.length,
          ),
        ),
      ),
    ];
  }
}
