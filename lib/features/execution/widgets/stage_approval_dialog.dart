import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../models/execution_models.dart';

/// Modal dialog for inspecting milestone readiness and dispatching WhatsApp OTP approval links.
class StageApprovalDialog extends StatefulWidget {
  final StageApprovalRequest approvalRequest;
  final VoidCallback onDispatched;

  const StageApprovalDialog({
    super.key,
    required this.approvalRequest,
    required this.onDispatched,
  });

  static Future<void> show({
    required BuildContext context,
    required ProjectMaster project,
    required StageApprovalRequest stage,
    required void Function(StageApprovalRequest updated) onApprove,
  }) {
    return showDialog(
      context: context,
      builder: (ctx) => StageApprovalDialog(
        approvalRequest: stage,
        onDispatched: () {
          final updated = stage.copyWith(
            isApproved: true,
            status: 'Approved & Certified',
            approvedAt: 'Just Now',
            otpSignoffAudit: 'Verified via OTP (WhatsApp)',
          );
          onApprove(updated);
        },
      ),
    );
  }

  @override
  State<StageApprovalDialog> createState() => _StageApprovalDialogState();
}

class _StageApprovalDialogState extends State<StageApprovalDialog> {
  bool _isSending = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final req = widget.approvalRequest;

    return Dialog(
      backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.lg,
        side: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder, width: 0.8),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 640),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.success.withValues(alpha: 0.15),
                          borderRadius: AppRadius.sm,
                        ),
                        child: const Icon(Icons.verified_rounded, size: 18, color: AppColors.success),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Stage Completion Work Sign-Off', style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700)),
                          Text(
                            'Client OTP Approval Engine (PRD Section 8.4)',
                            style: GoogleFonts.inter(fontSize: 11, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                          ),
                        ],
                      ),
                    ],
                  ),
                  IconButton(icon: const Icon(Icons.close_rounded, size: 20), onPressed: () => Navigator.of(context).pop()),
                ],
              ),
            ),
            Divider(height: 1, color: isDark ? AppColors.darkBorder : AppColors.lightBorder),

            // Body
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(req.milestoneName, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.primary)),
                  const SizedBox(height: 4),
                  Text('Project: ${req.projectTitle} • Client: ${req.clientName} (${req.clientPhone})', style: GoogleFonts.inter(fontSize: 11, color: Colors.grey)),
                  const SizedBox(height: 14),

                  // Contract Value Release Card
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.success.withValues(alpha: 0.1),
                      borderRadius: AppRadius.sm,
                      border: Border.all(color: AppColors.success.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Payment Milestone Release Amount', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600)),
                            Text('Unlocks upon client OTP verification signoff', style: GoogleFonts.inter(fontSize: 10, color: Colors.grey)),
                          ],
                        ),
                        Text('₹${req.stageContractShareAmount.toStringAsFixed(0)}', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w900, color: AppColors.success)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  Text('Quality Audit Checklist (Verified by Supervisor):', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 6),
                  ...req.inspectionChecklist.map((item) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        children: [
                          const Icon(Icons.check_circle_rounded, size: 14, color: AppColors.success),
                          const SizedBox(width: 8),
                          Expanded(child: Text(item, style: GoogleFonts.inter(fontSize: 11))),
                        ],
                      ),
                    );
                  }),
                  const SizedBox(height: 14),

                  // WhatsApp Notification Template Preview
                  Text('WhatsApp Cloud API Automated Dispatch Message:', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF0F2618) : const Color(0xFFDCF8C6),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFF25D366).withValues(alpha: 0.3)),
                    ),
                    child: Text(
                      '🌟 *Milestone Ready for Sign-Off*\n\n'
                      'Dear ${req.clientName},\n'
                      'We have completed *${req.milestoneName}* on your home *${req.projectTitle}*.\n\n'
                      '🔍 Inspect verified site photos & approve stage with instant OTP:\n'
                      '👉 https://homio.design/approve/${req.projectCode}-stg3\n\n'
                      'Thank you,\nHomio Execution Team',
                      style: GoogleFonts.inter(fontSize: 11, height: 1.4, color: isDark ? Colors.white : Colors.black87),
                    ),
                  ),
                ],
              ),
            ),
            Divider(height: 1, color: isDark ? AppColors.darkBorder : AppColors.lightBorder),

            // Actions
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Dismiss')),
                  ElevatedButton.icon(
                    onPressed: _isSending
                        ? null
                        : () {
                            setState(() => _isSending = true);
                            final nav = Navigator.of(context);
                            final messenger = ScaffoldMessenger.of(context);
                            final phone = req.clientPhone;
                            Future.delayed(const Duration(milliseconds: 600), () {
                              if (!mounted) return;
                              widget.onDispatched();
                              nav.pop();
                              messenger.showSnackBar(
                                SnackBar(
                                  content: Text('Stage sign-off link sent to $phone via WhatsApp Cloud API'),
                                  backgroundColor: AppColors.success,
                                ),
                              );
                            });
                          },
                    icon: _isSending
                        ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : const Icon(Icons.send_rounded, size: 16),
                    label: Text(_isSending ? 'Dispatching...' : 'Dispatch Sign-Off Link on WhatsApp'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF25D366),
                      foregroundColor: Colors.white,
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
}
