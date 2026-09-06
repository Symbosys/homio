import 'package:flutter/material.dart';

/// User roles supported by Homio CRM for dynamic RBAC menu filtering.
enum PanelUserRole {
  superAdmin,
  orgAdmin,
  salesHead,
  dealCloser,
  telecaller,
  designProjectManager,
  artist3D,
  juniorDesigner,
  siteMeasurementCoordinator,
  siteSupervisor,
  juniorCoordinator,
  serviceManager,
  serviceTelecaller,
  hrManager,
  financeController,
  client,
  labourContractor,
  vendorSupplier,
}

/// Logical grouping clusters for sidebar visual categorization.
enum ClusterCategory {
  coreAnalytics,
  growthPipeline,
  executionDesign,
  commerceLabourComms,
  aiArchitecturalSuite,
  operationsFinanceHr,
  clientProjectExecution,
  clientDesignsComms,
  clientBillingPayments,
  clientComplaintsRatings,
  clientAiMarketplace,
}

/// Represents a cluster / category header in the sidebar.
class NavigationCluster {
  final ClusterCategory category;
  final String title;
  final List<NavigationMenuItem> items;

  const NavigationCluster({
    required this.category,
    required this.title,
    required this.items,
  });

  NavigationCluster copyWith({
    ClusterCategory? category,
    String? title,
    List<NavigationMenuItem>? items,
  }) {
    return NavigationCluster(
      category: category ?? this.category,
      title: title ?? this.title,
      items: items ?? this.items,
    );
  }
}

/// Represents a top-level menu item in the sidebar (e.g. Sales CRM, Quotation, Execution).
class NavigationMenuItem {
  final String id;
  final String title;
  final IconData icon;
  final int? badgeCount;
  final Color? badgeColor;
  final List<NavigationSubMenuItem> subItems;
  final List<PanelUserRole>? allowedRoles;
  final String? tooltip;

  const NavigationMenuItem({
    required this.id,
    required this.title,
    required this.icon,
    this.badgeCount,
    this.badgeColor,
    this.subItems = const [],
    this.allowedRoles,
    this.tooltip,
  });

  bool get hasSubmenu => subItems.isNotEmpty;

  /// Default route name (first submenu if available).
  String? get defaultRouteName => subItems.isNotEmpty ? subItems.first.routeName : null;

  /// Default route path (first submenu if available).
  String? get defaultRoutePath => subItems.isNotEmpty ? subItems.first.routePath : null;

  bool isAllowedFor(PanelUserRole role) {
    if (allowedRoles == null || allowedRoles!.isEmpty) return true;
    if (role == PanelUserRole.superAdmin || role == PanelUserRole.orgAdmin) return true;
    return allowedRoles!.contains(role);
  }
}

/// Represents a granular sub-menu item in the sidebar accordion.
class NavigationSubMenuItem {
  final String id;
  final String title;
  final IconData icon;
  final String routeName;
  final String routePath;
  final int? badgeCount;
  final Color? badgeColor;
  final String? description;
  final List<PanelUserRole>? allowedRoles;

  const NavigationSubMenuItem({
    required this.id,
    required this.title,
    required this.icon,
    required this.routeName,
    required this.routePath,
    this.badgeCount,
    this.badgeColor,
    this.description,
    this.allowedRoles,
  });

  bool isAllowedFor(PanelUserRole role) {
    if (allowedRoles == null || allowedRoles!.isEmpty) return true;
    if (role == PanelUserRole.superAdmin || role == PanelUserRole.orgAdmin) return true;
    return allowedRoles!.contains(role);
  }
}
