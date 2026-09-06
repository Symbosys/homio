import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/responsive/adaptive_container.dart';
import '../../../../core/responsive/responsive_builder.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/theme_controller.dart';
import '../../../../core/widgets/app_badge.dart';

/// The Operating System Concept: "What is the Homio Platform?"
/// Interactive full-height module showcase with rich live cockpit preview,
/// key metrics, pipeline visuals, and seamless bi-directional integration details.
class EcosystemSection extends StatefulWidget {
  const EcosystemSection({super.key});

  @override
  State<EcosystemSection> createState() => _EcosystemSectionState();
}

class _EcosystemSectionState extends State<EcosystemSection> {
  int _activeModuleIndex = 0;

  final List<_EcosystemModule> _modules = [
    _EcosystemModule(
      title: 'CRM & Sales Funnels',
      icon: Icons.filter_alt_rounded,
      color: const Color(0xFF6366F1),
      stat: 'Lead-to-Project Conversion Engine',
      badge: '⚡ LIVE ENGINE',
      desc:
          'Capture leads seamlessly from Meta Ads, Google Ads, website webhooks, and direct WhatsApp. Automatically qualify leads with custom scoring algorithms and distribute them to available sales reps in under 15 seconds.',
      metrics: [
        _MetricItem(label: 'Avg Response Time', value: '< 30 sec', color: Color(0xFF10B981)),
        _MetricItem(label: 'Pipeline Velocity', value: '+42%', color: Color(0xFF6366F1)),
        _MetricItem(label: 'Active Pipeline', value: '₹1.8 Cr', color: Color(0xFFF59E0B)),
      ],
      previewHeadline: 'Live Omnichannel Pipeline Stream',
      previewDetails: [
        _StagePill(title: 'Captured', count: '142', color: Color(0xFF6366F1)),
        _StagePill(title: 'Qualified', count: '84', color: Color(0xFF0D9488)),
        _StagePill(title: 'Site Visit', count: '36', color: Color(0xFFF59E0B)),
        _StagePill(title: 'Won / Booked', count: '21', color: Color(0xFF10B981)),
      ],
      statusNote: '14 new leads ingested today • 100% assigned automatically',
      integrations: ['Meta Ads', 'Google Ads', 'WhatsApp Cloud', 'Webhooks API'],
    ),
    _EcosystemModule(
      title: 'Site & Project Execution',
      icon: Icons.business_center_rounded,
      color: const Color(0xFF0D9488),
      stat: '100% On-Time Milestone Delivery',
      badge: '🏗 SITE OS',
      desc:
          'Empower field project managers and contractors with mobile-first Gantt schedules, daily geo-tagged photo logs, client sign-off approvals, and real-time vendor material delivery tracking.',
      metrics: [
        _MetricItem(label: 'On-Time Milestones', value: '99.4%', color: Color(0xFF0D9488)),
        _MetricItem(label: 'Active Sites', value: '38 Active', color: Color(0xFF6366F1)),
        _MetricItem(label: 'Daily Photo Logs', value: '240+ Today', color: Color(0xFF10B981)),
      ],
      previewHeadline: 'Live Milestone Execution Stepper',
      previewDetails: [
        _StagePill(title: 'Civil & Masonry', count: '100%', color: Color(0xFF10B981)),
        _StagePill(title: 'Electrical & Plumbing', count: '85%', color: Color(0xFF0D9488)),
        _StagePill(title: 'Carpentry & Modular', count: '40%', color: Color(0xFFF59E0B)),
        _StagePill(title: 'Handover & Audit', count: 'Pending', color: Color(0xFF64748B)),
      ],
      statusNote: '8 active milestones updated today • 0 client escalation tickets',
      integrations: ['Mobile Geo-GPS', 'Google Maps API', 'Cloud Storage', 'Client App'],
    ),
    _EcosystemModule(
      title: 'WhatsApp Cloud Automation',
      icon: Icons.chat_rounded,
      color: const Color(0xFF10B981),
      stat: 'Zero Missed Follow-ups & 10x Engagement',
      badge: '💬 CLOUD API',
      desc:
          'Direct official Meta WhatsApp Cloud API integration. Trigger automated onboarding drips, instant quotation PDFs, payment reminder alerts, and 24/7 AI-powered inquiry resolution.',
      metrics: [
        _MetricItem(label: 'Open Rate', value: '98.6%', color: Color(0xFF10B981)),
        _MetricItem(label: 'Auto Drips Sent', value: '3,800/mo', color: Color(0xFF6366F1)),
        _MetricItem(label: 'AI Resolution', value: '86%', color: Color(0xFF0D9488)),
      ],
      previewHeadline: 'Automated WhatsApp AI Stream',
      previewDetails: [
        _StagePill(title: 'Lead Inbound', count: 'Instant', color: Color(0xFF10B981)),
        _StagePill(title: 'AI Nurture Bot', count: 'Active', color: Color(0xFF0D9488)),
        _StagePill(title: 'Estimate PDF Sent', count: 'Auto', color: Color(0xFF6366F1)),
        _StagePill(title: 'Call Scheduled', count: '4:00 PM', color: Color(0xFFF59E0B)),
      ],
      statusNote: 'Official Meta Cloud API connected • Verified Green Tick Support',
      integrations: ['Meta Cloud API', 'OpenAI GPT-4o', 'Payment Links', 'Webhooks'],
    ),
    _EcosystemModule(
      title: 'Team Hierarchy & Attendance',
      icon: Icons.groups_rounded,
      color: const Color(0xFF7C3AED),
      stat: 'Granular Multi-Tier Role Governance',
      badge: '👥 GOVERNANCE',
      desc:
          'Structure your entire organization into branches, departments, and roles. Track field sales and site supervisor attendance with GPS geo-fencing, facial check-in, and automated performance commissions.',
      metrics: [
        _MetricItem(label: 'Geo-Verification', value: '100% GPS', color: Color(0xFF10B981)),
        _MetricItem(label: 'Field Velocity', value: '96.2%', color: Color(0xFF7C3AED)),
        _MetricItem(label: 'Active Staff', value: '148 Members', color: Color(0xFF6366F1)),
      ],
      previewHeadline: 'Organizational Tree & Field Attendance',
      previewDetails: [
        _StagePill(title: 'HQ Leadership', count: '6 Admins', color: Color(0xFF7C3AED)),
        _StagePill(title: 'Project Heads', count: '8 Leads', color: Color(0xFF6366F1)),
        _StagePill(title: 'Site Engineers', count: '34 Staff', color: Color(0xFF0D9488)),
        _StagePill(title: 'Contractors', count: '62 Vendors', color: Color(0xFFF59E0B)),
      ],
      statusNote: '142 of 148 staff checked in with verified geo-location coordinates',
      integrations: ['Geo-Fencing SDK', 'Biometric Clocks', 'Google Workspace', 'Slack'],
    ),
    _EcosystemModule(
      title: 'Finance & Dynamic Quotations',
      icon: Icons.account_balance_wallet_rounded,
      color: const Color(0xFFF59E0B),
      stat: 'Real-Time Margins & Bulletproof Billing',
      badge: '💰 CASHFLOW OS',
      desc:
          'Generate 100-item customized quotations with automatic margin protection. Link client milestones directly to payment gateway links, track contractor ledgers, and automate GST invoices.',
      metrics: [
        _MetricItem(label: 'Margin Protection', value: 'Locked >25%', color: Color(0xFF10B981)),
        _MetricItem(label: 'Ledger Health', value: '100% ACID', color: Color(0xFFF59E0B)),
        _MetricItem(label: 'Invoiced Today', value: '₹24.8 Lakh', color: Color(0xFF6366F1)),
      ],
      previewHeadline: 'Dynamic Margin Calculator & Ledger',
      previewDetails: [
        _StagePill(title: 'Materials (BOQ)', count: '₹14.2L', color: Color(0xFF64748B)),
        _StagePill(title: 'Contractor Labour', count: '₹4.8L', color: Color(0xFF0D9488)),
        _StagePill(title: 'Net Margin', count: '26.5% (₹6.8L)', color: Color(0xFF10B981)),
        _StagePill(title: 'Client Billing', count: 'Auto-GST', color: Color(0xFFF59E0B)),
      ],
      statusNote: 'Razorpay & Stripe Gateway synced • Auto TDS & GST reconciliation',
      integrations: ['Razorpay', 'Stripe', 'Tally Prime API', 'Zoho Books'],
    ),
    _EcosystemModule(
      title: 'AI Intelligence & Advisory',
      icon: Icons.auto_awesome_rounded,
      color: const Color(0xFFEC4899),
      stat: 'Autonomous Generative Copilot',
      badge: '✨ NEXT-GEN AI',
      desc:
          'Transform sketches and floor plans into hyper-realistic 3D interior design renders in seconds. Run AI Vastu compliance audits, predict material price fluctuations, and let AI draft sales pitches.',
      metrics: [
        _MetricItem(label: 'Concept Render', value: '4.2 sec', color: Color(0xFFEC4899)),
        _MetricItem(label: 'Vastu Score', value: '94 / 100', color: Color(0xFF10B981)),
        _MetricItem(label: 'Hours Saved', value: '65+ hrs/mo', color: Color(0xFF6366F1)),
      ],
      previewHeadline: 'AI Spatial & Design Advisory Engine',
      previewDetails: [
        _StagePill(title: 'Floorplan Ingestion', count: 'Parsed', color: Color(0xFFEC4899)),
        _StagePill(title: 'Vastu Audit', count: '94/100', color: Color(0xFF10B981)),
        _StagePill(title: '3D AI Renders', count: '3 Created', color: Color(0xFF6366F1)),
        _StagePill(title: 'Auto BOQ Export', count: 'Ready', color: Color(0xFF0D9488)),
      ],
      statusNote: 'Homio AI Engine active • Continuous real-time operational learning',
      integrations: ['OpenAI GPT-4o', 'Stable Diffusion XL', 'Vector Embeddings', 'CAD Tools'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeController.instance.isDarkMode(context);
    final isCompact = context.isCompact;
    final isDesktop = context.isDesktop;

    final activeModule = _modules[_activeModuleIndex];

    return Container(
      padding: EdgeInsets.symmetric(vertical: isCompact ? 48 : 80),
      child: AdaptiveContainer(
        maxWidth: 1280,
        child: Column(
          children: [
            // Section Header
            AppBadge(
              label: 'THE OPERATING SYSTEM CONCEPT',
              icon: Icons.hub_rounded,
              color: AppColors.primary,
            ),
            const SizedBox(height: 16),
            Text(
              'What is the Homio Platform?',
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: isCompact ? 26 : 38,
                fontWeight: FontWeight.w800,
                letterSpacing: -1.0,
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
              ),
            ),
            const SizedBox(height: 14),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: Text(
                'High-growth companies waste up to 40% of their bandwidth stitching together spreadsheets, chat groups, accounting software, and point solutions. Homio brings every operational domain into one unified engine.',
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: isCompact ? 14.5 : 16.5,
                  height: 1.6,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                ),
              ),
            ),
            const SizedBox(height: 48),

            // Split Composition: Full-Height Matching Canvas
            if (isDesktop)
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Left List of Modules (Flex 5)
                    Expanded(
                      flex: 5,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(_modules.length, (index) {
                          final mod = _modules[index];
                          final isSelected = index == _activeModuleIndex;

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(16),
                              onTap: () => setState(() => _activeModuleIndex = index),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 180),
                                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? (isDark ? const Color(0xFF131A2E) : Colors.white)
                                      : (isDark ? const Color(0xFF0C101D).withValues(alpha: 0.6) : Colors.white.withValues(alpha: 0.6)),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: isSelected
                                        ? mod.color
                                        : (isDark ? const Color(0xFF1E2844) : const Color(0xFFE2E8F0)),
                                    width: isSelected ? 1.8 : 1.0,
                                  ),
                                  boxShadow: isSelected
                                      ? [
                                          BoxShadow(
                                            color: mod.color.withValues(alpha: isDark ? 0.25 : 0.12),
                                            blurRadius: 18,
                                            offset: const Offset(0, 4),
                                          ),
                                        ]
                                      : null,
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: mod.color.withValues(alpha: isDark ? 0.18 : 0.10),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Icon(mod.icon, size: 21, color: mod.color),
                                    ),
                                    const SizedBox(width: 14),
                                    Expanded(
                                      child: Text(
                                        mod.title,
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 15,
                                          fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                                          color: isSelected
                                              ? (isDark ? Colors.white : const Color(0xFF0F172A))
                                              : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                                        ),
                                      ),
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      size: 13,
                                      color: isSelected
                                          ? mod.color
                                          : (isDark ? const Color(0xFF475569) : const Color(0xFFCBD5E1)),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                    const SizedBox(width: 24),

                    // Right Focus Canvas Preview: Full-Height Cockpit (Flex 7)
                    Expanded(
                      flex: 7,
                      child: _buildRichFocusCanvas(activeModule, isDark),
                    ),
                  ],
                ),
              )
            else
              // Mobile / Tablet stacked presentation
              Column(
                children: _modules.map((mod) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _buildRichFocusCanvas(mod, isDark),
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }

  /// Right side Full-Height Rich Cockpit Canvas
  Widget _buildRichFocusCanvas(_EcosystemModule module, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0D1222) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? const Color(0xFF1E2844) : const Color(0xFFE2E8F0),
          width: 1.3,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.04),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 1. Header: Icon + Title + Live Status Badge
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: module.color.withValues(alpha: isDark ? 0.20 : 0.12),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: module.color.withValues(alpha: 0.35),
                        width: 1.2,
                      ),
                    ),
                    child: Icon(module.icon, size: 26, color: module.color),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              module.title,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.4,
                                color: isDark ? Colors.white : const Color(0xFF0F172A),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: module.color.withValues(alpha: isDark ? 0.16 : 0.10),
                                borderRadius: BorderRadius.circular(999),
                                border: Border.all(
                                  color: module.color.withValues(alpha: 0.4),
                                  width: 1.0,
                                ),
                              ),
                              child: Text(
                                module.badge,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.8,
                                  color: module.color,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          module.stat,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: module.color,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // Description
              Text(
                module.desc,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14.5,
                  height: 1.6,
                  fontWeight: FontWeight.w400,
                  color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                ),
              ),
            ],
          ),

          const SizedBox(height: 22),

          // 2. Metric Strip: 3 Frosted Insight Cards
          Row(
            children: module.metrics.map((m) {
              return Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF131A2E).withValues(alpha: 0.8)
                        : const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isDark ? const Color(0xFF243050) : const Color(0xFFE2E8F0),
                      width: 1.0,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        m.label,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        m.value,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: m.color,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 22),

          // 3. Live Pipeline / Stepper Visual Box
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF080C18) : const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark ? const Color(0xFF1E2844) : const Color(0xFFE2E8F0),
                width: 1.0,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      module.previewHeadline,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.4,
                        color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155),
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          width: 7,
                          height: 7,
                          decoration: const BoxDecoration(
                            color: Color(0xFF10B981),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          'Live Synced',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF10B981),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // 4 Interactive Stage Pills
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: module.previewDetails.map((stage) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF131A2E) : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: stage.color.withValues(alpha: 0.35),
                          width: 1.0,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: stage.color,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            stage.title,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w600,
                              color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            stage.count,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w800,
                              color: stage.color,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 10),

                // Live status note
                Text(
                  '● ${module.statusNote}',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w500,
                    color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 22),

          // 4. Footer: Connected Integrations & Zero-Latency Sync
          Column(
            children: [
              Row(
                children: [
                  const Icon(Icons.bolt_rounded, size: 16, color: Color(0xFF10B981)),
                  const SizedBox(width: 6),
                  Text(
                    'Native Connectors: ',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155),
                    ),
                  ),
                  Expanded(
                    child: Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: module.integrations.map((tool) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF1A2238) : const Color(0xFFE2E8F0),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            tool,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w600,
                              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: (isDark ? const Color(0xFF10B981) : const Color(0xFF059669)).withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFF10B981).withValues(alpha: 0.25),
                    width: 1.0,
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle_rounded, size: 16, color: Color(0xFF10B981)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Deep bi-directional sync across all other modules • < 15ms latency',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: isDark ? const Color(0xFF34D399) : const Color(0xFF047857),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Helper model for an Ecosystem Module
class _EcosystemModule {
  _EcosystemModule({
    required this.title,
    required this.icon,
    required this.color,
    required this.stat,
    required this.badge,
    required this.desc,
    required this.metrics,
    required this.previewHeadline,
    required this.previewDetails,
    required this.statusNote,
    required this.integrations,
  });

  final String title;
  final IconData icon;
  final Color color;
  final String stat;
  final String badge;
  final String desc;
  final List<_MetricItem> metrics;
  final String previewHeadline;
  final List<_StagePill> previewDetails;
  final String statusNote;
  final List<String> integrations;
}

class _MetricItem {
  _MetricItem({required this.label, required this.value, required this.color});
  final String label;
  final String value;
  final Color color;
}

class _StagePill {
  _StagePill({required this.title, required this.count, required this.color});
  final String title;
  final String count;
  final Color color;
}
