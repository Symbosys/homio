import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../domain/design_enums.dart';

/// Status badge for design review statuses with overflow safety.
class DesignStatusBadge extends StatelessWidget {
  final DesignReviewStatus status;
  final bool showIcon;
  final double fontSize;

  const DesignStatusBadge({
    super.key,
    required this.status,
    this.showIcon = true,
    this.fontSize = 11,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: status.color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: status.color.withValues(alpha: 0.35), width: 0.8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showIcon) ...[
            Icon(status.icon, size: fontSize + 2, color: status.color),
            const SizedBox(width: 4),
          ],
          Flexible(
            child: Text(
              status.label,
              style: GoogleFonts.inter(
                fontSize: fontSize,
                fontWeight: FontWeight.w600,
                color: status.color,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

/// Category badge for deliverables (CAD, 3D Render, Mood Board, etc.)
class DesignCategoryBadge extends StatelessWidget {
  final DesignCategory category;
  final bool showIcon;
  final double fontSize;

  const DesignCategoryBadge({
    super.key,
    required this.category,
    this.showIcon = true,
    this.fontSize = 11,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: category.color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: category.color.withValues(alpha: 0.35), width: 0.8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showIcon) ...[
            Icon(category.icon, size: fontSize + 2, color: category.color),
            const SizedBox(width: 4),
          ],
          Flexible(
            child: Text(
              category.label,
              style: GoogleFonts.inter(
                fontSize: fontSize,
                fontWeight: FontWeight.w600,
                color: category.color,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

/// File type badge (DWG, RVT, MAX, PDF, etc.)
class DesignFileTypeBadge extends StatelessWidget {
  final DesignFileType fileType;
  final double fontSize;

  const DesignFileTypeBadge({
    super.key,
    required this.fileType,
    this.fontSize = 11,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: fileType.color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: fileType.color.withValues(alpha: 0.4), width: 0.8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(fileType.icon, size: fontSize + 2, color: fileType.color),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              fileType.extension.toUpperCase(),
              style: GoogleFonts.inter(
                fontSize: fontSize,
                fontWeight: FontWeight.w700,
                color: fileType.color,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

/// Revision status badge
class DesignRevisionBadge extends StatelessWidget {
  final RevisionStatus status;
  final double fontSize;

  const DesignRevisionBadge({
    super.key,
    required this.status,
    this.fontSize = 11,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: status.color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: status.color.withValues(alpha: 0.35), width: 0.8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(status.icon, size: fontSize + 2, color: status.color),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              status.label,
              style: GoogleFonts.inter(
                fontSize: fontSize,
                fontWeight: FontWeight.w600,
                color: status.color,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

/// Handover status badge
class DesignHandoverBadge extends StatelessWidget {
  final HandoverStatus status;
  final double fontSize;

  const DesignHandoverBadge({
    super.key,
    required this.status,
    this.fontSize = 11,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: status.color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: status.color.withValues(alpha: 0.35), width: 0.8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(status.icon, size: fontSize + 2, color: status.color),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              status.label,
              style: GoogleFonts.inter(
                fontSize: fontSize,
                fontWeight: FontWeight.w600,
                color: status.color,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

/// Priority badge (Low, Medium, High, Urgent)
class DesignPriorityBadge extends StatelessWidget {
  final DesignPriority priority;
  final double fontSize;

  const DesignPriorityBadge({
    super.key,
    required this.priority,
    this.fontSize = 11,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: priority.color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: priority.color.withValues(alpha: 0.3), width: 0.8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(priority.icon, size: fontSize + 1, color: priority.color),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              priority.label,
              style: GoogleFonts.inter(
                fontSize: fontSize,
                fontWeight: FontWeight.w600,
                color: priority.color,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

/// Design lifecycle stage stepper (Draft -> Internal Review -> Sent to Client -> Revised -> Approved -> Sent to Execution)
class DesignStageStepper extends StatelessWidget {
  final DesignReviewStatus currentStatus;

  const DesignStageStepper({
    super.key,
    required this.currentStatus,
  });

  static const List<DesignReviewStatus> _stages = [
    DesignReviewStatus.draft,
    DesignReviewStatus.internalReview,
    DesignReviewStatus.sentToClient,
    DesignReviewStatus.revisionRequested,
    DesignReviewStatus.revised,
    DesignReviewStatus.approved,
    DesignReviewStatus.sentToExecution,
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final currentIdx = _stages.indexOf(
      currentStatus == DesignReviewStatus.underClientReview || currentStatus == DesignReviewStatus.changesRequested
          ? DesignReviewStatus.sentToClient
          : currentStatus,
    );

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(_stages.length, (index) {
          final stage = _stages[index];
          final isCompleted = index < currentIdx || currentStatus == DesignReviewStatus.sentToExecution;
          final isCurrent = index == currentIdx;

          Color stepColor;
          if (isCompleted) {
            stepColor = AppColors.success;
          } else if (isCurrent) {
            stepColor = stage.color;
          } else {
            stepColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;
          }

          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: isCurrent
                      ? stage.color.withValues(alpha: 0.15)
                      : (isCompleted
                          ? AppColors.success.withValues(alpha: 0.1)
                          : (isDark ? AppColors.darkCard : AppColors.lightCard)),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isCurrent ? stage.color : (isCompleted ? AppColors.success : (isDark ? AppColors.darkBorder : AppColors.lightBorder)),
                    width: isCurrent ? 1.5 : 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isCompleted ? Icons.check_circle_rounded : stage.icon,
                      size: 14,
                      color: stepColor,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      stage.label,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w500,
                        color: isCurrent
                            ? stage.color
                            : (isCompleted
                                ? (isDark ? Colors.white70 : Colors.black87)
                                : (isDark ? AppColors.darkMutedText : AppColors.lightMutedText)),
                      ),
                    ),
                  ],
                ),
              ),
              if (index < _stages.length - 1)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Icon(
                    Icons.chevron_right_rounded,
                    size: 16,
                    color: isCompleted ? AppColors.success : (isDark ? Colors.white24 : Colors.black26),
                  ),
                ),
            ],
          );
        }),
      ),
    );
  }
}

/// Linear progress bar with percentage label and customizable color
class DesignProgressBar extends StatelessWidget {
  final double progressPercent;
  final Color? color;
  final double height;
  final bool showLabel;

  const DesignProgressBar({
    super.key,
    required this.progressPercent,
    this.color,
    this.height = 8,
    this.showLabel = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final clamped = (progressPercent / 100).clamp(0.0, 1.0);
    final barColor = color ??
        (progressPercent >= 100
            ? AppColors.success
            : (progressPercent >= 60 ? AppColors.primary : AppColors.warning));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showLabel) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Progress',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: isDark ? AppColors.darkMutedText : AppColors.lightMutedText,
                ),
              ),
              Text(
                '${progressPercent.toInt()}%',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: barColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
        ],
        ClipRRect(
          borderRadius: BorderRadius.circular(height / 2),
          child: LinearProgressIndicator(
            value: clamped,
            minHeight: height,
            backgroundColor: isDark ? AppColors.darkBorder : AppColors.lightBorder,
            valueColor: AlwaysStoppedAnimation<Color>(barColor),
          ),
        ),
      ],
    );
  }
}

/// Generic empty state component for design lists and tables
class DesignEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  const DesignEmptyState({
    super.key,
    this.icon = Icons.folder_open_rounded,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCard : AppColors.lightCard,
                shape: BoxShape.circle,
                border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
              ),
              child: Icon(
                icon,
                size: 40,
                color: isDark ? AppColors.darkMutedText : AppColors.lightMutedText,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isDark ? AppColors.darkMutedText : AppColors.lightMutedText,
              ),
              textAlign: TextAlign.center,
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 18),
              ElevatedButton.icon(
                onPressed: onAction,
                icon: const Icon(Icons.add, size: 16),
                label: Text(actionLabel!),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
