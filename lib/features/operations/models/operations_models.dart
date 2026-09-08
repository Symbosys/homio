/// Domain models for Module 11: Operations, Material Procurement & Payment Dispatch
enum IndentUrgency {
  urgent,
  standard,
}

enum IndentStatus {
  pendingRfq,
  bidsReceived,
  approved,
  dispatched,
}

enum PaymentLinkStatus {
  pending,
  paid,
  disbursed,
}

enum SaturdayFeeStatus {
  scheduled,
  sent,
  failed,
}

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
  final String contractModel; // 'Fixed Consulting', 'Percentage of Cost', 'Turnkey'
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
