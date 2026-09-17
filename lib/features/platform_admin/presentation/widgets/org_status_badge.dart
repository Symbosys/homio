import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OrgStatusBadge extends StatelessWidget {
  final String status;

  const OrgStatusBadge({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    Color border;
    IconData icon;

    switch (status.toUpperCase()) {
      case 'ACTIVE':
        bg = const Color(0xFFECFDF5);
        fg = const Color(0xFF059669);
        border = const Color(0xFFA7F3D0);
        icon = Icons.check_circle_rounded;
        break;
      case 'SUSPENDED':
        bg = const Color(0xFFFEF2F2);
        fg = const Color(0xFFDC2626);
        border = const Color(0xFFFECACA);
        icon = Icons.block_rounded;
        break;
      case 'INACTIVE':
        bg = const Color(0xFFF1F5F9);
        fg = const Color(0xFF64748B);
        border = const Color(0xFFCBD5E1);
        icon = Icons.pause_circle_rounded;
        break;
      case 'PENDING_VERIFICATION':
      default:
        bg = const Color(0xFFFFFBEB);
        fg = const Color(0xFFD97706);
        border = const Color(0xFFFDE68A);
        icon = Icons.hourglass_top_rounded;
        break;
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (isDark) {
      bg = bg.withValues(alpha: 0.15);
      border = border.withValues(alpha: 0.3);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: border, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: fg),
          const SizedBox(width: 4),
          Text(
            status.replaceAll('_', ' '),
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: fg,
            ),
          ),
        ],
      ),
    );
  }
}
