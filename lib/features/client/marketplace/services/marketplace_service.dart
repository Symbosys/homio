import 'package:flutter/foundation.dart';
import '../models/digital_product_models.dart';
import '../models/home_decor_models.dart';
import '../models/material_models.dart';
import '../models/property_models.dart';
import '../models/labour_models.dart';
import '../models/marketplace_mock_data.dart';

/// Central marketplace state manager providing data querying and state updates
class MarketplaceService extends ChangeNotifier {
  static final MarketplaceService _instance = MarketplaceService._internal();
  factory MarketplaceService() => _instance;
  MarketplaceService._internal() {
    _initData();
  }

  late List<DigitalProductItem> _digitalProducts;
  late List<HomeDecorItem> _homeDecorItems;
  late List<MaterialItem> _materials;
  late List<PropertyItem> _properties;
  late List<LabourWorkerProfile> _labourWorkers;
  late List<LabourServicePackage> _servicePackages;

  final Set<String> _wishlistedIds = {};
  final Set<String> _unlockedPropertyIds = {};

  void _initData() {
    _digitalProducts = List.from(MarketplaceMockData.digitalProducts);
    _homeDecorItems = List.from(MarketplaceMockData.homeDecorItems);
    _materials = List.from(MarketplaceMockData.materials);
    _properties = List.from(MarketplaceMockData.properties);
    _labourWorkers = List.from(MarketplaceMockData.labourWorkers);
    _servicePackages = List.from(MarketplaceMockData.servicePackages);

    // Default unlocked property from mock data
    for (final p in _properties) {
      if (p.isUnlocked) {
        _unlockedPropertyIds.add(p.id);
      }
    }
  }

  // Getters
  List<DigitalProductItem> get digitalProducts => List.unmodifiable(_digitalProducts);
  List<HomeDecorItem> get homeDecorItems => List.unmodifiable(_homeDecorItems);
  List<MaterialItem> get materials => List.unmodifiable(_materials);
  List<PropertyItem> get properties => _properties.map((p) {
        final isUnlocked = _unlockedPropertyIds.contains(p.id);
        return p.copyWith(isUnlocked: isUnlocked);
      }).toList();
  List<LabourWorkerProfile> get labourWorkers => List.unmodifiable(_labourWorkers);
  List<LabourServicePackage> get servicePackages => List.unmodifiable(_servicePackages);

  Set<String> get wishlistedIds => Set.unmodifiable(_wishlistedIds);
  bool isWishlisted(String id) => _wishlistedIds.contains(id);

  void toggleWishlist(String id) {
    if (_wishlistedIds.contains(id)) {
      _wishlistedIds.remove(id);
    } else {
      _wishlistedIds.add(id);
    }
    notifyListeners();
  }

  bool isPropertyUnlocked(String propertyId) => _unlockedPropertyIds.contains(propertyId);

  bool unlockProperty(String propertyId) {
    _unlockedPropertyIds.add(propertyId);
    notifyListeners();
    return true;
  }

  // Search across all items
  Map<String, int> getCategoryCounts() {
    return {
      'digital': _digitalProducts.length,
      'decor': _homeDecorItems.length,
      'materials': _materials.length,
      'properties': _properties.length,
      'workers': _labourWorkers.length,
      'packages': _servicePackages.length,
    };
  }
}
