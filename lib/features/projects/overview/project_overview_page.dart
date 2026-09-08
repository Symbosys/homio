import 'package:client/features/projects/widgets/project_kpi_card.dart';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../data/projects_repository.dart';
import '../domain/projects_enums.dart';
import '../domain/projects_models.dart';
import '../widgets/project_page_header.dart';
import '../widgets/project_shared_widgets.dart';

/// Project Overview — 360° project dashboard with project selector,
/// KPI summary, multi-bar progress, stage stepper, timeline, alerts, and team.
class ProjectOverviewPage extends StatefulWidget {
  const ProjectOverviewPage({super.key});

  @override
  State<ProjectOverviewPage> createState() => _ProjectOverviewPageState();
}

class _ProjectOverviewPageState extends State<ProjectOverviewPage> {
  final _repo = ProjectsRepository();
  String? _selectedProjectId;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    if (_repo.projects.isNotEmpty) {
      _selectedProjectId = _repo.projects.first.id;
    }
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) setState(() => _isLoading = false);
    });
  }

  Project? get _currentProject {
    if (_selectedProjectId == null) return null;
    return _repo.getProjectById(_selectedProjectId!);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final project = _currentProject;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SafeArea(
        child: Column(
          children: [
            ProjectPageHeader(
              title: 'Project Overview',
              subtitle: project?.name ?? 'Select a project',
              icon: Icons.dashboard_outlined,
              actions: [
                _buildProjectSelector(isDark),
              ],
            ),
            Expanded(
              child: _isLoading
                  ? _buildLoadingSkeleton(isDark)
                  : project == null
                      ? const ProjectEmptyState(
                          title: 'No project selected',
                          description: 'Select a project from the dropdown above.',
                        )
                      : _buildOverviewContent(project, isDark),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectSelector(bool isDark) {
    return Container(
      height: 36,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedProjectId,
          hint: Text('Select Project', style: TextStyle(fontSize: 13, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
          icon: Icon(Icons.expand_more, size: 18, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
          isDense: true,
          style: TextStyle(fontSize: 13, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
          dropdownColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          items: _repo.projects.map((p) => DropdownMenuItem(
            value: p.id,
            child: Text('${p.code} — ${p.name}', style: const TextStyle(fontSize: 13), overflow: TextOverflow.ellipsis),
          )).toList(),
          onChanged: (v) => setState(() => _selectedProjectId = v),
        ),
      ),
    );
  }

  Widget _buildOverviewContent(Project project, bool isDark) {
    final timeline = _repo.getTimelineForProject(project.id);
    final projectAlerts = _repo.getAlertsForProject(project.id);
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width >= 1024;

    return SingleChildScrollView(
      key: PageStorageKey('project_overview_${project.id}'),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Project Header Card
          _buildProjectHeaderCard(project, isDark),
          const SizedBox(height: 16),
          // KPI Row
          LayoutBuilder(
            builder: (context, constraints) {
              final isCompact = constraints.maxWidth < 768;
              final cards = _buildKpiCards(project);
              if (isCompact) {
                return Wrap(
                  spacing: 8, runSpacing: 8,
                  children: cards.map((w) => SizedBox(width: (constraints.maxWidth - 8) / 2, child: w)).toList(),
                );
              }
              return Row(
                children: cards.map((w) => Expanded(child: Padding(padding: const EdgeInsets.only(right: 12), child: w))).toList(),
              );
            },
          ),
          const SizedBox(height: 16),
          // Stage Stepper
          ProjectStageStepper(currentStage: project.currentStage),
          const SizedBox(height: 16),
          // Two-column layout (Desktop) or single column (Mobile)
          if (isDesktop)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      ProjectProgressCard(
                        overallProgress: project.progressPercent,
                        designProgress: project.designProgress,
                        executionProgress: project.executionProgress,
                        procurementProgress: project.procurementProgress,
                        paymentProgress: project.paymentProgress,
                      ),
                      const SizedBox(height: 16),
                      _buildTimelineSection(timeline, isDark),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      _buildProjectInfoCard(project, isDark),
                      const SizedBox(height: 16),
                      if (projectAlerts.isNotEmpty) ...[
                        _buildAlertsSection(projectAlerts, isDark),
                        const SizedBox(height: 16),
                      ],
                      _buildTeamSection(project, isDark),
                    ],
                  ),
                ),
              ],
            )
          else ...[
            ProjectProgressCard(
              overallProgress: project.progressPercent,
              designProgress: project.designProgress,
              executionProgress: project.executionProgress,
              procurementProgress: project.procurementProgress,
              paymentProgress: project.paymentProgress,
            ),
            const SizedBox(height: 16),
            _buildProjectInfoCard(project, isDark),
            const SizedBox(height: 16),
            if (projectAlerts.isNotEmpty) ...[
              _buildAlertsSection(projectAlerts, isDark),
              const SizedBox(height: 16),
            ],
            _buildTeamSection(project, isDark),
            const SizedBox(height: 16),
            _buildTimelineSection(timeline, isDark),
          ],
        ],
      ),
    );
  }

  Widget _buildProjectHeaderCard(Project project, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.2),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(project.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: -0.3)),
                const SizedBox(height: 4),
                Text('${project.code} • ${project.category}', style: TextStyle(fontSize: 13, color: Colors.white.withValues(alpha: 0.8))),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(Icons.person_outlined, size: 14, color: Colors.white.withValues(alpha: 0.7)),
                    const SizedBox(width: 4),
                    Text(project.clientName, style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.9))),
                    const SizedBox(width: 16),
                    Icon(Icons.location_on_outlined, size: 14, color: Colors.white.withValues(alpha: 0.7)),
                    const SizedBox(width: 4),
                    Text(project.siteCity, style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.9))),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text('${project.progressPercent.toStringAsFixed(0)}% Complete', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white)),
              ),
              const SizedBox(height: 8),
              Text(
                project.isOverdue ? '${project.delayDays}d overdue' : '${project.daysRemaining}d remaining',
                style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.8)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> _buildKpiCards(Project project) {
    return [
      ProjectKpiCard(label: 'Tasks', value: '${project.completedTasks}/${project.totalTasks}', icon: Icons.task_alt_outlined, iconColor: const Color(0xFF3B82F6)),
      ProjectKpiCard(label: 'Milestones', value: '${project.completedMilestones}/${project.totalMilestones}', icon: Icons.flag_outlined, iconColor: const Color(0xFF8B5CF6)),
      ProjectKpiCard(label: 'Approvals', value: '${project.pendingApprovals}', icon: Icons.pending_actions_outlined, iconColor: const Color(0xFFF59E0B)),
      ProjectKpiCard(label: 'Complaints', value: '${project.openComplaints}', icon: Icons.report_outlined, iconColor: AppColors.error),
    ];
  }

  Widget _buildProjectInfoCard(Project project, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Project Details', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)),
          const SizedBox(height: 12),
          _infoRow('Type', project.type.label, isDark),
          _infoRow('Area', '${project.totalAreaSqFt.toStringAsFixed(0)} sq.ft.', isDark),
          _infoRow('Address', project.siteAddress, isDark),
          _infoRow('Contract', project.formattedContract, isDark),
          _infoRow('Received', project.formattedReceived, isDark),
          _infoRow('Outstanding', project.formattedOutstanding, isDark, valueColor: project.totalOutstandingLakhs > 0 ? AppColors.error : AppColors.success),
          _infoRow('PM', project.projectManager, isDark),
          _infoRow('Designer', project.designer, isDark),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value, bool isDark, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            child: Text(label, style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
          ),
          Expanded(
            child: Text(value, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500,
              color: valueColor ?? (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary))),
          ),
        ],
      ),
    );
  }

  Widget _buildAlertsSection(List<ProjectAlert> alerts, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.notifications_active_outlined, size: 16, color: AppColors.warning),
              const SizedBox(width: 6),
              Text('Active Alerts', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)),
            ],
          ),
          const SizedBox(height: 10),
          ...alerts.map((a) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Icon(a.icon, size: 16, color: a.color),
                const SizedBox(width: 8),
                Expanded(child: Text(a.message, style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary))),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildTeamSection(Project project, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Team', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)),
          const SizedBox(height: 10),
          ...project.team.map((m) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                  child: Text(m.name.isNotEmpty ? m.name[0] : '?', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.primary)),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(m.name, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)),
                      Text(m.role, style: TextStyle(fontSize: 11, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
                    ],
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildTimelineSection(List<ProjectTimelineEvent> events, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Activity Timeline', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)),
          const SizedBox(height: 12),
          if (events.isEmpty)
            Text('No activity yet.', style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted))
          else
            ...events.take(8).toList().asMap().entries.map((entry) {
              final e = entry.value;
              final isLast = entry.key == (events.length.clamp(0, 8) - 1);
              return IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Container(
                          width: 28, height: 28,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: e.iconColor.withValues(alpha: 0.12),
                          ),
                          child: Icon(e.icon, size: 14, color: e.iconColor),
                        ),
                        if (!isLast)
                          Expanded(
                            child: Container(
                              width: 1.5,
                              color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(e.action, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)),
                            const SizedBox(height: 2),
                            Text(e.description, style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
                            const SizedBox(height: 4),
                            Text('${_formatDateRelative(e.date)} • ${e.user}', style: TextStyle(fontSize: 10, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }

  String _formatDateRelative(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  Widget _buildLoadingSkeleton(bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          ProjectSkeleton.card(isDark: isDark, height: 100),
          const SizedBox(height: 16),
          ProjectSkeleton.kpiRow(count: 4, isDark: isDark),
          const SizedBox(height: 16),
          ProjectSkeleton.card(isDark: isDark, height: 60),
          const SizedBox(height: 16),
          ProjectSkeleton.card(isDark: isDark),
        ],
      ),
    );
  }
}
