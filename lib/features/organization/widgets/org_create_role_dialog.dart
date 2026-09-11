import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../models/organization_models.dart';
import '../models/organization_mock_data.dart';

class OrgCreateRoleDialog extends StatefulWidget {
  final OrganizationRole? roleToEdit;
  final ValueChanged<OrganizationRole> onSave;

  const OrgCreateRoleDialog({
    super.key,
    this.roleToEdit,
    required this.onSave,
  });

  static Future<void> show(
    BuildContext context, {
    OrganizationRole? roleToEdit,
    required ValueChanged<OrganizationRole> onSave,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => OrgCreateRoleDialog(
        roleToEdit: roleToEdit,
        onSave: onSave,
      ),
    );
  }

  @override
  State<OrgCreateRoleDialog> createState() => _OrgCreateRoleDialogState();
}

class _OrgCreateRoleDialogState extends State<OrgCreateRoleDialog> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _codeController;
  late TextEditingController _descController;
  late TextEditingController _reportingController;

  RoleType _roleType = RoleType.custom;
  DepartmentType _deptType = DepartmentType.sales;
  HierarchyLevel _hierarchyLevel = HierarchyLevel.specialist;
  late String _defaultScopeId;
  OrgStatus _status = OrgStatus.active;
  final Set<String> _selectedPermissionIds = {};
  String _permissionSearchQuery = '';

  @override
  void initState() {
    super.initState();
    final r = widget.roleToEdit;
    _nameController = TextEditingController(text: r?.roleTitle ?? '');
    _codeController = TextEditingController(text: r?.roleCode ?? 'ROLE_CUSTOM_${OrganizationMockData.roles.length + 1}');
    _descController = TextEditingController(text: r?.description ?? '');
    _reportingController = TextEditingController(text: r?.reportingToRole ?? 'Department Manager');

    _defaultScopeId = r?.defaultAccessScopeId ?? 'SCOPE-TEAM-WIDE';
    if (r != null) {
      _roleType = r.roleType;
      _deptType = r.departmentType;
      _hierarchyLevel = r.hierarchyLevel;
      _status = r.status;
      _selectedPermissionIds.addAll(r.permissionIds);
    } else {
      // Default common starter permissions
      _selectedPermissionIds.addAll(['crm.leads.view', 'sales.opp.view', 'proj.view']);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    _descController.dispose();
    _reportingController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      final scope = OrganizationMockData.accessScopes.firstWhere(
        (s) => s.id == _defaultScopeId,
        orElse: () => OrganizationMockData.accessScopes.first,
      );

      final role = OrganizationRole(
        id: widget.roleToEdit?.id ?? 'ROLE-${DateTime.now().millisecondsSinceEpoch}',
        roleCode: _codeController.text.trim().toUpperCase(),
        roleTitle: _nameController.text.trim(),
        description: _descController.text.trim(),
        roleType: _roleType,
        departmentType: _deptType,
        hierarchyLevel: _hierarchyLevel,
        reportingToRole: _reportingController.text.trim(),
        userCount: widget.roleToEdit?.userCount ?? 0,
        permissionCount: _selectedPermissionIds.length,
        defaultAccessScopeId: _defaultScopeId,
        defaultAccessScopeName: scope.name,
        status: _status,
        applicableDepartmentIds: widget.roleToEdit?.applicableDepartmentIds ?? [],
        applicableTeamIds: widget.roleToEdit?.applicableTeamIds ?? [],
        permissionIds: Set.from(_selectedPermissionIds),
        responsibilities: widget.roleToEdit?.responsibilities ?? ['Operational task execution'],
        createdDate: widget.roleToEdit?.createdDate ?? DateTime.now(),
        lastUpdated: DateTime.now(),
      );

      widget.onSave(role);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isEdit = widget.roleToEdit != null;

    // Group permissions by Module
    final allPerms = OrganizationMockData.permissions;
    final filteredPerms = allPerms.where((p) {
      if (_permissionSearchQuery.isEmpty) return true;
      final q = _permissionSearchQuery.toLowerCase();
      return p.name.toLowerCase().contains(q) ||
          p.code.toLowerCase().contains(q) ||
          p.feature.toLowerCase().contains(q) ||
          p.module.displayName.toLowerCase().contains(q);
    }).toList();

    final Map<PermissionModule, List<OrganizationPermission>> grouped = {};
    for (final p in filteredPerms) {
      grouped.putIfAbsent(p.module, () => []).add(p);
    }

    final hasHighPrivilege = _selectedPermissionIds.any((p) => p.contains('admin') || p.contains('delete') || p.contains('export'));

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      elevation: 10,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 780, maxHeight: 820),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
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
                          child: Icon(
                            isEdit ? Icons.edit_note_rounded : Icons.admin_panel_settings_outlined,
                            color: AppColors.primary,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isEdit ? 'Edit Role & Capabilities' : 'Create Role Definition',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                              ),
                            ),
                            Text(
                              'Define role metadata, default data visibility, and granular RBAC permissions',
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

                // Content
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionHeader(isDark, '1. ROLE IDENTITY & HIERARCHY'),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              flex: 6,
                              child: _buildTextField(
                                isDark,
                                controller: _nameController,
                                label: 'Role Title *',
                                hint: 'e.g. Senior Turnkey Architect',
                                validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              flex: 4,
                              child: _buildTextField(
                                isDark,
                                controller: _codeController,
                                label: 'Role Code *',
                                hint: 'e.g. SENIOR_ARCH',
                                validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: _buildDropdown<DepartmentType>(
                                isDark,
                                label: 'Primary Department',
                                value: _deptType,
                                items: DepartmentType.values.map((d) {
                                  return DropdownMenuItem(value: d, child: Text(d.displayName));
                                }).toList(),
                                onChanged: (v) => setState(() => _deptType = v!),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildDropdown<HierarchyLevel>(
                                isDark,
                                label: 'Hierarchy Level',
                                value: _hierarchyLevel,
                                items: HierarchyLevel.values.map((l) {
                                  return DropdownMenuItem(value: l, child: Text(l.displayName));
                                }).toList(),
                                onChanged: (v) => setState(() => _hierarchyLevel = v!),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: _buildTextField(
                                isDark,
                                controller: _reportingController,
                                label: 'Reports To (Role)',
                                hint: 'e.g. Head of Design',
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildDropdown<String>(
                                isDark,
                                label: 'Default Access Scope',
                                value: _defaultScopeId,
                                items: OrganizationMockData.accessScopes.map((s) {
                                  return DropdownMenuItem(value: s.id, child: Text(s.name));
                                }).toList(),
                                onChanged: (v) => setState(() => _defaultScopeId = v!),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _buildTextField(
                          isDark,
                          controller: _descController,
                          label: 'Role Description',
                          hint: 'Mandate, authority level, and key outcomes...',
                          maxLines: 2,
                        ),
                        const SizedBox(height: 20),

                        // Section 2: Permission Configuration
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildSectionHeader(isDark, '2. GRANULAR PERMISSIONS REGISTRY (${_selectedPermissionIds.length} SELECTED)'),
                            Row(
                              children: [
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      _selectedPermissionIds.addAll(allPerms.map((p) => p.code));
                                    });
                                  },
                                  child: const Text('Select All', style: TextStyle(fontSize: 12)),
                                ),
                                const SizedBox(width: 4),
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      _selectedPermissionIds.clear();
                                    });
                                  },
                                  child: const Text('Clear All', style: TextStyle(fontSize: 12, color: AppColors.error)),
                                ),
                              ],
                            ),
                          ],
                        ),

                        if (hasHighPrivilege) ...[
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: isDark ? const Color(0xFF78350F).withValues(alpha: 0.25) : const Color(0xFFFFFBEB),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: AppColors.warning.withValues(alpha: 0.4)),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.security_update_warning_rounded, size: 16, color: AppColors.warning),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Privileged Access: Role grants administrative override, data export, or record deletion capabilities.',
                                    style: TextStyle(
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.w500,
                                      color: isDark ? const Color(0xFFFDE68A) : const Color(0xFF92400E),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],

                        const SizedBox(height: 10),

                        // Quick Search Permissions
                        Container(
                          height: 36,
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            children: [
                              Icon(Icons.search_rounded, size: 16, color: isDark ? AppColors.darkSubtext : AppColors.lightTextSecondary),
                              const SizedBox(width: 8),
                              Expanded(
                                child: TextField(
                                  onChanged: (v) => setState(() => _permissionSearchQuery = v.trim()),
                                  style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                                  decoration: InputDecoration(
                                    hintText: 'Filter permissions by module or keyword...',
                                    hintStyle: TextStyle(fontSize: 12, color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted),
                                    border: InputBorder.none,
                                    isDense: true,
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Grouped Permission Modules
                        ...grouped.entries.map((entry) {
                          final mod = entry.key;
                          final perms = entry.value;
                          final allModSelected = perms.every((p) => _selectedPermissionIds.contains(p.code));

                          return Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                              color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                            ),
                            child: Column(
                              children: [
                                // Module Header
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      if (allModSelected) {
                                        _selectedPermissionIds.removeAll(perms.map((p) => p.code));
                                      } else {
                                        _selectedPermissionIds.addAll(perms.map((p) => p.code));
                                      }
                                    });
                                  },
                                  borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                    child: Row(
                                      children: [
                                        Icon(
                                          allModSelected ? Icons.check_box_rounded : Icons.check_box_outline_blank_rounded,
                                          size: 18,
                                          color: allModSelected ? AppColors.primary : (isDark ? AppColors.darkSubtext : AppColors.lightTextSecondary),
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          mod.displayName,
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                                          ),
                                        ),
                                        const Spacer(),
                                        Text(
                                          '${perms.where((p) => _selectedPermissionIds.contains(p.code)).length}/${perms.length}',
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                            color: isDark ? AppColors.darkSubtext : AppColors.lightTextSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const Divider(height: 1),

                                // Actions Grid
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: perms.map((p) {
                                      final isSelected = _selectedPermissionIds.contains(p.code);
                                      return FilterChip(
                                        selected: isSelected,
                                        showCheckmark: true,
                                        label: Text('${p.feature}: ${p.action.displayName}'),
                                        labelStyle: TextStyle(
                                          fontSize: 11,
                                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                          color: isSelected
                                              ? (isDark ? Colors.white : AppColors.primary)
                                              : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                                        ),
                                        backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                                        selectedColor: AppColors.primary.withValues(alpha: 0.2),
                                        side: BorderSide(
                                          color: isSelected ? AppColors.primary : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                                        ),
                                        onSelected: (val) {
                                          setState(() {
                                            if (val) {
                                              _selectedPermissionIds.add(p.code);
                                              // Auto-include dependencies
                                              _selectedPermissionIds.addAll(p.requiredDependencies);
                                            } else {
                                              _selectedPermissionIds.remove(p.code);
                                            }
                                          });
                                        },
                                      );
                                    }).toList(),
                                  ),
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

                // Footer
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        side: BorderSide(
                          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                        ),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: Text(isEdit ? 'Save Role Changes' : 'Create Role Definition'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(bool isDark, String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.bold,
        color: AppColors.primary,
        letterSpacing: 0.6,
      ),
    );
  }

  Widget _buildTextField(
    bool isDark, {
    required TextEditingController controller,
    required String label,
    required String hint,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          validator: validator,
          style: TextStyle(
            fontSize: 13,
            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              fontSize: 12,
              color: isDark ? AppColors.darkSubtext.withValues(alpha: 0.6) : AppColors.lightTextMuted,
            ),
            filled: true,
            fillColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            isDense: true,
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown<T>(
    bool isDark, {
    required String label,
    required T value,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              value: value,
              isExpanded: true,
              items: items,
              onChanged: onChanged,
              style: TextStyle(
                fontSize: 13,
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
              ),
              dropdownColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
            ),
          ),
        ),
      ],
    );
  }
}
