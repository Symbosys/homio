import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/layout/client_portal_shell.dart';
import '../../core/layout/dashboard_shell.dart';
import '../../core/navigation/client_navigation_registry.dart';
import '../../core/navigation/navigation_menu_registry.dart';
import '../../core/widgets/not_found_page.dart';
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
import '../../features/marketing/index.dart';
import '../../features/reports/index.dart';
import '../../features/sales/index.dart';
import '../../features/quotation/index.dart';
import '../../features/execution/index.dart';
import '../../features/designs/index.dart';
import '../../features/service_booking/index.dart';
import '../../features/shopping/index.dart';
import '../../features/communication/index.dart';
import '../../features/ai_suite/index.dart';
import '../../features/operations/index.dart';
import '../../features/accounting/index.dart';
import '../../features/hrms/index.dart';
import '../../features/after_sales/index.dart';
import '../../features/organization/index.dart';
import '../../features/system_admin/index.dart';
import '../navigation/admin_navigation_config.dart';
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
    errorBuilder: (context, state) => NotFoundPage(path: state.uri.path),
  );

  /// Automatically generates named GoRoutes for all submenus in NavigationMenuRegistry.
  static List<RouteBase> _buildAllSubmenuRoutes() {
    final List<RouteBase> routes = [];
    final Set<String> registeredNames = {};
    final Set<String> registeredPaths = {};

    for (final cluster in NavigationMenuRegistry.clusters) {
      for (final item in cluster.items) {
        for (final sub in item.subItems) {
          if (registeredNames.add(sub.routeName)) {
            registeredPaths.add(sub.routePath);
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
                    return const SalesLeadsPage();
                  }
                  if (sub.routeName == RouteNames.salesWhatsappApi) {
                    return const SalesAutomationPage();
                  }
                  if (sub.routeName == RouteNames.salesAiCalling) {
                    return const SalesCallsPage();
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

                  // Project Execution Submenus
                  if (sub.routeName == RouteNames.execProjects) {
                    return const ExecutionProjectsPage();
                  }
                  if (sub.routeName == RouteNames.execGantt) {
                    return const ExecutionGanttPage();
                  }
                  if (sub.routeName == RouteNames.execSiteProgress) {
                    return const ExecutionSiteProgressPage();
                  }
                  if (sub.routeName == RouteNames.execComplaints) {
                    return const ExecutionComplaintsPage();
                  }
                  if (sub.routeName == RouteNames.execWorkApprovals) {
                    return const ExecutionWorkApprovalsPage();
                  }
                  if (sub.routeName == RouteNames.execCommercials) {
                    return const ExecutionCommercialsPage();
                  }
                  if (sub.routeName == RouteNames.execRatings) {
                    return const ExecutionRatingsPage();
                  }
                  if (sub.routeName == RouteNames.execSpreadsheet) {
                    return const ExecutionSpreadsheetPage();
                  }

                  // Designs & DAM Submenus
                  if (sub.routeName == RouteNames.damWorkspace) {
                    return const DesignWorkspacePage();
                  }
                  if (sub.routeName == RouteNames.damApprovalLoop) {
                    return const DesignApprovalLoopPage();
                  }
                  if (sub.routeName == RouteNames.damCloudDrive) {
                    return const DesignCloudDrivePage();
                  }

                  // Service Booking & Labour Submenus
                  if (sub.routeName == RouteNames.srvHireLabour) {
                    return const HireLabourPage();
                  }
                  if (sub.routeName == RouteNames.srvLabourKyc) {
                    return const LabourKycPage();
                  }
                  if (sub.routeName == RouteNames.srvOnboardLabour) {
                    return const OnboardLabourPage();
                  }
                  if (sub.routeName == RouteNames.srvActiveBookings) {
                    return const ActiveBookingsPage();
                  }
                  if (sub.routeName == RouteNames.srvLegalHub) {
                    return const LegalHubPage();
                  }

                  // Shopping & Marketplace Submenus
                  if (sub.routeName == RouteNames.shopDigitalStore) {
                    return const DigitalStorePage();
                  }
                  if (sub.routeName == RouteNames.shopDecorAffiliates) {
                    return const DecorAffiliatesPage();
                  }
                  if (sub.routeName == RouteNames.shopProperties) {
                    return const PropertiesPage();
                  }
                  if (sub.routeName == RouteNames.shopMaterials) {
                    return const MaterialsPage();
                  }

                  // Communication Hub Submenus
                  if (sub.routeName == RouteNames.commChats) {
                    return const LiveCustomerChatsPage();
                  }
                  if (sub.routeName == RouteNames.commBroadcasts ||
                      sub.routeName == RouteNames.commBulkMessages ||
                      sub.routeName == RouteNames.commScheduled) {
                    return const BroadcastsScheduledPage();
                  }
                  if (sub.routeName == RouteNames.commTemplates) {
                    return const MessageTemplatesPage();
                  }
                  if (sub.routeName == RouteNames.commDripCampaigns) {
                    return const DripCampaignsPage();
                  }
                  if (sub.routeName == RouteNames.commHistory) {
                    return const CallMessageHistoryPage();
                  }
                  if (sub.routeName == RouteNames.commSiteProgress) {
                    return const LiveSiteProgressFeedPage();
                  }
                  if (sub.routeName == RouteNames.commBlueprints) {
                    return const BlueprintsDamFilesPage();
                  }
                  if (sub.routeName == RouteNames.commMeetings) {
                    return const MeetingSchedulingPage();
                  }

                  // AI Architectural Suite Submenus
                  if (sub.routeName == RouteNames.aiRoomGenerator) {
                    return const AiRoomGeneratorPage();
                  }
                  if (sub.routeName == RouteNames.aiVastuConsultant) {
                    return const AiVastuConsultantPage();
                  }
                  if (sub.routeName == RouteNames.aiBudgetCalculator) {
                    return const AiBudgetCalculatorPage();
                  }
                  if (sub.routeName == RouteNames.aiDoubtSolver) {
                    return const AiDoubtSolverPage();
                  }
                  if (sub.routeName == RouteNames.aiDesignerVideoCall) {
                    return const AiDesignerVideoCallPage();
                  }

                  // Operations & Procurement Submenus
                  if (sub.routeName == RouteNames.opsMaterialRfq) {
                    return const MaterialRfqPage();
                  }
                  if (sub.routeName == RouteNames.opsDesignPayment) {
                    return const DesignPaymentPage();
                  }
                  if (sub.routeName == RouteNames.opsSaturdayFees) {
                    return const SaturdayFeesPage();
                  }

                  // Accounting & Client Ledgers Submenus
                  if (sub.routeName == RouteNames.accCustomerSummary) {
                    return const CustomerFinancialSummaryPage();
                  }
                  if (sub.routeName == RouteNames.accExpenseLedgers) {
                    return const ClientExpenseLedgersPage();
                  }
                  if (sub.routeName == RouteNames.accOverdueAlerts) {
                    return const OverduePaymentAlertsPage();
                  }

                  // HRMS & Field Operations Submenus
                  if (sub.routeName == RouteNames.hrEmployeeDirectory) {
                    return const EmployeeDirectoryPage();
                  }
                  if (sub.routeName == RouteNames.hrDepartments) {
                    return const DepartmentsTeamsPage();
                  }
                  if (sub.routeName == RouteNames.hrGeofenceAttendance) {
                    return const GeofenceAttendancePage();
                  }
                  if (sub.routeName == RouteNames.hrTravelMileage) {
                    return const TravelMileagePage();
                  }
                  if (sub.routeName == RouteNames.hrLeavePenalty) {
                    return const LeavePenaltyPage();
                  }
                  if (sub.routeName == RouteNames.hrPayrollSlips) {
                    return const PayrollSlipsPage();
                  }
                  if (sub.routeName == RouteNames.hrNoticePeriod) {
                    return const NoticePeriodPage();
                  }

                  // After-Sales Service Submenus
                  if (sub.routeName == RouteNames.svcSnagsWarranty) {
                    return const SnagsWarrantyPage();
                  }
                  if (sub.routeName == RouteNames.svcRetentionCalls) {
                    return const RetentionCallsPage();
                  }

                  // Organization & Roles Submenus
                  if (sub.routeName == RouteNames.orgDepartments) {
                    return const OrgDepartmentsPage();
                  }
                  if (sub.routeName == RouteNames.orgRoleLevels) {
                    return const OrgRoleLevelsPage();
                  }
                  if (sub.routeName == RouteNames.orgAccessScope) {
                    return const OrgAccessScopePage();
                  }

                  // System Administration Submenus
                  if (sub.routeName == RouteNames.admRbacMatrix) {
                    return const RbacMatrixPage();
                  }
                  if (sub.routeName == RouteNames.admRateMasters) {
                    return const MasterRateCardsPage();
                  }
                  if (sub.routeName == RouteNames.admAiTraining) {
                    return const AiPromptTrainingPage();
                  }
                  if (sub.routeName == RouteNames.admDisasterBackup) {
                    return const DisasterBackupPage();
                  }

                  return PanelPageTemplate.fromPath(sub.routePath);
                },
              ),
            );
          }
        }
      }
    }

    // Explicit registration fallback for sub-routes
    if (registeredNames.add(RouteNames.srvOnboardLabour)) {
      routes.add(
        GoRoute(
          name: RouteNames.srvOnboardLabour,
          path: RouteNames.srvOnboardLabourPath,
          builder: (context, state) => const OnboardLabourPage(),
        ),
      );
    }

    // Register all 17 Admin Navigation modules & submenus from AdminNavigationConfig
    for (final group in AdminNavigationConfig.masterGroups) {
      for (final child in group.children) {
        if (registeredPaths.add(child.route)) {
          routes.add(
            GoRoute(
              name: child.id,
              path: child.route,
              builder: (context, state) => _resolveAdminPage(child.id, child.route),
            ),
          );
        }
        for (final alias in child.legacyAliases) {
          if (registeredPaths.add(alias)) {
            routes.add(
              GoRoute(
                name: 'alias_${child.id}_${alias.replaceAll('/', '_')}',
                path: alias,
                builder: (context, state) => _resolveAdminPage(child.id, child.route),
              ),
            );
          }
        }
      }
    }

    // Register all Legacy Route Aliases from RouteNames
    RouteNames.legacyRouteAliases.forEach((alias, canonical) {
      if (registeredPaths.add(alias)) {
        routes.add(
          GoRoute(
            path: alias,
            builder: (context, state) => _resolveAdminPage(alias, canonical),
          ),
        );
      }
    });

    return routes;
  }

  /// Maps an admin navigation item ID or route to its corresponding page widget.
  static Widget _resolveAdminPage(String id, String path) {
    switch (id) {
      // 1. Dashboard
      case 'dashboard_overview':
        return const DashboardOverviewPage();
      case 'dashboard_my_tasks':
        return const DashboardTasksPage();
      case 'dashboard_attendance':
        return const DashboardAttendancePage();
      case 'dashboard_travel':
        return const DashboardTravelPage();
      case 'dashboard_wallet':
        return const DashboardWalletPage();

      // 2. CRM & Sales
      case 'crm_overview':
        return const SalesOverviewPage();
      case 'crm_leads':
        return const SalesLeadsPage();
      case 'crm_customers':
        return const SalesCustomersPage();
      case 'crm_funnels':
        return const SalesFunnelsPage();
      case 'crm_followups':
        return const SalesFollowupsPage();
      case 'crm_calls':
        return const SalesCallsPage();
      case 'crm_meetings':
        return const SalesCalendarPage();
      case 'crm_tasks':
        return const SalesTasksPage();
      case 'crm_automation':
        return const SalesAutomationPage();

      // 3. Marketing
      case 'marketing_overview':
      case '/marketing/overview':
        return const MarketingOverviewPage();
      case 'marketing_sources':
      case '/marketing/sources':
      case '/marketing/lead-sources':
        return const MarketingSourcesPage();
      case 'marketing_campaigns':
      case '/marketing/campaigns':
        return const MarketingCampaignsPage();
      case 'marketing_social':
      case '/marketing/social':
      case '/marketing/social-analytics':
        return const MarketingSocialPage();
      case 'marketing_reports':
      case '/marketing/reports':
        return const MarketingReportsPage();

      // 4. Projects
      case 'projects_all':
      case 'projects_overview':
        return const ExecutionProjectsPage();
      case 'projects_gantt':
        return const ExecutionGanttPage();
      case 'projects_site_progress':
        return const ExecutionSiteProgressPage();
      case 'projects_snags':
        return const ExecutionComplaintsPage();
      case 'projects_approvals':
        return const ExecutionWorkApprovalsPage();
      case 'projects_commercials':
        return const ExecutionCommercialsPage();

      // 5. Designs & DAM
      case 'designs_workspace':
        return const DesignWorkspacePage();
      case 'designs_approvals':
        return const DesignApprovalLoopPage();
      case 'designs_drive':
        return const DesignCloudDrivePage();

      // 6. Quotations
      case 'quotations_all':
      case 'quotations_create':
        return const QuotationBuilderPage();
      case 'quotations_rate_master':
        return const QuotationItemMasterPage();
      case 'quotations_documents':
        return const QuotationDocumentsPage();
      case 'quotations_expiry_reminders':
        return const QuotationUrgencyPage();
      case 'quotations_self':
        return const QuotationSelfServicePage();

      // 7. Procurement & Operations
      case 'procurement_material_requests':
        return const MaterialRfqPage();
      case 'procurement_design_payments':
        return const DesignPaymentPage();
      case 'procurement_weekly_fees':
        return const SaturdayFeesPage();

      // 8. Accounting & Finance
      case 'finance_overview':
        return const CustomerFinancialSummaryPage();
      case 'finance_expenses':
        return const ClientExpenseLedgersPage();
      case 'finance_collections':
        return const OverduePaymentAlertsPage();

      // 9. Communication
      case 'communication_chats':
        return const LiveCustomerChatsPage();
      case 'communication_broadcasts':
      case 'communication_bulk':
      case 'communication_scheduled':
        return const BroadcastsScheduledPage();
      case 'communication_templates':
        return const MessageTemplatesPage();
      case 'communication_drip':
        return const DripCampaignsPage();
      case 'communication_history':
        return const CallMessageHistoryPage();

      // 10. Service & Labour
      case 'service_labour_directory':
        return const HireLabourPage();
      case 'service_labour_kyc':
        return const LabourKycPage();
      case 'service_labour_onboard':
        return const OnboardLabourPage();
      case 'service_labour_bookings':
        return const ActiveBookingsPage();
      case 'service_labour_disputes':
        return const LegalHubPage();

      // 11. After-Sales
      case 'after_sales_requests':
      case 'after_sales_warranty':
        return const SnagsWarrantyPage();
      case 'after_sales_retention':
        return const RetentionCallsPage();

      // 12. HRMS
      case 'hrms_employees':
        return const EmployeeDirectoryPage();
      case 'hrms_departments':
        return const DepartmentsTeamsPage();
      case 'hrms_attendance':
        return const GeofenceAttendancePage();
      case 'hrms_travel':
        return const TravelMileagePage();
      case 'hrms_leave':
        return const LeavePenaltyPage();
      case 'hrms_payroll':
        return const PayrollSlipsPage();
      case 'hrms_notice_period':
        return const NoticePeriodPage();

      // 13. Marketplace
      case 'marketplace_digital':
        return const DigitalStorePage();
      case 'marketplace_decor':
        return const DecorAffiliatesPage();
      case 'marketplace_properties':
        return const PropertiesPage();
      case 'marketplace_materials':
        return const MaterialsPage();

      // 14. AI Studio
      case 'ai_room_designer':
        return const AiRoomGeneratorPage();
      case 'ai_vastu':
        return const AiVastuConsultantPage();
      case 'ai_budget':
        return const AiBudgetCalculatorPage();
      case 'ai_doubt_solver':
        return const AiDoubtSolverPage();
      case 'ai_designer_calls':
        return const AiDesignerVideoCallPage();

      // 15. Reports & Analytics
      case 'reports_executive':
        return const ReportsMarketingPage();
      case 'reports_sales':
        return const ReportsSalesPage();
      case 'reports_design':
        return const ReportsDesignPage();
      case 'reports_execution':
        return const ReportsExecutionPage();
      case 'reports_service':
        return const ReportsVendorRatingsPage();
      case 'reports_finance':
        return const ReportsFinancesPage();

      // 16. Organization
      case 'org_departments':
        return const OrgDepartmentsPage();
      case 'org_roles':
        return const OrgRoleLevelsPage();
      case 'org_access_scope':
        return const OrgAccessScopePage();

      // 17. Administration
      case 'admin_users_rbac':
        return const RbacMatrixPage();
      case 'admin_rate_masters':
        return const MasterRateCardsPage();
      case 'admin_ai_training':
        return const AiPromptTrainingPage();
      case 'admin_backup_recovery':
        return const DisasterBackupPage();

      default:
        return PanelPageTemplate.fromPath(path);
    }
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
              if (r.$1 == RouteNames.clientDesignerCall) {
                return const ClientDesignerConsultationPage();
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
