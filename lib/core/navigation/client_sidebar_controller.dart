import 'package:flutter/material.dart';
import '../../app/router/route_names.dart';
import 'client_navigation_registry.dart';
import 'navigation_models.dart';

/// State Controller managing the responsive Homio Client/Customer Sidebar navigation.
/// Supports direct navigation for single items and accordion expansion for sub-item modules (AI Studio, Marketplace).
class ClientSidebarController extends ChangeNotifier {
  static final ClientSidebarController instance = ClientSidebarController._internal();
  factory ClientSidebarController() => instance;
  ClientSidebarController._internal();

  bool _isCollapsed = false;
  bool get isCollapsed => _isCollapsed;

  bool _isMobileOpen = false;
  bool get isMobileOpen => _isMobileOpen;

  String _activeRoute = RouteNames.clientOverviewPath;
  String get activeRoute => _activeRoute;

  /// The 5 high-priority routes displayed in the mobile bottom navigation bar
  static const Set<String> bottomTabRoutes = {
    RouteNames.clientOverviewPath,
    RouteNames.clientSiteProgressPath,
    RouteNames.clientApprovalsPath,
    RouteNames.clientChatPath,
    RouteNames.clientPaymentsPath,
  };

  /// Returns true if the active route is one of the 5 primary bottom tab routes.
  bool get isCurrentRouteInBottomTabs => bottomTabRoutes.contains(_activeRoute);

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  final Set<String> _expandedMenuIds = {};
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
    _isMobileOpen = false;

    // Auto-expand parent if route belongs to a sub-item
    for (final item in ClientNavigationRegistry.items) {
      if (item.hasSubItems) {
        final matches = item.subItems.any((s) => s.routePath == route) || item.routePath == route;
        if (matches) {
          _expandedMenuIds.clear();
          _expandedMenuIds.add(item.id);
          break;
        }
      }
    }

    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query.trim().toLowerCase();
    notifyListeners();
  }

  /// Returns filtered list of client menu items.
  List<ClientMenuItem> getFilteredItems() {
    if (_searchQuery.isEmpty) {
      return ClientNavigationRegistry.items;
    }

    return ClientNavigationRegistry.items.where((item) {
      final matchesTitle = item.title.toLowerCase().contains(_searchQuery);
      final matchesDesc = item.description.toLowerCase().contains(_searchQuery);
      final matchesSubFeatures = item.subFeatures.any((f) => f.toLowerCase().contains(_searchQuery));
      final matchesSubItems = item.subItems.any((s) =>
          s.title.toLowerCase().contains(_searchQuery) ||
          s.description.toLowerCase().contains(_searchQuery));
      return matchesTitle || matchesDesc || matchesSubFeatures || matchesSubItems;
    }).toList();
  }

  /// Backward-compatible method for legacy cluster callers.
  List<NavigationCluster> getFilteredClusters() {
    return ClientNavigationRegistry.clusters;
  }
}
