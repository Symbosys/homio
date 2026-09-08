// Homio CRM — Domain Models for Accounting & Finance Module
// Connects Customer Quotations, Projects, Invoices, Collections, Expenses,
// Vendor/Labour Payables, Commissions, and Overdue Collections.

import 'package:flutter/material.dart';

// =============================================================================
// 1. LEGACY ENUMS & CLASSES (Preserved for backwards compatibility)
// =============================================================================

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

// =============================================================================
// 2. NEW PRD FINANCIAL ENUMS
// =============================================================================

enum InvoiceStatus {
  draft('Draft', Color(0xFF64748B)),
  issued('Issued', Color(0xFF3B82F6)),
  partiallyPaid('Partially Paid', Color(0xFFF59E0B)),
  paid('Paid', Color(0xFF10B981)),
  overdue('Overdue', Color(0xFFEF4444)),
  cancelled('Cancelled', Color(0xFF94A3B8));

  final String label;
  final Color color;
  const InvoiceStatus(this.label, this.color);
}

enum PaymentStatus {
  pending('Pending', Color(0xFFF59E0B)),
  processing('Processing', Color(0xFF8B5CF6)),
  completed('Completed', Color(0xFF10B981)),
  failed('Failed', Color(0xFFEF4444)),
  partiallyApplied('Partially Applied', Color(0xFF06B6D4)),
  refunded('Refunded', Color(0xFF6B7280)),
  reconciled('Reconciled', Color(0xFF059669)),
  unreconciled('Unreconciled', Color(0xFFD97706));

  final String label;
  final Color color;
  const PaymentStatus(this.label, this.color);
}

enum PaymentMethod {
  bankTransfer('Bank Transfer (NEFT/RTGS/IMPS)', Icons.account_balance_rounded),
  upi('UPI / QR Code', Icons.qr_code_2_rounded),
  card('Credit / Debit Card', Icons.credit_card_rounded),
  paymentGateway('Payment Gateway', Icons.payment_rounded),
  cash('Cash', Icons.payments_rounded),
  cheque('Cheque / DD', Icons.receipt_rounded),
  other('Other Method', Icons.more_horiz_rounded);

  final String label;
  final IconData icon;
  const PaymentMethod(this.label, this.icon);
}

enum ExpenseType {
  material('Material Purchase', Icons.inventory_2_outlined),
  labour('Labour & Contractor', Icons.engineering_outlined),
  design('Design & CAD Work', Icons.draw_outlined),
  consulting('Consulting Fee', Icons.psychology_outlined),
  supervision('Site Supervision Fee', Icons.visibility_outlined),
  transport('Transport & Logistics', Icons.local_shipping_outlined),
  siteExpense('Site Expense & Consumables', Icons.construction_outlined),
  officeExpense('Office & Admin', Icons.business_outlined),
  marketing('Marketing & Acquisition', Icons.campaign_outlined),
  other('Other Operational', Icons.category_outlined);

  final String label;
  final IconData icon;
  const ExpenseType(this.label, this.icon);
}

enum ExpenseStatus {
  draft('Draft', Color(0xFF64748B)),
  submitted('Submitted', Color(0xFF3B82F6)),
  approved('Approved', Color(0xFF10B981)),
  partiallyPaid('Partially Paid', Color(0xFFF59E0B)),
  paid('Paid', Color(0xFF059669)),
  rejected('Rejected', Color(0xFFEF4444)),
  cancelled('Cancelled', Color(0xFF94A3B8));

  final String label;
  final Color color;
  const ExpenseStatus(this.label, this.color);
}

enum VendorPaymentStatus {
  pending('Pending Approval', Color(0xFFF59E0B)),
  approved('Approved for Release', Color(0xFF3B82F6)),
  processing('Bank Processing', Color(0xFF8B5CF6)),
  partiallyPaid('Partially Paid', Color(0xFF06B6D4)),
  paid('Fully Settled', Color(0xFF10B981)),
  failed('Transfer Failed', Color(0xFFEF4444)),
  cancelled('Cancelled', Color(0xFF94A3B8));

  final String label;
  final Color color;
  const VendorPaymentStatus(this.label, this.color);
}

enum LabourPaymentStatus {
  pendingVerification('Pending Site Verification', Color(0xFFF59E0B)),
  pendingApproval('Pending PM Approval', Color(0xFF3B82F6)),
  approved('Approved for Payment', Color(0xFF8B5CF6)),
  processing('Processing', Color(0xFF06B6D4)),
  partiallyPaid('Partially Paid', Color(0xFFD97706)),
  paid('Disbursed & Closed', Color(0xFF10B981)),
  rejected('Rejected / Defect', Color(0xFFEF4444)),
  onHold('Site Halt / On Hold', Color(0xFFDC2626));

  final String label;
  final Color color;
  const LabourPaymentStatus(this.label, this.color);
}

enum CommissionType {
  sales('Sales Incentive', Icons.trending_up_rounded),
  vendor('Vendor Sourcing Comm.', Icons.store_mall_directory_rounded),
  labour('Labour Contractor Comm.', Icons.handyman_rounded),
  service('Service Partner Comm.', Icons.build_circle_outlined),
  aiDesigner('AI Designer Revenue Share', Icons.auto_awesome_rounded),
  referral('Client Referral Comm.', Icons.people_outline_rounded),
  partner('Architect Partner Comm.', Icons.apartment_rounded),
  other('Other Commercial Comm.', Icons.monetization_on_outlined);

  final String label;
  final IconData icon;
  const CommissionType(this.label, this.icon);
}

enum CommissionStatus {
  pending('Pending Accrual', Color(0xFFF59E0B)),
  approved('Approved', Color(0xFF3B82F6)),
  payable('Payable / Due', Color(0xFF8B5CF6)),
  receivable('Receivable', Color(0xFF06B6D4)),
  paid('Paid & Settled', Color(0xFF10B981)),
  cancelled('Void / Cancelled', Color(0xFF94A3B8));

  final String label;
  final Color color;
  const CommissionStatus(this.label, this.color);
}

enum CollectionRisk {
  low('Low Risk (Current)', Color(0xFF10B981)),
  medium('Medium Risk (1-7d)', Color(0xFFF59E0B)),
  high('High Risk (8-30d)', Color(0xFFEA580C)),
  critical('Critical (30+d Overdue)', Color(0xFFEF4444));

  final String label;
  final Color color;
  const CollectionRisk(this.label, this.color);
}

enum PromiseToPayStatus {
  promised('Promised', Color(0xFF3B82F6)),
  due('Due Today', Color(0xFFF59E0B)),
  received('Received', Color(0xFF10B981)),
  broken('Broken Promise', Color(0xFFEF4444)),
  rescheduled('Rescheduled', Color(0xFF8B5CF6));

  final String label;
  final Color color;
  const PromiseToPayStatus(this.label, this.color);
}

enum RefundStatus {
  requested('Requested', Color(0xFFF59E0B)),
  approved('Approved', Color(0xFF3B82F6)),
  processing('Processing', Color(0xFF8B5CF6)),
  completed('Completed', Color(0xFF10B981)),
  failed('Failed', Color(0xFFEF4444)),
  rejected('Rejected', Color(0xFF94A3B8));

  final String label;
  final Color color;
  const RefundStatus(this.label, this.color);
}

// =============================================================================
// 3. CORE FINANCIAL ENTITIES
// =============================================================================

/// Customer Ledger Detail with 4-way cost segregation & account history
class CustomerLedgerDetailModel {
  final String customerId;
  final String customerName;
  final String customerPhone;
  final String customerEmail;
  final String billingAddress;
  final String activeProjectName;
  final String projectId;
  final String projectManager;
  final String contractModel; // 'Turnkey', 'Cost Plus %', 'Fixed Consulting'
  final double totalContractValue;
  final double totalInvoiced;
  final double totalCollected;
  final double materialPaid;
  final double materialUnpaid;
  final double labourPaid;
  final double labourUnpaid;
  final double consultingPaid;
  final double consultingUnpaid;
  final double supervisionPaid;
  final double supervisionUnpaid;
  final double totalOutstanding;
  final double overdueAmount;
  final DateTime? lastPaymentDate;
  final FinancialHealth accountStatus;
  final List<LedgerTransactionItem> transactions;

  const CustomerLedgerDetailModel({
    required this.customerId,
    required this.customerName,
    required this.customerPhone,
    required this.customerEmail,
    required this.billingAddress,
    required this.activeProjectName,
    required this.projectId,
    required this.projectManager,
    required this.contractModel,
    required this.totalContractValue,
    required this.totalInvoiced,
    required this.totalCollected,
    required this.materialPaid,
    required this.materialUnpaid,
    required this.labourPaid,
    required this.labourUnpaid,
    required this.consultingPaid,
    required this.consultingUnpaid,
    required this.supervisionPaid,
    required this.supervisionUnpaid,
    required this.totalOutstanding,
    required this.overdueAmount,
    this.lastPaymentDate,
    required this.accountStatus,
    this.transactions = const [],
  });

  double get totalMaterial => materialPaid + materialUnpaid;
  double get totalLabour => labourPaid + labourUnpaid;
  double get totalConsulting => consultingPaid + consultingUnpaid;
  double get totalSupervision => supervisionPaid + supervisionUnpaid;
  double get collectionPercentage =>
      totalInvoiced > 0 ? (totalCollected / totalInvoiced) * 100 : 0.0;
}

/// Granular debit/credit ledger line
class LedgerTransactionItem {
  final String id;
  final String transactionId;
  final DateTime date;
  final String type; // 'Invoice', 'Payment', 'Adjustment', 'Fee'
  final String reference;
  final String projectName;
  final String description;
  final double debit;
  final double credit;
  final double balance;
  final String status;

  const LedgerTransactionItem({
    required this.id,
    required this.transactionId,
    required this.date,
    required this.type,
    required this.reference,
    required this.projectName,
    required this.description,
    required this.debit,
    required this.credit,
    required this.balance,
    required this.status,
  });
}

/// Invoice line item supporting interior dimensions & units
class InvoiceLineItem {
  final String id;
  final String itemName;
  final String itemCode;
  final String description;
  final String category; // 'Woodwork', 'Civil', 'Electrical', 'Consulting'
  final double quantity;
  final String unit; // 'Sq.Ft.', 'Piece/Nos', 'Running Ft.', 'Lump Sum'
  final double rate;
  final double discount;
  final double taxPercent; // e.g. 18.0 for 18% GST
  final String roomArea;
  final String stageOrMilestone;

  const InvoiceLineItem({
    required this.id,
    required this.itemName,
    required this.itemCode,
    required this.description,
    required this.category,
    required this.quantity,
    required this.unit,
    required this.rate,
    this.discount = 0.0,
    this.taxPercent = 18.0,
    this.roomArea = 'Living Room',
    this.stageOrMilestone = 'Milestone 2',
  });

  double get subtotal => quantity * rate;
  double get discountedAmount => subtotal - discount;
  double get taxAmount => discountedAmount * (taxPercent / 100);
  double get totalAmount => discountedAmount + taxAmount;
}

/// Complete invoice entity matching Indian GST & Homio CRM specifications
class Invoice {
  final String id;
  final String invoiceNumber;
  final DateTime invoiceDate;
  final DateTime dueDate;
  final String invoiceType; // 'Tax Invoice', 'Proforma Invoice', 'Commercial Bill'
  final String customerId;
  final String customerName;
  final String customerPhone;
  final String customerEmail;
  final String billingAddress;
  final String siteAddress;
  final String? customerGstin;
  final String? customerPan;
  final String projectId;
  final String projectName;
  final String? referenceQuotationNo;
  final String? referenceBookingNo;
  final String paymentTerms;
  final List<InvoiceLineItem> items;
  final double subtotal;
  final double discount;
  final double taxableAmount;
  final double taxAmount;
  final double additionalCharges;
  final double roundOff;
  final double grandTotal;
  final double paidAmount;
  final InvoiceStatus status;
  final String? paymentLink;
  final String notes;
  final String termsAndConditions;
  final String createdBy;

  const Invoice({
    required this.id,
    required this.invoiceNumber,
    required this.invoiceDate,
    required this.dueDate,
    this.invoiceType = 'Tax Invoice',
    required this.customerId,
    required this.customerName,
    required this.customerPhone,
    required this.customerEmail,
    required this.billingAddress,
    required this.siteAddress,
    this.customerGstin,
    this.customerPan,
    required this.projectId,
    required this.projectName,
    this.referenceQuotationNo,
    this.referenceBookingNo,
    this.paymentTerms = 'Net 15 Days',
    required this.items,
    required this.subtotal,
    this.discount = 0.0,
    required this.taxableAmount,
    required this.taxAmount,
    this.additionalCharges = 0.0,
    this.roundOff = 0.0,
    required this.grandTotal,
    this.paidAmount = 0.0,
    required this.status,
    this.paymentLink,
    this.notes = 'Payment to be transferred via NEFT/RTGS to Homio Private Limited.',
    this.termsAndConditions = '1. Interest @ 18% p.a. will be charged on overdue payments.\n2. Goods once sold will not be taken back.',
    required this.createdBy,
  });

  double get outstandingAmount => (grandTotal - paidAmount).clamp(0.0, double.infinity);
  bool get isFullyPaid => paidAmount >= grandTotal;
  bool get isOverdue => dueDate.isBefore(DateTime.now()) && outstandingAmount > 0;
}

/// Payment recording entity
class CustomerPaymentRecord {
  final String id;
  final String paymentId;
  final DateTime paymentDate;
  final String customerId;
  final String customerName;
  final String projectId;
  final String projectName;
  final String invoiceId;
  final String invoiceNumber;
  final double invoiceTotal;
  final double previousPaid;
  final double currentPayment;
  final PaymentMethod paymentMethod;
  final String transactionId; // UTR, Bank Ref, Gateway ID
  final String? bankReference;
  final String? utrNumber;
  final String? chequeNumber;
  final String? settlementDate;
  final PaymentStatus status;
  final String receiptNumber;
  final String payerName;
  final String payerContact;
  final String notes;
  final String recordedBy;

  const CustomerPaymentRecord({
    required this.id,
    required this.paymentId,
    required this.paymentDate,
    required this.customerId,
    required this.customerName,
    required this.projectId,
    required this.projectName,
    required this.invoiceId,
    required this.invoiceNumber,
    required this.invoiceTotal,
    required this.previousPaid,
    required this.currentPayment,
    required this.paymentMethod,
    required this.transactionId,
    this.bankReference,
    this.utrNumber,
    this.chequeNumber,
    this.settlementDate,
    required this.status,
    required this.receiptNumber,
    required this.payerName,
    required this.payerContact,
    this.notes = 'Payment received and verified.',
    required this.recordedBy,
  });

  double get totalPaidAfterThis => previousPaid + currentPayment;
  double get remainingBalance => (invoiceTotal - totalPaidAfterThis).clamp(0.0, double.infinity);
}

/// Payment request model for WhatsApp & secure links
class PaymentRequestModel {
  final String id;
  final String requestId;
  final String customerName;
  final String customerPhone;
  final String projectName;
  final String invoiceNumber;
  final double amount;
  final DateTime dueDate;
  final String message;
  final String paymentInstructions;
  final String securePaymentLink;
  final String deliveryStatus; // 'Sent', 'Delivered', 'Opened', 'Paid'
  final DateTime createdAt;

  const PaymentRequestModel({
    required this.id,
    required this.requestId,
    required this.customerName,
    required this.customerPhone,
    required this.projectName,
    required this.invoiceNumber,
    required this.amount,
    required this.dueDate,
    required this.message,
    required this.paymentInstructions,
    required this.securePaymentLink,
    required this.deliveryStatus,
    required this.createdAt,
  });
}

/// Bank reconciliation item
class ReconciliationItem {
  final String id;
  final String systemPaymentRef;
  final String bankUtrRef;
  final DateTime paymentDate;
  final double amount;
  final String customerName;
  final String bankAccount;
  final bool isReconciled;
  final String? discrepancyNotes;
  final DateTime? reconciledAt;

  const ReconciliationItem({
    required this.id,
    required this.systemPaymentRef,
    required this.bankUtrRef,
    required this.paymentDate,
    required this.amount,
    required this.customerName,
    required this.bankAccount,
    required this.isReconciled,
    this.discrepancyNotes,
    this.reconciledAt,
  });
}

/// Payment refund record
class PaymentRefund {
  final String id;
  final String refundId;
  final String originalPaymentId;
  final String customerName;
  final String projectName;
  final double refundAmount;
  final String refundReason;
  final String requestedBy;
  final String approvedBy;
  final String refundMethod;
  final String transactionReference;
  final DateTime refundDate;
  final RefundStatus status;
  final String notes;

  const PaymentRefund({
    required this.id,
    required this.refundId,
    required this.originalPaymentId,
    required this.customerName,
    required this.projectName,
    required this.refundAmount,
    required this.refundReason,
    required this.requestedBy,
    required this.approvedBy,
    required this.refundMethod,
    required this.transactionReference,
    required this.refundDate,
    required this.status,
    required this.notes,
  });
}

/// Project-centric operational expense
class ProjectExpense {
  final String id;
  final String expenseNumber;
  final DateTime expenseDate;
  final ExpenseType expenseType;
  final String projectId;
  final String projectName;
  final String customerId;
  final String customerName;
  final String siteAddress;
  final String department;
  final String costCentre;
  final String description;
  final String supplierOrPayee;
  final String? supplierCode;
  final String? supplierGstin;
  final String? invoiceOrBillNo;
  final DateTime? billDate;
  final double subtotal;
  final double taxAmount;
  final double freightCharges;
  final double otherCharges;
  final double totalAmount;
  final double paidAmount;
  final ExpenseStatus status;
  final double commissionAmount;
  final String remarks;
  final String? billAttachmentRef;
  final String createdBy;

  const ProjectExpense({
    required this.id,
    required this.expenseNumber,
    required this.expenseDate,
    required this.expenseType,
    required this.projectId,
    required this.projectName,
    required this.customerId,
    required this.customerName,
    required this.siteAddress,
    required this.department,
    required this.costCentre,
    required this.description,
    required this.supplierOrPayee,
    this.supplierCode,
    this.supplierGstin,
    this.invoiceOrBillNo,
    this.billDate,
    required this.subtotal,
    this.taxAmount = 0.0,
    this.freightCharges = 0.0,
    this.otherCharges = 0.0,
    required this.totalAmount,
    this.paidAmount = 0.0,
    required this.status,
    this.commissionAmount = 0.0,
    this.remarks = 'Expense verified against physical voucher.',
    this.billAttachmentRef,
    required this.createdBy,
  });

  double get outstandingAmount => (totalAmount - paidAmount).clamp(0.0, double.infinity);
}

/// Vendor payable record linking directly to Procurement PO
class VendorPaymentRecord {
  final String id;
  final String paymentId;
  final String vendorId;
  final String vendorName;
  final String vendorCode;
  final String vendorContact;
  final String projectId;
  final String projectName;
  final String customerName;
  final String poNumber;
  final String? rfqNumber;
  final String? materialRequestNo;
  final String? dispatchLrNumber;
  final String vendorBillNumber;
  final DateTime billDate;
  final DateTime dueDate;
  final double billTotal;
  final double previousPaid;
  final double currentPayment;
  final VendorPaymentStatus status;
  final PaymentMethod paymentMethod;
  final String? bankName;
  final String? bankAccountNo;
  final String? utrNumber;
  final DateTime? paymentDate;
  final String notes;

  const VendorPaymentRecord({
    required this.id,
    required this.paymentId,
    required this.vendorId,
    required this.vendorName,
    required this.vendorCode,
    required this.vendorContact,
    required this.projectId,
    required this.projectName,
    required this.customerName,
    required this.poNumber,
    this.rfqNumber,
    this.materialRequestNo,
    this.dispatchLrNumber,
    required this.vendorBillNumber,
    required this.billDate,
    required this.dueDate,
    required this.billTotal,
    required this.previousPaid,
    required this.currentPayment,
    required this.status,
    this.paymentMethod = PaymentMethod.bankTransfer,
    this.bankName,
    this.bankAccountNo,
    this.utrNumber,
    this.paymentDate,
    this.notes = 'Approved against QA Site Verification.',
  });

  double get outstandingAmount =>
      (billTotal - (previousPaid + currentPayment)).clamp(0.0, double.infinity);
}

/// Labour payment record connecting Service Booking & site verification
class LabourPaymentRecord {
  final String id;
  final String paymentId;
  final String contractorName;
  final String contractorId;
  final String contactPhone;
  final String serviceCategory; // 'Carpentry', 'Electrical', 'Painting'
  final String projectId;
  final String projectName;
  final String customerName;
  final String siteAddress;
  final String workItem;
  final String workArea;
  final String stageOrMilestone;
  final DateTime workDate;
  final double completionPercentage; // 0-100%
  final double grossAmount;
  final double incentive;
  final double deduction;
  final double commissionDeduction;
  final double netPayable;
  final double previousPaid;
  final double currentPayment;
  final LabourPaymentStatus status;
  // 5-point verification checklist
  final bool workAssigned;
  final bool workCompleted;
  final bool siteVerified;
  final bool pmApproved;
  final bool paymentEligible;
  final String? supervisorVerificationNotes;
  final String? utrNumber;
  final DateTime? disbursementDate;

  const LabourPaymentRecord({
    required this.id,
    required this.paymentId,
    required this.contractorName,
    required this.contractorId,
    required this.contactPhone,
    required this.serviceCategory,
    required this.projectId,
    required this.projectName,
    required this.customerName,
    required this.siteAddress,
    required this.workItem,
    required this.workArea,
    required this.stageOrMilestone,
    required this.workDate,
    required this.completionPercentage,
    required this.grossAmount,
    this.incentive = 0.0,
    this.deduction = 0.0,
    this.commissionDeduction = 0.0,
    required this.netPayable,
    required this.previousPaid,
    required this.currentPayment,
    required this.status,
    this.workAssigned = true,
    this.workCompleted = true,
    this.siteVerified = true,
    this.pmApproved = true,
    this.paymentEligible = true,
    this.supervisorVerificationNotes,
    this.utrNumber,
    this.disbursementDate,
  });

  double get outstandingAmount =>
      (netPayable - (previousPaid + currentPayment)).clamp(0.0, double.infinity);
}

/// Commercial commission record
class CommissionRecord {
  final String id;
  final String commissionId;
  final CommissionType type;
  final String recipientName;
  final String recipientType; // 'Sales Executive', 'Vendor Sourcing', 'AI Designer'
  final String recipientId;
  final String sourceTransactionType; // 'Invoice', 'Payment', 'PO'
  final String sourceTransactionId;
  final String projectId;
  final String projectName;
  final String customerName;
  final double baseAmount;
  final double commissionRate; // e.g. 5.0 for 5%
  final double commissionAmount;
  final DateTime effectiveDate;
  final DateTime dueDate;
  final CommissionStatus status;
  final double paidAmount;
  final String notes;

  const CommissionRecord({
    required this.id,
    required this.commissionId,
    required this.type,
    required this.recipientName,
    required this.recipientType,
    required this.recipientId,
    required this.sourceTransactionType,
    required this.sourceTransactionId,
    required this.projectId,
    required this.projectName,
    required this.customerName,
    required this.baseAmount,
    required this.commissionRate,
    required this.commissionAmount,
    required this.effectiveDate,
    required this.dueDate,
    required this.status,
    this.paidAmount = 0.0,
    this.notes = 'Commercial commission calculated as per project milestone.',
  });

  double get outstandingAmount => (commissionAmount - paidAmount).clamp(0.0, double.infinity);
}

/// Operational overdue collection item with aging & escalation
class OverdueCollectionItem {
  final String id;
  final String customerId;
  final String customerName;
  final String customerPhone;
  final String customerEmail;
  final String projectId;
  final String projectName;
  final String invoiceNumber;
  final DateTime invoiceDate;
  final DateTime dueDate;
  final double invoiceAmount;
  final double paidAmount;
  final double outstandingAmount;
  final int daysOverdue;
  final String collectionOwner;
  final DateTime? lastReminderDate;
  final DateTime? nextFollowUpDate;
  final CollectionRisk risk;
  final int reminderCount;
  final String status; // 'Active Followup', 'Promise to Pay', 'Legal Notice'
  final String notes;

  const OverdueCollectionItem({
    required this.id,
    required this.customerId,
    required this.customerName,
    required this.customerPhone,
    required this.customerEmail,
    required this.projectId,
    required this.projectName,
    required this.invoiceNumber,
    required this.invoiceDate,
    required this.dueDate,
    required this.invoiceAmount,
    required this.paidAmount,
    required this.outstandingAmount,
    required this.daysOverdue,
    required this.collectionOwner,
    this.lastReminderDate,
    this.nextFollowUpDate,
    required this.risk,
    this.reminderCount = 1,
    this.status = 'Active Followup',
    this.notes = 'Customer requested follow-up call post bank clearing.',
  });

  String get agingBracket {
    if (daysOverdue <= 0) return 'Current';
    if (daysOverdue <= 7) return '1–7 Days';
    if (daysOverdue <= 30) return '8–30 Days';
    if (daysOverdue <= 60) return '31–60 Days';
    return '60+ Days';
  }
}

/// Client promise to pay record
class PromiseToPay {
  final String id;
  final String customerName;
  final String projectName;
  final String invoiceNumber;
  final DateTime promiseDate;
  final double promisedAmount;
  final String customerContact;
  final String collectionOwner;
  final DateTime followUpDate;
  final String notes;
  final PromiseToPayStatus status;

  const PromiseToPay({
    required this.id,
    required this.customerName,
    required this.projectName,
    required this.invoiceNumber,
    required this.promiseDate,
    required this.promisedAmount,
    required this.customerContact,
    required this.collectionOwner,
    required this.followUpDate,
    required this.notes,
    required this.status,
  });
}

/// Overdue escalation automation config
class OverdueAutomationConfig {
  final bool enableReminders;
  final bool sendWhatsApp;
  final bool sendEmail;
  final bool sendInternalAlert;
  final bool notifySupervisor;
  final bool escalateToFinance;
  final bool pushToOwnerDashboard;
  final double escalationThreshold;

  const OverdueAutomationConfig({
    this.enableReminders = true,
    this.sendWhatsApp = true,
    this.sendEmail = true,
    this.sendInternalAlert = true,
    this.notifySupervisor = true,
    this.escalateToFinance = true,
    this.pushToOwnerDashboard = true,
    this.escalationThreshold = 100000.0,
  });
}

/// Project-level operational financial health summary
class ProjectFinancialHealthSummary {
  final String projectId;
  final String projectName;
  final String customerName;
  final double totalProjectValue;
  final double invoicedAmount;
  final double collectedAmount;
  final double outstandingAmount;
  final double materialCost;
  final double labourCost;
  final double designCost;
  final double consultingCost;
  final double supervisionCost;
  final double otherExpenses;
  final FinancialHealth health;

  const ProjectFinancialHealthSummary({
    required this.projectId,
    required this.projectName,
    required this.customerName,
    required this.totalProjectValue,
    required this.invoicedAmount,
    required this.collectedAmount,
    required this.outstandingAmount,
    required this.materialCost,
    required this.labourCost,
    required this.designCost,
    required this.consultingCost,
    required this.supervisionCost,
    required this.otherExpenses,
    required this.health,
  });

  double get totalProjectExpenses =>
      materialCost + labourCost + designCost + consultingCost + supervisionCost + otherExpenses;
  double get operationalMargin => totalProjectValue - totalProjectExpenses;
  double get marginPercentage =>
      totalProjectValue > 0 ? (operationalMargin / totalProjectValue) * 100 : 0.0;
}
