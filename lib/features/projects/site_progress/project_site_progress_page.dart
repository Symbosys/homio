import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../data/projects_repository.dart';
import '../domain/projects_enums.dart';
import '../domain/projects_models.dart';
import '../widgets/project_page_header.dart';
import '../widgets/project_kpi_card.dart';
import '../widgets/project_shared_widgets.dart';

/// Site Progress page — field operations screen tracking daily site progress,
/// work logs, before/after photos, and supervisor verifications.
class ProjectSiteProgressPage extends StatefulWidget {
  const ProjectSiteProgressPage({super.key});

  @override
  State<ProjectSiteProgressPage> createState() => _ProjectSiteProgressPageState();
}

class _ProjectSiteProgressPageState extends State<ProjectSiteProgressPage> {
  final _repo = ProjectsRepository();
  String? _selectedProjectId;
  String _searchQuery = '';
  FileVisibility? _visibilityFilter;
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

  List<SiteProgressEntry> get _filteredEntries {
    var list = _selectedProjectId != null
        ? _repo.getSiteProgressForProject(_selectedProjectId!)
        : _repo.siteProgressEntries;

    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      list = list.where((e) =>
          e.description.toLowerCase().contains(q) ||
          e.areaRoom.toLowerCase().contains(q) ||
          e.submittedBy.toLowerCase().contains(q) ||
          e.workCompleted.toLowerCase().contains(q) ||
          e.workStage.toLowerCase().contains(q)).toList();
    }
    if (_visibilityFilter != null) {
      list = list.where((e) => e.visibility == _visibilityFilter).toList();
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final entries = _filteredEntries;

    final totalCount = entries.length;
    final verifiedCount = entries.where((e) => e.approvalStatus == SiteProgressApprovalStatus.supervisorVerified).length;
    final clientVisibleCount = entries.where((e) => e.visibility == FileVisibility.clientVisible).length;
    final pendingCount = entries.where((e) => e.approvalStatus == SiteProgressApprovalStatus.submitted).length;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SafeArea(
        child: Column(
          children: [
            ProjectPageHeader(
              title: 'Site Progress',
              subtitle: 'Daily site logs, photo evidence & supervisor verification',
              icon: Icons.camera_alt_outlined,
              actions: [
                _buildProjectSelector(isDark),
                const SizedBox(width: 8),
                _buildVisibilityFilter(isDark),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: () => _showAddProgressDialog(context, isDark),
                  icon: const Icon(Icons.add_a_photo_outlined, size: 16),
                  label: const Text('Post Update'),
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
                                    label: 'Total Updates',
                                    value: '$totalCount',
                                    icon: Icons.history_rounded,
                                    iconColor: AppColors.primary,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: ProjectKpiCard(
                                    label: 'Verified by Lead',
                                    value: '$verifiedCount',
                                    icon: Icons.verified_outlined,
                                    iconColor: AppColors.success,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: ProjectKpiCard(
                                    label: 'Client Visible',
                                    value: '$clientVisibleCount',
                                    icon: Icons.visibility_outlined,
                                    iconColor: AppColors.secondary,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: ProjectKpiCard(
                                    label: 'Pending Review',
                                    value: '$pendingCount',
                                    icon: Icons.pending_outlined,
                                    iconColor: AppColors.warning,
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
                                  hintText: 'Search updates by description, room, submitter or stage...',
                                  hintStyle: TextStyle(fontSize: 13, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                                  prefixIcon: Icon(Icons.search_rounded, size: 18, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Timeline Feed
                            if (entries.isEmpty)
                              const ProjectEmptyState(
                                title: 'No site progress logs',
                                description: 'Post an update with photos or adjust filters to view progress logs.',
                                icon: Icons.camera_alt_outlined,
                              )
                            else
                              ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: entries.length,
                                separatorBuilder: (_, _) => const SizedBox(height: 16),
                                itemBuilder: (context, index) {
                                  final entry = entries[index];
                                  return _buildProgressCard(entry, isDark);
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

  Widget _buildProgressCard(SiteProgressEntry entry, bool isDark) {
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
          // Header: Submitter, Date, Badges
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.primary.withValues(alpha: 0.15),
                child: Text(
                  entry.submittedBy.isNotEmpty ? entry.submittedBy[0].toUpperCase() : 'S',
                  style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.primary, fontSize: 13),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.submittedBy.isEmpty ? 'Site Supervisor' : entry.submittedBy,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                      ),
                    ),
                    Text(
                      '${_formatDate(entry.progressDate)}${entry.progressTime.isNotEmpty ? " • ${entry.progressTime}" : ""}',
                      style: TextStyle(fontSize: 11, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                    ),
                  ],
                ),
              ),
              // Area & Stage badge
              if (entry.areaRoom.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  margin: const EdgeInsets.only(right: 6),
                  decoration: BoxDecoration(
                    color: (isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(entry.areaRoom, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
                ),
              // Visibility badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                margin: const EdgeInsets.only(right: 6),
                decoration: BoxDecoration(
                  color: entry.visibility == FileVisibility.clientVisible
                      ? AppColors.secondary.withValues(alpha: 0.12)
                      : (isDark ? AppColors.darkSurfaceElevated : AppColors.lightSurfaceSubtle),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      entry.visibility == FileVisibility.clientVisible ? Icons.visibility_outlined : Icons.lock_outline_rounded,
                      size: 11,
                      color: entry.visibility == FileVisibility.clientVisible ? AppColors.secondary : (isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      entry.visibility == FileVisibility.clientVisible ? 'Client' : 'Internal',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: entry.visibility == FileVisibility.clientVisible ? AppColors.secondary : (isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                      ),
                    ),
                  ],
                ),
              ),
              // Approval badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: entry.approvalStatus.color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  entry.approvalStatus.label,
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: entry.approvalStatus.color),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Description
          if (entry.description.isNotEmpty)
            Text(
              entry.description,
              style: TextStyle(fontSize: 13, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
            ),
          const SizedBox(height: 10),

          // Progress bar
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: (entry.progressPercent / 100).clamp(0.0, 1.0),
                    minHeight: 6,
                    backgroundColor: isDark ? AppColors.darkSurfaceElevated : AppColors.lightSurfaceSubtle,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                '${entry.progressPercent.toStringAsFixed(0)}% Progress',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary),
              ),
            ],
          ),

          // Work details grid
          if (entry.workCompleted.isNotEmpty || entry.workPending.isNotEmpty || entry.issues.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: (isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle).withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (entry.workCompleted.isNotEmpty) ...[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.check_circle_outline_rounded, size: 14, color: AppColors.success),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            'Completed: ${entry.workCompleted}',
                            style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                          ),
                        ),
                      ],
                    ),
                  ],
                  if (entry.workPending.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.hourglass_top_rounded, size: 14, color: AppColors.secondary),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            'Pending: ${entry.workPending}',
                            style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                          ),
                        ),
                      ],
                    ),
                  ],
                  if (entry.issues.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.error_outline_rounded, size: 14, color: AppColors.error),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            'Issues: ${entry.issues}',
                            style: TextStyle(fontSize: 12, color: AppColors.error),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],

          // Media gallery / indicators
          if (entry.images.isNotEmpty || entry.videos.isNotEmpty) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ...entry.images.map((img) => Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkSurfaceElevated : AppColors.lightSurfaceSubtle,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.image_outlined, size: 22, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                          const SizedBox(height: 2),
                          Text('Photo', style: TextStyle(fontSize: 9, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
                        ],
                      ),
                    )),
                ...entry.videos.map((vid) => Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkSurfaceElevated : AppColors.lightSurfaceSubtle,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.play_circle_outline_rounded, size: 24, color: AppColors.primary),
                          const SizedBox(height: 2),
                          Text('Video', style: TextStyle(fontSize: 9, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
                        ],
                      ),
                    )),
              ],
            ),
          ],

          // Action bar (Verify / Toggle Visibility)
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (entry.approvalStatus != SiteProgressApprovalStatus.supervisorVerified)
                TextButton.icon(
                  onPressed: () {
                    final updated = entry.copyWith(approvalStatus: SiteProgressApprovalStatus.supervisorVerified);
                    _repo.addSiteProgress(updated);
                    setState(() {});
                  },
                  icon: const Icon(Icons.verified_rounded, size: 14, color: AppColors.success),
                  label: const Text('Verify Entry', style: TextStyle(fontSize: 12, color: AppColors.success)),
                ),
              TextButton.icon(
                onPressed: () {
                  final newVis = entry.visibility == FileVisibility.clientVisible ? FileVisibility.internal : FileVisibility.clientVisible;
                  final updated = entry.copyWith(visibility: newVis);
                  _repo.addSiteProgress(updated);
                  setState(() {});
                },
                icon: Icon(
                  entry.visibility == FileVisibility.clientVisible ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                  size: 14,
                ),
                label: Text(
                  entry.visibility == FileVisibility.clientVisible ? 'Make Internal' : 'Share with Client',
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
        ],
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

  Widget _buildVisibilityFilter(bool isDark) {
    return Container(
      height: 34,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<FileVisibility?>(
          value: _visibilityFilter,
          isDense: true,
          hint: Text('Visibility', style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
          icon: Icon(Icons.expand_more, size: 16, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
          dropdownColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          items: [
            DropdownMenuItem<FileVisibility?>(
              value: null,
              child: Text('All Visibility', style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)),
            ),
            ...FileVisibility.values.map((v) => DropdownMenuItem(
                  value: v,
                  child: Text(v.label, style: const TextStyle(fontSize: 12)),
                )),
          ],
          onChanged: (v) => setState(() => _visibilityFilter = v),
        ),
      ),
    );
  }

  void _showAddProgressDialog(BuildContext context, bool isDark) {
    final roomCtrl = TextEditingController();
    final stageCtrl = TextEditingController(text: 'Execution');
    final descCtrl = TextEditingController();
    final completedCtrl = TextEditingController();
    final pendingCtrl = TextEditingController();
    final issuesCtrl = TextEditingController();
    double progressPercent = 25;
    FileVisibility visibility = FileVisibility.internal;

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            return AlertDialog(
              backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
              title: Text('Post Site Progress Log', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)),
              content: SizedBox(
                width: 480,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: roomCtrl,
                              decoration: const InputDecoration(labelText: 'Room / Area *', hintText: 'e.g. Master Bedroom'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              controller: stageCtrl,
                              decoration: const InputDecoration(labelText: 'Work Stage', hintText: 'e.g. Carpentry / Flooring'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: descCtrl,
                        maxLines: 2,
                        decoration: const InputDecoration(labelText: 'General Progress Description *', hintText: 'Summary of today\'s work'),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: completedCtrl,
                        decoration: const InputDecoration(labelText: 'Work Completed Today', hintText: 'e.g. Frame assembly finished, 8 ply sheets installed'),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: pendingCtrl,
                        decoration: const InputDecoration(labelText: 'Work Pending / Next Steps', hintText: 'e.g. Edge banding and hinge installation'),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: issuesCtrl,
                        decoration: const InputDecoration(labelText: 'Issues / Site Blockers', hintText: 'Leave empty if none'),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Text('Progress: ${progressPercent.toStringAsFixed(0)}%', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                          Expanded(
                            child: Slider(
                              value: progressPercent,
                              min: 0,
                              max: 100,
                              divisions: 20,
                              activeColor: AppColors.primary,
                              onChanged: (val) => setDialogState(() => progressPercent = val),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Text('Client Visibility:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                          const SizedBox(width: 12),
                          ChoiceChip(
                            label: const Text('Internal Only', style: TextStyle(fontSize: 11)),
                            selected: visibility == FileVisibility.internal,
                            onSelected: (s) => setDialogState(() => visibility = FileVisibility.internal),
                          ),
                          const SizedBox(width: 8),
                          ChoiceChip(
                            label: const Text('Client Visible', style: TextStyle(fontSize: 11)),
                            selected: visibility == FileVisibility.clientVisible,
                            onSelected: (s) => setDialogState(() => visibility = FileVisibility.clientVisible),
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
                    if (descCtrl.text.trim().isEmpty) return;
                    final now = DateTime.now();
                    final newEntry = SiteProgressEntry(
                      id: 'sp-${now.millisecondsSinceEpoch}',
                      projectId: _selectedProjectId ?? (_repo.projects.isNotEmpty ? _repo.projects.first.id : 'proj-1'),
                      areaRoom: roomCtrl.text.trim(),
                      progressDate: now,
                      progressTime: '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}',
                      submittedBy: 'Current User',
                      workStage: stageCtrl.text.trim(),
                      progressPercent: progressPercent,
                      description: descCtrl.text.trim(),
                      workCompleted: completedCtrl.text.trim(),
                      workPending: pendingCtrl.text.trim(),
                      issues: issuesCtrl.text.trim(),
                      visibility: visibility,
                      approvalStatus: SiteProgressApprovalStatus.submitted,
                      images: const ['photo1.jpg', 'photo2.jpg'],
                    );
                    _repo.addSiteProgress(newEntry);
                    Navigator.pop(ctx);
                    setState(() {});
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
                  child: const Text('Post Log'),
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
          ...List.generate(3, (_) => ProjectSkeleton.card(isDark: isDark, height: 160)),
        ],
      ),
    );
  }
}
