import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/responsive/breakpoints.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';

// ============================================================================
// DOMAIN MODELS & ENUMS
// ============================================================================

enum SnagCategory {
  qualityDefect,
  timelineDelay,
  workerBehaviour,
  siteCleanliness,
  materialDeviation,
}

extension SnagCategoryExtension on SnagCategory {
  String get label {
    switch (this) {
      case SnagCategory.qualityDefect:
        return 'Quality Defect';
      case SnagCategory.timelineDelay:
        return 'Timeline Delay';
      case SnagCategory.workerBehaviour:
        return 'Worker Behaviour';
      case SnagCategory.siteCleanliness:
        return 'Site Cleanliness';
      case SnagCategory.materialDeviation:
        return 'Material Deviation';
    }
  }

  IconData get icon {
    switch (this) {
      case SnagCategory.qualityDefect:
        return Icons.build_circle_outlined;
      case SnagCategory.timelineDelay:
        return Icons.schedule_outlined;
      case SnagCategory.workerBehaviour:
        return Icons.badge_outlined;
      case SnagCategory.siteCleanliness:
        return Icons.cleaning_services_outlined;
      case SnagCategory.materialDeviation:
        return Icons.layers_outlined;
    }
  }

  Color get color {
    switch (this) {
      case SnagCategory.qualityDefect:
        return const Color(0xFFEF4444);
      case SnagCategory.timelineDelay:
        return const Color(0xFFF59E0B);
      case SnagCategory.workerBehaviour:
        return const Color(0xFF8B5CF6);
      case SnagCategory.siteCleanliness:
        return const Color(0xFF06B6D4);
      case SnagCategory.materialDeviation:
        return const Color(0xFF3B82F6);
    }
  }
}

enum SnagSeverity { critical, moderate, minor }

extension SnagSeverityExtension on SnagSeverity {
  String get label {
    switch (this) {
      case SnagSeverity.critical:
        return 'Critical (24h)';
      case SnagSeverity.moderate:
        return 'Moderate (48h)';
      case SnagSeverity.minor:
        return 'Minor (72h)';
    }
  }

  Color get color {
    switch (this) {
      case SnagSeverity.critical:
        return const Color(0xFFEF4444);
      case SnagSeverity.moderate:
        return const Color(0xFFF59E0B);
      case SnagSeverity.minor:
        return const Color(0xFF3B82F6);
    }
  }
}

enum SnagStatus { open, inProgress, resolved }

extension SnagStatusExtension on SnagStatus {
  String get label {
    switch (this) {
      case SnagStatus.open:
        return 'Open';
      case SnagStatus.inProgress:
        return 'In Progress';
      case SnagStatus.resolved:
        return 'Resolved';
    }
  }

  Color get color {
    switch (this) {
      case SnagStatus.open:
        return const Color(0xFFEF4444);
      case SnagStatus.inProgress:
        return const Color(0xFFF59E0B);
      case SnagStatus.resolved:
        return const Color(0xFF10B981);
    }
  }
}

class SnagTimelineEvent {
  final String title;
  final String timestamp;
  final String actor;
  final bool isCompleted;

  const SnagTimelineEvent({
    required this.title,
    required this.timestamp,
    required this.actor,
    this.isCompleted = true,
  });
}

class SnagTicket {
  final String id;
  final String title;
  final String roomLocation;
  final SnagCategory category;
  final SnagSeverity severity;
  SnagStatus status;
  final String reportedDate;
  final String slaTargetTime;
  final int slaRemainingHours;
  final bool isSlaMet;
  final String assignedTechnician;
  final String technicianRole;
  final String technicianPhone;
  final String description;
  final List<String> attachments;
  final List<SnagTimelineEvent> timeline;
  String? resolutionNote;
  String? resolvedDate;

  SnagTicket({
    required this.id,
    required this.title,
    required this.roomLocation,
    required this.category,
    required this.severity,
    required this.status,
    required this.reportedDate,
    required this.slaTargetTime,
    required this.slaRemainingHours,
    required this.isSlaMet,
    required this.assignedTechnician,
    required this.technicianRole,
    required this.technicianPhone,
    required this.description,
    required this.attachments,
    required this.timeline,
    this.resolutionNote,
    this.resolvedDate,
  });

  bool get isOpen => status == SnagStatus.open;
  bool get isInProgress => status == SnagStatus.inProgress;
  bool get isResolved => status == SnagStatus.resolved;
}

class WarrantyCoverage {
  final String id;
  final String title;
  final String duration;
  final String validUntil;
  final IconData icon;
  final Color color;
  final List<String> coveredItems;
  final String certificateNumber;
  final int claimsUsed;
  final int maxClaims;

  const WarrantyCoverage({
    required this.id,
    required this.title,
    required this.duration,
    required this.validUntil,
    required this.icon,
    required this.color,
    required this.coveredItems,
    required this.certificateNumber,
    this.claimsUsed = 0,
    this.maxClaims = 5,
  });
}

class MaintenanceVisit {
  final String id;
  final String title;
  final String milestone;
  final String scheduledDate;
  final String timeWindow;
  final String leadEngineer;
  final String engineerContact;
  bool isConfirmed;
  final bool isCompleted;

  MaintenanceVisit({
    required this.id,
    required this.title,
    required this.milestone,
    required this.scheduledDate,
    required this.timeWindow,
    required this.leadEngineer,
    required this.engineerContact,
    this.isConfirmed = true,
    this.isCompleted = false,
  });
}

// ============================================================================
// MAIN PAGE WIDGET
// ============================================================================

class ClientSnagsComplaintsPage extends StatefulWidget {
  const ClientSnagsComplaintsPage({super.key});

  @override
  State<ClientSnagsComplaintsPage> createState() =>
      _ClientSnagsComplaintsPageState();
}

class _ClientSnagsComplaintsPageState extends State<ClientSnagsComplaintsPage> {
  String _selectedTab = 'Snag Tickets';
  String _statusFilter = 'All';

  // Seeded tickets
  late final List<SnagTicket> _tickets = [
    SnagTicket(
      id: 'SNG-2026-089',
      title: 'Master Bedroom Wardrobe Soft-Close Hinge Misalignment',
      roomLocation: 'Master Bedroom',
      category: SnagCategory.qualityDefect,
      severity: SnagSeverity.moderate,
      status: SnagStatus.inProgress,
      reportedDate: 'Sep 04, 2026',
      slaTargetTime: 'Sep 06, 2026 • 02:00 PM',
      slaRemainingHours: 21,
      isSlaMet: true,
      assignedTechnician: 'Rajesh Verma',
      technicianRole: 'Site Execution Supervisor',
      technicianPhone: '+91 98201 44521',
      description:
          'Left shutter of the 4-door floor-to-ceiling wardrobe rubs against the carcass edge during closing. Needs hinge adjustment.',
      attachments: ['wardrobe_hinge_left.jpg', 'door_gap_measurement.png'],
      timeline: [
        SnagTimelineEvent(
          title: 'Ticket Raised by Client',
          timestamp: 'Sep 04, 02:00 PM',
          actor: 'Client (Sameer Joshi)',
        ),
        SnagTimelineEvent(
          title: 'Assigned to Site Supervisor',
          timestamp: 'Sep 04, 02:30 PM',
          actor: 'System SLA Router',
        ),
        SnagTimelineEvent(
          title: 'Häfele Hardware Technician Dispatched',
          timestamp: 'Sep 05, 10:00 AM',
          actor: 'Rajesh Verma',
        ),
      ],
    ),
    SnagTicket(
      id: 'SNG-2026-088',
      title: 'Balcony Corner Tile Grout Washout After Monsoons',
      roomLocation: 'Living Balcony',
      category: SnagCategory.materialDeviation,
      severity: SnagSeverity.minor,
      status: SnagStatus.open,
      reportedDate: 'Sep 05, 2026',
      slaTargetTime: 'Sep 07, 2026 • 11:30 AM',
      slaRemainingHours: 42,
      isSlaMet: true,
      assignedTechnician: 'Sunil Kumar',
      technicianRole: 'Civil Finishing Lead',
      technicianPhone: '+91 98202 88419',
      description:
          'Epoxy grout joint between 3 anti-skid porcelain tiles in balcony corner shows slight hairline erosion. Requires epoxy re-application.',
      attachments: ['balcony_grout_erosion.jpg'],
      timeline: [
        SnagTimelineEvent(
          title: 'Ticket Raised by Client',
          timestamp: 'Sep 05, 11:30 AM',
          actor: 'Client (Sameer Joshi)',
        ),
        SnagTimelineEvent(
          title: 'Queued in 48-Hour SLA Track',
          timestamp: 'Sep 05, 11:35 AM',
          actor: 'Warranty Automation',
        ),
      ],
    ),
    SnagTicket(
      id: 'SNG-2026-084',
      title: 'Dining Area False Ceiling Paint Touch-up',
      roomLocation: 'Dining Area',
      category: SnagCategory.siteCleanliness,
      severity: SnagSeverity.minor,
      status: SnagStatus.resolved,
      reportedDate: 'Aug 29, 2026',
      slaTargetTime: 'Aug 31, 2026 • 06:00 PM',
      slaRemainingHours: 0,
      isSlaMet: true,
      assignedTechnician: 'Rajesh Verma',
      technicianRole: 'Site Execution Supervisor',
      technicianPhone: '+91 98201 44521',
      description:
          'Minor pencil marking near chandelier magnetic track left by installation crew. Asian Paints Royale touch-up needed.',
      attachments: ['ceiling_pencil_mark.jpg', 'touchup_after.jpg'],
      timeline: [
        SnagTimelineEvent(
          title: 'Ticket Raised',
          timestamp: 'Aug 29, 10:15 AM',
          actor: 'Client',
        ),
        SnagTimelineEvent(
          title: 'Painter Team Dispatched',
          timestamp: 'Aug 29, 03:00 PM',
          actor: 'Rajesh Verma',
        ),
        SnagTimelineEvent(
          title: 'Rectification Verified by Supervisor',
          timestamp: 'Aug 30, 11:00 AM',
          actor: 'Rajesh Verma',
        ),
        SnagTimelineEvent(
          title: 'Signed Off by Client',
          timestamp: 'Aug 30, 04:30 PM',
          actor: 'Client',
        ),
      ],
      resolutionNote:
          'Applied 2 coats of Asian Paints Royale Base White. Sanded with 400-grit paper. Inspected under 3000K spot lights.',
      resolvedDate: 'Aug 30, 2026 (28h resolution)',
    ),
    SnagTicket(
      id: 'SNG-2026-080',
      title: 'Modular Kitchen Chimney Duct Vibration',
      roomLocation: 'Modular Kitchen',
      category: SnagCategory.qualityDefect,
      severity: SnagSeverity.critical,
      status: SnagStatus.resolved,
      reportedDate: 'Aug 21, 2026',
      slaTargetTime: 'Aug 22, 2026 • 01:00 PM',
      slaRemainingHours: 0,
      isSlaMet: true,
      assignedTechnician: 'Dr. Neha Kulkarni',
      technicianRole: 'MEP Consultant',
      technicianPhone: '+91 98204 77112',
      description:
          'Faber 1200 m3/h chimney duct rattled against gypsum framing at blower speed 3. Acoustic neoprene wrap requested.',
      attachments: ['chimney_duct.jpg', 'acoustic_pad_installed.jpg'],
      timeline: [
        SnagTimelineEvent(
          title: 'Critical Ticket Logged',
          timestamp: 'Aug 21, 01:00 PM',
          actor: 'Client',
        ),
        SnagTimelineEvent(
          title: 'Acoustic Clamp Fitted',
          timestamp: 'Aug 21, 05:45 PM',
          actor: 'MEP Contractor',
        ),
        SnagTimelineEvent(
          title: 'Decibel Test Passed (<48dB)',
          timestamp: 'Aug 22, 10:30 AM',
          actor: 'Dr. Neha Kulkarni',
        ),
      ],
      resolutionNote:
          'Installed rubber vibration isolator clamps and flexible acoustic aluminum sleeve. Vibration eliminated.',
      resolvedDate: 'Aug 22, 2026 (21h resolution)',
    ),
    SnagTicket(
      id: 'SNG-2026-077',
      title: 'Italian Marble Polish Gloss Level Uniformity',
      roomLocation: 'Living Lounge',
      category: SnagCategory.qualityDefect,
      severity: SnagSeverity.moderate,
      status: SnagStatus.resolved,
      reportedDate: 'Aug 15, 2026',
      slaTargetTime: 'Aug 17, 2026 • 05:00 PM',
      slaRemainingHours: 0,
      isSlaMet: true,
      assignedTechnician: 'Rajesh Verma',
      technicianRole: 'Site Execution Supervisor',
      technicianPhone: '+91 98201 44521',
      description:
          'Transition joint between living foyer and central seating had a 3-point gloss discrepancy on the reflectometer.',
      attachments: ['marble_gloss_reading.jpg'],
      timeline: [
        SnagTimelineEvent(
          title: 'Quality Observation Logged',
          timestamp: 'Aug 15, 04:00 PM',
          actor: 'Client',
        ),
        SnagTimelineEvent(
          title: 'Diamond Silicate Pad Re-Buffing',
          timestamp: 'Aug 16, 02:00 PM',
          actor: 'Klindex Specialist',
        ),
        SnagTimelineEvent(
          title: 'Gloss Value Verified: 94 GU',
          timestamp: 'Aug 17, 11:00 AM',
          actor: 'Rajesh Verma',
        ),
      ],
      resolutionNote:
          'Re-crystallized entire transition area with 3000-grit diamond pads. Uniform 94 Gloss Units achieved.',
      resolvedDate: 'Aug 17, 2026 (43h resolution)',
    ),
    SnagTicket(
      id: 'SNG-2026-071',
      title: 'Smart Touch Switch Panel Response Calibration',
      roomLocation: 'Guest Bedroom',
      category: SnagCategory.qualityDefect,
      severity: SnagSeverity.minor,
      status: SnagStatus.resolved,
      reportedDate: 'Aug 08, 2026',
      slaTargetTime: 'Aug 10, 2026 • 06:00 PM',
      slaRemainingHours: 0,
      isSlaMet: true,
      assignedTechnician: 'Vikram Malhotra',
      technicianRole: 'Project Manager',
      technicianPhone: '+91 98200 11201',
      description:
          'Capacitive touch switch 2 for reading spot required firm double tap to trigger automation scene.',
      attachments: ['smart_panel.jpg'],
      timeline: [
        SnagTimelineEvent(
          title: 'Ticket Raised',
          timestamp: 'Aug 08, 02:00 PM',
          actor: 'Client',
        ),
        SnagTimelineEvent(
          title: 'Firmware Calibrated',
          timestamp: 'Aug 09, 11:30 AM',
          actor: 'Home Automation Lead',
        ),
      ],
      resolutionNote:
          'Updated touch sensitivity threshold in Zigbee firmware v4.2. Tested 20 cycles flawlessly.',
      resolvedDate: 'Aug 09, 2026 (21h resolution)',
    ),
  ];

  // 10-Year Warranty Categories
  final List<WarrantyCoverage> _warrantyCategories = const [
    WarrantyCoverage(
      id: 'war_structural',
      title: '10-Year Core Structural & Waterproofing',
      duration: '10 Years Comprehensive',
      validUntil: 'Aug 28, 2036',
      icon: Icons.shield_rounded,
      color: Color(0xFF10B981),
      coveredItems: [
        'Wet-area PU waterproofing membranes (Bathrooms & Balconies)',
        'RCC core structural modifications and lintel framing',
        'Wall-to-ceiling bond beam anchoring & expansion joints',
        'Zero dampness & zero efflorescence guarantee',
      ],
      certificateNumber: 'HOMIO-WAR-10Y-STR-9821',
      claimsUsed: 0,
      maxClaims: 10,
    ),
    WarrantyCoverage(
      id: 'war_woodwork',
      title: '10-Year Anti-Termite & Modular Woodwork',
      duration: '10 Years Comprehensive',
      validUntil: 'Aug 28, 2036',
      icon: Icons.kitchen_rounded,
      color: Color(0xFF6366F1),
      coveredItems: [
        'BWP/Boiling Waterproof Marine Grade Birch Ply carcase integrity',
        'Anti-borer, anti-termite and moisture delamination protection',
        '0.8mm & 1mm German anti-scratch laminate bond peeling guarantee',
        'Factory PU edge banding seam separation protection',
      ],
      certificateNumber: 'HOMIO-WAR-10Y-WDW-9822',
      claimsUsed: 1,
      maxClaims: 10,
    ),
    WarrantyCoverage(
      id: 'war_hardware',
      title: '5-Year European Architectural Hardware',
      duration: '5 Years Mechanical',
      validUntil: 'Aug 28, 2031',
      icon: Icons.lock_outline_rounded,
      color: Color(0xFFF59E0B),
      coveredItems: [
        'Häfele & Blum soft-close hydraulic drawer runners & hinges',
        'Tandem box ball-bearing systems and lift-up stays (Aventos)',
        'Concealed wardrobe sliding tracks and soft-damping dampers',
        'Solid brass architectural door handles and lock mortises',
      ],
      certificateNumber: 'HOMIO-WAR-05Y-HDW-9823',
      claimsUsed: 1,
      maxClaims: 5,
    ),
    WarrantyCoverage(
      id: 'war_mep',
      title: '2-Year Electrical & Concealed Plumbing',
      duration: '2 Years Full System',
      validUntil: 'Aug 28, 2028',
      icon: Icons.electrical_services_rounded,
      color: Color(0xFF0EA5E9),
      coveredItems: [
        'Concealed copper VRV refrigeration line leaks & flares',
        'CPVC/UPVC pressure water supply line fittings & manifolds',
        'Distribution board MCB/ELCB tripping mechanism calibration',
        'Concealed conduit wiring insulation resistance guarantee',
      ],
      certificateNumber: 'HOMIO-WAR-02Y-MEP-9824',
      claimsUsed: 1,
      maxClaims: 3,
    ),
  ];

  // Maintenance Visits
  late final List<MaintenanceVisit> _maintenanceVisits = [
    MaintenanceVisit(
      id: 'maint_1',
      title: 'Post-Handover 30-Day Checkup',
      milestone: 'Month 1 Complimentary Routine',
      scheduledDate: 'Sep 28, 2026',
      timeWindow: '10:00 AM - 01:00 PM',
      leadEngineer: 'Rajesh Verma',
      engineerContact: '+91 98201 44521',
      isConfirmed: true,
      isCompleted: false,
    ),
    MaintenanceVisit(
      id: 'maint_2',
      title: 'Post-Handover 90-Day Deep Inspection',
      milestone: 'Month 3 Comprehensive Tuning',
      scheduledDate: 'Nov 28, 2026',
      timeWindow: '02:00 PM - 05:00 PM',
      leadEngineer: 'Sunil Kumar',
      engineerContact: '+91 98202 88419',
      isConfirmed: true,
      isCompleted: false,
    ),
    MaintenanceVisit(
      id: 'maint_3',
      title: '6-Month Hardware & Joint Service',
      milestone: 'Month 6 Lubrication & Re-alignment',
      scheduledDate: 'Feb 28, 2027',
      timeWindow: '10:00 AM - 01:00 PM',
      leadEngineer: 'Rajesh Verma',
      engineerContact: '+91 98201 44521',
      isConfirmed: false,
      isCompleted: false,
    ),
    MaintenanceVisit(
      id: 'maint_4',
      title: 'Annual Anniversary Warranty Audit',
      milestone: 'Year 1 Full Health Inspection',
      scheduledDate: 'Aug 28, 2027',
      timeWindow: '10:00 AM - 02:00 PM',
      leadEngineer: 'Vikram Malhotra',
      engineerContact: '+91 98200 11201',
      isConfirmed: false,
      isCompleted: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isMobile = screenWidth < Breakpoints.compact;

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 16.0 : 28.0,
          vertical: 24.0,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints:
                const BoxConstraints(maxWidth: Breakpoints.maxContentWidth),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Executive Clean Header
                _buildHeader(context, isDark, isMobile),

                const SizedBox(height: 18),

                // 2. Compact Metrics Strip
                _buildMetricStrip(context, isDark, isMobile),

                const SizedBox(height: 20),

                // 3. Navigation Sub-Tabs
                _buildSegmentedTabs(context, isDark, isMobile),

                const SizedBox(height: 20),

                // 4. Tab Views
                if (_selectedTab == 'Snag Tickets')
                  _buildSnagsView(context, isDark, isMobile)
                else if (_selectedTab == '10-Year Warranty Hub')
                  _buildWarrantyView(context, isDark, isMobile)
                else
                  _buildMaintenanceView(context, isDark, isMobile),

                const SizedBox(height: 28),

                // 5. Official SLA Guarantee Seal
                _buildSlaGuaranteeFooter(context, isDark, isMobile),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ==========================================================================
  // 1. CLEAN EXECUTIVE HEADER
  // ==========================================================================
  Widget _buildHeader(BuildContext context, bool isDark, bool isMobile) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 18.0 : 22.0),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: AppRadius.lg,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFEF4444).withValues(alpha: 0.12),
                  borderRadius: AppRadius.md,
                ),
                child: const Icon(
                  Icons.support_agent_rounded,
                  color: Color(0xFFEF4444),
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 8,
                      runSpacing: 4,
                      children: [
                        Text(
                          'Snags & Complaints Hub',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: isMobile ? 18 : 22,
                            fontWeight: FontWeight.w800,
                            color: isDark
                                ? Colors.white
                                : const Color(0xFF0F172A),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color:
                                const Color(0xFF10B981).withValues(alpha: 0.15),
                            borderRadius: AppRadius.full,
                            border: Border.all(
                              color: const Color(0xFF10B981)
                                  .withValues(alpha: 0.3),
                            ),
                          ),
                          child: Text(
                            '48-HR SLA ACTIVE',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF059669),
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Report workmanship issues with photo evidence • Track real-time resolution • 10-Year Warranty',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: isMobile ? 12 : 13,
                        fontWeight: FontWeight.w500,
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              FilledButton.icon(
                onPressed: () => _openRaiseSnagDialog(context, isDark),
                icon: const Icon(Icons.add_task_rounded, size: 16),
                label: Text(
                  'Raise Snag Ticket',
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFFEF4444),
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: AppRadius.md),
                ),
              ),
              OutlinedButton.icon(
                onPressed: () {
                  setState(() => _selectedTab = '10-Year Warranty Hub');
                },
                icon: const Icon(Icons.verified_user_outlined, size: 16),
                label: Text(
                  'Warranty Certificate',
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary,
                  side: BorderSide(
                    color:
                        isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: AppRadius.md),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ==========================================================================
  // 2. COMPACT METRIC STRIP
  // ==========================================================================
  Widget _buildMetricStrip(BuildContext context, bool isDark, bool isMobile) {
    final activeCount = _tickets.where((t) => !t.isResolved).length;
    final resolvedCount = _tickets.where((t) => t.isResolved).length;

    final cards = [
      _buildKpiCard(
        title: 'Active Snags',
        value: '$activeCount Tickets',
        subtitle: '1 In Progress • 1 Open',
        icon: Icons.pending_actions_rounded,
        color: const Color(0xFFF59E0B),
        isDark: isDark,
      ),
      _buildKpiCard(
        title: 'Resolved Tickets',
        value: '$resolvedCount Snags',
        subtitle: '100% Client Signed Off',
        icon: Icons.check_circle_rounded,
        color: const Color(0xFF10B981),
        isDark: isDark,
      ),
      _buildKpiCard(
        title: 'Average Resolution',
        value: '28.4 Hours',
        subtitle: '48h SLA Target Met',
        icon: Icons.timer_outlined,
        color: const Color(0xFF6366F1),
        isDark: isDark,
      ),
      _buildKpiCard(
        title: 'Warranty Protection',
        value: '10 Years Active',
        subtitle: 'Valid through 2036',
        icon: Icons.shield_rounded,
        color: const Color(0xFF0EA5E9),
        isDark: isDark,
      ),
    ];

    if (isMobile) {
      return GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1.5,
        children: cards,
      );
    }

    return Row(
      children: cards
          .map((card) => Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: card,
                ),
              ))
          .toList(),
    );
  }

  Widget _buildKpiCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: AppRadius.md,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(icon, size: 15, color: color),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? AppColors.darkTextMuted
                        : AppColors.lightTextMuted,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================================
  // 3. SEGMENTED SUB-TABS
  // ==========================================================================
  Widget _buildSegmentedTabs(
      BuildContext context, bool isDark, bool isMobile) {
    final tabs = [
      'Snag Tickets',
      '10-Year Warranty Hub',
      'Maintenance Dispatch'
    ];

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : const Color(0xFFF1F5F9),
        borderRadius: AppRadius.md,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          width: 1,
        ),
      ),
      child: isMobile
          ? Column(
              children: tabs.map((tab) => _buildTabButton(tab, isDark)).toList(),
            )
          : Row(
              children: tabs
                  .map((tab) => Expanded(child: _buildTabButton(tab, isDark)))
                  .toList(),
            ),
    );
  }

  Widget _buildTabButton(String tab, bool isDark) {
    final isSelected = _selectedTab == tab;
    return InkWell(
      onTap: () => setState(() => _selectedTab = tab),
      borderRadius: AppRadius.sm,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? const Color(0xFF1E293B) : Colors.white)
              : Colors.transparent,
          borderRadius: AppRadius.sm,
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  )
                ]
              : null,
        ),
        child: Center(
          child: Text(
            tab,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12.5,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected
                  ? (isDark ? Colors.white : const Color(0xFF0F172A))
                  : (isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary),
            ),
          ),
        ),
      ),
    );
  }

  // ==========================================================================
  // 4A. TAB 1: SNAG TICKETS VIEW
  // ==========================================================================
  Widget _buildSnagsView(BuildContext context, bool isDark, bool isMobile) {
    // Filter logic
    final filtered = _tickets.where((ticket) {
      if (_statusFilter == 'Open' && !ticket.isOpen) return false;
      if (_statusFilter == 'In Progress' && !ticket.isInProgress) return false;
      if (_statusFilter == 'Resolved' && !ticket.isResolved) return false;
      return true;
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Filter bar
        _buildFilterBar(isDark, isMobile),

        const SizedBox(height: 16),

        if (filtered.isEmpty)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : Colors.white,
              borderRadius: AppRadius.lg,
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              ),
            ),
            child: Center(
              child: Column(
                children: [
                  Icon(
                    Icons.check_circle_outline_rounded,
                    size: 44,
                    color: const Color(0xFF10B981).withValues(alpha: 0.7),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'No Tickets in Selected Filter',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'All snags in this category have been satisfactorily addressed.',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12.5,
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: filtered.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              return _buildTicketCard(filtered[index], isDark, isMobile);
            },
          ),
      ],
    );
  }

  Widget _buildFilterBar(bool isDark, bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: AppRadius.md,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Text(
            'STATUS:',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.8,
              color: isDark
                  ? AppColors.darkTextMuted
                  : AppColors.lightTextMuted,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ['All', 'Open', 'In Progress', 'Resolved'].map((s) {
                  final isSelected = _statusFilter == s;
                  return Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: ChoiceChip(
                      label: Text(s),
                      selected: isSelected,
                      onSelected: (_) => setState(() => _statusFilter = s),
                      labelStyle: GoogleFonts.plusJakartaSans(
                        fontSize: 11.5,
                        fontWeight: isSelected
                            ? FontWeight.w700
                            : FontWeight.w500,
                        color: isSelected
                            ? Colors.white
                            : (isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.lightTextSecondary),
                      ),
                      selectedColor: const Color(0xFFEF4444),
                      backgroundColor: isDark
                          ? const Color(0xFF1E293B)
                          : const Color(0xFFF1F5F9),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 0),
                      shape: RoundedRectangleBorder(
                          borderRadius: AppRadius.full),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTicketCard(SnagTicket ticket, bool isDark, bool isMobile) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: AppRadius.lg,
        border: Border.all(
          color: ticket.isOpen
              ? const Color(0xFFEF4444).withValues(alpha: 0.35)
              : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
          width: ticket.isOpen ? 1.5 : 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: AppRadius.lg,
        child: InkWell(
          onTap: () => _openSnagDetailsDialog(ticket, isDark),
          borderRadius: AppRadius.lg,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Badges Wrap
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: ticket.category.color.withValues(alpha: 0.12),
                        borderRadius: AppRadius.xs,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(ticket.category.icon,
                              size: 13, color: ticket.category.color),
                          const SizedBox(width: 4),
                          Text(
                            ticket.category.label,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w700,
                              color: ticket.category.color,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: ticket.severity.color.withValues(alpha: 0.12),
                        borderRadius: AppRadius.xs,
                      ),
                      child: Text(
                        ticket.severity.label,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w700,
                          color: ticket.severity.color,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: ticket.status.color.withValues(alpha: 0.14),
                        borderRadius: AppRadius.full,
                        border: Border.all(
                          color: ticket.status.color.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: ticket.status.color,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            ticket.status.label,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w800,
                              color: ticket.status.color,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // Title & Location
                Text(
                  ticket.title,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 4),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 6,
                  runSpacing: 2,
                  children: [
                    Icon(
                      Icons.room_outlined,
                      size: 13,
                      color: isDark
                          ? AppColors.darkTextMuted
                          : AppColors.lightTextMuted,
                    ),
                    Text(
                      '${ticket.roomLocation} • Reported ${ticket.reportedDate}',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w500,
                        color: isDark
                            ? AppColors.darkTextMuted
                            : AppColors.lightTextMuted,
                      ),
                    ),
                    Text(
                      '#${ticket.id}',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF6366F1),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // Description
                Text(
                  ticket.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12.5,
                    height: 1.4,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ),

                const SizedBox(height: 12),

                // Bottom strip: SLA countdown & Assigned tech
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 7),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF1E293B).withValues(alpha: 0.6)
                        : const Color(0xFFF8FAFC),
                    borderRadius: AppRadius.sm,
                  ),
                  child: isMobile
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  ticket.isResolved
                                      ? Icons.verified_rounded
                                      : Icons.access_time_rounded,
                                  size: 14,
                                  color: ticket.isResolved
                                      ? const Color(0xFF10B981)
                                      : const Color(0xFFF59E0B),
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    ticket.isResolved
                                        ? (ticket.resolvedDate ?? 'Resolved On-Time')
                                        : 'SLA: ${ticket.slaRemainingHours}h remaining',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: ticket.isResolved
                                          ? const Color(0xFF10B981)
                                          : const Color(0xFFF59E0B),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'Assigned: ${ticket.assignedTechnician}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: isDark
                                          ? AppColors.darkTextPrimary
                                          : AppColors.lightTextPrimary,
                                    ),
                                  ),
                                ),
                                Icon(
                                  Icons.chevron_right_rounded,
                                  size: 16,
                                  color: isDark
                                      ? AppColors.darkTextMuted
                                      : AppColors.lightTextMuted,
                                ),
                              ],
                            ),
                          ],
                        )
                      : Row(
                          children: [
                            Icon(
                              ticket.isResolved
                                  ? Icons.verified_rounded
                                  : Icons.access_time_rounded,
                              size: 14,
                              color: ticket.isResolved
                                  ? const Color(0xFF10B981)
                                  : const Color(0xFFF59E0B),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                ticket.isResolved
                                    ? (ticket.resolvedDate ?? 'Resolved On-Time')
                                    : 'SLA Target: ${ticket.slaRemainingHours}h remaining (${ticket.slaTargetTime})',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: ticket.isResolved
                                      ? const Color(0xFF10B981)
                                      : const Color(0xFFF59E0B),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Assigned: ${ticket.assignedTechnician}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: isDark
                                    ? AppColors.darkTextPrimary
                                    : AppColors.lightTextPrimary,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              Icons.chevron_right_rounded,
                              size: 16,
                              color: isDark
                                  ? AppColors.darkTextMuted
                                  : AppColors.lightTextMuted,
                            ),
                          ],
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ==========================================================================
  // 4B. TAB 2: 10-YEAR WARRANTY HUB VIEW
  // ==========================================================================
  Widget _buildWarrantyView(BuildContext context, bool isDark, bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Official Certificate Card
        Container(
          padding: EdgeInsets.all(isMobile ? 18 : 24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDark
                  ? [const Color(0xFF0F2027), const Color(0xFF203A43)]
                  : [const Color(0xFFEEF2FF), const Color(0xFFE0E7FF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: AppRadius.lg,
            border: Border.all(
              color: const Color(0xFF6366F1).withValues(alpha: 0.35),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6366F1),
                      borderRadius: AppRadius.md,
                    ),
                    child: const Icon(
                      Icons.military_tech_rounded,
                      color: Colors.white,
                      size: 26,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Homio 10-Year Turnkey Warranty Guarantee',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: isMobile ? 16 : 19,
                            fontWeight: FontWeight.w800,
                            color:
                                isDark ? Colors.white : const Color(0xFF1E1B4B),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Comprehensive warranty backed by corporate bank guarantee and certified branded material partnerships.',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12.5,
                            color: isDark
                                ? const Color(0xFFCBD5E1)
                                : const Color(0xFF4338CA),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Wrap(
                spacing: 12,
                runSpacing: 10,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.black.withValues(alpha: 0.3)
                          : Colors.white,
                      borderRadius: AppRadius.sm,
                      border: Border.all(
                        color: const Color(0xFF6366F1).withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.qr_code_2_rounded,
                            size: 16, color: Color(0xFF6366F1)),
                        const SizedBox(width: 6),
                        Text(
                          'CERT ID: HOMIO-2026-WAR-8819',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: isDark
                                ? Colors.white
                                : const Color(0xFF1E1B4B),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Downloading Official 10-Year Digital Warranty Certificate PDF...',
                            style: GoogleFonts.plusJakartaSans(),
                          ),
                          backgroundColor: const Color(0xFF10B981),
                        ),
                      );
                    },
                    icon: const Icon(Icons.download_rounded, size: 15),
                    label: Text(
                      'Download Certificate (PDF)',
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4F46E5),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 10),
                      shape: RoundedRectangleBorder(
                          borderRadius: AppRadius.sm),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // Warranty Pillars Grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: isMobile ? 1 : 2,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            mainAxisExtent: 220,
          ),
          itemCount: _warrantyCategories.length,
          itemBuilder: (context, index) {
            final war = _warrantyCategories[index];
            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : Colors.white,
                borderRadius: AppRadius.lg,
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: war.color.withValues(alpha: 0.12),
                          borderRadius: AppRadius.sm,
                        ),
                        child: Icon(war.icon, size: 20, color: war.color),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              war.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w700,
                                color: isDark
                                    ? Colors.white
                                    : const Color(0xFF0F172A),
                              ),
                            ),
                            Text(
                              '${war.duration} • Valid till ${war.validUntil}',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: war.color,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Divider(height: 1),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView(
                      physics: const NeverScrollableScrollPhysics(),
                      children: war.coveredItems.map((item) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.check_circle_rounded,
                                size: 13,
                                color: Color(0xFF10B981),
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  item,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 11.5,
                                    height: 1.3,
                                    color: isDark
                                        ? AppColors.darkTextSecondary
                                        : AppColors.lightTextSecondary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  // ==========================================================================
  // 4C. TAB 3: MAINTENANCE DISPATCH VIEW
  // ==========================================================================
  Widget _buildMaintenanceView(
      BuildContext context, bool isDark, bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Action Bar for On-Demand Dispatch
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : Colors.white,
            borderRadius: AppRadius.md,
            border: Border.all(
              color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Post-Handover Maintenance Schedule',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '4 scheduled visits in Year 1 included under turnkey service guarantee.',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              FilledButton.icon(
                onPressed: () => _openRequestMaintenanceDialog(context, isDark),
                icon: const Icon(Icons.handyman_rounded, size: 15),
                label: Text(
                  'Book Visit',
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w700,
                    fontSize: 12.5,
                  ),
                ),
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF4F46E5),
                  shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Maintenance Schedule List
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _maintenanceVisits.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final visit = _maintenanceVisits[index];
            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : Colors.white,
                borderRadius: AppRadius.md,
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: visit.isConfirmed
                          ? const Color(0xFF10B981).withValues(alpha: 0.12)
                          : const Color(0xFF6366F1).withValues(alpha: 0.12),
                      borderRadius: AppRadius.sm,
                    ),
                    child: Icon(
                      visit.isConfirmed
                          ? Icons.calendar_today_rounded
                          : Icons.event_available_rounded,
                      color: visit.isConfirmed
                          ? const Color(0xFF10B981)
                          : const Color(0xFF6366F1),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          visit.title,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: isDark
                                ? Colors.white
                                : const Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          '${visit.milestone} • ${visit.scheduledDate} (${visit.timeWindow})',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w500,
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.lightTextSecondary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Lead: ${visit.leadEngineer} (${visit.engineerContact})',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: isDark
                                ? AppColors.darkTextMuted
                                : AppColors.lightTextMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (visit.isConfirmed)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981).withValues(alpha: 0.12),
                        borderRadius: AppRadius.full,
                      ),
                      child: Text(
                        'CONFIRMED',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF059669),
                        ),
                      ),
                    )
                  else
                    OutlinedButton(
                      onPressed: () {
                        setState(() => visit.isConfirmed = true);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              '${visit.title} slot confirmed for ${visit.scheduledDate}!',
                              style: GoogleFonts.plusJakartaSans(),
                            ),
                            backgroundColor: const Color(0xFF10B981),
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        shape: RoundedRectangleBorder(
                            borderRadius: AppRadius.sm),
                      ),
                      child: Text(
                        'Confirm Slot',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  // ==========================================================================
  // 5. OFFICIAL SLA GUARANTEE FOOTER
  // ==========================================================================
  Widget _buildSlaGuaranteeFooter(
      BuildContext context, bool isDark, bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF1E293B).withValues(alpha: 0.5)
            : const Color(0xFFF1F5F9),
        borderRadius: AppRadius.md,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.verified_user_rounded,
            color: Color(0xFF10B981),
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Homio SLA Pledge: All critical snags attended within 24 hours. General defects rectified within 48 hours with digital client sign-off.',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11.5,
                fontWeight: FontWeight.w500,
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================================
  // MODALS & DIALOGS
  // ==========================================================================

  void _openRaiseSnagDialog(BuildContext context, bool isDark) {
    final titleCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    String selectedRoom = 'Living Lounge';
    SnagCategory selectedCategory = SnagCategory.qualityDefect;
    SnagSeverity selectedSeverity = SnagSeverity.moderate;

    final rooms = [
      'Living Lounge',
      'Modular Kitchen',
      'Master Bedroom',
      'Kids Bedroom',
      'Guest Bedroom',
      'Living Balcony',
      'Dining Area',
    ];

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (dialogCtx, setDialogState) {
            return AlertDialog(
              backgroundColor:
                  isDark ? AppColors.darkSurface : Colors.white,
              shape: RoundedRectangleBorder(borderRadius: AppRadius.lg),
              title: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEF4444).withValues(alpha: 0.12),
                      borderRadius: AppRadius.sm,
                    ),
                    child: const Icon(
                      Icons.add_task_rounded,
                      color: Color(0xFFEF4444),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Raise Snag Ticket',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),
              content: SizedBox(
                width: 500,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Room Selector
                      Text(
                        'Room / Area Location',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.lightTextPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      DropdownButtonFormField<String>(
                        isExpanded: true,
                        initialValue: selectedRoom,
                        dropdownColor:
                            isDark ? const Color(0xFF1E293B) : Colors.white,
                        items: rooms.map((r) {
                          return DropdownMenuItem(
                            value: r,
                            child: Text(r,
                                style: GoogleFonts.plusJakartaSans(
                                    fontSize: 12.5)),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setDialogState(() => selectedRoom = val);
                          }
                        },
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 10),
                          border: OutlineInputBorder(
                            borderRadius: AppRadius.sm,
                          ),
                        ),
                      ),

                      const SizedBox(height: 14),

                      // Category
                      Text(
                        'Category',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.lightTextPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: SnagCategory.values.map((cat) {
                          final isSelected = selectedCategory == cat;
                          return ChoiceChip(
                            label: Text(cat.label),
                            selected: isSelected,
                            onSelected: (_) {
                              setDialogState(() => selectedCategory = cat);
                            },
                            labelStyle: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              fontWeight: isSelected
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                              color: isSelected ? Colors.white : cat.color,
                            ),
                            selectedColor: cat.color,
                            backgroundColor:
                                cat.color.withValues(alpha: 0.12),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 0),
                            shape: RoundedRectangleBorder(
                                borderRadius: AppRadius.sm),
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 14),

                      // Severity
                      Text(
                        'Severity & SLA',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.lightTextPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: SnagSeverity.values.map((sev) {
                          final isSelected = selectedSeverity == sev;
                          return Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 6),
                              child: InkWell(
                                onTap: () {
                                  setDialogState(
                                      () => selectedSeverity = sev);
                                },
                                borderRadius: AppRadius.sm,
                                child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? sev.color.withValues(alpha: 0.15)
                                        : Colors.transparent,
                                    borderRadius: AppRadius.sm,
                                    border: Border.all(
                                      color: isSelected
                                          ? sev.color
                                          : (isDark
                                              ? AppColors.darkBorder
                                              : AppColors.lightBorder),
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      sev.label,
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 11,
                                        fontWeight: isSelected
                                            ? FontWeight.w700
                                            : FontWeight.w500,
                                        color: isSelected
                                            ? sev.color
                                            : (isDark
                                                ? AppColors.darkTextSecondary
                                                : AppColors.lightTextSecondary),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 14),

                      // Issue Title
                      Text(
                        'Issue Headline',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.lightTextPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextField(
                        controller: titleCtrl,
                        decoration: InputDecoration(
                          hintText: 'e.g. Wardrobe drawer hinge is loose',
                          hintStyle: GoogleFonts.plusJakartaSans(
                              fontSize: 12, color: Colors.grey),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 10),
                          border: OutlineInputBorder(
                            borderRadius: AppRadius.sm,
                          ),
                        ),
                      ),

                      const SizedBox(height: 14),

                      // Detailed Description
                      Text(
                        'Detailed Description',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.lightTextPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextField(
                        controller: descCtrl,
                        maxLines: 3,
                        decoration: InputDecoration(
                          hintText:
                              'Describe the defect, location, and symptoms...',
                          hintStyle: GoogleFonts.plusJakartaSans(
                              fontSize: 12, color: Colors.grey),
                          contentPadding: const EdgeInsets.all(12),
                          border: OutlineInputBorder(
                            borderRadius: AppRadius.sm,
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Photo Proof Simulator
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 8,
                        runSpacing: 6,
                        children: [
                          OutlinedButton.icon(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Photo captured & attached to snag ticket!',
                                    style: GoogleFonts.plusJakartaSans(),
                                  ),
                                  backgroundColor: const Color(0xFF10B981),
                                ),
                              );
                            },
                            icon: const Icon(Icons.add_a_photo_outlined,
                                size: 14),
                            label: Text(
                              'Attach Photo Proof',
                              style: GoogleFonts.plusJakartaSans(fontSize: 11.5),
                            ),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              shape: RoundedRectangleBorder(
                                  borderRadius: AppRadius.sm),
                            ),
                          ),
                          Text(
                            '1 photo attached (simulated)',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              color: const Color(0xFF10B981),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: Text('Cancel', style: GoogleFonts.plusJakartaSans()),
                ),
                FilledButton(
                  onPressed: () {
                    final title = titleCtrl.text.trim().isEmpty
                        ? '$selectedRoom Workmanship Defect'
                        : titleCtrl.text.trim();
                    final desc = descCtrl.text.trim().isEmpty
                        ? 'Inspection requested for $selectedRoom finish.'
                        : descCtrl.text.trim();

                    final newTicket = SnagTicket(
                      id: 'SNG-2026-${100 + _tickets.length}',
                      title: title,
                      roomLocation: selectedRoom,
                      category: selectedCategory,
                      severity: selectedSeverity,
                      status: SnagStatus.open,
                      reportedDate: 'Today',
                      slaTargetTime: 'In 48 Hours',
                      slaRemainingHours: 48,
                      isSlaMet: true,
                      assignedTechnician: 'Rajesh Verma',
                      technicianRole: 'Site Execution Supervisor',
                      technicianPhone: '+91 98201 44521',
                      description: desc,
                      attachments: ['snag_photo_proof.jpg'],
                      timeline: [
                        const SnagTimelineEvent(
                          title: 'Ticket Raised by Client',
                          timestamp: 'Just now',
                          actor: 'Client (Sameer Joshi)',
                        ),
                        const SnagTimelineEvent(
                          title: 'Queued for 48h SLA Tracking',
                          timestamp: 'Just now',
                          actor: 'Automated Router',
                        ),
                      ],
                    );

                    setState(() {
                      _tickets.insert(0, newTicket);
                    });

                    Navigator.of(ctx).pop();

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Ticket #${newTicket.id} logged! Assigned to Rajesh Verma with 48h SLA guarantee.',
                          style: GoogleFonts.plusJakartaSans(
                              fontWeight: FontWeight.w600),
                        ),
                        backgroundColor: const Color(0xFF10B981),
                      ),
                    );
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFFEF4444),
                  ),
                  child: Text('Submit Ticket',
                      style: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.w700)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _openSnagDetailsDialog(SnagTicket ticket, bool isDark) {
    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (dialogCtx, setDialogState) {
            return AlertDialog(
              backgroundColor:
                  isDark ? AppColors.darkSurface : Colors.white,
              shape: RoundedRectangleBorder(borderRadius: AppRadius.lg),
              title: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              '#${ticket.id}',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF6366F1),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: ticket.status.color
                                    .withValues(alpha: 0.12),
                                borderRadius: AppRadius.xs,
                              ),
                              child: Text(
                                ticket.status.label,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  color: ticket.status.color,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          ticket.title,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color:
                                isDark ? Colors.white : const Color(0xFF0F172A),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.of(ctx).pop(),
                  ),
                ],
              ),
              content: SizedBox(
                width: 500,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Location & Meta
                      Text(
                        'Location: ${ticket.roomLocation} • Reported ${ticket.reportedDate}',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Description
                      Text(
                        ticket.description,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          height: 1.4,
                          color: isDark
                              ? AppColors.darkTextPrimary
                              : const Color(0xFF1E293B),
                        ),
                      ),

                      const SizedBox(height: 16),
                      const Divider(height: 1),
                      const SizedBox(height: 16),

                      // Assigned Lead Contact Card
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFF1E293B)
                              : const Color(0xFFF8FAFC),
                          borderRadius: AppRadius.md,
                          border: Border.all(
                            color: isDark
                                ? AppColors.darkBorder
                                : AppColors.lightBorder,
                          ),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 18,
                              backgroundColor: const Color(0xFF6366F1),
                              child: Text(
                                ticket.assignedTechnician.isNotEmpty
                                    ? ticket.assignedTechnician[0]
                                    : 'T',
                                style: GoogleFonts.plusJakartaSans(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    ticket.assignedTechnician,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: isDark
                                          ? Colors.white
                                          : const Color(0xFF0F172A),
                                    ),
                                  ),
                                  Text(
                                    '${ticket.technicianRole} • ${ticket.technicianPhone}',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 11,
                                      color: isDark
                                          ? AppColors.darkTextMuted
                                          : AppColors.lightTextMuted,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.phone_rounded,
                                  color: Color(0xFF10B981), size: 18),
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Calling ${ticket.assignedTechnician} (${ticket.technicianPhone})...',
                                      style: GoogleFonts.plusJakartaSans(),
                                    ),
                                    backgroundColor: const Color(0xFF10B981),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Activity Timeline
                      Text(
                        'RESOLUTION TIMELINE',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.8,
                          color: isDark
                              ? AppColors.darkTextMuted
                              : AppColors.lightTextMuted,
                        ),
                      ),
                      const SizedBox(height: 10),

                      ...ticket.timeline.map((ev) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.check_circle_rounded,
                                size: 14,
                                color: Color(0xFF10B981),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      ev.title,
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color: isDark
                                            ? Colors.white
                                            : const Color(0xFF0F172A),
                                      ),
                                    ),
                                    Text(
                                      '${ev.timestamp} • By ${ev.actor}',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 10.5,
                                        color: isDark
                                            ? AppColors.darkTextMuted
                                            : AppColors.lightTextMuted,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }),

                      if (ticket.resolutionNote != null) ...[
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color:
                                const Color(0xFF10B981).withValues(alpha: 0.1),
                            borderRadius: AppRadius.sm,
                            border: Border.all(
                              color: const Color(0xFF10B981)
                                  .withValues(alpha: 0.3),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Resolution Notes:',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF059669),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                ticket.resolutionNote!,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 11.5,
                                  color: isDark
                                      ? Colors.white
                                      : const Color(0xFF064E3B),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              actions: [
                if (!ticket.isResolved)
                  FilledButton.icon(
                    onPressed: () {
                      setState(() {
                        ticket.status = SnagStatus.resolved;
                        ticket.resolvedDate = 'Today (Client Signed Off)';
                        ticket.resolutionNote =
                            'Rectification inspected and approved by client.';
                        ticket.timeline.add(
                          const SnagTimelineEvent(
                            title: 'Signed Off by Client',
                            timestamp: 'Just now',
                            actor: 'Client (Sameer Joshi)',
                          ),
                        );
                      });
                      Navigator.of(ctx).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Snag #${ticket.id} marked as satisfactorily resolved!',
                            style: GoogleFonts.plusJakartaSans(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          backgroundColor: const Color(0xFF10B981),
                        ),
                      );
                    },
                    icon: const Icon(Icons.check_circle_rounded, size: 16),
                    label: Text('Mark Satisfactorily Resolved',
                        style: GoogleFonts.plusJakartaSans(
                            fontWeight: FontWeight.w700)),
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF10B981),
                    ),
                  )
                else
                  OutlinedButton(
                    onPressed: () => Navigator.of(ctx).pop(),
                    child: Text('Close', style: GoogleFonts.plusJakartaSans()),
                  ),
              ],
            );
          },
        );
      },
    );
  }

  void _openRequestMaintenanceDialog(BuildContext context, bool isDark) {
    String selectedType = 'Routine Preventive Checkup';
    String selectedDate = 'Tomorrow Morning (10:00 AM - 01:00 PM)';

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: AppRadius.lg),
          title: Text(
            'Request Maintenance Dispatch',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
          ),
          content: SizedBox(
            width: 420,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Select Service Type',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                DropdownButtonFormField<String>(
                  isExpanded: true,
                  initialValue: selectedType,
                  dropdownColor:
                      isDark ? const Color(0xFF1E293B) : Colors.white,
                  items: [
                    'Routine Preventive Checkup',
                    'Hardware & Door Alignments',
                    'Plumbing & Drainage Health Check',
                    'Electrical MCB & Appliance Audit',
                  ].map((s) {
                    return DropdownMenuItem(
                      value: s,
                      child: Text(s,
                          style: GoogleFonts.plusJakartaSans(fontSize: 12.5)),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) selectedType = val;
                  },
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                    border: OutlineInputBorder(borderRadius: AppRadius.sm),
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  'Preferred Time Slot',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                DropdownButtonFormField<String>(
                  isExpanded: true,
                  initialValue: selectedDate,
                  dropdownColor:
                      isDark ? const Color(0xFF1E293B) : Colors.white,
                  items: [
                    'Tomorrow Morning (10:00 AM - 01:00 PM)',
                    'Tomorrow Afternoon (02:00 PM - 05:00 PM)',
                    'This Saturday (11:00 AM - 02:00 PM)',
                    'Next Monday (10:00 AM - 01:00 PM)',
                  ].map((s) {
                    return DropdownMenuItem(
                      value: s,
                      child: Text(s,
                          style: GoogleFonts.plusJakartaSans(fontSize: 12.5)),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) selectedDate = val;
                  },
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                    border: OutlineInputBorder(borderRadius: AppRadius.sm),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text('Cancel', style: GoogleFonts.plusJakartaSans()),
            ),
            FilledButton(
              onPressed: () {
                setState(() {
                  _maintenanceVisits.insert(
                    0,
                    MaintenanceVisit(
                      id: 'maint_custom_${_maintenanceVisits.length}',
                      title: selectedType,
                      milestone: 'On-Demand Service Request',
                      scheduledDate: selectedDate,
                      timeWindow: 'Confirmed Window',
                      leadEngineer: 'Rajesh Verma',
                      engineerContact: '+91 98201 44521',
                      isConfirmed: true,
                      isCompleted: false,
                    ),
                  );
                });
                Navigator.of(ctx).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Technician dispatch confirmed for $selectedDate!',
                      style: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.w600),
                    ),
                    backgroundColor: const Color(0xFF10B981),
                  ),
                );
              },
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF4F46E5),
              ),
              child: Text('Confirm Dispatch',
                  style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.w700)),
            ),
          ],
        );
      },
    );
  }
}
