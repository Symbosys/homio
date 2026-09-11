import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../models/organization_models.dart';
import '../models/organization_mock_data.dart';

class OrgCreateAccessScopeDialog extends StatefulWidget {
  final OrganizationAccessScope? scopeToEdit;
  final ValueChanged<OrganizationAccessScope> onSave;

  const OrgCreateAccessScopeDialog({
    super.key,
    this.scopeToEdit,
    required this.onSave,
  });

  static Future<void> show(
    BuildContext context, {
    OrganizationAccessScope? scopeToEdit,
    required ValueChanged<OrganizationAccessScope> onSave,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => OrgCreateAccessScopeDialog(
        scopeToEdit: scopeToEdit,
        onSave: onSave,
      ),
    );
  }

  @override
  State<OrgCreateAccessScopeDialog> createState() => _OrgCreateAccessScopeDialogState();
}

class _OrgCreateAccessScopeDialogState extends State<OrgCreateAccessScopeDialog> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _codeController;
  late TextEditingController _descController;
  late TextEditingController _ownershipRuleController;

  AccessScopeLevel _level = AccessScopeLevel.ownTeam;
  OrgStatus _status = OrgStatus.active;
  final Set<String> _selectedDeptIds = {};
  final Set<String> _selectedTeamIds = {};
  final Set<String> _selectedBranches = {};
  final Set<PermissionModule> _selectedModules = {
    PermissionModule.crm,
    PermissionModule.sales,
    PermissionModule.projects,
  };

  @override
  void initState() {
    super.initState();
    final s = widget.scopeToEdit;
    _nameController = TextEditingController(text: s?.name ?? '');
    _codeController = TextEditingController(text: s?.code ?? 'SCOPE_CUSTOM_${OrganizationMockData.accessScopes.length + 1}');
    _descController = TextEditingController(text: s?.description ?? '');
    _ownershipRuleController = TextEditingController(text: s?.recordOwnershipRule ?? 'Records where TeamId == User.TeamId');

    if (s != null) {
      _level = s.scopeLevel;
      _status = s.status;
      _selectedDeptIds.addAll(s.departmentIds);
      _selectedTeamIds.addAll(s.teamIds);
      _selectedBranches.addAll(s.branches);
      _selectedModules.addAll(s.applicableModules);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    _descController.dispose();
    _ownershipRuleController.dispose();
    super.dispose();
  }

  void _onLevelChanged(AccessScopeLevel newLevel) {
    setState(() {
      _level = newLevel;
      // Auto-populate recommended rule string
      switch (newLevel) {
        case AccessScopeLevel.ownRecords:
          _ownershipRuleController.text = 'Records where CreatedBy == User.Id';
          break;
        case AccessScopeLevel.assignedRecords:
          _ownershipRuleController.text = 'Records where AssignedUserId == User.Id OR Collaborators.contains(User.Id)';
          break;
        case AccessScopeLevel.ownTeam:
          _ownershipRuleController.text = 'Records where TeamId == User.TeamId';
          break;
        case AccessScopeLevel.department:
          _ownershipRuleController.text = 'Records where DepartmentId in User.DepartmentList';
          break;
        case AccessScopeLevel.branch:
          _ownershipRuleController.text = 'Records where BranchLocation in User.PermittedBranches';
          break;
        case AccessScopeLevel.organization:
          _ownershipRuleController.text = 'Global unrestricted read & write access';
          break;
        default:
          _ownershipRuleController.text = 'Custom security boundary rules';
      }
    });
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      final scope = OrganizationAccessScope(
        id: widget.scopeToEdit?.id ?? 'SCOPE-${DateTime.now().millisecondsSinceEpoch}',
        code: _codeController.text.trim().toUpperCase(),
        name: _nameController.text.trim(),
        scopeLevel: _level,
        description: _descController.text.trim().isNotEmpty ? _descController.text.trim() : _level.description,
        status: _status,
        applicableRoleIds: widget.scopeToEdit?.applicableRoleIds ?? [],
        departmentIds: _selectedDeptIds.toList(),
        teamIds: _selectedTeamIds.toList(),
        branches: _selectedBranches.toList(),
        regions: widget.scopeToEdit?.regions ?? ['South Zone'],
        userCount: widget.scopeToEdit?.userCount ?? 0,
        applicableModules: _selectedModules.toList(),
        recordOwnershipRule: _ownershipRuleController.text.trim(),
        createdDate: widget.scopeToEdit?.createdDate ?? DateTime.now(),
        lastUpdated: DateTime.now(),
      );

      widget.onSave(scope);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isEdit = widget.scopeToEdit != null;

    final allDepts = OrganizationMockData.departments;
    final allTeams = OrganizationMockData.teams;
    final allBranches = ['Bangalore Central Hub', 'Indiranagar Hub', 'Whitefield Design Studio', 'Koramangala Hub', 'Hebbal Site Office'];

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      elevation: 10,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 740, maxHeight: 800),
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
                            isEdit ? Icons.edit_note_rounded : Icons.security_outlined,
                            color: AppColors.primary,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isEdit ? 'Edit Access Scope Definition' : 'Define Data Access Scope',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                              ),
                            ),
                            Text(
                              'Dictates which CRM data, branches, teams, or leads the user can operate on',
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

                // Form Scrollable
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionHeader(isDark, '1. BASIC SCOPE CONFIGURATION'),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              flex: 6,
                              child: _buildTextField(
                                isDark,
                                controller: _nameController,
                                label: 'Scope Name *',
                                hint: 'e.g. South Zone Team Scope',
                                validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              flex: 4,
                              child: _buildTextField(
                                isDark,
                                controller: _codeController,
                                label: 'Scope Code *',
                                hint: 'e.g. SCOPE_SZ_TEAM',
                                validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: _buildDropdown<AccessScopeLevel>(
                                isDark,
                                label: 'Scope Visibility Level *',
                                value: _level,
                                items: AccessScopeLevel.values.map((l) {
                                  return DropdownMenuItem(value: l, child: Text(l.displayName));
                                }).toList(),
                                onChanged: (v) => _onLevelChanged(v!),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildDropdown<OrgStatus>(
                                isDark,
                                label: 'Status',
                                value: _status,
                                items: OrgStatus.values.map((s) {
                                  return DropdownMenuItem(value: s, child: Text(s.displayName));
                                }).toList(),
                                onChanged: (v) => setState(() => _status = v!),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _buildTextField(
                          isDark,
                          controller: _descController,
                          label: 'Scope Description',
                          hint: 'Explain what data records this boundary encompasses...',
                          maxLines: 2,
                        ),
                        const SizedBox(height: 20),

                        // Section 2: Contextual Dynamic Boundary Display
                        _buildSectionHeader(isDark, '2. DATA BOUNDARY CONSTRAINTS (${_level.displayName.toUpperCase()})'),
                        const SizedBox(height: 10),

                        // Dynamic Fields based on _level
                        if (_level == AccessScopeLevel.department || _level == AccessScopeLevel.customScope) ...[
                          Text(
                            'Select Applicable Departments',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                          ),
                          const SizedBox(height: 6),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: allDepts.map((d) {
                              final isSelected = _selectedDeptIds.contains(d.id);
                              return FilterChip(
                                selected: isSelected,
                                label: Text(d.name),
                                onSelected: (val) {
                                  setState(() {
                                    if (val) {
                                      _selectedDeptIds.add(d.id);
                                    } else {
                                      _selectedDeptIds.remove(d.id);
                                    }
                                  });
                                },
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 14),
                        ],

                        if (_level == AccessScopeLevel.ownTeam || _level == AccessScopeLevel.customScope) ...[
                          Text(
                            'Select Permitted Squads / Teams',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                          ),
                          const SizedBox(height: 6),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: allTeams.map((t) {
                              final isSelected = _selectedTeamIds.contains(t.id);
                              return FilterChip(
                                selected: isSelected,
                                label: Text('${t.name} (${t.departmentName})'),
                                onSelected: (val) {
                                  setState(() {
                                    if (val) {
                                      _selectedTeamIds.add(t.id);
                                    } else {
                                      _selectedTeamIds.remove(t.id);
                                    }
                                  });
                                },
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 14),
                        ],

                        if (_level == AccessScopeLevel.branch || _level == AccessScopeLevel.customScope) ...[
                          Text(
                            'Select Permitted Branches & Experience Centers',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                          ),
                          const SizedBox(height: 6),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: allBranches.map((b) {
                              final isSelected = _selectedBranches.contains(b);
                              return FilterChip(
                                selected: isSelected,
                                label: Text(b),
                                onSelected: (val) {
                                  setState(() {
                                    if (val) {
                                      _selectedBranches.add(b);
                                    } else {
                                      _selectedBranches.remove(b);
                                    }
                                  });
                                },
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 14),
                        ],

                        _buildTextField(
                          isDark,
                          controller: _ownershipRuleController,
                          label: 'Record Ownership Filter Rule',
                          hint: 'e.g. Records where TeamId == User.TeamId',
                        ),
                        const SizedBox(height: 20),

                        // Section 3: Applicable Modules
                        _buildSectionHeader(isDark, '3. APPLICABLE CRM MODULES'),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: PermissionModule.values.map((mod) {
                            final isSelected = _selectedModules.contains(mod);
                            return FilterChip(
                              selected: isSelected,
                              showCheckmark: true,
                              label: Text(mod.displayName),
                              labelStyle: TextStyle(
                                fontSize: 11,
                                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                color: isSelected
                                    ? (isDark ? Colors.white : AppColors.primary)
                                    : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                              ),
                              backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
                              selectedColor: AppColors.primary.withValues(alpha: 0.2),
                              side: BorderSide(
                                color: isSelected ? AppColors.primary : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                              ),
                              onSelected: (val) {
                                setState(() {
                                  if (val) {
                                    _selectedModules.add(mod);
                                  } else {
                                    _selectedModules.remove(mod);
                                  }
                                });
                              },
                            );
                          }).toList(),
                        ),
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
                      child: Text(isEdit ? 'Save Changes' : 'Create Access Scope'),
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
