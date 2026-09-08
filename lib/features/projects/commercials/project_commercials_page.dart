import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../data/projects_repository.dart';
import '../domain/projects_enums.dart';
import '../domain/projects_models.dart';
import '../widgets/project_page_header.dart';
import '../widgets/project_kpi_card.dart';
import '../widgets/project_shared_widgets.dart';

/// Project Commercials page — financial dashboard tracking contract sum,
/// material/labour expenses, payments, cash flow, and gross margins.
class ProjectCommercialsPage extends StatefulWidget {
  const ProjectCommercialsPage({super.key});

  @override
  State<ProjectCommercialsPage> createState() => _ProjectCommercialsPageState();
}

class _ProjectCommercialsPageState extends State<ProjectCommercialsPage> with SingleTickerProviderStateMixin {
  final _repo = ProjectsRepository();
  String? _selectedProjectId;
  late TabController _tabController;
  String _searchQuery = '';
  bool _isLoading = true;

  final _tabs = const ['Materials', 'Labour', 'Professional Fees', 'Client Payments'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) setState(() {});
    });

    final active = _repo.projects.where((p) => p.status.isActive).toList();
    if (active.isNotEmpty) {
      _selectedProjectId = active.first.id;
    } else if (_repo.projects.isNotEmpty) {
      _selectedProjectId = _repo.projects.first.id;
    }
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) setState(() => _isLoading = false);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final pid = _selectedProjectId ?? (_repo.projects.isNotEmpty ? _repo.projects.first.id : '');
    final summary = _repo.getCommercialSummary(pid);

    final materials = _repo.getMaterialExpensesForProject(pid);
    final labours = _repo.getLabourExpensesForProject(pid);
    final fees = _repo.getFeeRecordsForProject(pid);
    final payments = _repo.getPaymentsForProject(pid);

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SafeArea(
        child: Column(
          children: [
            ProjectPageHeader(
              title: 'Project Commercials',
              subtitle: 'Contract waterfall, vendor payables, site expenses & margin control',
              icon: Icons.account_balance_wallet_outlined,
              actions: [
                _buildProjectSelector(isDark),
                const SizedBox(width: 8),
                OutlinedButton.icon(
                  onPressed: () => _showAddExpenseDialog(context, isDark),
                  icon: const Icon(Icons.receipt_long_outlined, size: 16),
                  label: const Text('Add Expense'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: BorderSide(color: AppColors.primary.withValues(alpha: 0.5)),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: () => _showRecordPaymentDialog(context, isDark),
                  icon: const Icon(Icons.add_card_rounded, size: 16),
                  label: const Text('Record Payment'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ],
            ),
            Expanded(
              child: _isLoading
                  ? _buildLoadingSkeleton(isDark)
                  : RefreshIndicator(
                      onRefresh: () async => setState(() {}),
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Financial Waterfall KPI Row
                            Row(
                              children: [
                                Expanded(
                                  child: ProjectKpiCard(
                                    label: 'Revised Contract',
                                    value: '₹${(summary.revisedContract / 100000).toStringAsFixed(2)}L',
                                    icon: Icons.description_outlined,
                                    iconColor: AppColors.primary,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: ProjectKpiCard(
                                    label: 'Received (${((summary.totalReceived / (summary.revisedContract > 0 ? summary.revisedContract : 1)) * 100).toStringAsFixed(0)}%)',
                                    value: '₹${(summary.totalReceived / 100000).toStringAsFixed(2)}L',
                                    icon: Icons.check_circle_outline_rounded,
                                    iconColor: AppColors.success,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: ProjectKpiCard(
                                    label: 'Outstanding Due',
                                    value: '₹${(summary.totalOutstanding / 100000).toStringAsFixed(2)}L',
                                    icon: Icons.pending_outlined,
                                    iconColor: AppColors.warning,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: ProjectKpiCard(
                                    label: 'Total Expenses',
                                    value: '₹${(summary.totalExpenses / 100000).toStringAsFixed(2)}L',
                                    icon: Icons.payments_outlined,
                                    iconColor: AppColors.error,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: ProjectKpiCard(
                                    label: 'Gross Margin',
                                    value: '${summary.grossMargin.toStringAsFixed(1)}%',
                                    icon: Icons.trending_up_rounded,
                                    iconColor: summary.grossMargin >= 25 ? AppColors.success : AppColors.secondary,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),

                            // Tabs Header & Search
                            Row(
                              children: [
                                Container(
                                  height: 38,
                                  decoration: BoxDecoration(
                                    color: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                                  ),
                                  child: TabBar(
                                    controller: _tabController,
                                    isScrollable: true,
                                    indicatorColor: AppColors.primary,
                                    indicatorWeight: 2,
                                    labelColor: AppColors.primary,
                                    unselectedLabelColor: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                                    labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                                    tabs: _tabs.map((t) => Tab(text: t)).toList(),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Container(
                                    height: 38,
                                    decoration: BoxDecoration(
                                      color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                                    ),
                                    child: TextField(
                                      onChanged: (v) => setState(() => _searchQuery = v),
                                      style: TextStyle(fontSize: 13, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                                      decoration: InputDecoration(
                                        hintText: 'Search records...',
                                        hintStyle: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                                        prefixIcon: Icon(Icons.search_rounded, size: 18, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                                        border: InputBorder.none,
                                        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // Tab view bodies
                            if (_tabController.index == 0)
                              _buildMaterialsTable(materials, isDark)
                            else if (_tabController.index == 1)
                              _buildLabourTable(labours, isDark)
                            else if (_tabController.index == 2)
                              _buildFeesTable(fees, isDark)
                            else
                              _buildPaymentsTable(payments, isDark),
                          ],
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMaterialsTable(List<MaterialExpense> items, bool isDark) {
    var filtered = items;
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      filtered = filtered.where((m) =>
          m.vendor.toLowerCase().contains(q) ||
          m.material.toLowerCase().contains(q) ||
          m.invoiceNumber.toLowerCase().contains(q)).toList();
    }

    if (filtered.isEmpty) {
      return const ProjectEmptyState(
        title: 'No material expenses recorded',
        description: 'Click "Add Expense" to record vendor bills and materials.',
        icon: Icons.inventory_2_outlined,
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowColor: WidgetStateProperty.all(isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle),
          columns: const [
            DataColumn(label: Text('Date', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700))),
            DataColumn(label: Text('Vendor', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700))),
            DataColumn(label: Text('Material / Item', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700))),
            DataColumn(label: Text('Invoice #', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700))),
            DataColumn(label: Text('Amount', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700))),
            DataColumn(label: Text('Paid', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700))),
            DataColumn(label: Text('Due', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700))),
            DataColumn(label: Text('Status', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700))),
          ],
          rows: filtered.map((m) {
            return DataRow(
              cells: [
                DataCell(Text(_formatDate(m.date), style: const TextStyle(fontSize: 12))),
                DataCell(Text(m.vendor, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600))),
                DataCell(Text(m.material, style: const TextStyle(fontSize: 12))),
                DataCell(Text(m.invoiceNumber, style: const TextStyle(fontSize: 12))),
                DataCell(Text('₹${m.amount.toStringAsFixed(0)}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600))),
                DataCell(Text('₹${m.paid.toStringAsFixed(0)}', style: const TextStyle(fontSize: 12, color: AppColors.success))),
                DataCell(Text('₹${m.due.toStringAsFixed(0)}', style: TextStyle(fontSize: 12, color: m.due > 0 ? AppColors.error : null))),
                DataCell(PaymentStatusBadge(status: m.paymentStatus, compact: true)),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildLabourTable(List<LabourExpense> items, bool isDark) {
    var filtered = items;
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      filtered = filtered.where((l) =>
          l.labourName.toLowerCase().contains(q) ||
          l.work.toLowerCase().contains(q)).toList();
    }

    if (filtered.isEmpty) {
      return const ProjectEmptyState(
        title: 'No labour expenses recorded',
        description: 'Click "Add Expense" to log contractor and labour payouts.',
        icon: Icons.engineering_outlined,
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowColor: WidgetStateProperty.all(isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle),
          columns: const [
            DataColumn(label: Text('Date', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700))),
            DataColumn(label: Text('Contractor / Labour', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700))),
            DataColumn(label: Text('Work Description', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700))),
            DataColumn(label: Text('Amount', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700))),
            DataColumn(label: Text('Paid', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700))),
            DataColumn(label: Text('Due', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700))),
            DataColumn(label: Text('Status', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700))),
          ],
          rows: filtered.map((l) {
            return DataRow(
              cells: [
                DataCell(Text(_formatDate(l.date), style: const TextStyle(fontSize: 12))),
                DataCell(Text(l.labourName, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600))),
                DataCell(Text(l.work, style: const TextStyle(fontSize: 12))),
                DataCell(Text('₹${l.amount.toStringAsFixed(0)}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600))),
                DataCell(Text('₹${l.paid.toStringAsFixed(0)}', style: const TextStyle(fontSize: 12, color: AppColors.success))),
                DataCell(Text('₹${l.due.toStringAsFixed(0)}', style: TextStyle(fontSize: 12, color: l.due > 0 ? AppColors.error : null))),
                DataCell(PaymentStatusBadge(status: l.paymentStatus, compact: true)),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildFeesTable(List<FeeRecord> items, bool isDark) {
    if (items.isEmpty) {
      return const ProjectEmptyState(
        title: 'No professional fees recorded',
        description: 'Consulting, architectural & supervision fees will appear here.',
        icon: Icons.design_services_outlined,
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowColor: WidgetStateProperty.all(isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle),
          columns: const [
            DataColumn(label: Text('Date', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700))),
            DataColumn(label: Text('Fee Type', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700))),
            DataColumn(label: Text('Received By', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700))),
            DataColumn(label: Text('Amount', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700))),
            DataColumn(label: Text('Paid', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700))),
            DataColumn(label: Text('Due', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700))),
          ],
          rows: items.map((f) {
            return DataRow(
              cells: [
                DataCell(Text(_formatDate(f.date), style: const TextStyle(fontSize: 12))),
                DataCell(Text(f.feeType.label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600))),
                DataCell(Text(f.receivedBy, style: const TextStyle(fontSize: 12))),
                DataCell(Text('₹${f.amount.toStringAsFixed(0)}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600))),
                DataCell(Text('₹${f.paid.toStringAsFixed(0)}', style: const TextStyle(fontSize: 12, color: AppColors.success))),
                DataCell(Text('₹${f.due.toStringAsFixed(0)}', style: TextStyle(fontSize: 12, color: f.due > 0 ? AppColors.error : null))),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildPaymentsTable(List<ProjectPayment> items, bool isDark) {
    if (items.isEmpty) {
      return const ProjectEmptyState(
        title: 'No client payments logged',
        description: 'Click "Record Payment" to log customer receipts.',
        icon: Icons.payments_outlined,
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowColor: WidgetStateProperty.all(isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle),
          columns: const [
            DataColumn(label: Text('Receipt Date', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700))),
            DataColumn(label: Text('Amount', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700))),
            DataColumn(label: Text('Mode', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700))),
            DataColumn(label: Text('Reference / UTR', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700))),
            DataColumn(label: Text('Notes', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700))),
          ],
          rows: items.map((p) {
            return DataRow(
              cells: [
                DataCell(Text(_formatDate(p.date), style: const TextStyle(fontSize: 12))),
                DataCell(Text('₹${p.amount.toStringAsFixed(0)}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.success))),
                DataCell(Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(p.mode, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.primary)),
                )),
                DataCell(Text(p.reference.isEmpty ? '—' : p.reference, style: const TextStyle(fontSize: 12))),
                DataCell(Text(p.notes.isEmpty ? '—' : p.notes, style: const TextStyle(fontSize: 12))),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildProjectSelector(bool isDark) {
    return Container(
      height: 34,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String?>(
          value: _selectedProjectId,
          isDense: true,
          hint: Text('All Projects', style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
          icon: Icon(Icons.expand_more, size: 16, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
          dropdownColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          items: [
            DropdownMenuItem<String?>(
              value: null,
              child: Text('All Projects', style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)),
            ),
            ..._repo.projects.map((p) => DropdownMenuItem(
                  value: p.id,
                  child: Text('${p.code} — ${p.name}', style: const TextStyle(fontSize: 12)),
                )),
          ],
          onChanged: (v) => setState(() => _selectedProjectId = v),
        ),
      ),
    );
  }

  void _showRecordPaymentDialog(BuildContext context, bool isDark) {
    final amtCtrl = TextEditingController();
    final refCtrl = TextEditingController();
    final notesCtrl = TextEditingController();
    String mode = 'NEFT / RTGS';

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            return AlertDialog(
              backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
              title: Text('Record Client Payment', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)),
              content: SizedBox(
                width: 420,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: amtCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Received Amount (₹) *', hintText: 'e.g. 500000'),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      initialValue: mode,
                      decoration: const InputDecoration(labelText: 'Payment Mode'),
                      items: ['NEFT / RTGS', 'UPI', 'Cheque', 'Credit Card', 'Cash'].map((m) => DropdownMenuItem(value: m, child: Text(m, style: const TextStyle(fontSize: 12)))).toList(),
                      onChanged: (v) => setDialogState(() => mode = v ?? mode),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: refCtrl,
                      decoration: const InputDecoration(labelText: 'UTR / Transaction Reference', hintText: 'Bank reference / Cheque number'),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: notesCtrl,
                      decoration: const InputDecoration(labelText: 'Notes', hintText: 'Milestone 2 advance payment'),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
                ElevatedButton(
                  onPressed: () {
                    final amt = double.tryParse(amtCtrl.text.trim()) ?? 0;
                    if (amt <= 0) return;
                    final payment = ProjectPayment(
                      id: 'pay-${DateTime.now().millisecondsSinceEpoch}',
                      projectId: _selectedProjectId ?? (_repo.projects.isNotEmpty ? _repo.projects.first.id : 'proj-1'),
                      date: DateTime.now(),
                      amount: amt,
                      mode: mode,
                      reference: refCtrl.text.trim(),
                      notes: notesCtrl.text.trim(),
                    );
                    _repo.addPayment(payment);
                    Navigator.pop(ctx);
                    setState(() {});
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
                  child: const Text('Save Payment'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showAddExpenseDialog(BuildContext context, bool isDark) {
    String type = 'Material';
    final vendorCtrl = TextEditingController();
    final itemCtrl = TextEditingController();
    final amtCtrl = TextEditingController();
    final paidCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            return AlertDialog(
              backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
              title: Text('Record Project Expense', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)),
              content: SizedBox(
                width: 440,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<String>(
                      initialValue: type,
                      decoration: const InputDecoration(labelText: 'Expense Category'),
                      items: ['Material', 'Labour'].map((t) => DropdownMenuItem(value: t, child: Text(t, style: const TextStyle(fontSize: 12)))).toList(),
                      onChanged: (v) => setDialogState(() => type = v ?? type),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: vendorCtrl,
                      decoration: InputDecoration(labelText: type == 'Material' ? 'Vendor Name *' : 'Contractor / Labour Name *', hintText: 'e.g. Greenlam Plywoods'),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: itemCtrl,
                      decoration: InputDecoration(labelText: type == 'Material' ? 'Material Description' : 'Work Scope', hintText: 'e.g. 19mm Marine Ply 40 sheets'),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: amtCtrl,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(labelText: 'Total Bill (₹) *', hintText: '120000'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: paidCtrl,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(labelText: 'Amount Paid (₹)', hintText: '60000'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
                ElevatedButton(
                  onPressed: () {
                    final amt = double.tryParse(amtCtrl.text.trim()) ?? 0;
                    if (amt <= 0 || vendorCtrl.text.trim().isEmpty) return;
                    final paid = double.tryParse(paidCtrl.text.trim()) ?? 0;
                    final pid = _selectedProjectId ?? (_repo.projects.isNotEmpty ? _repo.projects.first.id : 'proj-1');

                    if (type == 'Material') {
                      _repo.addMaterialExpense(MaterialExpense(
                        id: 'mat-${DateTime.now().millisecondsSinceEpoch}',
                        projectId: pid,
                        date: DateTime.now(),
                        vendor: vendorCtrl.text.trim(),
                        material: itemCtrl.text.trim(),
                        invoiceNumber: 'INV-${DateTime.now().millisecondsSinceEpoch % 10000}',
                        amount: amt,
                        paid: paid,
                        due: (amt - paid).clamp(0, double.infinity),
                      ));
                    } else {
                      _repo.addLabourExpense(LabourExpense(
                        id: 'lab-${DateTime.now().millisecondsSinceEpoch}',
                        projectId: pid,
                        date: DateTime.now(),
                        labourName: vendorCtrl.text.trim(),
                        work: itemCtrl.text.trim(),
                        amount: amt,
                        paid: paid,
                        due: (amt - paid).clamp(0, double.infinity),
                      ));
                    }
                    Navigator.pop(ctx);
                    setState(() {});
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
                  child: const Text('Add Expense'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  String _formatDate(DateTime d) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${d.day} ${months[d.month - 1]} ${d.year}';
  }

  Widget _buildLoadingSkeleton(bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          ProjectSkeleton.kpiRow(count: 5, isDark: isDark),
          const SizedBox(height: 16),
          ...List.generate(5, (_) => ProjectSkeleton.listTile(isDark: isDark)),
        ],
      ),
    );
  }
}
