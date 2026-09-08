import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../models/labour_models.dart';

class LabourKycModal extends StatelessWidget {
  final LabourKycDocument kycDoc;
  final Function(String status, String notes) onVerify;

  const LabourKycModal({
    super.key,
    required this.kycDoc,
    required this.onVerify,
  });

  @override
  Widget build(BuildContext context) {
    final surfaceColor = AppColors.getSurface(context);
    final backgroundColor = AppColors.getBackground(context);
    final borderColor = AppColors.getBorder(context);
    final textPrimaryColor = AppColors.getTextPrimary(context);
    final textSecondaryColor = AppColors.getTextSecondary(context);
    final textMutedColor = AppColors.getTextMuted(context);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Container(
        width: 680,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: borderColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 24,
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
                color: backgroundColor,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(19)),
                border: Border(bottom: BorderSide(color: borderColor.withValues(alpha: 0.8))),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF06B6D4).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.verified_user_rounded, color: Color(0xFF06B6D4), size: 22),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'KYC Dossier: ${kycDoc.workerName} (${kycDoc.workerId})',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: textPrimaryColor,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Status: ${kycDoc.status.label} • Risk Score: ${kycDoc.riskLevel}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: kycDoc.status.color,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(Icons.close, color: textMutedColor),
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
                    // Section 1: Biometric & Aadhaar Verification Cards
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Live Selfie
                        Expanded(
                          flex: 4,
                          child: Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: backgroundColor,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: borderColor),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  'Live Facial Selfie Record',
                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: textPrimaryColor),
                                ),
                                const SizedBox(height: 10),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    kycDoc.selfiePhotoUrl,
                                    height: 130,
                                    width: 130,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, _, _) => Container(
                                      height: 130,
                                      width: 130,
                                      color: borderColor,
                                      child: const Icon(Icons.person, size: 50),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF10B981).withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Text(
                                    '✓ 99.2% Biometric Match',
                                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFF10B981)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Government Aadhaar & Police Verification
                        Expanded(
                          flex: 6,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildInfoRow('Aadhaar Document', kycDoc.aadhaarNumber, Icons.credit_card_rounded, backgroundColor, borderColor, textPrimaryColor, textMutedColor),
                              const SizedBox(height: 8),
                              _buildInfoRow('Police Station Jurisdiction', kycDoc.policeStationName, Icons.local_police_outlined, backgroundColor, borderColor, textPrimaryColor, textMutedColor),
                              const SizedBox(height: 8),
                              _buildInfoRow('Trade Test Evaluation', '${kycDoc.tradeTestScore}% (${kycDoc.tradeGrade})', Icons.assignment_turned_in_outlined, backgroundColor, borderColor, textPrimaryColor, textMutedColor),
                              const SizedBox(height: 8),
                              _buildInfoRow('Bank Account / UPI', '${kycDoc.bankAccountNo} (IFSC: ${kycDoc.ifscCode})\nUPI: ${kycDoc.upiId}', Icons.account_balance_outlined, backgroundColor, borderColor, textPrimaryColor, textMutedColor),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Section 2: Verification Audit Notes
                    Text(
                      'Compliance & Security Findings',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: textPrimaryColor),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: backgroundColor,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: borderColor),
                      ),
                      child: Text(
                        kycDoc.verificationNotes,
                        style: TextStyle(fontSize: 12, height: 1.5, color: textPrimaryColor),
                      ),
                    ),

                    const SizedBox(height: 16),

                    Row(
                      children: [
                        Icon(Icons.admin_panel_settings_outlined, size: 16, color: textMutedColor),
                        const SizedBox(width: 6),
                        Text(
                          'Verified By: ${kycDoc.verifiedByAdmin}',
                          style: TextStyle(fontSize: 11, color: textSecondaryColor),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Modal Footer
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(19)),
                border: Border(top: BorderSide(color: borderColor.withValues(alpha: 0.8))),
              ),
              child: Row(
                children: [
                  OutlinedButton.icon(
                    onPressed: () {
                      onVerify('REJECTED', 'Discrepancy in police certificate');
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.cancel_outlined, size: 16),
                    label: const Text('Reject KYC'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.error,
                      side: const BorderSide(color: AppColors.error),
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                  const Spacer(),
                  ElevatedButton.icon(
                    onPressed: () {
                      onVerify('APPROVED', 'All documents & biometric OCR verified');
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.verified_rounded, size: 16),
                    label: const Text('Approve & Issue Digital ID Card'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF10B981),
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

  Widget _buildInfoRow(
    String label,
    String value,
    IconData icon,
    Color backgroundColor,
    Color borderColor,
    Color textPrimaryColor,
    Color textMutedColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor.withValues(alpha: 0.6)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: AppColors.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(fontSize: 10, color: textMutedColor)),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: textPrimaryColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
