import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/responsive/breakpoints.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';

// ============================================================================
// DOMAIN MODELS & ENUMS
// ============================================================================

enum DepartmentCategory {
  all,
  leadership,
  design,
  execution,
  quality,
}

enum TeamMemberDutyStatus {
  available,
  onSite,
  inStudio,
}

extension TeamMemberDutyStatusX on TeamMemberDutyStatus {
  String get label {
    switch (this) {
      case TeamMemberDutyStatus.available:
        return 'Available';
      case TeamMemberDutyStatus.onSite:
        return 'Active On-Site';
      case TeamMemberDutyStatus.inStudio:
        return 'In Studio';
    }
  }

  Color get color {
    switch (this) {
      case TeamMemberDutyStatus.available:
        return const Color(0xFF10B981); // Emerald
      case TeamMemberDutyStatus.onSite:
        return const Color(0xFF3B82F6); // Blue
      case TeamMemberDutyStatus.inStudio:
        return const Color(0xFFF59E0B); // Amber
    }
  }

  IconData get icon {
    switch (this) {
      case TeamMemberDutyStatus.available:
        return Icons.check_circle_outline_rounded;
      case TeamMemberDutyStatus.onSite:
        return Icons.location_on_outlined;
      case TeamMemberDutyStatus.inStudio:
        return Icons.palette_outlined;
    }
  }
}

class TeamMember {
  final String id;
  final String name;
  final String role;
  final DepartmentCategory department;
  final String departmentLabel;
  final String initials;
  final Color avatarColor;
  final TeamMemberDutyStatus status;
  final int experienceYears;
  final int completedProjects;
  final double rating;
  final int reviewCount;
  final String phoneNumber;
  final String whatsappNumber;
  final String email;
  final String qualification;
  final List<String> coreResponsibilities;
  final String activeFocus;
  final String onSiteSchedule;

  const TeamMember({
    required this.id,
    required this.name,
    required this.role,
    required this.department,
    required this.departmentLabel,
    required this.initials,
    required this.avatarColor,
    required this.status,
    required this.experienceYears,
    required this.completedProjects,
    required this.rating,
    required this.reviewCount,
    required this.phoneNumber,
    required this.whatsappNumber,
    required this.email,
    required this.qualification,
    required this.coreResponsibilities,
    required this.activeFocus,
    required this.onSiteSchedule,
  });
}

class EscalationTier {
  final int level;
  final String title;
  final String role;
  final String name;
  final String sla;
  final String scope;
  final String phoneNumber;
  final Color badgeColor;

  const EscalationTier({
    required this.level,
    required this.title,
    required this.role,
    required this.name,
    required this.sla,
    required this.scope,
    required this.phoneNumber,
    required this.badgeColor,
  });
}

class WeeklyEvaluationScores {
  final double qualityScore;
  final double timelineScore;
  final double behaviourScore;
  final String clientNote;
  final DateTime updatedAt;

  const WeeklyEvaluationScores({
    required this.qualityScore,
    required this.timelineScore,
    required this.behaviourScore,
    required this.clientNote,
    required this.updatedAt,
  });

  double get averageScore =>
      ((qualityScore + timelineScore + behaviourScore) / 3);
}

// ============================================================================
// MAIN PAGE WIDGET: ASSIGNED TEAM
// ============================================================================

class ClientAssignedTeamPage extends StatefulWidget {
  const ClientAssignedTeamPage({super.key});

  @override
  State<ClientAssignedTeamPage> createState() => _ClientAssignedTeamPageState();
}

class _ClientAssignedTeamPageState extends State<ClientAssignedTeamPage> {
  DepartmentCategory _selectedDepartment = DepartmentCategory.all;

  // Evaluation scores state (satisfying docs/requirmenet.md 3 dimensions)
  WeeklyEvaluationScores _currentScores = WeeklyEvaluationScores(
    qualityScore: 9.8,
    timelineScore: 9.4,
    behaviourScore: 9.9,
    clientNote: 'Exceptional craftsmanship and smooth weekly coordination.',
    updatedAt: DateTime(2026, 9, 5),
  );

  // Dedicated project team assigned to client's residence
  static const List<TeamMember> _teamMembers = [
    TeamMember(
      id: 'tm_1',
      name: 'Vikram Malhotra',
      role: 'Senior Project Manager',
      department: DepartmentCategory.leadership,
      departmentLabel: 'Project Leadership',
      initials: 'VM',
      avatarColor: Color(0xFF6366F1),
      status: TeamMemberDutyStatus.available,
      experienceYears: 10,
      completedProjects: 52,
      rating: 4.97,
      reviewCount: 48,
      phoneNumber: '+91 98201 44521',
      whatsappNumber: '+91 98201 44521',
      email: 'vikram.m@homio.in',
      qualification: 'B.Arch • PMP® Certified',
      coreResponsibilities: [
        'Single point of contact for project governance & milestone tracking',
        'Weekly review calls, budget adherence & contractor management',
      ],
      activeFocus: 'Coordinating Stage 5 Modular Kitchen joinery & marble arrival',
      onSiteSchedule: 'On-Site Tue & Fri • Client Call Weekly Wednesdays',
    ),
    TeamMember(
      id: 'tm_2',
      name: 'Pooja Hegde',
      role: 'Principal Interior Designer',
      department: DepartmentCategory.design,
      departmentLabel: 'Design & Architecture',
      initials: 'PH',
      avatarColor: Color(0xFFEC4899),
      status: TeamMemberDutyStatus.inStudio,
      experienceYears: 8,
      completedProjects: 38,
      rating: 4.94,
      reviewCount: 35,
      phoneNumber: '+91 98203 11842',
      whatsappNumber: '+91 98203 11842',
      email: 'pooja.h@homio.in',
      qualification: 'M.Des (NID) • IIID Member',
      coreResponsibilities: [
        'Design aesthetics, 3D corrections, color palette & lighting selection',
        'Italian marble veneer matching and custom furniture details',
      ],
      activeFocus: 'Master Bedroom walk-in closet accent lighting schema',
      onSiteSchedule: 'Design Studio Mon-Sat • Site Walkthrough Thu 3 PM',
    ),
    TeamMember(
      id: 'tm_3',
      name: 'Rajesh Verma',
      role: 'Site Execution Supervisor',
      department: DepartmentCategory.execution,
      departmentLabel: 'Site Execution',
      initials: 'RV',
      avatarColor: Color(0xFF10B981),
      status: TeamMemberDutyStatus.onSite,
      experienceYears: 12,
      completedProjects: 65,
      rating: 4.91,
      reviewCount: 59,
      phoneNumber: '+91 98190 77319',
      whatsappNumber: '+91 98190 77319',
      email: 'rajesh.v@homio.in',
      qualification: 'B.Tech Civil • Safety Certified',
      coreResponsibilities: [
        'Daily on-site supervision of master carpenters, plumbers & electricians',
        'Daily photo/video log submissions and material quality inspection',
      ],
      activeFocus: 'Kitchen plumbing pressure tests & plywood moisture inspection',
      onSiteSchedule: 'Full-time On-Site Mon to Sat (9:00 AM – 6:30 PM)',
    ),
    TeamMember(
      id: 'tm_4',
      name: 'Rohan Deshpande',
      role: 'Lead 3D Visualizer & CAD Specialist',
      department: DepartmentCategory.design,
      departmentLabel: 'Design & Architecture',
      initials: 'RD',
      avatarColor: Color(0xFF8B5CF6),
      status: TeamMemberDutyStatus.inStudio,
      experienceYears: 6,
      completedProjects: 44,
      rating: 4.95,
      reviewCount: 40,
      phoneNumber: '+91 98205 66723',
      whatsappNumber: '+91 98205 66723',
      email: 'rohan.d@homio.in',
      qualification: 'B.Voc Interior CAD • Autodesk Certified',
      coreResponsibilities: [
        'Photorealistic 3D walkthroughs, lighting simulations & CAD drawings',
        '24-hour turnaround for client material & finish change requests',
      ],
      activeFocus: 'Balcony deck lounge 4K photorealistic lighting render',
      onSiteSchedule: 'Studio based • Attends design walkthroughs',
    ),
    TeamMember(
      id: 'tm_5',
      name: 'Amitabh Sen',
      role: 'Site Logistics Coordinator',
      department: DepartmentCategory.execution,
      departmentLabel: 'Site Execution',
      initials: 'AS',
      avatarColor: Color(0xFF0EA5E9),
      status: TeamMemberDutyStatus.onSite,
      experienceYears: 5,
      completedProjects: 26,
      rating: 4.88,
      reviewCount: 22,
      phoneNumber: '+91 98208 99144',
      whatsappNumber: '+91 98208 99144',
      email: 'amitabh.s@homio.in',
      qualification: 'Diploma Construction Tech',
      coreResponsibilities: [
        'Material dispatch logistics, vendor supply tracking & inventory logs',
        'Daily evening site video recording & portal upload',
      ],
      activeFocus: 'Receiving German hardware consignment & plywood transit',
      onSiteSchedule: 'Daily site visits & transit checkpoints',
    ),
    TeamMember(
      id: 'tm_6',
      name: 'Dr. Neha Kulkarni',
      role: 'Quality & Vastu Auditor',
      department: DepartmentCategory.quality,
      departmentLabel: 'Quality & Handover',
      initials: 'NK',
      avatarColor: Color(0xFFF59E0B),
      status: TeamMemberDutyStatus.available,
      experienceYears: 14,
      completedProjects: 85,
      rating: 4.99,
      reviewCount: 78,
      phoneNumber: '+91 98200 44102',
      whatsappNumber: '+91 98200 44102',
      email: 'dr.neha@homio.in',
      qualification: 'Ph.D. Architecture & Vastu Shastra',
      coreResponsibilities: [
        'Multi-point quality compliance audits at every milestone stage',
        'Vastu energy directional alignment & snag clearance certifications',
      ],
      activeFocus: 'Milestone 5 pre-installation acoustic & Vastu audit',
      onSiteSchedule: 'Milestone audit visits & bi-weekly client consultation',
    ),
  ];

  static const List<EscalationTier> _escalationTiers = [
    EscalationTier(
      level: 1,
      title: 'Level 1: Immediate On-Site Action',
      role: 'Site Execution Supervisor',
      name: 'Rajesh Verma',
      sla: '< 2 Hours',
      scope: 'On-site execution, labour issues, daily work snags',
      phoneNumber: '+91 98190 77319',
      badgeColor: Color(0xFF10B981),
    ),
    EscalationTier(
      level: 2,
      title: 'Level 2: Project Management',
      role: 'Senior Project Manager',
      name: 'Vikram Malhotra',
      sla: '< 6 Hours',
      scope: 'Timeline, design coordination, bill approvals',
      phoneNumber: '+91 98201 44521',
      badgeColor: Color(0xFF6366F1),
    ),
    EscalationTier(
      level: 4,
      title: 'Level 4: Client Ombudsman Hotline',
      role: 'Homio Grievance Redressal',
      name: 'Client Ombudsman Desk',
      sla: 'Immediate Priority',
      scope: 'Executive escalation & direct leadership assistance',
      phoneNumber: '1800-419-HOMIO',
      badgeColor: Color(0xFFEF4444),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isMobile = screenWidth < Breakpoints.compact;

    final filteredMembers = _selectedDepartment == DepartmentCategory.all
        ? _teamMembers
        : _teamMembers.where((m) => m.department == _selectedDepartment).toList();

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
                // 1. CLEAN HEADER (Assigned Team focus, no booking noise)
                _buildCleanHeader(context, isDark, isMobile),

                const SizedBox(height: 20),

                // 2. WEEKLY PERFORMANCE EVALUATION (docs/requirmenet.md 3 pillars)
                _buildWeeklyEvaluationCard(context, isDark, isMobile),

                const SizedBox(height: 20),

                // 3. CLEAN DEPARTMENT FILTER TABS
                _buildFilterTabs(isDark),

                const SizedBox(height: 18),

                // 4. CLEAN TEAM MEMBERS GRID (Clean cards, direct contact actions)
                _buildTeamGrid(filteredMembers, isDark),

                const SizedBox(height: 24),

                // 5. CLEAN DIRECT ESCALATION HOTLINE
                _buildEscalationSection(context, isDark, isMobile),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ==========================================================================
  // SECTION 1: CLEAN HEADER
  // ==========================================================================
  Widget _buildCleanHeader(BuildContext context, bool isDark, bool isMobile) {
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
          // Project badge
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 6,
            children: [
              Container(
                constraints: BoxConstraints(maxWidth: isMobile ? 290 : 380),
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
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: 0.1),
                  borderRadius: AppRadius.full,
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
                    const SizedBox(width: 5),
                    Text(
                      'Team Active',
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

          const SizedBox(height: 14),

          // Title & Quick description
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
                    'Assigned Team',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: isMobile ? 22 : 26,
                      fontWeight: FontWeight.w800,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Your dedicated turnkey interior delivery specialists assigned to your residence.',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    ),
                  ),
                ],
              ),

              // Action button to rate team
              OutlinedButton.icon(
                onPressed: () => _showWeeklyFeedbackModal(context, isDark),
                icon: const Icon(Icons.star_rate_rounded, size: 16, color: Color(0xFFF59E0B)),
                label: const Text('Rate Your Team'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: isDark ? Colors.white : const Color(0xFF0F172A),
                  side: BorderSide(
                    color: isDark ? const Color(0xFF475569) : const Color(0xFFCBD5E1),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  textStyle: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 14),

          // Clean Summary Metric Strip
          Wrap(
            spacing: 24,
            runSpacing: 8,
            children: [
              _buildHeaderStat('6 Specialists', Icons.people_outline_rounded, isDark),
              _buildHeaderStat('4.97 ★ Team Rating', Icons.star_outline_rounded, isDark, color: const Color(0xFFF59E0B)),
              _buildHeaderStat('Daily On-Site Supervision', Icons.verified_outlined, isDark, color: const Color(0xFF10B981)),
              _buildHeaderStat('Mon–Sat • 9:30 AM – 7:00 PM', Icons.access_time_rounded, isDark),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderStat(String label, IconData icon, bool isDark, {Color? color}) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 300),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color ?? (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
                color: color ?? (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================================
  // SECTION 2: CLEAN WEEKLY EVALUATION SCORECARD (docs/requirmenet.md)
  // ==========================================================================
  Widget _buildWeeklyEvaluationCard(BuildContext context, bool isDark, bool isMobile) {
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
                child: const Icon(Icons.analytics_outlined, size: 16, color: Color(0xFF6366F1)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Weekly Team Evaluation',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '3 performance dimensions',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
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
                  '${_currentScores.averageScore.toStringAsFixed(1)} / 10 • Grade A+',
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

          // 3 Evaluation Pillar bars (Design Quality, On-Time Work, Behaviour)
          LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 650;
              final tiles = [
                _buildCleanScoreTile('Design Quality', _currentScores.qualityScore, const Color(0xFF6366F1), isDark),
                _buildCleanScoreTile('On-Time Execution', _currentScores.timelineScore, const Color(0xFF3B82F6), isDark),
                _buildCleanScoreTile('Professional Behaviour', _currentScores.behaviourScore, const Color(0xFF10B981), isDark),
              ];

              if (isNarrow) {
                return Column(
                  children: tiles.map((t) => Padding(padding: const EdgeInsets.only(bottom: 8.0), child: t)).toList(),
                );
              }

              return Row(
                children: tiles
                    .map((t) => Expanded(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 4.0), child: t)))
                    .toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCleanScoreTile(String title, double score, Color color, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
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
              const SizedBox(width: 6),
              Text(
                '${score.toStringAsFixed(1)} / 10',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: (score / 10).clamp(0.0, 1.0),
              minHeight: 5,
              backgroundColor: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================================
  // SECTION 3: CLEAN FILTER TABS
  // ==========================================================================
  Widget _buildFilterTabs(bool isDark) {
    final filters = [
      (DepartmentCategory.all, 'All Stakeholders', _teamMembers.length),
      (DepartmentCategory.leadership, 'Project Leadership', _teamMembers.where((m) => m.department == DepartmentCategory.leadership).length),
      (DepartmentCategory.design, 'Design & 3D', _teamMembers.where((m) => m.department == DepartmentCategory.design).length),
      (DepartmentCategory.execution, 'Site Execution', _teamMembers.where((m) => m.department == DepartmentCategory.execution).length),
      (DepartmentCategory.quality, 'Quality & Handover', _teamMembers.where((m) => m.department == DepartmentCategory.quality).length),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: filters.map((f) {
          final isSelected = _selectedDepartment == f.$1;
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: InkWell(
              onTap: () {
                setState(() {
                  _selectedDepartment = f.$1;
                });
              },
              borderRadius: BorderRadius.circular(8),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF6366F1)
                      : (isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9)),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF6366F1)
                        : (isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1)),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      f.$2,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                        color: isSelected
                            ? Colors.white
                            : (isDark ? AppColors.darkTextPrimary : const Color(0xFF334155)),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.white.withValues(alpha: 0.25)
                            : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                        borderRadius: AppRadius.full,
                      ),
                      child: Text(
                        '${f.$3}',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: isSelected
                              ? Colors.white
                              : (isDark ? AppColors.darkTextSecondary : const Color(0xFF64748B)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ==========================================================================
  // SECTION 4: CLEAN TEAM MEMBERS GRID (Clean cards, direct contact actions)
  // ==========================================================================
  Widget _buildTeamGrid(List<TeamMember> members, bool isDark) {
    return LayoutBuilder(
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
          children: members.map((member) {
            return SizedBox(
              width: itemWidth,
              child: _buildCleanMemberCard(context, member, isDark),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildCleanMemberCard(BuildContext context, TeamMember member, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: AppRadius.lg,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.2)
                : const Color(0xFF0F172A).withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Card Upper Body
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Row: Avatar + Name & Designation + Status Badge
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Avatar
                    Stack(
                      children: [
                        Container(
                          width: 46,
                          height: 46,
                          decoration: BoxDecoration(
                            color: member.avatarColor.withValues(alpha: 0.12),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: member.avatarColor.withValues(alpha: 0.35),
                              width: 1.5,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              member.initials,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: member.avatarColor,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: member.status.color,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isDark ? AppColors.darkSurface : Colors.white,
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 12),

                    // Name and Role
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  member.name,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(Icons.verified_rounded, size: 14, color: Color(0xFF6366F1)),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            member.role,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: member.avatarColor,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Clean Stats Bar with Wrap to prevent overflow on any width
                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 8,
                  runSpacing: 6,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: member.status.color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(member.status.icon, size: 11, color: member.status.color),
                          const SizedBox(width: 4),
                          Text(
                            member.status.label,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w700,
                              color: member.status.color,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '${member.experienceYears}y exp • ${member.completedProjects} projects',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // Current Active Focus (1 clean line)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.flag_outlined, size: 12, color: Color(0xFF6366F1)),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          member.activeFocus,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: isDark ? Colors.white70 : const Color(0xFF334155),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Card Action Bar: Direct 1-Click WhatsApp and Call buttons
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B).withValues(alpha: 0.6) : const Color(0xFFF8FAFC),
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
              border: Border(
                top: BorderSide(
                  color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                ),
              ),
            ),
            child: Row(
              children: [
                // WhatsApp Button
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Opening WhatsApp Chat with ${member.name} (${member.whatsappNumber})...'),
                          backgroundColor: const Color(0xFF10B981),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    icon: const Icon(Icons.chat_bubble_outline_rounded, size: 13, color: Color(0xFF10B981)),
                    label: const Text('WhatsApp'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF10B981),
                      side: const BorderSide(color: Color(0xFF10B981)),
                      padding: const EdgeInsets.symmetric(vertical: 7),
                      textStyle: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                // Call Button
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Calling ${member.name}: ${member.phoneNumber}'),
                          backgroundColor: const Color(0xFF3B82F6),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    icon: const Icon(Icons.phone_in_talk_rounded, size: 13),
                    label: const Text('Call'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: isDark ? Colors.white : const Color(0xFF0F172A),
                      side: BorderSide(
                        color: isDark ? const Color(0xFF475569) : const Color(0xFFCBD5E1),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 7),
                      textStyle: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================================
  // SECTION 5: CLEAN DIRECT ESCALATION HOTLINE
  // ==========================================================================
  Widget _buildEscalationSection(BuildContext context, bool isDark, bool isMobile) {
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
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFFEF4444).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(Icons.shield_outlined, size: 15, color: Color(0xFFEF4444)),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Direct SLA Escalation Desk',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w800,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Guaranteed Response SLAs',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFEF4444),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Escalation Tiers in clean horizontal/vertical arrangement
          LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 750;
              final tierWidgets = _escalationTiers.map((tier) {
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              tier.title,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w800,
                                color: tier.badgeColor,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: tier.badgeColor.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              tier.sla,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: tier.badgeColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${tier.name} • ${tier.role}',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        tier.scope,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w500,
                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      InkWell(
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Direct escalation to ${tier.name}: ${tier.phoneNumber}'),
                              backgroundColor: tier.badgeColor,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.phone_in_talk_rounded, size: 12, color: tier.badgeColor),
                            const SizedBox(width: 4),
                            Text(
                              tier.phoneNumber,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: tier.badgeColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList();

              if (isNarrow) {
                return Column(
                  children: tierWidgets.map((w) => Padding(padding: const EdgeInsets.only(bottom: 8.0), child: w)).toList(),
                );
              }

              return Row(
                children: tierWidgets
                    .map((w) => Expanded(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 4.0), child: w)))
                    .toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  // ==========================================================================
  // MODAL: SUBMIT WEEKLY FEEDBACK
  // ==========================================================================
  void _showWeeklyFeedbackModal(BuildContext context, bool isDark) {
    double tempQuality = _currentScores.qualityScore;
    double tempTimeline = _currentScores.timelineScore;
    double tempBehaviour = _currentScores.behaviourScore;
    final noteController = TextEditingController(text: _currentScores.clientNote);

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (dialogContext, setDialogState) {
            final avg = (tempQuality + tempTimeline + tempBehaviour) / 3;

            return Dialog(
              backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500),
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
                                    'Weekly Team Evaluation',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800,
                                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Rate your dedicated team performance this week',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 12,
                                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                    ),
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

                        // Dimension 1: Design & Workmanship Quality
                        _buildSliderRatingRow(
                          title: '1. Design & Workmanship Quality',
                          value: tempQuality,
                          color: const Color(0xFF6366F1),
                          isDark: isDark,
                          onChanged: (val) {
                            setDialogState(() => tempQuality = val);
                          },
                        ),

                        const SizedBox(height: 14),

                        // Dimension 2: On-Time Execution & Attendance
                        _buildSliderRatingRow(
                          title: '2. On-Time Execution & Timeline',
                          value: tempTimeline,
                          color: const Color(0xFF3B82F6),
                          isDark: isDark,
                          onChanged: (val) {
                            setDialogState(() => tempTimeline = val);
                          },
                        ),

                        const SizedBox(height: 14),

                        // Dimension 3: Professional Behaviour & Clarity
                        _buildSliderRatingRow(
                          title: '3. Professional Behaviour & Communication',
                          value: tempBehaviour,
                          color: const Color(0xFF10B981),
                          isDark: isDark,
                          onChanged: (val) {
                            setDialogState(() => tempBehaviour = val);
                          },
                        ),

                        const SizedBox(height: 16),

                        // Overall Computed Average
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: const Color(0xFF10B981).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.3)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Overall Score:',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w700,
                                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                                ),
                              ),
                              Text(
                                '${avg.toStringAsFixed(1)} / 10',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                  color: const Color(0xFF10B981),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 14),

                        // Client Remarks Field
                        Text(
                          'Comments / Specific Observations (Optional)',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                          ),
                        ),
                        const SizedBox(height: 6),
                        TextField(
                          controller: noteController,
                          maxLines: 2,
                          style: GoogleFonts.plusJakartaSans(fontSize: 12),
                          decoration: InputDecoration(
                            hintText: 'Share any commendation or point of attention...',
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
                                setState(() {
                                  _currentScores = WeeklyEvaluationScores(
                                    qualityScore: tempQuality,
                                    timelineScore: tempTimeline,
                                    behaviourScore: tempBehaviour,
                                    clientNote: noteController.text.trim(),
                                    updatedAt: DateTime.now(),
                                  );
                                });
                                Navigator.of(ctx).pop();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Weekly evaluation successfully logged. Thank you!'),
                                    backgroundColor: Color(0xFF10B981),
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
                                'Submit Official Weekly Rating',
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

  Widget _buildSliderRatingRow({
    required String title,
    required double value,
    required Color color,
    required bool isDark,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '${value.toStringAsFixed(1)} / 10',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
          ],
        ),
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: color,
            inactiveTrackColor: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
            thumbColor: color,
            overlayColor: color.withValues(alpha: 0.15),
            trackHeight: 4,
          ),
          child: Slider(
            value: value,
            min: 5.0,
            max: 10.0,
            divisions: 50,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
