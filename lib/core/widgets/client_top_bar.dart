import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../app/router/route_names.dart';
import '../navigation/client_navigation_registry.dart';
import '../navigation/client_sidebar_controller.dart';
import '../responsive/breakpoints.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';

/// Top App Bar tailored for the Homio Client/Customer Portal.
/// On desktop or primary bottom-tab screens, shows the project selector and notifications.
/// On compact secondary screens (not in bottom tabs), shows a Back button, drawer access, and the active screen title.
class ClientTopBar extends StatelessWidget implements PreferredSizeWidget {
  const ClientTopBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final isCompact = screenWidth < Breakpoints.medium;
    final controller = ClientSidebarController.instance;
    final activeRoute = controller.activeRoute;
    final isBottomTab = controller.isCurrentRouteInBottomTabs;
    final pageInfo = ClientNavigationRegistry.findInfoByPath(activeRoute);

    return Container(
      height: 64,
      padding: EdgeInsets.symmetric(horizontal: isCompact ? 8.0 : AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
        border: Border(
          bottom: BorderSide(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // 1. COMPACT SECONDARY SCREEN: Drawer Menu & Current Screen Title
          if (isCompact && !isBottomTab) ...[
            IconButton(
              iconSize: 22,
              splashRadius: 20,
              tooltip: 'Open Menu',
              icon: const Icon(Icons.menu_rounded),
              onPressed: () => controller.openMobileDrawer(),
            ),
            const SizedBox(width: 4),

            // Current Page Title & Icon
            Expanded(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Icon(
                      pageInfo.icon,
                      size: 14,
                      color: const Color(0xFF10B981),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      pageInfo.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : const Color(0xFF1E293B),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          // 2. PRIMARY BOTTOM TAB OR DESKTOP: Drawer Button & Active Project Selector
          if (!isCompact || isBottomTab) ...[
            if (isCompact)
              IconButton(
                iconSize: 22,
                splashRadius: 20,
                tooltip: 'Open Menu',
                icon: const Icon(Icons.menu_rounded),
                onPressed: () => controller.openMobileDrawer(),
              ),

            // Active Project Selector Breadcrumb
            Flexible(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E1B4B).withValues(alpha: 0.3) : const Color(0xFFF1F5F9),
                  borderRadius: AppRadius.md,
                  border: Border.all(
                    color: isDark ? const Color(0xFF312E81) : const Color(0xFFE2E8F0),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.apartment_rounded,
                      size: 15,
                      color: Color(0xFF6366F1),
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        isCompact ? 'Villa 402' : 'Project: Villa 402 - 3BHK Turnkey Interior',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white : const Color(0xFF1E293B),
                        ),
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
                        '72%',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF10B981),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],

          const Spacer(),

          // Dedicated Support Hotline (On Desktop)
          if (!isCompact)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF10B981).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                children: [
                  const Icon(Icons.support_agent_rounded, color: Color(0xFF10B981), size: 16),
                  const SizedBox(width: 6),
                  Text(
                    'PM: +91 98765 43210',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF10B981),
                    ),
                  ),
                ],
              ),
            ),

          // Notifications Bell (On Desktop or Bottom-Tab screens)
          if (!isCompact || isBottomTab)
            Stack(
              clipBehavior: Clip.none,
              children: [
                IconButton(
                  iconSize: 20,
                  tooltip: '2 Approvals Pending',
                  icon: Icon(
                    Icons.notifications_outlined,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('You have 2 work stage approvals awaiting inspection.'),
                        backgroundColor: Color(0xFF6366F1),
                      ),
                    );
                  },
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Color(0xFFEF4444),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),

          const SizedBox(width: 4),

          // Client Profile & Sign Out
          IconButton(
            tooltip: 'Client Profile (Rohit Sharma)',
            icon: const CircleAvatar(
              radius: 14,
              backgroundColor: Color(0xFF059669),
              child: Text(
                'RS',
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
  }
}
