import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../app/router/route_names.dart';
import '../../data/ai_suite_repository.dart';
import '../../widgets/credit_purchase_modal.dart';
import '../../widgets/ai_commercial_config_dialog.dart';

class AiStudioOverviewPage extends StatelessWidget {
  const AiStudioOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isMobile = MediaQuery.of(context).size.width < 900;
    final repo = AiSuiteRepository.instance;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0B0F19) : const Color(0xFFF8FAFC),
      body: ListenableBuilder(
        listenable: repo,
        builder: (context, _) {
          return SingleChildScrollView(
            padding: EdgeInsets.all(isMobile ? 10 : 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. TOP HEADER
                _buildTopHeader(context, isDark, repo, isMobile),
                const SizedBox(height: 12),

                // 2. HERO AREA
                _buildHeroBanner(context, isDark, isMobile),
                const SizedBox(height: 14),

                // 3. CREDIT BALANCE CARD & OPERATIONAL STATS
                _buildCreditBalanceCard(context, isDark, repo, isMobile),
                const SizedBox(height: 14),

                // 4. THE 5 CORE AI TOOL CARDS
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF7C3AED).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Icon(Icons.auto_awesome_rounded, color: Color(0xFF7C3AED), size: 16),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Core AI Architectural Suite',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                _buildToolCardsGrid(context, isDark, repo, isMobile),
                const SizedBox(height: 16),

                // 5. RECENT ACTIVITY ACROSS ALL TOOLS
                _buildRecentActivitySection(context, isDark, repo, isMobile),
              ],
            ),
          );
        },
      ),
    );
  }

  // ==========================================================================
  // TOP HEADER
  // ==========================================================================
  Widget _buildTopHeader(BuildContext context, bool isDark, AiSuiteRepository repo, bool isMobile) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 12 : 14, vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF111827) : Colors.white,
        borderRadius: AppRadius.md,
        border: Border.all(
          color: isDark ? const Color(0xFF1F2937) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 12,
        runSpacing: 8,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF7C3AED), Color(0xFF4F46E5)],
                  ),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF7C3AED).withValues(alpha: 0.3),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(Icons.psychology_rounded, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 10),
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: isMobile ? 240 : 500),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            'Homio AI Studio',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: isMobile ? 15 : 17,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -0.3,
                              color: isDark ? Colors.white : const Color(0xFF0F172A),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFF10B981).withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.4)),
                          ),
                          child: Text(
                            'ENTERPRISE v3.0',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF10B981),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Intelligent interior visualization, Vastu audit, cost estimation & designer marketplace.',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Right Actions: Live Credit Pill + Buy Credits + Usage + Admin
          Wrap(
            spacing: 8,
            runSpacing: 6,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              // Credit balance pill
              InkWell(
                onTap: () => context.go(RouteNames.aiWallet),
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.4)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.toll_rounded, size: 14, color: Color(0xFF10B981)),
                      const SizedBox(width: 4),
                      Text(
                        '${repo.totalCredits} Credits',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF10B981),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Buy Credits CTA
              ElevatedButton.icon(
                onPressed: () => CreditPurchaseModal.show(context),
                icon: const Icon(Icons.add_shopping_cart_rounded, size: 14),
                label: const Text('Buy Credits'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7C3AED),
                  foregroundColor: Colors.white,
                  visualDensity: VisualDensity.compact,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),

              // AI Usage / Revenue CTA
              OutlinedButton.icon(
                onPressed: () => context.go(RouteNames.aiUsageRevenue),
                icon: const Icon(Icons.analytics_outlined, size: 14),
                label: const Text('Usage & Revenue'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: isDark ? Colors.white : const Color(0xFF334155),
                  side: BorderSide(color: isDark ? const Color(0xFF374151) : const Color(0xFFCBD5E1)),
                  visualDensity: VisualDensity.compact,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),

              // Commercial Rules Config Button
              IconButton(
                onPressed: () => AiCommercialConfigDialog.show(context),
                icon: const Icon(Icons.tune_rounded, size: 16),
                tooltip: 'Commercial Pricing & Split Configuration',
                style: IconButton.styleFrom(
                  backgroundColor: isDark ? const Color(0xFF1F2937) : const Color(0xFFF1F5F9),
                  visualDensity: VisualDensity.compact,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ==========================================================================
  // HERO BANNER & 5 QUICK ACTION BUTTONS
  // ==========================================================================
  Widget _buildHeroBanner(BuildContext context, bool isDark, bool isMobile) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 12 : 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF2E1065), const Color(0xFF1E1B4B), const Color(0xFF0F172A)]
              : [const Color(0xFFFAF5FF), const Color(0xFFF3E8FF), const Color(0xFFEDE9FE)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFF7C3AED).withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: const Color(0xFF7C3AED).withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.stars_rounded, color: Color(0xFF7C3AED), size: 12),
                const SizedBox(width: 4),
                Text(
                  'NEXT-GENERATION INTERIOR AI INFRASTRUCTURE',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.3,
                    color: const Color(0xFF7C3AED),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Design smarter. Estimate faster. Get expert guidance.',
            style: GoogleFonts.plusJakartaSans(
              fontSize: isMobile ? 16 : 20,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.4,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 4),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 750),
            child: Text(
              'Use Homio’s AI-powered tools to visualize spaces, understand Vastu, estimate budgets and connect with professional designers.',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                height: 1.4,
                color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // The 5 Quick Action Buttons
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              _buildHeroActionBtn(
                context: context,
                label: 'Start Room Design',
                icon: Icons.bedroom_parent_outlined,
                route: RouteNames.aiRoomDesigner,
                color: const Color(0xFF7C3AED),
                isPrimary: true,
              ),
              _buildHeroActionBtn(
                context: context,
                label: 'Check Vastu',
                icon: Icons.explore_outlined,
                route: RouteNames.aiVastu,
                color: const Color(0xFF0284C7),
              ),
              _buildHeroActionBtn(
                context: context,
                label: 'Calculate Budget',
                icon: Icons.calculate_outlined,
                route: RouteNames.aiBudget,
                color: const Color(0xFF10B981),
              ),
              _buildHeroActionBtn(
                context: context,
                label: 'Ask AI',
                icon: Icons.psychology_outlined,
                route: RouteNames.aiDoubtSolver,
                color: const Color(0xFFF59E0B),
              ),
              _buildHeroActionBtn(
                context: context,
                label: 'Book Designer',
                icon: Icons.video_camera_front_outlined,
                route: RouteNames.aiDesignerCalls,
                color: const Color(0xFFEC4899),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeroActionBtn({
    required BuildContext context,
    required String label,
    required IconData icon,
    required String route,
    required Color color,
    bool isPrimary = false,
  }) {
    return ElevatedButton.icon(
      onPressed: () => context.go(route),
      icon: Icon(icon, size: 14),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: isPrimary ? color : Colors.white,
        foregroundColor: isPrimary ? Colors.white : const Color(0xFF0F172A),
        elevation: 0,
        visualDensity: VisualDensity.compact,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: isPrimary ? Colors.transparent : const Color(0xFFE2E8F0),
          ),
        ),
      ),
    );
  }

  // ==========================================================================
  // CREDIT BALANCE CARD & EXPIRING BREAKDOWN
  // ==========================================================================
  Widget _buildCreditBalanceCard(BuildContext context, bool isDark, AiSuiteRepository repo, bool isMobile) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 12 : 14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF111827) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? const Color(0xFF1F2937) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Column(
        children: [
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 6,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.account_balance_wallet_rounded, color: Color(0xFF10B981), size: 16),
                  const SizedBox(width: 6),
                  Text(
                    'Prepaid AI Credit Balance',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),
              TextButton.icon(
                onPressed: () => context.go(RouteNames.aiWallet),
                style: TextButton.styleFrom(visualDensity: VisualDensity.compact),
                icon: const Icon(Icons.history_rounded, size: 14),
                label: const Text('View Ledger & History', style: TextStyle(fontSize: 11)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 650;
              return Flex(
                direction: isNarrow ? Axis.vertical : Axis.horizontal,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Available Credits
                  _buildCreditMetric(
                    title: 'AVAILABLE CREDITS',
                    value: '${repo.totalCredits}',
                    subtitle: '≈ ₹${(repo.totalCredits * 5.0).toInt()} rendering value',
                    color: const Color(0xFF10B981),
                  ),
                  if (!isNarrow) Container(width: 1, height: 36, color: isDark ? const Color(0xFF374151) : const Color(0xFFE2E8F0)),
                  // Used this month
                  _buildCreditMetric(
                    title: 'USED THIS MONTH',
                    value: '${repo.creditsConsumed}',
                    subtitle: '${repo.jobs.length} jobs run',
                    color: const Color(0xFF3B82F6),
                  ),
                  if (!isNarrow) Container(width: 1, height: 36, color: isDark ? const Color(0xFF374151) : const Color(0xFFE2E8F0)),
                  // Purchased
                  _buildCreditMetric(
                    title: 'PURCHASED',
                    value: '${repo.creditsSold}',
                    subtitle: 'Lifetime pack purchases',
                    color: const Color(0xFF7C3AED),
                  ),
                  if (!isNarrow) Container(width: 1, height: 36, color: isDark ? const Color(0xFF374151) : const Color(0xFFE2E8F0)),
                  // Expiring
                  _buildCreditMetric(
                    title: 'EXPIRING',
                    value: '0',
                    subtitle: '365-day rollover active',
                    color: const Color(0xFF64748B),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCreditMetric({
    required String title,
    required String value,
    required String subtitle,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 9,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.4,
              color: const Color(0xFF94A3B8),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: color,
            ),
          ),
          Text(
            subtitle,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 10,
              color: const Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================================
  // THE 5 CORE TOOL CARDS
  // ==========================================================================
  Widget _buildToolCardsGrid(BuildContext context, bool isDark, AiSuiteRepository repo, bool isMobile) {
    final tools = [
      {
        'title': 'Room Designer',
        'desc': 'Generate interior concepts from room photos. Customize 14 room types, 7 lighting modes, 12 styles, and obtain preliminary material BOQ specs.',
        'icon': Icons.bedroom_parent_outlined,
        'cost': '${repo.commercialConfig.roomDesignCreditCost} Credits / Render',
        'badge': 'IMAGE-TO-IMAGE AI',
        'color': const Color(0xFF7C3AED),
        'route': RouteNames.aiRoomDesigner,
      },
      {
        'title': 'Vastu Consultant',
        'desc': 'Upload your floor plan and receive an AI-assisted Vastu analysis with North calibration, 16-zone Chakra report, and non-demolition remedies.',
        'icon': Icons.explore_outlined,
        'cost': '${repo.commercialConfig.vastuAnalysisCreditCost} Credits / Audit',
        'badge': '16-ZONE CHAKRA',
        'color': const Color(0xFF0284C7),
        'route': RouteNames.aiVastu,
      },
      {
        'title': 'Budget Calculator',
        'desc': 'Estimate furniture and interior costs using dimensions and materials. Generate itemized BOQs, brand suggestions and quotation requests.',
        'icon': Icons.calculate_outlined,
        'cost': '${repo.commercialConfig.budgetEstimateCreditCost} Credits / Est',
        'badge': 'ACCURATE BOQ',
        'color': const Color(0xFF10B981),
        'route': RouteNames.aiBudget,
      },
      {
        'title': 'Doubt Solver',
        'desc': 'Ask design, engineering and construction questions. Enjoy 3 free queries, backed by BIS standards and material knowledgebases.',
        'icon': Icons.psychology_outlined,
        'cost': '${repo.freeDoubtQueriesRemaining} Free Left • Then ₹${repo.commercialConfig.doubtQueryFee.toInt()}',
        'badge': 'CONSTRUCTION AI',
        'color': const Color(0xFFF59E0B),
        'route': RouteNames.aiDoubtSolver,
      },
      {
        'title': 'Designer Video Calls',
        'desc': 'Book a 1-on-1 consultation with verified interior designers. Real-time screen share, floor plan annotations and 50/50 revenue sharing.',
        'icon': Icons.video_camera_front_outlined,
        'cost': '₹${repo.commercialConfig.consultation30MinFee.toInt()} / 30m',
        'badge': '1-ON-1 EXPERT',
        'color': const Color(0xFFEC4899),
        'route': RouteNames.aiDesignerCalls,
      },
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 1150 ? 3 : (constraints.maxWidth > 700 ? 2 : 1);
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: tools.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            mainAxisExtent: 175,
          ),
          itemBuilder: (context, index) {
            final t = tools[index];
            final color = t['color'] as Color;

            return InkWell(
              onTap: () => context.go(t['route'] as String),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF111827) : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDark ? const Color(0xFF1F2937) : const Color(0xFFE2E8F0),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
                      blurRadius: 6,
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
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(t['icon'] as IconData, color: color, size: 16),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            t['badge'] as String,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 8,
                              fontWeight: FontWeight.w800,
                              color: color,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      t['title'] as String,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Expanded(
                      child: Text(
                        t['desc'] as String,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          height: 1.3,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                    ),
                    const Divider(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          t['cost'] as String,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: color,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              'Launch',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                color: color,
                              ),
                            ),
                            const SizedBox(width: 3),
                            Icon(Icons.arrow_forward_rounded, size: 12, color: color),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // ==========================================================================
  // UNIFIED MULTI-TOOL RECENT ACTIVITY
  // ==========================================================================
  Widget _buildRecentActivitySection(BuildContext context, bool isDark, AiSuiteRepository repo, bool isMobile) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 12 : 14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF111827) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? const Color(0xFF1F2937) : const Color(0xFFE2E8F0),
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
                  const Icon(Icons.history_toggle_off_rounded, color: Color(0xFF7C3AED), size: 16),
                  const SizedBox(width: 6),
                  Text(
                    'Recent AI Activity Timeline',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),
              Text(
                'Live Asynchronous Sync',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF10B981),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: repo.jobs.length,
            separatorBuilder: (_, _) => const Divider(height: 8),
            itemBuilder: (context, i) {
              final job = repo.jobs[i];
              return ListTile(
                contentPadding: EdgeInsets.zero,
                dense: true,
                visualDensity: VisualDensity.compact,
                leading: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: job.status.color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(job.status.icon, color: job.status.color, size: 16),
                ),
                title: Row(
                  children: [
                    Flexible(
                      child: Text(
                        job.title,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                      decoration: BoxDecoration(
                        color: const Color(0xFF7C3AED).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        job.productType,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF7C3AED),
                        ),
                      ),
                    ),
                  ],
                ),
                subtitle: Text(
                  'User: ${job.user} • Prompt: ${job.prompt}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10,
                    color: const Color(0xFF64748B),
                  ),
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: job.status.color.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        job.status.label,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          color: job.status.color,
                        ),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${job.creditsCharged} Credits',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF94A3B8),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
