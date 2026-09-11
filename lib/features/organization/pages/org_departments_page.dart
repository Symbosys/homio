import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../models/organization_models.dart';
import '../models/organization_mock_data.dart';
import '../widgets/org_navigation_header.dart';
import '../widgets/org_toolbar.dart';
import '../widgets/org_status_badge.dart';
import '../widgets/org_detail_drawer.dart';
import '../widgets/org_confirmation_dialog.dart';
import '../widgets/org_create_department_dialog.dart';

class OrgDepartmentsPage extends StatefulWidget {
  const OrgDepartmentsPage({super.key});

  @override
  State<OrgDepartmentsPage> createState() => _OrgDepartmentsPageState();
}

class _OrgDepartmentsPageState extends State<OrgDepartmentsPage> {
  final List<OrganizationDepartment> _departments = List.from(OrganizationMockData.departments);
  String _searchQuery = '';
  OrgViewMode _viewMode = OrgViewMode.table;
  DepartmentType? _filterType;
  OrgStatus? _filterStatus;
  final Set<String> _expandedDeptIds = {'DEPT-OPS'};

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final width = MediaQuery.of(context).size.width;
    final isCompact = width < 768;

    final filtered = _departments.where((d) {
      final matchesSearch = _searchQuery.isEmpty ||
          d.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          d.code.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          d.headOfDepartment.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesType = _filterType == null || d.type == _filterType;
      final matchesStatus = _filterStatus == null || d.status == _filterStatus;
      return matchesSearch && matchesType && matchesStatus;
    }).toList();

    // Summary Metrics
    final totalDepts = _departments.length;
    final totalTeams = _departments.fold<int>(0, (sum, d) => sum + d.teamCount);
    final totalHeadcount = _departments.fold<int>(0, (sum, d) => sum + d.employeeCount);
    final totalBudget = _departments.fold<double>(0, (sum, d) => sum + d.monthlyBudgetPool);

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isCompact ? 14 : 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Navigation Header
            OrgNavigationHeader(
              activeTab: OrgNavTab.departments,
              title: 'Department Structures',
              subtitle: 'Organizational divisions, parent-child hierarchies, leadership & operational cost centers',
              trailing: !isCompact
                  ? ElevatedButton.icon(
                      onPressed: _openCreateDepartment,
                      icon: const Icon(Icons.add_rounded, size: 18, color: Colors.white),
                      label: const Text('New Department'),
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
            _buildKpiMetrics(isDark, totalDepts, totalTeams, totalHeadcount, totalBudget, width),
            const SizedBox(height: 20),

            // 3. Toolbar
            OrgToolbar(
              searchHint: 'Search departments by name, code or head...',
              searchQuery: _searchQuery,
              onSearchChanged: (v) => setState(() => _searchQuery = v),
              currentViewMode: _viewMode,
              supportedViewModes: const [OrgViewMode.table, OrgViewMode.tree, OrgViewMode.cards],
              onViewModeChanged: (m) => setState(() => _viewMode = m),
              primaryActionLabel: isCompact ? 'New Dept' : null,
              onPrimaryAction: _openCreateDepartment,
              activeFilterCount: (_filterType != null ? 1 : 0) + (_filterStatus != null ? 1 : 0),
              onFilterPressed: _showFilterDialog,
              onExportPressed: _exportData,
              onRefresh: () => setState(() {}),
            ),
            const SizedBox(height: 16),

            // 4. Data Content: Table / Tree / Cards
            if (filtered.isEmpty)
              _buildEmptyState(isDark)
            else if (_viewMode == OrgViewMode.tree)
              _buildHierarchyTreeView(isDark, filtered)
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
  Widget _buildKpiMetrics(bool isDark, int depts, int teams, int headcount, double budget, double width) {
    final currencyFormat = NumberFormat.compactSimpleCurrency(locale: 'en_IN', decimalDigits: 1);

    final cards = [
      _buildKpiCard(isDark, 'DEPARTMENTS', '$depts', '8 Core Divisions', Icons.account_tree_rounded, AppColors.primary),
      _buildKpiCard(isDark, 'TOTAL SQUADS', '$teams', 'Across 4 branches', Icons.group_work_rounded, const Color(0xFF0284C7)),
      _buildKpiCard(isDark, 'ORGANIZATION HEADCOUNT', '$headcount', 'Active full-time employees', Icons.groups_rounded, const Color(0xFF10B981)),
      _buildKpiCard(isDark, 'MONTHLY BUDGET POOL', currencyFormat.format(budget), 'Direct operational allocation', Icons.account_balance_wallet_rounded, const Color(0xFFD97706)),
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
  // View 1: Detailed Table View
  // ---------------------------------------------------------------------------
  Widget _buildTableView(bool isDark, List<OrganizationDepartment> items) {
    final currencyFormat = NumberFormat.compactSimpleCurrency(locale: 'en_IN', decimalDigits: 1);

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
            columnSpacing: 24,
            columns: const [
              DataColumn(label: Text('DEPARTMENT & CODE', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold))),
              DataColumn(label: Text('PARENT DEPT', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold))),
              DataColumn(label: Text('DEPARTMENT HEAD', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold))),
              DataColumn(label: Text('SQUADS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold))),
              DataColumn(label: Text('HEADCOUNT', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold))),
              DataColumn(label: Text('BUDGET POOL', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold))),
              DataColumn(label: Text('STATUS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold))),
              DataColumn(label: Text('ACTIONS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold))),
            ],
            rows: items.map((d) {
              return DataRow(
                cells: [
                  DataCell(
                    InkWell(
                      onTap: () => _openDepartmentDetail(d),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            d.name,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                          Text(
                            '${d.code} • ${d.locationBranch}',
                            style: TextStyle(fontSize: 11, color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted),
                          ),
                        ],
                      ),
                    ),
                  ),
                  DataCell(
                    Text(
                      d.parentDepartmentName ?? '— Top Level —',
                      style: TextStyle(
                        fontSize: 12,
                        color: d.parentDepartmentName != null ? (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary) : (isDark ? AppColors.darkSubtext : AppColors.lightTextMuted),
                        fontStyle: d.parentDepartmentName == null ? FontStyle.italic : FontStyle.normal,
                      ),
                    ),
                  ),
                  DataCell(
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 13,
                          backgroundColor: AppColors.primary.withValues(alpha: 0.15),
                          child: Text(
                            d.headOfDepartment.isNotEmpty ? d.headOfDepartment[0] : 'H',
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primary),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(d.headOfDepartment, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                            Text(d.headEmail, style: TextStyle(fontSize: 10, color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  DataCell(
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text('${d.teamCount} Teams', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                    ),
                  ),
                  DataCell(Text('${d.employeeCount} Members', style: const TextStyle(fontSize: 12))),
                  DataCell(Text(currencyFormat.format(d.monthlyBudgetPool), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600))),
                  DataCell(OrgStatusBadge.forOrgStatus(d.status, isDark)),
                  DataCell(
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.visibility_outlined, size: 17),
                          tooltip: 'View Overview',
                          onPressed: () => _openDepartmentDetail(d),
                          color: isDark ? AppColors.darkSubtext : AppColors.lightTextSecondary,
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit_outlined, size: 17),
                          tooltip: 'Edit Department',
                          onPressed: () => _openEditDepartment(d),
                          color: isDark ? AppColors.darkSubtext : AppColors.lightTextSecondary,
                        ),
                        PopupMenuButton<String>(
                          icon: const Icon(Icons.more_vert_rounded, size: 17),
                          onSelected: (action) => _handleDepartmentAction(action, d),
                          itemBuilder: (ctx) => [
                            const PopupMenuItem(value: 'add_child', child: Text('Add Child Department')),
                            const PopupMenuItem(value: 'toggle_status', child: Text('Toggle Active/Inactive')),
                            const PopupMenuItem(value: 'delete', child: Text('Archive Department', style: TextStyle(color: AppColors.error))),
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
  // View 2: Visual Hierarchy Tree View
  // ---------------------------------------------------------------------------
  Widget _buildHierarchyTreeView(bool isDark, List<OrganizationDepartment> items) {
    final topLevel = items.where((d) => d.parentDepartmentId == null).toList();

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.account_tree_outlined, size: 18, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                'ORGANIZATIONAL HIERARCHY TREE',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary, letterSpacing: 0.5),
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: () {
                  setState(() {
                    if (_expandedDeptIds.isEmpty) {
                      _expandedDeptIds.addAll(_departments.map((d) => d.id));
                    } else {
                      _expandedDeptIds.clear();
                    }
                  });
                },
                icon: Icon(_expandedDeptIds.isEmpty ? Icons.unfold_more_rounded : Icons.unfold_less_rounded, size: 16),
                label: Text(_expandedDeptIds.isEmpty ? 'Expand All' : 'Collapse All', style: const TextStyle(fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(height: 1),
          const SizedBox(height: 14),

          // Render root nodes
          ...topLevel.map((root) => _buildTreeNode(isDark, root, items, 0)),
        ],
      ),
    );
  }

  Widget _buildTreeNode(bool isDark, OrganizationDepartment dept, List<OrganizationDepartment> all, int depth) {
    final children = all.where((d) => d.parentDepartmentId == dept.id).toList();
    final hasChildren = children.isNotEmpty;
    final isExpanded = _expandedDeptIds.contains(dept.id);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: depth * 28.0, bottom: 8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
            ),
            child: Row(
              children: [
                if (hasChildren)
                  IconButton(
                    icon: Icon(isExpanded ? Icons.remove_circle_outline_rounded : Icons.add_circle_outline_rounded, size: 18),
                    color: AppColors.primary,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 28),
                    onPressed: () {
                      setState(() {
                        if (isExpanded) {
                          _expandedDeptIds.remove(dept.id);
                        } else {
                          _expandedDeptIds.add(dept.id);
                        }
                      });
                    },
                  )
                else
                  const Padding(
                    padding: EdgeInsets.only(left: 6, right: 12),
                    child: Icon(Icons.circle, size: 6, color: AppColors.primary),
                  ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            dept.name,
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 8),
                          OrgStatusBadge.forOrgStatus(dept.status, isDark),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${dept.code} • Head: ${dept.headOfDepartment} • ${dept.teamCount} Teams • ${dept.employeeCount} Employees',
                        style: TextStyle(fontSize: 11, color: isDark ? AppColors.darkSubtext : AppColors.lightTextSecondary),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () => _openDepartmentDetail(dept),
                  child: const Text('Inspect', style: TextStyle(fontSize: 12)),
                ),
              ],
            ),
          ),
        ),
        if (hasChildren && isExpanded)
          ...children.map((child) => _buildTreeNode(isDark, child, all, depth + 1)),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // View 3: Cards View (Responsive & Mobile)
  // ---------------------------------------------------------------------------
  Widget _buildCardsView(bool isDark, List<OrganizationDepartment> items) {
    return Column(
      children: items.map((d) {
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
                      d.name,
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  OrgStatusBadge.forOrgStatus(d.status, isDark),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'Code: ${d.code} • ${d.parentDepartmentName ?? "Root Department"}',
                style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkSubtext : AppColors.lightTextSecondary),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Icon(Icons.person_pin_rounded, size: 16, color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted),
                  const SizedBox(width: 6),
                  Text('Head: ${d.headOfDepartment}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                ],
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: [
                  _buildTag(isDark, '${d.teamCount} Squads', Icons.group_work_outlined),
                  _buildTag(isDark, '${d.employeeCount} Members', Icons.groups_outlined),
                  _buildTag(isDark, d.locationBranch, Icons.location_on_outlined),
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
                    onPressed: () => _openDepartmentDetail(d),
                    child: const Text('View Overview', style: TextStyle(fontSize: 12)),
                  ),
                  OutlinedButton(
                    onPressed: () => _openEditDepartment(d),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Edit', style: TextStyle(fontSize: 12)),
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
          Icon(Icons.search_off_rounded, size: 48, color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted),
          const SizedBox(height: 12),
          Text(
            'No Departments Found',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
          ),
          const SizedBox(height: 4),
          Text(
            'No departmental nodes match the selected search query or filters.',
            style: TextStyle(fontSize: 13, color: isDark ? AppColors.darkSubtext : AppColors.lightTextSecondary),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _searchQuery = '';
                _filterType = null;
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
  void _openCreateDepartment() {
    OrgCreateDepartmentDialog.show(
      context,
      onSave: (newDept) {
        setState(() {
          _departments.insert(0, newDept);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Department "${newDept.name}" created successfully!')),
        );
      },
    );
  }

  void _openEditDepartment(OrganizationDepartment dept) {
    OrgCreateDepartmentDialog.show(
      context,
      departmentToEdit: dept,
      onSave: (updated) {
        setState(() {
          final idx = _departments.indexWhere((d) => d.id == dept.id);
          if (idx != -1) _departments[idx] = updated;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Department "${updated.name}" updated successfully!')),
        );
      },
    );
  }

  void _openDepartmentDetail(OrganizationDepartment d) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final deptTeams = OrganizationMockData.teams.where((t) => t.departmentId == d.id).toList();
    final deptEmployees = OrganizationMockData.employees.where((e) => e.departmentId == d.id).toList();

    OrgDetailDrawer.show(
      context,
      title: d.name,
      subtitle: '${d.code} • ${d.type.displayName}',
      badge: OrgStatusBadge.forOrgStatus(d.status, isDark),
      tabTitles: const ['Overview', 'Squads', 'Staff', 'Access', 'Activity'],
      tabViews: [
        // Tab 1: Overview
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Head of Department', d.headOfDepartment),
            _buildDetailRow('Official Email', d.email),
            _buildDetailRow('Official Phone', d.phone),
            _buildDetailRow('Parent Department', d.parentDepartmentName ?? 'Root Organization Node'),
            _buildDetailRow('Branch / Hub', d.locationBranch),
            _buildDetailRow('Cost Center', d.costCenter),
            _buildDetailRow('Monthly Budget Pool', '₹${d.monthlyBudgetPool.toStringAsFixed(0)}'),
            const SizedBox(height: 16),
            const Text('Core Department Functions:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ...d.coreFunctions.map((f) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle_rounded, size: 14, color: AppColors.primary),
                      const SizedBox(width: 8),
                      Expanded(child: Text(f, style: const TextStyle(fontSize: 12))),
                    ],
                  ),
                )),
          ],
        ),

        // Tab 2: Teams
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: deptTeams.isEmpty
              ? [const Center(child: Text('No operational squads assigned.'))]
              : deptTeams.map((t) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.group_work_outlined, size: 16, color: AppColors.primary),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(t.name, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                              Text('Lead: ${t.teamLead} • ${t.memberCount} Members', style: const TextStyle(fontSize: 11)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
        ),

        // Tab 3: Staff
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: deptEmployees.isEmpty
              ? [const Center(child: Text('No employees assigned.'))]
              : deptEmployees.map((e) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 14,
                          backgroundImage: NetworkImage(e.avatarUrl),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(e.name, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                              Text('${e.jobTitle} • ${e.teamName ?? "Direct"}', style: const TextStyle(fontSize: 11)),
                            ],
                          ),
                        ),
                        OrgStatusBadge.forAccountStatus(e.accountStatus, isDark),
                      ],
                    ),
                  );
                }).toList(),
        ),

        // Tab 4: Access
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Default Access Scope', d.defaultAccessScopeId),
            _buildDetailRow('Allow Squad Creation', d.allowTeamCreation ? 'Enabled' : 'Disabled'),
          ],
        ),

        // Tab 5: Activity
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: OrganizationMockData.auditLogs
              .where((a) => a.entityId == d.id || a.entityType == 'Department Structure')
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(log.action, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primary)),
                      Text('${log.timestamp.day}/${log.timestamp.month}/${log.timestamp.year}', style: const TextStyle(fontSize: 10)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text('By: ${log.changedBy}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500)),
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
            _openEditDepartment(d);
          },
          child: const Text('Edit Department'),
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
          SizedBox(width: 150, child: Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey))),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600))),
        ],
      ),
    );
  }

  Future<void> _handleDepartmentAction(String action, OrganizationDepartment d) async {
    if (action == 'add_child') {
      _openCreateDepartment();
    } else if (action == 'toggle_status') {
      setState(() {
        final idx = _departments.indexWhere((item) => item.id == d.id);
        if (idx != -1) {
          _departments[idx] = d.copyWith(
            status: d.status == OrgStatus.active ? OrgStatus.inactive : OrgStatus.active,
          );
        }
      });
    } else if (action == 'delete') {
      final confirmed = await OrgConfirmationDialog.show(
        context,
        title: 'Archive Department',
        message: 'Are you sure you want to archive "${d.name}"?',
        consequenceWarning: 'This will affect ${d.teamCount} teams and ${d.employeeCount} active employees reporting into this department.',
        confirmLabel: 'Archive Department',
        isDestructive: true,
      );
      if (confirmed == true) {
        setState(() {
          final idx = _departments.indexWhere((item) => item.id == d.id);
          if (idx != -1) {
            _departments[idx] = d.copyWith(status: OrgStatus.archived);
          }
        });
      }
    }
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Filter Departments'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<DepartmentType?>(
                initialValue: _filterType,
                decoration: const InputDecoration(labelText: 'Department Type'),
                items: [
                  const DropdownMenuItem(value: null, child: Text('All Types')),
                  ...DepartmentType.values.map((t) => DropdownMenuItem(value: t, child: Text(t.displayName))),
                ],
                onChanged: (v) => setState(() => _filterType = v),
              ),
              const SizedBox(height: 12),
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
                  _filterType = null;
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
      const SnackBar(content: Text('Exporting departments to CSV/Excel...')),
    );
  }
}
