import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/responsive/adaptive_container.dart';
import '../../../../core/responsive/responsive_builder.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/theme_controller.dart';
import '../../../../core/widgets/app_logo.dart';

class TopNavBar extends StatelessWidget {
  const TopNavBar({
    super.key,
    required this.onSectionSelected,
    required this.onOpenMobileMenu,
  });

  /// Callback to scroll to a specific section index:
  /// 0: Platform (Hero)
  /// 1: AI (Design & Vastu)
  /// 4: Marketplace
  /// 5: Projects (Sales & Execution)
  /// 7: Operations (Finance & Workforce)
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
            ? AppColors.darkBackground.withValues(alpha: 0.92)
            : const Color(0xFFFAFAFA).withValues(alpha: 0.94),
        border: Border(
          bottom: BorderSide(
            color: isDark ? AppColors.darkBorder : const Color(0xFFE5E7EB),
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
              size: 34,
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
                          title: 'Platform',
                          onTap: () => onSectionSelected(0),
                        ),
                        _NavLink(
                          title: 'AI',
                          onTap: () => onSectionSelected(1),
                        ),
                        _NavLink(
                          title: 'Marketplace',
                          onTap: () => onSectionSelected(4),
                        ),
                        _NavLink(
                          title: 'Projects',
                          onTap: () => onSectionSelected(5),
                        ),
                        _NavLink(
                          title: 'Operations',
                          onTap: () => onSectionSelected(7),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            // Right Actions: Showcase Badge & Theme Switcher
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Product Showcase Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF1E293B)
                        : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isDark
                          ? const Color(0xFF334155)
                          : const Color(0xFFCBD5E1),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 7,
                        height: 7,
                        decoration: const BoxDecoration(
                          color: Color(0xFF10B981),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'PRODUCT SHOWCASE',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.8,
                          color: isDark
                              ? const Color(0xFF94A3B8)
                              : const Color(0xFF475569),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 12),

                // Theme Toggle
                ListenableBuilder(
                  listenable: ThemeController.instance,
                  builder: (context, _) {
                    final dark = ThemeController.instance.isDarkMode(context);
                    return IconButton(
                      icon: Icon(
                        dark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                        size: 20,
                        color: dark ? const Color(0xFFF1F5F9) : const Color(0xFF334155),
                      ),
                      tooltip: dark ? 'Switch to Light Theme' : 'Switch to Dark Theme',
                      onPressed: () => ThemeController.instance.toggleTheme(),
                    );
                  },
                ),

                // Mobile Hamburger Menu Button
                if (!isDesktop)
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
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 150),
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.2,
              color: _isHovered
                  ? (isDark ? AppColors.primaryLight : AppColors.primary)
                  : (isDark
                        ? const Color(0xFF94A3B8)
                        : const Color(0xFF475569)),
            ),
            child: Text(widget.title),
          ),
        ),
      ),
    );
  }
}
