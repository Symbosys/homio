import 'package:flutter/material.dart';
import '../router/route_names.dart';

/// Navigation Item Model representing a submenu route
class NavigationItem {
  final String id;
  final String label;
  final String route;
  final IconData icon;
  final String permission;
  final List<String> keywords;
  final List<String> legacyAliases;
  final String? badge;

  const NavigationItem({
    required this.id,
    required this.label,
    required this.route,
    required this.icon,
    required this.permission,
    this.keywords = const [],
    this.legacyAliases = const [],
    this.badge,
  });
}

/// Navigation Group Model representing a master parent accordion module
class NavigationGroup {
  final String id;
  final String label;
  final IconData icon;
  final String permission;
  final List<NavigationItem> children;

  const NavigationGroup({
    required this.id,
    required this.label,
    required this.icon,
    required this.permission,
    required this.children,
  });
}

/// Master Registry containing all 17 Master Admin Navigation Modules
class AdminNavigationConfig {
  static const List<NavigationGroup> masterGroups = [
    // 1. Dashboard
    NavigationGroup(
      id: 'dashboard',
      label: 'Dashboard',
      icon: Icons.dashboard_rounded,
      permission: 'dashboard.view',
      children: [
        NavigationItem(
          id: 'dashboard_overview',
          label: 'Overview',
          route: '/dashboard',
          icon: Icons.analytics_outlined,
          permission: 'dashboard.overview',
          keywords: ['kpi', 'home', 'summary', 'today'],
        ),
        NavigationItem(
          id: 'dashboard_my_tasks',
          label: 'My Tasks',
          route: '/dashboard/my-tasks',
          icon: Icons.task_alt_outlined,
          permission: 'dashboard.tasks',
          keywords: ['todo', 'pending', 'assigned', 'action'],
        ),
        NavigationItem(
          id: 'dashboard_attendance',
          label: 'Attendance',
          route: '/dashboard/attendance',
          icon: Icons.badge_outlined,
          permission: 'dashboard.attendance',
          keywords: ['checkin', 'punch', 'selfie', 'geofence'],
        ),
        NavigationItem(
          id: 'dashboard_travel',
          label: 'Travel',
          route: '/dashboard/travel',
          icon: Icons.commute_outlined,
          permission: 'dashboard.travel',
          keywords: ['field', 'visit', 'mileage', 'odometer'],
        ),
        NavigationItem(
          id: 'dashboard_wallet',
          label: 'Wallet / Incentives',
          route: '/dashboard/wallet',
          icon: Icons.account_balance_wallet_outlined,
          permission: 'dashboard.wallet',
          keywords: ['incentives', 'bonus', 'earnings', 'payout'],
        ),
      ],
    ),

    // 2. CRM & Sales
    NavigationGroup(
      id: 'crm',
      label: 'CRM & Sales',
      icon: Icons.people_alt_rounded,
      permission: 'crm.view',
      children: [
        NavigationItem(
          id: 'crm_overview',
          label: 'Overview',
          route: '/crm/overview',
          icon: Icons.insights_outlined,
          permission: 'crm.overview',
          keywords: ['funnel', 'pipeline', 'conversion', 'revenue'],
        ),
        NavigationItem(
          id: 'crm_leads',
          label: 'Leads',
          route: '/crm/leads',
          icon: Icons.person_search_outlined,
          permission: 'crm.leads',
          keywords: ['prospect', 'inquiry', 'assign', 'stage'],
        ),
        NavigationItem(
          id: 'crm_customers',
          label: 'Customers',
          route: '/crm/customers',
          icon: Icons.assignment_ind_outlined,
          permission: 'crm.customers',
          keywords: ['client', 'account', 'directory'],
        ),
        NavigationItem(
          id: 'crm_funnels',
          label: 'Lead Lists / Funnels',
          route: '/crm/funnels',
          icon: Icons.filter_alt_outlined,
          permission: 'crm.funnels',
          keywords: ['segment', 'list', 'stages', 'filters'],
        ),
        NavigationItem(
          id: 'crm_followups',
          label: 'Follow-ups',
          route: '/crm/follow-ups',
          icon: Icons.replay_circle_filled_outlined,
          permission: 'crm.followups',
          keywords: ['callback', 'remind', 'overdue'],
        ),
        NavigationItem(
          id: 'crm_calls',
          label: 'Calls',
          route: '/crm/calls',
          icon: Icons.phone_in_talk_outlined,
          permission: 'crm.calls',
          keywords: ['call log', 'telephony', 'recording'],
        ),
        NavigationItem(
          id: 'crm_meetings',
          label: 'Meetings / Calendar',
          route: '/crm/meetings',
          icon: Icons.calendar_month_outlined,
          permission: 'crm.meetings',
          legacyAliases: ['/meetings'],
          keywords: ['appointment', 'schedule', 'site visit meeting'],
        ),
        NavigationItem(
          id: 'crm_tasks',
          label: 'Tasks',
          route: '/crm/tasks',
          icon: Icons.checklist_rtl_outlined,
          permission: 'crm.tasks',
          keywords: ['sales task', 'todo'],
        ),
        NavigationItem(
          id: 'crm_automation',
          label: 'Sales Automation',
          route: '/crm/automation',
          icon: Icons.auto_mode_outlined,
          permission: 'crm.automation',
          keywords: ['workflow', 'rule', 'bot', 'trigger'],
        ),
      ],
    ),

    // 3. Marketing
    NavigationGroup(
      id: 'marketing',
      label: 'Marketing',
      icon: Icons.campaign_rounded,
      permission: 'marketing.view',
      children: [
        NavigationItem(
          id: 'marketing_overview',
          label: 'Overview',
          route: '/marketing/overview',
          icon: Icons.auto_graph_outlined,
          permission: 'marketing.overview',
          keywords: ['metrics', 'cpl', 'roi'],
        ),
        NavigationItem(
          id: 'marketing_sources',
          label: 'Lead Sources',
          route: '/marketing/sources',
          icon: Icons.alt_route_outlined,
          permission: 'marketing.sources',
          legacyAliases: ['/marketing/lead-sources'],
          keywords: ['attribution', 'channel', 'utm', 'google', 'meta'],
        ),
        NavigationItem(
          id: 'marketing_campaigns',
          label: 'Campaigns',
          route: '/marketing/campaigns',
          icon: Icons.ads_click_outlined,
          permission: 'marketing.campaigns',
          keywords: ['ad', 'promotion', 'budget', 'reach'],
        ),
        NavigationItem(
          id: 'marketing_social',
          label: 'Social Analytics',
          route: '/marketing/social',
          icon: Icons.share_outlined,
          permission: 'marketing.social',
          legacyAliases: ['/marketing/social-analytics'],
          keywords: ['instagram', 'youtube', 'pinterest', 'views', 'followers'],
        ),
        NavigationItem(
          id: 'marketing_reports',
          label: 'Marketing Reports',
          route: '/marketing/reports',
          icon: Icons.assessment_outlined,
          permission: 'marketing.reports',
          keywords: ['cac', 'growth', 'spend'],
        ),
      ],
    ),

    // 4. Projects
    NavigationGroup(
      id: 'projects',
      label: 'Projects',
      icon: Icons.apartment_rounded,
      permission: 'projects.view',
      children: [
        NavigationItem(
          id: 'projects_all',
          label: 'All Projects',
          route: '/projects/all',
          icon: Icons.folder_shared_outlined,
          permission: 'projects.all',
          keywords: ['active', 'completed', 'portfolio'],
        ),
        NavigationItem(
          id: 'projects_overview',
          label: 'Project Overview',
          route: '/projects/overview',
          icon: Icons.view_quilt_outlined,
          permission: 'projects.overview',
          keywords: ['summary', 'health', 'status'],
        ),
        NavigationItem(
          id: 'projects_gantt',
          label: 'Gantt / Timeline',
          route: '/projects/gantt',
          icon: Icons.waterfall_chart_outlined,
          permission: 'projects.gantt',
          keywords: ['gantt', 'schedule', 'chart', 'timeline'],
        ),
        NavigationItem(
          id: 'projects_milestones',
          label: 'Milestones',
          route: '/projects/milestones',
          icon: Icons.flag_outlined,
          permission: 'projects.milestones',
          legacyAliases: ['/milestones'],
          keywords: ['stages', 'phases', 'deliverables'],
        ),
        NavigationItem(
          id: 'projects_tasks',
          label: 'Tasks',
          route: '/projects/tasks',
          icon: Icons.task_outlined,
          permission: 'projects.tasks',
          keywords: ['execution task', 'subtask'],
        ),
        NavigationItem(
          id: 'projects_site_progress',
          label: 'Site Progress',
          route: '/projects/site-progress',
          icon: Icons.engineering_outlined,
          permission: 'projects.site_progress',
          keywords: ['construction', 'progress photos', 'daily log'],
        ),
        NavigationItem(
          id: 'projects_site_visits',
          label: 'Site Visits',
          route: '/projects/site-visits',
          icon: Icons.location_on_outlined,
          permission: 'projects.site_visits',
          keywords: ['field check', 'inspection', 'visit report'],
        ),
        NavigationItem(
          id: 'projects_approvals',
          label: 'Work Approvals',
          route: '/projects/approvals',
          icon: Icons.rule_folder_outlined,
          permission: 'projects.approvals',
          legacyAliases: ['/approval-history'],
          keywords: ['signoff', 'quality check', 'pass'],
        ),
        NavigationItem(
          id: 'projects_snags',
          label: 'Complaints / Snags',
          route: '/projects/snags',
          icon: Icons.report_problem_outlined,
          permission: 'projects.snags',
          keywords: ['issue', 'punch list', 'defect', 'snag'],
        ),
        NavigationItem(
          id: 'projects_commercials',
          label: 'Project Commercials',
          route: '/projects/commercials',
          icon: Icons.price_check_outlined,
          permission: 'projects.commercials',
          legacyAliases: ['/cost-summary'],
          keywords: ['budget', 'variance', 'margin', 'cost'],
        ),
      ],
    ),

    // 5. Designs & DAM
    NavigationGroup(
      id: 'designs_dam',
      label: 'Designs & DAM',
      icon: Icons.architecture_rounded,
      permission: 'designs.view',
      children: [
        NavigationItem(
          id: 'designs_workspace',
          label: 'Design Workspace',
          route: '/designs/workspace',
          icon: Icons.design_services_outlined,
          permission: 'designs.workspace',
          keywords: ['canvas', 'cad', '3d', 'render'],
        ),
        NavigationItem(
          id: 'designs_files',
          label: 'Files & Folders',
          route: '/designs/files',
          icon: Icons.snippet_folder_outlined,
          permission: 'designs.files',
          legacyAliases: ['/documents'],
          keywords: ['dam', 'blueprints', 'dwg', 'pdf', 'assets'],
        ),
        NavigationItem(
          id: 'designs_revisions',
          label: 'Revisions',
          route: '/designs/revisions',
          icon: Icons.history_edu_outlined,
          permission: 'designs.revisions',
          legacyAliases: ['/design-revisions'],
          keywords: ['v1', 'v2', 'markup', 'feedback'],
        ),
        NavigationItem(
          id: 'designs_client_approvals',
          label: 'Client Approvals',
          route: '/designs/approvals',
          icon: Icons.fact_check_outlined,
          permission: 'designs.approvals',
          keywords: ['client signoff', 'accepted design'],
        ),
        NavigationItem(
          id: 'designs_execution_handover',
          label: 'Execution Handover',
          route: '/designs/handover',
          icon: Icons.handshake_outlined,
          permission: 'designs.handover',
          keywords: ['site drawings', 'shop drawings', 'cutlist'],
        ),
        NavigationItem(
          id: 'designs_cloud_drive',
          label: 'Cloud Drive',
          route: '/designs/drive',
          icon: Icons.cloud_queue_outlined,
          permission: 'designs.drive',
          keywords: ['google drive', 'dropbox', 's3', 'storage'],
        ),
      ],
    ),

    // 6. Quotations
    NavigationGroup(
      id: 'quotations',
      label: 'Quotations',
      icon: Icons.request_quote_rounded,
      permission: 'quotations.view',
      children: [
        NavigationItem(
          id: 'quotations_all',
          label: 'All Quotations',
          route: '/quotations/all',
          icon: Icons.receipt_long_outlined,
          permission: 'quotations.all',
          keywords: ['estimates', 'proposals', 'bids'],
        ),
        NavigationItem(
          id: 'quotations_create',
          label: 'Create Quotation',
          route: '/quotations/create',
          icon: Icons.post_add_outlined,
          permission: 'quotations.create',
          keywords: ['new estimate', 'boq', 'builder'],
        ),
        NavigationItem(
          id: 'quotations_rate_master',
          label: 'Item / Rate Master',
          route: '/quotations/rate-master',
          icon: Icons.list_alt_outlined,
          permission: 'quotations.rates',
          keywords: ['item rate', 'sqft', 'specs', 'unit pricing'],
        ),
        NavigationItem(
          id: 'quotations_documents',
          label: 'Quotation Documents',
          route: '/quotations/documents',
          icon: Icons.picture_as_pdf_outlined,
          permission: 'quotations.documents',
          keywords: ['pdf preview', 'cover image', 'terms'],
        ),
        NavigationItem(
          id: 'quotations_expiry_reminders',
          label: 'Expiry / Reminders',
          route: '/quotations/expiry-reminders',
          icon: Icons.alarm_outlined,
          permission: 'quotations.expiry',
          keywords: ['validity', 'followup reminder', 'urgency'],
        ),
        NavigationItem(
          id: 'quotations_self',
          label: 'Self-Quotation',
          route: '/quotations/self-quotation',
          icon: Icons.calculate_outlined,
          permission: 'quotations.self',
          keywords: ['instant quote', 'customer calculator'],
        ),
      ],
    ),

    // 7. Procurement & Operations
    NavigationGroup(
      id: 'procurement',
      label: 'Procurement & Operations',
      icon: Icons.inventory_2_rounded,
      permission: 'procurement.view',
      children: [
        NavigationItem(
          id: 'procurement_material_requests',
          label: 'Material Requests',
          route: '/procurement/material-requests',
          icon: Icons.assignment_outlined,
          permission: 'procurement.requests',
          keywords: ['indent', 'site demand', 'raw material'],
        ),
        NavigationItem(
          id: 'procurement_vendor_rfqs',
          label: 'Vendor RFQs',
          route: '/procurement/vendor-rfqs',
          icon: Icons.forward_to_inbox_outlined,
          permission: 'procurement.rfqs',
          keywords: ['request for quote', 'vendor inquiry'],
        ),
        NavigationItem(
          id: 'procurement_vendor_quotations',
          label: 'Vendor Quotations',
          route: '/procurement/vendor-quotations',
          icon: Icons.compare_arrows_outlined,
          permission: 'procurement.quotations',
          keywords: ['vendor bids', 'comparison', 'rate comparison'],
        ),
        NavigationItem(
          id: 'procurement_purchase_orders',
          label: 'Purchase Orders',
          route: '/procurement/purchase-orders',
          icon: Icons.shopping_cart_checkout_outlined,
          permission: 'procurement.pos',
          keywords: ['po', 'order issue', 'vendor order'],
        ),
        NavigationItem(
          id: 'procurement_dispatch',
          label: 'Material Dispatch',
          route: '/procurement/dispatch',
          icon: Icons.local_shipping_outlined,
          permission: 'procurement.dispatch',
          keywords: ['delivery', 'grn', 'tracking', 'transit'],
        ),
        NavigationItem(
          id: 'procurement_design_payments',
          label: 'Design Payment Requests',
          route: '/procurement/design-payments',
          icon: Icons.payments_outlined,
          permission: 'procurement.design_payments',
          keywords: ['designer payout', 'drafting fee'],
        ),
        NavigationItem(
          id: 'procurement_weekly_fees',
          label: 'Weekly / Saturday Fees',
          route: '/procurement/weekly-fees',
          icon: Icons.event_repeat_outlined,
          permission: 'procurement.weekly_fees',
          keywords: ['weekly payouts', 'reimbursements'],
        ),
      ],
    ),

    // 8. Accounting & Finance
    NavigationGroup(
      id: 'accounting',
      label: 'Accounting & Finance',
      icon: Icons.account_balance_rounded,
      permission: 'finance.view',
      children: [
        NavigationItem(
          id: 'finance_overview',
          label: 'Overview',
          route: '/finance/overview',
          icon: Icons.account_balance_outlined,
          permission: 'finance.overview',
          keywords: ['cash flow', 'pl', 'p&l', 'balance'],
        ),
        NavigationItem(
          id: 'finance_customer_ledgers',
          label: 'Customer Ledgers',
          route: '/finance/customer-ledgers',
          icon: Icons.menu_book_outlined,
          permission: 'finance.ledgers',
          keywords: ['client ledger', 'statement', 'balance sheet'],
        ),
        NavigationItem(
          id: 'finance_invoices',
          label: 'Invoices',
          route: '/finance/invoices',
          icon: Icons.receipt_outlined,
          permission: 'finance.invoices',
          legacyAliases: ['/invoices'],
          keywords: ['tax invoice', 'gst', 'billing'],
        ),
        NavigationItem(
          id: 'finance_payments',
          label: 'Payments',
          route: '/finance/payments',
          icon: Icons.paid_outlined,
          permission: 'finance.payments',
          keywords: ['received', 'bank transfer', 'cheque', 'upi'],
        ),
        NavigationItem(
          id: 'finance_expenses',
          label: 'Expenses',
          route: '/finance/expenses',
          icon: Icons.money_off_outlined,
          permission: 'finance.expenses',
          keywords: ['petty cash', 'operational expense'],
        ),
        NavigationItem(
          id: 'finance_vendor_payments',
          label: 'Vendor Payments',
          route: '/finance/vendor-payments',
          icon: Icons.storefront_outlined,
          permission: 'finance.vendor_payments',
          keywords: ['supplier payment', 'bill settle'],
        ),
        NavigationItem(
          id: 'finance_labour_payments',
          label: 'Labour Payments',
          route: '/finance/labour-payments',
          icon: Icons.handyman_outlined,
          permission: 'finance.labour_payments',
          keywords: ['contractor payout', 'wage'],
        ),
        NavigationItem(
          id: 'finance_commissions',
          label: 'Commissions',
          route: '/finance/commissions',
          icon: Icons.monetization_on_outlined,
          permission: 'finance.commissions',
          keywords: ['referral', 'sales commission'],
        ),
        NavigationItem(
          id: 'finance_collections',
          label: 'Overdue / Collections',
          route: '/finance/collections',
          icon: Icons.warning_amber_outlined,
          permission: 'finance.collections',
          keywords: ['overdue', 'aging', 'recovery', 'collection'],
        ),
      ],
    ),

    // 9. Communication
    NavigationGroup(
      id: 'communication',
      label: 'Communication',
      icon: Icons.chat_bubble_outline_rounded,
      permission: 'communication.view',
      children: [
        NavigationItem(
          id: 'communication_inbox',
          label: 'Inbox / Chats',
          route: '/communication/inbox',
          icon: Icons.inbox_outlined,
          permission: 'communication.inbox',
          keywords: ['chat', 'customer messages', 'conversations'],
        ),
        NavigationItem(
          id: 'communication_whatsapp',
          label: 'WhatsApp',
          route: '/communication/whatsapp',
          icon: Icons.chat_outlined,
          permission: 'communication.whatsapp',
          keywords: ['whatsapp', 'wa', 'meta api', 'chat api'],
        ),
        NavigationItem(
          id: 'communication_broadcasts',
          label: 'Broadcasts',
          route: '/communication/broadcasts',
          icon: Icons.podcasts_outlined,
          permission: 'communication.broadcasts',
          keywords: ['mass message', 'announcements'],
        ),
        NavigationItem(
          id: 'communication_bulk',
          label: 'Bulk Messages',
          route: '/communication/bulk',
          icon: Icons.mark_email_read_outlined,
          permission: 'communication.bulk',
          keywords: ['sms bulk', 'bulk whatsapp'],
        ),
        NavigationItem(
          id: 'communication_templates',
          label: 'Templates',
          route: '/communication/templates',
          icon: Icons.dynamic_form_outlined,
          permission: 'communication.templates',
          keywords: ['message template', 'approved templates'],
        ),
        NavigationItem(
          id: 'communication_scheduled',
          label: 'Scheduled Messages',
          route: '/communication/scheduled',
          icon: Icons.schedule_send_outlined,
          permission: 'communication.scheduled',
          keywords: ['timer', 'scheduled sms'],
        ),
        NavigationItem(
          id: 'communication_drip',
          label: 'Drip Campaigns',
          route: '/communication/drip',
          icon: Icons.water_drop_outlined,
          permission: 'communication.drip',
          keywords: ['auto nurture', 'followup sequence'],
        ),
        NavigationItem(
          id: 'communication_history',
          label: 'Communication History',
          route: '/communication/history',
          icon: Icons.history_outlined,
          permission: 'communication.history',
          keywords: ['audit trail', 'all logs', 'lead to project history'],
        ),
      ],
    ),

    // 10. Service & Labour
    NavigationGroup(
      id: 'service_labour',
      label: 'Service & Labour',
      icon: Icons.handyman_rounded,
      permission: 'labour.view',
      children: [
        NavigationItem(
          id: 'labour_directory',
          label: 'Labour Directory',
          route: '/service-labour/directory',
          icon: Icons.badge_outlined,
          permission: 'labour.directory',
          legacyAliases: ['/hire-labour'],
          keywords: ['contractor', 'carpenter', 'electrician', 'plumber'],
        ),
        NavigationItem(
          id: 'labour_onboard',
          label: 'Onboard Labour',
          route: '/service-labour/onboard',
          icon: Icons.person_add_alt_outlined,
          permission: 'labour.onboard',
          keywords: ['registration', 'new worker'],
        ),
        NavigationItem(
          id: 'labour_kyc',
          label: 'KYC / Verification',
          route: '/service-labour/kyc',
          icon: Icons.verified_user_outlined,
          permission: 'labour.kyc',
          keywords: ['aadhaar', 'id check', 'police verification'],
        ),
        NavigationItem(
          id: 'labour_availability',
          label: 'Availability',
          route: '/service-labour/availability',
          icon: Icons.event_available_outlined,
          permission: 'labour.availability',
          keywords: ['calendar', 'shifts', 'free status'],
        ),
        NavigationItem(
          id: 'labour_bookings',
          label: 'Service Bookings',
          route: '/service-labour/bookings',
          icon: Icons.book_online_outlined,
          permission: 'labour.bookings',
          keywords: ['on demand', 'hourly service'],
        ),
        NavigationItem(
          id: 'labour_active_jobs',
          label: 'Active Jobs',
          route: '/service-labour/active-jobs',
          icon: Icons.construction_outlined,
          permission: 'labour.active_jobs',
          keywords: ['ongoing job', 'site allocation'],
        ),
        NavigationItem(
          id: 'labour_payments',
          label: 'Labour Payments',
          route: '/service-labour/payments',
          icon: Icons.payments_outlined,
          permission: 'labour.payments',
          keywords: ['daily wages', 'contract payout'],
        ),
        NavigationItem(
          id: 'labour_ratings',
          label: 'Ratings',
          route: '/service-labour/ratings',
          icon: Icons.star_outline_rounded,
          permission: 'labour.ratings',
          keywords: ['reviews', 'skill score'],
        ),
        NavigationItem(
          id: 'labour_disputes',
          label: 'Legal / Disputes',
          route: '/service-labour/disputes',
          icon: Icons.gavel_outlined,
          permission: 'labour.disputes',
          keywords: ['blacklist', 'warning', 'complaint'],
        ),
      ],
    ),

    // 11. After-Sales
    NavigationGroup(
      id: 'after_sales',
      label: 'After-Sales',
      icon: Icons.support_agent_rounded,
      permission: 'after_sales.view',
      children: [
        NavigationItem(
          id: 'after_sales_requests',
          label: 'Service Requests',
          route: '/after-sales/requests',
          icon: Icons.contact_support_outlined,
          permission: 'after_sales.requests',
          keywords: ['ticket', 'support', 'handover support'],
        ),
        NavigationItem(
          id: 'after_sales_complaints',
          label: 'Complaints / Snags',
          route: '/after-sales/complaints',
          icon: Icons.feedback_outlined,
          permission: 'after_sales.complaints',
          keywords: ['post completion snag', 'defect'],
        ),
        NavigationItem(
          id: 'after_sales_warranty',
          label: 'Warranty',
          route: '/after-sales/warranty',
          icon: Icons.security_outlined,
          permission: 'after_sales.warranty',
          legacyAliases: ['/warranty'],
          keywords: ['guarantee', 'amc', 'period'],
        ),
        NavigationItem(
          id: 'after_sales_visits',
          label: 'Service Visits',
          route: '/after-sales/visits',
          icon: Icons.car_repair_outlined,
          permission: 'after_sales.visits',
          keywords: ['technician visit', 'repair'],
        ),
        NavigationItem(
          id: 'after_sales_retention',
          label: 'Retention / Follow-ups',
          route: '/after-sales/retention',
          icon: Icons.loyalty_outlined,
          permission: 'after_sales.retention',
          keywords: ['amc renewal', 'repeat business'],
        ),
        NavigationItem(
          id: 'after_sales_feedback',
          label: 'Customer Feedback',
          route: '/after-sales/feedback',
          icon: Icons.sentiment_satisfied_alt_outlined,
          permission: 'after_sales.feedback',
          keywords: ['nps', 'csat', 'testimonials'],
        ),
      ],
    ),

    // 12. HRMS
    NavigationGroup(
      id: 'hrms',
      label: 'HRMS',
      icon: Icons.badge_rounded,
      permission: 'hrms.view',
      children: [
        NavigationItem(
          id: 'hrms_employees',
          label: 'Employee Directory',
          route: '/hrms/employees',
          icon: Icons.people_outline_rounded,
          permission: 'hrms.employees',
          keywords: ['staff', 'workforce', 'contacts'],
        ),
        NavigationItem(
          id: 'hrms_departments',
          label: 'Departments',
          route: '/hrms/departments',
          icon: Icons.domain_outlined,
          permission: 'hrms.departments',
          keywords: ['division', 'units'],
        ),
        NavigationItem(
          id: 'hrms_attendance',
          label: 'Attendance',
          route: '/hrms/attendance',
          icon: Icons.calendar_today_outlined,
          permission: 'hrms.attendance',
          keywords: ['biometric', 'geofence', 'timesheet'],
        ),
        NavigationItem(
          id: 'hrms_travel',
          label: 'Field Travel',
          route: '/hrms/travel',
          icon: Icons.map_outlined,
          permission: 'hrms.travel',
          keywords: ['mileage approval', 'field tracking', 'gps'],
        ),
        NavigationItem(
          id: 'hrms_leave',
          label: 'Leave',
          route: '/hrms/leave',
          icon: Icons.beach_access_outlined,
          permission: 'hrms.leave',
          keywords: ['vacation', 'sick leave', 'approval'],
        ),
        NavigationItem(
          id: 'hrms_performance',
          label: 'Performance',
          route: '/hrms/performance',
          icon: Icons.speed_outlined,
          permission: 'hrms.performance',
          keywords: ['kpi', 'appraisal', 'review'],
        ),
        NavigationItem(
          id: 'hrms_payroll',
          label: 'Payroll',
          route: '/hrms/payroll',
          icon: Icons.receipt_long_outlined,
          permission: 'hrms.payroll',
          keywords: ['salary', 'payslip', 'wages'],
        ),
        NavigationItem(
          id: 'hrms_incentives',
          label: 'Incentives',
          route: '/hrms/incentives',
          icon: Icons.card_giftcard_outlined,
          permission: 'hrms.incentives',
          keywords: ['bonus', 'commissions', 'reward'],
        ),
        NavigationItem(
          id: 'hrms_notice_period',
          label: 'Notice Period',
          route: '/hrms/notice-period',
          icon: Icons.door_front_door_outlined,
          permission: 'hrms.notice_period',
          keywords: ['exit', 'resignation', 'handover'],
        ),
      ],
    ),

    // 13. Marketplace
    NavigationGroup(
      id: 'marketplace',
      label: 'Marketplace',
      icon: Icons.store_mall_directory_rounded,
      permission: 'marketplace.view',
      children: [
        NavigationItem(
          id: 'marketplace_digital',
          label: 'Digital Store',
          route: '/marketplace/digital-store',
          icon: Icons.cloud_download_outlined,
          permission: 'marketplace.digital',
          legacyAliases: ['/digital-store'],
          keywords: ['3d models', 'templates', 'plans'],
        ),
        NavigationItem(
          id: 'marketplace_decor',
          label: 'Home Decor',
          route: '/marketplace/home-decor',
          icon: Icons.chair_outlined,
          permission: 'marketplace.decor',
          legacyAliases: ['/decor-store'],
          keywords: ['furniture', 'lighting', 'accessories'],
        ),
        NavigationItem(
          id: 'marketplace_properties',
          label: 'Properties',
          route: '/marketplace/properties',
          icon: Icons.villa_outlined,
          permission: 'marketplace.properties',
          legacyAliases: ['/properties'],
          keywords: ['real estate', 'projects', 'villas', 'flats'],
        ),
        NavigationItem(
          id: 'marketplace_materials',
          label: 'Materials',
          route: '/marketplace/materials',
          icon: Icons.texture_outlined,
          permission: 'marketplace.materials',
          keywords: ['plywood', 'laminates', 'hardware', 'tile'],
        ),
        NavigationItem(
          id: 'marketplace_orders',
          label: 'Orders',
          route: '/marketplace/orders',
          icon: Icons.shopping_bag_outlined,
          permission: 'marketplace.orders',
          keywords: ['ecommerce orders', 'fulfillment'],
        ),
        NavigationItem(
          id: 'marketplace_management',
          label: 'Marketplace Management',
          route: '/marketplace/management',
          icon: Icons.tune_outlined,
          permission: 'marketplace.management',
          keywords: ['vendors', 'catalog admin', 'commissions'],
        ),
      ],
    ),

    // 14. AI Studio
    NavigationGroup(
      id: 'ai_studio',
      label: 'AI Studio',
      icon: Icons.auto_awesome_rounded,
      permission: 'ai_studio.view',
      children: [
        NavigationItem(
          id: 'ai_overview',
          label: 'Overview',
          route: '/ai-studio',
          icon: Icons.dashboard_customize_outlined,
          permission: 'ai_studio.view',
          legacyAliases: ['/ai-studio/overview'],
          keywords: ['ai studio', 'hub', 'overview', 'dashboard'],
        ),
        NavigationItem(
          id: 'ai_room_designer',
          label: 'Room Designer',
          route: '/ai-studio/room-designer',
          icon: Icons.bedroom_parent_outlined,
          permission: 'ai.room_designer',
          legacyAliases: ['/ai-room-generator'],
          keywords: ['rendering', 'theme', 'remodel', 'day night', 'styles'],
        ),
        NavigationItem(
          id: 'ai_vastu',
          label: 'Vastu Consultant',
          route: '/ai-studio/vastu',
          icon: Icons.explore_outlined,
          permission: 'ai.vastu',
          legacyAliases: ['/ai-vastu'],
          keywords: ['vastu', 'directions', 'chakras', 'remedies'],
        ),
        NavigationItem(
          id: 'ai_budget',
          label: 'Budget Calculator',
          route: '/ai-studio/budget-calculator',
          icon: Icons.calculate_outlined,
          permission: 'ai.budget',
          legacyAliases: ['/ai-budget'],
          keywords: ['estimate', 'plywood', 'hardware cost'],
        ),
        NavigationItem(
          id: 'ai_doubt_solver',
          label: 'Doubt Solver',
          route: '/ai-studio/doubt-solver',
          icon: Icons.psychology_outlined,
          permission: 'ai.doubt_solver',
          legacyAliases: ['/ai-doubt-solver'],
          keywords: ['ai chat', 'knowledgebase', 'market info'],
        ),
        NavigationItem(
          id: 'ai_designer_calls',
          label: 'Designer Video Calls',
          route: '/ai-studio/designer-calls',
          icon: Icons.video_camera_front_outlined,
          permission: 'ai.designer_calls',
          legacyAliases: ['/designer-call'],
          keywords: ['video consultation', 'expert booking'],
        ),
        NavigationItem(
          id: 'ai_wallet',
          label: 'AI Wallet / Credits',
          route: '/ai-studio/wallet',
          icon: Icons.token_outlined,
          permission: 'ai.wallet',
          keywords: ['ai credits', 'tokens', 'quota'],
        ),
        NavigationItem(
          id: 'ai_usage_revenue',
          label: 'AI Usage / Revenue',
          route: '/ai-studio/usage-revenue',
          icon: Icons.monetization_on_outlined,
          permission: 'ai.usage_revenue',
          keywords: ['monetization', 'ai api costs'],
        ),
      ],
    ),

    // 15. Reports & Analytics
    NavigationGroup(
      id: 'reports',
      label: 'Reports & Analytics',
      icon: Icons.bar_chart_rounded,
      permission: 'reports.view',
      children: [
        NavigationItem(
          id: 'reports_executive',
          label: 'Executive Overview',
          route: '/reports/executive',
          icon: Icons.summarize_outlined,
          permission: 'reports.executive',
          keywords: ['ceo', 'board', 'kpi overview'],
        ),
        NavigationItem(
          id: 'reports_marketing',
          label: 'Marketing',
          route: '/reports/marketing',
          icon: Icons.trending_up_outlined,
          permission: 'reports.marketing',
          keywords: ['campaign roi', 'conversion rates'],
        ),
        NavigationItem(
          id: 'reports_sales',
          label: 'Sales',
          route: '/reports/sales',
          icon: Icons.point_of_sale_outlined,
          permission: 'reports.sales',
          keywords: ['rep performance', 'win rate', 'pipeline velocity'],
        ),
        NavigationItem(
          id: 'reports_projects',
          label: 'Projects / Execution',
          route: '/reports/projects',
          icon: Icons.speed_outlined,
          permission: 'reports.projects',
          legacyAliases: ['/reports/execution'],
          keywords: ['on time delivery', 'delays', 'snag rate'],
        ),
        NavigationItem(
          id: 'reports_design',
          label: 'Design',
          route: '/reports/design',
          icon: Icons.draw_outlined,
          permission: 'reports.design',
          keywords: ['turnaround time', 'revision count'],
        ),
        NavigationItem(
          id: 'reports_finance',
          label: 'Finance',
          route: '/reports/finance',
          icon: Icons.savings_outlined,
          permission: 'reports.finance',
          legacyAliases: ['/reports/finances'],
          keywords: ['gross margin', 'cash collection', 'revenue', 'expenses', 'p&l'],
        ),
        NavigationItem(
          id: 'reports_hr',
          label: 'HR',
          route: '/reports/hr',
          icon: Icons.people_alt_outlined,
          permission: 'reports.hr',
          keywords: ['headcount', 'attendance', 'attrition', 'recruitment', 'payroll'],
        ),
        NavigationItem(
          id: 'reports_service_labour',
          label: 'Service / Labour',
          route: '/reports/service',
          icon: Icons.construction_outlined,
          permission: 'reports.labour',
          legacyAliases: ['/reports/service-labour', '/reports/vendor-ratings'],
          keywords: ['work quality', 'sla', 'labour productivity', 'tickets'],
        ),
        NavigationItem(
          id: 'reports_feedback',
          label: 'Customer Feedback',
          route: '/reports/feedback',
          icon: Icons.sentiment_very_satisfied_outlined,
          permission: 'reports.feedback',
          legacyAliases: ['/reports/customer-feedback'],
          keywords: ['csat', 'nps', 'reviews', 'complaints', 'sentiment'],
        ),
        NavigationItem(
          id: 'reports_goals',
          label: 'Goals / Productivity',
          route: '/reports/goals',
          icon: Icons.track_changes_outlined,
          permission: 'reports.goals',
          legacyAliases: ['/reports/goals-productivity'],
          keywords: ['okr', 'targets', 'achievement', 'kpi', 'throughput'],
        ),
      ],
    ),

    // 16. Organization
    NavigationGroup(
      id: 'organization',
      label: 'Organization',
      icon: Icons.corporate_fare_rounded,
      permission: 'organization.view',
      children: [
        NavigationItem(
          id: 'org_departments',
          label: 'Departments',
          route: '/organization/departments',
          icon: Icons.schema_outlined,
          permission: 'org.departments',
          keywords: ['divisions', 'structure'],
        ),
        NavigationItem(
          id: 'org_teams',
          label: 'Teams',
          route: '/organization/teams',
          icon: Icons.group_work_outlined,
          permission: 'org.teams',
          keywords: ['squads', 'team leads'],
        ),
        NavigationItem(
          id: 'org_employees',
          label: 'Employees',
          route: '/organization/employees',
          icon: Icons.person_outline_rounded,
          permission: 'org.employees',
          keywords: ['hierarchy', 'reporting manager'],
        ),
        NavigationItem(
          id: 'org_roles',
          label: 'Roles',
          route: '/organization/roles',
          icon: Icons.admin_panel_settings_outlined,
          permission: 'org.roles',
          legacyAliases: ['/organization/role-levels'],
          keywords: ['job titles', 'role definitions'],
        ),
        NavigationItem(
          id: 'org_permissions',
          label: 'Permissions',
          route: '/organization/permissions',
          icon: Icons.vpn_key_outlined,
          permission: 'org.permissions',
          keywords: ['acl', 'capabilities', 'access keys'],
        ),
        NavigationItem(
          id: 'org_access_scope',
          label: 'Access Scope',
          route: '/organization/access-scope',
          icon: Icons.security_outlined,
          permission: 'org.scope',
          keywords: ['branch', 'hub', 'region', 'multi tenant'],
        ),
      ],
    ),

/*
    // 17. Administration
    NavigationGroup(
      id: 'administration',
      label: 'Administration',
      icon: Icons.settings_suggest_rounded,
      permission: 'admin.view',
      children: [
        NavigationItem(
          id: 'admin_users_rbac',
          label: 'Users & RBAC',
          route: '/admin/users-rbac',
          icon: Icons.manage_accounts_outlined,
          permission: 'admin.rbac',
          keywords: ['admin users', 'security policies'],
        ),
        NavigationItem(
          id: 'admin_master_data',
          label: 'Master Data',
          route: '/admin/master-data',
          icon: Icons.dataset_outlined,
          permission: 'admin.master_data',
          keywords: ['cities', 'states', 'categories'],
        ),
        NavigationItem(
          id: 'admin_rate_masters',
          label: 'Item / Rate Masters',
          route: '/admin/rate-masters',
          icon: Icons.table_chart_outlined,
          permission: 'admin.rate_masters',
          keywords: ['standard costs', 'vendor base rates'],
        ),
        NavigationItem(
          id: 'admin_message_templates',
          label: 'Message Templates',
          route: '/admin/message-templates',
          icon: Icons.mark_chat_unread_outlined,
          permission: 'admin.templates',
          keywords: ['system notifications', 'email templates'],
        ),
        NavigationItem(
          id: 'admin_ai_training',
          label: 'AI Training',
          route: '/admin/ai-training',
          icon: Icons.model_training_outlined,
          permission: 'admin.ai_training',
          keywords: ['prompt engineering', 'fine tuning', 'corpus'],
        ),
        NavigationItem(
          id: 'admin_integrations',
          label: 'Integrations',
          route: '/admin/integrations',
          icon: Icons.integration_instructions_outlined,
          permission: 'admin.integrations',
          keywords: ['whatsapp api', 'erp webhook', 'payment gateway'],
        ),
        NavigationItem(
          id: 'admin_notifications',
          label: 'Notifications',
          route: '/admin/notifications',
          icon: Icons.notifications_active_outlined,
          permission: 'admin.notifications',
          keywords: ['push', 'email', 'sms alerts'],
        ),
        NavigationItem(
          id: 'admin_automations',
          label: 'Automations',
          route: '/admin/automations',
          icon: Icons.smart_toy_outlined,
          permission: 'admin.automations',
          keywords: ['cron', 'triggers', 'webhooks'],
        ),
        NavigationItem(
          id: 'admin_audit_logs',
          label: 'Audit Logs',
          route: '/admin/audit-logs',
          icon: Icons.history_toggle_off_outlined,
          permission: 'admin.audit',
          keywords: ['compliance', 'activity trail', 'ip log'],
        ),
        NavigationItem(
          id: 'admin_backup_recovery',
          label: 'Backup / Recovery',
          route: '/admin/backup-recovery',
          icon: Icons.cloud_sync_outlined,
          permission: 'admin.backup',
          keywords: ['snapshots', 'restore', 'disaster recovery'],
        ),
        NavigationItem(
          id: 'admin_system_settings',
          label: 'System Settings',
          route: '/admin/settings',
          icon: Icons.settings_outlined,
          permission: 'admin.settings',
          keywords: ['branding', 'timezone', 'currency', 'company details'],
        ),
      ],
    ),
    */
  ];

  /// Filters navigation groups and children based on user permissions.
  /// Wildcard '*' grants access to all modules.
  static List<NavigationGroup> getFilteredNavigation(Set<String> userPermissions) {
    if (userPermissions.contains('*') || userPermissions.contains('super_admin')) {
      return masterGroups;
    }

    return masterGroups
        .where((group) => userPermissions.contains(group.permission))
        .map((group) {
          final authorizedChildren = group.children
              .where((child) => userPermissions.contains(child.permission))
              .toList();

          return NavigationGroup(
            id: group.id,
            label: group.label,
            icon: group.icon,
            permission: group.permission,
            children: authorizedChildren,
          );
        })
        .where((group) => group.children.isNotEmpty)
        .toList();
  }

  /// Resolves an active route or legacy alias to its matching NavigationItem
  static NavigationItem? findItemByRoute(String rawRoute) {
    final route = RouteNames.resolveCanonicalRoute(rawRoute);
    for (final group in masterGroups) {
      for (final child in group.children) {
        if (child.route == route || child.route == rawRoute || child.legacyAliases.contains(rawRoute) || child.legacyAliases.contains(route)) {
          return child;
        }
      }
    }
    return null;
  }

  /// Resolves an active route or legacy alias to its parent NavigationGroup
  static NavigationGroup? findGroupByRoute(String rawRoute) {
    final route = RouteNames.resolveCanonicalRoute(rawRoute);
    for (final group in masterGroups) {
      for (final child in group.children) {
        if (child.route == route || child.route == rawRoute || child.legacyAliases.contains(rawRoute) || child.legacyAliases.contains(route)) {
          return group;
        }
      }
    }
    return null;
  }
}
