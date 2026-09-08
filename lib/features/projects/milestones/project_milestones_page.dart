import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../data/projects_repository.dart';
import '../domain/projects_enums.dart';
import '../domain/projects_models.dart';
import '../widgets/project_page_header.dart';
import '../widgets/project_kpi_card.dart';
import '../widgets/project_shared_widgets.dart';

/// Project Milestones page — tracks phase-wise deliverables, checklists, and status.
class ProjectMilestonesPage extends StatefulWidget {
  const ProjectMilestonesPage({super.key});

  @override
  State<ProjectMilestonesPage> createState() => _ProjectMilestonesPageState();
}

class _ProjectMilestonesPageState extends State<ProjectMilestonesPage> {
  final _repo = ProjectsRepository();
  String? _selectedProjectId;
  String _searchQuery = '';
  MilestoneStatus? _statusFilter;
  ProjectStage? _stageFilter;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    final active = _repo.projects.where((p) => p.status.isActive).toList();
    if (active.isNotEmpty) {
      _selectedProjectId = active.first.id;
    } else if (_repo.projects.isNotEmpty) {
      _selectedProjectId = _repo.projects.first.id;
    }
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) setState(() => _isLoading = false);
    });
  }

  List<ProjectMilestone> get _filteredMilestones {
    var list = _selectedProjectId != null
        ? _repo.getMilestonesForProject(_selectedProjectId!)
        : _repo.milestones;

    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      list = list.where((m) =>
          m.name.toLowerCase().contains(q) ||
          m.description.toLowerCase().contains(q) ||
          m.assignee.toLowerCase().contains(q)).toList();
    }
    if (_statusFilter != null) {
      list = list.where((m) => m.status == _statusFilter).toList();
    }
    if (_stageFilter != null) {
      list = list.where((m) => m.stage == _stageFilter).toList();
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final milestones = _filteredMilestones;

    final totalCount = milestones.length;
    final completedCount = milestones.where((m) => m.status == MilestoneStatus.completed).length;
    final inProgressCount = milestones.where((m) => m.status == MilestoneStatus.inProgress).length;
    final overdueCount = milestones.where((m) => m.isOverdue).length;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SafeArea(
        child: Column(
          children: [
            ProjectPageHeader(
              title: 'Project Milestones',
              subtitle: 'Track deliverables, phase sign-offs & checklists',
              icon: Icons.flag_rounded,
              actions: [
                _buildProjectSelector(isDark),
                const SizedBox(width: 8),
                _buildStageFilter(isDark),
                const SizedBox(width: 8),
                _buildStatusFilter(isDark),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: () => _showCreateMilestoneDialog(context, isDark),
                  icon: const Icon(Icons.add_rounded, size: 16),
                  label: const Text('New Milestone'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ],
            ),
            Expanded(
              child: _isLoading
                  ? _buildLoadingSkeleton(isDark)
                  : RefreshIndicator(
                      onRefresh: () async {
                        setState(() {});
                      },
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // KPI Cards
                            Row(
                              children: [
                                Expanded(
                                  child: ProjectKpiCard(
                                    label: 'Total Milestones',
                                    value: '$totalCount',
                                    icon: Icons.flag_outlined,
                                    iconColor: AppColors.primary,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: ProjectKpiCard(
                                    label: 'Completed',
                                    value: '$completedCount',
                                    icon: Icons.task_alt_rounded,
                                    iconColor: AppColors.success,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: ProjectKpiCard(
                                    label: 'In Progress',
                                    value: '$inProgressCount',
                                    icon: Icons.pending_actions_rounded,
                                    iconColor: AppColors.secondary,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: ProjectKpiCard(
                                    label: 'Overdue',
                                    value: '$overdueCount',
                                    icon: Icons.warning_amber_rounded,
                                    iconColor: AppColors.error,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),

                            // Search bar
                            Container(
                              height: 40,
                              decoration: BoxDecoration(
                                color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                              ),
                              child: TextField(
                                onChanged: (v) => setState(() => _searchQuery = v),
                                style: TextStyle(fontSize: 13, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                                decoration: InputDecoration(
                                  hintText: 'Search milestones by title, description, assignee...',
                                  hintStyle: TextStyle(fontSize: 13, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                                  prefixIcon: Icon(Icons.search_rounded, size: 18, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Milestone List
                            if (milestones.isEmpty)
                              const ProjectEmptyState(
                                title: 'No milestones found',
                                description: 'Create a new milestone or adjust filters to view items.',
                                icon: Icons.flag_outlined,
                              )
                            else
                              ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: milestones.length,
                                separatorBuilder: (_, _) => const SizedBox(height: 12),
                                itemBuilder: (context, index) {
                                  final m = milestones[index];
                                  return _buildMilestoneCard(m, isDark);
                                },
                              ),
                          ],
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMilestoneCard(ProjectMilestone m, bool isDark) {
    final completedChecklist = m.checklist.where((c) => c.isDone).length;
    final totalChecklist = m.checklist.length;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: m.isOverdue
              ? AppColors.error.withValues(alpha: 0.5)
              : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: m.stage.color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(m.stage.icon, size: 20, color: m.stage.color),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            m.name,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                            ),
                          ),
                        ),
                        _buildStatusMenu(m, isDark),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      m.description,
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Details row
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: [
              _buildMetaTag(
                Icons.layers_outlined,
                m.stage.label,
                m.stage.color,
                isDark,
              ),
              _buildMetaTag(
                Icons.calendar_today_outlined,
                'Due ${_formatDate(m.dueDate)}${m.isOverdue ? " (Overdue)" : ""}',
                m.isOverdue ? AppColors.error : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                isDark,
              ),
              if (m.assignee.isNotEmpty)
                _buildMetaTag(
                  Icons.person_outline_rounded,
                  m.assignee,
                  isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  isDark,
                ),
              if (m.budgetLakhs > 0)
                _buildMetaTag(
                  Icons.currency_rupee_rounded,
                  '₹${m.budgetLakhs.toStringAsFixed(1)}L',
                  AppColors.success,
                  isDark,
                ),
              if (m.approvalRequired)
                _buildMetaTag(
                  Icons.verified_user_outlined,
                  'Approval Required',
                  AppColors.warning,
                  isDark,
                ),
              if (m.paymentRequired)
                _buildMetaTag(
                  Icons.payments_outlined,
                  'Payment Trigger',
                  AppColors.secondary,
                  isDark,
                ),
            ],
          ),
          const SizedBox(height: 14),

          // Progress bar
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: m.completionPercent / 100,
                    minHeight: 6,
                    backgroundColor: isDark ? AppColors.darkSurfaceElevated : AppColors.lightSurfaceSubtle,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      m.status == MilestoneStatus.completed ? AppColors.success : AppColors.primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '${m.completionPercent.toStringAsFixed(0)}%',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                ),
              ),
            ],
          ),

          // Checklist preview (if any)
          if (totalChecklist > 0) ...[
            const SizedBox(height: 12),
            Divider(color: isDark ? AppColors.darkBorder : AppColors.lightBorder, height: 1),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.checklist_rounded, size: 14, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                const SizedBox(width: 6),
                Text(
                  'Checklist: $completedChecklist / $totalChecklist completed',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => _showChecklistModal(context, m, isDark),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text('View All', style: TextStyle(fontSize: 11)),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMetaTag(IconData icon, String label, Color color, bool isDark) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: color),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: color),
        ),
      ],
    );
  }

  Widget _buildStatusMenu(ProjectMilestone m, bool isDark) {
    return PopupMenuButton<MilestoneStatus>(
      initialValue: m.status,
      tooltip: 'Change Status',
      onSelected: (newStatus) {
        _repo.updateMilestoneStatus(m.id, newStatus, newStatus == MilestoneStatus.completed ? 100 : m.completionPercent);
        setState(() {});
      },
      itemBuilder: (context) => MilestoneStatus.values.map((s) {
        return PopupMenuItem(
          value: s,
          child: Row(
            children: [
              Icon(s.icon, size: 14, color: s.color),
              const SizedBox(width: 8),
              Text(s.label, style: TextStyle(fontSize: 12, color: s.color, fontWeight: FontWeight.w600)),
            ],
          ),
        );
      }).toList(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: m.status.color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: m.status.color.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(m.status.icon, size: 12, color: m.status.color),
            const SizedBox(width: 4),
            Text(m.status.label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: m.status.color)),
            const SizedBox(width: 2),
            Icon(Icons.arrow_drop_down, size: 14, color: m.status.color),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectSelector(bool isDark) {
    return Container(
      height: 34,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String?>(
          value: _selectedProjectId,
          isDense: true,
          hint: Text('All Projects', style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
          icon: Icon(Icons.expand_more, size: 16, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
          dropdownColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          items: [
            DropdownMenuItem<String?>(
              value: null,
              child: Text('All Projects', style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)),
            ),
            ..._repo.projects.map((p) => DropdownMenuItem(
                  value: p.id,
                  child: Text('${p.code} — ${p.name}', style: const TextStyle(fontSize: 12)),
                )),
          ],
          onChanged: (v) => setState(() => _selectedProjectId = v),
        ),
      ),
    );
  }

  Widget _buildStageFilter(bool isDark) {
    return Container(
      height: 34,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<ProjectStage?>(
          value: _stageFilter,
          isDense: true,
          hint: Text('Stage', style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
          icon: Icon(Icons.expand_more, size: 16, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
          dropdownColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          items: [
            DropdownMenuItem<ProjectStage?>(
              value: null,
              child: Text('All Stages', style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)),
            ),
            ...ProjectStage.values.map((s) => DropdownMenuItem(
                  value: s,
                  child: Text(s.label, style: const TextStyle(fontSize: 12)),
                )),
          ],
          onChanged: (v) => setState(() => _stageFilter = v),
        ),
      ),
    );
  }

  Widget _buildStatusFilter(bool isDark) {
    return Container(
      height: 34,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<MilestoneStatus?>(
          value: _statusFilter,
          isDense: true,
          hint: Text('Status', style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
          icon: Icon(Icons.expand_more, size: 16, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
          dropdownColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          items: [
            DropdownMenuItem<MilestoneStatus?>(
              value: null,
              child: Text('All Statuses', style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)),
            ),
            ...MilestoneStatus.values.map((s) => DropdownMenuItem(
                  value: s,
                  child: Text(s.label, style: const TextStyle(fontSize: 12)),
                )),
          ],
          onChanged: (v) => setState(() => _statusFilter = v),
        ),
      ),
    );
  }

  void _showChecklistModal(BuildContext context, ProjectMilestone m, bool isDark) {
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.checklist_rounded, size: 20, color: AppColors.primary),
                      const SizedBox(width: 8),
                      Text(
                        '${m.name} — Checklist',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () => Navigator.pop(ctx),
                        icon: const Icon(Icons.close, size: 18),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ...m.checklist.map((item) {
                    return CheckboxListTile(
                      value: item.isDone,
                      onChanged: (val) {
                        final idx = m.checklist.indexWhere((c) => c.id == item.id);
                        if (idx != -1) {
                          final updated = List<MilestoneChecklistItem>.from(m.checklist);
                          updated[idx] = item.copyWith(isDone: val ?? false);
                          final doneCount = updated.where((c) => c.isDone).length;
                          final progress = (doneCount / updated.length) * 100;
                          final updatedMilestone = m.copyWith(checklist: updated, completionPercent: progress);
                          _repo.addMilestone(updatedMilestone); // Replaces or updates
                          setModalState(() {});
                          setState(() {});
                        }
                      },
                      title: Text(
                        item.label,
                        style: TextStyle(
                          fontSize: 13,
                          decoration: item.isDone ? TextDecoration.lineThrough : null,
                          color: item.isDone
                              ? (isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)
                              : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                        ),
                      ),
                      subtitle: item.assignee != null
                          ? Text(item.assignee!, style: TextStyle(fontSize: 11, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary))
                          : null,
                      controlAffinity: ListTileControlAffinity.leading,
                    );
                  }),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showCreateMilestoneDialog(BuildContext context, bool isDark) {
    final nameCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    final assigneeCtrl = TextEditingController();
    final budgetCtrl = TextEditingController();
    ProjectStage stage = ProjectStage.execution;
    ProjectTaskPriority priority = ProjectTaskPriority.medium;
    DateTime dueDate = DateTime.now().add(const Duration(days: 30));
    bool approvalReq = false;
    bool paymentReq = false;

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            return AlertDialog(
              backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
              title: Text('New Milestone', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)),
              content: SizedBox(
                width: 480,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: nameCtrl,
                        decoration: const InputDecoration(labelText: 'Milestone Title *', hintText: 'e.g. False Ceiling & Lighting'),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: descCtrl,
                        maxLines: 2,
                        decoration: const InputDecoration(labelText: 'Description', hintText: 'Key deliverables and criteria'),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<ProjectStage>(
                              initialValue: stage,
                              decoration: const InputDecoration(labelText: 'Stage'),
                              items: ProjectStage.values.map((s) => DropdownMenuItem(value: s, child: Text(s.label, style: const TextStyle(fontSize: 12)))).toList(),
                              onChanged: (v) => setDialogState(() => stage = v ?? stage),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: DropdownButtonFormField<ProjectTaskPriority>(
                              initialValue: priority,
                              decoration: const InputDecoration(labelText: 'Priority'),
                              items: ProjectTaskPriority.values.map((p) => DropdownMenuItem(value: p, child: Text(p.label, style: const TextStyle(fontSize: 12)))).toList(),
                              onChanged: (v) => setDialogState(() => priority = v ?? priority),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: assigneeCtrl,
                              decoration: const InputDecoration(labelText: 'Assignee', hintText: 'Site Supervisor / Lead'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              controller: budgetCtrl,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(labelText: 'Budget (Lakhs)', hintText: 'e.g. 2.5'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      CheckboxListTile(
                        value: approvalReq,
                        onChanged: (v) => setDialogState(() => approvalReq = v ?? false),
                        title: const Text('Client Approval Required', style: TextStyle(fontSize: 12)),
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: EdgeInsets.zero,
                      ),
                      CheckboxListTile(
                        value: paymentReq,
                        onChanged: (v) => setDialogState(() => paymentReq = v ?? false),
                        title: const Text('Triggers Milestone Payment', style: TextStyle(fontSize: 12)),
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (nameCtrl.text.trim().isEmpty) return;
                    final newM = ProjectMilestone(
                      id: 'ms-${DateTime.now().millisecondsSinceEpoch}',
                      projectId: _selectedProjectId ?? (_repo.projects.isNotEmpty ? _repo.projects.first.id : 'proj-1'),
                      name: nameCtrl.text.trim(),
                      stage: stage,
                      description: descCtrl.text.trim(),
                      startDate: DateTime.now(),
                      dueDate: dueDate,
                      priority: priority,
                      assignee: assigneeCtrl.text.trim(),
                      budgetLakhs: double.tryParse(budgetCtrl.text.trim()) ?? 0,
                      approvalRequired: approvalReq,
                      paymentRequired: paymentReq,
                      status: MilestoneStatus.notStarted,
                      completionPercent: 0,
                      checklist: [
                        const MilestoneChecklistItem(id: 'c1', label: 'Material procurement verified'),
                        const MilestoneChecklistItem(id: 'c2', label: 'Execution quality inspect passed'),
                        const MilestoneChecklistItem(id: 'c3', label: 'Site supervisor sign-off'),
                      ],
                    );
                    _repo.addMilestone(newM);
                    Navigator.pop(ctx);
                    setState(() {});
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
                  child: const Text('Create Milestone'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  String _formatDate(DateTime d) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${d.day} ${months[d.month - 1]} ${d.year}';
  }

  Widget _buildLoadingSkeleton(bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          ProjectSkeleton.kpiRow(count: 4, isDark: isDark),
          const SizedBox(height: 16),
          ...List.generate(4, (_) => ProjectSkeleton.listTile(isDark: isDark)),
        ],
      ),
    );
  }
}
