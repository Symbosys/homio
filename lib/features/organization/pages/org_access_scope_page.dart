import 'package:flutter/material.dart';
import '../../../core/responsive/breakpoints.dart';
import '../../../core/theme/app_colors.dart';
import '../models/organization_models.dart';
import '../models/organization_mock_data.dart';

class OrgAccessScopePage extends StatefulWidget {
  const OrgAccessScopePage({super.key});

  @override
  State<OrgAccessScopePage> createState() => _OrgAccessScopePageState();
}

class _OrgAccessScopePageState extends State<OrgAccessScopePage> {
  late RoleDefinition _selectedRole;
  final List<RoleDefinition> _roles = OrganizationMockData.roles;
  late Map<String, List<ModulePermission>> _rolePermissionsMap;
  String _searchQuery = '';
  bool _seniorOverrideEnabled = false;

  @override
  void initState() {
    super.initState();
    _selectedRole = _roles.firstWhere(
      (r) => r.id == 'ROLE-SALES-04', // Default to Junior Telecaller to showcase Field Isolation
      orElse: () => _roles.first,
    );

    // Initialize deep clone of permissions for each role
    _rolePermissionsMap = {};
    for (final role in _roles) {
      _rolePermissionsMap[role.id] = OrganizationMockData.permissions.map((p) {
        // Adjust permissions based on role hierarchy
        final isJunior = role.hierarchyLevel == HierarchyLevel.junior;
        final isSpecialist = role.hierarchyLevel == HierarchyLevel.specialist;
        final isManager = role.hierarchyLevel == HierarchyLevel.manager;
        final isLead = role.hierarchyLevel == HierarchyLevel.lead;

        // Customise initial state based on module and role
        bool matchesDept = false;
        if (role.departmentType == DepartmentType.sales && p.moduleCode == 'MOD-SALES') matchesDept = true;
        if (role.departmentType == DepartmentType.design && p.moduleCode == 'MOD-DESIGN') matchesDept = true;
        if (role.departmentType == DepartmentType.execution && p.moduleCode == 'MOD-EXEC') matchesDept = true;
        if (role.departmentType == DepartmentType.afterSales && p.moduleCode == 'MOD-AFTER-SALES') matchesDept = true;
        if (role.departmentType == DepartmentType.sales && p.moduleCode == 'MOD-QUOTATION') matchesDept = true;

        final canView = isLead || isManager || matchesDept || p.moduleCode == 'MOD-HRMS';
        final canCreate = (isLead || isManager || matchesDept) && p.moduleCode != 'MOD-HRMS';
        final canEdit = (isLead || isManager || matchesDept) && p.moduleCode != 'MOD-HRMS';
        final canDelete = isLead;
        final canExport = isLead || isManager;
        final canApprove = isLead || (isManager && matchesDept);
        final fieldIsolated = isJunior || (isSpecialist && p.moduleCode != 'MOD-HRMS');

        return p.copyWith(
          canView: canView,
          canCreate: canCreate,
          canEdit: canEdit,
          canDelete: canDelete,
          canExport: canExport,
          canApprove: canApprove,
          isFieldIsolated: fieldIsolated,
        );
      }).toList();
    }
  }

  List<ModulePermission> get _currentPermissions {
    final list = _rolePermissionsMap[_selectedRole.id] ?? [];
    if (_searchQuery.isEmpty) return list;
    final query = _searchQuery.toLowerCase();
    return list.where((p) =>
      p.moduleName.toLowerCase().contains(query) ||
      p.moduleCode.toLowerCase().contains(query) ||
      p.description.toLowerCase().contains(query),
    ).toList();
  }

  void _togglePermission(int index, String field) {
    setState(() {
      final currentList = _rolePermissionsMap[_selectedRole.id]!;
      final perm = currentList[index];
      ModulePermission updated;

      switch (field) {
        case 'view':
          updated = perm.copyWith(canView: !perm.canView);
          break;
        case 'create':
          updated = perm.copyWith(canCreate: !perm.canCreate);
          break;
        case 'edit':
          updated = perm.copyWith(canEdit: !perm.canEdit);
          break;
        case 'delete':
          updated = perm.copyWith(canDelete: !perm.canDelete);
          break;
        case 'export':
          updated = perm.copyWith(canExport: !perm.canExport);
          break;
        case 'approve':
          updated = perm.copyWith(canApprove: !perm.canApprove);
          break;
        case 'fieldIsolation':
          updated = perm.copyWith(isFieldIsolated: !perm.isFieldIsolated);
          break;
        default:
          return;
      }

      currentList[index] = updated;
    });
  }

  void _savePolicy() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.verified_user_rounded, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'RBAC Access Policy updated for ${_selectedRole.roleTitle}. Changes propagated to active session tokens.',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF0F9D58),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width >= Breakpoints.medium;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isDesktop ? 24 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(isDark, isDesktop),
            const SizedBox(height: 20),
            _buildSecuritySummaryCards(isDark, width),
            const SizedBox(height: 24),
            _buildRoleSelectorCard(isDark, isDesktop),
            const SizedBox(height: 24),
            _buildScopeBanner(isDark, isDesktop),
            const SizedBox(height: 24),
            _buildSearchAndActionsBar(isDark, isDesktop),
            const SizedBox(height: 16),
            isDesktop
                ? _buildPermissionsTable(isDark)
                : _buildPermissionsMobileCards(isDark),
            const SizedBox(height: 32),
            _buildSeniorOverrideCard(isDark, isDesktop),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDark, bool isDesktop) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.gold.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.gold.withValues(alpha: 0.3)),
                  ),
                  child: const Icon(Icons.shield_outlined, color: AppColors.gold, size: 22),
                ),
                const SizedBox(width: 14),
                Text(
                  'Scoped Access & Field Isolation Controls',
                  style: TextStyle(
                    fontSize: isDesktop ? 24 : 20,
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppColors.pureWhite : AppColors.deepNavy,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              'PRD Section 3.1 & 6.3: Strict field isolation (My Leads/Tasks) for Junior Staff vs Organization-Wide Access for PMs.',
              style: TextStyle(
                fontSize: 13,
                color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted,
              ),
            ),
          ],
        ),
        ElevatedButton.icon(
          onPressed: _savePolicy,
          icon: const Icon(Icons.save_rounded, size: 16),
          label: const Text('Apply RBAC Policy'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.gold,
            foregroundColor: AppColors.deepNavy,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
          ),
        ),
      ],
    );
  }

  Widget _buildSecuritySummaryCards(bool isDark, double width) {
    final isDesktop = width >= Breakpoints.medium;

    final cards = [
      _buildMetricCard(
        title: 'Selected Role',
        value: _selectedRole.roleTitle,
        subtitle: 'Hierarchy: ${_selectedRole.hierarchyLevel.name.toUpperCase()}',
        icon: Icons.badge_outlined,
        accentColor: AppColors.gold,
        isDark: isDark,
      ),
      _buildMetricCard(
        title: 'Isolation Scope',
        value: _selectedRole.defaultScope == AccessScope.myLeadsTasks ? 'Strict Field Isolation' : 'Organization-Wide',
        subtitle: _selectedRole.defaultScope == AccessScope.myLeadsTasks
            ? 'MY_LEADS_TASKS (Enforced)'
            : 'ORG_LEADS_TASKS (Executive)',
        icon: _selectedRole.defaultScope == AccessScope.myLeadsTasks
            ? Icons.lock_outline_rounded
            : Icons.public_rounded,
        accentColor: _selectedRole.defaultScope == AccessScope.myLeadsTasks
            ? const Color(0xFFEF4444)
            : const Color(0xFF10B981),
        isDark: isDark,
      ),
      _buildMetricCard(
        title: 'Active Modules',
        value: '${_currentPermissions.where((p) => p.canView).length} of ${_currentPermissions.length}',
        subtitle: 'Accessible with active session token',
        icon: Icons.apps_rounded,
        accentColor: const Color(0xFF3B82F6),
        isDark: isDark,
      ),
      _buildMetricCard(
        title: 'Lead Override',
        value: _seniorOverrideEnabled ? 'ACTIVE' : 'STANDBY',
        subtitle: 'Supervisor permission elevation',
        icon: Icons.supervisor_account_rounded,
        accentColor: const Color(0xFFF59E0B),
        isDark: isDark,
      ),
    ];

    if (isDesktop) {
      return Row(
        children: cards.map((c) => Expanded(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 6), child: c))).toList(),
      );
    } else {
      return Wrap(
        spacing: 12,
        runSpacing: 12,
        children: cards.map((c) => SizedBox(width: (width - 44) / 2, child: c)).toList(),
      );
    }
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color accentColor,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCardBg : AppColors.pureWhite,
        borderRadius: BorderRadius.circular(14),
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
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: accentColor, size: 16),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: isDark ? AppColors.pureWhite : AppColors.deepNavy,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildRoleSelectorCard(bool isDark, bool isDesktop) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCardBg : AppColors.pureWhite,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.manage_accounts_rounded, color: AppColors.gold, size: 20),
              const SizedBox(width: 10),
              Text(
                'Configure Permissions by Role Profile',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.pureWhite : AppColors.deepNavy,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Select a team role to inspect and tune its granular view, edit, delete, export, and field-isolation constraints.',
            style: TextStyle(
              fontSize: 12,
              color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted,
            ),
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _roles.map((role) {
                final isSelected = role.id == _selectedRole.id;
                final isJunior = role.hierarchyLevel == HierarchyLevel.junior;

                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    selected: isSelected,
                    showCheckmark: false,
                    avatar: Icon(
                      isJunior ? Icons.person_pin_circle_outlined : Icons.verified_user_outlined,
                      size: 16,
                      color: isSelected
                          ? AppColors.deepNavy
                          : (isJunior ? const Color(0xFFEF4444) : AppColors.gold),
                    ),
                    label: Text('${role.roleTitle} (${role.departmentType.name.toUpperCase()})'),
                    labelStyle: TextStyle(
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: isSelected
                          ? AppColors.deepNavy
                          : (isDark ? AppColors.pureWhite : AppColors.deepNavy),
                    ),
                    backgroundColor: isDark ? AppColors.darkCardBg : const Color(0xFFF1F5F9),
                    selectedColor: AppColors.gold,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(
                        color: isSelected
                            ? AppColors.gold
                            : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                      ),
                    ),
                    onSelected: (val) {
                      if (val) {
                        setState(() {
                          _selectedRole = role;
                        });
                      }
                    },
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScopeBanner(bool isDark, bool isDesktop) {
    final isFieldIsolated = _selectedRole.defaultScope == AccessScope.myLeadsTasks;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isFieldIsolated
            ? const Color(0xFFEF4444).withValues(alpha: isDark ? 0.12 : 0.08)
            : const Color(0xFF10B981).withValues(alpha: isDark ? 0.12 : 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isFieldIsolated
              ? const Color(0xFFEF4444).withValues(alpha: 0.3)
              : const Color(0xFF10B981).withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: (isFieldIsolated ? const Color(0xFFEF4444) : const Color(0xFF10B981))
                  .withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isFieldIsolated ? Icons.security_rounded : Icons.domain_verification_rounded,
              color: isFieldIsolated ? const Color(0xFFEF4444) : const Color(0xFF10B981),
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      isFieldIsolated
                          ? 'STRICT FIELD ISOLATION ACTIVE: MY_LEADS_TASKS'
                          : 'ORGANIZATION-WIDE ACCESS: ORG_LEADS_TASKS',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: isFieldIsolated ? const Color(0xFFEF4444) : const Color(0xFF10B981),
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: (isFieldIsolated ? const Color(0xFFEF4444) : const Color(0xFF10B981))
                            .withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        _selectedRole.hierarchyLevel.name.toUpperCase(),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: isFieldIsolated ? const Color(0xFFEF4444) : const Color(0xFF10B981),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  isFieldIsolated
                      ? 'Users assigned to "${_selectedRole.roleTitle}" can ONLY view and edit records where assignedUserId == currentUserId. Cross-team client records, budgets, and unassigned leads are hidden by row-level database filters.'
                      : 'Users assigned to "${_selectedRole.roleTitle}" have full organization-wide visibility across all projects, client accounts, contractor BOQs, and departmental performance ledgers.',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndActionsBar(bool isDark, bool isDesktop) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 44,
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCardBg : AppColors.pureWhite,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              ),
            ),
            child: TextField(
              onChanged: (val) => setState(() => _searchQuery = val),
              style: TextStyle(
                fontSize: 13,
                color: isDark ? AppColors.pureWhite : AppColors.deepNavy,
              ),
              decoration: InputDecoration(
                hintText: 'Search modules by name or code...',
                hintStyle: TextStyle(
                  fontSize: 13,
                  color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted,
                ),
                prefixIcon: Icon(
                  Icons.search_rounded,
                  size: 18,
                  color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        OutlinedButton.icon(
          onPressed: () {
            // Reset to defaults
            setState(() {
              _searchQuery = '';
            });
          },
          icon: const Icon(Icons.refresh_rounded, size: 16),
          label: const Text('Reset Defaults'),
          style: OutlinedButton.styleFrom(
            foregroundColor: isDark ? AppColors.pureWhite : AppColors.deepNavy,
            side: BorderSide(
              color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
          ),
        ),
      ],
    );
  }

  Widget _buildPermissionsTable(bool isDark) {
    final permissions = _currentPermissions;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCardBg : AppColors.pureWhite,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        children: [
          // Table Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
              border: Border(
                bottom: BorderSide(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    'MODULE / DOMAIN',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted,
                    ),
                  ),
                ),
                _buildColumnHeader('VIEW', isDark),
                _buildColumnHeader('CREATE', isDark),
                _buildColumnHeader('EDIT', isDark),
                _buildColumnHeader('DELETE', isDark),
                _buildColumnHeader('EXPORT', isDark),
                _buildColumnHeader('APPROVE', isDark),
                Expanded(
                  flex: 2,
                  child: Text(
                    'FIELD ISOLATION',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Table Rows
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: permissions.length,
            separatorBuilder: (_, _) => Divider(
              height: 1,
              color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
            ),
            itemBuilder: (context, index) {
              final perm = permissions[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                child: Row(
                  children: [
                    // Module description
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                perm.moduleName,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: isDark ? AppColors.pureWhite : AppColors.deepNavy,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.gold.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  perm.moduleCode,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.gold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            perm.description,
                            style: TextStyle(
                              fontSize: 11,
                              color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Checkbox actions
                    _buildPermissionToggle(perm.canView, () => _togglePermission(index, 'view'), isDark),
                    _buildPermissionToggle(perm.canCreate, () => _togglePermission(index, 'create'), isDark),
                    _buildPermissionToggle(perm.canEdit, () => _togglePermission(index, 'edit'), isDark),
                    _buildPermissionToggle(perm.canDelete, () => _togglePermission(index, 'delete'), isDark, activeColor: const Color(0xFFEF4444)),
                    _buildPermissionToggle(perm.canExport, () => _togglePermission(index, 'export'), isDark),
                    _buildPermissionToggle(perm.canApprove, () => _togglePermission(index, 'approve'), isDark, activeColor: const Color(0xFF10B981)),

                    // Field Isolation switch
                    Expanded(
                      flex: 2,
                      child: Center(
                        child: Switch(
                          value: perm.isFieldIsolated,
                          activeThumbColor: const Color(0xFFEF4444),
                          activeTrackColor: const Color(0xFFEF4444).withValues(alpha: 0.3),
                          onChanged: (_) => _togglePermission(index, 'fieldIsolation'),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildColumnHeader(String title, bool isDark) {
    return Expanded(
      flex: 1,
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted,
        ),
      ),
    );
  }

  Widget _buildPermissionToggle(bool isActive, VoidCallback onToggle, bool isDark, {Color activeColor = AppColors.gold}) {
    return Expanded(
      flex: 1,
      child: Center(
        child: InkWell(
          onTap: onToggle,
          borderRadius: BorderRadius.circular(6),
          child: Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: isActive ? activeColor.withValues(alpha: 0.15) : Colors.transparent,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: isActive ? activeColor : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                width: 1.5,
              ),
            ),
            child: isActive
                ? Icon(Icons.check_rounded, size: 18, color: activeColor)
                : null,
          ),
        ),
      ),
    );
  }

  Widget _buildPermissionsMobileCards(bool isDark) {
    final permissions = _currentPermissions;

    return Column(
      children: permissions.asMap().entries.map((entry) {
        final index = entry.key;
        final perm = entry.value;

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCardBg : AppColors.pureWhite,
            borderRadius: BorderRadius.circular(14),
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
                  Expanded(
                    child: Text(
                      perm.moduleName,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.pureWhite : AppColors.deepNavy,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.gold.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      perm.moduleCode,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: AppColors.gold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                perm.description,
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted,
                ),
              ),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Field Isolation (My Leads / Tasks Only)',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: perm.isFieldIsolated ? const Color(0xFFEF4444) : (isDark ? AppColors.pureWhite : AppColors.deepNavy),
                    ),
                  ),
                  Switch(
                    value: perm.isFieldIsolated,
                    activeThumbColor: const Color(0xFFEF4444),
                    activeTrackColor: const Color(0xFFEF4444).withValues(alpha: 0.3),
                    onChanged: (_) => _togglePermission(index, 'fieldIsolation'),
                  ),
                ],
              ),
              const Divider(height: 20),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildMobilePermChip('View', perm.canView, () => _togglePermission(index, 'view'), isDark),
                  _buildMobilePermChip('Create', perm.canCreate, () => _togglePermission(index, 'create'), isDark),
                  _buildMobilePermChip('Edit', perm.canEdit, () => _togglePermission(index, 'edit'), isDark),
                  _buildMobilePermChip('Delete', perm.canDelete, () => _togglePermission(index, 'delete'), isDark, color: const Color(0xFFEF4444)),
                  _buildMobilePermChip('Export', perm.canExport, () => _togglePermission(index, 'export'), isDark),
                  _buildMobilePermChip('Approve', perm.canApprove, () => _togglePermission(index, 'approve'), isDark, color: const Color(0xFF10B981)),
                ],
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildMobilePermChip(String label, bool active, VoidCallback onTap, bool isDark, {Color color = AppColors.gold}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: active ? color.withValues(alpha: 0.15) : (isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9)),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: active ? color : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              active ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
              size: 14,
              color: active ? color : (isDark ? AppColors.darkSubtext : AppColors.lightTextMuted),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                color: active ? color : (isDark ? AppColors.darkSubtext : AppColors.lightTextMuted),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSeniorOverrideCard(bool isDark, bool isDesktop) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCardBg : AppColors.pureWhite,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.gold.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.gold.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.admin_panel_settings_rounded, color: AppColors.gold, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Senior Role Scope Override & Lead Reassignment',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: isDark ? AppColors.pureWhite : AppColors.deepNavy,
                    ),
                  ),
                ],
              ),
              Switch(
                value: _seniorOverrideEnabled,
                activeThumbColor: AppColors.gold,
                activeTrackColor: AppColors.gold.withValues(alpha: 0.3),
                onChanged: (val) {
                  setState(() {
                    _seniorOverrideEnabled = val;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'When active, Leads and Managers (e.g. Sales Head, Project Manager, Service Manager) can temporarily bypass Junior field isolation boundaries to reassign stuck consultation leads or takeover delayed site milestones without database permission schema recompilation.',
            style: TextStyle(
              fontSize: 12,
              color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted,
              height: 1.5,
            ),
          ),
          if (_seniorOverrideEnabled) ...[
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.gold.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.gold.withValues(alpha: 0.2)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline_rounded, color: AppColors.gold, size: 18),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Override Session Audit Log: Supervisor emergency overrides are logged with SHA-256 tamper-proof timestamps.',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppColors.pureWhite : AppColors.deepNavy,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
