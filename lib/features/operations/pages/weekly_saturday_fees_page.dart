import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../models/operations_models.dart';
import '../models/operations_mock_data.dart';
import '../widgets/procurement_header.dart';
import '../widgets/procurement_kpi_card.dart';
import '../widgets/procurement_context_bar.dart';
import '../widgets/procurement_status_badge.dart';
import '../widgets/weekly_fee_segregation_card.dart';
import '../widgets/saturday_automation_modal.dart';
import '../widgets/whatsapp_payment_request_modal.dart';
import '../widgets/customer_operations_summary_modal.dart';

class WeeklySaturdayFeesPage extends StatefulWidget {
  const WeeklySaturdayFeesPage({super.key});

  @override
  State<WeeklySaturdayFeesPage> createState() => _WeeklySaturdayFeesPageState();
}

class _WeeklySaturdayFeesPageState extends State<WeeklySaturdayFeesPage> {
  late List<WeeklyFee> _fees;
  String _searchQuery = '';
  WeeklyFeeStatus? _statusFilter;
  WeeklyFee? _selectedFee;
  SaturdayAutomationConfig _automationConfig =
      OperationsMockData.saturdayAutomationConfig;

  @override
  void initState() {
    super.initState();
    _fees = List.from(OperationsMockData.weeklyFees);
    if (_fees.isNotEmpty) {
      _selectedFee = _fees.first;
    }
  }

  List<WeeklyFee> get _filteredFees {
    return _fees.where((fee) {
      final matchesSearch = _searchQuery.isEmpty ||
          fee.feeCode.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          fee.projectName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          fee.customerName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          fee.weekPeriod.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesStatus =
          _statusFilter == null || fee.status == _statusFilter;
      return matchesSearch && matchesStatus;
    }).toList();
  }

  // KPIs
  int get _totalCount => _fees.length;
  double get _totalWeeklyFees =>
      _fees.fold(0.0, (sum, f) => sum + f.totalAmount);
  double get _totalPaid =>
      _fees.fold(0.0, (sum, f) => sum + f.paidAmount);
  double get _totalPendingDues =>
      _totalWeeklyFees - _totalPaid;

  void _openCreateModal() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => _CreateWeeklyFeeModal(
        onCreated: (newFee) {
          setState(() {
            _fees.insert(0, newFee);
            _selectedFee = newFee;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Weekly Fee Dossier ${newFee.feeCode} generated!'),
              backgroundColor: AppColors.success,
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
      ),
    );
  }

  void _openSaturdayAutomationModal() {
    showDialog(
      context: context,
      builder: (ctx) => SaturdayAutomationModal(
        initialConfig: _automationConfig,
        logs: OperationsMockData.saturdayAutomationLogs,
        onSaveConfig: (updated) {
          setState(() => _automationConfig = updated);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Saturday Fee automation rules saved!')),
          );
        },
        onTriggerNow: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Triggered Saturday fee calculation for all active projects!'),
              backgroundColor: AppColors.success,
            ),
          );
        },
      ),
    );
  }

  void _openWhatsAppModal(WeeklyFee fee) {
    showDialog(
      context: context,
      builder: (ctx) => WhatsAppPaymentRequestModal(
        fee: fee,
        onDispatched: () {
          setState(() {
            final idx = _fees.indexWhere((f) => f.id == fee.id);
            if (idx != -1) {
              _fees[idx] = WeeklyFee(
                id: fee.id,
                feeCode: fee.feeCode,
                weekPeriod: fee.weekPeriod,
                weekStartDate: fee.weekStartDate,
                weekEndDate: fee.weekEndDate,
                feeDate: fee.feeDate,
                paymentDueDate: fee.paymentDueDate,
                paymentRequestDate: fee.paymentRequestDate,
                projectId: fee.projectId,
                projectName: fee.projectName,
                customerId: fee.customerId,
                customerName: fee.customerName,
                customerPhone: fee.customerPhone,
                siteAddress: fee.siteAddress,
                materialAmount: fee.materialAmount,
                materialBills: fee.materialBills,
                labourAmount: fee.labourAmount,
                labourBills: fee.labourBills,
                supervisionFees: fee.supervisionFees,
                consultingFees: fee.consultingFees,
                otherApprovedFees: fee.otherApprovedFees,
                totalAmount: fee.totalAmount,
                paidAmount: fee.paidAmount,
                status: WeeklyFeeStatus.paymentRequested,
                whatsappStatus: 'Delivered',
                whatsappSentAt: DateTime.now(),
                paymentLinkUrl: fee.paymentLinkUrl,
              );
              _selectedFee = _fees[idx];
            }
          });
        },
      ),
    );
  }

  void _openCustomerSummary(WeeklyFee fee) {
    final summary = OperationsMockData.customerSummaries.firstWhere(
      (s) => s.customerId == fee.customerId,
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
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: Column(
        children: [
          // 1. Header
          ProcurementPageHeader(
            title: 'Weekly / Saturday Fees',
            subtitle:
                'Manage recurring project operational costs, 3-way segregation (Material, Labour, Fees), auto-calculated summaries, and Saturday WhatsApp dispatches.',
            icon: Icons.calendar_today_outlined,
            primaryActionLabel: 'Create Weekly Dossier',
            primaryActionIcon: Icons.add_rounded,
            onPrimaryAction: _openCreateModal,
            onRefresh: () => setState(() {}),
            secondaryAction: FilledButton.tonalIcon(
              onPressed: _openSaturdayAutomationModal,
              icon: const Icon(Icons.alarm_on_rounded, size: 16),
              label: const Text('Saturday Automation Engine', style: TextStyle(fontSize: 12)),
            ),
          ),

          // 2. Global Context Bar
          if (_selectedFee != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 14, 24, 0),
              child: ProcurementContextBar(
                projectName: _selectedFee!.projectName,
                siteAddress: _selectedFee!.siteAddress,
                clientName: _selectedFee!.customerName,
                projectManager: _selectedFee!.projectManager,
                projectStatus: 'Weekly Site Operations Running',
                procurementStatus: 'Saturday Fee: ₹${_selectedFee!.totalAmount.toStringAsFixed(0)}',
                onViewCustomerSummary: () => _openCustomerSummary(_selectedFee!),
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
                            title: 'Current Week Fees',
                            value: '₹${_totalWeeklyFees.toStringAsFixed(0)}',
                            subtitle: '$_totalCount Active Projects • Week 36',
                            icon: Icons.calendar_today_outlined,
                            color: AppColors.primary,
                            isSelected: _statusFilter == null,
                            onTap: () => setState(() => _statusFilter = null),
                          ),
                          ProcurementKpiCard(
                            title: 'Paid Collections',
                            value: '₹${_totalPaid.toStringAsFixed(0)}',
                            subtitle: 'Recovered via online & bank',
                            icon: Icons.check_circle_outline_rounded,
                            color: AppColors.success,
                            isSelected: _statusFilter == WeeklyFeeStatus.paid,
                            onTap: () => setState(
                                () => _statusFilter = WeeklyFeeStatus.paid),
                          ),
                          ProcurementKpiCard(
                            title: 'Pending Client Dues',
                            value: '₹${_totalPendingDues.toStringAsFixed(0)}',
                            subtitle: 'Outstanding collections due',
                            icon: Icons.hourglass_empty_rounded,
                            color: AppColors.error,
                            isSelected: _statusFilter == WeeklyFeeStatus.paymentRequested,
                            onTap: () => setState(
                                () => _statusFilter = WeeklyFeeStatus.paymentRequested),
                          ),
                          ProcurementKpiCard(
                            title: 'Saturday Automation Status',
                            value: _automationConfig.isEnabled ? 'Active' : 'Paused',
                            subtitle: 'Auto-dispatches Sat 10:00 AM',
                            icon: Icons.smart_toy_outlined,
                            color: const Color(0xFF0D9488),
                            onTap: _openSaturdayAutomationModal,
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 24),

                  // Selected Fee Segregation Card (Client explicitly requires Segregation & Auto-calculated amounts)
                  if (_selectedFee != null) ...[
                    WeeklyFeeSegregationCard(
                      fee: _selectedFee!,
                      onSendWhatsApp: () => _openWhatsAppModal(_selectedFee!),
                      onGeneratePaymentRequest: () => _openWhatsAppModal(_selectedFee!),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Table Toolbar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Weekly Operations Dossiers (${_filteredFees.length})',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(
                        width: 280,
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Search fee code, project, or customer...',
                            prefixIcon: const Icon(Icons.search_rounded, size: 18),
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          onChanged: (val) => setState(() => _searchQuery = val),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

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
    if (_filteredFees.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 48),
          child: Column(
            children: [
              Icon(Icons.calendar_today_outlined,
                  size: 48,
                  color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted),
              const SizedBox(height: 12),
              Text('No Weekly Fee Dossiers Found',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: _openCreateModal,
                icon: const Icon(Icons.add_rounded, size: 16),
                label: const Text('Create Weekly Fee Dossier'),
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
            DataColumn(label: Text('FEE ID', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11))),
            DataColumn(label: Text('WEEK PERIOD', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11))),
            DataColumn(label: Text('PROJECT & CLIENT', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11))),
            DataColumn(label: Text('MATERIAL (₹)', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11))),
            DataColumn(label: Text('LABOUR (₹)', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11))),
            DataColumn(label: Text('FEES (₹)', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11))),
            DataColumn(label: Text('TOTAL (₹)', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11))),
            DataColumn(label: Text('DUE (₹)', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11))),
            DataColumn(label: Text('WHATSAPP', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11))),
            DataColumn(label: Text('STATUS', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11))),
            DataColumn(label: Text('ACTIONS', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11))),
          ],
          rows: _filteredFees.map((fee) {
            final isSelected = fee.id == _selectedFee?.id;
            return DataRow(
              selected: isSelected,
              onSelectChanged: (_) => setState(() => _selectedFee = fee),
              cells: [
                DataCell(
                  Text(
                    fee.feeCode,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                      fontSize: 12,
                    ),
                  ),
                ),
                DataCell(Text(fee.weekPeriod,
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12))),
                DataCell(
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(fee.projectName,
                          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                      Text(fee.customerName,
                          style: TextStyle(
                            fontSize: 10,
                            color: isDark ? AppColors.darkSubtext : AppColors.lightTextSecondary,
                          )),
                    ],
                  ),
                ),
                DataCell(Text('₹${fee.materialAmount.toStringAsFixed(0)}',
                    style: const TextStyle(fontSize: 12))),
                DataCell(Text('₹${fee.labourAmount.toStringAsFixed(0)}',
                    style: const TextStyle(fontSize: 12))),
                DataCell(Text('₹${fee.feesTotal.toStringAsFixed(0)}',
                    style: const TextStyle(fontSize: 12))),
                DataCell(
                  Text(
                    '₹${fee.totalAmount.toStringAsFixed(0)}',
                    style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12, color: AppColors.primary),
                  ),
                ),
                DataCell(
                  Text(
                    '₹${fee.dueAmount.toStringAsFixed(0)}',
                    style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12, color: AppColors.error),
                  ),
                ),
                DataCell(
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: fee.whatsappStatus == 'Delivered' || fee.whatsappStatus == 'Read'
                          ? const Color(0xFF25D366).withValues(alpha: 0.15)
                          : AppColors.warning.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.check_rounded, size: 12, color: Color(0xFF25D366)),
                        const SizedBox(width: 4),
                        Text(
                          fee.whatsappStatus,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF25D366),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                DataCell(ProcurementStatusBadge.weeklyFee(fee.status)),
                DataCell(
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.send_to_mobile_rounded, size: 18),
                        tooltip: 'Send / View WhatsApp Payment Request',
                        onPressed: () => _openWhatsAppModal(fee),
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
/// CREATE WEEKLY FEE MODAL (With Live Auto-Calculated 3-Way Summary)
/// ============================================================================
class _CreateWeeklyFeeModal extends StatefulWidget {
  final ValueChanged<WeeklyFee> onCreated;

  const _CreateWeeklyFeeModal({required this.onCreated});

  @override
  State<_CreateWeeklyFeeModal> createState() => _CreateWeeklyFeeModalState();
}

class _CreateWeeklyFeeModalState extends State<_CreateWeeklyFeeModal> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _projectNameCtrl =
      TextEditingController(text: 'The Camellias Villa Interior #1402');
  final TextEditingController _customerNameCtrl =
      TextEditingController(text: 'Rahul Sharma');
  final TextEditingController _phoneCtrl =
      TextEditingController(text: '+91 98101 44550');
  final TextEditingController _materialAmountCtrl =
      TextEditingController(text: '125000');
  final TextEditingController _labourAmountCtrl =
      TextEditingController(text: '85000');
  final TextEditingController _supervisionCtrl =
      TextEditingController(text: '15000');
  final TextEditingController _consultingCtrl =
      TextEditingController(text: '10000');

  double get _mat => double.tryParse(_materialAmountCtrl.text) ?? 0;
  double get _lab => double.tryParse(_labourAmountCtrl.text) ?? 0;
  double get _sup => double.tryParse(_supervisionCtrl.text) ?? 0;
  double get _con => double.tryParse(_consultingCtrl.text) ?? 0;
  double get _total => _mat + _lab + _sup + _con;

  @override
  void dispose() {
    _projectNameCtrl.dispose();
    _customerNameCtrl.dispose();
    _phoneCtrl.dispose();
    _materialAmountCtrl.dispose();
    _labourAmountCtrl.dispose();
    _supervisionCtrl.dispose();
    _consultingCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final newFee = WeeklyFee(
      id: 'wkf_${DateTime.now().millisecondsSinceEpoch}',
      feeCode: 'WKF-2026-W36-0${3 + DateTime.now().second}',
      weekPeriod: 'Week 36 (01 Sep - 07 Sep 2026)',
      weekStartDate: DateTime.now().subtract(const Duration(days: 7)),
      weekEndDate: DateTime.now(),
      feeDate: DateTime.now(),
      paymentDueDate: DateTime.now().add(const Duration(days: 3)),
      paymentRequestDate: DateTime.now(),
      projectId: 'PRJ-CAM-01',
      projectName: _projectNameCtrl.text,
      customerId: 'CUST-RS-01',
      customerName: _customerNameCtrl.text,
      customerPhone: _phoneCtrl.text,
      siteAddress: 'The Camellias, DLF Phase 5, Gurugram',
      materialAmount: _mat,
      labourAmount: _lab,
      supervisionFees: _sup,
      consultingFees: _con,
      totalAmount: _total,
      paidAmount: 0,
      status: WeeklyFeeStatus.calculated,
      whatsappStatus: 'Pending',
      paymentLinkUrl: 'https://pay.homio.in/w/CAM-W36-RS01',
    );
    widget.onCreated(newFee);
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
        width: 780,
        constraints: const BoxConstraints(maxHeight: 740),
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
                      child: const Icon(Icons.calendar_today_outlined,
                          color: AppColors.primary, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Create Weekly Operational Fee Dossier',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w800,
                              )),
                          Text(
                            'Segregated expenditure entries for Material bills, Labour gang wages & Supervision retainer.',
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
                              controller: _customerNameCtrl,
                              decoration: const InputDecoration(
                                labelText: 'Customer Name *',
                                isDense: true,
                                border: OutlineInputBorder(),
                              ),
                              validator: (v) => v!.isEmpty ? 'Required' : null,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // 3-Way Segregated Inputs
                      Text('FEE SEGREGATION CATEGORIES',
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
                              controller: _materialAmountCtrl,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'Material Bills Total (₹) *',
                                isDense: true,
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (_) => setState(() {}),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              controller: _labourAmountCtrl,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'Labour Wages Total (₹) *',
                                isDense: true,
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (_) => setState(() {}),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _supervisionCtrl,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'Supervision Retainer (₹) *',
                                isDense: true,
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (_) => setState(() {}),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              controller: _consultingCtrl,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'Consulting Retainer (₹) *',
                                isDense: true,
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (_) => setState(() {}),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Live Auto-Calculated Summary
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('AUTO-CALCULATED TOTAL',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.primary,
                                    )),
                                Text('Material + Labour + Supervision + Consulting',
                                    style: TextStyle(fontSize: 11)),
                              ],
                            ),
                            Text(
                              '₹${_total.toStringAsFixed(0)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 18,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
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
                      icon: const Icon(Icons.check_rounded, size: 16),
                      label: const Text('Save & Prepare Saturday Dispatch'),
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
