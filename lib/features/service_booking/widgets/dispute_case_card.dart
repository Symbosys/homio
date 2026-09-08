import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../models/labour_models.dart';

class DisputeCaseCard extends StatelessWidget {
  final DisputeCase dispute;
  final VoidCallback onViewDossier;
  final VoidCallback onAssignLawyer;
  final VoidCallback onIssueNotice;
  final VoidCallback onArbitrate;

  const DisputeCaseCard({
    super.key,
    required this.dispute,
    required this.onViewDossier,
    required this.onAssignLawyer,
    required this.onIssueNotice,
    required this.onArbitrate,
  });

  @override
  Widget build(BuildContext context) {
    final surfaceColor = AppColors.getSurface(context);
    final backgroundColor = AppColors.getBackground(context);
    final borderColor = AppColors.getBorder(context);
    final textPrimaryColor = AppColors.getTextPrimary(context);
    final textSecondaryColor = AppColors.getTextSecondary(context);
    final textMutedColor = AppColors.getTextMuted(context);

    final statusColor = dispute.legalStatus.color;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: dispute.legalStatus == DisputeLegalStatus.labourCourtFiled || dispute.legalStatus == DisputeLegalStatus.blacklisted
              ? AppColors.error.withValues(alpha: 0.6)
              : borderColor.withValues(alpha: 0.8),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            decoration: BoxDecoration(
              color: backgroundColor.withValues(alpha: 0.8),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
              border: Border(
                bottom: BorderSide(color: borderColor.withValues(alpha: 0.5)),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.gavel_rounded, size: 14, color: AppColors.error),
                      const SizedBox(width: 4),
                      Text(
                        dispute.caseNumber,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.error,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    dispute.disputeType.label,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: textPrimaryColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    dispute.legalStatus.label,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: statusColor,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Claim Amount & Parties Info Grid
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Dispute Parties', style: TextStyle(fontSize: 11, color: textMutedColor)),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              const Icon(Icons.arrow_right_rounded, size: 16, color: Color(0xFF10B981)),
                              Expanded(
                                child: Text(
                                  'Claimant: ${dispute.initiator}',
                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: textPrimaryColor),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(Icons.arrow_right_rounded, size: 16, color: AppColors.error),
                              Expanded(
                                child: Text(
                                  'Respondent: ${dispute.respondent}',
                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: textPrimaryColor),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            dispute.projectName,
                            style: TextStyle(fontSize: 11, color: textSecondaryColor),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Claim / Default Value', style: TextStyle(fontSize: 11, color: textMutedColor)),
                          const SizedBox(height: 2),
                          Text(
                            '₹${dispute.amountInDispute.toStringAsFixed(0)}',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.error),
                          ),
                          Text(
                            'Filed on ${_formatDate(dispute.dateFiled)}',
                            style: TextStyle(fontSize: 11, color: textSecondaryColor),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Assigned Legal Counsel', style: TextStyle(fontSize: 11, color: textMutedColor)),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              const Icon(Icons.account_balance_outlined, size: 14, color: AppColors.primary),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  dispute.assignedLawyerName,
                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: textPrimaryColor),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            'Bar No: ${dispute.lawyerBarCouncilNo} • ${dispute.courtJurisdiction}',
                            style: TextStyle(fontSize: 11, color: textSecondaryColor),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // Resolution Summary
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: borderColor.withValues(alpha: 0.5)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Case Summary & Findings:',
                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: textSecondaryColor),
                          ),
                          const Spacer(),
                          if (dispute.replacementDispatched)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFF10B981).withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                '✓ Emergency Squad Deployed',
                                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFF10B981)),
                              ),
                            ),
                          if (dispute.strikesCount > 0) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.error.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'Strike #${dispute.strikesCount}',
                                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.error),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        dispute.resolutionSummary,
                        style: TextStyle(fontSize: 12, color: textPrimaryColor),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // Audit Trail History Preview
                if (dispute.auditTrail.isNotEmpty) ...[
                  ExpansionTile(
                    tilePadding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                    title: const Text(
                      'View Audit Trail',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primary),
                    ),
                    children: dispute.auditTrail.map((event) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.circle, size: 6, color: textMutedColor),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                event,
                                style: TextStyle(fontSize: 11, color: textSecondaryColor),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],

                const SizedBox(height: 12),

                // Action Bar
                Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: onViewDossier,
                      icon: const Icon(Icons.folder_shared_outlined, size: 16),
                      label: const Text('Digital Evidence Dossier', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                    const SizedBox(width: 8),
                    OutlinedButton.icon(
                      onPressed: onIssueNotice,
                      icon: const Icon(Icons.description_outlined, size: 16),
                      label: const Text('Issue Legal Notice', style: TextStyle(fontSize: 12)),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        foregroundColor: const Color(0xFFEC4899),
                        side: const BorderSide(color: Color(0xFFEC4899)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                    const SizedBox(width: 8),
                    OutlinedButton.icon(
                      onPressed: onAssignLawyer,
                      icon: const Icon(Icons.person_add_alt_1_outlined, size: 16),
                      label: const Text('Assign Counsel', style: TextStyle(fontSize: 12)),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        foregroundColor: textPrimaryColor,
                        side: BorderSide(color: borderColor),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                    const Spacer(),
                    OutlinedButton.icon(
                      onPressed: onArbitrate,
                      icon: const Icon(Icons.shield_outlined, size: 16),
                      label: Text(
                        dispute.isClientBlacklisted || dispute.isLabourBlacklisted ? 'Blacklist Locked' : 'Arbitrate / Settle',
                        style: const TextStyle(fontSize: 12),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        foregroundColor: AppColors.error,
                        side: BorderSide(color: AppColors.error.withValues(alpha: 0.7)),
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
    );
  }

  String _formatDate(DateTime dt) {
    return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
  }
}
