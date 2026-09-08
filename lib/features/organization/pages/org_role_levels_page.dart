import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/responsive/breakpoints.dart';
import '../../../core/theme/app_colors.dart';
import '../models/organization_models.dart';
import '../models/organization_mock_data.dart';

class OrgRoleLevelsPage extends StatefulWidget {
  const OrgRoleLevelsPage({super.key});

  @override
  State<OrgRoleLevelsPage> createState() => _OrgRoleLevelsPageState();
}

class _OrgRoleLevelsPageState extends State<OrgRoleLevelsPage> {
  final List<RoleDefinition> _roles = List.from(OrganizationMockData.roles);

  DepartmentType? _selectedDept;
  HierarchyLevel? _selectedLevel;
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width >= Breakpoints.medium;

    final filteredRoles = _roles.where((r) {
      final matchesSearch = r.roleTitle.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          r.reportingToRole.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          r.departmentType.displayName.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesDept = _selectedDept == null || r.departmentType == _selectedDept;
      final matchesLevel = _selectedLevel == null || r.hierarchyLevel == _selectedLevel;

      return matchesSearch && matchesDept && matchesLevel;
    }).toList();

    // Summary counts
    final totalRoles = _roles.length;
    final isolatedRoles = _roles.where((r) => r.defaultScope == AccessScope.myLeadsTasks || r.defaultScope == AccessScope.myLeadsOnly).length;
    final totalMembers = _roles.fold<int>(0, (sum, r) => sum + r.activeMembersCount);

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isDesktop ? 24 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(isDark, isDesktop),
            const SizedBox(height: 20),
            _buildKpiMetrics(isDark, totalRoles, isolatedRoles, totalMembers, width),
            const SizedBox(height: 24),
            _buildRolesListCard(isDark, filteredRoles),
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
                  child: const Icon(Icons.work_history_rounded, color: AppColors.gold, size: 22),
                ),
                const SizedBox(width: 14),
                Text(
                  'Role & Level Hierarchy Management',
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
              'PRD Section 6.2: 15 specialized roles across Marketing, Sales, Design, Execution, and After-Sales.',
              style: TextStyle(
                fontSize: 13,
                color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted,
              ),
            ),
          ],
        ),
        ElevatedButton.icon(
          onPressed: () => _showAddRoleModal(isDark),
          icon: const Icon(Icons.add_rounded, size: 16),
          label: const Text('Define New Role'),
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

  Widget _buildKpiMetrics(bool isDark, int totalRoles, int isolatedCount, int membersCount, double width) {
    final cards = [
      _buildMetricCard(
        isDark: isDark,
        title: 'Total Defined Roles',
        value: '$totalRoles Positions',
        sub: 'Across 4 hierarchy tiers',
        icon: Icons.badge_rounded,
        color: const Color(0xFF3B82F6),
      ),
      _buildMetricCard(
        isDark: isDark,
        title: 'Field Isolated Roles',
        value: '$isolatedCount Positions',
        sub: 'Enforcing My Leads Only',
        icon: Icons.lock_person_rounded,
        color: const Color(0xFFF59E0B),
      ),
      _buildMetricCard(
        isDark: isDark,
        title: 'Active Personnel',
        value: '$membersCount Deployed',
        sub: 'Mapped to roles',
        icon: Icons.people_alt_rounded,
        color: const Color(0xFF10B981),
      ),
      _buildMetricCard(
        isDark: isDark,
        title: 'Hierarchy Tiers',
        value: '4 Levels',
        sub: 'Lead, Manager, Specialist, Junior',
        icon: Icons.stairs_rounded,
        color: const Color(0xFF8B5CF6),
      ),
    ];

    if (width < Breakpoints.compact) {
      return Column(
        children: cards.map((c) => Padding(padding: const EdgeInsets.only(bottom: 12), child: c)).toList(),
      );
    }

    return Row(
      children: cards.map((c) => Expanded(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 6), child: c))).toList(),
    );
  }

  Widget _buildMetricCard({
    required bool isDark,
    required String title,
    required String value,
    required String sub,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCardBg : AppColors.pureWhite,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppColors.pureWhite : AppColors.deepNavy,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  sub,
                  style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRolesListCard(bool isDark, List<RoleDefinition> roles) {
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
              Text(
                'Organizational Role Hierarchy Roster',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.pureWhite : AppColors.deepNavy,
                ),
              ),
              DropdownButton<DepartmentType?>(
                value: _selectedDept,
                dropdownColor: isDark ? AppColors.darkCardBg : AppColors.pureWhite,
                underline: const SizedBox(),
                hint: const Text('All Departments'),
                items: [
                  const DropdownMenuItem(value: null, child: Text('All Departments')),
                  ...DepartmentType.values.map((d) => DropdownMenuItem(value: d, child: Text(d.displayName))),
                ],
                onChanged: (val) => setState(() => _selectedDept = val),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            onChanged: (val) => setState(() => _searchQuery = val),
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search_rounded, size: 18),
              hintText: 'Search role title, reporting supervisor, or department...',
              filled: true,
              fillColor: isDark ? AppColors.darkSurface : AppColors.lightBackground,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            ),
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 8),
          if (roles.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Center(
                child: Column(
                  children: [
                    Icon(Icons.search_off_rounded, size: 36, color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted),
                    const SizedBox(height: 10),
                    Text('No roles match the selected filter.', style: TextStyle(color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted)),
                  ],
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: roles.length,
              separatorBuilder: (_, _) => const Divider(height: 24),
              itemBuilder: (context, index) {
                final role = roles[index];
                return _buildRoleRow(isDark, role);
              },
            ),
        ],
      ),
    );
  }

  Widget _buildRoleRow(bool isDark, RoleDefinition role) {
    final isIsolated = role.defaultScope == AccessScope.myLeadsTasks || role.defaultScope == AccessScope.myLeadsOnly;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightBackground,
        borderRadius: BorderRadius.circular(12),
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
                  Text(
                    role.roleTitle,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: isDark ? AppColors.pureWhite : AppColors.deepNavy,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.gold.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      role.departmentType.displayName,
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.gold),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: isIsolated
                          ? const Color(0xFFF59E0B).withValues(alpha: 0.15)
                          : const Color(0xFF10B981).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: isIsolated ? const Color(0xFFF59E0B) : const Color(0xFF10B981),
                        width: 0.8,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(isIsolated ? Icons.lock_person_rounded : Icons.public_rounded, size: 12, color: isIsolated ? const Color(0xFFF59E0B) : const Color(0xFF10B981)),
                        const SizedBox(width: 5),
                        Text(
                          isIsolated ? 'Strict Field Isolation' : 'Organization-Wide',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: isIsolated ? const Color(0xFFF59E0B) : const Color(0xFF10B981),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF3B82F6).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '${role.activeMembersCount} Staff Active',
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF3B82F6)),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.person_pin_circle_rounded, size: 14, color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted),
              const SizedBox(width: 5),
              Text(
                'Reports to: ${role.reportingToRole} • Hierarchy: ${role.hierarchyLevel.displayName}',
                style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted),
              ),
              const Spacer(),
              Text(
                'Salary Band: ₹${NumberFormat('#,##,###').format(role.minSalary)} - ₹${NumberFormat('#,##,###').format(role.maxSalary)} / mo',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF10B981)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: role.responsibilities.map((resp) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkCardBg : AppColors.pureWhite,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                ),
                child: Text('• $resp', style: TextStyle(fontSize: 11, color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted)),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  void _showAddRoleModal(bool isDark) {
    final titleCtrl = TextEditingController();
    final repCtrl = TextEditingController(text: 'Project Manager (PM)');
    final minSalCtrl = TextEditingController(text: '35000');
    final maxSalCtrl = TextEditingController(text: '50000');
    final respCtrl = TextEditingController(text: 'Client interaction, Task completion, Milestone updates');
    DepartmentType selectedDept = DepartmentType.design;
    HierarchyLevel selectedLevel = HierarchyLevel.specialist;
    AccessScope selectedScope = AccessScope.myLeadsTasks;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            backgroundColor: isDark ? AppColors.darkCardBg : AppColors.pureWhite,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: Text('Define Custom Role & Level', style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? AppColors.pureWhite : AppColors.deepNavy)),
            content: SizedBox(
              width: 480,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: 'Role Title *', border: OutlineInputBorder())),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<DepartmentType>(
                      initialValue: selectedDept,
                      decoration: const InputDecoration(labelText: 'Department', border: OutlineInputBorder()),
                      items: DepartmentType.values.map((d) => DropdownMenuItem(value: d, child: Text(d.displayName))).toList(),
                      onChanged: (val) => setDialogState(() => selectedDept = val!),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<HierarchyLevel>(
                      initialValue: selectedLevel,
                      decoration: const InputDecoration(labelText: 'Hierarchy Tier', border: OutlineInputBorder()),
                      items: HierarchyLevel.values.map((l) => DropdownMenuItem(value: l, child: Text(l.displayName))).toList(),
                      onChanged: (val) => setDialogState(() => selectedLevel = val!),
                    ),
                    const SizedBox(height: 12),
                    TextField(controller: repCtrl, decoration: const InputDecoration(labelText: 'Reports To (Supervisor Role) *', border: OutlineInputBorder())),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(child: TextField(controller: minSalCtrl, decoration: const InputDecoration(labelText: 'Min Salary (₹)', border: OutlineInputBorder()), keyboardType: TextInputType.number)),
                        const SizedBox(width: 10),
                        Expanded(child: TextField(controller: maxSalCtrl, decoration: const InputDecoration(labelText: 'Max Salary (₹)', border: OutlineInputBorder()), keyboardType: TextInputType.number)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<AccessScope>(
                      initialValue: selectedScope,
                      decoration: const InputDecoration(labelText: 'Default Data Scope', border: OutlineInputBorder()),
                      items: const [
                        DropdownMenuItem(value: AccessScope.myLeadsTasks, child: Text('My Leads / Tasks Only (Field Strict)')),
                        DropdownMenuItem(value: AccessScope.organizationWide, child: Text('Organization-Wide')),
                      ],
                      onChanged: (val) => setDialogState(() => selectedScope = val!),
                    ),
                    const SizedBox(height: 12),
                    TextField(controller: respCtrl, decoration: const InputDecoration(labelText: 'Key Responsibilities (comma separated) *', border: OutlineInputBorder()), maxLines: 2),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
              ElevatedButton(
                onPressed: () {
                  if (titleCtrl.text.trim().isEmpty) return;
                  final newRole = RoleDefinition(
                    id: 'ROLE-${DateTime.now().millisecondsSinceEpoch}',
                    departmentType: selectedDept,
                    roleTitle: titleCtrl.text.trim(),
                    hierarchyLevel: selectedLevel,
                    reportingToRole: repCtrl.text.trim(),
                    responsibilities: respCtrl.text.trim().split(',').map((s) => s.trim()).toList(),
                    minSalary: double.tryParse(minSalCtrl.text) ?? 30000,
                    maxSalary: double.tryParse(maxSalCtrl.text) ?? 50000,
                    defaultScope: selectedScope,
                    activeMembersCount: 1,
                  );
                  setState(() {
                    _roles.add(newRole);
                  });
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Created role definition: ${newRole.roleTitle}')),
                  );
                },
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.gold, foregroundColor: AppColors.deepNavy),
                child: const Text('Save Role Definition'),
              ),
            ],
          );
        },
      ),
    );
  }
}
