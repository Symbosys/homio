import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/theme_controller.dart';
import '../../../../core/widgets/app_logo.dart';

class MobileNavDrawer extends StatelessWidget {
  const MobileNavDrawer({super.key, required this.onSectionSelected});

  final ValueChanged<int> onSectionSelected;

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeController.instance.isDarkMode(context);

    return Drawer(
      backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const AppLogo(size: 32, showTag: false),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Divider(
                color: isDark ? AppColors.darkBorder : const Color(0xFFE5E7EB),
              ),
              const SizedBox(height: 16),

              // Nav Items matching the 5 anchor areas
              _MobileItem(
                title: 'Platform Overview',
                subtitle: 'Unified Design & Business System',
                icon: Icons.dashboard_outlined,
                onTap: () {
                  Navigator.of(context).pop();
                  onSectionSelected(0);
                },
              ),
              _MobileItem(
                title: 'AI Intelligence',
                subtitle: 'Room Generation & Vastu Analysis',
                icon: Icons.auto_awesome_rounded,
                onTap: () {
                  Navigator.of(context).pop();
                  onSectionSelected(1);
                },
              ),
              _MobileItem(
                title: 'Marketplace',
                subtitle: 'Decor, Digital, Properties & Materials',
                icon: Icons.storefront_outlined,
                onTap: () {
                  Navigator.of(context).pop();
                  onSectionSelected(4);
                },
              ),
              _MobileItem(
                title: 'Projects & Execution',
                subtitle: 'Sales CRM & Site Tracking',
                icon: Icons.apartment_rounded,
                onTap: () {
                  Navigator.of(context).pop();
                  onSectionSelected(5);
                },
              ),
              _MobileItem(
                title: 'Operations & Finance',
                subtitle: 'Procurement, Workforce & Ledger',
                icon: Icons.account_balance_outlined,
                onTap: () {
                  Navigator.of(context).pop();
                  onSectionSelected(7);
                },
              ),

              const Spacer(),

              // Theme Switcher Row in Drawer
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Theme Mode',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white70 : const Color(0xFF475569),
                      ),
                    ),
                    ListenableBuilder(
                      listenable: ThemeController.instance,
                      builder: (context, _) {
                        final dark = ThemeController.instance.isDarkMode(context);
                        return IconButton(
                          icon: Icon(
                            dark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                            size: 20,
                            color: dark ? Colors.amber : const Color(0xFF334155),
                          ),
                          onPressed: () => ThemeController.instance.toggleTheme(),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Product Showcase Pill
              Center(
                child: Text(
                  'HOMIO CRM • PRODUCT SHOWCASE',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                    color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MobileItem extends StatelessWidget {
  const _MobileItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeController.instance.isDarkMode(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.primary.withValues(alpha: 0.15)
                    : AppColors.primaryMuted,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 20, color: AppColors.primary),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              size: 18,
              color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
            ),
          ],
        ),
      ),
    );
  }
}
