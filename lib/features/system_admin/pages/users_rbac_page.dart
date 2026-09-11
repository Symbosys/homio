import 'package:flutter/material.dart';
import '../../../core/responsive/breakpoints.dart';
import '../../../core/theme/app_colors.dart';
import '../models/admin_models.dart';
import '../models/admin_mock_data.dart';
import '../widgets/admin_shared_widgets.dart';

class UsersRbacPage extends StatefulWidget {
  const UsersRbacPage({super.key});

  @override
  State<UsersRbacPage> createState() => _UsersRbacPageState();
}

class _UsersRbacPageState extends State<UsersRbacPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // State
  List<AdminUser> _users = [];
  List<AdminRole> _roles = [];
  List<AdminDepartment> _departments = [];
  List<AdminTeam> _teams = [];

  // Directory Filters & Search
  String _searchQuery = '';
  String? _selectedDepartmentFilter;
  String? _selectedRoleFilter;
  UserAccountStatus? _selectedStatusFilter;
  DataScopeType? _selectedScopeFilter;
  final Set<String> _selectedUserIds = {};

  // Active Drawers & Modals
  AdminUser? _selectedUserDetail;
  bool _isAddUserModalOpen = false;
  AdminRole? _selectedRoleForMatrix;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _users = List.from(AdminMockData.users);
    _roles = List.from(AdminMockData.roles);
    _departments = List.from(AdminMockData.departments);
    _teams = List.from(AdminMockData.teams);
    if (_roles.isNotEmpty) {
      _selectedRoleForMatrix = _roles.first;
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<AdminUser> get _filteredUsers {
    return _users.where((user) {
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final match = user.fullName.toLowerCase().contains(q) ||
            user.employeeId.toLowerCase().contains(q) ||
            user.email.toLowerCase().contains(q) ||
            user.jobTitle.toLowerCase().contains(q) ||
            user.primaryMobile.contains(q);
        if (!match) return false;
      }
      if (_selectedDepartmentFilter != null && user.departmentName != _selectedDepartmentFilter) {
        return false;
      }
      if (_selectedRoleFilter != null && user.roleName != _selectedRoleFilter) {
        return false;
      }
      if (_selectedStatusFilter != null && user.accountStatus != _selectedStatusFilter) {
        return false;
      }
      if (_selectedScopeFilter != null && user.accessScope != _selectedScopeFilter) {
        return false;
      }
      return true;
    }).toList();
  }

  Map<String, String> get _activeFiltersMap {
    final map = <String, String>{};
    if (_selectedDepartmentFilter != null) map['Department'] = _selectedDepartmentFilter!;
    if (_selectedRoleFilter != null) map['Role'] = _selectedRoleFilter!;
    if (_selectedStatusFilter != null) map['Status'] = _selectedStatusFilter!.label;
    if (_selectedScopeFilter != null) map['Scope'] = _selectedScopeFilter!.label;
    return map;
  }

  void _removeFilter(String key) {
    setState(() {
      if (key == 'Department') _selectedDepartmentFilter = null;
      if (key == 'Role') _selectedRoleFilter = null;
      if (key == 'Status') _selectedStatusFilter = null;
      if (key == 'Scope') _selectedScopeFilter = null;
    });
  }

  void _clearAllFilters() {
    setState(() {
      _searchQuery = '';
      _selectedDepartmentFilter = null;
      _selectedRoleFilter = null;
      _selectedStatusFilter = null;
      _selectedScopeFilter = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isMobile = Breakpoints.isMobile(context);

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Admin Page Header
                AdminHeader(
                  title: 'Users & RBAC',
                  description: 'Manage internal organizational hierarchy, users, access scopes, and granular module permissions.',
                  icon: Icons.manage_accounts_rounded,
                  breadcrumbs: const ['Homio Administration', 'Platform Configuration', 'Users & RBAC'],
                  actions: [
                    OutlinedButton.icon(
                      onPressed: () => _exportUserData(),
                      icon: const Icon(Icons.file_download_outlined, size: 16),
                      label: const Text('Export Directory', style: TextStyle(fontSize: 13)),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => setState(() => _isAddUserModalOpen = true),
                      icon: const Icon(Icons.person_add_alt_1_rounded, size: 16),
                      label: const Text('Add User', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ],
                ),

                // 2. Organization Summary Metrics
                AdminSummaryCards(
                  metrics: [
                    AdminMetricItem(
                      label: 'Total Users',
                      value: '${_users.length}',
                      subtitle: '6 Operating Hubs',
                      icon: Icons.people_alt_rounded,
                      color: AppColors.primary,
                    ),
                    AdminMetricItem(
                      label: 'Active Today',
                      value: '${_users.where((u) => u.accountStatus == UserAccountStatus.active).length}',
                      subtitle: '91% Attendance Rate',
                      icon: Icons.check_circle_outline_rounded,
                      color: AppColors.success,
                      trendText: '+5%',
                      isPositiveTrend: true,
                    ),
                    AdminMetricItem(
                      label: 'Pending Invites',
                      value: '${_users.where((u) => u.accountStatus == UserAccountStatus.pendingInvite).length}',
                      subtitle: 'Awaiting onboarding',
                      icon: Icons.mark_email_unread_outlined,
                      color: AppColors.warning,
                    ),
                    AdminMetricItem(
                      label: 'Configured Roles',
                      value: '${_roles.length}',
                      subtitle: '19 Module Matrices',
                      icon: Icons.admin_panel_settings_outlined,
                      color: AppColors.secondary,
                    ),
                  ],
                ),

                // 3. Navigation Tabs
                Container(
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                    border: Border(
                      bottom: BorderSide(
                        color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                      ),
                    ),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    onTap: (index) => setState(() {}),
                    isScrollable: true,
                    labelColor: AppColors.primary,
                    unselectedLabelColor: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                    indicatorColor: AppColors.primary,
                    indicatorWeight: 2.5,
                    labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                    tabs: const [
                      Tab(icon: Icon(Icons.people_alt_outlined, size: 18), text: 'Users Directory'),
                      Tab(icon: Icon(Icons.security_outlined, size: 18), text: 'Roles Management'),
                      Tab(icon: Icon(Icons.grid_view_rounded, size: 18), text: '19-Module Permission Matrix'),
                      Tab(icon: Icon(Icons.corporate_fare_outlined, size: 18), text: 'Departments & Teams'),
                      Tab(icon: Icon(Icons.lock_person_outlined, size: 18), text: 'Access Scopes'),
                    ],
                  ),
                ),

                // 4. Tab Views
                if (_tabController.index == 0)
                  _buildUsersDirectoryTab(isDark, isMobile),
                if (_tabController.index == 1)
                  _buildRolesManagementTab(isDark, isMobile),
                if (_tabController.index == 2)
                  _buildPermissionMatrixTab(isDark, isMobile),
                if (_tabController.index == 3)
                  _buildDepartmentsTeamsTab(isDark, isMobile),
                if (_tabController.index == 4)
                  _buildAccessScopesTab(isDark, isMobile),
              ],
            ),
          ),

          // User Detail Drawer (Side-over)
          if (_selectedUserDetail != null)
            Positioned(
              top: 0,
              bottom: 0,
              right: 0,
              child: _buildUserDetailDrawer(isDark),
            ),

          // Add User Multi-Section Modal
          if (_isAddUserModalOpen)
            _buildAddUserModal(isDark),
        ],
      ),
    );
  }

  // ==========================================================================
  // TAB 1: USERS DIRECTORY
  // ==========================================================================
  Widget _buildUsersDirectoryTab(bool isDark, bool isMobile) {
    final filtered = _filteredUsers;

    return Column(
      children: [
        // Filter & Search Toolbar
        AdminFilterBar(
          searchQuery: _searchQuery,
          onSearchChanged: (q) => setState(() => _searchQuery = q),
          searchHint: 'Search users by name, employee ID, mobile, job title...',
          activeFilters: _activeFiltersMap,
          onRemoveFilter: _removeFilter,
          onClearAll: _clearAllFilters,
          filterControls: [
            // Department Filter Dropdown
            DropdownButton<String?>(
              value: _selectedDepartmentFilter,
              hint: const Text('Department', style: TextStyle(fontSize: 12)),
              underline: const SizedBox(),
              items: [
                const DropdownMenuItem(value: null, child: Text('All Departments', style: TextStyle(fontSize: 12))),
                for (final d in _departments)
                  DropdownMenuItem(value: d.name, child: Text(d.name, style: const TextStyle(fontSize: 12))),
              ],
              onChanged: (val) => setState(() => _selectedDepartmentFilter = val),
            ),
            // Status Filter Dropdown
            DropdownButton<UserAccountStatus?>(
              value: _selectedStatusFilter,
              hint: const Text('Status', style: TextStyle(fontSize: 12)),
              underline: const SizedBox(),
              items: [
                const DropdownMenuItem(value: null, child: Text('All Statuses', style: TextStyle(fontSize: 12))),
                for (final s in UserAccountStatus.values)
                  DropdownMenuItem(value: s, child: Text(s.label, style: const TextStyle(fontSize: 12))),
              ],
              onChanged: (val) => setState(() => _selectedStatusFilter = val),
            ),
          ],
          trailingAction: _selectedUserIds.isNotEmpty
              ? Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.primary),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${_selectedUserIds.length} Selected',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primary),
                      ),
                      const SizedBox(width: 8),
                      TextButton(
                        onPressed: () => _showBulkActionsDialog(context),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text('Bulk Actions', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primary)),
                      ),
                    ],
                  ),
                )
              : null,
        ),

        // Data Table or List
        filtered.isEmpty
            ? _buildEmptyState(isDark)
            : isMobile
                ? _buildMobileUserCards(filtered, isDark)
                : _buildDesktopUserTable(filtered, isDark),
      ],
    );
  }

  Widget _buildDesktopUserTable(List<AdminUser> list, bool isDark) {
    return Container(
      margin: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            headingRowColor: WidgetStateProperty.all(
                isDark ? AppColors.darkBackground : AppColors.lightSurfaceSubtle,
              ),
              dataRowMinHeight: 48,
              dataRowMaxHeight: 56,
              columns: const [
                DataColumn(label: Text('Employee Identity', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12))),
                DataColumn(label: Text('Emp ID', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12))),
                DataColumn(label: Text('Department & Team', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12))),
                DataColumn(label: Text('Role & Scope', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12))),
                DataColumn(label: Text('Reporting Line', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12))),
                DataColumn(label: Text('Account Status', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12))),
                DataColumn(label: Text('Last Active', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12))),
                DataColumn(label: Text('Actions', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12))),
              ],
              rows: list.map((user) {
                final isSelected = _selectedUserIds.contains(user.id);
                return DataRow(
                  selected: isSelected,
                  onSelectChanged: (selected) {
                    setState(() {
                      if (selected == true) {
                        _selectedUserIds.add(user.id);
                      } else {
                        _selectedUserIds.remove(user.id);
                      }
                    });
                  },
                  cells: [
                    // User Identity
                    DataCell(
                      InkWell(
                        onTap: () => setState(() => _selectedUserDetail = user),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 17,
                              backgroundColor: AppColors.primary.withValues(alpha: 0.15),
                              backgroundImage: user.avatarUrl != null ? NetworkImage(user.avatarUrl!) : null,
                              child: user.avatarUrl == null
                                  ? Text(
                                      user.firstName.substring(0, 1),
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.primary),
                                    )
                                  : null,
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  user.fullName,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                                  ),
                                ),
                                Text(
                                  user.email,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Emp ID
                    DataCell(
                      Text(
                        user.employeeId,
                        style: const TextStyle(fontSize: 12, fontFamily: 'monospace', fontWeight: FontWeight.w600),
                      ),
                    ),
                    // Department & Team
                    DataCell(
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(user.departmentName, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                          Text(user.teamName, style: TextStyle(fontSize: 11, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
                        ],
                      ),
                    ),
                    // Role & Scope
                    DataCell(
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(user.roleName, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primary)),
                          Text(user.accessScope.label, style: TextStyle(fontSize: 11, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
                        ],
                      ),
                    ),
                    // Reporting Line
                    DataCell(
                      Text(
                        user.reportingManagerName ?? '— (Direct to Board)',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                    // Account Status
                    DataCell(
                      AdminStatusBadge(
                        label: user.accountStatus.label,
                        color: user.accountStatus.color,
                      ),
                    ),
                    // Last Active
                    DataCell(
                      Text(
                        user.lastLogin != null
                            ? '${user.lastLogin!.day}/${user.lastLogin!.month}/${user.lastLogin!.year} ${user.lastLogin!.hour}:${user.lastLogin!.minute.toString().padLeft(2, '0')}'
                            : 'Never',
                        style: TextStyle(fontSize: 11, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                      ),
                    ),
                    // Actions
                    DataCell(
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.visibility_outlined, size: 18),
                            tooltip: 'View Profile & Audit Dossier',
                            onPressed: () => setState(() => _selectedUserDetail = user),
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit_outlined, size: 18),
                            tooltip: 'Edit User & Permissions',
                            onPressed: () => _editUser(user),
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

  Widget _buildMobileUserCards(List<AdminUser> list, bool isDark) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final user = list[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
          ),
          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: AppColors.primary.withValues(alpha: 0.15),
                      child: Text(user.firstName.substring(0, 1), style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(user.fullName, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                          Text('${user.employeeId} • ${user.roleName}', style: const TextStyle(fontSize: 12, color: AppColors.primary)),
                        ],
                      ),
                    ),
                    AdminStatusBadge(label: user.accountStatus.label, color: user.accountStatus.color),
                  ],
                ),
                const Divider(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Dept: ${user.departmentName}', style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
                    Text('Scope: ${user.accessScope.label}', style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                      onPressed: () => setState(() => _selectedUserDetail = user),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text('View Dossier', style: TextStyle(fontSize: 12)),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () => _editUser(user),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text('Edit Access', style: TextStyle(fontSize: 12)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ==========================================================================
  // TAB 2: ROLES MANAGEMENT
  // ==========================================================================
  Widget _buildRolesManagementTab(bool isDark, bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('System Roles Directory', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)),
                  Text('Standard organizational roles and their baseline capability profiles.', style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () => _createNewRoleModal(context),
                icon: const Icon(Icons.add_moderator_rounded, size: 16),
                label: const Text('Create Role', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _roles.length,
              itemBuilder: (context, index) {
                final role = _roles[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                  ),
                  color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.admin_panel_settings_rounded, color: AppColors.primary, size: 20),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(role.roleName, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: isDark ? AppColors.darkBackground : AppColors.lightSurfaceSubtle,
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Text(role.roleCode, style: const TextStyle(fontSize: 10, fontFamily: 'monospace')),
                                      ),
                                    ],
                                  ),
                                  Text('${role.departmentName} • ${role.approvalAuthority}', style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.success.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text('${role.usersAssignedCount} Users Active', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.success)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(role.description, style: TextStyle(fontSize: 12.5, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
                        const SizedBox(height: 14),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Default Scope: ${role.defaultScope.label}',
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primary),
                            ),
                            Row(
                              children: [
                                OutlinedButton.icon(
                                  onPressed: () {
                                    setState(() {
                                      _selectedRoleForMatrix = role;
                                      _tabController.animateTo(2); // Jump to Matrix tab
                                    });
                                  },
                                  icon: const Icon(Icons.tune_rounded, size: 14),
                                  label: const Text('Configure Matrix', style: TextStyle(fontSize: 12)),
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  // ==========================================================================
  // TAB 3: 19-MODULE PERMISSION MATRIX
  // ==========================================================================
  Widget _buildPermissionMatrixTab(bool isDark, bool isMobile) {
    final activeRole = _selectedRoleForMatrix ?? _roles.first;

    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Role selector bar
          Row(
            children: [
              Text('Viewing Capabilities For:', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
              const SizedBox(width: 12),
              DropdownButton<AdminRole>(
                value: activeRole,
                items: [
                  for (final r in _roles)
                    DropdownMenuItem(value: r, child: Text(r.roleName, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13))),
                ],
                onChanged: (newRole) {
                  if (newRole != null) {
                    setState(() => _selectedRoleForMatrix = newRole);
                  }
                },
              ),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Capabilities for ${activeRole.roleName} saved to active cluster successfully.'),
                      backgroundColor: AppColors.success,
                    ),
                  );
                },
                icon: const Icon(Icons.save_outlined, size: 16),
                label: const Text('Save Permission Set', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Matrix Table
          Container(
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: activeRole.permissions.length,
                separatorBuilder: (context, index) => Divider(height: 1, color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                itemBuilder: (context, index) {
                  final perm = activeRole.permissions[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(perm.moduleName, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                            const SizedBox(width: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(perm.dataScope.label, style: const TextStyle(fontSize: 10, color: AppColors.primary, fontWeight: FontWeight.bold)),
                            ),
                            const Spacer(),
                            if (perm.phoneMasked)
                              const Padding(
                                padding: EdgeInsets.only(right: 8),
                                child: Tooltip(
                                  message: 'Customer Phone Masking Enforced',
                                  child: Icon(Icons.phone_locked_rounded, size: 16, color: AppColors.warning),
                                ),
                              ),
                            if (perm.marginMasked)
                              const Tooltip(
                                message: 'Commercial Margins Hidden',
                                child: Icon(Icons.visibility_off_outlined, size: 16, color: AppColors.error),
                              ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 6,
                          children: GranularAction.values.map((act) {
                            final allowed = perm.can(act);
                            return FilterChip(
                              label: Text(act.label, style: TextStyle(fontSize: 11, color: allowed ? Colors.white : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary))),
                              selected: allowed,
                              selectedColor: AppColors.primary,
                              backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightSurfaceSubtle,
                              visualDensity: VisualDensity.compact,
                              onSelected: (val) {
                                setState(() {
                                  perm.actions[act] = val;
                                });
                              },
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================================
  // TAB 4: DEPARTMENTS & TEAMS
  // ==========================================================================
  Widget _buildDepartmentsTeamsTab(bool isDark, bool isMobile) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Functional Departments', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isMobile ? 1 : 3,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              childAspectRatio: 1.8,
            ),
            itemCount: _departments.length,
            itemBuilder: (context, index) {
              final dept = _departments[index];
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(dept.name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                        Text(dept.code, style: const TextStyle(fontSize: 10, fontFamily: 'monospace')),
                      ],
                    ),
                    Text('Head: ${dept.headOfDepartment}', style: const TextStyle(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.w600)),
                    Text(dept.description, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 11, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${dept.activeTeamsCount} Teams', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                        Text('${dept.activeEmployeesCount} Staff Members', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          Text('Operational Squads & Teams', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)),
          const SizedBox(height: 12),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _teams.length,
            itemBuilder: (context, index) {
              final tm = _teams[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                ),
                color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(tm.name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                          Text('Lead: ${tm.teamLead}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primary)),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(tm.description, style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: tm.memberNames.map((name) {
                          return Chip(
                            label: Text(name, style: const TextStyle(fontSize: 11)),
                            avatar: CircleAvatar(
                              backgroundColor: AppColors.primary.withValues(alpha: 0.2),
                              child: Text(name.substring(0, 1), style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.primary)),
                            ),
                            visualDensity: VisualDensity.compact,
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // ==========================================================================
  // TAB 5: ACCESS SCOPES
  // ==========================================================================
  Widget _buildAccessScopesTab(bool isDark, bool isMobile) {
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(20),
      children: DataScopeType.values.map((scope) {
        return Card(
          margin: const EdgeInsets.only(bottom: 14),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
          ),
          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.security_rounded, color: AppColors.primary, size: 22),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(scope.label, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                      const SizedBox(height: 4),
                      Text(scope.description, style: TextStyle(fontSize: 12.5, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
                      const SizedBox(height: 10),
                      Text(
                        'Assigned to ${_users.where((u) => u.accessScope == scope).length} active users in the system.',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  // ==========================================================================
  // USER DETAIL DRAWER
  // ==========================================================================
  Widget _buildUserDetailDrawer(bool isDark) {
    final user = _selectedUserDetail!;

    return AdminDrawerLayout(
      title: user.fullName,
      subtitle: '${user.employeeId} • ${user.jobTitle}',
      onClose: () => setState(() => _selectedUserDetail = null),
      footerActions: [
        OutlinedButton(
          onPressed: () => _toggleUserStatus(user),
          child: Text(user.accountStatus == UserAccountStatus.active ? 'Deactivate' : 'Activate'),
        ),
        ElevatedButton(
          onPressed: () {
            setState(() => _selectedUserDetail = null);
            _editUser(user);
          },
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
          child: const Text('Edit User Profile'),
        ),
      ],
      child: DefaultTabController(
        length: 4,
        child: Column(
          children: [
            TabBar(
              labelColor: AppColors.primary,
              unselectedLabelColor: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
              indicatorColor: AppColors.primary,
              labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              tabs: const [
                Tab(text: 'Identity & Contact'),
                Tab(text: 'Organization & Line'),
                Tab(text: 'Access & Security'),
                Tab(text: 'Activity Trail'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  // Tab 1: Identity
                  ListView(
                    padding: const EdgeInsets.all(20),
                    children: [
                      _buildDetailRow('Full Name', user.fullName, isDark),
                      _buildDetailRow('Employee ID', user.employeeId, isDark),
                      _buildDetailRow('Job Title', user.jobTitle, isDark),
                      _buildDetailRow('Employment Type', user.employmentType.label, isDark),
                      _buildDetailRow('Account Status', user.accountStatus.label, isDark),
                      const Divider(height: 24),
                      _buildDetailRow('Primary Mobile', user.primaryMobile, isDark),
                      _buildDetailRow('Official Email', user.email, isDark),
                      _buildDetailRow('Residential Address', '${user.address}, ${user.city}, ${user.state} - ${user.postalCode}', isDark),
                    ],
                  ),
                  // Tab 2: Organization
                  ListView(
                    padding: const EdgeInsets.all(20),
                    children: [
                      _buildDetailRow('Department', user.departmentName, isDark),
                      _buildDetailRow('Team / Squad', user.teamName, isDark),
                      _buildDetailRow('Designated Role', user.roleName, isDark),
                      _buildDetailRow('Reporting Manager', user.reportingManagerName ?? 'Direct to VP / Board', isDark),
                      _buildDetailRow('Work Location', user.workLocation, isDark),
                      _buildDetailRow('Joining Date', '${user.joiningDate.day}/${user.joiningDate.month}/${user.joiningDate.year}', isDark),
                      _buildDetailRow('Approval Authority', user.approvalAuthority, isDark),
                    ],
                  ),
                  // Tab 3: Access & Security
                  ListView(
                    padding: const EdgeInsets.all(20),
                    children: [
                      _buildDetailRow('Access Scope', user.accessScope.label, isDark),
                      _buildDetailRow('Authentication Method', user.authMethod, isDark),
                      _buildDetailRow('Two-Factor Authentication (2FA)', user.isTwoFactorEnabled ? 'Enabled & Enforced (Active)' : 'Disabled', isDark),
                      _buildDetailRow('Default Landing Page', user.defaultLandingPage, isDark),
                      _buildDetailRow('Session Security Status', user.sessionSecurityStatus, isDark),
                      const SizedBox(height: 16),
                      Text('Allowed Modules', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: user.allowedModules.map((m) => Chip(label: Text(m, style: const TextStyle(fontSize: 11)))).toList(),
                      ),
                    ],
                  ),
                  // Tab 4: Activity Trail
                  ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: user.activityHistory.length,
                    itemBuilder: (context, index) {
                      final act = user.activityHistory[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.darkBackground : AppColors.lightSurfaceSubtle,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(act.actionTitle, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                                Text(
                                  '${act.timestamp.day}/${act.timestamp.month} ${act.timestamp.hour}:${act.timestamp.minute.toString().padLeft(2, '0')}',
                                  style: TextStyle(fontSize: 10, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(act.details, style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
                            const SizedBox(height: 4),
                            Text('By: ${act.performedBy}', style: const TextStyle(fontSize: 10, color: AppColors.primary, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 170,
            child: Text(label, style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
          ),
          Expanded(
            child: Text(value, style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)),
          ),
        ],
      ),
    );
  }

  // ==========================================================================
  // ADD USER MULTI-SECTION MODAL
  // ==========================================================================
  Widget _buildAddUserModal(bool isDark) {
    final fNameCtrl = TextEditingController();
    final lNameCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    final mobileCtrl = TextEditingController();
    final empIdCtrl = TextEditingController(text: 'HOM-${1000 + _users.length + 1}');
    final jobTitleCtrl = TextEditingController();

    return Container(
      color: Colors.black.withValues(alpha: 0.5),
      alignment: Alignment.center,
      child: Material(
        color: Colors.transparent,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: 750,
            maxHeight: MediaQuery.of(context).size.height * 0.9,
          ),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 25)],
          ),
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Add New Internal User', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)),
                        Text('Configure employee credentials, organization assignment, and security bounds.', style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded),
                      onPressed: () => setState(() => _isAddUserModalOpen = false),
                    ),
                  ],
                ),
              ),

              // Scrollable Form Sections
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(24),
                  children: [
                    // Section 1: Personal
                    Text('1. Personal & Identity Information', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: fNameCtrl,
                            decoration: const InputDecoration(labelText: 'First Name *', border: OutlineInputBorder()),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: lNameCtrl,
                            decoration: const InputDecoration(labelText: 'Last Name *', border: OutlineInputBorder()),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: empIdCtrl,
                            decoration: const InputDecoration(labelText: 'Employee ID *', border: OutlineInputBorder()),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: jobTitleCtrl,
                            decoration: const InputDecoration(labelText: 'Job Title *', border: OutlineInputBorder()),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Section 2: Contact
                    Text('2. Contact Information', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: emailCtrl,
                            decoration: const InputDecoration(labelText: 'Official Email *', border: OutlineInputBorder()),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: mobileCtrl,
                            decoration: const InputDecoration(labelText: 'Primary Mobile (+91) *', border: OutlineInputBorder()),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Section 3: Organization & Role
                    Text('3. Organization & Role Assignment', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      initialValue: _departments.first.name,
                      decoration: const InputDecoration(labelText: 'Assigned Department *', border: OutlineInputBorder()),
                      items: _departments.map((d) => DropdownMenuItem(value: d.name, child: Text(d.name))).toList(),
                      onChanged: (val) {},
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      initialValue: _roles.first.roleName,
                      decoration: const InputDecoration(labelText: 'Assigned System Role *', border: OutlineInputBorder()),
                      items: _roles.map((r) => DropdownMenuItem(value: r.roleName, child: Text(r.roleName))).toList(),
                      onChanged: (val) {},
                    ),
                  ],
                ),
              ),

              // Footer
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                decoration: BoxDecoration(
                  border: Border(top: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                      onPressed: () => setState(() => _isAddUserModalOpen = false),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: () {
                        if (fNameCtrl.text.isEmpty || lNameCtrl.text.isEmpty || emailCtrl.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please complete required fields (First Name, Last Name, Email).')),
                          );
                          return;
                        }

                        final newUser = AdminUser(
                          id: 'usr_${DateTime.now().millisecondsSinceEpoch}',
                          employeeId: empIdCtrl.text,
                          firstName: fNameCtrl.text,
                          lastName: lNameCtrl.text,
                          displayName: '${fNameCtrl.text} ${lNameCtrl.text}',
                          jobTitle: jobTitleCtrl.text.isEmpty ? 'Operations Specialist' : jobTitleCtrl.text,
                          primaryMobile: mobileCtrl.text.isEmpty ? '+91 98000 00000' : mobileCtrl.text,
                          email: emailCtrl.text,
                          address: 'Commercial Hub',
                          city: 'Bengaluru',
                          state: 'Karnataka',
                          postalCode: '560001',
                          departmentId: _departments.first.id,
                          departmentName: _departments.first.name,
                          teamId: _teams.first.id,
                          teamName: _teams.first.name,
                          roleId: _roles.first.id,
                          roleName: _roles.first.roleName,
                          workLocation: 'Bengaluru Central',
                          joiningDate: DateTime.now(),
                          accountStatus: UserAccountStatus.active,
                        );

                        setState(() {
                          _users.insert(0, newUser);
                          _isAddUserModalOpen = false;
                        });

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('User ${newUser.fullName} added successfully with invite link dispatched.'),
                            backgroundColor: AppColors.success,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
                      child: const Text('Save & Send Invite'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _editUser(AdminUser user) {
    setState(() => _selectedUserDetail = user);
  }

  void _toggleUserStatus(AdminUser user) {
    final nextStatus = user.accountStatus == UserAccountStatus.active ? UserAccountStatus.inactive : UserAccountStatus.active;
    setState(() {
      final idx = _users.indexWhere((u) => u.id == user.id);
      if (idx != -1) {
        _users[idx] = user.copyWith(accountStatus: nextStatus);
        if (_selectedUserDetail?.id == user.id) {
          _selectedUserDetail = _users[idx];
        }
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${user.fullName} marked as ${nextStatus.label}.')),
    );
  }

  void _exportUserData() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Users & Access directory exported to CSV with audit hash.'),
        backgroundColor: AppColors.info,
      ),
    );
  }

  void _showBulkActionsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Bulk Actions (${_selectedUserIds.length} Users)'),
        content: const Text('Select an operation to execute across all selected user records:'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              setState(() => _selectedUserIds.clear());
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              setState(() {
                for (final id in _selectedUserIds) {
                  final idx = _users.indexWhere((u) => u.id == id);
                  if (idx != -1) {
                    _users[idx] = _users[idx].copyWith(accountStatus: UserAccountStatus.active);
                  }
                }
                _selectedUserIds.clear();
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Selected users activated successfully.'), backgroundColor: AppColors.success),
              );
            },
            child: const Text('Activate Selected'),
          ),
        ],
      ),
    );
  }

  void _createNewRoleModal(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Role builder opened. Select baseline template.')),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.person_search_rounded, size: 54, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
          const SizedBox(height: 12),
          Text('No matching users found', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)),
          const SizedBox(height: 6),
          Text('Try clearing filters or adjusting your search term.', style: TextStyle(fontSize: 13, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
          const SizedBox(height: 14),
          OutlinedButton(onPressed: _clearAllFilters, child: const Text('Clear All Filters')),
        ],
      ),
    );
  }
}
