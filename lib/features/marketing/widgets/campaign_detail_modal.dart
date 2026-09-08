import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../domain/marketing_enums.dart';
import '../domain/marketing_models.dart';

class CampaignDetailModal extends StatefulWidget {
  final CampaignItem campaign;
  final ValueChanged<CampaignStatus>? onStatusChanged;
  final ValueChanged<double>? onBudgetUpdated;

  const CampaignDetailModal({
    super.key,
    required this.campaign,
    this.onStatusChanged,
    this.onBudgetUpdated,
  });

  static Future<void> show(
    BuildContext context, {
    required CampaignItem campaign,
    ValueChanged<CampaignStatus>? onStatusChanged,
    ValueChanged<double>? onBudgetUpdated,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => CampaignDetailModal(
        campaign: campaign,
        onStatusChanged: onStatusChanged,
        onBudgetUpdated: onBudgetUpdated,
      ),
    );
  }

  @override
  State<CampaignDetailModal> createState() => _CampaignDetailModalState();
}

class _CampaignDetailModalState extends State<CampaignDetailModal> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late CampaignStatus _currentStatus;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _currentStatus = widget.campaign.status;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final modalWidth = screenWidth > 900 ? 850.0 : screenWidth * 0.95;
    final c = widget.campaign;

    return Dialog(
      backgroundColor: isDark ? AppColors.darkCard : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Container(
        width: modalWidth,
        constraints: const BoxConstraints(maxHeight: 700),
        child: Column(
          children: [
            // Modal Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.brandPrimary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(c.channel.icon, color: AppColors.brandPrimary, size: 24),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              c.name,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: isDark ? Colors.white : AppColors.darkTextPrimary,
                              ),
                            ),
                            const SizedBox(width: 10),
                            _buildStatusBadge(_currentStatus),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${c.channel.label} • ${c.objective.label} • Started ${_formatDate(c.startDate)}',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),

            // Top Metrics Strip
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              color: isDark ? AppColors.darkBackground.withValues(alpha: 0.5) : AppColors.lightBackground.withValues(alpha: 0.5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildMetricCell('Spend / Budget', '${c.spentFormatted} / ${c.budgetFormatted}', isDark),
                  _buildMetricCell('Leads Generated', '${c.leadsGenerated}', isDark),
                  _buildMetricCell('Cost Per Lead', c.cplFormatted, isDark),
                  _buildMetricCell('Conversions', '${c.conversions}', isDark),
                  _buildMetricCell('CAC', c.cacFormatted, isDark),
                  _buildMetricCell('CTR / CPC', '${c.ctr.toStringAsFixed(1)}% / ${c.cpcFormatted}', isDark),
                ],
              ),
            ),

            // Tab Bar
            TabBar(
              controller: _tabController,
              indicatorColor: AppColors.brandPrimary,
              labelColor: AppColors.brandPrimary,
              unselectedLabelColor: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              tabs: const [
                Tab(text: 'Performance'),
                Tab(text: 'Ad Creative'),
                Tab(text: 'Audience & Targeting'),
                Tab(text: 'Linked CRM Leads'),
              ],
            ),
            const Divider(height: 1),

            // Tab Views
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildPerformanceTab(c, isDark),
                  _buildCreativeTab(c, isDark),
                  _buildAudienceTab(c, isDark),
                  _buildLeadsTab(c, isDark),
                ],
              ),
            ),

            // Modal Footer Actions
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton.icon(
                    onPressed: () {
                      final newStatus = _currentStatus == CampaignStatus.active
                          ? CampaignStatus.paused
                          : CampaignStatus.active;
                      setState(() => _currentStatus = newStatus);
                      widget.onStatusChanged?.call(newStatus);
                    },
                    icon: Icon(
                      _currentStatus == CampaignStatus.active ? Icons.pause_rounded : Icons.play_arrow_rounded,
                      size: 16,
                    ),
                    label: Text(_currentStatus == CampaignStatus.active ? 'Pause Campaign' : 'Resume Campaign'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: _currentStatus == CampaignStatus.active ? Colors.orange : Colors.green,
                    ),
                  ),
                  Row(
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Close'),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton.icon(
                        onPressed: () {
                          _showBudgetDialog(context, c);
                        },
                        icon: const Icon(Icons.account_balance_wallet_outlined, size: 16),
                        label: const Text('Adjust Budget'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.brandPrimary,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCell(String label, String value, bool isDark) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: isDark ? Colors.white : AppColors.darkTextPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildPerformanceTab(CampaignItem c, bool isDark) {
    final budgetProgress = c.budget > 0 ? (c.spent / c.budget).clamp(0.0, 1.0) : 0.0;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Budget Utilization & Pace',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : AppColors.darkTextPrimary,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${(budgetProgress * 100).toStringAsFixed(1)}% of ₹${c.budget.toStringAsFixed(0)} spent',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
              ),
              Text(
                'Remaining: ₹${(c.budget - c.spent).clamp(0, double.infinity).toStringAsFixed(0)}',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF10B981)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: budgetProgress,
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
            backgroundColor: isDark ? Colors.white10 : Colors.black12,
            valueColor: AlwaysStoppedAnimation<Color>(
              budgetProgress > 0.9 ? Colors.red : AppColors.brandPrimary,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Funnel & Efficiency Metrics',
            style: TextStyle(
              fontSize: 14,
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
                _buildTableRowCell('Impressions', '${c.impressions}', isDark),
                _buildTableRowCell('Clicks', '${c.clicks}', isDark),
                _buildTableRowCell('Click-Through Rate (CTR)', '${c.ctr.toStringAsFixed(2)}%', isDark),
              ]),
              TableRow(children: [
                _buildTableRowCell('Cost Per Click (CPC)', c.cpcFormatted, isDark),
                _buildTableRowCell('Cost Per Lead (CPL)', c.cplFormatted, isDark),
                _buildTableRowCell('CAC', c.cacFormatted, isDark),
              ]),
              TableRow(children: [
                _buildTableRowCell('Lead-to-Booking Conv.', '${c.conversionRate.toStringAsFixed(1)}%', isDark),
                _buildTableRowCell('Total Attributed Revenue', '₹${((c.conversions * 450000) / 100000).toStringAsFixed(2)}L', isDark),
                _buildTableRowCell('Estimated ROAS', '${((c.conversions * 450000 - c.spent) / c.spent * 100).toStringAsFixed(0)}%', isDark),
              ]),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCreativeTab(CampaignItem c, bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(c.channel.icon, size: 20, color: AppColors.brandPrimary),
                    const SizedBox(width: 8),
                    Text(
                      'Ad Creative Preview (${c.channel.label})',
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'Primary Headline:',
                  style: TextStyle(fontSize: 11, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                ),
                Text(
                  'Luxury 3BHK Interiors in Pune & Mumbai | Starting ₹8.5 Lakhs',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : AppColors.darkTextPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Primary Ad Copy:',
                  style: TextStyle(fontSize: 11, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                ),
                Text(
                  'Experience bespoke architectural interior design with 45-day guaranteed handover, 10-year warranty, and 3D VR walkthroughs. Book your free designer consultation today.',
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.4,
                    color: isDark ? Colors.white70 : AppColors.darkTextPrimary,
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.brandPrimary,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'Get Free Quote',
                        style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'homio.in/interiors-quote',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAudienceTab(CampaignItem c, bool isDark) {
    final targets = [
      {'label': 'Location', 'value': 'Mumbai, Pune, Thane, Navi Mumbai (Within 25km radius)'},
      {'label': 'Demographics', 'value': 'Age 28 - 55, All Genders, Household Income > ₹15L/yr'},
      {'label': 'Interests & Behaviors', 'value': 'Interior design, Architecture, Modular kitchens, Luxury lifestyle, Home decor, New home buyers'},
      {'label': 'Placements', 'value': 'Instagram Feed, Reels, Facebook Feed, Google Search Top Ads'},
      {'label': 'Exclusions', 'value': 'Existing booked customers, job seekers in architecture'},
    ];

    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: targets.length,
      separatorBuilder: (_, _) => const Divider(height: 16),
      itemBuilder: (context, index) {
        final t = targets[index];
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 160,
              child: Text(
                t['label']!,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                ),
              ),
            ),
            Expanded(
              child: Text(
                t['value']!,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: isDark ? Colors.white : AppColors.darkTextPrimary,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildLeadsTab(CampaignItem c, bool isDark) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: c.leadsGenerated > 8 ? 8 : c.leadsGenerated,
      separatorBuilder: (_, _) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final names = ['Vikram Sharma', 'Ananya Deshmukh', 'Rajesh Kulkarni', 'Pooja Mehta', 'Sameer Verma', 'Neha Joshi', 'Karan Patel', 'Meera Rao'];
        final leadName = names[index % names.length];
        final leadBudget = ['₹12 Lakhs', '₹18 Lakhs', '₹9 Lakhs', '₹25 Lakhs', '₹15 Lakhs'][index % 5];
        final leadStatus = ['Site Visit Scheduled', 'Quotation Sent', 'Contacted', 'Won / Booked'][index % 4];

        return ListTile(
          dense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          leading: CircleAvatar(
            radius: 16,
            backgroundColor: AppColors.brandPrimary.withValues(alpha: 0.15),
            child: Text(
              leadName.substring(0, 1),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.brandPrimary),
            ),
          ),
          title: Text(leadName, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
          subtitle: Text('Budget: $leadBudget • $leadStatus', style: const TextStyle(fontSize: 11)),
          trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
        );
      },
    );
  }

  Widget _buildTableRowCell(String label, String value, bool isDark) {
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
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: isDark ? Colors.white : AppColors.darkTextPrimary),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(CampaignStatus status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: status.color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        status.label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: status.color,
        ),
      ),
    );
  }

  String _formatDate(DateTime dt) {
    return '${dt.day}/${dt.month}/${dt.year}';
  }

  void _showBudgetDialog(BuildContext context, CampaignItem c) {
    final controller = TextEditingController(text: c.budget.toStringAsFixed(0));
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Update Campaign Budget'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'New Total Budget (₹)',
            prefixText: '₹ ',
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final newBudget = double.tryParse(controller.text);
              if (newBudget != null && newBudget > 0) {
                widget.onBudgetUpdated?.call(newBudget);
                Navigator.of(ctx).pop();
                setState(() {});
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
