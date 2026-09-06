import 'package:flutter/material.dart';

/// Measurement units for architectural items.
enum UnitOfMeasurement {
  sqft('Sq.Ft', 'Square Feet'),
  nos('Nos', 'Per Piece / Units'),
  runningFt('R.Ft', 'Running Feet'),
  lumpSum('LS', 'Lump Sum');

  final String symbol;
  final String label;
  const UnitOfMeasurement(this.symbol, this.label);
}

/// Material tiers for client options.
enum MaterialTier {
  budget('Essential / Budget', 'Engineered wood, 0.8mm standard laminates, standard hardware'),
  premium('Premium', 'BWP Marine Ply, 1.0mm anti-scratch laminates, soft-close hardware'),
  luxury('Luxury / Ultra-Luxe', 'Birch / BWP Calibrated Ply, Acrylic/PU Lacquered finish, Blum/Hafele hardware');

  final String title;
  final String description;
  const MaterialTier(this.title, this.description);
}

/// Lifecycle status for a quotation.
enum QuotationStatus {
  draft('Draft', Icons.edit_note_rounded, Color(0xFF64748B)),
  submitted('Submitted', Icons.send_rounded, Color(0xFF3B82F6)),
  underReview('Under Review', Icons.hourglass_top_rounded, Color(0xFFF59E0B)),
  accepted('Accepted', Icons.check_circle_rounded, Color(0xFF10B981)),
  expired('Discount Expired', Icons.timer_off_rounded, Color(0xFFEF4444)),
  revised('Revised', Icons.published_with_changes_rounded, Color(0xFF8B5CF6));

  final String label;
  final IconData icon;
  final Color color;
  const QuotationStatus(this.label, this.icon, this.color);
}

/// Item categories for the Master Rate Catalogue.
enum ItemCategory {
  civil('Civil & Masonry', Icons.foundation_rounded),
  carpentry('Carpentry & Woodwork', Icons.handyman_rounded),
  modularKitchen('Modular Kitchen', Icons.kitchen_rounded),
  electrical('Electrical & Lighting', Icons.electrical_services_rounded),
  plumbing('Plumbing & Sanitary', Icons.plumbing_rounded),
  falseCeiling('False Ceiling & POP', Icons.roofing_rounded),
  painting('Painting & Polish', Icons.format_paint_rounded),
  hardware('Hardware & Fittings', Icons.build_rounded),
  looseFurniture('Loose Furniture', Icons.chair_rounded),
  softFurnishing('Soft Furnishing & Decor', Icons.curtains_rounded);

  final String label;
  final IconData icon;
  const ItemCategory(this.label, this.icon);
}

/// Master Catalogue entry with technical specifications and rate cards.
class ItemMasterEntry {
  final String id;
  final String name;
  final ItemCategory category;
  final String technicalSpecs;
  final String imageUrl;
  final UnitOfMeasurement uom;
  final double baseCostRate;
  final double marginPercent;
  final double gstPercent;
  final List<String> approvedBrands;
  final bool isActive;

  const ItemMasterEntry({
    required this.id,
    required this.name,
    required this.category,
    required this.technicalSpecs,
    required this.imageUrl,
    required this.uom,
    required this.baseCostRate,
    required this.marginPercent,
    this.gstPercent = 18.0,
    required this.approvedBrands,
    this.isActive = true,
  });

  /// Selling rate computed from base rate + margin markup
  double get sellingRate => baseCostRate * (1 + (marginPercent / 100.0));

  ItemMasterEntry copyWith({
    String? id,
    String? name,
    ItemCategory? category,
    String? technicalSpecs,
    String? imageUrl,
    UnitOfMeasurement? uom,
    double? baseCostRate,
    double? marginPercent,
    double? gstPercent,
    List<String>? approvedBrands,
    bool? isActive,
  }) {
    return ItemMasterEntry(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      technicalSpecs: technicalSpecs ?? this.technicalSpecs,
      imageUrl: imageUrl ?? this.imageUrl,
      uom: uom ?? this.uom,
      baseCostRate: baseCostRate ?? this.baseCostRate,
      marginPercent: marginPercent ?? this.marginPercent,
      gstPercent: gstPercent ?? this.gstPercent,
      approvedBrands: approvedBrands ?? this.approvedBrands,
      isActive: isActive ?? this.isActive,
    );
  }
}

/// Individual line item within a room's BOQ.
class QuotationItem {
  final String id;
  final String itemMasterId;
  final String name;
  final ItemCategory category;
  final String materialSpecs;
  final UnitOfMeasurement uom;
  final double quantity;
  final double rate;
  final double marginPercent;
  final String? imageUrl;
  final String? notes;

  const QuotationItem({
    required this.id,
    required this.itemMasterId,
    required this.name,
    required this.category,
    required this.materialSpecs,
    required this.uom,
    required this.quantity,
    required this.rate,
    required this.marginPercent,
    this.imageUrl,
    this.notes,
  });

  /// Total amount for this item
  double get amount => quantity * rate;

  QuotationItem copyWith({
    String? id,
    String? itemMasterId,
    String? name,
    ItemCategory? category,
    String? materialSpecs,
    UnitOfMeasurement? uom,
    double? quantity,
    double? rate,
    double? marginPercent,
    String? imageUrl,
    String? notes,
  }) {
    return QuotationItem(
      id: id ?? this.id,
      itemMasterId: itemMasterId ?? this.itemMasterId,
      name: name ?? this.name,
      category: category ?? this.category,
      materialSpecs: materialSpecs ?? this.materialSpecs,
      uom: uom ?? this.uom,
      quantity: quantity ?? this.quantity,
      rate: rate ?? this.rate,
      marginPercent: marginPercent ?? this.marginPercent,
      imageUrl: imageUrl ?? this.imageUrl,
      notes: notes ?? this.notes,
    );
  }
}

/// Room or Area breakdown within a quotation.
class RoomArea {
  final String id;
  final String roomName;
  final double lengthFt;
  final double widthFt;
  final double heightFt;
  final MaterialTier tier;
  final List<QuotationItem> items;

  const RoomArea({
    required this.id,
    required this.roomName,
    required this.lengthFt,
    required this.widthFt,
    required this.heightFt,
    required this.tier,
    required this.items,
  });

  /// Computed carpet area in square feet
  double get carpetSqft => lengthFt * widthFt;

  /// Computed 4-wall perimeter surface area in square feet
  double get wallSqft => 2 * (lengthFt + widthFt) * heightFt;

  /// Total cost of all items in this room
  double get roomSubtotal => items.fold(0.0, (sum, item) => sum + item.amount);

  RoomArea copyWith({
    String? id,
    String? roomName,
    double? lengthFt,
    double? widthFt,
    double? heightFt,
    MaterialTier? tier,
    List<QuotationItem>? items,
  }) {
    return RoomArea(
      id: id ?? this.id,
      roomName: roomName ?? this.roomName,
      lengthFt: lengthFt ?? this.lengthFt,
      widthFt: widthFt ?? this.widthFt,
      heightFt: heightFt ?? this.heightFt,
      tier: tier ?? this.tier,
      items: items ?? this.items,
    );
  }
}

/// Complete Quotation Entity.
class Quotation {
  final String id;
  final String quoteNumber;
  final int revisionNumber;
  final String leadId;
  final String clientName;
  final String clientPhone;
  final String clientEmail;
  final String projectTitle;
  final String projectLocation;
  final String designerName;
  final String coverImageUrl;
  final DateTime submissionDate;
  final DateTime discountExpiryDate;
  final QuotationStatus status;

  // Granular Display Visibility Toggles (PRD Section 9.2 & docs/requirmenet.md)
  final bool hideRate; // Hide unit rate column
  final bool hideSqft; // Hide dimensions / sqft to prevent contractor poaching
  final bool showAmount; // Show total lump sum amount

  final List<RoomArea> rooms;
  final double discountPercent; // e.g., 8.0%
  final double gstPercent; // default 18.0%
  final String? termsAndConditions;

  const Quotation({
    required this.id,
    required this.quoteNumber,
    this.revisionNumber = 1,
    required this.leadId,
    required this.clientName,
    required this.clientPhone,
    required this.clientEmail,
    required this.projectTitle,
    required this.projectLocation,
    required this.designerName,
    required this.coverImageUrl,
    required this.submissionDate,
    required this.discountExpiryDate,
    this.status = QuotationStatus.draft,
    this.hideRate = false,
    this.hideSqft = false,
    this.showAmount = true,
    required this.rooms,
    this.discountPercent = 0.0,
    this.gstPercent = 18.0,
    this.termsAndConditions,
  });

  /// Total carpet area across all rooms
  double get totalCarpetSqft => rooms.fold(0.0, (sum, r) => sum + r.carpetSqft);

  /// Gross cost across all rooms before discount & tax
  double get grossSubtotal => rooms.fold(0.0, (sum, r) => sum + r.roomSubtotal);

  /// Discount value in INR
  double get discountAmount => grossSubtotal * (discountPercent / 100.0);

  /// Taxable subtotal after discount
  double get taxableAmount => grossSubtotal - discountAmount;

  /// GST 18% amount in INR
  double get gstAmount => taxableAmount * (gstPercent / 100.0);

  /// Net Grand Total payable
  double get grandTotal => taxableAmount + gstAmount;

  /// Check whether the early-bird discount has expired
  bool get isDiscountExpired => DateTime.now().isAfter(discountExpiryDate);

  /// Time remaining before discount expiration
  Duration get timeRemaining => discountExpiryDate.difference(DateTime.now());

  Quotation copyWith({
    String? id,
    String? quoteNumber,
    int? revisionNumber,
    String? leadId,
    String? clientName,
    String? clientPhone,
    String? clientEmail,
    String? projectTitle,
    String? projectLocation,
    String? designerName,
    String? coverImageUrl,
    DateTime? submissionDate,
    DateTime? discountExpiryDate,
    QuotationStatus? status,
    bool? hideRate,
    bool? hideSqft,
    bool? showAmount,
    List<RoomArea>? rooms,
    double? discountPercent,
    double? gstPercent,
    String? termsAndConditions,
  }) {
    return Quotation(
      id: id ?? this.id,
      quoteNumber: quoteNumber ?? this.quoteNumber,
      revisionNumber: revisionNumber ?? this.revisionNumber,
      leadId: leadId ?? this.leadId,
      clientName: clientName ?? this.clientName,
      clientPhone: clientPhone ?? this.clientPhone,
      clientEmail: clientEmail ?? this.clientEmail,
      projectTitle: projectTitle ?? this.projectTitle,
      projectLocation: projectLocation ?? this.projectLocation,
      designerName: designerName ?? this.designerName,
      coverImageUrl: coverImageUrl ?? this.coverImageUrl,
      submissionDate: submissionDate ?? this.submissionDate,
      discountExpiryDate: discountExpiryDate ?? this.discountExpiryDate,
      status: status ?? this.status,
      hideRate: hideRate ?? this.hideRate,
      hideSqft: hideSqft ?? this.hideSqft,
      showAmount: showAmount ?? this.showAmount,
      rooms: rooms ?? this.rooms,
      discountPercent: discountPercent ?? this.discountPercent,
      gstPercent: gstPercent ?? this.gstPercent,
      termsAndConditions: termsAndConditions ?? this.termsAndConditions,
    );
  }
}

/// Dynamic Pricing & WhatsApp 24h Expiry Log Entry (PRD Section 9.4 & TC-QUOT-001)
class UrgencyAlertLog {
  final String id;
  final String quotationId;
  final String quoteNumber;
  final String clientName;
  final String clientPhone;
  final double quotationAmount;
  final double discountAmount;
  final DateTime expiryDate;
  final DateTime scheduledAlertTime;
  final bool isTriggered;
  final DateTime? triggeredAt;
  final String deliveryStatus; // "SCHEDULED", "DISPATCHED", "DELIVERED", "READ", "LOCKED_IN"
  final String whatsappMessagePreview;

  const UrgencyAlertLog({
    required this.id,
    required this.quotationId,
    required this.quoteNumber,
    required this.clientName,
    required this.clientPhone,
    required this.quotationAmount,
    required this.discountAmount,
    required this.expiryDate,
    required this.scheduledAlertTime,
    this.isTriggered = false,
    this.triggeredAt,
    this.deliveryStatus = 'SCHEDULED',
    required this.whatsappMessagePreview,
  });
}

/// B2C Customer Self-Estimator inquiry captured via OTP verification (PRD Section 9.5)
class CustomerSelfEstimateLead {
  final String id;
  final String name;
  final String phone;
  final String email;
  final String propertyType; // "1BHK", "2BHK", "3BHK", "4BHK", "Villa", "Commercial"
  final double carpetAreaSqft;
  final MaterialTier tier;
  final List<String> selectedRooms;
  final double estimatedMinBudget;
  final double estimatedMaxBudget;
  final bool isOtpVerified;
  final DateTime createdAt;
  final String crmLeadStatus; // "SYNCED_TO_SALES", "CONTACTED", "SITE_VISIT_BOOKED"

  const CustomerSelfEstimateLead({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.propertyType,
    required this.carpetAreaSqft,
    required this.tier,
    required this.selectedRooms,
    required this.estimatedMinBudget,
    required this.estimatedMaxBudget,
    this.isOtpVerified = true,
    required this.createdAt,
    this.crmLeadStatus = 'SYNCED_TO_SALES',
  });
}
