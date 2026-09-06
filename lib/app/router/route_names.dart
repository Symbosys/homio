/// Centralized route constants and paths for Homio CRM platform.
/// Each route defines a camelCase route name and a corresponding URL path.
abstract class RouteNames {
  // Public & Auth
  static const String landing = 'landing';
  static const String landingPath = '/';

  static const String login = 'login';
  static const String loginPath = '/login';

  // 1. Dashboard Submenu Routes
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

  // 3. Sales & CRM Submenu Routes
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
  static const String damWorkspace = 'damWorkspace';
  static const String damWorkspacePath = '/designs/workspace';

  static const String damApprovalLoop = 'damApprovalLoop';
  static const String damApprovalLoopPath = '/designs/approval-loop';

  static const String damCloudDrive = 'damCloudDrive';
  static const String damCloudDrivePath = '/designs/cloud-drive';

  // 7. Service Booking & Labour Submenu Routes
  static const String srvHireLabour = 'srvHireLabour';
  static const String srvHireLabourPath = '/service-booking/hire-labour';

  static const String srvLabourKyc = 'srvLabourKyc';
  static const String srvLabourKycPath = '/service-booking/labour-kyc';

  static const String srvActiveBookings = 'srvActiveBookings';
  static const String srvActiveBookingsPath = '/service-booking/active-bookings';

  static const String srvLegalHub = 'srvLegalHub';
  static const String srvLegalHubPath = '/service-booking/legal-hub';

  // 8. Shopping & Marketplace Submenu Routes
  static const String shopDigitalStore = 'shopDigitalStore';
  static const String shopDigitalStorePath = '/shopping/digital-store';

  static const String shopDecorAffiliates = 'shopDecorAffiliates';
  static const String shopDecorAffiliatesPath = '/shopping/decor-affiliates';

  static const String shopProperties = 'shopProperties';
  static const String shopPropertiesPath = '/shopping/properties';

  // 9. Communication Hub Submenu Routes
  static const String commChats = 'commChats';
  static const String commChatsPath = '/communication/chats';

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
  static const String aiRoomGenerator = 'aiRoomGenerator';
  static const String aiRoomGeneratorPath = '/ai-suite/room-generator';

  static const String aiVastuConsultant = 'aiVastuConsultant';
  static const String aiVastuConsultantPath = '/ai-suite/vastu-consultant';

  static const String aiBudgetCalculator = 'aiBudgetCalculator';
  static const String aiBudgetCalculatorPath = '/ai-suite/budget-calculator';

  static const String aiDoubtSolver = 'aiDoubtSolver';
  static const String aiDoubtSolverPath = '/ai-suite/doubt-solver';

  static const String aiDesignerVideoCall = 'aiDesignerVideoCall';
  static const String aiDesignerVideoCallPath = '/ai-suite/designer-video-call';

  // 11. Operations & Procurement Submenu Routes
  static const String opsMaterialRfq = 'opsMaterialRfq';
  static const String opsMaterialRfqPath = '/operations/material-rfq';

  static const String opsDesignPayment = 'opsDesignPayment';
  static const String opsDesignPaymentPath = '/operations/design-payment';

  static const String opsSaturdayFees = 'opsSaturdayFees';
  static const String opsSaturdayFeesPath = '/operations/saturday-fees';

  // 12. Accounting & Finance Submenu Routes
  static const String accCustomerSummary = 'accCustomerSummary';
  static const String accCustomerSummaryPath = '/accounting/customer-summary';

  static const String accExpenseLedgers = 'accExpenseLedgers';
  static const String accExpenseLedgersPath = '/accounting/expense-ledgers';

  static const String accOverdueAlerts = 'accOverdueAlerts';
  static const String accOverdueAlertsPath = '/accounting/overdue-alerts';

  // 13. HRMS & Field Ops Submenu Routes
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

  static const String hrPayrollSlips = 'hrPayrollSlips';
  static const String hrPayrollSlipsPath = '/hrms/payroll-slips';

  static const String hrNoticePeriod = 'hrNoticePeriod';
  static const String hrNoticePeriodPath = '/hrms/notice-period';

  // 14. After-Sales Service Submenu Routes
  static const String svcSnagsWarranty = 'svcSnagsWarranty';
  static const String svcSnagsWarrantyPath = '/after-sales/snags-warranty';

  static const String svcRetentionCalls = 'svcRetentionCalls';
  static const String svcRetentionCallsPath = '/after-sales/retention-calls';

  // 15. Organization & Roles Submenu Routes
  static const String orgDepartments = 'orgDepartments';
  static const String orgDepartmentsPath = '/organization/departments';

  static const String orgRoleLevels = 'orgRoleLevels';
  static const String orgRoleLevelsPath = '/organization/role-levels';

  static const String orgAccessScope = 'orgAccessScope';
  static const String orgAccessScopePath = '/organization/access-scope';

  // 16. System Administration Submenu Routes
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
}
