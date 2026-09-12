import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../models/models.dart';
import '../services/ai_studio_service.dart';
import '../widgets/widgets.dart';

class AiHistoryPage extends StatefulWidget {
  const AiHistoryPage({super.key});

  @override
  State<AiHistoryPage> createState() => _AiHistoryPageState();
}

class _AiHistoryPageState extends State<AiHistoryPage> {
  AiArtifactType? _selectedType;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final allHistory = AiStudioService.instance.history;

    final filtered = _selectedType == null
        ? allHistory
        : allHistory.where((h) => h.type == _selectedType).toList();

    return AiStudioPageScaffold(
      title: 'AI Generation History & Archive',
      subtitle: 'Complete Audit Log of All 3D Transformations, Vastu Diagnostic Runs, Budget Models & Technical Advice',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                ChoiceChip(
                  label: Text('All Types (${allHistory.length})'),
                  selected: _selectedType == null,
                  onSelected: (_) => setState(() => _selectedType = null),
                  selectedColor: isDark ? const Color(0xFF1E2843) : const Color(0xFFEEF2FF),
                  backgroundColor: isDark ? const Color(0xFF161F30) : const Color(0xFFF1F5F9),
                  labelStyle: TextStyle(
                    color: _selectedType == null ? AppColors.primaryLight : AppColors.getTextSecondary(context),
                    fontWeight: _selectedType == null ? FontWeight.w700 : FontWeight.w500,
                  ),
                  shape: RoundedRectangleBorder(borderRadius: AppRadius.full),
                ),
                ...AiArtifactType.values.map((type) {
                  final isSelected = type == _selectedType;
                  return Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: ChoiceChip(
                      label: Text(type.label),
                      selected: isSelected,
                      onSelected: (_) => setState(() => _selectedType = type),
                      selectedColor: isDark ? const Color(0xFF1E2843) : const Color(0xFFEEF2FF),
                      backgroundColor: isDark ? const Color(0xFF161F30) : const Color(0xFFF1F5F9),
                      labelStyle: TextStyle(
                        color: isSelected ? AppColors.primaryLight : AppColors.getTextSecondary(context),
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      ),
                      shape: RoundedRectangleBorder(borderRadius: AppRadius.full),
                    ),
                  );
                }),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Timeline List
          if (filtered.isEmpty)
            const EmptyStateView(
              icon: Icons.history_toggle_off_rounded,
              title: 'No activity found',
              description: 'Run any of the AI Studio tools to populate your project timeline.',
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filtered.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = filtered[index];
                return _buildHistoryRow(context, item, isDark);
              },
            ),
        ],
      ),
    );
  }

  Widget _buildHistoryRow(BuildContext context, AiGenerationHistoryItem item, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: AppRadius.lg,
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primaryLight.withValues(alpha: 0.12),
              borderRadius: AppRadius.md,
            ),
            child: Icon(_getIconForType(item.type), color: AppColors.primaryLight, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF161F30) : const Color(0xFFF1F5F9),
                        borderRadius: AppRadius.xs,
                      ),
                      child: Text(
                        item.type.label,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryLight,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${item.creditsUsed} Credits Used',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFFF59E0B),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  item.title,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.getTextPrimary(context),
                  ),
                ),
                Text(
                  item.subtitle,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    color: AppColors.getTextSecondary(context),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton(
            onPressed: () => context.go(item.destinationRoute),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              shape: RoundedRectangleBorder(borderRadius: AppRadius.md),
            ),
            child: Text(
              'Open Tool',
              style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIconForType(AiArtifactType type) {
    switch (type) {
      case AiArtifactType.roomRender:
        return Icons.meeting_room_rounded;
      case AiArtifactType.imageJob:
        return Icons.image_rounded;
      case AiArtifactType.videoWalkthrough:
        return Icons.videocam_rounded;
      case AiArtifactType.vastuAudit:
        return Icons.compass_calibration_rounded;
      case AiArtifactType.budgetSpec:
        return Icons.calculate_rounded;
      case AiArtifactType.technicalDoubt:
        return Icons.psychology_rounded;
    }
  }
}
