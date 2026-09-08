import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_radius.dart';
import '../models/quotation_models.dart';

/// Visually distinct status badge for Quotations matching PRD Section 4.4.
class QuotationStatusBadge extends StatelessWidget {
  final QuotationStatus status;
  final bool showIcon;
  final bool isCompact;

  const QuotationStatusBadge({
    super.key,
    required this.status,
    this.showIcon = true,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isCompact ? 6 : 8,
        vertical: isCompact ? 2 : 4,
      ),
      decoration: BoxDecoration(
        color: status.color.withValues(alpha: isDark ? 0.2 : 0.1),
        borderRadius: AppRadius.full,
        border: Border.all(
          color: status.color.withValues(alpha: isDark ? 0.4 : 0.25),
          width: 0.8,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (showIcon) ...[
            Icon(status.icon, size: isCompact ? 11 : 13, color: status.color),
            const SizedBox(width: 4),
          ],
          Text(
            status.label,
            style: GoogleFonts.inter(
              fontSize: isCompact ? 10 : 11,
              fontWeight: FontWeight.w600,
              color: status.color,
              letterSpacing: -0.1,
            ),
          ),
        ],
      ),
    );
  }
}
