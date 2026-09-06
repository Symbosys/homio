import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../app/router/route_names.dart';
import '../../../../core/responsive/adaptive_container.dart';
import '../../../../core/responsive/responsive_builder.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/theme_controller.dart';
import '../../../../core/widgets/app_logo.dart';

class FooterSection extends StatelessWidget {
  const FooterSection({
    super.key,
    required this.onSectionSelected,
  });

  final ValueChanged<int> onSectionSelected;

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeController.instance.isDarkMode(context);
    final isCompact = context.isCompact;

    return Container(
      padding: EdgeInsets.only(
        top: isCompact ? 48 : 72,
        bottom: 36,
      ),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF070A10) : const Color(0xFFF1F5F9),
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
            width: 1,
          ),
        ),
      ),
      child: AdaptiveContainer(
        child: Column(
          children: [
            // Top Columns
            LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;
                final isStacked = width < 768;

                if (isStacked) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _BrandColumn(),
                      const SizedBox(height: 36),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _LinkColumn(
                              title: 'Platform',
                              links: [
                                _FooterLink('Overview', () => onSectionSelected(1)),
                                _FooterLink('Capabilities', () => onSectionSelected(2)),
                                _FooterLink('Outcomes', () => onSectionSelected(3)),
                                _FooterLink('Workflow', () => onSectionSelected(4)),
                              ],
                            ),
                          ),
                          Expanded(
                            child: _LinkColumn(
                              title: 'Account',
                              links: [
                                _FooterLink('Sign In', () => context.goNamed(RouteNames.login)),
                                _FooterLink('Free Trial', () => context.goNamed(RouteNames.login)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                }

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 4, child: _BrandColumn()),
                    const SizedBox(width: 48),
                    Expanded(
                      flex: 2,
                      child: _LinkColumn(
                        title: 'Platform',
                        links: [
                          _FooterLink('Overview', () => onSectionSelected(1)),
                          _FooterLink('Capabilities', () => onSectionSelected(2)),
                          _FooterLink('Outcomes', () => onSectionSelected(3)),
                          _FooterLink('How It Works', () => onSectionSelected(4)),
                          _FooterLink('Lifecycle Flow', () => onSectionSelected(5)),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: _LinkColumn(
                        title: 'Solutions',
                        links: [
                          _FooterLink('Interior & Architecture', () {}),
                          _FooterLink('Construction Teams', () {}),
                          _FooterLink('Home Services & MEP', () {}),
                          _FooterLink('Turnkey Contractors', () {}),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: _LinkColumn(
                        title: 'Account',
                        links: [
                          _FooterLink('Sign In', () => context.goNamed(RouteNames.login)),
                          _FooterLink('Start Free Trial', () => context.goNamed(RouteNames.login)),
                          _FooterLink('Enterprise Contact', () {}),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 48),
            const Divider(),
            const SizedBox(height: 24),

            // Bottom Copyright & Legal
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    '© ${DateTime.now().year} Homio Workspace Inc. All rights reserved.',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12.5,
                      color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                    ),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _LegalLink('Privacy Policy'),
                    const SizedBox(width: 16),
                    _LegalLink('Terms of Service'),
                    const SizedBox(width: 16),
                    _LegalLink('Security'),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _BrandColumn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark = ThemeController.instance.isDarkMode(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppLogo(size: 34),
        const SizedBox(height: 14),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 320),
          child: Text(
            'The all-in-one business operating system combining CRM, site execution, WhatsApp automation, finance, and AI intelligence.',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              height: 1.6,
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
            ),
          ),
        ),
      ],
    );
  }
}

class _FooterLink {
  _FooterLink(this.label, this.onTap);
  final String label;
  final VoidCallback onTap;
}

class _LinkColumn extends StatelessWidget {
  const _LinkColumn({required this.title, required this.links});

  final String title;
  final List<_FooterLink> links;

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeController.instance.isDarkMode(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.4,
            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
          ),
        ),
        const SizedBox(height: 14),
        ...links.map(
          (l) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: InkWell(
              onTap: l.onTap,
              child: Text(
                l.label,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _LegalLink extends StatelessWidget {
  const _LegalLink(this.title);
  final String title;

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeController.instance.isDarkMode(context);

    return Text(
      title,
      style: GoogleFonts.plusJakartaSans(
        fontSize: 12,
        color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
      ),
    );
  }
}
