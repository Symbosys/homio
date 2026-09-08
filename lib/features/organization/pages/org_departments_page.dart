import 'package:flutter/material.dart';
import '../../../core/responsive/breakpoints.dart';
import '../../../core/theme/app_colors.dart';
import '../models/organization_models.dart';
import '../models/organization_mock_data.dart';

class OrgDepartmentsPage extends StatefulWidget {
  const OrgDepartmentsPage({super.key});

  @override
  State<OrgDepartmentsPage> createState() => _OrgDepartmentsPageState();
}

class _OrgDepartmentsPageState extends State<OrgDepartmentsPage> {
  final List<DepartmentEntity> _departments = List.from(OrganizationMockData.departments);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width >= Breakpoints.medium;

    final totalHeadcount = _departments.fold<int>(0, (sum, d) => sum + d.headcount);
    final totalBudget = _departments.fold<double>(0, (sum, d) => sum + d.monthlyBudgetPool);

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isDesktop ? 24 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(isDark, isDesktop),
            const SizedBox(height: 20),
            _buildKpiMetrics(isDark, _departments.length, totalHeadcount, totalBudget, width),
            const SizedBox(height: 24),
            _buildLifecyclePipelineBanner(isDark),
            const SizedBox(height: 24),
            _buildDepartmentsGrid(isDark, width),
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
                  child: const Icon(Icons.corporate_fare_rounded, color: AppColors.gold, size: 22),
                ),
                const SizedBox(width: 14),
                Text(
                  'Department Structures & Governance',
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
              'PRD Module 3: 5 functional departments with designated heads, budget pools, and operating SLAs.',
              style: TextStyle(
                fontSize: 13,
                color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted,
              ),
            ),
          ],
        ),
        ElevatedButton.icon(
          onPressed: () => _showAddDepartmentModal(isDark),
          icon: const Icon(Icons.add_rounded, size: 16),
          label: const Text('Add Department'),
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

  Widget _buildKpiMetrics(bool isDark, int deptCount, int headcount, double totalBudget, double width) {
    final cards = [
      _buildMetricCard(
        isDark: isDark,
        title: 'Operational Verticals',
        value: '$deptCount Departments',
        sub: 'Core organizational clusters',
        icon: Icons.account_tree_rounded,
        color: const Color(0xFF3B82F6),
      ),
      _buildMetricCard(
        isDark: isDark,
        title: 'Active Headcount',
        value: '$headcount Personnel',
        sub: 'Across all 5 divisions',
        icon: Icons.groups_rounded,
        color: const Color(0xFF10B981),
      ),
      _buildMetricCard(
        isDark: isDark,
        title: 'Monthly Budget Pool',
        value: '₹${(totalBudget / 100000).toStringAsFixed(1)}L / Mo',
        sub: 'Operational & payroll pool',
        icon: Icons.account_balance_wallet_rounded,
        color: AppColors.gold,
      ),
      _buildMetricCard(
        isDark: isDark,
        title: 'Organizational Health',
        value: '99.2% SLA',
        sub: 'Cross-functional efficiency',
        icon: Icons.speed_rounded,
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

  Widget _buildLifecyclePipelineBanner(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCardBg : AppColors.pureWhite,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.alt_route_rounded, size: 18, color: AppColors.gold),
              SizedBox(width: 10),
              Text(
                'INTER-DEPARTMENTAL BUSINESS LIFECYCLE PIPELINE',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 0.5, color: AppColors.gold),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildPipelineStageChip('1. Marketing', 'Ad Spend & CAC', const Color(0xFF8B5CF6), isDark),
                const Icon(Icons.arrow_forward_rounded, size: 16, color: AppColors.gold),
                _buildPipelineStageChip('2. Sales', 'Closing & Deposit', const Color(0xFF3B82F6), isDark),
                const Icon(Icons.arrow_forward_rounded, size: 16, color: AppColors.gold),
                _buildPipelineStageChip('3. Design', '3D BIM Renders', const Color(0xFF10B981), isDark),
                const Icon(Icons.arrow_forward_rounded, size: 16, color: AppColors.gold),
                _buildPipelineStageChip('4. Execution', 'Turnkey Civil', const Color(0xFFF59E0B), isDark),
                const Icon(Icons.arrow_forward_rounded, size: 16, color: AppColors.gold),
                _buildPipelineStageChip('5. After-Sales', '10-Yr Warranty', const Color(0xFFEC4899), isDark),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPipelineStageChip(String title, String subtitle, Color color, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: color)),
            Text(subtitle, style: TextStyle(fontSize: 10, color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted)),
          ],
        ),
      ),
    );
  }

  Widget _buildDepartmentsGrid(bool isDark, double width) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _departments.length,
      separatorBuilder: (_, _) => const SizedBox(height: 18),
      itemBuilder: (context, index) {
        final dept = _departments[index];
        return _buildDepartmentCard(isDark, dept);
      },
    );
  }

  Widget _buildDepartmentCard(bool isDark, DepartmentEntity dept) {
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
                    radius: 22,
                    backgroundColor: AppColors.gold.withValues(alpha: 0.15),
                    child: Text(
                      dept.name.substring(0, 2).toUpperCase(),
                      style: const TextStyle(color: AppColors.gold, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dept.name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: isDark ? AppColors.pureWhite : AppColors.deepNavy,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Lead: ${dept.headOfDepartment} • ${dept.headEmail}',
                        style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF3B82F6).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '${dept.headcount} Staff',
                      style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: Color(0xFF3B82F6)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.gold.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'Budget: ₹${(dept.monthlyBudgetPool / 100000).toStringAsFixed(1)}L/mo',
                      style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: AppColors.gold),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            dept.description,
            style: TextStyle(fontSize: 12.5, color: isDark ? AppColors.pureWhite : AppColors.deepNavy),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.track_changes_rounded, size: 14, color: Color(0xFF10B981)),
              const SizedBox(width: 6),
              Text(
                'Target KPI: ${dept.targetKpi}',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF10B981)),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(),
          const SizedBox(height: 8),
          const Text('CORE FUNCTIONS & CAPABILITIES', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 0.5)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: dept.coreFunctions.map((fn) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : AppColors.lightBackground,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                ),
                child: Text(
                  '• $fn',
                  style: TextStyle(fontSize: 11.5, color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              OutlinedButton.icon(
                onPressed: () => _showEditBudgetModal(isDark, dept),
                icon: const Icon(Icons.tune_rounded, size: 14),
                label: const Text('Adjust Parameters & Budget'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showEditBudgetModal(bool isDark, DepartmentEntity dept) {
    final headCtrl = TextEditingController(text: dept.headOfDepartment);
    final kpiCtrl = TextEditingController(text: dept.targetKpi);
    final budgetCtrl = TextEditingController(text: dept.monthlyBudgetPool.toString());

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? AppColors.darkCardBg : AppColors.pureWhite,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Configure ${dept.name}', style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? AppColors.pureWhite : AppColors.deepNavy)),
        content: SizedBox(
          width: 440,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: headCtrl, decoration: const InputDecoration(labelText: 'Department Head *', border: OutlineInputBorder())),
              const SizedBox(height: 12),
              TextField(controller: kpiCtrl, decoration: const InputDecoration(labelText: 'Target Monthly KPI *', border: OutlineInputBorder())),
              const SizedBox(height: 12),
              TextField(controller: budgetCtrl, decoration: const InputDecoration(labelText: 'Monthly Budget Pool (₹) *', border: OutlineInputBorder()), keyboardType: TextInputType.number),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              setState(() {
                final idx = _departments.indexWhere((d) => d.id == dept.id);
                if (idx != -1) {
                  _departments[idx] = dept.copyWith(
                    headOfDepartment: headCtrl.text.trim(),
                    targetKpi: kpiCtrl.text.trim(),
                    monthlyBudgetPool: double.tryParse(budgetCtrl.text) ?? dept.monthlyBudgetPool,
                  );
                }
              });
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Updated parameters for ${dept.name}')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.gold, foregroundColor: AppColors.deepNavy),
            child: const Text('Save Changes'),
          ),
        ],
      ),
    );
  }

  void _showAddDepartmentModal(bool isDark) {
    final nameCtrl = TextEditingController();
    final headCtrl = TextEditingController();
    final kpiCtrl = TextEditingController();
    final budgetCtrl = TextEditingController(text: '750000');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? AppColors.darkCardBg : AppColors.pureWhite,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Add New Department Cluster', style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? AppColors.pureWhite : AppColors.deepNavy)),
        content: SizedBox(
          width: 440,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Department Name *', border: OutlineInputBorder())),
              const SizedBox(height: 12),
              TextField(controller: headCtrl, decoration: const InputDecoration(labelText: 'Designated Head *', border: OutlineInputBorder())),
              const SizedBox(height: 12),
              TextField(controller: kpiCtrl, decoration: const InputDecoration(labelText: 'Target Monthly KPI *', border: OutlineInputBorder())),
              const SizedBox(height: 12),
              TextField(controller: budgetCtrl, decoration: const InputDecoration(labelText: 'Monthly Budget Pool (₹) *', border: OutlineInputBorder()), keyboardType: TextInputType.number),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (nameCtrl.text.trim().isEmpty) return;
              final newDept = DepartmentEntity(
                id: 'DEPT-${DateTime.now().millisecondsSinceEpoch}',
                name: nameCtrl.text.trim(),
                type: DepartmentType.sales,
                headOfDepartment: headCtrl.text.trim(),
                headEmail: '${headCtrl.text.trim().toLowerCase().replaceAll(' ', '.')}@homio.in',
                headPhone: '+91 98000 11223',
                headcount: 1,
                targetKpi: kpiCtrl.text.trim(),
                monthlyBudgetPool: double.tryParse(budgetCtrl.text) ?? 500000,
                description: 'Specialized business cluster for expanding operational coverage.',
                coreFunctions: const ['Strategic Planning', 'Cross-Team Execution'],
              );
              setState(() {
                _departments.add(newDept);
              });
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Added new department: ${newDept.name}')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.gold, foregroundColor: AppColors.deepNavy),
            child: const Text('Create Department'),
          ),
        ],
      ),
    );
  }
}
