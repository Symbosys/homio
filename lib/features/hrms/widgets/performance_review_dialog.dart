import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_radius.dart';
import '../data/hrms_repository.dart';
import '../domain/hrms_domain_models.dart';
import '../domain/hrms_enums.dart';

class PerformanceReviewDialog extends StatefulWidget {
  final VoidCallback? onReviewSaved;

  const PerformanceReviewDialog({super.key, this.onReviewSaved});

  static void show(BuildContext context, {VoidCallback? onReviewSaved}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: PerformanceReviewDialog(onReviewSaved: onReviewSaved),
        ),
      ),
    );
  }

  @override
  State<PerformanceReviewDialog> createState() => _PerformanceReviewDialogState();
}

class _PerformanceReviewDialogState extends State<PerformanceReviewDialog> {
  final _repo = HrmsRepository();

  String _selectedEmployeeId = 'emp_006';
  ReviewType _selectedType = ReviewType.quarterly;
  double _overallScore = 4.5;
  String _recommendation = 'Merit Increment & Discretionary Bonus';
  final _commentsCtrl = TextEditingController(text: 'Exceptional 3D render aesthetics and client communication on luxury villa accounts.');

  final Map<String, double> _kpis = {
    'Design Quality & Innovation': 4.7,
    'Timeline & Delivery Pacing': 4.3,
    'Client Interfacing & CSAT': 4.6,
    'Subcontractor / Team Support': 4.4,
  };

  @override
  void dispose() {
    _commentsCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    final emp = _repo.getEmployeeById(_selectedEmployeeId);
    if (emp == null) return;

    final review = PerformanceReview(
      id: 'rev_${DateTime.now().millisecondsSinceEpoch}',
      employeeId: emp.id,
      employeeName: emp.fullName,
      employeeCode: emp.employeeCode,
      departmentName: emp.departmentName,
      reviewerId: 'emp_001',
      reviewerName: 'Rahul Sharma',
      reviewPeriod: 'Q3 2026 Appraisal',
      reviewType: _selectedType,
      overallScore: _overallScore,
      kpiScores: Map.from(_kpis),
      reviewerComments: _commentsCtrl.text.trim(),
      recommendation: _recommendation,
      status: ApprovalStatus.approved,
      reviewDate: DateTime.now(),
    );

    _repo.addReview(review);
    widget.onReviewSaved?.call();
    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Performance appraisal for ${emp.fullName} recorded successfully!'),
        backgroundColor: const Color(0xFF10B981),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final employees = _repo.employees;

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
                      child: const Icon(Icons.star_outline_rounded, size: 18, color: Color(0xFF8B5CF6)),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Conduct Performance Appraisal',
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
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _label('Employee to Review', isDark),
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
                                  items: employees.map((e) => DropdownMenuItem(value: e.id, child: Text(e.fullName))).toList(),
                                  onChanged: (v) => setState(() => _selectedEmployeeId = v!),
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
                            _label('Review Cycle', isDark),
                            Container(
                              height: 40,
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                color: isDark ? const Color(0xFF1B202E) : const Color(0xFFF8FAFC),
                                borderRadius: AppRadius.md,
                                border: Border.all(color: isDark ? Colors.white12 : Colors.black12),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<ReviewType>(
                                  value: _selectedType,
                                  isExpanded: true,
                                  dropdownColor: isDark ? const Color(0xFF1A1F2C) : Colors.white,
                                  items: ReviewType.values.map((t) => DropdownMenuItem(value: t, child: Text(t.label))).toList(),
                                  onChanged: (v) => setState(() => _selectedType = v!),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Overall Score Slider
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1B202E) : const Color(0xFFF8FAFC),
                      borderRadius: AppRadius.md,
                      border: Border.all(color: isDark ? Colors.white12 : Colors.black12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Overall Performance Score (1.0 - 5.0)',
                              style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w600),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFF8B5CF6).withValues(alpha: 0.15),
                                borderRadius: AppRadius.sm,
                              ),
                              child: Text(
                                '${_overallScore.toStringAsFixed(1)} / 5.0',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF8B5CF6),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Slider(
                          value: _overallScore,
                          min: 1.0,
                          max: 5.0,
                          divisions: 40,
                          activeColor: const Color(0xFF8B5CF6),
                          onChanged: (v) => setState(() => _overallScore = v),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // KPI Subscores
                  Text('KPI Breakdown Evaluation', style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 6),
                  ..._kpis.entries.map((entry) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Text(entry.key, style: GoogleFonts.plusJakartaSans(fontSize: 11)),
                          ),
                          Expanded(
                            flex: 2,
                            child: Slider(
                              value: entry.value,
                              min: 1.0,
                              max: 5.0,
                              divisions: 20,
                              activeColor: const Color(0xFF10B981),
                              onChanged: (v) => setState(() => _kpis[entry.key] = v),
                            ),
                          ),
                          SizedBox(
                            width: 32,
                            child: Text(
                              entry.value.toStringAsFixed(1),
                              style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w700),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                  const SizedBox(height: AppSpacing.sm),

                  _label('Manager Recommendation', isDark),
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
                        value: _recommendation,
                        isExpanded: true,
                        dropdownColor: isDark ? const Color(0xFF1A1F2C) : Colors.white,
                        items: const [
                          DropdownMenuItem(value: 'Merit Increment & Discretionary Bonus', child: Text('Merit Increment & Bonus')),
                          DropdownMenuItem(value: 'Promotion to Senior Grade', child: Text('Promotion to Senior Grade')),
                          DropdownMenuItem(value: 'Maintain Grade', child: Text('Maintain Grade')),
                          DropdownMenuItem(value: 'Performance Improvement Plan (PIP)', child: Text('Performance Improvement Plan (PIP)')),
                        ],
                        onChanged: (v) => setState(() => _recommendation = v!),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),

                  _label('Manager Appraisal Comments', isDark),
                  Container(
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1B202E) : const Color(0xFFF8FAFC),
                      borderRadius: AppRadius.md,
                      border: Border.all(color: isDark ? Colors.white12 : Colors.black12),
                    ),
                    child: TextField(
                      controller: _commentsCtrl,
                      maxLines: 2,
                      style: GoogleFonts.plusJakartaSans(fontSize: 12),
                      decoration: const InputDecoration(
                        hintText: 'Add qualitative feedback and development plan...',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(10),
                      ),
                    ),
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
                  child: Text('Record Appraisal', style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w600)),
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
