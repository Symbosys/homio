import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../models/operations_models.dart';
import '../models/operations_mock_data.dart';
import '../widgets/procurement_header.dart';
import '../widgets/procurement_kpi_card.dart';
import '../widgets/procurement_context_bar.dart';
import '../widgets/procurement_status_badge.dart';
import '../widgets/site_receipt_modal.dart';
import '../widgets/customer_operations_summary_modal.dart';

class MaterialDispatchPage extends StatefulWidget {
  const MaterialDispatchPage({super.key});

  @override
  State<MaterialDispatchPage> createState() => _MaterialDispatchPageState();
}

class _MaterialDispatchPageState extends State<MaterialDispatchPage> {
  late List<MaterialDispatch> _dispatches;
  String _searchQuery = '';
  MaterialDispatchStatus? _statusFilter;
  MaterialDispatch? _selectedDispatch;

  @override
  void initState() {
    super.initState();
    _dispatches = List.from(OperationsMockData.materialDispatches);
    if (_dispatches.isNotEmpty) {
      _selectedDispatch = _dispatches.first;
    }
  }

  List<MaterialDispatch> get _filteredDispatches {
    return _dispatches.where((d) {
      final matchesSearch = _searchQuery.isEmpty ||
          d.dispatchNumber.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          d.poNumber.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          d.vendorName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          d.vehicleNumber.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          d.lrNumber.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          d.projectName.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesStatus =
          _statusFilter == null || d.status == _statusFilter;
      return matchesSearch && matchesStatus;
    }).toList();
  }

  // KPIs
  int get _totalCount => _dispatches.length;
  int get _inTransitCount =>
      _dispatches.where((d) => d.status == MaterialDispatchStatus.inTransit).length;
  int get _deliveredCount =>
      _dispatches.where((d) => d.status == MaterialDispatchStatus.delivered).length;
  int get _partiallyReceivedCount =>
      _dispatches.where((d) => d.status == MaterialDispatchStatus.partiallyReceived).length;

  void _openCreateDispatchModal() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => _CreateDispatchModal(
        onCreated: (newDispatch) {
          setState(() {
            _dispatches.insert(0, newDispatch);
            _selectedDispatch = newDispatch;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Shipment ${newDispatch.dispatchNumber} created with LR ${newDispatch.lrNumber}!'),
              backgroundColor: AppColors.success,
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
      ),
    );
  }

  void _openInspectionModal(MaterialDispatch dispatch) {
    showDialog(
      context: context,
      builder: (ctx) => SiteReceiptModal(
        dispatch: dispatch,
        onSaveReceipt: (checklist) {
          setState(() {
            final idx = _dispatches.indexWhere((d) => d.id == dispatch.id);
            if (idx != -1) {
              final hasDamagedOrShort = checklist.any((item) =>
                  item.condition == MaterialItemCondition.damaged ||
                  item.condition == MaterialItemCondition.short ||
                  item.condition == MaterialItemCondition.rejected);

              _dispatches[idx] = MaterialDispatch(
                id: dispatch.id,
                dispatchNumber: dispatch.dispatchNumber,
                poId: dispatch.poId,
                poNumber: dispatch.poNumber,
                vendorName: dispatch.vendorName,
                projectId: dispatch.projectId,
                projectName: dispatch.projectName,
                customerName: dispatch.customerName,
                siteAddress: dispatch.siteAddress,
                dispatchDate: dispatch.dispatchDate,
                expectedArrival: dispatch.expectedArrival,
                actualArrival: DateTime.now(),
                destination: dispatch.destination,
                dispatchOwner: dispatch.dispatchOwner,
                transporterName: dispatch.transporterName,
                transporterContact: dispatch.transporterContact,
                vehicleNumber: dispatch.vehicleNumber,
                driverName: dispatch.driverName,
                driverContact: dispatch.driverContact,
                lrNumber: dispatch.lrNumber,
                trackingNumber: dispatch.trackingNumber,
                eWayBillNumber: dispatch.eWayBillNumber,
                items: dispatch.items,
                receiptChecklist: checklist,
                siteSupervisorSignature: 'Rajesh Verma (Verified QA Seal)',
                status: hasDamagedOrShort
                    ? MaterialDispatchStatus.partiallyReceived
                    : MaterialDispatchStatus.received,
                timeline: [
                  ...dispatch.timeline,
                  ProcurementTimelineEvent(
                    id: 'tl_${DateTime.now().millisecondsSinceEpoch}',
                    timestamp: DateTime.now(),
                    title: 'Site Delivery Inspection Completed',
                    description: hasDamagedOrShort
                        ? 'Material inspected: Shortage/damage noted in QA checklist.'
                        : 'All items verified and accepted in good condition.',
                    actorName: 'Rajesh Verma',
                    actorRole: 'Site Supervisor',
                    icon: Icons.fact_check_rounded,
                  ),
                ],
              );
              _selectedDispatch = _dispatches[idx];
            }
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Site receipt & QA inspection records saved!'),
              backgroundColor: AppColors.success,
            ),
          );
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
            title: 'Material Dispatch & Site Receipt',
            subtitle:
                'Track physical movement of approved materials to project sites, inspect delivery condition, and log QA sign-offs.',
            icon: Icons.local_shipping_outlined,
            primaryActionLabel: 'Create Dispatch Shipment',
            primaryActionIcon: Icons.add_road_rounded,
            onPrimaryAction: _openCreateDispatchModal,
            onRefresh: () => setState(() {}),
          ),

          // 2. Global Context Bar
          if (_selectedDispatch != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 14, 24, 0),
              child: ProcurementContextBar(
                projectName: _selectedDispatch!.projectName,
                siteAddress: _selectedDispatch!.siteAddress,
                clientName: _selectedDispatch!.customerName,
                projectManager: 'Amit Kumar',
                projectStatus: 'Active Site Delivery & Logistics',
                procurementStatus: 'Vehicle ${_selectedDispatch!.vehicleNumber} (${_selectedDispatch!.status.label})',
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
                            title: 'Total Dispatches',
                            value: '$_totalCount',
                            subtitle: 'Shipments tracked',
                            icon: Icons.local_shipping_outlined,
                            color: AppColors.primary,
                            isSelected: _statusFilter == null,
                            onTap: () => setState(() => _statusFilter = null),
                          ),
                          ProcurementKpiCard(
                            title: 'In Transit',
                            value: '$_inTransitCount',
                            subtitle: 'Active GPS tracking',
                            icon: Icons.moving_rounded,
                            color: AppColors.warning,
                            isSelected: _statusFilter == MaterialDispatchStatus.inTransit,
                            onTap: () => setState(
                                () => _statusFilter = MaterialDispatchStatus.inTransit),
                          ),
                          ProcurementKpiCard(
                            title: 'Site Delivery Verified',
                            value: '$_deliveredCount',
                            subtitle: 'Arrived at project site',
                            icon: Icons.place_rounded,
                            color: AppColors.success,
                            isSelected: _statusFilter == MaterialDispatchStatus.delivered,
                            onTap: () => setState(
                                () => _statusFilter = MaterialDispatchStatus.delivered),
                          ),
                          ProcurementKpiCard(
                            title: 'Inspection / Snags',
                            value: '$_partiallyReceivedCount',
                            subtitle: 'Shortage / damage recorded',
                            icon: Icons.report_problem_outlined,
                            color: const Color(0xFFF97316),
                            isSelected: _statusFilter == MaterialDispatchStatus.partiallyReceived,
                            onTap: () => setState(
                                () => _statusFilter = MaterialDispatchStatus.partiallyReceived),
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
                            hintText: 'Search dispatch ID, PO, vehicle number, LR, or vendor...',
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

                  // Dispatch Data Table
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
    if (_filteredDispatches.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 48),
          child: Column(
            children: [
              Icon(Icons.local_shipping_outlined,
                  size: 48,
                  color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted),
              const SizedBox(height: 12),
              Text('No Material Dispatches Found',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: _openCreateDispatchModal,
                icon: const Icon(Icons.add_rounded, size: 16),
                label: const Text('Create Dispatch Shipment'),
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
            DataColumn(label: Text('DISPATCH ID', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11))),
            DataColumn(label: Text('PO & VENDOR', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11))),
            DataColumn(label: Text('PROJECT & SITE', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11))),
            DataColumn(label: Text('VEHICLE & LR', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11))),
            DataColumn(label: Text('DISPATCH DATE', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11))),
            DataColumn(label: Text('EXPECTED ARRIVAL', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11))),
            DataColumn(label: Text('ITEMS / QTY', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11))),
            DataColumn(label: Text('STATUS', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11))),
            DataColumn(label: Text('ACTIONS', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11))),
          ],
          rows: _filteredDispatches.map((d) {
            final isSelected = d.id == _selectedDispatch?.id;
            return DataRow(
              selected: isSelected,
              onSelectChanged: (_) => setState(() => _selectedDispatch = d),
              cells: [
                DataCell(
                  Text(
                    d.dispatchNumber,
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
                      Text(d.poNumber,
                          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                      Text(d.vendorName,
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
                      Text(d.projectName,
                          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                      Text(d.destination,
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
                      Text(d.vehicleNumber,
                          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                      Text('LR: ${d.lrNumber}',
                          style: TextStyle(
                            fontSize: 10,
                            color: isDark ? AppColors.darkSubtext : AppColors.lightTextSecondary,
                          )),
                    ],
                  ),
                ),
                DataCell(Text('${d.dispatchDate.day}/${d.dispatchDate.month}/${d.dispatchDate.year}',
                    style: const TextStyle(fontSize: 12))),
                DataCell(
                  Text(
                    '${d.expectedArrival.day}/${d.expectedArrival.month} (${d.expectedArrival.hour}:00)',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ),
                DataCell(
                  Text(
                    '${d.totalItemsCount} Items (${d.totalQuantity.toStringAsFixed(0)})',
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                  ),
                ),
                DataCell(ProcurementStatusBadge.dispatch(d.status)),
                DataCell(
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.fact_check_outlined, size: 18),
                        tooltip: 'Site Delivery & QA Inspection',
                        onPressed: () => _openInspectionModal(d),
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
/// CREATE DISPATCH MODAL
/// ============================================================================
class _CreateDispatchModal extends StatefulWidget {
  final ValueChanged<MaterialDispatch> onCreated;

  const _CreateDispatchModal({required this.onCreated});

  @override
  State<_CreateDispatchModal> createState() => _CreateDispatchModalState();
}

class _CreateDispatchModalState extends State<_CreateDispatchModal> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _vehicleCtrl =
      TextEditingController(text: 'HR 26 DQ 8812');
  final TextEditingController _driverNameCtrl =
      TextEditingController(text: 'Mohinder Singh');
  final TextEditingController _driverPhoneCtrl =
      TextEditingController(text: '+91 99102 77102');
  final TextEditingController _lrCtrl =
      TextEditingController(text: 'VRL-GGN-2026-9921');
  final TextEditingController _ewayCtrl =
      TextEditingController(text: '2810 9920 4410');
  final TextEditingController _transporterCtrl =
      TextEditingController(text: 'VRL Logistics Dedicated Carrier');

  final DateTime _expectedArrival = DateTime.now().add(const Duration(days: 1));

  @override
  void dispose() {
    _vehicleCtrl.dispose();
    _driverNameCtrl.dispose();
    _driverPhoneCtrl.dispose();
    _lrCtrl.dispose();
    _ewayCtrl.dispose();
    _transporterCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final newDispatch = MaterialDispatch(
      id: 'dsp_${DateTime.now().millisecondsSinceEpoch}',
      dispatchNumber: 'DSP-2026-0009${3 + DateTime.now().second}',
      poId: 'po-001',
      poNumber: 'PO-2026-00142',
      vendorName: 'Century Wholesale Hub',
      projectId: 'PRJ-CAM-01',
      projectName: 'The Camellias Villa Interior #1402',
      customerName: 'Rahul Sharma',
      siteAddress: 'The Camellias, DLF Phase 5, Gurugram',
      dispatchDate: DateTime.now(),
      expectedArrival: _expectedArrival,
      destination: 'The Camellias Basement Staging Bay',
      transporterName: _transporterCtrl.text,
      transporterContact: '+91 98112 00192',
      vehicleNumber: _vehicleCtrl.text,
      driverName: _driverNameCtrl.text,
      driverContact: _driverPhoneCtrl.text,
      lrNumber: _lrCtrl.text,
      trackingNumber: 'GPS-LIVE-${DateTime.now().millisecondsSinceEpoch}',
      eWayBillNumber: _ewayCtrl.text,
      items: const [
        DispatchItem(
          itemName: 'Century Club Prime BWP Marine Plywood 19mm',
          poQuantity: 45,
          currentDispatchQuantity: 45,
          unit: 'Sheets (8x4)',
          batchLot: 'LOT-CEN-01',
        ),
      ],
      status: MaterialDispatchStatus.inTransit,
    );
    widget.onCreated(newDispatch);
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
        width: 760,
        constraints: const BoxConstraints(maxHeight: 700),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
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
                      child: const Icon(Icons.local_shipping_outlined,
                          color: AppColors.primary, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Create Material Dispatch Shipment',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w800,
                              )),
                          Text(
                            'Assign carrier, LR & E-Way bill for PO-2026-00142 (Century Wholesale Hub)',
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

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _transporterCtrl,
                              decoration: const InputDecoration(
                                labelText: 'Transporter Name *',
                                isDense: true,
                                border: OutlineInputBorder(),
                              ),
                              validator: (v) => v!.isEmpty ? 'Required' : null,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              controller: _vehicleCtrl,
                              decoration: const InputDecoration(
                                labelText: 'Vehicle Registration # *',
                                isDense: true,
                                border: OutlineInputBorder(),
                              ),
                              validator: (v) => v!.isEmpty ? 'Required' : null,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _driverNameCtrl,
                              decoration: const InputDecoration(
                                labelText: 'Driver Name',
                                isDense: true,
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              controller: _driverPhoneCtrl,
                              decoration: const InputDecoration(
                                labelText: 'Driver Mobile Number',
                                isDense: true,
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _lrCtrl,
                              decoration: const InputDecoration(
                                labelText: 'Lorry Receipt (LR) # *',
                                isDense: true,
                                border: OutlineInputBorder(),
                              ),
                              validator: (v) => v!.isEmpty ? 'Required' : null,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              controller: _ewayCtrl,
                              decoration: const InputDecoration(
                                labelText: 'E-Way Bill Number *',
                                isDense: true,
                                border: OutlineInputBorder(),
                              ),
                              validator: (v) => v!.isEmpty ? 'Required' : null,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

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
                      label: const Text('Confirm Dispatch & Generate Waybill'),
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
