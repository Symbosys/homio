import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:client/core/layout/dashboard_shell.dart';
import 'package:client/core/layout/client_portal_shell.dart';
import 'package:client/core/navigation/navigation_menu_registry.dart';
import 'package:client/core/navigation/client_navigation_registry.dart';
import 'package:client/core/navigation/sidebar_controller.dart';
import 'package:client/core/navigation/client_sidebar_controller.dart';
import 'package:client/core/widgets/app_bottom_bar.dart';
import 'package:client/core/widgets/app_sidebar.dart';
import 'package:client/core/widgets/app_top_bar.dart';
import 'package:client/core/widgets/client_bottom_bar.dart';
import 'package:client/core/widgets/client_sidebar.dart';
import 'package:client/core/widgets/client_top_bar.dart';
import 'package:client/core/widgets/panel_page_template.dart';

void main() {
  group('NavigationMenuRegistry Tests', () {
    test('Registry contains all 6 clusters and 16 top-level modules', () {
      expect(NavigationMenuRegistry.clusters.length, 6);

      final totalMenuItems = NavigationMenuRegistry.clusters
          .expand((c) => c.items)
          .toList();
      expect(totalMenuItems.length, 16);

      // Verify key module IDs exist
      final ids = totalMenuItems.map((i) => i.id).toSet();
      expect(ids.contains('dashboard'), isTrue);
      expect(ids.contains('reports'), isTrue);
      expect(ids.contains('sales_crm'), isTrue);
      expect(ids.contains('quotation'), isTrue);
      expect(ids.contains('execution'), isTrue);
      expect(ids.contains('designs_dam'), isTrue);
      expect(ids.contains('service_booking'), isTrue);
      expect(ids.contains('shopping'), isTrue);
      expect(ids.contains('communication'), isTrue);
      expect(ids.contains('ai_suite'), isTrue);
      expect(ids.contains('operations'), isTrue);
      expect(ids.contains('accounting'), isTrue);
      expect(ids.contains('hrms'), isTrue);
      expect(ids.contains('after_sales'), isTrue);
      expect(ids.contains('organization'), isTrue);
      expect(ids.contains('admin'), isTrue);
    });

    test('Registry contains complete set of submenus with clean direct URLs', () {
      final totalSubmenus = NavigationMenuRegistry.clusters
          .expand((c) => c.items)
          .expand((i) => i.subItems)
          .toList();

      expect(totalSubmenus.length, greaterThanOrEqualTo(50));

      // Verify no /panel prefix
      for (final sub in totalSubmenus) {
        expect(sub.routePath.startsWith('/panel/'), isFalse, reason: 'Route ${sub.routePath} should not have /panel prefix');
      }
    });

    test('findInfoByPath resolves route metadata accurately', () {
      final dashInfo = NavigationMenuRegistry.findInfoByPath('/dashboard/tasks');
      expect(dashInfo.title, "Today's Tasks & Followups");
      expect(dashInfo.clusterTitle, "CORE & ANALYTICS");

      final salesInfo = NavigationMenuRegistry.findInfoByPath('/sales/funnels');
      expect(salesInfo.title, "Lead Pipelines & Funnels");
      expect(salesInfo.clusterTitle, "GROWTH & PIPELINE");

      final vastuInfo = NavigationMenuRegistry.findInfoByPath('/ai-suite/vastu-consultant');
      expect(vastuInfo.title, "AI Vastu Consultant");
      expect(vastuInfo.clusterTitle, "AI & ARCHITECTURAL SUITE");

      // Verify new Communication submenus
      final chatsInfo = NavigationMenuRegistry.findInfoByPath('/communication/chats');
      expect(chatsInfo.title, "Live Customer Chats");
      expect(chatsInfo.clusterTitle, "COMMERCE, LABOUR & COMMS");

      final bulkInfo = NavigationMenuRegistry.findInfoByPath('/communication/bulk-messages');
      expect(bulkInfo.title, "Bulk Broadcast Messages");

      final templatesInfo = NavigationMenuRegistry.findInfoByPath('/communication/templates');
      expect(templatesInfo.title, "Message Templates");

      final dripInfo = NavigationMenuRegistry.findInfoByPath('/communication/drip-campaigns');
      expect(dripInfo.title, "Drip Campaigns & Funnels");

      final historyInfo = NavigationMenuRegistry.findInfoByPath('/communication/history');
      expect(historyInfo.title, "Call & Message History");

      // Verify HRMS departments submenu
      final hrDeptInfo = NavigationMenuRegistry.findInfoByPath('/hrms/departments');
      expect(hrDeptInfo.title, "Departments & Teams");
      expect(hrDeptInfo.clusterTitle, "OPERATIONS, FINANCE & HRMS");
    });
  });

  group('ClientNavigationRegistry Tests', () {
    test('Registry contains 11 client items with direct items (1-9) and submenus (10-11)', () {
      expect(ClientNavigationRegistry.items.length, 11);

      final ids = ClientNavigationRegistry.items.map((i) => i.id).toSet();
      expect(ids.contains('client_overview'), isTrue);
      expect(ids.contains('client_team'), isTrue);
      expect(ids.contains('client_site_progress'), isTrue);
      expect(ids.contains('client_approvals'), isTrue);
      expect(ids.contains('client_designs'), isTrue);
      expect(ids.contains('client_chat'), isTrue);
      expect(ids.contains('client_payments'), isTrue);
      expect(ids.contains('client_complaints'), isTrue);
      expect(ids.contains('client_ratings'), isTrue);
      expect(ids.contains('client_ai_suite'), isTrue);
      expect(ids.contains('client_marketplace'), isTrue);

      // Primary project screens 1-9 are single-level flat items
      for (int i = 0; i < 9; i++) {
        expect(ClientNavigationRegistry.items[i].hasSubItems, isFalse);
      }

      // AI Studio has 4 submenus (Architect video call removed) & Marketplace has 4 submenus
      final aiItem = ClientNavigationRegistry.items.firstWhere((i) => i.id == 'client_ai_suite');
      expect(aiItem.hasSubItems, isTrue);
      expect(aiItem.subItems.length, 4);

      final marketItem = ClientNavigationRegistry.items.firstWhere((i) => i.id == 'client_marketplace');
      expect(marketItem.hasSubItems, isTrue);
      expect(marketItem.subItems.length, 4);
    });

    test('Each client item has comprehensive subFeatures and clean /client/* path', () {
      for (final item in ClientNavigationRegistry.items) {
        expect(item.routePath.startsWith('/client/'), isTrue, reason: 'Route ${item.routePath} should start with /client/');
        expect(item.subFeatures.isNotEmpty, isTrue, reason: 'Item ${item.title} should have subFeatures');
      }
    });

    test('findInfoByPath resolves client route metadata and sub-item routes accurately', () {
      final siteProgress = ClientNavigationRegistry.findInfoByPath('/client/site-progress');
      expect(siteProgress.title, "Live Site Progress");
      expect(siteProgress.subFeatures.length, greaterThanOrEqualTo(3));

      final team = ClientNavigationRegistry.findInfoByPath('/client/team');
      expect(team.title, "Assigned Team Dossier");

      final approvals = ClientNavigationRegistry.findInfoByPath('/client/approvals');
      expect(approvals.title, "Stage Work Approvals");

      final designs = ClientNavigationRegistry.findInfoByPath('/client/designs');
      expect(designs.title, "3D Designs & CAD Vault");

      final payments = ClientNavigationRegistry.findInfoByPath('/client/payments');
      expect(payments.title, "Billing & Invoices");

      final complaints = ClientNavigationRegistry.findInfoByPath('/client/complaints');
      expect(complaints.title, "Snags & Complaints Hub");

      final aiSuite = ClientNavigationRegistry.findInfoByPath('/client/ai-suite');
      expect(aiSuite.title, "Client AI Studio");

      // Verify AI sub-routes
      final aiRoom = ClientNavigationRegistry.findInfoByPath('/client/ai-room-generator');
      expect(aiRoom.title, "AI Room 3D Generator (50/50)");

      final vastu = ClientNavigationRegistry.findInfoByPath('/client/ai-vastu');
      expect(vastu.title, "AI Vastu Consultant");

      // Verify Marketplace sub-routes
      final digitalStore = ClientNavigationRegistry.findInfoByPath('/client/digital-store');
      expect(digitalStore.title, "Digital Guides Store");

      final decor = ClientNavigationRegistry.findInfoByPath('/client/decor-store');
      expect(decor.title, "Home Decor & Materials");

      final properties = ClientNavigationRegistry.findInfoByPath('/client/properties');
      expect(properties.title, "Rental & Properties");

      final labour = ClientNavigationRegistry.findInfoByPath('/client/hire-labour');
      expect(labour.title, "Hire On-Demand Labour");
    });
  });

  group('SidebarController Tests', () {
    test('SidebarController manages collapse state, search and active routes', () {
      final controller = SidebarController();

      expect(controller.isCollapsed, isFalse);
      controller.toggleCollapse();
      expect(controller.isCollapsed, isTrue);
      controller.setCollapsed(false);
      expect(controller.isCollapsed, isFalse);

      controller.setActiveRoute('/quotation/builder');
      expect(controller.activeRoute, '/quotation/builder');

      // Test Search filtering
      controller.setSearchQuery('vastu');
      final filtered = controller.getFilteredClusters();
      expect(filtered.isNotEmpty, isTrue);

      final hasVastu = filtered
          .expand((c) => c.items)
          .any((i) => i.title.toLowerCase().contains('vastu') || i.subItems.any((s) => s.title.toLowerCase().contains('vastu')));
      expect(hasVastu, isTrue);

      // Clear search
      controller.setSearchQuery('');
      expect(controller.getFilteredClusters().length, 6);
    });

    test('SidebarController enforces single accordion menu expansion', () {
      final controller = SidebarController();

      // Expand a specific menu
      controller.expandMenu('reports');
      expect(controller.expandedMenuIds, {'reports'});

      // Toggling another menu closes the previous one
      controller.toggleMenuExpansion('sales_crm');
      expect(controller.expandedMenuIds, {'sales_crm'});

      // Toggling the same menu collapses it
      controller.toggleMenuExpansion('sales_crm');
      expect(controller.expandedMenuIds.isEmpty, isTrue);

      // Setting active route auto-expands only its parent menu
      controller.setActiveRoute('/dashboard/overview');
      expect(controller.expandedMenuIds, {'dashboard'});
    });

    test('SidebarController correctly identifies the 5 high-priority bottom tab routes', () {
      final controller = SidebarController();

      controller.setActiveRoute('/dashboard/overview');
      expect(controller.isCurrentRouteInBottomTabs, isTrue);

      controller.setActiveRoute('/sales/overview');
      expect(controller.isCurrentRouteInBottomTabs, isTrue);

      controller.setActiveRoute('/execution/projects');
      expect(controller.isCurrentRouteInBottomTabs, isTrue);

      controller.setActiveRoute('/accounting/customer-summary');
      expect(controller.isCurrentRouteInBottomTabs, isTrue);

      controller.setActiveRoute('/communication/chats');
      expect(controller.isCurrentRouteInBottomTabs, isTrue);

      controller.setActiveRoute('/quotation/builder');
      expect(controller.isCurrentRouteInBottomTabs, isFalse);

      controller.setActiveRoute('/hrms/departments');
      expect(controller.isCurrentRouteInBottomTabs, isFalse);
    });
  });

  group('ClientSidebarController Tests', () {
    test('ClientSidebarController manages collapse state, search and active routes', () {
      final controller = ClientSidebarController();

      expect(controller.isCollapsed, isFalse);
      controller.toggleCollapse();
      expect(controller.isCollapsed, isTrue);
      controller.setCollapsed(false);
      expect(controller.isCollapsed, isFalse);

      controller.setActiveRoute('/client/team');
      expect(controller.activeRoute, '/client/team');

      // Setting active route to a sub-item auto-expands the parent menu
      controller.setActiveRoute('/client/ai-room-generator');
      expect(controller.activeRoute, '/client/ai-room-generator');
      expect(controller.expandedMenuIds, {'client_ai_suite'});

      // Test Search filtering across items and subFeatures
      controller.setSearchQuery('vastu');
      final filtered = controller.getFilteredItems();
      expect(filtered.isNotEmpty, isTrue);

      final hasVastu = filtered.any((i) =>
          i.title.toLowerCase().contains('vastu') ||
          i.description.toLowerCase().contains('vastu') ||
          i.subFeatures.any((s) => s.toLowerCase().contains('vastu')) ||
          i.subItems.any((s) => s.title.toLowerCase().contains('vastu')));
      expect(hasVastu, isTrue);

      // Clear search
      controller.setSearchQuery('');
      expect(controller.getFilteredItems().length, 11);
    });

    test('ClientSidebarController manages menu expansion for AI and Marketplace', () {
      final controller = ClientSidebarController();

      controller.expandMenu('client_marketplace');
      expect(controller.expandedMenuIds, {'client_marketplace'});

      controller.toggleMenuExpansion('client_ai_suite');
      expect(controller.expandedMenuIds, {'client_ai_suite'});

      controller.toggleMenuExpansion('client_ai_suite');
      expect(controller.expandedMenuIds.isEmpty, isTrue);
    });
  });

  group('DashboardShell & ClientPortalShell Widget Tests', () {
    testWidgets('DashboardShell renders AppSidebar, AppTopBar, and PanelPageTemplate', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(
        MaterialApp(
          home: DashboardShell(
            child: PanelPageTemplate.fromPath('/dashboard/overview'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(AppSidebar), findsOneWidget);
      expect(find.byType(AppTopBar), findsOneWidget);
      expect(find.byType(PanelPageTemplate), findsOneWidget);
      expect(find.text('HOMIO'), findsWidgets);
      expect(find.text('This is Overview & Score'), findsOneWidget);
      expect(find.text('/dashboard/overview'), findsOneWidget);
    });

    testWidgets('DashboardShell renders AppBottomBar on mobile devices with 5 high-priority owner tabs', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(390, 844); // Mobile phone viewport
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      SidebarController.instance.setActiveRoute('/dashboard/overview');

      await tester.pumpWidget(
        MaterialApp(
          home: DashboardShell(
            child: PanelPageTemplate.fromPath('/dashboard/overview'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify AppBottomBar is rendered on mobile for primary tab
      expect(find.byType(AppBottomBar), findsOneWidget);

      // Verify all 5 high-priority owner tabs are present
      expect(find.text('Dashboard'), findsWidgets);
      expect(find.text('Sales CRM'), findsWidgets);
      expect(find.text('Projects'), findsWidgets);
      expect(find.text('Finance'), findsWidgets);
      expect(find.text('Comms'), findsWidgets);

      // Verify notification badges on owner tabs (Sales CRM: 5, Projects: 2, Comms: 3)
      expect(find.text('5'), findsWidgets);
      expect(find.text('2'), findsWidgets);
      expect(find.text('3'), findsWidgets);
    });

    testWidgets('DashboardShell hides AppBottomBar and shows drawer menu on secondary owner screens', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(390, 844); // Mobile phone viewport
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      SidebarController.instance.setActiveRoute('/quotation/builder');

      await tester.pumpWidget(
        MaterialApp(
          home: DashboardShell(
            child: PanelPageTemplate.fromPath('/quotation/builder'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify AppBottomBar is HIDDEN on non-bottom-tab screens
      expect(find.byType(AppBottomBar), findsNothing);

      // Verify no back icon, but drawer menu icon and page title are present in AppTopBar
      expect(find.byIcon(Icons.arrow_back_rounded), findsNothing);
      expect(find.text('Quotation Builder'), findsWidgets);
      expect(find.byIcon(Icons.menu_rounded), findsOneWidget);
    });

    testWidgets('ClientPortalShell renders ClientSidebar, ClientTopBar, and ClientScreenContent', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(
        MaterialApp(
          home: ClientPortalShell(
            child: PanelPageTemplate.fromPath('/client/site-progress'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(ClientSidebar), findsOneWidget);
      expect(find.byType(ClientTopBar), findsOneWidget);
      expect(find.byType(PanelPageTemplate), findsOneWidget);
      expect(find.text('Live Site Progress'), findsWidgets);
      expect(find.text('/client/site-progress'), findsOneWidget);
      expect(find.text('DAILY SITE INSPECTION STREAM (PHOTOS & VIDEOS)'), findsOneWidget);
    });

    testWidgets('ClientSidebar renders Marketplace & Services and expands all 4 submenus on tap', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      ClientSidebarController.instance.collapseAllMenus();

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ClientSidebar(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Find Marketplace & Services parent item
      final marketplaceFinder = find.text('Marketplace & Services');
      expect(marketplaceFinder, findsOneWidget);

      // Tap Marketplace & Services to expand
      await tester.tap(marketplaceFinder);
      await tester.pumpAndSettle();

      // Verify all 4 submenus are rendered
      expect(find.text('Digital Guides Store'), findsOneWidget);
      expect(find.text('Home Decor & Materials'), findsOneWidget);
      expect(find.text('Rental & Properties'), findsOneWidget);
      expect(find.text('Hire On-Demand Labour'), findsOneWidget);
    });

    testWidgets('ClientPortalShell renders ClientBottomBar on compact/mobile devices with all 5 high-priority tabs', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(390, 844); // Mobile phone viewport
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      ClientSidebarController.instance.setActiveRoute('/client/overview');

      await tester.pumpWidget(
        MaterialApp(
          home: ClientPortalShell(
            child: PanelPageTemplate.fromPath('/client/overview'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify ClientBottomBar is rendered on mobile
      expect(find.byType(ClientBottomBar), findsOneWidget);

      // Verify all 5 high-priority tabs are present
      expect(find.text('Overview'), findsWidgets);
      expect(find.text('Live Site'), findsWidgets);
      expect(find.text('Approvals'), findsWidgets);
      expect(find.text('Chat'), findsWidgets);
      expect(find.text('Billing'), findsWidgets);

      // Verify notification badges on tabs (Approvals: 2, Chat: 3, Billing: 1)
      expect(find.text('2'), findsWidgets);
      expect(find.text('3'), findsWidgets);
      expect(find.text('1'), findsWidgets);
    });

    testWidgets('ClientPortalShell hides ClientBottomBar and shows drawer menu with page title on secondary screens', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(390, 844); // Mobile phone viewport
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      ClientSidebarController.instance.setActiveRoute('/client/designs');

      await tester.pumpWidget(
        MaterialApp(
          home: ClientPortalShell(
            child: PanelPageTemplate.fromPath('/client/designs'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify ClientBottomBar is HIDDEN on non-bottom-tab screens
      expect(find.byType(ClientBottomBar), findsNothing);

      // Verify no back icon, but drawer menu icon and page title are present in ClientTopBar
      expect(find.byIcon(Icons.arrow_back_rounded), findsNothing);
      expect(find.text('3D Designs & CAD Vault'), findsWidgets);
      expect(find.byIcon(Icons.menu_rounded), findsOneWidget);
    });
  });
}

