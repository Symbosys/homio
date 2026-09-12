import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../models/designer_booking.dart';

class ExpertConsultationCard extends StatelessWidget {
  final ExpertDesignerProfile designer;
  final ValueChanged<String> onBookSlot;

  const ExpertConsultationCard({
    super.key,
    required this.designer,
    required this.onBookSlot,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: AppRadius.lg,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: AppColors.primaryLight.withValues(alpha: 0.15),
                child: Text(
                  designer.name.split(' ').map((e) => e.isNotEmpty ? e[0] : '').take(2).join(),
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w800,
                    color: AppColors.primaryLight,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      designer.name,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.getTextPrimary(context),
                      ),
                    ),
                    Text(
                      designer.designation,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11.5,
                        color: AppColors.getTextSecondary(context),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.star_rate_rounded, size: 15, color: Color(0xFFF59E0B)),
                        const SizedBox(width: 3),
                        Text(
                          '${designer.rating}',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w700,
                            color: AppColors.getTextPrimary(context),
                          ),
                        ),
                        Text(
                          ' (${designer.reviewCount} reviews) · ${designer.experienceYears} yrs exp',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            color: AppColors.getTextMuted(context),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: designer.designSpecialties.map((specialty) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF161F30) : const Color(0xFFF1F5F9),
                  borderRadius: AppRadius.xs,
                ),
                child: Text(
                  specialty,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.getTextSecondary(context),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 14),
          const Divider(height: 1),
          const SizedBox(height: 12),
          Text(
            'Available Video Slots Today:',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.getTextMuted(context),
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: designer.availableSlotsToday.map((slot) {
              return ActionChip(
                label: Text(
                  slot,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onPressed: () => onBookSlot(slot),
                backgroundColor: isDark ? const Color(0xFF1E2843) : const Color(0xFFEEF2FF),
                labelStyle: TextStyle(
                  color: isDark ? const Color(0xFF93C5FD) : const Color(0xFF3730A3),
                ),
                shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
                side: BorderSide.none,
                avatar: const Icon(Icons.videocam_rounded, size: 14, color: AppColors.primaryLight),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
