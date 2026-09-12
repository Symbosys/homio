import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../models/service_labour_models.dart';

/// Card showing an active or completed service booking in the Bookings tab
class ServiceBookingCard extends StatelessWidget {
  final ServiceBooking booking;
  final VoidCallback onViewDetails;

  const ServiceBookingCard({
    super.key,
    required this.booking,
    required this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isCompleted = booking.status == 'Completed';

    final statusColor = isCompleted
        ? const Color(0xFF10B981)
        : (booking.status == 'Work in Progress' ? AppColors.primary : const Color(0xFFF59E0B));

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
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
      child: ClipRRect(
        borderRadius: AppRadius.lg,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Bar: ID + Status
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurfaceElevated : const Color(0xFFF8FAFC),
                border: Border(
                  bottom: BorderSide(
                    color: isDark ? AppColors.darkBorder : Colors.grey.shade200,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Text(
                    booking.id,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '•  ${booking.serviceType}',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      booking.status,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: statusColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Body
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: booking.provider.avatarColor.withValues(alpha: 0.15),
                          border: Border.all(color: booking.provider.avatarColor.withValues(alpha: 0.3)),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          booking.provider.initials,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: booking.provider.avatarColor,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  booking.provider.name,
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                                  ),
                                ),
                                if (booking.provider.isVerified) ...[
                                  const SizedBox(width: 4),
                                  const Icon(Icons.verified_rounded, size: 14, color: Color(0xFF10B981)),
                                ],
                              ],
                            ),
                            Text(
                              '${booking.workerCount} Workers · Started: ${booking.startDate}',
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Progress Percentage
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            isCompleted ? '100%' : '60%',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: statusColor,
                            ),
                          ),
                          Text(
                            'Lifecycle',
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Description
                  Text(
                    booking.workDescription,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      height: 1.4,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 14),

                  // Financial Strip + Action
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Deal Value',
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                            ),
                          ),
                          Text(
                            '₹${booking.dealValue}',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 16),
                      if (booking.pendingAmount > 0)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Pending',
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                color: const Color(0xFFF59E0B),
                              ),
                            ),
                            Text(
                              '₹${booking.pendingAmount}',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFFF59E0B),
                              ),
                            ),
                          ],
                        ),
                      const Spacer(),
                      ElevatedButton.icon(
                        onPressed: onViewDetails,
                        icon: const Icon(Icons.arrow_forward_rounded, size: 14),
                        label: Text(
                          'View Service',
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
