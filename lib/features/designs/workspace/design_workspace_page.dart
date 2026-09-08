import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../data/designs_repository.dart';
import '../domain/design_enums.dart';
import '../domain/design_models.dart';
import '../widgets/deliverable_card.dart';
import '../widgets/design_header.dart';
import '../widgets/design_metric_card.dart';
import '../widgets/design_shared_widgets.dart';
import '../widgets/file_preview_modal.dart';
import '../widgets/revision_request_modal.dart';
import '../widgets/submit_to_client_modal.dart';
import '../widgets/upload_deliverable_modal.dart';
import '../widgets/version_history_modal.dart';

/// Central Design Workspace (PRD Section 15.1, Sidebar 6.1).
/// Provides project design overview, deliverable grid/table, designer workload distribution,
/// and live activity auditing.
class DesignWorkspacePage extends StatefulWidget {
  const DesignWorkspacePage({super.key});

  @override
  State<DesignWorkspacePage> createState() => _DesignWorkspacePageState();
}

class _DesignWorkspacePageState extends State<DesignWorkspacePage> {
  final DesignsRepository _repo = DesignsRepository();

  String? _selectedProjectCode;
  DesignCategory? _selectedCategory;
  DesignReviewStatus? _selectedStatus;
  String _searchQuery = '';
  bool _isGridView = true;

  List<DesignDeliverable> get _filteredDeliverables {
    return _repo.deliverables.where((d) {
      if (_selectedProjectCode != null && d.projectCode != _selectedProjectCode) return false;
      if (_selectedCategory != null && d.category != _selectedCategory) return false;
      if (_selectedStatus != null && d.status != _selectedStatus) return false;
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final match = d.title.toLowerCase().contains(q) ||
            d.roomArea.toLowerCase().contains(q) ||
            d.designerName.toLowerCase().contains(q) ||
            d.projectCode.toLowerCase().contains(q);
        if (!match) return false;
      }
      return true;
    }).toList();
  }

  void _handleUpload() {
    UploadDeliverableModal.show(
      context: context,
      initialProjectCode: _selectedProjectCode,
      onUpload: (newDeliverable) {
        setState(() {
          _repo.uploadDeliverable(newDeliverable);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Deliverable "${newDeliverable.title}" submitted successfully!'),
            backgroundColor: AppColors.success,
          ),
        );
      },
    );
  }

  void _handlePreview(DesignDeliverable d) {
    FilePreviewModal.show(
      context: context,
      deliverable: d,
      onUpdate: (updated) {
        setState(() {
          final idx = _repo.deliverables.indexWhere((item) => item.id == updated.id);
          if (idx != -1) {
            // Updated in repo
          }
        });
      },
    );
  }

  void _handleRequestRevision(DesignDeliverable d) {
    RevisionRequestModal.show(
      context: context,
      deliverable: d,
      onSubmitRevision: (rev) {
        setState(() {
          _repo.requestRevision(rev);
        });
      },
    );
  }

  void _handleHistory(DesignDeliverable d) {
    VersionHistoryModal.show(
      context: context,
      deliverable: d,
    );
  }

  void _handleSubmitBatchToClient() {
    SubmitToClientModal.show(
      context: context,
      availableDeliverables: _repo.deliverables,
      initialProjectCode: _selectedProjectCode,
      onSubmit: (ids, clientName, deadline, allowDownload) {
        setState(() {
          _repo.submitToClient(ids, clientName, deadline, allowDownload);
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final kpis = _repo.getWorkspaceKpis();
    final deliverables = _filteredDeliverables;
    final projects = _repo.projects;
    final workloads = _repo.designerWorkloads;
    final activities = _repo.activities;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Page Header
            DesignHeader(
              title: 'Design Workspace & DAM Hub',
              subtitle: 'Multi-project CAD drawings, 3D renders, revision lifecycles & client approval tracking',
              primaryActionLabel: 'Upload Deliverable',
              primaryActionIcon: Icons.cloud_upload_outlined,
              onPrimaryAction: _handleUpload,
              searchHint: 'Search drawing titles, rooms, designers, project codes...',
              onSearchChanged: (val) => setState(() => _searchQuery = val),
              actions: [
                OutlinedButton.icon(
                  onPressed: _handleSubmitBatchToClient,
                  icon: const Icon(Icons.send_rounded, size: 16),
                  label: const Text('Batch Submit to Client'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Exporting master design register (DWG/PDF Index)...')),
                    );
                  },
                  icon: const Icon(Icons.picture_as_pdf_outlined, size: 16),
                  label: const Text('Export Register'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Top KPI Row
            Row(
              children: [
                Expanded(
                  child: DesignMetricCard(
                    title: 'Active Projects',
                    value: '${kpis.activeDesignProjects}',
                    subtitle: '${kpis.totalDesignFiles} total deliverables',
                    icon: Icons.apartment_rounded,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: DesignMetricCard(
                    title: 'Client Review Loop',
                    value: '${kpis.clientReview}',
                    subtitle: '${kpis.overdueReviews} SLA overdue',
                    icon: Icons.hourglass_top_rounded,
                    color: AppColors.warning,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: DesignMetricCard(
                    title: 'Revisions Pending',
                    value: '${kpis.revisionRequested}',
                    subtitle: 'Avg ${kpis.averageRevisionCount.toStringAsFixed(1)} revs / file',
                    icon: Icons.published_with_changes_rounded,
                    color: AppColors.error,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: DesignMetricCard(
                    title: 'Sent to Execution',
                    value: '${kpis.sentToExecution}',
                    subtitle: '${kpis.approved} approved total',
                    icon: Icons.check_circle_outline_rounded,
                    color: AppColors.success,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Section 1: Active Project Design Progress Carousel/Cards
            Text('Project Design Progress', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w800)),
            const SizedBox(height: 12),
            SizedBox(
              height: 130,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: projects.length,
                separatorBuilder: (context, index) => const SizedBox(width: 14),
                itemBuilder: (context, index) {
                  final p = projects[index];
                  final isSelected = _selectedProjectCode == p.code;

                  return InkWell(
                    onTap: () {
                      setState(() {
                        _selectedProjectCode = isSelected ? null : p.code;
                      });
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: 280,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary.withValues(alpha: 0.08)
                            : (isDark ? AppColors.darkCard : AppColors.lightCard),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected ? AppColors.primary : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                          width: isSelected ? 1.5 : 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(p.code, style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary)),
                              const SizedBox(width: 8),
                              Flexible(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    p.designStage.label,
                                    style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.primary),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            p.name,
                            style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          DesignProgressBar(
                            progressPercent: p.progressPercent,
                            height: 6,
                            showLabel: false,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  '${p.progressPercent.toInt()}% Completed',
                                  style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Text(
                                'Lead: ${p.leadDesigner.split(' ').first}',
                                style: GoogleFonts.inter(fontSize: 11, color: isDark ? AppColors.darkMutedText : AppColors.lightMutedText),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),

            // Section 2: Deliverables Filter Bar & View Toggle
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCard : AppColors.lightCard,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Wrap(
                      spacing: 14,
                      runSpacing: 10,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        // Filter by Project
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
                                ...projects.map((p) => DropdownMenuItem(value: p.code, child: Text('${p.code} (${p.name})', style: const TextStyle(fontSize: 12)))),
                              ],
                              onChanged: (val) => setState(() => _selectedProjectCode = val),
                            ),
                          ],
                        ),

                        // Filter by Category
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.category_outlined, size: 16, color: Colors.grey),
                            const SizedBox(width: 6),
                            DropdownButton<DesignCategory?>(
                              value: _selectedCategory,
                              hint: const Text('All Categories', style: TextStyle(fontSize: 12)),
                              underline: const SizedBox(),
                              items: [
                                const DropdownMenuItem(value: null, child: Text('All Categories', style: TextStyle(fontSize: 12))),
                                ...DesignCategory.values.map((c) => DropdownMenuItem(value: c, child: Text(c.label, style: const TextStyle(fontSize: 12)))),
                              ],
                              onChanged: (val) => setState(() => _selectedCategory = val),
                            ),
                          ],
                        ),

                        // Filter by Status
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.filter_list_rounded, size: 16, color: Colors.grey),
                            const SizedBox(width: 6),
                            DropdownButton<DesignReviewStatus?>(
                              value: _selectedStatus,
                              hint: const Text('All Statuses', style: TextStyle(fontSize: 12)),
                              underline: const SizedBox(),
                              items: [
                                const DropdownMenuItem(value: null, child: Text('All Statuses', style: TextStyle(fontSize: 12))),
                                ...DesignReviewStatus.values.map((s) => DropdownMenuItem(value: s, child: Text(s.label, style: const TextStyle(fontSize: 12)))),
                              ],
                              onChanged: (val) => setState(() => _selectedStatus = val),
                            ),
                          ],
                        ),

                        // Reset Filters
                        if (_selectedProjectCode != null || _selectedCategory != null || _selectedStatus != null || _searchQuery.isNotEmpty)
                          TextButton.icon(
                            onPressed: () {
                              setState(() {
                                _selectedProjectCode = null;
                                _selectedCategory = null;
                                _selectedStatus = null;
                                _searchQuery = '';
                              });
                            },
                            icon: const Icon(Icons.clear_all_rounded, size: 16),
                            label: const Text('Clear Filters', style: TextStyle(fontSize: 12)),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Grid vs Table Toggle
                  Container(
                    decoration: BoxDecoration(
                      color: isDark ? Colors.black26 : Colors.black12,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.all(2),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.grid_view_rounded, size: 18, color: _isGridView ? AppColors.primary : Colors.grey),
                          onPressed: () => setState(() => _isGridView = true),
                          tooltip: 'Grid View',
                          constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                          padding: EdgeInsets.zero,
                        ),
                        IconButton(
                          icon: Icon(Icons.table_rows_rounded, size: 18, color: !_isGridView ? AppColors.primary : Colors.grey),
                          onPressed: () => setState(() => _isGridView = false),
                          tooltip: 'Table View',
                          constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                          padding: EdgeInsets.zero,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Deliverables Display (Grid or Table)
            if (deliverables.isEmpty)
              const DesignEmptyState(
                icon: Icons.search_off_rounded,
                title: 'No Deliverables Found',
                message: 'Try adjusting your filters or upload a new design deliverable.',
              )
            else if (_isGridView)
              LayoutBuilder(
                builder: (context, constraints) {
                  final crossAxisCount = (constraints.maxWidth / 340).floor().clamp(1, 4);
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                      mainAxisExtent: 380,
                    ),
                    itemCount: deliverables.length,
                    itemBuilder: (context, index) {
                      final d = deliverables[index];
                      return DeliverableCard(
                        deliverable: d,
                        onReview: () => _handlePreview(d),
                        onHistory: () => _handleHistory(d),
                      );
                    },
                  );
                },
              )
            else
              _buildDeliverablesTable(deliverables, isDark),

            const SizedBox(height: 32),

            // Section 3: Designer Workloads & Activity Feed
            LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 900;

                return Flex(
                  direction: isWide ? Axis.horizontal : Axis.vertical,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Workloads Box
                    Expanded(
                      flex: isWide ? 6 : 0,
                      child: Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.darkCard : AppColors.lightCard,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Designer Team Workload', style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700)),
                                Text('${workloads.length} Designers Active', style: GoogleFonts.inter(fontSize: 12, color: Colors.grey)),
                              ],
                            ),
                            const SizedBox(height: 14),
                            ...workloads.map((w) {
                              final loadPct = (w.assignedDeliverables / 12 * 100).clamp(10.0, 100.0);
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(w.designerName, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600)),
                                        Text(
                                          '${w.assignedDeliverables} files (${w.revisionsInProgress} revisions)',
                                          style: GoogleFonts.inter(fontSize: 11, color: isDark ? AppColors.darkMutedText : AppColors.lightMutedText),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    DesignProgressBar(
                                      progressPercent: loadPct,
                                      height: 6,
                                      showLabel: false,
                                      color: w.revisionsInProgress > 2 ? AppColors.warning : AppColors.primary,
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    ),
                    if (isWide) const SizedBox(width: 16) else const SizedBox(height: 16),

                    // Live Design Activity Stream
                    Expanded(
                      flex: isWide ? 6 : 0,
                      child: Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.darkCard : AppColors.lightCard,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Recent Design Activity', style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700)),
                                const Icon(Icons.stream_rounded, size: 18, color: AppColors.primary),
                              ],
                            ),
                            const SizedBox(height: 14),
                            ...activities.take(5).map((act) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: act.color.withValues(alpha: 0.15),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(act.icon, size: 14, color: act.color),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(act.title, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700)),
                                          Text(act.subtitle, style: GoogleFonts.inter(fontSize: 11, color: isDark ? AppColors.darkMutedText : AppColors.lightMutedText)),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      act.timeAgo,
                                      style: GoogleFonts.inter(fontSize: 10, color: Colors.grey),
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeliverablesTable(List<DesignDeliverable> items, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowHeight: 44,
          dataRowMinHeight: 52,
          dataRowMaxHeight: 56,
          columns: const [
            DataColumn(label: Text('Deliverable')),
            DataColumn(label: Text('Project')),
            DataColumn(label: Text('Category')),
            DataColumn(label: Text('Ver')),
            DataColumn(label: Text('Status')),
            DataColumn(label: Text('Lead Designer')),
            DataColumn(label: Text('SLA Deadline')),
            DataColumn(label: Text('Actions')),
          ],
          rows: items.map((d) {
            return DataRow(
              cells: [
                DataCell(
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(d.category.icon, size: 16, color: d.category.color),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(d.title, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600)),
                          Text(d.roomArea, style: GoogleFonts.inter(fontSize: 11, color: Colors.grey)),
                        ],
                      ),
                    ],
                  ),
                ),
                DataCell(Text(d.projectCode, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600))),
                DataCell(DesignCategoryBadge(category: d.category, fontSize: 10)),
                DataCell(
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(d.currentVersion, style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary)),
                  ),
                ),
                DataCell(DesignStatusBadge(status: d.status, fontSize: 10)),
                DataCell(Text(d.designerName, style: GoogleFonts.inter(fontSize: 12))),
                DataCell(
                  Text(
                    d.clientReviewSlaDeadline != null
                        ? '${d.clientReviewSlaDeadline!.day}/${d.clientReviewSlaDeadline!.month}'
                        : 'N/A',
                    style: GoogleFonts.inter(fontSize: 12, color: d.isOverdue ? AppColors.error : null),
                  ),
                ),
                DataCell(
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.visibility_outlined, size: 16),
                        tooltip: 'Preview & Annotate',
                        onPressed: () => _handlePreview(d),
                      ),
                      IconButton(
                        icon: const Icon(Icons.published_with_changes_rounded, size: 16),
                        tooltip: 'Request Revision',
                        onPressed: () => _handleRequestRevision(d),
                      ),
                      IconButton(
                        icon: const Icon(Icons.history_rounded, size: 16),
                        tooltip: 'Version History',
                        onPressed: () => _handleHistory(d),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
