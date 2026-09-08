// Homio CRM — Screen 9: Overdue & Operational Collections Workspace

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../models/accounting_models.dart';
import '../models/accounting_mock_data.dart';
import '../widgets/finance_page_header.dart';
import '../widgets/finance_kpi_card.dart';
import '../widgets/financial_filter_bar.dart';
import '../widgets/financial_status_badge.dart';
import '../widgets/whatsapp_payment_reminder_modal.dart';
import '../widgets/promise_to_pay_modal.dart';
import '../widgets/overdue_automation_modal.dart';

class OverdueCollectionsPage extends StatefulWidget {
  const OverdueCollectionsPage({super.key});

  @override
  State<OverdueCollectionsPage> createState() => _OverdueCollectionsPageState();
}

class _OverdueCollectionsPageState extends State<OverdueCollectionsPage> {
  late List<OverdueCollectionItem> _overdueList;
  late List<PromiseToPay> _promises;
  OverdueAutomationConfig _automationConfig = AccountingMockData.automationConfig;
  String _searchQuery = '';
  CollectionRisk? _selectedRisk;

  @override
  void initState() {
    super.initState();
    _overdueList = List.from(AccountingMockData.overdueCollections);
    _promises = List.from(AccountingMockData.promisesToPay);
  }

  List<OverdueCollectionItem> get _filteredOverdue {
    return _overdueList.where((o) {
      final matchesSearch = _searchQuery.isEmpty ||
          o.customerName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          o.invoiceNumber.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          o.projectName.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesRisk = _selectedRisk == null || o.risk == _selectedRisk;
      return matchesSearch && matchesRisk;
    }).toList();
  }

  double get _totalOverdueAmount =>
      _overdueList.fold(0.0, (sum, o) => sum + o.outstandingAmount);

  void _openAutomationModal() {
    showDialog(
      context: context,
      builder: (ctx) => OverdueAutomationModal(
        initialConfig: _automationConfig,
        onSaved: (newCfg) => setState(() => _automationConfig = newCfg),
      ),
    );
  }

  void _openPromiseModal(OverdueCollectionItem item) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => PromiseToPayModal(
        customerName: item.customerName,
        projectName: item.projectName,
        invoiceNumber: item.invoiceNumber,
        defaultAmount: item.outstandingAmount,
        customerContact: item.customerPhone,
        onSaved: (p) {
          setState(() {
            _promises.insert(0, p);
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Promise to Pay of ₹${p.promisedAmount.toStringAsFixed(0)} recorded for ${p.customerName}!'),
              backgroundColor: AppColors.success,
            ),
          );
        },
      ),
    );
  }

  void _openWhatsAppModal(OverdueCollectionItem item) {
    showDialog(
      context: context,
      builder: (ctx) => WhatsAppPaymentReminderModal(
        customerName: item.customerName,
        customerPhone: item.customerPhone,
        projectName: item.projectName,
        invoiceNumber: item.invoiceNumber,
        outstandingAmount: item.outstandingAmount,
        dueDate: item.dueDate,
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
            title: 'Overdue Receivables & Collections',
            subtitle:
                'Operational collection dashboard, aging breakdown, automated client WhatsApp reminders, site supervisor halts, and Promise to Pay commitments.',
            icon: Icons.notification_important_rounded,
            secondaryAction: FilledButton.tonalIcon(
              onPressed: _openAutomationModal,
              icon: const Icon(Icons.settings_suggest_rounded, size: 16),
              label: const Text('Overdue Automation Engine', style: TextStyle(fontSize: 12)),
            ),
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
                            title: 'Total Overdue Balance',
                            value: '₹${_totalOverdueAmount.toStringAsFixed(0)}',
                            subtitle: '${_overdueList.length} Invoices Exceeding Terms',
                            icon: Icons.warning_amber_rounded,
                            color: AppColors.error,
                            isSelected: _selectedRisk == null,
                            onTap: () => setState(() => _selectedRisk = null),
                          ),
                          FinanceKpiCard(
                            title: 'Critical Risk Accounts',
                            value: '${_overdueList.where((o) => o.risk == CollectionRisk.critical || o.risk == CollectionRisk.high).length}',
                            subtitle: 'Requires immediate PM intervention',
                            icon: Icons.shield_outlined,
                            color: const Color(0xFFEA580C),
                            isSelected: _selectedRisk == CollectionRisk.high,
                            onTap: () => setState(() => _selectedRisk = CollectionRisk.high),
                          ),
                          FinanceKpiCard(
                            title: 'Active Promises to Pay',
                            value: '${_promises.length} Commitments',
                            subtitle: 'Customer committed settlement dates',
                            icon: Icons.handshake_outlined,
                            color: AppColors.primary,
                          ),
                          FinanceKpiCard(
                            title: 'Automation Engine',
                            value: _automationConfig.enableReminders ? 'Active' : 'Paused',
                            subtitle: 'WhatsApp + Supervisor alerts enabled',
                            icon: Icons.smart_toy_outlined,
                            color: const Color(0xFF0D9488),
                            onTap: _openAutomationModal,
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 24),

                  // Collection Aging Brackets Ribbon
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'COLLECTION AGING REPORT (DAYS PAST INVOICE DUE DATE)',
                          style: theme.textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.6,
                            color: isDark ? AppColors.darkSubtext : AppColors.lightTextSecondary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(child: _buildAgingBox('CURRENT (0d)', '₹4,20,000', AppColors.success, isDark)),
                            const SizedBox(width: 10),
                            Expanded(child: _buildAgingBox('1–7 DAYS', '₹1,80,000', AppColors.warning, isDark)),
                            const SizedBox(width: 10),
                            Expanded(child: _buildAgingBox('8–30 DAYS', '₹2,10,000', const Color(0xFFEA580C), isDark)),
                            const SizedBox(width: 10),
                            Expanded(child: _buildAgingBox('31–60 DAYS', '₹90,000', const Color(0xFFDC2626), isDark)),
                            const SizedBox(width: 10),
                            Expanded(child: _buildAgingBox('60+ DAYS (LEGAL)', '₹1,40,000', const Color(0xFF991B1B), isDark)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Search Toolbar
                  FinancialFilterBar(
                    searchQuery: _searchQuery,
                    onSearchChanged: (val) => setState(() => _searchQuery = val),
                    searchHint: 'Search overdue client, project, or invoice #...',
                    activeFilterSummary: _selectedRisk != null ? 'Risk: ${_selectedRisk!.label}' : null,
                    onClearFilters: () => setState(() {
                      _searchQuery = '';
                      _selectedRisk = null;
                    }),
                  ),
                  const SizedBox(height: 20),

                  // Overdue Table
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
                            DataColumn(label: Text('CLIENT', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11))),
                            DataColumn(label: Text('PROJECT & INVOICE', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11))),
                            DataColumn(label: Text('DUE DATE', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11))),
                            DataColumn(label: Text('DAYS OVERDUE', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11))),
                            DataColumn(label: Text('OVERDUE (₹)', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11))),
                            DataColumn(label: Text('RISK LEVEL', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11))),
                            DataColumn(label: Text('COLLECTION OWNER', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11))),
                            DataColumn(label: Text('REMINDERS SENT', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11))),
                            DataColumn(label: Text('STATUS', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11))),
                            DataColumn(label: Text('ACTIONS', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11))),
                          ],
                          rows: _filteredOverdue.map((o) {
                            return DataRow(
                              cells: [
                                DataCell(
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(o.customerName, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                                      Text(o.customerPhone, style: const TextStyle(fontSize: 10, color: Colors.grey)),
                                    ],
                                  ),
                                ),
                                DataCell(
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(o.projectName, style: const TextStyle(fontSize: 12)),
                                      Text('Inv: ${o.invoiceNumber}', style: const TextStyle(fontSize: 10, color: AppColors.primary)),
                                    ],
                                  ),
                                ),
                                DataCell(Text('${o.dueDate.day}/${o.dueDate.month}/${o.dueDate.year}', style: const TextStyle(fontSize: 11))),
                                DataCell(
                                  Text(
                                    '${o.daysOverdue} Days',
                                    style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12, color: AppColors.error),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    '₹${o.outstandingAmount.toStringAsFixed(0)}',
                                    style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: AppColors.error),
                                  ),
                                ),
                                DataCell(FinancialStatusBadge.fromRisk(o.risk)),
                                DataCell(Text(o.collectionOwner, style: const TextStyle(fontSize: 11))),
                                DataCell(
                                  Text(
                                    '${o.reminderCount} Sent',
                                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                                  ),
                                ),
                                DataCell(
                                  Text(o.status, style: const TextStyle(fontSize: 11, fontStyle: FontStyle.italic)),
                                ),
                                DataCell(
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        onPressed: () => _openWhatsAppModal(o),
                                        icon: const Icon(Icons.chat_bubble_outline_rounded, size: 18, color: Color(0xFF22C55E)),
                                        tooltip: 'Send WhatsApp Reminder',
                                      ),
                                      IconButton(
                                        onPressed: () => _openPromiseModal(o),
                                        icon: const Icon(Icons.handshake_outlined, size: 18, color: AppColors.primary),
                                        tooltip: 'Record Promise to Pay',
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

  Widget _buildAgingBox(String label, String amount, Color color, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: color, letterSpacing: 0.5)),
          const SizedBox(height: 6),
          Text(amount, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: isDark ? Colors.white : const Color(0xFF0F172A))),
        ],
      ),
    );
  }
}
