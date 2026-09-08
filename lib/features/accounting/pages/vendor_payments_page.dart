// Homio CRM — Screen 6: Vendor Payables Workspace Connecting to Procurement POs

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../models/accounting_models.dart';
import '../models/accounting_mock_data.dart';
import '../widgets/finance_page_header.dart';
import '../widgets/finance_kpi_card.dart';
import '../widgets/financial_filter_bar.dart';
import '../widgets/financial_status_badge.dart';

class VendorPaymentsPage extends StatefulWidget {
  const VendorPaymentsPage({super.key});

  @override
  State<VendorPaymentsPage> createState() => _VendorPaymentsPageState();
}

class _VendorPaymentsPageState extends State<VendorPaymentsPage> {
  late List<VendorPaymentRecord> _vendorPayments;
  String _searchQuery = '';
  String? _selectedProject;

  @override
  void initState() {
    super.initState();
    _vendorPayments = List.from(AccountingMockData.vendorPayments);
  }

  List<VendorPaymentRecord> get _filteredPayments {
    return _vendorPayments.where((vp) {
      final matchesSearch = _searchQuery.isEmpty ||
          vp.vendorName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          vp.vendorBillNumber.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          vp.poNumber.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          vp.projectName.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesProject =
          _selectedProject == null || vp.projectName == _selectedProject;
      return matchesSearch && matchesProject;
    }).toList();
  }

  double get _totalPayables =>
      _vendorPayments.fold(0.0, (sum, v) => sum + v.billTotal);
  double get _totalPaid =>
      _vendorPayments.fold(0.0, (sum, v) => sum + (v.previousPaid + v.currentPayment));
  double get _totalOutstanding =>
      _vendorPayments.fold(0.0, (sum, v) => sum + v.outstandingAmount);

  void _openCreatePaymentModal() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => _CreateVendorPaymentModal(
        onCreated: (newPay) {
          setState(() {
            _vendorPayments.insert(0, newPay);
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Vendor Payment ${newPay.paymentId} created for ${newPay.vendorName}!'),
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
    final projectList = _vendorPayments.map((v) => v.projectName).toSet().toList();

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: Column(
        children: [
          // 1. Header
          FinancePageHeader(
            title: 'Vendor Payables & PO Settlements',
            subtitle:
                'Manage approved Purchase Order disbursements, supplier bills, bank NEFT/RTGS releases, and vendor statements.',
            icon: Icons.store_mall_directory_rounded,
            primaryActionLabel: 'Create Vendor Payment',
            primaryActionIcon: Icons.add_card_rounded,
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
                            title: 'Total Vendor Bills',
                            value: '₹${_totalPayables.toStringAsFixed(0)}',
                            subtitle: '${_vendorPayments.length} Contracted Supplier POs',
                            icon: Icons.receipt_long_outlined,
                            color: AppColors.primary,
                          ),
                          FinanceKpiCard(
                            title: 'Cleared Disbursements',
                            value: '₹${_totalPaid.toStringAsFixed(0)}',
                            subtitle: 'Released via Bank RTGS/NEFT',
                            icon: Icons.check_circle_outline_rounded,
                            color: AppColors.success,
                          ),
                          FinanceKpiCard(
                            title: 'Outstanding Payables',
                            value: '₹${_totalOutstanding.toStringAsFixed(0)}',
                            subtitle: 'Due upon site QA acceptance',
                            icon: Icons.hourglass_top_rounded,
                            color: AppColors.warning,
                          ),
                          FinanceKpiCard(
                            title: 'Active Suppliers',
                            value: '${_vendorPayments.map((v) => v.vendorId).toSet().length} Hubs',
                            subtitle: 'Century, Austin, Greenply',
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
                    searchHint: 'Search supplier name, PO number, or bill #...',
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
                            DataColumn(label: Text('VENDOR', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11))),
                            DataColumn(label: Text('PROJECT & PO #', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11))),
                            DataColumn(label: Text('BILL #', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11))),
                            DataColumn(label: Text('DUE DATE', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11))),
                            DataColumn(label: Text('TOTAL (₹)', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11))),
                            DataColumn(label: Text('PAID (₹)', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11))),
                            DataColumn(label: Text('OUTSTANDING (₹)', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11))),
                            DataColumn(label: Text('STATUS', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11))),
                            DataColumn(label: Text('ACTIONS', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11))),
                          ],
                          rows: _filteredPayments.map((vp) {
                            return DataRow(
                              cells: [
                                DataCell(Text(vp.paymentId, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: AppColors.primary))),
                                DataCell(
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(vp.vendorName, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                                      Text(vp.vendorCode, style: const TextStyle(fontSize: 10, color: Colors.grey)),
                                    ],
                                  ),
                                ),
                                DataCell(
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(vp.projectName, style: const TextStyle(fontSize: 12)),
                                      Text('Ref PO: ${vp.poNumber}', style: const TextStyle(fontSize: 10, color: AppColors.primary)),
                                    ],
                                  ),
                                ),
                                DataCell(Text(vp.vendorBillNumber, style: const TextStyle(fontSize: 11))),
                                DataCell(Text('${vp.dueDate.day}/${vp.dueDate.month}/${vp.dueDate.year}', style: const TextStyle(fontSize: 11))),
                                DataCell(Text('₹${vp.billTotal.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12))),
                                DataCell(Text('₹${(vp.previousPaid + vp.currentPayment).toStringAsFixed(0)}', style: const TextStyle(fontSize: 12, color: AppColors.success))),
                                DataCell(
                                  Text(
                                    '₹${vp.outstandingAmount.toStringAsFixed(0)}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: vp.outstandingAmount > 0 ? AppColors.warning : AppColors.success,
                                    ),
                                  ),
                                ),
                                DataCell(FinancialStatusBadge.fromVendorPayment(vp.status)),
                                DataCell(
                                  IconButton(
                                    onPressed: () {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('Payment details for ${vp.vendorName} (${vp.poNumber})')),
                                      );
                                    },
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
// Create Vendor Payment Modal
// -----------------------------------------------------------------------------
class _CreateVendorPaymentModal extends StatefulWidget {
  final ValueChanged<VendorPaymentRecord> onCreated;

  const _CreateVendorPaymentModal({required this.onCreated});

  @override
  State<_CreateVendorPaymentModal> createState() => _CreateVendorPaymentModalState();
}

class _CreateVendorPaymentModalState extends State<_CreateVendorPaymentModal> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _vendorNameCtrl =
      TextEditingController(text: 'Austin Plywood Direct');
  final TextEditingController _billNoCtrl =
      TextEditingController(text: 'BILL-AUS-4012');
  final TextEditingController _poNoCtrl =
      TextEditingController(text: 'PO-2026-0094');
  final TextEditingController _amountCtrl =
      TextEditingController(text: '145000');
  final TextEditingController _utrCtrl =
      TextEditingController(text: 'SBIR52026090881290');

  final DateTime _dueDate = DateTime.now().add(const Duration(days: 7));

  @override
  void dispose() {
    _vendorNameCtrl.dispose();
    _billNoCtrl.dispose();
    _poNoCtrl.dispose();
    _amountCtrl.dispose();
    _utrCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      final amt = double.tryParse(_amountCtrl.text) ?? 145000.0;
      final newPay = VendorPaymentRecord(
        id: 'VP-${DateTime.now().millisecondsSinceEpoch}',
        paymentId: 'VP-2026-${DateTime.now().millisecondsSinceEpoch.toString().substring(9)}',
        vendorId: 'VND-002',
        vendorName: _vendorNameCtrl.text,
        vendorCode: 'VND-AUS-02',
        vendorContact: '+91 98222 34567',
        projectId: 'PRJ-OBR-202',
        projectName: 'Oberoi Sky City Penthouse #801',
        customerName: 'Pooja Mehta',
        poNumber: _poNoCtrl.text,
        vendorBillNumber: _billNoCtrl.text,
        billDate: DateTime.now(),
        dueDate: _dueDate,
        billTotal: amt,
        previousPaid: 0,
        currentPayment: amt,
        status: VendorPaymentStatus.paid,
        bankName: 'State Bank of India',
        bankAccountNo: '30291029102',
        utrNumber: _utrCtrl.text,
        paymentDate: DateTime.now(),
        notes: 'Disbursement cleared via Bank RTGS.',
      );

      widget.onCreated(newPay);
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
                    Text('CREATE VENDOR PAYMENT', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
                    IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close_rounded)),
                  ],
                ),
                const Divider(height: 20),

                TextFormField(
                  controller: _vendorNameCtrl,
                  decoration: const InputDecoration(labelText: 'Supplier Name *', isDense: true, border: OutlineInputBorder()),
                  validator: (val) => (val == null || val.isEmpty) ? 'Enter vendor' : null,
                ),
                const SizedBox(height: 14),

                Row(
                  children: [
                    Expanded(child: TextFormField(controller: _poNoCtrl, decoration: const InputDecoration(labelText: 'Purchase Order Ref *', isDense: true, border: OutlineInputBorder()))),
                    const SizedBox(width: 12),
                    Expanded(child: TextFormField(controller: _billNoCtrl, decoration: const InputDecoration(labelText: 'Vendor Bill / Invoice # *', isDense: true, border: OutlineInputBorder()))),
                  ],
                ),
                const SizedBox(height: 14),

                TextFormField(
                  controller: _amountCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Disbursement Amount (₹) *', prefixText: '₹ ', isDense: true, border: OutlineInputBorder()),
                  validator: (val) => (val == null || val.isEmpty) ? 'Enter amount' : null,
                ),
                const SizedBox(height: 14),

                TextFormField(
                  controller: _utrCtrl,
                  decoration: const InputDecoration(labelText: 'Bank RTGS UTR Number *', isDense: true, border: OutlineInputBorder()),
                  validator: (val) => (val == null || val.isEmpty) ? 'Enter UTR' : null,
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
                      label: const Text('Release Vendor Payment'),
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
