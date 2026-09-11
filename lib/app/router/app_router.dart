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
import '../../features/projects/index.dart';
import '../../features/designs/index.dart';
import '../../features/service_booking/index.dart';
import '../../features/shopping/index.dart';
import '../../features/communication/index.dart';
import '../../features/ai_suite/index.dart';
import '../../features/operations/index.dart';
import '../../features/accounting/index.dart';
import '../../features/hrms/index.dart';
import '../../features/marketplace/index.dart';
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
                  if (sub.routeName == RouteNames.reportsExecutive) {
                    return const ReportsExecutiveOverviewPage();
                  }
                  if (sub.routeName == RouteNames.reportsMarketing) {
                    return const ReportsMarketingPage();
                  }
                  if (sub.routeName == RouteNames.reportsSales) {
                    return const ReportsSalesPage();
                  }
                  if (sub.routeName == RouteNames.reportsDesign) {
                    return const ReportsDesignPage();
                  }
                  if (sub.routeName == RouteNames.reportsExecution || sub.routeName == RouteNames.reportsProjects) {
                    return const ReportsExecutionPage();
                  }
                  if (sub.routeName == RouteNames.reportsVendorRatings) {
                    return const ReportsVendorRatingsPage();
                  }
                  if (sub.routeName == RouteNames.reportsFinances || sub.routeName == RouteNames.reportsFinance) {
                    return const ReportsFinancesPage();
                  }
                  if (sub.routeName == RouteNames.reportsHr) {
                    return const ReportsHrPage();
                  }
                  if (sub.routeName == RouteNames.reportsService) {
                    return const ReportsServicePage();
                  }
                  if (sub.routeName == RouteNames.reportsFeedback) {
                    return const ReportsFeedbackPage();
                  }
                  if (sub.routeName == RouteNames.reportsGoals) {
                    return const ReportsGoalsPage();
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
                  if (sub.routeName == 'quotationsAll' ||
                      sub.routeName == 'quotations_all' ||
                      sub.routePath == RouteNames.quotationsAll ||
                      sub.routePath == '/quotations/all') {
                    return const QuotationAllPage();
                  }
                  if (sub.routeName == RouteNames.quoteBuilder ||
                      sub.routeName == 'quotations_create' ||
                      sub.routePath == RouteNames.quotationsCreate ||
                      sub.routePath == RouteNames.quoteBuilderPath ||
                      sub.routePath == '/quotations/create') {
                    return const QuotationBuilderPage();
                  }
                  if (sub.routeName == RouteNames.quoteItemMaster ||
                      sub.routeName == 'quotations_rate_master' ||
                      sub.routePath == RouteNames.quotationsRateMaster ||
                      sub.routePath == RouteNames.quoteItemMasterPath ||
                      sub.routePath == '/quotations/rate-master') {
                    return const QuotationItemMasterPage();
                  }
                  if (sub.routeName == RouteNames.quoteDocuments ||
                      sub.routeName == 'quotations_documents' ||
                      sub.routePath == RouteNames.quotationsDocuments ||
                      sub.routePath == RouteNames.quoteDocumentsPath ||
                      sub.routePath == '/quotations/documents') {
                    return const QuotationDocumentsPage();
                  }
                  if (sub.routeName == RouteNames.quoteUrgency ||
                      sub.routeName == 'quotations_expiry_reminders' ||
                      sub.routePath == RouteNames.quotationsExpiryReminders ||
                      sub.routePath == RouteNames.quoteUrgencyPath ||
                      sub.routePath == '/quotations/expiry-reminders') {
                    return const QuotationUrgencyPage();
                  }
                  if (sub.routeName == RouteNames.quoteSelfService ||
                      sub.routeName == 'quotations_self' ||
                      sub.routePath == RouteNames.quotationsSelf ||
                      sub.routePath == RouteNames.quoteSelfServicePath ||
                      sub.routePath == '/quotations/self-quotation') {
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
                  if (sub.routeName == RouteNames.damWorkspace ||
                      sub.routeName == RouteNames.designsWorkspace ||
                      sub.routePath == RouteNames.damWorkspacePath ||
                      sub.routePath == '/designs/workspace') {
                    return const DesignWorkspacePage();
                  }
                  if (sub.routeName == RouteNames.damFiles ||
                      sub.routeName == RouteNames.designsFiles ||
                      sub.routePath == RouteNames.damFilesPath ||
                      sub.routePath == '/designs/files') {
                    return const DesignFilesPage();
                  }
                  if (sub.routeName == RouteNames.damRevisions ||
                      sub.routeName == RouteNames.designsRevisions ||
                      sub.routePath == RouteNames.damRevisionsPath ||
                      sub.routePath == '/designs/revisions') {
                    return const DesignRevisionsPage();
                  }
                  if (sub.routeName == RouteNames.damApprovalLoop ||
                      sub.routeName == RouteNames.designsApprovals ||
                      sub.routePath == RouteNames.damApprovalLoopPath ||
                      sub.routePath == '/designs/approvals' ||
                      sub.routePath == '/designs/approval-loop') {
                    return const DesignApprovalLoopPage();
                  }
                  if (sub.routeName == RouteNames.damHandover ||
                      sub.routeName == RouteNames.designsHandover ||
                      sub.routePath == RouteNames.damHandoverPath ||
                      sub.routePath == '/designs/handover' ||
                      sub.routePath == '/designs/execution-handover') {
                    return const DesignHandoverPage();
                  }
                  if (sub.routeName == RouteNames.damCloudDrive ||
                      sub.routeName == RouteNames.designsDrive ||
                      sub.routePath == RouteNames.damCloudDrivePath ||
                      sub.routePath == '/designs/drive' ||
                      sub.routePath == '/designs/cloud-drive') {
                    return const DesignCloudDrivePage();
                  }

                  // Service Booking & Labour Submenus
                  if (sub.routeName == RouteNames.srvHireLabour ||
                      sub.routeName == 'labour_directory' ||
                      sub.routePath == '/service-labour/directory' ||
                      sub.routePath == RouteNames.srvHireLabourPath) {
                    return const LabourDirectoryPage();
                  }
                  if (sub.routeName == RouteNames.srvOnboardLabour ||
                      sub.routeName == 'labour_onboard' ||
                      sub.routePath == '/service-labour/onboard' ||
                      sub.routePath == RouteNames.srvOnboardLabourPath) {
                    return const OnboardLabourPage();
                  }
                  if (sub.routeName == RouteNames.srvLabourKyc ||
                      sub.routeName == 'labour_kyc' ||
                      sub.routePath == '/service-labour/kyc' ||
                      sub.routePath == RouteNames.srvLabourKycPath) {
                    return const LabourKycPage();
                  }
                  if (sub.routeName == 'labour_availability' ||
                      sub.routePath == '/service-labour/availability') {
                    return const LabourAvailabilityPage();
                  }
                  if (sub.routeName == RouteNames.srvActiveBookings ||
                      sub.routeName == 'labour_bookings' ||
                      sub.routePath == '/service-labour/bookings' ||
                      sub.routePath == RouteNames.srvActiveBookingsPath) {
                    return const ServiceBookingsPage();
                  }
                  if (sub.routeName == 'labour_active_jobs' ||
                      sub.routePath == '/service-labour/active-jobs') {
                    return const ActiveJobsPage();
                  }
                  if (sub.routeName == 'labour_payments' ||
                      sub.routePath == '/service-labour/payments') {
                    return const LabourWagePaymentsPage();
                  }
                  if (sub.routeName == 'labour_ratings' ||
                      sub.routePath == '/service-labour/ratings') {
                    return const LabourRatingsPage();
                  }
                  if (sub.routeName == RouteNames.srvLegalHub ||
                      sub.routeName == 'labour_disputes' ||
                      sub.routePath == '/service-labour/disputes' ||
                      sub.routePath == RouteNames.srvLegalHubPath) {
                    return const LegalDisputesPage();
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

                  // Marketplace Operations Submenus
                  if (sub.routeName == 'marketplace_digital' ||
                      sub.routePath == RouteNames.marketplaceDigital ||
                      sub.routePath == '/marketplace/digital-store') {
                    return const MarketplaceDigitalPage();
                  }
                  if (sub.routeName == 'marketplace_decor' ||
                      sub.routePath == RouteNames.marketplaceDecor ||
                      sub.routePath == '/marketplace/home-decor') {
                    return const MarketplaceDecorPage();
                  }
                  if (sub.routeName == 'marketplace_properties' ||
                      sub.routePath == RouteNames.marketplaceProperties ||
                      sub.routePath == '/marketplace/properties') {
                    return const MarketplacePropertiesPage();
                  }
                  if (sub.routeName == 'marketplace_materials' ||
                      sub.routePath == RouteNames.marketplaceMaterials ||
                      sub.routePath == '/marketplace/materials') {
                    return const MarketplaceMaterialsPage();
                  }
                  if (sub.routeName == 'marketplace_orders' ||
                      sub.routePath == RouteNames.marketplaceOrders ||
                      sub.routePath == '/marketplace/orders') {
                    return const MarketplaceOrdersPage();
                  }
                  if (sub.routeName == 'marketplace_management' ||
                      sub.routePath == RouteNames.marketplaceManagement ||
                      sub.routePath == '/marketplace/management') {
                    return const MarketplaceManagementPage();
                  }

                  // Communication Hub Submenus
                  if (sub.routeName == RouteNames.commChats) {
                    return const InboxChatsPage();
                  }
                  if (sub.routeName == RouteNames.commBroadcasts) {
                    return const BroadcastsPage();
                  }
                  if (sub.routeName == RouteNames.commBulkMessages) {
                    return const BulkMessagesPage();
                  }
                  if (sub.routeName == RouteNames.commScheduled) {
                    return const ScheduledMessagesPage();
                  }
                  if (sub.routeName == RouteNames.commTemplates) {
                    return const TemplatesPage();
                  }
                  if (sub.routeName == RouteNames.commDripCampaigns) {
                    return const DripCampaignsPage();
                  }
                  if (sub.routeName == RouteNames.commHistory ||
                      sub.routeName == RouteNames.commSiteProgress ||
                      sub.routeName == RouteNames.commBlueprints ||
                      sub.routeName == RouteNames.commMeetings) {
                    return const CommunicationHistoryPage();
                  }

                  // AI Architectural Suite / AI Studio Submenus
                  if (sub.routeName == 'ai_overview' ||
                      sub.routeName == RouteNames.aiStudioOverview ||
                      sub.routePath == RouteNames.aiStudioOverview ||
                      sub.routePath == '/ai-studio' ||
                      sub.routePath == '/ai-studio/overview') {
                    return const AiStudioOverviewPage();
                  }
                  if (sub.routeName == 'ai_room_designer' ||
                      sub.routeName == RouteNames.aiRoomGenerator ||
                      sub.routePath == RouteNames.aiRoomDesigner ||
                      sub.routePath == RouteNames.aiRoomGeneratorPath ||
                      sub.routePath == '/ai-studio/room-designer') {
                    return const AiRoomGeneratorPage();
                  }
                  if (sub.routeName == 'ai_vastu' ||
                      sub.routeName == RouteNames.aiVastuConsultant ||
                      sub.routePath == RouteNames.aiVastu ||
                      sub.routePath == RouteNames.aiVastuConsultantPath ||
                      sub.routePath == '/ai-studio/vastu') {
                    return const AiVastuConsultantPage();
                  }
                  if (sub.routeName == 'ai_budget' ||
                      sub.routeName == RouteNames.aiBudgetCalculator ||
                      sub.routePath == RouteNames.aiBudget ||
                      sub.routePath == RouteNames.aiBudgetCalculatorPath ||
                      sub.routePath == '/ai-studio/budget-calculator') {
                    return const AiBudgetCalculatorPage();
                  }
                  if (sub.routeName == 'ai_doubt_solver' ||
                      sub.routeName == RouteNames.aiDoubtSolver ||
                      sub.routePath == RouteNames.aiDoubtSolverPath ||
                      sub.routePath == '/ai-studio/doubt-solver') {
                    return const AiDoubtSolverPage();
                  }
                  if (sub.routeName == 'ai_designer_calls' ||
                      sub.routeName == RouteNames.aiDesignerVideoCall ||
                      sub.routePath == RouteNames.aiDesignerCalls ||
                      sub.routePath == RouteNames.aiDesignerVideoCallPath ||
                      sub.routePath == '/ai-studio/designer-calls') {
                    return const AiDesignerVideoCallPage();
                  }
                  if (sub.routeName == 'ai_wallet' ||
                      sub.routePath == RouteNames.aiWallet ||
                      sub.routePath == '/ai-studio/wallet') {
                    return const AiWalletCreditsPage();
                  }
                  if (sub.routeName == 'ai_usage_revenue' ||
                      sub.routePath == RouteNames.aiUsageRevenue ||
                      sub.routePath == '/ai-studio/usage-revenue') {
                    return const AiUsageRevenuePage();
                  }

                  // Operations & Procurement Submenus
                  if (sub.routeName == RouteNames.procurementMaterialRequests ||
                      sub.routeName == RouteNames.opsMaterialRfq) {
                    return const MaterialRequestsPage();
                  }
                  if (sub.routeName == RouteNames.procurementVendorRfqs) {
                    return const VendorRfqsPage();
                  }
                  if (sub.routeName == RouteNames.procurementVendorQuotations) {
                    return const VendorQuotationsPage();
                  }
                  if (sub.routeName == RouteNames.procurementPurchaseOrders) {
                    return const PurchaseOrdersPage();
                  }
                  if (sub.routeName == RouteNames.procurementDispatch) {
                    return const MaterialDispatchPage();
                  }
                  if (sub.routeName == RouteNames.procurementDesignPayments ||
                      sub.routeName == RouteNames.opsDesignPayment) {
                    return const DesignPaymentRequestsPage();
                  }
                  if (sub.routeName == RouteNames.procurementWeeklyFees ||
                      sub.routeName == RouteNames.opsSaturdayFees) {
                    return const WeeklySaturdayFeesPage();
                  }

                  // Accounting & Finance Submenus
                  if (sub.routeName == RouteNames.financeOverview) {
                    return const AccountingOverviewPage();
                  }
                  if (sub.routeName == RouteNames.financeCustomerLedgers ||
                      sub.routeName == RouteNames.accCustomerSummary) {
                    return const CustomerLedgersPage();
                  }
                  if (sub.routeName == RouteNames.financeInvoices) {
                    return const InvoicesPage();
                  }
                  if (sub.routeName == RouteNames.financePayments) {
                    return const PaymentsPage();
                  }
                  if (sub.routeName == RouteNames.financeExpenses ||
                      sub.routeName == RouteNames.accExpenseLedgers) {
                    return const ExpensesPage();
                  }
                  if (sub.routeName == RouteNames.financeVendorPayments) {
                    return const VendorPaymentsPage();
                  }
                  if (sub.routeName == RouteNames.financeLabourPayments) {
                    return const LabourPaymentsPage();
                  }
                  if (sub.routeName == RouteNames.financeCommissions) {
                    return const CommissionsPage();
                  }
                  if (sub.routeName == RouteNames.financeCollections ||
                      sub.routeName == RouteNames.accOverdueAlerts) {
                    return const OverdueCollectionsPage();
                  }

                  // HRMS & Field Operations Submenus
                  if (sub.routeName == RouteNames.hrOverview ||
                      sub.routePath == RouteNames.hrOverviewPath ||
                      sub.routePath == RouteNames.hrmsOverview) {
                    return const HrmsOverviewPage();
                  }
                  if (sub.routeName == RouteNames.hrEmployeeDirectory ||
                      sub.routePath == RouteNames.hrEmployeeDirectoryPath ||
                      sub.routePath == RouteNames.hrmsEmployees) {
                    return const HrmsEmployeesPage();
                  }
                  if (sub.routeName == RouteNames.hrDepartments ||
                      sub.routePath == RouteNames.hrDepartmentsPath ||
                      sub.routePath == RouteNames.hrmsDepartments) {
                    return const HrmsDepartmentsPage();
                  }
                  if (sub.routeName == RouteNames.hrGeofenceAttendance ||
                      sub.routePath == RouteNames.hrGeofenceAttendancePath ||
                      sub.routePath == RouteNames.hrmsAttendance) {
                    return const HrmsAttendancePage();
                  }
                  if (sub.routeName == RouteNames.hrTravelMileage ||
                      sub.routePath == RouteNames.hrTravelMileagePath ||
                      sub.routePath == RouteNames.hrmsTravel) {
                    return const HrmsTravelPage();
                  }
                  if (sub.routeName == RouteNames.hrLeavePenalty ||
                      sub.routePath == RouteNames.hrLeavePenaltyPath ||
                      sub.routePath == RouteNames.hrmsLeave) {
                    return const HrmsLeavePage();
                  }
                  if (sub.routeName == RouteNames.hrPerformance ||
                      sub.routePath == RouteNames.hrPerformancePath ||
                      sub.routePath == RouteNames.hrmsPerformance) {
                    return const HrmsPerformancePage();
                  }
                  if (sub.routeName == RouteNames.hrIncentives ||
                      sub.routePath == RouteNames.hrIncentivesPath ||
                      sub.routePath == RouteNames.hrmsIncentives) {
                    return const HrmsIncentivesPage();
                  }
                  if (sub.routeName == RouteNames.hrPayrollSlips ||
                      sub.routePath == RouteNames.hrPayrollSlipsPath ||
                      sub.routePath == RouteNames.hrmsPayroll) {
                    return const HrmsPayrollPage();
                  }
                  if (sub.routeName == RouteNames.hrNoticePeriod ||
                      sub.routePath == RouteNames.hrNoticePeriodPath ||
                      sub.routePath == RouteNames.hrmsNoticePeriod) {
                    return const HrmsNoticePage();
                  }

                  // After-Sales Service Submenus
                  if (sub.routeName == RouteNames.svcRequests ||
                      sub.routeName == RouteNames.afterSalesRequests ||
                      sub.routePath == '/after-sales/requests' ||
                      sub.routeName == 'after_sales_requests') {
                    return const ServiceRequestsPage();
                  }
                  if (sub.routeName == RouteNames.svcComplaints ||
                      sub.routeName == RouteNames.afterSalesComplaints ||
                      sub.routePath == '/after-sales/complaints' ||
                      sub.routeName == 'after_sales_complaints') {
                    return const ComplaintsSnagsPage();
                  }
                  if (sub.routeName == RouteNames.svcWarranty ||
                      sub.routeName == RouteNames.afterSalesWarranty ||
                      sub.routePath == '/after-sales/warranty' ||
                      sub.routeName == 'after_sales_warranty') {
                    return const WarrantyManagementPage();
                  }
                  if (sub.routeName == RouteNames.svcVisits ||
                      sub.routeName == RouteNames.afterSalesVisits ||
                      sub.routePath == '/after-sales/visits' ||
                      sub.routeName == 'after_sales_visits') {
                    return const ServiceVisitsPage();
                  }
                  if (sub.routeName == RouteNames.svcRetention ||
                      sub.routeName == RouteNames.afterSalesRetention ||
                      sub.routePath == '/after-sales/retention' ||
                      sub.routeName == 'after_sales_retention') {
                    return const RetentionFollowupsPage();
                  }
                  if (sub.routeName == RouteNames.svcFeedback ||
                      sub.routeName == RouteNames.afterSalesFeedback ||
                      sub.routePath == '/after-sales/feedback' ||
                      sub.routeName == 'after_sales_feedback') {
                    return const CustomerFeedbackPage();
                  }
                  if (sub.routeName == RouteNames.svcSnagsWarranty) {
                    return const SnagsWarrantyPage();
                  }
                  if (sub.routeName == RouteNames.svcRetentionCalls) {
                    return const RetentionCallsPage();
                  }

                  // HRMS & Field Ops Submenus
                  if (sub.routeName == RouteNames.hrOverview ||
                      sub.routePath == RouteNames.hrOverviewPath ||
                      sub.routePath == '/hrms/overview') {
                    return const HrmsOverviewPage();
                  }
                  if (sub.routeName == RouteNames.hrEmployeeDirectory ||
                      sub.routePath == RouteNames.hrEmployeeDirectoryPath ||
                      sub.routePath == '/hrms/employees') {
                    return const HrmsEmployeesPage();
                  }
                  if (sub.routeName == RouteNames.hrDepartments ||
                      sub.routePath == RouteNames.hrDepartmentsPath ||
                      sub.routePath == '/hrms/departments') {
                    return const HrmsDepartmentsPage();
                  }
                  if (sub.routeName == RouteNames.hrGeofenceAttendance ||
                      sub.routePath == RouteNames.hrGeofenceAttendancePath ||
                      sub.routePath == '/hrms/attendance') {
                    return const HrmsAttendancePage();
                  }
                  if (sub.routeName == RouteNames.hrTravelMileage ||
                      sub.routePath == RouteNames.hrTravelMileagePath ||
                      sub.routePath == '/hrms/travel') {
                    return const HrmsTravelPage();
                  }
                  if (sub.routeName == RouteNames.hrLeavePenalty ||
                      sub.routePath == RouteNames.hrLeavePenaltyPath ||
                      sub.routePath == '/hrms/leave') {
                    return const HrmsLeavePage();
                  }
                  if (sub.routeName == RouteNames.hrPerformance ||
                      sub.routePath == RouteNames.hrPerformancePath ||
                      sub.routePath == '/hrms/performance') {
                    return const HrmsPerformancePage();
                  }
                  if (sub.routeName == RouteNames.hrIncentives ||
                      sub.routePath == RouteNames.hrIncentivesPath ||
                      sub.routePath == '/hrms/incentives') {
                    return const HrmsIncentivesPage();
                  }
                  if (sub.routeName == RouteNames.hrPayrollSlips ||
                      sub.routePath == RouteNames.hrPayrollSlipsPath ||
                      sub.routePath == '/hrms/payroll') {
                    return const HrmsPayrollPage();
                  }
                  if (sub.routeName == RouteNames.hrNoticePeriod ||
                      sub.routePath == RouteNames.hrNoticePeriodPath ||
                      sub.routePath == '/hrms/notice-period') {
                    return const HrmsNoticePage();
                  }

                  // Organization & Roles Submenus
                  if (sub.routeName == RouteNames.orgDepartments ||
                      sub.routePath == RouteNames.orgDepartmentsPath) {
                    return const OrgDepartmentsPage();
                  }
                  if (sub.routeName == RouteNames.orgTeams ||
                      sub.routePath == RouteNames.orgTeamsPath) {
                    return const OrgTeamsPage();
                  }
                  if (sub.routeName == RouteNames.orgEmployees ||
                      sub.routePath == RouteNames.orgEmployeesPath) {
                    return const OrgEmployeesPage();
                  }
                  if (sub.routeName == RouteNames.orgRoles ||
                      sub.routePath == RouteNames.orgRolesPath ||
                      sub.routeName == RouteNames.orgRoleLevels ||
                      sub.routePath == RouteNames.orgRoleLevelsPath) {
                    return const OrgRolesPage();
                  }
                  if (sub.routeName == RouteNames.orgPermissions ||
                      sub.routePath == RouteNames.orgPermissionsPath) {
                    return const OrgPermissionsPage();
                  }
                  if (sub.routeName == RouteNames.orgAccessScope ||
                      sub.routePath == RouteNames.orgAccessScopePath) {
                    return const OrgAccessScopePage();
                  }

                  // Administration Submenus (Phase 1: Core Platform Configuration)
                  if (sub.routeName == RouteNames.adminUsersRbac || sub.routePath == RouteNames.adminUsersRbacPath) {
                    return const UsersRbacPage();
                  }
                  if (sub.routeName == RouteNames.adminMasterData || sub.routePath == RouteNames.adminMasterDataPath) {
                    return const MasterDataPage();
                  }
                  if (sub.routeName == RouteNames.adminRateMasters || sub.routePath == RouteNames.adminRateMastersPath) {
                    return const ItemRateMastersPage();
                  }
                  if (sub.routeName == RouteNames.adminMessageTemplates || sub.routePath == RouteNames.adminMessageTemplatesPath) {
                    return const MessageTemplatesPage();
                  }
                  if (sub.routeName == RouteNames.adminAiTraining || sub.routePath == RouteNames.adminAiTrainingPath) {
                    return const AiTrainingPage();
                  }
                  if (sub.routeName == RouteNames.adminIntegrations || sub.routePath == RouteNames.adminIntegrationsPath) {
                    return const IntegrationsPage();
                  }

                  // Administration Submenus (Phase 2: Operations & Platform Control)
                  if (sub.routeName == RouteNames.adminNotifications || sub.routePath == RouteNames.adminNotificationsPath) {
                    return const NotificationsPage();
                  }
                  if (sub.routeName == RouteNames.adminAutomations || sub.routePath == RouteNames.adminAutomationsPath) {
                    return const AutomationsPage();
                  }
                  if (sub.routeName == RouteNames.adminAuditLogs || sub.routePath == RouteNames.adminAuditLogsPath) {
                    return const AuditLogsPage();
                  }
                  if (sub.routeName == RouteNames.adminBackup || sub.routePath == RouteNames.adminBackupPath ||
                      sub.routeName == RouteNames.adminBackupRecovery || sub.routePath == RouteNames.adminBackupRecoveryPath) {
                    return const BackupRecoveryPage();
                  }
                  if (sub.routeName == RouteNames.adminSettings || sub.routePath == RouteNames.adminSettingsPath ||
                      sub.routeName == RouteNames.adminSystemSettings || sub.routePath == RouteNames.adminSystemSettingsPath) {
                    return const SystemSettingsPage();
                  }

                  // Legacy / Specialized Admin Submenus
                  if (sub.routeName == RouteNames.admRbacMatrix || sub.routePath == RouteNames.admRbacMatrixPath) {
                    return const RbacMatrixPage();
                  }
                  if (sub.routeName == RouteNames.admDisasterBackup || sub.routePath == RouteNames.admDisasterBackupPath) {
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
    // Designs & DAM fast path/id resolution
    if (id == 'designs_workspace' || id == 'damWorkspace' || id == 'dam_workspace' || path == '/designs/workspace') {
      return const DesignWorkspacePage();
    }
    if (id == 'designs_files' || id == 'damFiles' || id == 'dam_files' || path == '/designs/files' || path == '/documents') {
      return const DesignFilesPage();
    }
    if (id == 'designs_revisions' || id == 'damRevisions' || id == 'dam_revisions' || path == '/designs/revisions' || path == '/design-revisions') {
      return const DesignRevisionsPage();
    }
    if (id == 'designs_client_approvals' || id == 'designs_approvals' || id == 'damApprovalLoop' || id == 'dam_approval_loop' || path == '/designs/approvals' || path == '/designs/approval-loop') {
      return const DesignApprovalLoopPage();
    }
    if (id == 'designs_execution_handover' || id == 'designs_handover' || id == 'damHandover' || id == 'dam_handover' || path == '/designs/handover' || path == '/designs/execution-handover') {
      return const DesignHandoverPage();
    }
    if (id == 'designs_cloud_drive' || id == 'designs_drive' || id == 'damCloudDrive' || id == 'dam_cloud_drive' || path == '/designs/drive' || path == '/designs/cloud-drive') {
      return const DesignCloudDrivePage();
    }

    // Quotations fast path / ID resolution
    if (id == 'quotations_all' || id == 'quotationsAll' || path == '/quotations/all') {
      return const QuotationAllPage();
    }
    if (id == 'quotations_create' || id == 'quoteBuilder' || path == '/quotations/create' || path == '/quotation/builder') {
      return const QuotationBuilderPage();
    }
    if (id == 'quotations_rate_master' || id == 'quoteItemMaster' || path == '/quotations/rate-master' || path == '/quotation/item-master') {
      return const QuotationItemMasterPage();
    }
    if (id == 'quotations_documents' || id == 'quoteDocuments' || path == '/quotations/documents' || path == '/quotation/documents') {
      return const QuotationDocumentsPage();
    }
    if (id == 'quotations_expiry_reminders' || id == 'quoteUrgency' || path == '/quotations/expiry-reminders' || path == '/quotation/urgency') {
      return const QuotationUrgencyPage();
    }
    if (id == 'quotations_self' || id == 'quoteSelfService' || path == '/quotations/self-quotation' || path == '/quotation/self-service') {
      return const QuotationSelfServicePage();
    }

    // Marketplace Operations fast path / ID resolution
    if (id == 'marketplace_digital' || path == '/marketplace/digital-store' || path == '/digital-store') {
      return const MarketplaceDigitalPage();
    }
    if (id == 'marketplace_decor' || path == '/marketplace/home-decor' || path == '/decor-store') {
      return const MarketplaceDecorPage();
    }
    if (id == 'marketplace_properties' || path == '/marketplace/properties' || path == '/properties') {
      return const MarketplacePropertiesPage();
    }
    if (id == 'marketplace_materials' || path == '/marketplace/materials') {
      return const MarketplaceMaterialsPage();
    }
    if (id == 'marketplace_orders' || path == '/marketplace/orders') {
      return const MarketplaceOrdersPage();
    }
    if (id == 'marketplace_management' || path == '/marketplace/management') {
      return const MarketplaceManagementPage();
    }

    // AI Studio fast path / ID resolution
    if (id == 'ai_overview' || path == '/ai-studio' || path == '/ai-studio/overview') {
      return const AiStudioOverviewPage();
    }
    if (id == 'ai_room_designer' || path == '/ai-studio/room-designer' || path == '/ai-room-generator') {
      return const AiRoomGeneratorPage();
    }
    if (id == 'ai_vastu' || path == '/ai-studio/vastu' || path == '/ai-vastu') {
      return const AiVastuConsultantPage();
    }
    if (id == 'ai_budget' || path == '/ai-studio/budget-calculator' || path == '/ai-budget') {
      return const AiBudgetCalculatorPage();
    }
    if (id == 'ai_doubt_solver' || path == '/ai-studio/doubt-solver' || path == '/ai-doubt-solver') {
      return const AiDoubtSolverPage();
    }
    if (id == 'ai_designer_calls' || path == '/ai-studio/designer-calls' || path == '/designer-call') {
      return const AiDesignerVideoCallPage();
    }
    if (id == 'ai_wallet' || path == '/ai-studio/wallet') {
      return const AiWalletCreditsPage();
    }
    if (id == 'ai_usage_revenue' || path == '/ai-studio/usage-revenue') {
      return const AiUsageRevenuePage();
    }

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
      case '/projects/all':
        return const AllProjectsPage();
      case 'projects_overview':
      case '/projects/overview':
        return const ProjectOverviewPage();
      case 'projects_gantt':
      case '/projects/gantt':
        return const ProjectGanttPage();
      case 'projects_milestones':
      case '/projects/milestones':
        return const ProjectMilestonesPage();
      case 'projects_tasks':
      case '/projects/tasks':
        return const ProjectTasksPage();
      case 'projects_site_progress':
      case '/projects/site-progress':
        return const ProjectSiteProgressPage();
      case 'projects_site_visits':
      case '/projects/site-visits':
        return const ProjectSiteVisitsPage();
      case 'projects_approvals':
      case '/projects/approvals':
        return const ProjectApprovalsPage();
      case 'projects_snags':
      case '/projects/snags':
        return const ProjectComplaintsPage();
      case 'projects_commercials':
      case '/projects/commercials':
        return const ProjectCommercialsPage();

      // 5. Designs & DAM
      case 'designs_workspace':
      case 'damWorkspace':
      case 'dam_workspace':
      case '/designs/workspace':
        return const DesignWorkspacePage();
      case 'designs_files':
      case 'damFiles':
      case 'dam_files':
      case '/designs/files':
      case '/documents':
        return const DesignFilesPage();
      case 'designs_revisions':
      case 'damRevisions':
      case 'dam_revisions':
      case '/designs/revisions':
      case '/design-revisions':
        return const DesignRevisionsPage();
      case 'designs_client_approvals':
      case 'designs_approvals':
      case 'damApprovalLoop':
      case 'dam_approval_loop':
      case '/designs/approvals':
      case '/designs/approval-loop':
        return const DesignApprovalLoopPage();
      case 'designs_execution_handover':
      case 'designs_handover':
      case 'damHandover':
      case 'dam_handover':
      case '/designs/handover':
      case '/designs/execution-handover':
        return const DesignHandoverPage();
      case 'designs_cloud_drive':
      case 'designs_drive':
      case 'damCloudDrive':
      case 'dam_cloud_drive':
      case '/designs/drive':
      case '/designs/cloud-drive':
        return const DesignCloudDrivePage();

      // 6. Quotations
      case 'quotations_all':
      case '/quotations/all':
        return const QuotationAllPage();
      case 'quotations_create':
      case '/quotations/create':
      case 'quoteBuilder':
      case '/quotation/builder':
        return const QuotationBuilderPage();
      case 'quotations_rate_master':
      case '/quotations/rate-master':
      case 'quoteItemMaster':
      case '/quotation/item-master':
        return const QuotationItemMasterPage();
      case 'quotations_documents':
      case '/quotations/documents':
      case 'quoteDocuments':
      case '/quotation/documents':
        return const QuotationDocumentsPage();
      case 'quotations_expiry_reminders':
      case '/quotations/expiry-reminders':
      case 'quoteUrgency':
      case '/quotation/urgency':
        return const QuotationUrgencyPage();
      case 'quotations_self':
      case '/quotations/self-quotation':
      case 'quoteSelfService':
      case '/quotation/self-service':
        return const QuotationSelfServicePage();

      // 7. Procurement & Operations
      case 'procurement_material_requests':
      case 'procurementMaterialRequests':
      case '/procurement/material-requests':
      case 'opsMaterialRfq':
      case '/operations/material-rfq':
        return const MaterialRequestsPage();
      case 'procurement_vendor_rfqs':
      case 'procurementVendorRfqs':
      case '/procurement/vendor-rfqs':
        return const VendorRfqsPage();
      case 'procurement_vendor_quotations':
      case 'procurementVendorQuotations':
      case '/procurement/vendor-quotations':
        return const VendorQuotationsPage();
      case 'procurement_purchase_orders':
      case 'procurementPurchaseOrders':
      case '/procurement/purchase-orders':
        return const PurchaseOrdersPage();
      case 'procurement_dispatch':
      case 'procurementDispatch':
      case '/procurement/dispatch':
        return const MaterialDispatchPage();
      case 'procurement_design_payments':
      case 'procurementDesignPayments':
      case '/procurement/design-payments':
      case 'opsDesignPayment':
      case '/operations/design-payment':
        return const DesignPaymentRequestsPage();
      case 'procurement_weekly_fees':
      case 'procurementWeeklyFees':
      case '/procurement/weekly-fees':
      case 'opsSaturdayFees':
      case '/operations/saturday-fees':
        return const WeeklySaturdayFeesPage();

      // 8. Accounting & Finance
      case 'fin_overview':
      case 'finance_overview':
      case 'financeOverview':
      case '/finance/overview':
        return const AccountingOverviewPage();

      case 'fin_customer_ledgers':
      case 'finance_customer_ledgers':
      case 'financeCustomerLedgers':
      case '/finance/customer-ledgers':
      case 'acc_customer_summary':
      case 'accCustomerSummary':
      case '/accounting/customer-summary':
        return const CustomerLedgersPage();

      case 'fin_invoices':
      case 'finance_invoices':
      case 'financeInvoices':
      case '/finance/invoices':
        return const InvoicesPage();

      case 'fin_payments':
      case 'finance_payments':
      case 'financePayments':
      case '/finance/payments':
        return const PaymentsPage();

      case 'fin_expenses':
      case 'finance_expenses':
      case 'financeExpenses':
      case '/finance/expenses':
      case 'acc_expense_ledgers':
      case 'accExpenseLedgers':
      case '/accounting/expense-ledgers':
        return const ExpensesPage();

      case 'fin_vendor_payments':
      case 'finance_vendor_payments':
      case 'financeVendorPayments':
      case '/finance/vendor-payments':
        return const VendorPaymentsPage();

      case 'fin_labour_payments':
      case 'finance_labour_payments':
      case 'financeLabourPayments':
      case '/finance/labour-payments':
        return const LabourPaymentsPage();

      case 'fin_commissions':
      case 'finance_commissions':
      case 'financeCommissions':
      case '/finance/commissions':
        return const CommissionsPage();

      case 'fin_collections':
      case 'finance_collections':
      case 'financeCollections':
      case '/finance/collections':
      case 'acc_overdue_alerts':
      case 'accOverdueAlerts':
      case '/accounting/overdue-alerts':
        return const OverdueCollectionsPage();

      // 9. Communication
      case 'communication_inbox':
      case 'communication_chats':
      case '/communication/inbox':
      case '/communication/chats':
        return const InboxChatsPage();
      case 'communication_whatsapp':
      case '/communication/whatsapp':
        return const WhatsAppWorkspacePage();
      case 'communication_broadcasts':
      case '/communication/broadcasts':
        return const BroadcastsPage();
      case 'communication_bulk':
      case '/communication/bulk':
      case '/communication/bulk-messages':
        return const BulkMessagesPage();
      case 'communication_templates':
      case '/communication/templates':
        return const TemplatesPage();
      case 'communication_scheduled':
      case '/communication/scheduled':
        return const ScheduledMessagesPage();
      case 'communication_drip':
      case '/communication/drip':
      case '/communication/drip-campaigns':
        return const DripCampaignsPage();
      case 'communication_history':
      case '/communication/history':
        return const CommunicationHistoryPage();

      // 10. Service & Labour
      case 'labour_directory':
      case 'service_labour_directory':
      case '/service-labour/directory':
      case '/hire-labour':
        return const LabourDirectoryPage();

      case 'labour_onboard':
      case 'service_labour_onboard':
      case '/service-labour/onboard':
        return const OnboardLabourPage();

      case 'labour_kyc':
      case 'service_labour_kyc':
      case '/service-labour/kyc':
        return const LabourKycPage();

      case 'labour_availability':
      case 'service_labour_availability':
      case '/service-labour/availability':
        return const LabourAvailabilityPage();

      case 'labour_bookings':
      case 'service_labour_bookings':
      case '/service-labour/bookings':
        return const ServiceBookingsPage();

      case 'labour_active_jobs':
      case 'service_labour_active_jobs':
      case '/service-labour/active-jobs':
        return const ActiveJobsPage();

      case 'labour_payments':
      case 'service_labour_payments':
      case '/service-labour/payments':
        return const LabourWagePaymentsPage();

      case 'labour_ratings':
      case 'service_labour_ratings':
      case '/service-labour/ratings':
        return const LabourRatingsPage();

      case 'labour_disputes':
      case 'service_labour_disputes':
      case '/service-labour/disputes':
        return const LegalDisputesPage();

      // 11. After-Sales
      case 'after_sales_requests':
      case 'svcRequests':
      case '/after-sales/requests':
        return const ServiceRequestsPage();

      case 'after_sales_complaints':
      case 'svcComplaints':
      case '/after-sales/complaints':
        return const ComplaintsSnagsPage();

      case 'after_sales_warranty':
      case 'svcWarranty':
      case '/after-sales/warranty':
      case '/warranty':
        return const WarrantyManagementPage();

      case 'after_sales_visits':
      case 'svcVisits':
      case '/after-sales/visits':
        return const ServiceVisitsPage();

      case 'after_sales_retention':
      case 'svcRetention':
      case '/after-sales/retention':
        return const RetentionFollowupsPage();

      case 'after_sales_feedback':
      case 'svcFeedback':
      case '/after-sales/feedback':
        return const CustomerFeedbackPage();

      case 'svcSnagsWarranty':
      case '/after-sales/snags-warranty':
        return const SnagsWarrantyPage();

      case 'svcRetentionCalls':
      case '/after-sales/retention-calls':
        return const RetentionCallsPage();

      // 12. HRMS
      case 'hrOverview':
      case 'hrms_overview':
      case '/hrms/overview':
        return const HrmsOverviewPage();

      case 'hrEmployeeDirectory':
      case 'hrms_employees':
      case '/hrms/employee-directory':
      case '/hrms/employees':
        return const HrmsEmployeesPage();

      case 'hrDepartments':
      case 'hrms_departments':
      case '/hrms/departments':
        return const HrmsDepartmentsPage();

      case 'hrGeofenceAttendance':
      case 'hrms_attendance':
      case '/hrms/geofence-attendance':
      case '/hrms/attendance':
        return const HrmsAttendancePage();

      case 'hrTravelMileage':
      case 'hrms_travel':
      case '/hrms/travel-mileage':
      case '/hrms/travel':
        return const HrmsTravelPage();

      case 'hrLeavePenalty':
      case 'hrms_leave':
      case '/hrms/leave-penalty':
      case '/hrms/leave':
        return const HrmsLeavePage();

      case 'hrPerformance':
      case 'hrms_performance':
      case '/hrms/performance':
        return const HrmsPerformancePage();

      case 'hrIncentives':
      case 'hrms_incentives':
      case '/hrms/incentives':
        return const HrmsIncentivesPage();

      case 'hrPayrollSlips':
      case 'hrms_payroll':
      case '/hrms/payroll-slips':
      case '/hrms/payroll':
        return const HrmsPayrollPage();

      case 'hrNoticePeriod':
      case 'hrms_notice_period':
      case '/hrms/notice-period':
        return const HrmsNoticePage();

      // 13. Marketplace
      case 'marketplace_digital':
      case '/marketplace/digital-store':
      case '/digital-store':
        return const MarketplaceDigitalPage();

      case 'marketplace_decor':
      case '/marketplace/home-decor':
      case '/decor-store':
        return const MarketplaceDecorPage();

      case 'marketplace_properties':
      case '/marketplace/properties':
      case '/properties':
        return const MarketplacePropertiesPage();

      case 'marketplace_materials':
      case '/marketplace/materials':
        return const MarketplaceMaterialsPage();

      case 'marketplace_orders':
      case '/marketplace/orders':
        return const MarketplaceOrdersPage();

      case 'marketplace_management':
      case '/marketplace/management':
        return const MarketplaceManagementPage();

      // 14. AI Studio
      case 'ai_overview':
      case '/ai-studio':
      case '/ai-studio/overview':
        return const AiStudioOverviewPage();
      case 'ai_room_designer':
      case '/ai-studio/room-designer':
      case '/ai-room-generator':
        return const AiRoomGeneratorPage();
      case 'ai_vastu':
      case '/ai-studio/vastu':
      case '/ai-vastu':
        return const AiVastuConsultantPage();
      case 'ai_budget':
      case '/ai-studio/budget-calculator':
      case '/ai-budget':
        return const AiBudgetCalculatorPage();
      case 'ai_doubt_solver':
      case '/ai-studio/doubt-solver':
      case '/ai-doubt-solver':
        return const AiDoubtSolverPage();
      case 'ai_designer_calls':
      case '/ai-studio/designer-calls':
      case '/designer-call':
        return const AiDesignerVideoCallPage();
      case 'ai_wallet':
      case '/ai-studio/wallet':
        return const AiWalletCreditsPage();
      case 'ai_usage_revenue':
      case '/ai-studio/usage-revenue':
        return const AiUsageRevenuePage();

      // 15. Reports & Analytics
      case 'reports_executive':
      case '/reports/executive':
        return const ReportsExecutiveOverviewPage();
      case 'reports_marketing':
      case '/reports/marketing':
        return const ReportsMarketingPage();
      case 'reports_sales':
      case '/reports/sales':
        return const ReportsSalesPage();
      case 'reports_projects':
      case '/reports/projects':
      case 'reports_execution':
      case '/reports/execution':
        return const ReportsExecutionPage();
      case 'reports_design':
      case '/reports/design':
        return const ReportsDesignPage();
      case 'reports_finance':
      case '/reports/finance':
      case 'reports_finances':
      case '/reports/finances':
        return const ReportsFinancesPage();
      case 'reports_hr':
      case '/reports/hr':
        return const ReportsHrPage();
      case 'reports_service':
      case '/reports/service':
      case 'reports_service_labour':
      case '/reports/service-labour':
        return const ReportsServicePage();
      case 'reports_vendor_ratings':
      case '/reports/vendor-ratings':
        return const ReportsVendorRatingsPage();
      case 'reports_feedback':
      case '/reports/feedback':
      case 'reports_customer_feedback':
      case '/reports/customer-feedback':
        return const ReportsFeedbackPage();
      case 'reports_goals':
      case '/reports/goals':
      case 'reports_goals_productivity':
      case '/reports/goals-productivity':
        return const ReportsGoalsPage();


      // 16. Organization
      case 'org_departments':
      case 'orgDepartments':
      case '/organization/departments':
        return const OrgDepartmentsPage();
      case 'org_teams':
      case 'orgTeams':
      case '/organization/teams':
        return const OrgTeamsPage();
      case 'org_employees':
      case 'orgEmployees':
      case '/organization/employees':
        return const OrgEmployeesPage();
      case 'org_roles':
      case 'orgRoles':
      case '/organization/roles':
      case 'org_role_levels':
      case 'orgRoleLevels':
      case '/organization/role-levels':
        return const OrgRolesPage();
      case 'org_permissions':
      case 'orgPermissions':
      case '/organization/permissions':
        return const OrgPermissionsPage();
      case 'org_access_scope':
      case 'orgAccessScope':
      case '/organization/access-scope':
        return const OrgAccessScopePage();

      // 17. Administration (Phase 1 Workspaces)
      case 'admin_users_rbac':
      case 'adm_users_rbac':
      case 'adminUsersRbac':
      case '/admin/users-rbac':
        return const UsersRbacPage();

      case 'admin_master_data':
      case 'adm_master_data':
      case 'adminMasterData':
      case '/admin/master-data':
        return const MasterDataPage();

      case 'admin_rate_masters':
      case 'adm_rate_masters':
      case 'adminRateMasters':
      case '/admin/rate-masters':
        return const ItemRateMastersPage();

      case 'admin_message_templates':
      case 'adm_message_templates':
      case 'adminMessageTemplates':
      case '/admin/message-templates':
        return const MessageTemplatesPage();

      case 'admin_ai_training':
      case 'adm_ai_training':
      case 'adminAiTraining':
      case '/admin/ai-training':
        return const AiTrainingPage();

      case 'admin_integrations':
      case 'adm_integrations':
      case 'adminIntegrations':
      case '/admin/integrations':
        return const IntegrationsPage();

      case 'admin_notifications':
      case 'adm_notifications':
      case 'adminNotifications':
      case '/admin/notifications':
        return const NotificationsPage();

      case 'admin_automations':
      case 'adm_automations':
      case 'adminAutomations':
      case '/admin/automations':
        return const AutomationsPage();

      case 'admin_audit_logs':
      case 'adm_audit_logs':
      case 'adminAuditLogs':
      case '/admin/audit-logs':
        return const AuditLogsPage();

      case 'admin_backup':
      case 'adm_backup':
      case 'admin_backup_recovery':
      case 'adm_backup_recovery':
      case 'adminBackup':
      case 'adminBackupRecovery':
      case '/admin/backup-recovery':
        return const BackupRecoveryPage();

      case 'admin_settings':
      case 'adm_settings':
      case 'admin_system_settings':
      case 'adm_system_settings':
      case 'adminSettings':
      case 'adminSystemSettings':
      case '/admin/settings':
      case '/admin/system-settings':
        return const SystemSettingsPage();

      case 'adm_rbac_matrix':
      case '/admin/rbac-matrix':
        return const RbacMatrixPage();

      case 'adm_disaster_backup':
      case '/admin/disaster-backup':
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
