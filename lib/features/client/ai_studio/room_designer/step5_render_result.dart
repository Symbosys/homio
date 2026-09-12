import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../models/room_design_session.dart';
import '../widgets/dual_view_comparison.dart';

class Step5RenderResult extends StatelessWidget {
  final RoomDesignSession session;
  final VoidCallback onSaveToMoodboard;
  final VoidCallback onAddMaterialsToBOQ;
  final VoidCallback onBookDesignerConsultation;
  final VoidCallback onDownloadRender;
  final VoidCallback onResetAndNewDesign;

  const Step5RenderResult({
    super.key,
    required this.session,
    required this.onSaveToMoodboard,
    required this.onAddMaterialsToBOQ,
    required this.onBookDesignerConsultation,
    required this.onDownloadRender,
    required this.onResetAndNewDesign,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final beforeImg = session.baseUploadImageUrl ??
        'https://images.unsplash.com/photo-1513694203232-719a280e022f?w=900&auto=format&fit=crop&q=80';
    final afterImg = session.renderedImageUrl ??
        'https://images.unsplash.com/photo-1618221195710-dd6b41faaea6?w=900&auto=format&fit=crop&q=80';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with status & actions
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.15),
                borderRadius: AppRadius.md,
              ),
              child: const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${session.roomType.label} — ${session.styleTheme}',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.getTextPrimary(context),
                    ),
                  ),
                  Text(
                    'Photorealistic 3D synthesis calibrated to ${session.lengthFt.toInt()}ft x ${session.widthFt.toInt()}ft (${session.floorAreaSqFt.toInt()} sq.ft)',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12.5,
                      color: AppColors.getTextSecondary(context),
                    ),
                  ),
                ],
              ),
            ),
            Wrap(
              spacing: 8,
              children: [
                OutlinedButton.icon(
                  onPressed: onDownloadRender,
                  icon: const Icon(Icons.download_rounded, size: 16),
                  label: Text(
                    'Download 4K',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: AppRadius.md),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: onSaveToMoodboard,
                  icon: const Icon(Icons.bookmark_added_rounded, size: 16),
                  label: Text(
                    'Save to Studio Vault',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: AppRadius.md),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Interactive 50/50 Dual View Slider
        DualViewComparison(
          beforeImageUrl: beforeImg,
          afterImageUrl: afterImg,
          beforeLabel: 'Raw Site Photo',
          afterLabel: '3D Synthesized Design',
          height: 460,
        ),
        const SizedBox(height: 24),

        // Design Specs & Material Callouts Strip
        LayoutBuilder(
          builder: (context, constraints) {
            final isNarrow = constraints.maxWidth < 750;

            final colorPaletteBlock = _buildDetailCard(
              context,
              title: 'Harmonized Color Palette',
              child: Row(
                children: session.colorPaletteHex.map((hex) {
                  final color = Color(int.parse(hex.replaceFirst('#', '0xFF')));
                  return Container(
                    width: 32,
                    height: 32,
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black12, width: 1.5),
                    ),
                  );
                }).toList(),
              ),
            );

            final budgetBlock = _buildDetailCard(
              context,
              title: 'Calibrated Cost Estimate',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '₹${(session.estimatedCostLow / 100000).toStringAsFixed(1)}L - ₹${(session.estimatedCostHigh / 100000).toStringAsFixed(1)}L',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primaryLight,
                    ),
                  ),
                  Text(
                    'Includes BWP 710 ply carcass, hardware, lighting & turnkey execution',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      color: AppColors.getTextSecondary(context),
                    ),
                  ),
                ],
              ),
            );

            final vastuBlock = _buildDetailCard(
              context,
              title: 'Vastu Compliance Score',
              child: Row(
                children: [
                  const Icon(Icons.verified_rounded, size: 20, color: Color(0xFF10B981)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      session.vastuComplianceSummary.isNotEmpty
                          ? session.vastuComplianceSummary
                          : 'Bed headboard against South wall, optimal Agni alignment',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.getTextPrimary(context),
                      ),
                    ),
                  ),
                ],
              ),
            );

            if (isNarrow) {
              return Column(
                children: [
                  colorPaletteBlock,
                  const SizedBox(height: 12),
                  budgetBlock,
                  const SizedBox(height: 12),
                  vastuBlock,
                ],
              );
            }

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: colorPaletteBlock),
                const SizedBox(width: 14),
                Expanded(child: budgetBlock),
                const SizedBox(width: 14),
                Expanded(child: vastuBlock),
              ],
            );
          },
        ),
        const SizedBox(height: 24),

        // Specified Brand Materials List
        Container(
          padding: const EdgeInsets.all(20),
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
              Row(
                children: [
                  const Icon(Icons.texture_rounded, size: 20, color: AppColors.primaryLight),
                  const SizedBox(width: 10),
                  Text(
                    'Specified Materials & Indian Standards',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.getTextPrimary(context),
                    ),
                  ),
                  const Spacer(),
                  ElevatedButton.icon(
                    onPressed: onAddMaterialsToBOQ,
                    icon: const Icon(Icons.playlist_add_check_rounded, size: 16),
                    label: Text(
                      'Sync All to Project BOQ',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.success,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              ...session.specifiedMaterials.map((mat) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle_outline_rounded, size: 16, color: AppColors.success),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          mat,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                            color: AppColors.getTextPrimary(context),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Next Actions Callout
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E1B4B) : const Color(0xFFEEF2FF),
            borderRadius: AppRadius.lg,
            border: Border.all(
              color: isDark ? const Color(0xFF3730A3) : const Color(0xFFC7D2FE),
            ),
          ),
          child: Row(
            children: [
              const Icon(Icons.video_call_rounded, size: 26, color: AppColors.primaryLight),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Review this 3D design live with a Senior Architect',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.getTextPrimary(context),
                      ),
                    ),
                    Text(
                      'Book a 30-minute 1-on-1 video call to adjust furniture dimensions or change wood stains.',
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
                onPressed: onBookDesignerConsultation,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: AppRadius.md),
                ),
                child: Text(
                  'Book Video Call',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Center(
          child: TextButton.icon(
            onPressed: onResetAndNewDesign,
            icon: const Icon(Icons.restart_alt_rounded, size: 16),
            label: Text(
              'Design Another Room',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
            style: TextButton.styleFrom(foregroundColor: AppColors.primaryLight),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailCard(
    BuildContext context, {
    required String title,
    required Widget child,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
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
          Text(
            title,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.getTextMuted(context),
            ),
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}
