import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../app/router/route_names.dart';
import '../../../../core/responsive/adaptive_container.dart';
import '../../../../core/responsive/responsive_builder.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/theme_controller.dart';
import '../../../../core/widgets/app_badge.dart';
import '../../../../core/widgets/app_button.dart';
import 'dashboard_mockup.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key, required this.onExploreTap});

  final VoidCallback onExploreTap;

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeController.instance.isDarkMode(context);
    final isCompact = context.isCompact;
    final isDesktop = context.isDesktop;

    final headingSize = context.responsiveValue<double>(
      compact: 32.0,
      medium: 42.0,
      expanded: 52.0,
      large: 58.0,
    );

    return Stack(
      children: [
        // Decorative radial ambient glow
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: 500,
          child: Container(
            decoration: BoxDecoration(
              gradient: isDark
                  ? AppColors.heroGlowDark
                  : AppColors.heroGlowLight,
            ),
          ),
        ),

        AdaptiveContainer(
          padding: EdgeInsets.symmetric(
            horizontal: isCompact ? 16.0 : 32.0,
            vertical: isCompact ? 36.0 : 64.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Announcement Pill
              AppBadge(
                label: 'THE NEXT-GENERATION ENTERPRISE WORKSPACE',
                icon: Icons.auto_awesome_rounded,
                color: AppColors.primary,
              ),
              const SizedBox(height: 24),

              // Hero Headline
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 960),
                child: Text.rich(
                  TextSpan(
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: headingSize,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -1.5,
                      height: 1.14,
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary,
                    ),
                    children: [
                      const TextSpan(
                        text: 'Run Your Business.\nManage Your Customers.\n',
                      ),
                      TextSpan(
                        text: 'Deliver Every Project.',
                        style: TextStyle(
                          foreground: Paint()
                            ..shader =
                                const LinearGradient(
                                  colors: [
                                    Color(0xFF4F46E5),
                                    Color(0xFF9333EA),
                                    Color(0xFF06B6D4),
                                  ],
                                ).createShader(
                                  const Rect.fromLTWH(0.0, 0.0, 450.0, 70.0),
                                ),
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),

              // Supporting Copy
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 720),
                child: Text(
                  'One intelligent platform unifying lead funnels, site execution milestones, WhatsApp drip automation, team hierarchy, finance, and AI intelligence — without the chaos of disconnected tools.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: isCompact ? 15.0 : 18.0,
                    fontWeight: FontWeight.w400,
                    height: 1.6,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // CTAs
              isCompact
                  ? ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 340),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AppButton(
                            text: 'Start Free 14-Day Trial',
                            size: AppButtonSize.large,
                            isFullWidth: true,
                            suffixIcon: Icons.arrow_forward_rounded,
                            onPressed: () => context.goNamed(RouteNames.login),
                          ),
                          const SizedBox(height: 12),
                          AppButton(
                            text: 'Explore Capabilities',
                            variant: AppButtonVariant.outline,
                            size: AppButtonSize.large,
                            isFullWidth: true,
                            prefixIcon: Icons.explore_rounded,
                            onPressed: onExploreTap,
                          ),
                        ],
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AppButton(
                          text: 'Start Free 14-Day Trial',
                          size: AppButtonSize.large,
                          suffixIcon: Icons.arrow_forward_rounded,
                          onPressed: () => context.goNamed(RouteNames.login),
                        ),
                        const SizedBox(width: 16),
                        AppButton(
                          text: 'Explore Capabilities',
                          variant: AppButtonVariant.outline,
                          size: AppButtonSize.large,
                          prefixIcon: Icons.explore_rounded,
                          onPressed: onExploreTap,
                        ),
                      ],
                    ),
              const SizedBox(height: 24),

              // Micro Trust Strip
              Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 20,
                runSpacing: 8,
                children: [
                  _TrustItem(
                    icon: Icons.check_circle_rounded,
                    text: 'No credit card required',
                  ),
                  _TrustItem(
                    icon: Icons.bolt_rounded,
                    text: 'Setup in 2 minutes',
                  ),
                  _TrustItem(
                    icon: Icons.shield_rounded,
                    text: 'SOC 2 Type II Certified',
                  ),
                  _TrustItem(
                    icon: Icons.star_rounded,
                    text: '4.9/5 from 1,200+ teams',
                  ),
                ],
              ),
              SizedBox(height: isDesktop ? 54 : 36),

              // Simulated Interactive Dashboard Mockup
              const DashboardMockup(),
            ],
          ),
        ),
      ],
    );
  }
}

class _TrustItem extends StatelessWidget {
  const _TrustItem({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeController.instance.isDarkMode(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 15, color: AppColors.success),
        const SizedBox(width: 6),
        Text(
          text,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12.5,
            fontWeight: FontWeight.w500,
            color: isDark
                ? AppColors.darkTextMuted
                : AppColors.lightTextSecondary,
          ),
        ),
      ],
    );
  }
}
