import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../models/quotation_models.dart';

/// Customer self-service estimated proposal summary card.
class EstimateResult extends StatelessWidget {
  final CustomerSelfEstimateLead estimate;
  final VoidCallback onBookConsultation;
  final VoidCallback onWhatsAppChat;
  final VoidCallback onDownloadSummary;

  const EstimateResult({
    super.key,
    required this.estimate,
    required this.onBookConsultation,
    required this.onWhatsAppChat,
    required this.onDownloadSummary,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: AppRadius.lg,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          width: 0.8,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check_circle_rounded, size: 36, color: AppColors.success),
          ),
          const SizedBox(height: 14),
          Text(
            'Your Instant Interior Estimate',
            style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(
            'For ${estimate.propertyType} (${estimate.carpetAreaSqft.toInt()} Sq.Ft) • ${estimate.tier.title}',
            style: GoogleFonts.inter(
              fontSize: 13,
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
            ),
          ),
          const SizedBox(height: 20),

          // Big Budget Range Box
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primary.withValues(alpha: isDark ? 0.25 : 0.12),
                  const Color(0xFF8B5CF6).withValues(alpha: isDark ? 0.25 : 0.12),
                ],
              ),
              borderRadius: AppRadius.md,
              border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
            ),
            child: Column(
              children: [
                Text(
                  'ESTIMATED BUDGET RANGE',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 6),
                FittedBox(
                  child: Text(
                    '₹${_formatInLakhs(estimate.estimatedMinBudget)} - ₹${_formatInLakhs(estimate.estimatedMaxBudget)}',
                    style: GoogleFonts.inter(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                      letterSpacing: -0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '*Inclusive of material, installation, 3D design and 10-year warranty.',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Selected Spaces Breakdown
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Selected Scope of Work:',
              style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: estimate.selectedRooms.map((room) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurfaceElevated : Colors.grey.shade100,
                  borderRadius: AppRadius.sm,
                  border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check_rounded, size: 13, color: AppColors.primary),
                    const SizedBox(width: 6),
                    Text(room, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500)),
                  ],
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),

          // CTAs
          Wrap(
            spacing: 12,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children: [
              FilledButton.icon(
                onPressed: onBookConsultation,
                icon: const Icon(Icons.calendar_month_rounded, size: 16),
                label: const Text('Book Free 3D Design Session'),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
                ),
              ),
              FilledButton.icon(
                onPressed: onWhatsAppChat,
                icon: const Icon(Icons.chat_bubble_rounded, size: 16),
                label: const Text('Chat with Designer'),
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF25D366),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
                ),
              ),
              OutlinedButton.icon(
                onPressed: onDownloadSummary,
                icon: const Icon(Icons.download_rounded, size: 16),
                label: const Text('Download Estimate PDF'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatInLakhs(double amount) {
    if (amount >= 100000) {
      return '${(amount / 100000).toStringAsFixed(2)} Lakhs';
    }
    return amount.toStringAsFixed(0);
  }
}
