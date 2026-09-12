import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../models/ai_tool_definition.dart';

class AiToolCard extends StatefulWidget {
  final AiToolDefinition tool;
  final VoidCallback onTap;

  const AiToolCard({
    super.key,
    required this.tool,
    required this.onTap,
  });

  @override
  State<AiToolCard> createState() => _AiToolCardState();
}

class _AiToolCardState extends State<AiToolCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final tool = widget.tool;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        transform: Matrix4.translationValues(0, _isHovered ? -3 : 0, 0),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : Colors.white,
          borderRadius: AppRadius.lg,
          border: Border.all(
            color: _isHovered
                ? tool.accentColor.withValues(alpha: 0.6)
                : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
            width: _isHovered ? 1.5 : 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: _isHovered
                  ? tool.accentColor.withValues(alpha: isDark ? 0.2 : 0.12)
                  : Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
              blurRadius: _isHovered ? 16 : 8,
              offset: Offset(0, _isHovered ? 6 : 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: AppRadius.lg,
            onTap: widget.onTap,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: tool.accentColor.withValues(alpha: isDark ? 0.2 : 0.12),
                          borderRadius: AppRadius.md,
                        ),
                        child: Icon(
                          tool.icon,
                          color: tool.accentColor,
                          size: 24,
                        ),
                      ),
                      const Spacer(),
                      if (tool.badgeText.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: tool.accentColor.withValues(alpha: 0.15),
                            borderRadius: AppRadius.xs,
                          ),
                          child: Text(
                            tool.badgeText,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: tool.accentColor,
                              letterSpacing: 0.4,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    tool.title,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.getTextPrimary(context),
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    tool.subtitle,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: tool.accentColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: Text(
                      tool.description,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12.5,
                        color: AppColors.getTextSecondary(context),
                        height: 1.4,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Divider(height: 1),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF1E2433) : const Color(0xFFF1F5F9),
                          borderRadius: AppRadius.xs,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.bolt_rounded,
                              size: 13,
                              color: tool.creditCost > 0
                                  ? const Color(0xFFF59E0B)
                                  : AppColors.success,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              tool.costLabel,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: isDark
                                    ? const Color(0xFFCBD5E1)
                                    : const Color(0xFF475569),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Text(
                        'Launch Tool',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: _isHovered ? tool.accentColor : AppColors.getTextMuted(context),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.arrow_forward_rounded,
                        size: 14,
                        color: _isHovered ? tool.accentColor : AppColors.getTextMuted(context),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
