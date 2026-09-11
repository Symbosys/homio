import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../models/organization_models.dart';
import '../models/organization_mock_data.dart';
import 'org_status_badge.dart';

class OrgEffectiveAccessModal extends StatelessWidget {
  final OrganizationEmployee employee;

  const OrgEffectiveAccessModal({
    super.key,
    required this.employee,
  });

  static void show(BuildContext context, OrganizationEmployee employee) {
    showDialog(
      context: context,
      builder: (ctx) => OrgEffectiveAccessModal(employee: employee),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final summary = OrganizationMockData.getEffectiveAccessForEmployee(employee);
    final role = OrganizationMockData.roles.firstWhere(
      (r) => r.id == employee.roleId,
      orElse: () => OrganizationMockData.roles.first,
    );
    final scope = OrganizationMockData.accessScopes.firstWhere(
      (s) => s.id == employee.accessScopeId,
      orElse: () => OrganizationMockData.accessScopes.first,
    );

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      elevation: 10,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 680, maxHeight: 720),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Modal Title Bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.security_outlined,
                          size: 22,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Effective Access Evaluation',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                            ),
                          ),
                          Text(
                            'User → Role → Permissions + Access Scope Audit',
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark ? AppColors.darkSubtext : AppColors.lightTextSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close_rounded, size: 20),
                    color: isDark ? AppColors.darkSubtext : AppColors.lightTextSecondary,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(height: 1),
              const SizedBox(height: 16),

              // Scrollable Content
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // User Identity & Assignment Card
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                          ),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 24,
                              backgroundImage: NetworkImage(employee.avatarUrl),
                              backgroundColor: AppColors.primary.withValues(alpha: 0.2),
                              child: Text(
                                employee.name.isNotEmpty ? employee.name[0] : 'U',
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Flexible(
                                        child: Text(
                                          employee.name,
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      OrgStatusBadge.forAccountStatus(employee.accountStatus, isDark),
                                    ],
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    '${employee.jobTitle} • ${employee.departmentName} (${employee.teamName ?? "No Team"})',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: isDark ? AppColors.darkSubtext : AppColors.lightTextSecondary,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Reports to: ${employee.managerName ?? "Direct to Board"} • ID: ${employee.employeeId}',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Plain-English Effective Access Summary (Callout)
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: summary.hasAdminPrivileges
                              ? (isDark ? const Color(0xFF4C1D95).withValues(alpha: 0.2) : const Color(0xFFEDE9FE))
                              : (isDark ? const Color(0xFF0C4A6E).withValues(alpha: 0.2) : const Color(0xFFE0F2FE)),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: summary.hasAdminPrivileges
                                ? const Color(0xFF8B5CF6).withValues(alpha: 0.4)
                                : const Color(0xFF38BDF8).withValues(alpha: 0.4),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  summary.hasAdminPrivileges ? Icons.admin_panel_settings_rounded : Icons.psychology_outlined,
                                  size: 18,
                                  color: summary.hasAdminPrivileges ? const Color(0xFF8B5CF6) : const Color(0xFF0284C7),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Effective Security Evaluation',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: summary.hasAdminPrivileges
                                        ? (isDark ? const Color(0xFFDDD6FE) : const Color(0xFF5B21B6))
                                        : (isDark ? const Color(0xFFBAE6FD) : const Color(0xFF075985)),
                                    letterSpacing: 0.3,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              summary.humanReadableSummary,
                              style: TextStyle(
                                fontSize: 13,
                                height: 1.45,
                                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),

                      // Security Coordinates Grid (Role + Scope)
                      Row(
                        children: [
                          Expanded(
                            child: _buildInfoCard(
                              isDark,
                              title: 'ASSIGNED ROLE',
                              mainText: role.roleTitle,
                              subText: '${role.permissionCount} Granular Permissions Granted',
                              badge: OrgStatusBadge.forRoleType(role.roleType, isDark),
                              icon: Icons.badge_outlined,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildInfoCard(
                              isDark,
                              title: 'APPLICABLE ACCESS SCOPE',
                              mainText: scope.name,
                              subText: scope.description,
                              badge: OrgStatusBadge.forScope(scope.scopeLevel, isDark),
                              icon: Icons.travel_explore_rounded,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Permissions Matrix by Module
                      Text(
                        'GRANTED MODULE CAPABILITIES',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: isDark ? AppColors.darkSubtext : AppColors.lightTextSecondary,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ...summary.permissionsByModule.entries.map((entry) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.check_circle_rounded, size: 16, color: AppColors.success),
                                  const SizedBox(width: 8),
                                  Text(
                                    entry.key.displayName,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    '${entry.value.length} actions allowed',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 6,
                                runSpacing: 6,
                                children: entry.value.map((p) {
                                  return Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(
                                        color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                                      ),
                                    ),
                                    child: Text(
                                      '${p.feature}: ${p.action.displayName}',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w500,
                                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),
              const Divider(height: 1),
              const SizedBox(height: 16),

              // Bottom Actions
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Audit ID: EVA-${employee.id}-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
                    style: TextStyle(
                      fontSize: 11,
                      color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Close'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(
    bool isDark, {
    required String title,
    required String mainText,
    required String subText,
    required Widget badge,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.darkSubtext : AppColors.lightTextSecondary,
                  letterSpacing: 0.5,
                ),
              ),
              badge,
            ],
          ),
          const SizedBox(height: 6),
          Text(
            mainText,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            subText,
            style: TextStyle(
              fontSize: 11,
              color: isDark ? AppColors.darkSubtext : AppColors.lightTextSecondary,
              height: 1.3,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
