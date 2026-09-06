import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/layout/client_portal_shell.dart';
import '../../core/layout/dashboard_shell.dart';
import '../../core/navigation/client_navigation_registry.dart';
import '../../core/navigation/navigation_menu_registry.dart';
import '../../core/widgets/panel_page_template.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/client/ai_studio/index.dart';
import '../../features/client/assigned_team/index.dart';
import '../../features/client/billing_invoices/index.dart';
import '../../features/client/dashboard/index.dart';
import '../../features/client/designs_vault/index.dart';
import '../../features/client/feedback_ratings/index.dart';
import '../../features/client/marketplace/index.dart';
import '../../features/client/project_chat_meetings/index.dart';
import '../../features/client/site_progress/index.dart';
import '../../features/client/snags_complaints/index.dart';
import '../../features/client/stage_work_approvals/index.dart';
import '../../features/dashboard/index.dart';
import '../../features/landing/presentation/pages/landing_page.dart';
import '../../features/reports/index.dart';
import '../../features/sales/index.dart';
import '../../features/quotation/index.dart';
import 'route_names.dart';

export 'route_names.dart';

/// Central routing logic and GoRouter configuration for Homio SaaS platform.
/// Manages routes for both the Team/Admin CRM and the Client/Homeowner Portal.
abstract class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: RouteNames.landingPath,
    routes: [
      // 1. Public Landing Page
      GoRoute(
        path: RouteNames.landingPath,
        name: RouteNames.landing,
        builder: (context, state) => const LandingPage(),
      ),

      // 2. Authentication Login Page (With Team CRM / Client Portal Switcher)
      GoRoute(
        path: RouteNames.loginPath,
        name: RouteNames.login,
        builder: (context, state) => const LoginPage(),
      ),

      // 3. Authenticated Team CRM Panel Layout Shell (Persistent Sidebar + Top Bar)
      ShellRoute(
        builder: (context, state, child) {
          return DashboardShell(child: child);
        },
        routes: _buildAllSubmenuRoutes(),
      ),

      // 4. Authenticated Client / Customer Portal Shell (Client Sidebar + Top Bar)
      ShellRoute(
        builder: (context, state, child) {
          return ClientPortalShell(child: child);
        },
        routes: _buildAllClientRoutes(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(child: Text('Page not found: ${state.uri.path}')),
    ),
  );

  /// Automatically generates named GoRoutes for all submenus in NavigationMenuRegistry.
  static List<RouteBase> _buildAllSubmenuRoutes() {
    final List<RouteBase> routes = [];
    final Set<String> registeredNames = {};

    for (final cluster in NavigationMenuRegistry.clusters) {
      for (final item in cluster.items) {
        for (final sub in item.subItems) {
          if (registeredNames.add(sub.routeName)) {
            routes.add(
              GoRoute(
                name: sub.routeName,
                path: sub.routePath,
                builder: (context, state) {
                  // Core Dashboard Submenus
                  if (sub.routeName == RouteNames.dashboardOverview) {
                    return const DashboardOverviewPage();
                  }
                  if (sub.routeName == RouteNames.dashboardTasks) {
                    return const DashboardTasksPage();
                  }
                  if (sub.routeName == RouteNames.dashboardAttendance) {
                    return const DashboardAttendancePage();
                  }
                  if (sub.routeName == RouteNames.dashboardTravel) {
                    return const DashboardTravelPage();
                  }
                  if (sub.routeName == RouteNames.dashboardWallet) {
                    return const DashboardWalletPage();
                  }

                  // Reports & Analytics Submenus
                  if (sub.routeName == RouteNames.reportsMarketing) {
                    return const ReportsMarketingPage();
                  }
                  if (sub.routeName == RouteNames.reportsSales) {
                    return const ReportsSalesPage();
                  }
                  if (sub.routeName == RouteNames.reportsDesign) {
                    return const ReportsDesignPage();
                  }
                  if (sub.routeName == RouteNames.reportsExecution) {
                    return const ReportsExecutionPage();
                  }
                  if (sub.routeName == RouteNames.reportsVendorRatings) {
                    return const ReportsVendorRatingsPage();
                  }
                  if (sub.routeName == RouteNames.reportsFinances) {
                    return const ReportsFinancesPage();
                  }

                  // Sales & CRM Submenus
                  if (sub.routeName == RouteNames.salesOverview) {
                    return const SalesOverviewPage();
                  }
                  if (sub.routeName == RouteNames.salesFunnels) {
                    return const SalesFunnelsPage();
                  }
                  if (sub.routeName == RouteNames.salesDirectory) {
                    return const SalesDirectoryPage();
                  }
                  if (sub.routeName == RouteNames.salesWhatsappApi) {
                    return const SalesWhatsAppPage();
                  }
                  if (sub.routeName == RouteNames.salesAiCalling) {
                    return const SalesAiCallingPage();
                  }
                  if (sub.routeName == RouteNames.salesCalendar) {
                    return const SalesCalendarPage();
                  }
                  if (sub.routeName == RouteNames.salesTasks) {
                    return const SalesTasksPage();
                  }

                  // Quotation & Estimation Submenus
                  if (sub.routeName == RouteNames.quoteBuilder) {
                    return const QuotationBuilderPage();
                  }
                  if (sub.routeName == RouteNames.quoteItemMaster) {
                    return const QuotationItemMasterPage();
                  }
                  if (sub.routeName == RouteNames.quoteDocuments) {
                    return const QuotationDocumentsPage();
                  }
                  if (sub.routeName == RouteNames.quoteUrgency) {
                    return const QuotationUrgencyPage();
                  }
                  if (sub.routeName == RouteNames.quoteSelfService) {
                    return const QuotationSelfServicePage();
                  }

                  return PanelPageTemplate.fromPath(sub.routePath);
                },
              ),
            );
          }
        }
      }
    }

    return routes;
  }

  /// Automatically generates named GoRoutes for all direct and alias routes in ClientNavigationRegistry.
  static List<RouteBase> _buildAllClientRoutes() {
    final List<RouteBase> routes = [];
    final Set<String> registeredNames = {};

    // Direct single-level flat routes
    for (final item in ClientNavigationRegistry.items) {
      if (registeredNames.add(item.routeName)) {
        routes.add(
          GoRoute(
            name: item.routeName,
            path: item.routePath,
            builder: (context, state) {
              if (item.routeName == RouteNames.clientOverview) {
                return const ClientDashboardPage();
              }
              if (item.routeName == RouteNames.clientTeam) {
                return const ClientAssignedTeamPage();
              }
              if (item.routeName == RouteNames.clientSiteProgress) {
                return const ClientSiteProgressPage();
              }
              if (item.routeName == RouteNames.clientApprovals) {
                return const ClientStageWorkApprovalsPage();
              }
              if (item.routeName == RouteNames.clientDesigns) {
                return const ClientDesignsVaultPage();
              }
              if (item.routeName == RouteNames.clientChat) {
                return const ClientProjectChatMeetingsPage();
              }
              if (item.routeName == RouteNames.clientPayments) {
                return const ClientBillingInvoicesPage();
              }
              if (item.routeName == RouteNames.clientComplaints) {
                return const ClientSnagsComplaintsPage();
              }
              if (item.routeName == RouteNames.clientRatings) {
                return const ClientFeedbackRatingsPage();
              }
              if (item.routeName == RouteNames.clientAiSuite) {
                return const ClientAiStudioHubPage();
              }
              if (item.routeName == RouteNames.clientMarketplace) {
                return const ClientMarketplaceHubPage();
              }
              return PanelPageTemplate.fromPath(item.routePath);
            },
          ),
        );
      }
    }

    // Backward-compatible alias routes
    final legacyRoutes = [
      (RouteNames.clientMilestones, RouteNames.clientMilestonesPath),
      (RouteNames.clientApprovalHistory, RouteNames.clientApprovalHistoryPath),
      (RouteNames.clientDesignRevisions, RouteNames.clientDesignRevisionsPath),
      (RouteNames.clientDocuments, RouteNames.clientDocumentsPath),
      (RouteNames.clientMeetings, RouteNames.clientMeetingsPath),
      (RouteNames.clientCostSummary, RouteNames.clientCostSummaryPath),
      (RouteNames.clientInvoices, RouteNames.clientInvoicesPath),
      (RouteNames.clientWarranty, RouteNames.clientWarrantyPath),
      (RouteNames.clientAiRoomGen, RouteNames.clientAiRoomGenPath),
      (RouteNames.clientAiVastu, RouteNames.clientAiVastuPath),
      (RouteNames.clientAiBudget, RouteNames.clientAiBudgetPath),
      (RouteNames.clientAiDoubtSolver, RouteNames.clientAiDoubtSolverPath),
      (RouteNames.clientDesignerCall, RouteNames.clientDesignerCallPath),
      (RouteNames.clientDigitalStore, RouteNames.clientDigitalStorePath),
      (RouteNames.clientDecorStore, RouteNames.clientDecorStorePath),
      (RouteNames.clientProperties, RouteNames.clientPropertiesPath),
      (RouteNames.clientHireLabour, RouteNames.clientHireLabourPath),
    ];

    for (final r in legacyRoutes) {
      if (registeredNames.add(r.$1)) {
        routes.add(
          GoRoute(
            name: r.$1,
            path: r.$2,
            builder: (context, state) {
              if (r.$1 == RouteNames.clientApprovalHistory) {
                return const ClientStageWorkApprovalsPage();
              }
              if (r.$1 == RouteNames.clientDesignRevisions ||
                  r.$1 == RouteNames.clientDocuments) {
                return const ClientDesignsVaultPage();
              }
              if (r.$1 == RouteNames.clientMeetings) {
                return const ClientProjectChatMeetingsPage();
              }
              if (r.$1 == RouteNames.clientWarranty) {
                return const ClientSnagsComplaintsPage();
              }
              if (r.$1 == RouteNames.clientCostSummary ||
                  r.$1 == RouteNames.clientInvoices ||
                  r.$1 == RouteNames.clientMilestones) {
                return const ClientBillingInvoicesPage();
              }
              if (r.$1 == RouteNames.clientAiRoomGen) {
                return const ClientAiRoomGeneratorPage();
              }
              if (r.$1 == RouteNames.clientAiVastu) {
                return const ClientAiVastuConsultantPage();
              }
              if (r.$1 == RouteNames.clientAiBudget) {
                return const ClientAiBudgetEstimatorPage();
              }
              if (r.$1 == RouteNames.clientAiDoubtSolver) {
                return const ClientAiDoubtSolverPage();
              }
              if (r.$1 == RouteNames.clientDigitalStore) {
                return const ClientDigitalStorePage();
              }
              if (r.$1 == RouteNames.clientDecorStore) {
                return const ClientDecorStorePage();
              }
              if (r.$1 == RouteNames.clientProperties) {
                return const ClientPropertiesPage();
              }
              if (r.$1 == RouteNames.clientHireLabour) {
                return const ClientHireLabourPage();
              }
              return PanelPageTemplate.fromPath(r.$2);
            },
          ),
        );
      }
    }

    return routes;
  }
}
