import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../app/router/route_names.dart';
import '../models/organization_models.dart';
import '../models/organization_mock_data.dart';
import 'org_confirmation_dialog.dart';

class OrgEditEmployeeAssignmentDialog extends StatefulWidget {
  final OrganizationEmployee employee;
  final ValueChanged<OrganizationEmployee> onSave;

  const OrgEditEmployeeAssignmentDialog({
    super.key,
    required this.employee,
    required this.onSave,
  });

  static Future<void> show(
    BuildContext context, {
    required OrganizationEmployee employee,
    required ValueChanged<OrganizationEmployee> onSave,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => OrgEditEmployeeAssignmentDialog(
        employee: employee,
        onSave: onSave,
      ),
    );
  }

  @override
  State<OrgEditEmployeeAssignmentDialog> createState() => _OrgEditEmployeeAssignmentDialogState();
}

class _OrgEditEmployeeAssignmentDialogState extends State<OrgEditEmployeeAssignmentDialog> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _jobTitleController;
  late TextEditingController _branchController;
  late TextEditingController _businessUnitController;

  late String _selectedDepartmentId;
  String? _selectedTeamId;
  String? _selectedManagerId;
  late String _selectedRoleId;
  late String _selectedScopeId;
  late AccountStatus _selectedAccountStatus;

  @override
  void initState() {
    super.initState();
    final e = widget.employee;
    _jobTitleController = TextEditingController(text: e.jobTitle);
    _branchController = TextEditingController(text: e.branch);
    _businessUnitController = TextEditingController(text: e.businessUnit);

    _selectedDepartmentId = e.departmentId;
    _selectedTeamId = e.teamId;
    _selectedManagerId = e.managerId;
    _selectedRoleId = e.roleId;
    _selectedScopeId = e.accessScopeId;
    _selectedAccountStatus = e.accountStatus;
  }

  @override
  void dispose() {
    _jobTitleController.dispose();
    _branchController.dispose();
    _businessUnitController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_formKey.currentState?.validate() ?? false) {
      // Safety confirmation if suspending or deactivating
      if ((_selectedAccountStatus == AccountStatus.suspended || _selectedAccountStatus == AccountStatus.deactivated) &&
          _selectedAccountStatus != widget.employee.accountStatus) {
        final confirmed = await OrgConfirmationDialog.show(
          context,
          title: 'Confirm Account ${_selectedAccountStatus.displayName}',
          message: 'Are you sure you want to change the account status for ${widget.employee.name}?',
          consequenceWarning:
              'The employee will immediately lose login access to Homio CRM, active autodialer sessions, and lead notifications.',
          confirmLabel: 'Confirm ${_selectedAccountStatus.displayName}',
          isDestructive: true,
        );
        if (confirmed != true) return;
      }

      final dept = OrganizationMockData.departments.firstWhere(
        (d) => d.id == _selectedDepartmentId,
        orElse: () => OrganizationMockData.departments.first,
      );

      String? teamName;
      if (_selectedTeamId != null) {
        final team = OrganizationMockData.teams.firstWhere(
          (t) => t.id == _selectedTeamId,
          orElse: () => OrganizationMockData.teams.first,
        );
        teamName = team.name;
      }

      String? managerName;
      if (_selectedManagerId != null) {
        final mgr = OrganizationMockData.employees.firstWhere(
          (m) => m.id == _selectedManagerId,
          orElse: () => widget.employee,
        );
        managerName = mgr.name;
      }

      final role = OrganizationMockData.roles.firstWhere(
        (r) => r.id == _selectedRoleId,
        orElse: () => OrganizationMockData.roles.first,
      );

      final scope = OrganizationMockData.accessScopes.firstWhere(
        (s) => s.id == _selectedScopeId,
        orElse: () => OrganizationMockData.accessScopes.first,
      );

      final updated = widget.employee.copyWith(
        jobTitle: _jobTitleController.text.trim(),
        departmentId: _selectedDepartmentId,
        departmentName: dept.name,
        teamId: _selectedTeamId,
        teamName: teamName,
        managerId: _selectedManagerId,
        managerName: managerName,
        roleId: _selectedRoleId,
        roleTitle: role.roleTitle,
        roleType: role.roleType,
        accessScopeId: _selectedScopeId,
        accessScopeName: scope.name,
        accountStatus: _selectedAccountStatus,
        branch: _branchController.text.trim(),
        businessUnit: _businessUnitController.text.trim(),
      );

      widget.onSave(updated);
      if (mounted) Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final emp = widget.employee;

    final availableTeams = OrganizationMockData.teams.where((t) => t.departmentId == _selectedDepartmentId).toList();
    final availableManagers = OrganizationMockData.employees.where((e) => e.id != emp.id).toList();

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      elevation: 10,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 680, maxHeight: 720),
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
                        CircleAvatar(
                          radius: 20,
                          backgroundImage: NetworkImage(emp.avatarUrl),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Edit Organizational Assignment',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                              ),
                            ),
                            Text(
                              '${emp.name} • ID: ${emp.employeeId}',
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
                const SizedBox(height: 14),

                // HR Quick Link Info Banner
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline_rounded, size: 16, color: AppColors.primary),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Personal records, payroll, leave & documents are managed in HRMS.',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                          ),
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () {
                          Navigator.of(context).pop();
                          context.go(RouteNames.hrmsEmployees);
                        },
                        icon: const Icon(Icons.open_in_new_rounded, size: 14),
                        label: const Text('View HR Profile', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          visualDensity: VisualDensity.compact,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),
                const Divider(height: 1),
                const SizedBox(height: 14),

                // Form Fields
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionHeader(isDark, '1. DEPARTMENT & TEAM PLACEMENT'),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: _buildDropdown<String>(
                                isDark,
                                label: 'Department *',
                                value: _selectedDepartmentId,
                                items: OrganizationMockData.departments.map((d) {
                                  return DropdownMenuItem(value: d.id, child: Text(d.name));
                                }).toList(),
                                onChanged: (v) {
                                  setState(() {
                                    _selectedDepartmentId = v!;
                                    _selectedTeamId = null;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildDropdown<String?>(
                                isDark,
                                label: 'Assigned Squad / Team',
                                value: _selectedTeamId,
                                items: [
                                  const DropdownMenuItem(value: null, child: Text('No Squad (Department Level)')),
                                  ...availableTeams.map((t) => DropdownMenuItem(value: t.id, child: Text(t.name))),
                                ],
                                onChanged: (v) => setState(() => _selectedTeamId = v),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: _buildDropdown<String?>(
                                isDark,
                                label: 'Direct Reporting Manager',
                                value: _selectedManagerId,
                                items: [
                                  const DropdownMenuItem(value: null, child: Text('None (Reports to Board)')),
                                  ...availableManagers.map((m) => DropdownMenuItem(value: m.id, child: Text('${m.name} (${m.jobTitle})'))),
                                ],
                                onChanged: (v) => setState(() => _selectedManagerId = v),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildTextField(
                                isDark,
                                controller: _jobTitleController,
                                label: 'Job Title / Designation *',
                                hint: 'e.g. Senior Turnkey Closer',
                                validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
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
                                controller: _branchController,
                                label: 'Branch / Hub Location',
                                hint: 'e.g. Indiranagar Hub',
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildTextField(
                                isDark,
                                controller: _businessUnitController,
                                label: 'Business Unit',
                                hint: 'e.g. Turnkey Residential',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        _buildSectionHeader(isDark, '2. SYSTEM ACCESS & SECURITY GOVERNANCE'),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: _buildDropdown<String>(
                                isDark,
                                label: 'Assigned System Role *',
                                value: _selectedRoleId,
                                items: OrganizationMockData.roles.map((r) {
                                  return DropdownMenuItem(value: r.id, child: Text('${r.roleTitle} (${r.roleType.displayName})'));
                                }).toList(),
                                onChanged: (v) => setState(() => _selectedRoleId = v!),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildDropdown<String>(
                                isDark,
                                label: 'Data Access Scope *',
                                value: _selectedScopeId,
                                items: OrganizationMockData.accessScopes.map((s) {
                                  return DropdownMenuItem(value: s.id, child: Text('${s.name} (${s.scopeLevel.displayName})'));
                                }).toList(),
                                onChanged: (v) => setState(() => _selectedScopeId = v!),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        _buildDropdown<AccountStatus>(
                          isDark,
                          label: 'CRM System Account Status',
                          value: _selectedAccountStatus,
                          items: AccountStatus.values.map((s) {
                            return DropdownMenuItem(value: s, child: Text('${s.displayName} Account'));
                          }).toList(),
                          onChanged: (v) => setState(() => _selectedAccountStatus = v!),
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
                      child: const Text('Update Assignment'),
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
