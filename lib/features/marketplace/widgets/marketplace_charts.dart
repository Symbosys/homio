import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_radius.dart';

class MarketplaceSalesTrendChart extends StatelessWidget {
  final List<double> weeklySalesLakhs;
  final List<String> dayLabels;

  const MarketplaceSalesTrendChart({
    super.key,
    this.weeklySalesLakhs = const [1.2, 2.4, 1.8, 3.5, 4.2, 3.8, 5.1],
    this.dayLabels = const ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final maxVal = weeklySalesLakhs.reduce(math.max);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF131722) : Colors.white,
        borderRadius: AppRadius.md,
        border: Border.all(color: isDark ? const Color(0xFF262D40) : const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Weekly Gross Sales Velocity',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: 0.12),
                  borderRadius: AppRadius.sm,
                ),
                child: Text(
                  '+18.4% WoW',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF10B981),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          SizedBox(
            height: 140,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(weeklySalesLakhs.length, (index) {
                final val = weeklySalesLakhs[index];
                final heightFactor = maxVal > 0 ? (val / maxVal) : 0.1;
                final isHighest = val == maxVal;

                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          '₹${val.toStringAsFixed(1)}L',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                            color: isHighest
                                ? const Color(0xFF3B82F6)
                                : (isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8)),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          height: (100 * heightFactor).clamp(12.0, 100.0),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: isHighest
                                  ? [const Color(0xFF3B82F6), const Color(0xFF60A5FA)]
                                  : [
                                      (isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1)),
                                      (isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0)),
                                    ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          dayLabels[index],
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class MarketplaceRevenueByModelDonut extends StatelessWidget {
  final double digitalPercent;
  final double decorPercent;
  final double materialsPercent;
  final double propertyUnlockPercent;

  const MarketplaceRevenueByModelDonut({
    super.key,
    this.digitalPercent = 22.0,
    this.decorPercent = 28.0,
    this.materialsPercent = 38.0,
    this.propertyUnlockPercent = 12.0,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF131722) : Colors.white,
        borderRadius: AppRadius.md,
        border: Border.all(color: isDark ? const Color(0xFF262D40) : const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Revenue by Marketplace Model',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              SizedBox(
                width: 90,
                height: 90,
                child: CustomPaint(
                  painter: _DonutPainter(
                    slices: [
                      _Slice(digitalPercent, const Color(0xFF3B82F6)),
                      _Slice(decorPercent, const Color(0xFF8B5CF6)),
                      _Slice(materialsPercent, const Color(0xFFF59E0B)),
                      _Slice(propertyUnlockPercent, const Color(0xFF10B981)),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _legendItem('Wholesale Materials (${materialsPercent.toInt()}%)', const Color(0xFFF59E0B), isDark),
                    _legendItem('Decor & Affiliates (${decorPercent.toInt()}%)', const Color(0xFF8B5CF6), isDark),
                    _legendItem('Digital Guides (${digitalPercent.toInt()}%)', const Color(0xFF3B82F6), isDark),
                    _legendItem('Property Unlocks (${propertyUnlockPercent.toInt()}%)', const Color(0xFF10B981), isDark),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _legendItem(String label, Color color, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.5),
      child: Row(
        children: [
          Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 10.5,
                fontWeight: FontWeight.w500,
                color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Slice {
  final double percent;
  final Color color;
  _Slice(this.percent, this.color);
}

class _DonutPainter extends CustomPainter {
  final List<_Slice> slices;
  _DonutPainter({required this.slices});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final strokeWidth = radius * 0.38;

    double startAngle = -math.pi / 2;
    final total = slices.fold(0.0, (sum, s) => sum + s.percent);

    for (final slice in slices) {
      final sweepAngle = (slice.percent / total) * 2 * math.pi;
      final paint = Paint()
        ..color = slice.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.butt;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
        startAngle,
        sweepAngle - 0.05,
        false,
        paint,
      );
      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
