import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../models/execution_models.dart';
import '../models/execution_mock_data.dart';
import '../widgets/execution_header.dart';
import '../widgets/execution_metric_card.dart';
import '../widgets/stage_approval_dialog.dart';

class ExecutionWorkApprovalsPage extends StatefulWidget {
  const ExecutionWorkApprovalsPage({super.key});

  @override
  State<ExecutionWorkApprovalsPage> createState() => _ExecutionWorkApprovalsPageState();
}

class _ExecutionWorkApprovalsPageState extends State<ExecutionWorkApprovalsPage> {
  late List<ProjectMaster> _projects;
  String? _selectedProjectId;

  @override
  void initState() {
    super.initState();
    _projects = List.from(ExecutionMockData.projects);
    if (_projects.isNotEmpty) {
      _selectedProjectId = _projects.first.id;
    }
  }

  ProjectMaster? get _currentProject {
    if (_projects.isEmpty) return null;
    return _projects.firstWhere(
      (p) => p.id == _selectedProjectId,
      orElse: () => _projects.first,
    );
  }

  void _handleStageAction(StageApprovalRequest request) {
    final proj = _currentProject;
    if (proj == null) return;

    StageApprovalDialog.show(
      context: context,
      project: proj,
      stage: request,
      onApprove: (updated) {
        setState(() {
          final idx = proj.stageApprovals.indexWhere((s) => s.id == updated.id);
          if (idx != -1) {
            proj.stageApprovals[idx] = updated;

            // Unlock next stage if exists
            if (idx + 1 < proj.stageApprovals.length) {
              final next = proj.stageApprovals[idx + 1];
              if (next.isLocked) {
                proj.stageApprovals[idx + 1] = next.copyWith(
                  isLocked: false,
                  status: 'Pending Client Sign-Off',
                );
              }
            }
          }
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Milestone "${updated.stageName}" signed off! Subsequent stage unlocked.'),
            backgroundColor: AppColors.success,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final proj = _currentProject;
    final stages = proj?.stageApprovals ?? [];

    // Stage KPIs
    final totalStages = stages.length;
    final approvedStages = stages.where((s) => s.isApproved).length;
    final pendingStages = stages.where((s) => !s.isLocked && !s.isApproved).length;
    final lockedStages = stages.where((s) => s.isLocked).length;

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            ExecutionHeader(
              title: 'Stage Work Approvals & Sign-Offs',
              subtitle: '5-stage milestone gates, strict stage locking, WhatsApp OTP validation & client sign-offs',
              primaryActionLabel: 'Audit Gate Check',
              primaryActionIcon: Icons.verified_user_outlined,
              onPrimaryAction: () {
                if (stages.isNotEmpty) _handleStageAction(stages.first);
              },
              actions: [
                OutlinedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Exporting Stage-Gate Certificate Audit Trail...')),
                    );
                  },
                  icon: const Icon(Icons.picture_as_pdf_outlined, size: 18),
                  label: const Text('Export Audit Certificate'),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Metrics
            Row(
              children: [
                Expanded(
                  child: ExecutionMetricCard(
                    title: 'Total Stage Gates',
                    value: '$totalStages',
                    subtitle: 'Sequential project gates',
                    icon: Icons.door_sliding_outlined,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: ExecutionMetricCard(
                    title: 'Approved & Certified',
                    value: '$approvedStages',
                    subtitle: 'OTP / Signature signed off',
                    icon: Icons.check_circle_outline,
                    color: AppColors.success,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: ExecutionMetricCard(
                    title: 'Pending Sign-Off',
                    value: '$pendingStages',
                    subtitle: 'Active gate awaiting client',
                    icon: Icons.hourglass_top,
                    color: AppColors.warning,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: ExecutionMetricCard(
                    title: 'Locked Stages',
                    value: '$lockedStages',
                    subtitle: 'Blocked by prerequisite gates',
                    icon: Icons.lock_outline,
                    color: AppColors.lightMutedText,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Project Selector Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCard : AppColors.lightCard,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.apartment, size: 18, color: AppColors.primary),
                  const SizedBox(width: 10),
                  Text(
                    'Active Project:',
                    style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 12),
                  DropdownButton<String>(
                    value: _selectedProjectId,
                    underline: const SizedBox(),
                    items: _projects.map((p) {
                      return DropdownMenuItem(
                        value: p.id,
                        child: Text(
                          '${p.projectName} (${p.projectCode}) - ${p.clientName}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      );
                    }).toList(),
                    onChanged: (v) {
                      if (v != null) setState(() => _selectedProjectId = v);
                    },
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Gate Health: $approvedStages / $totalStages Completed',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 5-Stage Stepper / Pipeline View
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: stages.length,
              separatorBuilder: (_, _) => const SizedBox(height: 16),
              itemBuilder: (context, idx) {
                final stage = stages[idx];
                return _buildStageCard(stage, idx + 1, isDark, theme);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStageCard(StageApprovalRequest stage, int stageNumber, bool isDark, ThemeData theme) {
    final isLocked = stage.isLocked;
    final isApproved = stage.isApproved;

    Color borderColor;
    Color iconBg;
    IconData icon;

    if (isApproved) {
      borderColor = AppColors.success.withValues(alpha: 0.7);
      iconBg = AppColors.success.withValues(alpha: 0.15);
      icon = Icons.check_circle;
    } else if (isLocked) {
      borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;
      iconBg = isDark ? AppColors.darkSurface : AppColors.lightSurface;
      icon = Icons.lock_outline;
    } else {
      borderColor = AppColors.warning.withValues(alpha: 0.8);
      iconBg = AppColors.warning.withValues(alpha: 0.15);
      icon = Icons.pending_actions;
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor, width: isApproved ? 1.5 : 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gate Number & Status Icon
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconBg,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: isApproved
                  ? AppColors.success
                  : (isLocked ? AppColors.lightMutedText : AppColors.warning),
              size: 24,
            ),
          ),
          const SizedBox(width: 16),

          // Main Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'GATE 0$stageNumber',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      stage.stageName,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isLocked ? AppColors.lightMutedText : null,
                      ),
                    ),
                    const Spacer(),
                    _buildStageStatusBadge(stage),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  stage.description,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: isDark ? AppColors.darkMutedText : AppColors.lightMutedText,
                  ),
                ),
                const SizedBox(height: 12),

                // QC Checklist Chips
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: stage.qcChecklist.entries.map((entry) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: entry.value
                            ? AppColors.success.withValues(alpha: 0.1)
                            : (isDark ? AppColors.darkSurface : AppColors.lightSurface),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: entry.value
                              ? AppColors.success.withValues(alpha: 0.3)
                              : Colors.transparent,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            entry.value ? Icons.check_circle : Icons.radio_button_unchecked,
                            size: 13,
                            color: entry.value ? AppColors.success : AppColors.lightMutedText,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            entry.key,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: entry.value ? FontWeight.w600 : FontWeight.normal,
                              color: entry.value ? AppColors.success : null,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),

                // Audit metadata if approved
                if (isApproved && stage.signedOffBy != null) ...[
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.success.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.verified, size: 16, color: AppColors.success),
                        const SizedBox(width: 8),
                        Text(
                          'Signed off by ${stage.signedOffBy} via ${stage.approvalMethod} on ${stage.signedOffAt?.day}/${stage.signedOffAt?.month}/${stage.signedOffAt?.year} at ${stage.signedOffAt?.hour}:${stage.signedOffAt?.minute.toString().padLeft(2, '0')}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.success,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 16),

          // Action Button
          if (isLocked)
            ElevatedButton.icon(
              onPressed: null,
              icon: const Icon(Icons.lock, size: 16),
              label: const Text('Locked Gate'),
              style: ElevatedButton.styleFrom(
                backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
              ),
            )
          else if (isApproved)
            OutlinedButton.icon(
              onPressed: () => _handleStageAction(stage),
              icon: const Icon(Icons.visibility, size: 16),
              label: const Text('View Sign-Off'),
            )
          else
            ElevatedButton.icon(
              onPressed: () => _handleStageAction(stage),
              icon: const Icon(Icons.mark_email_read_outlined, size: 16),
              label: const Text('Initiate Sign-Off'),
            ),
        ],
      ),
    );
  }

  Widget _buildStageStatusBadge(StageApprovalRequest stage) {
    if (stage.isApproved) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.success.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Text(
          'Approved & Certified',
          style: TextStyle(color: AppColors.success, fontSize: 11, fontWeight: FontWeight.bold),
        ),
      );
    } else if (stage.isLocked) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.lightMutedText.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Text(
          'Prerequisite Locked',
          style: TextStyle(color: AppColors.lightMutedText, fontSize: 11, fontWeight: FontWeight.bold),
        ),
      );
    } else {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.warning.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Text(
          'Awaiting Client OTP Sign-Off',
          style: TextStyle(color: AppColors.warning, fontSize: 11, fontWeight: FontWeight.bold),
        ),
      );
    }
  }
}
