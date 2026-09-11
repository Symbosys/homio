import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../models/reports_mock_data.dart';
import '../models/reports_models.dart';
import '../widgets/reports_charts.dart';
import '../widgets/reports_common_widgets.dart';
import '../widgets/reports_controls_bar.dart';
import '../widgets/reports_drilldown_modal.dart';
import '../widgets/reports_export_dialog.dart';
import '../widgets/reports_filter_drawer.dart';

/// Screen 6: Finance Analytics Screen.
/// Enterprise-grade financial intelligence layer for Homio CRM.
class ReportsFinancesPage extends StatefulWidget {
  const ReportsFinancesPage({super.key});

  @override
  State<ReportsFinancesPage> createState() => _ReportsFinancesPageState();
}

class _ReportsFinancesPageState extends State<ReportsFinancesPage> {
  ReportFilterState _filterState = const ReportFilterState();
  String _trendGranularity = 'Monthly';
  String _revenueDimension = 'Project';

  void _onDrillDown(String title, String category, String metricValue, List<Map<String, dynamic>> records) {
    ReportsDrilldownModal.show(
      context,
      title: title,
      category: category,
      metricValue: metricValue,
      records: records,
    );
  }

  void _openExportDialog() {
    ReportsExportDialog.show(
      context,
      reportTitle: 'Finance Analytics Report',
      dateRangeLabel: _filterState.dateFilter.label,
    );
  }

  void _openFilterDrawer() {
    ReportsFilterDrawer.show(
      context,
      initialFilter: _filterState,
      onApply: (newFilter) {
        setState(() => _filterState = newFilter);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = width < 768;
    final isTablet = width >= 768 && width < 1100;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 12 : 20,
            vertical: 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Controls Bar
              ReportsControlsBar(
                title: 'Finance Analytics',
                subtitle: 'Monitor revenue, expenses, profitability, receivables, payables, collections, and cash flow',
                icon: Icons.savings_rounded,
                filterState: _filterState,
                onFilterChanged: (newFilter) => setState(() => _filterState = newFilter),
                onOpenFilterDrawer: _openFilterDrawer,
                onExport: _openExportDialog,
                onRefresh: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Financial ledgers and bank disbursements refreshed', style: GoogleFonts.inter(fontSize: 12)),
                      duration: const Duration(seconds: 2),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                onSaveView: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Saved current financial view preset'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),

              // 2. Priority Financial KPIs
              _buildFinancialKpis(isMobile, isTablet),
              const SizedBox(height: 16),

              // 3. Revenue vs Expense Trend Chart
              ReportFinanceRevExpTrendChart(
                points: ReportsMockData.financeTrendPoints,
                granularity: _trendGranularity,
                onGranularityChanged: (g) => setState(() => _trendGranularity = g),
              ),
              const SizedBox(height: 16),

              // 4. Revenue Breakdown & Expense Analysis (Split Grid)
              if (isMobile || isTablet) ...[
                _buildRevenueBreakdownSection(isDark),
                const SizedBox(height: 16),
                _buildExpenseAnalysisSection(isDark),
              ] else ...[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 6,
                      child: _buildRevenueBreakdownSection(isDark),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 5,
                      child: _buildExpenseAnalysisSection(isDark),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 16),

              // 5. Receivables Aging & Customer Collections
              if (isMobile || isTablet) ...[
                _buildReceivablesAgingCard(isDark),
                const SizedBox(height: 16),
                _buildCustomerCollectionsSection(isDark, isMobile),
              ] else ...[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 4,
                      child: _buildReceivablesAgingCard(isDark),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 7,
                      child: _buildCustomerCollectionsSection(isDark, isMobile),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 16),

              // 6. Vendor & Labour Payables Table
              _buildPayablesSection(isDark, isMobile),
              const SizedBox(height: 16),

              // 7. Master Financial Performance Ledger Table
              _buildMasterFinancialTable(isDark, isMobile),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================================================
  // SECTION 1: FINANCIAL KPIS
  // ==========================================================================
  Widget _buildFinancialKpis(bool isMobile, bool isTablet) {
    final kpis = ReportsMockData.financeDetailedKpis;
    final crossAxisCount = isMobile ? 1 : (isTablet ? 2 : (MediaQuery.sizeOf(context).width > 1500 ? 6 : 3));

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisExtent: 135,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: kpis.length,
      itemBuilder: (context, index) {
        final kpi = kpis[index];
        return EnterpriseKpiCard(
          title: kpi.title,
          value: kpi.value,
          previousValue: kpi.previousValue,
          growthPercent: kpi.growthPercent,
          isPositive: kpi.isPositive,
          targetText: kpi.target,
          targetProgress: kpi.targetAchievementPercent / 100,
          icon: kpi.icon,
          color: kpi.color,
          onTap: () {
            _onDrillDown(
              kpi.title,
              kpi.category,
              kpi.value,
              [
                {
                  'title': 'DLF Camellias Phase 2 Escrow Disbursement',
                  'subtitle': 'Client: Rajiv Singhania • ICICI Bank Escrow',
                  'status': 'Settled',
                  'statusColor': const Color(0xFF10B981),
                  'metric': '₹14,50,000',
                  'date': 'Sep 06, 2026',
                  'badge': 'Milestone 2',
                },
                {
                  'title': 'Indiranagar Villa Material Advance',
                  'subtitle': 'Client: Dr. Ananya Reddy • Direct RTGS',
                  'status': 'Cleared',
                  'statusColor': const Color(0xFF3B82F6),
                  'metric': '₹8,20,000',
                  'date': 'Sep 04, 2026',
                  'badge': 'Plywood & Hardware',
                },
                {
                  'title': 'Bandra Duplex Designer Retainer',
                  'subtitle': 'Client: Vikram Merchant • GST Invoice',
                  'status': 'Audited',
                  'statusColor': const Color(0xFF6366F1),
                  'metric': '₹3,50,000',
                  'date': 'Sep 02, 2026',
                  'badge': 'Design Fee',
                },
              ],
            );
          },
        );
      },
    );
  }

  // ==========================================================================
  // SECTION 2: REVENUE BREAKDOWN BY DIMENSION
  // ==========================================================================
  Widget _buildRevenueBreakdownSection(bool isDark) {
    final items = ReportsMockData.financeRevenueBreakdown;

    return ReportSectionContainer(
      title: 'Revenue & Gross Margin Breakdown',
      subtitle: 'Analyze gross earnings, direct costs, and contribution margins',
      icon: Icons.pie_chart_outline_rounded,
      iconColor: const Color(0xFF10B981),
      trailing: Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
          borderRadius: AppRadius.sm,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: ['Project', 'Customer', 'Branch'].map((d) {
            final isSelected = _revenueDimension == d;
            return InkWell(
              onTap: () => setState(() => _revenueDimension = d),
              borderRadius: AppRadius.xs,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: isSelected ? (isDark ? AppColors.primary : Colors.white) : Colors.transparent,
                  borderRadius: AppRadius.xs,
                  boxShadow: isSelected && !isDark ? [
                    BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 2, offset: const Offset(0, 1))
                  ] : null,
                ),
                child: Text(
                  d,
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected
                        ? (isDark ? Colors.white : AppColors.primary)
                        : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
      child: Column(
        children: items.map((item) {
          return InkWell(
            onTap: () {
              _onDrillDown(
                item.title,
                'Project Scope',
                '₹${(item.revenue / 100000).toStringAsFixed(2)}L',
                [
                  {
                    'title': 'Gross Invoiced Contract',
                    'subtitle': 'Client: ${item.customerOrClient}',
                    'status': item.projectStatus,
                    'statusColor': const Color(0xFF10B981),
                    'metric': '₹${(item.revenue / 100000).toStringAsFixed(2)}L',
                    'date': 'Current Period',
                    'badge': 'Direct Margin ${item.marginPercent}%',
                  },
                ],
              );
            },
            borderRadius: AppRadius.sm,
            child: Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B).withValues(alpha: 0.4) : const Color(0xFFF8FAFC),
                borderRadius: AppRadius.sm,
                border: Border.all(
                  color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                  width: 0.8,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: isDark ? Colors.white : AppColors.lightTextPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${item.customerOrClient} • ${item.projectStatus}',
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '₹${(item.revenue / 100000).toStringAsFixed(2)}L',
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF10B981),
                        ),
                      ),
                      Text(
                        'Margin: ${item.marginPercent}% (₹${(item.grossProfit / 100000).toStringAsFixed(1)}L)',
                        style: GoogleFonts.inter(
                          fontSize: 9.5,
                          fontWeight: FontWeight.w500,
                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ==========================================================================
  // SECTION 3: EXPENSE ANALYSIS BY CATEGORY
  // ==========================================================================
  Widget _buildExpenseAnalysisSection(bool isDark) {
    final categories = ReportsMockData.financeExpenseCategories;

    return ReportSectionContainer(
      title: 'Expense Breakdown by Category',
      subtitle: 'Operational spend across procurement, site labor, logistics & overheads',
      icon: Icons.account_balance_wallet_rounded,
      iconColor: const Color(0xFFEF4444),
      child: Column(
        children: categories.map((cat) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(cat.icon, size: 14, color: cat.color),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        cat.category,
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white : AppColors.lightTextPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Flexible(
                      child: Text(
                        '₹${(cat.actual / 100000).toStringAsFixed(1)}L (${cat.percentageOfTotal.toStringAsFixed(1)}%)',
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w600,
                          color: cat.color,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: LinearProgressIndicator(
                    value: (cat.percentageOfTotal / 100).clamp(0.02, 1.0),
                    backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
                    valueColor: AlwaysStoppedAnimation<Color>(cat.color),
                    minHeight: 6,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'Budget: ₹${(cat.budget / 100000).toStringAsFixed(1)}L',
                        style: GoogleFonts.inter(
                          fontSize: 9,
                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        cat.isOverBudget
                            ? '+₹${(cat.variance.abs() / 1000).toStringAsFixed(0)}k Over'
                            : '-₹${(cat.variance.abs() / 1000).toStringAsFixed(0)}k Under',
                        style: GoogleFonts.inter(
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                          color: cat.isOverBudget ? const Color(0xFFEF4444) : const Color(0xFF10B981),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  // ==========================================================================
  // SECTION 4: RECEIVABLES AGING BUCKETS
  // ==========================================================================
  Widget _buildReceivablesAgingCard(bool isDark) {
    return ReportSectionContainer(
      title: 'Receivables Aging Buckets',
      subtitle: 'Outstanding client invoices grouped by payment overdue threshold',
      icon: Icons.history_toggle_off_rounded,
      iconColor: const Color(0xFFF59E0B),
      child: ReportReceivablesAgingBarChart(
        buckets: ReportsMockData.financeAgingBuckets,
        onBucketTap: (bucket) {
          _onDrillDown(
            'Receivables: ${bucket.label}',
            'Overdue Invoices',
            '₹${(bucket.amount / 100000).toStringAsFixed(1)}L',
            [
              {
                'title': 'Gaurav Khandelwal (Gurgaon Res)',
                'subtitle': 'Stage 3 Joinery Milestone',
                'status': bucket.label,
                'statusColor': bucket.color,
                'metric': '₹4,50,000 Overdue',
                'date': 'Due: Aug 10, 2026',
                'badge': '31 Days Overdue',
              },
              {
                'title': 'Prestige Palms Villa Milestone 2',
                'subtitle': 'Client: Sandeep Bansal',
                'status': bucket.label,
                'statusColor': bucket.color,
                'metric': '₹3,70,000 Overdue',
                'date': 'Due: Aug 24, 2026',
                'badge': '17 Days Overdue',
              },
            ],
          );
        },
      ),
    );
  }

  // ==========================================================================
  // SECTION 5: CUSTOMER COLLECTION PERFORMANCE
  // ==========================================================================
  Widget _buildCustomerCollectionsSection(bool isDark, bool isMobile) {
    final collections = ReportsMockData.financeCustomerCollections;

    return ReportSectionContainer(
      title: 'Customer Collection Performance',
      subtitle: 'Track recovery rates, overdue amounts, and collection cycles',
      icon: Icons.supervised_user_circle_rounded,
      iconColor: const Color(0xFF3B82F6),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowHeight: 38,
          dataRowMinHeight: 46,
          dataRowMaxHeight: 52,
          horizontalMargin: 8,
          columnSpacing: 18,
          columns: [
            DataColumn(label: Text('Customer', style: _headerStyle(isDark))),
            DataColumn(label: Text('Invoiced', style: _headerStyle(isDark))),
            DataColumn(label: Text('Collected', style: _headerStyle(isDark))),
            DataColumn(label: Text('Outstanding', style: _headerStyle(isDark))),
            DataColumn(label: Text('Recovery %', style: _headerStyle(isDark))),
            DataColumn(label: Text('Oldest Due', style: _headerStyle(isDark))),
            DataColumn(label: Text('Action', style: _headerStyle(isDark))),
          ],
          rows: collections.map((c) {
            return DataRow(
              cells: [
                DataCell(
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        c.customerName,
                        style: GoogleFonts.inter(fontSize: 11.5, fontWeight: FontWeight.w700, color: isDark ? Colors.white : AppColors.lightTextPrimary),
                      ),
                      Text(
                        '${c.customerId} • ${c.invoiceCount} invoices',
                        style: GoogleFonts.inter(fontSize: 9.5, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                      ),
                    ],
                  ),
                ),
                DataCell(Text('₹${(c.invoicedAmount / 100000).toStringAsFixed(1)}L', style: _monoStyle(isDark))),
                DataCell(Text('₹${(c.paidAmount / 100000).toStringAsFixed(1)}L', style: _monoStyle(isDark, color: const Color(0xFF10B981)))),
                DataCell(
                  Text(
                    '₹${(c.outstandingAmount / 100000).toStringAsFixed(1)}L',
                    style: _monoStyle(isDark, color: c.overdueAmount > 0 ? const Color(0xFFEF4444) : (isDark ? Colors.white : AppColors.lightTextPrimary)),
                  ),
                ),
                DataCell(
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: (c.collectionRate > 80 ? const Color(0xFF10B981) : const Color(0xFFF59E0B)).withValues(alpha: 0.15),
                      borderRadius: AppRadius.xs,
                    ),
                    child: Text(
                      '${c.collectionRate}%',
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: c.collectionRate > 80 ? const Color(0xFF10B981) : const Color(0xFFF59E0B),
                      ),
                    ),
                  ),
                ),
                DataCell(
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(c.oldestDueDate, style: GoogleFonts.inter(fontSize: 10, color: isDark ? Colors.white : AppColors.lightTextPrimary)),
                      if (c.daysOverdue > 0)
                        Text('${c.daysOverdue}d overdue', style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.w600, color: const Color(0xFFEF4444))),
                    ],
                  ),
                ),
                DataCell(
                  OutlinedButton(
                    onPressed: () {
                      _onDrillDown(
                        'Client Ledger: ${c.customerName}',
                        'Invoices & Payments',
                        '₹${(c.paidAmount / 100000).toStringAsFixed(1)}L Paid',
                        [
                          {
                            'title': 'Civil & Flooring Progress Settlement',
                            'subtitle': 'Approved by Site Architect',
                            'status': 'Settled',
                            'statusColor': const Color(0xFF10B981),
                            'metric': '₹12,40,000',
                            'date': c.lastPaymentDate,
                            'badge': 'NEFT-59281',
                          },
                        ],
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      minimumSize: const Size(60, 26),
                      side: BorderSide(color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1)),
                      shape: RoundedRectangleBorder(borderRadius: AppRadius.xs),
                    ),
                    child: Text('View Ledger', style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w600)),
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  // ==========================================================================
  // SECTION 6: VENDOR & LABOUR PAYABLES
  // ==========================================================================
  Widget _buildPayablesSection(bool isDark, bool isMobile) {
    final payables = ReportsMockData.financePayables;

    return ReportSectionContainer(
      title: 'Vendor & Contractor Labour Payables',
      subtitle: 'Pending vendor supply invoices, weekly labour allocations & settlement dates',
      icon: Icons.receipt_long_rounded,
      iconColor: const Color(0xFF8B5CF6),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowHeight: 38,
          dataRowMinHeight: 44,
          dataRowMaxHeight: 50,
          horizontalMargin: 8,
          columnSpacing: 18,
          columns: [
            DataColumn(label: Text('Payable Ref', style: _headerStyle(isDark))),
            DataColumn(label: Text('Recipient / Contractor', style: _headerStyle(isDark))),
            DataColumn(label: Text('Category', style: _headerStyle(isDark))),
            DataColumn(label: Text('Due Date', style: _headerStyle(isDark))),
            DataColumn(label: Text('Total Amount', style: _headerStyle(isDark))),
            DataColumn(label: Text('Outstanding', style: _headerStyle(isDark))),
            DataColumn(label: Text('Status', style: _headerStyle(isDark))),
          ],
          rows: payables.map((p) {
            return DataRow(
              cells: [
                DataCell(Text(p.invoiceRef, style: _monoStyle(isDark))),
                DataCell(Text(p.recipientName, style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: isDark ? Colors.white : AppColors.lightTextPrimary))),
                DataCell(Text(p.category, style: GoogleFonts.inter(fontSize: 10.5, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary))),
                DataCell(Text(p.dueDate, style: GoogleFonts.inter(fontSize: 10.5, color: isDark ? Colors.white : AppColors.lightTextPrimary))),
                DataCell(Text('₹${(p.amount / 100000).toStringAsFixed(2)}L', style: _monoStyle(isDark))),
                DataCell(Text('₹${(p.outstandingAmount / 100000).toStringAsFixed(2)}L', style: _monoStyle(isDark, color: p.outstandingAmount > 0 ? const Color(0xFFEF4444) : const Color(0xFF10B981)))),
                DataCell(
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: p.statusColor.withValues(alpha: 0.15),
                      borderRadius: AppRadius.xs,
                    ),
                    child: Text(
                      p.status,
                      style: GoogleFonts.inter(fontSize: 9.5, fontWeight: FontWeight.w700, color: p.statusColor),
                    ),
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  // ==========================================================================
  // SECTION 7: MASTER FINANCIAL PERFORMANCE TABLE
  // ==========================================================================
  Widget _buildMasterFinancialTable(bool isDark, bool isMobile) {
    final ledger = ReportsMockData.financePerformanceLedger;

    return ReportSectionContainer(
      title: 'Financial Performance Statement',
      subtitle: 'Consolidated revenue, operating costs, gross margins, collections & net cash position',
      icon: Icons.table_chart_rounded,
      iconColor: const Color(0xFF6366F1),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowHeight: 40,
          dataRowMinHeight: 46,
          dataRowMaxHeight: 52,
          horizontalMargin: 10,
          columnSpacing: 18,
          columns: [
            DataColumn(label: Text('Period', style: _headerStyle(isDark))),
            DataColumn(label: Text('Revenue', style: _headerStyle(isDark))),
            DataColumn(label: Text('Expenses', style: _headerStyle(isDark))),
            DataColumn(label: Text('Gross Profit', style: _headerStyle(isDark))),
            DataColumn(label: Text('Gross Margin', style: _headerStyle(isDark))),
            DataColumn(label: Text('Collections', style: _headerStyle(isDark))),
            DataColumn(label: Text('Payables', style: _headerStyle(isDark))),
            DataColumn(label: Text('Net Position', style: _headerStyle(isDark))),
          ],
          rows: ledger.map((row) {
            return DataRow(
              cells: [
                DataCell(Text(row.period, style: GoogleFonts.inter(fontSize: 11.5, fontWeight: FontWeight.w700, color: isDark ? Colors.white : AppColors.lightTextPrimary))),
                DataCell(Text('₹${(row.revenue / 10000000).toStringAsFixed(2)} Cr', style: _monoStyle(isDark, color: const Color(0xFF10B981)))),
                DataCell(Text('₹${(row.expenses / 10000000).toStringAsFixed(2)} Cr', style: _monoStyle(isDark, color: const Color(0xFFEF4444)))),
                DataCell(Text('₹${(row.grossProfit / 100000).toStringAsFixed(1)}L', style: _monoStyle(isDark, color: const Color(0xFF6366F1)))),
                DataCell(
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981).withValues(alpha: 0.15),
                      borderRadius: AppRadius.xs,
                    ),
                    child: Text(
                      '${row.grossMargin}%',
                      style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: const Color(0xFF10B981)),
                    ),
                  ),
                ),
                DataCell(Text('₹${(row.collections / 100000).toStringAsFixed(1)}L', style: _monoStyle(isDark))),
                DataCell(Text('₹${(row.payables / 100000).toStringAsFixed(1)}L', style: _monoStyle(isDark))),
                DataCell(
                  Text(
                    '₹${(row.netPosition / 100000).toStringAsFixed(1)}L',
                    style: _monoStyle(isDark, color: row.netPosition >= 0 ? const Color(0xFF10B981) : const Color(0xFFEF4444)),
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  TextStyle _headerStyle(bool isDark) {
    return GoogleFonts.inter(
      fontSize: 10.5,
      fontWeight: FontWeight.w700,
      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
      letterSpacing: 0.3,
    );
  }

  TextStyle _monoStyle(bool isDark, {Color? color}) {
    return GoogleFonts.jetBrainsMono(
      fontSize: 11,
      fontWeight: FontWeight.w600,
      color: color ?? (isDark ? Colors.white : AppColors.lightTextPrimary),
    );
  }
}
