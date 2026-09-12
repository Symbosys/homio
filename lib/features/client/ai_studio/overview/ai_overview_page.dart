import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../app/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../models/models.dart';
import '../services/ai_studio_service.dart';
import '../widgets/widgets.dart';

class AiOverviewPage extends StatefulWidget {
  const AiOverviewPage({super.key});

  @override
  State<AiOverviewPage> createState() => _AiOverviewPageState();
}

class _AiOverviewPageState extends State<AiOverviewPage> {
  AiToolCategory? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final allTools = AiStudioService.instance.tools;
    final filteredTools = _selectedCategory == null
        ? allTools
        : allTools.where((t) => t.category == _selectedCategory).toList();

    return Scaffold(
      backgroundColor: AppColors.getBackground(context),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1240),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Navigation Header with Title & Credit Balance
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight.withValues(alpha: 0.15),
                          borderRadius: AppRadius.md,
                        ),
                        child: const Icon(
                          Icons.auto_awesome_rounded,
                          color: AppColors.primaryLight,
                          size: 26,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'HOMIO AI Studio',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.getTextPrimary(context),
                                    letterSpacing: -0.5,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withValues(alpha: 0.15),
                                    borderRadius: AppRadius.xs,
                                  ),
                                  child: Text(
                                    'PRO WORKSPACE',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.primaryLight,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Architectural-grade 3D visualization, material intelligence, Vastu audits & designer consultations',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13,
                                color: AppColors.getTextSecondary(context),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      const AiCreditChip(),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Project Context Live Banner
                  const AiProjectContextBanner(),
                  const SizedBox(height: 24),

                  // Hero Action Showcase
                  _buildHeroCallout(context, isDark),
                  const SizedBox(height: 28),

                  // Category Filter Chips
                  Row(
                    children: [
                      Text(
                        'AI Tools Workspace',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: AppColors.getTextPrimary(context),
                        ),
                      ),
                      const Spacer(),
                      _buildCategoryChip(
                        context,
                        label: 'All Tools (${allTools.length})',
                        isSelected: _selectedCategory == null,
                        onTap: () => setState(() => _selectedCategory = null),
                        isDark: isDark,
                      ),
                      const SizedBox(width: 6),
                      _buildCategoryChip(
                        context,
                        label: '3D & Visuals',
                        isSelected: _selectedCategory == AiToolCategory.design3D,
                        onTap: () => setState(() => _selectedCategory = AiToolCategory.design3D),
                        isDark: isDark,
                      ),
                      const SizedBox(width: 6),
                      _buildCategoryChip(
                        context,
                        label: 'Technical & Vastu',
                        isSelected: _selectedCategory == AiToolCategory.technical,
                        onTap: () => setState(() => _selectedCategory = AiToolCategory.technical),
                        isDark: isDark,
                      ),
                      const SizedBox(width: 6),
                      _buildCategoryChip(
                        context,
                        label: 'Consultation & Budget',
                        isSelected: _selectedCategory == AiToolCategory.financial,
                        onTap: () => setState(() => _selectedCategory = AiToolCategory.financial),
                        isDark: isDark,
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),

                  // Tools Grid (Responsive 1-col mobile, 2-col tablet, 3-col desktop)
                  LayoutBuilder(
                    builder: (context, constraints) {
                      int crossAxisCount = 1;
                      if (constraints.maxWidth >= 1080) {
                        crossAxisCount = 3;
                      } else if (constraints.maxWidth >= 680) {
                        crossAxisCount = 2;
                      }

                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: filteredTools.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: crossAxisCount == 1 ? 1.6 : 1.15,
                        ),
                        itemBuilder: (context, index) {
                          final tool = filteredTools[index];
                          return AiToolCard(
                            tool: tool,
                            onTap: () => context.go(tool.routePath),
                          );
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 36),

                  // Recent Generations Activity Strip
                  _buildRecentGenerationsSection(context, isDark),
                  const SizedBox(height: 36),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChip(
    BuildContext context, {
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return ChoiceChip(
      label: Text(
        label,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 11.5,
          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
        ),
      ),
      selected: isSelected,
      onSelected: (_) => onTap(),
      selectedColor: isDark ? const Color(0xFF1E2843) : const Color(0xFFEEF2FF),
      backgroundColor: isDark ? const Color(0xFF161F30) : const Color(0xFFF1F5F9),
      labelStyle: TextStyle(
        color: isSelected
            ? AppColors.primaryLight
            : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
      ),
      shape: RoundedRectangleBorder(borderRadius: AppRadius.full),
      side: BorderSide(
        color: isSelected
            ? AppColors.primaryLight.withValues(alpha: 0.5)
            : Colors.transparent,
      ),
    );
  }

  Widget _buildHeroCallout(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF1E1B4B), const Color(0xFF172554)]
              : [const Color(0xFF4F46E5), const Color(0xFF6366F1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: AppRadius.xl,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4F46E5).withValues(alpha: isDark ? 0.3 : 0.25),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isNarrow = constraints.maxWidth < 720;

          final content = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: AppRadius.xs,
                ),
                child: Text(
                  'HOMIO NEURAL ARCHITECTURE ENGINE',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Transform your apartment rooms with precision 3D styling & Indian IS standard materials.',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Upload your current site photo to generate 50/50 photorealistic renders calibrated with CenturyPly, Hettich, and Asian Paints.',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  color: Colors.white.withValues(alpha: 0.85),
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 18),
              Wrap(
                spacing: 12,
                runSpacing: 10,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => context.go(RouteNames.clientAiRoomGenPath),
                    icon: const Icon(Icons.auto_awesome_rounded, size: 16),
                    label: Text(
                      'Launch 3D Room Designer',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF4F46E5),
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: AppRadius.md),
                    ),
                  ),
                  OutlinedButton.icon(
                    onPressed: () => context.go(RouteNames.clientAiVastuPath),
                    icon: const Icon(Icons.compass_calibration_rounded, size: 16),
                    label: Text(
                      'Audit Floorplan Vastu',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.white70),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: AppRadius.md),
                    ),
                  ),
                ],
              ),
            ],
          );

          if (isNarrow) return content;

          return Row(
            children: [
              Expanded(flex: 3, child: content),
              const SizedBox(width: 24),
              Expanded(
                flex: 2,
                child: Container(
                  height: 180,
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.15),
                    borderRadius: AppRadius.lg,
                    border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.verified_rounded, size: 18, color: Color(0xFF34D399)),
                          const SizedBox(width: 8),
                          Text(
                            'Calibrated Parameters',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      _buildCalibratedBullet('Indian IS Codes & NBC 2016 Compliant'),
                      _buildCalibratedBullet('IS:710 Marine & IS:1658 HDHMR standards'),
                      _buildCalibratedBullet('Direct sync with Project BOQ & Quotations'),
                      _buildCalibratedBullet('1-on-1 human architect review available'),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCalibratedBullet(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 4,
            decoration: const BoxDecoration(color: Colors.white70, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                color: Colors.white.withValues(alpha: 0.85),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentGenerationsSection(BuildContext context, bool isDark) {
    final history = AiStudioService.instance.history;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Recent AI Generations & Audits',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.getTextPrimary(context),
              ),
            ),
            const Spacer(),
            TextButton.icon(
              onPressed: () => context.go('/client/ai-history'),
              icon: const Icon(Icons.history_rounded, size: 16),
              label: Text(
                'View All History',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primaryLight,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        if (history.isEmpty)
          const EmptyStateView(
            icon: Icons.history_toggle_off_rounded,
            title: 'No generations yet',
            description: 'Run any of the 10 AI Studio tools to start building your project portfolio.',
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: history.take(4).length,
            separatorBuilder: (context, index) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final item = history[index];

              return Container(
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
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight.withValues(alpha: 0.12),
                        borderRadius: AppRadius.sm,
                      ),
                      child: Icon(
                        item.type == AiArtifactType.roomRender
                            ? Icons.meeting_room_rounded
                            : (item.type == AiArtifactType.vastuAudit
                                ? Icons.compass_calibration_rounded
                                : (item.type == AiArtifactType.budgetSpec
                                    ? Icons.calculate_rounded
                                    : Icons.psychology_rounded)),
                        color: AppColors.primaryLight,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w700,
                              color: AppColors.getTextPrimary(context),
                            ),
                          ),
                          Text(
                            item.subtitle,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11.5,
                              color: AppColors.getTextSecondary(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    OutlinedButton(
                      onPressed: () => context.go(item.destinationRoute),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: isDark ? AppColors.darkBorderStrong : AppColors.lightBorderStrong,
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
                      ),
                      child: Text(
                        'Open Tool',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          color: AppColors.getTextPrimary(context),
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
}
