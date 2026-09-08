import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../data/projects_repository.dart';
import '../domain/projects_enums.dart';
import '../domain/projects_models.dart';
import '../widgets/project_page_header.dart';
import '../widgets/project_kpi_card.dart';
import '../widgets/project_shared_widgets.dart';

/// Project Approvals page — manages client and internal approvals for designs,
/// material selections, milestone sign-offs, and final handovers.
class ProjectApprovalsPage extends StatefulWidget {
  const ProjectApprovalsPage({super.key});

  @override
  State<ProjectApprovalsPage> createState() => _ProjectApprovalsPageState();
}

class _ProjectApprovalsPageState extends State<ProjectApprovalsPage> with SingleTickerProviderStateMixin {
  final _repo = ProjectsRepository();
  String? _selectedProjectId;
  String _searchQuery = '';
  ApprovalType? _typeFilter;
  late TabController _tabController;
  bool _isLoading = true;

  final _tabs = const [
    'All',
    'Pending',
    'Approved',
    'Rejected / Revision',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) setState(() {});
    });

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

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<WorkApproval> get _filteredApprovals {
    var list = _selectedProjectId != null
        ? _repo.getApprovalsForProject(_selectedProjectId!)
        : _repo.approvals;

    // Tab filter
    if (_tabController.index == 1) {
      list = list.where((a) => a.status == ApprovalStatus.pending).toList();
    } else if (_tabController.index == 2) {
      list = list.where((a) => a.status == ApprovalStatus.approved).toList();
    } else if (_tabController.index == 3) {
      list = list.where((a) => a.status == ApprovalStatus.rejected || a.status == ApprovalStatus.revisionRequested).toList();
    }

    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      list = list.where((a) =>
          a.description.toLowerCase().contains(q) ||
          a.milestoneName.toLowerCase().contains(q) ||
          a.clientName.toLowerCase().contains(q) ||
          a.submittedBy.toLowerCase().contains(q)).toList();
    }
    if (_typeFilter != null) {
      list = list.where((a) => a.type == _typeFilter).toList();
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final allApprovals = _selectedProjectId != null
        ? _repo.getApprovalsForProject(_selectedProjectId!)
        : _repo.approvals;

    final totalCount = allApprovals.length;
    final pendingCount = allApprovals.where((a) => a.status == ApprovalStatus.pending).length;
    final approvedCount = allApprovals.where((a) => a.status == ApprovalStatus.approved).length;
    final rejectedCount = allApprovals.where((a) => a.status == ApprovalStatus.rejected || a.status == ApprovalStatus.revisionRequested).length;

    final displayed = _filteredApprovals;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SafeArea(
        child: Column(
          children: [
            ProjectPageHeader(
              title: 'Work Approvals',
              subtitle: 'Client sign-offs on drawings, finishes, execution & handover',
              icon: Icons.verified_user_outlined,
              actions: [
                _buildProjectSelector(isDark),
                const SizedBox(width: 8),
                _buildTypeFilter(isDark),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: () => _showCreateApprovalDialog(context, isDark),
                  icon: const Icon(Icons.add_task_rounded, size: 16),
                  label: const Text('Request Approval'),
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
                            // KPI Cards
                            Row(
                              children: [
                                Expanded(
                                  child: ProjectKpiCard(
                                    label: 'Total Requests',
                                    value: '$totalCount',
                                    icon: Icons.assignment_outlined,
                                    iconColor: AppColors.primary,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: ProjectKpiCard(
                                    label: 'Pending Approval',
                                    value: '$pendingCount',
                                    icon: Icons.pending_actions_rounded,
                                    iconColor: AppColors.warning,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: ProjectKpiCard(
                                    label: 'Approved',
                                    value: '$approvedCount',
                                    icon: Icons.verified_rounded,
                                    iconColor: AppColors.success,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: ProjectKpiCard(
                                    label: 'Revision / Rejected',
                                    value: '$rejectedCount',
                                    icon: Icons.replay_rounded,
                                    iconColor: AppColors.error,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 18),

                            // Tabs & Search Row
                            Row(
                              children: [
                                Container(
                                  height: 38,
                                  decoration: BoxDecoration(
                                    color: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                                  ),
                                  child: TabBar(
                                    controller: _tabController,
                                    isScrollable: true,
                                    indicatorColor: AppColors.primary,
                                    indicatorWeight: 2,
                                    labelColor: AppColors.primary,
                                    unselectedLabelColor: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                                    labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                                    tabs: _tabs.map((t) => Tab(text: t)).toList(),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Container(
                                    height: 38,
                                    decoration: BoxDecoration(
                                      color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                                    ),
                                    child: TextField(
                                      onChanged: (v) => setState(() => _searchQuery = v),
                                      style: TextStyle(fontSize: 13, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                                      decoration: InputDecoration(
                                        hintText: 'Search approvals by milestone, description, or submitter...',
                                        hintStyle: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                                        prefixIcon: Icon(Icons.search_rounded, size: 18, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                                        border: InputBorder.none,
                                        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // List of Approvals
                            if (displayed.isEmpty)
                              const ProjectEmptyState(
                                title: 'No approval requests',
                                description: 'Submit a new approval request or change tab filter.',
                                icon: Icons.verified_user_outlined,
                              )
                            else
                              ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: displayed.length,
                                separatorBuilder: (_, _) => const SizedBox(height: 14),
                                itemBuilder: (context, index) {
                                  final app = displayed[index];
                                  return _buildApprovalCard(app, isDark);
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

  Widget _buildApprovalCard(WorkApproval app, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: app.isOverdue
              ? AppColors.error.withValues(alpha: 0.5)
              : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row: Type badge, Due date, Status badge
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: app.type.color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(app.type.icon, size: 13, color: app.type.color),
                    const SizedBox(width: 4),
                    Text(
                      app.type.label,
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: app.type.color),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              if (app.milestoneName.isNotEmpty)
                Text(
                  'Milestone: ${app.milestoneName}',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                ),
              const Spacer(),
              _buildApprovalStatusBadge(app.status),
            ],
          ),
          const SizedBox(height: 12),

          // Description & Message
          Text(
            app.description,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
          ),
          if (app.message.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              app.message,
              style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
            ),
          ],
          const SizedBox(height: 12),

          // Meta info
          Wrap(
            spacing: 16,
            runSpacing: 6,
            children: [
              _buildMeta(Icons.person_outline_rounded, 'By: ${app.submittedBy}', isDark),
              _buildMeta(Icons.calendar_today_outlined, 'Submitted ${_formatDate(app.submittedDate)}', isDark),
              if (app.dueDate != null)
                _buildMeta(
                  Icons.alarm_outlined,
                  'Due ${_formatDate(app.dueDate!)}${app.isOverdue ? " (Overdue)" : ""}',
                  isDark,
                  color: app.isOverdue ? AppColors.error : null,
                ),
              if (app.clientName.isNotEmpty)
                _buildMeta(Icons.account_circle_outlined, 'Client: ${app.clientName}', isDark),
            ],
          ),

          // Rejection / Revision Reason banner
          if (app.rejectionReason != null && app.rejectionReason!.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.info_outline_rounded, size: 16, color: AppColors.error),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Reason for Revision / Rejection:', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.error)),
                        const SizedBox(height: 2),
                        Text(app.rejectionReason!, style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],

          // Approved info banner
          if (app.status == ApprovalStatus.approved && app.approvedBy != null) ...[
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.check_circle_rounded, size: 14, color: AppColors.success),
                const SizedBox(width: 6),
                Text(
                  'Approved by ${app.approvedBy} on ${app.approvedDate != null ? _formatDate(app.approvedDate!) : ""}',
                  style: const TextStyle(fontSize: 12, color: AppColors.success, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ],

          // Action buttons for Pending items
          if (app.status == ApprovalStatus.pending) ...[
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton.icon(
                  onPressed: () => _showRejectDialog(context, app, isDark),
                  icon: const Icon(Icons.close_rounded, size: 14, color: AppColors.error),
                  label: const Text('Reject / Request Changes', style: TextStyle(fontSize: 12, color: AppColors.error)),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppColors.error.withValues(alpha: 0.5)),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: () {
                    _repo.approveRequest(app.id, 'Client / Lead Architect');
                    setState(() {});
                  },
                  icon: const Icon(Icons.check_rounded, size: 14),
                  label: const Text('Approve Request', style: TextStyle(fontSize: 12)),
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

  Widget _buildApprovalStatusBadge(ApprovalStatus status) {
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

  Widget _buildTypeFilter(bool isDark) {
    return Container(
      height: 34,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<ApprovalType?>(
          value: _typeFilter,
          isDense: true,
          hint: Text('Approval Type', style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
          icon: Icon(Icons.expand_more, size: 16, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
          dropdownColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          items: [
            DropdownMenuItem<ApprovalType?>(
              value: null,
              child: Text('All Types', style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)),
            ),
            ...ApprovalType.values.map((t) => DropdownMenuItem(
                  value: t,
                  child: Text(t.label, style: const TextStyle(fontSize: 12)),
                )),
          ],
          onChanged: (v) => setState(() => _typeFilter = v),
        ),
      ),
    );
  }

  void _showRejectDialog(BuildContext context, WorkApproval app, bool isDark) {
    final reasonCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          title: Text('Request Changes / Reject', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)),
          content: SizedBox(
            width: 420,
            child: TextField(
              controller: reasonCtrl,
              maxLines: 3,
              decoration: const InputDecoration(labelText: 'Feedback / Revision Reason *', hintText: 'Explain what adjustments or corrections are needed'),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                if (reasonCtrl.text.trim().isEmpty) return;
                _repo.rejectRequest(app.id, 'Client / Lead Architect', reasonCtrl.text.trim());
                Navigator.pop(ctx);
                setState(() {});
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.error, foregroundColor: Colors.white),
              child: const Text('Submit Feedback'),
            ),
          ],
        );
      },
    );
  }

  void _showCreateApprovalDialog(BuildContext context, bool isDark) {
    ApprovalType type = ApprovalType.design;
    final milestoneCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    final msgCtrl = TextEditingController();
    DateTime dueDate = DateTime.now().add(const Duration(days: 5));

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            return AlertDialog(
              backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
              title: Text('Request Work Approval', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)),
              content: SizedBox(
                width: 480,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      DropdownButtonFormField<ApprovalType>(
                        initialValue: type,
                        decoration: const InputDecoration(labelText: 'Approval Type *'),
                        items: ApprovalType.values.map((t) => DropdownMenuItem(value: t, child: Text(t.label, style: const TextStyle(fontSize: 12)))).toList(),
                        onChanged: (v) => setDialogState(() => type = v ?? type),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: milestoneCtrl,
                        decoration: const InputDecoration(labelText: 'Milestone / Phase Name', hintText: 'e.g. Master Bedroom 3D Renders'),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: descCtrl,
                        decoration: const InputDecoration(labelText: 'Title / Subject *', hintText: 'e.g. Italian Marble flooring sample sign-off'),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: msgCtrl,
                        maxLines: 3,
                        decoration: const InputDecoration(labelText: 'Message for Client', hintText: 'Please review and confirm selections before we initiate cutting'),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
                ElevatedButton(
                  onPressed: () {
                    if (descCtrl.text.trim().isEmpty) return;
                    final newApproval = WorkApproval(
                      id: 'app-${DateTime.now().millisecondsSinceEpoch}',
                      projectId: _selectedProjectId ?? (_repo.projects.isNotEmpty ? _repo.projects.first.id : 'proj-1'),
                      type: type,
                      milestoneName: milestoneCtrl.text.trim(),
                      description: descCtrl.text.trim(),
                      message: msgCtrl.text.trim(),
                      submittedBy: 'Design Lead',
                      submittedDate: DateTime.now(),
                      dueDate: dueDate,
                      status: ApprovalStatus.pending,
                    );
                    _repo.createApproval(newApproval);
                    Navigator.pop(ctx);
                    setState(() {});
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
                  child: const Text('Send for Approval'),
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
