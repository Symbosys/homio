import 'package:flutter/material.dart';
import '../navigation/client_sidebar_controller.dart';
import '../responsive/breakpoints.dart';
import '../widgets/client_bottom_bar.dart';
import '../widgets/client_sidebar.dart';
import '../widgets/client_top_bar.dart';

/// Root shell layout for all authenticated Homio Client/Customer Portal routes.
/// Provides a persistent, responsive collapsible sidebar on desktop, and a drawer + 5-tab bottom navigation bar on mobile/tablet.
class ClientPortalShell extends StatefulWidget {
  final Widget child;

  const ClientPortalShell({
    super.key,
    required this.child,
  });

  @override
  State<ClientPortalShell> createState() => _ClientPortalShellState();
}

class _ClientPortalShellState extends State<ClientPortalShell> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ClientSidebarController _sidebarController = ClientSidebarController.instance;

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

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isCompact = screenWidth < Breakpoints.medium;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isBottomTabScreen = _sidebarController.isCurrentRouteInBottomTabs;

    final bgColor = isDark ? const Color(0xFF090D16) : const Color(0xFFF8FAFC);

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
        drawer: const Drawer(
          width: 290,
          child: ClientSidebar(isDrawer: true),
        ),
        appBar: const ClientTopBar(),
        body: widget.child,
        bottomNavigationBar: isBottomTabScreen ? const ClientBottomBar() : null,
      );
    }

    // Desktop Persistent Collapsible Sidebar Layout
    return Scaffold(
      backgroundColor: bgColor,
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Persistent Responsive Sidebar
          const ClientSidebar(isDrawer: false),

          // Main Content Area with Top Bar
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const ClientTopBar(),
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
