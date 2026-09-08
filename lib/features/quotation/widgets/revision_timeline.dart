import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../models/quotation_models.dart';

/// Version history timeline for tracking all quotation revisions.
class RevisionTimeline extends StatelessWidget {
  final List<QuotationRevision> revisions;
  final ValueChanged<QuotationRevision>? onRestoreRevision;
  final ValueChanged<QuotationRevision>? onCompareRevision;

  const RevisionTimeline({
    super.key,
    required this.revisions,
    this.onRestoreRevision,
    this.onCompareRevision,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (revisions.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            'No revisions yet. Initial version active.',
            style: GoogleFonts.inter(
              fontSize: 12,
              color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
            ),
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: revisions.length,
      itemBuilder: (context, index) {
        final rev = revisions[index];
        final isLatest = index == revisions.length - 1;
        final delta = rev.newTotal - rev.previousTotal;
        final hasDelta = rev.previousTotal > 0;

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
            borderRadius: AppRadius.md,
            border: Border.all(
              color: isLatest
                  ? AppColors.primary
                  : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
              width: isLatest ? 1.2 : 0.8,
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
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: isDark ? 0.2 : 0.1),
                          borderRadius: AppRadius.sm,
                        ),
                        child: Text(
                          'Rev ${rev.revisionNumber}',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        rev.title,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                        ),
                      ),
                      if (isLatest) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                          decoration: BoxDecoration(
                            color: AppColors.success.withValues(alpha: 0.15),
                            borderRadius: AppRadius.sm,
                          ),
                          child: Text(
                            'CURRENT',
                            style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.w700, color: AppColors.success),
                          ),
                        ),
                      ],
                    ],
                  ),
                  Text(
                    '₹${rev.newTotal.toStringAsFixed(0)}',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                rev.changesSummary,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.person_outline_rounded, size: 12, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                      const SizedBox(width: 4),
                      Text(
                        'By ${rev.createdBy} • ${_formatDate(rev.createdAt)}',
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                        ),
                      ),
                      if (hasDelta) ...[
                        const SizedBox(width: 10),
                        Text(
                          '(${delta >= 0 ? '+' : ''}₹${delta.toStringAsFixed(0)})',
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: delta >= 0 ? AppColors.success : AppColors.error,
                          ),
                        ),
                      ],
                    ],
                  ),
                  Row(
                    children: [
                      if (onCompareRevision != null)
                        TextButton(
                          onPressed: () => onCompareRevision!(rev),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            minimumSize: Size.zero,
                          ),
                          child: Text('Compare', style: GoogleFonts.inter(fontSize: 11)),
                        ),
                      if (!isLatest && onRestoreRevision != null)
                        TextButton(
                          onPressed: () => onRestoreRevision!(rev),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            minimumSize: Size.zero,
                            foregroundColor: AppColors.primary,
                          ),
                          child: Text('Restore', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600)),
                        ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatDate(DateTime dt) => '${dt.day}/${dt.month}/${dt.year}';
}
