// Homio CRM — Screen 7: Labour & Contractor Payment Workspace

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../models/accounting_models.dart';
import '../models/accounting_mock_data.dart';
import '../widgets/finance_page_header.dart';
import '../widgets/finance_kpi_card.dart';
import '../widgets/financial_filter_bar.dart';
import '../widgets/financial_status_badge.dart';
import '../widgets/labour_verification_card.dart';

class LabourPaymentsPage extends StatefulWidget {
  const LabourPaymentsPage({super.key});

  @override
  State<LabourPaymentsPage> createState() => _LabourPaymentsPageState();
}

class _LabourPaymentsPageState extends State<LabourPaymentsPage> {
  late List<LabourPaymentRecord> _labourPayments;
  String _searchQuery = '';
  String? _selectedProject;

  @override
  void initState() {
    super.initState();
    _labourPayments = List.from(AccountingMockData.labourPayments);
  }

  List<LabourPaymentRecord> get _filteredPayments {
    return _labourPayments.where((lp) {
      final matchesSearch = _searchQuery.isEmpty ||
          lp.contractorName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          lp.serviceCategory.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          lp.projectName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          lp.workItem.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesProject =
          _selectedProject == null || lp.projectName == _selectedProject;
      return matchesSearch && matchesProject;
    }).toList();
  }

  double get _totalLabourCosts =>
      _labourPayments.fold(0.0, (sum, l) => sum + l.netPayable);
  double get _totalDisbursed =>
      _labourPayments.fold(0.0, (sum, l) => sum + l.currentPayment);
  int get _pendingVerificationCount =>
      _labourPayments.where((l) => !l.pmApproved).length;

  void _openVerificationModal(LabourPaymentRecord record) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Container(
          width: 580,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColors.darkSurface
                : AppColors.lightSurface,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'LABOUR DISBURSEMENT AUDIT',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
                  ),
                  IconButton(onPressed: () => Navigator.pop(ctx), icon: const Icon(Icons.close_rounded)),
                ],
              ),
              const Divider(),
              LabourVerificationCard(
                record: record,
                onApprovePm: () {
                  setState(() {
                    final idx = _labourPayments.indexWhere((l) => l.id == record.id);
                    if (idx != -1) {
                      _labourPayments[idx] = LabourPaymentRecord(
                        id: record.id,
                        paymentId: record.paymentId,
                        contractorName: record.contractorName,
                        contractorId: record.contractorId,
                        contactPhone: record.contactPhone,
                        serviceCategory: record.serviceCategory,
                        projectId: record.projectId,
                        projectName: record.projectName,
                        customerName: record.customerName,
                        siteAddress: record.siteAddress,
                        workItem: record.workItem,
                        workArea: record.workArea,
                        stageOrMilestone: record.stageOrMilestone,
                        workDate: record.workDate,
                        completionPercentage: record.completionPercentage,
                        grossAmount: record.grossAmount,
                        netPayable: record.netPayable,
                        previousPaid: record.previousPaid,
                        currentPayment: record.netPayable,
                        status: LabourPaymentStatus.approved,
                        workAssigned: true,
                        workCompleted: true,
                        siteVerified: true,
                        pmApproved: true,
                        paymentEligible: true,
                        supervisorVerificationNotes: 'PM Approval granted by Amit Kumar.',
                      );
                    }
                  });
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Labour Payment ${record.paymentId} approved and cleared for release!'),
                      backgroundColor: AppColors.success,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openCreatePaymentModal() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => _CreateLabourPaymentModal(
        onCreated: (newPay) {
          setState(() {
            _labourPayments.insert(0, newPay);
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Labour payment request created for ${newPay.contractorName}!'),
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
    final projectList = _labourPayments.map((l) => l.projectName).toSet().toList();

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: Column(
        children: [
          // 1. Header
          FinancePageHeader(
            title: 'Labour & Contractor Payments',
            subtitle:
                'Manage contractor disbursements, 5-point site verification audits, work progress %, and project manager authorizations.',
            icon: Icons.engineering_rounded,
            primaryActionLabel: 'Create Labour Payment',
            primaryActionIcon: Icons.add_rounded,
            onPrimaryAction: _openCreatePaymentModal,
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
                            title: 'Total Labour Valuation',
                            value: '₹${_totalLabourCosts.toStringAsFixed(0)}',
                            subtitle: '${_labourPayments.length} Contractor Milestones',
                            icon: Icons.engineering_outlined,
                            color: AppColors.primary,
                          ),
                          FinanceKpiCard(
                            title: 'Disbursed Payouts',
                            value: '₹${_totalDisbursed.toStringAsFixed(0)}',
                            subtitle: 'Cleared into contractor accounts',
                            icon: Icons.check_circle_outline_rounded,
                            color: AppColors.success,
                          ),
                          FinanceKpiCard(
                            title: 'Pending PM Verification',
                            value: '$_pendingVerificationCount Vouchers',
                            subtitle: 'Requires site manager sign-off',
                            icon: Icons.pending_actions_rounded,
                            color: AppColors.warning,
                          ),
                          FinanceKpiCard(
                            title: 'Active Trades',
                            value: '${_labourPayments.map((l) => l.serviceCategory).toSet().length} Trades',
                            subtitle: 'Carpentry, Electrical, False Ceiling',
                            icon: Icons.construction_rounded,
                            color: const Color(0xFF8B5CF6),
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
                    searchHint: 'Search contractor, trade category, or work item...',
                    selectedProject: _selectedProject,
                    projectList: projectList,
                    onProjectChanged: (val) => setState(() => _selectedProject = val),
                    onClearFilters: () => setState(() {
                      _searchQuery = '';
                      _selectedProject = null;
                    }),
                  ),
                  const SizedBox(height: 20),

                  // Table
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
                            DataColumn(label: Text('CONTRACTOR', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11))),
                            DataColumn(label: Text('CATEGORY', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11))),
                            DataColumn(label: Text('PROJECT & WORK ITEM', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11))),
                            DataColumn(label: Text('PROGRESS', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11))),
                            DataColumn(label: Text('GROSS (₹)', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11))),
                            DataColumn(label: Text('NET DUE (₹)', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11))),
                            DataColumn(label: Text('5-PT AUDIT', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11))),
                            DataColumn(label: Text('STATUS', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11))),
                            DataColumn(label: Text('ACTIONS', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11))),
                          ],
                          rows: _filteredPayments.map((lp) {
                            return DataRow(
                              cells: [
                                DataCell(Text(lp.paymentId, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: AppColors.primary))),
                                DataCell(
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(lp.contractorName, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                                      Text(lp.contactPhone, style: const TextStyle(fontSize: 10, color: Colors.grey)),
                                    ],
                                  ),
                                ),
                                DataCell(Text(lp.serviceCategory, style: const TextStyle(fontSize: 12))),
                                DataCell(
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(lp.projectName, style: const TextStyle(fontSize: 12)),
                                      Text(lp.workItem, style: const TextStyle(fontSize: 10, color: Colors.grey)),
                                    ],
                                  ),
                                ),
                                DataCell(Text('${lp.completionPercentage.toStringAsFixed(0)}%', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12))),
                                DataCell(Text('₹${lp.grossAmount.toStringAsFixed(0)}', style: const TextStyle(fontSize: 12))),
                                DataCell(Text('₹${lp.netPayable.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12, color: AppColors.primary))),
                                DataCell(
                                  Icon(
                                    lp.pmApproved ? Icons.verified_rounded : Icons.pending_rounded,
                                    color: lp.pmApproved ? AppColors.success : AppColors.warning,
                                    size: 20,
                                  ),
                                ),
                                DataCell(FinancialStatusBadge.fromLabourPayment(lp.status)),
                                DataCell(
                                  IconButton(
                                    onPressed: () => _openVerificationModal(lp),
                                    icon: const Icon(Icons.checklist_rtl_rounded, size: 20, color: AppColors.primary),
                                    tooltip: '5-Point Verification Audit',
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
// Create Labour Payment Modal
// -----------------------------------------------------------------------------
class _CreateLabourPaymentModal extends StatefulWidget {
  final ValueChanged<LabourPaymentRecord> onCreated;

  const _CreateLabourPaymentModal({required this.onCreated});

  @override
  State<_CreateLabourPaymentModal> createState() => _CreateLabourPaymentModalState();
}

class _CreateLabourPaymentModalState extends State<_CreateLabourPaymentModal> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _contractorCtrl =
      TextEditingController(text: 'Ramesh Electrical & Lighting Squad');
  final TextEditingController _phoneCtrl =
      TextEditingController(text: '+91 99102 33445');
  final TextEditingController _workCtrl =
      TextEditingController(text: 'DALI Dimming & DB Dressing Complete');
  final TextEditingController _grossCtrl =
      TextEditingController(text: '45000');
  final TextEditingController _deductionCtrl =
      TextEditingController(text: '0');

  String _category = 'Electrical & Automation';

  @override
  void dispose() {
    _contractorCtrl.dispose();
    _phoneCtrl.dispose();
    _workCtrl.dispose();
    _grossCtrl.dispose();
    _deductionCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      final gross = double.tryParse(_grossCtrl.text) ?? 45000.0;
      final ded = double.tryParse(_deductionCtrl.text) ?? 0.0;
      final net = gross - ded;

      final newRecord = LabourPaymentRecord(
        id: 'LP-${DateTime.now().millisecondsSinceEpoch}',
        paymentId: 'LP-2026-${DateTime.now().millisecondsSinceEpoch.toString().substring(9)}',
        contractorName: _contractorCtrl.text,
        contractorId: 'LAB-NEW',
        contactPhone: _phoneCtrl.text,
        serviceCategory: _category,
        projectId: 'PRJ-CAM-101',
        projectName: 'The Camellias Villa Interior #1402',
        customerName: 'Rahul Sharma',
        siteAddress: 'The Camellias, DLF Phase 5, Gurugram',
        workItem: _workCtrl.text,
        workArea: 'Master Suite',
        stageOrMilestone: 'Milestone 2',
        workDate: DateTime.now(),
        completionPercentage: 100,
        grossAmount: gross,
        deduction: ded,
        netPayable: net,
        previousPaid: 0,
        currentPayment: 0,
        status: LabourPaymentStatus.pendingApproval,
        workAssigned: true,
        workCompleted: true,
        siteVerified: true,
        pmApproved: false,
        paymentEligible: false,
        supervisorVerificationNotes: 'Awaiting formal PM sign-off.',
      );

      widget.onCreated(newRecord);
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
                    Text('CREATE LABOUR PAYMENT REQUEST', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
                    IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close_rounded)),
                  ],
                ),
                const Divider(height: 20),

                TextFormField(
                  controller: _contractorCtrl,
                  decoration: const InputDecoration(labelText: 'Contractor / Squad Name *', isDense: true, border: OutlineInputBorder()),
                  validator: (val) => (val == null || val.isEmpty) ? 'Enter contractor' : null,
                ),
                const SizedBox(height: 14),

                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        initialValue: _category,
                        decoration: const InputDecoration(labelText: 'Trade Category', isDense: true, border: OutlineInputBorder()),
                        items: ['Modular Carpentry', 'Electrical & Automation', 'False Ceiling', 'Civil & Tiling', 'Painting']
                            .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                            .toList(),
                        onChanged: (val) => setState(() => _category = val!),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(child: TextFormField(controller: _phoneCtrl, decoration: const InputDecoration(labelText: 'Mobile Phone', isDense: true, border: OutlineInputBorder()))),
                  ],
                ),
                const SizedBox(height: 14),

                TextFormField(
                  controller: _workCtrl,
                  decoration: const InputDecoration(labelText: 'Work Item & Scope *', isDense: true, border: OutlineInputBorder()),
                  validator: (val) => (val == null || val.isEmpty) ? 'Enter work scope' : null,
                ),
                const SizedBox(height: 14),

                Row(
                  children: [
                    Expanded(child: TextFormField(controller: _grossCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Gross Amount (₹) *', prefixText: '₹ ', isDense: true, border: OutlineInputBorder()))),
                    const SizedBox(width: 12),
                    Expanded(child: TextFormField(controller: _deductionCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Deductions (₹)', prefixText: '₹ ', isDense: true, border: OutlineInputBorder()))),
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
                      label: const Text('Submit Labour Voucher'),
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
