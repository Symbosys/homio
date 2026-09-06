import 'package:flutter/material.dart';
import '../../app/router/route_names.dart';
import 'navigation_models.dart';

/// Sub-menu item representation for client modules with submenus (e.g. AI Studio, Marketplace).
class ClientSubMenuItem {
  final String id;
  final String title;
  final IconData icon;
  final String routeName;
  final String routePath;
  final String description;
  final int badgeCount;
  final Color? badgeColor;

  const ClientSubMenuItem({
    required this.id,
    required this.title,
    required this.icon,
    required this.routeName,
    required this.routePath,
    required this.description,
    this.badgeCount = 0,
    this.badgeColor,
  });
}

/// Menu item representing either a direct flat screen or an expandable module with submenus.
class ClientMenuItem {
  final String id;
  final String title;
  final IconData icon;
  final String routeName;
  final String routePath;
  final String description;
  final int badgeCount;
  final Color? badgeColor;
  final List<String> subFeatures;
  final List<ClientSubMenuItem> subItems;

  const ClientMenuItem({
    required this.id,
    required this.title,
    required this.icon,
    required this.routeName,
    required this.routePath,
    required this.description,
    this.badgeCount = 0,
    this.badgeColor,
    this.subFeatures = const [],
    this.subItems = const [],
  });

  bool get hasSubItems => subItems.isNotEmpty;
}

/// Central registry containing all 11 client navigation items.
/// Items 1 to 9 are direct single-level items; Items 10 and 11 feature dedicated submenus.
abstract class ClientNavigationRegistry {
  static const List<ClientMenuItem> items = [
    // 1. Project Dashboard
    ClientMenuItem(
      id: 'client_overview',
      title: 'Project Dashboard',
      icon: Icons.dashboard_customize_rounded,
      routeName: RouteNames.clientOverview,
      routePath: RouteNames.clientOverviewPath,
      description: 'Overall progress, active stage milestone & live health metrics',
      subFeatures: [
        'Live 72% Milestone Progress & Health',
        'Active Stage: Carpentry & Polish',
        'Budget Spent & Timeline Tracking',
        'Recent Activity & Quick Action Center',
      ],
    ),

    // 2. Assigned Team Dossier
    ClientMenuItem(
      id: 'client_team',
      title: 'Assigned Team Dossier',
      icon: Icons.badge_rounded,
      routeName: RouteNames.clientTeam,
      routePath: RouteNames.clientTeamPath,
      description: 'Direct contact with your PM, Senior Designer & Site Supervisor',
      subFeatures: [
        'Dedicated Project Manager (Vikram Malhotra)',
        'Senior Interior Designer (Pooja Hegde)',
        'Site Execution Supervisor (Rajesh Verma)',
        'Lead Structural Architect & Vastu Expert',
        '1-Click WhatsApp & Phone Hotline',
      ],
    ),

    // 3. Live Site Progress
    ClientMenuItem(
      id: 'client_site_progress',
      title: 'Live Site Progress',
      icon: Icons.camera_indoor_rounded,
      routeName: RouteNames.clientSiteProgress,
      routePath: RouteNames.clientSiteProgressPath,
      badgeCount: 4,
      badgeColor: Color(0xFF10B981),
      description: 'Daily supervisor inspection photos, videos & stage checklist',
      subFeatures: [
        'Daily Inspection Photo & Video Walkthrough Feed',
        'CCTV / Time-Lapse Site Camera Snapshot',
        'Stage Milestones Checklist (Civil, MEP, Carpentry, Painting)',
        'Quality Inspection Sign-Off Criteria',
      ],
    ),

    // 4. Stage Work Approvals
    ClientMenuItem(
      id: 'client_approvals',
      title: 'Stage Work Approvals',
      icon: Icons.verified_rounded,
      routeName: RouteNames.clientApprovals,
      routePath: RouteNames.clientApprovalsPath,
      badgeCount: 2,
      badgeColor: Color(0xFF6366F1),
      description: 'Digital sign-offs for stage milestones & complete audit history',
      subFeatures: [
        'Pending Work Sign-Offs (2 Stages Awaiting Approval)',
        'Inspection Checklist & Site Photo Evidence Review',
        '1-Click Digital Approval & Modification Request',
        'Audit Trail & Downloadable Stage Certificates',
      ],
    ),

    // 5. Designs & 3D Visualizer
    ClientMenuItem(
      id: 'client_designs',
      title: '3D Designs & CAD Vault',
      icon: Icons.view_in_ar_rounded,
      routeName: RouteNames.clientDesigns,
      routePath: RouteNames.clientDesignsPath,
      description: 'Photorealistic 3D renders, revision requests & blueprint vault',
      subFeatures: [
        'Living Room, Modular Kitchen & Master Bedroom 3D Renders',
        'Interactive AR & Full-Screen Render Lightbox',
        'Color & Material Finish Revision Requests',
        'Approved CAD Floor Plans, BOQs & Legal Agreements Vault',
      ],
    ),

    // 6. Project Chat & Meetings
    ClientMenuItem(
      id: 'client_chat',
      title: 'Project Chat & Meetings',
      icon: Icons.forum_rounded,
      routeName: RouteNames.clientChat,
      routePath: RouteNames.clientChatPath,
      badgeCount: 3,
      badgeColor: Color(0xFF10B981),
      description: 'Unified WhatsApp chat with team & review meeting scheduler',
      subFeatures: [
        'Unified WhatsApp Project Chat Thread',
        'Direct Audio / Video Call with PM',
        'Schedule Virtual Review or Physical Site Visit',
        'Meeting Minutes & Action Item Log',
      ],
    ),

    // 7. Billing & Invoices
    ClientMenuItem(
      id: 'client_payments',
      title: 'Billing & Invoices',
      icon: Icons.account_balance_wallet_rounded,
      routeName: RouteNames.clientPayments,
      routePath: RouteNames.clientPaymentsPath,
      badgeCount: 1,
      badgeColor: Color(0xFFF59E0B),
      description: 'Milestone payment links, project cost breakdown & tax invoices',
      subFeatures: [
        'Milestone Payment Links (Instant UPI, Cards & Net Banking)',
        'Total Contract Cost Summary & Paid vs Balance Ledger',
        'Approved Variation Work Commercials',
        'Download GST Tax Invoices & Official Receipts',
      ],
    ),

    // 8. Snags & Complaints Hub
    ClientMenuItem(
      id: 'client_complaints',
      title: 'Snags & Complaints Hub',
      icon: Icons.support_agent_rounded,
      routeName: RouteNames.clientComplaints,
      routePath: RouteNames.clientComplaintsPath,
      description: 'Raise defect tickets with photo proof & 10-year warranty claims',
      subFeatures: [
        'Raise Snag / Defect Ticket with Photo Attachments',
        'Live Resolution SLA Tracker (48-Hour Guarantee)',
        '10-Year Warranty Coverage Hub & Terms',
        'Post-Handover Maintenance Dispatch Request',
      ],
    ),

    // 9. Feedback & 360° Ratings
    ClientMenuItem(
      id: 'client_ratings',
      title: 'Feedback & 360° Ratings',
      icon: Icons.star_rate_rounded,
      routeName: RouteNames.clientRatings,
      routePath: RouteNames.clientRatingsPath,
      description: 'Rate Design, Execution, Site Supervisor & Material Quality',
      subFeatures: [
        'Design & Architecture Rating',
        'Workmanship & Execution Quality Score',
        'Site Supervisor & Labour Behaviour Rating',
        'Material & Finish Quality Feedback',
      ],
    ),

    // 10. Client AI Studio (With 4 Submenus - Architect call removed)
    ClientMenuItem(
      id: 'client_ai_suite',
      title: 'Client AI Studio',
      icon: Icons.auto_awesome_rounded,
      routeName: RouteNames.clientAiSuite,
      routePath: RouteNames.clientAiSuitePath,
      badgeCount: 4,
      badgeColor: Color(0xFF6366F1),
      description: 'Instant 3D room generator, Vastu score, budget calculator & doubt solver',
      subFeatures: [
        'Instant 3D Room Generator (50/50 Photo Styling)',
        'AI Vastu Consultant (Floor Plan Chakra Score & Remedies)',
        'AI Furniture Budget Calculator (Price Estimator & Comparisons)',
        'AI Doubt Solver (Rs. 50/Question Technical Advice)',
      ],
      subItems: [
        ClientSubMenuItem(
          id: 'client_ai_room_gen',
          title: 'AI Room 3D Generator (50/50)',
          icon: Icons.auto_awesome_rounded,
          routeName: RouteNames.clientAiRoomGen,
          routePath: RouteNames.clientAiRoomGenPath,
          description: '50/50 dual view photo-to-3D styling',
        ),
        ClientSubMenuItem(
          id: 'client_ai_vastu',
          title: 'AI Vastu Consultant',
          icon: Icons.compass_calibration_rounded,
          routeName: RouteNames.clientAiVastu,
          routePath: RouteNames.clientAiVastuPath,
          description: 'Floor plan chakra score & Vedic remedies',
        ),
        ClientSubMenuItem(
          id: 'client_ai_budget',
          title: 'AI Furniture Budget Estimator',
          icon: Icons.calculate_rounded,
          routeName: RouteNames.clientAiBudget,
          routePath: RouteNames.clientAiBudgetPath,
          description: 'Compare Commercial vs HDHMR vs Acrylic',
        ),
        ClientSubMenuItem(
          id: 'client_ai_doubt_solver',
          title: 'AI Technical Doubt Solver',
          icon: Icons.psychology_rounded,
          routeName: RouteNames.clientAiDoubtSolver,
          routePath: RouteNames.clientAiDoubtSolverPath,
          description: 'Instant technical advice at Rs. 50/query',
        ),
      ],
    ),

    // 11. Marketplace & Services (With Submenus) - Commented out for Client Sidebar
    /*
    ClientMenuItem(
      id: 'client_marketplace',
      title: 'Marketplace & Services',
      icon: Icons.storefront_rounded,
      routeName: RouteNames.clientMarketplace,
      routePath: RouteNames.clientMarketplacePath,
      badgeCount: 4,
      badgeColor: Color(0xFF10B981),
      description: 'Digital styling guides, home decor materials, rental listings & labour hire',
      subFeatures: [
        'Digital Guides Store (Vastu Handbook & Styling Guides)',
        'Curated Home Decor & Material Catalog',
        'Verified Rental & Property Listings (Rs. 500 Unlock)',
        'Hire On-Demand Vetted Labour (Carpenters, Plumbers, Electricians)',
      ],
      subItems: [
        ClientSubMenuItem(
          id: 'client_digital_store',
          title: 'Digital Guides Store',
          icon: Icons.menu_book_rounded,
          routeName: RouteNames.clientDigitalStore,
          routePath: RouteNames.clientDigitalStorePath,
          description: 'Vastu blueprints & styling handbooks',
        ),
        ClientSubMenuItem(
          id: 'client_decor_store',
          title: 'Home Decor & Materials',
          icon: Icons.shopping_bag_rounded,
          routeName: RouteNames.clientDecorStore,
          routePath: RouteNames.clientDecorStorePath,
          description: 'Designer chandeliers & Italian marble',
        ),
        ClientSubMenuItem(
          id: 'client_properties',
          title: 'Rental & Properties',
          icon: Icons.holiday_village_rounded,
          routeName: RouteNames.clientProperties,
          routePath: RouteNames.clientPropertiesPath,
          description: 'Verified luxury rentals & homes',
        ),
        ClientSubMenuItem(
          id: 'client_hire_labour',
          title: 'Hire On-Demand Labour',
          icon: Icons.engineering_rounded,
          routeName: RouteNames.clientHireLabour,
          routePath: RouteNames.clientHireLabourPath,
          description: 'Book verified master carpenters & plumbers',
        ),
      ],
    ),
    */
  ];

  /// Resolves the title, description, icon, and sub-features for any client route path.
  static ({String title, String clusterTitle, IconData icon, String? description, List<String> subFeatures}) findInfoByPath(String path) {
    // 1. Match direct items and sub-items
    for (final item in items) {
      if (item.routePath == path) {
        return (
          title: item.title,
          clusterTitle: 'HOMIO CLIENT PORTAL',
          icon: item.icon,
          description: item.description,
          subFeatures: item.subFeatures,
        );
      }
      for (final sub in item.subItems) {
        if (sub.routePath == path) {
          return (
            title: sub.title,
            clusterTitle: item.title.toUpperCase(),
            icon: sub.icon,
            description: sub.description,
            subFeatures: item.subFeatures,
          );
        }
      }
    }

    // 2. Normalize aliases
    String normalized = path;
    if (path == '/client/milestones') normalized = RouteNames.clientSiteProgressPath;
    if (path == '/client/approval-history') normalized = RouteNames.clientApprovalsPath;
    if (path == '/client/designs-gallery' || path == '/client/design-revisions' || path == '/client/documents') normalized = RouteNames.clientDesignsPath;
    if (path == '/client/meetings') normalized = RouteNames.clientChatPath;
    if (path == '/client/cost-summary' || path == '/client/invoices') normalized = RouteNames.clientPaymentsPath;
    if (path == '/client/warranty') normalized = RouteNames.clientComplaintsPath;

    for (final item in items) {
      if (item.routePath == normalized) {
        return (
          title: item.title,
          clusterTitle: 'HOMIO CLIENT PORTAL',
          icon: item.icon,
          description: item.description,
          subFeatures: item.subFeatures,
        );
      }
      for (final sub in item.subItems) {
        if (sub.routePath == normalized) {
          return (
            title: sub.title,
            clusterTitle: item.title.toUpperCase(),
            icon: sub.icon,
            description: sub.description,
            subFeatures: item.subFeatures,
          );
        }
      }
    }

    return (
      title: 'Client Portal Module',
      clusterTitle: 'HOMIO CLIENT PORTAL',
      icon: Icons.home_repair_service_rounded,
      description: 'Homio Homeowner Portal Workspace',
      subFeatures: const [],
    );
  }

  /// Backward-compatible NavigationCluster adapter for legacy callers
  static List<NavigationCluster> get clusters {
    return [
      NavigationCluster(
        category: ClusterCategory.clientProjectExecution,
        title: 'CLIENT PORTAL',
        items: items.map((i) => NavigationMenuItem(
          id: i.id,
          title: i.title,
          icon: i.icon,
          badgeCount: i.badgeCount > 0 ? i.badgeCount : null,
          badgeColor: i.badgeColor,
          subItems: i.hasSubItems
              ? i.subItems.map((s) => NavigationSubMenuItem(
                  id: s.id,
                  title: s.title,
                  icon: s.icon,
                  routeName: s.routeName,
                  routePath: s.routePath,
                  description: s.description,
                )).toList()
              : [
                  NavigationSubMenuItem(
                    id: i.id,
                    title: i.title,
                    icon: i.icon,
                    routeName: i.routeName,
                    routePath: i.routePath,
                    description: i.description,
                  ),
                ],
        )).toList(),
      ),
    ];
  }
}
