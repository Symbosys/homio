// Homio CRM — Screen 8: Commercial Commissions & Revenue Share Workspace

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../models/accounting_models.dart';
import '../models/accounting_mock_data.dart';
import '../widgets/finance_page_header.dart';
import '../widgets/finance_kpi_card.dart';
import '../widgets/financial_filter_bar.dart';
import '../widgets/financial_status_badge.dart';

class CommissionsPage extends StatefulWidget {
  const CommissionsPage({super.key});

  @override
  State<CommissionsPage> createState() => _CommissionsPageState();
}

class _CommissionsPageState extends State<CommissionsPage> {
  late List<CommissionRecord> _commissions;
  String _searchQuery = '';
  CommissionType? _selectedType;

  @override
  void initState() {
    super.initState();
    _commissions = List.from(AccountingMockData.commissions);
  }

  List<CommissionRecord> get _filteredCommissions {
    return _commissions.where((c) {
      final matchesSearch = _searchQuery.isEmpty ||
          c.commissionId.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          c.recipientName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          c.projectName.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesType = _selectedType == null || c.type == _selectedType;
      return matchesSearch && matchesType;
    }).toList();
  }

  double get _totalCommissions =>
      _commissions.fold(0.0, (sum, c) => sum + c.commissionAmount);
  double get _totalPaid =>
      _commissions.fold(0.0, (sum, c) => sum + c.paidAmount);
  double get _totalPending => _totalCommissions - _totalPaid;

  void _openCreateCommissionModal() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => _CreateCommissionModal(
        onCreated: (newComm) {
          setState(() {
            _commissions.insert(0, newComm);
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Commission rule ${newComm.commissionId} saved for ${newComm.recipientName}!'),
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
          FinancePageHeader(
            title: 'Commercial Commissions & Incentives',
            subtitle:
                'Track configurable commissions across Sales incentives, Vendor volume kickbacks, Contractor margins, and AI Designer revenue share.',
            icon: Icons.monetization_on_outlined,
            primaryActionLabel: 'Create Commission Rule',
            primaryActionIcon: Icons.add_rounded,
            onPrimaryAction: _openCreateCommissionModal,
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
                            title: 'Total Commission Accruals',
                            value: '₹${_totalCommissions.toStringAsFixed(0)}',
                            subtitle: '${_commissions.length} Active Commission Agreements',
                            icon: Icons.account_balance_wallet_outlined,
                            color: AppColors.primary,
                          ),
                          FinanceKpiCard(
                            title: 'Disbursed Incentives',
                            value: '₹${_totalPaid.toStringAsFixed(0)}',
                            subtitle: 'Settled to reps & partners',
                            icon: Icons.check_circle_outline_rounded,
                            color: AppColors.success,
                          ),
                          FinanceKpiCard(
                            title: 'Payable Balance',
                            value: '₹${_totalPending.toStringAsFixed(0)}',
                            subtitle: 'Due upon customer milestone clearance',
                            icon: Icons.hourglass_top_rounded,
                            color: AppColors.warning,
                          ),
                          FinanceKpiCard(
                            title: 'Beneficiary Channels',
                            value: '${_commissions.map((c) => c.type).toSet().length} Channels',
                            subtitle: 'Sales, Vendors, AI Studio Pool',
                            icon: Icons.hub_rounded,
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
                    searchHint: 'Search recipient name, project, or commission ID...',
                    activeFilterSummary: _selectedType != null ? 'Channel: ${_selectedType!.label}' : null,
                    onClearFilters: () => setState(() {
                      _searchQuery = '';
                      _selectedType = null;
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
                            DataColumn(label: Text('COMMISSION ID', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11))),
                            DataColumn(label: Text('CHANNEL', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11))),
                            DataColumn(label: Text('RECIPIENT', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11))),
                            DataColumn(label: Text('SOURCE TXN', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11))),
                            DataColumn(label: Text('PROJECT & CLIENT', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11))),
                            DataColumn(label: Text('BASE (₹)', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11))),
                            DataColumn(label: Text('RATE', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11))),
                            DataColumn(label: Text('COMMISSION (₹)', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11))),
                            DataColumn(label: Text('STATUS', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11))),
                            DataColumn(label: Text('ACTIONS', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11))),
                          ],
                          rows: _filteredCommissions.map((c) {
                            return DataRow(
                              cells: [
                                DataCell(Text(c.commissionId, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: AppColors.primary))),
                                DataCell(
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(c.type.icon, size: 14, color: AppColors.primary),
                                      const SizedBox(width: 6),
                                      Text(c.type.name.toUpperCase(), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                                    ],
                                  ),
                                ),
                                DataCell(
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(c.recipientName, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                                      Text(c.recipientType, style: const TextStyle(fontSize: 10, color: Colors.grey)),
                                    ],
                                  ),
                                ),
                                DataCell(Text('${c.sourceTransactionType}: ${c.sourceTransactionId}', style: const TextStyle(fontSize: 11))),
                                DataCell(
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(c.projectName, style: const TextStyle(fontSize: 12)),
                                      Text(c.customerName, style: const TextStyle(fontSize: 10, color: Colors.grey)),
                                    ],
                                  ),
                                ),
                                DataCell(Text('₹${c.baseAmount.toStringAsFixed(0)}', style: const TextStyle(fontSize: 12))),
                                DataCell(Text('${c.commissionRate}%', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12))),
                                DataCell(Text('₹${c.commissionAmount.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12, color: AppColors.primary))),
                                DataCell(FinancialStatusBadge.fromCommission(c.status)),
                                DataCell(
                                  IconButton(
                                    onPressed: () {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('Commission details for ${c.recipientName}')),
                                      );
                                    },
                                    icon: const Icon(Icons.visibility_rounded, size: 18),
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
// Create Commission Modal
// -----------------------------------------------------------------------------
class _CreateCommissionModal extends StatefulWidget {
  final ValueChanged<CommissionRecord> onCreated;

  const _CreateCommissionModal({required this.onCreated});

  @override
  State<_CreateCommissionModal> createState() => _CreateCommissionModalState();
}

class _CreateCommissionModalState extends State<_CreateCommissionModal> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _recipientCtrl =
      TextEditingController(text: 'Arjun Kapoor (Senior Sales Rep)');
  final TextEditingController _baseAmountCtrl =
      TextEditingController(text: '1500000');
  final TextEditingController _rateCtrl =
      TextEditingController(text: '2.5');
  final TextEditingController _sourceTxnCtrl =
      TextEditingController(text: 'INV-2026-1024');

  CommissionType _type = CommissionType.sales;

  @override
  void dispose() {
    _recipientCtrl.dispose();
    _baseAmountCtrl.dispose();
    _rateCtrl.dispose();
    _sourceTxnCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      final base = double.tryParse(_baseAmountCtrl.text) ?? 1500000.0;
      final rate = double.tryParse(_rateCtrl.text) ?? 2.5;
      final commAmt = base * (rate / 100);

      final newComm = CommissionRecord(
        id: 'COM-${DateTime.now().millisecondsSinceEpoch}',
        commissionId: 'COM-2026-${DateTime.now().millisecondsSinceEpoch.toString().substring(9)}',
        type: _type,
        recipientName: _recipientCtrl.text,
        recipientType: 'Sales Executive',
        recipientId: 'EMP-SAL-NEW',
        sourceTransactionType: 'Invoice',
        sourceTransactionId: _sourceTxnCtrl.text,
        projectId: 'PRJ-CAM-101',
        projectName: 'The Camellias Villa Interior #1402',
        customerName: 'Rahul Sharma',
        baseAmount: base,
        commissionRate: rate,
        commissionAmount: commAmt,
        effectiveDate: DateTime.now(),
        dueDate: DateTime.now().add(const Duration(days: 30)),
        status: CommissionStatus.approved,
      );

      widget.onCreated(newComm);
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
        width: 600,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('NEW COMMERCIAL COMMISSION AGREEMENT', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
                  IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close_rounded)),
                ],
              ),
              const Divider(height: 20),

              DropdownButtonFormField<CommissionType>(
                initialValue: _type,
                decoration: const InputDecoration(labelText: 'Commission Channel *', isDense: true, border: OutlineInputBorder()),
                items: CommissionType.values.map((t) {
                  return DropdownMenuItem(value: t, child: Row(children: [Icon(t.icon, size: 16), const SizedBox(width: 8), Text(t.label)]));
                }).toList(),
                onChanged: (val) => setState(() => _type = val!),
              ),
              const SizedBox(height: 14),

              TextFormField(
                controller: _recipientCtrl,
                decoration: const InputDecoration(labelText: 'Beneficiary Name & Role *', isDense: true, border: OutlineInputBorder()),
                validator: (val) => (val == null || val.isEmpty) ? 'Enter recipient' : null,
              ),
              const SizedBox(height: 14),

              TextFormField(
                controller: _sourceTxnCtrl,
                decoration: const InputDecoration(labelText: 'Source Transaction Ref (Invoice/PO) *', isDense: true, border: OutlineInputBorder()),
                validator: (val) => (val == null || val.isEmpty) ? 'Enter source ref' : null,
              ),
              const SizedBox(height: 14),

              Row(
                children: [
                  Expanded(child: TextFormField(controller: _baseAmountCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Base Transaction Amount (₹) *', prefixText: '₹ ', isDense: true, border: OutlineInputBorder()))),
                  const SizedBox(width: 12),
                  Expanded(child: TextFormField(controller: _rateCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Commission Rate (%) *', suffixText: '%', isDense: true, border: OutlineInputBorder()))),
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
                    label: const Text('Accrue Commission'),
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
