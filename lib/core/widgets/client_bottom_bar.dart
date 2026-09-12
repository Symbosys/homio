import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../app/router/route_names.dart';
import '../navigation/client_sidebar_controller.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';

import '../../features/client/shared/customer_shared_widgets.dart';

/// Data model representing a high-priority bottom navigation tab item for mobile & small/medium screens.
class ClientBottomTabItem {
  final String id;
  final String title;
  final IconData icon;
  final IconData activeIcon;
  final String routeName;
  final String routePath;
  final int badgeCount;
  final Color badgeColor;

  const ClientBottomTabItem({
    required this.id,
    required this.title,
    required this.icon,
    required this.activeIcon,
    required this.routeName,
    required this.routePath,
    this.badgeCount = 0,
    this.badgeColor = const Color(0xFF10B981),
  });
}

/// Premium, responsive 5-tab bottom navigation bar for the Homio Client Portal on mobile/small-medium devices.
/// Displays the 5 customer workflows: Home, Projects, Enquiries, Quotations, and More.
class ClientBottomBar extends StatefulWidget {
  const ClientBottomBar({super.key});

  /// The 5 core high-priority client tabs
  static const List<ClientBottomTabItem> tabs = [
    ClientBottomTabItem(
      id: 'client_overview',
      title: 'Home',
      icon: Icons.dashboard_outlined,
      activeIcon: Icons.dashboard_rounded,
      routeName: RouteNames.clientOverview,
      routePath: RouteNames.clientOverviewPath,
    ),
    ClientBottomTabItem(
      id: 'client_projects',
      title: 'Projects',
      icon: Icons.home_work_outlined,
      activeIcon: Icons.home_work_rounded,
      routeName: RouteNames.clientProjects,
      routePath: RouteNames.clientProjectsPath,
    ),
    ClientBottomTabItem(
      id: 'client_enquiries',
      title: 'Enquiries',
      icon: Icons.assignment_outlined,
      activeIcon: Icons.assignment_rounded,
      routeName: RouteNames.clientEnquiries,
      routePath: RouteNames.clientEnquiriesPath,
      badgeCount: 1,
      badgeColor: Color(0xFF3B82F6),
    ),
    ClientBottomTabItem(
      id: 'client_quotations',
      title: 'Quotations',
      icon: Icons.receipt_long_outlined,
      activeIcon: Icons.receipt_long_rounded,
      routeName: RouteNames.clientQuotations,
      routePath: RouteNames.clientQuotationsPath,
      badgeCount: 1,
      badgeColor: Color(0xFFF59E0B),
    ),
    ClientBottomTabItem(
      id: 'client_more',
      title: 'More',
      icon: Icons.grid_view_outlined,
      activeIcon: Icons.grid_view_rounded,
      routeName: '',
      routePath: '',
    ),
  ];

  @override
  State<ClientBottomBar> createState() => _ClientBottomBarState();
}

class _ClientBottomBarState extends State<ClientBottomBar> {
  final ClientSidebarController _controller = ClientSidebarController.instance;

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

  bool _isTabActive(ClientBottomTabItem tab) {
    if (tab.id == 'client_more') return false;
    final currentRoute = _controller.activeRoute;
    if (currentRoute == tab.routePath) return true;
    if (tab.routePath.isNotEmpty &&
        tab.routePath != RouteNames.clientOverviewPath &&
        currentRoute.startsWith(tab.routePath)) {
      return true;
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
            children: ClientBottomBar.tabs.map((tab) {
              final isActive = _isTabActive(tab);
              return Expanded(child: _buildTabItem(tab, isActive, isDark));
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildTabItem(ClientBottomTabItem tab, bool isActive, bool isDark) {
    final activeColor = isDark
        ? const Color(0xFF34D399)
        : const Color(0xFF059669);
    final inactiveColor = isDark
        ? const Color(0xFF94A3B8)
        : const Color(0xFF64748B);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          if (tab.id == 'client_more') {
            CustomerMoreBottomSheet.show(context);
            return;
          }
          _controller.setActiveRoute(tab.routePath);
          context.goNamed(tab.routeName);
        },
        borderRadius: AppRadius.md,
        splashColor: const Color(0xFF10B981).withValues(alpha: 0.12),
        highlightColor: const Color(0xFF10B981).withValues(alpha: 0.06),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon with Active Indicator & Notification Badge
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 3.5,
              ),
              decoration: BoxDecoration(
                color: isActive
                    ? (isDark
                          ? const Color(0xFF064E3B).withValues(alpha: 0.45)
                          : const Color(0xFFECFDF5))
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
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 1,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 14,
                          minHeight: 14,
                        ),
                        decoration: BoxDecoration(
                          color: tab.badgeColor,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isDark
                                ? const Color(0xFF0F172A)
                                : Colors.white,
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
