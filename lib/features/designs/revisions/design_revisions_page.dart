import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../data/designs_repository.dart';
import '../domain/design_enums.dart';
import '../domain/design_models.dart';
import '../widgets/design_header.dart';
import '../widgets/design_metric_card.dart';
import '../widgets/design_shared_widgets.dart';
import '../widgets/file_preview_modal.dart';
import '../widgets/revision_request_modal.dart';

/// Screen 3: Design Revisions Management (`/designs/revisions`).
/// Version-control tracking (v1, v2, v3...), immutable history, client change requests,
/// visual pin reviews, and designer SLA turnaround monitoring.
class DesignRevisionsPage extends StatefulWidget {
  const DesignRevisionsPage({super.key});

  @override
  State<DesignRevisionsPage> createState() => _DesignRevisionsPageState();
}

class _DesignRevisionsPageState extends State<DesignRevisionsPage> {
  final DesignsRepository _repo = DesignsRepository();

  String? _selectedProjectCode;
  RevisionStatus? _selectedStatus;
  DesignPriority? _selectedPriority;
  String _searchQuery = '';

  List<DesignRevision> get _filteredRevisions {
    return _repo.revisions.where((r) {
      if (_selectedProjectCode != null && r.projectCode != _selectedProjectCode) return false;
      if (_selectedStatus != null && r.status != _selectedStatus) return false;
      if (_selectedPriority != null && r.priority != _selectedPriority) return false;
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final match = r.deliverableTitle.toLowerCase().contains(q) ||
            r.reason.toLowerCase().contains(q) ||
            r.assignedDesigner.toLowerCase().contains(q) ||
            r.requestedBy.toLowerCase().contains(q) ||
            r.specificArea.toLowerCase().contains(q);
        if (!match) return false;
      }
      return true;
    }).toList();
  }

  void _handleCreateRevision() {
    final deliverables = _repo.deliverables;
    if (deliverables.isEmpty) return;

    // Pick first or let user choose
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text('Select Deliverable to Request Revision', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700)),
          content: SizedBox(
            width: 450,
            height: 300,
            child: ListView.separated(
              itemCount: deliverables.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final d = deliverables[index];
                return ListTile(
                  title: Text(d.title, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600)),
                  subtitle: Text('${d.projectCode} • ${d.roomArea} • ${d.currentVersion}', style: const TextStyle(fontSize: 11)),
                  trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
                  onTap: () {
                    Navigator.pop(ctx);
                    RevisionRequestModal.show(
                      context: context,
                      deliverable: d,
                      onSubmitRevision: (rev) {
                        setState(() {
                          _repo.requestRevision(rev);
                        });
                      },
                    );
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ],
        );
      },
    );
  }

  void _handleUpdateStatus(DesignRevision rev, RevisionStatus nextStatus) {
    setState(() {
      _repo.updateRevisionStatus(rev.id, nextStatus);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Revision #${rev.revisionNumber} moved to "${nextStatus.label}".'),
        backgroundColor: nextStatus == RevisionStatus.resolved ? AppColors.success : AppColors.primary,
      ),
    );
  }

  void _handleInspectDeliverable(String deliverableId) {
    final d = _repo.deliverables.firstWhere((item) => item.id == deliverableId, orElse: () => _repo.deliverables.first);
    FilePreviewModal.show(
      context: context,
      deliverable: d,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final revisions = _filteredRevisions;
    final projects = _repo.projects;

    // Metrics
    final totalRevs = _repo.revisions.length;
    final requestedCount = _repo.revisions.where((r) => r.status == RevisionStatus.requested).length;
    final inProgressCount = _repo.revisions.where((r) => r.status == RevisionStatus.inProgress).length;
    final resolvedCount = _repo.revisions.where((r) => r.status == RevisionStatus.resolved || r.status == RevisionStatus.closed).length;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Page Header
            DesignHeader(
              title: 'Design Revision Control & Change Requests',
              subtitle: 'Multi-version revision history (v1 to vN), visual pin feedback, and designer turnaround SLAs',
              primaryActionLabel: 'New Revision Request',
              primaryActionIcon: Icons.published_with_changes_rounded,
              onPrimaryAction: _handleCreateRevision,
              searchHint: 'Search revision reason, deliverable, designer, area...',
              onSearchChanged: (val) => setState(() => _searchQuery = val),
            ),
            const SizedBox(height: 20),

            // Metrics Cards Row
            Row(
              children: [
                Expanded(
                  child: DesignMetricCard(
                    title: 'Total Revisions Logged',
                    value: '$totalRevs',
                    subtitle: 'Across all active projects',
                    icon: Icons.history_rounded,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: DesignMetricCard(
                    title: 'Awaiting Action',
                    value: '$requestedCount',
                    subtitle: 'Requires designer attention',
                    icon: Icons.notification_important_rounded,
                    color: AppColors.error,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: DesignMetricCard(
                    title: 'In Progress',
                    value: '$inProgressCount',
                    subtitle: 'Active drafting iterations',
                    icon: Icons.pending_actions_rounded,
                    color: AppColors.warning,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: DesignMetricCard(
                    title: 'Resolved & Closed',
                    value: '$resolvedCount',
                    subtitle: 'Approved into next version',
                    icon: Icons.task_alt_rounded,
                    color: AppColors.success,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Filters Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCard : AppColors.lightCard,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
              ),
              child: Wrap(
                spacing: 16,
                runSpacing: 10,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  // Project Filter
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.apartment, size: 16, color: AppColors.primary),
                      const SizedBox(width: 6),
                      DropdownButton<String?>(
                        value: _selectedProjectCode,
                        hint: const Text('All Projects', style: TextStyle(fontSize: 12)),
                        underline: const SizedBox(),
                        items: [
                          const DropdownMenuItem(value: null, child: Text('All Projects', style: TextStyle(fontSize: 12))),
                          ...projects.map((p) => DropdownMenuItem(value: p.code, child: Text(p.code, style: const TextStyle(fontSize: 12)))),
                        ],
                        onChanged: (val) => setState(() => _selectedProjectCode = val),
                      ),
                    ],
                  ),

                  // Status Filter
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.filter_list_rounded, size: 16, color: Colors.grey),
                      const SizedBox(width: 6),
                      DropdownButton<RevisionStatus?>(
                        value: _selectedStatus,
                        hint: const Text('All Statuses', style: TextStyle(fontSize: 12)),
                        underline: const SizedBox(),
                        items: [
                          const DropdownMenuItem(value: null, child: Text('All Statuses', style: TextStyle(fontSize: 12))),
                          ...RevisionStatus.values.map((s) => DropdownMenuItem(value: s, child: Text(s.label, style: const TextStyle(fontSize: 12)))),
                        ],
                        onChanged: (val) => setState(() => _selectedStatus = val),
                      ),
                    ],
                  ),

                  // Priority Filter
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.flag_outlined, size: 16, color: Colors.grey),
                      const SizedBox(width: 6),
                      DropdownButton<DesignPriority?>(
                        value: _selectedPriority,
                        hint: const Text('All Priorities', style: TextStyle(fontSize: 12)),
                        underline: const SizedBox(),
                        items: [
                          const DropdownMenuItem(value: null, child: Text('All Priorities', style: TextStyle(fontSize: 12))),
                          ...DesignPriority.values.map((p) => DropdownMenuItem(value: p, child: Text(p.label, style: const TextStyle(fontSize: 12)))),
                        ],
                        onChanged: (val) => setState(() => _selectedPriority = val),
                      ),
                    ],
                  ),

                  if (_selectedProjectCode != null || _selectedStatus != null || _selectedPriority != null || _searchQuery.isNotEmpty)
                    TextButton.icon(
                      onPressed: () {
                        setState(() {
                          _selectedProjectCode = null;
                          _selectedStatus = null;
                          _selectedPriority = null;
                          _searchQuery = '';
                        });
                      },
                      icon: const Icon(Icons.clear_all_rounded, size: 16),
                      label: const Text('Clear Filters', style: TextStyle(fontSize: 12)),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Revisions Stream / Table
            if (revisions.isEmpty)
              const DesignEmptyState(
                icon: Icons.done_all_rounded,
                title: 'No Revision Requests Found',
                message: 'All drawings and renders are currently clear with zero pending change requests.',
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: revisions.length,
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final rev = revisions[index];
                  return _buildRevisionCard(rev, isDark);
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildRevisionCard(DesignRevision rev, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: rev.priority == DesignPriority.urgent
              ? AppColors.error.withValues(alpha: 0.5)
              : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
          width: rev.priority == DesignPriority.urgent ? 1.5 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row: Revision Tag, Status, Priority, Project
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'Rev #${rev.revisionNumber} (${rev.currentVersion})',
                  style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.primary),
                ),
              ),
              const SizedBox(width: 8),
              DesignRevisionBadge(status: rev.status, fontSize: 11),
              const SizedBox(width: 8),
              DesignPriorityBadge(priority: rev.priority, fontSize: 11),
              const Spacer(),
              Text(
                '${rev.projectCode} • Due: ${rev.dueDate.day}/${rev.dueDate.month}/${rev.dueDate.year}',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: rev.dueDate.isBefore(DateTime.now()) && rev.status != RevisionStatus.resolved
                      ? AppColors.error
                      : (isDark ? AppColors.darkMutedText : AppColors.lightMutedText),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Title & Reason
          Text(
            rev.reason,
            style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Text(
            rev.description,
            style: GoogleFonts.inter(fontSize: 13, color: isDark ? AppColors.darkMutedText : AppColors.lightMutedText),
          ),
          const SizedBox(height: 12),

          // Context details & Actions
          Row(
            children: [
              Icon(Icons.person_outline_rounded, size: 14, color: Colors.grey),
              const SizedBox(width: 4),
              Text(
                'Assigned: ${rev.assignedDesigner}',
                style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500),
              ),
              const SizedBox(width: 14),
              Icon(Icons.place_outlined, size: 14, color: Colors.grey),
              const SizedBox(width: 4),
              Text(
                'Zone: ${rev.specificArea}',
                style: GoogleFonts.inter(fontSize: 12),
              ),
              if (rev.annotations.isNotEmpty) ...[
                const SizedBox(width: 14),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.push_pin, size: 12, color: AppColors.warning),
                      const SizedBox(width: 4),
                      Text(
                        '${rev.annotations.length} Visual Pins',
                        style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.warning),
                      ),
                    ],
                  ),
                ),
              ],
              const Spacer(),

              // Status Transitions
              if (rev.status == RevisionStatus.requested)
                ElevatedButton.icon(
                  onPressed: () => _handleUpdateStatus(rev, RevisionStatus.inProgress),
                  icon: const Icon(Icons.play_arrow_rounded, size: 16),
                  label: const Text('Start Work'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.warning,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                )
              else if (rev.status == RevisionStatus.inProgress)
                ElevatedButton.icon(
                  onPressed: () => _handleUpdateStatus(rev, RevisionStatus.resolved),
                  icon: const Icon(Icons.check_rounded, size: 16),
                  label: const Text('Mark Resolved'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.success,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
              const SizedBox(width: 8),
              OutlinedButton.icon(
                onPressed: () => _handleInspectDeliverable(rev.deliverableId),
                icon: const Icon(Icons.visibility_outlined, size: 16),
                label: const Text('Inspect Drawing'),
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
