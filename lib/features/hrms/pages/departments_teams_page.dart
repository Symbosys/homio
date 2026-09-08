import 'package:flutter/material.dart';
import '../../../core/responsive/breakpoints.dart';
import '../../../core/theme/app_colors.dart';
import '../models/hrms_models.dart';
import '../models/hrms_mock_data.dart';

class DepartmentsTeamsPage extends StatefulWidget {
  const DepartmentsTeamsPage({super.key});

  @override
  State<DepartmentsTeamsPage> createState() => _DepartmentsTeamsPageState();
}

class _DepartmentsTeamsPageState extends State<DepartmentsTeamsPage> {
  DepartmentType _selectedDept = DepartmentType.design;
  final List<EmployeeDossier> _employees = List.from(hrmsMockEmployees);

  // Department definitions
  final Map<DepartmentType, Map<String, dynamic>> _deptMeta = {
    DepartmentType.marketing: {
      'name': 'Marketing & Growth',
      'icon': Icons.campaign_rounded,
      'color': const Color(0xFF8B5CF6),
      'description': 'Campaign performance, lead gen ad spend, CAC tracking & brand outreach.',
      'head': 'Meera Rao',
      'target': '350 Qualified Leads/mo',
    },
    DepartmentType.sales: {
      'name': 'Sales & Consultations',
      'icon': Icons.point_of_sale_rounded,
      'color': const Color(0xFF3B82F6),
      'description': 'Lead conversion, site demo booking, commercial contract closings.',
      'head': 'Rahul Verma',
      'target': '₹85L GMV Bookings/mo',
    },
    DepartmentType.design: {
      'name': 'Interior & Architectural Design',
      'icon': Icons.brush_rounded,
      'color': const Color(0xFF10B981),
      'description': '2D/3D BIM CAD rendering, moodboards, AI aesthetic generative renders.',
      'head': 'Ananya Sharma',
      'target': '24 Turnkey Blueprints/mo',
    },
    DepartmentType.execution: {
      'name': 'Site Execution & Turnkey Civil',
      'icon': Icons.construction_rounded,
      'color': const Color(0xFFF59E0B),
      'description': 'Vendor orchestration, site supervisor geofenced punch-lists, BOQ installs.',
      'head': 'Vikramaditya Patil',
      'target': '98.5% On-Time Milestones',
    },
    DepartmentType.afterSales: {
      'name': 'After-Sales & Warranty Support',
      'icon': Icons.verified_user_rounded,
      'color': const Color(0xFFEC4899),
      'description': 'Handover snags, 10-year structural warranty claims & client SLA compliance.',
      'head': 'Pooja Hegde',
      'target': '< 4h Mean Resolution Time',
    },
  };

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width >= Breakpoints.medium;

    final deptEmployees = _employees.where((e) => e.department == _selectedDept).toList();
    final totalDeptPayroll = deptEmployees.fold<double>(0, (sum, e) => sum + e.baseSalary);

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isDesktop ? 24 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(isDark, isDesktop),
            const SizedBox(height: 24),
            _buildDepartmentClusters(isDark, width),
            const SizedBox(height: 28),
            if (isDesktop)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 6,
                    child: _buildRosterSection(isDark, deptEmployees, totalDeptPayroll),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    flex: 4,
                    child: _buildHierarchyAndPermissionsPanel(isDark),
                  ),
                ],
              )
            else ...[
              _buildRosterSection(isDark, deptEmployees, totalDeptPayroll),
              const SizedBox(height: 24),
              _buildHierarchyAndPermissionsPanel(isDark),
            ],
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
                  child: const Icon(Icons.account_tree_rounded, color: AppColors.gold, size: 22),
                ),
                const SizedBox(width: 14),
                Text(
                  'Departments & Org Hierarchy',
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
              'Manage 5 core operational clusters, team roster, and strict lead data isolation scopes.',
              style: TextStyle(
                fontSize: 13,
                color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted,
              ),
            ),
          ],
        ),
        ElevatedButton.icon(
          onPressed: () => _showAddTeamMemberDialog(isDark),
          icon: const Icon(Icons.person_add_rounded, size: 16),
          label: const Text('Assign Member'),
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

  Widget _buildDepartmentClusters(bool isDark, double width) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'SELECT CLUSTER TO VIEW SQUAD & ACCESS ROLES',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.1,
            color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted,
          ),
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: DepartmentType.values.map((dept) {
              final isSelected = dept == _selectedDept;
              final meta = _deptMeta[dept]!;
              final count = _employees.where((e) => e.department == dept).length;
              final color = meta['color'] as Color;

              return Padding(
                padding: const EdgeInsets.only(right: 14),
                child: InkWell(
                  onTap: () => setState(() => _selectedDept = dept),
                  borderRadius: BorderRadius.circular(14),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 230,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? (isDark ? color.withValues(alpha: 0.18) : color.withValues(alpha: 0.08))
                          : (isDark ? AppColors.darkCardBg : AppColors.pureWhite),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isSelected ? color : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                        width: isSelected ? 2 : 1,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: color.withValues(alpha: 0.2),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              )
                            ]
                          : [],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: color.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(meta['icon'] as IconData, color: color, size: 18),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: isDark ? AppColors.darkSurface : AppColors.lightBackground,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '$count Active',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: isDark ? AppColors.pureWhite : AppColors.deepNavy,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          meta['name'] as String,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: isDark ? AppColors.pureWhite : AppColors.deepNavy,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Lead: ${meta['head']}',
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w500,
                            color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildRosterSection(bool isDark, List<EmployeeDossier> squad, double totalPayroll) {
    final meta = _deptMeta[_selectedDept]!;
    final color = meta['color'] as Color;

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCardBg : AppColors.pureWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: color.withValues(alpha: 0.15),
                    child: Icon(meta['icon'] as IconData, color: color, size: 18),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${meta['name']} Roster',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: isDark ? AppColors.pureWhite : AppColors.deepNavy,
                        ),
                      ),
                      Text(
                        meta['description'] as String,
                        style: TextStyle(
                          fontSize: 11.5,
                          color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.gold.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.gold.withValues(alpha: 0.3)),
                ),
                child: Text(
                  'Monthly Pool: ₹${(totalPayroll / 100000).toStringAsFixed(1)}L',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.gold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          const Divider(),
          const SizedBox(height: 12),
          if (squad.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 36),
              child: Center(
                child: Column(
                  children: [
                    Icon(Icons.group_off_rounded, size: 36, color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted),
                    const SizedBox(height: 10),
                    Text(
                      'No personnel assigned to this department yet.',
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: squad.length,
              separatorBuilder: (_, _) => const Divider(height: 20),
              itemBuilder: (context, index) {
                final emp = squad[index];
                return Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: color.withValues(alpha: 0.15),
                      child: Text(
                        emp.name.substring(0, 2).toUpperCase(),
                        style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 13),
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
                                emp.name,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: isDark ? AppColors.pureWhite : AppColors.deepNavy,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: isDark ? AppColors.darkSurface : AppColors.lightBackground,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  emp.code,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontFamily: 'monospace',
                                    color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 3),
                          Text(
                            emp.designation,
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getHierarchyColor(emp.hierarchyLevel).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        emp.hierarchyLevel.displayName,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: _getHierarchyColor(emp.hierarchyLevel),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    _buildScopeBadge(emp.accessScope, isDark),
                  ],
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildScopeBadge(AccessScope scope, bool isDark) {
    Color color;
    String label;
    IconData icon;

    switch (scope) {
      case AccessScope.myLeadsTasks:
      case AccessScope.myLeadsOnly:
        color = const Color(0xFFF59E0B);
        label = 'My Leads Only';
        icon = Icons.lock_rounded;
        break;
      case AccessScope.teamWide:
        color = const Color(0xFF3B82F6);
        label = 'Team-Wide';
        icon = Icons.groups_rounded;
        break;
      case AccessScope.organizationWide:
        color = const Color(0xFF10B981);
        label = 'Org-Wide';
        icon = Icons.public_rounded;
        break;
    }

    return Tooltip(
      message: 'Field Data Isolation Level: $label',
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 12, color: color),
            const SizedBox(width: 5),
            Text(
              label,
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: color),
            ),
          ],
        ),
      ),
    );
  }

  Color _getHierarchyColor(HierarchyLevel level) {
    switch (level) {
      case HierarchyLevel.director:
      case HierarchyLevel.lead:
      case HierarchyLevel.departmentHead:
        return const Color(0xFF8B5CF6);
      case HierarchyLevel.manager:
        return const Color(0xFF3B82F6);
      case HierarchyLevel.specialist:
      case HierarchyLevel.fieldLead:
        return const Color(0xFF10B981);
      case HierarchyLevel.executive:
        return const Color(0xFFF59E0B);
      case HierarchyLevel.junior:
      case HierarchyLevel.intern:
        return const Color(0xFF64748B);
    }
  }

  Widget _buildHierarchyAndPermissionsPanel(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCardBg : AppColors.pureWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.gold.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.security_rounded, color: AppColors.gold, size: 18),
              ),
              const SizedBox(width: 10),
              Text(
                'Data Isolation Matrix',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.pureWhite : AppColors.deepNavy,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'PRD Section 3.1: Strict Field Isolation enforcement prevents lead poaching and client leakages across tiers.',
            style: TextStyle(
              fontSize: 12,
              color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted,
            ),
          ),
          const SizedBox(height: 18),
          _buildPermissionRuleTile(
            isDark: isDark,
            title: 'Field Leads & Executives',
            scope: 'My Leads / Tasks Only',
            description: 'Can only view and update customer inquiries & project sites assigned explicitly to their profile.',
            color: const Color(0xFFF59E0B),
            icon: Icons.person_pin_rounded,
          ),
          const SizedBox(height: 12),
          _buildPermissionRuleTile(
            isDark: isDark,
            title: 'Department Managers',
            scope: 'Team-Wide Scope',
            description: 'Can audit all pipelines, design tasks, travel mileage, and attendance logs across their department.',
            color: const Color(0xFF3B82F6),
            icon: Icons.groups_rounded,
          ),
          const SizedBox(height: 12),
          _buildPermissionRuleTile(
            isDark: isDark,
            title: 'Directors & HR Admin',
            scope: 'Organization-Wide',
            description: 'Unrestricted oversight across all 5 departments, payroll disbursements, penalty rules, and KYC.',
            color: const Color(0xFF10B981),
            icon: Icons.admin_panel_settings_rounded,
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : AppColors.lightBackground,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline_rounded, size: 18, color: AppColors.gold),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Role changes take effect immediately on next mobile sync or live websocket handshake.',
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w500,
                      color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionRuleTile({
    required bool isDark,
    required String title,
    required String scope,
    required String description,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(icon, size: 16, color: color),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: isDark ? AppColors.pureWhite : AppColors.deepNavy,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  scope,
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            description,
            style: TextStyle(
              fontSize: 11.5,
              color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted,
            ),
          ),
        ],
      ),
    );
  }

  void _showAddTeamMemberDialog(bool isDark) {
    final nameCtrl = TextEditingController();
    final desigCtrl = TextEditingController();
    DepartmentType selectedDept = _selectedDept;
    HierarchyLevel selectedLevel = HierarchyLevel.executive;
    AccessScope selectedScope = AccessScope.myLeadsTasks;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            backgroundColor: isDark ? AppColors.darkCardBg : AppColors.pureWhite,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: Text(
              'Assign Team Member',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.pureWhite : AppColors.deepNavy,
              ),
            ),
            content: SizedBox(
              width: 480,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Full Name *',
                        hintText: 'e.g. Alok Nath',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      controller: desigCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Designation / Role Title *',
                        hintText: 'e.g. Senior Site Engineer',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 14),
                    DropdownButtonFormField<DepartmentType>(
                      initialValue: selectedDept,
                      decoration: const InputDecoration(
                        labelText: 'Department Cluster',
                        border: OutlineInputBorder(),
                      ),
                      items: DepartmentType.values.map((d) {
                        return DropdownMenuItem(value: d, child: Text(d.displayName));
                      }).toList(),
                      onChanged: (val) => setDialogState(() => selectedDept = val!),
                    ),
                    const SizedBox(height: 14),
                    DropdownButtonFormField<HierarchyLevel>(
                      initialValue: selectedLevel,
                      decoration: const InputDecoration(
                        labelText: 'Hierarchy Tier',
                        border: OutlineInputBorder(),
                      ),
                      items: HierarchyLevel.values.map((l) {
                        return DropdownMenuItem(value: l, child: Text(l.displayName));
                      }).toList(),
                      onChanged: (val) => setDialogState(() => selectedLevel = val!),
                    ),
                    const SizedBox(height: 14),
                    DropdownButtonFormField<AccessScope>(
                      initialValue: selectedScope,
                      decoration: const InputDecoration(
                        labelText: 'Field Data Isolation Level',
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: AccessScope.myLeadsTasks,
                          child: Text('My Leads / Tasks Only (Field Strict)'),
                        ),
                        DropdownMenuItem(
                          value: AccessScope.teamWide,
                          child: Text('Team-Wide (Department Manager)'),
                        ),
                        DropdownMenuItem(
                          value: AccessScope.organizationWide,
                          child: Text('Organization-Wide (Director / Admin)'),
                        ),
                      ],
                      onChanged: (val) => setDialogState(() => selectedScope = val!),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (nameCtrl.text.trim().isEmpty) return;
                  final newEmp = EmployeeDossier(
                    id: 'emp-${DateTime.now().millisecondsSinceEpoch}',
                    name: nameCtrl.text.trim(),
                    email: '${nameCtrl.text.trim().toLowerCase().replaceAll(' ', '.')}@homio.in',
                    phone: '+91 98765 00000',
                    department: selectedDept,
                    hierarchyLevel: selectedLevel,
                    designation: desigCtrl.text.trim().isEmpty ? 'Associate' : desigCtrl.text.trim(),
                    accessScope: selectedScope,
                    joiningDate: DateTime.now(),
                    baseSalary: 45000,
                    status: EmployeeStatus.probation,
                    kyc: const KycVerification(
                      isAadhaarVerified: true,
                      isPanVerified: true,
                      isBankVerified: true,
                    ),
                  );
                  setState(() {
                    _employees.add(newEmp);
                  });
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Assigned ${newEmp.name} to ${selectedDept.displayName}'),
                      backgroundColor: AppColors.gold,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.gold,
                  foregroundColor: AppColors.deepNavy,
                ),
                child: const Text('Assign Member'),
              ),
            ],
          );
        },
      ),
    );
  }
}
