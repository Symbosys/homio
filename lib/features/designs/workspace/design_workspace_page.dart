import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../models/design_models.dart';
import '../models/design_mock_data.dart';
import '../widgets/design_header.dart';
import '../widgets/design_metric_card.dart';
import '../widgets/deliverable_card.dart';
import '../widgets/upload_deliverable_modal.dart';
import '../widgets/client_review_modal.dart';
import '../widgets/version_history_modal.dart';

/// 2D CAD & 3D Render Submissions Directory Workspace (PRD Section 15.1, Sidebar 6.1).
class DesignWorkspacePage extends StatefulWidget {
  const DesignWorkspacePage({super.key});

  @override
  State<DesignWorkspacePage> createState() => _DesignWorkspacePageState();
}

class _DesignWorkspacePageState extends State<DesignWorkspacePage> {
  late List<DesignDeliverable> _deliverables;
  String? _selectedProject;
  DesignCategory? _selectedCategory;
  DesignReviewStatus? _selectedStatus;
  String _searchQuery = '';
  bool _isGridView = true;

  @override
  void initState() {
    super.initState();
    _deliverables = List.from(DesignMockData.deliverables);
  }

  List<DesignDeliverable> get _filteredDeliverables {
    return _deliverables.where((d) {
      if (_selectedProject != null && d.projectCode != _selectedProject) return false;
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
      initialProjectCode: _selectedProject,
      onUpload: (newDeliverable) {
        setState(() {
          _deliverables.insert(0, newDeliverable);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Deliverable "${newDeliverable.title}" submitted successfully for client review!'),
            backgroundColor: AppColors.success,
          ),
        );
      },
    );
  }

  void _handleReview(DesignDeliverable deliverable) {
    ClientReviewModal.show(
      context: context,
      deliverable: deliverable,
      onUpdate: (updated) {
        setState(() {
          final idx = _deliverables.indexWhere((d) => d.id == updated.id);
          if (idx != -1) {
            _deliverables[idx] = updated;
          }
        });
      },
    );
  }

  void _handleHistory(DesignDeliverable deliverable) {
    VersionHistoryModal.show(
      context: context,
      deliverable: deliverable,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final filtered = _filteredDeliverables;

    // Metrics
    final totalCount = _deliverables.length;
    final approvedCount = _deliverables.where((d) => d.isApproved).length;
    final underReviewCount = _deliverables.where((d) => d.isUnderReview).length;
    final revisionCount = _deliverables.where((d) => d.isChangesRequested).length;

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Page Header
            DesignHeader(
              title: '2D CAD & 3D Render Submissions',
              subtitle: 'Deliverable lifecycle, version control repository, review loops & execution handover',
              primaryActionLabel: 'Upload Deliverable',
              primaryActionIcon: Icons.cloud_upload_outlined,
              onPrimaryAction: _handleUpload,
              searchHint: 'Search drawing titles, rooms, designers, project codes...',
              onSearchChanged: (val) => setState(() => _searchQuery = val),
              actions: [
                OutlinedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Exporting master design register (DWG/PDF Index)...')),
                    );
                  },
                  icon: const Icon(Icons.picture_as_pdf_outlined, size: 18),
                  label: const Text('Export Design Register'),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Top KPI Cards
            Row(
              children: [
                Expanded(
                  child: DesignMetricCard(
                    title: 'Total Deliverables',
                    value: '$totalCount',
                    subtitle: 'Across 4 active projects',
                    icon: Icons.layers_rounded,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: DesignMetricCard(
                    title: 'Sent to Execution',
                    value: '$approvedCount',
                    subtitle: 'Client approved & WBS active',
                    icon: Icons.check_circle_outline_rounded,
                    color: AppColors.success,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: DesignMetricCard(
                    title: 'Under Client Review',
                    value: '$underReviewCount',
                    subtitle: 'SLA timer 48h active',
                    icon: Icons.hourglass_top_rounded,
                    color: AppColors.warning,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: DesignMetricCard(
                    title: 'Revisions Pending',
                    value: '$revisionCount',
                    subtitle: 'Client changes requested',
                    icon: Icons.published_with_changes_rounded,
                    color: AppColors.error,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Filter Control Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCard : AppColors.lightCard,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                ),
              ),
              child: Wrap(
                spacing: 16,
                runSpacing: 12,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  // Project Filter
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.apartment, size: 18, color: AppColors.primary),
                      const SizedBox(width: 8),
                      DropdownButton<String?>(
                        value: _selectedProject,
                        hint: const Text('All Projects'),
                        underline: const SizedBox(),
                        items: const [
                          DropdownMenuItem(value: null, child: Text('All Projects')),
                          DropdownMenuItem(value: 'PRJ-104', child: Text('PRJ-104 (Camellias)')),
                          DropdownMenuItem(value: 'PRJ-105', child: Text('PRJ-105 (Godrej Woods)')),
                          DropdownMenuItem(value: 'PRJ-106', child: Text('PRJ-106 (Prestige Golfshire)')),
                          DropdownMenuItem(value: 'PRJ-107', child: Text('PRJ-107 (Oberoi Sky City)')),
                        ],
                        onChanged: (v) => setState(() => _selectedProject = v),
                      ),
                    ],
                  ),

                  // Category Filter
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.category_outlined, size: 18, color: AppColors.primary),
                      const SizedBox(width: 8),
                      DropdownButton<DesignCategory?>(
                        value: _selectedCategory,
                        hint: const Text('Category: All'),
                        underline: const SizedBox(),
                        items: [
                          const DropdownMenuItem(value: null, child: Text('All Categories')),
                          ...DesignCategory.values.map(
                            (c) => DropdownMenuItem(value: c, child: Text(c.label)),
                          ),
                        ],
                        onChanged: (v) => setState(() => _selectedCategory = v),
                      ),
                    ],
                  ),

                  // Status Filter
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.filter_list_rounded, size: 18, color: AppColors.primary),
                      const SizedBox(width: 8),
                      DropdownButton<DesignReviewStatus?>(
                        value: _selectedStatus,
                        hint: const Text('Review Status: All'),
                        underline: const SizedBox(),
                        items: [
                          const DropdownMenuItem(value: null, child: Text('All Review Statuses')),
                          ...DesignReviewStatus.values.map(
                            (s) => DropdownMenuItem(value: s, child: Text(s.label)),
                          ),
                        ],
                        onChanged: (v) => setState(() => _selectedStatus = v),
                      ),
                    ],
                  ),

                  // View Toggle
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.grid_view_rounded,
                          color: _isGridView ? AppColors.primary : Colors.grey,
                          size: 20,
                        ),
                        tooltip: 'Grid View',
                        onPressed: () => setState(() => _isGridView = true),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.view_list_rounded,
                          color: !_isGridView ? AppColors.primary : Colors.grey,
                          size: 20,
                        ),
                        tooltip: 'List View',
                        onPressed: () => setState(() => _isGridView = false),
                      ),
                    ],
                  ),

                  Text(
                    'Showing ${filtered.length} of $totalCount drawings',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isDark ? AppColors.darkMutedText : AppColors.lightMutedText,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Deliverables Display Grid or List
            if (filtered.isEmpty)
              Container(
                padding: const EdgeInsets.all(48),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkCard : AppColors.lightCard,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                ),
                child: Column(
                  children: [
                    Icon(Icons.search_off_rounded, size: 48, color: isDark ? AppColors.darkMutedText : AppColors.lightMutedText),
                    const SizedBox(height: 12),
                    Text(
                      'No Deliverables Found',
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Try changing your filters or upload a new CAD drawing or 3D render.',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: isDark ? AppColors.darkMutedText : AppColors.lightMutedText,
                      ),
                    ),
                  ],
                ),
              )
            else if (_isGridView)
              LayoutBuilder(
                builder: (context, constraints) {
                  final crossAxisCount = constraints.maxWidth > 1150
                      ? 3
                      : (constraints.maxWidth > 750 ? 2 : 1);

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.88,
                    ),
                    itemCount: filtered.length,
                    itemBuilder: (context, idx) {
                      final item = filtered[idx];
                      return DeliverableCard(
                        deliverable: item,
                        onReview: () => _handleReview(item),
                        onHistory: () => _handleHistory(item),
                      );
                    },
                  );
                },
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filtered.length,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (context, idx) {
                  final item = filtered[idx];
                  return Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkCard : AppColors.lightCard,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: SizedBox(
                            width: 100,
                            height: 68,
                            child: Image.network(
                              item.thumbnailUrl,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    item.projectCode,
                                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.primary),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    item.roomArea,
                                    style: TextStyle(fontSize: 11, color: item.category.color, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                                    decoration: BoxDecoration(
                                      color: item.fileType.color,
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                    child: Text(
                                      item.fileType.extension.toUpperCase(),
                                      style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                item.title,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                              ),
                              Text(
                                'Designer: ${item.designerName} • ${item.currentVersion} (Rev #${item.revisionCount}) • ${item.fileSizeFormatted}',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: isDark ? AppColors.darkMutedText : AppColors.lightMutedText,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: item.status.color.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            item.status.label,
                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: item.status.color),
                          ),
                        ),
                        const SizedBox(width: 12),
                        OutlinedButton(
                          onPressed: () => _handleHistory(item),
                          child: const Text('History'),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () => _handleReview(item),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: item.isApproved ? AppColors.success : AppColors.primary,
                          ),
                          child: Text(item.isApproved ? 'View' : 'Review'),
                        ),
                      ],
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
