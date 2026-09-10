import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_radius.dart';
import '../data/hrms_repository.dart';
import '../domain/hrms_domain_models.dart';
import '../domain/hrms_enums.dart';

class ResignationDialog extends StatefulWidget {
  final VoidCallback? onResignationSubmitted;

  const ResignationDialog({super.key, this.onResignationSubmitted});

  static void show(BuildContext context, {VoidCallback? onResignationSubmitted}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: ResignationDialog(onResignationSubmitted: onResignationSubmitted),
        ),
      ),
    );
  }

  @override
  State<ResignationDialog> createState() => _ResignationDialogState();
}

class _ResignationDialogState extends State<ResignationDialog> {
  final _repo = HrmsRepository();
  final _reasonCtrl = TextEditingController();
  final _feedbackCtrl = TextEditingController();

  String _selectedEmployeeId = 'emp_009';
  String _category = 'Relocation';
  final DateTime _requestedDate = DateTime.now().add(const Duration(days: 30));
  bool _isEligibleForRehire = true;

  @override
  void dispose() {
    _reasonCtrl.dispose();
    _feedbackCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    final emp = _repo.getEmployeeById(_selectedEmployeeId);
    if (emp == null) return;

    final officialLastWorkingDay = DateTime.now().add(Duration(days: emp.noticePeriodDays));

    final resignation = Resignation(
      id: 'res_${DateTime.now().millisecondsSinceEpoch}',
      employeeId: emp.id,
      employeeName: emp.fullName,
      employeeCode: emp.employeeCode,
      departmentName: emp.departmentName,
      submissionDate: DateTime.now(),
      requestedRelievingDate: _requestedDate,
      officialLastWorkingDate: officialLastWorkingDay,
      noticePeriodDays: emp.noticePeriodDays,
      reason: _reasonCtrl.text.trim().isNotEmpty ? _reasonCtrl.text.trim() : 'Personal relocation to home town.',
      reasonCategory: _category,
      status: ApprovalStatus.pending,
      feedback: _feedbackCtrl.text.trim(),
      isEligibleForRehire: _isEligibleForRehire,
    );

    _repo.resignations.add(resignation);
    _repo.updateEmployee(emp.copyWith(status: EmployeeStatus.noticePeriod));
    widget.onResignationSubmitted?.call();
    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Resignation initiated for ${emp.fullName}. Notice period tracking active.'),
        backgroundColor: const Color(0xFF8B5CF6),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final employees = _repo.employees.where((e) => e.status != EmployeeStatus.resigned && e.status != EmployeeStatus.terminated).toList();
    final selectedEmp = _repo.getEmployeeById(_selectedEmployeeId);

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
          // Header
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
                        color: const Color(0xFF8B5CF6).withValues(alpha: 0.12),
                        borderRadius: AppRadius.sm,
                      ),
                      child: const Icon(Icons.exit_to_app_rounded, size: 18, color: Color(0xFF8B5CF6)),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Initiate Resignation & Notice Period',
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
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _label('Resigning Personnel', isDark),
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
                        items: employees.map((e) => DropdownMenuItem(value: e.id, child: Text('${e.fullName} (${e.role})'))).toList(),
                        onChanged: (v) => setState(() => _selectedEmployeeId = v!),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),

                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _label('Reason Category', isDark),
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
                                  value: _category,
                                  isExpanded: true,
                                  dropdownColor: isDark ? const Color(0xFF1A1F2C) : Colors.white,
                                  items: const [
                                    DropdownMenuItem(value: 'Relocation', child: Text('Family Relocation')),
                                    DropdownMenuItem(value: 'Better Opportunity', child: Text('Career Advancement')),
                                    DropdownMenuItem(value: 'Higher Studies', child: Text('Higher Education')),
                                    DropdownMenuItem(value: 'Personal Reasons', child: Text('Personal Health/Family')),
                                  ],
                                  onChanged: (v) => setState(() => _category = v!),
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
                            _label('Notice Policy', isDark),
                            Container(
                              height: 40,
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.08),
                                borderRadius: AppRadius.md,
                                border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
                              ),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '${selectedEmp?.noticePeriodDays ?? 30} Days Notice Required',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),

                  _label('Formal Resignation Statement / Reasons', isDark),
                  Container(
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1B202E) : const Color(0xFFF8FAFC),
                      borderRadius: AppRadius.md,
                      border: Border.all(color: isDark ? Colors.white12 : Colors.black12),
                    ),
                    child: TextField(
                      controller: _reasonCtrl,
                      maxLines: 2,
                      style: GoogleFonts.plusJakartaSans(fontSize: 12),
                      decoration: const InputDecoration(
                        hintText: 'Enter resignation context and transition proposal...',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),

                  CheckboxListTile(
                    value: _isEligibleForRehire,
                    onChanged: (v) => setState(() => _isEligibleForRehire = v ?? true),
                    title: Text('Eligible for Rehire in Homio Organization', style: GoogleFonts.plusJakartaSans(fontSize: 12)),
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                ],
              ),
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
                    backgroundColor: const Color(0xFF8B5CF6),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  ),
                  child: Text('Confirm Resignation', style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w600)),
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
