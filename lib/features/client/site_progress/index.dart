import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/responsive/breakpoints.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../shared/client_models.dart';
import '../shared/customer_shared_widgets.dart';

/// Screen 2: LIVE PROJECT PROGRESS (/client/site-progress)
/// Real-time transparency portal for HOMIO homeowners.
/// Communicates overall progress (68%), current stage status, live site photo & video feed,
/// responsive stage steppers, milestone tracking, and verified completed vs. pending tasks.
class ClientSiteProgressPage extends StatefulWidget {
  const ClientSiteProgressPage({super.key});

  @override
  State<ClientSiteProgressPage> createState() => _ClientSiteProgressPageState();
}

class _ClientSiteProgressPageState extends State<ClientSiteProgressPage> {
  String _selectedFilter = 'All'; // 'All', 'Today', 'This Week', 'Electrical', 'Ceiling'

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= Breakpoints.medium;
    final isTablet = screenWidth >= 640 && screenWidth < Breakpoints.medium;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0B0F19) : const Color(0xFFF8FAFC),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(
          horizontal: isDesktop ? AppSpacing.xl : (isTablet ? AppSpacing.lg : AppSpacing.md),
          vertical: isDesktop ? AppSpacing.xl : AppSpacing.md,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1240),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. SHARED PROJECT CONTEXT HEADER & SUB-NAVIGATION
                const CustomerProjectContextBar(activeTab: 'progress'),
                const SizedBox(height: 16),

                // 2. HERO PROGRESS DASHBOARD CARD (68% + Freshness)
                _buildProgressHeroCard(context, isDark, isDesktop),
                const SizedBox(height: 18),

                // 3. CUSTOMER ALERT BANNER (Transparent Supply Update)
                _buildCustomerAlertBanner(context, isDark),
                const SizedBox(height: 18),

                // 4. CURRENT ACTIVE STAGE CARD
                _buildCurrentStageCard(context, isDark, isDesktop),
                const SizedBox(height: 24),

                // 5. RESPONSIVE PROJECT STAGE STEPPER
                _buildStageStepperSection(context, isDark, isDesktop),
                const SizedBox(height: 24),

                // 6. MAIN CONTENT COLUMNS (FEED & MILESTONES)
                if (isDesktop)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Left (65%): Live Site Updates Feed & Media
                      Expanded(
                        flex: 65,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _buildFilterBar(context, isDark),
                            const SizedBox(height: 16),
                            _buildSiteUpdatesFeed(context, isDark, isDesktop),
                          ],
                        ),
                      ),
                      const SizedBox(width: 20),

                      // Right (35%): Active Milestones & Completed vs. Pending
                      Expanded(
                        flex: 35,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _buildMilestonesCard(context, isDark),
                            const SizedBox(height: 20),
                            _buildWorkChecklistCard(context, isDark),
                          ],
                        ),
                      ),
                    ],
                  )
                else
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildMilestonesCard(context, isDark),
                      const SizedBox(height: 20),
                      _buildFilterBar(context, isDark),
                      const SizedBox(height: 16),
                      _buildSiteUpdatesFeed(context, isDark, isDesktop),
                      const SizedBox(height: 20),
                      _buildWorkChecklistCard(context, isDark),
                    ],
                  ),

                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================================
  // 1. PROGRESS HERO CARD
  // ============================================================================
  Widget _buildProgressHeroCard(BuildContext context, bool isDark, bool isDesktop) {
    final proj = ClientDataRepository.activeProject;

    return Container(
      padding: EdgeInsets.all(isDesktop ? AppSpacing.lg : AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF111827) : Colors.white,
        borderRadius: AppRadius.lg,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.03),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFF10B981).withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.check_circle_rounded, size: 12, color: Color(0xFF10B981)),
                              const SizedBox(width: 4),
                              Text(
                                'PROJECT STATUS: ON TRACK',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.4,
                                  color: const Color(0xFF059669),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '• Last updated: ${proj.lastUpdated}',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Live Site Execution Progress',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: isDesktop ? 22 : 18,
                        fontWeight: FontWeight.w800,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Stage 5 of 7: Civil masonry completed, electrical conduits running, false ceiling framing active.',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12.5,
                        color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // Big Percentage
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${(proj.overallProgress * 100).toInt()}%',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: isDesktop ? 36 : 28,
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFF10B981),
                      letterSpacing: -1,
                    ),
                  ),
                  Text(
                    'Overall Complete',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Main Multi-Segmented Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: SizedBox(
              height: 10,
              child: Stack(
                children: [
                  Container(color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0)),
                  FractionallySizedBox(
                    widthFactor: proj.overallProgress,
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF10B981), Color(0xFF059669)],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Meta Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Kickoff: ${proj.startDate}',
                style: GoogleFonts.plusJakartaSans(fontSize: 11.5, color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted),
              ),
              Text(
                'Target Handover: ${proj.expectedCompletion}',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                  color: isDark ? const Color(0xFF60A5FA) : const Color(0xFF2563EB),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================================
  // 2. CUSTOMER ALERT BANNER
  // ============================================================================
  Widget _buildCustomerAlertBanner(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF451A03).withValues(alpha: 0.3) : const Color(0xFFFEF3C7).withValues(alpha: 0.7),
        borderRadius: AppRadius.md,
        border: Border.all(color: const Color(0xFFF59E0B).withValues(alpha: 0.35)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline_rounded, color: Color(0xFFD97706), size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'LOGISTICS NOTICE',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFFD97706),
                        letterSpacing: 0.4,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '• Updated 11 Sep',
                      style: GoogleFonts.plusJakartaSans(fontSize: 10.5, color: const Color(0xFF92400E)),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  'Saint-Gobain false ceiling gypsum delivery is scheduled for 20 Sep (2-day transit buffer). '
                  'Internal carpentry fabrication remains on schedule with zero impact on overall handover date.',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    height: 1.35,
                    color: isDark ? const Color(0xFFFDE68A) : const Color(0xFF78350F),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================================
  // 3. CURRENT ACTIVE STAGE CARD
  // ============================================================================
  Widget _buildCurrentStageCard(BuildContext context, bool isDark, bool isDesktop) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF111827) : Colors.white,
        borderRadius: AppRadius.lg,
        border: Border.all(
          color: const Color(0xFF4F46E5).withValues(alpha: 0.35),
          width: 1.2,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF4F46E5).withValues(alpha: 0.12),
              borderRadius: AppRadius.md,
            ),
            child: const Icon(Icons.electrical_services_rounded, color: Color(0xFF4F46E5), size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'CURRENT ACTIVE STAGE',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                        color: const Color(0xFF4F46E5),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFF3B82F6).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '72% Complete',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF2563EB),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Stage 5: Electrical Conduiting & False Ceiling Framing',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Started 08 Sep 2026 • Expected completion: 18 Sep 2026 • 18 of 25 tasks verified',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11.5,
                    color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4F46E5),
              foregroundColor: Colors.white,
              shape: RoundedAppRadius.md,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            ),
            onPressed: () => context.go('/client/approvals'),
            icon: const Icon(Icons.rule_folder_outlined, size: 15),
            label: Text(
              isDesktop ? 'View Stage & Sign-Offs' : 'Stage',
              style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================================
  // 4. RESPONSIVE PROJECT STAGE STEPPER
  // ============================================================================
  Widget _buildStageStepperSection(BuildContext context, bool isDark, bool isDesktop) {
    final stages = [
      ('01 Planning', 'Survey & Layout', 'Completed', 1.0, Icons.check_circle_rounded),
      ('02 Design', '3D Concepts & CAD', 'Completed', 1.0, Icons.check_circle_rounded),
      ('03 Client Approval', 'BOQ Sign-Off', 'Completed', 1.0, Icons.check_circle_rounded),
      ('04 Procurement', 'Factory Intake', 'Completed', 1.0, Icons.check_circle_rounded),
      ('05 Execution', 'Electrical & Ceiling', 'Active (72%)', 0.72, Icons.timelapse_rounded),
      ('06 Inspection', 'Quality Checklist', 'Upcoming', 0.0, Icons.radio_button_unchecked_rounded),
      ('07 Handover', 'Key Handover', 'Upcoming', 0.0, Icons.radio_button_unchecked_rounded),
    ];

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF111827) : Colors.white,
        borderRadius: AppRadius.lg,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Master Construction Journey (7 Stages)',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 14),

          if (isDesktop)
            // Horizontal Desktop Stepper
            Row(
              children: stages.asMap().entries.map((entry) {
                final i = entry.key;
                final stg = entry.value;
                final isDone = stg.$4 == 1.0;
                final isActive = stg.$4 > 0 && stg.$4 < 1.0;

                return Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  stg.$5,
                                  size: 16,
                                  color: isDone
                                      ? const Color(0xFF10B981)
                                      : (isActive ? const Color(0xFF4F46E5) : const Color(0xFF94A3B8)),
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    stg.$1,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.w700,
                                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              stg.$2,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 10.5,
                                color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted,
                              ),
                            ),
                            const SizedBox(height: 6),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(2),
                              child: LinearProgressIndicator(
                                value: stg.$4,
                                minHeight: 4,
                                backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  isDone ? const Color(0xFF10B981) : const Color(0xFF4F46E5),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (i < stages.length - 1)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: Icon(Icons.arrow_forward_ios_rounded, size: 10, color: isDark ? Colors.white24 : Colors.black12),
                        ),
                    ],
                  ),
                );
              }).toList(),
            )
          else
            // Vertical Mobile Stepper
            Column(
              children: stages.map((stg) {
                final isDone = stg.$4 == 1.0;
                final isActive = stg.$4 > 0 && stg.$4 < 1.0;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: [
                      Icon(
                        stg.$5,
                        size: 18,
                        color: isDone
                            ? const Color(0xFF10B981)
                            : (isActive ? const Color(0xFF4F46E5) : const Color(0xFF94A3B8)),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  stg.$1,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w700,
                                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                                  ),
                                ),
                                Text(
                                  stg.$3,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: isDone ? const Color(0xFF10B981) : (isActive ? const Color(0xFF4F46E5) : const Color(0xFF94A3B8)),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              stg.$2,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
                                color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }

  // ============================================================================
  // 5. FILTER CHIPS BAR
  // ============================================================================
  Widget _buildFilterBar(BuildContext context, bool isDark) {
    final filters = ['All', 'Today', 'This Week', 'Electrical', 'Ceiling', 'Plumbing'];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters.map((f) {
          final isSelected = _selectedFilter == f;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(f),
              selected: isSelected,
              onSelected: (val) => setState(() => _selectedFilter = f),
              selectedColor: const Color(0xFF4F46E5),
              backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
              labelStyle: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                color: isSelected ? Colors.white : (isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569)),
              ),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ============================================================================
  // 6. LIVE SITE UPDATES FEED
  // ============================================================================
  Widget _buildSiteUpdatesFeed(BuildContext context, bool isDark, bool isDesktop) {
    final updates = ClientDataRepository.siteUpdates;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: updates.map((upd) {
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF111827) : Colors.white,
            borderRadius: AppRadius.lg,
            border: Border.all(
              color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Timestamp + Stage Badge
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFF4F46E5).withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          upd.timestamp.toUpperCase(),
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF4F46E5),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'by ${upd.authorName} (${upd.authorRole})',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11.5,
                          color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted,
                        ),
                      ),
                    ],
                  ),
                  CustomerStatusBadge(status: upd.stage, isSmall: true),
                ],
              ),
              const SizedBox(height: 10),

              // Title & Description
              Text(
                upd.title,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                upd.description,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12.5,
                  height: 1.4,
                  color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155),
                ),
              ),
              const SizedBox(height: 14),

              // Media Thumbnails Grid (Photos & Video)
              if (upd.media.isNotEmpty)
                LayoutBuilder(
                  builder: (context, constraints) {
                    final isNarrow = constraints.maxWidth < 450;
                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: isNarrow ? 2 : 3,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 1.4,
                      ),
                      itemCount: upd.media.length,
                      itemBuilder: (context, i) {
                        final med = upd.media[i];
                        final isVideo = med.type == SiteMediaType.video;

                        return InkWell(
                          onTap: () {
                            if (isVideo) {
                              VideoPlayerPreviewModal.show(
                                context,
                                title: med.title,
                                duration: med.duration ?? '0:30',
                                zone: med.zone,
                                uploader: med.uploader,
                                caption: med.caption,
                              );
                            } else {
                              FullscreenImageViewerModal.show(
                                context,
                                title: med.title,
                                caption: med.caption,
                                zone: med.zone,
                                uploader: med.uploader,
                                timestamp: med.timestamp,
                                placeholderGradientStart: med.placeholderGradientStart,
                                placeholderGradientEnd: med.placeholderGradientEnd,
                              );
                            }
                          },
                          borderRadius: AppRadius.md,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: AppRadius.md,
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [med.placeholderGradientStart, med.placeholderGradientEnd],
                              ),
                              border: Border.all(color: Colors.white12),
                            ),
                            child: Stack(
                              children: [
                                Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        isVideo ? Icons.play_circle_fill_rounded : Icons.camera_alt_rounded,
                                        color: Colors.white70,
                                        size: isVideo ? 30 : 22,
                                      ),
                                      const SizedBox(height: 4),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 6),
                                        child: Text(
                                          med.zone,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.plusJakartaSans(
                                            color: Colors.white,
                                            fontSize: 10,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (isVideo)
                                  Positioned(
                                    bottom: 6,
                                    right: 6,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withValues(alpha: 0.7),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        med.duration ?? '0:30',
                                        style: GoogleFonts.plusJakartaSans(color: Colors.white, fontSize: 9.5, fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              const SizedBox(height: 12),

              // Tags & Verification
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: upd.tags.map((t) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '#$t',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  // ============================================================================
  // 7. ACTIVE MILESTONES CARD
  // ============================================================================
  Widget _buildMilestonesCard(BuildContext context, bool isDark) {
    final milestones = [
      ('Concealed Conduits & Cable Pulling', 'Electrical Work', 0.72, 'Due 16 Sep', const Color(0xFF3B82F6)),
      ('False Ceiling Framing & Suspension Grid', 'False Ceiling', 0.45, 'Due 22 Sep', const Color(0xFF8B5CF6)),
      ('Modular Kitchen HDHMR Joinery', 'Carpentry', 0.60, 'Due 28 Sep', const Color(0xFF10B981)),
    ];

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF111827) : Colors.white,
        borderRadius: AppRadius.lg,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.flag_rounded, size: 16, color: Color(0xFF4F46E5)),
                  const SizedBox(width: 8),
                  Text(
                    'Active Stage Milestones',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),
              Text(
                'Stage 5',
                style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w700, color: const Color(0xFF4F46E5)),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ...milestones.map((ms) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          ms.$1,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700,
                            color: isDark ? Colors.white : const Color(0xFF0F172A),
                          ),
                        ),
                      ),
                      Text(
                        '${(ms.$3 * 100).toInt()}%',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w800,
                          color: ms.$5,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        ms.$2,
                        style: GoogleFonts.plusJakartaSans(fontSize: 11, color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted),
                      ),
                      Text(
                        ms.$4,
                        style: GoogleFonts.plusJakartaSans(fontSize: 11, color: const Color(0xFFD97706), fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(3),
                    child: LinearProgressIndicator(
                      value: ms.$3,
                      minHeight: 5,
                      backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
                      valueColor: AlwaysStoppedAnimation<Color>(ms.$5),
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

  // ============================================================================
  // 8. COMPLETED VS. PENDING WORK CHECKLIST
  // ============================================================================
  Widget _buildWorkChecklistCard(BuildContext context, bool isDark) {
    final completed = [
      'Civil demolition & partition wall removal',
      'Astral CPVC pressure test certified at 10 bar',
      'Concealed PVC conduit chases in living room & master bed',
      'Finolex FR copper wire pulling with earth test loops',
      'Ceiling waterline leveled with 360-degree laser level',
    ];

    final pending = [
      'Distribution board MCB wiring and circuit breaker grouping',
      '12.5mm Saint-Gobain gypsum board screw fastening',
      'Tenax epoxy nano-grouting on Italian marble floor',
      'Asian Paints Royale 3-coat luxury velvet painting',
      'Final key handover cleaning & snag clearance',
    ];

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF111827) : Colors.white,
        borderRadius: AppRadius.lg,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Verified Work Status',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 12),

          // Completed Section
          Text(
            'COMPLETED TASKS',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 10.5,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
              color: const Color(0xFF10B981),
            ),
          ),
          const SizedBox(height: 6),
          ...completed.map((task) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.check_circle_rounded, size: 13, color: Color(0xFF10B981)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      task,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11.5,
                        color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 14),

          // Pending Section
          Text(
            'PENDING TASKS (UPCOMING)',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 10.5,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
              color: const Color(0xFFF59E0B),
            ),
          ),
          const SizedBox(height: 6),
          ...pending.map((task) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.radio_button_unchecked_rounded, size: 13, color: Color(0xFFF59E0B)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      task,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11.5,
                        color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
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
}
