import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../models/organization_models.dart';
import '../models/organization_mock_data.dart';
import '../widgets/org_navigation_header.dart';
import '../widgets/org_toolbar.dart';
import '../widgets/org_status_badge.dart';
import '../widgets/org_detail_drawer.dart';

class OrgPermissionsPage extends StatefulWidget {
  const OrgPermissionsPage({super.key});

  @override
  State<OrgPermissionsPage> createState() => _OrgPermissionsPageState();
}

class _OrgPermissionsPageState extends State<OrgPermissionsPage> {
  final List<OrganizationPermission> _permissions = List.from(OrganizationMockData.permissions);
  String _searchQuery = '';
  OrgViewMode _viewMode = OrgViewMode.table;
  PermissionModule? _filterModule;
  PermissionAction? _filterAction;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final width = MediaQuery.of(context).size.width;
    final isCompact = width < 768;

    final filtered = _permissions.where((p) {
      final matchesSearch = _searchQuery.isEmpty ||
          p.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          p.code.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          p.feature.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          p.module.displayName.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesModule = _filterModule == null || p.module == _filterModule;
      final matchesAction = _filterAction == null || p.action == _filterAction;

      return matchesSearch && matchesModule && matchesAction;
    }).toList();

    // Summary counts
    final totalPerms = _permissions.length;
    final totalModules = PermissionModule.values.length;
    final totalActions = PermissionAction.values.length;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isCompact ? 14 : 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Navigation Header
            OrgNavigationHeader(
              activeTab: OrgNavTab.permissions,
              title: 'Centralized Permissions Registry',
              subtitle: 'Granular Module → Feature → Action capability definitions, dependencies, and audit controls',
            ),
            const SizedBox(height: 18),

            // 2. High-Level Summary Metrics Row
            _buildKpiMetrics(isDark, totalPerms, totalModules, totalActions, width),
            const SizedBox(height: 20),

            // 3. Toolbar
            OrgToolbar(
              searchHint: 'Search permissions by code, capability, feature or module...',
              searchQuery: _searchQuery,
              onSearchChanged: (v) => setState(() => _searchQuery = v),
              currentViewMode: _viewMode,
              supportedViewModes: const [OrgViewMode.table, OrgViewMode.cards],
              onViewModeChanged: (m) => setState(() => _viewMode = m),
              activeFilterCount: (_filterModule != null ? 1 : 0) + (_filterAction != null ? 1 : 0),
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
  Widget _buildKpiMetrics(bool isDark, int total, int modules, int actions, double width) {
    final cards = [
      _buildKpiCard(isDark, 'TOTAL CAPABILITIES', '$total Granular Actions', 'Module → Feature → Action', Icons.vpn_key_rounded, AppColors.primary),
      _buildKpiCard(isDark, 'ACTIVE MODULES', '$modules Enterprise Domains', 'CRM, Sales, Design, Finance, HR', Icons.grid_view_rounded, const Color(0xFF0284C7)),
      _buildKpiCard(isDark, 'ACTION VERBS', '$actions Standard Operations', 'View, Create, Edit, Delete, Export...', Icons.bolt_rounded, const Color(0xFF10B981)),
      _buildKpiCard(isDark, 'SYSTEM ACL ARCHITECTURE', 'Immutable Registry', 'Protected from unauthenticated alteration', Icons.shield_rounded, const Color(0xFF7C3AED)),
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
  Widget _buildTableView(bool isDark, List<OrganizationPermission> items) {
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
              DataColumn(label: Text('PERMISSION NAME & CODE', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold))),
              DataColumn(label: Text('MODULE', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold))),
              DataColumn(label: Text('FEATURE', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold))),
              DataColumn(label: Text('ACTION', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold))),
              DataColumn(label: Text('DEPENDENCIES', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold))),
              DataColumn(label: Text('ASSIGNED ROLES', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold))),
              DataColumn(label: Text('ACTIONS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold))),
            ],
            rows: items.map((p) {
              final rolesWithPerm = OrganizationMockData.roles.where((r) => r.permissionIds.contains(p.code)).toList();

              return DataRow(
                cells: [
                  DataCell(
                    InkWell(
                      onTap: () => _openPermissionDetail(p, rolesWithPerm),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            p.name,
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.primary),
                          ),
                          Text(
                            p.code,
                            style: TextStyle(fontSize: 11, color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted, fontFamily: 'monospace'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  DataCell(
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(p.module.displayName, style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: AppColors.primary)),
                    ),
                  ),
                  DataCell(Text(p.feature, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500))),
                  DataCell(_buildActionBadge(p.action, isDark)),
                  DataCell(
                    p.requiredDependencies.isEmpty
                        ? Text('None (Atomic)', style: TextStyle(fontSize: 11, fontStyle: FontStyle.italic, color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted))
                        : Wrap(
                            spacing: 4,
                            children: p.requiredDependencies.map((dep) {
                              return Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                                ),
                                child: Text(dep, style: const TextStyle(fontSize: 10, fontFamily: 'monospace')),
                              );
                            }).toList(),
                          ),
                  ),
                  DataCell(
                    Text('${rolesWithPerm.length} Roles', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                  ),
                  DataCell(
                    IconButton(
                      icon: const Icon(Icons.info_outline_rounded, size: 18),
                      tooltip: 'Inspect Permission Details',
                      onPressed: () => _openPermissionDetail(p, rolesWithPerm),
                      color: isDark ? AppColors.darkSubtext : AppColors.lightTextSecondary,
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

  Widget _buildActionBadge(PermissionAction action, bool isDark) {
    Color color;
    switch (action) {
      case PermissionAction.view:
        color = const Color(0xFF0284C7);
        break;
      case PermissionAction.create:
        color = const Color(0xFF10B981);
        break;
      case PermissionAction.edit:
        color = const Color(0xFFD97706);
        break;
      case PermissionAction.delete:
        color = const Color(0xFFEF4444);
        break;
      case PermissionAction.export:
        color = const Color(0xFF7C3AED);
        break;
      case PermissionAction.approve:
        color = const Color(0xFF059669);
        break;
      case PermissionAction.assign:
        color = const Color(0xFF6366F1);
        break;
      case PermissionAction.import:
        color = const Color(0xFF0D9488);
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2.5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        action.displayName.toUpperCase(),
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: color, letterSpacing: 0.4),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Cards View (Mobile & Tablet)
  // ---------------------------------------------------------------------------
  Widget _buildCardsView(bool isDark, List<OrganizationPermission> items) {
    return Column(
      children: items.map((p) {
        final rolesWithPerm = OrganizationMockData.roles.where((r) => r.permissionIds.contains(p.code)).toList();

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
                      p.name,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  _buildActionBadge(p.action, isDark),
                ],
              ),
              const SizedBox(height: 3),
              Text(
                p.code,
                style: TextStyle(fontSize: 11, color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted, fontFamily: 'monospace'),
              ),
              const SizedBox(height: 6),
              Text(
                p.description,
                style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: [
                  _buildTag(isDark, p.module.displayName, Icons.folder_outlined),
                  _buildTag(isDark, p.feature, Icons.extension_outlined),
                  _buildTag(isDark, '${rolesWithPerm.length} Assigned Roles', Icons.badge_outlined),
                ],
              ),
              const SizedBox(height: 10),
              const Divider(height: 1),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: () => _openPermissionDetail(p, rolesWithPerm),
                  icon: const Icon(Icons.info_outline_rounded, size: 16),
                  label: const Text('View Dependencies & Roles', style: TextStyle(fontSize: 12)),
                ),
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
          Text(label, style: TextStyle(fontSize: 11, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)),
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
          Icon(Icons.search_off_rounded, size: 48, color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted),
          const SizedBox(height: 12),
          Text(
            'No Permissions Found',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
          ),
          const SizedBox(height: 4),
          Text(
            'No granular permission codes match the active filters.',
            style: TextStyle(fontSize: 13, color: isDark ? AppColors.darkSubtext : AppColors.lightTextSecondary),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _searchQuery = '';
                _filterModule = null;
                _filterAction = null;
              });
            },
            child: const Text('Clear All Filters'),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Drawer Detail Inspection
  // ---------------------------------------------------------------------------
  void _openPermissionDetail(OrganizationPermission p, List<OrganizationRole> rolesWithPerm) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    OrgDetailDrawer.show(
      context,
      title: p.name,
      subtitle: p.code,
      badge: _buildActionBadge(p.action, isDark),
      tabTitles: const ['Overview', 'Dependencies', 'Assigned Roles', 'Audit'],
      tabViews: [
        // Tab 1: Overview
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Permission Name', p.name),
            _buildDetailRow('Code Token', p.code),
            _buildDetailRow('Module Domain', p.module.displayName),
            _buildDetailRow('Functional Feature', p.feature),
            _buildDetailRow('Operational Action', p.action.displayName),
            _buildDetailRow('Classification', p.isSystem ? 'Core System Policy' : 'Custom Policy'),
            const SizedBox(height: 14),
            const Text('Policy Description:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(p.description, style: const TextStyle(fontSize: 12, height: 1.4)),
          ],
        ),

        // Tab 2: Dependencies
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'PREREQUISITE PERMISSIONS',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 0.5),
            ),
            const SizedBox(height: 8),
            if (p.requiredDependencies.isEmpty)
              const Text('This capability has no prerequisite dependencies. It can be granted atomically.')
            else
              ...p.requiredDependencies.map((dep) {
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
                      const Icon(Icons.link_rounded, size: 16, color: AppColors.primary),
                      const SizedBox(width: 8),
                      Text(dep, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'monospace')),
                      const Spacer(),
                      const Text('Required Prerequisite', style: TextStyle(fontSize: 11, color: Colors.grey)),
                    ],
                  ),
                );
              }),
          ],
        ),

        // Tab 3: Assigned Roles
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ROLES WITH THIS CAPABILITY (${rolesWithPerm.length})',
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 0.5),
            ),
            const SizedBox(height: 10),
            if (rolesWithPerm.isEmpty)
              const Text('No roles currently have this permission assigned.')
            else
              ...rolesWithPerm.map((r) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.admin_panel_settings_outlined, size: 16, color: AppColors.primary),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(r.roleTitle, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                            Text('${r.roleCode} • ${r.departmentType.displayName}', style: const TextStyle(fontSize: 11)),
                          ],
                        ),
                      ),
                      OrgStatusBadge.forRoleType(r.roleType, isDark),
                    ],
                  ),
                );
              }),
          ],
        ),

        // Tab 4: Audit
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('Immutable Core Policy', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            SizedBox(height: 4),
            Text('Registered in standard Homio CRM RBAC master definitions. Not subject to deletion.', style: TextStyle(fontSize: 11, color: Colors.grey)),
          ],
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

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Filter Permissions'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<PermissionModule?>(
                initialValue: _filterModule,
                decoration: const InputDecoration(labelText: 'Module Domain'),
                items: [
                  const DropdownMenuItem(value: null, child: Text('All Modules')),
                  ...PermissionModule.values.map((m) => DropdownMenuItem(value: m, child: Text(m.displayName))),
                ],
                onChanged: (v) => setState(() => _filterModule = v),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<PermissionAction?>(
                initialValue: _filterAction,
                decoration: const InputDecoration(labelText: 'Action Verb'),
                items: [
                  const DropdownMenuItem(value: null, child: Text('All Actions')),
                  ...PermissionAction.values.map((a) => DropdownMenuItem(value: a, child: Text(a.displayName))),
                ],
                onChanged: (v) => setState(() => _filterAction = v),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _filterModule = null;
                  _filterAction = null;
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
      const SnackBar(content: Text('Exporting complete permissions registry...')),
    );
  }
}
