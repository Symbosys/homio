import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../app/router/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import 'models.dart';

/// Universal top navigation bar for all Client Marketplace & Services screens.
class ClientMarketplaceNavBar extends StatelessWidget {
  final String activeRoutePath;

  const ClientMarketplaceNavBar({
    super.key,
    required this.activeRoutePath,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isMobile = MediaQuery.of(context).size.width < 768;

    final tabs = [
      (
        label: 'Marketplace Hub',
        icon: Icons.storefront_rounded,
        routePath: RouteNames.clientMarketplacePath,
        routeName: RouteNames.clientMarketplace,
      ),
      (
        label: 'Digital Guides',
        icon: Icons.menu_book_rounded,
        routePath: RouteNames.clientDigitalStorePath,
        routeName: RouteNames.clientDigitalStore,
      ),
      (
        label: 'Decor & Materials',
        icon: Icons.shopping_bag_rounded,
        routePath: RouteNames.clientDecorStorePath,
        routeName: RouteNames.clientDecorStore,
      ),
      (
        label: 'Rental & Properties',
        icon: Icons.holiday_village_rounded,
        routePath: RouteNames.clientPropertiesPath,
        routeName: RouteNames.clientProperties,
      ),
      (
        label: 'Hire On-Demand Labour',
        icon: Icons.engineering_rounded,
        routePath: RouteNames.clientHireLabourPath,
        routeName: RouteNames.clientHireLabour,
      ),
    ];

    // Compute active items count
    final purchasedGuidesCount = globalMarketplaceState.digitalGuides.where((g) => g.isPurchased).length;
    final sampleCartCount = globalMarketplaceState.decorProducts.where((p) => p.inSampleCart).length;
    final unlockedPropsCount = globalMarketplaceState.propertyListings.where((p) => p.isUnlocked).length;

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 12 : 16,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: AppRadius.lg,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Top Row: Marketplace Branding + Quick Status Pills
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF10B981), Color(0xFF059669)],
                  ),
                  borderRadius: AppRadius.md,
                ),
                child: const Icon(
                  Icons.storefront_rounded,
                  color: Colors.white,
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Homio Marketplace & Services',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: isMobile ? 13 : 15,
                        fontWeight: FontWeight.w800,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                    Text(
                      'Direct Trade Pricing • Vetted Craftsmen • Zero Brokerage',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: isMobile ? 10 : 11,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF10B981),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),

              // Activity Status Pill
              InkWell(
                key: const Key('navbar_marketplace_cart_pill'),
                onTap: () => _showMyActivityDialog(context, isDark),
                borderRadius: AppRadius.full,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981).withValues(alpha: 0.12),
                    borderRadius: AppRadius.full,
                    border: Border.all(
                      color: const Color(0xFF10B981).withValues(alpha: 0.35),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.inventory_2_outlined,
                        color: Color(0xFF059669),
                        size: 15,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        '${purchasedGuidesCount + sampleCartCount + unlockedPropsCount} Active',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF059669),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 10),

          // Bottom Row: Navigation Tabs
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: tabs.map((tab) {
                final isActive = activeRoutePath == tab.routePath;
                return Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: InkWell(
                    onTap: () {
                      if (!isActive) {
                        context.goNamed(tab.routeName);
                      }
                    },
                    borderRadius: AppRadius.md,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: isActive
                            ? const Color(0xFF10B981)
                            : (isDark
                                ? const Color(0xFF1E293B)
                                : const Color(0xFFF1F5F9)),
                        borderRadius: AppRadius.md,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            tab.icon,
                            size: 14,
                            color: isActive
                                ? Colors.white
                                : (isDark
                                    ? AppColors.darkTextSecondary
                                    : AppColors.lightTextSecondary),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            tab.label,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11.5,
                              fontWeight:
                                  isActive ? FontWeight.w700 : FontWeight.w600,
                              color: isActive
                                  ? Colors.white
                                  : (isDark
                                      ? AppColors.darkTextPrimary
                                      : const Color(0xFF334155)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  void _showMyActivityDialog(BuildContext context, bool isDark) {
    final purchasedGuides = globalMarketplaceState.digitalGuides.where((g) => g.isPurchased).toList();
    final sampleItems = globalMarketplaceState.decorProducts.where((p) => p.inSampleCart).toList();
    final unlockedProps = globalMarketplaceState.propertyListings.where((p) => p.isUnlocked).toList();

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: AppRadius.lg),
          title: Row(
            children: [
              const Icon(Icons.inventory_2_rounded, color: Color(0xFF10B981), size: 22),
              const SizedBox(width: 10),
              Text(
                'My Marketplace Activity',
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
            ],
          ),
          content: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480, maxHeight: 440),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'PURCHASED BLUEPRINTS (${purchasedGuides.length})',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF10B981),
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  if (purchasedGuides.isEmpty)
                    Text(
                      'No digital handbooks purchased yet.',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                      ),
                    )
                  else
                    ...purchasedGuides.map((g) => Container(
                          margin: const EdgeInsets.only(bottom: 6),
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
                            borderRadius: AppRadius.sm,
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.picture_as_pdf_rounded, color: Color(0xFFEF4444), size: 16),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  g.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w700,
                                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              const Icon(Icons.download_done_rounded, color: Color(0xFF10B981), size: 16),
                            ],
                          ),
                        )),
                  const SizedBox(height: 14),
                  const Divider(height: 1),
                  const SizedBox(height: 14),
                  Text(
                    'SAMPLE REQUESTS TO SITE (${sampleItems.length})',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF0284C7),
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  if (sampleItems.isEmpty)
                    Text(
                      'No material samples requested for Villa 402.',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                      ),
                    )
                  else
                    ...sampleItems.map((p) => Container(
                          margin: const EdgeInsets.only(bottom: 6),
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
                            borderRadius: AppRadius.sm,
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.inventory_2_rounded, color: Color(0xFF0284C7), size: 16),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  '${p.title} (${p.brand})',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w700,
                                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )),
                  const SizedBox(height: 14),
                  const Divider(height: 1),
                  const SizedBox(height: 14),
                  Text(
                    'UNLOCKED PROPERTIES (${unlockedProps.length})',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF8B5CF6),
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  if (unlockedProps.isEmpty)
                    Text(
                      'No direct owner contacts unlocked yet.',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                      ),
                    )
                  else
                    ...unlockedProps.map((prop) => Container(
                          margin: const EdgeInsets.only(bottom: 6),
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
                            borderRadius: AppRadius.sm,
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.verified_user_rounded, color: Color(0xFF8B5CF6), size: 16),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  '${prop.title} • Owner: ${prop.ownerName}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w700,
                                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text(
                'Close',
                style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        );
      },
    );
  }
}
