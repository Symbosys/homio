import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../data/marketing_repository.dart';
import '../domain/marketing_enums.dart';
import '../domain/marketing_models.dart';
import '../widgets/campaign_create_dialog.dart';
import '../widgets/campaign_detail_modal.dart';
import '../widgets/marketing_header.dart';

class MarketingCampaignsPage extends StatefulWidget {
  final String? initialChannel;

  const MarketingCampaignsPage({
    super.key,
    this.initialChannel,
  });

  @override
  State<MarketingCampaignsPage> createState() => _MarketingCampaignsPageState();
}

class _MarketingCampaignsPageState extends State<MarketingCampaignsPage> {
  final _repo = MarketingRepository();
  String _searchQuery = '';
  CampaignStatus? _selectedStatus;
  MarketingChannel? _selectedChannel;
  bool _isRefreshing = false;
  late List<CampaignItem> _campaigns;

  @override
  void initState() {
    super.initState();
    if (widget.initialChannel != null) {
      _selectedChannel = MarketingChannel.values.cast<MarketingChannel?>().firstWhere(
            (c) => c?.name == widget.initialChannel,
            orElse: () => null,
          );
    }
    _loadData();
  }

  void _loadData() {
    _campaigns = _repo.getCampaigns();
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

  void _openLaunchDialog() {
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

  void _openCampaignDetails(CampaignItem camp) {
    CampaignDetailModal.show(
      context,
      campaign: camp,
      onStatusChanged: (newStatus) {
        _repo.updateCampaignStatus(camp.id, newStatus);
        _handleRefresh();
      },
      onBudgetUpdated: (newBudget) {
        _repo.updateCampaignBudget(camp.id, newBudget);
        _handleRefresh();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final filtered = _campaigns.where((c) {
      if (_selectedStatus != null && c.status != _selectedStatus) return false;
      if (_selectedChannel != null && c.channel != _selectedChannel) return false;
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        return c.name.toLowerCase().contains(q) || c.channel.label.toLowerCase().contains(q);
      }
      return true;
    }).toList();

    // Summary calculations
    final activeCount = _campaigns.where((c) => c.status == CampaignStatus.active).length;
    final totalBudget = _campaigns.fold<double>(0, (sum, c) => sum + c.budget);
    final totalSpend = _campaigns.fold<double>(0, (sum, c) => sum + c.spent);
    final totalLeads = _campaigns.fold<int>(0, (sum, c) => sum + c.leadsGenerated);
    final blendedCpl = totalLeads > 0 ? (totalSpend / totalLeads) : 0.0;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          key: const PageStorageKey('marketing_campaigns_scroll_key'),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              MarketingHeader(
                title: 'Ad Campaigns',
                subtitle: 'Meta Ads & Google Ads flight management, budget pacing, and CPA/ROAS optimization',
                isRefreshing: _isRefreshing,
                onRefresh: _handleRefresh,
                primaryActionLabel: 'Launch Campaign',
                primaryActionIcon: Icons.rocket_launch_rounded,
                onPrimaryAction: _openLaunchDialog,
              ),
              const SizedBox(height: 20),
            // Top Summary KPIs Strip
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCard : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildSummaryItem('Active Campaigns', '$activeCount of ${_campaigns.length}', isDark),
                  _buildSummaryItem('Total Allocated Budget', '₹${(totalBudget / 100000).toStringAsFixed(1)} Lakhs', isDark),
                  _buildSummaryItem('Lifetime Ad Spend', '₹${(totalSpend / 100000).toStringAsFixed(2)} Lakhs', isDark),
                  _buildSummaryItem('Paid Leads Acquired', '$totalLeads', isDark),
                  _buildSummaryItem('Blended CPL', '₹${blendedCpl.toStringAsFixed(0)}', isDark),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Controls Bar: Search, Status Filter, Channel Filter
            Container(
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
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Search campaigns by name...',
                            prefixIcon: const Icon(Icons.search, size: 20),
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          onChanged: (val) => setState(() => _searchQuery = val.trim()),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<MarketingChannel?>(
                            value: _selectedChannel,
                            hint: const Text('All Channels'),
                            items: [
                              const DropdownMenuItem(value: null, child: Text('All Channels')),
                              DropdownMenuItem(value: MarketingChannel.metaAds, child: Text(MarketingChannel.metaAds.label)),
                              DropdownMenuItem(value: MarketingChannel.googleAds, child: Text(MarketingChannel.googleAds.label)),
                            ],
                            onChanged: (val) => setState(() => _selectedChannel = val),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      FilterChip(
                        label: const Text('All Statuses'),
                        selected: _selectedStatus == null,
                        onSelected: (_) => setState(() => _selectedStatus = null),
                      ),
                      ...CampaignStatus.values.map((s) {
                        return FilterChip(
                          label: Text(s.label),
                          selected: _selectedStatus == s,
                          onSelected: (_) => setState(() => _selectedStatus = s),
                        );
                      }),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Campaigns List
            if (filtered.isEmpty)
              Container(
                padding: const EdgeInsets.all(40),
                alignment: Alignment.center,
                child: Text(
                  'No campaigns matched the current filters.',
                  style: TextStyle(color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filtered.length,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final camp = filtered[index];
                  return _buildCampaignCard(camp, isDark);
                },
              ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    ),
  );
}

  Widget _buildSummaryItem(String label, String value, bool isDark) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 11, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: isDark ? Colors.white : AppColors.darkTextPrimary),
        ),
      ],
    );
  }

  Widget _buildCampaignCard(CampaignItem c, bool isDark) {
    final budgetProgress = c.budget > 0 ? (c.spent / c.budget).clamp(0.0, 1.0) : 0.0;

    return Container(
      padding: const EdgeInsets.all(18),
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
          // Header Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.brandPrimary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(c.channel.icon, color: AppColors.brandPrimary, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          c.name,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: isDark ? Colors.white : AppColors.darkTextPrimary,
                          ),
                        ),
                        const SizedBox(width: 8),
                        _buildStatusBadge(c.status),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${c.channel.label} • ${c.objective.label} • Started ${c.startDate.day}/${c.startDate.month}/${c.startDate.year}',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              // Status Toggle Switch
              Row(
                children: [
                  Text(
                    c.status == CampaignStatus.active ? 'Active' : 'Paused',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: c.status == CampaignStatus.active ? const Color(0xFF10B981) : Colors.grey,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Switch(
                    value: c.status == CampaignStatus.active,
                    activeThumbColor: const Color(0xFF10B981),
                    onChanged: (val) {
                      final newStatus = val ? CampaignStatus.active : CampaignStatus.paused;
                      _repo.updateCampaignStatus(c.id, newStatus);
                      _handleRefresh();
                    },
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Budget Pacing Bar
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Budget Spent: ${c.spentFormatted} of ${c.budgetFormatted} (${(budgetProgress * 100).toStringAsFixed(0)}%)',
                    style: TextStyle(fontSize: 11, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                  ),
                  Text(
                    'Remaining: ₹${(c.budget - c.spent).clamp(0, double.infinity).toStringAsFixed(0)}',
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF10B981)),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: budgetProgress,
                  backgroundColor: isDark ? Colors.white10 : Colors.black12,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    budgetProgress > 0.9 ? Colors.red : AppColors.brandPrimary,
                  ),
                  minHeight: 6,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Performance Metrics Strip
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildMetricCell('Leads', '${c.leadsGenerated}', isDark),
                _buildMetricCell('Cost / Lead', c.cplFormatted, isDark),
                _buildMetricCell('Conversions', '${c.conversions}', isDark),
                _buildMetricCell('CAC', c.cacFormatted, isDark),
                _buildMetricCell('Conv. Rate', '${c.conversionRate.toStringAsFixed(1)}%', isDark),
                _buildMetricCell('CTR / CPC', '${c.ctr.toStringAsFixed(1)}% / ${c.cpcFormatted}', isDark),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // Card Footer
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${c.impressions} impressions • ${c.clicks} link clicks',
                style: TextStyle(fontSize: 11, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
              ),
              Row(
                children: [
                  OutlinedButton.icon(
                    onPressed: () => _openCampaignDetails(c),
                    icon: const Icon(Icons.analytics_outlined, size: 14),
                    label: const Text('360° Analytics & Creative', style: TextStyle(fontSize: 12)),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCell(String label, String value, bool isDark) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 10, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
        ),
        const SizedBox(height: 3),
        Text(
          value,
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: isDark ? Colors.white : AppColors.darkTextPrimary),
        ),
      ],
    );
  }

  Widget _buildStatusBadge(CampaignStatus status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: status.color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        status.label,
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: status.color),
      ),
    );
  }
}
