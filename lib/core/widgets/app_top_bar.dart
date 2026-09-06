import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../app/router/route_names.dart';
import '../navigation/navigation_menu_registry.dart';
import '../navigation/sidebar_controller.dart';
import '../responsive/breakpoints.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

/// Top operational bar for Homio CRM with breadcrumbs, search, alerts, and tenant pill.
/// Adapts responsively:
/// - Desktop / Primary 5 Bottom Tabs: Shows breadcrumb hub, workspace badge, search (desktop), alerts bell, and profile.
/// - Mobile / Tablet Secondary Screens: Shows drawer menu button, current module/page title & category icon, alerts bell, and profile (no back icon).
class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;

  const AppTopBar({
    super.key,
    this.title,
  });

  @override
  Size get preferredSize => const Size.fromHeight(68.0);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final isCompact = screenWidth < Breakpoints.medium;
    final controller = SidebarController.instance;

    final bgColor = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final activeRoute = controller.activeRoute;
        final isBottomTab = controller.isCurrentRouteInBottomTabs;
        final pageInfo = NavigationMenuRegistry.findInfoByPath(activeRoute);
        final displayTitle = title ?? pageInfo.title;

        return Container(
          height: preferredSize.height,
          padding: EdgeInsets.symmetric(horizontal: isCompact ? 8.0 : AppSpacing.md),
          decoration: BoxDecoration(
            color: bgColor,
            border: Border(
              bottom: BorderSide(color: borderColor, width: 1.0),
            ),
          ),
          child: Row(
            children: [
              // 1. COMPACT SECONDARY SCREEN: Drawer Menu & Current Screen Title & Icon
              if (isCompact && !isBottomTab) ...[
                IconButton(
                  iconSize: 22,
                  splashRadius: 20,
                  tooltip: 'Open Navigation Menu',
                  icon: const Icon(Icons.menu_rounded),
                  onPressed: () => controller.openMobileDrawer(),
                ),
                const SizedBox(width: 4),

                // Current Page Icon & Title
                Expanded(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF6366F1).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Icon(
                          pageInfo.icon,
                          size: 15,
                          color: isDark ? const Color(0xFF818CF8) : const Color(0xFF4F46E5),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              displayTitle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                              ),
                            ),
                            Text(
                              pageInfo.clusterTitle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              // 2. PRIMARY BOTTOM TAB OR DESKTOP: Hamburger (if compact) & Breadcrumbs
              if (!isCompact || isBottomTab) ...[
                if (isCompact)
                  Padding(
                    padding: const EdgeInsets.only(right: AppSpacing.xs),
                    child: IconButton(
                      iconSize: 22,
                      splashRadius: 20,
                      tooltip: 'Open Navigation Menu',
                      icon: const Icon(Icons.menu_rounded),
                      onPressed: () => controller.openMobileDrawer(),
                    ),
                  ),

                // Breadcrumbs & Section Title
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Homio Operations',
                            style: AppTypography.bodySmall.copyWith(
                              fontSize: 11,
                              color: isDark
                                  ? AppColors.darkTextMuted
                                  : AppColors.lightTextMuted,
                            ),
                          ),
                          Icon(
                            Icons.chevron_right_rounded,
                            size: 14,
                            color: isDark
                                ? AppColors.darkTextMuted
                                : AppColors.lightTextMuted,
                          ),
                          Flexible(
                            child: Text(
                              displayTitle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTypography.labelMedium.copyWith(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: isDark
                                    ? AppColors.darkTextPrimary
                                    : AppColors.lightTextPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        'Workspace: DLF Phase 5 Hub',
                        style: AppTypography.bodySmall.copyWith(
                          fontSize: 11,
                          color: AppColors.primaryLight,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              // 3. Quick Global Search Shortcut (Desktop only)
              if (!isCompact)
                Container(
                  margin: const EdgeInsets.only(right: AppSpacing.md),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.darkSurfaceSubtle
                        : AppColors.lightSurfaceSubtle,
                    borderRadius: AppRadius.full,
                    border: Border.all(
                      color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                      width: 1.0,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.search_rounded,
                        size: 16,
                        color: isDark
                            ? AppColors.darkTextMuted
                            : AppColors.lightTextMuted,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Quick Search',
                        style: AppTypography.bodySmall.copyWith(
                          fontSize: 12,
                          color: isDark
                              ? AppColors.darkTextMuted
                              : AppColors.lightTextMuted,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 1.5,
                        ),
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.darkSurfaceElevated
                              : AppColors.lightSurface,
                          borderRadius: AppRadius.xs,
                          border: Border.all(
                            color: isDark
                                ? AppColors.darkBorderStrong
                                : AppColors.lightBorderStrong,
                          ),
                        ),
                        child: Text(
                          'Ctrl+K',
                          style: AppTypography.labelSmall.copyWith(
                            fontSize: 9.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              // 4. High-Priority Alert Counter Bell
              Stack(
                children: [
                  IconButton(
                    iconSize: 20,
                    icon: const Icon(Icons.notifications_outlined),
                    tooltip: 'High Priority Alerts (3)',
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('3 High-Priority Operational Alerts: 1 Overdue Site Visit, 1 Expiring Discount, 1 Pending Approval'),
                        ),
                      );
                    },
                  ),
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppColors.error,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(width: AppSpacing.xs),

              // 5. User Profile Icon Action
              IconButton(
                tooltip: 'User Profile & Settings',
                icon: const CircleAvatar(
                  radius: 14,
                  backgroundColor: AppColors.primary,
                  child: Text(
                    'VM',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                onPressed: () => context.goNamed(RouteNames.login),
              ),
            ],
          ),
        );
      },
    );
  }
}
