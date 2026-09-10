import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/responsive/breakpoints.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_radius.dart';
import '../data/hrms_repository.dart';
import '../domain/hrms_domain_models.dart';
import '../domain/hrms_enums.dart';
import '../widgets/hrms_header.dart';
import '../widgets/hrms_metric_card.dart';
import '../widgets/hrms_filter_bar.dart';
import '../widgets/hrms_data_table.dart';
import '../widgets/hrms_status_badge.dart';
import '../widgets/employee_profile_modal.dart';
import '../widgets/employee_registration_dialog.dart';

class HrmsEmployeesPage extends StatefulWidget {
  const HrmsEmployeesPage({super.key});

  @override
  State<HrmsEmployeesPage> createState() => _HrmsEmployeesPageState();
}

class _HrmsEmployeesPageState extends State<HrmsEmployeesPage> {
  final _repo = HrmsRepository();

  String _searchQuery = '';
  String _selectedStatusFilter = 'all';
  String _selectedDeptId = 'all';
  bool _isGridView = false;
  int _currentPage = 1;
  static const int _pageSize = 8;

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

  List<Employee> get _filteredEmployees {
    EmployeeStatus? status;
    if (_selectedStatusFilter == 'active') status = EmployeeStatus.active;
    if (_selectedStatusFilter == 'probation') status = EmployeeStatus.probation;
    if (_selectedStatusFilter == 'notice') status = EmployeeStatus.noticePeriod;
    if (_selectedStatusFilter == 'leave') status = EmployeeStatus.onLeave;

    return _repo.filterEmployees(
      query: _searchQuery,
      departmentId: _selectedDeptId == 'all' ? null : _selectedDeptId,
      status: status,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isCompact = MediaQuery.of(context).size.width < 768;

    final all = _filteredEmployees;
    final totalRecords = all.length;
    final totalPages = (totalRecords / _pageSize).ceil().clamp(1, 99);
    final startIndex = (_currentPage - 1) * _pageSize;
    final pagedEmployees = all.skip(startIndex).take(_pageSize).toList();

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
                  title: 'Personnel Dossiers & KYC Directory',
                  subtitle: 'Centralized employee records, organizational roles, verified KYC documents & compensation profiles',
                  icon: Icons.badge_rounded,
                  badgeText: '${_repo.employees.length} TOTAL DOSSIERS',
                  actions: [
                    IconButton(
                      icon: Icon(_isGridView ? Icons.view_list_rounded : Icons.grid_view_rounded, size: 20),
                      onPressed: () => setState(() => _isGridView = !_isGridView),
                      tooltip: _isGridView ? 'Switch to Table View' : 'Switch to Grid View',
                    ),
                    OutlinedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Exporting Employee Master Roster (CSV)...')),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        visualDensity: VisualDensity.compact,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      icon: const Icon(Icons.file_download_outlined, size: 16),
                      label: Text('Export Roster', style: GoogleFonts.plusJakartaSans(fontSize: 12)),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => EmployeeRegistrationDialog.show(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        visualDensity: VisualDensity.compact,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      ),
                      icon: const Icon(Icons.person_add_alt_1, size: 16),
                      label: Text('Onboard Employee', style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),

                // Metrics Row
                _buildMetrics(context, isCompact),
                const SizedBox(height: AppSpacing.md),

                // Search & Filter Bar
                HrmsFilterBar(
                  searchHint: 'Search by employee name, code, role, or email...',
                  selectedFilter: _selectedStatusFilter,
                  onSearchChanged: (q) => setState(() {
                    _searchQuery = q;
                    _currentPage = 1;
                  }),
                  filterOptions: [
                    FilterOption(label: 'All Staff', value: 'all', count: _repo.employees.length),
                    FilterOption(label: 'Active', value: 'active', count: _repo.employees.where((e) => e.status == EmployeeStatus.active).length),
                    FilterOption(label: 'Probation', value: 'probation', count: _repo.employees.where((e) => e.status == EmployeeStatus.probation).length),
                    FilterOption(label: 'Notice Period', value: 'notice', count: _repo.employees.where((e) => e.status == EmployeeStatus.noticePeriod).length),
                    FilterOption(label: 'On Leave', value: 'leave', count: _repo.employees.where((e) => e.status == EmployeeStatus.onLeave).length),
                  ],
                  onFilterSelected: (val) => setState(() {
                    _selectedStatusFilter = val;
                    _currentPage = 1;
                  }),
                  trailing: Container(
                    height: 40,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1B202E) : const Color(0xFFF8FAFC),
                      borderRadius: AppRadius.md,
                      border: Border.all(color: isDark ? Colors.white12 : Colors.black12),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedDeptId,
                        dropdownColor: isDark ? const Color(0xFF1A1F2C) : Colors.white,
                        items: [
                          const DropdownMenuItem(value: 'all', child: Text('All Departments')),
                          ..._repo.departments.map((d) => DropdownMenuItem(value: d.id, child: Text(d.name))),
                        ],
                        onChanged: (v) => setState(() {
                          _selectedDeptId = v!;
                          _currentPage = 1;
                        }),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),

                // Table or Grid View
                if (_isGridView)
                  _buildGridView(pagedEmployees, isDark)
                else
                  _buildTableView(pagedEmployees, totalRecords, totalPages, isDark),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMetrics(BuildContext context, bool isCompact) {
    final activeCount = _repo.employees.where((e) => e.status == EmployeeStatus.active).length;
    final probationCount = _repo.employees.where((e) => e.status == EmployeeStatus.probation).length;
    final verifiedKyc = _repo.employees.where((e) => e.kycDocuments.any((d) => d.isVerified)).length;

    final cards = [
      HrmsMetricCard(
        title: 'Active Workforce',
        value: '$activeCount Staff',
        subtitle: 'Confirmed Full-Time',
        icon: Icons.check_circle_outline,
        accentColor: const Color(0xFF10B981),
      ),
      HrmsMetricCard(
        title: 'Probation Tracking',
        value: '$probationCount Staff',
        subtitle: 'Assessment Pending (90d)',
        icon: Icons.timelapse,
        accentColor: const Color(0xFFF59E0B),
      ),
      HrmsMetricCard(
        title: 'Verified KYC Dossiers',
        value: '$verifiedKyc / ${_repo.employees.length}',
        subtitle: 'Aadhaar & PAN Cleared',
        icon: Icons.verified_user_outlined,
        accentColor: const Color(0xFF3B82F6),
      ),
      HrmsMetricCard(
        title: 'Notice Period Exit',
        value: '${_repo.employees.where((e) => e.status == EmployeeStatus.noticePeriod).length} Serving',
        subtitle: 'Handover in Progress',
        icon: Icons.exit_to_app_rounded,
        accentColor: const Color(0xFF8B5CF6),
      ),
    ];

    if (isCompact) {
      return Column(children: cards.map((c) => Padding(padding: const EdgeInsets.only(bottom: 8), child: c)).toList());
    }
    return Row(children: cards.map((c) => Expanded(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 4), child: c))).toList());
  }

  Widget _buildTableView(List<Employee> employees, int totalRecords, int totalPages, bool isDark) {
    return HrmsDataTable(
      columns: const [
        HrmsDataColumn(title: 'EMPLOYEE & CODE'),
        HrmsDataColumn(title: 'DEPARTMENT & ROLE'),
        HrmsDataColumn(title: 'STATUS'),
        HrmsDataColumn(title: 'HUB LOCATION'),
        HrmsDataColumn(title: 'CTC / SALARY'),
        HrmsDataColumn(title: 'ACTIONS', alignment: Alignment.centerRight),
      ],
      currentPage: _currentPage,
      totalPages: totalPages,
      totalRecords: totalRecords,
      onPageChanged: (p) => setState(() => _currentPage = p),
      rows: employees.map((emp) {
        return [
          // Employee Name & Avatar & Code
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 16,
                backgroundImage: NetworkImage(emp.avatarUrl),
                backgroundColor: AppColors.primary.withValues(alpha: 0.2),
                child: Text(emp.initials, style: GoogleFonts.plusJakartaSans(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.primary)),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    emp.fullName,
                    style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700, color: isDark ? Colors.white : const Color(0xFF0F172A)),
                  ),
                  Text(
                    emp.employeeCode,
                    style: GoogleFonts.plusJakartaSans(fontSize: 10, color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8)),
                  ),
                ],
              ),
            ],
          ),

          // Department & Role
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                emp.role,
                style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w600, color: isDark ? Colors.white70 : const Color(0xFF334155)),
              ),
              Text(
                emp.departmentName,
                style: GoogleFonts.plusJakartaSans(fontSize: 10, color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8)),
              ),
            ],
          ),

          // Status Badge
          HrmsStatusBadge.employee(emp.status),

          // Hub Location & Shift
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                emp.workLocationName,
                style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w500, color: isDark ? Colors.white70 : const Color(0xFF475569)),
              ),
              Text(
                emp.shiftName,
                style: GoogleFonts.plusJakartaSans(fontSize: 10, color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8)),
              ),
            ],
          ),

          // Salary & CTC
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '₹${emp.baseSalary.toInt()} /mo',
                style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700, color: isDark ? Colors.white : const Color(0xFF0F172A)),
              ),
              Text(
                'CTC: ₹${(emp.ctc / 100000).toStringAsFixed(1)}L',
                style: GoogleFonts.plusJakartaSans(fontSize: 10, color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8)),
              ),
            ],
          ),

          // Action button
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              OutlinedButton.icon(
                onPressed: () => EmployeeProfileModal.show(context, emp),
                style: OutlinedButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  side: BorderSide(color: AppColors.primary.withValues(alpha: 0.5)),
                  foregroundColor: AppColors.primary,
                ),
                icon: const Icon(Icons.visibility_outlined, size: 14),
                label: Text('Dossier', style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
        ];
      }).toList(),
    );
  }

  Widget _buildGridView(List<Employee> employees, bool isDark) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: employees.length,
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 360,
        mainAxisExtent: 220,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
      ),
      itemBuilder: (context, index) {
        final emp = employees[index];
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundImage: NetworkImage(emp.avatarUrl),
                    child: Text(emp.initials, style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700)),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          emp.fullName,
                          style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w700, color: isDark ? Colors.white : const Color(0xFF0F172A)),
                        ),
                        Text(emp.role, style: GoogleFonts.plusJakartaSans(fontSize: 11, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B))),
                        Text(emp.employeeCode, style: GoogleFonts.plusJakartaSans(fontSize: 10, color: const Color(0xFF94A3B8))),
                      ],
                    ),
                  ),
                  HrmsStatusBadge.employee(emp.status),
                ],
              ),
              const Divider(height: 1),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Department', style: GoogleFonts.plusJakartaSans(fontSize: 11, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B))),
                  Text(emp.departmentName, style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w600)),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Base Salary', style: GoogleFonts.plusJakartaSans(fontSize: 11, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B))),
                  Text('₹${emp.baseSalary.toInt()} /mo', style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w700, color: const Color(0xFF10B981))),
                ],
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => EmployeeProfileModal.show(context, emp),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDark ? const Color(0xFF1B202E) : const Color(0xFFF1F5F9),
                    foregroundColor: isDark ? Colors.white : const Color(0xFF0F172A),
                    elevation: 0,
                    visualDensity: VisualDensity.compact,
                  ),
                  icon: const Icon(Icons.badge_outlined, size: 14),
                  label: Text('View 360° Dossier', style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
