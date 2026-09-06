import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/responsive/adaptive_container.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/theme_controller.dart';

/// Effortless Onboarding Section matching the exact design mockup.
/// Features 4 intuitive steps with circular icon badges, connector nodes,
/// action chevrons, and the "Day 1 Impact" highlight banner.
class WorkflowSteps extends StatelessWidget {
  const WorkflowSteps({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeController.instance.isDarkMode(context);
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isMobile = screenWidth < 768;

    return Container(
      padding: EdgeInsets.symmetric(vertical: isMobile ? 48 : 72),
      child: AdaptiveContainer(
        child: Column(
          children: [
            // Top Badge: ∿ EFFORTLESS ONBOARDING
            _buildTopBadge(isDark),

            const SizedBox(height: 18),

            // Headline: Up and Running in 4 Intuitive Steps
            _buildHeadline(isDark, isMobile),

            const SizedBox(height: 14),

            // Subtitle Description
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 680),
              child: Text(
                'No six-month implementation cycles. Homio is built for rapid adoption\nso your teams start executing on Day 1.',
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: isMobile ? 13.5 : 15.5,
                  height: 1.6,
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : const Color(0xFF64748B),
                ),
              ),
            ),

            const SizedBox(height: 22),

            // Day 1 Impact Highlight Pill (shifted above the 4 steps)
            _buildDay1ImpactBanner(isDark, isMobile),

            const SizedBox(height: 40),

            // 4 Step Cards (Horizontal with connector nodes on desktop, column on mobile)
            _buildStepsRow(context, isDark, isMobile),
          ],
        ),
      ),
    );
  }

  /// Top pill badge with wavy ribbon icon
  Widget _buildTopBadge(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6.5),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF1E1B4B).withValues(alpha: 0.6)
            : Colors.white,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: isDark ? const Color(0xFF3730A3) : const Color(0xFFE0E7FF),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4F46E5)
                .withValues(alpha: isDark ? 0.2 : 0.06),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const _WavyRibbonIcon(color: Color(0xFF4F46E5)),
          const SizedBox(width: 8),
          Text(
            'EFFORTLESS ONBOARDING',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.1,
              color: const Color(0xFF4F46E5),
            ),
          ),
        ],
      ),
    );
  }

  /// Two-tone headline
  Widget _buildHeadline(bool isDark, bool isMobile) {
    return Text.rich(
      TextSpan(
        style: GoogleFonts.plusJakartaSans(
          fontSize: isMobile ? 26 : 42,
          fontWeight: FontWeight.w800,
          letterSpacing: -1.2,
        ),
        children: [
          TextSpan(
            text: 'Up and Running in ',
            style: TextStyle(
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
          ),
          const TextSpan(
            text: '4 Intuitive Steps',
            style: TextStyle(color: Color(0xFF4F46E5)),
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }

  // Steps Dataset
  List<_StepData> _getSteps() {
    return [
      _StepData(
        step: 'STEP 01',
        title: 'Choose Your Plan &\nWorkspace',
        description: 'Sign up in under 60 seconds. Pick a tier tailored to your team size and operational complexity.',
        icon: Icons.rocket_launch_outlined,
        color: const Color(0xFF4F46E5),
        bgColor: const Color(0xFFF5F3FF),
        borderColor: const Color(0xFFDDD6FE),
      ),
      _StepData(
        step: 'STEP 02',
        title: 'Set Up Organization\n& Roles',
        description: 'Configure department hierarchies, staff permission tiers, sales pipelines, and quotation margin rules.',
        icon: Icons.groups_outlined,
        color: const Color(0xFF4F46E5),
        bgColor: const Color(0xFFEEF2FF),
        borderColor: const Color(0xFFC7D2FE),
      ),
      _StepData(
        step: 'STEP 03',
        title: 'Bring Operations\nInto One Place',
        description: 'Connect Meta/Google lead sources, import clients, set up active site milestones, and invite team members.',
        icon: Icons.link_rounded,
        color: const Color(0xFF10B981),
        bgColor: const Color(0xFFECFDF5),
        borderColor: const Color(0xFFA7F3D0),
      ),
      _StepData(
        step: 'STEP 04',
        title: 'Scale with\nAutomation & AI',
        description: 'Trigger automated WhatsApp nurture drips, generate instant AI quotes, and track growth with live analytics.',
        icon: Icons.auto_awesome_rounded,
        color: const Color(0xFFDB2777),
        bgColor: const Color(0xFFFDF2F8),
        borderColor: const Color(0xFFFBCFE8),
      ),
    ];
  }

  /// 4 Steps Row / Grid
  Widget _buildStepsRow(BuildContext context, bool isDark, bool isMobile) {
    final steps = _getSteps();

    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 1050;
        final isTablet = constraints.maxWidth >= 650 && !isDesktop;

        if (isDesktop) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              for (int i = 0; i < steps.length; i++) ...[
                Expanded(child: _buildStepCard(steps[i], isDark)),
                if (i < steps.length - 1) _buildConnectorNode(isDark),
              ],
            ],
          );
        }

        if (isTablet) {
          return Wrap(
            spacing: 20,
            runSpacing: 20,
            children: steps.map((s) {
              final cardWidth = (constraints.maxWidth - 20) / 2;
              return SizedBox(
                width: cardWidth,
                child: _buildStepCard(s, isDark),
              );
            }).toList(),
          );
        }

        // Mobile Single Column
        return Column(
          children: steps.map((s) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _buildStepCard(s, isDark),
            );
          }).toList(),
        );
      },
    );
  }

  /// Individual Step Card
  Widget _buildStepCard(_StepData data, bool isDark) {
    return Container(
      constraints: const BoxConstraints(minHeight: 330),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF111827) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? const Color(0xFF1F2937) : const Color(0xFFF1F5F9),
          width: 1.3,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.25)
                : const Color(0xFF0F172A).withValues(alpha: 0.04),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Circular Icon Badge
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: isDark ? data.color.withValues(alpha: 0.15) : data.bgColor,
              shape: BoxShape.circle,
              border: Border.all(
                color: isDark
                    ? data.color.withValues(alpha: 0.35)
                    : data.borderColor,
                width: 1.3,
              ),
              boxShadow: [
                BoxShadow(
                  color: data.color.withValues(alpha: isDark ? 0.2 : 0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Center(child: Icon(data.icon, size: 24, color: data.color)),
          ),

          const SizedBox(height: 22),

          // Step Label (e.g. STEP 01)
          Text(
            data.step,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11.5,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.8,
              color: data.color,
            ),
          ),

          const SizedBox(height: 8),

          // Title
          Text(
            data.title,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16.5,
              fontWeight: FontWeight.w800,
              height: 1.25,
              letterSpacing: -0.4,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
          ),

          const SizedBox(height: 14),

          // Description
          Text(
            data.description,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12.5,
              height: 1.55,
              fontWeight: FontWeight.w400,
              color: isDark
                  ? AppColors.darkTextSecondary
                  : const Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }

  /// Connector node between cards on desktop
  Widget _buildConnectorNode(bool isDark) {
    return Container(
      width: 24,
      alignment: Alignment.center,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Horizontal dashed connector line
          SizedBox(
            width: 24,
            child: CustomPaint(
              painter: _DashedConnectorPainter(
                color: isDark
                    ? const Color(0xFF334155)
                    : const Color(0xFFCBD5E1),
              ),
            ),
          ),
          // Central circular dot node
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : Colors.white,
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFF6366F1).withValues(alpha: 0.5),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF6366F1).withValues(alpha: 0.15),
                  blurRadius: 6,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Center(
              child: Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: Color(0xFF6366F1),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Highlight Pill: Day 1 Impact
  Widget _buildDay1ImpactBanner(bool isDark, bool isMobile) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 22,
        vertical: isMobile ? 10 : 9,
      ),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF1E1B4B).withValues(alpha: 0.35)
            : const Color(0xFFF8F9FE),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: isDark ? const Color(0xFF312E81) : const Color(0xFFEDE9FE),
          width: 1.2,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: const Color(0xFF6366F1).withValues(alpha: 0.14),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.bolt_rounded,
              size: 16,
              color: Color(0xFF4F46E5),
            ),
          ),
          const SizedBox(width: 10),
          Flexible(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Day 1 Impact: ',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: isMobile ? 12 : 13,
                      fontWeight: FontWeight.w800,
                      color: isDark ? Colors.white : const Color(0xFF1E1B4B),
                    ),
                  ),
                  TextSpan(
                    text:
                        'Your team is ready. Your operations are unified. Growth starts now.',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: isMobile ? 11.5 : 12.5,
                      fontWeight: FontWeight.w500,
                      color: isDark
                          ? const Color(0xFF94A3B8)
                          : const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
              textAlign: isMobile ? TextAlign.center : TextAlign.start,
            ),
          ),
        ],
      ),
    );
  }
}

/// Helper model for the 4 steps
class _StepData {
  _StepData({
    required this.step,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.bgColor,
    required this.borderColor,
  });

  final String step;
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final Color bgColor;
  final Color borderColor;
}

/// Custom Wavy Ribbon Icon for the top badge
class _WavyRibbonIcon extends StatelessWidget {
  const _WavyRibbonIcon({required this.color});
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 16,
      height: 14,
      child: CustomPaint(painter: _WavyRibbonPainter(color: color)),
    );
  }
}

class _WavyRibbonPainter extends CustomPainter {
  _WavyRibbonPainter({required this.color});
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.8
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    path.moveTo(2, size.height * 0.7);
    path.cubicTo(
      size.width * 0.25,
      0,
      size.width * 0.45,
      0,
      size.width * 0.5,
      size.height * 0.5,
    );
    path.cubicTo(
      size.width * 0.55,
      size.height,
      size.width * 0.75,
      size.height,
      size.width - 2,
      size.height * 0.3,
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _WavyRibbonPainter oldDelegate) =>
      oldDelegate.color != color;
}

/// Dashed horizontal connector between cards
class _DashedConnectorPainter extends CustomPainter {
  _DashedConnectorPainter({required this.color});
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.4
      ..style = PaintingStyle.stroke;

    double x = 0;
    while (x < size.width) {
      canvas.drawLine(
        Offset(x, size.height / 2),
        Offset(x + 3, size.height / 2),
        paint,
      );
      x += 6;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
