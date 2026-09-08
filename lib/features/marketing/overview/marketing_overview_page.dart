import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../data/marketing_repository.dart';
import '../domain/marketing_enums.dart';
import '../domain/marketing_models.dart';
import '../widgets/campaign_create_dialog.dart';
import '../widgets/channel_performance_table.dart';
import '../widgets/marketing_funnel_widget.dart';
import '../widgets/marketing_header.dart';
import '../widgets/marketing_kpi_card.dart';

class MarketingOverviewPage extends StatefulWidget {
  const MarketingOverviewPage({super.key});

  @override
  State<MarketingOverviewPage> createState() => _MarketingOverviewPageState();
}

class _MarketingOverviewPageState extends State<MarketingOverviewPage> {
  final _repo = MarketingRepository();
  String _selectedDateRange = 'Last 30 Days';
  MarketingChannel? _selectedChannel;
  bool _isRefreshing = false;

  late MarketingKpiSummary _kpis;
  late List<AcquisitionFunnelStage> _funnelStages;
  late OrganicVsPaidBreakdown _organicVsPaid;
  late List<ChannelPerformanceItem> _channelPerformances;
  late List<DecliningReasonMetric> _decliningReasons;
  late List<MarketingAlert> _alerts;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    _kpis = _repo.getKpiSummary(dateRange: _selectedDateRange, channel: _selectedChannel);
    _funnelStages = _repo.getAcquisitionFunnel();
    _organicVsPaid = _repo.getOrganicVsPaid();
    _channelPerformances = _repo.getChannelPerformance();
    _decliningReasons = _repo.getDecliningReasons();
    _alerts = _repo.getMarketingAlerts();
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

  void _openNewCampaignDialog() {
    CampaignCreateDialog.show(
      context,
      onCampaignCreated: (newCamp) {
        _repo.addCampaign(newCamp);
        _handleRefresh();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Campaign "${newCamp.name}" launched successfully!')),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          key: const PageStorageKey('marketing_overview_scroll_key'),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              MarketingHeader(
                title: 'Marketing Overview',
                subtitle: 'Full-funnel demand generation, ad attribution, and multi-channel unit economics',
                selectedDateRange: _selectedDateRange,
                selectedChannel: _selectedChannel,
                isRefreshing: _isRefreshing,
                onDateRangeChanged: (val) {
                  setState(() {
                    _selectedDateRange = val;
                    _loadData();
                  });
                },
                onChannelChanged: (ch) {
                  setState(() {
                    _selectedChannel = ch;
                    _loadData();
                  });
                },
                onRefresh: _handleRefresh,
                primaryActionLabel: 'New Campaign',
                primaryActionIcon: Icons.campaign_rounded,
                onPrimaryAction: _openNewCampaignDialog,
              ),
              const SizedBox(height: 20),
            // Marketing Alerts Banner (if any)
            if (_alerts.isNotEmpty) ...[
              _buildAlertsBanner(isDark),
              const SizedBox(height: 20),
            ],

            // Top Row of 4 Primary KPIs
            LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 900;
                final isMedium = constraints.maxWidth > 600;
                final crossAxisCount = isWide ? 4 : (isMedium ? 2 : 1);

                return GridView.count(
                  crossAxisCount: crossAxisCount,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: isWide ? 1.35 : 1.8,
                  children: [
                    MarketingKpiCard(
                      title: 'Total Leads Generated',
                      value: '${_kpis.totalLeads}',
                      trendPercent: _kpis.leadsTrend,
                      subtitle: 'vs prior period',
                      icon: Icons.group_add_rounded,
                      iconColor: const Color(0xFF6366F1),
                      formulaTooltip: 'PRD: Total acquisition across Meta, Google, Organic & Social',
                      onTap: () => context.go('/sales/leads'),
                    ),
                    MarketingKpiCard(
                      title: 'Total Ad Spend',
                      value: _kpis.spendFormatted,
                      trendPercent: _kpis.spendTrend,
                      subtitle: 'Meta & Google Ads',
                      icon: Icons.monetization_on_rounded,
                      iconColor: const Color(0xFFEC4899),
                      formulaTooltip: 'Sum of real-time paid ad spend across connected accounts',
                    ),
                    MarketingKpiCard(
                      title: 'Cost Per Lead (CPL)',
                      value: _kpis.cplFormatted,
                      trendPercent: _kpis.cplTrend,
                      isPositiveGood: false,
                      subtitle: 'Ad Spend / Leads',
                      icon: Icons.price_check_rounded,
                      iconColor: const Color(0xFF06B6D4),
                      formulaTooltip: 'PRD Rule: CPL = Total Ad Spend / Total Leads (₹5,24,000 / 1,248)',
                    ),
                    MarketingKpiCard(
                      title: 'Total Conversions',
                      value: '${_kpis.totalConversions}',
                      trendPercent: _kpis.conversionsTrend,
                      subtitle: '${_kpis.conversionRate.toStringAsFixed(1)}% booking rate',
                      icon: Icons.verified_rounded,
                      iconColor: const Color(0xFF10B981),
                      formulaTooltip: 'PRD: Leads converted to signed interior/architecture agreements',
                      onTap: () => context.go('/sales/customers'),
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 16),

            // Secondary Row of 4 Efficiency & ROI KPIs
            LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 900;
                final isMedium = constraints.maxWidth > 600;
                final crossAxisCount = isWide ? 4 : (isMedium ? 2 : 1);

                return GridView.count(
                  crossAxisCount: crossAxisCount,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: isWide ? 1.35 : 1.8,
                  children: [
                    MarketingKpiCard(
                      title: 'Customer Acq. Cost (CAC)',
                      value: _kpis.cacFormatted,
                      trendPercent: -4.2,
                      isPositiveGood: false,
                      subtitle: 'Ad Spend / Bookings',
                      icon: Icons.account_balance_wallet_rounded,
                      iconColor: const Color(0xFF8B5CF6),
                      formulaTooltip: 'PRD Rule: CAC = Total Ad Spend / Bookings (₹5,24,000 / 142)',
                    ),
                    MarketingKpiCard(
                      title: 'Attributed Revenue',
                      value: _kpis.revenueFormatted,
                      trendPercent: 18.6,
                      subtitle: 'Closed order value',
                      icon: Icons.trending_up_rounded,
                      iconColor: const Color(0xFF10B981),
                      formulaTooltip: 'Closed project agreements attributed to active marketing sources',
                    ),
                    MarketingKpiCard(
                      title: 'Return on Ad Spend (ROI)',
                      value: '${_kpis.roiPercent.toStringAsFixed(0)}%',
                      trendPercent: 15.3,
                      subtitle: '(Revenue - Spend) / Spend',
                      icon: Icons.auto_graph_rounded,
                      iconColor: const Color(0xFFF59E0B),
                      formulaTooltip: 'PRD Rule: ROI = (Revenue - Spend) / Spend * 100%',
                    ),
                    MarketingKpiCard(
                      title: 'Organic vs Paid Split',
                      value: '${_organicVsPaid.organicShare.toStringAsFixed(0)}% / ${_organicVsPaid.paidShare.toStringAsFixed(0)}%',
                      trendPercent: 2.1,
                      subtitle: 'Organic leads growing',
                      icon: Icons.pie_chart_rounded,
                      iconColor: const Color(0xFF3B82F6),
                      formulaTooltip: 'Ratio of organic search/social leads vs paid campaign acquisitions',
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 24),

            // Middle Section: Acquisition Funnel (Left) & Organic vs Paid Card (Right)
            LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 900;
                if (isWide) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 6,
                        child: MarketingFunnelWidget(stages: _funnelStages),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        flex: 4,
                        child: _buildOrganicVsPaidCard(isDark),
                      ),
                    ],
                  );
                } else {
                  return Column(
                    children: [
                      MarketingFunnelWidget(stages: _funnelStages),
                      const SizedBox(height: 20),
                      _buildOrganicVsPaidCard(isDark),
                    ],
                  );
                }
              },
            ),

            const SizedBox(height: 24),

            // Channel Performance Table
            ChannelPerformanceTable(
              items: _channelPerformances,
              onChannelTap: (channelItem) {
                context.go('/marketing/campaigns?channel=${channelItem.channel.name}');
              },
            ),

            const SizedBox(height: 24),

            // Declining Reasons Analytics Card
            _buildDecliningReasonsCard(isDark),

            const SizedBox(height: 20),
          ],
        ),
      ),
    ),
  );
}

  Widget _buildAlertsBanner(bool isDark) {
    return Column(
      children: _alerts.map((alert) {
        final alertColor = alert.severity == 'critical'
            ? const Color(0xFFEF4444)
            : (alert.severity == 'warning' ? const Color(0xFFF59E0B) : const Color(0xFF3B82F6));

        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: alertColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: alertColor.withValues(alpha: 0.3)),
          ),
          child: Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: alertColor, size: 18),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  alert.message,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: isDark ? Colors.white : AppColors.darkTextPrimary,
                  ),
                ),
              ),
              if (alert.actionLabel != null)
                TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Executing: ${alert.actionLabel}')),
                    );
                  },
                  child: Text(
                    alert.actionLabel!,
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: alertColor),
                  ),
                ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildOrganicVsPaidCard(bool isDark) {
    final o = _organicVsPaid;

    return Container(
      padding: const EdgeInsets.all(20),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Organic vs Paid Split',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : AppColors.darkTextPrimary,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  '42% Zero-CAC',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF10B981),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // Split Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              height: 12,
              child: Row(
                children: [
                  Expanded(
                    flex: o.organicShare.toInt(),
                    child: Container(color: const Color(0xFF10B981)),
                  ),
                  Expanded(
                    flex: o.paidShare.toInt(),
                    child: Container(color: const Color(0xFF6366F1)),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(width: 10, height: 10, decoration: const BoxDecoration(color: Color(0xFF10B981), shape: BoxShape.circle)),
                  const SizedBox(width: 6),
                  Text('Organic (${o.organicShare.toStringAsFixed(0)}%)', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                ],
              ),
              Row(
                children: [
                  Container(width: 10, height: 10, decoration: const BoxDecoration(color: Color(0xFF6366F1), shape: BoxShape.circle)),
                  const SizedBox(width: 6),
                  Text('Paid Ads (${o.paidShare.toStringAsFixed(0)}%)', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildComparisonRow('Total Leads', '${o.organicLeads}', '${o.paidLeads}', isDark),
          const Divider(height: 16),
          _buildComparisonRow('Total Spend', '₹0 (Zero Ad Spend)', '₹${(o.paidSpend / 100000).toStringAsFixed(2)} Lakhs', isDark),
          const Divider(height: 16),
          _buildComparisonRow('Cost Per Lead', '₹0', '₹${o.paidCpl.toStringAsFixed(0)}', isDark),
          const Divider(height: 16),
          _buildComparisonRow('Conversions', '${o.organicConversions}', '${o.paidConversions}', isDark),
          const Divider(height: 16),
          _buildComparisonRow('Effective CAC', '₹0', '₹${o.paidCac.toStringAsFixed(0)}', isDark),
        ],
      ),
    );
  }

  Widget _buildComparisonRow(String label, String organicVal, String paidVal, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Row(
          children: [
            Text(
              organicVal,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF10B981)),
            ),
            const Text('  vs  ', style: TextStyle(fontSize: 11, color: Colors.grey)),
            Text(
              paidVal,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF6366F1)),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDecliningReasonsCard(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Lost & Declining Reason Analytics',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : AppColors.darkTextPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Root causes of lead drop-offs with AI mitigation actions',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFEF4444).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'PRD Tracked',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFEF4444),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ..._decliningReasons.map((reason) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkBackground.withValues(alpha: 0.5) : AppColors.lightBackground.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(reason.reason.icon, size: 16, color: reason.reason.color),
                            const SizedBox(width: 8),
                            Text(
                              reason.reason.label,
                              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                            ),
                          ],
                        ),
                        Text(
                          '${reason.count} leads (${reason.percentage.toStringAsFixed(1)}%)',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                            color: reason.reason.color,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: reason.percentage / 100,
                        backgroundColor: isDark ? Colors.white10 : Colors.black12,
                        valueColor: AlwaysStoppedAnimation<Color>(reason.reason.color),
                        minHeight: 6,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.lightbulb_outline_rounded, size: 13, color: Colors.orange),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            'Action: ${reason.suggestedAction}',
                            style: TextStyle(
                              fontSize: 11,
                              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
