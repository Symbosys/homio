import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../app/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/theme_controller.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_logo.dart';

class MobileNavDrawer extends StatelessWidget {
  const MobileNavDrawer({
    super.key,
    required this.onSectionSelected,
  });

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
              const SizedBox(height: 28),
              const Divider(),
              const SizedBox(height: 16),

              // Nav Items
              _MobileItem(
                title: 'Overview',
                icon: Icons.dashboard_outlined,
                onTap: () {
                  Navigator.of(context).pop();
                  onSectionSelected(1);
                },
              ),
              _MobileItem(
                title: 'Key Capabilities',
                icon: Icons.layers_outlined,
                onTap: () {
                  Navigator.of(context).pop();
                  onSectionSelected(2);
                },
              ),
              _MobileItem(
                title: 'Business Outcomes',
                icon: Icons.trending_up_rounded,
                onTap: () {
                  Navigator.of(context).pop();
                  onSectionSelected(3);
                },
              ),
              _MobileItem(
                title: 'How It Works',
                icon: Icons.route_outlined,
                onTap: () {
                  Navigator.of(context).pop();
                  onSectionSelected(4);
                },
              ),
              _MobileItem(
                title: 'Platform Lifecycle',
                icon: Icons.all_inclusive_rounded,
                onTap: () {
                  Navigator.of(context).pop();
                  onSectionSelected(5);
                },
              ),

              const Spacer(),

              // Action Buttons
              AppButton(
                text: 'Sign In',
                variant: AppButtonVariant.outline,
                isFullWidth: true,
                onPressed: () {
                  Navigator.of(context).pop();
                  context.goNamed(RouteNames.login);
                },
              ),
              const SizedBox(height: 12),
              AppButton(
                text: 'Start Free Trial',
                variant: AppButtonVariant.primary,
                isFullWidth: true,
                suffixIcon: Icons.arrow_forward_rounded,
                onPressed: () {
                  Navigator.of(context).pop();
                  context.goNamed(RouteNames.login);
                },
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
    required this.icon,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeController.instance.isDarkMode(context);

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 4),
      leading: Icon(
        icon,
        size: 22,
        color: isDark ? AppColors.primaryLight : AppColors.primary,
      ),
      title: Text(
        title,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right_rounded,
        size: 20,
        color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
      ),
      onTap: onTap,
    );
  }
}
