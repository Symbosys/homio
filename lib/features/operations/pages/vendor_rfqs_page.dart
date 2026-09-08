import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../models/operations_models.dart';
import '../models/operations_mock_data.dart';
import '../widgets/procurement_header.dart';
import '../widgets/procurement_kpi_card.dart';
import '../widgets/procurement_context_bar.dart';
import '../widgets/procurement_status_badge.dart';
import '../widgets/customer_operations_summary_modal.dart';

class VendorRfqsPage extends StatefulWidget {
  final ValueChanged<String>? onNavigateToComparison;

  const VendorRfqsPage({super.key, this.onNavigateToComparison});

  @override
  State<VendorRfqsPage> createState() => _VendorRfqsPageState();
}

class _VendorRfqsPageState extends State<VendorRfqsPage> {
  late List<VendorRfq> _rfqs;
  String _searchQuery = '';
  VendorRfqStatus? _statusFilter;
  VendorRfq? _selectedRfq;

  @override
  void initState() {
    super.initState();
    _rfqs = List.from(OperationsMockData.vendorRfqs);
    if (_rfqs.isNotEmpty) {
      _selectedRfq = _rfqs.first;
    }
  }

  List<VendorRfq> get _filteredRfqs {
    return _rfqs.where((rfq) {
      final matchesSearch = _searchQuery.isEmpty ||
          rfq.rfqNumber.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          rfq.rfqTitle.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          rfq.projectName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          rfq.customerName.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesStatus =
          _statusFilter == null || rfq.status == _statusFilter;
      return matchesSearch && matchesStatus;
    }).toList();
  }

  // KPIs
  int get _totalRfqs => _rfqs.length;
  int get _sentCount =>
      _rfqs.where((r) => r.status == VendorRfqStatus.sent).length;
  int get _awaitingResponsesCount => _rfqs
      .where((r) => r.status == VendorRfqStatus.partiallyResponded)
      .length;
  int get _comparisonReadyCount => _rfqs
      .where((r) => r.status == VendorRfqStatus.comparisonReady)
      .length;

  void _openCreateModal() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => _CreateRfqModal(
        onCreated: (newRfq) {
          setState(() {
            _rfqs.insert(0, newRfq);
            _selectedRfq = newRfq;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('RFQ ${newRfq.rfqNumber} sent to vendors via WhatsApp & Email!'),
              backgroundColor: AppColors.success,
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
      ),
    );
  }

  void _openDetailModal(VendorRfq rfq) {
    showDialog(
      context: context,
      builder: (ctx) => _RfqDetailModal(
        rfq: rfq,
        onProceedToComparison: () {
          Navigator.of(ctx).pop();
          if (widget.onNavigateToComparison != null) {
            widget.onNavigateToComparison!(rfq.id);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Opening Vendor Comparison Workspace for ${rfq.rfqNumber}...'),
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
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
            title: 'Vendor RFQs',
            subtitle:
                'Create and dispatch multi-vendor requests for quotation, track responses and initiate comparative analysis.',
            icon: Icons.send_and_archive_outlined,
            primaryActionLabel: 'Create Vendor RFQ',
            primaryActionIcon: Icons.add_rounded,
            onPrimaryAction: _openCreateModal,
            onRefresh: () => setState(() {}),
          ),

          // 2. Global Homio Context Bar
          if (_selectedRfq != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 14, 24, 0),
              child: ProcurementContextBar(
                projectName: _selectedRfq!.projectName,
                siteAddress: _selectedRfq!.siteAddress,
                clientName: _selectedRfq!.customerName,
                projectManager: 'Amit Kumar',
                projectStatus: 'Active Procurement Bidding',
                procurementStatus: '${_selectedRfq!.vendorsInvitedCount} Vendors Invited',
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
                        childAspectRatio: 2.2,
                        children: [
                          ProcurementKpiCard(
                            title: 'Total Active RFQs',
                            value: '$_totalRfqs',
                            subtitle: 'Multi-vendor bids in progress',
                            icon: Icons.send_and_archive_outlined,
                            color: AppColors.primary,
                            isSelected: _statusFilter == null,
                            onTap: () => setState(() => _statusFilter = null),
                          ),
                          ProcurementKpiCard(
                            title: 'Responses Received',
                            value: '$_awaitingResponsesCount',
                            subtitle: 'Partial vendor quotes in',
                            icon: Icons.hourglass_top_rounded,
                            color: AppColors.warning,
                            isSelected: _statusFilter == VendorRfqStatus.partiallyResponded,
                            onTap: () => setState(
                                () => _statusFilter = VendorRfqStatus.partiallyResponded),
                          ),
                          ProcurementKpiCard(
                            title: 'Comparison Ready',
                            value: '$_comparisonReadyCount',
                            subtitle: 'Ready for vendor evaluation',
                            icon: Icons.compare_arrows_rounded,
                            color: const Color(0xFF8B5CF6),
                            isSelected: _statusFilter == VendorRfqStatus.comparisonReady,
                            onTap: () => setState(
                                () => _statusFilter = VendorRfqStatus.comparisonReady),
                          ),
                          ProcurementKpiCard(
                            title: 'Sent & Awaiting',
                            value: '$_sentCount',
                            subtitle: 'WhatsApp links delivered',
                            icon: Icons.mark_email_read_rounded,
                            color: AppColors.success,
                            isSelected: _statusFilter == VendorRfqStatus.sent,
                            onTap: () => setState(
                                () => _statusFilter = VendorRfqStatus.sent),
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
                            hintText: 'Search RFQ number, title, project, or invited vendors...',
                            prefixIcon: const Icon(Icons.search_rounded, size: 20),
                            isDense: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
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

                  // RFQ Data Table
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
    if (_filteredRfqs.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 48),
          child: Column(
            children: [
              Icon(Icons.send_and_archive_outlined,
                  size: 48,
                  color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted),
              const SizedBox(height: 12),
              Text(
                'No Vendor RFQs Found',
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: _openCreateModal,
                icon: const Icon(Icons.add_rounded, size: 16),
                label: const Text('Create RFQ from Approved Material Request'),
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
          columnSpacing: 22,
          horizontalMargin: 16,
          columns: const [
            DataColumn(label: Text('RFQ NUMBER', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11))),
            DataColumn(label: Text('TITLE & PROJECT', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11))),
            DataColumn(label: Text('MATERIAL REQ', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11))),
            DataColumn(label: Text('DEADLINE', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11))),
            DataColumn(label: Text('VENDORS INVITED', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11))),
            DataColumn(label: Text('RESPONSES', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11))),
            DataColumn(label: Text('EST. VALUE', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11))),
            DataColumn(label: Text('STATUS', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11))),
            DataColumn(label: Text('ACTIONS', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11))),
          ],
          rows: _filteredRfqs.map((rfq) {
            final isSelected = rfq.id == _selectedRfq?.id;
            return DataRow(
              selected: isSelected,
              onSelectChanged: (_) => setState(() => _selectedRfq = rfq),
              cells: [
                DataCell(
                  Text(
                    rfq.rfqNumber,
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
                      Text(rfq.rfqTitle,
                          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                      Text('${rfq.projectName} • ${rfq.customerName}',
                          style: TextStyle(
                            fontSize: 10,
                            color: isDark ? AppColors.darkSubtext : AppColors.lightTextSecondary,
                          )),
                    ],
                  ),
                ),
                DataCell(
                  Text(
                    rfq.materialRequestNumber,
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ),
                DataCell(
                  Text(
                    '${rfq.responseDeadline.day}/${rfq.responseDeadline.month}/${rfq.responseDeadline.year}',
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
                DataCell(
                  Text(
                    '${rfq.vendorsInvitedCount} Suppliers',
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                  ),
                ),
                DataCell(
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: rfq.responsesReceivedCount > 0
                          ? AppColors.success.withValues(alpha: 0.15)
                          : AppColors.warning.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '${rfq.responsesReceivedCount} / ${rfq.vendorsInvitedCount} Received',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: rfq.responsesReceivedCount > 0
                            ? AppColors.success
                            : AppColors.warning,
                      ),
                    ),
                  ),
                ),
                DataCell(
                  Text(
                    '₹${rfq.estimatedValue.toStringAsFixed(0)}',
                    style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12),
                  ),
                ),
                DataCell(ProcurementStatusBadge.vendorRfq(rfq.status)),
                DataCell(
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.visibility_outlined, size: 18),
                        tooltip: 'View RFQ Details',
                        onPressed: () => _openDetailModal(rfq),
                      ),
                      if (rfq.status == VendorRfqStatus.comparisonReady)
                        IconButton(
                          icon: const Icon(Icons.compare_arrows_rounded,
                              size: 18, color: AppColors.primary),
                          tooltip: 'Open Comparison Matrix',
                          onPressed: () {
                            if (widget.onNavigateToComparison != null) {
                              widget.onNavigateToComparison!(rfq.id);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Switched to Comparison Matrix for ${rfq.rfqNumber}!'),
                                ),
                              );
                            }
                          },
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
/// CREATE RFQ MODAL
/// ============================================================================
class _CreateRfqModal extends StatefulWidget {
  final ValueChanged<VendorRfq> onCreated;

  const _CreateRfqModal({required this.onCreated});

  @override
  State<_CreateRfqModal> createState() => _CreateRfqModalState();
}

class _CreateRfqModalState extends State<_CreateRfqModal> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleCtrl = TextEditingController(
      text: 'Marine Plywood Requisition & Soft-Close Hardware');
  final TextEditingController _contactCtrl =
      TextEditingController(text: 'Rajesh Verma (Site Engg)');
  final TextEditingController _contactPhoneCtrl =
      TextEditingController(text: '+91 98110 55201');
  final TextEditingController _instructionsCtrl = TextEditingController(
      text: 'Entry via Service Gate 3. Unloading operational 9 AM - 6 PM.');

  final DateTime _deadline = DateTime.now().add(const Duration(days: 4));
  final List<String> _selectedVendorIds = ['VND-001', 'VND-002', 'VND-003'];

  static const List<RfqVendorInvite> _availableVendors = [
    RfqVendorInvite(
      vendorId: 'VND-001',
      vendorName: 'Century Wholesale Hub',
      vendorCode: 'VND-CEN-01',
      category: 'Plywood & Boards',
      rating: 4.8,
      location: 'DLF Phase 2, Gurugram',
      contactPerson: 'Sunil Aggarwal',
      mobile: '+91 98101 33412',
      email: 'sales@centuryhub.in',
    ),
    RfqVendorInvite(
      vendorId: 'VND-002',
      vendorName: 'Austin Plywood Regional Depot',
      vendorCode: 'VND-AUS-02',
      category: 'Plywood & Boards',
      rating: 4.6,
      location: 'Kirti Nagar, Delhi',
      contactPerson: 'Ramesh Bansal',
      mobile: '+91 98112 44900',
      email: 'quotes@austindepot.com',
    ),
    RfqVendorInvite(
      vendorId: 'VND-003',
      vendorName: 'Greenply Metro Distributors',
      vendorCode: 'VND-GRN-03',
      category: 'Plywood & Laminates',
      rating: 4.7,
      location: 'Sohna Road, Gurugram',
      contactPerson: 'Deepak Chopra',
      mobile: '+91 99105 88210',
      email: 'procure@greenplymetro.in',
    ),
  ];

  @override
  void dispose() {
    _titleCtrl.dispose();
    _contactCtrl.dispose();
    _contactPhoneCtrl.dispose();
    _instructionsCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final selectedVendors = _availableVendors
        .where((v) => _selectedVendorIds.contains(v.vendorId))
        .toList();

    final newRfq = VendorRfq(
      id: 'rfq_${DateTime.now().millisecondsSinceEpoch}',
      rfqNumber: 'RFQ-2026-0008${6 + DateTime.now().second}',
      rfqTitle: _titleCtrl.text,
      rfqDate: DateTime.now(),
      responseDeadline: _deadline,
      materialRequestId: 'mr-001',
      materialRequestNumber: 'MR-2026-00124',
      projectId: 'PRJ-CAM-01',
      projectName: 'The Camellias Villa Interior #1402',
      customerName: 'Rahul Sharma',
      siteAddress: 'The Camellias, DLF Phase 5, Gurugram',
      vendors: selectedVendors,
      items: OperationsMockData.materialRequests.first.items,
      estimatedValue: 195450,
      siteContactPerson: _contactCtrl.text,
      siteContactNumber: _contactPhoneCtrl.text,
      siteAccessInstructions: _instructionsCtrl.text,
      status: VendorRfqStatus.sent,
    );
    widget.onCreated(newRfq);
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
                      child: const Icon(Icons.outgoing_mail,
                          color: AppColors.primary, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Create & Send Vendor RFQ',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w800,
                              )),
                          Text(
                            'Associate approved materials, select multiple vetted vendors, set commercial terms and dispatch.',
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

              // Body
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: _titleCtrl,
                        decoration: const InputDecoration(
                          labelText: 'RFQ Title *',
                          isDense: true,
                          border: OutlineInputBorder(),
                        ),
                        validator: (v) => v!.isEmpty ? 'Required' : null,
                      ),
                      const SizedBox(height: 14),

                      // Associated Material Request Badge
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                          ),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.link_rounded, size: 16, color: AppColors.primary),
                            SizedBox(width: 8),
                            Text(
                              'Linked Material Request: MR-2026-00124 (The Camellias #1402 • 2 Items)',
                              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Multi-Vendor Selector
                      Text(
                        'Select Vendors to Invite (${_selectedVendorIds.length} Selected)',
                        style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 8),

                      Column(
                        children: _availableVendors.map((vendor) {
                          final isSelected = _selectedVendorIds.contains(vendor.vendorId);
                          return CheckboxListTile(
                            value: isSelected,
                            dense: true,
                            contentPadding: EdgeInsets.zero,
                            title: Row(
                              children: [
                                Text(vendor.vendorName,
                                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                                const SizedBox(width: 8),
                                Text('(${vendor.rating} ★)',
                                    style: const TextStyle(color: AppColors.gold, fontSize: 11)),
                              ],
                            ),
                            subtitle: Text('${vendor.category} • ${vendor.location} • ${vendor.mobile}',
                                style: const TextStyle(fontSize: 11)),
                            onChanged: (val) {
                              setState(() {
                                if (val == true) {
                                  _selectedVendorIds.add(vendor.vendorId);
                                } else {
                                  if (_selectedVendorIds.length > 1) {
                                    _selectedVendorIds.remove(vendor.vendorId);
                                  }
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 20),

                      // Site Delivery Instructions
                      Text('Site Delivery & Access Instructions',
                          style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _contactCtrl,
                              decoration: const InputDecoration(
                                labelText: 'Site Contact Person',
                                isDense: true,
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              controller: _contactPhoneCtrl,
                              decoration: const InputDecoration(
                                labelText: 'Contact Phone Number',
                                isDense: true,
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _instructionsCtrl,
                        maxLines: 2,
                        decoration: const InputDecoration(
                          labelText: 'Gate & Unloading Instructions',
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
                      icon: const Icon(Icons.send_rounded, size: 16),
                      label: const Text('Dispatch RFQ to All Vendors'),
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

/// ============================================================================
/// RFQ DETAIL MODAL
/// ============================================================================
class _RfqDetailModal extends StatelessWidget {
  final VendorRfq rfq;
  final VoidCallback onProceedToComparison;

  const _RfqDetailModal({
    required this.rfq,
    required this.onProceedToComparison,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Container(
        width: 820,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(rfq.rfqNumber,
                              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
                          const SizedBox(width: 10),
                          ProcurementStatusBadge.vendorRfq(rfq.status),
                        ],
                      ),
                      Text(rfq.rfqTitle, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const Divider(height: 24),

            Text('Invited Vendors & Response Status',
                style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800)),
            const SizedBox(height: 10),

            ...rfq.vendors.map((v) {
              return ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  backgroundColor: AppColors.primary.withValues(alpha: 0.15),
                  child: Text(v.vendorName[0],
                      style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.primary)),
                ),
                title: Text(v.vendorName,
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                subtitle: Text('Contact: ${v.contactPerson} (${v.mobile}) • Rating: ${v.rating} ★',
                    style: const TextStyle(fontSize: 11)),
                trailing: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: v.status == 'Responded'
                        ? AppColors.success.withValues(alpha: 0.15)
                        : AppColors.warning.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    v.status,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: v.status == 'Responded' ? AppColors.success : AppColors.warning,
                    ),
                  ),
                ),
              );
            }),
            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Close'),
                ),
                const SizedBox(width: 12),
                FilledButton.icon(
                  onPressed: onProceedToComparison,
                  icon: const Icon(Icons.compare_arrows_rounded, size: 16),
                  label: const Text('Open Comparison Workspace'),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
