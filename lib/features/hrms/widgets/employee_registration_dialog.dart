import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_radius.dart';
import '../data/hrms_repository.dart';
import '../domain/hrms_domain_models.dart';
import '../domain/hrms_enums.dart';

class EmployeeRegistrationDialog extends StatefulWidget {
  final VoidCallback? onEmployeeRegistered;

  const EmployeeRegistrationDialog({super.key, this.onEmployeeRegistered});

  static void show(BuildContext context, {VoidCallback? onEmployeeRegistered}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720, maxHeight: 680),
          child: EmployeeRegistrationDialog(onEmployeeRegistered: onEmployeeRegistered),
        ),
      ),
    );
  }

  @override
  State<EmployeeRegistrationDialog> createState() => _EmployeeRegistrationDialogState();
}

class _EmployeeRegistrationDialogState extends State<EmployeeRegistrationDialog> {
  final _repo = HrmsRepository();

  int _currentStep = 0;

  // Form controllers
  final _firstNameCtrl = TextEditingController();
  final _lastNameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _roleCtrl = TextEditingController();
  final _baseSalaryCtrl = TextEditingController(text: '65000');
  final _ctcCtrl = TextEditingController(text: '900000');
  final _bankNameCtrl = TextEditingController(text: 'HDFC Bank');
  final _accountNumberCtrl = TextEditingController(text: '501002910839');
  final _ifscCtrl = TextEditingController(text: 'HDFC0000128');

  String _selectedDeptId = 'dept_design';
  EmploymentType _selectedEmploymentType = EmploymentType.fullTime;
  String _selectedWorkLocationId = 'loc_mumbai_hq';
  String _selectedShiftId = 'shift_gen';
  int _noticePeriodDays = 30;

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _roleCtrl.dispose();
    _baseSalaryCtrl.dispose();
    _ctcCtrl.dispose();
    _bankNameCtrl.dispose();
    _accountNumberCtrl.dispose();
    _ifscCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (_firstNameCtrl.text.isEmpty || _lastNameCtrl.text.isEmpty || _emailCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill out all required personal fields.')),
      );
      return;
    }

    final dept = _repo.departments.firstWhere((d) => d.id == _selectedDeptId);
    final loc = _repo.workLocations.firstWhere((l) => l.id == _selectedWorkLocationId);
    final shift = _repo.shifts.firstWhere((s) => s.id == _selectedShiftId);

    final newEmployee = Employee(
      id: 'emp_${DateTime.now().millisecondsSinceEpoch}',
      employeeCode: 'HOM-2026-${(100 + _repo.employees.length + 1)}',
      firstName: _firstNameCtrl.text.trim(),
      lastName: _lastNameCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      phone: _phoneCtrl.text.trim().isNotEmpty ? _phoneCtrl.text.trim() : '+91 98000 00000',
      avatarUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150',
      departmentId: dept.id,
      departmentName: dept.name,
      role: _roleCtrl.text.trim().isNotEmpty ? _roleCtrl.text.trim() : 'Design Associate',
      designation: _roleCtrl.text.trim().isNotEmpty ? _roleCtrl.text.trim() : 'Associate',
      employmentType: _selectedEmploymentType,
      status: EmployeeStatus.probation,
      joinDate: DateTime.now(),
      probationEndDate: DateTime.now().add(const Duration(days: 90)),
      noticePeriodDays: _noticePeriodDays,
      workLocationId: loc.id,
      workLocationName: loc.name,
      shiftId: shift.id,
      shiftName: shift.name,
      baseSalary: double.tryParse(_baseSalaryCtrl.text) ?? 65000.0,
      ctc: double.tryParse(_ctcCtrl.text) ?? 900000.0,
      bankDetails: BankDetails(
        bankName: _bankNameCtrl.text,
        accountNumber: _accountNumberCtrl.text,
        ifscCode: _ifscCtrl.text,
        branchName: 'Corporate Branch',
        accountHolderName: '${_firstNameCtrl.text} ${_lastNameCtrl.text}',
      ),
      skills: ['AutoCAD', 'Interior Space Planning', 'Team Collaboration'],
      createdDate: DateTime.now(),
      updatedDate: DateTime.now(),
    );

    _repo.addEmployee(newEmployee);
    widget.onEmployeeRegistered?.call();
    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Employee ${newEmployee.fullName} registered successfully! (Probation Active)'),
        backgroundColor: const Color(0xFF10B981),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF131722) : Colors.white,
        borderRadius: AppRadius.lg,
        border: Border.all(
          color: isDark ? Colors.white.withValues(alpha: 0.08) : Colors.black.withValues(alpha: 0.06),
        ),
      ),
      child: Column(
        children: [
          // Dialog Title Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: isDark ? Colors.white10 : Colors.black12)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.12),
                        borderRadius: AppRadius.sm,
                      ),
                      child: const Icon(Icons.person_add_alt_1, size: 18, color: AppColors.primary),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Onboard New Team Member',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close, size: 20),
                ),
              ],
            ),
          ),

          // Stepper Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 8),
            color: isDark ? const Color(0xFF181D2A) : const Color(0xFFF8FAFC),
            child: Row(
              children: [
                _stepIndicator(0, 'Personal', isDark),
                _stepDivider(isDark),
                _stepIndicator(1, 'Role & Org', isDark),
                _stepDivider(isDark),
                _stepIndicator(2, 'Compensation', isDark),
              ],
            ),
          ),

          // Step Body
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: _buildCurrentStep(isDark),
            ),
          ),

          // Action Buttons
          Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: isDark ? Colors.white10 : Colors.black12)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (_currentStep > 0)
                  OutlinedButton(
                    onPressed: () => setState(() => _currentStep--),
                    child: Text('Back', style: GoogleFonts.plusJakartaSans(fontSize: 12)),
                  )
                else
                  const SizedBox(),
                ElevatedButton(
                  onPressed: () {
                    if (_currentStep < 2) {
                      setState(() => _currentStep++);
                    } else {
                      _submit();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                  child: Text(
                    _currentStep == 2 ? 'Complete Onboarding' : 'Next Step',
                    style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _stepIndicator(int stepIndex, String title, bool isDark) {
    final isActive = _currentStep == stepIndex;
    final isDone = _currentStep > stepIndex;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: isDone
                ? const Color(0xFF10B981)
                : (isActive ? AppColors.primary : (isDark ? Colors.white12 : Colors.black12)),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: isDone
              ? const Icon(Icons.check, size: 12, color: Colors.white)
              : Text(
                  '${stepIndex + 1}',
                  style: GoogleFonts.plusJakartaSans(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.white),
                ),
        ),
        const SizedBox(width: 6),
        Text(
          title,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
            color: isActive
                ? (isDark ? Colors.white : const Color(0xFF0F172A))
                : (isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8)),
          ),
        ),
      ],
    );
  }

  Widget _stepDivider(bool isDark) {
    return Expanded(
      child: Container(
        height: 1,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        color: isDark ? Colors.white12 : Colors.black12,
      ),
    );
  }

  Widget _buildCurrentStep(bool isDark) {
    switch (_currentStep) {
      case 0:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: _field('First Name *', _firstNameCtrl, 'e.g. Aditi', isDark)),
                const SizedBox(width: AppSpacing.md),
                Expanded(child: _field('Last Name *', _lastNameCtrl, 'e.g. Sen', isDark)),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            _field('Official Email Address *', _emailCtrl, 'e.g. aditi.sen@homio.in', isDark),
            const SizedBox(height: AppSpacing.sm),
            _field('Mobile Phone Number *', _phoneCtrl, 'e.g. +91 98123 45678', isDark),
          ],
        );
      case 1:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _label('Department *', isDark),
            _dropdown<String>(
              value: _selectedDeptId,
              items: _repo.departments.map((d) => DropdownMenuItem(value: d.id, child: Text(d.name))).toList(),
              onChanged: (v) => setState(() => _selectedDeptId = v!),
              isDark: isDark,
            ),
            const SizedBox(height: AppSpacing.sm),
            _field('Designation / Role Title *', _roleCtrl, 'e.g. Senior Interior Architect', isDark),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _label('Employment Type', isDark),
                      _dropdown<EmploymentType>(
                        value: _selectedEmploymentType,
                        items: EmploymentType.values.map((t) => DropdownMenuItem(value: t, child: Text(t.label))).toList(),
                        onChanged: (v) => setState(() => _selectedEmploymentType = v!),
                        isDark: isDark,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _label('Primary Hub Location', isDark),
                      _dropdown<String>(
                        value: _selectedWorkLocationId,
                        items: _repo.workLocations.map((l) => DropdownMenuItem(value: l.id, child: Text(l.name))).toList(),
                        onChanged: (v) => setState(() => _selectedWorkLocationId = v!),
                        isDark: isDark,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _label('Shift Allocation', isDark),
                      _dropdown<String>(
                        value: _selectedShiftId,
                        items: _repo.shifts.map((s) => DropdownMenuItem(value: s.id, child: Text(s.name))).toList(),
                        onChanged: (v) => setState(() => _selectedShiftId = v!),
                        isDark: isDark,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _label('Notice Period Days', isDark),
                      _dropdown<int>(
                        value: _noticePeriodDays,
                        items: const [
                          DropdownMenuItem(value: 15, child: Text('15 Days')),
                          DropdownMenuItem(value: 30, child: Text('30 Days (Standard)')),
                          DropdownMenuItem(value: 45, child: Text('45 Days')),
                          DropdownMenuItem(value: 60, child: Text('60 Days (Leadership)')),
                        ],
                        onChanged: (v) => setState(() => _noticePeriodDays = v!),
                        isDark: isDark,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        );
      case 2:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: _field('Base Monthly Salary (₹) *', _baseSalaryCtrl, '65000', isDark)),
                const SizedBox(width: AppSpacing.md),
                Expanded(child: _field('Annual CTC (₹) *', _ctcCtrl, '900000', isDark)),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            _label('Bank Disbursal Information', isDark),
            Row(
              children: [
                Expanded(child: _field('Bank Name', _bankNameCtrl, 'HDFC Bank', isDark)),
                const SizedBox(width: AppSpacing.md),
                Expanded(child: _field('IFSC Code', _ifscCtrl, 'HDFC0000128', isDark)),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            _field('Account Number', _accountNumberCtrl, '50100XXXXXXXX', isDark),
          ],
        );
      default:
        return const SizedBox();
    }
  }

  Widget _field(String label, TextEditingController ctrl, String hint, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label(label, isDark),
        Container(
          height: 40,
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1B202E) : const Color(0xFFF8FAFC),
            borderRadius: AppRadius.md,
            border: Border.all(color: isDark ? Colors.white12 : Colors.black12),
          ),
          child: TextField(
            controller: ctrl,
            style: GoogleFonts.plusJakartaSans(fontSize: 12, color: isDark ? Colors.white : const Color(0xFF0F172A)),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: GoogleFonts.plusJakartaSans(fontSize: 12, color: const Color(0xFF94A3B8)),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),
          ),
        ),
      ],
    );
  }

  Widget _label(String text, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        text,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569),
        ),
      ),
    );
  }

  Widget _dropdown<T>({
    required T value,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
    required bool isDark,
  }) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1B202E) : const Color(0xFFF8FAFC),
        borderRadius: AppRadius.md,
        border: Border.all(color: isDark ? Colors.white12 : Colors.black12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          isExpanded: true,
          dropdownColor: isDark ? const Color(0xFF1A1F2C) : Colors.white,
          items: items,
          onChanged: onChanged,
        ),
      ),
    );
  }
}
