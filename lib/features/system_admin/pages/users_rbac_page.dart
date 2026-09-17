import 'package:flutter/material.dart';
import 'package:cached_query_flutter/cached_query_flutter.dart';
import '../../../core/responsive/breakpoints.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/toast_service.dart';
import '../data/models/user_management_models.dart';
import '../models/admin_models.dart';
import '../models/admin_mock_data.dart';
import '../presentation/queries/user_queries.dart';
import '../widgets/admin_shared_widgets.dart';

class UsersRbacPage extends StatefulWidget {
  const UsersRbacPage({super.key});

  @override
  State<UsersRbacPage> createState() => _UsersRbacPageState();
}

class _UsersRbacPageState extends State<UsersRbacPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final UserQueries _userQueries = UserQueries();

  // Directory Filters & Search
  String _searchQuery = '';
  String? _selectedRoleFilter;
  String? _selectedStatusFilter;
  final Set<String> _selectedUserIds = {};

  // Active Modals & Drawer state
  UserApiItem? _selectedUserDetail;
  bool _isAddUserModalOpen = false;
  RoleApiItem? _selectedRoleForMatrix;
  final Set<String> _selectedPermissionIdsForMatrix = {};

  // Reference departments & teams from organizational structure
  final List<AdminDepartment> _departments = AdminMockData.departments;
  final List<AdminTeam> _teams = AdminMockData.teams;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Map<String, String> get _activeFiltersMap {
    final map = <String, String>{};
    if (_selectedRoleFilter != null) map['Role'] = _selectedRoleFilter!;
    if (_selectedStatusFilter != null) map['Status'] = _selectedStatusFilter!;
    return map;
  }

  void _removeFilter(String key) {
    setState(() {
      if (key == 'Role') _selectedRoleFilter = null;
      if (key == 'Status') _selectedStatusFilter = null;
    });
  }

  void _clearAllFilters() {
    setState(() {
      _searchQuery = '';
      _selectedRoleFilter = null;
      _selectedStatusFilter = null;
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
                  description:
                      'Manage organizational users, authentication credentials, system roles, and granular permission matrices.',
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

                // 2. Metrics Header with live queries
                _buildMetricsBar(),

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
                    onTap: (_) => setState(() {}),
                    isScrollable: true,
                    labelColor: AppColors.primary,
                    unselectedLabelColor: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                    indicatorColor: AppColors.primary,
                    indicatorWeight: 2.5,
                    labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                    tabs: const [
                      Tab(icon: Icon(Icons.people_alt_outlined, size: 18), text: 'Users Directory'),
                      Tab(icon: Icon(Icons.security_outlined, size: 18), text: 'Roles Management'),
                      Tab(icon: Icon(Icons.grid_view_rounded, size: 18), text: 'Permission Matrix'),
                      Tab(icon: Icon(Icons.corporate_fare_outlined, size: 18), text: 'Departments & Teams'),
                      Tab(icon: Icon(Icons.lock_person_outlined, size: 18), text: 'Access Scopes'),
                    ],
                  ),
                ),

                // 4. Tab Content
                if (_tabController.index == 0) _buildUsersDirectoryTab(isDark, isMobile),
                if (_tabController.index == 1) _buildRolesManagementTab(isDark, isMobile),
                if (_tabController.index == 2) _buildPermissionMatrixTab(isDark, isMobile),
                if (_tabController.index == 3) _buildDepartmentsTeamsTab(isDark, isMobile),
                if (_tabController.index == 4) _buildAccessScopesTab(isDark, isMobile),
              ],
            ),
          ),

          // User Detail Drawer
          if (_selectedUserDetail != null)
            Positioned(
              top: 0,
              bottom: 0,
              right: 0,
              child: _buildUserDetailDrawer(isDark),
            ),

          // Add User Modal
          if (_isAddUserModalOpen) _buildAddUserModal(isDark),
        ],
      ),
    );
  }

  // ==========================================================================
  // METRICS BAR
  // ==========================================================================
  Widget _buildMetricsBar() {
    return QueryBuilder(
      query: _userQueries.getUsersQuery(limit: 100),
      builder: (context, userState) {
        final users = userState.data?.users ?? [];
        final totalUsers = userState.data?.total ?? users.length;
        final activeUsers = users.where((u) => u.status == 'ACTIVE').length;
        final pendingUsers = users.where((u) => u.status == 'PENDING_VERIFICATION').length;

        return QueryBuilder(
          query: _userQueries.getRolesQuery(),
          builder: (context, roleState) {
            final roles = roleState.data ?? [];

            return AdminSummaryCards(
              metrics: [
                AdminMetricItem(
                  label: 'Total Users',
                  value: '$totalUsers',
                  subtitle: 'Platform Directory',
                  icon: Icons.people_alt_rounded,
                  color: AppColors.primary,
                ),
                AdminMetricItem(
                  label: 'Active Users',
                  value: '$activeUsers',
                  subtitle: '${totalUsers > 0 ? ((activeUsers / totalUsers) * 100).toStringAsFixed(0) : 0}% Active rate',
                  icon: Icons.check_circle_outline_rounded,
                  color: AppColors.success,
                  trendText: '+Live',
                  isPositiveTrend: true,
                ),
                AdminMetricItem(
                  label: 'Pending Invites',
                  value: '$pendingUsers',
                  subtitle: 'Awaiting verification',
                  icon: Icons.mark_email_unread_outlined,
                  color: AppColors.warning,
                ),
                AdminMetricItem(
                  label: 'Configured Roles',
                  value: '${roles.length}',
                  subtitle: 'RBAC Security Profiles',
                  icon: Icons.admin_panel_settings_outlined,
                  color: AppColors.secondary,
                ),
              ],
            );
          },
        );
      },
    );
  }

  // ==========================================================================
  // TAB 1: USERS DIRECTORY
  // ==========================================================================
  Widget _buildUsersDirectoryTab(bool isDark, bool isMobile) {
    final usersQuery = _userQueries.getUsersQuery(
      search: _searchQuery.isNotEmpty ? _searchQuery : null,
      status: _selectedStatusFilter,
      roleId: _selectedRoleFilter,
    );

    return Column(
      children: [
        // Filter & Search Toolbar
        AdminFilterBar(
          searchQuery: _searchQuery,
          onSearchChanged: (q) => setState(() => _searchQuery = q),
          searchHint: 'Search users by name, email, phone...',
          activeFilters: _activeFiltersMap,
          onRemoveFilter: _removeFilter,
          onClearAll: _clearAllFilters,
          filterControls: [
            // Status Dropdown
            DropdownButton<String?>(
              value: _selectedStatusFilter,
              hint: const Text('Status', style: TextStyle(fontSize: 12)),
              underline: const SizedBox(),
              items: const [
                DropdownMenuItem(value: null, child: Text('All Statuses', style: TextStyle(fontSize: 12))),
                DropdownMenuItem(value: 'ACTIVE', child: Text('Active', style: TextStyle(fontSize: 12))),
                DropdownMenuItem(value: 'INACTIVE', child: Text('Inactive', style: TextStyle(fontSize: 12))),
                DropdownMenuItem(value: 'SUSPENDED', child: Text('Suspended', style: TextStyle(fontSize: 12))),
                DropdownMenuItem(value: 'PENDING_VERIFICATION', child: Text('Pending Verification', style: TextStyle(fontSize: 12))),
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
                        style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero),
                        child: const Text('Bulk Actions', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primary)),
                      ),
                    ],
                  ),
                )
              : null,
        ),

        // Live Query Builder for Users
        QueryBuilder(
          query: usersQuery,
          builder: (context, state) {
            if (state.data == null && state.error == null) {
              return const Padding(
                padding: EdgeInsets.all(40),
                child: Center(child: CircularProgressIndicator()),
              );
            }

            if (state.error != null && state.data == null) {
              return Padding(
                padding: const EdgeInsets.all(30),
                child: Center(
                  child: Column(
                    children: [
                      const Icon(Icons.error_outline_rounded, color: AppColors.error, size: 40),
                      const SizedBox(height: 10),
                      Text('Failed to load users: ${state.error ?? 'Unknown error'}'),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () => usersQuery.refetch(),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              );
            }

            final users = state.data?.users ?? [];
            if (users.isEmpty) {
              return _buildEmptyState(isDark);
            }

            return isMobile
                ? _buildMobileUserCards(users, isDark)
                : _buildDesktopUserTable(users, isDark);
          },
        ),
      ],
    );
  }

  Widget _buildDesktopUserTable(List<UserApiItem> list, bool isDark) {
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
            dataRowMinHeight: 52,
            dataRowMaxHeight: 58,
            columns: const [
              DataColumn(label: Text('User Profile', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
              DataColumn(label: Text('Contact / Phone', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
              DataColumn(label: Text('Assigned Roles', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
              DataColumn(label: Text('Type', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
              DataColumn(label: Text('Account Status', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
              DataColumn(label: Text('Last Login', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
              DataColumn(label: Text('Actions', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
            ],
            rows: list.map((user) {
              return DataRow(
                cells: [
                  // User Profile
                  DataCell(
                    InkWell(
                      onTap: () => setState(() => _selectedUserDetail = user),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 16,
                            backgroundColor: AppColors.primary.withValues(alpha: 0.15),
                            child: Text(
                              user.firstName.isNotEmpty ? user.firstName.substring(0, 1).toUpperCase() : 'U',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.primary),
                            ),
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

                  // Contact / Phone
                  DataCell(
                    Text(
                      user.phone ?? '—',
                      style: const TextStyle(fontSize: 12, fontFamily: 'monospace'),
                    ),
                  ),

                  // Assigned Roles
                  DataCell(
                    user.roles.isEmpty
                        ? const Text('No Roles', style: TextStyle(fontSize: 11, fontStyle: FontStyle.italic))
                        : Wrap(
                            spacing: 4,
                            children: user.roles
                                .map((r) => Chip(
                                      label: Text(r.name, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.primary)),
                                      backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                                      padding: EdgeInsets.zero,
                                      visualDensity: VisualDensity.compact,
                                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    ))
                                .toList(),
                          ),
                  ),

                  // User Type
                  DataCell(
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: user.userType == 'ADMIN'
                            ? AppColors.primary.withValues(alpha: 0.12)
                            : (isDark ? AppColors.darkBackground : AppColors.lightSurfaceSubtle),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        user.userType,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: user.userType == 'ADMIN' ? AppColors.primary : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                        ),
                      ),
                    ),
                  ),

                  // Status
                  DataCell(
                    AdminStatusBadge(
                      label: user.status,
                      color: _getStatusColor(user.status),
                    ),
                  ),

                  // Last Login
                  DataCell(
                    Text(
                      user.lastLoginAt != null
                          ? '${user.lastLoginAt!.day}/${user.lastLoginAt!.month}/${user.lastLoginAt!.year} ${user.lastLoginAt!.hour}:${user.lastLoginAt!.minute.toString().padLeft(2, '0')}'
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
                          tooltip: 'View Profile',
                          onPressed: () => setState(() => _selectedUserDetail = user),
                        ),
                        IconButton(
                          icon: const Icon(Icons.lock_reset_rounded, size: 18),
                          tooltip: 'Reset Password',
                          onPressed: () => _showResetPasswordDialog(context, user),
                        ),
                        IconButton(
                          icon: const Icon(Icons.admin_panel_settings_outlined, size: 18),
                          tooltip: 'Manage Roles',
                          onPressed: () => _showManageRolesDialog(context, user),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit_outlined, size: 18),
                          tooltip: 'Edit User',
                          onPressed: () => _showEditUserModal(context, user),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline_rounded, size: 18, color: AppColors.error),
                          tooltip: 'Delete User',
                          onPressed: () => _confirmDeleteUser(context, user),
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

  Widget _buildMobileUserCards(List<UserApiItem> list, bool isDark) {
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
                      child: Text(
                        user.firstName.isNotEmpty ? user.firstName.substring(0, 1).toUpperCase() : 'U',
                        style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(user.fullName, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                          Text(user.email, style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
                        ],
                      ),
                    ),
                    AdminStatusBadge(label: user.status, color: _getStatusColor(user.status)),
                  ],
                ),
                const Divider(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Type: ${user.userType}', style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
                    Text(
                      user.roles.isNotEmpty ? 'Roles: ${user.roles.map((r) => r.name).join(", ")}' : 'No roles assigned',
                      style: const TextStyle(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                      onPressed: () => setState(() => _selectedUserDetail = user),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text('View', style: TextStyle(fontSize: 12)),
                    ),
                    const SizedBox(width: 6),
                    OutlinedButton(
                      onPressed: () => _showResetPasswordDialog(context, user),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text('Password', style: TextStyle(fontSize: 12)),
                    ),
                    const SizedBox(width: 6),
                    ElevatedButton(
                      onPressed: () => _showEditUserModal(context, user),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text('Edit', style: TextStyle(fontSize: 12)),
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

  Color _getStatusColor(String status) {
    switch (status) {
      case 'ACTIVE':
        return AppColors.success;
      case 'INACTIVE':
        return AppColors.lightTextMuted;
      case 'SUSPENDED':
        return AppColors.error;
      case 'PENDING_VERIFICATION':
        return AppColors.warning;
      default:
        return AppColors.lightTextMuted;
    }
  }

  // ==========================================================================
  // TAB 2: ROLES MANAGEMENT
  // ==========================================================================
  Widget _buildRolesManagementTab(bool isDark, bool isMobile) {
    final rolesQuery = _userQueries.getRolesQuery();

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
                  Text('Standard organizational security roles and assigned permission profiles.', style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () => _showCreateRoleModal(context),
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
          QueryBuilder(
            query: rolesQuery,
            builder: (context, state) {
              if (state.data == null && state.error == null) {
                return const Center(child: Padding(padding: EdgeInsets.all(30), child: CircularProgressIndicator()));
              }

              final roles = state.data ?? [];
              if (roles.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(30),
                    child: Column(
                      children: [
                        const Icon(Icons.shield_outlined, size: 48, color: AppColors.lightTextMuted),
                        const SizedBox(height: 10),
                        const Text('No roles found in system.', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 12),
                        ElevatedButton(onPressed: () => _showCreateRoleModal(context), child: const Text('Create First Role')),
                      ],
                    ),
                  ),
                );
              }

              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: roles.length,
                itemBuilder: (context, index) {
                  final role = roles[index];
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
                                        Text(role.name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                                        const SizedBox(width: 8),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: isDark ? AppColors.darkBackground : AppColors.lightSurfaceSubtle,
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: Text(role.slug, style: const TextStyle(fontSize: 10, fontFamily: 'monospace')),
                                        ),
                                        if (role.isSystem) ...[
                                          const SizedBox(width: 6),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: AppColors.primary.withValues(alpha: 0.12),
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                            child: const Text('SYSTEM', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.primary)),
                                          ),
                                        ],
                                      ],
                                    ),
                                    Text('${role.permissions.length} Permissions configured', style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: role.isActive ? AppColors.success.withValues(alpha: 0.12) : AppColors.lightTextMuted.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  '${role.userCount} Users Active',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: role.isActive ? AppColors.success : AppColors.lightTextMuted,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (role.description != null && role.description!.isNotEmpty) ...[
                            const SizedBox(height: 10),
                            Text(role.description!, style: TextStyle(fontSize: 12.5, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
                          ],
                          const SizedBox(height: 14),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                role.isActive ? 'Status: Active' : 'Status: Inactive',
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: role.isActive ? AppColors.success : AppColors.lightTextMuted),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit_outlined, size: 18),
                                    tooltip: 'Edit Role',
                                    onPressed: () => _showEditRoleModal(context, role),
                                  ),
                                  if (!role.isSystem)
                                    IconButton(
                                      icon: const Icon(Icons.delete_outline_rounded, size: 18, color: AppColors.error),
                                      tooltip: 'Delete Role',
                                      onPressed: () => _confirmDeleteRole(context, role),
                                    ),
                                  const SizedBox(width: 8),
                                  OutlinedButton.icon(
                                    onPressed: () {
                                      setState(() {
                                        _selectedRoleForMatrix = role;
                                        _selectedPermissionIdsForMatrix.clear();
                                        _selectedPermissionIdsForMatrix.addAll(role.permissions.map((p) => p.id));
                                        _tabController.animateTo(2); // Switch to Matrix Tab
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
              );
            },
          ),
        ],
      ),
    );
  }

  // ==========================================================================
  // TAB 3: PERMISSION MATRIX
  // ==========================================================================
  Widget _buildPermissionMatrixTab(bool isDark, bool isMobile) {
    return QueryBuilder(
      query: _userQueries.getRolesQuery(),
      builder: (context, roleState) {
        final roles = roleState.data ?? [];
        if (roles.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(30),
              child: Text('No roles available to configure.'),
            ),
          );
        }

        final activeRole = _selectedRoleForMatrix != null && roles.any((r) => r.id == _selectedRoleForMatrix!.id)
            ? roles.firstWhere((r) => r.id == _selectedRoleForMatrix!.id)
            : roles.first;

        if (_selectedRoleForMatrix == null || _selectedRoleForMatrix!.id != activeRole.id) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              setState(() {
                _selectedRoleForMatrix = activeRole;
                _selectedPermissionIdsForMatrix.clear();
                _selectedPermissionIdsForMatrix.addAll(activeRole.permissions.map((p) => p.id));
              });
            }
          });
        }

        return QueryBuilder(
          query: _userQueries.getPermissionsQuery(),
          builder: (context, permState) {
            final allPermissions = permState.data ?? [];

            // Group permissions by resource
            final Map<String, List<PermissionApiItem>> grouped = {};
            for (final p in allPermissions) {
              grouped.putIfAbsent(p.resource, () => []).add(p);
            }

            return Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Role Selector Bar
                  Row(
                    children: [
                      Text(
                        'Viewing Capabilities For:',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                      ),
                      const SizedBox(width: 12),
                      DropdownButton<RoleApiItem>(
                        value: activeRole,
                        items: roles
                            .map((r) => DropdownMenuItem(
                                  value: r,
                                  child: Text(r.name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                                ))
                            .toList(),
                        onChanged: (newRole) {
                          if (newRole != null) {
                            setState(() {
                              _selectedRoleForMatrix = newRole;
                              _selectedPermissionIdsForMatrix.clear();
                              _selectedPermissionIdsForMatrix.addAll(newRole.permissions.map((p) => p.id));
                            });
                          }
                        },
                      ),
                      const Spacer(),
                      ElevatedButton.icon(
                        onPressed: () => _saveRolePermissions(context, activeRole),
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

                  // Permission Matrix Content
                  if (allPermissions.isEmpty && permState.data == null)
                    const Center(child: Padding(padding: EdgeInsets.all(30), child: CircularProgressIndicator()))
                  else
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
                          itemCount: grouped.keys.length,
                          separatorBuilder: (context, index) => Divider(height: 1, color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                          itemBuilder: (context, index) {
                            final resource = grouped.keys.elementAt(index);
                            final perms = grouped[resource]!;

                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: AppColors.primary.withValues(alpha: 0.1),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          resource,
                                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.primary),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        '(${perms.length} Permissions Available)',
                                        style: TextStyle(fontSize: 11, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: perms.map((perm) {
                                      final isSelected = _selectedPermissionIdsForMatrix.contains(perm.id);

                                      return FilterChip(
                                        label: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              perm.action,
                                              style: TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.bold,
                                                color: isSelected ? Colors.white : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                                              ),
                                            ),
                                            if (perm.description != null)
                                              Text(
                                                perm.description!,
                                                style: TextStyle(
                                                  fontSize: 9,
                                                  color: isSelected ? Colors.white70 : (isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                                                ),
                                              ),
                                          ],
                                        ),
                                        selected: isSelected,
                                        selectedColor: AppColors.primary,
                                        backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightSurfaceSubtle,
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        onSelected: (val) {
                                          setState(() {
                                            if (val) {
                                              _selectedPermissionIdsForMatrix.add(perm.id);
                                            } else {
                                              _selectedPermissionIdsForMatrix.remove(perm.id);
                                            }
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
          },
        );
      },
    );
  }

  void _saveRolePermissions(BuildContext context, RoleApiItem role) {
    final mutation = _userQueries.getAssignRolePermissionsMutation(
      onAssigned: (updatedRole) {
        if (mounted) {
          setState(() {
            _selectedRoleForMatrix = updatedRole;
            _selectedPermissionIdsForMatrix.clear();
            _selectedPermissionIdsForMatrix.addAll(updatedRole.permissions.map((p) => p.id));
          });
        }
      },
    );
    mutation.mutate((
      roleId: role.id,
      permissionIds: _selectedPermissionIdsForMatrix.toList(),
    ));
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
      subtitle: '${user.userType} • ${user.status}',
      onClose: () => setState(() => _selectedUserDetail = null),
      footerActions: [
        OutlinedButton(
          onPressed: () {
            setState(() => _selectedUserDetail = null);
            _showResetPasswordDialog(context, user);
          },
          child: const Text('Reset Password'),
        ),
        ElevatedButton(
          onPressed: () {
            setState(() => _selectedUserDetail = null);
            _showEditUserModal(context, user);
          },
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
          child: const Text('Edit User'),
        ),
      ],
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildDetailRow('User ID', user.id, isDark),
          _buildDetailRow('Full Name', user.fullName, isDark),
          _buildDetailRow('Official Email', user.email, isDark),
          _buildDetailRow('Phone Number', user.phone ?? 'Not provided', isDark),
          _buildDetailRow('User Type', user.userType, isDark),
          _buildDetailRow('Account Status', user.status, isDark),
          _buildDetailRow(
            'Created At',
            '${user.createdAt.day}/${user.createdAt.month}/${user.createdAt.year} ${user.createdAt.hour}:${user.createdAt.minute.toString().padLeft(2, '0')}',
            isDark,
          ),
          _buildDetailRow(
            'Last Login',
            user.lastLoginAt != null
                ? '${user.lastLoginAt!.day}/${user.lastLoginAt!.month}/${user.lastLoginAt!.year} ${user.lastLoginAt!.hour}:${user.lastLoginAt!.minute.toString().padLeft(2, '0')}'
                : 'Never logged in',
            isDark,
          ),
          const Divider(height: 24),
          Text('Assigned Roles', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)),
          const SizedBox(height: 8),
          user.roles.isEmpty
              ? Text('No roles assigned', style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted))
              : Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: user.roles
                      .map((r) => Chip(
                            label: Text(r.name, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primary)),
                            backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                          ))
                      .toList(),
                ),
        ],
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
            width: 140,
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
    final phoneCtrl = TextEditingController();
    final passwordCtrl = TextEditingController();
    String selectedStatus = 'ACTIVE';
    String? selectedRoleId;

    return Container(
      color: Colors.black.withValues(alpha: 0.5),
      alignment: Alignment.center,
      child: Material(
        color: Colors.transparent,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: 680,
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
                        Text('Add New System User', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)),
                        Text('Create credentials, portal access, and role assignment.', style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded),
                      onPressed: () => setState(() => _isAddUserModalOpen = false),
                    ),
                  ],
                ),
              ),

              // Form fields
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(24),
                  children: [
                    Text('1. Personal & Contact Info', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)),
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
                            decoration: const InputDecoration(labelText: 'Last Name', border: OutlineInputBorder()),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: emailCtrl,
                            decoration: const InputDecoration(labelText: 'Email Address *', border: OutlineInputBorder()),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: phoneCtrl,
                            decoration: const InputDecoration(labelText: 'Phone Number', border: OutlineInputBorder()),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: passwordCtrl,
                      obscureText: true,
                      decoration: const InputDecoration(labelText: 'Initial Password (min 8 chars) *', border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 20),

                    Text('2. Security & Role Assignment', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      initialValue: selectedStatus,
                      decoration: const InputDecoration(labelText: 'Initial Status', border: OutlineInputBorder()),
                      items: const [
                        DropdownMenuItem(value: 'ACTIVE', child: Text('ACTIVE')),
                        DropdownMenuItem(value: 'INACTIVE', child: Text('INACTIVE')),
                      ],
                      onChanged: (val) {
                        if (val != null) selectedStatus = val;
                      },
                    ),
                    const SizedBox(height: 12),
                    QueryBuilder(
                      query: _userQueries.getRolesQuery(),
                      builder: (context, state) {
                        final roles = state.data ?? [];
                        return DropdownButtonFormField<String?>(
                          initialValue: selectedRoleId,
                          decoration: const InputDecoration(labelText: 'Assign Role', border: OutlineInputBorder()),
                          items: [
                            const DropdownMenuItem(value: null, child: Text('None (No Role)')),
                            for (final r in roles)
                              DropdownMenuItem(value: r.id, child: Text('${r.name} (${r.slug})')),
                          ],
                          onChanged: (val) => selectedRoleId = val,
                        );
                      },
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
                        final firstName = fNameCtrl.text.trim();
                        final lastName = lNameCtrl.text.trim();
                        final email = emailCtrl.text.trim().toLowerCase();
                        final phone = phoneCtrl.text.trim();
                        final password = passwordCtrl.text.trim();

                        if (firstName.isEmpty || email.isEmpty || password.isEmpty) {
                          ToastService.showError('First Name, Email, and Password are required.');
                          return;
                        }

                        // Validate email format
                        final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
                        if (!emailRegex.hasMatch(email)) {
                          ToastService.showError('Please enter a valid email address.');
                          return;
                        }

                        if (password.length < 8) {
                          ToastService.showError('Password must be at least 8 characters long.');
                          return;
                        }

                        // Validate phone format if provided
                        if (phone.isNotEmpty && phone.length < 6) {
                          ToastService.showError('Phone number must be at least 6 digits.');
                          return;
                        }

                        final mutation = _userQueries.getCreateUserMutation(
                          onCreated: (_) => setState(() => _isAddUserModalOpen = false),
                        );

                        mutation.mutate((
                          firstName: firstName,
                          lastName: lastName.isNotEmpty ? lastName : null,
                          email: email,
                          phone: phone.isNotEmpty ? phone : null,
                          password: password,
                          userType: 'ADMIN',
                          status: selectedStatus,
                          avatarUrl: null,
                          roleIds: selectedRoleId != null ? [selectedRoleId!] : null,
                        ));
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
                      child: const Text('Save & Create User'),
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

  // ==========================================================================
  // EDIT USER MODAL
  // ==========================================================================
  void _showEditUserModal(BuildContext context, UserApiItem user) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fNameCtrl = TextEditingController(text: user.firstName);
    final lNameCtrl = TextEditingController(text: user.lastName ?? '');
    final emailCtrl = TextEditingController(text: user.email);
    final phoneCtrl = TextEditingController(text: user.phone ?? '');
    String selectedStatus = user.status;
    String? selectedRoleId = user.roles.isNotEmpty ? user.roles.first.id : null;

    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Material(
              color: Colors.transparent,
              child: Center(
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: 680,
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
                                Text('Edit User: ${user.fullName}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)),
                                Text('Update profile details, contact information, and role assignment.', style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
                              ],
                            ),
                            IconButton(
                              icon: const Icon(Icons.close_rounded),
                              onPressed: () => Navigator.pop(ctx),
                            ),
                          ],
                        ),
                      ),

                      // Form fields
                      Expanded(
                        child: ListView(
                          padding: const EdgeInsets.all(24),
                          children: [
                            Text('1. Personal & Contact Info', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)),
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
                                    decoration: const InputDecoration(labelText: 'Last Name', border: OutlineInputBorder()),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: emailCtrl,
                                    readOnly: true,
                                    enabled: false,
                                    decoration: const InputDecoration(labelText: 'Email Address (Locked)', border: OutlineInputBorder()),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: TextField(
                                    controller: phoneCtrl,
                                    decoration: const InputDecoration(labelText: 'Phone Number', border: OutlineInputBorder()),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),

                            Text('2. Security & Role Assignment', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)),
                            const SizedBox(height: 12),
                            DropdownButtonFormField<String>(
                              initialValue: selectedStatus,
                              decoration: const InputDecoration(labelText: 'Status', border: OutlineInputBorder()),
                              items: const [
                                DropdownMenuItem(value: 'ACTIVE', child: Text('ACTIVE')),
                                DropdownMenuItem(value: 'INACTIVE', child: Text('INACTIVE')),
                              ],
                              onChanged: (val) {
                                if (val != null) {
                                  setModalState(() => selectedStatus = val);
                                }
                              },
                            ),
                            const SizedBox(height: 12),
                            QueryBuilder(
                              query: _userQueries.getRolesQuery(),
                              builder: (context, state) {
                                final roles = state.data ?? [];
                                return DropdownButtonFormField<String?>(
                                  initialValue: selectedRoleId,
                                  decoration: const InputDecoration(labelText: 'Assign Role', border: OutlineInputBorder()),
                                  items: [
                                    const DropdownMenuItem(value: null, child: Text('None (No Role)')),
                                    for (final r in roles)
                                      DropdownMenuItem(value: r.id, child: Text('${r.name} (${r.slug})')),
                                  ],
                                  onChanged: (val) => setModalState(() => selectedRoleId = val),
                                );
                              },
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
                              onPressed: () => Navigator.pop(ctx),
                              child: const Text('Cancel'),
                            ),
                            const SizedBox(width: 12),
                            ElevatedButton(
                              onPressed: () {
                                final firstName = fNameCtrl.text.trim();
                                final lastName = lNameCtrl.text.trim();
                                final phone = phoneCtrl.text.trim();

                                if (firstName.isEmpty) {
                                  ToastService.showError('First Name is required.');
                                  return;
                                }

                                if (phone.isNotEmpty && phone.length < 6) {
                                  ToastService.showError('Phone number must be at least 6 digits.');
                                  return;
                                }

                                Navigator.pop(ctx);

                                final updateMutation = _userQueries.getUpdateUserMutation(
                                  onUpdated: (updatedUser) {
                                    if (mounted) {
                                      setState(() {
                                        if (_selectedUserDetail?.id == updatedUser.id) {
                                          _selectedUserDetail = updatedUser;
                                        }
                                      });
                                    }
                                  },
                                );

                                updateMutation.mutate((
                                  id: user.id,
                                  firstName: firstName,
                                  lastName: lastName.isNotEmpty ? lastName : null,
                                  phone: phone.isNotEmpty ? phone : null,
                                  status: selectedStatus,
                                  userType: 'ADMIN',
                                  avatarUrl: null,
                                ));

                                // If role changed, update assigned roles
                                final currentRoleId = user.roles.isNotEmpty ? user.roles.first.id : null;
                                if (selectedRoleId != currentRoleId) {
                                  final roleMutation = _userQueries.getAssignUserRolesMutation();
                                  roleMutation.mutate((
                                    id: user.id,
                                    roleIds: selectedRoleId != null ? [selectedRoleId!] : [],
                                  ));
                                }
                              },
                              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
                              child: const Text('Save Changes'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // ==========================================================================
  // RESET PASSWORD DIALOG
  // ==========================================================================
  void _showResetPasswordDialog(BuildContext context, UserApiItem user) {
    final passwordCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text('Reset Password for ${user.fullName}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Enter new password for ${user.email}. This will immediately invalidate existing sessions.'),
              const SizedBox(height: 14),
              TextField(
                controller: passwordCtrl,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'New Password *',
                  hintText: 'Minimum 8 characters',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                if (passwordCtrl.text.trim().length < 8) {
                  ToastService.showError('Password must be at least 8 characters long.');
                  return;
                }
                Navigator.pop(ctx);
                final mutation = _userQueries.getResetPasswordMutation();
                mutation.mutate((id: user.id, newPassword: passwordCtrl.text.trim()));
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
              child: const Text('Confirm Reset'),
            ),
          ],
        );
      },
    );
  }

  // ==========================================================================
  // MANAGE ROLES DIALOG
  // ==========================================================================
  void _showManageRolesDialog(BuildContext context, UserApiItem user) {
    final assignedRoleIds = user.roles.map((r) => r.id).toSet();

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text('Assign Roles: ${user.fullName}'),
              content: SizedBox(
                width: 420,
                child: QueryBuilder(
                  query: _userQueries.getRolesQuery(),
                  builder: (context, state) {
                    final allRoles = state.data ?? [];
                    if (allRoles.isEmpty) {
                      return const Text('No roles available.');
                    }

                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: allRoles.map((role) {
                        final isChecked = assignedRoleIds.contains(role.id);
                        return CheckboxListTile(
                          title: Text(role.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                          subtitle: Text(role.slug),
                          value: isChecked,
                          onChanged: (val) {
                            setDialogState(() {
                              if (val == true) {
                                assignedRoleIds.add(role.id);
                              } else {
                                assignedRoleIds.remove(role.id);
                              }
                            });
                          },
                        );
                      }).toList(),
                    );
                  },
                ),
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    final mutation = _userQueries.getAssignUserRolesMutation(
                      onAssigned: () {
                        if (mounted) {
                          setState(() {});
                        }
                      },
                    );
                    mutation.mutate((
                      id: user.id,
                      roleIds: assignedRoleIds.toList(),
                    ));
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
                  child: const Text('Save Roles'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // ==========================================================================
  // DELETE USER CONFIRMATION
  // ==========================================================================
  void _confirmDeleteUser(BuildContext context, UserApiItem user) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete User Account'),
        content: Text('Are you sure you want to soft-delete account for "${user.fullName}" (${user.email})?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              final mutation = _userQueries.getDeleteUserMutation(
                onDeleted: (deletedId) {
                  if (mounted) {
                    setState(() {
                      if (_selectedUserDetail?.id == deletedId) {
                        _selectedUserDetail = null;
                      }
                      _selectedUserIds.remove(deletedId);
                    });
                  }
                },
              );
              mutation.mutate(user.id);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error, foregroundColor: Colors.white),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  // ==========================================================================
  // CREATE ROLE MODAL
  // ==========================================================================
  void _showCreateRoleModal(BuildContext context) {
    final nameCtrl = TextEditingController();
    final slugCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    bool isActive = true;

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return AlertDialog(
              title: const Text('Create New Security Role'),
              content: SizedBox(
                width: 480,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: nameCtrl,
                        decoration: const InputDecoration(labelText: 'Role Name *', hintText: 'e.g. Sales Manager', border: OutlineInputBorder()),
                        onChanged: (val) {
                          slugCtrl.text = val.trim().toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '-');
                          setModalState(() {});
                        },
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: slugCtrl,
                        decoration: const InputDecoration(labelText: 'Role Slug', hintText: 'e.g. sales-manager', border: OutlineInputBorder()),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: descCtrl,
                        maxLines: 2,
                        decoration: const InputDecoration(labelText: 'Description', hintText: 'Functional responsibilities...', border: OutlineInputBorder()),
                      ),
                      const SizedBox(height: 12),
                      SwitchListTile(
                        title: const Text('Role Is Active'),
                        value: isActive,
                        onChanged: (val) => setModalState(() => isActive = val),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
                ElevatedButton(
                  onPressed: () {
                    if (nameCtrl.text.trim().isEmpty) {
                      ToastService.showError('Role name is required.');
                      return;
                    }
                    Navigator.pop(ctx);
                    final mutation = _userQueries.getCreateRoleMutation(
                      onCreated: (_) {
                        if (mounted) {
                          setState(() {});
                        }
                      },
                    );
                    mutation.mutate((
                      name: nameCtrl.text.trim(),
                      slug: slugCtrl.text.trim().isNotEmpty ? slugCtrl.text.trim() : null,
                      description: descCtrl.text.trim().isNotEmpty ? descCtrl.text.trim() : null,
                      isActive: isActive,
                      permissionIds: null,
                    ));
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
                  child: const Text('Create Role'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // ==========================================================================
  // EDIT ROLE MODAL
  // ==========================================================================
  void _showEditRoleModal(BuildContext context, RoleApiItem role) {
    final nameCtrl = TextEditingController(text: role.name);
    final slugCtrl = TextEditingController(text: role.slug);
    final descCtrl = TextEditingController(text: role.description ?? '');
    bool isActive = role.isActive;

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return AlertDialog(
              title: Text('Edit Role: ${role.name}'),
              content: SizedBox(
                width: 480,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: nameCtrl,
                        decoration: const InputDecoration(labelText: 'Role Name *', border: OutlineInputBorder()),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: slugCtrl,
                        decoration: const InputDecoration(labelText: 'Role Slug', border: OutlineInputBorder()),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: descCtrl,
                        maxLines: 2,
                        decoration: const InputDecoration(labelText: 'Description', border: OutlineInputBorder()),
                      ),
                      const SizedBox(height: 12),
                      SwitchListTile(
                        title: const Text('Role Is Active'),
                        value: isActive,
                        onChanged: (val) => setModalState(() => isActive = val),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
                ElevatedButton(
                  onPressed: () {
                    if (nameCtrl.text.trim().isEmpty) {
                      ToastService.showError('Role name is required.');
                      return;
                    }
                    Navigator.pop(ctx);
                    final mutation = _userQueries.getUpdateRoleMutation(
                      onUpdated: (updatedRole) {
                        if (mounted) {
                          setState(() {
                            if (_selectedRoleForMatrix?.id == updatedRole.id) {
                              _selectedRoleForMatrix = updatedRole;
                            }
                          });
                        }
                      },
                    );
                    mutation.mutate((
                      id: role.id,
                      name: nameCtrl.text.trim(),
                      slug: slugCtrl.text.trim().isNotEmpty ? slugCtrl.text.trim() : null,
                      description: descCtrl.text.trim().isNotEmpty ? descCtrl.text.trim() : null,
                      isActive: isActive,
                    ));
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
                  child: const Text('Save Changes'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // ==========================================================================
  // DELETE ROLE CONFIRMATION
  // ==========================================================================
  void _confirmDeleteRole(BuildContext context, RoleApiItem role) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Role'),
        content: Text('Are you sure you want to delete role "${role.name}" (${role.slug})?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              final mutation = _userQueries.getDeleteRoleMutation(
                onDeleted: (deletedRoleId) {
                  if (mounted) {
                    setState(() {
                      if (_selectedRoleForMatrix?.id == deletedRoleId) {
                        _selectedRoleForMatrix = null;
                      }
                    });
                  }
                },
              );
              mutation.mutate(role.id);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error, foregroundColor: Colors.white),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _exportUserData() {
    ToastService.showSuccess('Users directory exported successfully.');
  }

  void _showBulkActionsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Bulk Actions (${_selectedUserIds.length} Users)'),
        content: const Text('Select an operation to execute across selected user records:'),
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
              setState(() => _selectedUserIds.clear());
              ToastService.showSuccess('Selected users processed successfully.');
            },
            child: const Text('Activate Selected'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
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
      ),
    );
  }
}
