import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../models/organization_models.dart';
import '../models/organization_mock_data.dart';

class OrgCreateTeamDialog extends StatefulWidget {
  final OrganizationTeam? teamToEdit;
  final ValueChanged<OrganizationTeam> onSave;

  const OrgCreateTeamDialog({
    super.key,
    this.teamToEdit,
    required this.onSave,
  });

  static Future<void> show(
    BuildContext context, {
    OrganizationTeam? teamToEdit,
    required ValueChanged<OrganizationTeam> onSave,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => OrgCreateTeamDialog(
        teamToEdit: teamToEdit,
        onSave: onSave,
      ),
    );
  }

  @override
  State<OrgCreateTeamDialog> createState() => _OrgCreateTeamDialogState();
}

class _OrgCreateTeamDialogState extends State<OrgCreateTeamDialog> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _codeController;
  late TextEditingController _descController;
  late TextEditingController _teamLeadController;
  late TextEditingController _teamLeadEmailController;
  late TextEditingController _managerController;
  late TextEditingController _managerEmailController;
  late TextEditingController _branchController;
  late TextEditingController _typeController;
  late TextEditingController _maxSizeController;

  late String _selectedDepartmentId;
  String? _selectedParentTeamId;
  String _selectedScopeId = 'SCOPE-TEAM-WIDE';
  OrgStatus _status = OrgStatus.active;

  @override
  void initState() {
    super.initState();
    final t = widget.teamToEdit;
    _nameController = TextEditingController(text: t?.name ?? '');
    _codeController = TextEditingController(text: t?.code ?? 'TM-NEW-0${OrganizationMockData.teams.length + 1}');
    _descController = TextEditingController(text: t?.description ?? '');
    _teamLeadController = TextEditingController(text: t?.teamLead ?? '');
    _teamLeadEmailController = TextEditingController(text: t?.teamLeadEmail ?? '');
    _managerController = TextEditingController(text: t?.manager ?? '');
    _managerEmailController = TextEditingController(text: t?.managerEmail ?? '');
    _branchController = TextEditingController(text: t?.branch ?? 'Bangalore Central Hub');
    _typeController = TextEditingController(text: t?.teamType ?? 'Operational Squad');
    _maxSizeController = TextEditingController(text: t?.maxTeamSize.toString() ?? '15');

    _selectedDepartmentId = t?.departmentId ?? OrganizationMockData.departments.first.id;
    _selectedParentTeamId = t?.parentTeamId;
    _selectedScopeId = t?.defaultAccessScopeId ?? 'SCOPE-TEAM-WIDE';
    if (t != null) {
      _status = t.status;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    _descController.dispose();
    _teamLeadController.dispose();
    _teamLeadEmailController.dispose();
    _managerController.dispose();
    _managerEmailController.dispose();
    _branchController.dispose();
    _typeController.dispose();
    _maxSizeController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      final dept = OrganizationMockData.departments.firstWhere(
        (d) => d.id == _selectedDepartmentId,
        orElse: () => OrganizationMockData.departments.first,
      );

      final team = OrganizationTeam(
        id: widget.teamToEdit?.id ?? 'TEAM-${DateTime.now().millisecondsSinceEpoch}',
        code: _codeController.text.trim(),
        name: _nameController.text.trim(),
        departmentId: _selectedDepartmentId,
        departmentName: dept.name,
        parentTeamId: _selectedParentTeamId,
        teamLead: _teamLeadController.text.trim(),
        teamLeadEmail: _teamLeadEmailController.text.trim(),
        manager: _managerController.text.trim(),
        managerEmail: _managerEmailController.text.trim(),
        memberCount: widget.teamToEdit?.memberCount ?? 1,
        status: _status,
        branch: _branchController.text.trim(),
        teamType: _typeController.text.trim(),
        maxTeamSize: int.tryParse(_maxSizeController.text) ?? 15,
        defaultAccessScopeId: _selectedScopeId,
        description: _descController.text.trim(),
        createdDate: widget.teamToEdit?.createdDate ?? DateTime.now(),
        lastUpdated: DateTime.now(),
      );

      widget.onSave(team);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isEdit = widget.teamToEdit != null;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      elevation: 10,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 700, maxHeight: 720),
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
                            isEdit ? Icons.edit_note_rounded : Icons.group_add_rounded,
                            color: AppColors.primary,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isEdit ? 'Edit Operational Team' : 'Create Operational Team',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                              ),
                            ),
                            Text(
                              'Squad grouping under departments with designated leadership',
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
                        _buildSectionHeader(isDark, '1. BASIC SQUAD INFORMATION'),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              flex: 6,
                              child: _buildTextField(
                                isDark,
                                controller: _nameController,
                                label: 'Team Name *',
                                hint: 'e.g. Turnkey Civil Squad - East Hub',
                                validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              flex: 4,
                              child: _buildTextField(
                                isDark,
                                controller: _codeController,
                                label: 'Team Code *',
                                hint: 'e.g. TM-EXEC-02',
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
                                controller: _typeController,
                                label: 'Team Type / Focus',
                                hint: 'e.g. Site Supervision, Inbound Closing',
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
                          label: 'Team Description & Responsibilities',
                          hint: 'Operational mandate and deliverables...',
                          maxLines: 2,
                        ),
                        const SizedBox(height: 20),

                        _buildSectionHeader(isDark, '2. DEPARTMENT & LOCATION ASSIGNMENT'),
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
                                onChanged: (v) => setState(() => _selectedDepartmentId = v!),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildTextField(
                                isDark,
                                controller: _branchController,
                                label: 'Branch / Hub Location',
                                hint: 'e.g. Indiranagar Hub',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        _buildSectionHeader(isDark, '3. LEADERSHIP & MANAGEMENT'),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: _buildTextField(
                                isDark,
                                controller: _teamLeadController,
                                label: 'Team Lead Name *',
                                hint: 'e.g. Manoj Kumar',
                                validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildTextField(
                                isDark,
                                controller: _teamLeadEmailController,
                                label: 'Team Lead Email',
                                hint: 'lead@homio.in',
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
                                controller: _managerController,
                                label: 'Reporting Manager',
                                hint: 'e.g. Rajesh Verma',
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildTextField(
                                isDark,
                                controller: _managerEmailController,
                                label: 'Manager Email',
                                hint: 'mgr@homio.in',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        _buildSectionHeader(isDark, '4. CONSTRAINTS & DEFAULT ACCESS SCOPE'),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: _buildTextField(
                                isDark,
                                controller: _maxSizeController,
                                label: 'Maximum Team Capacity',
                                hint: '15',
                                keyboardType: TextInputType.number,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildDropdown<String>(
                                isDark,
                                label: 'Default Member Scope',
                                value: _selectedScopeId,
                                items: OrganizationMockData.accessScopes.map((s) {
                                  return DropdownMenuItem(value: s.id, child: Text(s.name));
                                }).toList(),
                                onChanged: (v) => setState(() => _selectedScopeId = v!),
                              ),
                            ),
                          ],
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
                      child: Text(isEdit ? 'Save Changes' : 'Create Team'),
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
      style: TextStyle(
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
    TextInputType keyboardType = TextInputType.text,
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
          keyboardType: keyboardType,
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
