import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../models/feedback_models.dart';

/// Card presenting a submitted customer feedback record
class FeedbackHistoryCard extends StatelessWidget {
  final CustomerFeedbackItem item;

  const FeedbackHistoryCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: AppRadius.lg,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : Colors.grey.shade200,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row: Rating score badge + Verified tag + Date
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF59E0B).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star_rounded, size: 16, color: Color(0xFFF59E0B)),
                    const SizedBox(width: 4),
                    Text(
                      '${item.overallScore.toStringAsFixed(1)} / 5',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFFF59E0B),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              if (item.isVerified)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.verified_rounded, size: 11, color: Color(0xFF10B981)),
                      const SizedBox(width: 3),
                      Text(
                        'Verified Client Review',
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF10B981),
                        ),
                      ),
                    ],
                  ),
                ),
              const Spacer(),
              Text(
                item.date,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Title
          Text(
            item.title,
            style: GoogleFonts.inter(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            ),
          ),
          const SizedBox(height: 4),

          // Target Entity / Professional
          Row(
            children: [
              Icon(
                Icons.person_outline_rounded,
                size: 14,
                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              ),
              const SizedBox(width: 4),
              Text(
                item.targetEntity,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Category Scores Row
          if (item.categoryScores.isNotEmpty) ...[
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: item.categoryScores.entries.map((entry) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurfaceElevated : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: isDark ? AppColors.darkBorder : Colors.grey.shade200,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        entry.key,
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.star_rounded, size: 11, color: Color(0xFFF59E0B)),
                      Text(
                        ' ${entry.value.toStringAsFixed(1)}',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 12),
          ],

          // Comments Quote
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.darkSurfaceElevated.withValues(alpha: 0.5)
                  : const Color(0xFFF8FAFC),
              borderRadius: AppRadius.md,
              border: Border.all(
                color: isDark ? AppColors.darkBorder : Colors.grey.shade200,
              ),
            ),
            child: Text(
              '"${item.comments}"',
              style: GoogleFonts.inter(
                fontSize: 13,
                fontStyle: FontStyle.italic,
                height: 1.45,
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Praise Tags
          if (item.tags.isNotEmpty)
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: item.tags.map((tag) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    tag,
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }
}
