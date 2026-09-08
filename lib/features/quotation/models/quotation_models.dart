import 'package:flutter/material.dart';

/// Measurement units for architectural items.
enum UnitOfMeasurement {
  sqft('Sq.Ft', 'Square Feet'),
  nos('Nos', 'Per Piece / Units'),
  runningFt('R.Ft', 'Running Feet'),
  lumpSum('LS', 'Lump Sum'),
  sqMtr('Sq.M', 'Square Meters'),
  cft('CFT', 'Cubic Feet');

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

/// Lifecycle status for a quotation (PRD Section 4.4).
enum QuotationStatus {
  draft('Draft', Icons.edit_note_rounded, Color(0xFF64748B)),
  internalReview('Internal Review', Icons.rate_review_rounded, Color(0xFF0EA5E9)),
  readyToSend('Ready to Send', Icons.mark_email_read_rounded, Color(0xFF6366F1)),
  submitted('Submitted', Icons.send_rounded, Color(0xFF3B82F6)),
  sent('Sent', Icons.forward_to_inbox_rounded, Color(0xFF2563EB)),
  viewed('Viewed', Icons.visibility_rounded, Color(0xFF8B5CF6)),
  underReview('Under Review', Icons.hourglass_top_rounded, Color(0xFFF59E0B)),
  accepted('Accepted', Icons.check_circle_rounded, Color(0xFF10B981)),
  booked('Booked', Icons.verified_rounded, Color(0xFF059669)),
  rejected('Rejected', Icons.cancel_rounded, Color(0xFFEF4444)),
  expired('Discount Expired', Icons.timer_off_rounded, Color(0xFFDC2626)),
  revised('Revised', Icons.published_with_changes_rounded, Color(0xFFA855F7)),
  cancelled('Cancelled', Icons.block_rounded, Color(0xFF94A3B8)),
  archived('Archived', Icons.archive_rounded, Color(0xFF475569));

  final String label;
  final IconData icon;
  final Color color;
  const QuotationStatus(this.label, this.icon, this.color);
}

/// Quotation classification type.
enum QuotationType {
  residentialInterior('Residential Interior', Icons.home_rounded),
  turnkey('Turnkey Execution', Icons.construction_rounded),
  modularKitchen('Modular Kitchen & Wardrobes', Icons.kitchen_rounded),
  luxuryVilla('Luxury Villa', Icons.villa_rounded),
  commercialOffice('Commercial / Office', Icons.business_rounded),
  renovation('Home Renovation', Icons.auto_fix_high_rounded),
  architecturalConsulting('Design & Consulting', Icons.architecture_rounded);

  final String label;
  final IconData icon;
  const QuotationType(this.label, this.icon);
}

/// Discount calculation type.
enum DiscountType {
  percentage('Percentage (%)'),
  fixedAmount('Flat Discount (₹)');

  final String label;
  const DiscountType(this.label);
}

/// Internal approval status.
enum ApprovalStatus {
  pending('Pending Approval', Icons.hourglass_empty_rounded, Color(0xFFF59E0B)),
  approved('Approved', Icons.check_circle_rounded, Color(0xFF10B981)),
  rejected('Rejected', Icons.cancel_rounded, Color(0xFFEF4444)),
  notRequired('Auto Approved', Icons.done_all_rounded, Color(0xFF64748B));

  final String label;
  final IconData icon;
  final Color color;
  const ApprovalStatus(this.label, this.icon, this.color);
}

/// Reminder dispatch & tracking status.
enum ReminderStatus {
  scheduled('Scheduled', Icons.schedule_rounded, Color(0xFF6366F1)),
  dispatched('Dispatched', Icons.send_rounded, Color(0xFF3B82F6)),
  delivered('Delivered', Icons.done_all_rounded, Color(0xFF10B981)),
  read('Read', Icons.mark_chat_read_rounded, Color(0xFF0EA5E9)),
  lockedIn('Locked In', Icons.lock_clock_rounded, Color(0xFF059669)),
  failed('Failed', Icons.error_outline_rounded, Color(0xFFEF4444));

  final String label;
  final IconData icon;
  final Color color;
  const ReminderStatus(this.label, this.icon, this.color);
}

/// Document sections for PDF & Proposal generation.
enum DocumentSectionType {
  coverPage('Cover Page', Icons.newspaper_rounded),
  executiveSummary('Executive Summary', Icons.summarize_rounded),
  scopeOfWork('Scope of Work', Icons.assignment_rounded),
  boqItemized('Itemized BOQ Costing', Icons.table_chart_rounded),
  roomBreakdown('Room-Wise Cost Summary', Icons.meeting_room_rounded),
  materialSpecs('Material & Finish Specifications', Icons.palette_rounded),
  renderGallery('3D Renderings & Concepts', Icons.image_rounded),
  paymentMilestones('Payment Milestones', Icons.payments_rounded),
  termsAndConditions('Terms & Conditions', Icons.gavel_rounded),
  warrantyAndSignoff('Warranty & Client Sign-off', Icons.verified_user_rounded),
  companyProfile('About Homio & Team', Icons.info_outline_rounded);

  final String label;
  final IconData icon;
  const DocumentSectionType(this.label, this.icon);
}

/// Standard architectural room types.
enum RoomAreaType {
  livingRoom('Living Room', Icons.weekend_rounded),
  masterBedroom('Master Bedroom', Icons.king_bed_rounded),
  guestBedroom('Guest Bedroom', Icons.single_bed_rounded),
  kidsBedroom('Kids Bedroom', Icons.child_friendly_rounded),
  kitchen('Modular Kitchen', Icons.kitchen_rounded),
  diningArea('Dining Area', Icons.restaurant_rounded),
  balcony('Balcony / Terrace', Icons.deck_rounded),
  bathroom('Bathroom / Powder Room', Icons.bathtub_rounded),
  poojaRoom('Pooja Room', Icons.temple_hindu_rounded),
  foyer('Entrance Foyer', Icons.door_front_door_rounded),
  utility('Utility Area', Icons.local_laundry_service_rounded),
  homeOffice('Home Office / Study', Icons.computer_rounded),
  entertainment('Home Theater / Lounge', Icons.tv_rounded),
  other('Other Custom Space', Icons.space_dashboard_rounded);

  final String label;
  final IconData icon;
  const RoomAreaType(this.label, this.icon);
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

/// Customer entity linked to quotation.
class CustomerInfo {
  final String id;
  final String name;
  final String phone;
  final String email;
  final String? address;
  final String? city;
  final String? state;
  final String? pinCode;
  final String? company;
  final String? gstin;
  final String leadSource;

  const CustomerInfo({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    this.address,
    this.city,
    this.state,
    this.pinCode,
    this.company,
    this.gstin,
    this.leadSource = 'Direct Website',
  });

  CustomerInfo copyWith({
    String? id,
    String? name,
    String? phone,
    String? email,
    String? address,
    String? city,
    String? state,
    String? pinCode,
    String? company,
    String? gstin,
    String? leadSource,
  }) {
    return CustomerInfo(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      address: address ?? this.address,
      city: city ?? this.city,
      state: state ?? this.state,
      pinCode: pinCode ?? this.pinCode,
      company: company ?? this.company,
      gstin: gstin ?? this.gstin,
      leadSource: leadSource ?? this.leadSource,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CustomerInfo && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

/// Project entity linked to quotation.
class ProjectInfo {
  final String id;
  final String name;
  final String code;
  final String type;
  final String location;
  final String city;
  final String projectManager;
  final String designer;
  final DateTime? startDate;
  final DateTime? targetCompletionDate;
  final double totalBudget;

  const ProjectInfo({
    required this.id,
    required this.name,
    required this.code,
    this.type = 'Full Interior',
    required this.location,
    this.city = 'Bangalore',
    required this.projectManager,
    required this.designer,
    this.startDate,
    this.targetCompletionDate,
    this.totalBudget = 0.0,
  });

  ProjectInfo copyWith({
    String? id,
    String? name,
    String? code,
    String? type,
    String? location,
    String? city,
    String? projectManager,
    String? designer,
    DateTime? startDate,
    DateTime? targetCompletionDate,
    double? totalBudget,
  }) {
    return ProjectInfo(
      id: id ?? this.id,
      name: name ?? this.name,
      code: code ?? this.code,
      type: type ?? this.type,
      location: location ?? this.location,
      city: city ?? this.city,
      projectManager: projectManager ?? this.projectManager,
      designer: designer ?? this.designer,
      startDate: startDate ?? this.startDate,
      targetCompletionDate: targetCompletionDate ?? this.targetCompletionDate,
      totalBudget: totalBudget ?? this.totalBudget,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProjectInfo && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

/// Payment milestone for scheduled drawdowns.
class PaymentMilestone {
  final String id;
  final String title;
  final double percentage; // e.g. 10.0%
  final double amount;
  final DateTime? dueDate;
  final String triggerEvent; // e.g. "Booking advance", "On carcass completion"
  final bool isPaid;
  final DateTime? paidDate;
  final String? paymentReference;

  const PaymentMilestone({
    required this.id,
    required this.title,
    required this.percentage,
    required this.amount,
    this.dueDate,
    required this.triggerEvent,
    this.isPaid = false,
    this.paidDate,
    this.paymentReference,
  });

  PaymentMilestone copyWith({
    String? id,
    String? title,
    double? percentage,
    double? amount,
    DateTime? dueDate,
    String? triggerEvent,
    bool? isPaid,
    DateTime? paidDate,
    String? paymentReference,
  }) {
    return PaymentMilestone(
      id: id ?? this.id,
      title: title ?? this.title,
      percentage: percentage ?? this.percentage,
      amount: amount ?? this.amount,
      dueDate: dueDate ?? this.dueDate,
      triggerEvent: triggerEvent ?? this.triggerEvent,
      isPaid: isPaid ?? this.isPaid,
      paidDate: paidDate ?? this.paidDate,
      paymentReference: paymentReference ?? this.paymentReference,
    );
  }
}

/// Version history revision for quotation.
class QuotationRevision {
  final String id;
  final String quotationId;
  final int revisionNumber;
  final String title;
  final String changesSummary;
  final double previousTotal;
  final double newTotal;
  final DateTime createdAt;
  final String createdBy;
  final String? approvedBy;
  final String? diffNotes;

  const QuotationRevision({
    required this.id,
    required this.quotationId,
    required this.revisionNumber,
    required this.title,
    required this.changesSummary,
    required this.previousTotal,
    required this.newTotal,
    required this.createdAt,
    required this.createdBy,
    this.approvedBy,
    this.diffNotes,
  });
}

/// Quotation internal approval step.
class QuotationApproval {
  final String id;
  final String approverName;
  final String approverRole;
  final ApprovalStatus status;
  final String? comments;
  final DateTime requestedAt;
  final DateTime? respondedAt;

  const QuotationApproval({
    required this.id,
    required this.approverName,
    required this.approverRole,
    this.status = ApprovalStatus.pending,
    this.comments,
    required this.requestedAt,
    this.respondedAt,
  });

  QuotationApproval copyWith({
    String? id,
    String? approverName,
    String? approverRole,
    ApprovalStatus? status,
    String? comments,
    DateTime? requestedAt,
    DateTime? respondedAt,
  }) {
    return QuotationApproval(
      id: id ?? this.id,
      approverName: approverName ?? this.approverName,
      approverRole: approverRole ?? this.approverRole,
      status: status ?? this.status,
      comments: comments ?? this.comments,
      requestedAt: requestedAt ?? this.requestedAt,
      respondedAt: respondedAt ?? this.respondedAt,
    );
  }
}

/// Audit trail activity log.
class QuotationActivity {
  final String id;
  final String quotationId;
  final DateTime timestamp;
  final String actorName;
  final String actorRole;
  final String action;
  final String description;
  final String? oldValue;
  final String? newValue;
  final IconData icon;

  const QuotationActivity({
    required this.id,
    required this.quotationId,
    required this.timestamp,
    required this.actorName,
    required this.actorRole,
    required this.action,
    required this.description,
    this.oldValue,
    this.newValue,
    this.icon = Icons.info_outline_rounded,
  });
}

/// Generated document artifact.
class QuotationDocument {
  final String id;
  final String quotationId;
  final String title;
  final String fileName;
  final String fileType; // PDF, XLS, DOCX
  final int fileSizeKb;
  final String url;
  final DateTime generatedAt;
  final String generatedBy;
  final int version;
  final bool isSigned;
  final bool isClientViewable;

  const QuotationDocument({
    required this.id,
    required this.quotationId,
    required this.title,
    required this.fileName,
    this.fileType = 'PDF',
    required this.fileSizeKb,
    required this.url,
    required this.generatedAt,
    required this.generatedBy,
    this.version = 1,
    this.isSigned = false,
    this.isClientViewable = true,
  });
}

/// Granular display visibility settings for client-facing PDF/Portal.
class VisibilitySettings {
  final bool hideRate;
  final bool hideSqft;
  final bool showAmount;
  final bool hideCostPrice;
  final bool hideMargin;
  final bool hideBrand;
  final bool hideDimensions;
  final bool hideMaterialSpecs;
  final bool showPaymentSchedule;

  const VisibilitySettings({
    this.hideRate = false,
    this.hideSqft = false,
    this.showAmount = true,
    this.hideCostPrice = true,
    this.hideMargin = true,
    this.hideBrand = false,
    this.hideDimensions = false,
    this.hideMaterialSpecs = false,
    this.showPaymentSchedule = true,
  });

  VisibilitySettings copyWith({
    bool? hideRate,
    bool? hideSqft,
    bool? showAmount,
    bool? hideCostPrice,
    bool? hideMargin,
    bool? hideBrand,
    bool? hideDimensions,
    bool? hideMaterialSpecs,
    bool? showPaymentSchedule,
  }) {
    return VisibilitySettings(
      hideRate: hideRate ?? this.hideRate,
      hideSqft: hideSqft ?? this.hideSqft,
      showAmount: showAmount ?? this.showAmount,
      hideCostPrice: hideCostPrice ?? this.hideCostPrice,
      hideMargin: hideMargin ?? this.hideMargin,
      hideBrand: hideBrand ?? this.hideBrand,
      hideDimensions: hideDimensions ?? this.hideDimensions,
      hideMaterialSpecs: hideMaterialSpecs ?? this.hideMaterialSpecs,
      showPaymentSchedule: showPaymentSchedule ?? this.showPaymentSchedule,
    );
  }
}

/// PDF Document Builder Configuration.
class DocumentConfig {
  final String templateId;
  final String coverTitle;
  final String coverSubtitle;
  final bool include3dRender;
  final bool showCompanyLogo;
  final bool showClientAddress;
  final List<DocumentSectionType> selectedSections;
  final String themeColorHex;
  final bool signatureRequired;

  const DocumentConfig({
    this.templateId = 'tmpl_standard_01',
    this.coverTitle = 'Interior Architecture & Estimation Proposal',
    this.coverSubtitle = 'Custom-Crafted Living Spaces for Modern Living',
    this.include3dRender = true,
    this.showCompanyLogo = true,
    this.showClientAddress = true,
    this.selectedSections = const [
      DocumentSectionType.coverPage,
      DocumentSectionType.executiveSummary,
      DocumentSectionType.scopeOfWork,
      DocumentSectionType.boqItemized,
      DocumentSectionType.roomBreakdown,
      DocumentSectionType.paymentMilestones,
      DocumentSectionType.termsAndConditions,
    ],
    this.themeColorHex = '#1E3A8A',
    this.signatureRequired = true,
  });

  DocumentConfig copyWith({
    String? templateId,
    String? coverTitle,
    String? coverSubtitle,
    bool? include3dRender,
    bool? showCompanyLogo,
    bool? showClientAddress,
    List<DocumentSectionType>? selectedSections,
    String? themeColorHex,
    bool? signatureRequired,
  }) {
    return DocumentConfig(
      templateId: templateId ?? this.templateId,
      coverTitle: coverTitle ?? this.coverTitle,
      coverSubtitle: coverSubtitle ?? this.coverSubtitle,
      include3dRender: include3dRender ?? this.include3dRender,
      showCompanyLogo: showCompanyLogo ?? this.showCompanyLogo,
      showClientAddress: showClientAddress ?? this.showClientAddress,
      selectedSections: selectedSections ?? this.selectedSections,
      themeColorHex: themeColorHex ?? this.themeColorHex,
      signatureRequired: signatureRequired ?? this.signatureRequired,
    );
  }
}

/// Reusable Document & Proposal Template.
class QuotationTemplate {
  final String id;
  final String name;
  final String description;
  final QuotationType type;
  final bool isDefault;
  final String coverTheme;
  final String primaryColorHex;
  final String fontName;
  final String? headerLogoUrl;
  final String footerNote;
  final String termsAndConditions;
  final List<DocumentSectionType> includedSections;

  const QuotationTemplate({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    this.isDefault = false,
    this.coverTheme = 'Modern Elegance',
    this.primaryColorHex = '#1E3A8A',
    this.fontName = 'Inter',
    this.headerLogoUrl,
    required this.footerNote,
    required this.termsAndConditions,
    required this.includedSections,
  });
}

/// Named Rate Card with tier multiplier & item overrides.
class RateCard {
  final String id;
  final String name;
  final String description;
  final MaterialTier tier;
  final DateTime effectiveDate;
  final bool isActive;
  final bool isDefault;
  final double markupPercent;
  final Map<String, double> itemRateOverrides; // itemId -> customSellingRate

  const RateCard({
    required this.id,
    required this.name,
    required this.description,
    required this.tier,
    required this.effectiveDate,
    this.isActive = true,
    this.isDefault = false,
    this.markupPercent = 25.0,
    this.itemRateOverrides = const {},
  });

  RateCard copyWith({
    String? id,
    String? name,
    String? description,
    MaterialTier? tier,
    DateTime? effectiveDate,
    bool? isActive,
    bool? isDefault,
    double? markupPercent,
    Map<String, double>? itemRateOverrides,
  }) {
    return RateCard(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      tier: tier ?? this.tier,
      effectiveDate: effectiveDate ?? this.effectiveDate,
      isActive: isActive ?? this.isActive,
      isDefault: isDefault ?? this.isDefault,
      markupPercent: markupPercent ?? this.markupPercent,
      itemRateOverrides: itemRateOverrides ?? this.itemRateOverrides,
    );
  }
}

/// Audit log entry for Rate changes.
class RateHistoryEntry {
  final String id;
  final String itemMasterId;
  final String itemName;
  final double oldBaseRate;
  final double newBaseRate;
  final double oldSellingRate;
  final double newSellingRate;
  final String changedBy;
  final String changeReason;
  final DateTime changedAt;

  const RateHistoryEntry({
    required this.id,
    required this.itemMasterId,
    required this.itemName,
    required this.oldBaseRate,
    required this.newBaseRate,
    required this.oldSellingRate,
    required this.newSellingRate,
    required this.changedBy,
    required this.changeReason,
    required this.changedAt,
  });
}

/// Master Catalogue entry with technical specifications and rate cards.
class ItemMasterEntry {
  final String id;
  final String sku;
  final String name;
  final ItemCategory category;
  final String subcategory;
  final String technicalSpecs;
  final String description;
  final String imageUrl;
  final List<String> galleryUrls;
  final UnitOfMeasurement uom;
  final double baseCostRate;
  final double marginPercent;
  final double minRate;
  final double maxRate;
  final double gstPercent;
  final List<String> approvedBrands;
  final String? preferredVendor;
  final List<String> tags;
  final bool isActive;

  const ItemMasterEntry({
    required this.id,
    this.sku = '',
    required this.name,
    required this.category,
    this.subcategory = 'Standard',
    required this.technicalSpecs,
    this.description = '',
    required this.imageUrl,
    this.galleryUrls = const [],
    required this.uom,
    required this.baseCostRate,
    required this.marginPercent,
    this.minRate = 0.0,
    this.maxRate = 0.0,
    this.gstPercent = 18.0,
    required this.approvedBrands,
    this.preferredVendor,
    this.tags = const [],
    this.isActive = true,
  });

  /// Selling rate computed from base rate + margin markup
  double get sellingRate => baseCostRate * (1 + (marginPercent / 100.0));

  ItemMasterEntry copyWith({
    String? id,
    String? sku,
    String? name,
    ItemCategory? category,
    String? subcategory,
    String? technicalSpecs,
    String? description,
    String? imageUrl,
    List<String>? galleryUrls,
    UnitOfMeasurement? uom,
    double? baseCostRate,
    double? marginPercent,
    double? minRate,
    double? maxRate,
    double? gstPercent,
    List<String>? approvedBrands,
    String? preferredVendor,
    List<String>? tags,
    bool? isActive,
  }) {
    return ItemMasterEntry(
      id: id ?? this.id,
      sku: sku ?? this.sku,
      name: name ?? this.name,
      category: category ?? this.category,
      subcategory: subcategory ?? this.subcategory,
      technicalSpecs: technicalSpecs ?? this.technicalSpecs,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      galleryUrls: galleryUrls ?? this.galleryUrls,
      uom: uom ?? this.uom,
      baseCostRate: baseCostRate ?? this.baseCostRate,
      marginPercent: marginPercent ?? this.marginPercent,
      minRate: minRate ?? this.minRate,
      maxRate: maxRate ?? this.maxRate,
      gstPercent: gstPercent ?? this.gstPercent,
      approvedBrands: approvedBrands ?? this.approvedBrands,
      preferredVendor: preferredVendor ?? this.preferredVendor,
      tags: tags ?? this.tags,
      isActive: isActive ?? this.isActive,
    );
  }
}

/// Individual line item within a room's BOQ.
class QuotationItem {
  final String id;
  final String itemMasterId;
  final String itemCode;
  final String name;
  final ItemCategory category;
  final String subcategory;
  final String materialSpecs;
  final String? brand;
  final String? model;
  final String? finish;
  final String? colour;
  final UnitOfMeasurement uom;
  final double length;
  final double width;
  final double height;
  final double quantity;
  final double rate;
  final double marginPercent;
  final double discountPercent;
  final double taxPercent;
  final String? imageUrl;
  final String? notes;
  final bool isVisible;

  const QuotationItem({
    required this.id,
    required this.itemMasterId,
    this.itemCode = '',
    required this.name,
    required this.category,
    this.subcategory = '',
    required this.materialSpecs,
    this.brand,
    this.model,
    this.finish,
    this.colour,
    required this.uom,
    this.length = 0.0,
    this.width = 0.0,
    this.height = 0.0,
    required this.quantity,
    required this.rate,
    required this.marginPercent,
    this.discountPercent = 0.0,
    this.taxPercent = 18.0,
    this.imageUrl,
    this.notes,
    this.isVisible = true,
  });

  /// Base gross amount before discount
  double get baseAmount => quantity * rate;

  /// Discount amount for item
  double get discountAmount => baseAmount * (discountPercent / 100.0);

  /// Net item total amount after item-level discount
  double get amount => baseAmount - discountAmount;

  QuotationItem copyWith({
    String? id,
    String? itemMasterId,
    String? itemCode,
    String? name,
    ItemCategory? category,
    String? subcategory,
    String? materialSpecs,
    String? brand,
    String? model,
    String? finish,
    String? colour,
    UnitOfMeasurement? uom,
    double? length,
    double? width,
    double? height,
    double? quantity,
    double? rate,
    double? marginPercent,
    double? discountPercent,
    double? taxPercent,
    String? imageUrl,
    String? notes,
    bool? isVisible,
  }) {
    return QuotationItem(
      id: id ?? this.id,
      itemMasterId: itemMasterId ?? this.itemMasterId,
      itemCode: itemCode ?? this.itemCode,
      name: name ?? this.name,
      category: category ?? this.category,
      subcategory: subcategory ?? this.subcategory,
      materialSpecs: materialSpecs ?? this.materialSpecs,
      brand: brand ?? this.brand,
      model: model ?? this.model,
      finish: finish ?? this.finish,
      colour: colour ?? this.colour,
      uom: uom ?? this.uom,
      length: length ?? this.length,
      width: width ?? this.width,
      height: height ?? this.height,
      quantity: quantity ?? this.quantity,
      rate: rate ?? this.rate,
      marginPercent: marginPercent ?? this.marginPercent,
      discountPercent: discountPercent ?? this.discountPercent,
      taxPercent: taxPercent ?? this.taxPercent,
      imageUrl: imageUrl ?? this.imageUrl,
      notes: notes ?? this.notes,
      isVisible: isVisible ?? this.isVisible,
    );
  }
}

/// Room or Area breakdown within a quotation.
class RoomArea {
  final String id;
  final String roomName;
  final RoomAreaType areaType;
  final String? customName;
  final int floor;
  final double lengthFt;
  final double widthFt;
  final double heightFt;
  final MaterialTier tier;
  final String? description;
  final String? referenceImageUrl;
  final String? notes;
  final List<QuotationItem> items;

  const RoomArea({
    required this.id,
    required this.roomName,
    this.areaType = RoomAreaType.livingRoom,
    this.customName,
    this.floor = 0,
    required this.lengthFt,
    required this.widthFt,
    required this.heightFt,
    required this.tier,
    this.description,
    this.referenceImageUrl,
    this.notes,
    required this.items,
  });

  /// Computed carpet area in square feet
  double get carpetSqft => lengthFt * widthFt;

  /// Computed 4-wall perimeter surface area in square feet
  double get wallSqft => 2 * (lengthFt + widthFt) * heightFt;

  /// Computed ceiling area in square feet
  double get ceilingSqft => lengthFt * widthFt;

  /// Total cost of all items in this room
  double get roomSubtotal => items.fold(0.0, (sum, item) => sum + item.amount);

  RoomArea copyWith({
    String? id,
    String? roomName,
    RoomAreaType? areaType,
    String? customName,
    int? floor,
    double? lengthFt,
    double? widthFt,
    double? heightFt,
    MaterialTier? tier,
    String? description,
    String? referenceImageUrl,
    String? notes,
    List<QuotationItem>? items,
  }) {
    return RoomArea(
      id: id ?? this.id,
      roomName: roomName ?? this.roomName,
      areaType: areaType ?? this.areaType,
      customName: customName ?? this.customName,
      floor: floor ?? this.floor,
      lengthFt: lengthFt ?? this.lengthFt,
      widthFt: widthFt ?? this.widthFt,
      heightFt: heightFt ?? this.heightFt,
      tier: tier ?? this.tier,
      description: description ?? this.description,
      referenceImageUrl: referenceImageUrl ?? this.referenceImageUrl,
      notes: notes ?? this.notes,
      items: items ?? this.items,
    );
  }
}

/// Complete Quotation Entity.
class Quotation {
  final String id;
  final String quoteNumber;
  final String title;
  final QuotationType quotationType;
  final int revisionNumber;
  final String leadId;
  final String clientName;
  final String clientPhone;
  final String clientEmail;
  final String projectTitle;
  final String projectLocation;
  final String designerName;
  final String salesOwner;
  final String projectManager;
  final String createdBy;
  final String coverImageUrl;
  final DateTime submissionDate;
  final DateTime discountExpiryDate;
  final DateTime? validUntil;
  final QuotationStatus status;

  // Granular Display Visibility Toggles (PRD Section 9.2 & docs/requirmenet.md)
  final bool hideRate; // Hide unit rate column
  final bool hideSqft; // Hide dimensions / sqft to prevent contractor poaching
  final bool showAmount; // Show total lump sum amount
  final VisibilitySettings visibilitySettings;

  final List<RoomArea> rooms;
  final double discountPercent; // e.g., 8.0%
  final double fixedDiscountAmount;
  final DiscountType discountType;
  final double gstPercent; // default 18.0%
  final double amountPaid;
  final String? termsAndConditions;
  final String? internalNotes;
  final String? customerNotes;
  final List<String> tags;

  // Nested structures for rich 360 view
  final CustomerInfo? customerInfo;
  final ProjectInfo? projectInfo;
  final List<PaymentMilestone> paymentSchedule;
  final List<QuotationRevision> revisions;
  final List<QuotationApproval> approvals;
  final List<QuotationActivity> activities;
  final List<QuotationDocument> documents;
  final DocumentConfig documentConfig;

  const Quotation({
    required this.id,
    required this.quoteNumber,
    this.title = '',
    this.quotationType = QuotationType.residentialInterior,
    this.revisionNumber = 1,
    required this.leadId,
    required this.clientName,
    required this.clientPhone,
    required this.clientEmail,
    required this.projectTitle,
    required this.projectLocation,
    required this.designerName,
    this.salesOwner = 'Vikram Malhotra',
    this.projectManager = 'Rajesh Sharma',
    this.createdBy = 'Vikram Malhotra',
    required this.coverImageUrl,
    required this.submissionDate,
    required this.discountExpiryDate,
    this.validUntil,
    this.status = QuotationStatus.draft,
    this.hideRate = false,
    this.hideSqft = false,
    this.showAmount = true,
    this.visibilitySettings = const VisibilitySettings(),
    required this.rooms,
    this.discountPercent = 0.0,
    this.fixedDiscountAmount = 0.0,
    this.discountType = DiscountType.percentage,
    this.gstPercent = 18.0,
    this.amountPaid = 0.0,
    this.termsAndConditions,
    this.internalNotes,
    this.customerNotes,
    this.tags = const [],
    this.customerInfo,
    this.projectInfo,
    this.paymentSchedule = const [],
    this.revisions = const [],
    this.approvals = const [],
    this.activities = const [],
    this.documents = const [],
    this.documentConfig = const DocumentConfig(),
  });

  /// Total carpet area across all rooms
  double get totalCarpetSqft => rooms.fold(0.0, (sum, r) => sum + r.carpetSqft);

  /// Gross cost across all rooms before discount & tax
  double get grossSubtotal => rooms.fold(0.0, (sum, r) => sum + r.roomSubtotal);

  /// Discount value in INR
  double get discountAmount {
    if (discountType == DiscountType.fixedAmount) {
      return fixedDiscountAmount;
    }
    return grossSubtotal * (discountPercent / 100.0);
  }

  /// Taxable subtotal after discount
  double get taxableAmount => (grossSubtotal - discountAmount).clamp(0.0, double.infinity);

  /// GST 18% amount in INR
  double get gstAmount => taxableAmount * (gstPercent / 100.0);

  /// Net Grand Total payable
  double get grandTotal => taxableAmount + gstAmount;

  /// Balance amount due
  double get balanceDue => (grandTotal - amountPaid).clamp(0.0, double.infinity);

  /// Check whether the early-bird discount has expired
  bool get isDiscountExpired => DateTime.now().isAfter(discountExpiryDate);

  /// Time remaining before discount expiration
  Duration get timeRemaining => discountExpiryDate.difference(DateTime.now());

  Quotation copyWith({
    String? id,
    String? quoteNumber,
    String? title,
    QuotationType? quotationType,
    int? revisionNumber,
    String? leadId,
    String? clientName,
    String? clientPhone,
    String? clientEmail,
    String? projectTitle,
    String? projectLocation,
    String? designerName,
    String? salesOwner,
    String? projectManager,
    String? createdBy,
    String? coverImageUrl,
    DateTime? submissionDate,
    DateTime? discountExpiryDate,
    DateTime? validUntil,
    QuotationStatus? status,
    bool? hideRate,
    bool? hideSqft,
    bool? showAmount,
    VisibilitySettings? visibilitySettings,
    List<RoomArea>? rooms,
    double? discountPercent,
    double? fixedDiscountAmount,
    DiscountType? discountType,
    double? gstPercent,
    double? amountPaid,
    String? termsAndConditions,
    String? internalNotes,
    String? customerNotes,
    List<String>? tags,
    CustomerInfo? customerInfo,
    ProjectInfo? projectInfo,
    List<PaymentMilestone>? paymentSchedule,
    List<QuotationRevision>? revisions,
    List<QuotationApproval>? approvals,
    List<QuotationActivity>? activities,
    List<QuotationDocument>? documents,
    DocumentConfig? documentConfig,
  }) {
    return Quotation(
      id: id ?? this.id,
      quoteNumber: quoteNumber ?? this.quoteNumber,
      title: title ?? this.title,
      quotationType: quotationType ?? this.quotationType,
      revisionNumber: revisionNumber ?? this.revisionNumber,
      leadId: leadId ?? this.leadId,
      clientName: clientName ?? this.clientName,
      clientPhone: clientPhone ?? this.clientPhone,
      clientEmail: clientEmail ?? this.clientEmail,
      projectTitle: projectTitle ?? this.projectTitle,
      projectLocation: projectLocation ?? this.projectLocation,
      designerName: designerName ?? this.designerName,
      salesOwner: salesOwner ?? this.salesOwner,
      projectManager: projectManager ?? this.projectManager,
      createdBy: createdBy ?? this.createdBy,
      coverImageUrl: coverImageUrl ?? this.coverImageUrl,
      submissionDate: submissionDate ?? this.submissionDate,
      discountExpiryDate: discountExpiryDate ?? this.discountExpiryDate,
      validUntil: validUntil ?? this.validUntil,
      status: status ?? this.status,
      hideRate: hideRate ?? this.hideRate,
      hideSqft: hideSqft ?? this.hideSqft,
      showAmount: showAmount ?? this.showAmount,
      visibilitySettings: visibilitySettings ?? this.visibilitySettings,
      rooms: rooms ?? this.rooms,
      discountPercent: discountPercent ?? this.discountPercent,
      fixedDiscountAmount: fixedDiscountAmount ?? this.fixedDiscountAmount,
      discountType: discountType ?? this.discountType,
      gstPercent: gstPercent ?? this.gstPercent,
      amountPaid: amountPaid ?? this.amountPaid,
      termsAndConditions: termsAndConditions ?? this.termsAndConditions,
      internalNotes: internalNotes ?? this.internalNotes,
      customerNotes: customerNotes ?? this.customerNotes,
      tags: tags ?? this.tags,
      customerInfo: customerInfo ?? this.customerInfo,
      projectInfo: projectInfo ?? this.projectInfo,
      paymentSchedule: paymentSchedule ?? this.paymentSchedule,
      revisions: revisions ?? this.revisions,
      approvals: approvals ?? this.approvals,
      activities: activities ?? this.activities,
      documents: documents ?? this.documents,
      documentConfig: documentConfig ?? this.documentConfig,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Quotation && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
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
  final ReminderStatus deliveryStatus;
  final String whatsappMessagePreview;
  final String? salesOwner;
  final int retryCount;

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
    this.deliveryStatus = ReminderStatus.scheduled,
    required this.whatsappMessagePreview,
    this.salesOwner,
    this.retryCount = 0,
  });

  UrgencyAlertLog copyWith({
    String? id,
    String? quotationId,
    String? quoteNumber,
    String? clientName,
    String? clientPhone,
    double? quotationAmount,
    double? discountAmount,
    DateTime? expiryDate,
    DateTime? scheduledAlertTime,
    bool? isTriggered,
    DateTime? triggeredAt,
    ReminderStatus? deliveryStatus,
    String? whatsappMessagePreview,
    String? salesOwner,
    int? retryCount,
  }) {
    return UrgencyAlertLog(
      id: id ?? this.id,
      quotationId: quotationId ?? this.quotationId,
      quoteNumber: quoteNumber ?? this.quoteNumber,
      clientName: clientName ?? this.clientName,
      clientPhone: clientPhone ?? this.clientPhone,
      quotationAmount: quotationAmount ?? this.quotationAmount,
      discountAmount: discountAmount ?? this.discountAmount,
      expiryDate: expiryDate ?? this.expiryDate,
      scheduledAlertTime: scheduledAlertTime ?? this.scheduledAlertTime,
      isTriggered: isTriggered ?? this.isTriggered,
      triggeredAt: triggeredAt ?? this.triggeredAt,
      deliveryStatus: deliveryStatus ?? this.deliveryStatus,
      whatsappMessagePreview: whatsappMessagePreview ?? this.whatsappMessagePreview,
      salesOwner: salesOwner ?? this.salesOwner,
      retryCount: retryCount ?? this.retryCount,
    );
  }
}

/// B2C Customer Self-Estimator inquiry captured via OTP verification (PRD Section 9.5)
class CustomerSelfEstimateLead {
  final String id;
  final String name;
  final String phone;
  final String email;
  final String propertyType; // "1BHK", "2BHK", "3BHK", "4BHK", "Villa", "Commercial"
  final String city;
  final String possessionTimeline;
  final double carpetAreaSqft;
  final MaterialTier tier;
  final String designStyle;
  final List<String> selectedRooms;
  final double estimatedMinBudget;
  final double estimatedMaxBudget;
  final bool isOtpVerified;
  final DateTime createdAt;
  final String crmLeadStatus; // "SYNCED_TO_SALES", "CONTACTED", "SITE_VISIT_BOOKED", "QUOTATION_CREATED"
  final String? assignedTo;
  final String? notes;

  const CustomerSelfEstimateLead({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.propertyType,
    this.city = 'Bangalore',
    this.possessionTimeline = 'Ready to Move',
    required this.carpetAreaSqft,
    required this.tier,
    this.designStyle = 'Modern Contemporary',
    required this.selectedRooms,
    required this.estimatedMinBudget,
    required this.estimatedMaxBudget,
    this.isOtpVerified = true,
    required this.createdAt,
    this.crmLeadStatus = 'SYNCED_TO_SALES',
    this.assignedTo,
    this.notes,
  });

  CustomerSelfEstimateLead copyWith({
    String? id,
    String? name,
    String? phone,
    String? email,
    String? propertyType,
    String? city,
    String? possessionTimeline,
    double? carpetAreaSqft,
    MaterialTier? tier,
    String? designStyle,
    List<String>? selectedRooms,
    double? estimatedMinBudget,
    double? estimatedMaxBudget,
    bool? isOtpVerified,
    DateTime? createdAt,
    String? crmLeadStatus,
    String? assignedTo,
    String? notes,
  }) {
    return CustomerSelfEstimateLead(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      propertyType: propertyType ?? this.propertyType,
      city: city ?? this.city,
      possessionTimeline: possessionTimeline ?? this.possessionTimeline,
      carpetAreaSqft: carpetAreaSqft ?? this.carpetAreaSqft,
      tier: tier ?? this.tier,
      designStyle: designStyle ?? this.designStyle,
      selectedRooms: selectedRooms ?? this.selectedRooms,
      estimatedMinBudget: estimatedMinBudget ?? this.estimatedMinBudget,
      estimatedMaxBudget: estimatedMaxBudget ?? this.estimatedMaxBudget,
      isOtpVerified: isOtpVerified ?? this.isOtpVerified,
      createdAt: createdAt ?? this.createdAt,
      crmLeadStatus: crmLeadStatus ?? this.crmLeadStatus,
      assignedTo: assignedTo ?? this.assignedTo,
      notes: notes ?? this.notes,
    );
  }
}
