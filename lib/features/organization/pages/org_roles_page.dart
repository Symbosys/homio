import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../models/organization_models.dart';
import '../models/organization_mock_data.dart';
import '../widgets/org_navigation_header.dart';
import '../widgets/org_toolbar.dart';
import '../widgets/org_status_badge.dart';
import '../widgets/org_detail_drawer.dart';
import '../widgets/org_confirmation_dialog.dart';
import '../widgets/org_create_role_dialog.dart';

class OrgRolesPage extends StatefulWidget {
  const OrgRolesPage({super.key});

  @override
  State<OrgRolesPage> createState() => _OrgRolesPageState();
}

class _OrgRolesPageState extends State<OrgRolesPage> {
  final List<OrganizationRole> _roles = List.from(OrganizationMockData.roles);
  String _searchQuery = '';
  OrgViewMode _viewMode = OrgViewMode.table;
  DepartmentType? _filterDepartment;
  RoleType? _filterRoleType;
  OrgStatus? _filterStatus;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final width = MediaQuery.of(context).size.width;
    final isCompact = width < 768;

    final filtered = _roles.where((r) {
      final matchesSearch = _searchQuery.isEmpty ||
          r.roleTitle.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          r.roleCode.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          r.departmentType.displayName.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesDept = _filterDepartment == null || r.departmentType == _filterDepartment;
      final matchesType = _filterRoleType == null || r.roleType == _filterRoleType;
      final matchesStatus = _filterStatus == null || r.status == _filterStatus;

      return matchesSearch && matchesDept && matchesType && matchesStatus;
    }).toList();

    // KPI counts
    final totalRoles = _roles.length;
    final systemRoles = _roles.where((r) => r.roleType == RoleType.system).length;
    final customRoles = _roles.where((r) => r.roleType == RoleType.custom).length;
    final totalAssigned = _roles.fold<int>(0, (sum, r) => sum + r.userCount);

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isCompact ? 14 : 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Navigation Header
            OrgNavigationHeader(
              activeTab: OrgNavTab.roles,
              title: 'Role Definitions & Capability Matrices',
              subtitle: 'System security roles, functional authority levels, default visibility boundaries & permission sets',
              trailing: !isCompact
                  ? ElevatedButton.icon(
                      onPressed: _openCreateRole,
                      icon: const Icon(Icons.add_rounded, size: 18, color: Colors.white),
                      label: const Text('New Role'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    )
                  : null,
            ),
            const SizedBox(height: 18),

            // 2. High-Level Summary Metrics Row
            _buildKpiMetrics(isDark, totalRoles, systemRoles, customRoles, totalAssigned, width),
            const SizedBox(height: 20),

            // 3. Toolbar
            OrgToolbar(
              searchHint: 'Search roles by title, code or department...',
              searchQuery: _searchQuery,
              onSearchChanged: (v) => setState(() => _searchQuery = v),
              currentViewMode: _viewMode,
              supportedViewModes: const [OrgViewMode.table, OrgViewMode.cards],
              onViewModeChanged: (m) => setState(() => _viewMode = m),
              primaryActionLabel: isCompact ? 'New Role' : null,
              onPrimaryAction: _openCreateRole,
              activeFilterCount: (_filterDepartment != null ? 1 : 0) +
                  (_filterRoleType != null ? 1 : 0) +
                  (_filterStatus != null ? 1 : 0),
              onFilterPressed: _showFilterDialog,
              onExportPressed: _exportData,
              onRefresh: () => setState(() {}),
            ),
            const SizedBox(height: 16),

            // 4. Content Area
            if (filtered.isEmpty)
              _buildEmptyState(isDark)
            else if (_viewMode == OrgViewMode.cards || isCompact)
              _buildCardsView(isDark, filtered)
            else
              _buildTableView(isDark, filtered),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // KPI Metrics
  // ---------------------------------------------------------------------------
  Widget _buildKpiMetrics(bool isDark, int total, int system, int custom, int assigned, double width) {
    final cards = [
      _buildKpiCard(isDark, 'TOTAL SYSTEM ROLES', '$total', 'Across all 8 departments', Icons.admin_panel_settings_outlined, AppColors.primary),
      _buildKpiCard(isDark, 'SYSTEM PROTECTED', '$system Roles', 'Protected from deletion', Icons.lock_outline_rounded, const Color(0xFF7C3AED)),
      _buildKpiCard(isDark, 'CUSTOM DEFINITIONS', '$custom Roles', 'Organization-specific', Icons.tune_rounded, const Color(0xFF0284C7)),
      _buildKpiCard(isDark, 'ASSIGNED USERS', '$assigned Staff', 'Active role occupants', Icons.people_outline_rounded, const Color(0xFF10B981)),
    ];

    if (width < 600) {
      return Column(
        children: cards.map((c) => Padding(padding: const EdgeInsets.only(bottom: 10), child: c)).toList(),
      );
    } else if (width < 1100) {
      return GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        childAspectRatio: 2.3,
        children: cards,
      );
    } else {
      return Row(
        children: cards.map((c) => Expanded(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 6), child: c))).toList(),
      );
    }
  }

  Widget _buildKpiCard(bool isDark, String label, String val, String sub, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: isDark ? AppColors.darkSubtext : AppColors.lightTextSecondary, letterSpacing: 0.5),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    val,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                  ),
                ),
                Text(
                  sub,
                  style: TextStyle(fontSize: 11, color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Table View
  // ---------------------------------------------------------------------------
  Widget _buildTableView(bool isDark, List<OrganizationRole> items) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            headingRowColor: WidgetStateProperty.all(isDark ? AppColors.darkBackground : AppColors.lightBackground),
            horizontalMargin: 16,
            columnSpacing: 22,
            columns: const [
              DataColumn(label: Text('ROLE TITLE & CODE', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold))),
              DataColumn(label: Text('TYPE', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold))),
              DataColumn(label: Text('DEPARTMENT', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold))),
              DataColumn(label: Text('LEVEL', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold))),
              DataColumn(label: Text('USERS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold))),
              DataColumn(label: Text('PERMISSIONS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold))),
              DataColumn(label: Text('DEFAULT SCOPE', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold))),
              DataColumn(label: Text('STATUS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold))),
              DataColumn(label: Text('ACTIONS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold))),
            ],
            rows: items.map((r) {
              return DataRow(
                cells: [
                  DataCell(
                    InkWell(
                      onTap: () => _openRoleDetail(r),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            r.roleTitle,
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.primary),
                          ),
                          Text(
                            '${r.roleCode} • Reports: ${r.reportingToRole}',
                            style: TextStyle(fontSize: 11, color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted),
                          ),
                        ],
                      ),
                    ),
                  ),
                  DataCell(OrgStatusBadge.forRoleType(r.roleType, isDark)),
                  DataCell(Text(r.departmentType.displayName, style: const TextStyle(fontSize: 12))),
                  DataCell(
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(r.hierarchyLevel.displayName, style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w500)),
                    ),
                  ),
                  DataCell(Text('${r.userCount} Users', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600))),
                  DataCell(
                    ActionChip(
                      avatar: const Icon(Icons.vpn_key_rounded, size: 14, color: AppColors.primary),
                      label: Text('${r.permissionCount} Perms', style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600)),
                      onPressed: () => _openRoleDetail(r),
                    ),
                  ),
                  DataCell(
                    Text(
                      r.defaultAccessScopeName,
                      style: const TextStyle(fontSize: 11.5),
                    ),
                  ),
                  DataCell(OrgStatusBadge.forOrgStatus(r.status, isDark)),
                  DataCell(
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.visibility_outlined, size: 17),
                          tooltip: 'View Role Details',
                          onPressed: () => _openRoleDetail(r),
                          color: isDark ? AppColors.darkSubtext : AppColors.lightTextSecondary,
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit_outlined, size: 17),
                          tooltip: 'Edit Permissions',
                          onPressed: () => _openEditRole(r),
                          color: isDark ? AppColors.darkSubtext : AppColors.lightTextSecondary,
                        ),
                        PopupMenuButton<String>(
                          icon: const Icon(Icons.more_vert_rounded, size: 17),
                          onSelected: (action) => _handleRoleAction(action, r),
                          itemBuilder: (ctx) => [
                            const PopupMenuItem(value: 'duplicate', child: Text('Duplicate Role')),
                            const PopupMenuItem(value: 'toggle_status', child: Text('Toggle Status')),
                            if (r.roleType == RoleType.custom)
                              const PopupMenuItem(value: 'delete', child: Text('Delete Custom Role', style: TextStyle(color: AppColors.error))),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Cards View (Mobile & Tablet)
  // ---------------------------------------------------------------------------
  Widget _buildCardsView(bool isDark, List<OrganizationRole> items) {
    return Column(
      children: items.map((r) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      r.roleTitle,
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  OrgStatusBadge.forRoleType(r.roleType, isDark),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                '${r.roleCode} • ${r.departmentType.displayName} (${r.hierarchyLevel.displayName})',
                style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkSubtext : AppColors.lightTextSecondary),
              ),
              const SizedBox(height: 8),
              Text(
                r.description,
                style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary, height: 1.35),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: [
                  _buildTag(isDark, '${r.permissionCount} Permissions', Icons.vpn_key_outlined),
                  _buildTag(isDark, '${r.userCount} Assigned Staff', Icons.people_outline_rounded),
                  _buildTag(isDark, r.defaultAccessScopeName, Icons.security_outlined),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(height: 1),
              const SizedBox(height: 8),
              Wrap(
                alignment: WrapAlignment.end,
                spacing: 8,
                runSpacing: 6,
                children: [
                  TextButton(
                    onPressed: () => _openRoleDetail(r),
                    child: const Text('View Matrix', style: TextStyle(fontSize: 12)),
                  ),
                  OutlinedButton(
                    onPressed: () => _openEditRole(r),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Edit Permissions', style: TextStyle(fontSize: 12)),
                  ),
                ],
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTag(bool isDark, String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      constraints: const BoxConstraints(maxWidth: 260),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: isDark ? AppColors.darkSubtext : AppColors.lightTextSecondary),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              label,
              style: TextStyle(fontSize: 11, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(40),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Column(
        children: [
          Icon(Icons.policy_outlined, size: 48, color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted),
          const SizedBox(height: 12),
          Text(
            'No Security Roles Found',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
          ),
          const SizedBox(height: 4),
          Text(
            'No roles match the selected search query or department filter.',
            style: TextStyle(fontSize: 13, color: isDark ? AppColors.darkSubtext : AppColors.lightTextSecondary),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _searchQuery = '';
                _filterDepartment = null;
                _filterRoleType = null;
                _filterStatus = null;
              });
            },
            child: const Text('Clear All Filters'),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Action Handlers & Dialog Triggers
  // ---------------------------------------------------------------------------
  void _openCreateRole() {
    OrgCreateRoleDialog.show(
      context,
      onSave: (newRole) {
        setState(() {
          _roles.insert(0, newRole);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Role "${newRole.roleTitle}" created successfully!')),
        );
      },
    );
  }

  void _openEditRole(OrganizationRole r) {
    OrgCreateRoleDialog.show(
      context,
      roleToEdit: r,
      onSave: (updated) {
        setState(() {
          final idx = _roles.indexWhere((item) => item.id == r.id);
          if (idx != -1) _roles[idx] = updated;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Role "${updated.roleTitle}" updated successfully!')),
        );
      },
    );
  }

  void _openRoleDetail(OrganizationRole r) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final assignedStaff = OrganizationMockData.employees.where((e) => e.roleId == r.id).toList();
    final rolePermissions = OrganizationMockData.permissions.where((p) => r.permissionIds.contains(p.code)).toList();

    OrgDetailDrawer.show(
      context,
      title: r.roleTitle,
      subtitle: '${r.roleCode} • ${r.departmentType.displayName}',
      badge: OrgStatusBadge.forRoleType(r.roleType, isDark),
      tabTitles: const ['Overview', 'Permissions', 'Users', 'Scope', 'Activity'],
      tabViews: [
        // Tab 1: Overview
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Role Classification', r.roleType.displayName),
            _buildDetailRow('Primary Department', r.departmentType.displayName),
            _buildDetailRow('Hierarchy Level', r.hierarchyLevel.displayName),
            _buildDetailRow('Reports To', r.reportingToRole),
            _buildDetailRow('Default Access Scope', r.defaultAccessScopeName),
            const SizedBox(height: 14),
            Text(r.description, style: const TextStyle(fontSize: 12, height: 1.4)),
            const SizedBox(height: 16),
            const Text('Core Responsibilities:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ...r.responsibilities.map((resp) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle_rounded, size: 14, color: AppColors.primary),
                      const SizedBox(width: 8),
                      Expanded(child: Text(resp, style: const TextStyle(fontSize: 12))),
                    ],
                  ),
                )),
          ],
        ),

        // Tab 2: Permissions Matrix
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'GRANTED CAPABILITIES (${rolePermissions.length} PERMISSIONS)',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: isDark ? AppColors.darkSubtext : AppColors.lightTextSecondary, letterSpacing: 0.5),
            ),
            const SizedBox(height: 12),
            ...rolePermissions.map((p) {
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle_rounded, size: 16, color: AppColors.success),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${p.module.displayName}: ${p.name}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                          Text('Code: ${p.code} • Action: ${p.action.displayName}', style: TextStyle(fontSize: 10.5, color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted)),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),

        // Tab 3: Users
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ASSIGNED STAFF (${assignedStaff.length} EMPLOYEES)',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: isDark ? AppColors.darkSubtext : AppColors.lightTextSecondary, letterSpacing: 0.5),
            ),
            const SizedBox(height: 12),
            if (assignedStaff.isEmpty)
              const Center(child: Text('No employees currently assigned.'))
            else
              ...assignedStaff.map((e) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(radius: 14, backgroundImage: NetworkImage(e.avatarUrl)),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(e.name, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                            Text('${e.jobTitle} • ${e.departmentName}', style: const TextStyle(fontSize: 11)),
                          ],
                        ),
                      ),
                      OrgStatusBadge.forAccountStatus(e.accountStatus, isDark),
                    ],
                  ),
                );
              }),
          ],
        ),

        // Tab 4: Scope
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Default Access Scope', r.defaultAccessScopeName),
            _buildDetailRow('Boundary Rule', 'Inherited from Access Scope configuration'),
          ],
        ),

        // Tab 5: Activity
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: OrganizationMockData.auditLogs
              .where((a) => a.entityId == r.id || a.entityType.contains('Role'))
              .map((log) {
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(log.action, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primary)),
                  const SizedBox(height: 2),
                  Text(log.reason, style: const TextStyle(fontSize: 11)),
                ],
              ),
            );
          }).toList(),
        ),
      ],
      actions: [
        OutlinedButton(
          onPressed: () {
            Navigator.of(context).pop();
            _openEditRole(r);
          },
          child: const Text('Edit Permissions'),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 140, child: Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey))),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600))),
        ],
      ),
    );
  }

  Future<void> _handleRoleAction(String action, OrganizationRole r) async {
    if (action == 'duplicate') {
      final duplicate = r.copyWith(
        id: 'ROLE-${DateTime.now().millisecondsSinceEpoch}',
        roleCode: '${r.roleCode}_COPY',
        roleTitle: '${r.roleTitle} (Copy)',
        roleType: RoleType.custom,
        userCount: 0,
      );
      setState(() => _roles.insert(0, duplicate));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Duplicated "${r.roleTitle}" to new custom role!')),
      );
    } else if (action == 'toggle_status') {
      setState(() {
        final idx = _roles.indexWhere((item) => item.id == r.id);
        if (idx != -1) {
          _roles[idx] = r.copyWith(
            status: r.status == OrgStatus.active ? OrgStatus.inactive : OrgStatus.active,
          );
        }
      });
    } else if (action == 'delete') {
      if (r.roleType == RoleType.system) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('System roles cannot be deleted for compliance and stability.')),
        );
        return;
      }
      final confirmed = await OrgConfirmationDialog.show(
        context,
        title: 'Delete Custom Role',
        message: 'Are you sure you want to delete "${r.roleTitle}"?',
        confirmLabel: 'Delete Role',
        isDestructive: true,
      );
      if (confirmed == true) {
        setState(() => _roles.removeWhere((item) => item.id == r.id));
      }
    }
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Filter Roles'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<DepartmentType?>(
                initialValue: _filterDepartment,
                decoration: const InputDecoration(labelText: 'Department'),
                items: [
                  const DropdownMenuItem(value: null, child: Text('All Departments')),
                  ...DepartmentType.values.map((d) => DropdownMenuItem(value: d, child: Text(d.displayName))),
                ],
                onChanged: (v) => setState(() => _filterDepartment = v),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<RoleType?>(
                initialValue: _filterRoleType,
                decoration: const InputDecoration(labelText: 'Role Type'),
                items: [
                  const DropdownMenuItem(value: null, child: Text('All Types')),
                  ...RoleType.values.map((t) => DropdownMenuItem(value: t, child: Text(t.displayName))),
                ],
                onChanged: (v) => setState(() => _filterRoleType = v),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _filterDepartment = null;
                  _filterRoleType = null;
                  _filterStatus = null;
                });
                Navigator.of(ctx).pop();
              },
              child: const Text('Reset'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Apply'),
            ),
          ],
        );
      },
    );
  }

  void _exportData() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Exporting security roles & permissions matrix...')),
    );
  }
}
