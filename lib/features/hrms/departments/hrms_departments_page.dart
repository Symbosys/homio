import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/responsive/breakpoints.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_radius.dart';
import '../data/hrms_repository.dart';
import '../domain/hrms_domain_models.dart';
import '../widgets/hrms_header.dart';
import '../widgets/hrms_metric_card.dart';

class HrmsDepartmentsPage extends StatefulWidget {
  const HrmsDepartmentsPage({super.key});

  @override
  State<HrmsDepartmentsPage> createState() => _HrmsDepartmentsPageState();
}

class _HrmsDepartmentsPageState extends State<HrmsDepartmentsPage> {
  final _repo = HrmsRepository();

  @override
  void initState() {
    super.initState();
    _repo.addListener(_onRepoChanged);
  }

  @override
  void dispose() {
    _repo.removeListener(_onRepoChanged);
    super.dispose();
  }

  void _onRepoChanged() {
    if (mounted) setState(() {});
  }

  void _openAddDepartmentDialog() {
    final nameCtrl = TextEditingController();
    final codeCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    final budgetCtrl = TextEditingController(text: '5000000');
    String selectedHeadId = _repo.employees.first.id;

    showDialog(
      context: context,
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
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Create Organization Department',
                        style: GoogleFonts.plusJakartaSans(fontSize: 15, fontWeight: FontWeight.w700),
                      ),
                      IconButton(onPressed: () => Navigator.of(ctx).pop(), icon: const Icon(Icons.close, size: 20)),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: TextField(
                          controller: nameCtrl,
                          style: GoogleFonts.plusJakartaSans(fontSize: 12),
                          decoration: const InputDecoration(labelText: 'Department Name', hintText: 'e.g. 3D Renders & VR'),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        flex: 1,
                        child: TextField(
                          controller: codeCtrl,
                          style: GoogleFonts.plusJakartaSans(fontSize: 12),
                          decoration: const InputDecoration(labelText: 'Code', hintText: 'VR'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  DropdownButtonFormField<String>(
                    initialValue: selectedHeadId,
                    dropdownColor: isDark ? const Color(0xFF1A1F2C) : Colors.white,
                    decoration: const InputDecoration(labelText: 'Department Head'),
                    items: _repo.employees.map((e) => DropdownMenuItem(value: e.id, child: Text(e.fullName))).toList(),
                    onChanged: (v) => setModalState(() => selectedHeadId = v!),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  TextField(
                    controller: budgetCtrl,
                    style: GoogleFonts.plusJakartaSans(fontSize: 12),
                    decoration: const InputDecoration(labelText: 'Annual Budget Allocation (INR)', hintText: '5000000'),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  TextField(
                    controller: descCtrl,
                    maxLines: 2,
                    style: GoogleFonts.plusJakartaSans(fontSize: 12),
                    decoration: const InputDecoration(labelText: 'Charter / Functional Description', hintText: 'Space planning, photorealistic lighting...'),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
                      const SizedBox(width: AppSpacing.sm),
                      ElevatedButton(
                        onPressed: () {
                          if (nameCtrl.text.isEmpty || codeCtrl.text.isEmpty) return;
                          final head = _repo.getEmployeeById(selectedHeadId);
                          _repo.addDepartment(
                            Department(
                              id: 'dept_${DateTime.now().millisecondsSinceEpoch}',
                              code: codeCtrl.text.trim().toUpperCase(),
                              name: nameCtrl.text.trim(),
                              description: descCtrl.text.trim(),
                              headEmployeeId: selectedHeadId,
                              headEmployeeName: head?.fullName ?? 'Department Head',
                              totalEmployees: 1,
                              activeCount: 1,
                              budget: double.tryParse(budgetCtrl.text) ?? 5000000.0,
                              createdDate: DateTime.now(),
                            ),
                          );
                          Navigator.of(ctx).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Department registered successfully!')),
                          );
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
                        child: const Text('Create Department'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isCompact = MediaQuery.of(context).size.width < 768;

    final departments = _repo.departments;
    final teams = _repo.teams;
    final totalBudget = departments.fold<double>(0.0, (s, d) => s + d.budget);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0B0E14) : const Color(0xFFF1F5F9),
      body: SingleChildScrollView(
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
                  subtitle: 'Corporate department governance, cross-functional project teams, lead assignments & annual budget allocation',
                  icon: Icons.account_tree_rounded,
                  badgeText: '${departments.length} ACTIVE DEPARTMENTS',
                  actions: [
                    ElevatedButton.icon(
                      onPressed: _openAddDepartmentDialog,
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
                _buildMetrics(context, departments, teams, totalBudget, isCompact),
                const SizedBox(height: AppSpacing.lg),

                // Departments Grid
                Text(
                  'Organizational Departments',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.3,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                _buildDepartmentsGrid(departments, isDark),
                const SizedBox(height: AppSpacing.lg),

                // Cross-Functional Teams Section
                Text(
                  'Specialized Project Teams',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.3,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                _buildTeamsGrid(teams, isDark),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMetrics(BuildContext context, List<Department> departments, List<Team> teams, double totalBudget, bool isCompact) {
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
        subtitle: 'Turnkey & Studio Units',
        icon: Icons.groups_outlined,
        accentColor: const Color(0xFF10B981),
      ),
      HrmsMetricCard(
        title: 'Total Annual Budget',
        value: '₹${(totalBudget / 10000000).toStringAsFixed(2)} Cr',
        subtitle: 'Operational Expenditure',
        icon: Icons.account_balance_wallet_outlined,
        accentColor: const Color(0xFF8B5CF6),
      ),
      HrmsMetricCard(
        title: 'Staff Allocation Rate',
        value: '100% Deployed',
        subtitle: 'Across 5 Hub Offices',
        icon: Icons.pie_chart_outline_rounded,
        accentColor: const Color(0xFFF59E0B),
      ),
    ];

    if (isCompact) {
      return Column(children: cards.map((c) => Padding(padding: const EdgeInsets.only(bottom: 8), child: c)).toList());
    }
    return Row(children: cards.map((c) => Expanded(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 4), child: c))).toList());
  }

  Widget _buildDepartmentsGrid(List<Department> departments, bool isDark) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth < 700 ? 1 : (constraints.maxWidth < 1100 ? 2 : 3);

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: departments.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisExtent: 220,
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
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
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                dept.name,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                                ),
                              ),
                              Text(
                                'Code: ${dept.code}',
                                style: GoogleFonts.plusJakartaSans(fontSize: 10, color: const Color(0xFF94A3B8)),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.1),
                          borderRadius: AppRadius.full,
                        ),
                        child: Text(
                          '${dept.totalEmployees} Staff',
                          style: GoogleFonts.plusJakartaSans(fontSize: 10, fontWeight: FontWeight.w700, color: color),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    dept.description,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Divider(height: 1),
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
                          Text('₹${(dept.budget / 100000).toStringAsFixed(1)} Lacs', style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w700, color: color)),
                        ],
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

  Widget _buildTeamsGrid(List<Team> teams, bool isDark) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth < 700 ? 1 : 2;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: teams.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisExtent: 160,
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
                      Text(
                        team.name,
                        style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w700, color: isDark ? Colors.white : const Color(0xFF0F172A)),
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
                    team.description,
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
                          Text('Lead: ${team.leadEmployeeName}', style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w600)),
                        ],
                      ),
                      Text('${team.memberIds.length} Members', style: GoogleFonts.plusJakartaSans(fontSize: 10, color: const Color(0xFF94A3B8))),
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

  Color _getDeptColor(int index) {
    const colors = [
      Color(0xFF3B82F6),
      Color(0xFF10B981),
      Color(0xFF8B5CF6),
      Color(0xFFF59E0B),
      Color(0xFF06B6D4),
    ];
    return colors[index % colors.length];
  }
}
