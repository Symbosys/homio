import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Pill showing compatible software for a digital asset
class SoftwareBadge extends StatelessWidget {
  final String softwareName;

  const SoftwareBadge({
    super.key,
    required this.softwareName,
  });

  @override
  Widget build(BuildContext context) {
    Color badgeColor;
    IconData icon;

    switch (softwareName.toLowerCase()) {
      case 'autocad':
      case 'dwg':
        badgeColor = const Color(0xFFEF4444);
        icon = Icons.architecture_rounded;
        break;
      case 'autodesk revit':
      case 'revit':
        badgeColor = const Color(0xFF3B82F6);
        icon = Icons.domain_rounded;
        break;
      case '3ds max':
      case 'corona renderer':
      case 'v-ray':
        badgeColor = const Color(0xFF8B5CF6);
        icon = Icons.view_in_ar_rounded;
        break;
      case 'microsoft excel':
      case 'google sheets':
        badgeColor = const Color(0xFF10B981);
        icon = Icons.table_chart_rounded;
        break;
      case 'meta quest 2/3':
      case 'unreal engine 5':
        badgeColor = const Color(0xFF06B6D4);
        icon = Icons.vrpano_rounded;
        break;
      default:
        badgeColor = const Color(0xFF64748B);
        icon = Icons.code_rounded;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: badgeColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: badgeColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: badgeColor),
          const SizedBox(width: 4),
          Text(
            softwareName,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: badgeColor,
            ),
          ),
        ],
      ),
    );
  }
}
