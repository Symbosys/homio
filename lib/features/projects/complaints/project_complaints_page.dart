import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../data/projects_repository.dart';
import '../domain/projects_enums.dart';
import '../domain/projects_models.dart';
import '../widgets/project_page_header.dart';
import '../widgets/project_kpi_card.dart';
import '../widgets/project_shared_widgets.dart';

/// Complaints & Snags page — snag list, quality punch list, client complaints,
/// priority escalation chain, and resolution sign-offs.
class ProjectComplaintsPage extends StatefulWidget {
  const ProjectComplaintsPage({super.key});

  @override
  State<ProjectComplaintsPage> createState() => _ProjectComplaintsPageState();
}

class _ProjectComplaintsPageState extends State<ProjectComplaintsPage> {
  final _repo = ProjectsRepository();
  String? _selectedProjectId;
  String _searchQuery = '';
  ComplaintStatus? _statusFilter;
  ComplaintPriority? _priorityFilter;
  ComplaintType? _typeFilter;
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

  List<Complaint> get _filteredComplaints {
    var list = _selectedProjectId != null
        ? _repo.getComplaintsForProject(_selectedProjectId!)
        : _repo.complaints;

    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      list = list.where((c) =>
          c.title.toLowerCase().contains(q) ||
          c.description.toLowerCase().contains(q) ||
          c.areaRoom.toLowerCase().contains(q) ||
          c.reportedBy.toLowerCase().contains(q) ||
          c.assignedTo.toLowerCase().contains(q)).toList();
    }
    if (_statusFilter != null) {
      list = list.where((c) => c.status == _statusFilter).toList();
    }
    if (_priorityFilter != null) {
      list = list.where((c) => c.priority == _priorityFilter).toList();
    }
    if (_typeFilter != null) {
      list = list.where((c) => c.type == _typeFilter).toList();
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final allComplaints = _selectedProjectId != null
        ? _repo.getComplaintsForProject(_selectedProjectId!)
        : _repo.complaints;

    final totalCount = allComplaints.length;
    final openCount = allComplaints.where((c) => !c.isResolved).length;
    final criticalCount = allComplaints.where((c) => c.priority == ComplaintPriority.critical || c.priority == ComplaintPriority.high).length;
    final resolvedCount = allComplaints.where((c) => c.isResolved).length;

    final displayed = _filteredComplaints;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SafeArea(
        child: Column(
          children: [
            ProjectPageHeader(
              title: 'Complaints / Snags',
              subtitle: 'Defect punch list, quality issues & customer resolution tracking',
              icon: Icons.report_problem_outlined,
              actions: [
                _buildProjectSelector(isDark),
                const SizedBox(width: 8),
                _buildPriorityFilter(isDark),
                const SizedBox(width: 8),
                _buildStatusFilter(isDark),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: () => _showReportSnagDialog(context, isDark),
                  icon: const Icon(Icons.add_alert_rounded, size: 16),
                  label: const Text('Report Snag'),
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
                      onRefresh: () async => setState(() {}),
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // KPI row
                            Row(
                              children: [
                                Expanded(
                                  child: ProjectKpiCard(
                                    label: 'Total Snags',
                                    value: '$totalCount',
                                    icon: Icons.checklist_rtl_rounded,
                                    iconColor: AppColors.primary,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: ProjectKpiCard(
                                    label: 'Open / Unresolved',
                                    value: '$openCount',
                                    icon: Icons.warning_amber_rounded,
                                    iconColor: AppColors.warning,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: ProjectKpiCard(
                                    label: 'High / Critical',
                                    value: '$criticalCount',
                                    icon: Icons.priority_high_rounded,
                                    iconColor: AppColors.error,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: ProjectKpiCard(
                                    label: 'Resolved & Closed',
                                    value: '$resolvedCount',
                                    icon: Icons.task_alt_rounded,
                                    iconColor: AppColors.success,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 18),

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
                                  hintText: 'Search snags by title, area, assigned person, or description...',
                                  hintStyle: TextStyle(fontSize: 13, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                                  prefixIcon: Icon(Icons.search_rounded, size: 18, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),

                            // List of Snags
                            if (displayed.isEmpty)
                              const ProjectEmptyState(
                                title: 'No snags or complaints reported',
                                description: 'Report a new snag or adjust filters to view items.',
                                icon: Icons.sentiment_satisfied_alt_rounded,
                              )
                            else
                              ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: displayed.length,
                                separatorBuilder: (_, _) => const SizedBox(height: 14),
                                itemBuilder: (context, index) {
                                  final complaint = displayed[index];
                                  return _buildComplaintCard(complaint, isDark);
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

  Widget _buildComplaintCard(Complaint c, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: c.priority == ComplaintPriority.critical
              ? AppColors.error.withValues(alpha: 0.5)
              : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row: Type badge, Room/area, Priority badge, Escalation, Status badge
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: c.type.color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(c.type.icon, size: 13, color: c.type.color),
                    const SizedBox(width: 4),
                    Text(c.type.label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: c.type.color)),
                  ],
                ),
              ),
              if (c.areaRoom.isNotEmpty) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(c.areaRoom, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
                ),
              ],
              const SizedBox(width: 8),
              _buildPriorityBadge(c.priority),
              if (c.escalationLevel > 0) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'Level ${c.escalationLevel} Escalation',
                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.error),
                  ),
                ),
              ],
              const Spacer(),
              _buildComplaintStatusBadge(c.status),
            ],
          ),
          const SizedBox(height: 12),

          // Title & description
          Text(
            c.title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              decoration: c.isResolved ? TextDecoration.lineThrough : null,
              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            c.description,
            style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
          ),
          const SizedBox(height: 12),

          // Meta info
          Wrap(
            spacing: 16,
            runSpacing: 6,
            children: [
              if (c.reportedBy.isNotEmpty)
                _buildMeta(Icons.person_pin_outlined, 'Reported by: ${c.reportedBy}', isDark),
              if (c.assignedTo.isNotEmpty)
                _buildMeta(Icons.assignment_ind_outlined, 'Assigned: ${c.assignedTo}', isDark),
              _buildMeta(Icons.calendar_today_outlined, 'Reported: ${_formatDate(c.date)}', isDark),
              if (c.expectedResolution != null)
                _buildMeta(
                  Icons.alarm_outlined,
                  'Target: ${_formatDate(c.expectedResolution!)}${c.isOverdue ? " (Overdue)" : ""}',
                  isDark,
                  color: c.isOverdue ? AppColors.error : null,
                ),
            ],
          ),

          // Resolution banner (if resolved)
          if (c.resolution != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.success.withValues(alpha: 0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.check_circle_rounded, size: 16, color: AppColors.success),
                      const SizedBox(width: 6),
                      Text(
                        'Resolved by ${c.resolution!.resolvedBy} on ${_formatDate(c.resolution!.resolvedDate)}',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.success),
                      ),
                      const Spacer(),
                      if (c.resolution!.customerConfirmed)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.success.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text('Client Confirmed', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.success)),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    c.resolution!.description,
                    style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                  ),
                ],
              ),
            ),
          ],

          // Footer action: "Resolve Snag" button if not resolved
          if (!c.isResolved) ...[
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _showResolveDialog(context, c, isDark),
                  icon: const Icon(Icons.check_circle_outline_rounded, size: 14),
                  label: const Text('Resolve & Close Snag', style: TextStyle(fontSize: 12)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.success,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPriorityBadge(ComplaintPriority priority) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: priority.color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        priority.label,
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: priority.color),
      ),
    );
  }

  Widget _buildComplaintStatusBadge(ComplaintStatus status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: status.color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        status.label,
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: status.color),
      ),
    );
  }

  Widget _buildMeta(IconData icon, String label, bool isDark, {Color? color}) {
    final c = color ?? (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: c),
        const SizedBox(width: 4),
        Text(label, style: TextStyle(fontSize: 11, color: c)),
      ],
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

  Widget _buildPriorityFilter(bool isDark) {
    return Container(
      height: 34,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<ComplaintPriority?>(
          value: _priorityFilter,
          isDense: true,
          hint: Text('Priority', style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
          icon: Icon(Icons.expand_more, size: 16, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
          dropdownColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          items: [
            DropdownMenuItem<ComplaintPriority?>(
              value: null,
              child: Text('All Priorities', style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)),
            ),
            ...ComplaintPriority.values.map((p) => DropdownMenuItem(
                  value: p,
                  child: Text(p.label, style: const TextStyle(fontSize: 12)),
                )),
          ],
          onChanged: (v) => setState(() => _priorityFilter = v),
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
        child: DropdownButton<ComplaintStatus?>(
          value: _statusFilter,
          isDense: true,
          hint: Text('Status', style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
          icon: Icon(Icons.expand_more, size: 16, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
          dropdownColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          items: [
            DropdownMenuItem<ComplaintStatus?>(
              value: null,
              child: Text('All Statuses', style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)),
            ),
            ...ComplaintStatus.values.map((s) => DropdownMenuItem(
                  value: s,
                  child: Text(s.label, style: const TextStyle(fontSize: 12)),
                )),
          ],
          onChanged: (v) => setState(() => _statusFilter = v),
        ),
      ),
    );
  }

  void _showResolveDialog(BuildContext context, Complaint c, bool isDark) {
    final resCtrl = TextEditingController();
    final leadCtrl = TextEditingController(text: 'Site Quality Lead');
    bool clientConfirmed = true;

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            return AlertDialog(
              backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
              title: Text('Resolve Snag / Defect', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)),
              content: SizedBox(
                width: 440,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: resCtrl,
                      maxLines: 3,
                      decoration: const InputDecoration(labelText: 'Resolution Summary *', hintText: 'Explain corrective work executed'),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: leadCtrl,
                      decoration: const InputDecoration(labelText: 'Resolved By (Lead / Supervisor)', hintText: 'Name & role'),
                    ),
                    const SizedBox(height: 8),
                    CheckboxListTile(
                      value: clientConfirmed,
                      onChanged: (v) => setDialogState(() => clientConfirmed = v ?? false),
                      title: const Text('Client verbally inspected & confirmed', style: TextStyle(fontSize: 12)),
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
                ElevatedButton(
                  onPressed: () {
                    if (resCtrl.text.trim().isEmpty) return;
                    final res = ComplaintResolution(
                      description: resCtrl.text.trim(),
                      resolvedBy: leadCtrl.text.trim(),
                      resolvedDate: DateTime.now(),
                      customerConfirmed: clientConfirmed,
                    );
                    _repo.resolveComplaint(c.id, res);
                    Navigator.pop(ctx);
                    setState(() {});
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.success, foregroundColor: Colors.white),
                  child: const Text('Confirm Resolution'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showReportSnagDialog(BuildContext context, bool isDark) {
    ComplaintType type = ComplaintType.quality;
    ComplaintPriority priority = ComplaintPriority.medium;
    final titleCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    final roomCtrl = TextEditingController();
    final assignedCtrl = TextEditingController();
    DateTime targetDate = DateTime.now().add(const Duration(days: 3));

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            return AlertDialog(
              backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
              title: Text('Report Snag / Quality Issue', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)),
              content: SizedBox(
                width: 480,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<ComplaintType>(
                              initialValue: type,
                              decoration: const InputDecoration(labelText: 'Issue Type *'),
                              items: ComplaintType.values.map((t) => DropdownMenuItem(value: t, child: Text(t.label, style: const TextStyle(fontSize: 12)))).toList(),
                              onChanged: (v) => setDialogState(() => type = v ?? type),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: DropdownButtonFormField<ComplaintPriority>(
                              initialValue: priority,
                              decoration: const InputDecoration(labelText: 'Priority *'),
                              items: ComplaintPriority.values.map((p) => DropdownMenuItem(value: p, child: Text(p.label, style: const TextStyle(fontSize: 12)))).toList(),
                              onChanged: (v) => setDialogState(() => priority = v ?? priority),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: titleCtrl,
                        decoration: const InputDecoration(labelText: 'Title *', hintText: 'e.g. Paint scratch on wardrobe panel'),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: descCtrl,
                        maxLines: 2,
                        decoration: const InputDecoration(labelText: 'Description / Defect Details *', hintText: 'Exact defect observed and rectification needed'),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: roomCtrl,
                              decoration: const InputDecoration(labelText: 'Room / Area', hintText: 'e.g. Kids Bedroom'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              controller: assignedCtrl,
                              decoration: const InputDecoration(labelText: 'Assign Rectification To', hintText: 'Carpenter / Painter'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
                ElevatedButton(
                  onPressed: () {
                    if (titleCtrl.text.trim().isEmpty) return;
                    final newComplaint = Complaint(
                      id: 'snag-${DateTime.now().millisecondsSinceEpoch}',
                      projectId: _selectedProjectId ?? (_repo.projects.isNotEmpty ? _repo.projects.first.id : 'proj-1'),
                      type: type,
                      priority: priority,
                      title: titleCtrl.text.trim(),
                      description: descCtrl.text.trim(),
                      areaRoom: roomCtrl.text.trim(),
                      reportedBy: 'Site Engineer',
                      assignedTo: assignedCtrl.text.trim(),
                      date: DateTime.now(),
                      expectedResolution: targetDate,
                      status: ComplaintStatus.open,
                    );
                    _repo.addComplaint(newComplaint);
                    Navigator.pop(ctx);
                    setState(() {});
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
                  child: const Text('Log Snag'),
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
    return '${d.day} ${months[d.month - 1]}';
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
