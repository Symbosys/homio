import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../models/design_models.dart';
import '../models/design_mock_data.dart';
import '../widgets/design_header.dart';
import '../widgets/design_metric_card.dart';
import '../widgets/client_review_modal.dart';
import '../widgets/version_history_modal.dart';

/// Client Review & Approval Loop Screen (PRD Section 15.1, Sidebar 6.2).
/// Implements state machine: Approved -> Execution Webhook / Rejected -> Revisions.
class DesignApprovalLoopPage extends StatefulWidget {
  const DesignApprovalLoopPage({super.key});

  @override
  State<DesignApprovalLoopPage> createState() => _DesignApprovalLoopPageState();
}

class _DesignApprovalLoopPageState extends State<DesignApprovalLoopPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late List<DesignDeliverable> _deliverables;
  String? _selectedProject;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _deliverables = List.from(DesignMockData.deliverables);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<DesignDeliverable> _getFilteredForStatus(DesignReviewStatus status) {
    return _deliverables.where((d) {
      if (d.status != status) return false;
      if (_selectedProject != null && d.projectCode != _selectedProject) return false;
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

  void _handleReview(DesignDeliverable d) {
    ClientReviewModal.show(
      context: context,
      deliverable: d,
      onUpdate: (updated) {
        setState(() {
          final idx = _deliverables.indexWhere((item) => item.id == updated.id);
          if (idx != -1) {
            _deliverables[idx] = updated;
          }
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final underReviewList = _getFilteredForStatus(DesignReviewStatus.submitted);
    final approvedList = _getFilteredForStatus(DesignReviewStatus.approved);
    final revisionsList = _getFilteredForStatus(DesignReviewStatus.changesRequested);

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Page Header
            DesignHeader(
              title: 'Client Review & Approval Loop',
              subtitle: 'Workflow state machine: Approved -> Execution Webhook / Rejected -> Revisions & Turnaround SLA',
              searchHint: 'Search drawings under review, client notes...',
              onSearchChanged: (val) => setState(() => _searchQuery = val),
              actions: [
                OutlinedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Generating Client Review Status Summary PDF...')),
                    );
                  },
                  icon: const Icon(Icons.picture_as_pdf_outlined, size: 18),
                  label: const Text('Export Review Summary'),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Top KPI Metrics
            Row(
              children: [
                Expanded(
                  child: DesignMetricCard(
                    title: 'Under Client Review',
                    value: '${underReviewList.length}',
                    subtitle: '48h SLA turnaround active',
                    icon: Icons.hourglass_top_rounded,
                    color: AppColors.warning,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: DesignMetricCard(
                    title: 'Sent to Execution',
                    value: '${approvedList.length}',
                    subtitle: 'WBS Milestones unlocked',
                    icon: Icons.check_circle_rounded,
                    color: AppColors.success,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: DesignMetricCard(
                    title: 'Revision Requests',
                    value: '${revisionsList.length}',
                    subtitle: 'Annotations attached',
                    icon: Icons.published_with_changes_rounded,
                    color: AppColors.error,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: DesignMetricCard(
                    title: 'Avg Turnaround',
                    value: '22.4h',
                    subtitle: 'Within 48h client SLA limit',
                    icon: Icons.speed_rounded,
                    color: AppColors.info,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Project Selector & State Machine Explanation
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCard : AppColors.lightCard,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
              ),
              child: Row(
                children: [
                  const Icon(Icons.apartment, size: 18, color: AppColors.primary),
                  const SizedBox(width: 8),
                  DropdownButton<String?>(
                    value: _selectedProject,
                    hint: const Text('All Projects'),
                    underline: const SizedBox(),
                    items: const [
                      DropdownMenuItem(value: null, child: Text('All Projects')),
                      DropdownMenuItem(value: 'PRJ-104', child: Text('PRJ-104 (DLF Camellias)')),
                      DropdownMenuItem(value: 'PRJ-105', child: Text('PRJ-105 (Godrej Woods)')),
                      DropdownMenuItem(value: 'PRJ-106', child: Text('PRJ-106 (Prestige Golfshire)')),
                      DropdownMenuItem(value: 'PRJ-107', child: Text('PRJ-107 (Oberoi Sky City)')),
                    ],
                    onChanged: (v) => setState(() => _selectedProject = v),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.webhook_rounded, size: 14, color: AppColors.primary),
                        const SizedBox(width: 6),
                        Text(
                          'Webhook: Approved -> Sent to Execution WBS',
                          style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Tabs for State Machine Columns
            Container(
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCard : AppColors.lightCard,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
              ),
              child: TabBar(
                controller: _tabController,
                indicatorColor: AppColors.primary,
                labelColor: AppColors.primary,
                unselectedLabelColor: Colors.grey,
                labelStyle: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 13),
                tabs: [
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.hourglass_top_rounded, size: 16),
                        const SizedBox(width: 8),
                        Text('Under Client Review (${underReviewList.length})'),
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.check_circle_outline, size: 16),
                        const SizedBox(width: 8),
                        Text('Approved -> Execution (${approvedList.length})'),
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.published_with_changes_rounded, size: 16),
                        const SizedBox(width: 8),
                        Text('Changes Requested (${revisionsList.length})'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Tab View Area
            SizedBox(
              height: 600,
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Tab 1: Under Client Review
                  _buildDeliverableList(underReviewList, isDark, true),

                  // Tab 2: Approved (Sent to Execution)
                  _buildDeliverableList(approvedList, isDark, false),

                  // Tab 3: Changes Requested (Revisions)
                  _buildDeliverableList(revisionsList, isDark, false),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeliverableList(List<DesignDeliverable> list, bool isDark, bool isActionable) {
    if (list.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(48),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : AppColors.lightCard,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.done_all_rounded, size: 48, color: AppColors.success),
            const SizedBox(height: 12),
            Text(
              'No Deliverables in this Stage',
              style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              'All items in this workflow state have been resolved.',
              style: GoogleFonts.inter(
                fontSize: 12,
                color: isDark ? AppColors.darkMutedText : AppColors.lightMutedText,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      itemCount: list.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, idx) {
        final item = list[idx];
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCard : AppColors.lightCard,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  width: 140,
                  height: 95,
                  child: Image.network(
                    item.thumbnailUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // Deliverable Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            item.projectCode,
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primary),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          item.roomArea,
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: item.category.color),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: item.fileType.color,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            item.fileType.extension.toUpperCase(),
                            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: item.status.color.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: item.status.color.withValues(alpha: 0.3)),
                          ),
                          child: Text(
                            item.status.label,
                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: item.status.color),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      item.title,
                      style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Client: ${item.clientName} • Designer: ${item.designerName} • ${item.currentVersion} (Rev #${item.revisionCount})',
                      style: TextStyle(
                        fontSize: 11,
                        color: isDark ? AppColors.darkMutedText : AppColors.lightMutedText,
                      ),
                    ),
                    if (item.executionWebhookTriggeredAt != null) ...[
                      const SizedBox(height: 6),
                      Text(
                        '🚀 ${item.executionWebhookTriggeredAt}',
                        style: const TextStyle(fontSize: 11, color: AppColors.success, fontWeight: FontWeight.w600),
                      ),
                    ],
                    if (item.versionHistory.isNotEmpty && item.versionHistory.last.clientFeedback != null) ...[
                      const SizedBox(height: 6),
                      Text(
                        '💬 Feedback: "${item.versionHistory.last.clientFeedback}"',
                        style: const TextStyle(fontSize: 11, color: AppColors.error, fontStyle: FontStyle.italic),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 16),

              // Action Buttons
              Column(
                children: [
                  OutlinedButton.icon(
                    onPressed: () => _handleHistory(item),
                    icon: const Icon(Icons.history, size: 16),
                    label: const Text('History'),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: item.isApproved ? AppColors.success : AppColors.primary,
                    ),
                    onPressed: () => _handleReview(item),
                    icon: Icon(item.isApproved ? Icons.visibility : Icons.rate_review, size: 16),
                    label: Text(item.isApproved ? 'Inspect' : 'Review & Sign-off'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
