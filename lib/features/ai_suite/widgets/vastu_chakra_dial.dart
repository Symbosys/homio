import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/ai_suite_models.dart';

class VastuChakraDial extends StatefulWidget {
  final double northDegrees;
  final ValueChanged<double>? onNorthDegreesChanged;
  final List<VastuZoneDetail> zones;
  final VastuZoneDetail? selectedZone;
  final ValueChanged<VastuZoneDetail>? onZoneSelected;
  final double size;

  const VastuChakraDial({
    super.key,
    double northDegrees = 0.0,
    double? calibratedDegrees,
    this.onNorthDegreesChanged,
    List<VastuZoneDetail>? zones,
    this.selectedZone,
    this.onZoneSelected,
    this.size = 320.0,
  })  : northDegrees = calibratedDegrees ?? northDegrees,
        zones = zones ?? _default16Zones;

  static const List<VastuZoneDetail> _default16Zones = [
    VastuZoneDetail(zoneCode: 'N', name: 'North (Kuber)', element: 'Water', deity: 'Kuber', status: VastuZoneStatus.balanced, currentUsage: 'Wealth Entrance', recommendedRemedy: 'Keep clean and clear'),
    VastuZoneDetail(zoneCode: 'NNE', name: 'North-North-East', element: 'Water', deity: 'Diti', status: VastuZoneStatus.balanced, currentUsage: 'Health & Healing', recommendedRemedy: 'Keep light green/blue'),
    VastuZoneDetail(zoneCode: 'NE', name: 'North-East (Ishanya)', element: 'Water / Ether', deity: 'Shiva', status: VastuZoneStatus.balanced, currentUsage: 'Puja & Meditation', recommendedRemedy: 'Auspicious prana zone'),
    VastuZoneDetail(zoneCode: 'ENE', name: 'East-North-East', element: 'Air', deity: 'Jayant', status: VastuZoneStatus.balanced, currentUsage: 'Recreation', recommendedRemedy: 'Family lounge area'),
    VastuZoneDetail(zoneCode: 'E', name: 'East (Indra)', element: 'Air', deity: 'Indra', status: VastuZoneStatus.balanced, currentUsage: 'Social Networking', recommendedRemedy: 'Open airy windows'),
    VastuZoneDetail(zoneCode: 'ESE', name: 'East-South-East', element: 'Air', deity: 'Surya', status: VastuZoneStatus.neutral, currentUsage: 'Churning & Analysis', recommendedRemedy: 'Study alcove'),
    VastuZoneDetail(zoneCode: 'SE', name: 'South-East (Agneya)', element: 'Fire', deity: 'Agni', status: VastuZoneStatus.balanced, currentUsage: 'Kitchen Cooking', recommendedRemedy: 'Keep gas stove facing East'),
    VastuZoneDetail(zoneCode: 'SSE', name: 'South-South-East', element: 'Fire', deity: 'Pusha', status: VastuZoneStatus.balanced, currentUsage: 'Confidence & Power', recommendedRemedy: 'Red or warm orange accent'),
    VastuZoneDetail(zoneCode: 'S', name: 'South (Yama)', element: 'Fire', deity: 'Yama', status: VastuZoneStatus.neutral, currentUsage: 'Fame & Relaxation', recommendedRemedy: 'Relaxation lounge'),
    VastuZoneDetail(zoneCode: 'SSW', name: 'South-South-West', element: 'Earth', deity: 'Gandharva', status: VastuZoneStatus.mildIssue, currentUsage: 'Expenditure / Waste', recommendedRemedy: 'Keep heavy storage'),
    VastuZoneDetail(zoneCode: 'SW', name: 'South-West (Nairutya)', element: 'Earth', deity: 'Pitri', status: VastuZoneStatus.balanced, currentUsage: 'Master Bedroom', recommendedRemedy: 'Solid headboard touching South/West'),
    VastuZoneDetail(zoneCode: 'WSW', name: 'West-South-West', element: 'Space', deity: 'Dauvarika', status: VastuZoneStatus.balanced, currentUsage: 'Education & Knowledge', recommendedRemedy: 'Bookshelves and study desk'),
    VastuZoneDetail(zoneCode: 'W', name: 'West (Varuna)', element: 'Space', deity: 'Varuna', status: VastuZoneStatus.balanced, currentUsage: 'Profit & Gains', recommendedRemedy: 'Dining and wealth gains'),
    VastuZoneDetail(zoneCode: 'WNW', name: 'West-North-West', element: 'Air', deity: 'Roga', status: VastuZoneStatus.neutral, currentUsage: 'Depression / Detox', recommendedRemedy: 'Exercise or washroom'),
    VastuZoneDetail(zoneCode: 'NW', name: 'North-West (Vayavya)', element: 'Air', deity: 'Vayu', status: VastuZoneStatus.balanced, currentUsage: 'Support & Guests', recommendedRemedy: 'Guest bedroom and pantry'),
    VastuZoneDetail(zoneCode: 'NNW', name: 'North-North-West', element: 'Water', deity: 'Bhallat', status: VastuZoneStatus.balanced, currentUsage: 'Attraction & Charm', recommendedRemedy: 'Perfumes and wardrobe dressing'),
  ];

  @override
  State<VastuChakraDial> createState() => _VastuChakraDialState();
}

class _VastuChakraDialState extends State<VastuChakraDial> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return LayoutBuilder(
      builder: (context, constraints) {
        final dialSize = math.min(widget.size, math.max(200.0, constraints.maxWidth - 24));

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Dial Canvas & Stack
            SizedBox(
              width: dialSize,
              height: dialSize,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Outer Glow Ring
                  Container(
                    width: dialSize,
                    height: dialSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          const Color(0xFF6366F1).withValues(alpha: 0.15),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),

                  // Rotating Vastu Compass Canvas
                  GestureDetector(
                    onPanUpdate: (details) {
                      final renderBox = context.findRenderObject() as RenderBox?;
                      if (renderBox == null) return;
                      final center = renderBox.size.center(Offset.zero);
                      final touch = details.localPosition;
                      final angle = math.atan2(touch.dy - center.dy, touch.dx - center.dx);
                      double degrees = angle * (180 / math.pi) + 90;
                      if (degrees < 0) degrees += 360;
                      widget.onNorthDegreesChanged?.call(degrees % 360);
                    },
                    child: CustomPaint(
                      size: Size(dialSize, dialSize),
                      painter: _VastuDialPainter(
                        northAngle: widget.northDegrees * (math.pi / 180),
                        zones: widget.zones,
                        selectedZone: widget.selectedZone,
                        isDark: isDark,
                      ),
                    ),
                  ),

                  // Center Hub with North Indicator
                  Container(
                    width: dialSize < 240 ? 60 : 76,
                    height: dialSize < 240 ? 60 : 76,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isDark ? const Color(0xFF0F172A) : Colors.white,
                      border: Border.all(
                        color: const Color(0xFF8B5CF6),
                        width: 2.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.25),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.explore_rounded,
                            size: dialSize < 240 ? 16 : 22,
                            color: const Color(0xFFEF4444),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${widget.northDegrees.toInt()}° N',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: dialSize < 240 ? 9.5 : 11,
                              fontWeight: FontWeight.w900,
                              color: isDark ? Colors.white : const Color(0xFF0F172A),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // Slider for Fine Angle Tuning with Wrap to prevent overflow
            Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 8,
              runSpacing: 6,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.rotate_right_rounded, size: 18, color: Color(0xFF8B5CF6)),
                    const SizedBox(width: 6),
                    Text(
                      'Align North Compass:',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 140,
                      child: Slider(
                        value: widget.northDegrees,
                        min: 0,
                        max: 360,
                        divisions: 72,
                        activeColor: const Color(0xFF7C3AED),
                        inactiveColor: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                        onChanged: widget.onNorthDegreesChanged ?? (_) {},
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1),
                        ),
                      ),
                      child: Text(
                        '${widget.northDegrees.toStringAsFixed(1)}°',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF7C3AED),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _VastuDialPainter extends CustomPainter {
  final double northAngle;
  final List<VastuZoneDetail> zones;
  final VastuZoneDetail? selectedZone;
  final bool isDark;

  _VastuDialPainter({
    required this.northAngle,
    required this.zones,
    this.selectedZone,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.width / 2;
    final innerRadius = radius * 0.48;

    // 1. Draw dial background disc
    final bgPaint = Paint()
      ..color = isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius, bgPaint);

    // 2. Draw 16 sector wedges
    const double sectorAngle = (2 * math.pi) / 16;

    for (int i = 0; i < 16; i++) {
      final double startAngle = (i * sectorAngle) + northAngle - (math.pi / 2);
      final zone = zones.length > i ? zones[i] : null;

      final isSelected = selectedZone?.zoneCode == zone?.zoneCode;
      final sectorColor = zone?.status.color.withValues(alpha: isSelected ? 0.45 : 0.18) ??
          const Color(0xFF6366F1).withValues(alpha: 0.15);

      final sectorPaint = Paint()
        ..color = sectorColor
        ..style = PaintingStyle.fill;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius - 4),
        startAngle,
        sectorAngle,
        true,
        sectorPaint,
      );

      // Border arc line
      final linePaint = Paint()
        ..color = (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)).withValues(alpha: 0.8)
        ..strokeWidth = 1.0
        ..style = PaintingStyle.stroke;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius - 4),
        startAngle,
        sectorAngle,
        true,
        linePaint,
      );

      // Label in the sector
      if (zone != null) {
        final labelAngle = startAngle + (sectorAngle / 2);
        final labelRadius = (radius + innerRadius) / 2;
        final lx = center.dx + labelRadius * math.cos(labelAngle);
        final ly = center.dy + labelRadius * math.sin(labelAngle);

        final textSpan = TextSpan(
          text: zone.zoneCode,
          style: TextStyle(
            fontSize: 9,
            fontWeight: isSelected ? FontWeight.w900 : FontWeight.w700,
            color: isSelected
                ? (isDark ? Colors.white : const Color(0xFF0F172A))
                : (isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155)),
          ),
        );
        final textPainter = TextPainter(
          text: textSpan,
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr,
        )..layout();

        textPainter.paint(
          canvas,
          Offset(lx - (textPainter.width / 2), ly - (textPainter.height / 2)),
        );
      }
    }

    // 3. Draw North Pointer Arrow
    final arrowPaint = Paint()
      ..color = const Color(0xFFEF4444)
      ..style = PaintingStyle.fill;

    final arrowPath = Path();
    final double nx = center.dx + (radius - 8) * math.cos(northAngle - (math.pi / 2));
    final double ny = center.dy + (radius - 8) * math.sin(northAngle - (math.pi / 2));

    final double bx1 = center.dx + (radius - 22) * math.cos(northAngle - (math.pi / 2) - 0.12);
    final double by1 = center.dy + (radius - 22) * math.sin(northAngle - (math.pi / 2) - 0.12);

    final double bx2 = center.dx + (radius - 22) * math.cos(northAngle - (math.pi / 2) + 0.12);
    final double by2 = center.dy + (radius - 22) * math.sin(northAngle - (math.pi / 2) + 0.12);

    arrowPath.moveTo(nx, ny);
    arrowPath.lineTo(bx1, by1);
    arrowPath.lineTo(bx2, by2);
    arrowPath.close();
    canvas.drawPath(arrowPath, arrowPaint);

    // 4. Outer rim circle
    final rimPaint = Paint()
      ..color = const Color(0xFF8B5CF6).withValues(alpha: 0.5)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(center, radius - 2, rimPaint);
  }

  @override
  bool shouldRepaint(covariant _VastuDialPainter oldDelegate) {
    return oldDelegate.northAngle != northAngle ||
        oldDelegate.selectedZone != selectedZone ||
        oldDelegate.isDark != isDark;
  }
}
