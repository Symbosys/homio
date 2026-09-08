import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../app/router/route_names.dart';

class ShoppingHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final String activeTab;
  final Widget? trailing;

  const ShoppingHeader({
    super.key,
    required this.title,
    required this.subtitle,
    required this.activeTab,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = AppColors.getSurface(context);
    final borderColor = AppColors.getBorder(context);
    final textPrimaryColor = AppColors.getTextPrimary(context);
    final textSecondaryColor = AppColors.getTextSecondary(context);

    final tabs = [
      {'label': 'Digital Guides Store', 'route': RouteNames.shopDigitalStorePath, 'icon': Icons.menu_book_rounded},
      {'label': 'Home Decor & Materials', 'route': RouteNames.shopDecorAffiliatesPath, 'icon': Icons.chair_rounded},
      {'label': 'Rental & Real Estate (₹500 Paywall)', 'route': RouteNames.shopPropertiesPath, 'icon': Icons.apartment_rounded},
      {'label': 'Wholesale Materials & Live Index', 'route': RouteNames.shopMaterialsPath, 'icon': Icons.inventory_2_rounded},
    ];

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
      decoration: BoxDecoration(
        color: surfaceColor,
        border: Border(bottom: BorderSide(color: borderColor)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row: Breadcrumbs & Trailing
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.storefront_rounded, size: 14, color: AppColors.primary),
                        const SizedBox(width: 4),
                        Text(
                          'COMMERCE & MARKETPLACE',
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.8,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(Icons.chevron_right, size: 14, color: textSecondaryColor),
                  const SizedBox(width: 8),
                  Text(
                    activeTab,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: textSecondaryColor,
                    ),
                  ),
                ],
              ),
              ?trailing,
            ],
          ),

          const SizedBox(height: 12),

          // Title & Subtitle
          Text(
            title,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
              color: textPrimaryColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 13,
              color: textSecondaryColor,
            ),
          ),

          const SizedBox(height: 16),

          // Sub-Module Navigation Tabs
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: tabs.map((tab) {
                final isActive = activeTab.contains(tab['label'] as String) ||
                    (tab['label'] as String).contains(activeTab);
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: InkWell(
                    onTap: () {
                      if (!isActive) {
                        context.go(tab['route'] as String);
                      }
                    },
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: isActive ? AppColors.primary : Colors.transparent,
                            width: 2.5,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            tab['icon'] as IconData,
                            size: 16,
                            color: isActive
                                ? AppColors.primary
                                : textSecondaryColor,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            tab['label'] as String,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                              color: isActive
                                  ? (isDark ? Colors.white : AppColors.primary)
                                  : textSecondaryColor,
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
}
