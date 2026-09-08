import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../models/operations_models.dart';
import '../models/operations_mock_data.dart';
import '../widgets/procurement_header.dart';
import '../widgets/procurement_kpi_card.dart';
import '../widgets/procurement_context_bar.dart';
import '../widgets/procurement_status_badge.dart';
import '../widgets/material_line_item_builder.dart';
import '../widgets/customer_operations_summary_modal.dart';

class MaterialRequestsPage extends StatefulWidget {
  const MaterialRequestsPage({super.key});

  @override
  State<MaterialRequestsPage> createState() => _MaterialRequestsPageState();
}

class _MaterialRequestsPageState extends State<MaterialRequestsPage> {
  late List<MaterialRequest> _requests;
  String _searchQuery = '';
  MaterialRequestStatus? _statusFilter;
  RequestPriority? _priorityFilter;
  MaterialRequest? _selectedRequest;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _requests = List.from(OperationsMockData.materialRequests);
    if (_requests.isNotEmpty) {
      _selectedRequest = _requests.first;
    }
  }

  List<MaterialRequest> get _filteredRequests {
    return _requests.where((r) {
      final matchesSearch = _searchQuery.isEmpty ||
          r.requestNumber.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          r.projectName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          r.customerName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          r.requestedBy.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesStatus =
          _statusFilter == null || r.status == _statusFilter;
      final matchesPriority =
          _priorityFilter == null || r.priority == _priorityFilter;
      return matchesSearch && matchesStatus && matchesPriority;
    }).toList();
  }

  // KPI Computations
  int get _totalCount => _requests.length;
  int get _draftCount =>
      _requests.where((r) => r.status == MaterialRequestStatus.draft).length;
  int get _pendingApprovalCount => _requests
      .where((r) =>
          r.status == MaterialRequestStatus.submitted ||
          r.status == MaterialRequestStatus.underReview)
      .length;
  int get _approvedCount => _requests
      .where((r) =>
          r.status == MaterialRequestStatus.approved ||
          r.status == MaterialRequestStatus.partiallyApproved)
      .length;
  int get _inProcurementCount => _requests
      .where((r) => r.status == MaterialRequestStatus.inProcurement)
      .length;
  int get _partiallyFulfilledCount => _requests
      .where((r) => r.status == MaterialRequestStatus.partiallyFulfilled)
      .length;
  int get _fulfilledCount => _requests
      .where((r) => r.status == MaterialRequestStatus.fulfilled)
      .length;

  double get _totalRequestedValue =>
      _requests.fold(0.0, (sum, r) => sum + r.estimatedTotal);
  double get _totalApprovedValue =>
      _requests.fold(0.0, (sum, r) => sum + r.approvedAmount);
  double get _totalPendingValue =>
      _totalRequestedValue - _totalApprovedValue;

  void _openCreateModal() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => _CreateMaterialRequestModal(
        onCreated: (newReq) {
          setState(() {
            _requests.insert(0, newReq);
            _selectedRequest = newReq;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Material Request ${newReq.requestNumber} created successfully!'),
              backgroundColor: AppColors.success,
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
      ),
    );
  }

  void _openDetailModal(MaterialRequest request) {
    showDialog(
      context: context,
      builder: (ctx) => _MaterialRequestDetailModal(
        request: request,
        onApprove: () {
          setState(() {
            final idx = _requests.indexWhere((r) => r.id == request.id);
            if (idx != -1) {
              final updated = MaterialRequest(
                id: request.id,
                requestNumber: request.requestNumber,
                requestDate: request.requestDate,
                requestType: request.requestType,
                department: request.department,
                requestedBy: request.requestedBy,
                projectId: request.projectId,
                projectName: request.projectName,
                customerId: request.customerId,
                customerName: request.customerName,
                siteAddress: request.siteAddress,
                floor: request.floor,
                roomArea: request.roomArea,
                costCentre: request.costCentre,
                projectBudgetCategory: request.projectBudgetCategory,
                requiredByDate: request.requiredByDate,
                requiredByTime: request.requiredByTime,
                priority: request.priority,
                requestReason: request.requestReason,
                businessJustification: request.businessJustification,
                internalNotes: request.internalNotes,
                items: request.items,
                estimatedMaterialCost: request.estimatedMaterialCost,
                otherCharges: request.otherCharges,
                estimatedTotal: request.estimatedTotal,
                approvedAmount: request.estimatedTotal,
                budgetAvailable: request.budgetAvailable,
                status: MaterialRequestStatus.approved,
                procurementOwner: request.procurementOwner,
                lastUpdated: DateTime.now(),
                timeline: [
                  ...request.timeline,
                  ProcurementTimelineEvent(
                    id: 'tl_${DateTime.now().millisecondsSinceEpoch}',
                    timestamp: DateTime.now(),
                    title: 'Material Request Approved',
                    description: 'Approved by Project Manager Amit Kumar',
                    actorName: 'Amit Kumar',
                    actorRole: 'Project Manager',
                    icon: Icons.verified_rounded,
                  ),
                ],
                documents: request.documents,
              );
              _requests[idx] = updated;
              _selectedRequest = updated;
            }
          });
          Navigator.of(ctx).pop();
        },
      ),
    );
  }

  void _openCustomerSummary(MaterialRequest request) {
    final summary = OperationsMockData.customerSummaries.firstWhere(
      (s) => s.customerId == request.customerId,
      orElse: () => OperationsMockData.customerSummaries.first,
    );
    showDialog(
      context: context,
      builder: (_) => CustomerOperationsSummaryModal(summary: summary),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      key: _scaffoldKey,
      endDrawer: _buildFilterDrawer(isDark, theme),
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: Column(
        children: [
          // 1. Page Header
          ProcurementPageHeader(
            title: 'Material Requests',
            subtitle:
                'Manage project material requirements, multi-tier approvals and downstream procurement progress.',
            icon: Icons.inventory_2_outlined,
            primaryActionLabel: 'Create Material Request',
            primaryActionIcon: Icons.add_rounded,
            onPrimaryAction: _openCreateModal,
            onRefresh: () => setState(() {}),
            secondaryAction: OutlinedButton.icon(
              onPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
              icon: const Icon(Icons.filter_list_rounded, size: 16),
              label: Text(
                _statusFilter != null || _priorityFilter != null
                    ? 'Filters (Active)'
                    : 'Filters',
                style: const TextStyle(fontSize: 12),
              ),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ),
          ),

          // 2. Global Context Bar
          if (_selectedRequest != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 14, 24, 0),
              child: ProcurementContextBar(
                projectName: _selectedRequest!.projectName,
                siteAddress: _selectedRequest!.siteAddress,
                clientName: _selectedRequest!.customerName,
                projectManager: 'Amit Kumar',
                projectStatus: 'Execution Phase (Milestone 3)',
                procurementStatus: '${_requests.length} Project Requirements',
                onViewCustomerSummary: () => _openCustomerSummary(_selectedRequest!),
              ),
            ),

          // 3. Scrollable Dashboard Body
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // KPI Section (8 Cards + Value Metrics)
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final cols = constraints.maxWidth > 1100
                          ? 4
                          : (constraints.maxWidth > 650 ? 2 : 1);
                      return GridView.count(
                        crossAxisCount: cols,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisSpacing: 14,
                        mainAxisSpacing: 14,
                        childAspectRatio: 2.2,
                        children: [
                          ProcurementKpiCard(
                            title: 'Total Requests',
                            value: '$_totalCount',
                            subtitle: 'Value: ₹${_totalRequestedValue.toStringAsFixed(0)}',
                            icon: Icons.inventory_2_outlined,
                            color: AppColors.primary,
                            isSelected: _statusFilter == null,
                            onTap: () => setState(() => _statusFilter = null),
                          ),
                          ProcurementKpiCard(
                            title: 'Draft Requests',
                            value: '$_draftCount',
                            subtitle: 'Unsubmitted draft specs',
                            icon: Icons.edit_note_rounded,
                            color: const Color(0xFF64748B),
                            isSelected: _statusFilter == MaterialRequestStatus.draft,
                            onTap: () => setState(
                                () => _statusFilter = MaterialRequestStatus.draft),
                          ),
                          ProcurementKpiCard(
                            title: 'Pending Approval',
                            value: '$_pendingApprovalCount',
                            subtitle: 'Requires PM / Ops sign-off',
                            icon: Icons.hourglass_top_rounded,
                            color: AppColors.warning,
                            isSelected: _statusFilter == MaterialRequestStatus.underReview ||
                                _statusFilter == MaterialRequestStatus.submitted,
                            onTap: () => setState(
                                () => _statusFilter = MaterialRequestStatus.submitted),
                          ),
                          ProcurementKpiCard(
                            title: 'Approved for RFQ',
                            value: '$_approvedCount',
                            subtitle: 'Value: ₹${_totalApprovedValue.toStringAsFixed(0)}',
                            icon: Icons.check_circle_outline_rounded,
                            color: AppColors.success,
                            isSelected: _statusFilter == MaterialRequestStatus.approved,
                            onTap: () => setState(
                                () => _statusFilter = MaterialRequestStatus.approved),
                          ),
                          ProcurementKpiCard(
                            title: 'In Procurement',
                            value: '$_inProcurementCount',
                            subtitle: 'Active RFQs & POs open',
                            icon: Icons.shopping_bag_outlined,
                            color: const Color(0xFF8B5CF6),
                            isSelected: _statusFilter == MaterialRequestStatus.inProcurement,
                            onTap: () => setState(
                                () => _statusFilter = MaterialRequestStatus.inProcurement),
                          ),
                          ProcurementKpiCard(
                            title: 'Partially Received',
                            value: '$_partiallyFulfilledCount',
                            subtitle: 'Partial dispatch delivered',
                            icon: Icons.incomplete_circle_rounded,
                            color: AppColors.accent,
                            isSelected: _statusFilter == MaterialRequestStatus.partiallyFulfilled,
                            onTap: () => setState(
                                () => _statusFilter = MaterialRequestStatus.partiallyFulfilled),
                          ),
                          ProcurementKpiCard(
                            title: 'Fully Fulfilled',
                            value: '$_fulfilledCount',
                            subtitle: '100% materials delivered',
                            icon: Icons.done_all_rounded,
                            color: const Color(0xFF059669),
                            isSelected: _statusFilter == MaterialRequestStatus.fulfilled,
                            onTap: () => setState(
                                () => _statusFilter = MaterialRequestStatus.fulfilled),
                          ),
                          ProcurementKpiCard(
                            title: 'Pending Budget Value',
                            value: '₹${_totalPendingValue.toStringAsFixed(0)}',
                            subtitle: 'Under review for sign-off',
                            icon: Icons.account_balance_wallet_outlined,
                            color: const Color(0xFFD97706),
                            isSelected: false,
                            onTap: () {},
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 24),

                  // Search & Filter Toolbar
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText:
                                'Search request ID, project name, customer, or supervisor...',
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
                      if (_statusFilter != null || _priorityFilter != null)
                        TextButton.icon(
                          onPressed: () {
                            setState(() {
                              _statusFilter = null;
                              _priorityFilter = null;
                            });
                          },
                          icon: const Icon(Icons.clear_all_rounded, size: 16),
                          label: const Text('Reset Filters'),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Data Table
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
    if (_filteredRequests.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 48),
          child: Column(
            children: [
              Icon(Icons.inventory_2_outlined,
                  size: 48,
                  color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted),
              const SizedBox(height: 12),
              Text(
                'No Material Requests Found',
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 4),
              Text(
                'No material requirements match the active search or filters.',
                style: TextStyle(
                  color: isDark ? AppColors.darkSubtext : AppColors.lightTextSecondary,
                ),
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: _openCreateModal,
                icon: const Icon(Icons.add_rounded, size: 16),
                label: const Text('Create Material Request'),
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
            DataColumn(label: Text('REQUEST ID', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11))),
            DataColumn(label: Text('PROJECT & CLIENT', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11))),
            DataColumn(label: Text('REQUESTED BY', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11))),
            DataColumn(label: Text('REQUIRED BY', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11))),
            DataColumn(label: Text('PRIORITY', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11))),
            DataColumn(label: Text('ITEMS', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11))),
            DataColumn(label: Text('EST. AMOUNT', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11))),
            DataColumn(label: Text('STATUS', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11))),
            DataColumn(label: Text('ACTIONS', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11))),
          ],
          rows: _filteredRequests.map((req) {
            final isSelected = req.id == _selectedRequest?.id;
            return DataRow(
              selected: isSelected,
              onSelectChanged: (_) {
                setState(() => _selectedRequest = req);
              },
              cells: [
                DataCell(
                  Text(
                    req.requestNumber,
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
                      Text(req.projectName,
                          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                      Text('Client: ${req.customerName} • ${req.roomArea}',
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
                      Text(req.requestedBy, style: const TextStyle(fontSize: 12)),
                      Text(req.department,
                          style: TextStyle(
                            fontSize: 10,
                            color: isDark ? AppColors.darkSubtext : AppColors.lightTextSecondary,
                          )),
                    ],
                  ),
                ),
                DataCell(
                  Text(
                    '${req.requiredByDate.day}/${req.requiredByDate.month}/${req.requiredByDate.year}',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ),
                DataCell(ProcurementStatusBadge.priority(req.priority)),
                DataCell(
                  Text(
                    '${req.items.length} Materials',
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                  ),
                ),
                DataCell(
                  Text(
                    '₹${req.estimatedTotal.toStringAsFixed(0)}',
                    style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12),
                  ),
                ),
                DataCell(ProcurementStatusBadge.materialRequest(req.status)),
                DataCell(
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.visibility_outlined, size: 18),
                        tooltip: 'View 12-Tab Details & Downstream RFQ/PO',
                        onPressed: () => _openDetailModal(req),
                      ),
                      if (req.status == MaterialRequestStatus.submitted ||
                          req.status == MaterialRequestStatus.underReview)
                        IconButton(
                          icon: const Icon(Icons.check_circle_outline,
                              size: 18, color: AppColors.success),
                          tooltip: 'Quick Approve',
                          onPressed: () {
                            setState(() {
                              final idx = _requests.indexOf(req);
                              if (idx != -1) {
                                _requests[idx] = MaterialRequest(
                                  id: req.id,
                                  requestNumber: req.requestNumber,
                                  requestDate: req.requestDate,
                                  requestedBy: req.requestedBy,
                                  projectId: req.projectId,
                                  projectName: req.projectName,
                                  customerId: req.customerId,
                                  customerName: req.customerName,
                                  siteAddress: req.siteAddress,
                                  requiredByDate: req.requiredByDate,
                                  items: req.items,
                                  estimatedMaterialCost: req.estimatedMaterialCost,
                                  estimatedTotal: req.estimatedTotal,
                                  approvedAmount: req.estimatedTotal,
                                  budgetAvailable: req.budgetAvailable,
                                  status: MaterialRequestStatus.approved,
                                  lastUpdated: DateTime.now(),
                                );
                              }
                            });
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

  Widget _buildFilterDrawer(bool isDark, ThemeData theme) {
    return Drawer(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Filter Material Requests',
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const Divider(),
              const SizedBox(height: 10),
              Text('Approval & Procurement Status',
                  style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: MaterialRequestStatus.values.map((s) {
                  final isSelected = _statusFilter == s;
                  return ChoiceChip(
                    label: Text(s.label, style: const TextStyle(fontSize: 11)),
                    selected: isSelected,
                    onSelected: (val) {
                      setState(() => _statusFilter = val ? s : null);
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              Text('Priority Level',
                  style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: RequestPriority.values.map((p) {
                  final isSelected = _priorityFilter == p;
                  return ChoiceChip(
                    label: Text(p.label, style: const TextStyle(fontSize: 11)),
                    selected: isSelected,
                    onSelected: (val) {
                      setState(() => _priorityFilter = val ? p : null);
                    },
                  );
                }).toList(),
              ),
              const Spacer(),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          _statusFilter = null;
                          _priorityFilter = null;
                        });
                        Navigator.of(context).pop();
                      },
                      child: const Text('Clear All'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Apply Filter'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// ============================================================================
/// CREATE MATERIAL REQUEST MODAL (Multi-Section Form + Line Item Builder)
/// ============================================================================
class _CreateMaterialRequestModal extends StatefulWidget {
  final ValueChanged<MaterialRequest> onCreated;

  const _CreateMaterialRequestModal({required this.onCreated});

  @override
  State<_CreateMaterialRequestModal> createState() =>
      _CreateMaterialRequestModalState();
}

class _CreateMaterialRequestModalState
    extends State<_CreateMaterialRequestModal> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _projectNameCtrl =
      TextEditingController(text: 'The Camellias Villa Interior #1402');
  final TextEditingController _clientNameCtrl =
      TextEditingController(text: 'Rahul Sharma');
  final TextEditingController _siteAddressCtrl =
      TextEditingController(text: 'The Camellias, DLF Phase 5, Gurugram');
  final TextEditingController _requestedByCtrl =
      TextEditingController(text: 'Rajesh Verma (Site Supervisor)');
  final TextEditingController _departmentCtrl =
      TextEditingController(text: 'Modular Carpentry & Woodwork');
  final TextEditingController _reasonCtrl =
      TextEditingController(text: 'Execution requirement as per drawing DWG-CAM-102');

  RequestType _requestType = RequestType.projectMaterial;
  RequestPriority _priority = RequestPriority.high;
  final DateTime _requiredByDate = DateTime.now().add(const Duration(days: 7));
  final double _budgetAvailable = 250000;
  List<MaterialRequestItem> _items = [
    MaterialRequestItem(
      id: 'item_1',
      itemName: 'Century Club Prime BWP Marine Plywood 19mm',
      itemCode: 'MAT-PLY-710',
      category: 'Wood & Boards',
      specification: const MaterialSpecification(
        materialType: 'BWP Plywood',
        grade: '710 IS:710 Marine',
        thickness: '19mm',
      ),
      dimensions: const DimensionInput(length: 8, width: 4, unit: 'ft'),
      quantity: 30,
      unit: 'Sheets (8x4)',
      estimatedRate: 2850,
      estimatedAmount: 85500,
      requiredDate: DateTime.now().add(const Duration(days: 7)),
    ),
  ];

  double get _estimatedTotal =>
      _items.fold<double>(0.0, (sum, i) => sum + i.estimatedAmount);
  double get _remainingBudget => _budgetAvailable - _estimatedTotal;

  @override
  void dispose() {
    _projectNameCtrl.dispose();
    _clientNameCtrl.dispose();
    _siteAddressCtrl.dispose();
    _requestedByCtrl.dispose();
    _departmentCtrl.dispose();
    _reasonCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final newReq = MaterialRequest(
      id: 'mr_${DateTime.now().millisecondsSinceEpoch}',
      requestNumber: 'MR-2026-00${128 + DateTime.now().second}',
      requestDate: DateTime.now(),
      requestType: _requestType,
      department: _departmentCtrl.text,
      requestedBy: _requestedByCtrl.text,
      projectId: 'PRJ-CAM-01',
      projectName: _projectNameCtrl.text,
      customerId: 'CUST-RS-01',
      customerName: _clientNameCtrl.text,
      siteAddress: _siteAddressCtrl.text,
      requiredByDate: _requiredByDate,
      priority: _priority,
      requestReason: _reasonCtrl.text,
      items: _items,
      estimatedMaterialCost: _estimatedTotal,
      estimatedTotal: _estimatedTotal,
      approvedAmount: 0,
      budgetAvailable: _budgetAvailable,
      status: MaterialRequestStatus.submitted,
      lastUpdated: DateTime.now(),
      timeline: [
        ProcurementTimelineEvent(
          id: 'tl_${DateTime.now().millisecondsSinceEpoch}',
          timestamp: DateTime.now(),
          title: 'Material Request Created',
          description: 'Created by ${_requestedByCtrl.text}',
          actorName: _requestedByCtrl.text,
          actorRole: 'Site Supervisor',
        ),
      ],
    );
    widget.onCreated(newReq);
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
        width: 880,
        constraints: const BoxConstraints(maxHeight: 780),
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
                      child: const Icon(Icons.add_shopping_cart_rounded,
                          color: AppColors.primary, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Create Material Request',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w800,
                              )),
                          Text(
                            'Enter project site requirement, material dimensions, specifications and budget allocation.',
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
                      // Section A: Project & Client
                      Text('SECTION A — PROJECT & SITE DETAILS',
                          style: theme.textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                            color: AppColors.primary,
                          )),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _projectNameCtrl,
                              decoration: const InputDecoration(
                                labelText: 'Project Name *',
                                isDense: true,
                                border: OutlineInputBorder(),
                              ),
                              validator: (v) => v!.isEmpty ? 'Required' : null,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              controller: _clientNameCtrl,
                              decoration: const InputDecoration(
                                labelText: 'Customer / Client *',
                                isDense: true,
                                border: OutlineInputBorder(),
                              ),
                              validator: (v) => v!.isEmpty ? 'Required' : null,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: TextFormField(
                              controller: _siteAddressCtrl,
                              decoration: const InputDecoration(
                                labelText: 'Site Delivery Address *',
                                isDense: true,
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              controller: _requestedByCtrl,
                              decoration: const InputDecoration(
                                labelText: 'Requested By *',
                                isDense: true,
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Section B: Request Configuration
                      Text('SECTION B — REQUEST TYPE & PRIORITY',
                          style: theme.textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                            color: AppColors.primary,
                          )),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<RequestType>(
                              initialValue: _requestType,
                              decoration: const InputDecoration(
                                labelText: 'Request Type',
                                isDense: true,
                                border: OutlineInputBorder(),
                              ),
                              items: RequestType.values.map((t) {
                                return DropdownMenuItem(value: t, child: Text(t.label));
                              }).toList(),
                              onChanged: (val) => setState(() => _requestType = val!),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: DropdownButtonFormField<RequestPriority>(
                              initialValue: _priority,
                              decoration: const InputDecoration(
                                labelText: 'Priority',
                                isDense: true,
                                border: OutlineInputBorder(),
                              ),
                              items: RequestPriority.values.map((p) {
                                return DropdownMenuItem(value: p, child: Text(p.label));
                              }).toList(),
                              onChanged: (val) => setState(() => _priority = val!),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              controller: _reasonCtrl,
                              decoration: const InputDecoration(
                                labelText: 'Request Reason / Justification',
                                isDense: true,
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Section C: Line Item Builder
                      MaterialLineItemBuilder(
                        initialItems: _items,
                        onChanged: (updated) => setState(() => _items = updated),
                      ),
                      const SizedBox(height: 20),

                      // Sticky Budget Check Summary
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: _remainingBudget >= 0 ? AppColors.success : AppColors.error,
                            width: 1.2,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'BUDGET ALLOCATION HEALTH',
                                  style: TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w800,
                                    color: _remainingBudget >= 0 ? AppColors.success : AppColors.error,
                                  ),
                                ),
                                Text(
                                  _remainingBudget >= 0
                                      ? '✓ Within Allocated Budget'
                                      : '⚠️ Near/Over Budget Limit',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w800,
                                    color: _remainingBudget >= 0 ? AppColors.success : AppColors.error,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                _buildSummaryMetric(
                                  'Estimated Cost',
                                  '₹${_estimatedTotal.toStringAsFixed(0)}',
                                  AppColors.primary,
                                ),
                                const SizedBox(width: 24),
                                _buildSummaryMetric(
                                  'Available Budget',
                                  '₹${_budgetAvailable.toStringAsFixed(0)}',
                                  isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                                ),
                                const SizedBox(width: 24),
                                _buildSummaryMetric(
                                  'Remaining Post-Request',
                                  '₹${_remainingBudget.toStringAsFixed(0)}',
                                  _remainingBudget >= 0 ? AppColors.success : AppColors.error,
                                ),
                              ],
                            ),
                          ],
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
                      label: const Text('Submit Material Request'),
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

  Widget _buildSummaryMetric(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600)),
        Text(value,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: color)),
      ],
    );
  }
}

/// ============================================================================
/// 12-TAB MATERIAL REQUEST DETAIL MODAL
/// ============================================================================
class _MaterialRequestDetailModal extends StatefulWidget {
  final MaterialRequest request;
  final VoidCallback onApprove;

  const _MaterialRequestDetailModal({
    required this.request,
    required this.onApprove,
  });

  @override
  State<_MaterialRequestDetailModal> createState() =>
      _MaterialRequestDetailModalState();
}

class _MaterialRequestDetailModalState
    extends State<_MaterialRequestDetailModal>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  static const List<String> _tabTitles = [
    'Overview',
    'Items (BOQ)',
    'Project Context',
    'Downstream RFQs',
    'Vendor Quotes',
    'Purchase Orders',
    'Dispatch',
    'Documents',
    'Approvals',
    'Activity Timeline',
    'Audit Log',
    'Actions',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabTitles.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Container(
        width: 960,
        constraints: const BoxConstraints(maxHeight: 760),
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
                    child: const Icon(Icons.inventory_2_outlined,
                        color: AppColors.primary, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(widget.request.requestNumber,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w900, fontSize: 16)),
                            const SizedBox(width: 10),
                            ProcurementStatusBadge.materialRequest(widget.request.status),
                            const SizedBox(width: 8),
                            ProcurementStatusBadge.priority(widget.request.priority),
                          ],
                        ),
                        Text(
                          '${widget.request.projectName} • Client: ${widget.request.customerName}',
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

            // Tab Bar
            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  ),
                ),
              ),
              child: TabBar(
                controller: _tabController,
                isScrollable: true,
                labelColor: AppColors.primary,
                unselectedLabelColor: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted,
                indicatorColor: AppColors.primary,
                tabs: _tabTitles.map((t) => Tab(text: t)).toList(),
              ),
            ),

            // Tab Views
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildOverviewTab(isDark, theme),
                  _buildItemsTab(isDark, theme),
                  _buildProjectContextTab(isDark, theme),
                  _buildGenericTab('Downstream RFQs', '1 Active RFQ generated from this requirement (RFQ-2026-00084).', isDark),
                  _buildGenericTab('Vendor Quotations', '3 Quotations received from Century Hub, Austin & Greenply.', isDark),
                  _buildGenericTab('Purchase Orders', 'PO-2026-00142 created for Century Wholesale Hub.', isDark),
                  _buildGenericTab('Dispatch & Site Deliveries', 'DSP-2026-00091 in transit. Delivery scheduled tomorrow.', isDark),
                  _buildGenericTab('Drawings & Specifications', 'Approved GFC joinery details & CAD sheets attached.', isDark),
                  _buildApprovalsTab(isDark, theme),
                  _buildTimelineTab(isDark),
                  _buildGenericTab('Audit History', 'Full change history and role modifications.', isDark),
                  _buildActionsTab(isDark),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewTab(bool isDark, ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: _buildInfoCard(
                  'FINANCIALS',
                  [
                    'Est. Material Cost: ₹${widget.request.estimatedMaterialCost.toStringAsFixed(0)}',
                    'Total Request Value: ₹${widget.request.estimatedTotal.toStringAsFixed(0)}',
                    'Available Budget: ₹${widget.request.budgetAvailable.toStringAsFixed(0)}',
                    'Budget Remaining: ₹${widget.request.remainingBudget.toStringAsFixed(0)}',
                  ],
                  isDark,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildInfoCard(
                  'EXECUTION SCOPE',
                  [
                    'Floor & Room: ${widget.request.floor} • ${widget.request.roomArea}',
                    'Department: ${widget.request.department}',
                    'Cost Centre: ${widget.request.costCentre}',
                    'Required Date: ${widget.request.requiredByDate.day}/${widget.request.requiredByDate.month}/${widget.request.requiredByDate.year}',
                  ],
                  isDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text('Business Justification & Technical Reason',
              style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              widget.request.requestReason,
              style: const TextStyle(fontSize: 12, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemsTab(bool isDark, ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Table(
        border: TableBorder.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          width: 0.8,
        ),
        children: [
          TableRow(
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
            ),
            children: const [
              _HeaderCell('#'),
              _HeaderCell('Item Name & Code'),
              _HeaderCell('Specification'),
              _HeaderCell('Qty / Unit'),
              _HeaderCell('Est. Rate'),
              _HeaderCell('Est. Amount'),
            ],
          ),
          ...widget.request.items.asMap().entries.map((entry) {
            final idx = entry.key;
            final item = entry.value;
            return TableRow(
              children: [
                _TextCell('${idx + 1}', alignCenter: true),
                _TextCell('${item.itemName}\n(${item.itemCode})'),
                _TextCell(item.specification.grade.isNotEmpty
                    ? '${item.specification.materialType} • ${item.specification.grade}'
                    : 'Standard'),
                _TextCell('${item.quantity.toStringAsFixed(0)} ${item.unit}', alignRight: true),
                _TextCell('₹${item.estimatedRate.toStringAsFixed(0)}', alignRight: true),
                _TextCell('₹${item.estimatedAmount.toStringAsFixed(0)}',
                    alignRight: true, isBold: true),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildProjectContextTab(bool isDark, ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProcurementContextBar(
            projectName: widget.request.projectName,
            siteAddress: widget.request.siteAddress,
            clientName: widget.request.customerName,
          ),
          const SizedBox(height: 20),
          Text(
            'Connected Approved Customer Quotation: QT-2026-00124',
            style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Quoted Material Budget: ₹28,50,000', style: TextStyle(fontWeight: FontWeight.w700)),
                SizedBox(height: 4),
                Text('Procured to Date: ₹12,40,000 (43.5% allocated)', style: TextStyle(fontSize: 12)),
                SizedBox(height: 4),
                Text('Remaining Procurement Margin: ₹16,10,000', style: TextStyle(fontSize: 12, color: AppColors.success)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildApprovalsTab(bool isDark, ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.verified_user_outlined, size: 48, color: AppColors.primary),
            const SizedBox(height: 12),
            Text('Material Request Approvals',
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
            const SizedBox(height: 6),
            Text(
              'Current Status: ${widget.request.status.label} • Estimated Total: ₹${widget.request.estimatedTotal.toStringAsFixed(0)}',
              style: TextStyle(color: isDark ? AppColors.darkSubtext : AppColors.lightTextSecondary),
            ),
            const SizedBox(height: 20),
            if (widget.request.status != MaterialRequestStatus.approved)
              FilledButton.icon(
                onPressed: widget.onApprove,
                icon: const Icon(Icons.check_circle_rounded, size: 16),
                label: const Text('Approve Request for Procurement RFQ'),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.success,
                  foregroundColor: Colors.white,
                ),
              )
            else
              const Text('✓ This request has already been approved and forwarded to Procurement.',
                  style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.success)),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineTab(bool isDark) {
    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: widget.request.timeline.length,
      itemBuilder: (context, index) {
        final ev = widget.request.timeline[index];
        return ListTile(
          dense: true,
          leading: Icon(ev.icon, color: AppColors.primary, size: 20),
          title: Text(ev.title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
          subtitle: Text('${ev.description} • ${ev.actorName} (${ev.actorRole})',
              style: const TextStyle(fontSize: 11)),
          trailing: Text(
            '${ev.timestamp.day}/${ev.timestamp.month} ${ev.timestamp.hour}:${ev.timestamp.minute.toString().padLeft(2, '0')}',
            style: const TextStyle(fontSize: 10),
          ),
        );
      },
    );
  }

  Widget _buildActionsTab(bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Downstream Operations Triggers',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
          const SizedBox(height: 12),
          ListTile(
            leading: const Icon(Icons.send_and_archive_outlined, color: AppColors.primary),
            title: const Text('Generate Vendor RFQ from this Request'),
            subtitle: const Text('Invites vetted suppliers to bid on these item specifications'),
            trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
            onTap: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Forwarded items to Vendor RFQ Builder!')),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.receipt_long_outlined, color: AppColors.primary),
            title: const Text('Direct PO Generation'),
            subtitle: const Text('Generate purchase order directly if single-source vendor contract is in place'),
            trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
            onTap: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  Widget _buildGenericTab(String title, String description, bool isDark) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
            const SizedBox(height: 6),
            Text(description,
                style: TextStyle(
                    fontSize: 12,
                    color: isDark ? AppColors.darkSubtext : AppColors.lightTextSecondary)),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, List<String> lines, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 10, fontWeight: FontWeight.w800, color: AppColors.primary)),
          const SizedBox(height: 8),
          ...lines.map((l) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Text(l, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
              )),
        ],
      ),
    );
  }
}

class _HeaderCell extends StatelessWidget {
  final String text;
  const _HeaderCell(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 11)),
    );
  }
}

class _TextCell extends StatelessWidget {
  final String text;
  final bool isBold;
  final bool alignRight;
  final bool alignCenter;

  const _TextCell(this.text, {this.isBold = false, this.alignRight = false, this.alignCenter = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Text(
        text,
        textAlign: alignRight ? TextAlign.right : alignCenter ? TextAlign.center : TextAlign.left,
        style: TextStyle(
          fontSize: 11,
          fontWeight: isBold ? FontWeight.w800 : FontWeight.normal,
        ),
      ),
    );
  }
}
