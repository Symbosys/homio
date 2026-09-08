// Homio CRM — Screen 2: Customer Ledgers Workspace with 4-Way Cost Segregation

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../models/accounting_models.dart';
import '../models/accounting_mock_data.dart';
import '../widgets/finance_page_header.dart';
import '../widgets/finance_kpi_card.dart';
import '../widgets/financial_filter_bar.dart';
import '../widgets/customer_statement_modal.dart';

class CustomerLedgersPage extends StatefulWidget {
  const CustomerLedgersPage({super.key});

  @override
  State<CustomerLedgersPage> createState() => _CustomerLedgersPageState();
}

class _CustomerLedgersPageState extends State<CustomerLedgersPage> {
  late List<CustomerLedgerDetailModel> _ledgers;
  String _searchQuery = '';
  String? _selectedProject;

  @override
  void initState() {
    super.initState();
    _ledgers = List.from(AccountingMockData.customerLedgers);
  }

  List<CustomerLedgerDetailModel> get _filteredLedgers {
    return _ledgers.where((l) {
      final matchesSearch = _searchQuery.isEmpty ||
          l.customerName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          l.customerId.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          l.activeProjectName.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesProject =
          _selectedProject == null || l.activeProjectName == _selectedProject;
      return matchesSearch && matchesProject;
    }).toList();
  }

  double get _totalPortfolioValue =>
      _ledgers.fold(0.0, (sum, l) => sum + l.totalContractValue);
  double get _totalCollected =>
      _ledgers.fold(0.0, (sum, l) => sum + l.totalCollected);
  double get _totalOutstanding =>
      _ledgers.fold(0.0, (sum, l) => sum + l.totalOutstanding);
  double get _totalOverdue =>
      _ledgers.fold(0.0, (sum, l) => sum + l.overdueAmount);

  void _openCustomerDetail(CustomerLedgerDetailModel ledger) {
    showDialog(
      context: context,
      builder: (ctx) => _CustomerLedgerDetailModal(
        ledger: ledger,
        onOpenStatement: () => _openStatementModal(ledger),
      ),
    );
  }

  void _openStatementModal(CustomerLedgerDetailModel ledger) {
    showDialog(
      context: context,
      builder: (_) => CustomerStatementModal(
        ledger: ledger,
        onDownloadPdf: () {},
        onDownloadExcel: () {},
        onShareWhatsApp: () {},
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final projectList = _ledgers.map((l) => l.activeProjectName).toSet().toList();

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: Column(
        children: [
          // 1. Header
          FinancePageHeader(
            title: 'Customer Ledgers',
            subtitle:
                'Customer-wise financial position across projects, material, labour, consulting, supervision and outstanding dues.',
            icon: Icons.menu_book_rounded,
            primaryActionLabel: 'Generate All Statements',
            primaryActionIcon: Icons.summarize_rounded,
            onPrimaryAction: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Generating batch customer account statements...')),
              );
            },
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
                            title: 'Active Client Accounts',
                            value: '${_ledgers.length}',
                            subtitle: 'Portfolio Value: ₹${_totalPortfolioValue.toStringAsFixed(0)}',
                            icon: Icons.groups_rounded,
                            color: AppColors.primary,
                          ),
                          FinanceKpiCard(
                            title: 'Total Invoiced Realization',
                            value: '₹${_totalCollected.toStringAsFixed(0)}',
                            subtitle: 'Cleared into bank accounts',
                            icon: Icons.check_circle_outline_rounded,
                            color: AppColors.success,
                          ),
                          FinanceKpiCard(
                            title: 'Receivables Outstanding',
                            value: '₹${_totalOutstanding.toStringAsFixed(0)}',
                            subtitle: 'Pending milestone payment releases',
                            icon: Icons.hourglass_top_rounded,
                            color: AppColors.warning,
                          ),
                          FinanceKpiCard(
                            title: 'Critical Overdue Amount',
                            value: '₹${_totalOverdue.toStringAsFixed(0)}',
                            subtitle: 'Past payment due dates',
                            icon: Icons.warning_amber_rounded,
                            color: AppColors.error,
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 24),

                  // Search & Filter Toolbar
                  FinancialFilterBar(
                    searchQuery: _searchQuery,
                    onSearchChanged: (val) => setState(() => _searchQuery = val),
                    searchHint: 'Search customer name, ID, or project...',
                    selectedProject: _selectedProject,
                    projectList: projectList,
                    onProjectChanged: (val) => setState(() => _selectedProject = val),
                    onClearFilters: () => setState(() {
                      _searchQuery = '';
                      _selectedProject = null;
                    }),
                  ),
                  const SizedBox(height: 20),

                  // Customer Ledgers Table
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
                            DataColumn(label: Text('CUSTOMER', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11))),
                            DataColumn(label: Text('PROJECT & PM', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11))),
                            DataColumn(label: Text('CONTRACT (₹)', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11))),
                            DataColumn(label: Text('INVOICED', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11))),
                            DataColumn(label: Text('COLLECTED', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11))),
                            DataColumn(label: Text('MATERIAL (P / U)', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11))),
                            DataColumn(label: Text('LABOUR (P / U)', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11))),
                            DataColumn(label: Text('FEES (CONS / SUP)', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11))),
                            DataColumn(label: Text('OUTSTANDING', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11))),
                            DataColumn(label: Text('OVERDUE', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11))),
                            DataColumn(label: Text('STATUS', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11))),
                            DataColumn(label: Text('ACTIONS', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11))),
                          ],
                          rows: _filteredLedgers.map((l) {
                            return DataRow(
                              cells: [
                                DataCell(
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(l.customerName, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                                      Text('${l.customerId} • ${l.customerPhone}', style: const TextStyle(fontSize: 10, color: Colors.grey)),
                                    ],
                                  ),
                                ),
                                DataCell(
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(l.activeProjectName, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                                      Text('PM: ${l.projectManager}', style: const TextStyle(fontSize: 10, color: Colors.grey)),
                                    ],
                                  ),
                                ),
                                DataCell(Text('₹${l.totalContractValue.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12))),
                                DataCell(Text('₹${l.totalInvoiced.toStringAsFixed(0)}', style: const TextStyle(fontSize: 12))),
                                DataCell(
                                  Text(
                                    '₹${l.totalCollected.toStringAsFixed(0)} (${l.collectionPercentage.toStringAsFixed(0)}%)',
                                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.success),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    '₹${l.materialPaid.toStringAsFixed(0)} / ₹${l.materialUnpaid.toStringAsFixed(0)}',
                                    style: const TextStyle(fontSize: 11),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    '₹${l.labourPaid.toStringAsFixed(0)} / ₹${l.labourUnpaid.toStringAsFixed(0)}',
                                    style: const TextStyle(fontSize: 11),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    '₹${l.consultingPaid.toStringAsFixed(0)} / ₹${l.supervisionPaid.toStringAsFixed(0)}',
                                    style: const TextStyle(fontSize: 11),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    '₹${l.totalOutstanding.toStringAsFixed(0)}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: l.totalOutstanding > 0 ? AppColors.warning : AppColors.success,
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    '₹${l.overdueAmount.toStringAsFixed(0)}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w800,
                                      color: l.overdueAmount > 0 ? AppColors.error : Colors.grey,
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: (l.accountStatus == FinancialHealth.healthy
                                              ? AppColors.success
                                              : (l.accountStatus == FinancialHealth.warning ? AppColors.warning : AppColors.error))
                                          .withValues(alpha: 0.12),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      l.accountStatus.name.toUpperCase(),
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w800,
                                        color: l.accountStatus == FinancialHealth.healthy
                                            ? AppColors.success
                                            : (l.accountStatus == FinancialHealth.warning ? AppColors.warning : AppColors.error),
                                      ),
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        onPressed: () => _openCustomerDetail(l),
                                        icon: const Icon(Icons.visibility_rounded, size: 18),
                                        tooltip: 'View Full Ledger & Segregations',
                                      ),
                                      IconButton(
                                        onPressed: () => _openStatementModal(l),
                                        icon: const Icon(Icons.picture_as_pdf_outlined, size: 18, color: AppColors.primary),
                                        tooltip: 'Account Statement',
                                      ),
                                    ],
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
// Detailed Customer Ledger Modal with 4-Way Cost Segregation Tabs
// -----------------------------------------------------------------------------
class _CustomerLedgerDetailModal extends StatelessWidget {
  final CustomerLedgerDetailModel ledger;
  final VoidCallback onOpenStatement;

  const _CustomerLedgerDetailModal({
    required this.ledger,
    required this.onOpenStatement,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: DefaultTabController(
        length: 5,
        child: Container(
          width: 920,
          height: 640,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'CUSTOMER FINANCIAL DOSSIER',
                        style: theme.textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.6,
                          color: AppColors.primary,
                        ),
                      ),
                      Text(
                        ledger.customerName,
                        style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                      ),
                      Text(
                        '${ledger.customerId} • ${ledger.activeProjectName}',
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      FilledButton.icon(
                        onPressed: onOpenStatement,
                        icon: const Icon(Icons.summarize_rounded, size: 16),
                        label: const Text('Statement of Account', style: TextStyle(fontSize: 12)),
                      ),
                      const SizedBox(width: 12),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close_rounded, size: 20),
                      ),
                    ],
                  ),
                ],
              ),
              const Divider(height: 20),

              // Tab Bar
              const TabBar(
                isScrollable: true,
                tabs: [
                  Tab(text: 'Financial Overview'),
                  Tab(text: 'Transactions Ledger'),
                  Tab(text: 'Material Payments'),
                  Tab(text: 'Labour Payments'),
                  Tab(text: 'Consulting & Supervision'),
                ],
              ),
              const SizedBox(height: 16),

              // Tab Views
              Expanded(
                child: TabBarView(
                  children: [
                    // Tab 1: Overview & 4-way Segregation
                    SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(child: _buildSegCard('Material Payments', ledger.materialPaid, ledger.materialUnpaid, AppColors.primary)),
                              const SizedBox(width: 12),
                              Expanded(child: _buildSegCard('Labour Payments', ledger.labourPaid, ledger.labourUnpaid, const Color(0xFF8B5CF6))),
                              const SizedBox(width: 12),
                              Expanded(child: _buildSegCard('Consulting Fees', ledger.consultingPaid, ledger.consultingUnpaid, const Color(0xFF0284C7))),
                              const SizedBox(width: 12),
                              Expanded(child: _buildSegCard('Supervision Fees', ledger.supervisionPaid, ledger.supervisionUnpaid, const Color(0xFFD97706))),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: isDark ? AppColors.darkSurfaceElevated : AppColors.lightSurfaceSubtle,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('CLIENT BILLING PROFILE & CONTRACT DETAILS', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                                const SizedBox(height: 8),
                                Text('Billing Address: ${ledger.billingAddress}', style: const TextStyle(fontSize: 12)),
                                Text('Contract Model: ${ledger.contractModel}', style: const TextStyle(fontSize: 12)),
                                Text('Project Manager: ${ledger.projectManager}', style: const TextStyle(fontSize: 12)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Tab 2: Transactions Ledger
                    ledger.transactions.isEmpty
                        ? const Center(child: Text('No historical ledger transactions logged yet.'))
                        : ListView.separated(
                            itemCount: ledger.transactions.length,
                            separatorBuilder: (_, _) => const Divider(height: 1),
                            itemBuilder: (context, idx) {
                              final tx = ledger.transactions[idx];
                              return ListTile(
                                dense: true,
                                title: Text(tx.description, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                                subtitle: Text('${tx.reference} • ${tx.type} • ${tx.date.day}/${tx.date.month}/${tx.date.year}'),
                                trailing: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      tx.credit > 0 ? '+₹${tx.credit.toStringAsFixed(0)}' : '-₹${tx.debit.toStringAsFixed(0)}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 13,
                                        color: tx.credit > 0 ? AppColors.success : AppColors.error,
                                      ),
                                    ),
                                    Text('Bal: ₹${tx.balance.toStringAsFixed(0)}', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                                  ],
                                ),
                              );
                            },
                          ),

                    // Tab 3: Material
                    _buildSublist('Material Purchases', [
                      'Century Marine Plywood 19mm — ₹1,86,695 (Paid)',
                      'Austin Birch Architectural Veneer — ₹2,45,000 (Approved)',
                    ]),

                    // Tab 4: Labour
                    _buildSublist('Labour Disbursals', [
                      'Nooruddin Carpentry Team (Milestone 2) — ₹66,600 (Disbursed)',
                      'Ramesh Electrical Lighting Work — ₹37,900 (Pending PM)',
                    ]),

                    // Tab 5: Consulting & Supervision
                    _buildSublist('Fee Collection Logs', [
                      'Architectural 3D & VR Consulting — ₹3,50,000 (Cleared)',
                      'Weekly Site PMC Supervision Fee — ₹3,00,000 (Cleared)',
                    ]),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSegCard(String title, double paid, double unpaid, Color color) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: color)),
          const SizedBox(height: 8),
          Text('Paid: ₹${paid.toStringAsFixed(0)}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.success)),
          Text('Unpaid: ₹${unpaid.toStringAsFixed(0)}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.error)),
          const Divider(height: 12),
          Text('Total: ₹${(paid + unpaid).toStringAsFixed(0)}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }

  Widget _buildSublist(String heading, List<String> items) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (ctx, i) {
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 6),
          child: ListTile(
            leading: const Icon(Icons.receipt_rounded, size: 20),
            title: Text(items[i], style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
          ),
        );
      },
    );
  }
}
