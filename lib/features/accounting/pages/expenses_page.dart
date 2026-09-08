// Homio CRM — Screen 5: Operational & Project Expense Workspace

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../models/accounting_models.dart';
import '../models/accounting_mock_data.dart';
import '../widgets/finance_page_header.dart';
import '../widgets/finance_kpi_card.dart';
import '../widgets/financial_filter_bar.dart';
import '../widgets/financial_status_badge.dart';

class ExpensesPage extends StatefulWidget {
  const ExpensesPage({super.key});

  @override
  State<ExpensesPage> createState() => _ExpensesPageState();
}

class _ExpensesPageState extends State<ExpensesPage> {
  late List<ProjectExpense> _expenses;
  String _searchQuery = '';
  String? _selectedProject;
  ExpenseType? _selectedType;

  @override
  void initState() {
    super.initState();
    _expenses = List.from(AccountingMockData.projectExpenses);
  }

  List<ProjectExpense> get _filteredExpenses {
    return _expenses.where((e) {
      final matchesSearch = _searchQuery.isEmpty ||
          e.expenseNumber.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          e.supplierOrPayee.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          e.projectName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          e.description.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesProject =
          _selectedProject == null || e.projectName == _selectedProject;
      final matchesType = _selectedType == null || e.expenseType == _selectedType;
      return matchesSearch && matchesProject && matchesType;
    }).toList();
  }

  double get _totalExpenses =>
      _expenses.fold(0.0, (sum, e) => sum + e.totalAmount);
  double get _materialExpenses => _expenses
      .where((e) => e.expenseType == ExpenseType.material)
      .fold(0.0, (sum, e) => sum + e.totalAmount);
  double get _labourExpenses => _expenses
      .where((e) => e.expenseType == ExpenseType.labour)
      .fold(0.0, (sum, e) => sum + e.totalAmount);
  int get _pendingApprovalCount =>
      _expenses.where((e) => e.status == ExpenseStatus.submitted).length;

  void _openAddExpenseModal() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => _CreateExpenseModal(
        onCreated: (newExp) {
          setState(() {
            _expenses.insert(0, newExp);
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Expense ${newExp.expenseNumber} recorded successfully!'),
              backgroundColor: AppColors.success,
            ),
          );
        },
      ),
    );
  }

  void _openExpenseDetail(ProjectExpense expense) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.receipt_long_rounded, color: AppColors.primary),
            const SizedBox(width: 8),
            Text('Expense ${expense.expenseNumber}'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Payee: ${expense.supplierOrPayee}', style: const TextStyle(fontWeight: FontWeight.w700)),
            Text('Project: ${expense.projectName}'),
            Text('Bill No: ${expense.invoiceOrBillNo ?? "N/A"}'),
            Text('Category: ${expense.expenseType.label}'),
            const Divider(),
            Text('Total Amount: ₹${expense.totalAmount.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
            Text('Paid: ₹${expense.paidAmount.toStringAsFixed(0)}', style: const TextStyle(color: AppColors.success)),
            Text('Outstanding: ₹${expense.outstandingAmount.toStringAsFixed(0)}', style: const TextStyle(color: AppColors.error)),
            const SizedBox(height: 8),
            Text('Remarks: ${expense.remarks}', style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic)),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final projectList = _expenses.map((e) => e.projectName).toSet().toList();

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: Column(
        children: [
          // 1. Header
          FinancePageHeader(
            title: 'Project & Site Expenses',
            subtitle:
                'Track project-centric expenses across materials, labour, design milestones, site consumables, and commercial commissions.',
            icon: Icons.receipt_rounded,
            primaryActionLabel: 'Add Expense Voucher',
            primaryActionIcon: Icons.add_rounded,
            onPrimaryAction: _openAddExpenseModal,
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
                            title: 'Total Project Expenses',
                            value: '₹${_totalExpenses.toStringAsFixed(0)}',
                            subtitle: '${_expenses.length} Vouchers Recorded',
                            icon: Icons.shopping_bag_outlined,
                            color: AppColors.primary,
                            isSelected: _selectedType == null,
                            onTap: () => setState(() => _selectedType = null),
                          ),
                          FinanceKpiCard(
                            title: 'Material Purchases',
                            value: '₹${_materialExpenses.toStringAsFixed(0)}',
                            subtitle: 'Woodwork, hardware & finishes',
                            icon: Icons.inventory_2_outlined,
                            color: const Color(0xFF8B5CF6),
                            isSelected: _selectedType == ExpenseType.material,
                            onTap: () => setState(() => _selectedType = ExpenseType.material),
                          ),
                          FinanceKpiCard(
                            title: 'Labour Disbursements',
                            value: '₹${_labourExpenses.toStringAsFixed(0)}',
                            subtitle: 'Site carpentry, civil & electrical',
                            icon: Icons.engineering_outlined,
                            color: const Color(0xFF0284C7),
                            isSelected: _selectedType == ExpenseType.labour,
                            onTap: () => setState(() => _selectedType = ExpenseType.labour),
                          ),
                          FinanceKpiCard(
                            title: 'Pending PM Approval',
                            value: '$_pendingApprovalCount Pending',
                            subtitle: 'Requires site supervisor verification',
                            icon: Icons.hourglass_top_rounded,
                            color: AppColors.warning,
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
                    searchHint: 'Search voucher #, payee, or description...',
                    selectedProject: _selectedProject,
                    projectList: projectList,
                    onProjectChanged: (val) => setState(() => _selectedProject = val),
                    activeFilterSummary: _selectedType != null ? 'Category: ${_selectedType!.label}' : null,
                    onClearFilters: () => setState(() {
                      _searchQuery = '';
                      _selectedProject = null;
                      _selectedType = null;
                    }),
                  ),
                  const SizedBox(height: 20),

                  // Expenses Table
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
                            DataColumn(label: Text('EXPENSE #', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11))),
                            DataColumn(label: Text('CATEGORY', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11))),
                            DataColumn(label: Text('PAYEE / SUPPLIER', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11))),
                            DataColumn(label: Text('PROJECT & SITE', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11))),
                            DataColumn(label: Text('BILL / INV REF', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11))),
                            DataColumn(label: Text('DATE', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11))),
                            DataColumn(label: Text('TOTAL (₹)', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11))),
                            DataColumn(label: Text('PAID (₹)', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11))),
                            DataColumn(label: Text('STATUS', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11))),
                            DataColumn(label: Text('ACTIONS', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11))),
                          ],
                          rows: _filteredExpenses.map((exp) {
                            return DataRow(
                              cells: [
                                DataCell(
                                  Text(
                                    exp.expenseNumber,
                                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: AppColors.primary),
                                  ),
                                ),
                                DataCell(
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(exp.expenseType.icon, size: 14, color: AppColors.primary),
                                      const SizedBox(width: 6),
                                      Text(exp.expenseType.name.toUpperCase(), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                                    ],
                                  ),
                                ),
                                DataCell(
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(exp.supplierOrPayee, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                                      Text(exp.department, style: const TextStyle(fontSize: 10, color: Colors.grey)),
                                    ],
                                  ),
                                ),
                                DataCell(
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(exp.projectName, style: const TextStyle(fontSize: 12)),
                                      Text(exp.costCentre, style: const TextStyle(fontSize: 10, color: Colors.grey)),
                                    ],
                                  ),
                                ),
                                DataCell(Text(exp.invoiceOrBillNo ?? '—', style: const TextStyle(fontSize: 11))),
                                DataCell(Text('${exp.expenseDate.day}/${exp.expenseDate.month}/${exp.expenseDate.year}', style: const TextStyle(fontSize: 11))),
                                DataCell(Text('₹${exp.totalAmount.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12))),
                                DataCell(Text('₹${exp.paidAmount.toStringAsFixed(0)}', style: const TextStyle(fontSize: 12, color: AppColors.success))),
                                DataCell(FinancialStatusBadge.fromExpense(exp.status)),
                                DataCell(
                                  IconButton(
                                    onPressed: () => _openExpenseDetail(exp),
                                    icon: const Icon(Icons.visibility_rounded, size: 18),
                                    tooltip: 'View Details',
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
// Create Project Expense Modal
// -----------------------------------------------------------------------------
class _CreateExpenseModal extends StatefulWidget {
  final ValueChanged<ProjectExpense> onCreated;

  const _CreateExpenseModal({required this.onCreated});

  @override
  State<_CreateExpenseModal> createState() => _CreateExpenseModalState();
}

class _CreateExpenseModalState extends State<_CreateExpenseModal> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _expenseNoCtrl =
      TextEditingController(text: 'EXP-2026-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}');
  final TextEditingController _payeeCtrl =
      TextEditingController(text: 'Century Wholesale Hub, DLF Phase 2');
  final TextEditingController _billNoCtrl =
      TextEditingController(text: 'BILL-CEN-9921');
  final TextEditingController _descCtrl =
      TextEditingController(text: 'BWP Marine Plywood 19mm sheets for TV Unit');
  final TextEditingController _subtotalCtrl = TextEditingController(text: '125000');
  final TextEditingController _taxCtrl = TextEditingController(text: '22500');

  ExpenseType _type = ExpenseType.material;

  @override
  void dispose() {
    _expenseNoCtrl.dispose();
    _payeeCtrl.dispose();
    _billNoCtrl.dispose();
    _descCtrl.dispose();
    _subtotalCtrl.dispose();
    _taxCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      final sub = double.tryParse(_subtotalCtrl.text) ?? 125000.0;
      final tax = double.tryParse(_taxCtrl.text) ?? 22500.0;
      final total = sub + tax;

      final newExpense = ProjectExpense(
        id: 'EXP-${DateTime.now().millisecondsSinceEpoch}',
        expenseNumber: _expenseNoCtrl.text,
        expenseDate: DateTime.now(),
        expenseType: _type,
        projectId: 'PRJ-CAM-101',
        projectName: 'The Camellias Villa Interior #1402',
        customerId: 'CUST-001',
        customerName: 'Rahul Sharma',
        siteAddress: 'The Camellias, DLF Phase 5, Gurugram',
        department: 'Modular Carpentry',
        costCentre: 'Cost Centre #104',
        description: _descCtrl.text,
        supplierOrPayee: _payeeCtrl.text,
        invoiceOrBillNo: _billNoCtrl.text,
        billDate: DateTime.now(),
        subtotal: sub,
        taxAmount: tax,
        totalAmount: total,
        paidAmount: 0,
        status: ExpenseStatus.submitted,
        remarks: 'Physical invoice verified on site.',
        createdBy: 'Site Supervisor',
      );

      widget.onCreated(newExpense);
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
        width: 680,
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
                    Text('RECORD PROJECT EXPENSE', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
                    IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close_rounded)),
                  ],
                ),
                const Divider(height: 20),

                DropdownButtonFormField<ExpenseType>(
                  initialValue: _type,
                  decoration: const InputDecoration(labelText: 'Expense Category *', isDense: true, border: OutlineInputBorder()),
                  items: ExpenseType.values.map((t) {
                    return DropdownMenuItem(value: t, child: Row(children: [Icon(t.icon, size: 16), const SizedBox(width: 8), Text(t.label)]));
                  }).toList(),
                  onChanged: (val) => setState(() => _type = val!),
                ),
                const SizedBox(height: 14),

                Row(
                  children: [
                    Expanded(child: TextFormField(controller: _expenseNoCtrl, decoration: const InputDecoration(labelText: 'Voucher Number *', isDense: true, border: OutlineInputBorder()))),
                    const SizedBox(width: 12),
                    Expanded(child: TextFormField(controller: _billNoCtrl, decoration: const InputDecoration(labelText: 'Supplier Bill / Invoice # *', isDense: true, border: OutlineInputBorder()))),
                  ],
                ),
                const SizedBox(height: 14),

                TextFormField(
                  controller: _payeeCtrl,
                  decoration: const InputDecoration(labelText: 'Supplier / Payee Name *', isDense: true, border: OutlineInputBorder()),
                  validator: (val) => (val == null || val.isEmpty) ? 'Enter payee' : null,
                ),
                const SizedBox(height: 14),

                TextFormField(
                  controller: _descCtrl,
                  decoration: const InputDecoration(labelText: 'Description / Scope *', isDense: true, border: OutlineInputBorder()),
                  validator: (val) => (val == null || val.isEmpty) ? 'Enter description' : null,
                ),
                const SizedBox(height: 14),

                Row(
                  children: [
                    Expanded(child: TextFormField(controller: _subtotalCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Subtotal (₹) *', prefixText: '₹ ', isDense: true, border: OutlineInputBorder()))),
                    const SizedBox(width: 12),
                    Expanded(child: TextFormField(controller: _taxCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'GST Tax (₹)', prefixText: '₹ ', isDense: true, border: OutlineInputBorder()))),
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
                      label: const Text('Submit Expense Voucher'),
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
