import 'package:client/features/projects/widgets/project_kpi_card.dart';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../data/projects_repository.dart';
import '../domain/projects_enums.dart';
import '../domain/projects_models.dart';
import '../widgets/project_page_header.dart';
import '../widgets/project_shared_widgets.dart';

/// All Projects — Central project directory with Table/Cards view,
/// search, filters, and project detail navigation.
class AllProjectsPage extends StatefulWidget {
  const AllProjectsPage({super.key});

  @override
  State<AllProjectsPage> createState() => _AllProjectsPageState();
}

class _AllProjectsPageState extends State<AllProjectsPage> {
  final _repo = ProjectsRepository();
  String _searchQuery = '';
  ProjectStatus? _statusFilter;
  ProjectHealth? _healthFilter;
  ProjectType? _typeFilter;
  ProjectViewMode _viewMode = ProjectViewMode.table;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) setState(() => _isLoading = false);
    });
  }

  List<Project> get _filteredProjects {
    return _repo.projects.where((p) {
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final match = p.name.toLowerCase().contains(q) ||
            p.code.toLowerCase().contains(q) ||
            p.clientName.toLowerCase().contains(q) ||
            p.siteCity.toLowerCase().contains(q);
        if (!match) return false;
      }
      if (_statusFilter != null && p.status != _statusFilter) return false;
      if (_healthFilter != null && p.health != _healthFilter) return false;
      if (_typeFilter != null && p.type != _typeFilter) return false;
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final kpis = _repo.getProjectKpis();

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SafeArea(
        child: Column(
          children: [
            ProjectPageHeader(
              title: 'All Projects',
              subtitle: '${_repo.projects.length} total projects',
              icon: Icons.folder_special_outlined,
              searchHint: 'Search projects, clients, codes...',
              onSearchChanged: (v) => setState(() => _searchQuery = v),
              onAddPressed: () {},
              addLabel: 'New Project',
              actions: [
                _buildViewToggle(isDark),
                const SizedBox(width: 8),
              ],
              filters: [
                _buildDropdownFilter<ProjectStatus>(
                  'Status', _statusFilter, ProjectStatus.values,
                  (v) => setState(() => _statusFilter = v),
                  (e) => e.label, isDark,
                ),
                _buildDropdownFilter<ProjectHealth>(
                  'Health', _healthFilter, ProjectHealth.values,
                  (v) => setState(() => _healthFilter = v),
                  (e) => e.label, isDark,
                ),
                _buildDropdownFilter<ProjectType>(
                  'Type', _typeFilter, ProjectType.values,
                  (v) => setState(() => _typeFilter = v),
                  (e) => e.label, isDark,
                ),
                if (_statusFilter != null || _healthFilter != null || _typeFilter != null)
                  TextButton.icon(
                    onPressed: () => setState(() {
                      _statusFilter = null;
                      _healthFilter = null;
                      _typeFilter = null;
                    }),
                    icon: const Icon(Icons.clear_all_rounded, size: 16),
                    label: const Text('Clear Filters', style: TextStyle(fontSize: 12)),
                  ),
              ],
            ),
            // KPI Summary Row
            if (!_isLoading)
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final isCompact = constraints.maxWidth < 768;
                    if (isCompact) {
                      return Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _buildKpiCards(kpis).map((w) => SizedBox(width: (constraints.maxWidth - 8) / 2, child: w)).toList(),
                      );
                    }
                    return Row(
                      children: _buildKpiCards(kpis)
                          .map((w) => Expanded(child: Padding(padding: const EdgeInsets.only(right: 12), child: w)))
                          .toList(),
                    );
                  },
                ),
              ),
            // Project List/Grid
            Expanded(
              child: _isLoading
                  ? _buildLoadingSkeleton(isDark)
                  : _filteredProjects.isEmpty
                      ? ProjectEmptyState(
                          title: 'No projects found',
                          description: _searchQuery.isNotEmpty
                              ? 'Try adjusting your search or filters.'
                              : 'Create your first project to get started.',
                          buttonLabel: 'New Project',
                          onButtonPressed: () {},
                        )
                      : _viewMode == ProjectViewMode.table
                          ? _buildTableView(isDark)
                          : _buildCardsView(isDark),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildKpiCards(ProjectKpiSummary kpis) {
    return [
      ProjectKpiCard(
        label: 'Total Projects', value: '${kpis.totalProjects}',
        icon: Icons.folder_outlined, iconColor: AppColors.primary,
      ),
      ProjectKpiCard(
        label: 'Ongoing', value: '${kpis.ongoingProjects}',
        icon: Icons.engineering_outlined, iconColor: const Color(0xFF3B82F6),
      ),
      ProjectKpiCard(
        label: 'On-Time', value: '${kpis.onTimeProjects}',
        icon: Icons.check_circle_outlined, iconColor: AppColors.success,
      ),
      ProjectKpiCard(
        label: 'Delayed', value: '${kpis.delayedProjects}',
        icon: Icons.warning_amber_outlined, iconColor: AppColors.error,
        trend: kpis.delayedProjects > 0 ? '${kpis.delayedProjects}' : null,
        trendPositive: false,
      ),
      ProjectKpiCard(
        label: 'Outstanding', value: '₹${kpis.outstandingAmountLakhs.toStringAsFixed(1)}L',
        icon: Icons.account_balance_wallet_outlined, iconColor: const Color(0xFFF59E0B),
      ),
    ];
  }

  Widget _buildTableView(bool isDark) {
    return SingleChildScrollView(
      key: const PageStorageKey('all_projects_table'),
      padding: const EdgeInsets.all(24),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
        ),
        child: Column(
          children: [
            // Table Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              ),
              child: Row(
                children: [
                  _tableHeader('Project', flex: 3, isDark: isDark),
                  _tableHeader('Client', flex: 2, isDark: isDark),
                  _tableHeader('Status', flex: 2, isDark: isDark),
                  _tableHeader('Health', flex: 1, isDark: isDark),
                  _tableHeader('Progress', flex: 2, isDark: isDark),
                  _tableHeader('Contract', flex: 1, isDark: isDark),
                  _tableHeader('Outstanding', flex: 1, isDark: isDark),
                ],
              ),
            ),
            // Table Rows
            ..._filteredProjects.asMap().entries.map((entry) {
              final p = entry.value;
              final isLast = entry.key == _filteredProjects.length - 1;
              return _buildProjectRow(p, isDark, isLast);
            }),
          ],
        ),
      ),
    );
  }

  Widget _tableHeader(String label, {required int flex, required bool isDark}) {
    return Expanded(
      flex: flex,
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildProjectRow(Project p, bool isDark, bool isLast) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {},
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            border: isLast
                ? null
                : Border(
                    bottom: BorderSide(
                      color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                      width: 0.5,
                    ),
                  ),
          ),
          child: Row(
            children: [
              // Project
              Expanded(
                flex: 3,
                child: Row(
                  children: [
                    Container(
                      width: 36, height: 36,
                      decoration: BoxDecoration(
                        color: p.type.color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(p.type.icon, size: 18, color: p.type.color),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            p.name,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            p.code,
                            style: TextStyle(
                              fontSize: 11,
                              color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Client
              Expanded(
                flex: 2,
                child: Text(
                  p.clientName,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              // Status
              Expanded(flex: 2, child: ProjectStatusBadge(status: p.status, compact: true)),
              // Health
              Expanded(flex: 2, child: ProjectHealthBadge(health: p.health, compact: true)),
              // Progress
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: p.progressPercent / 100,
                              minHeight: 6,
                              backgroundColor: isDark ? AppColors.darkSurfaceElevated : AppColors.lightSurfaceSubtle,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                p.progressPercent >= 100
                                    ? AppColors.success
                                    : p.isOverdue
                                        ? AppColors.error
                                        : AppColors.primary,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${p.progressPercent.toStringAsFixed(0)}%',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Contract
              Expanded(
                flex: 1,
                child: Text(
                  p.formattedContract,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                  ),
                ),
              ),
              // Outstanding
              Expanded(
                flex: 1,
                child: Text(
                  p.formattedOutstanding,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: p.totalOutstandingLakhs > 0 ? AppColors.error : AppColors.success,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardsView(bool isDark) {
    return SingleChildScrollView(
      key: const PageStorageKey('all_projects_cards'),
      padding: const EdgeInsets.all(24),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final crossAxisCount = constraints.maxWidth > 1024 ? 3 : (constraints.maxWidth > 768 ? 2 : 1);
          return Wrap(
            spacing: 16,
            runSpacing: 16,
            children: _filteredProjects.map((p) => SizedBox(
              width: (constraints.maxWidth - (crossAxisCount - 1) * 16) / crossAxisCount,
              child: _buildProjectCard(p, isDark),
            )).toList(),
          );
        },
      ),
    );
  }

  Widget _buildProjectCard(Project p, bool isDark) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
            boxShadow: [
              BoxShadow(
                color: (isDark ? Colors.black : Colors.grey).withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: p.type.color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(p.type.icon, size: 18, color: p.type.color),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(p.name, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700,
                          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary), overflow: TextOverflow.ellipsis),
                        Text(p.code, style: TextStyle(fontSize: 11, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
                      ],
                    ),
                  ),
                  ProjectHealthBadge(health: p.health, compact: true),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.person_outlined, size: 14, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                  const SizedBox(width: 4),
                  Text(p.clientName, style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Icon(Icons.location_on_outlined, size: 14, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                  const SizedBox(width: 4),
                  Expanded(child: Text('${p.siteCity} — ${p.totalAreaSqFt.toStringAsFixed(0)} sq.ft.',
                    style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary), overflow: TextOverflow.ellipsis)),
                ],
              ),
              const SizedBox(height: 14),
              // Progress Bar
              Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: p.progressPercent / 100, minHeight: 6,
                        backgroundColor: isDark ? AppColors.darkSurfaceElevated : AppColors.lightSurfaceSubtle,
                        valueColor: AlwaysStoppedAnimation<Color>(p.progressPercent >= 100 ? AppColors.success : AppColors.primary),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text('${p.progressPercent.toStringAsFixed(0)}%',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)),
                ],
              ),
              const SizedBox(height: 12),
              // Footer
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ProjectStatusBadge(status: p.status, compact: true),
                  Row(
                    children: [
                      Text(p.formattedContract, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)),
                      if (p.totalOutstandingLakhs > 0) ...[
                        const SizedBox(width: 8),
                        Text(p.formattedOutstanding, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.error)),
                      ],
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildViewToggle(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _viewToggleButton(ProjectViewMode.table, isDark),
          _viewToggleButton(ProjectViewMode.cards, isDark),
        ],
      ),
    );
  }

  Widget _viewToggleButton(ProjectViewMode mode, bool isDark) {
    final isActive = _viewMode == mode;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => setState(() => _viewMode = mode),
        borderRadius: BorderRadius.circular(6),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary.withValues(alpha: 0.1) : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(
            mode.icon,
            size: 16,
            color: isActive ? AppColors.primary : (isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownFilter<T>(
    String label,
    T? current,
    List<T> values,
    ValueChanged<T?> onChanged,
    String Function(T) labelFn,
    bool isDark,
  ) {
    return Container(
      height: 32,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T?>(
          value: current,
          hint: Text(label, style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
          icon: Icon(Icons.expand_more, size: 16, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
          isDense: true,
          style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
          dropdownColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          items: [
            DropdownMenuItem<T?>(value: null, child: Text('All $label', style: const TextStyle(fontSize: 12))),
            ...values.map((v) => DropdownMenuItem<T?>(value: v, child: Text(labelFn(v), style: const TextStyle(fontSize: 12)))),
          ],
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildLoadingSkeleton(bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          ProjectSkeleton.kpiRow(count: 5, isDark: isDark),
          const SizedBox(height: 16),
          ...List.generate(5, (_) => ProjectSkeleton.listTile(isDark: isDark)),
        ],
      ),
    );
  }
}
