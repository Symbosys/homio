// Homio CRM — Screen 4: Payments & Collections Workspace

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../models/accounting_models.dart';
import '../models/accounting_mock_data.dart';
import '../widgets/finance_page_header.dart';
import '../widgets/finance_kpi_card.dart';
import '../widgets/financial_filter_bar.dart';
import '../widgets/financial_status_badge.dart';
import '../widgets/payment_receipt_modal.dart';
import '../widgets/payment_reconciliation_modal.dart';

class PaymentsPage extends StatefulWidget {
  const PaymentsPage({super.key});

  @override
  State<PaymentsPage> createState() => _PaymentsPageState();
}

class _PaymentsPageState extends State<PaymentsPage> {
  late List<CustomerPaymentRecord> _payments;
  String _searchQuery = '';
  String? _selectedProject;

  @override
  void initState() {
    super.initState();
    _payments = List.from(AccountingMockData.customerPayments);
  }

  List<CustomerPaymentRecord> get _filteredPayments {
    return _payments.where((p) {
      final matchesSearch = _searchQuery.isEmpty ||
          p.paymentId.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          p.customerName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          p.transactionId.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          p.invoiceNumber.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesProject =
          _selectedProject == null || p.projectName == _selectedProject;
      return matchesSearch && matchesProject;
    }).toList();
  }

  double get _totalCollected =>
      _payments.fold(0.0, (sum, p) => sum + p.currentPayment);

  void _openRecordPaymentModal() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => _RecordPaymentModal(
        onRecorded: (newPayment) {
          setState(() {
            _payments.insert(0, newPayment);
          });
          _openReceiptModal(newPayment);
        },
      ),
    );
  }

  void _openReceiptModal(CustomerPaymentRecord payment) {
    showDialog(
      context: context,
      builder: (ctx) => PaymentReceiptModal(payment: payment),
    );
  }

  void _openReconciliationModal() {
    showDialog(
      context: context,
      builder: (ctx) => PaymentReconciliationModal(
        items: AccountingMockData.reconciliations,
        onReconciled: (item) => setState(() {}),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final projectList = _payments.map((p) => p.projectName).toSet().toList();

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: Column(
        children: [
          // 1. Header
          FinancePageHeader(
            title: 'Payments & Collections',
            subtitle:
                'Record customer payments, track bank transaction UTRs, manage partial realizations, generate receipts, and reconcile statements.',
            icon: Icons.payments_rounded,
            primaryActionLabel: 'Record Payment',
            primaryActionIcon: Icons.add_card_rounded,
            onPrimaryAction: _openRecordPaymentModal,
            secondaryAction: FilledButton.tonalIcon(
              onPressed: _openReconciliationModal,
              icon: const Icon(Icons.sync_alt_rounded, size: 16),
              label: const Text('Bank Reconciliation', style: TextStyle(fontSize: 12)),
            ),
            onRefresh: () => setState(() {}),
          ),

          // 2. Body
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // KPI Grid
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final cols = constraints.maxWidth > 1100 ? 4 : 2;
                      return GridView.count(
                        crossAxisCount: cols,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisSpacing: 14,
                        mainAxisSpacing: 14,
                        childAspectRatio: 2.3,
                        children: [
                          FinanceKpiCard(
                            title: 'Total Cleared Collections',
                            value: '₹${_totalCollected.toStringAsFixed(0)}',
                            subtitle: '${_payments.length} Cleared Transactions',
                            icon: Icons.account_balance_rounded,
                            color: AppColors.success,
                          ),
                          FinanceKpiCard(
                            title: "Latest RTGS Receipt",
                            value: '₹${_payments.isNotEmpty ? _payments.first.currentPayment.toStringAsFixed(0) : "0"}',
                            subtitle: _payments.isNotEmpty ? 'Ref: ${_payments.first.paymentId}' : 'No receipts yet',
                            icon: Icons.verified_rounded,
                            color: AppColors.primary,
                          ),
                          FinanceKpiCard(
                            title: 'Reconciled Bank Credits',
                            value: '${AccountingMockData.reconciliations.where((r) => r.isReconciled).length}',
                            subtitle: 'Matched against HDFC & Axis accounts',
                            icon: Icons.task_alt_rounded,
                            color: const Color(0xFF0D9488),
                          ),
                          FinanceKpiCard(
                            title: 'Pending Reconciliation',
                            value: '${AccountingMockData.reconciliations.where((r) => !r.isReconciled).length} Unmatched',
                            subtitle: 'Requires client ledger allocation',
                            icon: Icons.sync_problem_rounded,
                            color: AppColors.warning,
                            onTap: _openReconciliationModal,
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 24),

                  // Search Toolbar
                  FinancialFilterBar(
                    searchQuery: _searchQuery,
                    onSearchChanged: (val) => setState(() => _searchQuery = val),
                    searchHint: 'Search payment ID, customer, UTR, or invoice...',
                    selectedProject: _selectedProject,
                    projectList: projectList,
                    onProjectChanged: (val) => setState(() => _selectedProject = val),
                    onClearFilters: () => setState(() {
                      _searchQuery = '';
                      _selectedProject = null;
                    }),
                  ),
                  const SizedBox(height: 20),

                  // Payments Table
                  Container(
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          headingRowColor: WidgetStatePropertyAll(
                            isDark ? AppColors.darkSurfaceElevated : AppColors.lightSurfaceSubtle,
                          ),
                          columns: const [
                            DataColumn(label: Text('PAYMENT ID', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11))),
                            DataColumn(label: Text('CUSTOMER', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11))),
                            DataColumn(label: Text('PROJECT & INVOICE', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11))),
                            DataColumn(label: Text('DATE', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11))),
                            DataColumn(label: Text('AMOUNT (₹)', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11))),
                            DataColumn(label: Text('METHOD', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11))),
                            DataColumn(label: Text('TRANSACTION / UTR', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11))),
                            DataColumn(label: Text('REMAINING BAL', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11))),
                            DataColumn(label: Text('STATUS', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11))),
                            DataColumn(label: Text('ACTIONS', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11))),
                          ],
                          rows: _filteredPayments.map((pay) {
                            return DataRow(
                              cells: [
                                DataCell(
                                  Text(
                                    pay.paymentId,
                                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: AppColors.primary),
                                  ),
                                ),
                                DataCell(
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(pay.customerName, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                                      Text(pay.payerContact, style: const TextStyle(fontSize: 10, color: Colors.grey)),
                                    ],
                                  ),
                                ),
                                DataCell(
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(pay.projectName, style: const TextStyle(fontSize: 12)),
                                      Text(pay.invoiceNumber, style: const TextStyle(fontSize: 10, color: AppColors.primary)),
                                    ],
                                  ),
                                ),
                                DataCell(Text('${pay.paymentDate.day}/${pay.paymentDate.month}/${pay.paymentDate.year}', style: const TextStyle(fontSize: 11))),
                                DataCell(
                                  Text(
                                    '₹${pay.currentPayment.toStringAsFixed(0)}',
                                    style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: AppColors.success),
                                  ),
                                ),
                                DataCell(
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(pay.paymentMethod.icon, size: 14, color: AppColors.primary),
                                      const SizedBox(width: 6),
                                      Text(pay.paymentMethod.name.toUpperCase(), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                                    ],
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    pay.transactionId,
                                    style: const TextStyle(fontFamily: 'monospace', fontSize: 11, fontWeight: FontWeight.w600),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    '₹${pay.remainingBalance.toStringAsFixed(0)}',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: pay.remainingBalance > 0 ? AppColors.warning : AppColors.success,
                                    ),
                                  ),
                                ),
                                DataCell(FinancialStatusBadge.fromPayment(pay.status)),
                                DataCell(
                                  IconButton(
                                    onPressed: () => _openReceiptModal(pay),
                                    icon: const Icon(Icons.receipt_long_rounded, size: 18, color: AppColors.primary),
                                    tooltip: 'View Official Receipt',
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Record Customer Payment Modal with Partial Payment Calculator
// -----------------------------------------------------------------------------
class _RecordPaymentModal extends StatefulWidget {
  final ValueChanged<CustomerPaymentRecord> onRecorded;

  const _RecordPaymentModal({required this.onRecorded});

  @override
  State<_RecordPaymentModal> createState() => _RecordPaymentModalState();
}

class _RecordPaymentModalState extends State<_RecordPaymentModal> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _amountCtrl = TextEditingController(text: '830000');
  final TextEditingController _utrCtrl = TextEditingController(text: 'HDFCR52026090881920');
  final TextEditingController _payerNameCtrl = TextEditingController(text: 'Rahul Sharma');
  final TextEditingController _payerContactCtrl = TextEditingController(text: '+91 98100 45210');
  final TextEditingController _notesCtrl = TextEditingController(text: 'Part payment cleared via RTGS.');

  PaymentMethod _paymentMethod = PaymentMethod.bankTransfer;
  String _selectedInvoiceId = 'INV-001';

  @override
  void dispose() {
    _amountCtrl.dispose();
    _utrCtrl.dispose();
    _payerNameCtrl.dispose();
    _payerContactCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      final selectedInv = AccountingMockData.invoices.firstWhere(
        (i) => i.id == _selectedInvoiceId,
        orElse: () => AccountingMockData.invoices.first,
      );

      final enteredAmount = double.tryParse(_amountCtrl.text) ?? selectedInv.outstandingAmount;

      final newRecord = CustomerPaymentRecord(
        id: 'PAY-${DateTime.now().millisecondsSinceEpoch}',
        paymentId: 'PAY-2026-${DateTime.now().millisecondsSinceEpoch.toString().substring(9)}',
        paymentDate: DateTime.now(),
        customerId: selectedInv.customerId,
        customerName: selectedInv.customerName,
        projectId: selectedInv.projectId,
        projectName: selectedInv.projectName,
        invoiceId: selectedInv.id,
        invoiceNumber: selectedInv.invoiceNumber,
        invoiceTotal: selectedInv.grandTotal,
        previousPaid: selectedInv.paidAmount,
        currentPayment: enteredAmount,
        paymentMethod: _paymentMethod,
        transactionId: _utrCtrl.text,
        utrNumber: _utrCtrl.text,
        status: PaymentStatus.completed,
        receiptNumber: 'REC-2026-${DateTime.now().millisecondsSinceEpoch.toString().substring(9)}',
        payerName: _payerNameCtrl.text,
        payerContact: _payerContactCtrl.text,
        notes: _notesCtrl.text,
        recordedBy: 'Accounts Officer',
      );

      widget.onRecorded(newRecord);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final selectedInv = AccountingMockData.invoices.firstWhere(
      (i) => i.id == _selectedInvoiceId,
      orElse: () => AccountingMockData.invoices.first,
    );

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Container(
        width: 640,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('RECORD CUSTOMER PAYMENT', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
                    IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close_rounded)),
                  ],
                ),
                const Divider(height: 20),

                // Select Invoice
                DropdownButtonFormField<String>(
                  initialValue: _selectedInvoiceId,
                  decoration: const InputDecoration(labelText: 'Select Pending Invoice *', isDense: true, border: OutlineInputBorder()),
                  items: AccountingMockData.invoices.map((inv) {
                    return DropdownMenuItem(
                      value: inv.id,
                      child: Text('${inv.invoiceNumber} — ${inv.customerName} (Due: ₹${inv.outstandingAmount.toStringAsFixed(0)})'),
                    );
                  }).toList(),
                  onChanged: (val) => setState(() => _selectedInvoiceId = val!),
                ),
                const SizedBox(height: 14),

                // Live Ledger Balance Strip
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurfaceElevated : AppColors.lightSurfaceSubtle,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text('Invoice Total: ₹${selectedInv.grandTotal.toStringAsFixed(0)}', style: const TextStyle(fontSize: 11)),
                      Text('Prev Paid: ₹${selectedInv.paidAmount.toStringAsFixed(0)}', style: const TextStyle(fontSize: 11, color: AppColors.success)),
                      Text('Current Due: ₹${selectedInv.outstandingAmount.toStringAsFixed(0)}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.error)),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _amountCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Current Payment Cleared (₹) *', prefixText: '₹ ', isDense: true, border: OutlineInputBorder()),
                  validator: (val) => (val == null || val.isEmpty) ? 'Please enter amount' : null,
                ),
                const SizedBox(height: 14),

                DropdownButtonFormField<PaymentMethod>(
                  initialValue: _paymentMethod,
                  decoration: const InputDecoration(labelText: 'Payment Method *', isDense: true, border: OutlineInputBorder()),
                  items: PaymentMethod.values.map((m) {
                    return DropdownMenuItem(value: m, child: Row(children: [Icon(m.icon, size: 16), const SizedBox(width: 8), Text(m.label)]));
                  }).toList(),
                  onChanged: (val) => setState(() => _paymentMethod = val!),
                ),
                const SizedBox(height: 14),

                TextFormField(
                  controller: _utrCtrl,
                  decoration: const InputDecoration(labelText: 'Bank UTR / Transaction Reference *', isDense: true, border: OutlineInputBorder()),
                  validator: (val) => (val == null || val.isEmpty) ? 'Please enter UTR or Transaction ID' : null,
                ),
                const SizedBox(height: 14),

                Row(
                  children: [
                    Expanded(child: TextFormField(controller: _payerNameCtrl, decoration: const InputDecoration(labelText: 'Payer Name', isDense: true, border: OutlineInputBorder()))),
                    const SizedBox(width: 12),
                    Expanded(child: TextFormField(controller: _payerContactCtrl, decoration: const InputDecoration(labelText: 'Payer Mobile', isDense: true, border: OutlineInputBorder()))),
                  ],
                ),
                const SizedBox(height: 14),

                TextFormField(
                  controller: _notesCtrl,
                  maxLines: 2,
                  decoration: const InputDecoration(labelText: 'Accounting Notes', isDense: true, border: OutlineInputBorder()),
                ),
                const SizedBox(height: 24),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                    const SizedBox(width: 12),
                    FilledButton.icon(
                      onPressed: _submit,
                      icon: const Icon(Icons.check_rounded, size: 16),
                      label: const Text('Record & Issue Receipt'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
