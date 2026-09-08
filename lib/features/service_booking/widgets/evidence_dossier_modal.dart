import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../models/labour_models.dart';

class EvidenceDossierModal extends StatelessWidget {
  final DisputeCase dispute;

  const EvidenceDossierModal({
    super.key,
    required this.dispute,
  });

  @override
  Widget build(BuildContext context) {
    final surfaceColor = AppColors.getSurface(context);
    final bgColor = AppColors.getBackground(context);
    final borderColor = AppColors.getBorder(context);
    final textPrimary = AppColors.getTextPrimary(context);
    final textSecondary = AppColors.getTextSecondary(context);
    final textMuted = AppColors.getTextMuted(context);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Container(
        width: 800,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.90,
        ),
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: borderColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 30,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: [
            // Modal Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(19)),
                border: Border(bottom: BorderSide(color: borderColor)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.verified_outlined, color: AppColors.primary, size: 22),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Certified Digital Evidence Dossier: ${dispute.caseNumber}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Admissible under Section 65B Indian Evidence Act • Jurisdiction: ${dispute.courtJurisdiction}',
                          style: TextStyle(fontSize: 12, color: textSecondary),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(Icons.close, color: textSecondary),
                  ),
                ],
              ),
            ),

            // Modal Body
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Legal Case Credentials Banner
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: bgColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: borderColor),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Claimant / Injured Party', style: TextStyle(fontSize: 11, color: textMuted)),
                                Text(dispute.initiator, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: textPrimary)),
                                const SizedBox(height: 8),
                                Text('Project Site & Target Address', style: TextStyle(fontSize: 11, color: textMuted)),
                                Text(dispute.projectName, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: textSecondary)),
                              ],
                            ),
                          ),
                          Container(height: 50, width: 1, color: borderColor),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Respondent / Defaulting Entity', style: TextStyle(fontSize: 11, color: textMuted)),
                                Text(dispute.respondent, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.error)),
                                const SizedBox(height: 8),
                                Text('Total Verified Claim Amount', style: TextStyle(fontSize: 11, color: textMuted)),
                                Text('₹${dispute.amountInDispute.toStringAsFixed(0)} + 18% Statutory Int.', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.error)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Evidence Tabs / Packages
                    Text(
                      'Compiled Admissible Evidence Packages',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: textPrimary),
                    ),
                    const SizedBox(height: 12),

                    _buildEvidenceCard(
                      context: context,
                      icon: Icons.gps_fixed_rounded,
                      iconColor: const Color(0xFF10B981),
                      title: '1. GPS Geo-Fenced Site Attendance Logs',
                      subtitle: '4 Verified biometric check-ins within 50m site geofence radius. Timestamped SHA-256 hash verified.',
                      status: 'CERTIFIED & TAMPER-PROOF',
                    ),
                    const SizedBox(height: 10),
                    _buildEvidenceCard(
                      context: context,
                      icon: Icons.fact_check_rounded,
                      iconColor: AppColors.primary,
                      title: '2. Signed Daily Site Supervisor Task Checklists',
                      subtitle: 'Complete work done sheets with digital signatures by Site Supervisor Amit Joshi. Plywood grade & carcass assembly signed.',
                      status: 'SUPERVISOR AUTHENTICATED',
                    ),
                    const SizedBox(height: 10),
                    _buildEvidenceCard(
                      context: context,
                      icon: Icons.chat_bubble_outline_rounded,
                      iconColor: const Color(0xFF06B6D4),
                      title: '3. WhatsApp Cloud API & SMS Communication Trail',
                      subtitle: '12 Official payment demand messages, automated reminder delivery receipts (double-blue tick read logs), and client acknowledgements.',
                      status: 'DELIVERY LOG VERIFIED',
                    ),
                    const SizedBox(height: 10),
                    _buildEvidenceCard(
                      context: context,
                      icon: Icons.gavel_rounded,
                      iconColor: const Color(0xFFEC4899),
                      title: '4. Statutory 15-Day Legal Demand Notice (Section 138 / Labour Code)',
                      subtitle: 'Drafted by Empanelled Adv. Rajeshwar Swaroop (Bar: D/1492/2004). Speed Post Tracking: ED892019281IN.',
                      status: 'SERVED & LAPSED',
                    ),

                    const SizedBox(height: 20),

                    // Audit Chronology
                    Text(
                      'Immutable Chronological Audit Trail',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: textPrimary),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: bgColor,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: borderColor),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: dispute.auditTrail.map((ev) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.check_circle_outline_rounded, size: 14, color: Color(0xFF10B981)),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    ev,
                                    style: TextStyle(fontSize: 11, height: 1.4, color: textPrimary),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Modal Footer
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(19)),
                border: Border(top: BorderSide(color: borderColor)),
              ),
              child: Row(
                children: [
                  OutlinedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Transmitted digital dossier to Labour Court Clerk portal.')),
                      );
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.send_rounded, size: 16),
                    label: const Text('Transmit to Court e-Filing Portal'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                  const Spacer(),
                  ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Downloading Certified Dossier PDF (${dispute.caseNumber}.pdf)...')),
                      );
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.download_rounded, size: 16),
                    label: const Text('Download Certified Dossier (PDF)'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEvidenceCard({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required String status,
  }) {
    final surfaceColor = AppColors.getSurface(context);
    final borderColor = AppColors.getBorder(context);
    final textPrimary = AppColors.getTextPrimary(context);
    final textSecondary = AppColors.getTextSecondary(context);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: textPrimary),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        status,
                        style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: Color(0xFF10B981)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 11, color: textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
