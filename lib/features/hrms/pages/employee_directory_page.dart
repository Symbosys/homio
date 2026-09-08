import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/responsive/breakpoints.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../models/hrms_mock_data.dart';
import '../models/hrms_models.dart';

class EmployeeDirectoryPage extends StatefulWidget {
  const EmployeeDirectoryPage({super.key});

  @override
  State<EmployeeDirectoryPage> createState() => _EmployeeDirectoryPageState();
}

class _EmployeeDirectoryPageState extends State<EmployeeDirectoryPage> {
  late List<EmployeeDossier> _employees;
  DepartmentType? _deptFilter;
  EmployeeStatus? _statusFilter;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _employees = List.from(HrmsMockData.employees);
  }

  List<EmployeeDossier> get _filteredEmployees {
    return _employees.where((e) {
      if (_deptFilter != null && e.department != _deptFilter) return false;
      if (_statusFilter != null && e.status != _statusFilter) return false;
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final match = e.fullName.toLowerCase().contains(q) ||
            e.roleTitle.toLowerCase().contains(q) ||
            e.email.toLowerCase().contains(q) ||
            e.phone.toLowerCase().contains(q);
        if (!match) return false;
      }
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isMobile = MediaQuery.of(context).size.width < 768;

    final totalCount = _employees.length;
    final activeCount = _employees.where((e) => e.status == EmployeeStatus.active).length;
    final kycCompliantCount = _employees.where((e) => e.kyc.isFullyCompliant).length;
    final noticeCount = _employees.where((e) => e.status == EmployeeStatus.noticePeriod).length;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 16 : 28,
          vertical: 24,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: Breakpoints.maxContentWidth),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Header Banner
                _buildHeader(context, isDark, isMobile),

                const SizedBox(height: 20),

                // 2. Metrics Summary Bar
                _buildMetricsBar(isDark, isMobile, totalCount, activeCount, kycCompliantCount, noticeCount),

                const SizedBox(height: 24),

                // 3. Search & Filter Bar
                _buildFilterBar(isDark, isMobile),

                const SizedBox(height: 20),

                // 4. Employee Dossiers Grid
                if (_filteredEmployees.isEmpty)
                  _buildEmptyState(isDark)
                else
                  _buildEmployeeGrid(context, isDark, isMobile),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark, bool isMobile) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 18 : 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF1E1435), const Color(0xFF131127), const Color(0xFF0F172A)]
              : [const Color(0xFFFAF5FF), const Color(0xFFF3E8FF), Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: AppRadius.lg,
        border: Border.all(
          color: const Color(0xFF8B5CF6).withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFF8B5CF6).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFF8B5CF6).withValues(alpha: 0.4)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.groups_rounded, size: 14, color: Color(0xFF8B5CF6)),
                    const SizedBox(width: 6),
                    Text(
                      'MODULE 13: HRMS & PERSONNEL DIRECTORY',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF8B5CF6),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
              FilledButton.icon(
                onPressed: () => _showOnboardingWizard(context),
                icon: const Icon(Icons.person_add_alt_1_rounded, size: 16),
                label: Text(
                  'Onboard Employee',
                  style: GoogleFonts.plusJakartaSans(fontSize: 12.5, fontWeight: FontWeight.w700),
                ),
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF8B5CF6),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            'Employee Personnel Dossier & KYC Verification Hub',
            style: GoogleFonts.plusJakartaSans(
              fontSize: isMobile ? 20 : 24,
              fontWeight: FontWeight.w800,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Comprehensive internal personnel roster with Aadhaar/PAN validation, linked bank accounts, signed employment agreements, emergency contacts, and granular role permissions.',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricsBar(bool isDark, bool isMobile, int total, int active, int kyc, int notice) {
    final items = [
      (label: 'Total Personnel', value: '$total Staff', sub: 'Across 5 departments', color: const Color(0xFF6366F1), icon: Icons.badge_rounded),
      (label: 'Active on Duty', value: '$active Staff', sub: '${((active / total) * 100).toInt()}% operational', color: const Color(0xFF10B981), icon: Icons.check_circle_rounded),
      (label: 'Full KYC Compliance', value: '$kyc / $total', sub: 'Aadhaar, PAN & Bank', color: const Color(0xFF0EA5E9), icon: Icons.verified_user_rounded),
      (label: 'Notice Period Staff', value: '$notice Staff', sub: 'Handoff in progress', color: const Color(0xFFF59E0B), icon: Icons.exit_to_app_rounded),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 700;
        final cardWidth = isWide ? (constraints.maxWidth - 36) / 4 : (constraints.maxWidth - 12) / 2;

        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: items.map((item) {
            return SizedBox(
              width: cardWidth,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : Colors.white,
                  borderRadius: AppRadius.md,
                  border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: item.color.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(item.icon, size: 22, color: item.color),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.label,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            item.value,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: isDark ? Colors.white : const Color(0xFF0F172A),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            item.sub,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.plusJakartaSans(fontSize: 10, fontWeight: FontWeight.w600, color: item.color),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildFilterBar(bool isDark, bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: AppRadius.md,
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        crossAxisAlignment: WrapCrossAlignment.center,
        alignment: WrapAlignment.spaceBetween,
        children: [
          // Search Input
          SizedBox(
            width: isMobile ? double.infinity : 320,
            height: 40,
            child: TextField(
              onChanged: (val) => setState(() => _searchQuery = val),
              decoration: InputDecoration(
                hintText: 'Search by name, role, email or phone...',
                hintStyle: GoogleFonts.plusJakartaSans(fontSize: 12.5),
                prefixIcon: const Icon(Icons.search_rounded, size: 18),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                filled: true,
                fillColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1)),
                ),
              ),
            ),
          ),

          // Filters
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              // Department Filter
              DropdownButton<DepartmentType?>(
                value: _deptFilter,
                underline: const SizedBox(),
                hint: Text('All Departments', style: GoogleFonts.plusJakartaSans(fontSize: 12.5)),
                dropdownColor: isDark ? const Color(0xFF1E293B) : Colors.white,
                items: [
                  DropdownMenuItem(value: null, child: Text('All Departments', style: GoogleFonts.plusJakartaSans(fontSize: 12.5))),
                  DropdownMenuItem(value: DepartmentType.marketing, child: Text('Marketing', style: GoogleFonts.plusJakartaSans(fontSize: 12.5))),
                  DropdownMenuItem(value: DepartmentType.sales, child: Text('Sales CRM', style: GoogleFonts.plusJakartaSans(fontSize: 12.5))),
                  DropdownMenuItem(value: DepartmentType.design, child: Text('Design & 3D', style: GoogleFonts.plusJakartaSans(fontSize: 12.5))),
                  DropdownMenuItem(value: DepartmentType.execution, child: Text('Site Execution', style: GoogleFonts.plusJakartaSans(fontSize: 12.5))),
                  DropdownMenuItem(value: DepartmentType.afterSales, child: Text('After-Sales', style: GoogleFonts.plusJakartaSans(fontSize: 12.5))),
                ],
                onChanged: (val) => setState(() => _deptFilter = val),
              ),

              // Status Filter
              DropdownButton<EmployeeStatus?>(
                value: _statusFilter,
                underline: const SizedBox(),
                hint: Text('All Statuses', style: GoogleFonts.plusJakartaSans(fontSize: 12.5)),
                dropdownColor: isDark ? const Color(0xFF1E293B) : Colors.white,
                items: [
                  DropdownMenuItem(value: null, child: Text('All Statuses', style: GoogleFonts.plusJakartaSans(fontSize: 12.5))),
                  DropdownMenuItem(value: EmployeeStatus.active, child: Text('Active Only', style: GoogleFonts.plusJakartaSans(fontSize: 12.5))),
                  DropdownMenuItem(value: EmployeeStatus.onLeave, child: Text('On Leave', style: GoogleFonts.plusJakartaSans(fontSize: 12.5))),
                  DropdownMenuItem(value: EmployeeStatus.noticePeriod, child: Text('Notice Period', style: GoogleFonts.plusJakartaSans(fontSize: 12.5))),
                ],
                onChanged: (val) => setState(() => _statusFilter = val),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmployeeGrid(BuildContext context, bool isDark, bool isMobile) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 700;
        final cardWidth = isWide ? (constraints.maxWidth - 16) / 2 : double.infinity;

        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: _filteredEmployees.map((emp) {
            return SizedBox(
              width: cardWidth,
              child: _buildEmployeeCard(context, emp, isDark),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildEmployeeCard(BuildContext context, EmployeeDossier emp, bool isDark) {
    Color deptColor;
    switch (emp.department) {
      case DepartmentType.marketing:
        deptColor = const Color(0xFFEC4899);
        break;
      case DepartmentType.sales:
        deptColor = const Color(0xFF6366F1);
        break;
      case DepartmentType.design:
        deptColor = const Color(0xFF8B5CF6);
        break;
      case DepartmentType.execution:
        deptColor = const Color(0xFFF59E0B);
        break;
      case DepartmentType.afterSales:
        deptColor = const Color(0xFF10B981);
        break;
    }

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: AppRadius.md,
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row: Avatar + Info + Department Badge
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 26,
                backgroundImage: NetworkImage(emp.avatarUrl),
                backgroundColor: deptColor.withValues(alpha: 0.15),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            emp.fullName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: isDark ? Colors.white : const Color(0xFF0F172A),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(
                            color: deptColor.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            emp.departmentName.toUpperCase(),
                            style: GoogleFonts.plusJakartaSans(fontSize: 9.5, fontWeight: FontWeight.w800, color: deptColor),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      emp.roleTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${emp.email}  •  ${emp.phone}',
                      style: GoogleFonts.plusJakartaSans(fontSize: 11, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // KYC Badges Strip
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildKycPill('Aadhaar', emp.kyc.aadhaarVerified, isDark),
                _buildKycPill('PAN', emp.kyc.panVerified, isDark),
                _buildKycPill('Bank', emp.kyc.bankAccountLinked, isDark),
                _buildKycPill('Agreement', emp.kyc.signedAgreementAttached, isDark),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Bottom Action & Scope Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    emp.accessScope == AccessScope.organizationWide ? Icons.public_rounded : Icons.lock_outline_rounded,
                    size: 13,
                    color: const Color(0xFF94A3B8),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    emp.accessScope == AccessScope.organizationWide ? 'Org-Wide Access' : 'My Leads / Tasks Only',
                    style: GoogleFonts.plusJakartaSans(fontSize: 10.5, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                  ),
                ],
              ),
              OutlinedButton.icon(
                onPressed: () => _showDossierDrawer(context, emp),
                icon: const Icon(Icons.badge_rounded, size: 13),
                label: Text('Full Dossier', style: GoogleFonts.plusJakartaSans(fontSize: 11.5, fontWeight: FontWeight.w700)),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  side: BorderSide(color: isDark ? const Color(0xFF64748B) : const Color(0xFFCBD5E1)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildKycPill(String label, bool isDone, bool isDark) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          isDone ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
          size: 12,
          color: isDone ? const Color(0xFF10B981) : (isDark ? Colors.white30 : Colors.black26),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 10.5,
            fontWeight: isDone ? FontWeight.w700 : FontWeight.w500,
            color: isDone ? (isDark ? const Color(0xFFA7F3D0) : const Color(0xFF065F46)) : (isDark ? Colors.white38 : Colors.black38),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(40),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: AppRadius.md,
      ),
      child: Text(
        'No matching employees found in directory.',
        style: GoogleFonts.plusJakartaSans(fontSize: 14, color: const Color(0xFF94A3B8)),
      ),
    );
  }

  void _showDossierDrawer(BuildContext context, EmployeeDossier emp) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text('${emp.fullName} - Personnel Dossier', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800)),
          content: SizedBox(
            width: 480,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildDossierRow('Department', emp.departmentName),
                  _buildDossierRow('Designation', emp.roleTitle),
                  _buildDossierRow('Monthly Base Pay', '₹${emp.baseSalary.toInt()} / month'),
                  _buildDossierRow('Joining Date', '${emp.joiningDate.day}/${emp.joiningDate.month}/${emp.joiningDate.year}'),
                  _buildDossierRow('Access Permission Scope', emp.accessScope == AccessScope.organizationWide ? 'Organization-Wide' : 'My Leads / Tasks Only'),
                  const Divider(height: 20),
                  Text('KYC & Financial Compliance:', style: GoogleFonts.plusJakartaSans(fontSize: 12.5, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 6),
                  _buildDossierRow('Aadhaar Card', emp.kyc.aadhaarNumber ?? 'Verified', isGreen: emp.kyc.aadhaarVerified),
                  _buildDossierRow('PAN Card', emp.kyc.panNumber ?? 'Verified', isGreen: emp.kyc.panVerified),
                  _buildDossierRow('Bank Account', '${emp.kyc.bankAccountNumber ?? 'Linked'} (IFSC: ${emp.kyc.ifscCode ?? 'HDFC'})', isGreen: emp.kyc.bankAccountLinked),
                  _buildDossierRow('Employment Contract', emp.kyc.signedAgreementAttached ? 'Digitally Signed & Archived' : 'Pending', isGreen: emp.kyc.signedAgreementAttached),
                  const Divider(height: 20),
                  Text('Emergency Contact:', style: GoogleFonts.plusJakartaSans(fontSize: 12.5, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 6),
                  _buildDossierRow('Contact Person', emp.emergencyContactName),
                  _buildDossierRow('Phone Number', emp.emergencyContactPhone),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close')),
          ],
        );
      },
    );
  }

  Widget _buildDossierRow(String label, String value, {bool isGreen = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.plusJakartaSans(fontSize: 12, color: const Color(0xFF94A3B8))),
          Text(
            value,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: isGreen ? const Color(0xFF10B981) : null,
            ),
          ),
        ],
      ),
    );
  }

  void _showOnboardingWizard(BuildContext context) {
    final nameCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    final roleCtrl = TextEditingController();
    final salaryCtrl = TextEditingController(text: '50000');
    DepartmentType selectedDept = DepartmentType.execution;

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: Text('Onboard New Personnel', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800)),
              content: SizedBox(
                width: 480,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Full Name')),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(child: TextField(controller: emailCtrl, decoration: const InputDecoration(labelText: 'Company Email'))),
                          const SizedBox(width: 12),
                          Expanded(child: TextField(controller: phoneCtrl, decoration: const InputDecoration(labelText: 'Phone Number'))),
                        ],
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<DepartmentType>(
                        initialValue: selectedDept,
                        decoration: const InputDecoration(labelText: 'Department'),
                        items: DepartmentType.values.map((d) {
                          String name = d.name.toUpperCase();
                          return DropdownMenuItem(value: d, child: Text(name));
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) setDialogState(() => selectedDept = val);
                        },
                      ),
                      const SizedBox(height: 12),
                      TextField(controller: roleCtrl, decoration: const InputDecoration(labelText: 'Designation / Role Title')),
                      const SizedBox(height: 12),
                      TextField(
                        controller: salaryCtrl,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'Monthly Base Salary (₹)'),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
                FilledButton(
                  onPressed: () {
                    if (nameCtrl.text.isNotEmpty) {
                      setState(() {
                        _employees.insert(
                          0,
                          EmployeeDossier(
                            id: 'EMP-${_employees.length + 1}',
                            fullName: nameCtrl.text,
                            email: emailCtrl.text.isNotEmpty ? emailCtrl.text : 'staff@homio.in',
                            phone: phoneCtrl.text.isNotEmpty ? phoneCtrl.text : '+91 98000 00000',
                            avatarUrl: 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=150',
                            department: selectedDept,
                            roleTitle: roleCtrl.text.isNotEmpty ? roleCtrl.text : 'Team Member',
                            level: HierarchyLevel.specialist,
                            joiningDate: DateTime.now(),
                            status: EmployeeStatus.active,
                            accessScope: AccessScope.myLeadsTasks,
                            kyc: const KycVerification(
                              aadhaarVerified: true,
                              panVerified: true,
                              bankAccountLinked: true,
                              signedAgreementAttached: true,
                            ),
                            baseSalary: double.tryParse(salaryCtrl.text) ?? 50000,
                            emergencyContactName: 'Primary Contact',
                            emergencyContactPhone: '+91 98000 00001',
                          ),
                        );
                      });
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Employee onboarded into Homio Directory!')),
                      );
                    }
                  },
                  child: const Text('Complete Onboarding'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
