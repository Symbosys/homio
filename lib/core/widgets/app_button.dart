import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import '../theme/theme_controller.dart';

enum AppButtonVariant { primary, secondary, outline, ghost }
enum AppButtonSize { small, medium, large }

class AppButton extends StatefulWidget {
  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.medium,
    this.prefixIcon,
    this.suffixIcon,
    this.isLoading = false,
    this.isFullWidth = false,
  });

  final String text;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final AppButtonSize size;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final bool isLoading;
  final bool isFullWidth;

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeController.instance.isDarkMode(context);
    final isEnabled = widget.onPressed != null && !widget.isLoading;

    // Height & Padding based on Size
    final double height;
    final EdgeInsets padding;
    final double fontSize;
    final double iconSize;

    switch (widget.size) {
      case AppButtonSize.small:
        height = 38.0;
        padding = const EdgeInsets.symmetric(horizontal: 14);
        fontSize = 13.0;
        iconSize = 16.0;
        break;
      case AppButtonSize.medium:
        height = 46.0;
        padding = const EdgeInsets.symmetric(horizontal: 20);
        fontSize = 14.5;
        iconSize = 18.0;
        break;
      case AppButtonSize.large:
        height = 48.0;
        padding = const EdgeInsets.symmetric(horizontal: 24);
        fontSize = 15.0;
        iconSize = 18.0;
        break;
    }

    // Color computation
    Color background;
    Color foreground;
    BorderSide border = BorderSide.none;

    switch (widget.variant) {
      case AppButtonVariant.primary:
        background = _isHovered
            ? (isDark ? AppColors.primary : AppColors.primaryHover)
            : (isDark ? AppColors.primaryLight : AppColors.primary);
        foreground = Colors.white;
        break;

      case AppButtonVariant.secondary:
        background = isDark
            ? (_isHovered ? AppColors.darkSurfaceElevated : AppColors.darkSurfaceSubtle)
            : (_isHovered ? AppColors.lightSurfaceSubtle : AppColors.primaryMuted);
        foreground = isDark ? AppColors.primaryLight : AppColors.primary;
        break;

      case AppButtonVariant.outline:
        background = _isHovered
            ? (isDark ? AppColors.darkSurfaceElevated.withValues(alpha: 0.5) : AppColors.lightSurfaceSubtle)
            : Colors.transparent;
        foreground = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
        border = BorderSide(
          color: _isHovered
              ? (isDark ? AppColors.primaryLight : AppColors.primary)
              : (isDark ? AppColors.darkBorderStrong : AppColors.lightBorderStrong),
          width: 1.5,
        );
        break;

      case AppButtonVariant.ghost:
        background = _isHovered
            ? (isDark ? AppColors.darkSurfaceElevated : AppColors.lightSurfaceSubtle)
            : Colors.transparent;
        foreground = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
        break;
    }

    if (!isEnabled) {
      background = isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle;
      foreground = isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted;
      border = BorderSide.none;
    }

    Widget content = Row(
      mainAxisSize: widget.isFullWidth ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (widget.isLoading) ...[
          SizedBox(
            width: iconSize,
            height: iconSize,
            child: CircularProgressIndicator(
              strokeWidth: 2.2,
              valueColor: AlwaysStoppedAnimation<Color>(foreground),
            ),
          ),
          const SizedBox(width: 10),
        ] else if (widget.prefixIcon != null) ...[
          Icon(widget.prefixIcon, size: iconSize, color: foreground),
          const SizedBox(width: 8),
        ],
        Flexible(
          child: Text(
            widget.text,
            style: GoogleFonts.plusJakartaSans(
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.1,
              color: foreground,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
        if (!widget.isLoading && widget.suffixIcon != null) ...[
          const SizedBox(width: 8),
          Icon(widget.suffixIcon, size: iconSize, color: foreground),
        ],
      ],
    );

    return MouseRegion(
      cursor: isEnabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
      onEnter: (_) => isEnabled ? setState(() => _isHovered = true) : null,
      onExit: (_) => isEnabled ? setState(() => _isHovered = false) : null,
      child: GestureDetector(
        onTap: isEnabled ? widget.onPressed : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          height: height,
          width: widget.isFullWidth ? double.infinity : null,
          padding: padding,
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(12),
            border: border != BorderSide.none ? Border.fromBorderSide(border) : null,
            boxShadow: (widget.variant == AppButtonVariant.primary && isEnabled && _isHovered)
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.35),
                      blurRadius: 14,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Center(child: content),
        ),
      ),
    );
  }
}
