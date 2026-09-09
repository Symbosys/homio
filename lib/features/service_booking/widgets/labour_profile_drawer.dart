import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../models/labour_models.dart';

class LabourProfileDrawer extends StatelessWidget {
  final LabourProfile worker;
  final VoidCallback? onAssignJob;
  final VoidCallback? onViewKyc;
  final VoidCallback? onViewPayments;
  final VoidCallback? onViewRatings;
  final VoidCallback? onToggleBlacklist;

  const LabourProfileDrawer({
    super.key,
    required this.worker,
    this.onAssignJob,
    this.onViewKyc,
    this.onViewPayments,
    this.onViewRatings,
    this.onToggleBlacklist,
  });

  @override
  Widget build(BuildContext context) {
    final surfaceColor = AppColors.getSurface(context);
    final backgroundColor = AppColors.getBackground(context);
    final borderColor = AppColors.getBorder(context);
    final textPrimaryColor = AppColors.getTextPrimary(context);
    final textSecondaryColor = AppColors.getTextSecondary(context);

    return Drawer(
      width: 480,
      backgroundColor: surfaceColor,
      child: SafeArea(
        child: Column(
          children: [
            // Drawer Top Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: borderColor)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'LABOUR PROFILE DOSSIER',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                      color: textSecondaryColor,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded, size: 20),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile Header Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: backgroundColor,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: borderColor),
                      ),
                      child: Row(
                        children: [
                          Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  worker.photoUrl,
                                  width: 72,
                                  height: 72,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) => Container(
                                    width: 72,
                                    height: 72,
                                    color: Colors.grey.shade300,
                                    child: const Icon(Icons.person, size: 36),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(3),
                                  decoration: BoxDecoration(
                                    color: worker.labourStatus.color,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: surfaceColor, width: 2),
                                  ),
                                  child: const Icon(Icons.check, size: 10, color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        worker.legalName,
                                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: textPrimaryColor),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: worker.trade.color.withValues(alpha: 0.15),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        worker.skillLevel.label.split(' ').first,
                                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: worker.trade.color),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Text('${worker.alias} • ID: ${worker.id}', style: TextStyle(fontSize: 11, color: textSecondaryColor)),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: Colors.amber.withValues(alpha: 0.15),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Row(
                                        children: [
                                          const Icon(Icons.star_rounded, size: 13, color: Colors.amber),
                                          const SizedBox(width: 3),
                                          Text('${worker.rating}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.amber)),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text('(${worker.totalReviews} reviews)', style: TextStyle(fontSize: 11, color: textSecondaryColor)),
                                    const Spacer(),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: worker.labourStatus.color.withValues(alpha: 0.15),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        worker.labourStatus.label,
                                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: worker.labourStatus.color),
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
                    const SizedBox(height: 18),

                    // Quick Action Toolbar
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: onAssignJob,
                            icon: const Icon(Icons.assignment_ind_rounded, size: 16),
                            label: const Text('Assign Job'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        OutlinedButton(
                          onPressed: onViewKyc,
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: const Text('KYC'),
                        ),
                        const SizedBox(width: 8),
                        OutlinedButton(
                          onPressed: onViewRatings,
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: const Text('Ratings'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Performance Scorecard
                    _buildSectionHeader('PERFORMANCE SCORECARD', textSecondaryColor),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        _buildMetricBox('On-Time %', '${worker.onTimePercentage.toInt()}%', const Color(0xFF10B981), surfaceColor, borderColor, textPrimaryColor, textSecondaryColor),
                        const SizedBox(width: 10),
                        _buildMetricBox('Quality Score', '${worker.qualityScore} ★', const Color(0xFF3B82F6), surfaceColor, borderColor, textPrimaryColor, textSecondaryColor),
                        const SizedBox(width: 10),
                        _buildMetricBox('Jobs Completed', '${worker.completedJobs}', const Color(0xFF8B5CF6), surfaceColor, borderColor, textPrimaryColor, textSecondaryColor),
                        const SizedBox(width: 10),
                        _buildMetricBox('Disputes', '${worker.disputeCount}', worker.disputeCount > 0 ? const Color(0xFFEF4444) : const Color(0xFF10B981), surfaceColor, borderColor, textPrimaryColor, textSecondaryColor),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Trade & Rates
                    _buildSectionHeader('TRADE & COMMERCIAL RATES', textSecondaryColor),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: backgroundColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: borderColor),
                      ),
                      child: Column(
                        children: [
                          _buildDetailRow('Primary Trade', worker.trade.label, textPrimaryColor, textSecondaryColor),
                          const SizedBox(height: 8),
                          _buildDetailRow('Skill Level', worker.skillLevel.label, textPrimaryColor, textSecondaryColor),
                          const SizedBox(height: 8),
                          _buildDetailRow('Daily Standard Rate', '₹${worker.dailyRate.toInt()} / 8-hr Shift', const Color(0xFF10B981), textSecondaryColor),
                          const SizedBox(height: 8),
                          _buildDetailRow('Overtime Rate', '₹${worker.overtimeHourlyRate.toInt()} / Hour', textPrimaryColor, textSecondaryColor),
                          const SizedBox(height: 8),
                          _buildDetailRow('Travel Charge', '₹${worker.travelCharge.toInt()} (Within ${worker.preferredRadiusKm.toInt()} km)', textPrimaryColor, textSecondaryColor),
                          const SizedBox(height: 8),
                          _buildDetailRow('Rate Negotiability', worker.isNegotiable ? 'Negotiable for Long Projects' : 'Fixed Standard Rate', textPrimaryColor, textSecondaryColor),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Identity & KYC Badges
                    _buildSectionHeader('IDENTITY & COMPLIANCE (KYC)', textSecondaryColor),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: backgroundColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: borderColor),
                      ),
                      child: Column(
                        children: [
                          _buildDetailRow('Aadhaar (Masked)', worker.aadhaarMasked, textPrimaryColor, textSecondaryColor),
                          const SizedBox(height: 8),
                          _buildDetailRow('Police Verification', worker.policeVerificationNo, textPrimaryColor, textSecondaryColor),
                          const SizedBox(height: 8),
                          _buildDetailRow('KYC Status', worker.kycStatus.label, worker.kycStatus.color, textSecondaryColor),
                          const SizedBox(height: 8),
                          _buildDetailRow('Experience', '${worker.experienceYears} Years in Construction/Interiors', textPrimaryColor, textSecondaryColor),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Contact & Emergency
                    _buildSectionHeader('CONTACT & EMERGENCY DETAILS', textSecondaryColor),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: backgroundColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: borderColor),
                      ),
                      child: Column(
                        children: [
                          _buildDetailRow('Mobile Number', worker.phone, textPrimaryColor, textSecondaryColor),
                          const SizedBox(height: 8),
                          _buildDetailRow('Alternate Phone', worker.altPhone.isNotEmpty ? worker.altPhone : 'Not Provided', textPrimaryColor, textSecondaryColor),
                          const SizedBox(height: 8),
                          _buildDetailRow('Service City & Zone', '${worker.city} (${worker.zone})', textPrimaryColor, textSecondaryColor),
                          const SizedBox(height: 8),
                          _buildDetailRow('Emergency Contact', '${worker.emergencyContact} • ${worker.emergencyPhone}', textPrimaryColor, textSecondaryColor),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Danger Actions (Suspend / Blacklist)
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.red.withValues(alpha: 0.2)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('ADMINISTRATIVE CONTROLS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.red)),
                          const SizedBox(height: 4),
                          Text('Suspension and blacklisting actions require compliance authorization and will lock dispatch privileges.', style: TextStyle(fontSize: 11, color: textSecondaryColor)),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              OutlinedButton.icon(
                                onPressed: onToggleBlacklist,
                                icon: const Icon(Icons.block_rounded, size: 16, color: Colors.red),
                                label: Text(
                                  worker.labourStatus == LabourStatus.blacklisted ? 'Remove Blacklist' : 'Blacklist Worker',
                                  style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w700, fontSize: 12),
                                ),
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(color: Colors.red.withValues(alpha: 0.4)),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, Color color) {
    return Text(
      title,
      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 0.6, color: color),
    );
  }

  Widget _buildMetricBox(String label, String value, Color color, Color bg, Color border, Color textPrimary, Color textSecondary) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: border),
        ),
        child: Column(
          children: [
            Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: color)),
            const SizedBox(height: 2),
            Text(label, style: TextStyle(fontSize: 10, color: textSecondary), textAlign: TextAlign.center, maxLines: 1),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, Color valueColor, Color labelColor) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 140,
          child: Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: labelColor)),
        ),
        Expanded(
          child: Text(value, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: valueColor)),
        ),
      ],
    );
  }
}
