import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../app/router/route_names.dart';
import '../../../core/responsive/breakpoints.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import 'shared_widgets.dart';

/// Screen 1: Client AI Studio Hub (/client/ai-suite)
class ClientAiStudioHubPage extends StatefulWidget {
  const ClientAiStudioHubPage({super.key});

  @override
  State<ClientAiStudioHubPage> createState() => _ClientAiStudioHubPageState();
}

class _ClientAiStudioHubPageState extends State<ClientAiStudioHubPage> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SingleChildScrollView(
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
                // 1. Executive Hero Banner
                _buildHeroBanner(context, isDark, isMobile),

                const SizedBox(height: 20),

                // 3. Quick Stats Grid
                _buildStatsGrid(context, isDark, isMobile),

                const SizedBox(height: 24),

                // 4. Section Title: AI Studio Tools
                Row(
                  children: [
                    const Icon(Icons.apps_rounded, size: 18, color: Color(0xFF6366F1)),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        'AI Architectural & Styling Suites',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: isMobile ? 16 : 18,
                          fontWeight: FontWeight.w800,
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // 5. 4 Core Tools Grid
                _buildToolsGrid(context, isDark, isMobile),

                const SizedBox(height: 28),

                // 6. Recent Studio Generations Showcase
                _buildRecentGenerations(context, isDark, isMobile),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeroBanner(BuildContext context, bool isDark, bool isMobile) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 18 : 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF311042), const Color(0xFF1E1B4B), const Color(0xFF0F172A)]
              : [const Color(0xFFFAF5FF), const Color(0xFFEEF2FF), Colors.white],
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
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 6,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF8B5CF6).withValues(alpha: 0.18),
                  borderRadius: AppRadius.full,
                  border: Border.all(
                    color: const Color(0xFF8B5CF6).withValues(alpha: 0.4),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.bolt_rounded, size: 14, color: Color(0xFF8B5CF6)),
                    const SizedBox(width: 4),
                    Text(
                      isMobile ? 'ARCHITECTURAL AI' : 'NEXT-GEN ARCHITECTURAL INTELLIGENCE',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF8B5CF6),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: 0.15),
                  borderRadius: AppRadius.full,
                ),
                child: Text(
                  '50-50 DESIGNER SHARE ACTIVE',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF059669),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            'Transform Your Villa with High-Precision AI Tools',
            style: GoogleFonts.plusJakartaSans(
              fontSize: isMobile ? 18 : 24,
              fontWeight: FontWeight.w900,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
              height: 1.25,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'From 50/50 dual-view photo styling to 16-zone Vedic Vastu audits, real-time material BOQ pricing, and instant technical guidance—all calibrated for Palm Heights Villa 402.',
            style: GoogleFonts.plusJakartaSans(
              fontSize: isMobile ? 12 : 13.5,
              fontWeight: FontWeight.w500,
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid(BuildContext context, bool isDark, bool isMobile) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 700;
        final cardWidth = isWide ? (constraints.maxWidth - 36) / 4 : (constraints.maxWidth - 12) / 2;

        final stats = [
          (
            label: 'AI Studio Tokens',
            value: '${globalAiWallet.totalTokens}',
            sub: 'Usable for 4K Renders',
            icon: Icons.toll_rounded,
            color: const Color(0xFF6366F1),
          ),
          (
            label: 'Designer Revenue',
            value: '50% Split',
            sub: 'Credited to Pooja Hegde',
            icon: Icons.handshake_rounded,
            color: const Color(0xFF10B981),
          ),
          (
            label: 'Free Doubt Queries',
            value: '${globalAiWallet.freeDoubtQueriesLeft} Left',
            sub: '₹50/query thereafter',
            icon: Icons.psychology_rounded,
            color: const Color(0xFF0EA5E9),
          ),
          (
            label: 'Vastu Energy Score',
            value: '92 / 100',
            sub: 'Auspicious MahaVastu',
            icon: Icons.compass_calibration_rounded,
            color: const Color(0xFFF59E0B),
          ),
        ];

        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: stats.map((s) {
            return SizedBox(
              width: cardWidth,
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : Colors.white,
                  borderRadius: AppRadius.md,
                  border: Border.all(
                    color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(s.icon, size: 16, color: s.color),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            s.label,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      s.value,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      s.sub,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: s.color,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildToolsGrid(BuildContext context, bool isDark, bool isMobile) {
    final tools = [
      (
        title: 'AI Room 3D Generator (50/50 Dual View)',
        desc: 'Upload an under-construction site photo to generate 4K furnished photorealistic renders with an interactive split comparison slider.',
        badge: '50/50 SLIDER • 4K RENDER',
        color: const Color(0xFF6366F1),
        icon: Icons.auto_awesome_rounded,
        routeName: RouteNames.clientAiRoomGen,
      ),
      (
        title: 'AI Vastu Shastra Consultant & Chakra',
        desc: 'Upload your floor plan & set True North to inspect the 16-zone energy mandala and apply non-demolition remedial cures.',
        badge: '16-ZONE CHAKRA • 92/100',
        color: const Color(0xFF10B981),
        icon: Icons.compass_calibration_rounded,
        routeName: RouteNames.clientAiVastu,
      ),
      (
        title: 'AI Furniture & Interior Budget Estimator',
        desc: 'Interactive material calculator comparing Commercial MR vs HDHMR vs Marine Ply with hardware tiers and top-brand pricing.',
        badge: 'LIVE BOQ • BRAND ESTIMATES',
        color: const Color(0xFFF59E0B),
        icon: Icons.calculate_rounded,
        routeName: RouteNames.clientAiBudget,
      ),
      (
        title: 'AI Technical Architectural Doubt Solver',
        desc: 'Freemium construction QA advisor trained on Indian Standards (IS Codes) to prevent costly on-site execution errors.',
        badge: '₹50/QUERY • FIRST 3 FREE',
        color: const Color(0xFF0EA5E9),
        icon: Icons.psychology_rounded,
        routeName: RouteNames.clientAiDoubtSolver,
      ),
      (
        title: '30-Min On-Demand Video Consultation',
        desc: 'Book one-on-one live video consultations with verified interior designers & Vastu experts with instant screen sharing & live sketch whiteboard.',
        badge: 'LIVE VIDEO • EXPERT ADVICE',
        color: const Color(0xFFEC4899),
        icon: Icons.video_call_rounded,
        routeName: RouteNames.clientDesignerCall,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final isTwoCol = constraints.maxWidth > 700;
        final cardWidth = isTwoCol ? (constraints.maxWidth - 14) / 2 : double.infinity;

        return Wrap(
          spacing: 14,
          runSpacing: 14,
          children: tools.map((tool) {
            return SizedBox(
              width: cardWidth,
              child: Container(
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
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: tool.color.withValues(alpha: 0.12),
                            borderRadius: AppRadius.md,
                          ),
                          child: Icon(tool.icon, size: 22, color: tool.color),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                decoration: BoxDecoration(
                                  color: tool.color.withValues(alpha: 0.12),
                                  borderRadius: AppRadius.full,
                                ),
                                child: Text(
                                  tool.badge,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.w800,
                                    color: tool.color,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                tool.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      tool.desc,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: () => context.goNamed(tool.routeName),
                        icon: const Icon(Icons.arrow_forward_rounded, size: 15),
                        label: Text(
                          'Open Tool',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        style: FilledButton.styleFrom(
                          backgroundColor: tool.color,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(borderRadius: AppRadius.md),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildRecentGenerations(BuildContext context, bool isDark, bool isMobile) {
    final recents = [
      (
        title: 'Master Living Area • Modern Minimalist',
        date: 'Generated Sep 3, 2026',
        tokens: '10 Tokens',
        theme: 'Warm Ambient • 3000K',
        colors: [const Color(0xFF6366F1), const Color(0xFF8B5CF6)],
      ),
      (
        title: 'Gourmet Kitchen • Acrylic High Gloss',
        date: 'Generated Sep 1, 2026',
        tokens: '10 Tokens',
        theme: 'Studio Bright • 4000K',
        colors: [const Color(0xFF0EA5E9), const Color(0xFF38BDF8)],
      ),
      (
        title: 'Master Bedroom • Neo-Classical',
        date: 'Generated Aug 28, 2026',
        tokens: '10 Tokens',
        theme: 'Daylight Natural • 5500K',
        colors: [const Color(0xFF10B981), const Color(0xFF34D399)],
      ),
    ];

    return Container(
      padding: const EdgeInsets.all(18),
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
          if (isMobile)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.history_edu_rounded, size: 18, color: Color(0xFF8B5CF6)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Recent Studio Generations',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => context.goNamed(RouteNames.clientAiRoomGen),
                    child: Text(
                      'View All in Generator →',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF6366F1),
                      ),
                    ),
                  ),
                ),
              ],
            )
          else
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.history_edu_rounded, size: 18, color: Color(0xFF8B5CF6)),
                    const SizedBox(width: 8),
                    Text(
                      'Recent Studio Generations',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () => context.goNamed(RouteNames.clientAiRoomGen),
                  child: Text(
                    'View All in Generator →',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF6366F1),
                    ),
                  ),
                ),
              ],
            ),
          const SizedBox(height: 12),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: recents.length,
            separatorBuilder: (context, index) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final r = recents[index];
              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                  borderRadius: AppRadius.md,
                  border: Border.all(
                    color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: r.colors),
                        borderRadius: AppRadius.sm,
                      ),
                      child: const Icon(Icons.view_in_ar_rounded, color: Colors.white, size: 22),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            r.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: isDark ? Colors.white : const Color(0xFF0F172A),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${r.date} • ${r.theme}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    OutlinedButton(
                      onPressed: () => context.goNamed(RouteNames.clientAiRoomGen),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
                      ),
                      child: Text(
                        'Compare 50/50',
                        style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
