import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../app/router/route_names.dart';

enum OrgNavTab {
  departments,
  teams,
  employees,
  roles,
  permissions,
  accessScope;

  String get label {
    switch (this) {
      case OrgNavTab.departments:
        return 'Departments';
      case OrgNavTab.teams:
        return 'Teams';
      case OrgNavTab.employees:
        return 'Employees';
      case OrgNavTab.roles:
        return 'Roles';
      case OrgNavTab.permissions:
        return 'Permissions';
      case OrgNavTab.accessScope:
        return 'Access Scope';
    }
  }

  IconData get icon {
    switch (this) {
      case OrgNavTab.departments:
        return Icons.schema_outlined;
      case OrgNavTab.teams:
        return Icons.group_work_outlined;
      case OrgNavTab.employees:
        return Icons.person_outline_rounded;
      case OrgNavTab.roles:
        return Icons.admin_panel_settings_outlined;
      case OrgNavTab.permissions:
        return Icons.vpn_key_outlined;
      case OrgNavTab.accessScope:
        return Icons.security_outlined;
    }
  }

  String get route {
    switch (this) {
      case OrgNavTab.departments:
        return RouteNames.orgDepartmentsPath;
      case OrgNavTab.teams:
        return RouteNames.orgTeamsPath;
      case OrgNavTab.employees:
        return RouteNames.orgEmployeesPath;
      case OrgNavTab.roles:
        return RouteNames.orgRolesPath;
      case OrgNavTab.permissions:
        return RouteNames.orgPermissionsPath;
      case OrgNavTab.accessScope:
        return RouteNames.orgAccessScopePath;
    }
  }
}

class OrgNavigationHeader extends StatelessWidget {
  final OrgNavTab activeTab;
  final String title;
  final String subtitle;
  final Widget? trailing;

  const OrgNavigationHeader({
    super.key,
    required this.activeTab,
    required this.title,
    required this.subtitle,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title Bar & Trailing Actions
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
              ),
              child: const Icon(
                Icons.corporate_fare_rounded,
                size: 24,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.3,
                          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: AppColors.primary.withValues(alpha: 0.25)),
                        ),
                        child: const Text(
                          'ORGANIZATION MODULE',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark ? AppColors.darkSubtext : AppColors.lightTextSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (trailing != null) ...[
              const SizedBox(width: 12),
              trailing!,
            ],
          ],
        ),
        const SizedBox(height: 16),

        // Global Navigation Tabs with Contextual Counts
        Container(
          height: 46,
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
            ),
          ),
          padding: const EdgeInsets.all(4),
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildTab(context, OrgNavTab.departments, '8', isDark),
              const SizedBox(width: 4),
              _buildTab(context, OrgNavTab.teams, '18', isDark),
              const SizedBox(width: 4),
              _buildTab(context, OrgNavTab.employees, '42', isDark),
              const SizedBox(width: 4),
              _buildTab(context, OrgNavTab.roles, '12', isDark),
              const SizedBox(width: 4),
              _buildTab(context, OrgNavTab.permissions, '64', isDark),
              const SizedBox(width: 4),
              _buildTab(context, OrgNavTab.accessScope, '9', isDark),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTab(BuildContext context, OrgNavTab tab, String count, bool isDark) {
    final isSelected = tab == activeTab;

    return InkWell(
      onTap: () {
        if (!isSelected) {
          context.go(tab.route);
        }
      },
      borderRadius: BorderRadius.circular(8),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              tab.icon,
              size: 16,
              color: isSelected
                  ? Colors.white
                  : (isDark ? AppColors.darkSubtext : AppColors.lightTextSecondary),
            ),
            const SizedBox(width: 8),
            Text(
              tab.label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected
                    ? Colors.white
                    : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
              ),
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.white.withValues(alpha: 0.22)
                    : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                count,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: isSelected
                      ? Colors.white
                      : (isDark ? AppColors.darkSubtext : AppColors.lightTextSecondary),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
