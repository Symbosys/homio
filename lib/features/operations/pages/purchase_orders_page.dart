import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../models/operations_models.dart';
import '../models/operations_mock_data.dart';
import '../widgets/procurement_header.dart';
import '../widgets/procurement_kpi_card.dart';
import '../widgets/procurement_context_bar.dart';
import '../widgets/procurement_status_badge.dart';
import '../widgets/po_document_preview.dart';
import '../widgets/customer_operations_summary_modal.dart';

class PurchaseOrdersPage extends StatefulWidget {
  final ValueChanged<PurchaseOrder>? onDispatchPo;

  const PurchaseOrdersPage({super.key, this.onDispatchPo});

  @override
  State<PurchaseOrdersPage> createState() => _PurchaseOrdersPageState();
}

class _PurchaseOrdersPageState extends State<PurchaseOrdersPage> {
  late List<PurchaseOrder> _pos;
  String _searchQuery = '';
  PurchaseOrderStatus? _statusFilter;
  PurchaseOrder? _selectedPo;

  @override
  void initState() {
    super.initState();
    _pos = List.from(OperationsMockData.purchaseOrders);
    if (_pos.isNotEmpty) {
      _selectedPo = _pos.first;
    }
  }

  List<PurchaseOrder> get _filteredPos {
    return _pos.where((po) {
      final matchesSearch = _searchQuery.isEmpty ||
          po.poNumber.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          po.vendorLegalName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          po.projectName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          po.customerName.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesStatus =
          _statusFilter == null || po.status == _statusFilter;
      return matchesSearch && matchesStatus;
    }).toList();
  }

  // KPIs
  int get _totalCount => _pos.length;
  int get _approvedCount =>
      _pos.where((p) => p.status == PurchaseOrderStatus.approved).length;
  int get _acknowledgedCount =>
      _pos.where((p) => p.status == PurchaseOrderStatus.vendorAcknowledged).length;
  int get _dispatchedCount =>
      _pos.where((p) => p.dispatchStatus == MaterialDispatchStatus.dispatched).length;

  double get _totalPoValue =>
      _pos.fold(0.0, (sum, p) => sum + p.grandTotal);
  double get _totalPaidValue =>
      _pos.fold(0.0, (sum, p) => sum + p.paidAmount);
  double get _totalOutstandingValue =>
      _totalPoValue - _totalPaidValue;

  void _openCreateModal() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => _CreatePurchaseOrderModal(
        onCreated: (newPo) {
          setState(() {
            _pos.insert(0, newPo);
            _selectedPo = newPo;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Purchase Order ${newPo.poNumber} created and approved!'),
              backgroundColor: AppColors.success,
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
      ),
    );
  }

  void _openPoPreview(PurchaseOrder po) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        insetPadding: const EdgeInsets.all(24),
        child: Container(
          width: 900,
          constraints: const BoxConstraints(maxHeight: 820),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Purchase Order Preview (${po.poNumber})',
                        style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
                    IconButton(
                      icon: const Icon(Icons.close_rounded),
                      onPressed: () => Navigator.of(ctx).pop(),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: PoDocumentPreview(
                  po: po,
                  onPrint: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Sent PO document to printer!')),
                    );
                  },
                  onDownloadPdf: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Downloaded PDF for ${po.poNumber}')),
                    );
                  },
                  onShareWhatsApp: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('PO sent to vendor WhatsApp: ${po.vendorMobile}')),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: Column(
        children: [
          // 1. Header
          ProcurementPageHeader(
            title: 'Purchase Orders',
            subtitle:
                'Generate legally binding, branded POs for vetted suppliers, track acknowledgments, and link to dispatches.',
            icon: Icons.receipt_long_outlined,
            primaryActionLabel: 'Create Purchase Order',
            primaryActionIcon: Icons.add_rounded,
            onPrimaryAction: _openCreateModal,
            onRefresh: () => setState(() {}),
          ),

          // 2. Global Context Bar
          if (_selectedPo != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 14, 24, 0),
              child: ProcurementContextBar(
                projectName: _selectedPo!.projectName,
                siteAddress: _selectedPo!.siteAddress,
                clientName: _selectedPo!.customerName,
                projectManager: 'Amit Kumar',
                projectStatus: 'Approved Purchase Order Issued',
                procurementStatus: 'PO Issued • ₹${_selectedPo!.grandTotal.toStringAsFixed(0)}',
                onViewCustomerSummary: () {
                  final summary = OperationsMockData.customerSummaries.first;
                  showDialog(
                    context: context,
                    builder: (_) => CustomerOperationsSummaryModal(summary: summary),
                  );
                },
              ),
            ),

          // 3. Scrollable Dashboard Body
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // KPI Grid (4 Cards)
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final cols = constraints.maxWidth > 1100 ? 4 : 2;
                      return GridView.count(
                        crossAxisCount: cols,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisSpacing: 14,
                        mainAxisSpacing: 14,
                        childAspectRatio: 2.2,
                        children: [
                          ProcurementKpiCard(
                            title: 'Total PO Value',
                            value: '₹${_totalPoValue.toStringAsFixed(0)}',
                            subtitle: '$_approvedCount Approved • $_totalCount Orders',
                            icon: Icons.receipt_long_outlined,
                            color: AppColors.primary,
                            isSelected: _statusFilter == null,
                            onTap: () => setState(() => _statusFilter = null),
                          ),
                          ProcurementKpiCard(
                            title: 'Acknowledged by Vendor',
                            value: '$_acknowledgedCount',
                            subtitle: 'Confirmed delivery date',
                            icon: Icons.handshake_rounded,
                            color: AppColors.success,
                            isSelected: _statusFilter == PurchaseOrderStatus.vendorAcknowledged,
                            onTap: () => setState(
                                () => _statusFilter = PurchaseOrderStatus.vendorAcknowledged),
                          ),
                          ProcurementKpiCard(
                            title: 'Dispatched Shipments',
                            value: '$_dispatchedCount',
                            subtitle: 'In transit to site',
                            icon: Icons.local_shipping_outlined,
                            color: const Color(0xFF0284C7),
                            isSelected: _statusFilter == PurchaseOrderStatus.dispatched,
                            onTap: () => setState(
                                () => _statusFilter = PurchaseOrderStatus.dispatched),
                          ),
                          ProcurementKpiCard(
                            title: 'Outstanding Balance',
                            value: '₹${_totalOutstandingValue.toStringAsFixed(0)}',
                            subtitle: 'Paid: ₹${_totalPaidValue.toStringAsFixed(0)}',
                            icon: Icons.account_balance_wallet_outlined,
                            color: AppColors.warning,
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 24),

                  // Search Toolbar
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Search PO number, vendor legal name, project, or customer...',
                            prefixIcon: const Icon(Icons.search_rounded, size: 20),
                            isDense: true,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          onChanged: (val) => setState(() => _searchQuery = val),
                        ),
                      ),
                      const SizedBox(width: 12),
                      if (_statusFilter != null)
                        TextButton.icon(
                          onPressed: () => setState(() => _statusFilter = null),
                          icon: const Icon(Icons.clear_all_rounded, size: 16),
                          label: const Text('Reset Filter'),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // PO Data Table
                  _buildDataTable(isDark, theme),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataTable(bool isDark, ThemeData theme) {
    if (_filteredPos.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 48),
          child: Column(
            children: [
              Icon(Icons.receipt_long_outlined,
                  size: 48,
                  color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted),
              const SizedBox(height: 12),
              Text(
                'No Purchase Orders Found',
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: _openCreateModal,
                icon: const Icon(Icons.add_rounded, size: 16),
                label: const Text('Create Purchase Order'),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowColor: WidgetStateProperty.all(
            isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
          ),
          columnSpacing: 20,
          horizontalMargin: 16,
          columns: const [
            DataColumn(label: Text('PO NUMBER', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11))),
            DataColumn(label: Text('VENDOR & GSTIN', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11))),
            DataColumn(label: Text('PROJECT & CLIENT', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11))),
            DataColumn(label: Text('PO DATE', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11))),
            DataColumn(label: Text('EXPECTED DELIVERY', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11))),
            DataColumn(label: Text('TOTAL (₹)', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11))),
            DataColumn(label: Text('PAID / DUE', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11))),
            DataColumn(label: Text('DISPATCH', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11))),
            DataColumn(label: Text('STATUS', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11))),
            DataColumn(label: Text('ACTIONS', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11))),
          ],
          rows: _filteredPos.map((po) {
            final isSelected = po.id == _selectedPo?.id;
            return DataRow(
              selected: isSelected,
              onSelectChanged: (_) => setState(() => _selectedPo = po),
              cells: [
                DataCell(
                  Text(
                    po.poNumber,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                      fontSize: 12,
                    ),
                  ),
                ),
                DataCell(
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(po.vendorLegalName,
                          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                      Text('GSTIN: ${po.gstin}',
                          style: TextStyle(
                            fontSize: 10,
                            color: isDark ? AppColors.darkSubtext : AppColors.lightTextSecondary,
                          )),
                    ],
                  ),
                ),
                DataCell(
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(po.projectName,
                          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                      Text('Client: ${po.customerName}',
                          style: TextStyle(
                            fontSize: 10,
                            color: isDark ? AppColors.darkSubtext : AppColors.lightTextSecondary,
                          )),
                    ],
                  ),
                ),
                DataCell(Text('${po.poDate.day}/${po.poDate.month}/${po.poDate.year}',
                    style: const TextStyle(fontSize: 12))),
                DataCell(
                  Text(
                    '${po.expectedDeliveryDate.day}/${po.expectedDeliveryDate.month}/${po.expectedDeliveryDate.year}',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ),
                DataCell(
                  Text(
                    '₹${po.grandTotal.toStringAsFixed(0)}',
                    style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12),
                  ),
                ),
                DataCell(
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Paid: ₹${po.paidAmount.toStringAsFixed(0)}',
                          style: const TextStyle(
                              fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.success)),
                      Text('Due: ₹${po.dueAmount.toStringAsFixed(0)}',
                          style: const TextStyle(
                              fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.error)),
                    ],
                  ),
                ),
                DataCell(ProcurementStatusBadge.dispatch(po.dispatchStatus)),
                DataCell(ProcurementStatusBadge.purchaseOrder(po.status)),
                DataCell(
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.picture_as_pdf_outlined, size: 18),
                        tooltip: 'Branded PO PDF Preview',
                        onPressed: () => _openPoPreview(po),
                      ),
                      if (widget.onDispatchPo != null)
                        IconButton(
                          icon: const Icon(Icons.local_shipping_outlined,
                              size: 18, color: AppColors.primary),
                          tooltip: 'Initiate Dispatch',
                          onPressed: () => widget.onDispatchPo!(po),
                        ),
                    ],
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}

/// ============================================================================
/// CREATE PURCHASE ORDER MODAL
/// ============================================================================
class _CreatePurchaseOrderModal extends StatefulWidget {
  final ValueChanged<PurchaseOrder> onCreated;

  const _CreatePurchaseOrderModal({required this.onCreated});

  @override
  State<_CreatePurchaseOrderModal> createState() =>
      _CreatePurchaseOrderModalState();
}

class _CreatePurchaseOrderModalState extends State<_CreatePurchaseOrderModal> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _vendorLegalCtrl =
      TextEditingController(text: 'Century Wholesale Hub Private Limited');
  final TextEditingController _gstinCtrl =
      TextEditingController(text: '07AABCC8810K1ZT');
  final TextEditingController _panCtrl =
      TextEditingController(text: 'AABCC8810K');
  final TextEditingController _shippingAddressCtrl = TextEditingController(
      text: 'The Camellias, Tower 2, Flat 1402, DLF Phase 5, Gurugram');
  final TextEditingController _paymentTermsCtrl = TextEditingController(
      text: '50% on Dispatch, Balance 50% Net 15 Days after Site QA Acceptance');
  final TextEditingController _instructionsCtrl = TextEditingController(
      text: 'Service gate inspection mandatory before unloading.');

  final DateTime _expectedDelivery = DateTime.now().add(const Duration(days: 3));

  @override
  void dispose() {
    _vendorLegalCtrl.dispose();
    _gstinCtrl.dispose();
    _panCtrl.dispose();
    _shippingAddressCtrl.dispose();
    _paymentTermsCtrl.dispose();
    _instructionsCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final newPo = PurchaseOrder(
      id: 'po_${DateTime.now().millisecondsSinceEpoch}',
      poNumber: 'PO-2026-0014${4 + DateTime.now().second}',
      poDate: DateTime.now(),
      vendorId: 'VND-001',
      vendorLegalName: _vendorLegalCtrl.text,
      vendorCode: 'VND-CEN-01',
      gstin: _gstinCtrl.text,
      pan: _panCtrl.text,
      vendorContactPerson: 'Sunil Aggarwal',
      vendorMobile: '+91 98101 33412',
      vendorEmail: 'sales@centuryhub.in',
      shippingAddress: _shippingAddressCtrl.text,
      rfqId: 'rfq-001',
      rfqNumber: 'RFQ-2026-00084',
      vendorQuoteId: 'vq-101',
      vendorQuoteNumber: 'QT-CEN-2026-881',
      materialRequestId: 'mr-001',
      materialRequestNumber: 'MR-2026-00124',
      projectId: 'PRJ-CAM-01',
      projectName: 'The Camellias Villa Interior #1402',
      customerId: 'CUST-RS-01',
      customerName: 'Rahul Sharma',
      siteAddress: 'The Camellias, DLF Phase 5, Gurugram',
      expectedDeliveryDate: _expectedDelivery,
      paymentTerms: _paymentTermsCtrl.text,
      deliveryInstructions: _instructionsCtrl.text,
      advancePercent: 50,
      advanceAmount: 108040,
      tax: 32580,
      grandTotal: 216080,
      paidAmount: 108040,
      items: [
        PurchaseOrderItem(
          id: 'poi_1',
          itemName: 'Century Club Prime BWP Marine Plywood 19mm',
          itemCode: 'MAT-PLY-710-19',
          specification: 'IS:710 Marine Calibrated 19mm',
          quantity: 45,
          unit: 'Sheets (8x4)',
          rate: 2820,
          amount: 126900,
          requiredDate: _expectedDelivery,
          expectedDelivery: _expectedDelivery,
        ),
      ],
      status: PurchaseOrderStatus.approved,
      dispatchStatus: MaterialDispatchStatus.ready,
    );
    widget.onCreated(newPo);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Container(
        width: 820,
        constraints: const BoxConstraints(maxHeight: 740),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  border: Border(
                    bottom: BorderSide(
                      color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.receipt_long_outlined,
                          color: AppColors.primary, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Create Approved Purchase Order',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w800,
                              )),
                          Text(
                            'Generate contract PO from selected quotation QT-CEN-2026-881 (Century Wholesale Hub).',
                            style: TextStyle(
                              fontSize: 11,
                              color: isDark ? AppColors.darkSubtext : AppColors.lightTextSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),

              // Form fields
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('VENDOR DETAILS & LEGAL IDENTIFIERS',
                          style: theme.textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                            color: AppColors.primary,
                          )),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: TextFormField(
                              controller: _vendorLegalCtrl,
                              decoration: const InputDecoration(
                                labelText: 'Vendor Legal Entity Name *',
                                isDense: true,
                                border: OutlineInputBorder(),
                              ),
                              validator: (v) => v!.isEmpty ? 'Required' : null,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              controller: _gstinCtrl,
                              decoration: const InputDecoration(
                                labelText: 'GSTIN *',
                                isDense: true,
                                border: OutlineInputBorder(),
                              ),
                              validator: (v) => v!.isEmpty ? 'Required' : null,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              controller: _panCtrl,
                              decoration: const InputDecoration(
                                labelText: 'PAN',
                                isDense: true,
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      Text('SITE DELIVERY & INSTRUCTIONS',
                          style: theme.textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                            color: AppColors.primary,
                          )),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _shippingAddressCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Shipping / Site Delivery Address *',
                          isDense: true,
                          border: OutlineInputBorder(),
                        ),
                        validator: (v) => v!.isEmpty ? 'Required' : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _paymentTermsCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Payment & Advance Terms *',
                          isDense: true,
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _instructionsCtrl,
                        maxLines: 2,
                        decoration: const InputDecoration(
                          labelText: 'Unloading & Site Access Guidelines',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Footer
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                  borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
                  border: Border(
                    top: BorderSide(
                      color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 12),
                    FilledButton.icon(
                      onPressed: _submit,
                      icon: const Icon(Icons.check_rounded, size: 16),
                      label: const Text('Generate & Approve PO'),
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
