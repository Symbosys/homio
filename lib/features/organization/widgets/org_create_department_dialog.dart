import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../models/organization_models.dart';
import '../models/organization_mock_data.dart';

class OrgCreateDepartmentDialog extends StatefulWidget {
  final OrganizationDepartment? departmentToEdit;
  final ValueChanged<OrganizationDepartment> onSave;

  const OrgCreateDepartmentDialog({
    super.key,
    this.departmentToEdit,
    required this.onSave,
  });

  static Future<void> show(
    BuildContext context, {
    OrganizationDepartment? departmentToEdit,
    required ValueChanged<OrganizationDepartment> onSave,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => OrgCreateDepartmentDialog(
        departmentToEdit: departmentToEdit,
        onSave: onSave,
      ),
    );
  }

  @override
  State<OrgCreateDepartmentDialog> createState() => _OrgCreateDepartmentDialogState();
}

class _OrgCreateDepartmentDialogState extends State<OrgCreateDepartmentDialog> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _codeController;
  late TextEditingController _descController;
  late TextEditingController _headNameController;
  late TextEditingController _headEmailController;
  late TextEditingController _headPhoneController;
  late TextEditingController _deputyHeadController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _branchController;
  late TextEditingController _costCenterController;
  late TextEditingController _budgetController;

  DepartmentType _type = DepartmentType.execution;
  String? _selectedParentId;
  String _selectedScopeId = 'SCOPE-DEPT-WIDE';
  bool _allowTeamCreation = true;
  OrgStatus _status = OrgStatus.active;

  @override
  void initState() {
    super.initState();
    final d = widget.departmentToEdit;
    _nameController = TextEditingController(text: d?.name ?? '');
    _codeController = TextEditingController(text: d?.code ?? 'DEPT-00${OrganizationMockData.departments.length + 1}');
    _descController = TextEditingController(text: d?.description ?? '');
    _headNameController = TextEditingController(text: d?.headOfDepartment ?? '');
    _headEmailController = TextEditingController(text: d?.headEmail ?? '');
    _headPhoneController = TextEditingController(text: d?.headPhone ?? '');
    _deputyHeadController = TextEditingController(text: d?.deputyHead ?? '');
    _emailController = TextEditingController(text: d?.email ?? '');
    _phoneController = TextEditingController(text: d?.phone ?? '');
    _branchController = TextEditingController(text: d?.locationBranch ?? 'Bangalore Central Hub');
    _costCenterController = TextEditingController(text: d?.costCenter ?? 'CC-NEW-100');
    _budgetController = TextEditingController(text: d?.monthlyBudgetPool.toStringAsFixed(0) ?? '1500000');

    if (d != null) {
      _type = d.type;
      _selectedParentId = d.parentDepartmentId;
      _selectedScopeId = d.defaultAccessScopeId;
      _allowTeamCreation = d.allowTeamCreation;
      _status = d.status;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    _descController.dispose();
    _headNameController.dispose();
    _headEmailController.dispose();
    _headPhoneController.dispose();
    _deputyHeadController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _branchController.dispose();
    _costCenterController.dispose();
    _budgetController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      String? parentName;
      if (_selectedParentId != null) {
        final parent = OrganizationMockData.departments.firstWhere(
          (p) => p.id == _selectedParentId,
          orElse: () => OrganizationMockData.departments.first,
        );
        parentName = parent.name;
      }

      final dept = OrganizationDepartment(
        id: widget.departmentToEdit?.id ?? 'DEPT-${DateTime.now().millisecondsSinceEpoch}',
        code: _codeController.text.trim(),
        name: _nameController.text.trim(),
        type: _type,
        parentDepartmentId: _selectedParentId,
        parentDepartmentName: parentName,
        headOfDepartment: _headNameController.text.trim(),
        headEmail: _headEmailController.text.trim(),
        headPhone: _headPhoneController.text.trim(),
        deputyHead: _deputyHeadController.text.trim().isNotEmpty ? _deputyHeadController.text.trim() : null,
        description: _descController.text.trim(),
        teamCount: widget.departmentToEdit?.teamCount ?? 0,
        employeeCount: widget.departmentToEdit?.employeeCount ?? 0,
        status: _status,
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        locationBranch: _branchController.text.trim(),
        costCenter: _costCenterController.text.trim(),
        monthlyBudgetPool: double.tryParse(_budgetController.text) ?? 1500000,
        allowTeamCreation: _allowTeamCreation,
        defaultAccessScopeId: _selectedScopeId,
        coreFunctions: widget.departmentToEdit?.coreFunctions ?? ['Operational Coordination', 'Resource Allocation'],
        createdDate: widget.departmentToEdit?.createdDate ?? DateTime.now(),
        lastUpdated: DateTime.now(),
      );

      widget.onSave(dept);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isEdit = widget.departmentToEdit != null;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      elevation: 10,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 720, maxHeight: 760),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Dialog Header
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
                            isEdit ? Icons.edit_note_rounded : Icons.domain_add_rounded,
                            color: AppColors.primary,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isEdit ? 'Edit Department Structure' : 'Create New Department',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                              ),
                            ),
                            Text(
                              'Define major organizational nodes, hierarchy, leadership & scope',
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

                // Form Fields (Scrollable)
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionHeader(isDark, '1. BASIC INFORMATION'),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              flex: 6,
                              child: _buildTextField(
                                isDark,
                                controller: _nameController,
                                label: 'Department Name *',
                                hint: 'e.g. Luxury Turnkey Execution',
                                validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              flex: 4,
                              child: _buildTextField(
                                isDark,
                                controller: _codeController,
                                label: 'Department Code *',
                                hint: 'e.g. EXEC-002',
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
                                label: 'Department Type',
                                value: _type,
                                items: DepartmentType.values.map((t) {
                                  return DropdownMenuItem(value: t, child: Text(t.displayName));
                                }).toList(),
                                onChanged: (v) => setState(() => _type = v!),
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
                          label: 'Description & Scope of Work',
                          hint: 'Describe key operational responsibilities and business functions',
                          maxLines: 2,
                        ),
                        const SizedBox(height: 20),

                        _buildSectionHeader(isDark, '2. ORGANIZATIONAL STRUCTURE & HIERARCHY'),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: _buildDropdown<String?>(
                                isDark,
                                label: 'Parent Department (Optional)',
                                value: _selectedParentId,
                                items: [
                                  const DropdownMenuItem(value: null, child: Text('None (Top-Level Department)')),
                                  ...OrganizationMockData.departments
                                      .where((d) => d.id != widget.departmentToEdit?.id)
                                      .map((d) => DropdownMenuItem(value: d.id, child: Text(d.name))),
                                ],
                                onChanged: (v) => setState(() => _selectedParentId = v),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildTextField(
                                isDark,
                                controller: _headNameController,
                                label: 'Department Head *',
                                hint: 'e.g. Rajesh Verma',
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
                                controller: _headEmailController,
                                label: 'Head Email',
                                hint: 'head@homio.in',
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildTextField(
                                isDark,
                                controller: _headPhoneController,
                                label: 'Head Phone',
                                hint: '+91 98000 00000',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _buildTextField(
                          isDark,
                          controller: _deputyHeadController,
                          label: 'Deputy / Secondary Head (Optional)',
                          hint: 'e.g. Amit Sharma',
                        ),
                        const SizedBox(height: 20),

                        _buildSectionHeader(isDark, '3. OPERATIONS & CONTACT'),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: _buildTextField(
                                isDark,
                                controller: _emailController,
                                label: 'Official Dept Email',
                                hint: 'dept@homio.in',
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildTextField(
                                isDark,
                                controller: _phoneController,
                                label: 'Dept Desk Phone',
                                hint: '+91 80 4400 0000',
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
                                label: 'Location / Hub',
                                hint: 'e.g. Bangalore Central Hub',
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildTextField(
                                isDark,
                                controller: _costCenterController,
                                label: 'Cost Center Code',
                                hint: 'e.g. CC-EXEC-101',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _buildTextField(
                          isDark,
                          controller: _budgetController,
                          label: 'Monthly Budget Pool (₹)',
                          hint: '1500000',
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 20),

                        _buildSectionHeader(isDark, '4. CONFIGURATION & ACCESS CONTROL'),
                        const SizedBox(height: 10),
                        SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            'Allow Operational Team Creation',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                            ),
                          ),
                          subtitle: Text(
                            'Permits department head and managers to create and configure squads',
                            style: TextStyle(
                              fontSize: 11,
                              color: isDark ? AppColors.darkSubtext : AppColors.lightTextSecondary,
                            ),
                          ),
                          value: _allowTeamCreation,
                          activeThumbColor: AppColors.primary,
                          onChanged: (v) => setState(() => _allowTeamCreation = v),
                        ),
                        const SizedBox(height: 10),
                        _buildDropdown<String>(
                          isDark,
                          label: 'Default Data Access Scope',
                          value: _selectedScopeId,
                          items: OrganizationMockData.accessScopes.map((s) {
                            return DropdownMenuItem(value: s.id, child: Text('${s.name} (${s.scopeLevel.displayName})'));
                          }).toList(),
                          onChanged: (v) => setState(() => _selectedScopeId = v!),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),
                const Divider(height: 1),
                const SizedBox(height: 16),

                // Actions Footer
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
                      child: Text(isEdit ? 'Save Changes' : 'Create Department'),
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
