import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/marketplace_enums.dart';

/// Badge highlighting fulfillment channel (HOMIO Direct vs Affiliate Partner)
class AffiliateBadge extends StatelessWidget {
  final AffiliatePlatform platform;
  final bool isAffiliate;

  const AffiliateBadge({
    super.key,
    required this.platform,
    required this.isAffiliate,
  });

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;

    switch (platform) {
      case AffiliatePlatform.ikeaIndia:
        bg = const Color(0xFF0051BA).withValues(alpha: 0.15);
        fg = const Color(0xFF0051BA);
        break;
      case AffiliatePlatform.pepperfry:
        bg = const Color(0xFFFF6F00).withValues(alpha: 0.15);
        fg = const Color(0xFFFF6F00);
        break;
      case AffiliatePlatform.urbanLadder:
        bg = const Color(0xFF8B5CF6).withValues(alpha: 0.15);
        fg = const Color(0xFF8B5CF6);
        break;
      case AffiliatePlatform.amazonIndia:
        bg = const Color(0xFFFF9900).withValues(alpha: 0.15);
        fg = const Color(0xFFD97706);
        break;
      case AffiliatePlatform.homioDirect:
      default:
        bg = const Color(0xFF10B981).withValues(alpha: 0.15);
        fg = const Color(0xFF10B981);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: fg.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(platform.icon, size: 12, color: fg),
          const SizedBox(width: 4),
          Text(
            platform.displayName,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              color: fg,
              letterSpacing: 0.4,
            ),
          ),
        ],
      ),
    );
  }
}
