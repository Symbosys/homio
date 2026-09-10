import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';

class HrmsMapWidget extends StatefulWidget {
  final String locationTitle;
  final double centerLat;
  final double centerLng;
  final double radiusMeters;
  final double? userLat;
  final double? userLng;
  final bool isInside;
  final double height;

  const HrmsMapWidget({
    super.key,
    required this.locationTitle,
    required this.centerLat,
    required this.centerLng,
    this.radiusMeters = 150.0,
    this.userLat,
    this.userLng,
    this.isInside = true,
    this.height = 240,
  });

  @override
  State<HrmsMapWidget> createState() => _HrmsMapWidgetState();
}

class _HrmsMapWidgetState extends State<HrmsMapWidget> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: widget.height,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F1420) : const Color(0xFFE2E8F0),
        borderRadius: AppRadius.lg,
        border: Border.all(
          color: isDark ? Colors.white.withValues(alpha: 0.08) : Colors.black.withValues(alpha: 0.08),
        ),
      ),
      child: Stack(
        children: [
          // Custom radar/map painter
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _pulseController,
              builder: (context, child) {
                return CustomPaint(
                  painter: _GeofenceRadarPainter(
                    pulseValue: _pulseController.value,
                    isInside: widget.isInside,
                    isDark: isDark,
                  ),
                );
              },
            ),
          ),

          // Top Info Banner
          Positioned(
            top: 12,
            left: 12,
            right: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: (isDark ? const Color(0xFF131722) : Colors.white).withValues(alpha: 0.92),
                borderRadius: AppRadius.md,
                border: Border.all(
                  color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.black.withValues(alpha: 0.08),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.my_location,
                        size: 16,
                        color: widget.isInside ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        widget.locationTitle,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: (widget.isInside ? const Color(0xFF10B981) : const Color(0xFFEF4444)).withValues(alpha: 0.15),
                      borderRadius: AppRadius.sm,
                    ),
                    child: Text(
                      widget.isInside ? 'INSIDE (${widget.radiusMeters.toInt()}m)' : 'BREACH DETECTED',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: widget.isInside ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom Coordinates Stamp
          Positioned(
            bottom: 12,
            left: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.65),
                borderRadius: AppRadius.sm,
              ),
              child: Text(
                'GPS: ${widget.centerLat.toStringAsFixed(4)}° N, ${widget.centerLng.toStringAsFixed(4)}° E • ±3m Acc',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: Colors.white70,
                  fontFeatures: const [],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GeofenceRadarPainter extends CustomPainter {
  final double pulseValue;
  final bool isInside;
  final bool isDark;

  _GeofenceRadarPainter({
    required this.pulseValue,
    required this.isInside,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2 + 10);
    final baseRadius = math.min(size.width, size.height) * 0.32;

    // Grid lines
    final gridPaint = Paint()
      ..color = (isDark ? Colors.white : Colors.black).withValues(alpha: 0.04)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    const step = 28.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Geofence outer filled circle
    final zoneColor = isInside ? const Color(0xFF10B981) : const Color(0xFFEF4444);
    final fillPaint = Paint()
      ..color = zoneColor.withValues(alpha: 0.10)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, baseRadius, fillPaint);

    // Geofence border dashed circle
    final borderPaint = Paint()
      ..color = zoneColor.withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(center, baseRadius, borderPaint);

    // Animated pulse wave
    final pulseRadius = baseRadius + (pulseValue * 30);
    final pulseOpacity = (1.0 - pulseValue).clamp(0.0, 1.0) * 0.4;
    final pulsePaint = Paint()
      ..color = zoneColor.withValues(alpha: pulseOpacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawCircle(center, pulseRadius, pulsePaint);

    // Center Office/Site Pin
    final centerPinPaint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, 7, centerPinPaint);

    final centerPinRing = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(center, 7, centerPinRing);

    // User clock-in position dot
    final userOffset = isInside
        ? Offset(center.dx + (baseRadius * 0.35), center.dy - (baseRadius * 0.25))
        : Offset(center.dx + (baseRadius * 1.35), center.dy - (baseRadius * 0.5));

    final userDotPaint = Paint()
      ..color = isInside ? const Color(0xFF10B981) : const Color(0xFFEF4444)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(userOffset, 6, userDotPaint);

    final userDotRing = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawCircle(userOffset, 6, userDotRing);

    // Connecting line from center to user
    final linePaint = Paint()
      ..color = (isInside ? const Color(0xFF10B981) : const Color(0xFFEF4444)).withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    canvas.drawLine(center, userOffset, linePaint);
  }

  @override
  bool shouldRepaint(covariant _GeofenceRadarPainter oldDelegate) {
    return oldDelegate.pulseValue != pulseValue ||
        oldDelegate.isInside != isInside ||
        oldDelegate.isDark != isDark;
  }
}
