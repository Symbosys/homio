import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_radius.dart';
import '../services/ai_credit_service.dart';

class AiCreditChip extends StatelessWidget {
  final bool showTopUpAction;
  final VoidCallback? onTap;

  const AiCreditChip({
    super.key,
    this.showTopUpAction = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AiCreditService.instance,
      builder: (context, _) {
        final balance = AiCreditService.instance.balance;
        final isDark = Theme.of(context).brightness == Brightness.dark;

        return Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: AppRadius.full,
            onTap: onTap ?? () => context.go('/client/ai-credits'),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E2433) : const Color(0xFFEFF6FF),
                borderRadius: AppRadius.full,
                border: Border.all(
                  color: isDark ? const Color(0xFF3B4863) : const Color(0xFFBFDBFE),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(
                      color: Color(0xFFF59E0B),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.bolt_rounded,
                      size: 13,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '$balance Credits',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: isDark ? const Color(0xFF93C5FD) : const Color(0xFF1D4ED8),
                    ),
                  ),
                  if (showTopUpAction) ...[
                    const SizedBox(width: 6),
                    Icon(
                      Icons.add_circle_outline_rounded,
                      size: 14,
                      color: isDark ? const Color(0xFF93C5FD) : const Color(0xFF1D4ED8),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
