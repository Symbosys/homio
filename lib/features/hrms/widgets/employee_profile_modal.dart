import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:cached_query_flutter/cached_query_flutter.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_radius.dart';
import '../data/models/hrms_employee_api_model.dart';
import '../data/models/hrms_salary_api_model.dart';
import '../presentation/queries/hrms_queries.dart';
import 'hrms_status_badge.dart';
import 'employee_registration_dialog.dart';
import 'salary_revision_dialog.dart';

class EmployeeProfileModal extends StatefulWidget {
  final HrmsEmployeeApiModel employee;

  const EmployeeProfileModal({super.key, required this.employee});

  static void show(BuildContext context, HrmsEmployeeApiModel employee) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 880, maxHeight: 760),
          child: EmployeeProfileModal(employee: employee),
        ),
      ),
    );
  }

  @override
  State<EmployeeProfileModal> createState() => _EmployeeProfileModalState();
}

class _EmployeeProfileModalState extends State<EmployeeProfileModal>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

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
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return QueryBuilder(
      query: hrmsQueries.getEmployeeDetailQuery(widget.employee.id),
      builder: (context, state) {
        final emp = state.data ?? widget.employee;

        return Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF131722) : Colors.white,
            borderRadius: AppRadius.lg,
            border: Border.all(
              color: isDark ? Colors.white.withValues(alpha: 0.08) : Colors.black.withValues(alpha: 0.06),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            children: [
              // Header Banner & Bio
              _buildHeader(context, emp, isDark),

              // Tab Bar
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: isDark ? Colors.white.withValues(alpha: 0.06) : Colors.black.withValues(alpha: 0.06),
                    ),
                  ),
                ),
                child: TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  labelColor: AppColors.primary,
                  unselectedLabelColor: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                  indicatorColor: AppColors.primary,
                  indicatorWeight: 2.5,
                  labelStyle: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w600),
                  tabs: const [
                    Tab(icon: Icon(Icons.badge_outlined, size: 16), text: 'Dossier & Bio'),
                    Tab(icon: Icon(Icons.contact_phone_outlined, size: 16), text: 'Contacts & Addresses'),
                    Tab(icon: Icon(Icons.verified_user_outlined, size: 16), text: 'Compliance & Banking'),
                    Tab(icon: Icon(Icons.payments_outlined, size: 16), text: 'Compensation & Period History'),
                  ],
                ),
              ),

              // Tab Content
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildDossierTab(emp, isDark),
                    _buildContactsTab(emp, isDark),
                    _buildComplianceTab(emp, isDark),
                    _buildCompensationTab(emp, isDark),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, HrmsEmployeeApiModel emp, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1B202E) : const Color(0xFFF8FAFC),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.lgVal)),
        border: Border(
          bottom: BorderSide(
            color: isDark ? Colors.white.withValues(alpha: 0.06) : Colors.black.withValues(alpha: 0.06),
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: emp.avatarUrl != null ? NetworkImage(emp.avatarUrl!) : null,
            backgroundColor: AppColors.primary.withValues(alpha: 0.2),
            child: emp.avatarUrl == null
                ? Text(emp.initials,
                    style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.primary))
                : null,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      emp.fullName,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        emp.employeeCode,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    HrmsStatusBadge(
                      label: emp.employmentStatus.replaceAll('_', ' '),
                      color: _getStatusColor(emp.employmentStatus),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '${emp.designation} • Joined ${DateFormat('dd MMM yyyy').format(emp.joiningDate)} • ${emp.employmentType.replaceAll('_', ' ')}',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 8),
                // Prominent Department, Team & Role Allocation Badges
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    // Department Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF6366F1).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: const Color(0xFF6366F1).withValues(alpha: 0.28)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.business_rounded, size: 13, color: Color(0xFF6366F1)),
                          const SizedBox(width: 5),
                          Text(
                            emp.department != null
                                ? 'Dept: ${emp.department!.name} (${emp.department!.code})'
                                : 'No Department',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: emp.department != null
                                  ? const Color(0xFF6366F1)
                                  : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Team Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0EA5E9).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: const Color(0xFF0EA5E9).withValues(alpha: 0.28)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.group_work_outlined, size: 13, color: Color(0xFF0EA5E9)),
                          const SizedBox(width: 5),
                          Text(
                            emp.team != null
                                ? 'Team: ${emp.team!.name} (${emp.team!.code})'
                                : 'No Team Assigned',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: emp.team != null
                                  ? const Color(0xFF0EA5E9)
                                  : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Role Badge
                    if (emp.departmentRole != null)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF59E0B).withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: const Color(0xFFF59E0B).withValues(alpha: 0.28)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.stars_rounded, size: 12, color: Color(0xFFF59E0B)),
                            const SizedBox(width: 4),
                            Text(
                              'Role: ${emp.departmentRole!.replaceAll('_', ' ')}',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFFF59E0B),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
            ),
            icon: const Icon(Icons.edit_outlined, size: 15),
            label: Text('Edit Dossier', style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w600)),
            onPressed: () {
              Navigator.of(context).pop();
              EmployeeRegistrationDialog.show(context, employee: emp);
            },
          ),
          const SizedBox(width: AppSpacing.xs),
          IconButton(
            icon: const Icon(Icons.close_rounded, size: 20),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  // Tab 1: Dossier & Bio
  Widget _buildDossierTab(HrmsEmployeeApiModel emp, bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // PROMINENT CARD 1: Department, Team & Role Allocation
          _buildCard(
            title: 'Department, Team & Role Allocation',
            icon: Icons.domain_rounded,
            isDark: isDark,
            children: [
              _infoRow(
                'Department',
                emp.department != null
                    ? '${emp.department!.name} (${emp.department!.code})'
                    : 'Unassigned',
                isDark,
              ),
              _infoRow(
                'Project Team',
                emp.team != null
                    ? '${emp.team!.name} (${emp.team!.code})'
                    : 'No Team Assigned',
                isDark,
              ),
              _infoRow(
                'Department Role',
                emp.departmentRole != null
                    ? emp.departmentRole!.replaceAll('_', ' ')
                    : 'MEMBER (Default)',
                isDark,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          _buildCard(
            title: 'Personal & Demographic Information',
            icon: Icons.person_outline_rounded,
            isDark: isDark,
            children: [
              _infoRow('Display Name', emp.displayName ?? emp.fullName, isDark),
              _infoRow('Gender', emp.gender ?? 'Not Specified', isDark),
              _infoRow('Date of Birth', emp.dateOfBirth != null ? DateFormat('dd MMM yyyy').format(emp.dateOfBirth!) : 'Not Specified', isDark),
              _infoRow('Marital Status', emp.maritalStatus ?? 'Not Specified', isDark),
              _infoRow('Blood Group', emp.bloodGroup?.replaceAll('_', '+') ?? 'Not Specified', isDark),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          _buildCard(
            title: 'Reporting Hierarchy & Key Dates',
            icon: Icons.account_tree_outlined,
            isDark: isDark,
            children: [
              _infoRow('Work Location', emp.workLocation ?? 'HQ Corporate', isDark),
              _infoRow('Assigned Department', emp.department != null ? '${emp.department!.name} (${emp.department!.code})' : 'Unassigned', isDark),
              _infoRow('Project Team', emp.team != null ? '${emp.team!.name} (${emp.team!.code})' : 'No Team Assigned', isDark),
              if (emp.departmentRole != null)
                _infoRow('Department Role', emp.departmentRole!.replaceAll('_', ' '), isDark),
              _infoRow('Reporting Manager', emp.reportingManager != null ? '${emp.reportingManager!.fullName} (${emp.reportingManager!.employeeCode}) - ${emp.reportingManager!.designation}' : 'Direct to Board / Executive', isDark),
              _infoRow('Joining Date', DateFormat('dd MMM yyyy').format(emp.joiningDate), isDark),
              _infoRow('Probation End Date', emp.probationEndDate != null ? DateFormat('dd MMM yyyy').format(emp.probationEndDate!) : 'Confirmed', isDark),
              _infoRow('Confirmation Date', emp.confirmationDate != null ? DateFormat('dd MMM yyyy').format(emp.confirmationDate!) : 'Pending', isDark),
              _infoRow('Notice Period', '${emp.noticePeriodDays} Days', isDark),
              if (emp.subordinates.isNotEmpty)
                _infoRow('Direct Reports (${emp.subordinates.length})', emp.subordinates.map((s) => s.fullName).join(', '), isDark),
            ],
          ),
        ],
      ),
    );
  }

  // Tab 2: Contacts & Dual Addresses
  Widget _buildContactsTab(HrmsEmployeeApiModel emp, bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCard(
            title: 'Contact Information',
            icon: Icons.alternate_email_rounded,
            isDark: isDark,
            children: [
              _infoRow('Work Email', emp.workEmail ?? 'None', isDark),
              _infoRow('Personal Email', emp.personalEmail ?? 'None', isDark),
              _infoRow('Work Phone', emp.workPhone ?? 'None', isDark),
              _infoRow('Personal Phone', emp.personalPhone ?? 'None', isDark),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          _buildCard(
            title: 'Emergency Contact Person',
            icon: Icons.emergency_outlined,
            isDark: isDark,
            children: [
              _infoRow('Name', emp.emergencyContactName ?? 'None', isDark),
              _infoRow('Relationship', emp.emergencyContactRelationship ?? 'None', isDark),
              _infoRow('Phone', emp.emergencyContactPhone ?? 'None', isDark),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          _buildCard(
            title: 'Residential Addresses',
            icon: Icons.home_outlined,
            isDark: isDark,
            children: [
              _infoRow('Current Address', '${emp.currentAddress ?? ""}, ${emp.currentCity ?? ""}, ${emp.currentState ?? ""} - ${emp.currentPincode ?? ""}', isDark),
              _infoRow('Permanent Address', '${emp.permanentAddress ?? ""}, ${emp.permanentCity ?? ""}, ${emp.permanentState ?? ""} - ${emp.permanentPincode ?? ""}', isDark),
            ],
          ),
        ],
      ),
    );
  }

  // Tab 3: Compliance & Banking
  Widget _buildComplianceTab(HrmsEmployeeApiModel emp, bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCard(
            title: 'Statutory Identification & Tax Regime',
            icon: Icons.verified_user_outlined,
            isDark: isDark,
            children: [
              _infoRow('PAN Number', emp.panNumber ?? 'Not Provided', isDark),
              _infoRow('Aadhaar Number', emp.aadhaarNumber != null && emp.aadhaarNumber!.length >= 4 ? 'XXXX-XXXX-${emp.aadhaarNumber!.substring(emp.aadhaarNumber!.length - 4)}' : (emp.aadhaarNumber ?? 'Not Provided'), isDark),
              _infoRow('UAN (PF Number)', emp.uanNumber ?? 'Not Provided', isDark),
              _infoRow('PF Member ID', emp.pfNumber ?? 'Not Provided', isDark),
              _infoRow('ESI Number', emp.esiNumber ?? 'Not Provided', isDark),
              _infoRow('Passport Number', emp.passportNumber ?? 'Not Provided', isDark),
              _infoRow('Income Tax Regime', '${emp.taxRegime} Tax Regime', isDark),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          _buildCard(
            title: 'Bank Account Details (Disbursal)',
            icon: Icons.account_balance_outlined,
            isDark: isDark,
            children: [
              _infoRow('Bank Name', emp.bankName ?? 'Not Provided', isDark),
              _infoRow('Account Holder', emp.bankAccountHolderName ?? emp.fullName, isDark),
              _infoRow('Account Number', emp.bankAccountNumber ?? 'Not Provided', isDark),
              _infoRow('IFSC / SWIFT Code', emp.bankIfscCode ?? 'Not Provided', isDark),
              _infoRow('Branch Name', emp.bankBranchName ?? 'Not Provided', isDark),
            ],
          ),
        ],
      ),
    );
  }

  // Tab 4: Compensation & Period-to-Period Salary History
  Widget _buildCompensationTab(HrmsEmployeeApiModel emp, bool isDark) {
    return QueryBuilder(
      query: hrmsQueries.getSalaryHistoryQuery(emp.id),
      builder: (context, state) {
        if (state.data == null && state.error == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final history = state.data ?? [];
        final activeSalary = history.where((s) => s.isCurrent).firstOrNull ?? emp.currentSalary;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Active Package Card
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Active Compensation Package',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                  FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
                    ),
                    icon: const Icon(Icons.add_rounded, size: 16),
                    label: Text('Revise Salary / Increment',
                        style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700)),
                    onPressed: () {
                      SalaryRevisionDialog.show(
                        context,
                        employee: emp,
                        currentSalary: activeSalary,
                        onSalarySaved: () => hrmsQueries.invalidateSalaryCache(emp.id),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),

              if (activeSalary != null) ...[
                Row(
                  children: [
                    Expanded(
                      child: _buildMetricBox(
                        'Annual CTC Package',
                        '₹${(activeSalary.annualCtc / 100000).toStringAsFixed(2)} Lacs',
                        'Cost to Company',
                        const Color(0xFF8B5CF6),
                        isDark,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: _buildMetricBox(
                        'Monthly Gross',
                        '₹${activeSalary.monthlyGross.toInt()}',
                        'Earnings Before Deductions',
                        const Color(0xFF10B981),
                        isDark,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: _buildMetricBox(
                        'Estimated Net Take-Home',
                        '₹${(activeSalary.monthlyNet ?? (activeSalary.monthlyGross - 2000)).toInt()}',
                        'After PF, PT & TDS',
                        const Color(0xFF3B82F6),
                        isDark,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                _buildCard(
                  title: 'Active Monthly Breakdown Components',
                  icon: Icons.receipt_long_outlined,
                  isDark: isDark,
                  children: [
                    _infoRow('Basic Salary', '₹${activeSalary.basicSalary.toInt()}', isDark),
                    _infoRow('House Rent Allowance (HRA)', '₹${activeSalary.hra.toInt()}', isDark),
                    _infoRow('Special Allowance', '₹${activeSalary.specialAllowance.toInt()}', isDark),
                    _infoRow('Dearness Allowance (DA)', '₹${activeSalary.dearnessAllowance.toInt()}', isDark),
                    _infoRow('PF Employee Share (12%)', '₹${activeSalary.pfEmployee.toInt()}', isDark),
                    _infoRow('Professional Tax (PT)', '₹${activeSalary.professionalTax.toInt()}', isDark),
                    _infoRow('PF Employer Contribution', '₹${activeSalary.pfEmployer.toInt()}', isDark),
                    _infoRow('Effective Starting Date', DateFormat('dd MMM yyyy').format(activeSalary.effectiveFrom), isDark),
                  ],
                ),
              ] else ...[
                Container(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF181D2A) : const Color(0xFFF8FAFC),
                    borderRadius: AppRadius.md,
                    border: Border.all(color: isDark ? Colors.white.withValues(alpha: 0.04) : Colors.black.withValues(alpha: 0.04)),
                  ),
                  child: Center(
                    child: Column(
                      children: [
                        const Icon(Icons.account_balance_wallet_outlined, size: 36, color: Color(0xFF64748B)),
                        const SizedBox(height: 8),
                        Text(
                          'No active compensation record assigned yet.',
                          style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Click "+ Revise Salary / Increment" to record the initial package.',
                          style: GoogleFonts.plusJakartaSans(fontSize: 12, color: const Color(0xFF94A3B8)),
                        ),
                      ],
                    ),
                  ),
                ),
              ],

              const SizedBox(height: AppSpacing.lg),

              // Period-to-Period History Timeline
              Row(
                children: [
                  const Icon(Icons.history_rounded, size: 18, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Text(
                    'Chronological Period-to-Period Salary Revisions',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '${history.length} Revisions',
                      style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),

              if (history.isEmpty)
                Text(
                  'No historical salary revisions on file.',
                  style: GoogleFonts.plusJakartaSans(fontSize: 12, color: const Color(0xFF64748B)),
                )
              else
                ...history.map((salary) => _buildSalaryHistoryCard(salary, isDark)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSalaryHistoryCard(HrmsSalaryApiModel salary, bool isDark) {
    final startStr = DateFormat('dd MMM yyyy').format(salary.effectiveFrom);
    final endStr = salary.effectiveTo != null ? DateFormat('dd MMM yyyy').format(salary.effectiveTo!) : 'Present (Active)';

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF181D2A) : const Color(0xFFF8FAFC),
        borderRadius: AppRadius.md,
        border: Border.all(
          color: salary.isCurrent
              ? AppColors.primary.withValues(alpha: 0.4)
              : (isDark ? Colors.white.withValues(alpha: 0.04) : Colors.black.withValues(alpha: 0.04)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: salary.isCurrent
                          ? const Color(0xFF10B981).withValues(alpha: 0.15)
                          : const Color(0xFF64748B).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      salary.isCurrent ? 'CURRENT ACTIVE' : 'PAST PACKAGE',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: salary.isCurrent ? const Color(0xFF10B981) : const Color(0xFF64748B),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    salary.revisionReason.replaceAll('_', ' '),
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),
              if (salary.percentageHike != null && salary.percentageHike! > 0)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFF8B5CF6).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '+${salary.percentageHike!.toStringAsFixed(1)}% Hike',
                    style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w800, color: const Color(0xFF8B5CF6)),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),

          Row(
            children: [
              Icon(Icons.date_range_rounded, size: 14, color: AppColors.primary),
              const SizedBox(width: 4),
              Text(
                'Period: $startStr  →  $endStr',
                style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w600, color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155)),
              ),
              const Spacer(),
              Text(
                'CTC: ₹${salary.annualCtc.toInt()}  |  Gross: ₹${salary.monthlyGross.toInt()}/mo',
                style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700, color: const Color(0xFF10B981)),
              ),
            ],
          ),

          if (salary.remarks != null && salary.remarks!.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              'Remarks: ${salary.remarks}',
              style: GoogleFonts.plusJakartaSans(fontSize: 11, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B), fontStyle: FontStyle.italic),
            ),
          ],

          if (salary.incrementLetterUrl != null && salary.incrementLetterUrl!.isNotEmpty) ...[
            const SizedBox(height: 8),
            InkWell(
              onTap: () => _viewIncrementLetter(context, salary.incrementLetterUrl!),
              borderRadius: AppRadius.xs,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  borderRadius: AppRadius.xs,
                  border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Image.network(
                        salary.incrementLetterUrl!,
                        width: 26,
                        height: 26,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => const Icon(Icons.description_outlined, size: 18, color: AppColors.primary),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'View Increment Letter',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.open_in_new_rounded, size: 13, color: AppColors.primary),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _viewIncrementLetter(BuildContext context, String url) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 850, maxHeight: 850),
          child: Stack(
            alignment: Alignment.topRight,
            children: [
              InteractiveViewer(
                minScale: 0.5,
                maxScale: 4.0,
                child: Center(
                  child: ClipRRect(
                    borderRadius: AppRadius.md,
                    child: Image.network(
                      url,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => Container(
                        padding: const EdgeInsets.all(AppSpacing.xl),
                        color: Colors.white,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.broken_image_rounded, size: 48, color: Colors.grey),
                            const SizedBox(height: 8),
                            Text('Could not load increment letter image', style: GoogleFonts.plusJakartaSans()),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: CircleAvatar(
                  backgroundColor: Colors.black.withValues(alpha: 0.7),
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.white, size: 20),
                    onPressed: () => Navigator.of(ctx).pop(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard({
    required String title,
    required IconData icon,
    required bool isDark,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF181D2A) : const Color(0xFFF8FAFC),
        borderRadius: AppRadius.md,
        border: Border.all(
          color: isDark ? Colors.white.withValues(alpha: 0.04) : Colors.black.withValues(alpha: 0.04),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
            child: Row(
              children: [
                Icon(icon, size: 16, color: AppColors.primary),
                const SizedBox(width: 6),
                Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: isDark ? Colors.white.withValues(alpha: 0.04) : Colors.black.withValues(alpha: 0.04)),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 170,
            child: Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricBox(String title, String value, String subtitle, Color color, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF181D2A) : const Color(0xFFF8FAFC),
        borderRadius: AppRadius.md,
        border: Border.all(
          color: color.withValues(alpha: 0.25),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: GoogleFonts.plusJakartaSans(fontSize: 11, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B))),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(subtitle, style: GoogleFonts.plusJakartaSans(fontSize: 10, color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8))),
        ],
      ),
    );
  }
}
