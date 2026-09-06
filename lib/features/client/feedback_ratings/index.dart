import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/responsive/breakpoints.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';

// ============================================================================
// DOMAIN MODELS & DATA
// ============================================================================

class MilestoneRating {
  final String id;
  final String stageName;
  final String completedDate;
  final double overallScore;
  final double designScore;
  final double executionScore;
  final double supervisorScore;
  final double materialScore;
  final String clientReview;
  final List<String> praiseTags;
  final String supervisorName;
  final String designerName;
  final String status;

  const MilestoneRating({
    required this.id,
    required this.stageName,
    required this.completedDate,
    required this.overallScore,
    required this.designScore,
    required this.executionScore,
    required this.supervisorScore,
    required this.materialScore,
    required this.clientReview,
    required this.praiseTags,
    required this.supervisorName,
    required this.designerName,
    this.status = 'Verified Sign-off',
  });
}

class SpecialistScorecard {
  final String id;
  final String name;
  final String role;
  final Color avatarColor;
  final String initials;
  double score;
  int reviewsCount;
  final String topPraise;
  final Map<String, double> parameters;

  SpecialistScorecard({
    required this.id,
    required this.name,
    required this.role,
    required this.avatarColor,
    required this.initials,
    required this.score,
    required this.reviewsCount,
    required this.topPraise,
    required this.parameters,
  });
}

class WeeklyCsatLog {
  final String weekLabel;
  final String date;
  final double score;
  final String mood;
  final Color moodColor;
  final String comment;
  final String channel;

  const WeeklyCsatLog({
    required this.weekLabel,
    required this.date,
    required this.score,
    required this.mood,
    required this.moodColor,
    required this.comment,
    this.channel = 'Automated WhatsApp Friday Pulse',
  });
}

// ============================================================================
// MAIN PAGE WIDGET
// ============================================================================

class ClientFeedbackRatingsPage extends StatefulWidget {
  const ClientFeedbackRatingsPage({super.key});

  @override
  State<ClientFeedbackRatingsPage> createState() =>
      _ClientFeedbackRatingsPageState();
}

class _ClientFeedbackRatingsPageState extends State<ClientFeedbackRatingsPage> {
  String _selectedTab = 'Milestone Reviews';

  // Seeded Milestone Reviews
  late final List<MilestoneRating> _milestoneReviews = [
    const MilestoneRating(
      id: 'rev_stage_4',
      stageName: 'Stage 4: Italian Marble Flooring & Wall Cladding',
      completedDate: 'Aug 28, 2026',
      overallScore: 4.9,
      designScore: 5.0,
      executionScore: 4.8,
      supervisorScore: 5.0,
      materialScore: 4.9,
      clientReview:
          'Statuario bookmatch polish is breathtaking. Rajesh Verma maintained strict dust barriers and cleared debris daily.',
      praiseTags: ['#ImpeccableFinish', '#CleanSite', '#PunctualDelivery'],
      supervisorName: 'Rajesh Verma',
      designerName: 'Pooja Hegde',
    ),
    const MilestoneRating(
      id: 'rev_stage_3',
      stageName: 'Stage 3: Gypsum False Ceiling & Cove Lighting',
      completedDate: 'Aug 14, 2026',
      overallScore: 5.0,
      designScore: 5.0,
      executionScore: 5.0,
      supervisorScore: 5.0,
      materialScore: 5.0,
      clientReview:
          'Laser leveling on the living room double-height ceiling was executed to absolute perfection. Magnetic track lights look stunning.',
      praiseTags: ['#LaserPrecision', '#ZeroDefects', '#PromptUpdates'],
      supervisorName: 'Rajesh Verma',
      designerName: 'Pooja Hegde',
    ),
    const MilestoneRating(
      id: 'rev_stage_2',
      stageName: 'Stage 2: Concealed MEP & HVAC Ducting',
      completedDate: 'Jul 29, 2026',
      overallScore: 4.8,
      designScore: 4.9,
      executionScore: 4.7,
      supervisorScore: 4.8,
      materialScore: 4.9,
      clientReview:
          'Multi-split VRV pressure testing passed on first attempt. Dr. Neha Kulkarni conducted a thorough decibel and airflow audit.',
      praiseTags: ['#EngineeringRigor', '#TransparentAudit', '#QualityMaterials'],
      supervisorName: 'Rajesh Verma',
      designerName: 'Dr. Neha Kulkarni',
    ),
    const MilestoneRating(
      id: 'rev_stage_1',
      stageName: 'Stage 1: Civil Demolition & Core Masonry',
      completedDate: 'Jul 12, 2026',
      overallScore: 4.9,
      designScore: 5.0,
      executionScore: 4.9,
      supervisorScore: 4.9,
      materialScore: 4.8,
      clientReview:
          'Internal layout alteration was managed cleanly with society approvals obtained without hassle. Structural engineer sign-off provided.',
      praiseTags: ['#StructuralSafety', '#PoliteCrew', '#SmoothClearance'],
      supervisorName: 'Rajesh Verma',
      designerName: 'Ar. Sameer Mehta',
    ),
  ];

  // Seeded Specialists
  late final List<SpecialistScorecard> _specialists = [
    SpecialistScorecard(
      id: 'spec_pooja',
      name: 'Pooja Hegde',
      role: 'Lead Interior Designer',
      avatarColor: const Color(0xFF8B5CF6),
      initials: 'PH',
      score: 5.0,
      reviewsCount: 18,
      topPraise: 'Flawless 3D execution and material sample curations',
      parameters: {
        'Aesthetic Vision': 5.0,
        'Drawing Accuracy': 5.0,
        'Client Empathy': 4.9,
        'Turnaround Speed': 5.0,
      },
    ),
    SpecialistScorecard(
      id: 'spec_rajesh',
      name: 'Rajesh Verma',
      role: 'Site Execution Supervisor',
      avatarColor: const Color(0xFF0EA5E9),
      initials: 'RV',
      score: 4.9,
      reviewsCount: 24,
      topPraise: 'Daily site video updates, punctuality & clean housekeeping',
      parameters: {
        'Workmanship QA': 4.9,
        'Punctuality': 5.0,
        'Labour Coordination': 4.9,
        'Cleanliness': 4.8,
      },
    ),
    SpecialistScorecard(
      id: 'spec_vikram',
      name: 'Vikram Malhotra',
      role: 'Senior Project Manager',
      avatarColor: const Color(0xFF10B981),
      initials: 'VM',
      score: 4.9,
      reviewsCount: 31,
      topPraise: 'Transparent budget governance & proactive weekly milestone tracking',
      parameters: {
        'Budget Control': 5.0,
        'Timeline Adherence': 4.8,
        'WhatsApp Updates': 5.0,
        'Problem Solving': 4.9,
      },
    ),
    SpecialistScorecard(
      id: 'spec_sameer',
      name: 'Ar. Sameer Mehta',
      role: 'Principal Architect & Project Director',
      avatarColor: const Color(0xFFF59E0B),
      initials: 'SM',
      score: 5.0,
      reviewsCount: 42,
      topPraise: 'Spatial layout genius & structural integrity guidance',
      parameters: {
        'Design Leadership': 5.0,
        'Technical Expertise': 5.0,
        'Executive Governance': 5.0,
        'Client Trust': 5.0,
      },
    ),
  ];

  // Seeded Weekly CSAT Logs
  final List<WeeklyCsatLog> _csatLogs = const [
    WeeklyCsatLog(
      weekLabel: 'Week 8 (Aug 25 - Aug 31)',
      date: 'Aug 29, 2026',
      score: 5.0,
      mood: 'Delighted',
      moodColor: Color(0xFF10B981),
      comment: 'Italian marble polishing looks stunning. Extremely pleased with the crew cleanliness.',
    ),
    WeeklyCsatLog(
      weekLabel: 'Week 7 (Aug 18 - Aug 24)',
      date: 'Aug 22, 2026',
      score: 4.8,
      mood: 'Happy',
      moodColor: Color(0xFF10B981),
      comment: 'Kitchen joinery carcase delivery received on time. Good job on the vibration testing.',
    ),
    WeeklyCsatLog(
      weekLabel: 'Week 6 (Aug 11 - Aug 17)',
      date: 'Aug 15, 2026',
      score: 5.0,
      mood: 'Delighted',
      moodColor: Color(0xFF10B981),
      comment: 'Ceiling handover was prompt. The magnetic tracks match 3D render exactly.',
    ),
    WeeklyCsatLog(
      weekLabel: 'Week 5 (Aug 04 - Aug 10)',
      date: 'Aug 08, 2026',
      score: 4.9,
      mood: 'Happy',
      moodColor: Color(0xFF10B981),
      comment: 'False ceiling framing completed without issues. Rajesh gives clear daily briefings.',
    ),
    WeeklyCsatLog(
      weekLabel: 'Week 4 (Jul 28 - Aug 03)',
      date: 'Aug 01, 2026',
      score: 4.8,
      mood: 'Happy',
      moodColor: Color(0xFF10B981),
      comment: 'MEP pressure test reports shared promptly. Transparent inspection.',
    ),
    WeeklyCsatLog(
      weekLabel: 'Week 3 (Jul 21 - Jul 27)',
      date: 'Jul 24, 2026',
      score: 5.0,
      mood: 'Delighted',
      moodColor: Color(0xFF10B981),
      comment: 'Civil debris cleared within 24 hours. Society manager complimented our team.',
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
                // 1. Executive Header
                _buildHeader(context, isDark, isMobile),

                const SizedBox(height: 18),

                // 2. 360° Quality Scorecard Hero
                _buildScorecardHero(context, isDark, isMobile),

                const SizedBox(height: 20),

                // 3. Navigation Sub-Tabs
                _buildSegmentedTabs(context, isDark, isMobile),

                const SizedBox(height: 20),

                // 4. Tab Views
                if (_selectedTab == 'Milestone Reviews')
                  _buildMilestoneReviewsView(context, isDark, isMobile)
                else if (_selectedTab == 'Specialists 360°')
                  _buildSpecialistsView(context, isDark, isMobile)
                else
                  _buildCsatPulseView(context, isDark, isMobile),

                const SizedBox(height: 28),

                // 5. Governance Guarantee Seal
                _buildQualityGuaranteeFooter(context, isDark, isMobile),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ==========================================================================
  // 1. EXECUTIVE HEADER
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
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF59E0B).withValues(alpha: 0.14),
                  borderRadius: AppRadius.md,
                ),
                child: const Icon(
                  Icons.star_rate_rounded,
                  color: Color(0xFFF59E0B),
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
                          'Feedback & 360° Ratings',
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
                            'AUDITED & VERIFIED',
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
                      'Rate Design, Workmanship, Site Supervisor, and Material Quality across completed milestones',
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
                onPressed: () => _openSubmitFeedbackDialog(context, isDark),
                icon: const Icon(Icons.rate_review_rounded, size: 16),
                label: Text(
                  'Submit Stage Feedback',
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFFF59E0B),
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: AppRadius.md),
                ),
              ),
              OutlinedButton.icon(
                onPressed: () => _openDirectorReviewDialog(context, isDark),
                icon: const Icon(Icons.support_agent_rounded, size: 16),
                label: Text(
                  'Request Director Review',
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
  // 2. 360° QUALITY SCORECARD HERO
  // ==========================================================================
  Widget _buildScorecardHero(
      BuildContext context, bool isDark, bool isMobile) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 18 : 22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF1E1B4B), const Color(0xFF0F172A)]
              : [const Color(0xFFFAF5FF), const Color(0xFFF8FAFC)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: AppRadius.lg,
        border: Border.all(
          color: const Color(0xFF8B5CF6).withValues(alpha: 0.35),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Overall Score Header
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF59E0B),
                  borderRadius: AppRadius.md,
                ),
                child: Row(
                  children: [
                    const Icon(Icons.star_rounded,
                        color: Colors.white, size: 20),
                    const SizedBox(width: 6),
                    Text(
                      '4.9',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      ' / 5.0',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Overall Project Execution Index',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: isMobile ? 14 : 16,
                        fontWeight: FontWeight.w800,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Top 1% Homio Turnkey Standard • 98% CSAT Satisfaction Benchmark',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF10B981),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),
          const Divider(height: 1),
          const SizedBox(height: 18),

          // 4 Core Quality Pillars Grid
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: isMobile ? 1 : 4,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: isMobile ? 3.2 : 1.35,
            children: [
              _buildPillarCard(
                title: 'Design & Architecture',
                score: '5.0',
                subtitle: 'Aesthetics, 3D detail & layouts',
                icon: Icons.architecture_rounded,
                color: const Color(0xFF8B5CF6),
                isDark: isDark,
              ),
              _buildPillarCard(
                title: 'Site Workmanship',
                score: '4.8',
                subtitle: 'Precision joinery & finishes',
                icon: Icons.handyman_rounded,
                color: const Color(0xFF10B981),
                isDark: isDark,
              ),
              _buildPillarCard(
                title: 'Supervisor & Crew',
                score: '4.9',
                subtitle: 'Daily updates & site discipline',
                icon: Icons.badge_outlined,
                color: const Color(0xFF0EA5E9),
                isDark: isDark,
              ),
              _buildPillarCard(
                title: 'Material Quality',
                score: '5.0',
                subtitle: 'Zero deviations, 100% genuine',
                icon: Icons.verified_rounded,
                color: const Color(0xFFF59E0B),
                isDark: isDark,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPillarCard({
    required String title,
    required String score,
    required String subtitle,
    required IconData icon,
    required Color color,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF111827) : Colors.white,
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
              Icon(icon, size: 16, color: color),
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
          Row(
            children: [
              Text(
                score,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
              const SizedBox(width: 4),
              const Icon(Icons.star_rounded,
                  size: 15, color: Color(0xFFF59E0B)),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
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
      'Milestone Reviews',
      'Specialists 360°',
      'Weekly CSAT Pulse',
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
  // 4A. TAB 1: MILESTONE REVIEWS VIEW
  // ==========================================================================
  Widget _buildMilestoneReviewsView(
      BuildContext context, bool isDark, bool isMobile) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _milestoneReviews.length,
      separatorBuilder: (context, index) => const SizedBox(height: 14),
      itemBuilder: (context, index) {
        final rev = _milestoneReviews[index];
        return Container(
          padding: const EdgeInsets.all(18),
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
              // Header Row: Stage Name, Score, Verified Badge
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          rev.stageName,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color:
                                isDark ? Colors.white : const Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          'Completed ${rev.completedDate} • Lead Supervisor: ${rev.supervisorName}',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w500,
                            color: isDark
                                ? AppColors.darkTextMuted
                                : AppColors.lightTextMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF59E0B).withValues(alpha: 0.12),
                      borderRadius: AppRadius.full,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star_rounded,
                            size: 15, color: Color(0xFFF59E0B)),
                        const SizedBox(width: 4),
                        Text(
                          '${rev.overallScore}',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFFD97706),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Client Review Text
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF1E293B).withValues(alpha: 0.5)
                      : const Color(0xFFF8FAFC),
                  borderRadius: AppRadius.md,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.format_quote_rounded,
                            size: 16, color: Color(0xFF6366F1)),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            'Client Milestone Testimonial',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.5,
                              color: const Color(0xFF6366F1),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '"${rev.clientReview}"',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12.5,
                        height: 1.4,
                        fontStyle: FontStyle.italic,
                        color: isDark
                            ? Colors.white
                            : const Color(0xFF1E293B),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Pillar Micro-Scores
              Wrap(
                spacing: 12,
                runSpacing: 6,
                children: [
                  _buildMicroScore(
                      'Design: ${rev.designScore} ★', const Color(0xFF8B5CF6)),
                  _buildMicroScore('Execution: ${rev.executionScore} ★',
                      const Color(0xFF10B981)),
                  _buildMicroScore('Supervisor: ${rev.supervisorScore} ★',
                      const Color(0xFF0EA5E9)),
                  _buildMicroScore('Material: ${rev.materialScore} ★',
                      const Color(0xFFF59E0B)),
                ],
              ),

              const SizedBox(height: 10),

              // Praise Tags
              Wrap(
                spacing: 6,
                runSpacing: 4,
                children: rev.praiseTags.map((tag) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF1E293B)
                          : const Color(0xFFF1F5F9),
                      borderRadius: AppRadius.sm,
                    ),
                    child: Text(
                      tag,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMicroScore(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: AppRadius.xs,
      ),
      child: Text(
        label,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 10.5,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }

  // ==========================================================================
  // 4B. TAB 2: SPECIALISTS 360° VIEW
  // ==========================================================================
  Widget _buildSpecialistsView(
      BuildContext context, bool isDark, bool isMobile) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isMobile ? 1 : 2,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        mainAxisExtent: isMobile ? 310 : 295,
      ),
      itemCount: _specialists.length,
      itemBuilder: (context, index) {
        final spec = _specialists[index];
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
              // Profile Row
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: spec.avatarColor,
                    child: Text(
                      spec.initials,
                      style: GoogleFonts.plusJakartaSans(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          spec.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w700,
                            color:
                                isDark ? Colors.white : const Color(0xFF0F172A),
                          ),
                        ),
                        Text(
                          spec.role,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
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
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF59E0B).withValues(alpha: 0.12),
                      borderRadius: AppRadius.full,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star_rounded,
                            size: 14, color: Color(0xFFF59E0B)),
                        const SizedBox(width: 3),
                        Text(
                          '${spec.score}',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFFD97706),
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

              // Top praise highlight
              Text(
                '"${spec.topPraise}"',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11.5,
                  fontStyle: FontStyle.italic,
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                ),
              ),

              const SizedBox(height: 12),

              // Parameter Bars
              ...spec.parameters.entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 110,
                        child: Text(
                          entry.key,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? AppColors.darkTextMuted
                                : AppColors.lightTextMuted,
                          ),
                        ),
                      ),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: entry.value / 5.0,
                            minHeight: 4,
                            backgroundColor: isDark
                                ? const Color(0xFF1E293B)
                                : const Color(0xFFE2E8F0),
                            valueColor: AlwaysStoppedAnimation<Color>(
                                spec.avatarColor),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${entry.value}',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                    ],
                  ),
                );
              }),

              const Spacer(),

              // Rate specialist action
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => _openRateSpecialistDialog(spec, isDark),
                  icon: const Icon(Icons.star_outline_rounded, size: 14),
                  label: Text('Rate ${spec.name.split(' ').first}',
                      style: GoogleFonts.plusJakartaSans(
                          fontSize: 11.5, fontWeight: FontWeight.w600)),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    shape: RoundedRectangleBorder(
                        borderRadius: AppRadius.sm),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ==========================================================================
  // 4C. TAB 3: WEEKLY CSAT PULSE VIEW
  // ==========================================================================
  Widget _buildCsatPulseView(
      BuildContext context, bool isDark, bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Informative note
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : Colors.white,
            borderRadius: AppRadius.md,
            border: Border.all(
              color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
            ),
          ),
          child: Row(
            children: [
              const Icon(Icons.mark_chat_unread_rounded,
                  size: 20, color: Color(0xFF25D366)),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Automated Friday WhatsApp Pulse: Quick 1-tap CSAT rating dispatched to homeowner every Friday at 05:00 PM.',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 14),

        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _csatLogs.length,
          separatorBuilder: (context, index) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final log = _csatLogs[index];
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
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: log.moodColor.withValues(alpha: 0.12),
                      borderRadius: AppRadius.sm,
                    ),
                    child: Icon(
                      Icons.sentiment_very_satisfied_rounded,
                      color: log.moodColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                log.weekLabel,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: isDark
                                      ? Colors.white
                                      : const Color(0xFF0F172A),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFF10B981)
                                    .withValues(alpha: 0.12),
                                borderRadius: AppRadius.xs,
                              ),
                              child: Text(
                                '${log.score} ★ ${log.mood}',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF059669),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 3),
                        Text(
                          '"${log.comment}"',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.lightTextSecondary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${log.date} • Dispatched via ${log.channel}',
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
          },
        ),
      ],
    );
  }

  // ==========================================================================
  // 5. GOVERNANCE SEAL FOOTER
  // ==========================================================================
  Widget _buildQualityGuaranteeFooter(
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
            color: Color(0xFF8B5CF6),
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Homio Quality Guarantee: Ratings directly influence team performance bonuses and trade contractor retention. Scores under 4.0 trigger automatic Project Director review.',
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

  void _openSubmitFeedbackDialog(BuildContext context, bool isDark) {
    double designScore = 5.0;
    double executionScore = 5.0;
    double supervisorScore = 5.0;
    double materialScore = 5.0;
    final reviewCtrl = TextEditingController();
    final selectedTags = <String>{'#ImpeccableFinish', '#CleanSite'};

    final availableTags = [
      '#ImpeccableFinish',
      '#CleanSite',
      '#PunctualDelivery',
      '#TransparentBilling',
      '#LaserPrecision',
      '#PoliteCrew',
      '#GreatCommunication',
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
                      color: const Color(0xFFF59E0B).withValues(alpha: 0.12),
                      borderRadius: AppRadius.sm,
                    ),
                    child: const Icon(
                      Icons.rate_review_rounded,
                      color: Color(0xFFF59E0B),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Submit Milestone Feedback',
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
                      Text(
                        'Rate the 4 Quality Dimensions',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.lightTextPrimary,
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Star selectors
                      _buildInteractiveStarRow('Design & Architecture',
                          designScore, (v) => setDialogState(() => designScore = v)),
                      const SizedBox(height: 8),
                      _buildInteractiveStarRow('Workmanship & Execution',
                          executionScore, (v) => setDialogState(() => executionScore = v)),
                      const SizedBox(height: 8),
                      _buildInteractiveStarRow('Supervisor & Behaviour',
                          supervisorScore, (v) => setDialogState(() => supervisorScore = v)),
                      const SizedBox(height: 8),
                      _buildInteractiveStarRow('Material & Finish',
                          materialScore, (v) => setDialogState(() => materialScore = v)),

                      const SizedBox(height: 16),

                      // Selectable Praise Tags
                      Text(
                        'What went exceptionally well?',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.lightTextPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: availableTags.map((tag) {
                          final isSelected = selectedTags.contains(tag);
                          return FilterChip(
                            label: Text(tag),
                            selected: isSelected,
                            onSelected: (selected) {
                              setDialogState(() {
                                if (selected) {
                                  selectedTags.add(tag);
                                } else {
                                  selectedTags.remove(tag);
                                }
                              });
                            },
                            labelStyle: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              fontWeight: isSelected
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                              color: isSelected
                                  ? Colors.white
                                  : (isDark
                                      ? AppColors.darkTextSecondary
                                      : AppColors.lightTextSecondary),
                            ),
                            selectedColor: const Color(0xFFF59E0B),
                            backgroundColor: isDark
                                ? const Color(0xFF1E293B)
                                : const Color(0xFFF1F5F9),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 0),
                            shape: RoundedRectangleBorder(
                                borderRadius: AppRadius.sm),
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 16),

                      // Written Comments
                      Text(
                        'Detailed Comments & Testimonial',
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
                        controller: reviewCtrl,
                        maxLines: 3,
                        decoration: InputDecoration(
                          hintText:
                              'Share your experience regarding finishing, timeliness, and team conduct...',
                          hintStyle: GoogleFonts.plusJakartaSans(
                              fontSize: 12, color: Colors.grey),
                          contentPadding: const EdgeInsets.all(12),
                          border: OutlineInputBorder(
                            borderRadius: AppRadius.sm,
                          ),
                        ),
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
                    final overall = (designScore +
                            executionScore +
                            supervisorScore +
                            materialScore) /
                        4.0;
                    final text = reviewCtrl.text.trim().isEmpty
                        ? 'Workmanship and execution were handled with great precision.'
                        : reviewCtrl.text.trim();

                    final newReview = MilestoneRating(
                      id: 'rev_custom_${_milestoneReviews.length}',
                      stageName: 'Stage 5: Modular Kitchen Joinery Sign-off',
                      completedDate: 'Today',
                      overallScore: double.parse(overall.toStringAsFixed(1)),
                      designScore: designScore,
                      executionScore: executionScore,
                      supervisorScore: supervisorScore,
                      materialScore: materialScore,
                      clientReview: text,
                      praiseTags: selectedTags.toList(),
                      supervisorName: 'Rajesh Verma',
                      designerName: 'Pooja Hegde',
                    );

                    setState(() {
                      _milestoneReviews.insert(0, newReview);
                    });

                    Navigator.of(ctx).pop();

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Feedback submitted successfully! Overall score: ${newReview.overallScore} ★',
                          style: GoogleFonts.plusJakartaSans(
                              fontWeight: FontWeight.w600),
                        ),
                        backgroundColor: const Color(0xFF10B981),
                      ),
                    );
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFFF59E0B),
                  ),
                  child: Text('Submit Review',
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

  Widget _buildInteractiveStarRow(
      String label, double currentScore, ValueChanged<double> onScoreChanged) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(5, (index) {
            final starVal = index + 1.0;
            return InkWell(
              onTap: () => onScoreChanged(starVal),
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Icon(
                  starVal <= currentScore
                      ? Icons.star_rounded
                      : Icons.star_outline_rounded,
                  color: const Color(0xFFF59E0B),
                  size: 22,
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  void _openRateSpecialistDialog(SpecialistScorecard spec, bool isDark) {
    double specScore = spec.score;
    final commentCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (dialogCtx, setDialogState) {
            return AlertDialog(
              backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
              shape: RoundedRectangleBorder(borderRadius: AppRadius.lg),
              title: Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: spec.avatarColor,
                    child: Text(
                      spec.initials,
                      style: GoogleFonts.plusJakartaSans(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 11,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Rate ${spec.name}',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),
              content: SizedBox(
                width: 400,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Role: ${spec.role}',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        color: isDark
                            ? AppColors.darkTextMuted
                            : AppColors.lightTextMuted,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'Your Rating for ${spec.name.split(' ').first}',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        final star = index + 1.0;
                        return InkWell(
                          onTap: () => setDialogState(() => specScore = star),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Icon(
                              star <= specScore
                                  ? Icons.star_rounded
                                  : Icons.star_outline_rounded,
                              color: const Color(0xFFF59E0B),
                              size: 30,
                            ),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Praise or Suggestions',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: commentCtrl,
                      maxLines: 2,
                      decoration: InputDecoration(
                        hintText: 'e.g. Always responsive and proactive on site...',
                        hintStyle: GoogleFonts.plusJakartaSans(
                            fontSize: 12, color: Colors.grey),
                        contentPadding: const EdgeInsets.all(10),
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
                      spec.score = specScore;
                      spec.reviewsCount += 1;
                    });
                    Navigator.of(ctx).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Your rating for ${spec.name} has been updated!',
                          style: GoogleFonts.plusJakartaSans(
                              fontWeight: FontWeight.w600),
                        ),
                        backgroundColor: const Color(0xFF10B981),
                      ),
                    );
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: spec.avatarColor,
                  ),
                  child: Text('Submit Rating',
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

  void _openDirectorReviewDialog(BuildContext context, bool isDark) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: AppRadius.lg),
          title: Row(
            children: [
              const Icon(Icons.shield_rounded,
                  color: Color(0xFF6366F1), size: 22),
              const SizedBox(width: 10),
              Text(
                'Director Priority Escalation',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
            ],
          ),
          content: SizedBox(
            width: 440,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Direct governance with Homio leadership:',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12.5,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ),
                const SizedBox(height: 12),
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
                      const CircleAvatar(
                        radius: 20,
                        backgroundColor: Color(0xFFF59E0B),
                        child: Text(
                          'SM',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Ar. Sameer Mehta',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w700,
                                color: isDark
                                    ? Colors.white
                                    : const Color(0xFF0F172A),
                              ),
                            ),
                            Text(
                              'Principal Architect & Project Director\nDirect Desk: +91 98200 00001',
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
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  'Triggering this escalation immediately alerts the Director Desk. You will receive a direct phone call within 2 hours.',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11.5,
                    color: isDark
                        ? AppColors.darkTextMuted
                        : AppColors.lightTextMuted,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text('Close', style: GoogleFonts.plusJakartaSans()),
            ),
            FilledButton.icon(
              onPressed: () {
                Navigator.of(ctx).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Priority escalation dispatched to Ar. Sameer Mehta. Callback scheduled within 2 hours.',
                      style: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.w600),
                    ),
                    backgroundColor: const Color(0xFF6366F1),
                  ),
                );
              },
              icon: const Icon(Icons.phone_callback_rounded, size: 16),
              label: Text('Request Priority Callback',
                  style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.w700)),
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF6366F1),
              ),
            ),
          ],
        );
      },
    );
  }
}
