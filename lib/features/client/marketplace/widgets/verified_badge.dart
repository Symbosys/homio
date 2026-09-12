import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum VerifiedBadgeType {
  homioVerified('HOMIO VERIFIED', Icons.verified_rounded, Color(0xFF10B981)),
  tradeCertified('TRADE GRADE', Icons.handshake_rounded, Color(0xFF3B82F6)),
  reraApproved('RERA APPROVED', Icons.gavel_rounded, Color(0xFF8B5CF6)),
  vedicCompliant('VEDIC COMPLIANT', Icons.brightness_auto_rounded, Color(0xFFF59E0B)),
  policeVerified('POLICE VERIFIED', Icons.shield_rounded, Color(0xFF10B981));

  final String label;
  final IconData icon;
  final Color color;
  const VerifiedBadgeType(this.label, this.icon, this.color);
}

/// Trust and certification pill
class VerifiedBadge extends StatelessWidget {
  final VerifiedBadgeType type;
  final bool compact;

  const VerifiedBadge({
    super.key,
    this.type = VerifiedBadgeType.homioVerified,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 6 : 8,
        vertical: compact ? 2 : 4,
      ),
      decoration: BoxDecoration(
        color: type.color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: type.color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(type.icon, size: compact ? 11 : 13, color: type.color),
          const SizedBox(width: 4),
          Text(
            type.label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: compact ? 9 : 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.6,
              color: type.color,
            ),
          ),
        ],
      ),
    );
  }
}
