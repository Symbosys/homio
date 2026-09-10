/// Centralized route constants and paths for Homio CRM platform.
/// Each route defines a camelCase route name and a corresponding URL path.
abstract class RouteNames {
  // Public & Auth
  static const String landing = 'landing';
  static const String landingPath = '/';

  static const String login = 'login';
  static const String loginPath = '/login';

  // 1. Dashboard Submenu Routes
  static const String dashboard = '/dashboard';
  static const String dashboardMyTasks = '/dashboard/my-tasks';
  static const String dashboardOverview = 'dashboardOverview';
  static const String dashboardOverviewPath = '/dashboard/overview';

  static const String dashboardTasks = 'dashboardTasks';
  static const String dashboardTasksPath = '/dashboard/tasks';

  static const String dashboardAttendance = 'dashboardAttendance';
  static const String dashboardAttendancePath = '/dashboard/attendance';

  static const String dashboardTravel = 'dashboardTravel';
  static const String dashboardTravelPath = '/dashboard/travel';

  static const String dashboardWallet = 'dashboardWallet';
  static const String dashboardWalletPath = '/dashboard/wallet';

  // 2. Reports & Analytics Submenu Routes
  static const String reportsExecutive = '/reports/executive';
  static const String reportsMarketing = 'reportsMarketing';
  static const String reportsMarketingPath = '/reports/marketing';

  static const String reportsSales = 'reportsSales';
  static const String reportsSalesPath = '/reports/sales';

  static const String reportsDesign = 'reportsDesign';
  static const String reportsDesignPath = '/reports/design';

  static const String reportsExecution = 'reportsExecution';
  static const String reportsExecutionPath = '/reports/execution';

  static const String reportsVendorRatings = 'reportsVendorRatings';
  static const String reportsVendorRatingsPath = '/reports/vendor-ratings';

  static const String reportsFinances = 'reportsFinances';
  static const String reportsFinancesPath = '/reports/finances';

  static const String reportsHr = '/reports/hr';
  static const String reportsService = '/reports/service';
  static const String reportsFeedback = '/reports/feedback';
  static const String reportsGoals = '/reports/goals';

  // Marketing Submenu Routes
  static const String marketingOverview = 'marketingOverview';
  static const String marketingOverviewPath = '/marketing/overview';
  static const String marketingSources = 'marketingSources';
  static const String marketingSourcesPath = '/marketing/sources';
  static const String marketingLeadSourcesPath = '/marketing/lead-sources';
  static const String marketingCampaigns = 'marketingCampaigns';
  static const String marketingCampaignsPath = '/marketing/campaigns';
  static const String marketingSocial = 'marketingSocial';
  static const String marketingSocialPath = '/marketing/social';
  static const String marketingSocialAnalyticsPath = '/marketing/social-analytics';
  static const String marketingReports = 'marketingReports';
  static const String marketingReportsPath = '/marketing/reports';

  // 3. Sales & CRM Submenu Routes
  static const String crmOverview = '/crm/overview';
  static const String crmLeads = '/crm/leads';
  static const String crmCustomers = '/crm/customers';
  static const String crmFunnels = '/crm/funnels';
  static const String crmFollowups = '/crm/follow-ups';
  static const String crmCalls = '/crm/calls';
  static const String crmMeetings = '/crm/meetings';
  static const String crmTasks = '/crm/tasks';
  static const String crmAutomation = '/crm/automation';

  static const String salesOverview = 'salesOverview';
  static const String salesOverviewPath = '/sales/overview';

  static const String salesFunnels = 'salesFunnels';
  static const String salesFunnelsPath = '/sales/funnels';

  static const String salesDirectory = 'salesDirectory';
  static const String salesDirectoryPath = '/sales/directory';

  static const String salesWhatsappApi = 'salesWhatsappApi';
  static const String salesWhatsappApiPath = '/sales/whatsapp-api';

  static const String salesAiCalling = 'salesAiCalling';
  static const String salesAiCallingPath = '/sales/ai-calling';

  static const String salesCalendar = 'salesCalendar';
  static const String salesCalendarPath = '/sales/calendar';

  static const String salesTasks = 'salesTasks';
  static const String salesTasksPath = '/sales/tasks';

  // 4. Quotation & Estimation Submenu Routes
  static const String quotationsAll = '/quotations/all';
  static const String quotationsCreate = '/quotations/create';
  static const String quotationsRateMaster = '/quotations/rate-master';
  static const String quotationsDocuments = '/quotations/documents';
  static const String quotationsExpiryReminders = '/quotations/expiry-reminders';
  static const String quotationsSelf = '/quotations/self-quotation';

  static const String quoteBuilder = 'quoteBuilder';
  static const String quoteBuilderPath = '/quotation/builder';

  static const String quoteItemMaster = 'quoteItemMaster';
  static const String quoteItemMasterPath = '/quotation/item-master';

  static const String quoteDocuments = 'quoteDocuments';
  static const String quoteDocumentsPath = '/quotation/documents';

  static const String quoteUrgency = 'quoteUrgency';
  static const String quoteUrgencyPath = '/quotation/urgency';

  static const String quoteSelfService = 'quoteSelfService';
  static const String quoteSelfServicePath = '/quotation/self-service';

  // 5. Project Execution Submenu Routes
  static const String projectsAll = '/projects/all';
  static const String projectsOverview = '/projects/overview';
  static const String projectsGantt = '/projects/gantt';
  static const String projectsMilestones = '/projects/milestones';
  static const String projectsTasks = '/projects/tasks';
  static const String projectsSiteProgress = '/projects/site-progress';
  static const String projectsSiteVisits = '/projects/site-visits';
  static const String projectsApprovals = '/projects/approvals';
  static const String projectsSnags = '/projects/snags';
  static const String projectsCommercials = '/projects/commercials';

  static const String execProjects = 'execProjects';
  static const String execProjectsPath = '/execution/projects';

  static const String execGantt = 'execGantt';
  static const String execGanttPath = '/execution/gantt';

  static const String execSiteProgress = 'execSiteProgress';
  static const String execSiteProgressPath = '/execution/site-progress';

  static const String execComplaints = 'execComplaints';
  static const String execComplaintsPath = '/execution/complaints';

  static const String execWorkApprovals = 'execWorkApprovals';
  static const String execWorkApprovalsPath = '/execution/work-approvals';

  static const String execCommercials = 'execCommercials';
  static const String execCommercialsPath = '/execution/commercials';

  static const String execRatings = 'execRatings';
  static const String execRatingsPath = '/execution/ratings';

  static const String execSpreadsheet = 'execSpreadsheet';
  static const String execSpreadsheetPath = '/execution/spreadsheet';

  // 6. Designs & DAM Submenu Routes
  static const String designsWorkspace = '/designs/workspace';
  static const String designsFiles = '/designs/files';
  static const String designsRevisions = '/designs/revisions';
  static const String designsApprovals = '/designs/approvals';
  static const String designsHandover = '/designs/handover';
  static const String designsDrive = '/designs/drive';

  static const String damWorkspace = 'damWorkspace';
  static const String damWorkspacePath = '/designs/workspace';

  static const String damFiles = 'damFiles';
  static const String damFilesPath = '/designs/files';

  static const String damRevisions = 'damRevisions';
  static const String damRevisionsPath = '/designs/revisions';

  static const String damApprovalLoop = 'damApprovalLoop';
  static const String damApprovalLoopPath = '/designs/approval-loop';

  static const String damHandover = 'damHandover';
  static const String damHandoverPath = '/designs/handover';

  static const String damCloudDrive = 'damCloudDrive';
  static const String damCloudDrivePath = '/designs/cloud-drive';

  // 7. Service Booking & Labour Submenu Routes
  static const String labourDirectory = '/service-labour/directory';
  static const String labourOnboard = '/service-labour/onboard';
  static const String labourKyc = '/service-labour/kyc';
  static const String labourAvailability = '/service-labour/availability';
  static const String labourBookings = '/service-labour/bookings';
  static const String labourActiveJobs = '/service-labour/active-jobs';
  static const String labourPayments = '/service-labour/payments';
  static const String labourRatings = '/service-labour/ratings';
  static const String labourDisputes = '/service-labour/disputes';

  static const String srvHireLabour = 'srvHireLabour';
  static const String srvHireLabourPath = '/service-booking/hire-labour';

  static const String srvLabourKyc = 'srvLabourKyc';
  static const String srvLabourKycPath = '/service-booking/labour-kyc';

  static const String srvOnboardLabour = 'srvOnboardLabour';
  static const String srvOnboardLabourPath = '/service-booking/onboard-labour';

  static const String srvActiveBookings = 'srvActiveBookings';
  static const String srvActiveBookingsPath = '/service-booking/active-bookings';

  static const String srvLegalHub = 'srvLegalHub';
  static const String srvLegalHubPath = '/service-booking/legal-hub';

  // 8. Shopping & Marketplace Submenu Routes
  static const String marketplaceDigital = '/marketplace/digital-store';
  static const String marketplaceDecor = '/marketplace/home-decor';
  static const String marketplaceProperties = '/marketplace/properties';
  static const String marketplaceMaterials = '/marketplace/materials';
  static const String marketplaceOrders = '/marketplace/orders';
  static const String marketplaceManagement = '/marketplace/management';

  static const String shopDigitalStore = 'shopDigitalStore';
  static const String shopDigitalStorePath = '/shopping/digital-store';

  static const String shopDecorAffiliates = 'shopDecorAffiliates';
  static const String shopDecorAffiliatesPath = '/shopping/decor-affiliates';

  static const String shopProperties = 'shopProperties';
  static const String shopPropertiesPath = '/shopping/properties';

  static const String shopMaterials = 'shopMaterials';
  static const String shopMaterialsPath = '/shopping/materials';

  // 9. Communication Hub Submenu Routes
  static const String communicationInbox = '/communication/inbox';
  static const String communicationWhatsapp = '/communication/whatsapp';
  static const String communicationBroadcasts = '/communication/broadcasts';
  static const String communicationBulk = '/communication/bulk';
  static const String communicationTemplates = '/communication/templates';
  static const String communicationScheduled = '/communication/scheduled';
  static const String communicationDrip = '/communication/drip';
  static const String communicationHistory = '/communication/history';

  static const String commChats = 'commChats';
  static const String commChatsPath = '/communication/chats';

  static const String commBroadcasts = 'commBroadcasts';
  static const String commBroadcastsPath = '/communication/broadcasts';

  static const String commBulkMessages = 'commBulkMessages';
  static const String commBulkMessagesPath = '/communication/bulk-messages';

  static const String commTemplates = 'commTemplates';
  static const String commTemplatesPath = '/communication/templates';

  static const String commScheduled = 'commScheduled';
  static const String commScheduledPath = '/communication/scheduled';

  static const String commDripCampaigns = 'commDripCampaigns';
  static const String commDripCampaignsPath = '/communication/drip-campaigns';

  static const String commHistory = 'commHistory';
  static const String commHistoryPath = '/communication/history';

  static const String commSiteProgress = 'commSiteProgress';
  static const String commSiteProgressPath = '/communication/site-progress';

  static const String commBlueprints = 'commBlueprints';
  static const String commBlueprintsPath = '/communication/blueprints';

  static const String commMeetings = 'commMeetings';
  static const String commMeetingsPath = '/communication/meetings';

  // 10. AI Architectural Suite Submenu Routes
  static const String aiStudioOverview = '/ai-studio';
  static const String aiRoomDesigner = '/ai-studio/room-designer';
  static const String aiVastu = '/ai-studio/vastu';
  static const String aiBudget = '/ai-studio/budget-calculator';
  static const String aiDoubtSolver = 'aiDoubtSolver';
  static const String aiDoubtSolverPath = '/ai-suite/doubt-solver';
  static const String aiDesignerCalls = '/ai-studio/designer-calls';
  static const String aiWallet = '/ai-studio/wallet';
  static const String aiUsageRevenue = '/ai-studio/usage-revenue';

  static const String aiRoomGenerator = 'aiRoomGenerator';
  static const String aiRoomGeneratorPath = '/ai-suite/room-generator';

  static const String aiVastuConsultant = 'aiVastuConsultant';
  static const String aiVastuConsultantPath = '/ai-suite/vastu-consultant';

  static const String aiBudgetCalculator = 'aiBudgetCalculator';
  static const String aiBudgetCalculatorPath = '/ai-suite/budget-calculator';

  static const String aiDesignerVideoCall = 'aiDesignerVideoCall';
  static const String aiDesignerVideoCallPath = '/ai-suite/designer-video-call';

  // 11. Operations & Procurement Submenu Routes
  static const String procurementMaterialRequests = 'procurementMaterialRequests';
  static const String procurementMaterialRequestsPath = '/procurement/material-requests';

  static const String procurementVendorRfqs = 'procurementVendorRfqs';
  static const String procurementVendorRfqsPath = '/procurement/vendor-rfqs';

  static const String procurementVendorQuotations = 'procurementVendorQuotations';
  static const String procurementVendorQuotationsPath = '/procurement/vendor-quotations';

  static const String procurementPurchaseOrders = 'procurementPurchaseOrders';
  static const String procurementPurchaseOrdersPath = '/procurement/purchase-orders';

  static const String procurementDispatch = 'procurementDispatch';
  static const String procurementDispatchPath = '/procurement/dispatch';

  static const String procurementDesignPayments = 'procurementDesignPayments';
  static const String procurementDesignPaymentsPath = '/procurement/design-payments';

  static const String procurementWeeklyFees = 'procurementWeeklyFees';
  static const String procurementWeeklyFeesPath = '/procurement/weekly-fees';

  static const String opsMaterialRfq = 'opsMaterialRfq';
  static const String opsMaterialRfqPath = '/operations/material-rfq';

  static const String opsDesignPayment = 'opsDesignPayment';
  static const String opsDesignPaymentPath = '/operations/design-payment';

  static const String opsSaturdayFees = 'opsSaturdayFees';
  static const String opsSaturdayFeesPath = '/operations/saturday-fees';

  // 12. Accounting & Finance Submenu Routes
  static const String financeOverview = 'financeOverview';
  static const String financeOverviewPath = '/finance/overview';

  static const String financeCustomerLedgers = 'financeCustomerLedgers';
  static const String financeCustomerLedgersPath = '/finance/customer-ledgers';

  static const String financeInvoices = 'financeInvoices';
  static const String financeInvoicesPath = '/finance/invoices';

  static const String financePayments = 'financePayments';
  static const String financePaymentsPath = '/finance/payments';

  static const String financeExpenses = 'financeExpenses';
  static const String financeExpensesPath = '/finance/expenses';

  static const String financeVendorPayments = 'financeVendorPayments';
  static const String financeVendorPaymentsPath = '/finance/vendor-payments';

  static const String financeLabourPayments = 'financeLabourPayments';
  static const String financeLabourPaymentsPath = '/finance/labour-payments';

  static const String financeCommissions = 'financeCommissions';
  static const String financeCommissionsPath = '/finance/commissions';

  static const String financeCollections = 'financeCollections';
  static const String financeCollectionsPath = '/finance/collections';

  static const String accCustomerSummary = 'accCustomerSummary';
  static const String accCustomerSummaryPath = '/accounting/customer-summary';

  static const String accExpenseLedgers = 'accExpenseLedgers';
  static const String accExpenseLedgersPath = '/accounting/expense-ledgers';

  static const String accOverdueAlerts = 'accOverdueAlerts';
  static const String accOverdueAlertsPath = '/accounting/overdue-alerts';

  // 13. HRMS & Field Ops Submenu Routes
  static const String hrmsOverview = '/hrms/overview';
  static const String hrmsEmployees = '/hrms/employees';
  static const String hrmsDepartments = '/hrms/departments';
  static const String hrmsAttendance = '/hrms/attendance';
  static const String hrmsTravel = '/hrms/travel';
  static const String hrmsLeave = '/hrms/leave';
  static const String hrmsPerformance = '/hrms/performance';
  static const String hrmsPayroll = '/hrms/payroll';
  static const String hrmsIncentives = '/hrms/incentives';
  static const String hrmsNoticePeriod = '/hrms/notice-period';

  static const String hrOverview = 'hrOverview';
  static const String hrOverviewPath = '/hrms/overview';

  static const String hrEmployeeDirectory = 'hrEmployeeDirectory';
  static const String hrEmployeeDirectoryPath = '/hrms/employee-directory';

  static const String hrDepartments = 'hrDepartments';
  static const String hrDepartmentsPath = '/hrms/departments';

  static const String hrGeofenceAttendance = 'hrGeofenceAttendance';
  static const String hrGeofenceAttendancePath = '/hrms/geofence-attendance';

  static const String hrTravelMileage = 'hrTravelMileage';
  static const String hrTravelMileagePath = '/hrms/travel-mileage';

  static const String hrLeavePenalty = 'hrLeavePenalty';
  static const String hrLeavePenaltyPath = '/hrms/leave-penalty';

  static const String hrPerformance = 'hrPerformance';
  static const String hrPerformancePath = '/hrms/performance';

  static const String hrPayrollSlips = 'hrPayrollSlips';
  static const String hrPayrollSlipsPath = '/hrms/payroll-slips';

  static const String hrIncentives = 'hrIncentives';
  static const String hrIncentivesPath = '/hrms/incentives';

  static const String hrNoticePeriod = 'hrNoticePeriod';
  static const String hrNoticePeriodPath = '/hrms/notice-period';

  // 14. After-Sales Service Submenu Routes
  static const String afterSalesRequests = '/after-sales/requests';
  static const String afterSalesComplaints = '/after-sales/complaints';
  static const String afterSalesWarranty = '/after-sales/warranty';
  static const String afterSalesVisits = '/after-sales/visits';
  static const String afterSalesRetention = '/after-sales/retention';
  static const String afterSalesFeedback = '/after-sales/feedback';

  static const String svcRequests = 'svcRequests';
  static const String svcRequestsPath = '/after-sales/requests';

  static const String svcComplaints = 'svcComplaints';
  static const String svcComplaintsPath = '/after-sales/complaints';

  static const String svcWarranty = 'svcWarranty';
  static const String svcWarrantyPath = '/after-sales/warranty';

  static const String svcVisits = 'svcVisits';
  static const String svcVisitsPath = '/after-sales/visits';

  static const String svcRetention = 'svcRetention';
  static const String svcRetentionPath = '/after-sales/retention';

  static const String svcFeedback = 'svcFeedback';
  static const String svcFeedbackPath = '/after-sales/feedback';

  static const String svcSnagsWarranty = 'svcSnagsWarranty';
  static const String svcSnagsWarrantyPath = '/after-sales/snags-warranty';

  static const String svcRetentionCalls = 'svcRetentionCalls';
  static const String svcRetentionCallsPath = '/after-sales/retention-calls';

  // 15. Organization & Roles Submenu Routes
  static const String orgDepartments = 'orgDepartments';
  static const String orgDepartmentsPath = '/organization/departments';

  static const String orgTeams = '/organization/teams';
  static const String orgEmployees = '/organization/employees';
  static const String orgRoles = '/organization/roles';
  static const String orgPermissions = '/organization/permissions';

  static const String orgRoleLevels = 'orgRoleLevels';
  static const String orgRoleLevelsPath = '/organization/role-levels';

  static const String orgAccessScope = 'orgAccessScope';
  static const String orgAccessScopePath = '/organization/access-scope';

  // 16. System Administration Submenu Routes
  static const String adminUsersRbac = '/admin/users-rbac';
  static const String adminMasterData = '/admin/master-data';
  static const String adminRateMasters = '/admin/rate-masters';
  static const String adminTemplates = '/admin/message-templates';
  static const String adminIntegrations = '/admin/integrations';
  static const String adminNotifications = '/admin/notifications';
  static const String adminAutomations = '/admin/automations';
  static const String adminAuditLogs = '/admin/audit-logs';
  static const String adminBackup = '/admin/backup-recovery';
  static const String adminSettings = '/admin/settings';

  static const String admRbacMatrix = 'admRbacMatrix';
  static const String admRbacMatrixPath = '/admin/rbac-matrix';

  static const String admRateMasters = 'admRateMasters';
  static const String admRateMastersPath = '/admin/rate-masters';

  static const String admAiTraining = 'admAiTraining';
  static const String admAiTrainingPath = '/admin/ai-training';

  static const String admDisasterBackup = 'admDisasterBackup';
  static const String admDisasterBackupPath = '/admin/disaster-backup';

  // =========================================================================
  // CLIENT / CUSTOMER PORTAL DIRECT ROUTES (Single-level Flat Navigation)
  // =========================================================================
  // 1. Project Dashboard
  static const String clientOverview = 'clientOverview';
  static const String clientOverviewPath = '/client/overview';

  // 2. Assigned Team Dossier
  static const String clientTeam = 'clientTeam';
  static const String clientTeamPath = '/client/team';

  // 3. Live Site Progress (Photos, Videos & Milestones)
  static const String clientSiteProgress = 'clientSiteProgress';
  static const String clientSiteProgressPath = '/client/site-progress';

  // 4. Stage Work Approvals (Sign-Offs & Audit Logs)
  static const String clientApprovals = 'clientApprovals';
  static const String clientApprovalsPath = '/client/approvals';

  // 5. Designs & 3D Visualizer (Gallery, Revisions & Documents)
  static const String clientDesigns = 'clientDesigns';
  static const String clientDesignsPath = '/client/designs';

  // 6. Project Chat & Meetings (WhatsApp Thread & Scheduler)
  static const String clientChat = 'clientChat';
  static const String clientChatPath = '/client/chat';

  // 7. Billing & Invoices (Milestones, Cost Summary & Invoices)
  static const String clientPayments = 'clientPayments';
  static const String clientPaymentsPath = '/client/payments';

  // 8. Snags & Complaints Hub (Ticket Logging & Warranty)
  static const String clientComplaints = 'clientComplaints';
  static const String clientComplaintsPath = '/client/complaints';

  // 9. Feedback & 360° Ratings
  static const String clientRatings = 'clientRatings';
  static const String clientRatingsPath = '/client/ratings';

  // 10. Client AI Studio (Room Gen, Vastu, Calculator, Doubts & Calls)
  static const String clientAiSuite = 'clientAiSuite';
  static const String clientAiSuitePath = '/client/ai-suite';

  // 11. Marketplace & Services (Guides, Decor, Properties & Labour)
  static const String clientMarketplace = 'clientMarketplace';
  static const String clientMarketplacePath = '/client/marketplace';

  // Legacy/Alias paths for backward-compatibility
  static const String clientMilestones = 'clientMilestones';
  static const String clientMilestonesPath = '/client/milestones';
  static const String clientApprovalHistory = 'clientApprovalHistory';
  static const String clientApprovalHistoryPath = '/client/approval-history';
  static const String clientDesignRevisions = 'clientDesignRevisions';
  static const String clientDesignRevisionsPath = '/client/design-revisions';
  static const String clientDocuments = 'clientDocuments';
  static const String clientDocumentsPath = '/client/documents';
  static const String clientMeetings = 'clientMeetings';
  static const String clientMeetingsPath = '/client/meetings';
  static const String clientCostSummary = 'clientCostSummary';
  static const String clientCostSummaryPath = '/client/cost-summary';
  static const String clientInvoices = 'clientInvoices';
  static const String clientInvoicesPath = '/client/invoices';
  static const String clientWarranty = 'clientWarranty';
  static const String clientWarrantyPath = '/client/warranty';
  static const String clientAiRoomGen = 'clientAiRoomGen';
  static const String clientAiRoomGenPath = '/client/ai-room-generator';
  static const String clientAiVastu = 'clientAiVastu';
  static const String clientAiVastuPath = '/client/ai-vastu';
  static const String clientAiBudget = 'clientAiBudget';
  static const String clientAiBudgetPath = '/client/ai-budget';
  static const String clientAiDoubtSolver = 'clientAiDoubtSolver';
  static const String clientAiDoubtSolverPath = '/client/ai-doubt-solver';
  static const String clientDesignerCall = 'clientDesignerCall';
  static const String clientDesignerCallPath = '/client/designer-call';
  static const String clientDigitalStore = 'clientDigitalStore';
  static const String clientDigitalStorePath = '/client/digital-store';
  static const String clientDecorStore = 'clientDecorStore';
  static const String clientDecorStorePath = '/client/decor-store';
  static const String clientProperties = 'clientProperties';
  static const String clientPropertiesPath = '/client/properties';
  static const String clientHireLabour = 'clientHireLabour';
  static const String clientHireLabourPath = '/client/hire-labour';

  /// Legacy Route Map preserving old URLs and redirecting to canonical routes
  static const Map<String, String> legacyRouteAliases = {
    '/milestones': projectsMilestones,
    '/approval-history': projectsApprovals,
    '/design-revisions': designsRevisions,
    '/documents': designsFiles,
    '/meetings': crmMeetings,
    '/cost-summary': projectsCommercials,
    '/invoices': financeInvoices,
    '/warranty': afterSalesWarranty,
    '/ai-room-generator': aiRoomDesigner,
    '/ai-vastu': aiVastu,
    '/ai-budget': aiBudget,
    '/ai-doubt-solver': '/ai-studio/doubt-solver',
    '/designer-call': aiDesignerCalls,
    '/digital-store': marketplaceDigital,
    '/decor-store': marketplaceDecor,
    '/properties': marketplaceProperties,
    '/hire-labour': labourDirectory,
    '/marketing/lead-sources': marketingSourcesPath,
    '/marketing/social-analytics': marketingSocialPath,
  };

  /// Resolves legacy route aliases to the current canonical navigation route
  static String resolveCanonicalRoute(String currentPath) {
    if (legacyRouteAliases.containsKey(currentPath)) {
      return legacyRouteAliases[currentPath]!;
    }
    return currentPath;
  }
}
