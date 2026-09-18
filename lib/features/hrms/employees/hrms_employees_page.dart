import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_query_flutter/cached_query_flutter.dart';
import '../../../core/responsive/breakpoints.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_radius.dart';
import '../data/models/hrms_employee_api_model.dart';
import '../presentation/queries/hrms_queries.dart';
import '../widgets/hrms_header.dart';
import '../widgets/hrms_metric_card.dart';
import '../widgets/hrms_filter_bar.dart';
import '../widgets/hrms_data_table.dart';
import '../widgets/hrms_status_badge.dart';
import '../widgets/employee_profile_modal.dart';
import '../widgets/employee_registration_dialog.dart';
import '../widgets/salary_revision_dialog.dart';

class HrmsEmployeesPage extends StatefulWidget {
  const HrmsEmployeesPage({super.key});

  @override
  State<HrmsEmployeesPage> createState() => _HrmsEmployeesPageState();
}

class _HrmsEmployeesPageState extends State<HrmsEmployeesPage> {
  String _searchQuery = '';
  String _selectedStatusFilter = 'all';
  String _selectedEmploymentType = 'all';
  String? _selectedDepartmentId;
  bool _isGridView = false;
  int _currentPage = 1;
  static const int _pageSize = 10;

  Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'ACTIVE':
        return const Color(0xFF10B981);
      case 'PROBATION':
        return const Color(0xFFF59E0B);
      case 'NOTICE_PERIOD':
        return const Color(0xFF8B5CF6);
      case 'TERMINATED':
      case 'RESIGNED':
        return const Color(0xFFEF4444);
      default:
        return const Color(0xFF64748B);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isCompact = MediaQuery.of(context).size.width < 768;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0B0E14) : const Color(0xFFF1F5F9),
      body: QueryBuilder(
        query: hrmsQueries.getEmployeesQuery(
          page: _currentPage,
          limit: _pageSize,
          search: _searchQuery,
          status: _selectedStatusFilter == 'all' ? null : _selectedStatusFilter.toUpperCase(),
          employmentType: _selectedEmploymentType == 'all' ? null : _selectedEmploymentType,
          departmentId: _selectedDepartmentId,
        ),
        builder: (context, state) {
          final isLoading = state.data == null && state.error == null;
          final response = state.data;
          final employees = response?.items ?? [];
          final totalRecords = response?.total ?? 0;
          final totalPages = response?.totalPages ?? 1;

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
                      title: 'Personnel Dossiers & Compensation Directory',
                      subtitle:
                          'Enterprise employee records, organizational roles, statutory KYC, and SCD Type 2 salary tracking',
                      icon: Icons.badge_rounded,
                      badgeText: '$totalRecords REGISTERED EMPLOYEES',
                      actions: [
                        IconButton(
                          icon: Icon(_isGridView ? Icons.view_list_rounded : Icons.grid_view_rounded, size: 20),
                          onPressed: () => setState(() => _isGridView = !_isGridView),
                          tooltip: _isGridView ? 'Switch to Table View' : 'Switch to Grid View',
                        ),
                        IconButton(
                          icon: const Icon(Icons.refresh_rounded, size: 20),
                          onPressed: () => hrmsQueries.invalidateEmployeesCache(),
                          tooltip: 'Refresh Employee Roster',
                        ),
                        ElevatedButton.icon(
                          onPressed: () => EmployeeRegistrationDialog.show(
                            context,
                            onEmployeeSaved: () => hrmsQueries.invalidateEmployeesCache(),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            visualDensity: VisualDensity.compact,
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          ),
                          icon: const Icon(Icons.person_add_alt_1, size: 16),
                          label: Text('Onboard Employee',
                              style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),

                    // Metrics Row
                    _buildMetrics(employees, totalRecords, isCompact),
                    const SizedBox(height: AppSpacing.md),

                    // Search & Filter Bar
                    HrmsFilterBar(
                      searchHint: 'Search by employee name, code, designation, or email...',
                      selectedFilter: _selectedStatusFilter,
                      onSearchChanged: (q) => setState(() {
                        _searchQuery = q;
                        _currentPage = 1;
                      }),
                      filterOptions: [
                        FilterOption(label: 'All Staff', value: 'all', count: totalRecords),
                        const FilterOption(label: 'Active', value: 'active'),
                        const FilterOption(label: 'Probation', value: 'probation'),
                        const FilterOption(label: 'Notice Period', value: 'notice_period'),
                        const FilterOption(label: 'On Leave', value: 'on_leave'),
                      ],
                      onFilterSelected: (val) => setState(() {
                        _selectedStatusFilter = val;
                        _currentPage = 1;
                      }),
                      trailing: Wrap(
                        spacing: AppSpacing.sm,
                        children: [
                          // Department Filter
                          QueryBuilder(
                            query: hrmsQueries.getDepartmentsQuery(limit: 100),
                            builder: (context, deptState) {
                              final departments = deptState.data?.items ?? [];

                              return Container(
                                height: 40,
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                  color: isDark ? const Color(0xFF1B202E) : const Color(0xFFF8FAFC),
                                  borderRadius: AppRadius.md,
                                  border: Border.all(color: isDark ? Colors.white12 : Colors.black12),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String?>(
                                    value: _selectedDepartmentId,
                                    dropdownColor: isDark ? const Color(0xFF1A1F2C) : Colors.white,
                                    hint: const Text('All Departments'),
                                    items: [
                                      const DropdownMenuItem<String?>(
                                        value: null,
                                        child: Text('All Departments'),
                                      ),
                                      ...departments.map((d) => DropdownMenuItem<String?>(
                                            value: d.id,
                                            child: Text('${d.name} (${d.code})'),
                                          )),
                                    ],
                                    onChanged: (v) => setState(() {
                                      _selectedDepartmentId = v;
                                      _currentPage = 1;
                                    }),
                                  ),
                                ),
                              );
                            },
                          ),

                          // Employment Type Filter
                          Container(
                            height: 40,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              color: isDark ? const Color(0xFF1B202E) : const Color(0xFFF8FAFC),
                              borderRadius: AppRadius.md,
                              border: Border.all(color: isDark ? Colors.white12 : Colors.black12),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: _selectedEmploymentType,
                                dropdownColor: isDark ? const Color(0xFF1A1F2C) : Colors.white,
                                items: const [
                                  DropdownMenuItem(value: 'all', child: Text('All Types')),
                                  DropdownMenuItem(value: 'FULL_TIME', child: Text('Full-Time')),
                                  DropdownMenuItem(value: 'PART_TIME', child: Text('Part-Time')),
                                  DropdownMenuItem(value: 'CONTRACT', child: Text('Contract')),
                                  DropdownMenuItem(value: 'INTERN', child: Text('Intern')),
                                  DropdownMenuItem(value: 'PROBATIONARY', child: Text('Probationary')),
                                  DropdownMenuItem(value: 'FREELANCE', child: Text('Freelance')),
                                ],
                                onChanged: (v) => setState(() {
                                  _selectedEmploymentType = v ?? 'all';
                                  _currentPage = 1;
                                }),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),

                    // Table / Grid View / Loading / Empty
                    if (isLoading && employees.isEmpty)
                      Container(
                        height: 300,
                        alignment: Alignment.center,
                        child: const CircularProgressIndicator(),
                      )
                    else if (employees.isEmpty)
                      _buildEmptyState(isDark)
                    else if (_isGridView)
                      _buildGridView(employees, isDark)
                    else
                      _buildTableView(employees, totalRecords, totalPages, isDark),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMetrics(List<HrmsEmployeeApiModel> employees, int totalCount, bool isCompact) {
    final activeCount = employees.where((e) => e.employmentStatus == 'ACTIVE').length;
    final probationCount = employees.where((e) => e.employmentStatus == 'PROBATION').length;
    final noticeCount = employees.where((e) => e.employmentStatus == 'NOTICE_PERIOD').length;

    final cards = [
      HrmsMetricCard(
        title: 'Active Workforce',
        value: '$activeCount Staff',
        subtitle: 'Confirmed Active Status',
        icon: Icons.check_circle_outline,
        accentColor: const Color(0xFF10B981),
      ),
      HrmsMetricCard(
        title: 'Probation Tracking',
        value: '$probationCount Staff',
        subtitle: 'Assessment in Progress',
        icon: Icons.timelapse,
        accentColor: const Color(0xFFF59E0B),
      ),
      HrmsMetricCard(
        title: 'Serving Notice',
        value: '$noticeCount Staff',
        subtitle: 'Exit / Transition Period',
        icon: Icons.exit_to_app_rounded,
        accentColor: const Color(0xFF8B5CF6),
      ),
      HrmsMetricCard(
        title: 'Total Headcount',
        value: '$totalCount Profiles',
        subtitle: 'Organization Roster',
        icon: Icons.groups_rounded,
        accentColor: const Color(0xFF3B82F6),
      ),
    ];

    if (isCompact) {
      return Column(children: cards.map((c) => Padding(padding: const EdgeInsets.only(bottom: 8), child: c)).toList());
    }
    return Row(children: cards.map((c) => Expanded(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 4), child: c))).toList());
  }

  Widget _buildTableView(List<HrmsEmployeeApiModel> employees, int totalRecords, int totalPages, bool isDark) {
    return HrmsDataTable(
      columns: const [
        HrmsDataColumn(title: 'EMPLOYEE & CODE'),
        HrmsDataColumn(title: 'DESIGNATION & TYPE'),
        HrmsDataColumn(title: 'DEPARTMENT & TEAM'),
        HrmsDataColumn(title: 'STATUS'),
        HrmsDataColumn(title: 'LOCATION / HUB'),
        HrmsDataColumn(title: 'ACTIVE CTC / SALARY'),
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
                backgroundImage: emp.avatarUrl != null ? NetworkImage(emp.avatarUrl!) : null,
                backgroundColor: AppColors.primary.withValues(alpha: 0.2),
                child: emp.avatarUrl == null
                    ? Text(emp.initials,
                        style: GoogleFonts.plusJakartaSans(
                            fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.primary))
                    : null,
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    emp.fullName,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                  Text(
                    emp.employeeCode,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10,
                      color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Designation & Employment Type
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                emp.designation,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white70 : const Color(0xFF334155),
                ),
              ),
              Text(
                emp.employmentType.replaceAll('_', ' '),
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 10,
                  color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                ),
              ),
            ],
          ),

          // Department & Team
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (emp.department != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '${emp.department!.name} (${emp.department!.code})',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                )
              else
                Text(
                  'Unassigned',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontStyle: FontStyle.italic,
                    color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                  ),
                ),
              if (emp.team != null) ...[
                const SizedBox(height: 2),
                Text(
                  'Team: ${emp.team!.name}',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10,
                    color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                  ),
                ),
              ],
            ],
          ),

          // Status Badge
          HrmsStatusBadge(
            label: emp.employmentStatus.replaceAll('_', ' '),
            color: _getStatusColor(emp.employmentStatus),
          ),

          // Location
          Text(
            emp.workLocation ?? 'HQ Corporate',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: isDark ? Colors.white70 : const Color(0xFF475569),
            ),
          ),

          // Salary & CTC
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (emp.currentSalary != null) ...[
                Text(
                  '₹${(emp.currentSalary!.annualCtc / 100000).toStringAsFixed(2)}L CTC',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF10B981),
                  ),
                ),
                Text(
                  '₹${emp.currentSalary!.monthlyGross.toInt()} /mo gross',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10,
                    color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                  ),
                ),
              ] else
                Text(
                  'Not Set',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontStyle: FontStyle.italic,
                    color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                  ),
                ),
            ],
          ),

          // Action Buttons
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: const Icon(Icons.payments_outlined, size: 16, color: Color(0xFF8B5CF6)),
                tooltip: 'Revise Salary / View Timeline',
                onPressed: () {
                  SalaryRevisionDialog.show(
                    context,
                    employee: emp,
                    currentSalary: emp.currentSalary,
                    onSalarySaved: () => hrmsQueries.invalidateSalaryCache(emp.id),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.edit_outlined, size: 16, color: Color(0xFF3B82F6)),
                tooltip: 'Edit Employee',
                onPressed: () {
                  EmployeeRegistrationDialog.show(
                    context,
                    employee: emp,
                    onEmployeeSaved: () => hrmsQueries.invalidateEmployeesCache(),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline_rounded, size: 16, color: Color(0xFFEF4444)),
                tooltip: 'Archive Employee',
                onPressed: () => _confirmDelete(emp),
              ),
              const SizedBox(width: 4),
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

  Widget _buildGridView(List<HrmsEmployeeApiModel> employees, bool isDark) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: employees.length,
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 360,
        mainAxisExtent: 230,
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
                    radius: 20,
                    backgroundImage: emp.avatarUrl != null ? NetworkImage(emp.avatarUrl!) : null,
                    child: emp.avatarUrl == null
                        ? Text(emp.initials, style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700))
                        : null,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          emp.fullName,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: isDark ? Colors.white : const Color(0xFF0F172A),
                          ),
                        ),
                        Text(emp.designation,
                            style: GoogleFonts.plusJakartaSans(
                                fontSize: 11, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B))),
                        Text(emp.employeeCode,
                            style: GoogleFonts.plusJakartaSans(fontSize: 10, color: const Color(0xFF94A3B8))),
                      ],
                    ),
                  ),
                  HrmsStatusBadge(
                    label: emp.employmentStatus.replaceAll('_', ' '),
                    color: _getStatusColor(emp.employmentStatus),
                  ),
                ],
              ),
              const Divider(height: 1),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Location',
                      style: GoogleFonts.plusJakartaSans(
                          fontSize: 11, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B))),
                  Text(emp.workLocation ?? 'HQ Corporate',
                      style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w600)),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Active CTC',
                      style: GoogleFonts.plusJakartaSans(
                          fontSize: 11, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B))),
                  Text(
                    emp.currentSalary != null
                        ? '₹${(emp.currentSalary!.annualCtc / 100000).toStringAsFixed(2)} Lacs'
                        : 'Not Assigned',
                    style: GoogleFonts.plusJakartaSans(
                        fontSize: 11, fontWeight: FontWeight.w700, color: const Color(0xFF10B981)),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => EmployeeProfileModal.show(context, emp),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDark ? const Color(0xFF1B202E) : const Color(0xFFF1F5F9),
                        foregroundColor: isDark ? Colors.white : const Color(0xFF0F172A),
                        elevation: 0,
                        visualDensity: VisualDensity.compact,
                      ),
                      icon: const Icon(Icons.badge_outlined, size: 14),
                      label: Text('360° Dossier', style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w600)),
                    ),
                  ),
                  const SizedBox(width: 6),
                  IconButton.filledTonal(
                    icon: const Icon(Icons.payments_rounded, size: 15),
                    tooltip: 'Revise Salary',
                    onPressed: () {
                      SalaryRevisionDialog.show(
                        context,
                        employee: emp,
                        currentSalary: emp.currentSalary,
                        onSalarySaved: () => hrmsQueries.invalidateSalaryCache(emp.id),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xxl),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF131722) : Colors.white,
        borderRadius: AppRadius.lg,
        border: Border.all(color: isDark ? Colors.white12 : Colors.black12),
      ),
      child: Center(
        child: Column(
          children: [
            const Icon(Icons.badge_outlined, size: 48, color: Color(0xFF64748B)),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'No Employee Records Found',
              style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            Text(
              'Try changing your filters or onboard the first employee into the organization roster.',
              style: GoogleFonts.plusJakartaSans(fontSize: 12, color: const Color(0xFF94A3B8)),
            ),
            const SizedBox(height: AppSpacing.md),
            FilledButton.icon(
              style: FilledButton.styleFrom(backgroundColor: AppColors.primary),
              onPressed: () => EmployeeRegistrationDialog.show(
                context,
                onEmployeeSaved: () => hrmsQueries.invalidateEmployeesCache(),
              ),
              icon: const Icon(Icons.person_add_rounded, size: 16),
              label: const Text('Onboard New Employee'),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(HrmsEmployeeApiModel emp) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Archive Employee Profile', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700)),
        content: Text(
          'Are you sure you want to archive ${emp.fullName} (${emp.employeeCode})? This will soft-delete their dossier while retaining historical salary records for audit.',
          style: GoogleFonts.plusJakartaSans(fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: const Color(0xFFEF4444)),
            onPressed: () {
              Navigator.of(ctx).pop();
              final mutation = hrmsQueries.getDeleteEmployeeMutation();
              mutation.mutate(emp.id);
            },
            child: const Text('Archive Profile'),
          ),
        ],
      ),
    );
  }
}
