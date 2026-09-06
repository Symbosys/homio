import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/responsive/adaptive_container.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/theme_controller.dart';

/// Deep Capabilities section with a balanced 3 / 3 grid (6 foundational pillars),
/// spacious professional typography, and fully responsive layout for all screen sizes.
class CapabilitiesGrid extends StatelessWidget {
  const CapabilitiesGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeController.instance.isDarkMode(context);
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isMobile = screenWidth < 768;

    return Container(
      padding: EdgeInsets.symmetric(vertical: isMobile ? 48 : 80),
      child: AdaptiveContainer(
        maxWidth: 1280,
        child: Column(
          children: [
            // Top Badge: ❖ BUILT FOR EXCELLENCE
            _buildTopBadge(isDark),

            const SizedBox(height: 20),

            // Headline: Engineered for Precision at Scale
            _buildHeadline(isDark, isMobile),

            const SizedBox(height: 16),

            // Subtitle Description
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 700),
              child: Text(
                'Explore the 6 foundational pillars powering high-performing\nproject, sales, and operations teams.',
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: isMobile ? 14.0 : 16.0,
                  height: 1.65,
                  color: isDark ? AppColors.darkTextSecondary : const Color(0xFF64748B),
                ),
              ),
            ),

            const SizedBox(height: 48),

            // 6 Capabilities Cards (Balanced 3 / 3 Grid)
            _buildCapabilitiesLayout(context, isDark),
          ],
        ),
      ),
    );
  }

  /// Top pill badge with 4-dot diamond mosaic icon
  Widget _buildTopBadge(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1B4B).withValues(alpha: 0.5) : Colors.white,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: isDark ? const Color(0xFF3730A3) : const Color(0xFFE0E7FF),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4F46E5).withValues(alpha: isDark ? 0.2 : 0.06),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.auto_awesome_mosaic_rounded,
            size: 15,
            color: Color(0xFF818CF8),
          ),
          const SizedBox(width: 8),
          Text(
            'BUILT FOR EXCELLENCE',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.1,
              color: isDark ? const Color(0xFF818CF8) : const Color(0xFF4F46E5),
            ),
          ),
        ],
      ),
    );
  }

  /// Two-tone headline
  Widget _buildHeadline(bool isDark, bool isMobile) {
    return Text.rich(
      TextSpan(
        style: GoogleFonts.plusJakartaSans(
          fontSize: isMobile ? 28 : 42,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.8,
        ),
        children: [
          TextSpan(
            text: 'Engineered for ',
            style: TextStyle(
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
          ),
          TextSpan(
            text: 'Precision',
            style: TextStyle(
              color: isDark ? const Color(0xFF818CF8) : const Color(0xFF4F46E5),
            ),
          ),
          TextSpan(
            text: ' at Scale',
            style: TextStyle(
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }

  /// Dataset for the 6 Pillars (3 Top + 3 Bottom)
  List<_CapabilityData> _getCapabilities() {
    return [
      // Top Row (3 cards)
      _CapabilityData(
        category: 'CRM & SALES',
        title: 'Lead Funnels & Conversions',
        description: 'Capture leads from Meta & Google Ads, qualify with custom scoring, assign to teams automatically, and more.',
        icon: Icons.trending_up_rounded,
        color: const Color(0xFF818CF8),
        features: const [
          'Lead qualification & stage funnels',
          'Automatic salesperson assignment',
        ],
      ),
      _CapabilityData(
        category: 'PROJECT MANAGEMENT',
        badge: 'Live Tracking',
        title: 'Site Milestones & Execution',
        description: 'Deliver projects on time with interactive Gantt schedules, milestone checklist sign-offs, site photos, and updates.',
        icon: Icons.assignment_outlined,
        color: const Color(0xFF34D399),
        features: const [
          'Gantt & interactive timeline views',
          'Live site progress photo logs',
        ],
      ),
      _CapabilityData(
        category: 'OMNICHANNEL & COMMS',
        badge: '10x Engagement',
        title: 'WhatsApp & Drip Automation',
        description: 'Engage prospects directly on WhatsApp. Run automated onboarding drip, broadcast promotions, and more.',
        icon: Icons.chat_bubble_outline_rounded,
        color: const Color(0xFF2DD4BF),
        features: const [
          'Official WhatsApp Business integration',
          'Trigger-based automated drip messaging',
        ],
      ),

      // Bottom Row (3 cards)
      _CapabilityData(
        category: 'TEAM & HR',
        badge: 'Governance',
        title: 'Hierarchy, Roles & Attendance',
        description: 'Structure your company into departments with granular role permissions. Track daily attendance, leaves & approvals.',
        icon: Icons.groups_outlined,
        color: const Color(0xFF818CF8),
        features: const [
          'Multi-tier roles & permissions',
          'Geo-tagged attendance & leave approvals',
        ],
      ),
      _CapabilityData(
        category: 'FINANCE & BILLING',
        badge: 'Cashflow',
        title: 'Quotations & Vendor Ledgers',
        description: 'Build dynamic quotations with customized margins. Track vendor ledgers, customer payments, milestones, and invoices.',
        icon: Icons.receipt_long_outlined,
        color: const Color(0xFFFBBF24),
        features: const [
          'Dynamic quotation builder',
          'Milestone billing & receipt generation',
        ],
      ),
      _CapabilityData(
        category: 'AI & INTELLIGENCE',
        badge: 'Next-Gen AI',
        title: 'Generative Design & Advisory',
        description: 'Supercharge your workflow with specialized AI assistants, interior design concepts, AI Vastu & layout guidance.',
        icon: Icons.auto_awesome_rounded,
        color: const Color(0xFFF43F5E),
        features: const [
          'AI concept design generator',
          'AI Vastu layout consultant',
        ],
      ),
    ];
  }

  /// Responsive Layout: Balanced 3 / 3 on Desktop, 2-col on Tablet, 1-col on Mobile
  Widget _buildCapabilitiesLayout(BuildContext context, bool isDark) {
    final items = _getCapabilities();

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final isDesktop = width >= 1050;
        final isTablet = width >= 650 && !isDesktop;

        if (isDesktop) {
          // Top Row: 3 cards
          final topRowItems = items.take(3).toList();
          // Bottom Row: 3 cards
          final bottomRowItems = items.skip(3).take(3).toList();

          return Column(
            children: [
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (int i = 0; i < topRowItems.length; i++) ...[
                      Expanded(
                        child: _buildCapabilityCard(topRowItems[i], isDark),
                      ),
                      if (i < topRowItems.length - 1)
                        const SizedBox(width: 20),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 20),
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (int i = 0; i < bottomRowItems.length; i++) ...[
                      Expanded(
                        child: _buildCapabilityCard(bottomRowItems[i], isDark),
                      ),
                      if (i < bottomRowItems.length - 1)
                        const SizedBox(width: 20),
                    ],
                  ],
                ),
              ),
            ],
          );
        }

        if (isTablet) {
          // 2 columns on tablet (3 rows of 2 cards)
          return Wrap(
            spacing: 18,
            runSpacing: 18,
            children: items.map((item) {
              final cardWidth = (width - 18) / 2;
              return SizedBox(
                width: cardWidth,
                child: _buildCapabilityCard(item, isDark),
              );
            }).toList(),
          );
        }

        // Mobile Single Column
        return Column(
          children: items.map((item) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _buildCapabilityCard(item, isDark),
            );
          }).toList(),
        );
      },
    );
  }

  /// Individual Capability Card
  Widget _buildCapabilityCard(_CapabilityData data, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F1420) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? const Color(0xFF1E2638) : const Color(0xFFE2E8F0),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.03),
            blurRadius: 18,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Upper Content: Header + Description
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCardHeader(data, isDark),
              const SizedBox(height: 16),
              Text(
                data.description,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13.0,
                  height: 1.55,
                  fontWeight: FontWeight.w400,
                  color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                ),
              ),
            ],
          ),

          const SizedBox(height: 22),

          // Lower Content: 2 Bullet Checkmarks (No overflow, wraps cleanly)
          Column(
            children: data.features.map((feature) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Icon(
                        Icons.check_circle_rounded,
                        size: 14,
                        color: data.color,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        feature,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12.2,
                          height: 1.4,
                          fontWeight: FontWeight.w500,
                          color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  /// Card Header: Icon squircle + Category & Badge + Title
  Widget _buildCardHeader(_CapabilityData data, bool isDark) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Icon squircle
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: data.color.withValues(alpha: isDark ? 0.16 : 0.10),
            borderRadius: BorderRadius.circular(13),
          ),
          child: Center(
            child: Icon(
              data.icon,
              size: 24,
              color: data.color,
            ),
          ),
        ),
        const SizedBox(width: 14),

        // Category, Badge & Title
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 4,
                crossAxisAlignment: WrapCrossAlignment.center,
                alignment: WrapAlignment.spaceBetween,
                children: [
                  Text(
                    data.category,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                      color: data.color,
                    ),
                  ),
                  if (data.badge != null)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                      decoration: BoxDecoration(
                        color: data.color.withValues(alpha: isDark ? 0.15 : 0.08),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: data.color.withValues(alpha: 0.35),
                          width: 0.8,
                        ),
                      ),
                      child: Text(
                        data.badge!,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 9.5,
                          fontWeight: FontWeight.w700,
                          color: data.color,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 5),

              // Title
              Text(
                data.title,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16.5,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.3,
                  height: 1.25,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Helper model for a single Capability
class _CapabilityData {
  _CapabilityData({
    required this.category,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.features,
    this.badge,
  });

  final String category;
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final List<String> features;
  final String? badge;
}
