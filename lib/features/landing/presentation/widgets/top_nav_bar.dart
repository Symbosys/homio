import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../app/router/route_names.dart';
import '../../../../core/responsive/adaptive_container.dart';
import '../../../../core/responsive/responsive_builder.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/theme_controller.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_logo.dart';

class TopNavBar extends StatelessWidget {
  const TopNavBar({
    super.key,
    required this.onSectionSelected,
    required this.onOpenMobileMenu,
  });

  final ValueChanged<int> onSectionSelected;
  final VoidCallback onOpenMobileMenu;

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeController.instance.isDarkMode(context);
    final isDesktop = context.isDesktop;

    return Container(
      height: 74,
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.darkBackground.withValues(alpha: 0.88)
            : Colors.white.withValues(alpha: 0.9),
        border: Border(
          bottom: BorderSide(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
            width: 1,
          ),
        ),
      ),
      child: AdaptiveContainer(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Brand Logo
            AppLogo(
              size: 36,
              showTag: isDesktop,
              onTap: () => onSectionSelected(0),
            ),

            // Desktop Nav Links
            if (isDesktop)
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _NavLink(
                          title: 'Overview',
                          onTap: () => onSectionSelected(1),
                        ),
                        _NavLink(
                          title: 'Capabilities',
                          onTap: () => onSectionSelected(2),
                        ),
                        _NavLink(
                          title: 'Outcomes',
                          onTap: () => onSectionSelected(3),
                        ),
                        _NavLink(
                          title: 'How It Works',
                          onTap: () => onSectionSelected(4),
                        ),
                        _NavLink(
                          title: 'Lifecycle',
                          onTap: () => onSectionSelected(5),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            // Right Actions
            if (isDesktop)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppButton(
                    text: 'Sign In',
                    variant: AppButtonVariant.ghost,
                    size: AppButtonSize.small,
                    onPressed: () => context.goNamed(RouteNames.login),
                  ),
                  const SizedBox(width: 10),
                  AppButton(
                    text: 'Start Free Trial',
                    variant: AppButtonVariant.primary,
                    size: AppButtonSize.small,
                    suffixIcon: Icons.arrow_forward_rounded,
                    onPressed: () => context.goNamed(RouteNames.login),
                  ),
                ],
              )
            else
              IconButton(
                icon: Icon(
                  Icons.menu_rounded,
                  size: 26,
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary,
                ),
                onPressed: onOpenMobileMenu,
                tooltip: 'Open navigation menu',
              ),
          ],
        ),
      ),
    );
  }
}

class _NavLink extends StatefulWidget {
  const _NavLink({required this.title, required this.onTap});

  final String title;
  final VoidCallback onTap;

  @override
  State<_NavLink> createState() => _NavLinkState();
}

class _NavLinkState extends State<_NavLink> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeController.instance.isDarkMode(context);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          child: Text(
            widget.title,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: _isHovered
                  ? (isDark ? AppColors.primaryLight : AppColors.primary)
                  : (isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary),
            ),
          ),
        ),
      ),
    );
  }
}
