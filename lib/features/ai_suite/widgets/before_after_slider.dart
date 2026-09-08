import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BeforeAfterSlider extends StatefulWidget {
  final String beforeImageUrl;
  final String afterImageUrl;
  final double initialPosition;
  final double height;
  final String beforeLabel;
  final String afterLabel;

  const BeforeAfterSlider({
    super.key,
    required this.beforeImageUrl,
    required this.afterImageUrl,
    this.initialPosition = 0.5,
    this.height = 420.0,
    this.beforeLabel = 'ORIGINAL SITE PHOTO',
    this.afterLabel = '4K AI STAGED RENDER',
  });

  @override
  State<BeforeAfterSlider> createState() => _BeforeAfterSliderState();
}

class _BeforeAfterSliderState extends State<BeforeAfterSlider> {
  late double _position;

  @override
  void initState() {
    super.initState();
    _position = widget.initialPosition;
  }

  @override
  void didUpdateWidget(covariant BeforeAfterSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.beforeImageUrl != widget.beforeImageUrl ||
        oldWidget.afterImageUrl != widget.afterImageUrl) {
      _position = widget.initialPosition;
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final totalWidth = constraints.maxWidth;
        final splitPx = (totalWidth * _position).clamp(0.0, totalWidth);

        return ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Container(
            height: widget.height,
            width: totalWidth,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: const Color(0xFF8B5CF6).withValues(alpha: 0.35),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.25),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // 1. After Image (Full width background)
                Image.network(
                  widget.afterImageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => _buildFallbackImage(isAfter: true),
                ),

                // 2. Before Image (Clipped to splitPx)
                ClipRect(
                  clipper: _HorizontalSplitClipper(splitPx),
                  child: Image.network(
                    widget.beforeImageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => _buildFallbackImage(isAfter: false),
                  ),
                ),

                // 3. Before Label (Top Left)
                Positioned(
                  top: 14,
                  left: 14,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.2),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.photo_camera_back_rounded, size: 12, color: Colors.white70),
                        const SizedBox(width: 5),
                        Text(
                          widget.beforeLabel,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.6,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // 4. After Label (Top Right)
                Positioned(
                  top: 14,
                  right: 14,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF7C3AED), Color(0xFF4F46E5)],
                      ),
                      borderRadius: BorderRadius.circular(6),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF7C3AED).withValues(alpha: 0.4),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.auto_awesome_rounded, size: 12, color: Colors.white),
                        const SizedBox(width: 5),
                        Text(
                          widget.afterLabel,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.6,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // 5. Divider Line with Vertical Gradient
                Positioned(
                  left: splitPx - 1.5,
                  top: 0,
                  bottom: 0,
                  child: Container(
                    width: 3,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.6),
                          blurRadius: 6,
                        ),
                        BoxShadow(
                          color: const Color(0xFF8B5CF6).withValues(alpha: 0.8),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                  ),
                ),

                // 6. Interactive Draggable Center Handle
                Positioned(
                  left: splitPx - 20,
                  top: (widget.height / 2) - 20,
                  child: GestureDetector(
                    onHorizontalDragUpdate: (details) {
                      setState(() {
                        final newPos = (_position + (details.delta.dx / totalWidth)).clamp(0.02, 0.98);
                        _position = newPos;
                      });
                    },
                    child: MouseRegion(
                      cursor: SystemMouseCursors.resizeLeftRight,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFF7C3AED),
                            width: 2.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.45),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.arrow_left_rounded, size: 18, color: Color(0xFF4F46E5)),
                              Icon(Icons.arrow_right_rounded, size: 18, color: Color(0xFF4F46E5)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // 7. Full-surface drag detector overlay
                Positioned.fill(
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onHorizontalDragUpdate: (details) {
                      setState(() {
                        final newPos = (_position + (details.delta.dx / totalWidth)).clamp(0.02, 0.98);
                        _position = newPos;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFallbackImage({required bool isAfter}) {
    return Container(
      color: isAfter ? const Color(0xFF1E1B4B) : const Color(0xFF334155),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isAfter ? Icons.auto_awesome_rounded : Icons.construction_rounded,
              size: 48,
              color: Colors.white54,
            ),
            const SizedBox(height: 8),
            Text(
              isAfter ? '4K AI Staged Render' : 'Raw Site Photo',
              style: GoogleFonts.plusJakartaSans(
                color: Colors.white70,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HorizontalSplitClipper extends CustomClipper<Rect> {
  final double splitWidth;
  _HorizontalSplitClipper(this.splitWidth);

  @override
  Rect getClip(Size size) {
    return Rect.fromLTWH(0, 0, splitWidth, size.height);
  }

  @override
  bool shouldReclip(covariant _HorizontalSplitClipper oldClipper) {
    return oldClipper.splitWidth != splitWidth;
  }
}
