import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../models/marketplace_enums.dart';
import '../services/cart_service.dart';
import 'cart_sheet.dart';

/// Top-level shell scaffold for all Marketplace pages
class MarketplaceScaffold extends StatelessWidget {
  final Widget body;
  final MarketplaceCategory? activeCategory;
  final String title;
  final String? subtitle;
  final Widget? floatingActionButton;
  final List<Widget>? actions;

  const MarketplaceScaffold({
    super.key,
    required this.body,
    this.activeCategory,
    required this.title,
    this.subtitle,
    this.floatingActionButton,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkBackground : AppColors.lightBackground;
    final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;

    return Scaffold(
      backgroundColor: bg,
      floatingActionButton: floatingActionButton,
      body: SafeArea(
        child: Column(
          children: [
            // Top Navigation Bar
            Container(
              decoration: BoxDecoration(
                color: surface,
                border: Border(bottom: BorderSide(color: border)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: Row(
                children: [
                  // Logo/Icon and Title
                  InkWell(
                    onTap: () => context.go('/client/marketplace'),
                    borderRadius: BorderRadius.circular(10),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF10B981).withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.storefront_rounded,
                            color: Color(0xFF10B981),
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'HOMIO',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 1.5,
                                    color: const Color(0xFF10B981),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF10B981).withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    'MARKETPLACE',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF10B981),
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              title,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  ...?actions,

                  // Live Cart Button
                  ListenableBuilder(
                    listenable: CartService(),
                    builder: (context, _) {
                      final count = CartService().itemCount;
                      return Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: OutlinedButton.icon(
                          onPressed: () => CartSheet.show(context),
                          style: OutlinedButton.styleFrom(
                            backgroundColor:
                                count > 0 ? const Color(0xFF10B981).withValues(alpha: 0.1) : Colors.transparent,
                            side: BorderSide(
                              color: count > 0 ? const Color(0xFF10B981) : border,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          ),
                          icon: Badge(
                            isLabelVisible: count > 0,
                            label: Text(
                              count.toString(),
                              style: GoogleFonts.plusJakartaSans(fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                            backgroundColor: const Color(0xFF10B981),
                            child: Icon(
                              Icons.shopping_bag_outlined,
                              size: 18,
                              color: count > 0 ? const Color(0xFF10B981) : textPrimary,
                            ),
                          ),
                          label: Text(
                            count > 0 ? 'Cart (${CartService().formattedGrandTotal})' : 'Cart',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: count > 0 ? const Color(0xFF10B981) : textPrimary,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            // Sub-Module Pills Quick Nav Bar
            Container(
              height: 48,
              decoration: BoxDecoration(
                color: surface,
                border: Border(bottom: BorderSide(color: border)),
              ),
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                children: [
                  _buildNavPill(
                    context: context,
                    label: 'Overview',
                    icon: Icons.dashboard_outlined,
                    path: '/client/marketplace',
                    isSelected: activeCategory == null,
                    isDark: isDark,
                  ),
                  for (final cat in MarketplaceCategory.values)
                    _buildNavPill(
                      context: context,
                      label: cat.label,
                      icon: cat.icon,
                      path: cat.routePath,
                      isSelected: activeCategory == cat,
                      isDark: isDark,
                    ),
                ],
              ),
            ),

            // Main Body Content
            Expanded(child: body),
          ],
        ),
      ),
    );
  }

  Widget _buildNavPill({
    required BuildContext context,
    required String label,
    required IconData icon,
    required String path,
    required bool isSelected,
    required bool isDark,
  }) {
    final activeColor = const Color(0xFF10B981);
    final textMuted = isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: InkWell(
        onTap: () {
          if (!isSelected) {
            context.go(path);
          }
        },
        borderRadius: BorderRadius.circular(8),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: isSelected ? activeColor.withValues(alpha: 0.15) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? activeColor : Colors.transparent,
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 15,
                color: isSelected ? activeColor : textMuted,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected ? activeColor : textMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
