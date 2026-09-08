import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../domain/projects_enums.dart';

/// Colored status chip with icon for any ProjectStatus.
class ProjectStatusBadge extends StatelessWidget {
  final ProjectStatus status;
  final bool compact;

  const ProjectStatusBadge({
    super.key,
    required this.status,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 6 : 10,
        vertical: compact ? 2 : 4,
      ),
      decoration: BoxDecoration(
        color: status.color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: status.color.withValues(alpha: 0.3),
          width: 0.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(status.icon, size: compact ? 12 : 14, color: status.color),
          SizedBox(width: compact ? 3 : 5),
          Flexible(
            child: Text(
              status.label,
              style: TextStyle(
                fontSize: compact ? 10 : 11,
                fontWeight: FontWeight.w600,
                color: status.color,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

/// Health indicator with icon + label + optional tooltip.
class ProjectHealthBadge extends StatelessWidget {
  final ProjectHealth health;
  final bool compact;
  final String? tooltip;

  const ProjectHealthBadge({
    super.key,
    required this.health,
    this.compact = false,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final badge = Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 6 : 10,
        vertical: compact ? 2 : 4,
      ),
      decoration: BoxDecoration(
        color: health.color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: health.color.withValues(alpha: 0.3),
          width: 0.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(health.icon, size: compact ? 12 : 14, color: health.color),
          SizedBox(width: compact ? 3 : 5),
          Flexible(
            child: Text(
              health.label,
              style: TextStyle(
                fontSize: compact ? 10 : 11,
                fontWeight: FontWeight.w600,
                color: health.color,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );

    if (tooltip != null) {
      return Tooltip(message: tooltip!, child: badge);
    }
    return badge;
  }
}

/// Colored payment status badge.
class PaymentStatusBadge extends StatelessWidget {
  final PaymentStatus status;
  final bool compact;

  const PaymentStatusBadge({
    super.key,
    required this.status,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 6 : 10,
        vertical: compact ? 2 : 4,
      ),
      decoration: BoxDecoration(
        color: status.color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: status.color.withValues(alpha: 0.3),
          width: 0.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(status.icon, size: compact ? 12 : 14, color: status.color),
          SizedBox(width: compact ? 3 : 5),
          Text(
            status.label,
            style: TextStyle(
              fontSize: compact ? 10 : 11,
              fontWeight: FontWeight.w600,
              color: status.color,
            ),
          ),
        ],
      ),
    );
  }
}

/// Generic enum badge for any type with label + color.
class EnumBadge extends StatelessWidget {
  final String label;
  final Color color;
  final IconData? icon;
  final bool compact;

  const EnumBadge({
    super.key,
    required this.label,
    required this.color,
    this.icon,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 6 : 10,
        vertical: compact ? 2 : 4,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 0.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: compact ? 12 : 14, color: color),
            SizedBox(width: compact ? 3 : 5),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: compact ? 10 : 11,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

/// Project stage stepper widget — visual horizontal stage tracker.
class ProjectStageStepper extends StatelessWidget {
  final ProjectStage currentStage;

  const ProjectStageStepper({super.key, required this.currentStage});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final stages = ProjectStage.values;
    final currentIdx = stages.indexOf(currentStage);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(stages.length * 2 - 1, (i) {
            if (i.isOdd) {
              // Connector line
              final stageIdx = i ~/ 2;
              final isCompleted = stageIdx < currentIdx;
              return Container(
                width: 28,
                height: 2,
                color: isCompleted
                    ? AppColors.success
                    : (isDark
                        ? AppColors.darkBorderStrong
                        : AppColors.lightBorderStrong),
              );
            }
            final stageIdx = i ~/ 2;
            final stage = stages[stageIdx];
            final isCompleted = stageIdx < currentIdx;
            final isCurrent = stageIdx == currentIdx;

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isCompleted
                        ? AppColors.success
                        : isCurrent
                            ? stage.color
                            : (isDark
                                ? AppColors.darkSurfaceElevated
                                : AppColors.lightSurfaceSubtle),
                    border: Border.all(
                      color: isCompleted
                          ? AppColors.success
                          : isCurrent
                              ? stage.color
                              : (isDark
                                  ? AppColors.darkBorderStrong
                                  : AppColors.lightBorderStrong),
                      width: isCurrent ? 2 : 1,
                    ),
                  ),
                  child: Icon(
                    isCompleted ? Icons.check_rounded : stage.icon,
                    size: 16,
                    color: isCompleted || isCurrent
                        ? Colors.white
                        : (isDark
                            ? AppColors.darkTextMuted
                            : AppColors.lightTextMuted),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  stage.label,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w500,
                    color: isCurrent
                        ? stage.color
                        : (isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}

/// Multi-bar progress indicator card (Overall, Design, Execution, Procurement, Payments).
class ProjectProgressCard extends StatelessWidget {
  final double overallProgress;
  final double designProgress;
  final double executionProgress;
  final double procurementProgress;
  final double paymentProgress;

  const ProjectProgressCard({
    super.key,
    required this.overallProgress,
    required this.designProgress,
    required this.executionProgress,
    required this.procurementProgress,
    required this.paymentProgress,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.pie_chart_outline_rounded,
                size: 16,
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
              ),
              const SizedBox(width: 6),
              Text(
                'Progress Breakdown',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary,
                ),
              ),
              const Spacer(),
              Text(
                '${overallProgress.toStringAsFixed(0)}% Overall',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _buildProgressBar('Design', designProgress, const Color(0xFF8B5CF6), isDark),
          const SizedBox(height: 10),
          _buildProgressBar('Execution', executionProgress, const Color(0xFF3B82F6), isDark),
          const SizedBox(height: 10),
          _buildProgressBar('Procurement', procurementProgress, const Color(0xFF0EA5E9), isDark),
          const SizedBox(height: 10),
          _buildProgressBar('Payments', paymentProgress, const Color(0xFF10B981), isDark),
        ],
      ),
    );
  }

  Widget _buildProgressBar(
      String label, double percent, Color color, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
              ),
            ),
            Text(
              '${percent.toStringAsFixed(0)}%',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: percent / 100,
            minHeight: 6,
            backgroundColor: isDark
                ? AppColors.darkSurfaceElevated
                : AppColors.lightSurfaceSubtle,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}

/// Skeleton loading widgets for project screens.
class ProjectSkeleton {
  static Widget kpiRow({int count = 4, required bool isDark}) {
    return Row(
      children: List.generate(
        count,
        (i) => Expanded(
          child: Container(
            margin: EdgeInsets.only(right: i < count - 1 ? 12 : 0),
            height: 110,
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              ),
            ),
          ),
        ),
      ),
    );
  }

  static Widget card({required bool isDark, double height = 200}) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
    );
  }

  static Widget listTile({required bool isDark}) {
    final skelColor = isDark
        ? AppColors.darkSurfaceElevated
        : AppColors.lightSurfaceSubtle;
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
              color: skelColor, borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity, height: 14,
                  decoration: BoxDecoration(
                    color: skelColor, borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  width: 160, height: 10,
                  decoration: BoxDecoration(
                    color: skelColor, borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Empty state widget with icon, message, and CTA.
class ProjectEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final String? buttonLabel;
  final VoidCallback? onButtonPressed;

  const ProjectEmptyState({
    super.key,
    this.icon = Icons.folder_open_outlined,
    required this.title,
    this.description = '',
    this.buttonLabel,
    this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(48),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 48, color: AppColors.primary.withValues(alpha: 0.5)),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.lightTextPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            if (description.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                description,
                style: TextStyle(
                  fontSize: 13,
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (buttonLabel != null && onButtonPressed != null) ...[
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: onButtonPressed,
                icon: const Icon(Icons.add_rounded, size: 18),
                label: Text(buttonLabel!),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
