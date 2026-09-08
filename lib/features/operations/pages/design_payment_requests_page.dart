import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../models/operations_models.dart';
import '../models/operations_mock_data.dart';
import '../widgets/procurement_header.dart';
import '../widgets/procurement_kpi_card.dart';
import '../widgets/procurement_context_bar.dart';
import '../widgets/procurement_status_badge.dart';
import '../widgets/design_verification_panel.dart';
import '../widgets/customer_operations_summary_modal.dart';

class DesignPaymentRequestsPage extends StatefulWidget {
  const DesignPaymentRequestsPage({super.key});

  @override
  State<DesignPaymentRequestsPage> createState() =>
      _DesignPaymentRequestsPageState();
}

class _DesignPaymentRequestsPageState extends State<DesignPaymentRequestsPage> {
  late List<DesignPaymentRequest> _requests;
  String _searchQuery = '';
  DesignPaymentStatus? _statusFilter;
  DesignPaymentRequest? _selectedRequest;

  @override
  void initState() {
    super.initState();
    _requests = List.from(OperationsMockData.designPaymentRequests);
    if (_requests.isNotEmpty) {
      _selectedRequest = _requests.first;
    }
  }

  List<DesignPaymentRequest> get _filteredRequests {
    return _requests.where((r) {
      final matchesSearch = _searchQuery.isEmpty ||
          r.requestNumber.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          r.designerName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          r.projectName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          r.milestoneTitle.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesStatus =
          _statusFilter == null || r.status == _statusFilter;
      return matchesSearch && matchesStatus;
    }).toList();
  }

  // KPIs
  int get _totalCount => _requests.length;
  int get _underVerificationCount => _requests
      .where((r) => r.status == DesignPaymentStatus.underVerification)
      .length;
  int get _approvedCount =>
      _requests.where((r) => r.status == DesignPaymentStatus.approved).length;
  int get _paidCount =>
      _requests.where((r) => r.status == DesignPaymentStatus.paid).length;

  double get _totalRequested =>
      _requests.fold(0.0, (sum, r) => sum + r.netPayable);
  double get _totalPaid => _requests
      .where((r) => r.status == DesignPaymentStatus.paid)
      .fold(0.0, (sum, r) => sum + r.netPayable);

  void _openCreateModal() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => _CreateDesignPaymentModal(
        onCreated: (newReq) {
          setState(() {
            _requests.insert(0, newReq);
            _selectedRequest = newReq;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Design Payment Request ${newReq.requestNumber} submitted!'),
              backgroundColor: AppColors.success,
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
      ),
    );
  }

  void _openDetailModal(DesignPaymentRequest request) {
    showDialog(
      context: context,
      builder: (ctx) => _DesignPaymentDetailModal(
        request: request,
        onApproveAndPay: () {
          setState(() {
            final idx = _requests.indexWhere((r) => r.id == request.id);
            if (idx != -1) {
              _requests[idx] = DesignPaymentRequest(
                id: request.id,
                requestNumber: request.requestNumber,
                requestDate: request.requestDate,
                designerName: request.designerName,
                designerRole: request.designerRole,
                projectId: request.projectId,
                projectName: request.projectName,
                customerName: request.customerName,
                milestoneTitle: request.milestoneTitle,
                milestonePercent: request.milestonePercent,
                dueDate: request.dueDate,
                workPeriod: request.workPeriod,
                contractAmount: request.contractAmount,
                eligibleAmount: request.eligibleAmount,
                previouslyPaid: request.previouslyPaid,
                currentRequest: request.currentRequest,
                netPayable: request.netPayable,
                filesSubmittedCount: request.filesSubmittedCount,
                filesApprovedCount: request.filesSubmittedCount,
                filesPendingCount: 0,
                googleDriveUrl: request.googleDriveUrl,
                status: DesignPaymentStatus.paid,
                paidDate: DateTime.now(),
                timeline: [
                  ...request.timeline,
                  ProcurementTimelineEvent(
                    id: 'tl_${DateTime.now().millisecondsSinceEpoch}',
                    timestamp: DateTime.now(),
                    title: 'Payment Approved & Disbursed',
                    description: '₹${request.netPayable.toStringAsFixed(0)} released to ${request.designerName}',
                    actorName: 'Accounts Director',
                    actorRole: 'Finance Head',
                    icon: Icons.paid_rounded,
                  ),
                ],
              );
              _selectedRequest = _requests[idx];
            }
          });
          Navigator.of(ctx).pop();
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
            title: 'Design Payment Requests',
            subtitle:
                'Manage architectural & design milestone deliverables, verify submitted files & Google Drive links, and release designer payments.',
            icon: Icons.draw_outlined,
            primaryActionLabel: 'Create Payment Request',
            primaryActionIcon: Icons.add_rounded,
            onPrimaryAction: _openCreateModal,
            onRefresh: () => setState(() {}),
          ),

          // 2. Global Context Bar
          if (_selectedRequest != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 14, 24, 0),
              child: ProcurementContextBar(
                projectName: _selectedRequest!.projectName,
                siteAddress: 'The Camellias, DLF Phase 5, Gurugram',
                clientName: _selectedRequest!.customerName,
                projectManager: 'Amit Kumar',
                projectStatus: 'Design Execution & CAD GFC Phase',
                procurementStatus: 'Milestone: ${_selectedRequest!.milestoneTitle}',
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
                            title: 'Total Requests',
                            value: '$_totalCount',
                            subtitle: 'Requested: ₹${_totalRequested.toStringAsFixed(0)}',
                            icon: Icons.draw_outlined,
                            color: AppColors.primary,
                            isSelected: _statusFilter == null,
                            onTap: () => setState(() => _statusFilter = null),
                          ),
                          ProcurementKpiCard(
                            title: 'Under Verification',
                            value: '$_underVerificationCount',
                            subtitle: 'Drawings & CAD sign-off',
                            icon: Icons.fact_check_rounded,
                            color: AppColors.warning,
                            isSelected: _statusFilter == DesignPaymentStatus.underVerification,
                            onTap: () => setState(
                                () => _statusFilter = DesignPaymentStatus.underVerification),
                          ),
                          ProcurementKpiCard(
                            title: 'Approved for Payment',
                            value: '$_approvedCount',
                            subtitle: 'Verified by Design Director',
                            icon: Icons.check_circle_outline_rounded,
                            color: const Color(0xFF06B6D4),
                            isSelected: _statusFilter == DesignPaymentStatus.approved,
                            onTap: () => setState(
                                () => _statusFilter = DesignPaymentStatus.approved),
                          ),
                          ProcurementKpiCard(
                            title: 'Total Paid Out',
                            value: '₹${_totalPaid.toStringAsFixed(0)}',
                            subtitle: '$_paidCount Milestones Cleared',
                            icon: Icons.verified_rounded,
                            color: AppColors.success,
                            isSelected: _statusFilter == DesignPaymentStatus.paid,
                            onTap: () => setState(
                                () => _statusFilter = DesignPaymentStatus.paid),
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
                            hintText: 'Search designer name, milestone, project, or request number...',
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

                  // Table
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
              Icon(Icons.draw_outlined,
                  size: 48,
                  color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted),
              const SizedBox(height: 12),
              Text('No Design Payment Requests Found',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: _openCreateModal,
                icon: const Icon(Icons.add_rounded, size: 16),
                label: const Text('Create Design Payment Request'),
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
            DataColumn(label: Text('REQUEST #', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11))),
            DataColumn(label: Text('DESIGNER & ROLE', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11))),
            DataColumn(label: Text('PROJECT', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11))),
            DataColumn(label: Text('MILESTONE & STAGE', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11))),
            DataColumn(label: Text('FILES STATUS', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11))),
            DataColumn(label: Text('NET PAYABLE', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11))),
            DataColumn(label: Text('DUE DATE', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11))),
            DataColumn(label: Text('STATUS', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11))),
            DataColumn(label: Text('ACTIONS', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11))),
          ],
          rows: _filteredRequests.map((req) {
            final isSelected = req.id == _selectedRequest?.id;
            return DataRow(
              selected: isSelected,
              onSelectChanged: (_) => setState(() => _selectedRequest = req),
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
                      Text(req.designerName,
                          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                      Text(req.designerRole,
                          style: TextStyle(
                            fontSize: 10,
                            color: isDark ? AppColors.darkSubtext : AppColors.lightTextSecondary,
                          )),
                    ],
                  ),
                ),
                DataCell(Text(req.projectName, style: const TextStyle(fontSize: 12))),
                DataCell(
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(req.milestoneTitle,
                          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                      Text('${req.milestonePercent}% of ₹${req.contractAmount.toStringAsFixed(0)}',
                          style: TextStyle(
                            fontSize: 10,
                            color: isDark ? AppColors.darkSubtext : AppColors.lightTextSecondary,
                          )),
                    ],
                  ),
                ),
                DataCell(
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: req.filesPendingCount == 0
                          ? AppColors.success.withValues(alpha: 0.15)
                          : AppColors.warning.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '${req.filesApprovedCount}/${req.filesSubmittedCount} Files Approved',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: req.filesPendingCount == 0 ? AppColors.success : AppColors.warning,
                      ),
                    ),
                  ),
                ),
                DataCell(
                  Text(
                    '₹${req.netPayable.toStringAsFixed(0)}',
                    style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: AppColors.primary),
                  ),
                ),
                DataCell(Text('${req.dueDate.day}/${req.dueDate.month}/${req.dueDate.year}',
                    style: const TextStyle(fontSize: 12))),
                DataCell(ProcurementStatusBadge.designPayment(req.status)),
                DataCell(
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.fact_check_outlined, size: 18),
                        tooltip: 'Verify Files & Milestone Sign-off',
                        onPressed: () => _openDetailModal(req),
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
/// CREATE DESIGN PAYMENT REQUEST MODAL
/// ============================================================================
class _CreateDesignPaymentModal extends StatefulWidget {
  final ValueChanged<DesignPaymentRequest> onCreated;

  const _CreateDesignPaymentModal({required this.onCreated});

  @override
  State<_CreateDesignPaymentModal> createState() =>
      _CreateDesignPaymentModalState();
}

class _CreateDesignPaymentModalState extends State<_CreateDesignPaymentModal> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _designerCtrl =
      TextEditingController(text: 'Ananya Roy (Principal Architect)');
  final TextEditingController _milestoneTitleCtrl = TextEditingController(
      text: 'GFC CAD Drawings & Electrical MEP Layout Sign-off');
  final TextEditingController _contractAmountCtrl =
      TextEditingController(text: '350000');
  final TextEditingController _percentCtrl =
      TextEditingController(text: '25');
  final TextEditingController _driveUrlCtrl = TextEditingController(
      text: 'https://drive.google.com/drive/folders/homio-camellias-1402-gfc');

  @override
  void dispose() {
    _designerCtrl.dispose();
    _milestoneTitleCtrl.dispose();
    _contractAmountCtrl.dispose();
    _percentCtrl.dispose();
    _driveUrlCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final contract = double.tryParse(_contractAmountCtrl.text) ?? 300000;
    final pct = double.tryParse(_percentCtrl.text) ?? 20;
    final payable = contract * (pct / 100);

    final newReq = DesignPaymentRequest(
      id: 'dpr_${DateTime.now().millisecondsSinceEpoch}',
      requestNumber: 'DPR-2026-0004${7 + DateTime.now().second}',
      requestDate: DateTime.now(),
      designerName: _designerCtrl.text,
      projectId: 'PRJ-CAM-01',
      projectName: 'The Camellias Villa Interior #1402',
      customerName: 'Rahul Sharma',
      milestoneTitle: _milestoneTitleCtrl.text,
      milestonePercent: pct,
      dueDate: DateTime.now().add(const Duration(days: 7)),
      contractAmount: contract,
      eligibleAmount: payable,
      previouslyPaid: 100000,
      currentRequest: payable,
      netPayable: payable,
      filesSubmittedCount: 14,
      filesApprovedCount: 12,
      filesPendingCount: 2,
      googleDriveUrl: _driveUrlCtrl.text,
      status: DesignPaymentStatus.submitted,
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
        width: 760,
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Create Design Payment Request',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
              const SizedBox(height: 6),
              Text(
                'Connect architectural milestone deliverables, submitted files & Google Drive verification.',
                style: TextStyle(
                  fontSize: 11,
                  color: isDark ? AppColors.darkSubtext : AppColors.lightTextSecondary,
                ),
              ),
              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _designerCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Lead Designer / Architect *',
                        isDense: true,
                        border: OutlineInputBorder(),
                      ),
                      validator: (v) => v!.isEmpty ? 'Required' : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _milestoneTitleCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Design Milestone Title *',
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
                    child: TextFormField(
                      controller: _contractAmountCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Total Design Contract Amount (₹) *',
                        isDense: true,
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _percentCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Milestone Percentage (%) *',
                        isDense: true,
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _driveUrlCtrl,
                decoration: const InputDecoration(
                  labelText: 'Project Google Drive URL (CAD & 3D Deliverables Folder) *',
                  isDense: true,
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 24),

              Row(
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
                    label: const Text('Submit for PM Verification'),
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
      ),
    );
  }
}

/// ============================================================================
/// DETAIL MODAL WITH WORK VERIFICATION & DRIVE LINK
/// ============================================================================
class _DesignPaymentDetailModal extends StatelessWidget {
  final DesignPaymentRequest request;
  final VoidCallback onApproveAndPay;

  const _DesignPaymentDetailModal({
    required this.request,
    required this.onApproveAndPay,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Container(
        width: 860,
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
                          Text(request.requestNumber,
                              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
                          const SizedBox(width: 10),
                          ProcurementStatusBadge.designPayment(request.status),
                        ],
                      ),
                      Text('${request.designerName} (${request.designerRole}) • ${request.projectName}',
                          style: TextStyle(
                            fontSize: 11,
                            color: isDark ? AppColors.darkSubtext : AppColors.lightTextSecondary,
                          )),
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

            // Financial Summary Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildMetric('Design Contract', '₹${request.contractAmount.toStringAsFixed(0)}'),
                  _buildMetric('Milestone', '${request.milestonePercent}%'),
                  _buildMetric('Previously Paid', '₹${request.previouslyPaid.toStringAsFixed(0)}'),
                  _buildMetric('Net Payable Now', '₹${request.netPayable.toStringAsFixed(0)}',
                      color: AppColors.primary),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Work Verification Panel
            DesignVerificationPanel(
              request: request,
              onOpenDrive: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Opening Google Drive: ${request.googleDriveUrl}')),
                );
              },
              onVerifyApproval: onApproveAndPay,
            ),
            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Close'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetric(String label, String value, {Color? color}) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600)),
        const SizedBox(height: 2),
        Text(value,
            style: TextStyle(
                fontWeight: FontWeight.w900, fontSize: 15, color: color ?? AppColors.primary)),
      ],
    );
  }
}
