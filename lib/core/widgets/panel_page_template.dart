import 'package:flutter/material.dart';

import '../navigation/client_navigation_registry.dart';
import '../navigation/navigation_menu_registry.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import 'app_badge.dart';
import 'app_card.dart';
import 'client_screen_content.dart';

/// Single, reusable template screen for all Homio CRM and Client Portal routes.
class PanelPageTemplate extends StatelessWidget {
  final String title;
  final String? clusterName;
  final String? routePath;
  final String? description;
  final IconData? icon;
  final List<String> subFeatures;

  const PanelPageTemplate({
    super.key,
    required this.title,
    this.clusterName,
    this.routePath,
    this.description,
    this.icon,
    this.subFeatures = const [],
  });

  /// Factory constructor to dynamically build the template from a route path.
  factory PanelPageTemplate.fromPath(String path) {
    if (path.startsWith('/client/')) {
      final info = ClientNavigationRegistry.findInfoByPath(path);
      return PanelPageTemplate(
        title: info.title,
        clusterName: info.clusterTitle,
        routePath: path,
        description: info.description,
        icon: info.icon,
        subFeatures: info.subFeatures,
      );
    }

    final info = NavigationMenuRegistry.findInfoByPath(path);
    return PanelPageTemplate(
      title: info.title,
      clusterName: info.clusterTitle,
      routePath: path,
      description: info.description,
      icon: info.icon,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isClient = (routePath ?? '').startsWith('/client/');

    if (isClient) {
      return SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: ClientScreenContent(
          path: routePath ?? '/client/overview',
          title: title,
          description: description,
          icon: icon ?? Icons.home_repair_service_rounded,
          subFeatures: subFeatures,
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. TOP HERO CARD
          AppCard(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Icon Box
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: AppRadius.lg,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.35),
                        blurRadius: 14,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    icon ?? Icons.layers_rounded,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),

                // Title & Badges
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 8,
                        runSpacing: 4,
                        children: [
                          if (clusterName != null && clusterName!.isNotEmpty)
                            AppBadge(
                              label: clusterName!.toUpperCase(),
                              color: AppColors.primary,
                              isPill: true,
                            ),
                          if (routePath != null && routePath!.isNotEmpty)
                            AppBadge(
                              label: routePath!,
                              color: AppColors.secondary,
                              isPill: true,
                            ),
                          const AppBadge(
                            label: 'READY',
                            color: AppColors.success,
                            isPill: true,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'This is $title',
                        style: AppTypography.headlineMedium.copyWith(
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                          color: isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.lightTextPrimary,
                        ),
                      ),
                      if (description != null && description!.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          description!,
                          style: AppTypography.bodyMedium.copyWith(
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.lightTextSecondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // 2. FEATURE WORKSPACE PLACEHOLDER CARD
          AppCard(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.darkSurfaceSubtle
                        : AppColors.lightSurfaceSubtle,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                      width: 1.5,
                    ),
                  ),
                  child: Icon(
                    icon ?? Icons.dashboard_customize_rounded,
                    size: 32,
                    color: AppColors.primaryLight,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: AppTypography.titleLarge.copyWith(
                    fontWeight: FontWeight.w800,
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 580),
                  child: Text(
                    'You are viewing the dedicated screen for "$title" at route "${routePath ?? ""}". '
                    'Detailed forms, data tables, and API integrations for this section will be configured in subsequent phases.',
                    textAlign: TextAlign.center,
                    style: AppTypography.bodyMedium.copyWith(
                      color: isDark
                          ? AppColors.darkTextMuted
                          : AppColors.lightTextMuted,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.darkSurfaceElevated
                        : AppColors.lightSurfaceSubtle,
                    borderRadius: AppRadius.md,
                    border: Border.all(
                      color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.check_circle_rounded,
                        size: 16,
                        color: AppColors.success,
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          'Route Registered & Live in Homio CRM Shell',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.labelSmall.copyWith(
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.lightTextSecondary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
