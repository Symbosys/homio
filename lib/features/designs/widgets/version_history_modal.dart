import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../models/design_models.dart';

/// Modal dialog displaying historical versions, diff changelogs, and turnaround timelines.
class VersionHistoryModal extends StatelessWidget {
  final DesignDeliverable deliverable;

  const VersionHistoryModal({
    super.key,
    required this.deliverable,
  });

  static void show({
    required BuildContext context,
    required DesignDeliverable deliverable,
  }) {
    showDialog(
      context: context,
      builder: (ctx) => VersionHistoryModal(deliverable: deliverable),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final history = deliverable.versionHistory.reversed.toList();

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 640, maxHeight: 600),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.history_rounded, color: AppColors.primary),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Version History & Revision Audit',
                            style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w800),
                          ),
                          Text(
                            deliverable.title,
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: isDark ? AppColors.darkMutedText : AppColors.lightMutedText,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 12),

              // Summary stats
              Row(
                children: [
                  _buildStatPill('Total Revisions', 'Rev #${deliverable.revisionCount}', AppColors.primary, isDark),
                  const SizedBox(width: 10),
                  _buildStatPill('Current Active', deliverable.currentVersion, AppColors.success, isDark),
                  const SizedBox(width: 10),
                  _buildStatPill('Format', deliverable.fileType.extension.toUpperCase(), deliverable.fileType.color, isDark),
                ],
              ),
              const SizedBox(height: 16),

              // Version Timeline List
              Expanded(
                child: history.isEmpty
                    ? const Center(child: Text('No historical revisions logged yet.'))
                    : ListView.separated(
                        itemCount: history.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 14),
                        itemBuilder: (context, idx) {
                          final v = history[idx];
                          final isCurrent = v.versionTag == deliverable.currentVersion;

                          return Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: isCurrent
                                  ? AppColors.primary.withValues(alpha: isDark ? 0.15 : 0.06)
                                  : (isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: isCurrent
                                    ? AppColors.primary
                                    : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                                width: isCurrent ? 1.5 : 0.8,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: isCurrent ? AppColors.primary : Colors.grey,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        v.versionTag,
                                        style: GoogleFonts.inter(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      v.fileName,
                                      style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold),
                                    ),
                                    const Spacer(),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: v.reviewStatus.color.withValues(alpha: 0.12),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        v.reviewStatus.label,
                                        style: GoogleFonts.inter(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: v.reviewStatus.color,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Changelog: ${v.changelogNote}',
                                  style: GoogleFonts.inter(fontSize: 11),
                                ),
                                if (v.clientFeedback != null && v.clientFeedback!.isNotEmpty) ...[
                                  const SizedBox(height: 6),
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: AppColors.error.withValues(alpha: 0.08),
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(color: AppColors.error.withValues(alpha: 0.2)),
                                    ),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Icon(Icons.comment_outlined, size: 14, color: AppColors.error),
                                        const SizedBox(width: 6),
                                        Expanded(
                                          child: Text(
                                            'Client Feedback: "${v.clientFeedback}"',
                                            style: GoogleFonts.inter(
                                              fontSize: 10,
                                              fontStyle: FontStyle.italic,
                                              color: AppColors.error,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Text(
                                      'Uploaded by ${v.uploadedByName} • ${_formatDateTime(v.uploadedAt)} • ${v.fileSizeFormatted}',
                                      style: GoogleFonts.inter(
                                        fontSize: 10,
                                        color: isDark ? AppColors.darkMutedText : AppColors.lightMutedText,
                                      ),
                                    ),
                                    const Spacer(),
                                    Text(
                                      'Turnaround: ${v.turnaroundHours}h',
                                      style: GoogleFonts.inter(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatPill(String label, String value, Color color, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('$label: ', style: GoogleFonts.inter(fontSize: 11, color: isDark ? Colors.white70 : Colors.black87)),
          Text(value, style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dt) =>
      '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
}
