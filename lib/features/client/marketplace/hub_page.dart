import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../app/router/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import 'models.dart';

/// Executive Hub Page for Homio Client Marketplace & Value-Added Services.
class ClientMarketplaceHubPage extends StatelessWidget {
  const ClientMarketplaceHubPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(isMobile ? 12 : 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Hero Banner
              _buildHeroBanner(context, isDark, isMobile),
              const SizedBox(height: 20),

              // KPI Stats Row
              _buildKpiStats(context, isDark, isMobile),
              const SizedBox(height: 24),

              // Marketplace Specialized Hubs Grid (4 Modules)
              _buildSectionHeader(
                context,
                title: 'MARKETPLACE MODULES & SERVICES',
                subtitle: 'Direct contractor pricing, architectural guides, and on-demand site execution',
                isDark: isDark,
              ),
              const SizedBox(height: 12),
              _buildModulesGrid(context, isDark, isMobile),
              const SizedBox(height: 28),

              // Trending Deals & Spotlights
              _buildSectionHeader(
                context,
                title: 'CURATED SPOTLIGHTS & POPULAR PICKS',
                subtitle: 'Hand-picked recommendations vetted for Palm Heights Villa 402',
                isDark: isDark,
              ),
              const SizedBox(height: 12),
              _buildSpotlightsRow(context, isDark, isMobile),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroBanner(BuildContext context, bool isDark, bool isMobile) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF0F172A), const Color(0xFF1E293B)]
              : [const Color(0xFF0F172A), const Color(0xFF1E293B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: AppRadius.lg,
        border: Border.all(
          color: const Color(0xFF334155),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: 0.2),
                  borderRadius: AppRadius.full,
                  border: Border.all(
                    color: const Color(0xFF10B981).withValues(alpha: 0.5),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.verified_rounded,
                      color: Color(0xFF10B981),
                      size: 13,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      'HOMIO CERTIFIED ECOSYSTEM',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF10B981),
                        letterSpacing: 0.6,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: AppRadius.sm,
                ),
                child: Text(
                  'Active Site: Villa 402',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.white70,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            'Homio Marketplace & Value-Added Services',
            style: GoogleFonts.plusJakartaSans(
              fontSize: isMobile ? 20 : 26,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Access wholesale contractor discounts on premium decor materials, explore vetted architectural blueprints, unlock direct zero-brokerage rental properties, and hire police-verified master craftsmen on-demand.',
            style: GoogleFonts.plusJakartaSans(
              fontSize: isMobile ? 12.5 : 14,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF94A3B8),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 8,
            children: [
              _buildQuickActionChip(
                context,
                icon: Icons.menu_book_rounded,
                label: 'Digital Blueprints',
                onTap: () => context.go(RouteNames.clientDigitalStorePath),
              ),
              _buildQuickActionChip(
                context,
                icon: Icons.shopping_bag_rounded,
                label: 'Wholesale Materials',
                onTap: () => context.go(RouteNames.clientDecorStorePath),
              ),
              _buildQuickActionChip(
                context,
                icon: Icons.holiday_village_rounded,
                label: 'Rental Network',
                onTap: () => context.go(RouteNames.clientPropertiesPath),
              ),
              _buildQuickActionChip(
                context,
                icon: Icons.engineering_rounded,
                label: 'Hire Labour',
                onTap: () => context.go(RouteNames.clientHireLabourPath),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionChip(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.md,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.08),
          borderRadius: AppRadius.md,
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.15),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: const Color(0xFF38BDF8), size: 14),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKpiStats(BuildContext context, bool isDark, bool isMobile) {
    final kpis = [
      (
        title: 'DIGITAL VAULT',
        value: '4 Guides Available',
        subtitle: '1 Blueprint Unlocked & Downloadable',
        icon: Icons.menu_book_rounded,
        color: const Color(0xFF10B981),
      ),
      (
        title: 'TRADE DISCOUNTS',
        value: '15% – 32% Off',
        subtitle: 'Direct Builder Pricing on 50+ Brands',
        icon: Icons.percent_rounded,
        color: const Color(0xFF0284C7),
      ),
      (
        title: 'VERIFIED RENTALS',
        value: '3 Luxury Properties',
        subtitle: 'Zero Brokerage • Direct Owner Connect',
        icon: Icons.holiday_village_rounded,
        color: const Color(0xFF8B5CF6),
      ),
      (
        title: 'ON-DEMAND TRADES',
        value: '5 Certified Trades',
        subtitle: '100% Police Verified & Daily Rate Card',
        icon: Icons.engineering_rounded,
        color: const Color(0xFFF59E0B),
      ),
    ];

    if (isMobile) {
      return Column(
        children: kpis
            .map((k) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _buildKpiCard(k.title, k.value, k.subtitle, k.icon, k.color, isDark),
                ))
            .toList(),
      );
    }

    return Row(
      children: kpis.map((k) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: _buildKpiCard(k.title, k.value, k.subtitle, k.icon, k.color, isDark),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildKpiCard(
    String title,
    String value,
    String subtitle,
    IconData icon,
    Color color,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: AppRadius.md,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: AppRadius.sm,
                ),
                child: Icon(icon, color: color, size: 16),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: color,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 3),
          Text(
            subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 10.5,
              fontWeight: FontWeight.w500,
              color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context, {
    required String title,
    required String subtitle,
    required bool isDark,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF10B981),
            letterSpacing: 0.6,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          subtitle,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
          ),
        ),
      ],
    );
  }

  Widget _buildModulesGrid(BuildContext context, bool isDark, bool isMobile) {
    final modules = [
      (
        title: 'Architectural & Interior Guides',
        badge: 'DIGITAL STORE',
        desc: 'Vastu Shastra blueprints, MEP technical schematics, and site material checklists with instant PDF downloads.',
        icon: Icons.menu_book_rounded,
        accent: const Color(0xFF10B981),
        route: RouteNames.clientDigitalStorePath,
        actionLabel: 'Browse Blueprints',
        stat: '4 Guides Available',
      ),
      (
        title: 'Trade Pricing Decor & Materials',
        badge: 'MATERIALS CATALOG',
        desc: 'Contractor discounts on Italian marble, charcoal fluted panels, and Hansgrohe fixtures with sample ordering.',
        icon: Icons.shopping_bag_rounded,
        accent: const Color(0xFF0284C7),
        route: RouteNames.clientDecorStorePath,
        actionLabel: 'Explore Catalog',
        stat: 'Up to 32% Discount',
      ),
      (
        title: 'Verified Rental & Properties Network',
        badge: 'PROPERTIES',
        desc: 'Curated luxury villas and penthouses with 100% Homio physical inspection and direct owner contact unlock.',
        icon: Icons.holiday_village_rounded,
        accent: const Color(0xFF8B5CF6),
        route: RouteNames.clientPropertiesPath,
        actionLabel: 'View Properties',
        stat: 'Zero Brokerage',
      ),
      (
        title: 'Hire On-Demand Labour & Craftsmen',
        badge: 'SERVICE BOOKING',
        desc: 'Police-verified master carpenters, electricians, plumbers, and PU spray polishers with standard transparent day rates.',
        icon: Icons.engineering_rounded,
        accent: const Color(0xFFF59E0B),
        route: RouteNames.clientHireLabourPath,
        actionLabel: 'Book Craftsman',
        stat: '1 Active On Site',
      ),
    ];

    if (isMobile) {
      return Column(
        children: modules
            .map((m) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _buildModuleItem(context, m, isDark),
                ))
            .toList(),
      );
    }

    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildModuleItem(context, modules[0], isDark)),
            const SizedBox(width: 14),
            Expanded(child: _buildModuleItem(context, modules[1], isDark)),
          ],
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(child: _buildModuleItem(context, modules[2], isDark)),
            const SizedBox(width: 14),
            Expanded(child: _buildModuleItem(context, modules[3], isDark)),
          ],
        ),
      ],
    );
  }

  Widget _buildModuleItem(
    BuildContext context,
    ({
      Color accent,
      String actionLabel,
      String badge,
      String desc,
      IconData icon,
      String route,
      String stat,
      String title,
    }) m,
    bool isDark,
  ) {
    return InkWell(
      onTap: () => context.go(m.route),
      borderRadius: AppRadius.lg,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : Colors.white,
          borderRadius: AppRadius.lg,
          border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: m.accent.withValues(alpha: 0.12),
                    borderRadius: AppRadius.md,
                  ),
                  child: Icon(m.icon, color: m.accent, size: 20),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 6,
                    runSpacing: 4,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: m.accent.withValues(alpha: 0.08),
                          borderRadius: AppRadius.full,
                        ),
                        child: Text(
                          m.badge,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: m.accent,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      Text(
                        m.stat,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: m.accent,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              m.title,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              m.desc,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Text(
                  m.actionLabel,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: m.accent,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(Icons.arrow_forward_rounded, color: m.accent, size: 14),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpotlightsRow(BuildContext context, bool isDark, bool isMobile) {
    final guide = globalMarketplaceState.digitalGuides.first;
    final decor = globalMarketplaceState.decorProducts.first;
    final prop = globalMarketplaceState.propertyListings.first;

    final items = [
      (
        category: 'FEATURED BLUEPRINT',
        title: guide.title,
        detail: 'PDF Blueprint • ${guide.pageCount} Pages • Rating ${guide.rating}',
        icon: Icons.menu_book_rounded,
        color: const Color(0xFF10B981),
        route: RouteNames.clientDigitalStorePath,
      ),
      (
        category: 'WHOLESALE MATERIAL',
        title: '${decor.title} (${decor.brand})',
        detail: '₹${decor.tradePrice.toInt()}/sq.ft (Save ${decor.discountPercent}%)',
        icon: Icons.layers_rounded,
        color: const Color(0xFF0284C7),
        route: RouteNames.clientDecorStorePath,
      ),
      (
        category: 'HOT RENTAL LISTING',
        title: '${prop.title} (${prop.bhk} BHK)',
        detail: '₹${(prop.monthlyRent / 1000).toStringAsFixed(0)}K/mo • Zero Brokerage',
        icon: Icons.apartment_rounded,
        color: const Color(0xFF8B5CF6),
        route: RouteNames.clientPropertiesPath,
      ),
    ];

    if (isMobile) {
      return Column(
        children: items
            .map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _buildSpotlightCard(context, item, isDark),
                ))
            .toList(),
      );
    }

    return Row(
      children: items.map((item) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: _buildSpotlightCard(context, item, isDark),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSpotlightCard(
    BuildContext context,
    ({
      String category,
      Color color,
      String detail,
      IconData icon,
      String route,
      String title,
    }) item,
    bool isDark,
  ) {
    return InkWell(
      onTap: () => context.go(item.route),
      borderRadius: AppRadius.md,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : Colors.white,
          borderRadius: AppRadius.md,
          border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(item.icon, color: item.color, size: 16),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    item.category,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: item.color,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              item.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 3),
            Text(
              item.detail,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
