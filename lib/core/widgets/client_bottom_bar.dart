import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../app/router/route_names.dart';
import '../navigation/client_sidebar_controller.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';

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
/// Displays the 5 highest priority client workflows: Overview, Live Site, Approvals, Chat, and Billing.
class ClientBottomBar extends StatefulWidget {
  const ClientBottomBar({super.key});

  /// The 5 core high-priority client tabs
  static const List<ClientBottomTabItem> tabs = [
    ClientBottomTabItem(
      id: 'client_overview',
      title: 'Overview',
      icon: Icons.grid_view_outlined,
      activeIcon: Icons.grid_view_rounded,
      routeName: RouteNames.clientOverview,
      routePath: RouteNames.clientOverviewPath,
    ),
    ClientBottomTabItem(
      id: 'client_site_progress',
      title: 'Live Site',
      icon: Icons.videocam_outlined,
      activeIcon: Icons.videocam_rounded,
      routeName: RouteNames.clientSiteProgress,
      routePath: RouteNames.clientSiteProgressPath,
    ),
    ClientBottomTabItem(
      id: 'client_approvals',
      title: 'Approvals',
      icon: Icons.fact_check_outlined,
      activeIcon: Icons.fact_check_rounded,
      routeName: RouteNames.clientApprovals,
      routePath: RouteNames.clientApprovalsPath,
      badgeCount: 2,
      badgeColor: Color(0xFFEF4444),
    ),
    ClientBottomTabItem(
      id: 'client_chat',
      title: 'Chat',
      icon: Icons.forum_outlined,
      activeIcon: Icons.forum_rounded,
      routeName: RouteNames.clientChat,
      routePath: RouteNames.clientChatPath,
      badgeCount: 3,
      badgeColor: Color(0xFF10B981),
    ),
    ClientBottomTabItem(
      id: 'client_payments',
      title: 'Billing',
      icon: Icons.account_balance_wallet_outlined,
      activeIcon: Icons.account_balance_wallet_rounded,
      routeName: RouteNames.clientPayments,
      routePath: RouteNames.clientPaymentsPath,
      badgeCount: 1,
      badgeColor: Color(0xFFF59E0B),
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
    final currentRoute = _controller.activeRoute;
    if (currentRoute == tab.routePath) return true;
    if (tab.routePath != RouteNames.clientOverviewPath &&
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
