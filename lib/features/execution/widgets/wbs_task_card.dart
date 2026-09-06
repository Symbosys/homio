import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../models/execution_models.dart';
import 'task_reschedule_modal.dart';

/// Interactive WBS Task Card with checklists, priority badge, and delay auditing trigger.
class WbsTaskCard extends StatefulWidget {
  final WbsTask task;
  final ValueChanged<WbsTask>? onTaskUpdated;
  final VoidCallback? onReschedule;
  final void Function(int index, bool done)? onToggleSubtask;

  const WbsTaskCard({
    super.key,
    required this.task,
    this.onTaskUpdated,
    this.onReschedule,
    this.onToggleSubtask,
  });

  @override
  State<WbsTaskCard> createState() => _WbsTaskCardState();
}

class _WbsTaskCardState extends State<WbsTaskCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final task = widget.task;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
        borderRadius: AppRadius.sm,
        border: Border.all(
          color: task.isCompleted
              ? AppColors.success.withValues(alpha: 0.3)
              : task.isRescheduled
                  ? AppColors.warning.withValues(alpha: 0.3)
                  : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
          width: 0.8,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Main Summary Row
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Checkbox(
                  value: task.isCompleted,
                  activeColor: AppColors.success,
                  onChanged: (val) {
                    widget.onTaskUpdated?.call(task.copyWith(isCompleted: val ?? false));
                  },
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              task.title,
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                                color: task.isCompleted
                                    ? Colors.grey
                                    : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: task.priority.color.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              task.priority.label,
                              style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: task.priority.color),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        task.scopeDescription,
                        style: GoogleFonts.inter(fontSize: 11, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                        maxLines: _isExpanded ? null : 2,
                      ),
                      const SizedBox(height: 8),

                      // Meta details: Assignee & Due Date
                      Wrap(
                        spacing: 12,
                        runSpacing: 6,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.person_outline_rounded, size: 13, color: Colors.grey),
                              const SizedBox(width: 4),
                              Text(
                                '${task.assigneeName} (${task.assigneeRole})',
                                style: GoogleFonts.inter(fontSize: 11, color: Colors.grey),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                task.isRescheduled ? Icons.history_toggle_off_rounded : Icons.calendar_today_rounded,
                                size: 13,
                                color: task.isRescheduled ? AppColors.warning : Colors.grey,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Due: ${_formatDate(task.currentDueDate)}',
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  fontWeight: task.isRescheduled ? FontWeight.w700 : FontWeight.w500,
                                  color: task.isRescheduled ? AppColors.warning : Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          if (task.isRescheduled)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                              decoration: BoxDecoration(
                                color: AppColors.warning.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(3),
                              ),
                              child: Text(
                                'Rescheduled (+${task.daysDelayed}d)',
                                style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.w700, color: AppColors.warning),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(_isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded, size: 18),
                  onPressed: () => setState(() => _isExpanded = !_isExpanded),
                  splashRadius: 14,
                ),
              ],
            ),
          ),

          // Expanded Content (Checklist & Reschedule Button)
          if (_isExpanded) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (task.isRescheduled && task.rescheduleReason != null) ...[
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.warning.withValues(alpha: 0.1),
                        borderRadius: AppRadius.sm,
                        border: Border.all(color: AppColors.warning.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.info_outline_rounded, size: 14, color: AppColors.warning),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              'Audit Delay Reason: ${task.rescheduleReason} (Original: ${_formatDate(task.originalTargetDate)})',
                              style: GoogleFonts.inter(fontSize: 10, color: AppColors.warning, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],

                  if (task.checklistItems.isNotEmpty) ...[
                    Text('Quality Checklist:', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 6),
                    ...task.checklistItems.asMap().entries.map((entry) {
                      final cIdx = entry.key;
                      final cText = entry.value;
                      final isChecked = cIdx < task.checklistChecked.length ? task.checklistChecked[cIdx] : false;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: Checkbox(
                                value: isChecked,
                                activeColor: AppColors.primary,
                                onChanged: (val) {
                                  if (widget.onToggleSubtask != null) {
                                    widget.onToggleSubtask!(cIdx, val ?? false);
                                  } else if (widget.onTaskUpdated != null) {
                                    final newChecked = List<bool>.from(task.checklistChecked);
                                    if (cIdx < newChecked.length) {
                                      newChecked[cIdx] = val ?? false;
                                      widget.onTaskUpdated!(task.copyWith(checklistChecked: newChecked));
                                    }
                                  }
                                },
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(child: Text(cText, style: GoogleFonts.inter(fontSize: 11))),
                          ],
                        ),
                      );
                    }),
                    const SizedBox(height: 10),
                  ],

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton.icon(
                        onPressed: () => _openRescheduleModal(context),
                        icon: const Icon(Icons.edit_calendar_rounded, size: 14, color: AppColors.warning),
                        label: const Text('Reschedule Deadline (Audit Log)'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.warning,
                          side: const BorderSide(color: AppColors.warning, width: 0.8),
                          visualDensity: VisualDensity.compact,
                          textStyle: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _openRescheduleModal(BuildContext context) {
    if (widget.onReschedule != null) {
      widget.onReschedule!();
    } else if (widget.onTaskUpdated != null) {
      showDialog(
        context: context,
        builder: (ctx) => TaskRescheduleModal(
          task: widget.task,
          onRescheduled: widget.onTaskUpdated!,
        ),
      );
    }
  }

  String _formatDate(DateTime dt) => '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
}
