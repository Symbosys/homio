import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../models/labour_models.dart';

class LabourCard extends StatelessWidget {
  final LabourProfile worker;
  final VoidCallback onBook;
  final VoidCallback onViewDetails;
  final VoidCallback? onDirectCall;

  const LabourCard({
    super.key,
    required this.worker,
    required this.onBook,
    required this.onViewDetails,
    this.onDirectCall,
  });

  @override
  Widget build(BuildContext context) {
    final surfaceColor = AppColors.getSurface(context);
    final backgroundColor = AppColors.getBackground(context);
    final borderColor = AppColors.getBorder(context);
    final textPrimaryColor = AppColors.getTextPrimary(context);
    final textSecondaryColor = AppColors.getTextSecondary(context);
    final textMutedColor = AppColors.getTextMuted(context);

    final tradeColor = worker.trade.color;
    final statusColor = worker.labourStatus.color;
    final isAvailable = worker.labourStatus == LabourStatus.available;
    final isBlacklisted = worker.labourStatus == LabourStatus.blacklisted;

    return Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isBlacklisted
              ? AppColors.error.withValues(alpha: 0.5)
              : borderColor.withValues(alpha: 0.8),
          width: isBlacklisted ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row: Avatar + Name + Trade Tag + Status Badge
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: tradeColor.withValues(alpha: 0.15),
                    backgroundImage: NetworkImage(worker.photoUrl),
                    onBackgroundImageError: (_, _) {},
                    child: Text(
                      worker.legalName.substring(0, 1),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: tradeColor,
                      ),
                    ),
                  ),
                  if (worker.kycStatus == KycStatus.approved)
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.verified,
                          size: 16,
                          color: Color(0xFF10B981),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            worker.legalName,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: textPrimaryColor,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: statusColor.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            worker.labourStatus.label,
                            style: TextStyle(
                              color: statusColor,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        Icon(worker.trade.icon, size: 14, color: tradeColor),
                        const SizedBox(width: 4),
                        Text(
                          worker.trade.label,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: tradeColor,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '• ${worker.experienceYears} yrs exp',
                          style: TextStyle(
                            fontSize: 12,
                            color: textSecondaryColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.location_on_outlined, size: 13, color: textMutedColor),
                        const SizedBox(width: 2),
                        Expanded(
                          child: Text(
                            '${worker.zone}, ${worker.city} (${worker.distanceKm} km)',
                            style: TextStyle(
                              fontSize: 11,
                              color: textSecondaryColor,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
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

          // Rating & Punctuality & Jobs Scoreboard
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildMetric(
                  icon: Icons.star_rounded,
                  iconColor: const Color(0xFFF59E0B),
                  value: worker.rating.toStringAsFixed(2),
                  label: '${worker.totalReviews} reviews',
                  textColor: textPrimaryColor,
                  mutedColor: textMutedColor,
                ),
                _divider(borderColor),
                _buildMetric(
                  icon: Icons.task_alt_rounded,
                  iconColor: const Color(0xFF10B981),
                  value: '${worker.completedJobs}',
                  label: 'Jobs Done',
                  textColor: textPrimaryColor,
                  mutedColor: textMutedColor,
                ),
                _divider(borderColor),
                _buildMetric(
                  icon: Icons.timer_outlined,
                  iconColor: const Color(0xFF3B82F6),
                  value: '${worker.punctualityScore.toStringAsFixed(0)}%',
                  label: 'Punctuality',
                  textColor: textPrimaryColor,
                  mutedColor: textMutedColor,
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Rate Card Grid
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(color: borderColor.withValues(alpha: 0.6)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Daily Shift (8h)', style: TextStyle(fontSize: 10, color: textMutedColor)),
                    Text(
                      '₹${worker.dailyRate.toStringAsFixed(0)}/day',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: textPrimaryColor),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Piece-Rate', style: TextStyle(fontSize: 10, color: textMutedColor)),
                    Text(
                      '₹${worker.sqftRate.toStringAsFixed(0)}/sq.ft',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: textPrimaryColor),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Overtime', style: TextStyle(fontSize: 10, color: textMutedColor)),
                    Text(
                      '₹${worker.overtimeHourlyRate.toStringAsFixed(0)}/hr',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: textPrimaryColor),
                    ),
                  ],
                ),
              ],
            ),
          ),

          if (worker.skillBadges.isNotEmpty) ...[
            const SizedBox(height: 10),
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: worker.skillBadges.map((badge) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    '✓ Verified Skill',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],

          if (worker.currentSiteAssigned.isNotEmpty) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.apartment_rounded, size: 13, color: textMutedColor),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    'Assigned to: ${worker.currentSiteAssigned}',
                    style: TextStyle(
                      fontSize: 11,
                      fontStyle: FontStyle.italic,
                      color: textSecondaryColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],

          const SizedBox(height: 16),
          const Spacer(),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onViewDetails,
                  icon: const Icon(Icons.badge_outlined, size: 15),
                  label: const Text('View KYC', style: TextStyle(fontSize: 12)),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    foregroundColor: textPrimaryColor,
                    side: BorderSide(color: borderColor),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 1,
                child: ElevatedButton.icon(
                  onPressed: isBlacklisted ? null : onBook,
                  icon: Icon(
                    isBlacklisted ? Icons.block : Icons.handshake_outlined,
                    size: 15,
                  ),
                  label: Text(
                    isBlacklisted ? 'Blacklisted' : (isAvailable ? 'Book Worker' : 'Pre-Book'),
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isBlacklisted
                        ? AppColors.error
                        : (isAvailable ? AppColors.primary : const Color(0xFFF59E0B)),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetric({
    required IconData icon,
    required Color iconColor,
    required String value,
    required String label,
    required Color textColor,
    required Color mutedColor,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: iconColor),
        const SizedBox(width: 4),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: textColor,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 9,
                color: mutedColor,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _divider(Color borderColor) {
    return Container(
      height: 20,
      width: 1,
      color: borderColor,
    );
  }
}
