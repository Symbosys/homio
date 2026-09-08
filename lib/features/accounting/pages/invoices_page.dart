// Homio CRM — Screen 3: Invoice Management Workspace

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../models/accounting_models.dart';
import '../models/accounting_mock_data.dart';
import '../widgets/finance_page_header.dart';
import '../widgets/finance_kpi_card.dart';
import '../widgets/financial_filter_bar.dart';
import '../widgets/financial_status_badge.dart';
import '../widgets/invoice_document_preview.dart';
import '../widgets/whatsapp_payment_reminder_modal.dart';

class InvoicesPage extends StatefulWidget {
  const InvoicesPage({super.key});

  @override
  State<InvoicesPage> createState() => _InvoicesPageState();
}

class _InvoicesPageState extends State<InvoicesPage> {
  late List<Invoice> _invoices;
  String _searchQuery = '';
  String? _selectedProject;
  InvoiceStatus? _statusFilter;

  @override
  void initState() {
    super.initState();
    _invoices = List.from(AccountingMockData.invoices);
  }

  List<Invoice> get _filteredInvoices {
    return _invoices.where((inv) {
      final matchesSearch = _searchQuery.isEmpty ||
          inv.invoiceNumber.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          inv.customerName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          inv.projectName.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesProject =
          _selectedProject == null || inv.projectName == _selectedProject;
      final matchesStatus = _statusFilter == null || inv.status == _statusFilter;
      return matchesSearch && matchesProject && matchesStatus;
    }).toList();
  }

  double get _totalInvoiceValue =>
      _invoices.fold(0.0, (sum, i) => sum + i.grandTotal);
  double get _totalPaidValue =>
      _invoices.fold(0.0, (sum, i) => sum + i.paidAmount);
  double get _totalOutstandingValue =>
      _invoices.fold(0.0, (sum, i) => sum + i.outstandingAmount);
  int get _overdueCount =>
      _invoices.where((i) => i.status == InvoiceStatus.overdue).length;

  void _openCreateModal() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => _CreateInvoiceModal(
        onCreated: (newInv) {
          setState(() {
            _invoices.insert(0, newInv);
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Tax Invoice ${newInv.invoiceNumber} generated successfully!'),
              backgroundColor: AppColors.success,
            ),
          );
        },
      ),
    );
  }

  void _openInvoicePreview(Invoice invoice) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: SizedBox(
          width: 860,
          height: 720,
          child: InvoiceDocumentPreview(
            invoice: invoice,
            onPrint: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Sent ${invoice.invoiceNumber} to printer.')),
              );
            },
            onDownloadPdf: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Downloaded PDF for ${invoice.invoiceNumber}')),
              );
            },
            onShareWhatsApp: () => _openWhatsAppModal(invoice),
          ),
        ),
      ),
    );
  }

  void _openWhatsAppModal(Invoice invoice) {
    showDialog(
      context: context,
      builder: (ctx) => WhatsAppPaymentReminderModal(
        customerName: invoice.customerName,
        customerPhone: invoice.customerPhone,
        projectName: invoice.projectName,
        invoiceNumber: invoice.invoiceNumber,
        outstandingAmount: invoice.outstandingAmount,
        dueDate: invoice.dueDate,
        paymentLink: invoice.paymentLink ?? 'https://pay.homio.in/inv/${invoice.invoiceNumber}',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final projectList = _invoices.map((i) => i.projectName).toSet().toList();

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: Column(
        children: [
          // 1. Header
          FinancePageHeader(
            title: 'Tax & Client Invoices',
            subtitle:
                'Generate GST-compliant tax invoices, track payment realization, export branded A4 documents, and send WhatsApp payment requests.',
            icon: Icons.receipt_long_rounded,
            primaryActionLabel: 'Create New Invoice',
            primaryActionIcon: Icons.add_rounded,
            onPrimaryAction: _openCreateModal,
            onRefresh: () => setState(() {}),
          ),

          // 2. Dashboard Body
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
                            title: 'Total Invoiced Value',
                            value: '₹${_totalInvoiceValue.toStringAsFixed(0)}',
                            subtitle: '${_invoices.length} Invoices Issued',
                            icon: Icons.receipt_long_outlined,
                            color: AppColors.primary,
                            isSelected: _statusFilter == null,
                            onTap: () => setState(() => _statusFilter = null),
                          ),
                          FinanceKpiCard(
                            title: 'Collected Revenue',
                            value: '₹${_totalPaidValue.toStringAsFixed(0)}',
                            subtitle: 'Cleared into company accounts',
                            icon: Icons.check_circle_outline_rounded,
                            color: AppColors.success,
                            isSelected: _statusFilter == InvoiceStatus.paid,
                            onTap: () => setState(() => _statusFilter = InvoiceStatus.paid),
                          ),
                          FinanceKpiCard(
                            title: 'Pending Outstanding',
                            value: '₹${_totalOutstandingValue.toStringAsFixed(0)}',
                            subtitle: 'Unpaid and partially paid invoices',
                            icon: Icons.hourglass_top_rounded,
                            color: AppColors.warning,
                            isSelected: _statusFilter == InvoiceStatus.partiallyPaid,
                            onTap: () => setState(() => _statusFilter = InvoiceStatus.partiallyPaid),
                          ),
                          FinanceKpiCard(
                            title: 'Overdue Dues',
                            value: '$_overdueCount Overdue',
                            subtitle: 'Requires immediate collection followup',
                            icon: Icons.warning_amber_rounded,
                            color: AppColors.error,
                            isSelected: _statusFilter == InvoiceStatus.overdue,
                            onTap: () => setState(() => _statusFilter = InvoiceStatus.overdue),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 24),

                  // Search & Filter Toolbar
                  FinancialFilterBar(
                    searchQuery: _searchQuery,
                    onSearchChanged: (val) => setState(() => _searchQuery = val),
                    searchHint: 'Search invoice #, customer name, or project...',
                    selectedProject: _selectedProject,
                    projectList: projectList,
                    onProjectChanged: (val) => setState(() => _selectedProject = val),
                    activeFilterSummary: _statusFilter != null ? 'Status: ${_statusFilter!.label}' : null,
                    onClearFilters: () => setState(() {
                      _searchQuery = '';
                      _selectedProject = null;
                      _statusFilter = null;
                    }),
                  ),
                  const SizedBox(height: 20),

                  // Invoices Data Table
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
                            DataColumn(label: Text('INVOICE #', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11))),
                            DataColumn(label: Text('CLIENT', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11))),
                            DataColumn(label: Text('PROJECT', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11))),
                            DataColumn(label: Text('DATE', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11))),
                            DataColumn(label: Text('DUE DATE', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11))),
                            DataColumn(label: Text('TOTAL AMOUNT (₹)', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11))),
                            DataColumn(label: Text('PAID (₹)', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11))),
                            DataColumn(label: Text('OUTSTANDING (₹)', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11))),
                            DataColumn(label: Text('STATUS', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11))),
                            DataColumn(label: Text('ACTIONS', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11))),
                          ],
                          rows: _filteredInvoices.map((inv) {
                            return DataRow(
                              cells: [
                                DataCell(
                                  Text(
                                    inv.invoiceNumber,
                                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: AppColors.primary),
                                  ),
                                ),
                                DataCell(
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(inv.customerName, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                                      Text(inv.customerPhone, style: const TextStyle(fontSize: 10, color: Colors.grey)),
                                    ],
                                  ),
                                ),
                                DataCell(Text(inv.projectName, style: const TextStyle(fontSize: 12))),
                                DataCell(Text('${inv.invoiceDate.day}/${inv.invoiceDate.month}/${inv.invoiceDate.year}', style: const TextStyle(fontSize: 11))),
                                DataCell(
                                  Text(
                                    '${inv.dueDate.day}/${inv.dueDate.month}/${inv.dueDate.year}',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: inv.isOverdue ? FontWeight.w800 : FontWeight.w500,
                                      color: inv.isOverdue ? AppColors.error : null,
                                    ),
                                  ),
                                ),
                                DataCell(Text('₹${inv.grandTotal.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12))),
                                DataCell(Text('₹${inv.paidAmount.toStringAsFixed(0)}', style: const TextStyle(fontSize: 12, color: AppColors.success))),
                                DataCell(
                                  Text(
                                    '₹${inv.outstandingAmount.toStringAsFixed(0)}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: inv.outstandingAmount > 0 ? AppColors.error : Colors.grey,
                                    ),
                                  ),
                                ),
                                DataCell(FinancialStatusBadge.fromInvoice(inv.status)),
                                DataCell(
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        onPressed: () => _openInvoicePreview(inv),
                                        icon: const Icon(Icons.visibility_rounded, size: 18),
                                        tooltip: 'Preview A4 Document',
                                      ),
                                      IconButton(
                                        onPressed: () => _openWhatsAppModal(inv),
                                        icon: const Icon(Icons.chat_bubble_outline_rounded, size: 18, color: Color(0xFF22C55E)),
                                        tooltip: 'Send WhatsApp Payment Link',
                                      ),
                                    ],
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
// Structured Create Invoice Multi-Section Modal
// -----------------------------------------------------------------------------
class _CreateInvoiceModal extends StatefulWidget {
  final ValueChanged<Invoice> onCreated;

  const _CreateInvoiceModal({required this.onCreated});

  @override
  State<_CreateInvoiceModal> createState() => _CreateInvoiceModalState();
}

class _CreateInvoiceModalState extends State<_CreateInvoiceModal> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _invoiceNoCtrl =
      TextEditingController(text: 'INV-2026-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}');
  final TextEditingController _customerNameCtrl =
      TextEditingController(text: 'Rahul Sharma');
  final TextEditingController _phoneCtrl =
      TextEditingController(text: '+91 98100 45210');
  final TextEditingController _emailCtrl =
      TextEditingController(text: 'rahul.sharma@dlf.in');
  final TextEditingController _projectNameCtrl =
      TextEditingController(text: 'The Camellias Villa Interior #1402');
  final TextEditingController _billingAddressCtrl =
      TextEditingController(text: 'Villa 1402, The Camellias, DLF Phase 5, Gurugram');
  final TextEditingController _siteAddressCtrl =
      TextEditingController(text: 'The Camellias, DLF Phase 5, Gurugram');
  final TextEditingController _itemDescCtrl =
      TextEditingController(text: 'Modular Kitchen Blum Soft-Close Carcass & Hardware');
  final TextEditingController _itemQtyCtrl = TextEditingController(text: '1');
  final TextEditingController _itemRateCtrl = TextEditingController(text: '150000');

  DateTime _dueDate = DateTime.now().add(const Duration(days: 15));

  @override
  void dispose() {
    _invoiceNoCtrl.dispose();
    _customerNameCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    _projectNameCtrl.dispose();
    _billingAddressCtrl.dispose();
    _siteAddressCtrl.dispose();
    _itemDescCtrl.dispose();
    _itemQtyCtrl.dispose();
    _itemRateCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      final qty = double.tryParse(_itemQtyCtrl.text) ?? 1.0;
      final rate = double.tryParse(_itemRateCtrl.text) ?? 150000.0;
      final subtotal = qty * rate;
      final taxAmount = subtotal * 0.18;
      final grandTotal = subtotal + taxAmount;

      final newInvoice = Invoice(
        id: 'INV-${DateTime.now().millisecondsSinceEpoch}',
        invoiceNumber: _invoiceNoCtrl.text,
        invoiceDate: DateTime.now(),
        dueDate: _dueDate,
        customerId: 'CUST-001',
        customerName: _customerNameCtrl.text,
        customerPhone: _phoneCtrl.text,
        customerEmail: _emailCtrl.text,
        billingAddress: _billingAddressCtrl.text,
        siteAddress: _siteAddressCtrl.text,
        projectId: 'PRJ-CAM-101',
        projectName: _projectNameCtrl.text,
        paymentTerms: 'Net 15 Days',
        subtotal: subtotal,
        taxableAmount: subtotal,
        taxAmount: taxAmount,
        grandTotal: grandTotal,
        paidAmount: 0,
        status: InvoiceStatus.issued,
        paymentLink: 'https://pay.homio.in/inv/${_invoiceNoCtrl.text}',
        createdBy: 'Finance Desk',
        items: [
          InvoiceLineItem(
            id: 'ITEM-NEW',
            itemName: _itemDescCtrl.text,
            itemCode: 'MAT-GEN-01',
            description: _itemDescCtrl.text,
            category: 'Modular Interior',
            quantity: qty,
            unit: 'Lump Sum',
            rate: rate,
            taxPercent: 18,
            roomArea: 'Site Level',
            stageOrMilestone: 'Execution Milestone',
          ),
        ],
      );

      widget.onCreated(newInvoice);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Container(
        width: 760,
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
                    Text('CREATE TAX INVOICE', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
                    IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close_rounded)),
                  ],
                ),
                const Divider(height: 20),

                // Section A: Header
                Text('SECTION A — INVOICE IDENTIFIERS', style: theme.textTheme.labelSmall?.copyWith(color: AppColors.primary, fontWeight: FontWeight.w800)),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _invoiceNoCtrl,
                        decoration: const InputDecoration(labelText: 'Invoice Number *', isDense: true, border: OutlineInputBorder()),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: _dueDate,
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(const Duration(days: 90)),
                          );
                          if (picked != null) setState(() => _dueDate = picked);
                        },
                        icon: const Icon(Icons.calendar_today_rounded, size: 14),
                        label: Text('Due: ${_dueDate.day}/${_dueDate.month}/${_dueDate.year}'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),

                // Section B: Customer
                Text('SECTION B — CUSTOMER & PROJECT ASSIGNMENT', style: theme.textTheme.labelSmall?.copyWith(color: AppColors.primary, fontWeight: FontWeight.w800)),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(child: TextFormField(controller: _customerNameCtrl, decoration: const InputDecoration(labelText: 'Customer Name *', isDense: true, border: OutlineInputBorder()))),
                    const SizedBox(width: 12),
                    Expanded(child: TextFormField(controller: _phoneCtrl, decoration: const InputDecoration(labelText: 'Contact Phone *', isDense: true, border: OutlineInputBorder()))),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(child: TextFormField(controller: _projectNameCtrl, decoration: const InputDecoration(labelText: 'Project Name *', isDense: true, border: OutlineInputBorder()))),
                    const SizedBox(width: 12),
                    Expanded(child: TextFormField(controller: _billingAddressCtrl, decoration: const InputDecoration(labelText: 'Billing Address', isDense: true, border: OutlineInputBorder()))),
                  ],
                ),
                const SizedBox(height: 18),

                // Section C: Line Item
                Text('SECTION C — LINE ITEM SPECIFICATION', style: theme.textTheme.labelSmall?.copyWith(color: AppColors.primary, fontWeight: FontWeight.w800)),
                const SizedBox(height: 10),
                TextFormField(controller: _itemDescCtrl, decoration: const InputDecoration(labelText: 'Item Description & Scope *', isDense: true, border: OutlineInputBorder())),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(child: TextFormField(controller: _itemQtyCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Quantity', isDense: true, border: OutlineInputBorder()))),
                    const SizedBox(width: 12),
                    Expanded(child: TextFormField(controller: _itemRateCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Rate (₹)', isDense: true, border: OutlineInputBorder()))),
                  ],
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
                      label: const Text('Generate Invoice'),
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
