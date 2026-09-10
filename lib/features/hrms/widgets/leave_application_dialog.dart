import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_radius.dart';
import '../data/hrms_repository.dart';
import '../domain/hrms_domain_models.dart';
import '../domain/hrms_enums.dart';

class LeaveApplicationDialog extends StatefulWidget {
  final VoidCallback? onLeaveApplied;

  const LeaveApplicationDialog({super.key, this.onLeaveApplied});

  static void show(BuildContext context, {VoidCallback? onLeaveApplied}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 580),
          child: LeaveApplicationDialog(onLeaveApplied: onLeaveApplied),
        ),
      ),
    );
  }

  @override
  State<LeaveApplicationDialog> createState() => _LeaveApplicationDialogState();
}

class _LeaveApplicationDialogState extends State<LeaveApplicationDialog> {
  final _repo = HrmsRepository();
  final _reasonCtrl = TextEditingController();

  String _selectedEmployeeId = 'emp_002';
  LeaveType _selectedType = LeaveType.casual;
  DateTime _startDate = DateTime.now().add(const Duration(days: 2));
  DateTime _endDate = DateTime.now().add(const Duration(days: 3));
  bool _isHalfDay = false;

  @override
  void dispose() {
    _reasonCtrl.dispose();
    super.dispose();
  }

  double get _calculatedDays {
    if (_isHalfDay) return 0.5;
    return (_endDate.difference(_startDate).inDays + 1).toDouble().clamp(1.0, 90.0);
  }

  void _submit() {
    if (_reasonCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please state the reason for this leave request.')),
      );
      return;
    }

    final emp = _repo.getEmployeeById(_selectedEmployeeId);
    if (emp == null) return;

    final application = LeaveApplication(
      id: 'lv_${DateTime.now().millisecondsSinceEpoch}',
      employeeId: emp.id,
      employeeName: emp.fullName,
      employeeCode: emp.employeeCode,
      departmentName: emp.departmentName,
      leaveType: _selectedType,
      startDate: _startDate,
      endDate: _endDate,
      totalDays: _calculatedDays,
      isHalfDay: _isHalfDay,
      reason: _reasonCtrl.text.trim(),
      status: ApprovalStatus.pending,
      appliedDate: DateTime.now(),
    );

    _repo.applyLeave(application);
    widget.onLeaveApplied?.call();
    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Leave application submitted for managerial approval.'),
        backgroundColor: Color(0xFF10B981),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final employees = _repo.employees;
    final policy = _repo.policyConfig;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF131722) : Colors.white,
        borderRadius: AppRadius.lg,
        border: Border.all(
          color: isDark ? Colors.white.withValues(alpha: 0.08) : Colors.black.withValues(alpha: 0.06),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Title
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
                        color: const Color(0xFF06B6D4).withValues(alpha: 0.12),
                        borderRadius: AppRadius.sm,
                      ),
                      child: const Icon(Icons.event_busy_outlined, size: 18, color: Color(0xFF06B6D4)),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Apply for Leave',
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

          // Body
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Employee
                _label('Employee', isDark),
                Container(
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1B202E) : const Color(0xFFF8FAFC),
                    borderRadius: AppRadius.md,
                    border: Border.all(color: isDark ? Colors.white12 : Colors.black12),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedEmployeeId,
                      isExpanded: true,
                      dropdownColor: isDark ? const Color(0xFF1A1F2C) : Colors.white,
                      items: employees.map((e) {
                        return DropdownMenuItem(value: e.id, child: Text('${e.fullName} (${e.departmentName})'));
                      }).toList(),
                      onChanged: (v) => setState(() => _selectedEmployeeId = v!),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),

                // Leave Type & Half Day
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _label('Leave Category', isDark),
                          Container(
                            height: 40,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: isDark ? const Color(0xFF1B202E) : const Color(0xFFF8FAFC),
                              borderRadius: AppRadius.md,
                              border: Border.all(color: isDark ? Colors.white12 : Colors.black12),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<LeaveType>(
                                value: _selectedType,
                                isExpanded: true,
                                dropdownColor: isDark ? const Color(0xFF1A1F2C) : Colors.white,
                                items: LeaveType.values.map((t) {
                                  return DropdownMenuItem(value: t, child: Text(t.label));
                                }).toList(),
                                onChanged: (v) => setState(() => _selectedType = v!),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _label('Duration Option', isDark),
                          Container(
                            height: 40,
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(
                              color: isDark ? const Color(0xFF1B202E) : const Color(0xFFF8FAFC),
                              borderRadius: AppRadius.md,
                              border: Border.all(color: isDark ? Colors.white12 : Colors.black12),
                            ),
                            child: Row(
                              children: [
                                Checkbox(
                                  value: _isHalfDay,
                                  onChanged: (v) => setState(() => _isHalfDay = v ?? false),
                                  visualDensity: VisualDensity.compact,
                                ),
                                Text(
                                  'Half-Day',
                                  style: GoogleFonts.plusJakartaSans(fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),

                // Dates & Total
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _label('From Date', isDark),
                          InkWell(
                            onTap: () async {
                              final d = await showDatePicker(
                                context: context,
                                initialDate: _startDate,
                                firstDate: DateTime.now().subtract(const Duration(days: 30)),
                                lastDate: DateTime.now().add(const Duration(days: 180)),
                              );
                              if (d != null) setState(() => _startDate = d);
                            },
                            child: Container(
                              height: 38,
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                color: isDark ? const Color(0xFF1B202E) : const Color(0xFFF8FAFC),
                                borderRadius: AppRadius.md,
                                border: Border.all(color: isDark ? Colors.white12 : Colors.black12),
                              ),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '${_startDate.day}/${_startDate.month}/${_startDate.year}',
                                style: GoogleFonts.plusJakartaSans(fontSize: 12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _label('To Date', isDark),
                          InkWell(
                            onTap: () async {
                              final d = await showDatePicker(
                                context: context,
                                initialDate: _endDate,
                                firstDate: _startDate,
                                lastDate: DateTime.now().add(const Duration(days: 180)),
                              );
                              if (d != null) setState(() => _endDate = d);
                            },
                            child: Container(
                              height: 38,
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                color: isDark ? const Color(0xFF1B202E) : const Color(0xFFF8FAFC),
                                borderRadius: AppRadius.md,
                                border: Border.all(color: isDark ? Colors.white12 : Colors.black12),
                              ),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '${_endDate.day}/${_endDate.month}/${_endDate.year}',
                                style: GoogleFonts.plusJakartaSans(fontSize: 12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Container(
                      height: 38,
                      margin: const EdgeInsets.only(top: 18),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: AppRadius.md,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'Total: $_calculatedDays day(s)',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),

                // Reason Field
                _label('Reason / Justification *', isDark),
                Container(
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1B202E) : const Color(0xFFF8FAFC),
                    borderRadius: AppRadius.md,
                    border: Border.all(color: isDark ? Colors.white12 : Colors.black12),
                  ),
                  child: TextField(
                    controller: _reasonCtrl,
                    maxLines: 2,
                    style: GoogleFonts.plusJakartaSans(fontSize: 12, color: isDark ? Colors.white : const Color(0xFF0F172A)),
                    decoration: InputDecoration(
                      hintText: 'Provide details regarding the purpose and handoff coverage...',
                      hintStyle: GoogleFonts.plusJakartaSans(fontSize: 12, color: const Color(0xFF94A3B8)),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(10),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),

                // Policy Alert Box (Double deduction configurable policy)
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEF4444).withValues(alpha: 0.08),
                    borderRadius: AppRadius.md,
                    border: Border.all(color: const Color(0xFFEF4444).withValues(alpha: 0.2)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.shield_outlined, size: 16, color: Color(0xFFEF4444)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Corporate Attendance & Double Penalty Policy Notice',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFFEF4444),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Leaves require reporting manager approval. Under Homio policy, taking unauthorized absence if rejected will invoke a double salary deduction (${policy.unauthorizedAbsenceMultiplier.toInt()}x daily wage per day).',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 10,
                                color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Actions
          Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: isDark ? Colors.white10 : Colors.black12)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Cancel', style: GoogleFonts.plusJakartaSans(fontSize: 12)),
                ),
                const SizedBox(width: AppSpacing.sm),
                ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  ),
                  child: Text('Submit Application', style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ),
        ],
      ),
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
}
