import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../app/router/route_names.dart';
import '../models/organization_models.dart';
import '../models/organization_mock_data.dart';
import '../widgets/org_navigation_header.dart';
import '../widgets/org_toolbar.dart';
import '../widgets/org_status_badge.dart';
import '../widgets/org_detail_drawer.dart';
import '../widgets/org_confirmation_dialog.dart';
import '../widgets/org_effective_access_modal.dart';
import '../widgets/org_edit_employee_assignment_dialog.dart';

class OrgEmployeesPage extends StatefulWidget {
  const OrgEmployeesPage({super.key});

  @override
  State<OrgEmployeesPage> createState() => _OrgEmployeesPageState();
}

class _OrgEmployeesPageState extends State<OrgEmployeesPage> {
  final List<OrganizationEmployee> _employees = List.from(OrganizationMockData.employees);
  String _searchQuery = '';
  OrgViewMode _viewMode = OrgViewMode.table;
  String? _filterDepartmentId;
  String? _filterRoleId;
  AccountStatus? _filterStatus;
  String? _filterScopeId;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final width = MediaQuery.of(context).size.width;
    final isCompact = width < 768;

    final filtered = _employees.where((e) {
      final matchesSearch = _searchQuery.isEmpty ||
          e.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          e.employeeId.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          e.workEmail.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          e.jobTitle.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          e.departmentName.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesDept = _filterDepartmentId == null || e.departmentId == _filterDepartmentId;
      final matchesRole = _filterRoleId == null || e.roleId == _filterRoleId;
      final matchesStatus = _filterStatus == null || e.accountStatus == _filterStatus;
      final matchesScope = _filterScopeId == null || e.accessScopeId == _filterScopeId;

      return matchesSearch && matchesDept && matchesRole && matchesStatus && matchesScope;
    }).toList();

    // Summary counts
    final totalStaff = _employees.length;
    final activeStaff = _employees.where((e) => e.accountStatus == AccountStatus.active).length;
    final pendingSuspended = _employees.where((e) => e.accountStatus != AccountStatus.active).length;
    final isolatedScopes = _employees.where((e) => e.accessScopeId.contains('ASSIGNED') || e.accessScopeId.contains('MY-LEADS')).length;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isCompact ? 14 : 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Navigation Header
            OrgNavigationHeader(
              activeTab: OrgNavTab.employees,
              title: 'Employee Directory & Access Management',
              subtitle: 'Organizational reporting hierarchies, team assignments, role allocations & data access scope control',
              trailing: !isCompact
                  ? OutlinedButton.icon(
                      onPressed: () => context.go(RouteNames.hrmsEmployees),
                      icon: const Icon(Icons.badge_outlined, size: 18),
                      label: const Text('Open HRMS Workforce'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    )
                  : null,
            ),
            const SizedBox(height: 18),

            // 2. High-Level Summary Metrics Row
            _buildKpiMetrics(isDark, totalStaff, activeStaff, pendingSuspended, isolatedScopes, width),
            const SizedBox(height: 20),

            // 3. Toolbar
            OrgToolbar(
              searchHint: 'Search directory by name, employee ID, job title, email...',
              searchQuery: _searchQuery,
              onSearchChanged: (v) => setState(() => _searchQuery = v),
              currentViewMode: _viewMode,
              supportedViewModes: const [OrgViewMode.table, OrgViewMode.cards],
              onViewModeChanged: (m) => setState(() => _viewMode = m),
              primaryActionLabel: isCompact ? 'HRMS' : null,
              primaryActionIcon: Icons.badge_outlined,
              onPrimaryAction: () => context.go(RouteNames.hrmsEmployees),
              activeFilterCount: (_filterDepartmentId != null ? 1 : 0) +
                  (_filterRoleId != null ? 1 : 0) +
                  (_filterStatus != null ? 1 : 0) +
                  (_filterScopeId != null ? 1 : 0),
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
  Widget _buildKpiMetrics(bool isDark, int total, int active, int pending, int isolated, double width) {
    final cards = [
      _buildKpiCard(isDark, 'DIRECTORY STAFF', '$total', 'Across 8 departments', Icons.person_outline_rounded, AppColors.primary),
      _buildKpiCard(isDark, 'ACTIVE CRM ACCOUNTS', '$active', 'Full operational access', Icons.verified_user_outlined, const Color(0xFF10B981)),
      _buildKpiCard(isDark, 'PENDING / SUSPENDED', '$pending', 'Requires admin review', Icons.hourglass_empty_rounded, const Color(0xFFD97706)),
      _buildKpiCard(isDark, 'ISOLATED SCOPES', '$isolated Staff', 'My Leads / Assigned only', Icons.lock_person_rounded, const Color(0xFF0284C7)),
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
  Widget _buildTableView(bool isDark, List<OrganizationEmployee> items) {
    final dateFormat = DateFormat('dd MMM, hh:mm a');

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
            columnSpacing: 20,
            columns: const [
              DataColumn(label: Text('EMPLOYEE', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold))),
              DataColumn(label: Text('DEPARTMENT & SQUAD', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold))),
              DataColumn(label: Text('REPORTING MANAGER', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold))),
              DataColumn(label: Text('ASSIGNED ROLE', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold))),
              DataColumn(label: Text('ACCOUNT', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold))),
              DataColumn(label: Text('ACCESS SCOPE', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold))),
              DataColumn(label: Text('LAST LOGIN', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold))),
              DataColumn(label: Text('ACTIONS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold))),
            ],
            rows: items.map((e) {
              return DataRow(
                cells: [
                  DataCell(
                    InkWell(
                      onTap: () => _openEmployeeOrgProfile(e),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 16,
                            backgroundColor: AppColors.primary.withValues(alpha: 0.15),
                            backgroundImage: NetworkImage(e.avatarUrl),
                            onBackgroundImageError: (exception, stackTrace) {},
                            child: Text(
                              e.name.isNotEmpty ? e.name[0] : 'E',
                              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primary),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(e.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.primary)),
                              Text('${e.jobTitle} • ID: ${e.employeeId}', style: TextStyle(fontSize: 11, color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  DataCell(
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(e.departmentName, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                        Text(e.teamName ?? '— Direct Dept —', style: TextStyle(fontSize: 10.5, color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted)),
                      ],
                    ),
                  ),
                  DataCell(Text(e.managerName ?? '— Board / CXO —', style: const TextStyle(fontSize: 12))),
                  DataCell(
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(e.roleTitle, style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: AppColors.primary)),
                    ),
                  ),
                  DataCell(OrgStatusBadge.forAccountStatus(e.accountStatus, isDark)),
                  DataCell(
                    Tooltip(
                      message: e.accessScopeName,
                      child: Text(e.accessScopeName, style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w500)),
                    ),
                  ),
                  DataCell(
                    Text(
                      e.lastLogin != null ? dateFormat.format(e.lastLogin!) : 'Never Logged In',
                      style: TextStyle(
                        fontSize: 11,
                        color: e.lastLogin == null ? AppColors.warning : (isDark ? AppColors.darkSubtext : AppColors.lightTextSecondary),
                        fontStyle: e.lastLogin == null ? FontStyle.italic : FontStyle.normal,
                      ),
                    ),
                  ),
                  DataCell(
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.security_outlined, size: 17),
                          tooltip: 'Evaluate Effective Access',
                          onPressed: () => OrgEffectiveAccessModal.show(context, e),
                          color: const Color(0xFF0284C7),
                        ),
                        IconButton(
                          icon: const Icon(Icons.manage_accounts_outlined, size: 17),
                          tooltip: 'Edit Org Assignment',
                          onPressed: () => _openEditAssignment(e),
                          color: isDark ? AppColors.darkSubtext : AppColors.lightTextSecondary,
                        ),
                        PopupMenuButton<String>(
                          icon: const Icon(Icons.more_vert_rounded, size: 17),
                          onSelected: (action) => _handleEmployeeAction(action, e),
                          itemBuilder: (ctx) => [
                            const PopupMenuItem(value: 'org_profile', child: Text('View Org Profile')),
                            const PopupMenuItem(value: 'hr_profile', child: Text('View Full HR Profile ↗')),
                            const PopupMenuItem(value: 'effective_access', child: Text('Inspect Permissions Matrix')),
                            const PopupMenuItem(value: 'edit_assignment', child: Text('Edit Role & Scope')),
                            const PopupMenuDivider(),
                            PopupMenuItem(
                              value: 'toggle_status',
                              child: Text(
                                e.accountStatus == AccountStatus.active ? 'Suspend Account' : 'Activate Account',
                                style: TextStyle(color: e.accountStatus == AccountStatus.active ? AppColors.error : AppColors.success),
                              ),
                            ),
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
  Widget _buildCardsView(bool isDark, List<OrganizationEmployee> items) {
    return Column(
      children: items.map((e) {
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: AppColors.primary.withValues(alpha: 0.15),
                    backgroundImage: NetworkImage(e.avatarUrl),
                    onBackgroundImageError: (exception, stackTrace) {},
                    child: Text(
                      e.name.isNotEmpty ? e.name[0] : 'E',
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.primary),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(
                                e.name,
                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            OrgStatusBadge.forAccountStatus(e.accountStatus, isDark),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${e.jobTitle} • ID: ${e.employeeId}',
                          style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkSubtext : AppColors.lightTextSecondary),
                        ),
                        Text(
                          '${e.departmentName} (${e.teamName ?? "No Squad"})',
                          style: TextStyle(fontSize: 11, color: AppColors.primary, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('ASSIGNED ROLE', style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.bold, color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted)),
                          Text(e.roleTitle, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('ACCESS SCOPE', style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.bold, color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted)),
                          Text(e.accessScopeName, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                        ],
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
                  TextButton.icon(
                    onPressed: () => OrgEffectiveAccessModal.show(context, e),
                    icon: const Icon(Icons.security_outlined, size: 16),
                    label: const Text('Effective Access', style: TextStyle(fontSize: 12)),
                  ),
                  OutlinedButton(
                    onPressed: () => _openEditAssignment(e),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Edit Org', style: TextStyle(fontSize: 12)),
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
          Icon(Icons.person_search_rounded, size: 48, color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted),
          const SizedBox(height: 12),
          Text(
            'No Directory Employees Found',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
          ),
          const SizedBox(height: 4),
          Text(
            'No staff records match the current search term or filter selection.',
            style: TextStyle(fontSize: 13, color: isDark ? AppColors.darkSubtext : AppColors.lightTextSecondary),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _searchQuery = '';
                _filterDepartmentId = null;
                _filterRoleId = null;
                _filterStatus = null;
                _filterScopeId = null;
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
  void _openEmployeeOrgProfile(OrganizationEmployee e) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    OrgDetailDrawer.show(
      context,
      title: e.name,
      subtitle: '${e.jobTitle} • ID: ${e.employeeId}',
      badge: OrgStatusBadge.forAccountStatus(e.accountStatus, isDark),
      tabTitles: const ['Org Profile', 'Access', 'HR Links', 'Activity'],
      tabViews: [
        // Tab 1: Org Profile
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Official Email', e.workEmail),
            _buildDetailRow('Official Phone', e.workPhone),
            _buildDetailRow('Department', e.departmentName),
            _buildDetailRow('Assigned Squad', e.teamName ?? 'Direct Department Member'),
            _buildDetailRow('Direct Manager', e.managerName ?? 'Board of Directors'),
            _buildDetailRow('Branch Location', e.branch),
            _buildDetailRow('Business Unit', e.businessUnit),
            _buildDetailRow('Employment Mode', e.employmentStatus.displayName),
          ],
        ),

        // Tab 2: Access & Governance
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Assigned Role', e.roleTitle),
            _buildDetailRow('Role Classification', e.roleType.displayName),
            _buildDetailRow('Data Access Scope', e.accessScopeName),
            _buildDetailRow('Account Status', e.accountStatus.displayName),
            _buildDetailRow(
              'Last CRM Session',
              e.lastLogin != null ? DateFormat('dd MMM yyyy, hh:mm a').format(e.lastLogin!) : 'Never Logged In',
            ),
            const SizedBox(height: 14),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).pop();
                OrgEffectiveAccessModal.show(context, e);
              },
              icon: const Icon(Icons.security_outlined, size: 16),
              label: const Text('Inspect Full Effective Permissions'),
            ),
          ],
        ),

        // Tab 3: Dedicated Non-Duplicating HR Links (Section 2 & 10.3)
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Notice: Detailed personal info, statutory payroll, biometric attendance, and performance appraisals are owned strictly by HRMS to avoid duplicate sources of truth.',
                style: TextStyle(fontSize: 12, height: 1.4),
              ),
            ),
            const SizedBox(height: 16),
            _buildHrModuleLink(
              isDark,
              title: 'View HR Profile & Documents',
              subtitle: 'Employment contract, ID KYC documents, bank account & emergency contact',
              icon: Icons.badge_outlined,
              onTap: () {
                Navigator.of(context).pop();
                context.go(RouteNames.hrmsEmployees);
              },
            ),
            _buildHrModuleLink(
              isDark,
              title: 'View Attendance & Geofence Logs',
              subtitle: 'Daily GPS selfie check-ins, site travel kilometers & late penalty hours',
              icon: Icons.fingerprint_rounded,
              onTap: () {
                Navigator.of(context).pop();
                context.go(RouteNames.hrmsAttendance);
              },
            ),
            _buildHrModuleLink(
              isDark,
              title: 'View Performance & Appraisals',
              subtitle: 'Quarterly OKR attainment, CSAT scores & supervisor reviews',
              icon: Icons.auto_graph_rounded,
              onTap: () {
                Navigator.of(context).pop();
                context.go(RouteNames.hrmsPerformance);
              },
            ),
          ],
        ),

        // Tab 4: Activity / Audit Logs
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: OrganizationMockData.auditLogs
              .where((a) => a.entityId == e.id || a.entityName == e.name)
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
                  Text('${log.previousValue} ➔ ${log.newValue}', style: const TextStyle(fontSize: 11, color: AppColors.primary)),
                  const SizedBox(height: 2),
                  Text('Reason: ${log.reason}', style: const TextStyle(fontSize: 11)),
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
            _openEditAssignment(e);
          },
          child: const Text('Edit Org Assignment'),
        ),
      ],
    );
  }

  Widget _buildHrModuleLink(bool isDark, {required String title, required String subtitle, required IconData icon, required VoidCallback onTap}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
        ),
        tileColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
        leading: Icon(icon, color: AppColors.primary),
        title: Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 11)),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
        onTap: onTap,
      ),
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

  void _openEditAssignment(OrganizationEmployee e) {
    OrgEditEmployeeAssignmentDialog.show(
      context,
      employee: e,
      onSave: (updated) {
        setState(() {
          final idx = _employees.indexWhere((item) => item.id == e.id);
          if (idx != -1) _employees[idx] = updated;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Updated organizational assignment for ${updated.name}')),
        );
      },
    );
  }

  Future<void> _handleEmployeeAction(String action, OrganizationEmployee e) async {
    if (action == 'org_profile') {
      _openEmployeeOrgProfile(e);
    } else if (action == 'hr_profile') {
      context.go(RouteNames.hrmsEmployees);
    } else if (action == 'effective_access') {
      OrgEffectiveAccessModal.show(context, e);
    } else if (action == 'edit_assignment') {
      _openEditAssignment(e);
    } else if (action == 'toggle_status') {
      final isCurrentlyActive = e.accountStatus == AccountStatus.active;
      final newStatus = isCurrentlyActive ? AccountStatus.suspended : AccountStatus.active;

      final confirmed = await OrgConfirmationDialog.show(
        context,
        title: isCurrentlyActive ? 'Suspend Account' : 'Activate Account',
        message: 'Are you sure you want to ${isCurrentlyActive ? "suspend" : "activate"} ${e.name}?',
        consequenceWarning: isCurrentlyActive
            ? 'The employee will immediately lose login access and active lead pipelines.'
            : 'The employee will be restored to active login status.',
        confirmLabel: isCurrentlyActive ? 'Suspend Account' : 'Activate Account',
        isDestructive: isCurrentlyActive,
      );

      if (confirmed == true && mounted) {
        setState(() {
          final idx = _employees.indexWhere((item) => item.id == e.id);
          if (idx != -1) _employees[idx] = e.copyWith(accountStatus: newStatus);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Account for ${e.name} is now ${newStatus.displayName}')),
        );
      }
    }
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Filter Employee Directory'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String?>(
                initialValue: _filterDepartmentId,
                decoration: const InputDecoration(labelText: 'Department'),
                items: [
                  const DropdownMenuItem(value: null, child: Text('All Departments')),
                  ...OrganizationMockData.departments.map((d) => DropdownMenuItem(value: d.id, child: Text(d.name))),
                ],
                onChanged: (v) => setState(() => _filterDepartmentId = v),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String?>(
                initialValue: _filterRoleId,
                decoration: const InputDecoration(labelText: 'Assigned Role'),
                items: [
                  const DropdownMenuItem(value: null, child: Text('All Roles')),
                  ...OrganizationMockData.roles.map((r) => DropdownMenuItem(value: r.id, child: Text(r.roleTitle))),
                ],
                onChanged: (v) => setState(() => _filterRoleId = v),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<AccountStatus?>(
                initialValue: _filterStatus,
                decoration: const InputDecoration(labelText: 'Account Status'),
                items: [
                  const DropdownMenuItem(value: null, child: Text('All Statuses')),
                  ...AccountStatus.values.map((s) => DropdownMenuItem(value: s, child: Text(s.displayName))),
                ],
                onChanged: (v) => setState(() => _filterStatus = v),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _filterDepartmentId = null;
                  _filterRoleId = null;
                  _filterStatus = null;
                  _filterScopeId = null;
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
      const SnackBar(content: Text('Exporting employee organization directory...')),
    );
  }
}
