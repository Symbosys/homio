import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../models/organization_models.dart';
import '../models/organization_mock_data.dart';
import '../widgets/org_navigation_header.dart';
import '../widgets/org_toolbar.dart';
import '../widgets/org_status_badge.dart';
import '../widgets/org_detail_drawer.dart';
import '../widgets/org_confirmation_dialog.dart';
import '../widgets/org_create_access_scope_dialog.dart';

class OrgAccessScopePage extends StatefulWidget {
  const OrgAccessScopePage({super.key});

  @override
  State<OrgAccessScopePage> createState() => _OrgAccessScopePageState();
}

class _OrgAccessScopePageState extends State<OrgAccessScopePage> {
  final List<OrganizationAccessScope> _scopes = List.from(OrganizationMockData.accessScopes);
  String _searchQuery = '';
  OrgViewMode _viewMode = OrgViewMode.table;
  AccessScopeLevel? _filterLevel;
  OrgStatus? _filterStatus;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final width = MediaQuery.of(context).size.width;
    final isCompact = width < 768;

    final filtered = _scopes.where((s) {
      final matchesSearch = _searchQuery.isEmpty ||
          s.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          s.code.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          s.description.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          s.scopeLevel.displayName.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesLevel = _filterLevel == null || s.scopeLevel == _filterLevel;
      final matchesStatus = _filterStatus == null || s.status == _filterStatus;

      return matchesSearch && matchesLevel && matchesStatus;
    }).toList();

    // Summary KPI metrics
    final totalScopes = _scopes.length;
    final totalUsersCovered = _scopes.fold<int>(0, (sum, s) => sum + s.userCount);
    final isolatedScopes = _scopes.where((s) => s.scopeLevel == AccessScopeLevel.ownRecords || s.scopeLevel == AccessScopeLevel.assignedRecords).length;
    final orgGlobalScopes = _scopes.where((s) => s.scopeLevel == AccessScopeLevel.organization).length;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isCompact ? 14 : 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Navigation Header
            OrgNavigationHeader(
              activeTab: OrgNavTab.accessScope,
              title: 'Data Access Scope & Isolation Boundaries',
              subtitle: 'Defines which records, branches, squads, and customer pipelines each role is permitted to see and operate on',
              trailing: !isCompact
                  ? ElevatedButton.icon(
                      onPressed: _openCreateScope,
                      icon: const Icon(Icons.add_rounded, size: 18, color: Colors.white),
                      label: const Text('New Scope'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    )
                  : null,
            ),
            const SizedBox(height: 16),

            // Conceptual Principle Banner (Section 13 & 15)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF0C4A6E).withValues(alpha: 0.25) : const Color(0xFFE0F2FE),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFF38BDF8).withValues(alpha: 0.4)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.lightbulb_outline_rounded, color: Color(0xFF0284C7), size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 12.5,
                          color: isDark ? AppColors.darkTextPrimary : const Color(0xFF0F172A),
                          height: 1.4,
                        ),
                        children: const [
                          TextSpan(text: 'Core Distinction: ', style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(text: 'A '),
                          TextSpan(text: 'Permission', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0284C7))),
                          TextSpan(text: ' answers: "What can the user do?" whereas an '),
                          TextSpan(text: 'Access Scope', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0284C7))),
                          TextSpan(text: ' answers: "Which data can the user do it to?"'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 2. High-Level Summary Metrics Row
            _buildKpiMetrics(isDark, totalScopes, orgGlobalScopes, isolatedScopes, totalUsersCovered, width),
            const SizedBox(height: 20),

            // 3. Toolbar
            OrgToolbar(
              searchHint: 'Search scopes by title, code or boundary rules...',
              searchQuery: _searchQuery,
              onSearchChanged: (v) => setState(() => _searchQuery = v),
              currentViewMode: _viewMode,
              supportedViewModes: const [OrgViewMode.table, OrgViewMode.cards],
              onViewModeChanged: (m) => setState(() => _viewMode = m),
              primaryActionLabel: isCompact ? 'New Scope' : null,
              onPrimaryAction: _openCreateScope,
              activeFilterCount: (_filterLevel != null ? 1 : 0) + (_filterStatus != null ? 1 : 0),
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
  Widget _buildKpiMetrics(bool isDark, int total, int global, int isolated, int users, double width) {
    final cards = [
      _buildKpiCard(isDark, 'TOTAL DATA BOUNDARIES', '$total Scopes', 'Configured security levels', Icons.security_rounded, AppColors.primary),
      _buildKpiCard(isDark, 'GLOBAL SCOPES', '$global Organization', 'Executive & super admin', Icons.public_rounded, const Color(0xFF7C3AED)),
      _buildKpiCard(isDark, 'FIELD ISOLATED', '$isolated Scopes', 'Assigned & own leads only', Icons.lock_person_rounded, const Color(0xFFD97706)),
      _buildKpiCard(isDark, 'GOVERNED STAFF', '$users Users', 'Across all active scopes', Icons.people_outline_rounded, const Color(0xFF10B981)),
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
  Widget _buildTableView(bool isDark, List<OrganizationAccessScope> items) {
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
              DataColumn(label: Text('SCOPE NAME & CODE', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold))),
              DataColumn(label: Text('VISIBILITY LEVEL', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold))),
              DataColumn(label: Text('BOUNDARY DESCRIPTION', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold))),
              DataColumn(label: Text('APPLICABLE MODULES', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold))),
              DataColumn(label: Text('GOVERNED USERS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold))),
              DataColumn(label: Text('STATUS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold))),
              DataColumn(label: Text('ACTIONS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold))),
            ],
            rows: items.map((s) {
              return DataRow(
                cells: [
                  DataCell(
                    InkWell(
                      onTap: () => _openScopeDetail(s),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            s.name,
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.primary),
                          ),
                          Text(
                            s.code,
                            style: TextStyle(fontSize: 11, color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted, fontFamily: 'monospace'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  DataCell(OrgStatusBadge.forScope(s.scopeLevel, isDark)),
                  DataCell(
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 240),
                      child: Text(
                        s.description,
                        style: const TextStyle(fontSize: 12),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  DataCell(
                    Text(
                      s.applicableModules.length == PermissionModule.values.length
                          ? 'All Modules'
                          : '${s.applicableModules.length} Modules',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  ),
                  DataCell(
                    Text('${s.userCount} Users', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                  ),
                  DataCell(OrgStatusBadge.forOrgStatus(s.status, isDark)),
                  DataCell(
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.visibility_outlined, size: 17),
                          tooltip: 'Inspect Scope Details',
                          onPressed: () => _openScopeDetail(s),
                          color: isDark ? AppColors.darkSubtext : AppColors.lightTextSecondary,
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit_outlined, size: 17),
                          tooltip: 'Edit Boundary Rules',
                          onPressed: () => _openEditScope(s),
                          color: isDark ? AppColors.darkSubtext : AppColors.lightTextSecondary,
                        ),
                        PopupMenuButton<String>(
                          icon: const Icon(Icons.more_vert_rounded, size: 17),
                          onSelected: (action) => _handleScopeAction(action, s),
                          itemBuilder: (ctx) => [
                            const PopupMenuItem(value: 'duplicate', child: Text('Duplicate Scope')),
                            const PopupMenuItem(value: 'toggle_status', child: Text('Toggle Status')),
                            const PopupMenuItem(value: 'delete', child: Text('Delete Scope', style: TextStyle(color: AppColors.error))),
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
  Widget _buildCardsView(bool isDark, List<OrganizationAccessScope> items) {
    return Column(
      children: items.map((s) {
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
                      s.name,
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  OrgStatusBadge.forScope(s.scopeLevel, isDark),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                s.code,
                style: TextStyle(fontSize: 11, color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted, fontFamily: 'monospace'),
              ),
              const SizedBox(height: 8),
              Text(
                s.description,
                style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary, height: 1.35),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.filter_alt_outlined, size: 14, color: AppColors.primary),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        s.recordOwnershipRule,
                        style: TextStyle(fontSize: 11, fontFamily: 'monospace', color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
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
                    onPressed: () => _openScopeDetail(s),
                    child: const Text('Inspect Details', style: TextStyle(fontSize: 12)),
                  ),
                  OutlinedButton(
                    onPressed: () => _openEditScope(s),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Edit Rules', style: TextStyle(fontSize: 12)),
                  ),
                ],
              ),
            ],
          ),
        );
      }).toList(),
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
          Icon(Icons.shield_outlined, size: 48, color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted),
          const SizedBox(height: 12),
          Text(
            'No Access Scopes Found',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
          ),
          const SizedBox(height: 4),
          Text(
            'No data boundaries match the current filter selection.',
            style: TextStyle(fontSize: 13, color: isDark ? AppColors.darkSubtext : AppColors.lightTextSecondary),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _searchQuery = '';
                _filterLevel = null;
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
  void _openCreateScope() {
    OrgCreateAccessScopeDialog.show(
      context,
      onSave: (newScope) {
        setState(() {
          _scopes.insert(0, newScope);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Access Scope "${newScope.name}" created successfully!')),
        );
      },
    );
  }

  void _openEditScope(OrganizationAccessScope scope) {
    OrgCreateAccessScopeDialog.show(
      context,
      scopeToEdit: scope,
      onSave: (updated) {
        setState(() {
          final idx = _scopes.indexWhere((s) => s.id == scope.id);
          if (idx != -1) _scopes[idx] = updated;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Access Scope "${updated.name}" updated successfully!')),
        );
      },
    );
  }

  void _openScopeDetail(OrganizationAccessScope s) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final assignedRoles = OrganizationMockData.roles.where((r) => r.defaultAccessScopeId == s.id).toList();

    OrgDetailDrawer.show(
      context,
      title: s.name,
      subtitle: '${s.code} • ${s.scopeLevel.displayName}',
      badge: OrgStatusBadge.forScope(s.scopeLevel, isDark),
      tabTitles: const ['Boundary Rules', 'Modules', 'Governed Roles', 'Activity'],
      tabViews: [
        // Tab 1: Boundary Rules
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Visibility Level', s.scopeLevel.displayName),
            _buildDetailRow('Level Description', s.scopeLevel.description),
            _buildDetailRow('Governed Users', '${s.userCount} Employees'),
            const SizedBox(height: 14),
            const Text('Technical Record Ownership Filter:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
              ),
              child: Text(
                s.recordOwnershipRule,
                style: const TextStyle(fontSize: 12, fontFamily: 'monospace'),
              ),
            ),
            if (s.branches.isNotEmpty) ...[
              const SizedBox(height: 14),
              const Text('Permitted Branches:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Wrap(
                spacing: 6,
                children: s.branches.map((b) => Chip(label: Text(b, style: const TextStyle(fontSize: 11)))).toList(),
              ),
            ],
          ],
        ),

        // Tab 2: Modules
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'APPLICABLE CRM MODULES (${s.applicableModules.length})',
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 0.5),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: s.applicableModules.map((m) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.check_rounded, size: 14, color: AppColors.success),
                      const SizedBox(width: 6),
                      Text(m.displayName, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),

        // Tab 3: Governed Roles
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ROLES BOUND BY THIS SCOPE (${assignedRoles.length})',
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 0.5),
            ),
            const SizedBox(height: 10),
            if (assignedRoles.isEmpty)
              const Text('No roles currently use this as default scope.')
            else
              ...assignedRoles.map((r) {
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
                            Text('${r.userCount} Users assigned • ${r.departmentType.displayName}', style: const TextStyle(fontSize: 11)),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),
          ],
        ),

        // Tab 4: Activity
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: OrganizationMockData.auditLogs
              .where((a) => a.entityId == s.id || a.entityType.contains('Scope'))
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
            _openEditScope(s);
          },
          child: const Text('Edit Scope Rules'),
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

  Future<void> _handleScopeAction(String action, OrganizationAccessScope s) async {
    if (action == 'duplicate') {
      final duplicate = s.copyWith(
        id: 'SCOPE-${DateTime.now().millisecondsSinceEpoch}',
        code: '${s.code}_COPY',
        name: '${s.name} (Copy)',
        userCount: 0,
      );
      setState(() => _scopes.insert(0, duplicate));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Duplicated "${s.name}" to new access scope!')),
      );
    } else if (action == 'toggle_status') {
      setState(() {
        final idx = _scopes.indexWhere((item) => item.id == s.id);
        if (idx != -1) {
          _scopes[idx] = s.copyWith(
            status: s.status == OrgStatus.active ? OrgStatus.inactive : OrgStatus.active,
          );
        }
      });
    } else if (action == 'delete') {
      if (s.scopeLevel == AccessScopeLevel.organization) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Global Organization Scope cannot be deleted.')),
        );
        return;
      }
      final confirmed = await OrgConfirmationDialog.show(
        context,
        title: 'Delete Access Scope',
        message: 'Are you sure you want to delete "${s.name}"?',
        consequenceWarning: 'This will affect ${s.userCount} users currently bound by this data boundary.',
        confirmLabel: 'Delete Scope',
        isDestructive: true,
      );
      if (confirmed == true) {
        setState(() => _scopes.removeWhere((item) => item.id == s.id));
      }
    }
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Filter Access Scopes'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<AccessScopeLevel?>(
                initialValue: _filterLevel,
                decoration: const InputDecoration(labelText: 'Visibility Level'),
                items: [
                  const DropdownMenuItem(value: null, child: Text('All Levels')),
                  ...AccessScopeLevel.values.map((l) => DropdownMenuItem(value: l, child: Text(l.displayName))),
                ],
                onChanged: (v) => setState(() => _filterLevel = v),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<OrgStatus?>(
                initialValue: _filterStatus,
                decoration: const InputDecoration(labelText: 'Status'),
                items: [
                  const DropdownMenuItem(value: null, child: Text('All Statuses')),
                  ...OrgStatus.values.map((s) => DropdownMenuItem(value: s, child: Text(s.displayName))),
                ],
                onChanged: (v) => setState(() => _filterStatus = v),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _filterLevel = null;
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
      const SnackBar(content: Text('Exporting access scopes definition register...')),
    );
  }
}
