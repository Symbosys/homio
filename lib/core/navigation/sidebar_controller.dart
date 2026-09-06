import 'package:flutter/material.dart';
import '../../app/router/route_names.dart';
import 'navigation_menu_registry.dart';
import 'navigation_models.dart';

/// State Controller managing the responsive Homio CRM Sidebar navigation.
/// All menus and submenus are fully accessible.
class SidebarController extends ChangeNotifier {
  static final SidebarController instance = SidebarController._internal();
  factory SidebarController() => instance;
  SidebarController._internal();

  bool _isCollapsed = false;
  bool get isCollapsed => _isCollapsed;

  bool _isMobileOpen = false;
  bool get isMobileOpen => _isMobileOpen;

  String _activeRoute = RouteNames.dashboardOverviewPath;
  String get activeRoute => _activeRoute;

  /// The 5 high-priority routes displayed in the owner/CRM mobile bottom navigation bar
  static const Set<String> bottomTabRoutes = {
    RouteNames.dashboardOverviewPath,    // '/dashboard/overview'
    RouteNames.salesOverviewPath,        // '/sales/overview'
    RouteNames.execProjectsPath,         // '/execution/projects'
    RouteNames.accCustomerSummaryPath,   // '/accounting/customer-summary'
    RouteNames.commChatsPath,            // '/communication/chats'
  };

  /// Returns true if the active route is one of the 5 primary owner bottom tab routes.
  bool get isCurrentRouteInBottomTabs => bottomTabRoutes.contains(_activeRoute);

  String? _activeSubItemId;
  String? get activeSubItemId => _activeSubItemId;

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  final Set<String> _expandedMenuIds = {'dashboard'};
  Set<String> get expandedMenuIds => Set.unmodifiable(_expandedMenuIds);

  void toggleCollapse() {
    _isCollapsed = !_isCollapsed;
    notifyListeners();
  }

  void setCollapsed(bool value) {
    if (_isCollapsed != value) {
      _isCollapsed = value;
      notifyListeners();
    }
  }

  void openMobileDrawer() {
    _isMobileOpen = true;
    notifyListeners();
  }

  void closeMobileDrawer() {
    _isMobileOpen = false;
    notifyListeners();
  }

  void toggleMenuExpansion(String menuId) {
    if (_expandedMenuIds.contains(menuId)) {
      _expandedMenuIds.remove(menuId);
    } else {
      _expandedMenuIds.clear();
      _expandedMenuIds.add(menuId);
    }
    notifyListeners();
  }

  void expandMenu(String menuId) {
    _expandedMenuIds.clear();
    _expandedMenuIds.add(menuId);
    notifyListeners();
  }

  void collapseAllMenus() {
    _expandedMenuIds.clear();
    notifyListeners();
  }

  void setActiveRoute(String route, {String? subItemId}) {
    _activeRoute = route;
    _activeSubItemId = subItemId;
    
    // Auto-expand active parent menu and close all others
    for (final cluster in NavigationMenuRegistry.clusters) {
      for (final item in cluster.items) {
        if (item.subItems.any((s) => s.routePath == route || s.id == subItemId)) {
          _expandedMenuIds.clear();
          _expandedMenuIds.add(item.id);
          break;
        }
      }
    }
    
    _isMobileOpen = false; // Auto close mobile drawer on navigation
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query.trim().toLowerCase();
    
    if (_searchQuery.isNotEmpty) {
      for (final cluster in NavigationMenuRegistry.clusters) {
        for (final item in cluster.items) {
          final matchesParent = item.title.toLowerCase().contains(_searchQuery);
          final matchesSub = item.subItems.any((s) => 
            s.title.toLowerCase().contains(_searchQuery) ||
            (s.description?.toLowerCase().contains(_searchQuery) ?? false)
          );
          if (matchesParent || matchesSub) {
            _expandedMenuIds.add(item.id);
          }
        }
      }
    }
    notifyListeners();
  }

  /// Returns all clusters and items, filtered only by search query (no role restrictions).
  List<NavigationCluster> getFilteredClusters() {
    if (_searchQuery.isEmpty) {
      return NavigationMenuRegistry.clusters;
    }

    final List<NavigationCluster> filtered = [];

    for (final cluster in NavigationMenuRegistry.clusters) {
      final List<NavigationMenuItem> matchingItems = [];

      for (final item in cluster.items) {
        final matchesParent = item.title.toLowerCase().contains(_searchQuery);
        final matchingSubItems = item.subItems.where((s) {
          final matchesTitle = s.title.toLowerCase().contains(_searchQuery);
          final matchesDesc = s.description?.toLowerCase().contains(_searchQuery) ?? false;
          return matchesTitle || matchesDesc;
        }).toList();

        if (matchesParent || matchingSubItems.isNotEmpty) {
          matchingItems.add(
            NavigationMenuItem(
              id: item.id,
              title: item.title,
              icon: item.icon,
              badgeCount: item.badgeCount,
              badgeColor: item.badgeColor,
              subItems: matchingSubItems.isNotEmpty ? matchingSubItems : item.subItems,
              allowedRoles: item.allowedRoles,
              tooltip: item.tooltip,
            ),
          );
        }
      }

      if (matchingItems.isNotEmpty) {
        filtered.add(
          cluster.copyWith(items: matchingItems),
        );
      }
    }

    return filtered;
  }
}
