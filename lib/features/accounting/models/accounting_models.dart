// Domain models for Module 10: Accounting, Client Ledgers & Commission Tracking

enum FinancialHealth {
  healthy,
  warning,
  critical,
}

enum LedgerCategory {
  material,
  labour,
  supervisionFee,
}

enum TransactionPaymentStatus {
  paid,
  partial,
  unpaid,
}

enum SiteHaltStatus {
  active,
  halted,
}

enum EscalationLevel {
  level1ClientReminder,
  level2SupervisorHalt,
  level3AdminEscalation,
}

class CustomerFinancialSummary {
  final String clientId;
  final String clientName;
  final String clientPhone;
  final String projectTitle;
  final String contractModel; // 'Fixed Consulting', 'Percentage of Cost', 'Turnkey'
  final double totalContractValue;
  final double materialPaid;
  final double materialUnpaid;
  final double labourPaid;
  final double labourUnpaid;
  final double feesPaid;
  final double feesUnpaid;
  final int totalBillsCount;
  final FinancialHealth health;
  final double completionPercent;

  const CustomerFinancialSummary({
    required this.clientId,
    required this.clientName,
    required this.clientPhone,
    required this.projectTitle,
    required this.contractModel,
    required this.totalContractValue,
    required this.materialPaid,
    required this.materialUnpaid,
    required this.labourPaid,
    required this.labourUnpaid,
    required this.feesPaid,
    required this.feesUnpaid,
    required this.totalBillsCount,
    required this.health,
    required this.completionPercent,
  });

  double get totalMaterial => materialPaid + materialUnpaid;
  double get totalLabour => labourPaid + labourUnpaid;
  double get totalFees => feesPaid + feesUnpaid;
  double get totalCollected => materialPaid + labourPaid + feesPaid;
  double get totalOutstandingDues => materialUnpaid + labourUnpaid + feesUnpaid;
  double get totalInvoiced => totalCollected + totalOutstandingDues;
}

class LedgerTransaction {
  final String id;
  final String voucherNo;
  final DateTime date;
  final String clientName;
  final String projectTitle;
  final LedgerCategory category;
  final String payeeOrVendor;
  final double amount;
  final TransactionPaymentStatus paymentStatus;
  final double commissionRatePercent;
  final double commissionEarned;
  final String remarks;
  final String? voucherFileRef;

  const LedgerTransaction({
    required this.id,
    required this.voucherNo,
    required this.date,
    required this.clientName,
    required this.projectTitle,
    required this.category,
    required this.payeeOrVendor,
    required this.amount,
    required this.paymentStatus,
    required this.commissionRatePercent,
    required this.commissionEarned,
    required this.remarks,
    this.voucherFileRef,
  });

  LedgerTransaction copyWith({
    String? id,
    String? voucherNo,
    DateTime? date,
    String? clientName,
    String? projectTitle,
    LedgerCategory? category,
    String? payeeOrVendor,
    double? amount,
    TransactionPaymentStatus? paymentStatus,
    double? commissionRatePercent,
    double? commissionEarned,
    String? remarks,
    String? voucherFileRef,
  }) {
    return LedgerTransaction(
      id: id ?? this.id,
      voucherNo: voucherNo ?? this.voucherNo,
      date: date ?? this.date,
      clientName: clientName ?? this.clientName,
      projectTitle: projectTitle ?? this.projectTitle,
      category: category ?? this.category,
      payeeOrVendor: payeeOrVendor ?? this.payeeOrVendor,
      amount: amount ?? this.amount,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      commissionRatePercent: commissionRatePercent ?? this.commissionRatePercent,
      commissionEarned: commissionEarned ?? this.commissionEarned,
      remarks: remarks ?? this.remarks,
      voucherFileRef: voucherFileRef ?? this.voucherFileRef,
    );
  }
}

class OverdueAlert {
  final String id;
  final String clientName;
  final String clientPhone;
  final String projectTitle;
  final int overdueDays;
  final double dueAmount;
  final String supervisorName;
  final SiteHaltStatus siteHaltStatus;
  final EscalationLevel escalationLevel;
  final DateTime lastAlertSent;
  final String notes;

  const OverdueAlert({
    required this.id,
    required this.clientName,
    required this.clientPhone,
    required this.projectTitle,
    required this.overdueDays,
    required this.dueAmount,
    required this.supervisorName,
    required this.siteHaltStatus,
    required this.escalationLevel,
    required this.lastAlertSent,
    required this.notes,
  });

  OverdueAlert copyWith({
    String? id,
    String? clientName,
    String? clientPhone,
    String? projectTitle,
    int? overdueDays,
    double? dueAmount,
    String? supervisorName,
    SiteHaltStatus? siteHaltStatus,
    EscalationLevel? escalationLevel,
    DateTime? lastAlertSent,
    String? notes,
  }) {
    return OverdueAlert(
      id: id ?? this.id,
      clientName: clientName ?? this.clientName,
      clientPhone: clientPhone ?? this.clientPhone,
      projectTitle: projectTitle ?? this.projectTitle,
      overdueDays: overdueDays ?? this.overdueDays,
      dueAmount: dueAmount ?? this.dueAmount,
      supervisorName: supervisorName ?? this.supervisorName,
      siteHaltStatus: siteHaltStatus ?? this.siteHaltStatus,
      escalationLevel: escalationLevel ?? this.escalationLevel,
      lastAlertSent: lastAlertSent ?? this.lastAlertSent,
      notes: notes ?? this.notes,
    );
  }
}
