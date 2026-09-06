import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../app/router/route_names.dart';
import '../navigation/sidebar_controller.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';

/// Data model representing a high-priority bottom navigation tab item for the Owner / CRM panel.
class OwnerBottomTabItem {
  final String id;
  final String title;
  final IconData icon;
  final IconData activeIcon;
  final String routeName;
  final String routePath;
  final int badgeCount;
  final Color badgeColor;

  const OwnerBottomTabItem({
    required this.id,
    required this.title,
    required this.icon,
    required this.activeIcon,
    required this.routeName,
    required this.routePath,
    this.badgeCount = 0,
    this.badgeColor = const Color(0xFF6366F1),
  });
}

/// Responsive 5-tab bottom navigation bar for the Homio Owner / CRM Panel on mobile/small-medium devices.
/// Displays the 5 highest priority operational workflows: Dashboard, Sales CRM, Projects, Finance, and Comms.
class AppBottomBar extends StatefulWidget {
  const AppBottomBar({super.key});

  /// The 5 core high-priority owner tabs
  static const List<OwnerBottomTabItem> tabs = [
    OwnerBottomTabItem(
      id: 'dashboard',
      title: 'Dashboard',
      icon: Icons.dashboard_outlined,
      activeIcon: Icons.dashboard_rounded,
      routeName: RouteNames.dashboardOverview,
      routePath: RouteNames.dashboardOverviewPath,
    ),
    OwnerBottomTabItem(
      id: 'sales_crm',
      title: 'Sales CRM',
      icon: Icons.trending_up_rounded,
      activeIcon: Icons.trending_up_rounded,
      routeName: RouteNames.salesOverview,
      routePath: RouteNames.salesOverviewPath,
      badgeCount: 5,
      badgeColor: Color(0xFF6366F1),
    ),
    OwnerBottomTabItem(
      id: 'project_mgmt',
      title: 'Projects',
      icon: Icons.construction_outlined,
      activeIcon: Icons.construction_rounded,
      routeName: RouteNames.execProjects,
      routePath: RouteNames.execProjectsPath,
      badgeCount: 2,
      badgeColor: Color(0xFFF59E0B),
    ),
    OwnerBottomTabItem(
      id: 'finance',
      title: 'Finance',
      icon: Icons.account_balance_wallet_outlined,
      activeIcon: Icons.account_balance_wallet_rounded,
      routeName: RouteNames.accCustomerSummary,
      routePath: RouteNames.accCustomerSummaryPath,
    ),
    OwnerBottomTabItem(
      id: 'communication',
      title: 'Comms',
      icon: Icons.forum_outlined,
      activeIcon: Icons.forum_rounded,
      routeName: RouteNames.commChats,
      routePath: RouteNames.commChatsPath,
      badgeCount: 3,
      badgeColor: Color(0xFF10B981),
    ),
  ];

  @override
  State<AppBottomBar> createState() => _AppBottomBarState();
}

class _AppBottomBarState extends State<AppBottomBar> {
  final SidebarController _controller = SidebarController.instance;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onControllerChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerChanged);
    super.dispose();
  }

  void _onControllerChanged() {
    if (mounted) setState(() {});
  }

  bool _isTabActive(OwnerBottomTabItem tab) {
    final currentRoute = _controller.activeRoute;
    if (currentRoute == tab.routePath) return true;

    // Route prefix match for subpages of the module
    if (tab.routePath == RouteNames.dashboardOverviewPath) {
      return currentRoute.startsWith('/dashboard');
    } else if (tab.routePath == RouteNames.salesOverviewPath) {
      return currentRoute.startsWith('/sales');
    } else if (tab.routePath == RouteNames.execProjectsPath) {
      return currentRoute.startsWith('/execution');
    } else if (tab.routePath == RouteNames.accCustomerSummaryPath) {
      return currentRoute.startsWith('/accounting');
    } else if (tab.routePath == RouteNames.commChatsPath) {
      return currentRoute.startsWith('/communication');
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.45)
                : const Color(0xFF0F172A).withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Container(
          height: 62,
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: AppBottomBar.tabs.map((tab) {
              final isActive = _isTabActive(tab);
              return Expanded(
                child: _buildTabItem(tab, isActive, isDark),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildTabItem(OwnerBottomTabItem tab, bool isActive, bool isDark) {
    final activeColor = isDark ? const Color(0xFF818CF8) : const Color(0xFF4F46E5);
    final inactiveColor = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          _controller.setActiveRoute(tab.routePath);
          context.goNamed(tab.routeName);
        },
        borderRadius: AppRadius.md,
        splashColor: const Color(0xFF6366F1).withValues(alpha: 0.12),
        highlightColor: const Color(0xFF6366F1).withValues(alpha: 0.06),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon with Active Indicator Pill & Notification Badge
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 3.5),
              decoration: BoxDecoration(
                color: isActive
                    ? (isDark
                        ? const Color(0xFF312E81).withValues(alpha: 0.45)
                        : const Color(0xFFEEF2FF))
                    : Colors.transparent,
                borderRadius: AppRadius.full,
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Icon(
                    isActive ? tab.activeIcon : tab.icon,
                    size: 21,
                    color: isActive ? activeColor : inactiveColor,
                  ),
                  if (tab.badgeCount > 0)
                    Positioned(
                      top: -3,
                      right: -7,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                        constraints: const BoxConstraints(minWidth: 14, minHeight: 14),
                        decoration: BoxDecoration(
                          color: tab.badgeColor,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isDark ? const Color(0xFF0F172A) : Colors.white,
                            width: 1.5,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            '${tab.badgeCount}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 8.5,
                              fontWeight: FontWeight.w800,
                              height: 1.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 2),

            // Tab Label
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: GoogleFonts.plusJakartaSans(
                fontSize: 10.5,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                color: isActive ? activeColor : inactiveColor,
                letterSpacing: 0.1,
              ),
              child: Text(
                tab.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
