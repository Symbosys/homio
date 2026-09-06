import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/theme_controller.dart';

class SocialAuthButtons extends StatelessWidget {
  const SocialAuthButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeController.instance.isDarkMode(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 340;
        return Row(
          children: [
            Expanded(
              child: _SSOButton(
                label: isNarrow ? 'Google' : 'Google Workspace',
                isDark: isDark,
                iconWidget: const _GoogleIcon(),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Connecting to Google Workspace Single Sign-On...'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _SSOButton(
                label: isNarrow ? 'Microsoft' : 'Microsoft 365',
                isDark: isDark,
                iconWidget: const _MicrosoftIcon(),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Connecting to Microsoft 365 Single Sign-On...'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class _SSOButton extends StatefulWidget {
  const _SSOButton({
    required this.label,
    required this.isDark,
    required this.iconWidget,
    required this.onTap,
  });

  final String label;
  final bool isDark;
  final Widget iconWidget;
  final VoidCallback onTap;

  @override
  State<_SSOButton> createState() => _SSOButtonState();
}

class _SSOButtonState extends State<_SSOButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final bgColor = widget.isDark
        ? (_isHovered ? const Color(0xFF1E293B) : const Color(0xFF0F172A))
        : (_isHovered ? const Color(0xFFF8FAFC) : Colors.white);

    final borderColor = widget.isDark
        ? (_isHovered ? const Color(0xFF475569) : const Color(0xFF334155))
        : (_isHovered ? const Color(0xFFCBD5E1) : const Color(0xFFE2E8F0));

    final textColor = widget.isDark
        ? AppColors.darkTextPrimary
        : const Color(0xFF1E293B);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 140),
          height: 38,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(9),
            border: Border.all(color: borderColor, width: 1.1),
            boxShadow: [
              if (!widget.isDark)
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 3,
                  offset: const Offset(0, 1),
                ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              widget.iconWidget,
              const SizedBox(width: 7),
              Flexible(
                child: Text(
                  widget.label,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.2,
                    color: textColor,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Vector-painted 4-color Google logo
class _GoogleIcon extends StatelessWidget {
  const _GoogleIcon();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 15,
      height: 15,
      child: CustomPaint(
        painter: _GooglePainter(),
      ),
    );
  }
}

class _GooglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final paintRed = Paint()..color = const Color(0xFFEA4335)..style = PaintingStyle.stroke..strokeWidth = 2.8;
    final paintBlue = Paint()..color = const Color(0xFF4285F4)..style = PaintingStyle.stroke..strokeWidth = 2.8;
    final paintGreen = Paint()..color = const Color(0xFF34A853)..style = PaintingStyle.stroke..strokeWidth = 2.8;
    final paintYellow = Paint()..color = const Color(0xFFFBBC05)..style = PaintingStyle.stroke..strokeWidth = 2.8;

    final rect = Rect.fromCircle(center: center, radius: radius - 1.4);

    canvas.drawArc(rect, 3.14 * 1.15, 3.14 * 0.7, false, paintRed);
    canvas.drawArc(rect, 3.14 * 0.75, 3.14 * 0.4, false, paintYellow);
    canvas.drawArc(rect, 3.14 * 0.25, 3.14 * 0.5, false, paintGreen);
    canvas.drawArc(rect, -0.1, 3.14 * 0.35, false, paintBlue);

    final barPaint = Paint()..color = const Color(0xFF4285F4)..style = PaintingStyle.fill;
    canvas.drawRect(Rect.fromLTWH(center.dx - 1, center.dy - 1.4, radius + 1.0, 2.8), barPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Official 4-color Microsoft 365 Tiles
class _MicrosoftIcon extends StatelessWidget {
  const _MicrosoftIcon();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 15,
      height: 15,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(width: 6.5, height: 6.5, color: const Color(0xFFF25022)), // Red
              const SizedBox(width: 2),
              Container(width: 6.5, height: 6.5, color: const Color(0xFF7FBA00)), // Green
            ],
          ),
          const SizedBox(height: 2),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(width: 6.5, height: 6.5, color: const Color(0xFF00A4EF)), // Blue
              const SizedBox(width: 2),
              Container(width: 6.5, height: 6.5, color: const Color(0xFFFFB900)), // Yellow
            ],
          ),
        ],
      ),
    );
  }
}
