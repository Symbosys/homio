import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/ai_suite_repository.dart';
import 'credit_purchase_modal.dart';

/// Production-grade safety modal ensuring users explicitly confirm credit consumption
/// or navigate to purchase credits if balance is insufficient.
class CreditConfirmationDialog extends StatelessWidget {
  final String actionTitle;
  final String actionDescription;
  final int creditsRequired;
  final String promptSummary;

  const CreditConfirmationDialog({
    super.key,
    required this.actionTitle,
    required this.actionDescription,
    required this.creditsRequired,
    required this.promptSummary,
  });

  static Future<bool> show(
    BuildContext context, {
    required String actionTitle,
    required String actionDescription,
    required int creditsRequired,
    required String promptSummary,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => CreditConfirmationDialog(
        actionTitle: actionTitle,
        actionDescription: actionDescription,
        creditsRequired: creditsRequired,
        promptSummary: promptSummary,
      ),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final repo = AiSuiteRepository.instance;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final available = repo.totalCredits;
    final hasEnough = available >= creditsRequired;
    final remaining = available - creditsRequired;

    return Dialog(
      backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 460),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: hasEnough
                          ? const Color(0xFF7C3AED).withValues(alpha: 0.12)
                          : const Color(0xFFEF4444).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      hasEnough ? Icons.token_rounded : Icons.warning_amber_rounded,
                      color: hasEnough ? const Color(0xFF7C3AED) : const Color(0xFFEF4444),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          hasEnough ? 'Confirm Credit Deduction' : 'Insufficient AI Credits',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            color: isDark ? Colors.white : const Color(0xFF0F172A),
                          ),
                        ),
                        Text(
                          actionTitle,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF7C3AED),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // Description & summary
              Text(
                actionDescription,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 12),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                  ),
                ),
                child: Text(
                  promptSummary,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                    color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              const SizedBox(height: 18),

              // Credit Math Breakdown Card
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: hasEnough
                      ? const Color(0xFF7C3AED).withValues(alpha: 0.06)
                      : const Color(0xFFEF4444).withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: hasEnough
                        ? const Color(0xFF7C3AED).withValues(alpha: 0.25)
                        : const Color(0xFFEF4444).withValues(alpha: 0.25),
                  ),
                ),
                child: Column(
                  children: [
                    _buildRow(
                      'Credits Required for Action:',
                      '$creditsRequired Credits',
                      isBold: true,
                      color: hasEnough ? const Color(0xFF7C3AED) : const Color(0xFFEF4444),
                      isDark: isDark,
                    ),
                    const Divider(height: 16),
                    _buildRow(
                      'Current Available Balance:',
                      '$available Credits',
                      isDark: isDark,
                    ),
                    const SizedBox(height: 6),
                    _buildRow(
                      hasEnough ? 'Remaining Balance After Job:' : 'Shortfall:',
                      hasEnough ? '$remaining Credits' : '${(creditsRequired - available)} Credits Missing',
                      color: hasEnough ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                      isBold: true,
                      isDark: isDark,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Action buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    style: TextButton.styleFrom(
                      foregroundColor: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                    ),
                    child: Text('Cancel', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600)),
                  ),
                  const SizedBox(width: 10),
                  if (hasEnough)
                    ElevatedButton.icon(
                      onPressed: () => Navigator.of(context).pop(true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7C3AED),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        elevation: 0,
                      ),
                      icon: const Icon(Icons.bolt_rounded, size: 18),
                      label: Text(
                        'Confirm & Deduct $creditsRequired Credits',
                        style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
                      ),
                    )
                  else
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(context).pop(false);
                        CreditPurchaseModal.show(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF10B981),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        elevation: 0,
                      ),
                      icon: const Icon(Icons.add_shopping_cart_rounded, size: 18),
                      label: Text(
                        'Buy Credits Now',
                        style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value, {bool isBold = false, Color? color, required bool isDark}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
          ),
        ),
        Text(
          value,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: isBold ? FontWeight.w800 : FontWeight.w600,
            color: color ?? (isDark ? Colors.white : const Color(0xFF0F172A)),
          ),
        ),
      ],
    );
  }
}
