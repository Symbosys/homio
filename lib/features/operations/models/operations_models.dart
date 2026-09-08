import 'package:flutter/material.dart';

// =============================================================================
// LEGACY COMPATIBILITY ENUMS & MODELS (Preserved for existing integrations)
// =============================================================================

enum IndentUrgency { urgent, standard }

enum IndentStatus { pendingRfq, bidsReceived, approved, dispatched }

enum PaymentLinkStatus { pending, paid, disbursed }

enum SaturdayFeeStatus { scheduled, sent, failed }

class VendorBid {
  final String id;
  final String vendorName;
  final double vendorRating;
  final double unitPrice;
  final double totalPrice;
  final double gstPercent;
  final int deliveryDays;
  final String qualityGrade;
  final int warrantyMonths;
  final String paymentTerms;
  final bool isSelected;

  const VendorBid({
    required this.id,
    required this.vendorName,
    required this.vendorRating,
    required this.unitPrice,
    required this.totalPrice,
    required this.gstPercent,
    required this.deliveryDays,
    required this.qualityGrade,
    required this.warrantyMonths,
    required this.paymentTerms,
    this.isSelected = false,
  });

  VendorBid copyWith({
    String? id,
    String? vendorName,
    double? vendorRating,
    double? unitPrice,
    double? totalPrice,
    double? gstPercent,
    int? deliveryDays,
    String? qualityGrade,
    int? warrantyMonths,
    String? paymentTerms,
    bool? isSelected,
  }) {
    return VendorBid(
      id: id ?? this.id,
      vendorName: vendorName ?? this.vendorName,
      vendorRating: vendorRating ?? this.vendorRating,
      unitPrice: unitPrice ?? this.unitPrice,
      totalPrice: totalPrice ?? this.totalPrice,
      gstPercent: gstPercent ?? this.gstPercent,
      deliveryDays: deliveryDays ?? this.deliveryDays,
      qualityGrade: qualityGrade ?? this.qualityGrade,
      warrantyMonths: warrantyMonths ?? this.warrantyMonths,
      paymentTerms: paymentTerms ?? this.paymentTerms,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}

class MaterialRequisitionIndent {
  final String id;
  final String projectTitle;
  final String clientName;
  final String siteSupervisor;
  final String itemName;
  final double quantity;
  final String unit;
  final DateTime requiredDate;
  final IndentUrgency urgency;
  final IndentStatus status;
  final List<VendorBid> bids;
  final String? approvedBidId;
  final String? clientPaymentUrl;
  final String? notes;

  const MaterialRequisitionIndent({
    required this.id,
    required this.projectTitle,
    required this.clientName,
    required this.siteSupervisor,
    required this.itemName,
    required this.quantity,
    required this.unit,
    required this.requiredDate,
    required this.urgency,
    required this.status,
    required this.bids,
    this.approvedBidId,
    this.clientPaymentUrl,
    this.notes,
  });

  VendorBid? get approvedBid {
    if (approvedBidId == null) return null;
    try {
      return bids.firstWhere((b) => b.id == approvedBidId);
    } catch (_) {
      return null;
    }
  }

  MaterialRequisitionIndent copyWith({
    String? id,
    String? projectTitle,
    String? clientName,
    String? siteSupervisor,
    String? itemName,
    double? quantity,
    String? unit,
    DateTime? requiredDate,
    IndentUrgency? urgency,
    IndentStatus? status,
    List<VendorBid>? bids,
    String? approvedBidId,
    String? clientPaymentUrl,
    String? notes,
  }) {
    return MaterialRequisitionIndent(
      id: id ?? this.id,
      projectTitle: projectTitle ?? this.projectTitle,
      clientName: clientName ?? this.clientName,
      siteSupervisor: siteSupervisor ?? this.siteSupervisor,
      itemName: itemName ?? this.itemName,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      requiredDate: requiredDate ?? this.requiredDate,
      urgency: urgency ?? this.urgency,
      status: status ?? this.status,
      bids: bids ?? this.bids,
      approvedBidId: approvedBidId ?? this.approvedBidId,
      clientPaymentUrl: clientPaymentUrl ?? this.clientPaymentUrl,
      notes: notes ?? this.notes,
    );
  }
}

class DesignPaymentMilestone {
  final String id;
  final String projectTitle;
  final String clientName;
  final String clientPhone;
  final String phaseTitle;
  final double baseAmount;
  final double gstPercent;
  final PaymentLinkStatus status;
  final String paymentLinkUrl;
  final DateTime generatedDate;
  final DateTime? paidDate;
  final String? invoiceNumber;

  const DesignPaymentMilestone({
    required this.id,
    required this.projectTitle,
    required this.clientName,
    required this.clientPhone,
    required this.phaseTitle,
    required this.baseAmount,
    this.gstPercent = 18.0,
    required this.status,
    required this.paymentLinkUrl,
    required this.generatedDate,
    this.paidDate,
    this.invoiceNumber,
  });

  double get gstAmount => baseAmount * (gstPercent / 100);
  double get totalAmount => baseAmount + gstAmount;

  DesignPaymentMilestone copyWith({
    String? id,
    String? projectTitle,
    String? clientName,
    String? clientPhone,
    String? phaseTitle,
    double? baseAmount,
    double? gstPercent,
    PaymentLinkStatus? status,
    String? paymentLinkUrl,
    DateTime? generatedDate,
    DateTime? paidDate,
    String? invoiceNumber,
  }) {
    return DesignPaymentMilestone(
      id: id ?? this.id,
      projectTitle: projectTitle ?? this.projectTitle,
      clientName: clientName ?? this.clientName,
      clientPhone: clientPhone ?? this.clientPhone,
      phaseTitle: phaseTitle ?? this.phaseTitle,
      baseAmount: baseAmount ?? this.baseAmount,
      gstPercent: gstPercent ?? this.gstPercent,
      status: status ?? this.status,
      paymentLinkUrl: paymentLinkUrl ?? this.paymentLinkUrl,
      generatedDate: generatedDate ?? this.generatedDate,
      paidDate: paidDate ?? this.paidDate,
      invoiceNumber: invoiceNumber ?? this.invoiceNumber,
    );
  }
}

class SaturdayFeeBatch {
  final String id;
  final String projectName;
  final String clientName;
  final String clientPhone;
  final String supervisorName;
  final String currentStage;
  final double weekProgressPercent;
  final String contractModel;
  final double baseWeeklyFee;
  final double calculatedFee;
  final double adjustment;
  final SaturdayFeeStatus status;
  final DateTime billingDate;
  final String? invoiceRef;

  const SaturdayFeeBatch({
    required this.id,
    required this.projectName,
    required this.clientName,
    required this.clientPhone,
    required this.supervisorName,
    required this.currentStage,
    required this.weekProgressPercent,
    required this.contractModel,
    required this.baseWeeklyFee,
    required this.calculatedFee,
    this.adjustment = 0.0,
    required this.status,
    required this.billingDate,
    this.invoiceRef,
  });

  double get netPayable => calculatedFee + adjustment;

  SaturdayFeeBatch copyWith({
    String? id,
    String? projectName,
    String? clientName,
    String? clientPhone,
    String? supervisorName,
    String? currentStage,
    double? weekProgressPercent,
    String? contractModel,
    double? baseWeeklyFee,
    double? calculatedFee,
    double? adjustment,
    SaturdayFeeStatus? status,
    DateTime? billingDate,
    String? invoiceRef,
  }) {
    return SaturdayFeeBatch(
      id: id ?? this.id,
      projectName: projectName ?? this.projectName,
      clientName: clientName ?? this.clientName,
      clientPhone: clientPhone ?? this.clientPhone,
      supervisorName: supervisorName ?? this.supervisorName,
      currentStage: currentStage ?? this.currentStage,
      weekProgressPercent: weekProgressPercent ?? this.weekProgressPercent,
      contractModel: contractModel ?? this.contractModel,
      baseWeeklyFee: baseWeeklyFee ?? this.baseWeeklyFee,
      calculatedFee: calculatedFee ?? this.calculatedFee,
      adjustment: adjustment ?? this.adjustment,
      status: status ?? this.status,
      billingDate: billingDate ?? this.billingDate,
      invoiceRef: invoiceRef ?? this.invoiceRef,
    );
  }
}

// =============================================================================
// GLOBAL HOMIO PROCUREMENT & OPERATIONS STATUS SYSTEM
// =============================================================================

/// 1. Material Request Statuses (11 States)
enum MaterialRequestStatus {
  draft('Draft', Color(0xFF64748B), Icons.edit_note_rounded),
  submitted('Submitted', Color(0xFF3B82F6), Icons.send_rounded),
  underReview('Under Review', Color(0xFF8B5CF6), Icons.rate_review_rounded),
  approved('Approved', Color(0xFF10B981), Icons.check_circle_rounded),
  partiallyApproved('Partially Approved', Color(0xFF0D9488), Icons.rule_rounded),
  rejected('Rejected', Color(0xFFEF4444), Icons.cancel_rounded),
  inProcurement('In Procurement', Color(0xFFF59E0B), Icons.shopping_bag_rounded),
  partiallyFulfilled('Partially Fulfilled', Color(0xFFF97316), Icons.timelapse_rounded),
  fulfilled('Fulfilled', Color(0xFF059669), Icons.task_alt_rounded),
  cancelled('Cancelled', Color(0xFF94A3B8), Icons.block_rounded);

  final String label;
  final Color color;
  final IconData icon;
  const MaterialRequestStatus(this.label, this.color, this.icon);
}

/// 2. Vendor RFQ Statuses (9 States)
enum VendorRfqStatus {
  draft('Draft', Color(0xFF64748B), Icons.edit_note_rounded),
  readyToSend('Ready to Send', Color(0xFF06B6D4), Icons.outgoing_mail),
  sent('Sent', Color(0xFF3B82F6), Icons.mark_email_read_rounded),
  partiallyResponded('Partially Responded', Color(0xFFF59E0B), Icons.hourglass_top_rounded),
  responsesReceived('Responses Received', Color(0xFF10B981), Icons.receipt_long_rounded),
  comparisonReady('Comparison Ready', Color(0xFF8B5CF6), Icons.compare_arrows_rounded),
  closed('Closed', Color(0xFF059669), Icons.lock_clock_rounded),
  cancelled('Cancelled', Color(0xFF94A3B8), Icons.block_rounded),
  expired('Expired', Color(0xFFEF4444), Icons.timer_off_rounded);

  final String label;
  final Color color;
  final IconData icon;
  const VendorRfqStatus(this.label, this.color, this.icon);
}

/// 3. Vendor Quotation Statuses (8 States)
enum VendorQuotationStatus {
  received('Received', Color(0xFF3B82F6), Icons.inbox_rounded),
  underReview('Under Review', Color(0xFF8B5CF6), Icons.visibility_rounded),
  shortlisted('Shortlisted', Color(0xFF06B6D4), Icons.star_border_rounded),
  recommended('Recommended', Color(0xFF10B981), Icons.thumb_up_alt_rounded),
  approved('Approved', Color(0xFF059669), Icons.check_circle_outline_rounded),
  rejected('Rejected', Color(0xFFEF4444), Icons.highlight_off_rounded),
  expired('Expired', Color(0xFF94A3B8), Icons.timer_off_outlined),
  superseded('Superseded', Color(0xFF64748B), Icons.history_rounded);

  final String label;
  final Color color;
  final IconData icon;
  const VendorQuotationStatus(this.label, this.color, this.icon);
}

/// 4. Purchase Order Statuses (10 States)
enum PurchaseOrderStatus {
  draft('Draft', Color(0xFF64748B), Icons.edit_note_rounded),
  pendingApproval('Pending Approval', Color(0xFFF59E0B), Icons.pending_actions_rounded),
  approved('Approved', Color(0xFF10B981), Icons.verified_rounded),
  sentToVendor('Sent to Vendor', Color(0xFF3B82F6), Icons.send_rounded),
  vendorAcknowledged('Vendor Acknowledged', Color(0xFF0D9488), Icons.handshake_rounded),
  partiallyDispatched('Partially Dispatched', Color(0xFFF97316), Icons.local_shipping_outlined),
  dispatched('Dispatched', Color(0xFF0284C7), Icons.local_shipping_rounded),
  partiallyReceived('Partially Received', Color(0xFF8B5CF6), Icons.inventory_2_outlined),
  completed('Completed', Color(0xFF059669), Icons.task_alt_rounded),
  cancelled('Cancelled', Color(0xFFEF4444), Icons.cancel_outlined);

  final String label;
  final Color color;
  final IconData icon;
  const PurchaseOrderStatus(this.label, this.color, this.icon);
}

/// 5. Material Dispatch Statuses (9 States)
enum MaterialDispatchStatus {
  planned('Planned', Color(0xFF64748B), Icons.schedule_rounded),
  ready('Ready', Color(0xFF06B6D4), Icons.check_box_outlined),
  dispatched('Dispatched', Color(0xFF3B82F6), Icons.local_shipping_rounded),
  inTransit('In Transit', Color(0xFFF59E0B), Icons.moving_rounded),
  delivered('Delivered', Color(0xFF10B981), Icons.place_rounded),
  received('Received', Color(0xFF059669), Icons.verified_outlined),
  partiallyReceived('Partially Received', Color(0xFF8B5CF6), Icons.call_split_rounded),
  rejected('Rejected', Color(0xFFEF4444), Icons.report_problem_rounded),
  cancelled('Cancelled', Color(0xFF94A3B8), Icons.block_rounded);

  final String label;
  final Color color;
  final IconData icon;
  const MaterialDispatchStatus(this.label, this.color, this.icon);
}

/// 6. Design Payment Request Statuses (10 States)
enum DesignPaymentStatus {
  draft('Draft', Color(0xFF64748B), Icons.edit_note_rounded),
  submitted('Submitted', Color(0xFF3B82F6), Icons.upload_file_rounded),
  underVerification('Under Verification', Color(0xFF8B5CF6), Icons.fact_check_rounded),
  pendingApproval('Pending Approval', Color(0xFFF59E0B), Icons.hourglass_empty_rounded),
  approved('Approved', Color(0xFF10B981), Icons.check_circle_rounded),
  paymentRequested('Payment Requested', Color(0xFF06B6D4), Icons.link_rounded),
  partiallyPaid('Partially Paid', Color(0xFFF97316), Icons.pie_chart_outline_rounded),
  paid('Paid', Color(0xFF059669), Icons.verified_rounded),
  rejected('Rejected', Color(0xFFEF4444), Icons.cancel_rounded),
  onHold('On Hold', Color(0xFF64748B), Icons.pause_circle_filled_rounded);

  final String label;
  final Color color;
  final IconData icon;
  const DesignPaymentStatus(this.label, this.color, this.icon);
}

/// 7. Weekly Fee Statuses (9 States)
enum WeeklyFeeStatus {
  draft('Draft', Color(0xFF64748B), Icons.edit_note_rounded),
  calculated('Calculated', Color(0xFF3B82F6), Icons.calculate_rounded),
  underReview('Under Review', Color(0xFF8B5CF6), Icons.rate_review_rounded),
  approved('Approved', Color(0xFF10B981), Icons.verified_rounded),
  paymentRequested('Payment Requested', Color(0xFF06B6D4), Icons.send_to_mobile_rounded),
  partiallyPaid('Partially Paid', Color(0xFFF97316), Icons.timelapse_rounded),
  paid('Paid', Color(0xFF059669), Icons.done_all_rounded),
  failed('Failed', Color(0xFFEF4444), Icons.error_outline_rounded),
  cancelled('Cancelled', Color(0xFF94A3B8), Icons.block_rounded);

  final String label;
  final Color color;
  final IconData icon;
  const WeeklyFeeStatus(this.label, this.color, this.icon);
}

/// Material Item Condition
enum MaterialItemCondition {
  good('Good', Color(0xFF10B981)),
  damaged('Damaged', Color(0xFFEF4444)),
  short('Short', Color(0xFFF59E0B)),
  wrongItem('Wrong Item', Color(0xFF8B5CF6)),
  qualityIssue('Quality Issue', Color(0xFFF97316)),
  rejected('Rejected', Color(0xFFDC2626));

  final String label;
  final Color color;
  const MaterialItemCondition(this.label, this.color);
}

/// Priority Level
enum RequestPriority {
  low('Low', Color(0xFF64748B)),
  normal('Normal', Color(0xFF3B82F6)),
  high('High', Color(0xFFF59E0B)),
  urgent('Urgent', Color(0xFFF97316)),
  critical('Critical', Color(0xFFEF4444));

  final String label;
  final Color color;
  const RequestPriority(this.label, this.color);
}

/// Request Type
enum RequestType {
  projectMaterial('Project Material'),
  siteMaterial('Site Material'),
  replacement('Replacement'),
  urgentRequirement('Urgent Requirement'),
  designSample('Design Sample'),
  hardware('Hardware'),
  consumable('Consumable'),
  other('Other');

  final String label;
  const RequestType(this.label);
}

// =============================================================================
// DOMAIN ENTITIES & WORKFLOW DATA STRUCTURES
// =============================================================================

/// Dimension inputs with auto-calculated area / volume
class DimensionInput {
  final double length;
  final double width;
  final double height;
  final double thickness;
  final String unit; // 'ft', 'inch', 'mm', 'meter'

  const DimensionInput({
    this.length = 0,
    this.width = 0,
    this.height = 0,
    this.thickness = 0,
    this.unit = 'ft',
  });

  double get calculatedArea => length * width;
  double get calculatedVolume => length * width * height;
}

/// Material Specification details
class MaterialSpecification {
  final String materialType;
  final String grade;
  final String thickness;
  final String size;
  final String finish;
  final String colour;
  final String brand;
  final String model;
  final String technicalSpecification;
  final String qualityLevel;
  final String installationRequirement;
  final String specialRequirement;

  const MaterialSpecification({
    this.materialType = '',
    this.grade = '',
    this.thickness = '',
    this.size = '',
    this.finish = '',
    this.colour = '',
    this.brand = '',
    this.model = '',
    this.technicalSpecification = '',
    this.qualityLevel = 'Standard Grade',
    this.installationRequirement = '',
    this.specialRequirement = '',
  });
}

/// Single Line Item in a Material Request
class MaterialRequestItem {
  final String id;
  final String itemName;
  final String itemCode;
  final String sku;
  final String category;
  final String subcategory;
  final String description;
  final MaterialSpecification specification;
  final DimensionInput? dimensions;
  final double quantity;
  final String unit; // 'Sq.Ft.', 'PC / Nos', 'Running Ft.', 'Lump Sum', 'Kg', 'Box'
  final String preferredBrand;
  final String preferredVendor;
  final double estimatedRate;
  final double estimatedAmount;
  final DateTime requiredDate;
  final String notes;
  final String? attachmentUrl;

  const MaterialRequestItem({
    required this.id,
    required this.itemName,
    required this.itemCode,
    this.sku = '',
    required this.category,
    this.subcategory = '',
    this.description = '',
    this.specification = const MaterialSpecification(),
    this.dimensions,
    required this.quantity,
    required this.unit,
    this.preferredBrand = '',
    this.preferredVendor = '',
    required this.estimatedRate,
    required this.estimatedAmount,
    required this.requiredDate,
    this.notes = '',
    this.attachmentUrl,
  });

  MaterialRequestItem copyWith({
    String? id,
    String? itemName,
    String? itemCode,
    String? sku,
    String? category,
    String? subcategory,
    String? description,
    MaterialSpecification? specification,
    DimensionInput? dimensions,
    double? quantity,
    String? unit,
    String? preferredBrand,
    String? preferredVendor,
    double? estimatedRate,
    double? estimatedAmount,
    DateTime? requiredDate,
    String? notes,
    String? attachmentUrl,
  }) {
    return MaterialRequestItem(
      id: id ?? this.id,
      itemName: itemName ?? this.itemName,
      itemCode: itemCode ?? this.itemCode,
      sku: sku ?? this.sku,
      category: category ?? this.category,
      subcategory: subcategory ?? this.subcategory,
      description: description ?? this.description,
      specification: specification ?? this.specification,
      dimensions: dimensions ?? this.dimensions,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      preferredBrand: preferredBrand ?? this.preferredBrand,
      preferredVendor: preferredVendor ?? this.preferredVendor,
      estimatedRate: estimatedRate ?? this.estimatedRate,
      estimatedAmount: estimatedAmount ?? this.estimatedAmount,
      requiredDate: requiredDate ?? this.requiredDate,
      notes: notes ?? this.notes,
      attachmentUrl: attachmentUrl ?? this.attachmentUrl,
    );
  }
}

/// Screen 1: Material Request
class MaterialRequest {
  final String id;
  final String requestNumber; // e.g. MR-2026-00124
  final DateTime requestDate;
  final RequestType requestType;
  final String department;
  final String requestedBy;
  final String projectId;
  final String projectName;
  final String customerId;
  final String customerName;
  final String siteAddress;
  final String floor;
  final String roomArea;
  final String costCentre;
  final String projectBudgetCategory;
  final DateTime requiredByDate;
  final String requiredByTime;
  final RequestPriority priority;
  final String requestReason;
  final String businessJustification;
  final String internalNotes;
  final List<MaterialRequestItem> items;
  final double estimatedMaterialCost;
  final double otherCharges;
  final double estimatedTotal;
  final double approvedAmount;
  final double budgetAvailable;
  final MaterialRequestStatus status;
  final String procurementOwner;
  final DateTime lastUpdated;
  final List<ProcurementTimelineEvent> timeline;
  final List<ProcurementDocument> documents;

  const MaterialRequest({
    required this.id,
    required this.requestNumber,
    required this.requestDate,
    this.requestType = RequestType.projectMaterial,
    this.department = 'Civil & Fitouts',
    required this.requestedBy,
    required this.projectId,
    required this.projectName,
    required this.customerId,
    required this.customerName,
    required this.siteAddress,
    this.floor = 'Ground Floor',
    this.roomArea = 'Master Bedroom & Living',
    this.costCentre = 'CC-FITOUTS-01',
    this.projectBudgetCategory = 'Finishing Materials',
    required this.requiredByDate,
    this.requiredByTime = '10:00 AM',
    this.priority = RequestPriority.normal,
    this.requestReason = 'Site execution requirement as per approved drawing',
    this.businessJustification = 'Execution schedule adherence for milestone 2',
    this.internalNotes = '',
    required this.items,
    required this.estimatedMaterialCost,
    this.otherCharges = 0,
    required this.estimatedTotal,
    this.approvedAmount = 0,
    this.budgetAvailable = 0,
    this.status = MaterialRequestStatus.submitted,
    this.procurementOwner = 'Amit Kumar',
    required this.lastUpdated,
    this.timeline = const [],
    this.documents = const [],
  });

  double get remainingBudget => budgetAvailable - estimatedTotal;
  bool get isWithinBudget => remainingBudget >= 0;
}

/// Vendor Invitation in an RFQ
class RfqVendorInvite {
  final String vendorId;
  final String vendorName;
  final String vendorCode;
  final String category;
  final double rating;
  final String location;
  final String kycStatus;
  final String contactPerson;
  final String mobile;
  final String email;
  final String status; // 'Invited', 'Opened', 'Responded', 'Declined'
  final DateTime? respondedAt;

  const RfqVendorInvite({
    required this.vendorId,
    required this.vendorName,
    required this.vendorCode,
    required this.category,
    required this.rating,
    required this.location,
    this.kycStatus = 'Verified',
    required this.contactPerson,
    required this.mobile,
    required this.email,
    this.status = 'Invited',
    this.respondedAt,
  });
}

/// Commercial Terms for RFQ
class RfqCommercialTerms {
  final String currency;
  final String paymentTermsRequested;
  final String creditPeriod;
  final String deliveryTimeline;
  final String deliveryLocation;
  final bool freightIncluded;
  final bool installationIncluded;
  final bool packagingIncluded;
  final bool taxIncluded;
  final bool warrantyRequired;
  final String quoteValidityRequired;
  final String advanceTerms;
  final String specialCommercialConditions;

  const RfqCommercialTerms({
    this.currency = 'INR',
    this.paymentTermsRequested = '30 Days Net on Verified Delivery',
    this.creditPeriod = '15 Days',
    this.deliveryTimeline = 'Within 5 Working Days',
    this.deliveryLocation = 'Direct to Site',
    this.freightIncluded = true,
    this.installationIncluded = false,
    this.packagingIncluded = true,
    this.taxIncluded = false,
    this.warrantyRequired = true,
    this.quoteValidityRequired = '15 Days',
    this.advanceTerms = 'Nil / 100% on Dispatch Verification',
    this.specialCommercialConditions = 'Standard Homio Quality Inspection on Site',
  });
}

/// Screen 2: Vendor RFQ
class VendorRfq {
  final String id;
  final String rfqNumber; // e.g. RFQ-2026-00084
  final String rfqTitle;
  final DateTime rfqDate;
  final DateTime responseDeadline;
  final String responseDeadlineTime;
  final String materialRequestId;
  final String materialRequestNumber;
  final String projectId;
  final String projectName;
  final String customerName;
  final String siteAddress;
  final String procurementOwner;
  final String department;
  final RequestPriority priority;
  final List<RfqVendorInvite> vendors;
  final List<MaterialRequestItem> items;
  final RfqCommercialTerms commercialTerms;
  final String siteContactPerson;
  final String siteContactNumber;
  final String siteAccessInstructions;
  final String unloadingRequirements;
  final double estimatedValue;
  final VendorRfqStatus status;
  final List<ProcurementTimelineEvent> timeline;

  const VendorRfq({
    required this.id,
    required this.rfqNumber,
    required this.rfqTitle,
    required this.rfqDate,
    required this.responseDeadline,
    this.responseDeadlineTime = '05:00 PM',
    required this.materialRequestId,
    required this.materialRequestNumber,
    required this.projectId,
    required this.projectName,
    required this.customerName,
    required this.siteAddress,
    this.procurementOwner = 'Amit Kumar',
    this.department = 'Procurement & Vendor Ops',
    this.priority = RequestPriority.normal,
    required this.vendors,
    required this.items,
    this.commercialTerms = const RfqCommercialTerms(),
    this.siteContactPerson = 'Rajesh Verma (Site Engg)',
    this.siteContactNumber = '+91 98110 55201',
    this.siteAccessInstructions = 'Entry via Service Gate 3. Security badge required.',
    this.unloadingRequirements = 'Service lift operational 9 AM - 6 PM only.',
    required this.estimatedValue,
    this.status = VendorRfqStatus.sent,
    this.timeline = const [],
  });

  int get vendorsInvitedCount => vendors.length;
  int get responsesReceivedCount => vendors.where((v) => v.status == 'Responded').length;
}

/// Vendor Scorecard for comparison
class VendorScorecard {
  final double rateScore; // 1 to 10
  final double qualityScore; // 1 to 10
  final double trustScore; // 1 to 10
  final double timelineScore; // 1 to 10
  final double warrantyScore; // 1 to 10
  final double overallRating; // 1 to 5
  final String feedback;
  final String evaluatedBy;
  final DateTime evaluatedDate;

  const VendorScorecard({
    this.rateScore = 8.5,
    this.qualityScore = 9.0,
    this.trustScore = 8.8,
    this.timelineScore = 8.2,
    this.warrantyScore = 8.5,
    this.overallRating = 4.6,
    this.feedback = 'Consistent quality & compliance with Homio specifications.',
    this.evaluatedBy = 'Amit Kumar',
    required this.evaluatedDate,
  });

  double get compositeIndex =>
      (rateScore + qualityScore + trustScore + timelineScore + warrantyScore) / 5;
}

/// Quotation Line Item
class VendorQuotationItem {
  final String itemName;
  final String vendorItemCode;
  final String description;
  final String materialSpecification;
  final String brand;
  final String model;
  final double quantity;
  final String unit;
  final double unitRate;
  final double discountPercent;
  final double taxPercent;
  final double freight;
  final double total;
  final String deliveryDays;
  final String warrantyPeriod;
  final String remarks;

  const VendorQuotationItem({
    required this.itemName,
    this.vendorItemCode = '',
    this.description = '',
    required this.materialSpecification,
    required this.brand,
    this.model = '',
    required this.quantity,
    required this.unit,
    required this.unitRate,
    this.discountPercent = 0,
    this.taxPercent = 18.0,
    this.freight = 0,
    required this.total,
    required this.deliveryDays,
    required this.warrantyPeriod,
    this.remarks = '',
  });
}

/// Screen 3: Vendor Quotation
class VendorQuotation {
  final String id;
  final String vendorQuoteNumber;
  final String rfqId;
  final String rfqNumber;
  final String vendorId;
  final String vendorName;
  final String vendorCode;
  final String projectId;
  final String projectName;
  final DateTime quoteDate;
  final DateTime validUntil;
  final String currency;
  final String contactPerson;
  final String contactNumber;
  final String contactEmail;
  final double subtotal;
  final double discount;
  final double tax;
  final double freight;
  final double deliveryCharges;
  final double installationCharges;
  final double packagingCharges;
  final double insurance;
  final double grandTotal;
  final String paymentTerms;
  final double advancePercent;
  final String creditPeriod;
  final String deliveryTimeline;
  final String warrantyPeriod;
  final String quoteValidity;
  final VendorScorecard scorecard;
  final List<VendorQuotationItem> items;
  final VendorQuotationStatus status;
  final String? recommendationRationale;

  const VendorQuotation({
    required this.id,
    required this.vendorQuoteNumber,
    required this.rfqId,
    required this.rfqNumber,
    required this.vendorId,
    required this.vendorName,
    required this.vendorCode,
    required this.projectId,
    required this.projectName,
    required this.quoteDate,
    required this.validUntil,
    this.currency = 'INR',
    required this.contactPerson,
    required this.contactNumber,
    required this.contactEmail,
    required this.subtotal,
    this.discount = 0,
    required this.tax,
    this.freight = 0,
    this.deliveryCharges = 0,
    this.installationCharges = 0,
    this.packagingCharges = 0,
    this.insurance = 0,
    required this.grandTotal,
    this.paymentTerms = '50% Advance, Balance on Delivery',
    this.advancePercent = 50,
    this.creditPeriod = '7 Days',
    required this.deliveryTimeline,
    required this.warrantyPeriod,
    this.quoteValidity = '15 Days',
    required this.scorecard,
    required this.items,
    this.status = VendorQuotationStatus.received,
    this.recommendationRationale,
  });
}

/// Line Item for Purchase Order
class PurchaseOrderItem {
  final String id;
  final String itemName;
  final String itemCode;
  final String description;
  final String specification;
  final double quantity;
  final String unit;
  final double rate;
  final double discountPercent;
  final double taxPercent;
  final double amount;
  final DateTime requiredDate;
  final DateTime expectedDelivery;
  final String remarks;

  const PurchaseOrderItem({
    required this.id,
    required this.itemName,
    required this.itemCode,
    this.description = '',
    required this.specification,
    required this.quantity,
    required this.unit,
    required this.rate,
    this.discountPercent = 0,
    this.taxPercent = 18.0,
    required this.amount,
    required this.requiredDate,
    required this.expectedDelivery,
    this.remarks = '',
  });
}

/// Screen 4: Purchase Order
class PurchaseOrder {
  final String id;
  final String poNumber; // e.g. PO-2026-00142
  final DateTime poDate;
  final String vendorId;
  final String vendorLegalName;
  final String vendorCode;
  final String gstin;
  final String pan;
  final String vendorContactPerson;
  final String vendorMobile;
  final String vendorEmail;
  final String billingAddress;
  final String shippingAddress;
  final String rfqId;
  final String rfqNumber;
  final String vendorQuoteId;
  final String vendorQuoteNumber;
  final String materialRequestId;
  final String materialRequestNumber;
  final String projectId;
  final String projectName;
  final String customerId;
  final String customerName;
  final String siteAddress;
  final String procurementOwner;
  final String department;
  final String costCentre;
  final DateTime expectedDeliveryDate;
  final String preferredDeliveryTime;
  final String deliveryInstructions;
  final String unloadingInstructions;
  final String paymentTerms;
  final double advancePercent;
  final double advanceAmount;
  final String creditPeriod;
  final double retentionPercent;
  final double discount;
  final double freight;
  final double installation;
  final double packaging;
  final double insurance;
  final double tax;
  final double roundOff;
  final double grandTotal;
  final double paidAmount;
  final List<PurchaseOrderItem> items;
  final String termsAndConditions;
  final PurchaseOrderStatus status;
  final MaterialDispatchStatus dispatchStatus;
  final List<ProcurementTimelineEvent> timeline;

  const PurchaseOrder({
    required this.id,
    required this.poNumber,
    required this.poDate,
    required this.vendorId,
    required this.vendorLegalName,
    required this.vendorCode,
    this.gstin = '07AAAAA0000A1Z5',
    this.pan = 'AAAAA0000A',
    required this.vendorContactPerson,
    required this.vendorMobile,
    required this.vendorEmail,
    this.billingAddress = 'Homio Operations Private Limited, DLF Cyber City, Tower B, Gurugram - 122002',
    required this.shippingAddress,
    required this.rfqId,
    required this.rfqNumber,
    required this.vendorQuoteId,
    required this.vendorQuoteNumber,
    required this.materialRequestId,
    required this.materialRequestNumber,
    required this.projectId,
    required this.projectName,
    required this.customerId,
    required this.customerName,
    required this.siteAddress,
    this.procurementOwner = 'Amit Kumar',
    this.department = 'Central Procurement',
    this.costCentre = 'CC-FITOUTS-01',
    required this.expectedDeliveryDate,
    this.preferredDeliveryTime = '11:00 AM - 03:00 PM',
    this.deliveryInstructions = 'Service gate inspection mandatory before unloading.',
    this.unloadingInstructions = 'Homio site supervisor must sign physical challan & verify seal.',
    this.paymentTerms = '50% on Dispatch, Balance 50% Net 15 Days after Site QA Acceptance',
    this.advancePercent = 50.0,
    required this.advanceAmount,
    this.creditPeriod = '15 Days',
    this.retentionPercent = 5.0,
    this.discount = 0.0,
    this.freight = 2500.0,
    this.installation = 0.0,
    this.packaging = 1200.0,
    this.insurance = 850.0,
    required this.tax,
    this.roundOff = 0.0,
    required this.grandTotal,
    this.paidAmount = 0.0,
    required this.items,
    this.termsAndConditions =
        '1. Materials must adhere strictly to IS:710 standards.\n2. Replacement for transit damages within 48 hours.\n3. Homio QA acceptance certificate mandatory for final balance release.',
    this.status = PurchaseOrderStatus.approved,
    this.dispatchStatus = MaterialDispatchStatus.dispatched,
    this.timeline = const [],
  });

  double get dueAmount => grandTotal - paidAmount;
}

/// Item in a Material Dispatch
class DispatchItem {
  final String itemName;
  final double poQuantity;
  final double previouslyDispatched;
  final double currentDispatchQuantity;
  final String unit;
  final String batchLot;
  final String remarks;

  const DispatchItem({
    required this.itemName,
    required this.poQuantity,
    this.previouslyDispatched = 0,
    required this.currentDispatchQuantity,
    required this.unit,
    this.batchLot = '',
    this.remarks = '',
  });

  double get remainingQuantity =>
      poQuantity - (previouslyDispatched + currentDispatchQuantity);
}

/// Item received and QA checked at project site
class SiteReceiptItem {
  final String itemName;
  final double dispatchedQuantity;
  final double quantityReceived;
  final double quantityAccepted;
  final double quantityRejected;
  final double shortQuantity;
  final double damagedQuantity;
  final MaterialItemCondition condition;
  final String remarks;

  const SiteReceiptItem({
    required this.itemName,
    required this.dispatchedQuantity,
    required this.quantityReceived,
    required this.quantityAccepted,
    this.quantityRejected = 0,
    this.shortQuantity = 0,
    this.damagedQuantity = 0,
    this.condition = MaterialItemCondition.good,
    this.remarks = '',
  });
}

/// Screen 5: Material Dispatch
class MaterialDispatch {
  final String id;
  final String dispatchNumber; // e.g. DSP-2026-00091
  final String poId;
  final String poNumber;
  final String vendorName;
  final String projectId;
  final String projectName;
  final String customerName;
  final String siteAddress;
  final DateTime dispatchDate;
  final DateTime expectedArrival;
  final DateTime? actualArrival;
  final String dispatchLocation;
  final String destination;
  final String dispatchOwner;
  final String transporterName;
  final String transporterContact;
  final String vehicleNumber;
  final String driverName;
  final String driverContact;
  final String lrNumber;
  final String trackingNumber;
  final String eWayBillNumber;
  final double freightCharges;
  final String transportNotes;
  final List<DispatchItem> items;
  final List<SiteReceiptItem>? receiptChecklist;
  final String? siteSupervisorSignature;
  final String? deliveryProofUrl;
  final MaterialDispatchStatus status;
  final List<ProcurementTimelineEvent> timeline;

  const MaterialDispatch({
    required this.id,
    required this.dispatchNumber,
    required this.poId,
    required this.poNumber,
    required this.vendorName,
    required this.projectId,
    required this.projectName,
    required this.customerName,
    required this.siteAddress,
    required this.dispatchDate,
    required this.expectedArrival,
    this.actualArrival,
    this.dispatchLocation = 'Vendor Central Warehouse, Okhla Phase 2',
    required this.destination,
    this.dispatchOwner = 'Vikram Malhotra (Logistics Head)',
    required this.transporterName,
    required this.transporterContact,
    required this.vehicleNumber,
    required this.driverName,
    required this.driverContact,
    required this.lrNumber,
    required this.trackingNumber,
    required this.eWayBillNumber,
    this.freightCharges = 3500,
    this.transportNotes = 'Direct dedicated flatbed truck with tarp cover.',
    required this.items,
    this.receiptChecklist,
    this.siteSupervisorSignature,
    this.deliveryProofUrl,
    this.status = MaterialDispatchStatus.inTransit,
    this.timeline = const [],
  });

  int get totalItemsCount => items.length;
  double get totalQuantity =>
      items.fold(0, (sum, item) => sum + item.currentDispatchQuantity);
}

/// Screen 6: Design Payment Request
class DesignPaymentRequest {
  final String id;
  final String requestNumber; // e.g. DPR-2026-00045
  final DateTime requestDate;
  final String designerName;
  final String designerRole; // 'Lead Architect', '3D Visualizer', 'Interior Designer'
  final bool isContractor;
  final String projectId;
  final String projectName;
  final String customerName;
  final String designType; // 'Turnkey Interior', 'Architectural Planning', '3D Modeling'
  final String designStage; // 'Concept', 'Design Freeze', 'GFC Drawings', 'Site Handover'
  final String milestoneTitle;
  final double milestonePercent;
  final DateTime dueDate;
  final String workPeriod;
  final double contractAmount;
  final double eligibleAmount;
  final double previouslyPaid;
  final double currentRequest;
  final double adjustment;
  final double deductions;
  final double netPayable;
  final int deliverablesCompletedPercent;
  final int filesSubmittedCount;
  final int filesApprovedCount;
  final int filesPendingCount;
  final String clientApprovalStatus; // 'Approved', 'Pending', 'Revision Requested'
  final String executionHandoverStatus; // 'Ready', 'In Progress', 'Blocked'
  final int revisionCount;
  final String verificationNotes;
  final String supervisorFeedback;
  final String googleDriveUrl;
  final String paymentMethod;
  final String? bankReference;
  final String? paymentReference;
  final String? transactionId;
  final DateTime? paidDate;
  final DesignPaymentStatus status;
  final List<ProcurementTimelineEvent> timeline;

  const DesignPaymentRequest({
    required this.id,
    required this.requestNumber,
    required this.requestDate,
    required this.designerName,
    this.designerRole = 'Senior Interior Architect',
    this.isContractor = false,
    required this.projectId,
    required this.projectName,
    required this.customerName,
    this.designType = 'Turnkey Luxury Interior',
    this.designStage = 'Stage 3: GFC & Working Drawings',
    required this.milestoneTitle,
    this.milestonePercent = 25.0,
    required this.dueDate,
    this.workPeriod = 'Aug 15 - Aug 31, 2026',
    required this.contractAmount,
    required this.eligibleAmount,
    required this.previouslyPaid,
    required this.currentRequest,
    this.adjustment = 0,
    this.deductions = 0,
    required this.netPayable,
    this.deliverablesCompletedPercent = 100,
    required this.filesSubmittedCount,
    required this.filesApprovedCount,
    this.filesPendingCount = 0,
    this.clientApprovalStatus = 'Approved on Sign-off Meeting',
    this.executionHandoverStatus = 'Handed over to Site PM',
    this.revisionCount = 2,
    this.verificationNotes = 'All electrical, plumbing & millwork CAD drawings verified.',
    this.supervisorFeedback = 'Flawless joinery details & client approved with 0 snags.',
    required this.googleDriveUrl,
    this.paymentMethod = 'NEFT Direct Bank Transfer',
    this.bankReference,
    this.paymentReference,
    this.transactionId,
    this.paidDate,
    this.status = DesignPaymentStatus.approved,
    this.timeline = const [],
  });
}

/// Itemized bill inside a weekly fee (Material or Labour bill)
class FeeBillItem {
  final String billNumber;
  final DateTime billDate;
  final String recipientName;
  final String description;
  final double amount;
  final double paidAmount;
  final bool isPaid;
  final String notes;
  final String? attachmentName;

  const FeeBillItem({
    required this.billNumber,
    required this.billDate,
    required this.recipientName,
    required this.description,
    required this.amount,
    this.paidAmount = 0,
    this.isPaid = false,
    this.notes = '',
    this.attachmentName,
  });

  double get dueAmount => amount - paidAmount;
}

/// Screen 7: Weekly / Saturday Fees
class WeeklyFee {
  final String id;
  final String feeCode; // e.g. WKF-2026-W36-01
  final String weekPeriod; // e.g. 'Week 36 (01 Sep - 07 Sep 2026)'
  final DateTime weekStartDate;
  final DateTime weekEndDate;
  final DateTime feeDate;
  final DateTime paymentDueDate;
  final DateTime paymentRequestDate;
  final String projectId;
  final String projectName;
  final String customerId;
  final String customerName;
  final String customerPhone;
  final String siteAddress;
  final String projectManager;
  final String siteSupervisor;
  final String department;
  final String costCentre;

  // Segregated amounts
  final double materialAmount;
  final List<FeeBillItem> materialBills;
  final String materialNotes;
  final String materialPaymentStatus;

  final double labourAmount;
  final List<FeeBillItem> labourBills;
  final String labourNotes;
  final String labourPaymentStatus;

  final double supervisionFees;
  final double consultingFees;
  final double otherApprovedFees;
  final String feeNotes;

  // Live Auto-Calculated Totals
  final double totalAmount;
  final double paidAmount;
  final WeeklyFeeStatus status;
  final String whatsappStatus; // 'Pending', 'Sent', 'Delivered', 'Read', 'Failed'
  final DateTime? whatsappSentAt;
  final String paymentLinkUrl;
  final List<ProcurementTimelineEvent> timeline;

  const WeeklyFee({
    required this.id,
    required this.feeCode,
    required this.weekPeriod,
    required this.weekStartDate,
    required this.weekEndDate,
    required this.feeDate,
    required this.paymentDueDate,
    required this.paymentRequestDate,
    required this.projectId,
    required this.projectName,
    required this.customerId,
    required this.customerName,
    required this.customerPhone,
    required this.siteAddress,
    this.projectManager = 'Amit Kumar',
    this.siteSupervisor = 'Rajesh Verma',
    this.department = 'Turnkey Operations',
    this.costCentre = 'CC-FITOUTS-01',
    required this.materialAmount,
    this.materialBills = const [],
    this.materialNotes = 'Direct site procurement bills for hardware & ply',
    this.materialPaymentStatus = 'Partially Paid',
    required this.labourAmount,
    this.labourBills = const [],
    this.labourNotes = 'Carpentry gang & false ceiling electrical crew wage',
    this.labourPaymentStatus = 'Due',
    this.supervisionFees = 15000.0,
    this.consultingFees = 10000.0,
    this.otherApprovedFees = 0.0,
    this.feeNotes = 'Weekly site management retainer as per clause 4.2',
    required this.totalAmount,
    this.paidAmount = 0.0,
    this.status = WeeklyFeeStatus.approved,
    this.whatsappStatus = 'Sent',
    this.whatsappSentAt,
    required this.paymentLinkUrl,
    this.timeline = const [],
  });

  double get dueAmount => totalAmount - paidAmount;
  double get feesTotal => supervisionFees + consultingFees + otherApprovedFees;
}

/// Saturday Fee Automation Configuration
class SaturdayAutomationConfig {
  final bool isEnabled;
  final String frequency; // 'Weekly'
  final String dayOfWeek; // 'Saturday'
  final String executionTime; // '10:00 AM'
  final bool generateRequest;
  final bool sendWhatsApp;
  final bool sendEmail;
  final bool managerReviewRequired;
  final bool accountsReviewRequired;

  const SaturdayAutomationConfig({
    this.isEnabled = true,
    this.frequency = 'Weekly',
    this.dayOfWeek = 'Saturday',
    this.executionTime = '10:00 AM',
    this.generateRequest = true,
    this.sendWhatsApp = true,
    this.sendEmail = true,
    this.managerReviewRequired = true,
    this.accountsReviewRequired = true,
  });
}

/// Saturday Automation Execution Log
class SaturdayAutomationLog {
  final String id;
  final DateTime executionDate;
  final String weekPeriod;
  final int feeCount;
  final double totalValue;
  final String status; // 'Delivered', 'Sent', 'Failed'
  final String? failureReason;

  const SaturdayAutomationLog({
    required this.id,
    required this.executionDate,
    required this.weekPeriod,
    required this.feeCount,
    required this.totalValue,
    required this.status,
    this.failureReason,
  });
}

/// Customer-Wise Operations Rollup
class CustomerOperationsSummary {
  final String customerId;
  final String customerName;
  final String projectId;
  final String projectName;
  final double materialTotal;
  final double materialPaid;
  final double materialDue;
  final double labourTotal;
  final double labourPaid;
  final double labourDue;
  final double feesTotal;
  final double feesPaid;
  final double feesDue;

  const CustomerOperationsSummary({
    required this.customerId,
    required this.customerName,
    required this.projectId,
    required this.projectName,
    required this.materialTotal,
    required this.materialPaid,
    required this.materialDue,
    required this.labourTotal,
    required this.labourPaid,
    required this.labourDue,
    required this.feesTotal,
    required this.feesPaid,
    required this.feesDue,
  });

  double get totalBills => materialTotal + labourTotal + feesTotal;
  double get totalReceived => materialPaid + labourPaid + feesPaid;
  double get totalOutstanding => materialDue + labourDue + feesDue;
}

/// Project Procurement Summary
class ProjectProcurementSummary {
  final String projectId;
  final String projectName;
  final int materialRequestsCount;
  final int rfqsCount;
  final int vendorQuotesCount;
  final int approvedVendorsCount;
  final int poCount;
  final int dispatchCount;
  final double materialCost;
  final double labourCost;
  final double feesCost;
  final double approvedQuotationValue;

  const ProjectProcurementSummary({
    required this.projectId,
    required this.projectName,
    required this.materialRequestsCount,
    required this.rfqsCount,
    required this.vendorQuotesCount,
    required this.approvedVendorsCount,
    required this.poCount,
    required this.dispatchCount,
    required this.materialCost,
    required this.labourCost,
    required this.feesCost,
    required this.approvedQuotationValue,
  });

  double get totalOperationalCost => materialCost + labourCost + feesCost;
  double get procurementBudgetRemaining => approvedQuotationValue - materialCost;
}

/// Unified Timeline Event
class ProcurementTimelineEvent {
  final String id;
  final DateTime timestamp;
  final String title;
  final String description;
  final String actorName;
  final String actorRole;
  final IconData icon;

  const ProcurementTimelineEvent({
    required this.id,
    required this.timestamp,
    required this.title,
    required this.description,
    required this.actorName,
    required this.actorRole,
    this.icon = Icons.check_circle_outline_rounded,
  });
}

/// Document Attachment
class ProcurementDocument {
  final String id;
  final String fileName;
  final String fileType; // 'PDF', 'DWG', 'Excel', 'Image'
  final String fileSize; // '2.4 MB'
  final String uploadedBy;
  final DateTime uploadDate;
  final String previewUrl;

  const ProcurementDocument({
    required this.id,
    required this.fileName,
    required this.fileType,
    required this.fileSize,
    required this.uploadedBy,
    required this.uploadDate,
    required this.previewUrl,
  });
}
