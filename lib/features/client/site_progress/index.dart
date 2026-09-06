import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/responsive/breakpoints.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';

// ============================================================================
// DOMAIN MODELS & ENUMS
// ============================================================================

enum MilestoneStatus {
  completed,
  inProgress,
  upcoming,
}

enum MediaType {
  video,
  photo,
  timelapse,
}

class SiteMilestone {
  final int stageNumber;
  final String title;
  final String category;
  final int progressPercent;
  final MilestoneStatus status;
  final String completionDate;
  final int checklistCompleted;
  final int checklistTotal;

  const SiteMilestone({
    required this.stageNumber,
    required this.title,
    required this.category,
    required this.progressPercent,
    required this.status,
    required this.completionDate,
    required this.checklistCompleted,
    required this.checklistTotal,
  });

  bool get isCompleted => status == MilestoneStatus.completed;
  bool get isInProgress => status == MilestoneStatus.inProgress;
}

class SiteFeedMedia {
  final String id;
  final String title;
  final String zone;
  final String timestamp;
  final MediaType mediaType;
  final String duration;
  final String authorName;
  final String authorRole;
  final String caption;
  final List<String> tags;
  final Color placeholderGradientStart;
  final Color placeholderGradientEnd;

  const SiteFeedMedia({
    required this.id,
    required this.title,
    required this.zone,
    required this.timestamp,
    required this.mediaType,
    required this.duration,
    required this.authorName,
    required this.authorRole,
    required this.caption,
    required this.tags,
    required this.placeholderGradientStart,
    required this.placeholderGradientEnd,
  });
}

class SiteCadenceInfo {
  final String lastVisitDate;
  final String lastVisitAuthor;
  final int daysSinceLastVisit;
  final int maxAllowedCadenceDays;
  final int activeSprintCompletedTasks;
  final int activeSprintTotalTasks;

  const SiteCadenceInfo({
    required this.lastVisitDate,
    required this.lastVisitAuthor,
    required this.daysSinceLastVisit,
    required this.maxAllowedCadenceDays,
    required this.activeSprintCompletedTasks,
    required this.activeSprintTotalTasks,
  });

  bool get isCadenceHealthy => daysSinceLastVisit <= maxAllowedCadenceDays;
}

class QualityCheckItem {
  final String title;
  final String category;
  final bool isPassed;
  final String verifiedBy;
  final String verifiedTime;

  const QualityCheckItem({
    required this.title,
    required this.category,
    required this.isPassed,
    required this.verifiedBy,
    required this.verifiedTime,
  });
}

// ============================================================================
// MAIN PAGE WIDGET: LIVE SITE PROGRESS
// ============================================================================

class ClientSiteProgressPage extends StatefulWidget {
  const ClientSiteProgressPage({super.key});

  @override
  State<ClientSiteProgressPage> createState() => _ClientSiteProgressPageState();
}

class _ClientSiteProgressPageState extends State<ClientSiteProgressPage> {
  String _selectedZone = 'All Zones';
  bool _isStage5Approved = false;

  // 1. 8-Stage Construction Milestone Progression (from docs/requirmenet.md)
  static const List<SiteMilestone> _milestones = [
    SiteMilestone(
      stageNumber: 1,
      title: 'Civil Demolition & Core Masonry',
      category: 'Civil & Structural',
      progressPercent: 100,
      status: MilestoneStatus.completed,
      completionDate: 'Completed Jul 12',
      checklistCompleted: 8,
      checklistTotal: 8,
    ),
    SiteMilestone(
      stageNumber: 2,
      title: 'MEP Concealed Plumbing & Electrical',
      category: 'Infrastructure',
      progressPercent: 100,
      status: MilestoneStatus.completed,
      completionDate: 'Completed Jul 29',
      checklistCompleted: 12,
      checklistTotal: 12,
    ),
    SiteMilestone(
      stageNumber: 3,
      title: 'Gypsum False Ceiling & Concealed Lights',
      category: 'Ceiling & HVAC',
      progressPercent: 100,
      status: MilestoneStatus.completed,
      completionDate: 'Completed Aug 14',
      checklistCompleted: 10,
      checklistTotal: 10,
    ),
    SiteMilestone(
      stageNumber: 4,
      title: 'Italian Statuario Marble Flooring & Polish',
      category: 'Flooring',
      progressPercent: 100,
      status: MilestoneStatus.completed,
      completionDate: 'Completed Aug 27',
      checklistCompleted: 9,
      checklistTotal: 9,
    ),
    SiteMilestone(
      stageNumber: 5,
      title: 'Bespoke Joinery & Modular Kitchen',
      category: 'Carpentry (Active)',
      progressPercent: 75,
      status: MilestoneStatus.inProgress,
      completionDate: 'Est. Sep 18 (On Time)',
      checklistCompleted: 7,
      checklistTotal: 9,
    ),
    SiteMilestone(
      stageNumber: 6,
      title: 'PU Veneer Polish & Acrylic Wall Paints',
      category: 'Finishes',
      progressPercent: 15,
      status: MilestoneStatus.upcoming,
      completionDate: 'Est. Oct 02',
      checklistCompleted: 0,
      checklistTotal: 8,
    ),
    SiteMilestone(
      stageNumber: 7,
      title: 'Smart Home Automation & Sanitary Fixtures',
      category: 'Fittings & Tech',
      progressPercent: 0,
      status: MilestoneStatus.upcoming,
      completionDate: 'Est. Oct 16',
      checklistCompleted: 0,
      checklistTotal: 11,
    ),
    SiteMilestone(
      stageNumber: 8,
      title: 'Deep Cleaning, Snag Audit & Handover',
      category: 'Handover Certification',
      progressPercent: 0,
      status: MilestoneStatus.upcoming,
      completionDate: 'Est. Oct 28',
      checklistCompleted: 0,
      checklistTotal: 14,
    ),
  ];

  // 2. Physical Site Inspection Cadence & Sprint Tracking (docs/requirmenet.md)
  static const SiteCadenceInfo _cadenceInfo = SiteCadenceInfo(
    lastVisitDate: 'Sep 01, 2026',
    lastVisitAuthor: 'Ar. Sameer Mehta (Sr. PM) & Client',
    daysSinceLastVisit: 4,
    maxAllowedCadenceDays: 10,
    activeSprintCompletedTasks: 18,
    activeSprintTotalTasks: 21,
  );

  // 3. Daily Supervisor Inspection Feed Items (Photos & Videos)
  static const List<SiteFeedMedia> _feedItems = [
    SiteFeedMedia(
      id: 'feed_1',
      title: 'German Tandem Box & Carcase Laser Level Check',
      zone: 'Kitchen',
      timestamp: 'Today, 11:30 AM',
      mediaType: MediaType.video,
      duration: '0:48 min',
      authorName: 'Rajesh Verma',
      authorRole: 'Site Execution Supervisor',
      caption: 'Installed Häfele soft-close undermount sliders. Verified 90-degree laser squareness on all lower modular boxes.',
      tags: ['#ModularKitchen', '#HafeleHardware', '#LaserAlignment'],
      placeholderGradientStart: Color(0xFF1E3A8A),
      placeholderGradientEnd: Color(0xFF0F172A),
    ),
    SiteFeedMedia(
      id: 'feed_2',
      title: 'Italian Fluted Walnut Panelling Framing',
      zone: 'Living Room',
      timestamp: 'Today, 09:15 AM',
      mediaType: MediaType.photo,
      duration: '4 Photos',
      authorName: 'Rajesh Verma',
      authorRole: 'Site Execution Supervisor',
      caption: 'Bespoke Marine-grade Birch Ply substrate secured with anti-corrosive brass anchor bolts.',
      tags: ['#LivingLounge', '#AcousticPanels', '#WalnutVeneer'],
      placeholderGradientStart: Color(0xFF312E81),
      placeholderGradientEnd: Color(0xFF1E1B4B),
    ),
    SiteFeedMedia(
      id: 'feed_3',
      title: 'Walk-In Wardrobe Dual Concealed Profile Lighting',
      zone: 'Master Bedroom',
      timestamp: 'Yesterday, 4:45 PM',
      mediaType: MediaType.video,
      duration: '1:12 min',
      authorName: 'Rajesh Verma',
      authorRole: 'Site Execution Supervisor',
      caption: 'Continuous 4000K warm white aluminum extrusion LED channels integrated into Italian wardrobe carcass.',
      tags: ['#MasterSuite', '#Wardrobe', '#LEDProfiles'],
      placeholderGradientStart: Color(0xFF4C1D95),
      placeholderGradientEnd: Color(0xFF2E1065),
    ),
    SiteFeedMedia(
      id: 'feed_4',
      title: 'Balcony Deck Ipe Hardwood Sub-Frame Prep',
      zone: 'Balcony',
      timestamp: 'Yesterday, 2:10 PM',
      mediaType: MediaType.photo,
      duration: '3 Photos',
      authorName: 'Amitabh Sen',
      authorRole: 'Site Logistics Coordinator',
      caption: 'High-density rubber pedestals laid for natural rainwater drainage before timber plank fastening.',
      tags: ['#BalconyDeck', '#IpeHardwood', '#Waterproofing'],
      placeholderGradientStart: Color(0xFF064E3B),
      placeholderGradientEnd: Color(0xFF022C22),
    ),
    SiteFeedMedia(
      id: 'feed_5',
      title: 'Island Breakfast Bar Statuario Waterfall Mockup',
      zone: 'Kitchen',
      timestamp: 'Sep 3, 3:30 PM',
      mediaType: MediaType.photo,
      duration: '5 Photos',
      authorName: 'Rajesh Verma',
      authorRole: 'Site Execution Supervisor',
      caption: 'Dry-fit veining alignment of bookmatched marble slabs approved by Senior Designer Pooja Hegde.',
      tags: ['#KitchenIsland', '#StatuarioMarble', '#Bookmatch'],
      placeholderGradientStart: Color(0xFF134E4A),
      placeholderGradientEnd: Color(0xFF042F2E),
    ),
    SiteFeedMedia(
      id: 'feed_6',
      title: 'False Ceiling Shadow Gap & AC Grill Inspection',
      zone: 'Living Room',
      timestamp: 'Sep 2, 11:00 AM',
      mediaType: MediaType.video,
      duration: '0:35 min',
      authorName: 'Rajesh Verma',
      authorRole: 'Site Execution Supervisor',
      caption: '15mm continuous perimeter shadow line verified with acoustic sealant for Daikin VRV linear slots.',
      tags: ['#FalseCeiling', '#ShadowLine', '#VRVSlots'],
      placeholderGradientStart: Color(0xFF1E293B),
      placeholderGradientEnd: Color(0xFF0F172A),
    ),
  ];

  // 4. Stage 5 Quality Verification Checkpoints (docs/requirmenet.md)
  static const List<QualityCheckItem> _qualityChecklist = [
    QualityCheckItem(
      title: 'HDHMR Board Moisture Level < 10.5%',
      category: 'Plywood & Substrates',
      isPassed: true,
      verifiedBy: 'Dr. Neha Kulkarni (QA Auditor)',
      verifiedTime: 'Sep 4, 10:30 AM',
    ),
    QualityCheckItem(
      title: 'Kitchen Carcase 90° Laser Vertical Level',
      category: 'Modular Alignment',
      isPassed: true,
      verifiedBy: 'Rajesh Verma (Supervisor)',
      verifiedTime: 'Sep 4, 02:15 PM',
    ),
    QualityCheckItem(
      title: 'Concealed Water Pressure Test (4.5 Bar 24h)',
      category: 'MEP Inspection',
      isPassed: true,
      verifiedBy: 'Rajesh Verma (Supervisor)',
      verifiedTime: 'Sep 3, 06:00 PM',
    ),
    QualityCheckItem(
      title: 'Anti-Termite & Anti-Fungal Chemical Shield',
      category: 'Protective Treatment',
      isPassed: true,
      verifiedBy: 'Rajesh Verma (Supervisor)',
      verifiedTime: 'Sep 2, 11:30 AM',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isMobile = screenWidth < Breakpoints.compact;

    final filteredFeed = _selectedZone == 'All Zones'
        ? _feedItems
        : _feedItems.where((item) => item.zone == _selectedZone).toList();

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 16.0 : 28.0,
          vertical: 24.0,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: Breakpoints.maxContentWidth),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. EXECUTIVE PROGRESS OVERVIEW HEADER
                _buildHeader(context, isDark, isMobile),

                const SizedBox(height: 20),

                // 2. PHYSICAL SITE VISIT CADENCE & SPRINT STATUS
                _buildSiteCadenceCard(context, isDark, isMobile),

                const SizedBox(height: 24),

                // 3. 8-STAGE CONSTRUCTION MILESTONE TIMELINE
                _buildMilestonePipelineSection(context, isDark, isMobile),

                const SizedBox(height: 24),

                // 4. DAILY INSPECTION PHOTO & VIDEO WALKTHROUGH FEED
                _buildInspectionFeedSection(context, filteredFeed, isDark, isMobile),

                const SizedBox(height: 24),

                // 5. STAGE 5 QUALITY INSPECTION SIGN-OFF CHECKLIST
                _buildQualitySignOffCard(context, isDark, isMobile),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ==========================================================================
  // 1. EXECUTIVE PROGRESS OVERVIEW HEADER
  // ==========================================================================
  Widget _buildHeader(BuildContext context, bool isDark, bool isMobile) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 18.0 : 24.0),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: AppRadius.lg,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.25)
                : const Color(0xFF0F172A).withValues(alpha: 0.03),
            blurRadius: 14,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Project location and status badges
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 6,
            children: [
              Container(
                constraints: BoxConstraints(maxWidth: isMobile ? 260 : 380),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF6366F1).withValues(alpha: 0.1),
                  borderRadius: AppRadius.full,
                  border: Border.all(color: const Color(0xFF6366F1).withValues(alpha: 0.25)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.home_work_outlined, size: 13, color: Color(0xFF6366F1)),
                    const SizedBox(width: 5),
                    Flexible(
                      child: Text(
                        'Skyline Villa Penthouse 402, Worli • 4 BHK Luxury',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF6366F1),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                constraints: BoxConstraints(maxWidth: isMobile ? 260 : 380),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: 0.12),
                  borderRadius: AppRadius.full,
                  border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: Color(0xFF10B981),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        'On Schedule • 0 Days Delay',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF10B981),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Title & Description
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 16,
            runSpacing: 12,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Live Site Progress',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: isMobile ? 22 : 26,
                      fontWeight: FontWeight.w800,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Daily supervisor inspection walkthroughs, physical audit cadence & milestone tracking.',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    ),
                  ),
                ],
              ),

              // Quick Action: Request Physical Site Visit
              ElevatedButton.icon(
                onPressed: () => _showRequestVisitDialog(context, isDark),
                icon: const Icon(Icons.calendar_month_rounded, size: 15, color: Colors.white),
                label: const Text('Request Site Visit'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6366F1),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  textStyle: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 14),

          // Clean Summary Metric Strip
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: [
              _buildHeaderStat('74% Completed', Icons.pie_chart_outline_rounded, isDark, color: const Color(0xFF6366F1)),
              _buildHeaderStat('Stage 5 Active', Icons.handyman_outlined, isDark, color: const Color(0xFF3B82F6)),
              _buildHeaderStat('14 Craftsmen', Icons.groups_outlined, isDark),
              _buildHeaderStat('Audit: Passed', Icons.verified_outlined, isDark, color: const Color(0xFF10B981)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderStat(String label, IconData icon, bool isDark, {Color? color}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color ?? (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
        const SizedBox(width: 6),
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 11.5,
            fontWeight: FontWeight.w600,
            color: color ?? (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
          ),
        ),
      ],
    );
  }

  // ==========================================================================
  // 2. PHYSICAL SITE VISIT CADENCE & ACTIVE SPRINT STATUS
  // ==========================================================================
  Widget _buildSiteCadenceCard(BuildContext context, bool isDark, bool isMobile) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 16.0 : 20.0),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: AppRadius.lg,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withValues(alpha: 0.2) : const Color(0xFF0F172A).withValues(alpha: 0.03),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: const Icon(Icons.assignment_turned_in_outlined, size: 16, color: Color(0xFF10B981)),
                  ),
                  const SizedBox(width: 10),
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: isMobile ? 220 : 380),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Physical Site Inspection & Sprint Cadence',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: isDark ? Colors.white : const Color(0xFF0F172A),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          'Mandatory 10-day physical inspection cycle tracking & Stage 5 active tasks',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w500,
                            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.check_circle_outline_rounded, size: 12, color: Color(0xFF10B981)),
                    const SizedBox(width: 4),
                    Text(
                      '10-Day Policy Compliant',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF10B981),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // 3 Metric Tiles
          LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 650;

              final tiles = [
                _buildCadenceMetricTile(
                  context,
                  isDark: isDark,
                  icon: Icons.calendar_today_rounded,
                  iconColor: const Color(0xFF6366F1),
                  title: 'Last Physical Inspection',
                  value: '4 Days Ago',
                  subtitle: '${_cadenceInfo.lastVisitDate} • ${_cadenceInfo.lastVisitAuthor}',
                ),
                _buildCadenceMetricTile(
                  context,
                  isDark: isDark,
                  icon: Icons.health_and_safety_outlined,
                  iconColor: const Color(0xFF10B981),
                  title: 'Audit Cadence Status',
                  value: 'Healthy (< 10 Days)',
                  subtitle: 'Next recommended visit: before Sep 11, 2026',
                ),
                _buildCadenceMetricTile(
                  context,
                  isDark: isDark,
                  icon: Icons.checklist_rounded,
                  iconColor: const Color(0xFFF59E0B),
                  title: 'Stage 5 Sprint Tasks',
                  value: '${_cadenceInfo.activeSprintCompletedTasks} of ${_cadenceInfo.activeSprintTotalTasks} Done',
                  subtitle: '3 pending in lower cabinet joinery & sealant',
                ),
              ];

              if (isNarrow) {
                return Column(
                  children: tiles.map((t) => Padding(padding: const EdgeInsets.only(bottom: 10), child: t)).toList(),
                );
              }

              return Row(
                children: [
                  Expanded(child: tiles[0]),
                  const SizedBox(width: 12),
                  Expanded(child: tiles[1]),
                  const SizedBox(width: 12),
                  Expanded(child: tiles[2]),
                ],
              );
            },
          ),

          const SizedBox(height: 14),

          // Action Row
          Wrap(
            spacing: 10,
            runSpacing: 8,
            alignment: WrapAlignment.end,
            children: [
              OutlinedButton.icon(
                onPressed: () => _showReportSnagDialog(context, isDark),
                icon: const Icon(Icons.flag_outlined, size: 14, color: Color(0xFFEF4444)),
                label: Text(
                  'Log Site Observation / Snag',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFFEF4444),
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: const Color(0xFFEF4444).withValues(alpha: 0.3)),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => _showRequestVisitDialog(context, isDark),
                icon: const Icon(Icons.add_location_alt_outlined, size: 14, color: Colors.white),
                label: Text(
                  'Request Physical Site Visit',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF10B981),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  elevation: 0,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCadenceMetricTile(
    BuildContext context, {
    required bool isDark,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: iconColor),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 10.5,
              fontWeight: FontWeight.w500,
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // ==========================================================================
  // 3. 8-STAGE CONSTRUCTION MILESTONE TIMELINE
  // ==========================================================================
  Widget _buildMilestonePipelineSection(BuildContext context, bool isDark, bool isMobile) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 16.0 : 20.0),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: AppRadius.lg,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: const Color(0xFF6366F1).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(7),
                ),
                child: const Icon(Icons.timeline_rounded, size: 16, color: Color(0xFF6366F1)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Stage Progression & Timeline Tracker',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '8 turnkey construction milestones from civil demolition to handover',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w500,
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF6366F1).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'Stage 5 of 8 Active',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF6366F1),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Overall Progress Linear Indicator
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Overall Project Execution Progress',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '74% / 100%',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF6366F1),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: 0.74,
                  minHeight: 6,
                  backgroundColor: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                  valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF6366F1)),
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          // Milestones List
          ..._milestones.map((m) {
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
              decoration: BoxDecoration(
                color: m.isInProgress
                    ? const Color(0xFF6366F1).withValues(alpha: 0.06)
                    : (isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC)),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: m.isInProgress
                      ? const Color(0xFF6366F1).withValues(alpha: 0.3)
                      : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                ),
              ),
              child: Row(
                children: [
                  // Stage Status Icon
                  Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: m.isCompleted
                          ? const Color(0xFF10B981)
                          : (m.isInProgress ? const Color(0xFF6366F1) : Colors.grey.withValues(alpha: 0.3)),
                    ),
                    child: Icon(
                      m.isCompleted ? Icons.check_rounded : (m.isInProgress ? Icons.bolt_rounded : Icons.lock_outline_rounded),
                      size: 13,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 10),

                  // Stage Title & Category
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Stage ${m.stageNumber}: ${m.title}',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            fontWeight: m.isInProgress ? FontWeight.w800 : FontWeight.w700,
                            color: isDark ? Colors.white : const Color(0xFF0F172A),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          '${m.category} • ${m.completionDate}',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w500,
                            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 8),

                  // Progress Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                    decoration: BoxDecoration(
                      color: m.isCompleted
                          ? const Color(0xFF10B981).withValues(alpha: 0.1)
                          : (m.isInProgress ? const Color(0xFF6366F1).withValues(alpha: 0.12) : Colors.transparent),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '${m.progressPercent}%',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: m.isCompleted
                            ? const Color(0xFF10B981)
                            : (m.isInProgress ? const Color(0xFF6366F1) : Colors.grey),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  // ==========================================================================
  // 4. DAILY INSPECTION PHOTO & VIDEO WALKTHROUGH FEED
  // ==========================================================================
  Widget _buildInspectionFeedSection(
    BuildContext context,
    List<SiteFeedMedia> feedItems,
    bool isDark,
    bool isMobile,
  ) {
    final zones = ['All Zones', 'Kitchen', 'Living Room', 'Master Bedroom', 'Balcony'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Title & Zone Filters
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 12,
          runSpacing: 8,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Daily Supervisor Inspection Feed',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                ),
                Text(
                  'Walkthrough videos and detailed photo inspection logs uploaded from site',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                ),
              ],
            ),

            // Filter Tabs
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: zones.map((zone) {
                  final isSelected = _selectedZone == zone;
                  return Padding(
                    padding: const EdgeInsets.only(left: 6.0),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _selectedZone = zone;
                        });
                      },
                      borderRadius: BorderRadius.circular(6),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFF6366F1)
                              : (isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9)),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xFF6366F1)
                                : (isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1)),
                          ),
                        ),
                        child: Text(
                          zone,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                            color: isSelected ? Colors.white : (isDark ? Colors.white70 : const Color(0xFF334155)),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Responsive Feed Grid
        LayoutBuilder(
          builder: (context, constraints) {
            int crossAxisCount = 3;
            if (constraints.maxWidth < 680) {
              crossAxisCount = 1;
            } else if (constraints.maxWidth < 1050) {
              crossAxisCount = 2;
            }

            final double cardSpacing = 16.0;
            final double itemWidth = (constraints.maxWidth - (crossAxisCount - 1) * cardSpacing) / crossAxisCount;

            return Wrap(
              spacing: cardSpacing,
              runSpacing: cardSpacing,
              children: feedItems.map((item) {
                return SizedBox(
                  width: itemWidth,
                  child: _buildFeedCard(context, item, isDark),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }

  Widget _buildFeedCard(BuildContext context, SiteFeedMedia item, bool isDark) {
    final isVideo = item.mediaType == MediaType.video;

    return InkWell(
      onTap: () => _showMediaViewerModal(context, item, isDark),
      borderRadius: AppRadius.lg,
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : Colors.white,
          borderRadius: AppRadius.lg,
          border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          ),
          boxShadow: [
            BoxShadow(
              color: isDark ? Colors.black.withValues(alpha: 0.2) : const Color(0xFF0F172A).withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Thumbnail / Media Preview Banner
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [item.placeholderGradientStart, item.placeholderGradientEnd],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Center Play / Photo Icon
                      Center(
                        child: Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.5),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white.withValues(alpha: 0.4), width: 1.5),
                          ),
                          child: Icon(
                            isVideo ? Icons.play_arrow_rounded : Icons.photo_library_outlined,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                      ),

                      // Duration / Photo Count Badge
                      Positioned(
                        bottom: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.7),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            item.duration,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),

                      // Zone Pill
                      Positioned(
                        top: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFF6366F1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            item.zone,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Card Body
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.caption,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11.5,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      height: 1.35,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 10),
                  const Divider(height: 1),
                  const SizedBox(height: 8),

                  // Author and Timestamp
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.person_outline_rounded, size: 12, color: Color(0xFF10B981)),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                item.authorName,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: isDark ? Colors.white70 : const Color(0xFF334155),
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        item.timestamp,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w500,
                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================================
  // 5. STAGE 5 QUALITY INSPECTION SIGN-OFF CHECKLIST
  // ==========================================================================
  Widget _buildQualitySignOffCard(BuildContext context, bool isDark, bool isMobile) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 16.0 : 20.0),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: AppRadius.lg,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(7),
                ),
                child: const Icon(Icons.verified_rounded, size: 16, color: Color(0xFF10B981)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Stage 5 Quality Assurance & Sign-Off Checklist',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      'Mandatory multi-point engineering inspections certified before milestone payment',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w500,
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '4 of 4 Verified',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF10B981),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Quality Items Checklist
          ..._qualityChecklist.map((item) {
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle_rounded, size: 16, color: Color(0xFF10B981)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: isDark ? Colors.white : const Color(0xFF0F172A),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          '${item.category} • Certified by ${item.verifiedBy} (${item.verifiedTime})',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w500,
                            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'PASSED',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF10B981),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),

          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 14),

          // Client Approval & Snag Action Bar (docs/requirmenet.md: WORK APPROVAL REQUEST & COMPLAINTS RAISED)
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: _isStage5Approved
                  ? const Color(0xFF10B981).withValues(alpha: 0.1)
                  : (isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9)),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: _isStage5Approved
                    ? const Color(0xFF10B981).withValues(alpha: 0.3)
                    : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      _isStage5Approved ? Icons.verified_rounded : Icons.pending_actions_rounded,
                      size: 16,
                      color: _isStage5Approved ? const Color(0xFF10B981) : const Color(0xFF6366F1),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _isStage5Approved
                            ? 'Stage 5 Milestone Approved & Certified by Client'
                            : 'Client Milestone Sign-Off (Stage 5)',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (_isStage5Approved)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          'DIGITALLY SIGNED',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 9.5,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  _isStage5Approved
                      ? 'Digital sign-off registered on Sep 5, 2026. Authorization granted for Stage 6 surface priming and luxury PU polish release.'
                      : 'All 4 technical checks have passed supervisor inspection. Review the daily feed and sign off to authorise Stage 6.',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w500,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                ),
                if (!_isStage5Approved) ...[
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    runSpacing: 8,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () => _showDigitalSignOffDialog(context, isDark),
                        icon: const Icon(Icons.draw_rounded, size: 14, color: Colors.white),
                        label: Text(
                          'Approve & Sign Stage 5',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6366F1),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
                          elevation: 0,
                        ),
                      ),
                      OutlinedButton.icon(
                        onPressed: () => _showReportSnagDialog(context, isDark),
                        icon: const Icon(Icons.report_problem_outlined, size: 14, color: Color(0xFFEF4444)),
                        label: Text(
                          'Raise a Snag / Observation',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFFEF4444),
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: const Color(0xFFEF4444).withValues(alpha: 0.3)),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================================
  // MODAL 1: MEDIA VIEWER PREVIEW
  // ==========================================================================
  void _showMediaViewerModal(BuildContext context, SiteFeedMedia item, bool isDark) {
    showDialog(
      context: context,
      builder: (ctx) {
        return Dialog(
          backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 650),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 14.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          item.title,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: isDark ? Colors.white : const Color(0xFF0F172A),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(ctx).pop(),
                        icon: const Icon(Icons.close_rounded, size: 20),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                ),

                // Media Preview Screen
                AspectRatio(
                  aspectRatio: 16 / 10,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [item.placeholderGradientStart, item.placeholderGradientEnd],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            item.mediaType == MediaType.video ? Icons.play_circle_fill_rounded : Icons.photo_size_select_actual_rounded,
                            size: 64,
                            color: Colors.white70,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            item.duration,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Note & Details
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: const Color(0xFF6366F1).withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'Zone: ${item.zone}',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF6366F1),
                              ),
                            ),
                          ),
                          Text(
                            item.timestamp,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        item.caption,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12.5,
                          color: isDark ? Colors.white70 : const Color(0xFF334155),
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: item.tags.map((tag) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                            decoration: BoxDecoration(
                              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              tag,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w600,
                                color: isDark ? Colors.white60 : const Color(0xFF64748B),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ==========================================================================
  // MODAL 2: REQUEST PHYSICAL SITE VISIT
  // ==========================================================================
  void _showRequestVisitDialog(BuildContext context, bool isDark) {
    String selectedSlot = 'Morning (10:30 AM – 12:30 PM)';
    final noteController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (dialogCtx, setDialogState) {
            return Dialog(
              backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: Padding(
                  padding: const EdgeInsets.all(22.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Request Physical Site Visit',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w800,
                                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Accompanied by Site Supervisor Rajesh Verma',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 11.5,
                                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: () => Navigator.of(ctx).pop(),
                              icon: const Icon(Icons.close_rounded, size: 20),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),
                        const Divider(height: 1),
                        const SizedBox(height: 16),

                        Text(
                          'Select Preferred Time Slot',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w700,
                            color: isDark ? Colors.white : const Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 8),

                        ...[
                          'Morning (10:30 AM – 12:30 PM)',
                          'Afternoon (02:30 PM – 04:30 PM)',
                          'Evening (05:00 PM – 06:30 PM)',
                        ].map((slot) {
                          final isSelected = selectedSlot == slot;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 6.0),
                            child: InkWell(
                              onTap: () => setDialogState(() => selectedSlot = slot),
                              borderRadius: BorderRadius.circular(8),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? const Color(0xFF6366F1).withValues(alpha: 0.12)
                                      : (isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC)),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: isSelected
                                        ? const Color(0xFF6366F1)
                                        : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      isSelected ? Icons.radio_button_checked_rounded : Icons.radio_button_off_rounded,
                                      size: 16,
                                      color: isSelected ? const Color(0xFF6366F1) : Colors.grey,
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        slot,
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 12,
                                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),

                        const SizedBox(height: 12),

                        Text(
                          'Specific Focus or Snag to Inspect (Optional)',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w700,
                            color: isDark ? Colors.white : const Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 6),
                        TextField(
                          controller: noteController,
                          maxLines: 2,
                          style: GoogleFonts.plusJakartaSans(fontSize: 12),
                          decoration: InputDecoration(
                            hintText: 'e.g., Modular kitchen carcase inspection or marble polish...',
                            hintStyle: GoogleFonts.plusJakartaSans(fontSize: 11.5, color: Colors.grey),
                            filled: true,
                            fillColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 18),

                        // Actions
                        Wrap(
                          alignment: WrapAlignment.end,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            TextButton(
                              onPressed: () => Navigator.of(ctx).pop(),
                              child: Text(
                                'Cancel',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(ctx).pop();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Site visit requested for $selectedSlot. Supervisor notified!'),
                                    backgroundColor: const Color(0xFF10B981),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF6366F1),
                                foregroundColor: Colors.white,
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              child: Text(
                                'Confirm Visit Request',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // ==========================================================================
  // MODAL 3: DIGITAL MILESTONE SIGN-OFF DIALOG
  // ==========================================================================
  void _showDigitalSignOffDialog(BuildContext context, bool isDark) {
    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (dialogCtx, setDialogState) {
            return Dialog(
              backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520),
                child: Padding(
                  padding: const EdgeInsets.all(22.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFF6366F1).withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.draw_rounded, color: Color(0xFF6366F1), size: 18),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Approve Stage 5 Milestone',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                                  ),
                                ),
                                Text(
                                  'Bespoke Joinery & Modular Kitchen Sign-Off',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 12,
                                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, size: 18),
                            onPressed: () => Navigator.of(ctx).pop(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'VERIFIED INSPECTION SUMMARY',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF6366F1),
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 8),
                            _buildSignOffBullet('4 of 4 Multi-Point Quality Checks Passed (Verified by Rajesh Verma)'),
                            _buildSignOffBullet('HDHMR Board Moisture Level certified at 8.2% (< 10.5% standard)'),
                            _buildSignOffBullet('Zero open critical snags or alignment flaws logged'),
                            _buildSignOffBullet('Authorizes commencement of Stage 6: Surface Priming & PU Polish'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        'By confirming, your digital stamp will be recorded in the project ledger and a milestone sign-off certificate will be generated.',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w500,
                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Wrap(
                        alignment: WrapAlignment.end,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.of(ctx).pop(),
                            child: Text(
                              'Review More',
                              style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(ctx).pop();
                              setState(() {
                                _isStage5Approved = true;
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Stage 5 Milestone approved and digitally certified!'),
                                  backgroundColor: Color(0xFF10B981),
                                  duration: Duration(seconds: 3),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF6366F1),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            child: Text(
                              'Confirm & Sign Digitally',
                              style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSignOffBullet(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle_rounded, size: 14, color: Color(0xFF10B981)),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.plusJakartaSans(fontSize: 11.5, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================================
  // MODAL 4: REPORT SITE SNAG / OBSERVATION DIALOG
  // ==========================================================================
  void _showReportSnagDialog(BuildContext context, bool isDark) {
    final descController = TextEditingController();
    String selectedCategory = 'Joinery / Alignment';

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (dialogCtx, setDialogState) {
            return Dialog(
              backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520),
                child: Padding(
                  padding: const EdgeInsets.all(22.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEF4444).withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.flag_outlined, color: Color(0xFFEF4444), size: 18),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Report Site Snag / Observation',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                                  ),
                                ),
                                Text(
                                  'Direct ticket dispatched to Site Supervisor Rajesh Verma',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 12,
                                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, size: 18),
                            onPressed: () => Navigator.of(ctx).pop(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Category',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 8,
                        runSpacing: 6,
                        children: [
                          'Joinery / Alignment',
                          'Surface Scratch / Polish',
                          'Electrical / MEP',
                          'Dimension Variance',
                        ].map((cat) {
                          final isSelected = selectedCategory == cat;
                          return ChoiceChip(
                            label: Text(cat),
                            selected: isSelected,
                            onSelected: (val) {
                              setDialogState(() {
                                selectedCategory = cat;
                              });
                            },
                            labelStyle: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                              color: isSelected
                                  ? Colors.white
                                  : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                            ),
                            selectedColor: const Color(0xFFEF4444),
                            backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        'Observation Details',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextField(
                        controller: descController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          hintText: 'Describe the issue or observation noted in daily photos/site visit...',
                          hintStyle: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                          ),
                          filled: true,
                          fillColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                            ),
                          ),
                          contentPadding: const EdgeInsets.all(12),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Wrap(
                        alignment: WrapAlignment.end,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.of(ctx).pop(),
                            child: Text(
                              'Cancel',
                              style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(ctx).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Site snag ticket #SG-402 logged! Supervisor notified.'),
                                  backgroundColor: Color(0xFFEF4444),
                                  duration: Duration(seconds: 3),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFEF4444),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            child: Text(
                              'Submit Snag Ticket',
                              style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
