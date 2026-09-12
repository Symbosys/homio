import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../services/ai_studio_service.dart';

class AiProjectContextBanner extends StatelessWidget {
  final VoidCallback? onEditContext;
  final bool compact;

  const AiProjectContextBanner({
    super.key,
    this.onEditContext,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final project = AiStudioService.instance.projectContext;

    if (compact) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF161F30) : const Color(0xFFEEF2FF),
          borderRadius: AppRadius.md,
          border: Border.all(
            color: isDark ? const Color(0xFF2E3D5C) : const Color(0xFFC7D2FE),
          ),
        ),
        child: Row(
          children: [
            const Icon(Icons.home_work_rounded, size: 18, color: AppColors.primaryLight),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                '${project.projectName} · ${project.unitType} (${project.carpetAreaSqFt.toInt()} sq.ft)',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.getTextPrimary(context),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.15),
                borderRadius: AppRadius.sm,
              ),
              child: Text(
                project.currentStage,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryLight,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF131B2E) : const Color(0xFFF5F7FF),
        borderRadius: AppRadius.lg,
        border: Border.all(
          color: isDark ? const Color(0xFF263554) : const Color(0xFFD6E0FF),
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isNarrow = constraints.maxWidth < 640;

          final infoChips = [
            _buildBadge(
              context,
              icon: Icons.architecture_rounded,
              label: '${project.carpetAreaSqFt.toInt()} sq.ft',
              sublabel: project.unitType,
            ),
            _buildBadge(
              context,
              icon: Icons.palette_outlined,
              label: project.preferredTheme,
              sublabel: 'Default Style',
            ),
            _buildBadge(
              context,
              icon: Icons.trending_up_rounded,
              label: project.currentStage,
              sublabel: 'Active Stage',
            ),
            _buildBadge(
              context,
              icon: Icons.currency_rupee_rounded,
              label: '₹${(project.allocatedBudget / 100000).toStringAsFixed(1)}L',
              sublabel: 'Allocated Budget',
            ),
          ];

          if (isNarrow) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.15),
                        borderRadius: AppRadius.md,
                      ),
                      child: const Icon(
                        Icons.home_work_rounded,
                        color: AppColors.primaryLight,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            project.projectName,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: AppColors.getTextPrimary(context),
                            ),
                          ),
                          Text(
                            'AI Studio linked to live project specifications',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              color: AppColors.getTextSecondary(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: infoChips,
                ),
              ],
            );
          }

          return Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  borderRadius: AppRadius.md,
                ),
                child: const Icon(
                  Icons.home_work_rounded,
                  color: AppColors.primaryLight,
                  size: 24,
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
                          project.projectName,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.getTextPrimary(context),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.success.withValues(alpha: 0.15),
                            borderRadius: AppRadius.xs,
                          ),
                          child: Text(
                            'LIVE SYNC',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: AppColors.success,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'AI tools automatically calibrate to your carpet area, floor plan, and material theme.',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        color: AppColors.getTextSecondary(context),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: infoChips,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBadge(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String sublabel,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1B2438) : Colors.white,
        borderRadius: AppRadius.md,
        border: Border.all(
          color: isDark ? const Color(0xFF2B3A5A) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.primaryLight),
          const SizedBox(width: 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.getTextPrimary(context),
                ),
              ),
              Text(
                sublabel,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 9,
                  fontWeight: FontWeight.w500,
                  color: AppColors.getTextMuted(context),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
