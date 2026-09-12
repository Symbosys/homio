import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';

class DualViewComparison extends StatefulWidget {
  final String beforeImageUrl;
  final String afterImageUrl;
  final String beforeLabel;
  final String afterLabel;
  final double height;

  const DualViewComparison({
    super.key,
    required this.beforeImageUrl,
    required this.afterImageUrl,
    this.beforeLabel = 'Original Site Photo',
    this.afterLabel = 'AI 3D Synthesized Design',
    this.height = 440,
  });

  @override
  State<DualViewComparison> createState() => _DualViewComparisonState();
}

class _DualViewComparisonState extends State<DualViewComparison> {
  double _splitFraction = 0.5;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: AppRadius.lg,
        border: Border.all(
          color: Theme.of(context).brightness == Brightness.dark
              ? AppColors.darkBorder
              : AppColors.lightBorder,
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final splitPixel = width * _splitFraction;

          return GestureDetector(
            onHorizontalDragUpdate: (details) {
              setState(() {
                _splitFraction = (_splitFraction + (details.delta.dx / width)).clamp(0.05, 0.95);
              });
            },
            onTapDown: (details) {
              setState(() {
                _splitFraction = (details.localPosition.dx / width).clamp(0.05, 0.95);
              });
            },
            child: Stack(
              fit: StackFit.expand,
              children: [
                // 1. Bottom Layer: After (AI 3D Render)
                _buildImageLayer(widget.afterImageUrl),

                // 2. Top Layer: Before (Original Photo) clipped to left width
                ClipRect(
                  clipper: _HorizontalClipper(splitPixel),
                  child: _buildImageLayer(widget.beforeImageUrl),
                ),

                // 3. Before Label (Top Left)
                Positioned(
                  top: 16,
                  left: 16,
                  child: _buildTagBadge(widget.beforeLabel, Colors.black87),
                ),

                // 4. After Label (Top Right)
                Positioned(
                  top: 16,
                  right: 16,
                  child: _buildTagBadge(widget.afterLabel, AppColors.primary),
                ),

                // 5. Divider Handle Line
                Positioned(
                  left: splitPixel - 1.5,
                  top: 0,
                  bottom: 0,
                  child: Container(
                    width: 3,
                    color: Colors.white,
                  ),
                ),

                // 6. Center Circle Handle
                Positioned(
                  left: splitPixel - 18,
                  top: (widget.height / 2) - 18,
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.35),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.code_rounded,
                        size: 18,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildImageLayer(String url) {
    if (url.startsWith('assets/')) {
      return Image.asset(url, fit: BoxFit.cover);
    }
    return Image.network(
      url,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => Container(
        color: const Color(0xFF1E293B),
        child: const Center(
          child: Icon(Icons.broken_image_rounded, size: 40, color: Colors.white38),
        ),
      ),
    );
  }

  Widget _buildTagBadge(String text, Color bgColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bgColor.withValues(alpha: 0.85),
        borderRadius: AppRadius.sm,
      ),
      child: Text(
        text,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: Colors.white,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}

class _HorizontalClipper extends CustomClipper<Rect> {
  final double splitWidth;
  const _HorizontalClipper(this.splitWidth);

  @override
  Rect getClip(Size size) {
    return Rect.fromLTWH(0, 0, splitWidth, size.height);
  }

  @override
  bool shouldReclip(_HorizontalClipper oldClipper) {
    return oldClipper.splitWidth != splitWidth;
  }
}
