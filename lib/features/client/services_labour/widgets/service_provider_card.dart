import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../models/service_labour_models.dart';

/// Card displaying a verified labour / service provider in the directory
class ServiceProviderCard extends StatelessWidget {
  final LabourServiceProvider provider;
  final VoidCallback onViewProfile;
  final VoidCallback onRequestService;

  const ServiceProviderCard({
    super.key,
    required this.provider,
    required this.onViewProfile,
    required this.onRequestService,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: AppRadius.lg,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : Colors.grey.shade200,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row: Avatar + Name & Trade + Verified badge
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: provider.avatarColor.withValues(alpha: 0.15),
                  border: Border.all(color: provider.avatarColor.withValues(alpha: 0.4), width: 1.5),
                ),
                alignment: Alignment.center,
                child: Text(
                  provider.initials,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: provider.avatarColor,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            provider.name,
                            style: GoogleFonts.inter(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (provider.isVerified) ...[
                          const SizedBox(width: 6),
                          const Icon(Icons.verified_rounded, size: 16, color: Color(0xFF10B981)),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      provider.trade,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: provider.avatarColor,
                      ),
                    ),
                  ],
                ),
              ),
              // Availability Pill
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: provider.availabilityStatus.contains('Today')
                      ? const Color(0xFF10B981).withValues(alpha: 0.12)
                      : const Color(0xFFF59E0B).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  provider.availabilityStatus,
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: provider.availabilityStatus.contains('Today')
                        ? const Color(0xFF10B981)
                        : const Color(0xFFF59E0B),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Stats Bar: Rating, Completed Jobs, Rate/Day
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurfaceElevated : const Color(0xFFF8FAFC),
              borderRadius: AppRadius.md,
              border: Border.all(
                color: isDark ? AppColors.darkBorder : Colors.grey.shade200,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  children: [
                    const Icon(Icons.star_rounded, size: 15, color: Color(0xFFF59E0B)),
                    const SizedBox(width: 4),
                    Text(
                      '${provider.rating}',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                      ),
                    ),
                  ],
                ),
                Container(height: 14, width: 1, color: isDark ? AppColors.darkBorder : Colors.grey.shade300),
                Text(
                  '${provider.completedJobs} Jobs',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                ),
                Container(height: 14, width: 1, color: isDark ? AppColors.darkBorder : Colors.grey.shade300),
                Text(
                  '₹${provider.dailyRate} / Day',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF10B981),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // Location & Experience
          Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 13,
                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  '${provider.serviceArea} · ${provider.experienceYears} yrs exp',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Action buttons: [View Profile] and [Request Service]
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onViewProfile,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: AppRadius.md),
                    side: BorderSide(
                      color: isDark ? AppColors.darkBorder : Colors.grey.shade300,
                    ),
                  ),
                  child: Text(
                    'Profile',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 2,
                child: ElevatedButton.icon(
                  onPressed: onRequestService,
                  icon: const Icon(Icons.bolt_rounded, size: 16),
                  label: Text(
                    'Book Labour',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: AppRadius.md),
                    elevation: 0,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
