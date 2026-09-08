import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../data/projects_repository.dart';
import '../domain/projects_enums.dart';
import '../domain/projects_models.dart';
import '../widgets/project_page_header.dart';
import '../widgets/project_kpi_card.dart';
import '../widgets/project_shared_widgets.dart';

/// Site Visits page — schedule and track site visits, inspections, supervisor check-ins,
/// and client walk-throughs with GPS coordinates and outcome reports.
class ProjectSiteVisitsPage extends StatefulWidget {
  const ProjectSiteVisitsPage({super.key});

  @override
  State<ProjectSiteVisitsPage> createState() => _ProjectSiteVisitsPageState();
}

class _ProjectSiteVisitsPageState extends State<ProjectSiteVisitsPage> {
  final _repo = ProjectsRepository();
  String? _selectedProjectId;
  String _searchQuery = '';
  SiteVisitType? _typeFilter;
  SiteVisitOutcome? _outcomeFilter;
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

  List<SiteVisit> get _filteredVisits {
    var list = _selectedProjectId != null
        ? _repo.getSiteVisitsForProject(_selectedProjectId!)
        : _repo.siteVisits;

    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      list = list.where((v) =>
          v.purpose.toLowerCase().contains(q) ||
          v.assignedEmployee.toLowerCase().contains(q) ||
          v.clientName.toLowerCase().contains(q) ||
          v.siteAddress.toLowerCase().contains(q) ||
          v.contactPerson.toLowerCase().contains(q)).toList();
    }
    if (_typeFilter != null) {
      list = list.where((v) => v.visitType == _typeFilter).toList();
    }
    if (_outcomeFilter != null) {
      list = list.where((v) => v.outcome == _outcomeFilter).toList();
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final visits = _filteredVisits;

    final totalCount = visits.length;
    final completedCount = visits.where((v) => v.outcome == SiteVisitOutcome.completed).length;
    final pendingCount = visits.where((v) => v.outcome == SiteVisitOutcome.pending).length;
    final issuesCount = visits.where((v) => v.outcome == SiteVisitOutcome.issuesFound).length;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SafeArea(
        child: Column(
          children: [
            ProjectPageHeader(
              title: 'Site Visits',
              subtitle: 'Supervision visits, measurements & client walk-throughs',
              icon: Icons.pin_drop_outlined,
              actions: [
                _buildProjectSelector(isDark),
                const SizedBox(width: 8),
                _buildTypeFilter(isDark),
                const SizedBox(width: 8),
                _buildOutcomeFilter(isDark),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: () => _showScheduleVisitDialog(context, isDark),
                  icon: const Icon(Icons.add_location_alt_outlined, size: 16),
                  label: const Text('Schedule Visit'),
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
                                    label: 'Total Visits',
                                    value: '$totalCount',
                                    icon: Icons.calendar_month_outlined,
                                    iconColor: AppColors.primary,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: ProjectKpiCard(
                                    label: 'Completed',
                                    value: '$completedCount',
                                    icon: Icons.check_circle_outline_rounded,
                                    iconColor: AppColors.success,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: ProjectKpiCard(
                                    label: 'Scheduled / Pending',
                                    value: '$pendingCount',
                                    icon: Icons.schedule_outlined,
                                    iconColor: AppColors.secondary,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: ProjectKpiCard(
                                    label: 'Issues Flagged',
                                    value: '$issuesCount',
                                    icon: Icons.warning_amber_rounded,
                                    iconColor: AppColors.error,
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
                                  hintText: 'Search visits by purpose, employee, client, or site address...',
                                  hintStyle: TextStyle(fontSize: 13, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                                  prefixIcon: Icon(Icons.search_rounded, size: 18, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Visits list
                            if (visits.isEmpty)
                              const ProjectEmptyState(
                                title: 'No site visits found',
                                description: 'Schedule a new site visit or adjust filters.',
                                icon: Icons.pin_drop_outlined,
                              )
                            else
                              ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: visits.length,
                                separatorBuilder: (_, _) => const SizedBox(height: 14),
                                itemBuilder: (context, index) {
                                  final visit = visits[index];
                                  return _buildVisitCard(visit, isDark);
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

  Widget _buildVisitCard(SiteVisit visit, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: visit.outcome == SiteVisitOutcome.issuesFound
              ? AppColors.error.withValues(alpha: 0.4)
              : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row: Type badge, Date/time, Outcome badge
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: visit.visitType.color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(visit.visitType.icon, size: 14, color: visit.visitType.color),
                    const SizedBox(width: 6),
                    Text(
                      visit.visitType.label,
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: visit.visitType.color),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Icon(Icons.calendar_today_outlined, size: 13, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
              const SizedBox(width: 4),
              Text(
                '${_formatDate(visit.date)}${visit.startTime.isNotEmpty ? " • ${visit.startTime}" : ""}',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
              ),
              const Spacer(),
              _buildOutcomeBadge(visit.outcome),
            ],
          ),
          const SizedBox(height: 12),

          // Purpose
          Text(
            visit.purpose,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
          ),
          if (visit.siteAddress.isNotEmpty) ...[
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.location_on_outlined, size: 13, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    visit.siteAddress,
                    style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 12),

          // Meta details
          Wrap(
            spacing: 16,
            runSpacing: 6,
            children: [
              if (visit.assignedEmployee.isNotEmpty)
                _buildMeta(Icons.person_pin_circle_outlined, 'Assigned: ${visit.assignedEmployee}', isDark),
              if (visit.clientName.isNotEmpty)
                _buildMeta(Icons.account_circle_outlined, 'Client: ${visit.clientName}', isDark),
              if (visit.contactPerson.isNotEmpty)
                _buildMeta(Icons.phone_outlined, '${visit.contactPerson} (${visit.contactNumber})', isDark),
              if (visit.gpsLat != null && visit.gpsLng != null)
                _buildMeta(Icons.my_location_rounded, 'GPS Verified', isDark, color: AppColors.success),
            ],
          ),

          // Notes / Issues
          if (visit.notes.isNotEmpty || (visit.issuesFound != null && visit.issuesFound!.isNotEmpty)) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: (isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle).withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (visit.notes.isNotEmpty)
                    Text('Notes: ${visit.notes}', style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
                  if (visit.issuesFound != null && visit.issuesFound!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text('Issues: ${visit.issuesFound}', style: const TextStyle(fontSize: 12, color: AppColors.error, fontWeight: FontWeight.w600)),
                  ],
                ],
              ),
            ),
          ],

          // Footer action: if pending, show "Complete Visit"
          if (visit.outcome == SiteVisitOutcome.pending) ...[
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton.icon(
                  onPressed: () => _showCompleteVisitDialog(context, visit, isDark),
                  icon: const Icon(Icons.check_circle_outline_rounded, size: 14),
                  label: const Text('Complete Visit & Record Outcome', style: TextStyle(fontSize: 12)),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: BorderSide(color: AppColors.primary.withValues(alpha: 0.5)),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildOutcomeBadge(SiteVisitOutcome outcome) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: outcome.color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        outcome.label,
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: outcome.color),
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
        child: DropdownButton<SiteVisitType?>(
          value: _typeFilter,
          isDense: true,
          hint: Text('Visit Type', style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
          icon: Icon(Icons.expand_more, size: 16, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
          dropdownColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          items: [
            DropdownMenuItem<SiteVisitType?>(
              value: null,
              child: Text('All Types', style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)),
            ),
            ...SiteVisitType.values.map((t) => DropdownMenuItem(
                  value: t,
                  child: Text(t.label, style: const TextStyle(fontSize: 12)),
                )),
          ],
          onChanged: (v) => setState(() => _typeFilter = v),
        ),
      ),
    );
  }

  Widget _buildOutcomeFilter(bool isDark) {
    return Container(
      height: 34,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<SiteVisitOutcome?>(
          value: _outcomeFilter,
          isDense: true,
          hint: Text('Outcome', style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
          icon: Icon(Icons.expand_more, size: 16, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
          dropdownColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          items: [
            DropdownMenuItem<SiteVisitOutcome?>(
              value: null,
              child: Text('All Outcomes', style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)),
            ),
            ...SiteVisitOutcome.values.map((o) => DropdownMenuItem(
                  value: o,
                  child: Text(o.label, style: const TextStyle(fontSize: 12)),
                )),
          ],
          onChanged: (v) => setState(() => _outcomeFilter = v),
        ),
      ),
    );
  }

  void _showCompleteVisitDialog(BuildContext context, SiteVisit visit, bool isDark) {
    SiteVisitOutcome outcome = SiteVisitOutcome.completed;
    final notesCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            return AlertDialog(
              backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
              title: Text('Record Visit Outcome', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)),
              content: SizedBox(
                width: 420,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<SiteVisitOutcome>(
                      initialValue: outcome,
                      decoration: const InputDecoration(labelText: 'Visit Outcome'),
                      items: [
                        SiteVisitOutcome.completed,
                        SiteVisitOutcome.issuesFound,
                        SiteVisitOutcome.followUpRequired,
                      ].map((o) => DropdownMenuItem(value: o, child: Text(o.label, style: const TextStyle(fontSize: 12)))).toList(),
                      onChanged: (v) => setDialogState(() => outcome = v ?? outcome),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: notesCtrl,
                      maxLines: 3,
                      decoration: const InputDecoration(labelText: 'Observation / Notes / Issues', hintText: 'Describe site condition and outcomes'),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
                ElevatedButton(
                  onPressed: () {
                    _repo.completeSiteVisit(visit.id, outcome, notesCtrl.text.trim());
                    Navigator.pop(ctx);
                    setState(() {});
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
                  child: const Text('Save Outcome'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showScheduleVisitDialog(BuildContext context, bool isDark) {
    SiteVisitType visitType = SiteVisitType.inspection;
    final purposeCtrl = TextEditingController();
    final employeeCtrl = TextEditingController();
    final addressCtrl = TextEditingController();
    final contactCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    final timeCtrl = TextEditingController(text: '10:30 AM');
    DateTime visitDate = DateTime.now().add(const Duration(days: 2));

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            return AlertDialog(
              backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
              title: Text('Schedule Site Visit', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)),
              content: SizedBox(
                width: 480,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      DropdownButtonFormField<SiteVisitType>(
                        initialValue: visitType,
                        decoration: const InputDecoration(labelText: 'Visit Type *'),
                        items: SiteVisitType.values.map((t) => DropdownMenuItem(value: t, child: Text(t.label, style: const TextStyle(fontSize: 12)))).toList(),
                        onChanged: (v) => setDialogState(() => visitType = v ?? visitType),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: purposeCtrl,
                        decoration: const InputDecoration(labelText: 'Visit Purpose *', hintText: 'e.g. Pre-flooring level inspection'),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: employeeCtrl,
                              decoration: const InputDecoration(labelText: 'Assigned Lead / Supervisor', hintText: 'e.g. Vikas Site Engg'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              controller: timeCtrl,
                              decoration: const InputDecoration(labelText: 'Scheduled Time', hintText: '11:00 AM'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: addressCtrl,
                        decoration: const InputDecoration(labelText: 'Site Address', hintText: 'Unit / Tower / Society address'),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: contactCtrl,
                              decoration: const InputDecoration(labelText: 'On-site Contact Person', hintText: 'Client / Caretaker'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              controller: phoneCtrl,
                              decoration: const InputDecoration(labelText: 'Phone Number', hintText: '+91 98765 43210'),
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
                    if (purposeCtrl.text.trim().isEmpty) return;
                    final newVisit = SiteVisit(
                      id: 'sv-${DateTime.now().millisecondsSinceEpoch}',
                      projectId: _selectedProjectId ?? (_repo.projects.isNotEmpty ? _repo.projects.first.id : 'proj-1'),
                      visitType: visitType,
                      date: visitDate,
                      startTime: timeCtrl.text.trim(),
                      assignedEmployee: employeeCtrl.text.trim(),
                      purpose: purposeCtrl.text.trim(),
                      siteAddress: addressCtrl.text.trim(),
                      contactPerson: contactCtrl.text.trim(),
                      contactNumber: phoneCtrl.text.trim(),
                      outcome: SiteVisitOutcome.pending,
                    );
                    _repo.addSiteVisit(newVisit);
                    Navigator.pop(ctx);
                    setState(() {});
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
                  child: const Text('Schedule Visit'),
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
