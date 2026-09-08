import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../data/marketing_repository.dart';
import '../domain/marketing_enums.dart';
import '../domain/marketing_models.dart';
import '../widgets/marketing_header.dart';

class MarketingReportsPage extends StatefulWidget {
  const MarketingReportsPage({super.key});

  @override
  State<MarketingReportsPage> createState() => _MarketingReportsPageState();
}

class _MarketingReportsPageState extends State<MarketingReportsPage> with SingleTickerProviderStateMixin {
  final _repo = MarketingRepository();
  String _selectedDateRange = 'This Quarter';
  ReportType _selectedReportType = ReportType.attribution;
  bool _isRefreshing = false;
  late TabController _tabController;

  late MarketingKpiSummary _kpis;
  late List<ChannelPerformanceItem> _channelPerformances;
  late List<DecliningReasonMetric> _decliningReasons;
  late List<AcquisitionFunnelStage> _funnelStages;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _loadData() {
    _kpis = _repo.getKpiSummary(dateRange: _selectedDateRange);
    _channelPerformances = _repo.getChannelPerformance();
    _decliningReasons = _repo.getDecliningReasons();
    _funnelStages = _repo.getAcquisitionFunnel();
  }

  Future<void> _handleRefresh() async {
    setState(() => _isRefreshing = true);
    await Future.delayed(const Duration(milliseconds: 300));
    if (mounted) {
      setState(() {
        _loadData();
        _isRefreshing = false;
      });
    }
  }

  void _exportReport(String format) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Exporting ${_selectedReportType.label} as $format... Download will begin shortly.'),
        backgroundColor: const Color(0xFF10B981),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          key: const PageStorageKey('marketing_reports_scroll_key'),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              MarketingHeader(
                title: 'Marketing Reports & Audits',
                subtitle: 'Executive attribution summaries, CAC & ROI audits, and compliance export reports',
                selectedDateRange: _selectedDateRange,
                isRefreshing: _isRefreshing,
                onDateRangeChanged: (val) {
                  setState(() {
                    _selectedDateRange = val;
                    _loadData();
                  });
                },
                onRefresh: _handleRefresh,
                primaryActionLabel: 'Export PDF Report',
                primaryActionIcon: Icons.picture_as_pdf_rounded,
                onPrimaryAction: () => _exportReport('PDF'),
              ),
              const SizedBox(height: 20),
            // Pre-built Report Type Templates Strip
            _buildReportTemplates(isDark),

            const SizedBox(height: 20),

            // Live Report Document Container
            Container(
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCard : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Report Header Details
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'HOMIO Marketing Performance Audit',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: isDark ? Colors.white : AppColors.darkTextPrimary,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF10B981).withValues(alpha: 0.12),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: const Text(
                                      'AUDITED',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF10B981),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Generated for Period: $_selectedDateRange • Prepared by HOMIO Operations OS',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Wrap(
                          spacing: 8,
                          children: [
                            OutlinedButton.icon(
                              onPressed: () => _exportReport('CSV'),
                              icon: const Icon(Icons.table_view_rounded, size: 14),
                              label: const Text('CSV', style: TextStyle(fontSize: 12)),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              ),
                            ),
                            OutlinedButton.icon(
                              onPressed: () => _exportReport('Excel'),
                              icon: const Icon(Icons.file_download_outlined, size: 14),
                              label: const Text('Excel', style: TextStyle(fontSize: 12)),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Report Tabs
                  TabBar(
                    controller: _tabController,
                    indicatorColor: AppColors.brandPrimary,
                    labelColor: AppColors.brandPrimary,
                    unselectedLabelColor: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                    tabs: const [
                      Tab(text: 'Executive Summary'),
                      Tab(text: 'Channel Attribution & CPL'),
                      Tab(text: 'Funnel Conversion Velocity'),
                      Tab(text: 'Lost Reasons Audit'),
                    ],
                  ),
                  const Divider(height: 1),

                  // Tab Contents
                  SizedBox(
                    height: 520,
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildExecutiveSummaryTab(isDark),
                        _buildAttributionTab(isDark),
                        _buildVelocityTab(isDark),
                        _buildLostReasonsTab(isDark),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    ),
  );
}

  Widget _buildReportTemplates(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Report Preset',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : AppColors.darkTextPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: ReportType.values.map((type) {
              final isSelected = _selectedReportType == type;
              return ChoiceChip(
                label: Text(type.label),
                selected: isSelected,
                selectedColor: AppColors.brandPrimary.withValues(alpha: 0.2),
                onSelected: (_) => setState(() => _selectedReportType = type),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildExecutiveSummaryTab(bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Key Performance Highlights',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : AppColors.darkTextPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Table(
            border: TableBorder.all(
              color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              borderRadius: BorderRadius.circular(8),
            ),
            children: [
              TableRow(children: [
                _buildReportDataCell('Total Leads Generated', '${_kpis.totalLeads} Leads', isDark),
                _buildReportDataCell('Total Paid Ad Spend', _kpis.spendFormatted, isDark),
                _buildReportDataCell('Cost Per Lead (CPL)', _kpis.cplFormatted, isDark),
              ]),
              TableRow(children: [
                _buildReportDataCell('Customer Bookings', '${_kpis.totalConversions} Orders', isDark),
                _buildReportDataCell('Customer Acq. Cost (CAC)', _kpis.cacFormatted, isDark),
                _buildReportDataCell('Lead-to-Booking Conv.', '${_kpis.conversionRate.toStringAsFixed(1)}%', isDark),
              ]),
              TableRow(children: [
                _buildReportDataCell('Attributed Revenue', _kpis.revenueFormatted, isDark),
                _buildReportDataCell('Blended Return On Ad Spend', '${_kpis.roiPercent.toStringAsFixed(0)}% ROI', isDark),
                _buildReportDataCell('Organic vs Paid Share', '42% Organic / 58% Paid', isDark),
              ]),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            'Executive Notes & Takeaways',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : AppColors.darkTextPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('• Meta Ads remains the most efficient volume channel with CPL of ₹388 and 18.2% conversion rate.', style: TextStyle(fontSize: 12, height: 1.5)),
                SizedBox(height: 4),
                Text('• Google Ads shows higher commercial intent for luxury interior design queries, achieving a 16.5% conversion rate.', style: TextStyle(fontSize: 12, height: 1.5)),
                SizedBox(height: 4),
                Text('• Organic SEO and social media accounts generate 42% of total pipeline at ₹0 direct ad acquisition cost.', style: TextStyle(fontSize: 12, height: 1.5)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttributionTab(bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Table(
        border: TableBorder.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          borderRadius: BorderRadius.circular(8),
        ),
        children: [
          TableRow(
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
            ),
            children: const [
              Padding(padding: EdgeInsets.all(10), child: Text('Channel', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
              Padding(padding: EdgeInsets.all(10), child: Text('Spend (₹)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
              Padding(padding: EdgeInsets.all(10), child: Text('Leads', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
              Padding(padding: EdgeInsets.all(10), child: Text('CPL (₹)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
              Padding(padding: EdgeInsets.all(10), child: Text('CAC (₹)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
              Padding(padding: EdgeInsets.all(10), child: Text('Revenue', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
              Padding(padding: EdgeInsets.all(10), child: Text('ROI', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
            ],
          ),
          ..._channelPerformances.map((item) {
            return TableRow(
              children: [
                Padding(padding: const EdgeInsets.all(10), child: Text(item.channel.label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600))),
                Padding(padding: const EdgeInsets.all(10), child: Text(item.spendFormatted, style: const TextStyle(fontSize: 12))),
                Padding(padding: const EdgeInsets.all(10), child: Text('${item.leadsGenerated}', style: const TextStyle(fontSize: 12))),
                Padding(padding: const EdgeInsets.all(10), child: Text(item.cplFormatted, style: const TextStyle(fontSize: 12))),
                Padding(padding: const EdgeInsets.all(10), child: Text(item.cacFormatted, style: const TextStyle(fontSize: 12))),
                Padding(padding: const EdgeInsets.all(10), child: Text(item.revenueFormatted, style: const TextStyle(fontSize: 12))),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    item.spend == 0 ? 'N/A' : '${item.roiPercent.toStringAsFixed(0)}%',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF10B981)),
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildVelocityTab(bool isDark) {
    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: _funnelStages.length,
      separatorBuilder: (_, _) => const Divider(height: 16),
      itemBuilder: (context, index) {
        final stage = _funnelStages[index];
        final avgDays = [1, 2, 4, 7, 12][index % 5];

        return Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: AppColors.brandPrimary.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                '${index + 1}',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.brandPrimary),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    stage.stageName,
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                  ),
                  Text(
                    '${stage.count} leads converted • ${stage.conversionRateFromPrevious.toStringAsFixed(1)}% conversion rate',
                    style: TextStyle(fontSize: 11, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                'Avg Velocity: $avgDays days',
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildLostReasonsTab(bool isDark) {
    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: _decliningReasons.length,
      separatorBuilder: (_, _) => const Divider(height: 16),
      itemBuilder: (context, index) {
        final reason = _decliningReasons[index];
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(reason.reason.icon, color: reason.reason.color, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${reason.reason.label} (${reason.percentage.toStringAsFixed(1)}%)',
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Recommended Action: ${reason.suggestedAction}',
                    style: TextStyle(fontSize: 11, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                  ),
                ],
              ),
            ),
            Text(
              '${reason.count} lost leads',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: reason.reason.color),
            ),
          ],
        );
      },
    );
  }

  Widget _buildReportDataCell(String label, String value, bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 11, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: isDark ? Colors.white : AppColors.darkTextPrimary),
          ),
        ],
      ),
    );
  }
}
