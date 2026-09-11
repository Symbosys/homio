import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../data/ai_suite_repository.dart';
import 'ai_commercial_config_dialog.dart';
import 'credit_purchase_modal.dart';
import 'revenue_share_badge.dart';

class CompactAiSuiteActions extends StatelessWidget {
  const CompactAiSuiteActions({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final screenWidth = MediaQuery.sizeOf(context).width;
    final showRevenueBadge = screenWidth >= 800;
    final showCreditLabel = screenWidth >= 420;

    return ListenableBuilder(
      listenable: AiSuiteRepository.instance,
      builder: (context, _) {
        final repo = AiSuiteRepository.instance;
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (showRevenueBadge) ...[
                const RevenueShareBadge(isCompact: true),
                const SizedBox(width: 8),
              ],
              // Compact Credits Chip
              InkWell(
                onTap: () => CreditPurchaseModal.show(context),
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E293B) : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFF10B981).withValues(alpha: 0.5),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.toll_rounded, size: 13, color: Color(0xFF10B981)),
                      const SizedBox(width: 4),
                      Text(
                        showCreditLabel ? '${repo.totalCredits} Credits' : '${repo.totalCredits}',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(width: 3),
                      const Icon(Icons.add_circle_outline_rounded, size: 13, color: Color(0xFF10B981)),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 2),
              // Compact Config Button
              IconButton(
                tooltip: 'Commercial Rules & Pricing',
                icon: const Icon(Icons.tune_rounded, size: 16),
                visualDensity: VisualDensity.compact,
                padding: const EdgeInsets.all(6),
                constraints: const BoxConstraints(),
                onPressed: () => AiCommercialConfigDialog.show(context),
              ),
            ],
          ),
        );
      },
    );
  }
}
