import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/responsive/adaptive_container.dart';
import '../../../../core/theme/theme_controller.dart';

/// ValueStrip: "Everything Your Business Needs. Zero Fragmentation."
/// Matches the attached design mockup with 3 cards on top and 2 cards on the bottom,
/// rich dark-indigo cards, custom vector watermarks, and responsive layout.
class ValueStrip extends StatelessWidget {
  const ValueStrip({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeController.instance.isDarkMode(context);
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isMobile = screenWidth < 768;

    return Container(
      padding: EdgeInsets.symmetric(vertical: isMobile ? 48 : 80),
      child: AdaptiveContainer(
        maxWidth: 1240,
        child: Column(
          children: [
            // Top Section Tagline
            Text(
              'EVERYTHING YOUR BUSINESS NEEDS. ZERO FRAGMENTATION.',
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11.5,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.2,
                color: isDark ? const Color(0xFF818CF8) : const Color(0xFF4F46E5),
              ),
            ),

            const SizedBox(height: 16),

            // Main Two-Tone Headline
            Text.rich(
              TextSpan(
                style: GoogleFonts.plusJakartaSans(
                  fontSize: isMobile ? 26 : 40,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.9,
                  height: 1.2,
                ),
                children: [
                  TextSpan(
                    text: 'Designed from the ground up\nfor ',
                    style: TextStyle(
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                  TextSpan(
                    text: 'high-velocity',
                    style: TextStyle(
                      color: isDark ? const Color(0xFF818CF8) : const Color(0xFF4F46E5),
                    ),
                  ),
                  TextSpan(
                    text: ' teams',
                    style: TextStyle(
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 18),

            // Subtle Central Accent Indicator (── ● ──)
            _buildAccentIndicator(isDark),

            const SizedBox(height: 48),

            // 5 Pillar Cards Layout (3 Top + 2 Centered Bottom on Desktop)
            _buildPillarsLayout(context, isDark),
          ],
        ),
      ),
    );
  }

  /// Subtle horizontal divider with glowing dot
  Widget _buildAccentIndicator(bool isDark) {
    return SizedBox(
      width: 70,
      height: 12,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 70,
            height: 1.2,
            color: (isDark ? const Color(0xFF818CF8) : const Color(0xFF4F46E5)).withValues(alpha: 0.25),
          ),
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF818CF8) : const Color(0xFF4F46E5),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF818CF8).withValues(alpha: 0.6),
                  blurRadius: 6,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Dataset for the 5 Pillars
  List<_ValuePillarData> _getPillars() {
    return [
      _ValuePillarData(
        title: 'One Unified Workspace',
        description: 'Say goodbye to 6+ fragmented apps. Leads, projects, staff, and payments live together.',
        icon: Icons.scatter_plot_rounded,
        watermarkType: _WatermarkType.waves,
        hasAccentLine: false,
      ),
      _ValuePillarData(
        title: 'Real-Time Visibility',
        description: 'Live site milestone tracking, photo progress logs, and instant client approvals.',
        icon: Icons.visibility_rounded,
        watermarkType: _WatermarkType.radar,
        hasAccentLine: false,
      ),
      _ValuePillarData(
        title: 'Smarter Automation',
        description: 'Automated WhatsApp follow-ups, scheduled broadcasts, and intelligent drip campaigns.',
        icon: Icons.bolt_rounded,
        watermarkType: _WatermarkType.dots,
        hasAccentLine: false,
      ),
      _ValuePillarData(
        title: 'Team Accountability',
        description: 'Multi-tier hierarchy, geo-attendance, task velocity, and transparent performance scores.',
        icon: Icons.groups_rounded,
        watermarkType: _WatermarkType.avatars,
        hasAccentLine: true,
      ),
      _ValuePillarData(
        title: 'Total Cashflow Clarity',
        description: 'Dynamic quotation pricing, client milestone invoicing, and labour/vendor ledgers.',
        icon: Icons.account_balance_wallet_rounded,
        watermarkType: _WatermarkType.bars,
        hasAccentLine: true,
      ),
    ];
  }

  /// Responsive Layout: 3 Top + 2 Centered Bottom on Desktop, 2-col on Tablet, 1-col on Mobile
  Widget _buildPillarsLayout(BuildContext context, bool isDark) {
    final items = _getPillars();

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final isDesktop = width >= 1050;
        final isTablet = width >= 650 && !isDesktop;

        if (isDesktop) {
          // Top Row: 3 cards
          final topRowItems = items.take(3).toList();
          // Bottom Row: 2 cards centered
          final bottomRowItems = items.skip(3).take(2).toList();

          return Column(
            children: [
              // Row 1 (3 cards)
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (int i = 0; i < topRowItems.length; i++) ...[
                      Expanded(
                        child: _buildPillarCard(topRowItems[i], isDark),
                      ),
                      if (i < topRowItems.length - 1)
                        const SizedBox(width: 20),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Row 2 (2 centered cards with comfortable proportions)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.08),
                child: IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      for (int i = 0; i < bottomRowItems.length; i++) ...[
                        Expanded(
                          child: _buildPillarCard(bottomRowItems[i], isDark),
                        ),
                        if (i < bottomRowItems.length - 1)
                          const SizedBox(width: 20),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          );
        }

        if (isTablet) {
          // 2-column grid for tablet
          return Wrap(
            spacing: 18,
            runSpacing: 18,
            children: items.map((item) {
              final cardWidth = (width - 18) / 2;
              return SizedBox(
                width: cardWidth,
                child: _buildPillarCard(item, isDark),
              );
            }).toList(),
          );
        }

        // Mobile Single Column
        return Column(
          children: items.map((item) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _buildPillarCard(item, isDark),
            );
          }).toList(),
        );
      },
    );
  }

  /// Individual Pillar Card with subtle watermark graphic
  Widget _buildPillarCard(_ValuePillarData data, bool isDark) {
    return Container(
      constraints: const BoxConstraints(minHeight: 250),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0E1424) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? const Color(0xFF1E2844) : const Color(0xFFE2E8F0),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.03),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            // Background Watermark Illustration
            Positioned.fill(
              child: CustomPaint(
                painter: _CardWatermarkPainter(
                  type: data.watermarkType,
                  isDark: isDark,
                ),
              ),
            ),

            // Card Foreground Content
            Padding(
              padding: const EdgeInsets.all(26),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Icon Squircle
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF1E1B4B).withValues(alpha: 0.8)
                          : const Color(0xFFEEF2FF),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: const Color(0xFF4F46E5).withValues(alpha: isDark ? 0.4 : 0.2),
                        width: 1.0,
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        data.icon,
                        size: 22,
                        color: isDark ? const Color(0xFFC7D2FE) : const Color(0xFF4F46E5),
                      ),
                    ),
                  ),

                  const SizedBox(height: 22),

                  // Title
                  Text(
                    data.title,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 17.5,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.3,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),

                  // Small Accent Line (for cards like Team Accountability & Cashflow)
                  if (data.hasAccentLine) ...[
                    const SizedBox(height: 8),
                    Container(
                      width: 28,
                      height: 2.2,
                      decoration: BoxDecoration(
                        color: const Color(0xFF4F46E5),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ] else ...[
                    const SizedBox(height: 12),
                  ],

                  // Description
                  Text(
                    data.description,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13.0,
                      height: 1.55,
                      fontWeight: FontWeight.w400,
                      color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Helper model for each Value Pillar
enum _WatermarkType { waves, radar, dots, avatars, bars }

class _ValuePillarData {
  _ValuePillarData({
    required this.title,
    required this.description,
    required this.icon,
    required this.watermarkType,
    required this.hasAccentLine,
  });

  final String title;
  final String description;
  final IconData icon;
  final _WatermarkType watermarkType;
  final bool hasAccentLine;
}

/// Subtle vector background watermarks matching the screenshot cards
class _CardWatermarkPainter extends CustomPainter {
  _CardWatermarkPainter({required this.type, required this.isDark});

  final _WatermarkType type;
  final bool isDark;

  @override
  void paint(Canvas canvas, Size size) {
    final baseColor = isDark ? const Color(0xFF4F46E5) : const Color(0xFF818CF8);

    switch (type) {
      case _WatermarkType.waves:
        // Flowing contour waves in bottom right
        final paint = Paint()
          ..color = baseColor.withValues(alpha: isDark ? 0.08 : 0.05)
          ..strokeWidth = 1.2
          ..style = PaintingStyle.stroke;

        for (int i = 0; i < 4; i++) {
          final path = Path();
          final offset = i * 10.0;
          path.moveTo(size.width * 0.5 + offset, size.height);
          path.cubicTo(
            size.width * 0.65 + offset,
            size.height * 0.85,
            size.width * 0.75 + offset,
            size.height * 0.90,
            size.width,
            size.height * 0.75 + offset,
          );
          canvas.drawPath(path, paint);
        }
        break;

      case _WatermarkType.radar:
        // Concentric radar arcs in bottom right
        final paint = Paint()
          ..color = baseColor.withValues(alpha: isDark ? 0.07 : 0.04)
          ..strokeWidth = 1.2
          ..style = PaintingStyle.stroke;

        final center = Offset(size.width * 0.9, size.height * 0.9);
        for (double r = 25; r <= 85; r += 20) {
          canvas.drawCircle(center, r, paint);
        }
        break;

      case _WatermarkType.dots:
        // Dot grid matrix on right side
        final paint = Paint()
          ..color = baseColor.withValues(alpha: isDark ? 0.12 : 0.06)
          ..style = PaintingStyle.fill;

        for (int col = 0; col < 5; col++) {
          for (int row = 0; row < 6; row++) {
            canvas.drawCircle(
              Offset(size.width - 45 + (col * 8), size.height * 0.45 + (row * 8)),
              1.2,
              paint,
            );
          }
        }
        break;

      case _WatermarkType.avatars:
        // Overlapping avatar circles in bottom right
        final paint = Paint()
          ..color = baseColor.withValues(alpha: isDark ? 0.06 : 0.04)
          ..style = PaintingStyle.fill;

        canvas.drawCircle(Offset(size.width * 0.78, size.height * 0.88), 18, paint);
        canvas.drawCircle(Offset(size.width * 0.88, size.height * 0.86), 22, paint);
        canvas.drawCircle(Offset(size.width * 0.96, size.height * 0.90), 16, paint);
        break;

      case _WatermarkType.bars:
        // Ascending rounded bars in bottom right
        final barPaint = Paint()
          ..color = (isDark ? const Color(0xFF6366F1) : const Color(0xFF4F46E5))
              .withValues(alpha: isDark ? 0.20 : 0.10)
          ..style = PaintingStyle.fill;

        final barWidth = 9.0;
        final barGap = 6.0;
        final heights = [28.0, 44.0, 62.0, 80.0];

        for (int i = 0; i < heights.length; i++) {
          final x = size.width - 65 + (i * (barWidth + barGap));
          final y = size.height - heights[i];
          final rrect = RRect.fromRectAndRadius(
            Rect.fromLTWH(x, y, barWidth, heights[i]),
            const Radius.circular(4),
          );
          canvas.drawRRect(rrect, barPaint);
        }
        break;
    }
  }

  @override
  bool shouldRepaint(covariant _CardWatermarkPainter oldDelegate) =>
      oldDelegate.type != type || oldDelegate.isDark != isDark;
}
