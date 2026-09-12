import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/responsive/breakpoints.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../models/service_labour_models.dart';

/// Full technician profile modal sheet or dialog
class ServiceProviderModal extends StatelessWidget {
  final LabourServiceProvider provider;
  final VoidCallback onRequestBooking;

  const ServiceProviderModal({
    super.key,
    required this.provider,
    required this.onRequestBooking,
  });

  static Future<void> show(
    BuildContext context, {
    required LabourServiceProvider provider,
    required VoidCallback onRequestBooking,
  }) {
    final isMobile = Breakpoints.isCompact(context);
    if (isMobile) {
      return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => FractionallySizedBox(
          heightFactor: 0.90,
          child: ServiceProviderModal(
            provider: provider,
            onRequestBooking: onRequestBooking,
          ),
        ),
      );
    }
    return showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560, maxHeight: 720),
          child: ServiceProviderModal(
            provider: provider,
            onRequestBooking: onRequestBooking,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : Colors.grey.shade200,
        ),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: isDark ? AppColors.darkBorder : Colors.grey.shade200,
                ),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: provider.avatarColor.withValues(alpha: 0.15),
                    border: Border.all(color: provider.avatarColor.withValues(alpha: 0.4)),
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
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
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
                      Text(
                        '${provider.trade} · ${provider.serviceArea}',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close_rounded, size: 20),
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                ),
              ],
            ),
          ),

          // Scrollable Body
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Rate & Experience Banner
                  Container(
                    padding: const EdgeInsets.all(14),
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
                        _buildStat('Rating', '${provider.rating} ★', const Color(0xFFF59E0B), isDark),
                        _buildDivider(isDark),
                        _buildStat('Jobs Done', '${provider.completedJobs}', AppColors.primary, isDark),
                        _buildDivider(isDark),
                        _buildStat('Experience', '${provider.experienceYears} Years', const Color(0xFF10B981), isDark),
                        _buildDivider(isDark),
                        _buildStat('Daily Rate', '₹${provider.dailyRate}', const Color(0xFF059669), isDark),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Bio
                  Text(
                    'About Professional',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    provider.bio,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      height: 1.5,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Skills
                  Text(
                    'Trade Specializations & Tool Certifications',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: provider.skills.map((skill) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
                        ),
                        child: Text(
                          skill,
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),

                  // Portfolio Work Areas
                  Text(
                    'Verified HOMIO Site Work',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: provider.portfolioImages.map((work) {
                      return Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 8),
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.darkSurfaceElevated : Colors.grey.shade100,
                            borderRadius: AppRadius.md,
                            border: Border.all(
                              color: isDark ? AppColors.darkBorder : Colors.grey.shade200,
                            ),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                Icons.image_outlined,
                                size: 24,
                                color: isDark ? AppColors.darkTextSecondary : Colors.grey.shade600,
                              ),
                              const SizedBox(height: 6),
                              Text(
                                work,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),

                  // Customer Reviews
                  Text(
                    'Client Reviews (${provider.reviews.length})',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...provider.reviews.map((rev) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkSurfaceElevated : const Color(0xFFF8FAFC),
                        borderRadius: AppRadius.md,
                        border: Border.all(
                          color: isDark ? AppColors.darkBorder : Colors.grey.shade200,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                rev.clientName,
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(Icons.star_rounded, size: 14, color: Color(0xFFF59E0B)),
                              Text(
                                '${rev.rating}',
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFFF59E0B),
                                ),
                              ),
                              const Spacer(),
                              Text(
                                rev.date,
                                style: GoogleFonts.inter(
                                  fontSize: 10,
                                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '"${rev.comment}"',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),

          // Bottom Action Bar
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCard : Colors.white,
              border: Border(
                top: BorderSide(
                  color: isDark ? AppColors.darkBorder : Colors.grey.shade200,
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).pop();
                      onRequestBooking();
                    },
                    icon: const Icon(Icons.calendar_month_rounded, size: 18),
                    label: Text(
                      'Request Service (₹${provider.dailyRate}/Day)',
                      style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(borderRadius: AppRadius.md),
                      elevation: 0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String label, String value, Color color, bool isDark) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 10,
            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider(bool isDark) {
    return Container(
      height: 22,
      width: 1,
      color: isDark ? AppColors.darkBorder : Colors.grey.shade300,
    );
  }
}
