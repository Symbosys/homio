import 'package:flutter/foundation.dart';
import '../domain/marketplace_enums.dart';
import '../domain/marketplace_domain_models.dart';
import 'marketplace_mock_data.dart';

/// Centralized Reactive State Manager for Homio Marketplace Administration
class MarketplaceRepository extends ChangeNotifier {
  static final MarketplaceRepository _instance = MarketplaceRepository._internal();
  factory MarketplaceRepository() => _instance;

  MarketplaceRepository._internal() {
    _initData();
  }

  late List<MarketplaceCategory> _categories;
  late List<MarketplaceBrand> _brands;
  late List<DigitalProductEntity> _digitalProducts;
  late List<DigitalDownloadAttempt> _downloadAttempts;
  late List<HomeDecorProductEntity> _homeDecorProducts;
  late List<AffiliateClickEvent> _affiliateClicks;
  late List<PropertyListingEntity> _properties;
  late List<PropertyUnlockTransaction> _unlockTransactions;
  late List<MaterialProductEntity> _materials;
  late List<MarketplaceOrderEntity> _orders;
  late List<MarketplaceApprovalItem> _approvals;
  late List<MarketplaceReviewEntity> _reviews;
  late List<MarketplaceMediaItem> _mediaItems;
  late List<MarketplaceAuditRecord> _auditRecords;
  late MarketplaceConfig _config;

  void _initData() {
    _categories = List.from(MarketplaceMockData.categories);
    _brands = List.from(MarketplaceMockData.brands);
    _digitalProducts = List.from(MarketplaceMockData.digitalProducts);
    _downloadAttempts = [];
    _homeDecorProducts = List.from(MarketplaceMockData.homeDecorProducts);
    _affiliateClicks = [];
    _properties = List.from(MarketplaceMockData.properties);
    _unlockTransactions = List.from(MarketplaceMockData.unlockTransactions);
    _materials = List.from(MarketplaceMockData.materials);
    _orders = List.from(MarketplaceMockData.orders);
    _approvals = List.from(MarketplaceMockData.approvals);
    _reviews = List.from(MarketplaceMockData.reviews);
    _mediaItems = List.from(MarketplaceMockData.mediaItems);
    _auditRecords = List.from(MarketplaceMockData.auditRecords);
    _config = MarketplaceMockData.policyConfig;
  }

  // --- Getters ---
  List<MarketplaceCategory> get categories => List.unmodifiable(_categories);
  List<MarketplaceBrand> get brands => List.unmodifiable(_brands);
  List<DigitalProductEntity> get digitalProducts => List.unmodifiable(_digitalProducts);
  List<DigitalDownloadAttempt> get downloadAttempts => List.unmodifiable(_downloadAttempts);
  List<HomeDecorProductEntity> get homeDecorProducts => List.unmodifiable(_homeDecorProducts);
  List<AffiliateClickEvent> get affiliateClicks => List.unmodifiable(_affiliateClicks);
  List<PropertyListingEntity> get properties => List.unmodifiable(_properties);
  List<PropertyUnlockTransaction> get unlockTransactions => List.unmodifiable(_unlockTransactions);
  List<MaterialProductEntity> get materials => List.unmodifiable(_materials);
  List<MarketplaceOrderEntity> get orders => List.unmodifiable(_orders);
  List<MarketplaceApprovalItem> get approvals => List.unmodifiable(_approvals);
  List<MarketplaceReviewEntity> get reviews => List.unmodifiable(_reviews);
  List<MarketplaceMediaItem> get mediaItems => List.unmodifiable(_mediaItems);
  List<MarketplaceAuditRecord> get auditRecords => List.unmodifiable(_auditRecords);
  MarketplaceConfig get config => _config;

  // --- Executive KPIs ---
  double get totalGrossSales {
    double total = 0.0;
    for (final o in _orders) {
      if (o.paymentStatus == PaymentStatus.successful) total += o.totalAmount;
    }
    return total;
  }

  int get totalOrdersCount => _orders.length;
  double get averageOrderValue => totalOrdersCount > 0 ? (totalGrossSales / totalOrdersCount) : 0.0;

  double get digitalGrossRevenue => _digitalProducts.fold(0.0, (sum, p) => sum + p.grossRevenue);
  int get totalDigitalDownloads => _digitalProducts.fold(0, (sum, p) => sum + p.totalDownloads);
  int get totalDigitalFailedDownloads => _digitalProducts.fold(0, (sum, p) => sum + p.failedDownloads);

  int get totalDecorAffiliateClicks => _homeDecorProducts.fold(0, (sum, p) => sum + p.affiliateClicksCount);
  double get totalDecorEstimatedCommission => _homeDecorProducts.fold(0.0, (sum, p) => sum + p.estimatedCommissionEarned);

  int get activePropertiesCount => _properties.where((p) => p.verificationStatus == PropertyVerificationStatus.verified).length;
  int get pendingPropertyVerificationsCount => _properties.where((p) => p.verificationStatus == PropertyVerificationStatus.inProgress || p.verificationStatus == PropertyVerificationStatus.submitted).length;
  int get totalPropertyUnlocks => _unlockTransactions.length;
  double get totalPropertyUnlockRevenue => _unlockTransactions.fold(0.0, (sum, u) => sum + u.totalPaid);

  int get activeMaterialsCount => _materials.where((m) => m.inventoryStatus == ListingStatus.active).length;
  int get lowStockMaterialsCount => _materials.where((m) => m.stockAvailableUnits < 50).length;

  int get pendingApprovalsCount => _approvals.where((a) => a.currentStatus == 'Pending' || a.currentStatus == 'InReview').length;
  int get ordersAwaitingActionCount => _orders.where((o) => o.deliveryStatus == DeliveryStatus.unassigned || o.orderStatus == OrderStatus.processing).length;

  // --- Digital Products Operations ---
  List<DigitalProductEntity> filterDigitalProducts({
    String? query,
    String? categoryId,
    ProductPublicationStatus? publicationStatus,
    double? minPrice,
    double? maxPrice,
  }) {
    return _digitalProducts.where((p) {
      if (query != null && query.isNotEmpty) {
        final q = query.toLowerCase();
        final matches = p.name.toLowerCase().contains(q) ||
            p.sku.toLowerCase().contains(q) ||
            p.authorName.toLowerCase().contains(q) ||
            p.tags.any((t) => t.toLowerCase().contains(q));
        if (!matches) return false;
      }
      if (categoryId != null && categoryId != 'all' && p.categoryId != categoryId) return false;
      if (publicationStatus != null && p.publicationStatus != publicationStatus) return false;
      if (minPrice != null && p.sellingPrice < minPrice) return false;
      if (maxPrice != null && p.sellingPrice > maxPrice) return false;
      return true;
    }).toList();
  }

  void addDigitalProduct(DigitalProductEntity product) {
    _digitalProducts.insert(0, product);
    _logAudit(
      action: MarketplaceAuditAction.create,
      entityName: 'Digital Product',
      entityId: product.id,
      oldValue: 'None',
      newValue: 'Created ${product.name}',
      reason: 'New digital publication catalog entry',
    );
    notifyListeners();
  }

  void updateDigitalProduct(DigitalProductEntity product) {
    final index = _digitalProducts.indexWhere((p) => p.id == product.id);
    if (index != -1) {
      _digitalProducts[index] = product;
      _logAudit(
        action: MarketplaceAuditAction.update,
        entityName: 'Digital Product',
        entityId: product.id,
        oldValue: 'Updated',
        newValue: 'Updated ${product.name}',
        reason: 'Admin modification',
      );
      notifyListeners();
    }
  }

  void toggleDigitalPublication(String id, bool publish) {
    final index = _digitalProducts.indexWhere((p) => p.id == id);
    if (index != -1) {
      final current = _digitalProducts[index];
      _digitalProducts[index] = current.copyWith(
        publicationStatus: publish ? ProductPublicationStatus.published : ProductPublicationStatus.unpublished,
        publishedAt: publish ? DateTime.now() : current.publishedAt,
      );
      _logAudit(
        action: publish ? MarketplaceAuditAction.publish : MarketplaceAuditAction.unpublish,
        entityName: 'Digital Product',
        entityId: id,
        oldValue: current.publicationStatus.label,
        newValue: publish ? 'Published & Live' : 'Unpublished',
        reason: 'Publication status toggle by admin',
      );
      notifyListeners();
    }
  }

  void updateDigitalProductStatus(String id, ProductPublicationStatus status) {
    final index = _digitalProducts.indexWhere((p) => p.id == id);
    if (index != -1) {
      final current = _digitalProducts[index];
      _digitalProducts[index] = current.copyWith(
        publicationStatus: status,
        publishedAt: status == ProductPublicationStatus.published ? DateTime.now() : current.publishedAt,
      );
      _logAudit(
        action: MarketplaceAuditAction.update,
        entityName: 'Digital Product',
        entityId: id,
        oldValue: current.publicationStatus.name,
        newValue: status.name,
        reason: 'Publication status change',
      );
      notifyListeners();
    }
  }

  void deleteDigitalProduct(String id) {
    _digitalProducts.removeWhere((p) => p.id == id);
    _logAudit(
      action: MarketplaceAuditAction.delete,
      entityName: 'Digital Product',
      entityId: id,
      oldValue: 'Active',
      newValue: 'Deleted',
      reason: 'Admin deletion',
    );
    notifyListeners();
  }


  // --- Home Decor Operations ---
  List<HomeDecorProductEntity> filterDecorProducts({
    String? query,
    String? categoryId,
    String? brandName,
    bool? affiliateOnly,
    ProductPublicationStatus? status,
  }) {
    return _homeDecorProducts.where((p) {
      if (query != null && query.isNotEmpty) {
        final q = query.toLowerCase();
        final matches = p.name.toLowerCase().contains(q) ||
            p.sku.toLowerCase().contains(q) ||
            p.brandName.toLowerCase().contains(q) ||
            p.tags.any((t) => t.toLowerCase().contains(q));
        if (!matches) return false;
      }
      if (categoryId != null && categoryId != 'all' && p.categoryId != categoryId) return false;
      if (brandName != null && brandName != 'all' && p.brandName != brandName) return false;
      if (affiliateOnly == true && !p.isAffiliateEnabled) return false;
      if (status != null && p.publicationStatus != status) return false;
      return true;
    }).toList();
  }

  void addDecorProduct(HomeDecorProductEntity product) {
    _homeDecorProducts.insert(0, product);
    _logAudit(
      action: MarketplaceAuditAction.create,
      entityName: 'Home Decor Product',
      entityId: product.id,
      oldValue: 'None',
      newValue: 'Added ${product.name}',
      reason: 'New curated decor catalog addition',
    );
    notifyListeners();
  }

  void updateDecorProduct(HomeDecorProductEntity product) {
    final index = _homeDecorProducts.indexWhere((p) => p.id == product.id);
    if (index != -1) {
      _homeDecorProducts[index] = product;
      _logAudit(
        action: MarketplaceAuditAction.update,
        entityName: 'Home Decor Product',
        entityId: product.id,
        oldValue: 'Updated',
        newValue: 'Updated ${product.name}',
        reason: 'Admin modification of decor item',
      );
      notifyListeners();
    }
  }

  void updateDecorProductStatus(String id, ProductPublicationStatus status) {
    final index = _homeDecorProducts.indexWhere((p) => p.id == id);
    if (index != -1) {
      final current = _homeDecorProducts[index];
      _homeDecorProducts[index] = current.copyWith(publicationStatus: status);
      _logAudit(
        action: MarketplaceAuditAction.update,
        entityName: 'Home Decor Product',
        entityId: id,
        oldValue: current.publicationStatus.name,
        newValue: status.name,
        reason: 'Publication status change',
      );
      notifyListeners();
    }
  }

  void deleteDecorProduct(String id) {
    _homeDecorProducts.removeWhere((p) => p.id == id);
    _logAudit(
      action: MarketplaceAuditAction.delete,
      entityName: 'Home Decor Product',
      entityId: id,
      oldValue: 'Active',
      newValue: 'Deleted',
      reason: 'Admin deletion',
    );
    notifyListeners();
  }


  void recordAffiliateClick(String productId, AffiliatePartner partner, String campaign) {
    final index = _homeDecorProducts.indexWhere((p) => p.id == productId);
    if (index != -1) {
      final p = _homeDecorProducts[index];
      _homeDecorProducts[index] = p.copyWith(
        affiliateClicksCount: p.affiliateClicksCount + 1,
        uniqueClicksCount: p.uniqueClicksCount + 1,
      );
      _affiliateClicks.add(
        AffiliateClickEvent(
          id: 'CLK-${DateTime.now().millisecondsSinceEpoch}',
          productId: productId,
          productTitle: p.name,
          brandName: p.brandName,
          partner: partner,
          campaignName: campaign,
          clickedAt: DateTime.now(),
          visitorIp: '103.21.244.12',
          destinationUrl: p.externalProductUrl,
        ),
      );
      notifyListeners();
    }
  }

  // --- Properties Operations ---
  List<PropertyListingEntity> filterProperties({
    String? query,
    PropertyType? propertyType,
    ListingIntent? intent,
    String? city,
    PropertyVerificationStatus? verificationStatus,
  }) {
    return _properties.where((p) {
      if (query != null && query.isNotEmpty) {
        final q = query.toLowerCase();
        final matches = p.title.toLowerCase().contains(q) ||
            p.locality.toLowerCase().contains(q) ||
            p.city.toLowerCase().contains(q) ||
            p.ownerName.toLowerCase().contains(q);
        if (!matches) return false;
      }
      if (propertyType != null && p.propertyType != propertyType) return false;
      if (intent != null && p.intent != intent) return false;
      if (city != null && city != 'all' && p.city.toLowerCase() != city.toLowerCase()) return false;
      if (verificationStatus != null && p.verificationStatus != verificationStatus) return false;
      return true;
    }).toList();
  }

  void addProperty(PropertyListingEntity property) {
    _properties.insert(0, property);
    _logAudit(
      action: MarketplaceAuditAction.create,
      entityName: 'Property Listing',
      entityId: property.id,
      oldValue: 'None',
      newValue: 'Submitted ${property.title}',
      reason: 'New property listing registered',
    );
    notifyListeners();
  }

  void updateProperty(PropertyListingEntity property) {
    final index = _properties.indexWhere((p) => p.id == property.id);
    if (index != -1) {
      _properties[index] = property;
      _logAudit(
        action: MarketplaceAuditAction.update,
        entityName: 'Property Listing',
        entityId: property.id,
        oldValue: 'Updated',
        newValue: 'Updated ${property.title}',
        reason: 'Admin property update',
      );
      notifyListeners();
    }
  }

  void verifyProperty(String propertyId, PropertyVerificationStatus newStatus, String notes) {
    final index = _properties.indexWhere((p) => p.id == propertyId);
    if (index != -1) {
      final current = _properties[index];
      _properties[index] = current.copyWith(
        verificationStatus: newStatus,
        verificationDate: DateTime.now(),
        verificationNotes: notes,
        verifiedByAdmin: 'Operations Verifier (Current Admin)',
        publicationStatus: newStatus == PropertyVerificationStatus.verified ? ProductPublicationStatus.published : current.publicationStatus,
      );
      _logAudit(
        action: newStatus == PropertyVerificationStatus.verified ? MarketplaceAuditAction.verify : MarketplaceAuditAction.reject,
        entityName: 'Property Listing',
        entityId: propertyId,
        oldValue: current.verificationStatus.label,
        newValue: newStatus.label,
        reason: notes,
      );
      notifyListeners();
    }
  }

  void deleteProperty(String id) {
    _properties.removeWhere((p) => p.id == id);
    _logAudit(
      action: MarketplaceAuditAction.delete,
      entityName: 'Property Listing',
      entityId: id,
      oldValue: 'Active',
      newValue: 'Deleted',
      reason: 'Admin property removal',
    );
    notifyListeners();
  }


  void unlockPropertyContact({
    required String propertyId,
    required String customerName,
    required String customerMobile,
    required String customerEmail,
  }) {
    final index = _properties.indexWhere((p) => p.id == propertyId);
    if (index != -1) {
      final prop = _properties[index];
      final fee = _config.propertyUnlockFee;
      final gst = fee * (_config.propertyUnlockGstRate / 100.0);
      final total = fee + gst;

      final unlockTx = PropertyUnlockTransaction(
        id: 'UNL-${DateTime.now().millisecondsSinceEpoch}',
        customerId: 'CUST-NEW',
        customerName: customerName,
        customerMobile: customerMobile,
        customerEmail: customerEmail,
        propertyId: prop.id,
        propertyTitle: prop.title,
        propertyCity: prop.city,
        unlockFee: fee,
        gstTaxAmount: gst,
        totalPaid: total,
        paymentStatus: PaymentStatus.successful,
        paymentGatewayRef: 'pay_SIM_${DateTime.now().millisecondsSinceEpoch}',
        unlockedAt: DateTime.now(),
        accessExpiresAt: DateTime.now().add(Duration(days: _config.propertyUnlockValidityDays)),
      );

      _unlockTransactions.insert(0, unlockTx);
      _properties[index] = prop.copyWith(
        totalContactUnlocks: prop.totalContactUnlocks + 1,
        grossUnlockRevenue: prop.grossUnlockRevenue + fee,
      );

      _logAudit(
        action: MarketplaceAuditAction.unlockAccess,
        entityName: 'Property Unlock',
        entityId: unlockTx.id,
        oldValue: 'Locked',
        newValue: 'Unlocked for $customerName ($customerMobile)',
        reason: 'Paid unlock fee of ₹$total verified',
      );
      notifyListeners();
    }
  }

  // --- Materials Operations ---
  List<MaterialProductEntity> filterMaterials({
    String? query,
    String? categoryId,
    String? brandName,
    bool? inStockOnly,
  }) {
    return _materials.where((m) {
      if (query != null && query.isNotEmpty) {
        final q = query.toLowerCase();
        final matches = m.name.toLowerCase().contains(q) ||
            m.sku.toLowerCase().contains(q) ||
            m.brandName.toLowerCase().contains(q) ||
            m.primarySupplier.vendorName.toLowerCase().contains(q);
        if (!matches) return false;
      }
      if (categoryId != null && categoryId != 'all' && m.categoryId != categoryId) return false;
      if (brandName != null && brandName != 'all' && m.brandName != brandName) return false;
      if (inStockOnly == true && m.stockAvailableUnits <= 0) return false;
      return true;
    }).toList();
  }

  void addMaterial(MaterialProductEntity material) {
    _materials.insert(0, material);
    _logAudit(
      action: MarketplaceAuditAction.create,
      entityName: 'Material Item',
      entityId: material.id,
      oldValue: 'None',
      newValue: 'Created ${material.name}',
      reason: 'New procurement catalogue addition',
    );
    notifyListeners();
  }

  void updateMaterial(MaterialProductEntity material) {
    final index = _materials.indexWhere((m) => m.id == material.id);
    if (index != -1) {
      _materials[index] = material;
      _logAudit(
        action: MarketplaceAuditAction.update,
        entityName: 'Material Item',
        entityId: material.id,
        oldValue: 'Updated',
        newValue: 'Updated ${material.name}',
        reason: 'Admin price or specification update',
      );
      notifyListeners();
    }
  }

  void updateMaterialStatus(String id, ProductPublicationStatus status) {
    final index = _materials.indexWhere((m) => m.id == id);
    if (index != -1) {
      final current = _materials[index];
      _materials[index] = current.copyWith(publicationStatus: status);
      _logAudit(
        action: MarketplaceAuditAction.update,
        entityName: 'Material Item',
        entityId: id,
        oldValue: current.publicationStatus.name,
        newValue: status.name,
        reason: 'Publication status change',
      );
      notifyListeners();
    }
  }

  void deleteMaterial(String id) {
    _materials.removeWhere((m) => m.id == id);
    _logAudit(
      action: MarketplaceAuditAction.delete,
      entityName: 'Material Item',
      entityId: id,
      oldValue: 'Active',
      newValue: 'Deleted',
      reason: 'Admin deletion of material SKU',
    );
    notifyListeners();
  }


  // --- Order Operations ---
  List<MarketplaceOrderEntity> filterOrders({
    String? query,
    OrderType? orderType,
    OrderStatus? orderStatus,
    PaymentStatus? paymentStatus,
    DeliveryStatus? deliveryStatus,
  }) {
    return _orders.where((o) {
      if (query != null && query.isNotEmpty) {
        final q = query.toLowerCase();
        final matches = o.orderNumber.toLowerCase().contains(q) ||
            o.customerName.toLowerCase().contains(q) ||
            o.customerMobile.contains(q) ||
            o.items.any((i) => i.productName.toLowerCase().contains(q));
        if (!matches) return false;
      }
      if (orderType != null && o.orderType != orderType) return false;
      if (orderStatus != null && o.orderStatus != orderStatus) return false;
      if (paymentStatus != null && o.paymentStatus != paymentStatus) return false;
      if (deliveryStatus != null && o.deliveryStatus != deliveryStatus) return false;
      return true;
    }).toList();
  }

  void assignOrderVendor(String orderId, String vendorId, String vendorName) {
    final index = _orders.indexWhere((o) => o.id == orderId);
    if (index != -1) {
      final o = _orders[index];
      final newTimeline = List<OrderTrackingEvent>.from(o.trackingTimeline)
        ..add(
          OrderTrackingEvent(
            id: 'TRK-${DateTime.now().millisecondsSinceEpoch}',
            eventName: 'Vendor Assigned: $vendorName',
            timestamp: DateTime.now(),
            location: 'Homio Vendor Management Operations',
            executedBy: 'Marketplace Operations Desk',
            notes: 'Official broadcast accepted by supplier $vendorName ($vendorId).',
          ),
        );

      _orders[index] = o.copyWith(
        assignedVendorId: vendorId,
        assignedVendorName: vendorName,
        vendorAssignedAt: DateTime.now(),
        orderStatus: OrderStatus.processing,
        trackingTimeline: newTimeline,
      );

      _logAudit(
        action: MarketplaceAuditAction.assignVendor,
        entityName: 'Marketplace Order',
        entityId: orderId,
        oldValue: o.assignedVendorName ?? 'Unassigned',
        newValue: vendorName,
        reason: 'Supplier allocation confirmed',
      );
      notifyListeners();
    }
  }

  void assignOrderDelivery(String orderId, String deliveryPartner, String contact) {
    final index = _orders.indexWhere((o) => o.id == orderId);
    if (index != -1) {
      final o = _orders[index];
      final newTimeline = List<OrderTrackingEvent>.from(o.trackingTimeline)
        ..add(
          OrderTrackingEvent(
            id: 'TRK-${DateTime.now().millisecondsSinceEpoch}',
            eventName: 'Delivery Partner Assigned: $deliveryPartner',
            timestamp: DateTime.now(),
            location: 'Homio Logistics Command Center',
            executedBy: 'Fleet Logistics Lead',
            notes: 'Assigned to driver $contact.',
          ),
        );

      _orders[index] = o.copyWith(
        assignedDeliveryPartner: deliveryPartner,
        deliveryPartnerContact: contact,
        deliveryAssignedAt: DateTime.now(),
        deliveryStatus: DeliveryStatus.assigned,
        trackingTimeline: newTimeline,
      );

      _logAudit(
        action: MarketplaceAuditAction.assignDelivery,
        entityName: 'Marketplace Order',
        entityId: orderId,
        oldValue: o.assignedDeliveryPartner ?? 'Unassigned',
        newValue: deliveryPartner,
        reason: 'Fleet partner allocated for dispatch',
      );
      notifyListeners();
    }
  }

  void updateOrderStatus(String orderId, OrderStatus newStatus, String location, String note) {
    final index = _orders.indexWhere((o) => o.id == orderId);
    if (index != -1) {
      final o = _orders[index];
      final newTimeline = List<OrderTrackingEvent>.from(o.trackingTimeline)
        ..add(
          OrderTrackingEvent(
            id: 'TRK-${DateTime.now().millisecondsSinceEpoch}',
            eventName: newStatus.label,
            timestamp: DateTime.now(),
            location: location,
            executedBy: 'Marketplace Operations Team',
            notes: note,
          ),
        );

      DeliveryStatus newDelivery = o.deliveryStatus;
      if (newStatus == OrderStatus.inTransit) newDelivery = DeliveryStatus.inTransit;
      if (newStatus == OrderStatus.delivered) newDelivery = DeliveryStatus.delivered;

      _orders[index] = o.copyWith(
        orderStatus: newStatus,
        deliveryStatus: newDelivery,
        actualDeliveredAt: newStatus == OrderStatus.delivered ? DateTime.now() : o.actualDeliveredAt,
        trackingTimeline: newTimeline,
      );

      _logAudit(
        action: MarketplaceAuditAction.statusChange,
        entityName: 'Marketplace Order',
        entityId: orderId,
        oldValue: o.orderStatus.label,
        newValue: newStatus.label,
        reason: note,
      );
      notifyListeners();
    }
  }

  void processOrderRefund(String orderId, double refundAmount, String reason) {
    final index = _orders.indexWhere((o) => o.id == orderId);
    if (index != -1) {
      final o = _orders[index];
      final refund = OrderRefundRecord(
        refundId: 'RFD-${DateTime.now().millisecondsSinceEpoch}',
        refundAmount: refundAmount,
        reason: reason,
        refundStatus: 'Processed & Settled',
        gatewayReference: 'pg_rfd_${DateTime.now().millisecondsSinceEpoch}',
        requestedAt: DateTime.now(),
        processedAt: DateTime.now(),
        approvedBy: 'Finance & Accounting Lead',
      );

      final newTimeline = List<OrderTrackingEvent>.from(o.trackingTimeline)
        ..add(
          OrderTrackingEvent(
            id: 'TRK-${DateTime.now().millisecondsSinceEpoch}',
            eventName: 'Full Order Refund Settled (₹$refundAmount)',
            timestamp: DateTime.now(),
            location: 'Homio Accounting Gateway',
            executedBy: 'Finance Ops Desk',
            notes: 'Refund reason: $reason',
          ),
        );

      _orders[index] = o.copyWith(
        paymentStatus: PaymentStatus.refunded,
        orderStatus: OrderStatus.cancelled,
        refundRecord: refund,
        trackingTimeline: newTimeline,
      );

      _logAudit(
        action: MarketplaceAuditAction.refund,
        entityName: 'Marketplace Order',
        entityId: orderId,
        oldValue: 'Paid: ₹${o.paidAmount}',
        newValue: 'Refunded: ₹$refundAmount',
        reason: reason,
      );
      notifyListeners();
    }
  }

  // --- Approvals Queue ---
  void resolveApproval(String approvalId, bool isApproved, String notes) {
    final index = _approvals.indexWhere((a) => a.id == approvalId);
    if (index != -1) {
      final current = _approvals[index];
      _approvals[index] = MarketplaceApprovalItem(
        id: current.id,
        entityType: current.entityType,
        entityId: current.entityId,
        entityTitle: current.entityTitle,
        categoryName: current.categoryName,
        submittedByName: current.submittedByName,
        submittedAt: current.submittedAt,
        currentStatus: isApproved ? 'Approved' : 'Rejected',
        reviewerName: 'Admin Operations Reviewer',
        priority: current.priority,
        missingInformation: current.missingInformation,
        rejectionReason: isApproved ? null : notes,
      );

      _logAudit(
        action: isApproved ? MarketplaceAuditAction.approve : MarketplaceAuditAction.reject,
        entityName: 'Approval Queue',
        entityId: approvalId,
        oldValue: current.currentStatus,
        newValue: isApproved ? 'Approved' : 'Rejected',
        reason: notes,
      );
      notifyListeners();
    }
  }

  // --- Reviews Moderation ---
  void moderateReview(String reviewId, ReviewStatus newStatus, String? adminReply) {
    final index = _reviews.indexWhere((r) => r.id == reviewId);
    if (index != -1) {
      final current = _reviews[index];
      _reviews[index] = MarketplaceReviewEntity(
        id: current.id,
        customerName: current.customerName,
        customerEmail: current.customerEmail,
        entityType: current.entityType,
        entityId: current.entityId,
        entityTitle: current.entityTitle,
        orderId: current.orderId,
        rating: current.rating,
        reviewTitle: current.reviewTitle,
        reviewText: current.reviewText,
        isVerifiedPurchase: current.isVerifiedPurchase,
        submittedAt: current.submittedAt,
        status: newStatus,
        adminResponse: adminReply ?? current.adminResponse,
      );
      notifyListeners();
    }
  }

  // --- Category & Brand CRUD ---
  void addCategory(MarketplaceCategory category) {
    _categories.add(category);
    _logAudit(
      action: MarketplaceAuditAction.create,
      entityName: 'Category Master',
      entityId: category.id,
      oldValue: 'None',
      newValue: category.name,
      reason: 'New category master created',
    );
    notifyListeners();
  }

  void addBrand(MarketplaceBrand brand) {
    _brands.add(brand);
    _logAudit(
      action: MarketplaceAuditAction.create,
      entityName: 'Brand Master',
      entityId: brand.id,
      oldValue: 'None',
      newValue: brand.name,
      reason: 'New brand onboarded to marketplace',
    );
    notifyListeners();
  }

  // --- Config Rules Update ---
  void updateConfig(MarketplaceConfig newConfig) {
    _config = newConfig;
    _logAudit(
      action: MarketplaceAuditAction.update,
      entityName: 'Marketplace Configuration',
      entityId: 'CONFIG-GLOBAL',
      oldValue: 'Prior Config',
      newValue: 'UnlockFee: ₹${newConfig.propertyUnlockFee}, Expiry: ${newConfig.digitalDownloadLinkExpiryHours}h',
      reason: 'Administrative policy update',
    );
    notifyListeners();
  }

  void _logAudit({
    required MarketplaceAuditAction action,
    required String entityName,
    required String entityId,
    required String oldValue,
    required String newValue,
    required String reason,
  }) {
    _auditRecords.insert(
      0,
      MarketplaceAuditRecord(
        id: 'AUD-${DateTime.now().millisecondsSinceEpoch}',
        userName: 'Admin User',
        userRole: 'Marketplace Operations Super Admin',
        action: action,
        entityName: entityName,
        entityId: entityId,
        timestamp: DateTime.now(),
        oldValue: oldValue,
        newValue: newValue,
        reason: reason,
      ),
    );
  }
}
