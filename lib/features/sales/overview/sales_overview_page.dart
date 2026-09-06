import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../models/sales_models.dart';
import '../models/sales_mock_data.dart';
import '../widgets/sales_header.dart';
import '../widgets/sales_metric_card.dart';

class SalesOverviewPage extends StatefulWidget {
  const SalesOverviewPage({super.key});

  @override
  State<SalesOverviewPage> createState() => _SalesOverviewPageState();
}

class _SalesOverviewPageState extends State<SalesOverviewPage> {
  SalesDateFilter _selectedDateFilter = SalesDateFilter.thisMonth;
  String _selectedAgentId = 'USR-001';

  final List<Map<String, dynamic>> _agents = [
    {
      'id': 'USR-001',
      'name': 'Rahul Sharma',
      'role': 'Senior Closer',
      'avatar': 'RS',
      'base': 45000,
      'closedRev': 3850000,
      'closedDeals': 6,
      'commRate': 0.025,
      'callsDone': 420,
      'callRate': 15,
      'meetings': 14,
      'meetingRate': 1200,
      'penalties': 2500,
      'leads': 48,
      'cycle': 14.2,
      'target': 4500000,
    },
    {
      'id': 'USR-002',
      'name': 'Sneha Kapoor',
      'role': 'Luxury Specialist',
      'avatar': 'SK',
      'base': 50000,
      'closedRev': 4620000,
      'closedDeals': 5,
      'commRate': 0.03,
      'callsDone': 380,
      'callRate': 15,
      'meetings': 18,
      'meetingRate': 1200,
      'penalties': 1000,
      'leads': 39,
      'cycle': 18.5,
      'target': 5000000,
    },
    {
      'id': 'USR-003',
      'name': 'Amit Verma',
      'role': 'Turnkey Fit-out Lead',
      'avatar': 'AV',
      'base': 40000,
      'closedRev': 2950000,
      'closedDeals': 4,
      'commRate': 0.02,
      'callsDone': 510,
      'callRate': 15,
      'meetings': 11,
      'meetingRate': 1200,
      'penalties': 3500,
      'leads': 55,
      'cycle': 12.8,
      'target': 3500000,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final currentAgent = _agents.firstWhere(
      (a) => a['id'] == _selectedAgentId,
      orElse: () => _agents.first,
    );

    final double bookingCommission = (currentAgent['closedRev'] as num) * (currentAgent['commRate'] as double);
    final double callBonus = (currentAgent['callsDone'] as num) * (currentAgent['callRate'] as num).toDouble();
    final double meetingBonus = (currentAgent['meetings'] as num) * (currentAgent['meetingRate'] as num).toDouble();
    final double baseSalary = (currentAgent['base'] as num).toDouble();
    final double penalties = (currentAgent['penalties'] as num).toDouble();
    final double netIncentivePayout = baseSalary + bookingCommission + callBonus + meetingBonus - penalties;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SalesHeader(
              title: 'Sales Dashboard & Goal Tracking',
              subtitle: 'Multi-funnel conversion velocity, quota attainment gauge & dynamic incentive engine',
              icon: Icons.analytics_outlined,
              activeFilter: _selectedDateFilter,
              onFilterChanged: (filter) => setState(() => _selectedDateFilter = filter),
              primaryAction: ElevatedButton.icon(
                icon: const Icon(Icons.file_download_outlined, size: 14),
                label: const Text('Export P&L', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                  elevation: 0,
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Executive sales performance report generated.')),
                  );
                },
              ),
              additionalFilters: [
                OutlinedButton.icon(
                  icon: const Icon(Icons.tune_outlined, size: 14),
                  label: const Text('Set Targets', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600)),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                  ),
                  onPressed: () => _showQuotaModal(context),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Metrics Strip
            LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 900;
                final isMedium = constraints.maxWidth > 600;
                final double width = isWide
                    ? (constraints.maxWidth - 48) / 4
                    : isMedium
                        ? (constraints.maxWidth - 16) / 2
                        : constraints.maxWidth;

                return Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: SalesMockData.overviewKpis.map((metric) {
                    return SizedBox(
                      width: width,
                      child: SalesMetricCard(metric: metric),
                    );
                  }).toList(),
                );
              },
            ),
            const SizedBox(height: 18),

            // Middle Row: Funnel Velocity + Target Quota Gauge
            LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 960;
                if (isWide) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 7, child: _buildFunnelVelocityCard(context, isDark)),
                      const SizedBox(width: 14),
                      Expanded(flex: 5, child: _buildQuotaGaugeCard(context, isDark)),
                    ],
                  );
                } else {
                  return Column(
                    children: [
                      _buildFunnelVelocityCard(context, isDark),
                      const SizedBox(height: 14),
                      _buildQuotaGaugeCard(context, isDark),
                    ],
                  );
                }
              },
            ),
            const SizedBox(height: 18),

            // Dynamic Commission & Incentive Engine Hero Section
            _buildCommissionEngineSection(
              context,
              isDark,
              currentAgent,
              baseSalary,
              bookingCommission,
              callBonus,
              meetingBonus,
              penalties,
              netIncentivePayout,
            ),
            const SizedBox(height: 18),

            // Closer Leaderboard Table
            _buildLeaderboardCard(context, isDark),
            const SizedBox(height: 18),

            // Channel Telemetry Card
            _buildChannelTelemetryCard(context, isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildFunnelVelocityCard(BuildContext context, bool isDark) {
    final stages = [
      {'name': 'Lead In & Capture', 'count': 340, 'val': '₹18.2 Cr', 'conv': '100%', 'color': const Color(0xFF3B82F6)},
      {'name': 'Initial Discovery & Budgeting', 'count': 218, 'val': '₹12.4 Cr', 'conv': '64.1%', 'color': const Color(0xFF0EA5E9)},
      {'name': 'Site Survey & Laser Scan', 'count': 136, 'val': '₹8.9 Cr', 'conv': '62.3%', 'color': const Color(0xFF6366F1)},
      {'name': '3D Concept & Quotation', 'count': 84, 'val': '₹5.6 Cr', 'conv': '61.7%', 'color': const Color(0xFF8B5CF6)},
      {'name': 'Final Negotiation & Contract', 'count': 46, 'val': '₹3.1 Cr', 'conv': '54.7%', 'color': const Color(0xFFEC4899)},
      {'name': 'Token Advance Paid (Won)', 'count': 28, 'val': '₹1.84 Cr', 'conv': '60.8%', 'color': const Color(0xFF10B981)},
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
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
                    'Interior Turnkey Funnel Velocity & Drop-off Rates',
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Step-by-step conversion efficiency from enquiry to booking',
                    style: TextStyle(
                      fontSize: 11,
                      color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'Avg Cycle: 15.6 Days',
                  style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600, color: Color(0xFF059669)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ...stages.map((stage) {
            final double percent = (stage['count'] as int) / 340.0;
            return Padding(
              padding: const EdgeInsets.only(bottom: 9),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        stage['name'] as String,
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextSecondary,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            '${stage['count']} leads (${stage['val']})',
                            style: TextStyle(
                              fontSize: 11,
                              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                            decoration: BoxDecoration(
                              color: (stage['color'] as Color).withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(3),
                            ),
                            child: Text(
                              stage['conv'] as String,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: stage['color'] as Color,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(3),
                    child: LinearProgressIndicator(
                      value: percent,
                      minHeight: 5,
                      backgroundColor: isDark ? AppColors.darkBorder : AppColors.lightSurfaceSubtle,
                      valueColor: AlwaysStoppedAnimation<Color>(stage['color'] as Color),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildQuotaGaugeCard(BuildContext context, bool isDark) {
    const double targetRev = 25000000;
    const double achievedRev = 18420000;
    const double progress = achievedRev / targetRev;
    const double pendingRev = targetRev - achievedRev;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Team Quota Attainment',
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                decoration: BoxDecoration(
                  color: const Color(0xFF2563EB).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  '11 Days Left',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Color(0xFF2563EB)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 105,
                  height: 105,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 9,
                    strokeCap: StrokeCap.round,
                    backgroundColor: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                    valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF10B981)),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${(progress * 100).toStringAsFixed(1)}%',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                      ),
                    ),
                    Text(
                      'Achieved',
                      style: TextStyle(
                        fontSize: 9.5,
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Monthly Target:', style: TextStyle(fontSize: 11, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
                    const Text('₹2,50,00,000', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Closed Actuals:', style: TextStyle(fontSize: 11, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
                    const Text('₹1,84,20,000', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF10B981))),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Gap to Target:', style: TextStyle(fontSize: 11, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B))),
                    Text('₹${(pendingRev / 100000).toStringAsFixed(2)} Lakhs', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFFF59E0B))),
                  ],
                ),
                const Divider(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Required Run Rate:', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600, color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569))),
                    const Text('₹5.98L / day', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Color(0xFF2563EB))),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommissionEngineSection(
    BuildContext context,
    bool isDark,
    Map<String, dynamic> currentAgent,
    double baseSalary,
    double bookingCommission,
    double callBonus,
    double meetingBonus,
    double penalties,
    double netPayout,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF2563EB).withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2563EB).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(Icons.calculate_outlined, color: Color(0xFF2563EB), size: 16),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Dynamic Incentive & Commission Calculation Engine',
                        style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w700,
                          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                        ),
                      ),
                      Text(
                        'Base + Booking % + Connects + Surveys - Penalties',
                        style: TextStyle(
                          fontSize: 11,
                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                height: 30,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorderStrong),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedAgentId,
                    style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                    items: _agents.map((a) {
                      return DropdownMenuItem<String>(
                        value: a['id'] as String,
                        child: Text('${a['name']} (${a['role']})'),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedAgentId = val);
                    },
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Math Cards Strip
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 850;
              final double cardWidth = isWide ? (constraints.maxWidth - 48) / 5 : (constraints.maxWidth - 16) / 2;

              return Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _buildMathCard(
                    title: '1. Base Retainer',
                    value: '₹${baseSalary.toStringAsFixed(0)}',
                    subtext: 'Monthly fixed',
                    color: const Color(0xFF64748B),
                    width: cardWidth,
                    isDark: isDark,
                  ),
                  _buildMathCard(
                    title: '2. Booking Spiff (${((currentAgent['commRate'] as double) * 100).toStringAsFixed(1)}%)',
                    value: '+ ₹${bookingCommission.toStringAsFixed(0)}',
                    subtext: '${currentAgent['closedDeals']} deals (₹${((currentAgent['closedRev'] as num) / 100000).toStringAsFixed(1)}L)',
                    color: const Color(0xFF10B981),
                    width: cardWidth,
                    isDark: isDark,
                  ),
                  _buildMathCard(
                    title: '3. Call Connects',
                    value: '+ ₹${callBonus.toStringAsFixed(0)}',
                    subtext: '${currentAgent['callsDone']} calls @ ₹${currentAgent['callRate']}',
                    color: const Color(0xFF3B82F6),
                    width: cardWidth,
                    isDark: isDark,
                  ),
                  _buildMathCard(
                    title: '4. Physical Visits',
                    value: '+ ₹${meetingBonus.toStringAsFixed(0)}',
                    subtext: '${currentAgent['meetings']} visits @ ₹${currentAgent['meetingRate']}',
                    color: const Color(0xFF8B5CF6),
                    width: cardWidth,
                    isDark: isDark,
                  ),
                  _buildMathCard(
                    title: '5. SLA Deductions',
                    value: '- ₹${penalties.toStringAsFixed(0)}',
                    subtext: 'SLA misses',
                    color: const Color(0xFFEF4444),
                    width: cardWidth,
                    isDark: isDark,
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 14),

          // Total Payout Banner
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [AppColors.infoMutedDark, AppColors.darkSurface]
                    : [const Color(0xFFEFF6FF), const Color(0xFFDBEAFE)],
              ),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFF3B82F6).withValues(alpha: 0.35)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'TOTAL PAYABLE INCENTIVE (${currentAgent['name']})',
                      style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                        color: isDark ? const Color(0xFF93C5FD) : const Color(0xFF1E40AF),
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      'Verified by Sales Telemetry Audit Engine',
                      style: TextStyle(fontSize: 10, color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569)),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      '₹${netPayout.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontSize: 16.5,
                        fontWeight: FontWeight.w800,
                        color: isDark ? Colors.white : const Color(0xFF1E3A8A),
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2563EB),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Voucher generated for ${currentAgent['name']}.')),
                        );
                      },
                      child: const Text('Approve Voucher', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600)),
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

  Widget _buildMathCard({
    required String title,
    required String value,
    required String subtext,
    required Color color,
    required double width,
    required bool isDark,
  }) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
          const SizedBox(height: 4),
          Text(value, style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w800, color: color)),
          const SizedBox(height: 2),
          Text(subtext, style: TextStyle(fontSize: 9.5, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
        ],
      ),
    );
  }

  Widget _buildLeaderboardCard(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
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
                    'Sales Executive Leaderboard & Performance Scorecard',
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    'Ranked by closed revenue, conversion velocity & SLA compliance',
                    style: TextStyle(
                      fontSize: 11,
                      color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
              OutlinedButton.icon(
                icon: const Icon(Icons.filter_list, size: 13),
                label: const Text('Filter', style: TextStyle(fontSize: 11)),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                ),
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(height: 12),

          LayoutBuilder(
            builder: (context, constraints) {
              final tableWidth = math.max(constraints.maxWidth, 860.0);
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: tableWidth,
                  child: Table(
                    columnWidths: const {
                      0: FlexColumnWidth(2.2),
                      1: FlexColumnWidth(1.2),
                      2: FlexColumnWidth(1.2),
                      3: FlexColumnWidth(1.6),
                      4: FlexColumnWidth(1.4),
                      5: FlexColumnWidth(1.2),
                      6: FlexColumnWidth(1.2),
                      7: FlexColumnWidth(1.0),
                    },
                    children: [
                      TableRow(
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        children: const [
                          _Th('Sales Closer'),
                          _Th('Active Leads'),
                          _Th('Deals Won'),
                          _Th('Closed Revenue'),
                          _Th('Quota %'),
                          _Th('Avg Cycle'),
                          _Th('Incentive'),
                          _Th('Details'),
                        ],
                      ),
                      ..._agents.asMap().entries.map((entry) {
                        final i = entry.key;
                        final a = entry.value;
                        final double quotaPercent = ((a['closedRev'] as num) / (a['target'] as num)) * 100;
                        return TableRow(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: isDark ? AppColors.darkBorder : AppColors.lightSurfaceSubtle,
                              ),
                            ),
                          ),
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 11,
                                    backgroundColor: i == 0
                                        ? const Color(0xFFF59E0B)
                                        : i == 1
                                            ? const Color(0xFF94A3B8)
                                            : const Color(0xFF3B82F6),
                                    child: Text(
                                      '#${i + 1}',
                                      style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: Colors.white),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        a['name'] as String,
                                        style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700),
                                      ),
                                      Text(
                                        a['role'] as String,
                                        style: TextStyle(
                                          fontSize: 9.5,
                                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            _Td('${a['leads']} Leads'),
                            _Td('${a['closedDeals']} Won'),
                            _Td('₹${((a['closedRev'] as num) / 100000).toStringAsFixed(2)} L', isBold: true, color: const Color(0xFF10B981)),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('${quotaPercent.toStringAsFixed(1)}%', style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700)),
                                  const SizedBox(height: 2),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(2),
                                    child: LinearProgressIndicator(
                                      value: quotaPercent / 100,
                                      minHeight: 3.5,
                                      backgroundColor: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        quotaPercent >= 90 ? const Color(0xFF10B981) : const Color(0xFF3B82F6),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            _Td('${a['cycle']} days'),
                            _Td('₹${(((a['closedRev'] as num) * (a['commRate'] as double)) / 1000).toStringAsFixed(1)}k', color: const Color(0xFF2563EB)),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                              child: IconButton(
                                icon: const Icon(Icons.arrow_forward, size: 14),
                                onPressed: () {
                                  setState(() => _selectedAgentId = a['id'] as String);
                                },
                              ),
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
        ],
      ),
    );
  }

  Widget _buildChannelTelemetryCard(BuildContext context, bool isDark) {
    final channels = [
      {'channel': 'Meta & Instagram Ads', 'leads': 142, 'spend': '₹85,000', 'cpl': '₹598', 'won': 12, 'revenue': '₹78.5 L', 'roas': '9.2x'},
      {'channel': 'Google Search (High Intent)', 'leads': 94, 'spend': '₹72,000', 'cpl': '₹765', 'won': 9, 'revenue': '₹62.0 L', 'roas': '8.6x'},
      {'channel': 'WhatsApp Cloud API Drips', 'leads': 68, 'spend': '₹8,400', 'cpl': '₹123', 'won': 5, 'revenue': '₹31.4 L', 'roas': '37.3x'},
      {'channel': 'Referrals & Word of Mouth', 'leads': 24, 'spend': '₹0', 'cpl': '₹0', 'won': 2, 'revenue': '₹12.3 L', 'roas': 'N/A'},
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
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
                    'Lead Acquisition Channel Telemetry & Marketing ROI',
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    'Cost Per Lead vs Win Rate across channels',
                    style: TextStyle(
                      fontSize: 11,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'Blended CPL: ₹512',
                  style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: Color(0xFF059669)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          LayoutBuilder(
            builder: (context, constraints) {
              final tableWidth = math.max(constraints.maxWidth, 780.0);
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: tableWidth,
                  child: Table(
                    columnWidths: const {
                      0: FlexColumnWidth(2.5),
                      1: FlexColumnWidth(1.2),
                      2: FlexColumnWidth(1.2),
                      3: FlexColumnWidth(1.2),
                      4: FlexColumnWidth(1.0),
                      5: FlexColumnWidth(1.5),
                      6: FlexColumnWidth(1.0),
                    },
                    children: [
                      TableRow(
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        children: const [
                          _Th('Lead Source Channel'),
                          _Th('Total Leads'),
                          _Th('Ad Spend'),
                          _Th('CPL'),
                          _Th('Won Deals'),
                          _Th('Closed Revenue'),
                          _Th('ROAS'),
                        ],
                      ),
                      ...channels.map((ch) {
                        return TableRow(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: isDark ? AppColors.darkBorder : AppColors.lightSurfaceSubtle,
                              ),
                            ),
                          ),
                          children: [
                            _Td(ch['channel'] as String, isBold: true),
                            _Td('${ch['leads']}'),
                            _Td(ch['spend'] as String),
                            _Td(ch['cpl'] as String),
                            _Td('${ch['won']}'),
                            _Td(ch['revenue'] as String, color: const Color(0xFF10B981), isBold: true),
                            _Td(ch['roas'] as String, color: const Color(0xFF2563EB), isBold: true),
                          ],
                        );
                      }),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showQuotaModal(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    InputDecoration modalInputDeco(String label) {
      return InputDecoration(
        labelText: label,
        labelStyle: TextStyle(fontSize: 11.5, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
        isDense: true,
        filled: true,
        fillColor: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorderStrong, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorderStrong, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: Color(0xFF2563EB), width: 1.4),
        ),
      );
    }

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
        title: const Text('Adjust Team Quotas & Target Tiers', style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w700)),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                initialValue: '25000000',
                style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                decoration: modalInputDeco('Monthly Revenue Quota (₹)'),
              ),
              const SizedBox(height: 10),
              TextFormField(
                initialValue: '40',
                style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                decoration: modalInputDeco('Target Closed Deals'),
              ),
              const SizedBox(height: 10),
              TextFormField(
                initialValue: '0.025',
                style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                decoration: modalInputDeco('Baseline Commission % (2.5% = 0.025)'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(fontSize: 11.5)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2563EB),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Target quota updated.')));
            },
            child: const Text('Save Targets', style: TextStyle(fontSize: 11.5)),
          ),
        ],
      ),
    );
  }
}

class _Th extends StatelessWidget {
  final String text;
  const _Th(this.text);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10.5,
          fontWeight: FontWeight.w700,
          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
        ),
      ),
    );
  }
}

class _Td extends StatelessWidget {
  final String text;
  final bool isBold;
  final Color? color;
  const _Td(this.text, {this.isBold = false, this.color});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 6),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
          color: color ?? (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
        ),
      ),
    );
  }
}
