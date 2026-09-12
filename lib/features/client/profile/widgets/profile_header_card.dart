import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/responsive/breakpoints.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../models/profile_models.dart';
import 'edit_profile_modal.dart';

/// Hero header card showcasing customer identity, member status & masked credentials
class ProfileHeaderCard extends StatelessWidget {
  final CustomerProfile profile;

  const ProfileHeaderCard({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isMobile = Breakpoints.isCompact(context);

    return Container(
      padding: const EdgeInsets.all(20),
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
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar with camera overlay badge
              Stack(
                children: [
                  Container(
                    width: isMobile ? 64 : 76,
                    height: isMobile ? 64 : 76,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [AppColors.primary, const Color(0xFF6366F1)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${profile.firstName[0]}${profile.lastName[0]}',
                      style: GoogleFonts.inter(
                        fontSize: isMobile ? 22 : 26,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isDark ? AppColors.darkSurfaceElevated : Colors.white,
                        border: Border.all(
                          color: isDark ? AppColors.darkBorder : Colors.grey.shade300,
                          width: 1.5,
                        ),
                      ),
                      child: Icon(
                        Icons.camera_alt_rounded,
                        size: 13,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),

              // Name + Member Tier + Quick Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            profile.fullName,
                            style: GoogleFonts.inter(
                              fontSize: isMobile ? 18 : 22,
                              fontWeight: FontWeight.w800,
                              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.verified_rounded, size: 18, color: Color(0xFF10B981)),
                      ],
                    ),
                    const SizedBox(height: 4),

                    // Tier Pill
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.shield_rounded, size: 12, color: Color(0xFF10B981)),
                          const SizedBox(width: 4),
                          Text(
                            profile.memberTier,
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF10B981),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Masked Credentials Pills
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: [
                        _buildMaskedPill(
                          icon: Icons.phone_android_rounded,
                          text: profile.maskedMobile,
                          isVerified: profile.isPhoneVerified,
                          isDark: isDark,
                        ),
                        _buildMaskedPill(
                          icon: Icons.email_outlined,
                          text: profile.maskedEmail,
                          isVerified: profile.isEmailVerified,
                          isDark: isDark,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Edit Profile Button (Desktop)
              if (!isMobile)
                ElevatedButton.icon(
                  onPressed: () => EditProfileModal.show(context),
                  icon: const Icon(Icons.edit_outlined, size: 15),
                  label: Text(
                    'Edit Profile',
                    style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDark ? AppColors.darkSurfaceElevated : Colors.grey.shade100,
                    foregroundColor: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadius.md,
                      side: BorderSide(
                        color: isDark ? AppColors.darkBorder : Colors.grey.shade300,
                      ),
                    ),
                    elevation: 0,
                  ),
                ),
            ],
          ),

          // Edit Profile Button (Mobile Full Width)
          if (isMobile) ...[
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => EditProfileModal.show(context),
                icon: const Icon(Icons.edit_outlined, size: 15),
                label: Text(
                  'Edit Profile',
                  style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDark ? AppColors.darkSurfaceElevated : Colors.grey.shade100,
                  foregroundColor: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: AppRadius.md,
                    side: BorderSide(
                      color: isDark ? AppColors.darkBorder : Colors.grey.shade300,
                    ),
                  ),
                  elevation: 0,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMaskedPill({
    required IconData icon,
    required String text,
    required bool isVerified,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurfaceElevated : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : Colors.grey.shade200,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
          const SizedBox(width: 4),
          Text(
            text,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            ),
          ),
          if (isVerified) ...[
            const SizedBox(width: 4),
            const Icon(Icons.check_circle_rounded, size: 11, color: Color(0xFF10B981)),
          ],
        ],
      ),
    );
  }
}
