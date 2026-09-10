import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_radius.dart';
import '../domain/hrms_domain_models.dart';
import '../domain/hrms_enums.dart';
import 'hrms_status_badge.dart';

class EmployeeProfileModal extends StatefulWidget {
  final Employee employee;

  const EmployeeProfileModal({super.key, required this.employee});

  static void show(BuildContext context, Employee employee) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 860, maxHeight: 720),
          child: EmployeeProfileModal(employee: employee),
        ),
      ),
    );
  }

  @override
  State<EmployeeProfileModal> createState() => _EmployeeProfileModalState();
}

class _EmployeeProfileModalState extends State<EmployeeProfileModal> with SingleTickerProviderStateMixin {
  late TabController _tabController;

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
    final emp = widget.employee;

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
          // Modal Header with Banner & Avatar
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
                Tab(icon: Icon(Icons.badge_outlined, size: 16), text: 'Dossier & Role'),
                Tab(icon: Icon(Icons.verified_user_outlined, size: 16), text: 'KYC & Banking'),
                Tab(icon: Icon(Icons.event_available_outlined, size: 16), text: 'Attendance & Leaves'),
                Tab(icon: Icon(Icons.payments_outlined, size: 16), text: 'Payroll & CTC'),
              ],
            ),
          ),

          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildDossierTab(emp, isDark),
                _buildKycBankingTab(emp, isDark),
                _buildAttendanceLeavesTab(emp, isDark),
                _buildPayrollTab(emp, isDark),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, Employee emp, bool isDark) {
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
            backgroundImage: NetworkImage(emp.avatarUrl),
            onBackgroundImageError: (exception, stackTrace) {},
            backgroundColor: AppColors.primary.withValues(alpha: 0.2),
            child: Text(
              emp.initials,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
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
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(width: 8),
                    HrmsStatusBadge.employee(emp.status),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: emp.employmentType.color.withValues(alpha: 0.12),
                        borderRadius: AppRadius.full,
                      ),
                      child: Text(
                        emp.employmentType.label,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: emp.employmentType.color,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  '${emp.role} • ${emp.departmentName} • Code: ${emp.employeeCode}',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.location_city_outlined, size: 13, color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8)),
                    const SizedBox(width: 4),
                    Text(
                      emp.workLocationName,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Icon(Icons.schedule_outlined, size: 13, color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8)),
                    const SizedBox(width: 4),
                    Text(
                      emp.shiftName,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close, size: 20),
            tooltip: 'Close Modal',
          ),
        ],
      ),
    );
  }

  Widget _buildDossierTab(Employee emp, bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionCard(
            title: 'Employment & Org Positioning',
            icon: Icons.business_outlined,
            isDark: isDark,
            children: [
              _infoTile('Official Email', emp.email, isDark),
              _infoTile('Contact Phone', emp.phone, isDark),
              _infoTile('Reporting Manager', emp.reportingManagerName ?? 'Executive Leadership', isDark),
              _infoTile('Joining Date', '${emp.joinDate.day}/${emp.joinDate.month}/${emp.joinDate.year}', isDark),
              _infoTile('Notice Period', '${emp.noticePeriodDays} Calendar Days', isDark),
              _infoTile('Shift Allocation', emp.shiftName, isDark),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          _buildSectionCard(
            title: 'Key Competencies & Architectural Skills',
            icon: Icons.psychology_outlined,
            isDark: isDark,
            children: [
              Padding(
                padding: const EdgeInsets.all(AppSpacing.sm),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: emp.skills.map((s) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: isDark ? 0.2 : 0.08),
                        borderRadius: AppRadius.md,
                        border: Border.all(color: AppColors.primary.withValues(alpha: 0.25)),
                      ),
                      child: Text(
                        s,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildKycBankingTab(Employee emp, bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionCard(
            title: 'Bank Details (Direct Deposit)',
            icon: Icons.account_balance_outlined,
            isDark: isDark,
            children: [
              _infoTile('Bank Name', emp.bankDetails?.bankName ?? 'Not Configured', isDark),
              _infoTile('Account Number', emp.bankDetails?.accountNumber ?? 'Pending', isDark),
              _infoTile('IFSC Code', emp.bankDetails?.ifscCode ?? 'Pending', isDark),
              _infoTile('Branch', emp.bankDetails?.branchName ?? 'Corporate Office', isDark),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          _buildSectionCard(
            title: 'Verified Identification & Compliance (KYC)',
            icon: Icons.verified_user_outlined,
            isDark: isDark,
            children: emp.kycDocuments.isEmpty
                ? [
                    Padding(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: Text(
                        'Standard Aadhaar & PAN on file with HR operations.',
                        style: GoogleFonts.plusJakartaSans(fontSize: 12, color: isDark ? Colors.white60 : Colors.black54),
                      ),
                    ),
                  ]
                : emp.kycDocuments.map((doc) {
                    return ListTile(
                      dense: true,
                      leading: const Icon(Icons.description_outlined, color: Color(0xFF10B981)),
                      title: Text(
                        doc.type.label,
                        style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(
                        'Document ID: ${doc.documentNumber} • Verified by ${doc.verifiedBy ?? "HR Admin"}',
                        style: GoogleFonts.plusJakartaSans(fontSize: 11),
                      ),
                      trailing: const Icon(Icons.check_circle, size: 16, color: Color(0xFF10B981)),
                    );
                  }).toList(),
          ),
          const SizedBox(height: AppSpacing.md),
          if (emp.emergencyContact != null)
            _buildSectionCard(
              title: 'Emergency Contact Details',
              icon: Icons.contact_phone_outlined,
              isDark: isDark,
              children: [
                _infoTile('Primary Contact', emp.emergencyContact!.name, isDark),
                _infoTile('Relationship', emp.emergencyContact!.relationship, isDark),
                _infoTile('Phone Number', emp.emergencyContact!.phone, isDark),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildAttendanceLeavesTab(Employee emp, bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: _buildBalanceCard('Casual Leave (CL)', '6.0 Left', '8.0 Allocated', const Color(0xFF3B82F6), isDark),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _buildBalanceCard('Sick Leave (SL)', '5.0 Left', '7.0 Allocated', const Color(0xFFEF4444), isDark),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _buildBalanceCard('Earned Leave (EL)', '12.0 Left', '15.0 Allocated', const Color(0xFF10B981), isDark),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          _buildSectionCard(
            title: 'Attendance Policy & Geofence Status',
            icon: Icons.location_on_outlined,
            isDark: isDark,
            children: [
              _infoTile('Primary Geofence Zone', emp.workLocationName, isDark),
              _infoTile('Current Month Attendance', '96.2% On-Time Rate', isDark),
              _infoTile('Penalty Deductions Incurred', '0 Days', isDark),
              _infoTile('Average Working Hours/Day', '8.4 Hours', isDark),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPayrollTab(Employee emp, bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: _buildBalanceCard('Base Monthly Salary', '₹${emp.baseSalary.toInt()}', 'Fixed Compensation', const Color(0xFF10B981), isDark),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _buildBalanceCard('Annual CTC Package', '₹${(emp.ctc / 100000).toStringAsFixed(2)} Lacs', 'Inclusive of Retirals', const Color(0xFF8B5CF6), isDark),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          _buildSectionCard(
            title: 'Standard Salary Component Breakdown',
            icon: Icons.receipt_long_outlined,
            isDark: isDark,
            children: [
              _infoTile('Basic Salary (50%)', '₹${(emp.baseSalary * 0.5).toInt()}', isDark),
              _infoTile('House Rent Allowance (HRA 40%)', '₹${(emp.baseSalary * 0.2).toInt()}', isDark),
              _infoTile('Special Allowance', '₹${(emp.baseSalary * 0.3).toInt()}', isDark),
              _infoTile('Provident Fund (Employee)', '₹1,800', isDark),
              _infoTile('Professional Tax (PT)', '₹200', isDark),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
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
            padding: const EdgeInsets.all(AppSpacing.sm),
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
          const Divider(height: 1),
          ...children,
        ],
      ),
    );
  }

  Widget _infoTile(String label, String value, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
            ),
          ),
          Text(
            value,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceCard(String title, String mainValue, String sub, Color color, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF181D2A) : const Color(0xFFF8FAFC),
        borderRadius: AppRadius.md,
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            mainValue,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          Text(
            sub,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 10,
              color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
            ),
          ),
        ],
      ),
    );
  }
}
