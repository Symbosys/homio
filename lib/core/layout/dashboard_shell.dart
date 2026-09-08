import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../navigation/sidebar_controller.dart';
import '../responsive/breakpoints.dart';
import '../theme/app_colors.dart';
import '../widgets/app_bottom_bar.dart';
import '../widgets/app_sidebar.dart';
import '../widgets/app_top_bar.dart';

/// Root shell layout for all authenticated Homio CRM panel routes.
/// Provides a persistent, responsive collapsible sidebar on desktop, and a drawer + 5-tab bottom navigation bar on mobile/tablet.
class DashboardShell extends StatefulWidget {
  final Widget child;

  const DashboardShell({
    super.key,
    required this.child,
  });

  @override
  State<DashboardShell> createState() => _DashboardShellState();
}

class _DashboardShellState extends State<DashboardShell> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final SidebarController _sidebarController = SidebarController.instance;

  @override
  void initState() {
    super.initState();
    _sidebarController.addListener(_onSidebarChanged);
  }

  @override
  void dispose() {
    _sidebarController.removeListener(_onSidebarChanged);
    super.dispose();
  }

  void _onSidebarChanged() {
    if (!mounted) return;
    setState(() {});
    final isCompact = MediaQuery.of(context).size.width < Breakpoints.medium;
    if (isCompact) {
      if (_sidebarController.isMobileOpen) {
        _scaffoldKey.currentState?.openDrawer();
      } else {
        if (_scaffoldKey.currentState?.isDrawerOpen ?? false) {
          Navigator.of(context).pop();
        }
      }
    }
  }

  void _onNavigate(String route) {
    _sidebarController.setActiveRoute(route);
    context.go(route);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isCompact = screenWidth < Breakpoints.medium;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isBottomTabScreen = _sidebarController.isCurrentRouteInBottomTabs;
    final currentRoute = GoRouterState.of(context).uri.path;

    final bgColor = isDark ? AppColors.darkBackground : AppColors.lightBackground;

    if (isCompact) {
      // Mobile & Tablet Drawer Layout: Show 5-tab bottom bar only when active screen is in bottom tabs
      return Scaffold(
        key: _scaffoldKey,
        backgroundColor: bgColor,
        onDrawerChanged: (isOpen) {
          if (!isOpen && _sidebarController.isMobileOpen) {
            _sidebarController.closeMobileDrawer();
          }
        },
        drawer: Drawer(
          width: 290,
          child: AppSidebar(
            currentRoute: currentRoute,
            onNavigate: _onNavigate,
            isMobileDrawer: true,
          ),
        ),
        appBar: const AppTopBar(),
        body: widget.child,
        bottomNavigationBar: isBottomTabScreen ? const AppBottomBar() : null,
      );
    }

    // Desktop Persistent Collapsible Sidebar Layout
    return Scaffold(
      backgroundColor: bgColor,
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Persistent Responsive Sidebar
          AppSidebar(
            currentRoute: currentRoute,
            onNavigate: _onNavigate,
            isMobileDrawer: false,
          ),

          // Main Content Area with Top Bar
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const AppTopBar(),
                Expanded(
                  child: widget.child,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
