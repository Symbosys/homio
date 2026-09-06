import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../dashboard/widgets/compact_data_table.dart';
import '../models/reports_mock_data.dart';
import '../models/reports_models.dart';
import '../widgets/reports_charts.dart';
import '../widgets/reports_header.dart';
import '../widgets/reports_metric_card.dart';

/// Financial Summary Executive Screen.
/// Provides cash outflow allocations across Material procurement, Labour disbursements,
/// Design fees, Consulting retainers, and project-level transaction ledgers.
class ReportsFinancesPage extends StatefulWidget {
  const ReportsFinancesPage({super.key});

  @override
  State<ReportsFinancesPage> createState() => _ReportsFinancesPageState();
}

class _ReportsFinancesPageState extends State<ReportsFinancesPage> {
  ReportDateFilter _dateFilter = ReportDateFilter.thisMonth;
  final List<FinancialOutflowLedgerItem> _outflows = List.from(ReportsMockData.financialOutflows);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final width = MediaQuery.of(context).size.width;
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
              // Header
              ReportHeader(
                title: 'Financial Summary & Disbursements',
                subtitle: 'Cash outflows across material supply, contractor disbursements, architectural fees & consulting retainers',
                icon: Icons.payments_rounded,
                activeFilter: _dateFilter,
                onFilterChanged: (val) => setState(() => _dateFilter = val),
                primaryAction: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.file_download_outlined, size: 14),
                  label: Text(
                    'Export Financials',
                    style: GoogleFonts.inter(fontSize: 11.5, fontWeight: FontWeight.w600),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                    shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
                  ),
                ),
              ),

              // 4 Financial KPIs
              _buildKpis(isMobile, isTablet),
              const SizedBox(height: 18),

              // Outflow Donut & Budget Utilization Summary Row
              _buildOutflowAndBudgetRow(isDark, isMobile, isTablet),
              const SizedBox(height: 18),

              // Full-Width Project-Level Outflows Ledger Table
              _buildOutflowsTable(isDark),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildKpis(bool isMobile, bool isTablet) {
    final kpis = ReportsMockData.financialKpis;
    final crossAxisCount = isMobile ? 1 : (isTablet ? 2 : 4);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisExtent: 118,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: kpis.length,
      itemBuilder: (context, index) {
        return ReportMetricCard(metric: kpis[index]);
      },
    );
  }

  Widget _buildOutflowAndBudgetRow(bool isDark, bool isMobile, bool isTablet) {
    if (isMobile || isTablet) {
      return Column(
        children: [
          const ReportFinancialOutflowDonutChart(),
          const SizedBox(height: 16),
          _buildBudgetHealthCard(isDark),
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Expanded(
          flex: 5,
          child: ReportFinancialOutflowDonutChart(),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 5,
          child: _buildBudgetHealthCard(isDark),
        ),
      ],
    );
  }

  Widget _buildBudgetHealthCard(bool isDark) {
    return Container(
      height: 260,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: AppRadius.md,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.account_balance_rounded, size: 16, color: Color(0xFF3B82F6)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Project Budget Variance & Health',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : AppColors.lightTextPrimary,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: isDark ? 0.2 : 0.1),
                  borderRadius: AppRadius.full,
                ),
                child: Text(
                  'Within 3.2% Target',
                  style: GoogleFonts.inter(fontSize: 9.5, fontWeight: FontWeight.w700, color: const Color(0xFF10B981)),
                ),
              ),
            ],
          ),
          _budgetRow('Material Price Fluctuation (Hafele/Plywood)', '₹42.8L / ₹44.0L', 0.97, const Color(0xFF3B82F6), isDark),
          _budgetRow('Labour & Contractor Daily Wages', '₹18.4L / ₹19.0L', 0.96, const Color(0xFF10B981), isDark),
          _budgetRow('Design Milestone Commissions', '₹6.2L / ₹6.5L', 0.95, const Color(0xFF8B5CF6), isDark),
          _budgetRow('Engineering & Vastu Retainers', '₹3.1L / ₹3.2L', 0.96, const Color(0xFFF59E0B), isDark),
        ],
      ),
    );
  }

  Widget _budgetRow(String title, String ratio, double pct, Color color, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: isDark ? Colors.white : AppColors.lightTextPrimary),
            ),
            Text(
              ratio,
              style: GoogleFonts.jetBrainsMono(fontSize: 10.5, fontWeight: FontWeight.w700, color: color),
            ),
          ],
        ),
        const SizedBox(height: 3),
        LinearProgressIndicator(
          value: pct,
          minHeight: 4,
          backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
          valueColor: AlwaysStoppedAnimation<Color>(color),
          borderRadius: BorderRadius.circular(2),
        ),
      ],
    );
  }

  Widget _buildOutflowsTable(bool isDark) {
    return CompactTableCard(
      title: 'Project Cash Outflows & Settlement Ledger',
      subtitle: 'Verified bank transfers, escrow releases, and vendor payment vouchers with invoice references',
      trailing: OutlinedButton.icon(
        onPressed: () {},
        icon: const Icon(Icons.file_download_outlined, size: 13),
        label: Text('Tax Statement', style: GoogleFonts.inter(fontSize: 11)),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          visualDensity: VisualDensity.compact,
          side: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final tableWidth = math.max(constraints.maxWidth, 960.0);

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: tableWidth,
              child: Table(
                columnWidths: const {
                  0: FlexColumnWidth(1.4), // TXN ID
                  1: FlexColumnWidth(2.8), // PROJECT & CLIENT
                  2: FlexColumnWidth(2.2), // CATEGORY
                  3: FlexColumnWidth(2.6), // RECIPIENT
                  4: FlexColumnWidth(1.6), // AMOUNT (₹)
                  5: FlexColumnWidth(1.4), // DATE
                  6: FlexColumnWidth(1.4), // METHOD
                  7: FlexColumnWidth(1.3), // STATUS
                  8: FlexColumnWidth(0.9), // INVOICE
                },
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: [
                  TableRow(
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E293B).withValues(alpha: 0.5) : const Color(0xFFF8FAFC),
                      border: Border(
                        bottom: BorderSide(
                          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                          width: 1,
                        ),
                      ),
                    ),
                    children: [
                      _buildHeaderCell('TXN ID', isDark),
                      _buildHeaderCell('PROJECT / CLIENT', isDark),
                      _buildHeaderCell('CATEGORY', isDark),
                      _buildHeaderCell('RECIPIENT VENDOR', isDark),
                      _buildHeaderCell('AMOUNT (₹)', isDark),
                      _buildHeaderCell('DATE', isDark),
                      _buildHeaderCell('METHOD', isDark),
                      _buildHeaderCell('STATUS', isDark),
                      _buildHeaderCell('INVOICE', isDark, align: TextAlign.center),
                    ],
                  ),
                  ..._outflows.map((tx) {
                    return TableRow(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: isDark ? AppColors.darkBorder.withValues(alpha: 0.5) : AppColors.lightBorder.withValues(alpha: 0.8),
                            width: 0.8,
                          ),
                        ),
                      ),
                      children: [
                        // TXN ID
                        _buildDataCell(
                          Text(
                            tx.txnId,
                            style: GoogleFonts.jetBrainsMono(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: isDark ? const Color(0xFF93C5FD) : const Color(0xFF2563EB),
                            ),
                          ),
                        ),
                        // PROJECT / CLIENT
                        _buildDataCell(
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                tx.clientName,
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: isDark ? Colors.white : AppColors.lightTextPrimary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                tx.projectId,
                                style: GoogleFonts.inter(
                                  fontSize: 10.5,
                                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // CATEGORY
                        _buildDataCell(
                          Text(
                            tx.category,
                            style: GoogleFonts.inter(fontSize: 11.5, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                          ),
                        ),
                        // RECIPIENT VENDOR
                        _buildDataCell(
                          Text(
                            tx.recipientName,
                            style: GoogleFonts.inter(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w600,
                              color: isDark ? Colors.white : AppColors.lightTextPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        // AMOUNT (₹)
                        _buildDataCell(
                          Text(
                            '₹${tx.amount.toStringAsFixed(0)}',
                            style: GoogleFonts.jetBrainsMono(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF3B82F6),
                            ),
                          ),
                        ),
                        // DATE
                        _buildDataCell(
                          Text(
                            tx.date,
                            style: GoogleFonts.inter(fontSize: 11, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                          ),
                        ),
                        // METHOD
                        _buildDataCell(
                          Text(
                            tx.paymentMethod,
                            style: GoogleFonts.inter(fontSize: 11, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                          ),
                        ),
                        // STATUS
                        _buildDataCell(
                          DashboardBadge(label: tx.status.toUpperCase(), color: tx.statusColor),
                        ),
                        // INVOICE
                        _buildDataCell(
                          Center(
                            child: IconButton(
                              icon: const Icon(Icons.download_for_offline_outlined, size: 16),
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Downloading voucher for ${tx.invoiceRef}'),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              },
                              tooltip: 'Download Voucher',
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                        ),
                      ],
                    );
                  }),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeaderCell(String text, bool isDark, {TextAlign align = TextAlign.start}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Text(
        text,
        textAlign: align,
        style: GoogleFonts.inter(
          fontSize: 10.5,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.3,
          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
        ),
      ),
    );
  }

  Widget _buildDataCell(Widget content, {EdgeInsetsGeometry? padding}) {
    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      child: content,
    );
  }
}
