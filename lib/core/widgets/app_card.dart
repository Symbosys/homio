import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/theme_controller.dart';

class AppCard extends StatefulWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(24),
    this.backgroundColor,
    this.borderRadius = 16.0,
    this.enableHoverEffect = true,
    this.borderColor,
    this.onTap,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? backgroundColor;
  final double borderRadius;
  final bool enableHoverEffect;
  final Color? borderColor;
  final VoidCallback? onTap;

  @override
  State<AppCard> createState() => _AppCardState();
}

class _AppCardState extends State<AppCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeController.instance.isDarkMode(context);

    final defaultBg = isDark ? AppColors.darkSurface : Colors.white;
    final defaultBorder = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final hoverBorder = isDark ? AppColors.primaryLight.withValues(alpha: 0.6) : AppColors.primary.withValues(alpha: 0.4);

    final currentBorderColor = widget.borderColor ??
        ((_isHovered && widget.enableHoverEffect) ? hoverBorder : defaultBorder);

    final card = AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      padding: widget.padding,
      transform: (_isHovered && widget.enableHoverEffect)
          ? Matrix4.translationValues(0, -4, 0)
          : Matrix4.identity(),
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? defaultBg,
        borderRadius: BorderRadius.circular(widget.borderRadius),
        border: Border.all(color: currentBorderColor, width: 1.5),
        boxShadow: [
          if (_isHovered && widget.enableHoverEffect)
            BoxShadow(
              color: isDark
                  ? Colors.black.withValues(alpha: 0.4)
                  : AppColors.primary.withValues(alpha: 0.08),
              blurRadius: 20,
              offset: const Offset(0, 8),
            )
          else
            BoxShadow(
              color: isDark
                  ? Colors.black.withValues(alpha: 0.2)
                  : Colors.black.withValues(alpha: 0.02),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
        ],
      ),
      child: widget.child,
    );

    if (!widget.enableHoverEffect && widget.onTap == null) {
      return card;
    }

    return MouseRegion(
      cursor: widget.onTap != null ? SystemMouseCursors.click : SystemMouseCursors.basic,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: widget.onTap != null
          ? GestureDetector(onTap: widget.onTap, child: card)
          : card,
    );
  }
}
