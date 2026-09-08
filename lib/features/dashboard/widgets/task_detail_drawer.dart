import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../domain/dashboard_enums.dart';
import '../domain/dashboard_models.dart';

/// Modal bottom sheet or side drawer for detailed Task inspection & editing.
class TaskDetailDrawer extends StatefulWidget {
  final TaskItem task;
  final Function(TaskItem updatedTask)? onTaskUpdated;
  final Function(String taskId, String comment)? onAddComment;
  final Function(String taskId, String itemId)? onToggleChecklist;

  const TaskDetailDrawer({
    super.key,
    required this.task,
    this.onTaskUpdated,
    this.onAddComment,
    this.onToggleChecklist,
  });

  static void show(
    BuildContext context, {
    required TaskItem task,
    Function(TaskItem updatedTask)? onTaskUpdated,
    Function(String taskId, String comment)? onAddComment,
    Function(String taskId, String itemId)? onToggleChecklist,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => TaskDetailDrawer(
        task: task,
        onTaskUpdated: onTaskUpdated,
        onAddComment: onAddComment,
        onToggleChecklist: onToggleChecklist,
      ),
    );
  }

  @override
  State<TaskDetailDrawer> createState() => _TaskDetailDrawerState();
}

class _TaskDetailDrawerState extends State<TaskDetailDrawer> {
  late TaskItem _task;
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _task = widget.task;
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _toggleCheck(String itemId) {
    if (widget.onToggleChecklist != null) {
      widget.onToggleChecklist!(_task.id, itemId);
    }
    setState(() {
      final updatedChecklist = _task.checklist.map((item) {
        if (item.id == itemId) {
          return item.copyWith(isDone: !item.isDone);
        }
        return item;
      }).toList();
      _task = _task.copyWith(checklist: updatedChecklist);
    });
  }

  void _postComment() {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;

    if (widget.onAddComment != null) {
      widget.onAddComment!(_task.id, text);
    }

    setState(() {
      final newComment = TaskComment(
        id: 'cm_${DateTime.now().millisecondsSinceEpoch}',
        authorName: 'Vikram Malhotra',
        authorRole: 'You',
        text: text,
        timeAgo: 'Just now',
      );
      _task = _task.copyWith(comments: [..._task.comments, newComment]);
      _commentController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 768;

    return Container(
      height: size.height * 0.88,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Drag Handle
          Center(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkBorderStrong : AppColors.lightBorderStrong,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: _task.priority.color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(_task.priority.icon, size: 12, color: _task.priority.color),
                      const SizedBox(width: 4),
                      Text(
                        _task.priority.label.toUpperCase(),
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: _task.priority.color,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: _task.status.color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    _task.status.label,
                    style: GoogleFonts.inter(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w600,
                      color: _task.status.color,
                    ),
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close_rounded, size: 18),
                  splashRadius: 18,
                ),
              ],
            ),
          ),
          Divider(height: 1, color: isDark ? AppColors.darkBorder : AppColors.lightBorder),

          // Scrollable Body
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    _task.title,
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Metadata chips
                  Wrap(
                    spacing: 12,
                    runSpacing: 8,
                    children: [
                      _buildMetaChip(
                        icon: Icons.apartment_rounded,
                        label: _task.projectName,
                        isDark: isDark,
                      ),
                      _buildMetaChip(
                        icon: Icons.person_outline_rounded,
                        label: _task.clientName,
                        isDark: isDark,
                      ),
                      _buildMetaChip(
                        icon: Icons.calendar_today_rounded,
                        label: '${_task.dueDate} at ${_task.dueTime}',
                        isDark: isDark,
                      ),
                      _buildMetaChip(
                        icon: Icons.assignment_ind_outlined,
                        label: 'Assigned to ${_task.assignedTo}',
                        isDark: isDark,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Description
                  if (_task.description.isNotEmpty) ...[
                    Text(
                      'Description',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _task.description,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        height: 1.5,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // Checklist section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Checklist (${_task.checklistCompletedCount}/${_task.checklist.length})',
                        style: GoogleFonts.inter(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                        ),
                      ),
                      Text(
                        _task.checklist.isNotEmpty
                            ? '${((_task.checklistCompletedCount / _task.checklist.length) * 100).round()}% Completed'
                            : '',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF10B981),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  if (_task.checklist.isEmpty)
                    Text(
                      'No checklist items attached to this task.',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                      ),
                    )
                  else
                    ..._task.checklist.map((item) {
                      return InkWell(
                        onTap: () => _toggleCheck(item.id),
                        borderRadius: AppRadius.sm,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Row(
                            children: [
                              Icon(
                                item.isDone ? Icons.check_box_rounded : Icons.check_box_outline_blank_rounded,
                                size: 18,
                                color: item.isDone ? const Color(0xFF10B981) : (isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  item.title,
                                  style: GoogleFonts.inter(
                                    fontSize: 12.5,
                                    decoration: item.isDone ? TextDecoration.lineThrough : null,
                                    color: item.isDone
                                        ? (isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)
                                        : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  const SizedBox(height: 24),

                  // Comments & Activity
                  Text(
                    'Activity & Comments (${_task.comments.length})',
                    style: GoogleFonts.inter(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Comment Input
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _commentController,
                          style: GoogleFonts.inter(fontSize: 12),
                          decoration: InputDecoration(
                            hintText: 'Add an update or note...',
                            hintStyle: GoogleFonts.inter(fontSize: 12),
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            border: OutlineInputBorder(borderRadius: AppRadius.sm),
                          ),
                          onSubmitted: (_) => _postComment(),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton.filled(
                        onPressed: _postComment,
                        icon: const Icon(Icons.send_rounded, size: 16),
                        style: IconButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  ..._task.comments.map((comment) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkSurfaceSubtle : const Color(0xFFF8FAFC),
                        borderRadius: AppRadius.sm,
                        border: Border.all(
                          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${comment.authorName} (${comment.authorRole})',
                                style: GoogleFonts.inter(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w600,
                                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                                ),
                              ),
                              Text(
                                comment.timeAgo,
                                style: GoogleFonts.inter(
                                  fontSize: 10.5,
                                  color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            comment.text,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),

          // Bottom Action Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurfaceSubtle : const Color(0xFFF8FAFC),
              border: Border(top: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      final newStatus = _task.status == TaskStatus.inProgress
                          ? TaskStatus.waiting
                          : TaskStatus.inProgress;
                      final updated = _task.copyWith(status: newStatus);
                      setState(() => _task = updated);
                      widget.onTaskUpdated?.call(updated);
                    },
                    icon: Icon(
                      _task.status == TaskStatus.inProgress ? Icons.pause_rounded : Icons.play_arrow_rounded,
                      size: 16,
                    ),
                    label: Text(
                      _task.status == TaskStatus.inProgress ? 'Pause Task' : 'Start Task',
                      style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 11),
                      shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      final newStatus = _task.isCompleted ? TaskStatus.inProgress : TaskStatus.completed;
                      final updated = _task.copyWith(
                        status: newStatus,
                        completedAt: newStatus == TaskStatus.completed ? DateTime.now() : null,
                      );
                      setState(() => _task = updated);
                      widget.onTaskUpdated?.call(updated);
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      _task.isCompleted ? Icons.undo_rounded : Icons.check_circle_outline_rounded,
                      size: 16,
                    ),
                    label: Text(
                      _task.isCompleted ? 'Reopen Task' : 'Mark Completed',
                      style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF10B981),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 11),
                      shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetaChip({
    required IconData icon,
    required String label,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurfaceSubtle : const Color(0xFFF1F5F9),
        borderRadius: AppRadius.sm,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 11.5,
              fontWeight: FontWeight.w500,
              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
