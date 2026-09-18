import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_query_flutter/cached_query_flutter.dart';
import '../../../core/responsive/breakpoints.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/utils/toast_service.dart';
import '../data/models/hrms_department_api_model.dart';
import '../data/models/hrms_team_api_model.dart';
import '../presentation/queries/hrms_queries.dart';
import '../widgets/hrms_header.dart';
import '../widgets/hrms_metric_card.dart';

class HrmsDepartmentsPage extends StatefulWidget {
  const HrmsDepartmentsPage({super.key});

  @override
  State<HrmsDepartmentsPage> createState() => _HrmsDepartmentsPageState();
}

class _HrmsDepartmentsPageState extends State<HrmsDepartmentsPage> {
  String _searchQuery = '';
  String? _selectedDeptFilter;

  Color _getDeptColor(int index) {
    const colors = [
      Color(0xFF3B82F6),
      Color(0xFF10B981),
      Color(0xFF8B5CF6),
      Color(0xFFF59E0B),
      Color(0xFF06B6D4),
      Color(0xFFEC4899),
    ];
    return colors[index % colors.length];
  }

  // ==========================================
  // DEPARTMENT MODAL (Create / Edit)
  // ==========================================
  void _openDepartmentDialog({HrmsDepartmentApiModel? department}) {
    final isEdit = department != null;
    final nameCtrl = TextEditingController(text: department?.name ?? '');
    final codeCtrl = TextEditingController(text: department?.code ?? '');
    final descCtrl = TextEditingController(text: department?.description ?? '');
    final costCenterCtrl = TextEditingController(text: department?.costCenterCode ?? '');
    final budgetCtrl = TextEditingController(
      text: department?.budget != null ? department!.budget!.toInt().toString() : '',
    );
    String? selectedHeadId = department?.headOfDepartmentId;
    String status = department?.status ?? 'ACTIVE';
    bool isSaving = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) {
          final isDark = Theme.of(context).brightness == Brightness.dark;

          return Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 540),
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF131722) : Colors.white,
                borderRadius: AppRadius.lg,
                border: Border.all(color: isDark ? Colors.white12 : Colors.black12),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.3), blurRadius: 20, offset: const Offset(0, 8)),
                ],
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          isEdit ? 'Edit Department Details' : 'Create Organization Department',
                          style: GoogleFonts.plusJakartaSans(fontSize: 15, fontWeight: FontWeight.w700),
                        ),
                        IconButton(
                          onPressed: () => Navigator.of(ctx).pop(),
                          icon: const Icon(Icons.close, size: 20),
                        ),
                      ],
                    ),
                    const Divider(height: 1),
                    const SizedBox(height: AppSpacing.md),

                    // Name & Code
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: TextField(
                            controller: nameCtrl,
                            style: GoogleFonts.plusJakartaSans(fontSize: 13),
                            decoration: const InputDecoration(
                              labelText: 'Department Name *',
                              hintText: 'e.g. Engineering & Technology',
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          flex: 2,
                          child: TextField(
                            controller: codeCtrl,
                            textCapitalization: TextCapitalization.characters,
                            style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w600),
                            decoration: const InputDecoration(
                              labelText: 'Code *',
                              hintText: 'ENG',
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),

                    // Head of Department Dropdown
                    QueryBuilder(
                      query: hrmsQueries.getEmployeesQuery(limit: 100),
                      builder: (context, empState) {
                        final employees = empState.data?.items ?? [];

                        return DropdownButtonFormField<String?>(
                          initialValue: selectedHeadId,
                          dropdownColor: isDark ? const Color(0xFF1A1F2C) : Colors.white,
                          decoration: const InputDecoration(labelText: 'Head of Department'),
                          isExpanded: true,
                          items: [
                            const DropdownMenuItem<String?>(
                              value: null,
                              child: Text('None / Unassigned'),
                            ),
                            ...employees.map((e) => DropdownMenuItem<String?>(
                                  value: e.id,
                                  child: Text('${e.fullName} (${e.employeeCode}) - ${e.designation}'),
                                )),
                          ],
                          onChanged: (v) => setModalState(() => selectedHeadId = v),
                        );
                      },
                    ),
                    const SizedBox(height: AppSpacing.sm),

                    // Budget & Cost Center
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: budgetCtrl,
                            keyboardType: TextInputType.number,
                            style: GoogleFonts.plusJakartaSans(fontSize: 13),
                            decoration: const InputDecoration(
                              labelText: 'Annual Budget (INR)',
                              hintText: '5000000',
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: TextField(
                            controller: costCenterCtrl,
                            style: GoogleFonts.plusJakartaSans(fontSize: 13),
                            decoration: const InputDecoration(
                              labelText: 'Cost Center Code',
                              hintText: 'CC-101',
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),

                    // Status Dropdown
                    DropdownButtonFormField<String>(
                      initialValue: status,
                      dropdownColor: isDark ? const Color(0xFF1A1F2C) : Colors.white,
                      decoration: const InputDecoration(labelText: 'Operational Status'),
                      items: const [
                        DropdownMenuItem(value: 'ACTIVE', child: Text('Active')),
                        DropdownMenuItem(value: 'INACTIVE', child: Text('Inactive')),
                        DropdownMenuItem(value: 'ARCHIVED', child: Text('Archived')),
                      ],
                      onChanged: (v) => setModalState(() => status = v ?? 'ACTIVE'),
                    ),
                    const SizedBox(height: AppSpacing.sm),

                    // Description
                    TextField(
                      controller: descCtrl,
                      maxLines: 2,
                      style: GoogleFonts.plusJakartaSans(fontSize: 13),
                      decoration: const InputDecoration(
                        labelText: 'Department Description / Mandate',
                        hintText: 'Core software engineering, UI/UX design, cloud infrastructure...',
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),

                    // Dialog Actions
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: isSaving ? null : () => Navigator.of(ctx).pop(),
                          child: const Text('Cancel'),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        ElevatedButton(
                          onPressed: isSaving
                              ? null
                              : () async {
                                  if (nameCtrl.text.trim().isEmpty || codeCtrl.text.trim().isEmpty) {
                                    ToastService.showError('Name and Code are required.');
                                    return;
                                  }

                                  setModalState(() => isSaving = true);

                                  final payload = <String, dynamic>{
                                    'name': nameCtrl.text.trim(),
                                    'code': codeCtrl.text.trim().toUpperCase(),
                                    'description': descCtrl.text.trim().isEmpty ? null : descCtrl.text.trim(),
                                    'headOfDepartmentId': selectedHeadId,
                                    'costCenterCode': costCenterCtrl.text.trim().isEmpty ? null : costCenterCtrl.text.trim(),
                                    'budget': double.tryParse(budgetCtrl.text.trim()),
                                    'status': status,
                                  };

                                  if (isEdit) {
                                    final mutation = hrmsQueries.getUpdateDepartmentMutation(
                                      onSuccess: (_) => Navigator.of(ctx).pop(),
                                    );
                                    await mutation.mutate((id: department.id, data: payload));
                                  } else {
                                    final mutation = hrmsQueries.getCreateDepartmentMutation(
                                      onSuccess: (_) => Navigator.of(ctx).pop(),
                                    );
                                    await mutation.mutate(payload);
                                  }

                                  setModalState(() => isSaving = false);
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                          ),
                          child: isSaving
                              ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                              : Text(isEdit ? 'Save Changes' : 'Create Department'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ==========================================
  // TEAM MODAL (Create / Edit)
  // ==========================================
  void _openTeamDialog({HrmsTeamApiModel? team, String? preselectedDeptId}) {
    final isEdit = team != null;
    final nameCtrl = TextEditingController(text: team?.name ?? '');
    final codeCtrl = TextEditingController(text: team?.code ?? '');
    final descCtrl = TextEditingController(text: team?.description ?? '');
    String? selectedDeptId = team?.departmentId ?? preselectedDeptId;
    String? selectedLeadId = team?.teamLeadId;
    String status = team?.status ?? 'ACTIVE';
    bool isSaving = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) {
          final isDark = Theme.of(context).brightness == Brightness.dark;

          return Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 520),
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF131722) : Colors.white,
                borderRadius: AppRadius.lg,
                border: Border.all(color: isDark ? Colors.white12 : Colors.black12),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.3), blurRadius: 20, offset: const Offset(0, 8)),
                ],
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          isEdit ? 'Edit Team Details' : 'Create Project Team',
                          style: GoogleFonts.plusJakartaSans(fontSize: 15, fontWeight: FontWeight.w700),
                        ),
                        IconButton(
                          onPressed: () => Navigator.of(ctx).pop(),
                          icon: const Icon(Icons.close, size: 20),
                        ),
                      ],
                    ),
                    const Divider(height: 1),
                    const SizedBox(height: AppSpacing.md),

                    // Parent Department
                    QueryBuilder(
                      query: hrmsQueries.getDepartmentsQuery(limit: 100),
                      builder: (context, deptState) {
                        final departments = deptState.data?.items ?? [];

                        return DropdownButtonFormField<String>(
                          initialValue: selectedDeptId,
                          dropdownColor: isDark ? const Color(0xFF1A1F2C) : Colors.white,
                          decoration: const InputDecoration(labelText: 'Parent Department *'),
                          items: departments
                              .map((d) => DropdownMenuItem(
                                    value: d.id,
                                    child: Text('${d.name} (${d.code})'),
                                  ))
                              .toList(),
                          onChanged: isEdit ? null : (v) => setModalState(() => selectedDeptId = v),
                        );
                      },
                    ),
                    const SizedBox(height: AppSpacing.sm),

                    // Team Name & Code
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: TextField(
                            controller: nameCtrl,
                            style: GoogleFonts.plusJakartaSans(fontSize: 13),
                            decoration: const InputDecoration(
                              labelText: 'Team Name *',
                              hintText: 'e.g. Frontend Core',
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          flex: 2,
                          child: TextField(
                            controller: codeCtrl,
                            textCapitalization: TextCapitalization.characters,
                            style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w600),
                            decoration: const InputDecoration(
                              labelText: 'Code *',
                              hintText: 'FE-CORE',
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),

                    // Team Lead Dropdown
                    QueryBuilder(
                      query: hrmsQueries.getEmployeesQuery(limit: 100),
                      builder: (context, empState) {
                        final employees = empState.data?.items ?? [];

                        return DropdownButtonFormField<String?>(
                          initialValue: selectedLeadId,
                          dropdownColor: isDark ? const Color(0xFF1A1F2C) : Colors.white,
                          decoration: const InputDecoration(labelText: 'Team Lead'),
                          isExpanded: true,
                          items: [
                            const DropdownMenuItem<String?>(
                              value: null,
                              child: Text('None / Unassigned'),
                            ),
                            ...employees.map((e) => DropdownMenuItem<String?>(
                                  value: e.id,
                                  child: Text('${e.fullName} (${e.employeeCode}) - ${e.designation}'),
                                )),
                          ],
                          onChanged: (v) => setModalState(() => selectedLeadId = v),
                        );
                      },
                    ),
                    const SizedBox(height: AppSpacing.sm),

                    // Status Dropdown
                    DropdownButtonFormField<String>(
                      initialValue: status,
                      dropdownColor: isDark ? const Color(0xFF1A1F2C) : Colors.white,
                      decoration: const InputDecoration(labelText: 'Team Status'),
                      items: const [
                        DropdownMenuItem(value: 'ACTIVE', child: Text('Active')),
                        DropdownMenuItem(value: 'INACTIVE', child: Text('Inactive')),
                        DropdownMenuItem(value: 'ARCHIVED', child: Text('Archived')),
                      ],
                      onChanged: (v) => setModalState(() => status = v ?? 'ACTIVE'),
                    ),
                    const SizedBox(height: AppSpacing.sm),

                    // Description
                    TextField(
                      controller: descCtrl,
                      maxLines: 2,
                      style: GoogleFonts.plusJakartaSans(fontSize: 13),
                      decoration: const InputDecoration(
                        labelText: 'Team Charter / Function',
                        hintText: 'Web applications, cross-platform mobile apps, design systems...',
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),

                    // Actions
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: isSaving ? null : () => Navigator.of(ctx).pop(),
                          child: const Text('Cancel'),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        ElevatedButton(
                          onPressed: isSaving
                              ? null
                              : () async {
                                  if (selectedDeptId == null || nameCtrl.text.trim().isEmpty || codeCtrl.text.trim().isEmpty) {
                                    ToastService.showError('Parent Department, Name and Code are required.');
                                    return;
                                  }

                                  setModalState(() => isSaving = true);

                                  final payload = <String, dynamic>{
                                    'name': nameCtrl.text.trim(),
                                    'code': codeCtrl.text.trim().toUpperCase(),
                                    'description': descCtrl.text.trim().isEmpty ? null : descCtrl.text.trim(),
                                    'teamLeadId': selectedLeadId,
                                    'status': status,
                                  };

                                  if (isEdit) {
                                    final mutation = hrmsQueries.getUpdateTeamMutation(
                                      onSuccess: (_) => Navigator.of(ctx).pop(),
                                    );
                                    await mutation.mutate((id: team.id, data: payload));
                                  } else {
                                    final mutation = hrmsQueries.getCreateTeamMutation(
                                      onSuccess: (_) => Navigator.of(ctx).pop(),
                                    );
                                    await mutation.mutate((departmentId: selectedDeptId!, data: payload));
                                  }

                                  setModalState(() => isSaving = false);
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                          ),
                          child: isSaving
                              ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                              : Text(isEdit ? 'Save Changes' : 'Create Team'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ==========================================
  // DEPARTMENT MEMBERS MODAL
  // ==========================================
  void _openDepartmentMembersModal(HrmsDepartmentApiModel dept) {
    showDialog(
      context: context,
      builder: (ctx) {
        final isDark = Theme.of(context).brightness == Brightness.dark;

        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 680, maxHeight: 600),
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF131722) : Colors.white,
              borderRadius: AppRadius.lg,
              border: Border.all(color: isDark ? Colors.white12 : Colors.black12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.groups_rounded, color: AppColors.primary, size: 22),
                        const SizedBox(width: AppSpacing.sm),
                        Text(
                          '${dept.name} (${dept.code}) Members',
                          style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                    IconButton(onPressed: () => Navigator.of(ctx).pop(), icon: const Icon(Icons.close, size: 20)),
                  ],
                ),
                const Divider(height: 1),
                const SizedBox(height: AppSpacing.sm),

                Expanded(
                  child: QueryBuilder(
                    query: hrmsQueries.getDepartmentMembersQuery(dept.id),
                    builder: (context, state) {
                      if (state.data == null && state.error == null) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final members = state.data ?? [];
                      if (members.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.person_off_outlined, size: 40, color: isDark ? Colors.white30 : Colors.black26),
                              const SizedBox(height: 8),
                              Text('No employees currently assigned to this department.',
                                  style: GoogleFonts.plusJakartaSans(color: isDark ? Colors.white60 : Colors.black54)),
                            ],
                          ),
                        );
                      }

                      return ListView.separated(
                        itemCount: members.length,
                        separatorBuilder: (_, _) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final m = members[index];
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundImage: m.avatarUrl != null ? NetworkImage(m.avatarUrl!) : null,
                              child: m.avatarUrl == null
                                  ? Text(m.firstName.isNotEmpty ? m.firstName[0] : 'E')
                                  : null,
                            ),
                            title: Text(
                              m.fullName,
                              style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w700),
                            ),
                            subtitle: Text(
                              '${m.employeeCode} • ${m.designation}${m.team != null ? " • Team: ${m.team!.name}" : ""}',
                              style: GoogleFonts.plusJakartaSans(fontSize: 11),
                            ),
                            trailing: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                m.role.replaceAll('_', ' '),
                                style: GoogleFonts.plusJakartaSans(fontSize: 10.5, fontWeight: FontWeight.w700, color: AppColors.primary),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ==========================================
  // TEAM MEMBERS MODAL
  // ==========================================
  void _openTeamMembersModal(HrmsTeamApiModel team) {
    showDialog(
      context: context,
      builder: (ctx) {
        final isDark = Theme.of(context).brightness == Brightness.dark;

        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 600, maxHeight: 540),
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF131722) : Colors.white,
              borderRadius: AppRadius.lg,
              border: Border.all(color: isDark ? Colors.white12 : Colors.black12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.people_alt_rounded, color: Color(0xFF10B981), size: 22),
                        const SizedBox(width: AppSpacing.sm),
                        Text(
                          '${team.name} (${team.code}) Members',
                          style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                    IconButton(onPressed: () => Navigator.of(ctx).pop(), icon: const Icon(Icons.close, size: 20)),
                  ],
                ),
                const Divider(height: 1),
                const SizedBox(height: AppSpacing.sm),

                Expanded(
                  child: QueryBuilder(
                    query: hrmsQueries.getTeamMembersQuery(team.id),
                    builder: (context, state) {
                      if (state.data == null && state.error == null) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final members = state.data ?? [];
                      if (members.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.person_off_outlined, size: 40, color: isDark ? Colors.white30 : Colors.black26),
                              const SizedBox(height: 8),
                              Text('No members currently assigned to this team.',
                                  style: GoogleFonts.plusJakartaSans(color: isDark ? Colors.white60 : Colors.black54)),
                            ],
                          ),
                        );
                      }

                      return ListView.separated(
                        itemCount: members.length,
                        separatorBuilder: (_, _) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final m = members[index];
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundImage: m.avatarUrl != null ? NetworkImage(m.avatarUrl!) : null,
                              child: m.avatarUrl == null
                                  ? Text(m.firstName.isNotEmpty ? m.firstName[0] : 'E')
                                  : null,
                            ),
                            title: Text(
                              m.fullName,
                              style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w700),
                            ),
                            subtitle: Text(
                              '${m.employeeCode} • ${m.designation}',
                              style: GoogleFonts.plusJakartaSans(fontSize: 11),
                            ),
                            trailing: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: const Color(0xFF10B981).withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                m.role.replaceAll('_', ' '),
                                style: GoogleFonts.plusJakartaSans(fontSize: 10.5, fontWeight: FontWeight.w700, color: const Color(0xFF10B981)),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ==========================================
  // MAIN BUILD
  // ==========================================
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isCompact = MediaQuery.of(context).size.width < 768;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0B0E14) : const Color(0xFFF1F5F9),
      body: QueryBuilder(
        query: hrmsQueries.getDepartmentsQuery(limit: 100),
        builder: (context, deptState) {
          final departments = deptState.data?.items ?? [];

          return QueryBuilder(
            query: hrmsQueries.getTeamsQuery(limit: 100),
            builder: (context, teamState) {
              final teams = teamState.data?.items ?? [];

              final totalBudget = departments.fold<double>(0.0, (s, d) => s + (d.budget ?? 0.0));
              final totalEmployeesAssigned = departments.fold<int>(0, (s, d) => s + d.employeesCount);

              // Filtered lists
              final filteredDepts = departments.where((d) {
                if (_searchQuery.isEmpty) return true;
                final q = _searchQuery.toLowerCase();
                return d.name.toLowerCase().contains(q) || d.code.toLowerCase().contains(q);
              }).toList();

              final filteredTeams = teams.where((t) {
                if (_selectedDeptFilter != null && t.departmentId != _selectedDeptFilter) {
                  return false;
                }
                if (_searchQuery.isEmpty) return true;
                final q = _searchQuery.toLowerCase();
                return t.name.toLowerCase().contains(q) || t.code.toLowerCase().contains(q);
              }).toList();

              return SingleChildScrollView(
                padding: EdgeInsets.all(isCompact ? AppSpacing.md : AppSpacing.lg),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: Breakpoints.maxContentWidth),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Header
                        HrmsHeader(
                          title: 'Departments, Teams & Org Hierarchy',
                          subtitle:
                              'Corporate department governance, cross-functional project teams, lead assignments & annual budget allocation',
                          icon: Icons.account_tree_rounded,
                          badgeText: '${departments.length} ACTIVE DEPARTMENTS',
                          actions: [
                            IconButton(
                              icon: const Icon(Icons.refresh_rounded, size: 20),
                              onPressed: () {
                                hrmsQueries.invalidateDepartmentsCache();
                                hrmsQueries.invalidateTeamsCache();
                              },
                              tooltip: 'Refresh Roster',
                            ),
                            OutlinedButton.icon(
                              onPressed: () => _openTeamDialog(),
                              style: OutlinedButton.styleFrom(
                                visualDensity: VisualDensity.compact,
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              ),
                              icon: const Icon(Icons.group_add_outlined, size: 16),
                              label: Text('New Team', style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w600)),
                            ),
                            const SizedBox(width: AppSpacing.xs),
                            ElevatedButton.icon(
                              onPressed: () => _openDepartmentDialog(),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                visualDensity: VisualDensity.compact,
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              ),
                              icon: const Icon(Icons.add_business_rounded, size: 16),
                              label: Text('Create Department', style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w600)),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.md),

                        // Metrics Row
                        _buildMetrics(context, departments, teams, totalBudget, totalEmployeesAssigned, isCompact),
                        const SizedBox(height: AppSpacing.lg),

                        // Search & Filter Bar
                        Container(
                          padding: const EdgeInsets.all(AppSpacing.sm),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF131722) : Colors.white,
                            borderRadius: AppRadius.lg,
                            border: Border.all(color: isDark ? Colors.white12 : Colors.black12),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  onChanged: (val) => setState(() => _searchQuery = val),
                                  style: GoogleFonts.plusJakartaSans(fontSize: 13),
                                  decoration: InputDecoration(
                                    hintText: 'Search department or team by name or code...',
                                    prefixIcon: const Icon(Icons.search_rounded, size: 20),
                                    border: InputBorder.none,
                                    isDense: true,
                                    suffixIcon: _searchQuery.isNotEmpty
                                        ? IconButton(
                                            icon: const Icon(Icons.clear, size: 18),
                                            onPressed: () => setState(() => _searchQuery = ''),
                                          )
                                        : null,
                                  ),
                                ),
                              ),
                              if (departments.isNotEmpty) ...[
                                const SizedBox(width: AppSpacing.sm),
                                Container(
                                  height: 38,
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  decoration: BoxDecoration(
                                    color: isDark ? const Color(0xFF1B202E) : const Color(0xFFF8FAFC),
                                    borderRadius: AppRadius.md,
                                    border: Border.all(color: isDark ? Colors.white12 : Colors.black12),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String?>(
                                      value: _selectedDeptFilter,
                                      dropdownColor: isDark ? const Color(0xFF1A1F2C) : Colors.white,
                                      hint: const Text('All Departments'),
                                      items: [
                                        const DropdownMenuItem<String?>(value: null, child: Text('All Departments')),
                                        ...departments.map((d) => DropdownMenuItem<String?>(
                                              value: d.id,
                                              child: Text('${d.name} (${d.code})'),
                                            )),
                                      ],
                                      onChanged: (v) => setState(() => _selectedDeptFilter = v),
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),

                        // Departments Section Title
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Organizational Departments (${filteredDepts.length})',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.3,
                                color: isDark ? Colors.white : const Color(0xFF0F172A),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.sm),

                        if (filteredDepts.isEmpty)
                          Container(
                            height: 140,
                            alignment: Alignment.center,
                            child: Text('No departments found matching search criteria.',
                                style: GoogleFonts.plusJakartaSans(color: isDark ? Colors.white54 : Colors.black45)),
                          )
                        else
                          _buildDepartmentsGrid(filteredDepts, isDark),
                        const SizedBox(height: AppSpacing.xl),

                        // Specialized Teams Section Title
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Specialized Project Teams (${filteredTeams.length})',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.3,
                                color: isDark ? Colors.white : const Color(0xFF0F172A),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.sm),

                        if (filteredTeams.isEmpty)
                          Container(
                            height: 120,
                            alignment: Alignment.center,
                            child: Text('No project teams found matching criteria.',
                                style: GoogleFonts.plusJakartaSans(color: isDark ? Colors.white54 : Colors.black45)),
                          )
                        else
                          _buildTeamsGrid(filteredTeams, isDark),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  // ==========================================
  // METRICS
  // ==========================================
  Widget _buildMetrics(
    BuildContext context,
    List<HrmsDepartmentApiModel> departments,
    List<HrmsTeamApiModel> teams,
    double totalBudget,
    int totalEmployeesAssigned,
    bool isCompact,
  ) {
    final cards = [
      HrmsMetricCard(
        title: 'Core Departments',
        value: '${departments.length} Units',
        subtitle: 'Enterprise Structure',
        icon: Icons.business_outlined,
        accentColor: const Color(0xFF3B82F6),
      ),
      HrmsMetricCard(
        title: 'Functional Teams',
        value: '${teams.length} Teams',
        subtitle: 'Project & Studio Units',
        icon: Icons.groups_outlined,
        accentColor: const Color(0xFF10B981),
      ),
      HrmsMetricCard(
        title: 'Total Annual Budget',
        value: totalBudget >= 10000000
            ? '₹${(totalBudget / 10000000).toStringAsFixed(2)} Cr'
            : '₹${(totalBudget / 100000).toStringAsFixed(1)} L',
        subtitle: 'Operational Expenditure',
        icon: Icons.account_balance_wallet_outlined,
        accentColor: const Color(0xFF8B5CF6),
      ),
      HrmsMetricCard(
        title: 'Deployed Personnel',
        value: '$totalEmployeesAssigned Assigned',
        subtitle: 'Active Staff Allocation',
        icon: Icons.pie_chart_outline_rounded,
        accentColor: const Color(0xFFF59E0B),
      ),
    ];

    if (isCompact) {
      return Column(children: cards.map((c) => Padding(padding: const EdgeInsets.only(bottom: 8), child: c)).toList());
    }
    return Row(children: cards.map((c) => Expanded(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 4), child: c))).toList());
  }

  // ==========================================
  // DEPARTMENTS GRID
  // ==========================================
  Widget _buildDepartmentsGrid(List<HrmsDepartmentApiModel> departments, bool isDark) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth < 720 ? 1 : (constraints.maxWidth < 1150 ? 2 : 3);

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: departments.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisExtent: 250,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
          ),
          itemBuilder: (context, index) {
            final dept = departments[index];
            final color = _getDeptColor(index);

            return Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF131722) : Colors.white,
                borderRadius: AppRadius.lg,
                border: Border.all(color: isDark ? Colors.white.withValues(alpha: 0.08) : Colors.black.withValues(alpha: 0.06)),
                boxShadow: [
                  BoxShadow(color: color.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Top Title & Badges
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: color.withValues(alpha: 0.15),
                                borderRadius: AppRadius.md,
                              ),
                              child: Icon(Icons.corporate_fare_rounded, size: 20, color: color),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    dept.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 13.5,
                                      fontWeight: FontWeight.w700,
                                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                                    ),
                                  ),
                                  Text(
                                    'Code: ${dept.code}${dept.costCenterCode != null ? " • CC: ${dept.costCenterCode}" : ""}',
                                    style: GoogleFonts.plusJakartaSans(fontSize: 10, color: const Color(0xFF94A3B8)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.1),
                          borderRadius: AppRadius.full,
                        ),
                        child: Text(
                          '${dept.employeesCount} Staff',
                          style: GoogleFonts.plusJakartaSans(fontSize: 10, fontWeight: FontWeight.w700, color: color),
                        ),
                      ),
                    ],
                  ),

                  // Description
                  Text(
                    dept.description ?? 'No functional description provided.',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  // Head of Dept & Budget
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Head of Department', style: GoogleFonts.plusJakartaSans(fontSize: 10, color: const Color(0xFF94A3B8))),
                          Text(dept.headEmployeeName, style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w600)),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('Annual Budget', style: GoogleFonts.plusJakartaSans(fontSize: 10, color: const Color(0xFF94A3B8))),
                          Text(
                            dept.budget != null
                                ? '₹${(dept.budget! / 100000).toStringAsFixed(1)} Lacs'
                                : 'Not Set',
                            style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w700, color: color),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Divider(height: 1),

                  // Actions Row
                  Row(
                    children: [
                      TextButton.icon(
                        onPressed: () => _openDepartmentMembersModal(dept),
                        style: TextButton.styleFrom(
                          visualDensity: VisualDensity.compact,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                        ),
                        icon: const Icon(Icons.groups_outlined, size: 14),
                        label: Text('Members (${dept.employeesCount})', style: GoogleFonts.plusJakartaSans(fontSize: 11)),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline, size: 17),
                        tooltip: 'Add Sub-Team',
                        onPressed: () => _openTeamDialog(preselectedDeptId: dept.id),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit_outlined, size: 17),
                        tooltip: 'Edit Department',
                        onPressed: () => _openDepartmentDialog(department: dept),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, size: 17, color: Colors.redAccent),
                        tooltip: 'Delete Department',
                        onPressed: () => _confirmDeleteDepartment(dept),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // ==========================================
  // TEAMS GRID
  // ==========================================
  Widget _buildTeamsGrid(List<HrmsTeamApiModel> teams, bool isDark) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth < 700 ? 1 : 2;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: teams.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisExtent: 180,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
          ),
          itemBuilder: (context, index) {
            final team = teams[index];
            return Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF131722) : Colors.white,
                borderRadius: AppRadius.lg,
                border: Border.all(color: isDark ? Colors.white.withValues(alpha: 0.08) : Colors.black.withValues(alpha: 0.06)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            team.name,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w700,
                              color: isDark ? Colors.white : const Color(0xFF0F172A),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                            decoration: BoxDecoration(
                              color: isDark ? Colors.white10 : Colors.black12,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              team.code,
                              style: GoogleFonts.plusJakartaSans(fontSize: 9.5, fontWeight: FontWeight.w700),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: AppRadius.full,
                        ),
                        child: Text(
                          team.departmentName,
                          style: GoogleFonts.plusJakartaSans(fontSize: 9.5, fontWeight: FontWeight.w600, color: AppColors.primary),
                        ),
                      ),
                    ],
                  ),

                  Text(
                    team.description ?? 'No project scope description.',
                    style: GoogleFonts.plusJakartaSans(fontSize: 11, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.star, size: 14, color: Color(0xFFF59E0B)),
                          const SizedBox(width: 4),
                          Text(
                            'Lead: ${team.leadEmployeeName}',
                            style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      Text(
                        '${team.employeesCount} Members',
                        style: GoogleFonts.plusJakartaSans(fontSize: 10, color: const Color(0xFF94A3B8), fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  const Divider(height: 1),

                  // Actions Row
                  Row(
                    children: [
                      TextButton.icon(
                        onPressed: () => _openTeamMembersModal(team),
                        style: TextButton.styleFrom(
                          visualDensity: VisualDensity.compact,
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                        ),
                        icon: const Icon(Icons.people_outline, size: 14),
                        label: Text('Members', style: GoogleFonts.plusJakartaSans(fontSize: 11)),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.edit_outlined, size: 16),
                        tooltip: 'Edit Team',
                        onPressed: () => _openTeamDialog(team: team),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, size: 16, color: Colors.redAccent),
                        tooltip: 'Delete Team',
                        onPressed: () => _confirmDeleteTeam(team),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // ==========================================
  // CONFIRM DELETIONS
  // ==========================================
  void _confirmDeleteDepartment(HrmsDepartmentApiModel dept) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Delete Department "${dept.name}"?'),
        content: Text(
          'Are you sure you want to delete this department? Any assigned employees must be reassigned first.',
          style: GoogleFonts.plusJakartaSans(fontSize: 13),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              final mutation = hrmsQueries.getDeleteDepartmentMutation();
              await mutation.mutate(dept.id);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, foregroundColor: Colors.white),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteTeam(HrmsTeamApiModel team) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Delete Team "${team.name}"?'),
        content: Text(
          'Are you sure you want to delete this project team? Assigned employees must be reassigned first.',
          style: GoogleFonts.plusJakartaSans(fontSize: 13),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              final mutation = hrmsQueries.getDeleteTeamMutation();
              await mutation.mutate(team.id);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, foregroundColor: Colors.white),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
