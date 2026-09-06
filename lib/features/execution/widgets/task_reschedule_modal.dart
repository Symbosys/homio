import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../models/execution_models.dart';

/// Modal dialog that enforces selection of a Reschedule Reason and records original vs revised dates.
class TaskRescheduleModal extends StatefulWidget {
  final WbsTask task;
  final ValueChanged<WbsTask> onRescheduled;

  const TaskRescheduleModal({
    super.key,
    required this.task,
    required this.onRescheduled,
  });

  static Future<void> show({
    required BuildContext context,
    required WbsTask task,
    required ValueChanged<RescheduleAuditRecord> onConfirm,
  }) {
    return showDialog(
      context: context,
      builder: (ctx) => TaskRescheduleModal(
        task: task,
        onRescheduled: (updated) {
          final record = RescheduleAuditRecord(
            originalDate: task.originalTargetDate,
            revisedDate: updated.currentDueDate,
            reason: updated.rescheduleReason ?? 'Site delay',
            rescheduledBy: 'Site Supervisor',
            timestamp: DateTime.now(),
          );
          onConfirm(record);
        },
      ),
    );
  }

  @override
  State<TaskRescheduleModal> createState() => _TaskRescheduleModalState();
}

class _TaskRescheduleModalState extends State<TaskRescheduleModal> {
  late DateTime _newDueDate;
  String _selectedReason = 'Client Design Revision';
  final TextEditingController _notesController = TextEditingController();

  final List<String> _reasons = [
    'Client Design Revision / Scope Addition',
    'Material Supply Delay from Vendor',
    'Site Readiness / Uncivil Disruption',
    'Labour Absenteeism / Shortage',
    'Building RWA Work Timing Restrictions',
    'Weather / Rain / Humidity Disruption',
    'Site Electricity / Water Cut',
  ];

  @override
  void initState() {
    super.initState();
    _newDueDate = widget.task.currentDueDate.add(const Duration(days: 3));
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final delayDays = _newDueDate.difference(widget.task.originalTargetDate).inDays;

    return Dialog(
      backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.lg,
        side: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder, width: 0.8),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 540),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.warning.withValues(alpha: 0.15),
                          borderRadius: AppRadius.sm,
                        ),
                        child: const Icon(Icons.history_toggle_off_rounded, size: 18, color: AppColors.warning),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Reschedule Task Deadline',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                            ),
                          ),
                          Text(
                            'Mandatory delay SLA reason auditing (PRD Section 8.1)',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, size: 20),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const Divider(height: 24),

              // Task Title
              Text(
                widget.task.title,
                style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),

              // Audit Comparison Banner
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                  borderRadius: AppRadius.sm,
                  border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder, width: 0.8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Original Target Date', style: GoogleFonts.inter(fontSize: 10, color: Colors.grey)),
                        Text(
                          _formatDate(widget.task.originalTargetDate),
                          style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                    const Icon(Icons.arrow_forward_rounded, size: 16, color: AppColors.warning),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('Revised Target Date', style: GoogleFonts.inter(fontSize: 10, color: Colors.grey)),
                        Text(
                          _formatDate(_newDueDate),
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: delayDays > 0 ? AppColors.error : AppColors.success,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // New Date Picker Trigger
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Select New Target Date:', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600)),
                  OutlinedButton.icon(
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _newDueDate,
                        firstDate: DateTime.now().subtract(const Duration(days: 30)),
                        lastDate: DateTime.now().add(const Duration(days: 180)),
                      );
                      if (picked != null) setState(() => _newDueDate = picked);
                    },
                    icon: const Icon(Icons.calendar_today_rounded, size: 14),
                    label: Text(_formatDate(_newDueDate)),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      textStyle: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Mandatory Reason Dropdown
              Text('Mandatory Reschedule Reason:', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                initialValue: _selectedReason,
                items: _reasons.map((r) => DropdownMenuItem(value: r, child: Text(r, style: GoogleFonts.inter(fontSize: 12)))).toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedReason = val);
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                  border: OutlineInputBorder(borderRadius: AppRadius.sm),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
              ),
              const SizedBox(height: 14),

              // Notes
              Text('Additional Audit Notes (Optional):', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              TextField(
                controller: _notesController,
                maxLines: 2,
                decoration: InputDecoration(
                  hintText: 'Enter specific details, WhatsApp approval snippet, or vendor order number...',
                  filled: true,
                  fillColor: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                  border: OutlineInputBorder(borderRadius: AppRadius.sm),
                  contentPadding: const EdgeInsets.all(10),
                ),
              ),
              const SizedBox(height: 20),

              // Actions
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      final updated = widget.task.copyWith(
                        currentDueDate: _newDueDate,
                        isRescheduled: true,
                        rescheduleReason: _selectedReason,
                        rescheduledAt: DateTime.now(),
                      );
                      widget.onRescheduled(updated);
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.warning,
                      foregroundColor: Colors.black87,
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                      textStyle: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 12),
                    ),
                    child: const Text('Commit Reschedule & Log SLA Audit'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime dt) => '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
}
