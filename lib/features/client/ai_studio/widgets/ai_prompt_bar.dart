import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';

class AiPromptBar extends StatefulWidget {
  final String hintText;
  final List<String> quickStylePresets;
  final int creditCost;
  final ValueChanged<String> onSubmit;
  final VoidCallback? onAttachPhoto;
  final bool isGenerating;

  const AiPromptBar({
    super.key,
    this.hintText = 'Describe your desired room style, materials, mood, or lighting...',
    this.quickStylePresets = const [
      'Japandi Warm Minimalism',
      'Contemporary Italian Luxury',
      'Fluted Wood & Marble Backsplash',
      'Scandinavian Clean Lines',
      'Indian Neo-Classical Brass',
    ],
    this.creditCost = 2,
    required this.onSubmit,
    this.onAttachPhoto,
    this.isGenerating = false,
  });

  @override
  State<AiPromptBar> createState() => _AiPromptBarState();
}

class _AiPromptBarState extends State<AiPromptBar> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final text = _controller.text.trim();
    if (text.isNotEmpty && !widget.isGenerating) {
      widget.onSubmit(text);
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: AppRadius.xl,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Presets pills
          if (widget.quickStylePresets.isNotEmpty) ...[
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: widget.quickStylePresets.map((preset) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 6, bottom: 10),
                    child: ActionChip(
                      label: Text(
                        preset,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          _controller.text = preset;
                        });
                      },
                      backgroundColor:
                          isDark ? const Color(0xFF1E2843) : const Color(0xFFEEF2FF),
                      labelStyle: TextStyle(
                        color: isDark ? const Color(0xFF93C5FD) : const Color(0xFF4338CA),
                      ),
                      shape: RoundedRectangleBorder(borderRadius: AppRadius.full),
                      side: BorderSide.none,
                      visualDensity: VisualDensity.compact,
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
          // Input field row
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (widget.onAttachPhoto != null)
                IconButton(
                  onPressed: widget.onAttachPhoto,
                  icon: const Icon(Icons.add_photo_alternate_rounded, size: 22),
                  color: AppColors.primaryLight,
                  tooltip: 'Attach Reference Image / Floorplan',
                ),
              Expanded(
                child: TextField(
                  controller: _controller,
                  maxLines: 3,
                  minLines: 1,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13.5,
                    color: AppColors.getTextPrimary(context),
                  ),
                  decoration: InputDecoration(
                    hintText: widget.hintText,
                    hintStyle: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      color: AppColors.getTextMuted(context),
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                  ),
                  onSubmitted: (_) => _submit(),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                onPressed: widget.isGenerating ? null : _submit,
                icon: widget.isGenerating
                    ? const SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Icon(Icons.auto_awesome_rounded, size: 16),
                label: Text(
                  widget.isGenerating ? 'Generating...' : 'Generate (${widget.creditCost} cr)',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: AppRadius.md),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
