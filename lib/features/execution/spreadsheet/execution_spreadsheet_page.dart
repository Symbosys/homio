import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../models/execution_models.dart';
import '../models/execution_mock_data.dart';
import '../widgets/execution_header.dart';
import '../widgets/execution_metric_card.dart';
import '../widgets/ledger_entry_form_modal.dart';

class ExecutionSpreadsheetPage extends StatefulWidget {
  const ExecutionSpreadsheetPage({super.key});

  @override
  State<ExecutionSpreadsheetPage> createState() => _ExecutionSpreadsheetPageState();
}

class _ExecutionSpreadsheetPageState extends State<ExecutionSpreadsheetPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late List<ProjectMaster> _projects;
  String? _selectedProjectId;
  String _searchQuery = '';
  LedgerType _selectedLedgerType = LedgerType.material;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _projects = List.from(ExecutionMockData.projects);
    if (_projects.isNotEmpty) {
      _selectedProjectId = _projects.first.id;
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  ProjectMaster? get _currentProject {
    if (_projects.isEmpty) return null;
    return _projects.firstWhere(
      (p) => p.id == _selectedProjectId,
      orElse: () => _projects.first,
    );
  }

  List<FinancialLedgerEntry> get _filteredLedgerEntries {
    final proj = _currentProject;
    if (proj == null) return [];

    return proj.ledgerEntries.where((e) {
      if (e.type != _selectedLedgerType) return false;
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final match = e.description.toLowerCase().contains(q) ||
            e.vendorOrContractor.toLowerCase().contains(q) ||
            e.referenceCode.toLowerCase().contains(q);
        if (!match) return false;
      }
      return true;
    }).toList();
  }

  void _handleAddLedgerEntry() {
    final proj = _currentProject;
    if (proj == null) return;

    LedgerEntryFormModal.show(
      context: context,
      project: proj,
      initialType: _selectedLedgerType,
      onSubmit: (newEntry) {
        setState(() {
          proj.ledgerEntries.insert(0, newEntry);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ledger entry "${newEntry.referenceCode}" posted successfully!'),
            backgroundColor: AppColors.success,
          ),
        );
      },
    );
  }

  void _handleEditLedgerEntry(FinancialLedgerEntry entry) {
    final proj = _currentProject;
    if (proj == null) return;

    LedgerEntryFormModal.show(
      context: context,
      project: proj,
      initialType: entry.type,
      initialEntry: entry,
      onSubmit: (updated) {
        setState(() {
          final idx = proj.ledgerEntries.indexWhere((e) => e.id == updated.id);
          if (idx != -1) {
            proj.ledgerEntries[idx] = updated;
          }
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ledger entry "${updated.referenceCode}" updated.'),
            backgroundColor: AppColors.primary,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final proj = _currentProject;

    // Financial calculations
    final budget = proj?.totalContractValue ?? 0.0;
    double incurred = 0.0;
    double totalPaid = 0.0;

    if (proj != null) {
      for (final e in proj.ledgerEntries) {
        incurred += e.totalAmount;
        totalPaid += e.paidAmount;
      }
    }
    final remainingFunds = budget - incurred;
    final variance = budget - incurred;

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            ExecutionHeader(
              title: 'Master Project Spreadsheet & Financial Ledgers',
              subtitle: 'Comprehensive tabular WBS execution view, Material, Labour, and Supervision cost ledgers',
              primaryActionLabel: 'New Ledger Entry',
              primaryActionIcon: Icons.post_add,
              onPrimaryAction: _handleAddLedgerEntry,
              searchHint: 'Search tasks, POs, vendors...',
              onSearchChanged: (val) => setState(() => _searchQuery = val),
              actions: [
                OutlinedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Exporting spreadsheet data to Excel (.xlsx)...')),
                    );
                  },
                  icon: const Icon(Icons.table_view_outlined, size: 18),
                  label: const Text('Export Excel'),
                ),
                const SizedBox(width: 8),
                OutlinedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Exporting CSV format...')),
                    );
                  },
                  icon: const Icon(Icons.file_download_outlined, size: 18),
                  label: const Text('Export CSV'),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Top Financial Metric Cards
            Row(
              children: [
                Expanded(
                  child: ExecutionMetricCard(
                    title: 'Total Project Budget',
                    value: '₹${(budget / 100000).toStringAsFixed(2)}L',
                    subtitle: 'Contract order book baseline',
                    icon: Icons.account_balance_outlined,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: ExecutionMetricCard(
                    title: 'Total Incurred Spends',
                    value: '₹${(incurred / 100000).toStringAsFixed(2)}L',
                    subtitle: '₹${(totalPaid / 100000).toStringAsFixed(2)}L disbursed',
                    icon: Icons.receipt_long_outlined,
                    color: AppColors.warning,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: ExecutionMetricCard(
                    title: 'Budget Variance',
                    value: '₹${(variance / 100000).toStringAsFixed(2)}L',
                    subtitle: variance >= 0 ? 'Within approved budget' : 'Budget overrun warning',
                    icon: variance >= 0 ? Icons.trending_up : Icons.trending_down,
                    color: variance >= 0 ? AppColors.success : AppColors.error,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: ExecutionMetricCard(
                    title: 'Remaining Funds',
                    value: '₹${(remainingFunds / 100000).toStringAsFixed(2)}L',
                    subtitle: '${budget > 0 ? ((remainingFunds / budget) * 100).toInt() : 0}% runway left',
                    icon: Icons.savings_outlined,
                    color: AppColors.info,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Project Selector & View Tabs
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCard : AppColors.lightCard,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.apartment, size: 18, color: AppColors.primary),
                  const SizedBox(width: 8),
                  DropdownButton<String>(
                    value: _selectedProjectId,
                    underline: const SizedBox(),
                    items: _projects.map((p) {
                      return DropdownMenuItem(
                        value: p.id,
                        child: Text(
                          '${p.projectName} (${p.projectCode})',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      );
                    }).toList(),
                    onChanged: (v) {
                      if (v != null) setState(() => _selectedProjectId = v);
                    },
                  ),
                  const Spacer(),
                  // Tab Bar for WBS Matrix vs Ledgers
                  TabBar(
                    controller: _tabController,
                    isScrollable: true,
                    tabAlignment: TabAlignment.start,
                    labelColor: AppColors.primary,
                    unselectedLabelColor: isDark ? AppColors.darkMutedText : AppColors.lightMutedText,
                    indicatorColor: AppColors.primary,
                    tabs: const [
                      Tab(icon: Icon(Icons.grid_on, size: 16), text: 'Master WBS Spreadsheet'),
                      Tab(icon: Icon(Icons.account_balance_wallet, size: 16), text: 'Multi-Category Ledgers'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Tab Views
            SizedBox(
              height: 600,
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Tab 1: Master WBS Spreadsheet
                  _buildWbsSpreadsheetTab(proj, isDark, theme),
                  // Tab 2: Sub-Ledgers (Material, Labour, Supervision)
                  _buildLedgersTab(proj, isDark, theme),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWbsSpreadsheetTab(ProjectMaster? proj, bool isDark, ThemeData theme) {
    if (proj == null) return const Center(child: Text('No project selected.'));

    final allTasks = <Map<String, dynamic>>[];
    int counter = 1;
    for (final stream in proj.workStreams) {
      for (final task in stream.tasks) {
        allTasks.add({
          'num': counter++,
          'stream': stream.name,
          'task': task,
        });
      }
    }

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SingleChildScrollView(
            child: DataTable(
              headingRowColor: WidgetStateProperty.all(
                isDark ? AppColors.darkSurface : AppColors.lightSurface,
              ),
              columnSpacing: 20,
              columns: const [
                DataColumn(label: Text('#', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Milestone Stream', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Task Scope & Description', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Start Date', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('End Date', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Assigned Contractor', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Priority', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Progress', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Status', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Delay Audit Reason', style: TextStyle(fontWeight: FontWeight.bold))),
              ],
              rows: allTasks.map((item) {
                final int num = item['num'] as int;
                final String stream = item['stream'] as String;
                final WbsTask task = item['task'] as WbsTask;

                return DataRow(
                  cells: [
                    DataCell(Text('$num', style: const TextStyle(fontWeight: FontWeight.bold))),
                    DataCell(Text(stream, style: const TextStyle(fontWeight: FontWeight.w500))),
                    DataCell(
                      SizedBox(
                        width: 200,
                        child: Text(
                          task.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    DataCell(Text('${task.startDate.day}/${task.startDate.month}/${task.startDate.year}')),
                    DataCell(
                      Text(
                        '${task.endDate.day}/${task.endDate.month}/${task.endDate.year}',
                        style: TextStyle(
                          color: task.isDelayed ? AppColors.error : null,
                          fontWeight: task.isDelayed ? FontWeight.bold : null,
                        ),
                      ),
                    ),
                    DataCell(Text(task.assignedTo)),
                    DataCell(
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: _getPriorityBg(task.priority),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          task.priority.label,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: _getPriorityFg(task.priority),
                          ),
                        ),
                      ),
                    ),
                    DataCell(
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 60,
                            child: LinearProgressIndicator(
                              value: task.progress,
                              minHeight: 5,
                              color: task.progress == 1.0 ? AppColors.success : AppColors.primary,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text('${(task.progress * 100).toInt()}%'),
                        ],
                      ),
                    ),
                    DataCell(
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: task.status == WbsTaskStatus.completed
                              ? AppColors.success.withValues(alpha: 0.15)
                              : (task.status == WbsTaskStatus.delayed
                                  ? AppColors.error.withValues(alpha: 0.15)
                                  : AppColors.primary.withValues(alpha: 0.1)),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          task.status.label,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: task.status == WbsTaskStatus.completed
                                ? AppColors.success
                                : (task.status == WbsTaskStatus.delayed
                                    ? AppColors.error
                                    : AppColors.primary),
                          ),
                        ),
                      ),
                    ),
                    DataCell(
                      SizedBox(
                        width: 180,
                        child: Text(
                          task.delayReason ?? 'On schedule',
                          style: TextStyle(
                            fontSize: 11,
                            fontStyle: task.delayReason != null ? FontStyle.italic : FontStyle.normal,
                            color: task.delayReason != null ? AppColors.error : AppColors.lightMutedText,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLedgersTab(ProjectMaster? proj, bool isDark, ThemeData theme) {
    if (proj == null) return const Center(child: Text('No project selected.'));
    final entries = _filteredLedgerEntries;

    return Column(
      children: [
        // Sub-Ledger Category Switcher (Material, Labour, Supervision)
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCard : AppColors.lightCard,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
            ),
          ),
          child: Row(
            children: [
              Wrap(
                spacing: 10,
                children: LedgerType.values.map((type) {
                  final isSel = _selectedLedgerType == type;
                  return ChoiceChip(
                    label: Text(type.label),
                    selected: isSel,
                    selectedColor: AppColors.primary.withValues(alpha: 0.15),
                    labelStyle: TextStyle(
                      fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                      color: isSel
                          ? AppColors.primary
                          : (isDark ? AppColors.darkText : AppColors.lightText),
                    ),
                    onSelected: (val) {
                      if (val) setState(() => _selectedLedgerType = type);
                    },
                  );
                }).toList(),
              ),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: _handleAddLedgerEntry,
                icon: const Icon(Icons.add, size: 16),
                label: Text('Add ${_selectedLedgerType.label} Entry'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Ledger DataTable
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCard : AppColors.lightCard,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: entries.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.receipt_outlined, size: 40, color: AppColors.primary),
                          const SizedBox(height: 10),
                          Text('No ${_selectedLedgerType.label} records found.'),
                        ],
                      ),
                    )
                  : SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SingleChildScrollView(
                        child: DataTable(
                          headingRowColor: WidgetStateProperty.all(
                            isDark ? AppColors.darkSurface : AppColors.lightSurface,
                          ),
                          columnSpacing: 18,
                          columns: const [
                            DataColumn(label: Text('Ref / PO #', style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('Date', style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('Vendor / Contractor', style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('Description', style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('Qty', style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('Unit Rate', style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('GST %', style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('Gross Total', style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('Paid Amount', style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('Balance Due', style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('Status', style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('Action', style: TextStyle(fontWeight: FontWeight.bold))),
                          ],
                          rows: entries.map((entry) {
                            return DataRow(
                              cells: [
                                DataCell(
                                  Text(
                                    entry.referenceCode,
                                    style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
                                  ),
                                ),
                                DataCell(Text('${entry.entryDate.day}/${entry.entryDate.month}/${entry.entryDate.year}')),
                                DataCell(Text(entry.vendorOrContractor, style: const TextStyle(fontWeight: FontWeight.w500))),
                                DataCell(
                                  SizedBox(
                                    width: 180,
                                    child: Text(
                                      entry.description,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                DataCell(Text('${entry.quantity}')),
                                DataCell(Text('₹${entry.unitPrice.toStringAsFixed(0)}')),
                                DataCell(Text('${entry.taxGstPercentage.toStringAsFixed(0)}%')),
                                DataCell(
                                  Text(
                                    '₹${entry.totalAmount.toStringAsFixed(0)}',
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    '₹${entry.paidAmount.toStringAsFixed(0)}',
                                    style: const TextStyle(color: AppColors.success, fontWeight: FontWeight.w600),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    '₹${entry.balanceDue.toStringAsFixed(0)}',
                                    style: TextStyle(
                                      color: entry.balanceDue > 0 ? AppColors.error : AppColors.lightMutedText,
                                      fontWeight: entry.balanceDue > 0 ? FontWeight.bold : null,
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: entry.paymentStatus == 'Paid'
                                          ? AppColors.success.withValues(alpha: 0.15)
                                          : AppColors.warning.withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      entry.paymentStatus,
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: entry.paymentStatus == 'Paid'
                                            ? AppColors.success
                                            : AppColors.warning,
                                      ),
                                    ),
                                  ),
                                ),
                                DataCell(
                                  IconButton(
                                    icon: const Icon(Icons.edit_outlined, size: 16),
                                    onPressed: () => _handleEditLedgerEntry(entry),
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ),
            ),
          ),
        ),
      ],
    );
  }

  Color _getPriorityBg(TaskPriority p) {
    switch (p) {
      case TaskPriority.critical:
        return AppColors.error.withValues(alpha: 0.15);
      case TaskPriority.high:
        return Colors.deepOrange.withValues(alpha: 0.15);
      case TaskPriority.medium:
        return AppColors.warning.withValues(alpha: 0.15);
      case TaskPriority.low:
        return AppColors.info.withValues(alpha: 0.15);
    }
  }

  Color _getPriorityFg(TaskPriority p) {
    switch (p) {
      case TaskPriority.critical:
        return AppColors.error;
      case TaskPriority.high:
        return Colors.deepOrange;
      case TaskPriority.medium:
        return AppColors.warning;
      case TaskPriority.low:
        return AppColors.info;
    }
  }
}
