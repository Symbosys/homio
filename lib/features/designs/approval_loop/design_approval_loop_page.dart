import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../data/designs_repository.dart';
import '../domain/design_enums.dart';
import '../domain/design_models.dart';
import '../widgets/client_review_modal.dart';
import '../widgets/design_header.dart';
import '../widgets/design_metric_card.dart';
import '../widgets/design_shared_widgets.dart';
import '../widgets/file_preview_modal.dart';
import '../widgets/submit_to_client_modal.dart';

/// Screen 4: Client Review & Approval Loop (`/designs/approvals` / `/designs/approval-loop`).
/// Manages formal client review cycles, 48-hour SLA clocks, client annotations,
/// digital sign-off approvals, and automated execution triggers.
class DesignApprovalLoopPage extends StatefulWidget {
  const DesignApprovalLoopPage({super.key});

  @override
  State<DesignApprovalLoopPage> createState() => _DesignApprovalLoopPageState();
}

class _DesignApprovalLoopPageState extends State<DesignApprovalLoopPage>
    with SingleTickerProviderStateMixin {
  final DesignsRepository _repo = DesignsRepository();
  late TabController _tabController;

  String? _selectedProjectCode;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<DesignDeliverable> _getDeliverablesForTab(int tabIndex) {
    return _repo.deliverables.where((d) {
      if (_selectedProjectCode != null && d.projectCode != _selectedProjectCode) return false;

      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final match = d.title.toLowerCase().contains(q) ||
            d.roomArea.toLowerCase().contains(q) ||
            d.designerName.toLowerCase().contains(q) ||
            d.clientName.toLowerCase().contains(q) ||
            d.projectCode.toLowerCase().contains(q);
        if (!match) return false;
      }

      switch (tabIndex) {
        case 0: // Under Review
          return d.status == DesignReviewStatus.sentToClient ||
              d.status == DesignReviewStatus.underClientReview;
        case 1: // Approved
          return d.status == DesignReviewStatus.approved ||
              d.status == DesignReviewStatus.sentToExecution;
        case 2: // Changes Requested
          return d.status == DesignReviewStatus.revisionRequested ||
              d.status == DesignReviewStatus.changesRequested;
        case 3: // All
        default:
          return true;
      }
    }).toList();
  }

  void _handleBatchSubmit() {
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

  void _handleInteractiveReview(DesignDeliverable d) {
    ClientReviewModal.show(
      context: context,
      deliverable: d,
      onUpdate: (updated) {
        setState(() {
          if (updated.status == DesignReviewStatus.approved) {
            _repo.clientApprove(d.id, d.clientName, 'Approved via Client Review Portal');
          } else if (updated.status == DesignReviewStatus.changesRequested) {
            _repo.clientRequestRevision(d.id, 'Revision Requested', 'Client feedback updated.');
          }
        });
      },
    );
  }

  void _handlePreview(DesignDeliverable d) {
    FilePreviewModal.show(
      context: context,
      deliverable: d,
    );
  }

  void _handleQuickApprove(DesignDeliverable d) {
    setState(() {
      _repo.clientApprove(d.id, d.clientName, 'Quick Approved by Architect/Client');
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Deliverable "${d.title}" APPROVED! Marked ready for GFC Handover.'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final kpis = _repo.getWorkspaceKpis();
    final projects = _repo.projects;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Page Header
            DesignHeader(
              title: 'Client Review & Approval Loop',
              subtitle: 'Multi-party approval workflows: Client review SLAs, visual annotations, sign-off registers & execution release',
              primaryActionLabel: 'Submit to Client',
              primaryActionIcon: Icons.send_rounded,
              onPrimaryAction: _handleBatchSubmit,
              searchHint: 'Search deliverable title, client name, room area...',
              onSearchChanged: (val) => setState(() => _searchQuery = val),
              actions: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkCard : AppColors.lightCard,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.apartment, size: 16, color: AppColors.primary),
                      const SizedBox(width: 8),
                      DropdownButtonHideUnderline(
                        child: DropdownButton<String?>(
                          value: _selectedProjectCode,
                          hint: const Text('All Projects', style: TextStyle(fontSize: 12)),
                          items: [
                            const DropdownMenuItem(value: null, child: Text('All Projects', style: TextStyle(fontSize: 12))),
                            ...projects.map((p) => DropdownMenuItem(value: p.code, child: Text(p.code, style: const TextStyle(fontSize: 12)))),
                          ],
                          onChanged: (val) => setState(() => _selectedProjectCode = val),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Top KPI Cards Row
            Row(
              children: [
                Expanded(
                  child: DesignMetricCard(
                    title: 'Under Client Review',
                    value: '${kpis.clientReview}',
                    subtitle: '48h SLA turnaround active',
                    icon: Icons.hourglass_top_rounded,
                    color: AppColors.warning,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: DesignMetricCard(
                    title: 'Client Approved',
                    value: '${kpis.approved}',
                    subtitle: 'Signed-off by homeowners',
                    icon: Icons.verified_rounded,
                    color: AppColors.success,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: DesignMetricCard(
                    title: 'Changes Demanded',
                    value: '${kpis.revisionRequested}',
                    subtitle: 'Revisions in progress',
                    icon: Icons.published_with_changes_rounded,
                    color: AppColors.error,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: DesignMetricCard(
                    title: 'Avg Turnaround',
                    value: '${kpis.averageApprovalTurnaroundHours.toInt()}h',
                    subtitle: 'Standard benchmark: 48h',
                    icon: Icons.speed_rounded,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Tabs Bar
            Container(
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCard : AppColors.lightCard,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
              ),
              child: TabBar(
                controller: _tabController,
                indicatorColor: AppColors.primary,
                indicatorWeight: 3,
                labelColor: AppColors.primary,
                unselectedLabelColor: Colors.grey,
                labelStyle: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700),
                tabs: const [
                  Tab(text: 'Under Client Review'),
                  Tab(text: 'Approved Deliverables'),
                  Tab(text: 'Revisions Requested'),
                  Tab(text: 'All Approval Records'),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Tab Content
            AnimatedBuilder(
              animation: _tabController,
              builder: (context, _) {
                final deliverables = _getDeliverablesForTab(_tabController.index);

                if (deliverables.isEmpty) {
                  return const DesignEmptyState(
                    icon: Icons.folder_open_rounded,
                    title: 'No Deliverables in this Queue',
                    message: 'Deliverables will appear here as they progress through the review lifecycle.',
                  );
                }

                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: deliverables.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final d = deliverables[index];
                    return _buildApprovalCard(d, isDark);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildApprovalCard(DesignDeliverable d, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: d.isOverdue ? AppColors.error.withValues(alpha: 0.5) : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
          width: d.isOverdue ? 1.5 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: d.category.color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(d.category.icon, size: 20, color: d.category.color),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            d.title,
                            style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        DesignFileTypeBadge(fileType: d.fileType, fontSize: 10),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(d.currentVersion, style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${d.projectCode} — ${d.projectName} • ${d.roomArea}',
                      style: GoogleFonts.inter(fontSize: 12, color: isDark ? AppColors.darkMutedText : AppColors.lightMutedText),
                    ),
                  ],
                ),
              ),
              DesignStatusBadge(status: d.status),
            ],
          ),
          const SizedBox(height: 14),

          // Details Row: Client, SLA deadline, designer
          Row(
            children: [
              Expanded(
                child: Wrap(
                  spacing: 14,
                  runSpacing: 6,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.person_outline_rounded, size: 14, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text('Client: ${d.clientName}', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600)),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.brush_outlined, size: 14, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text('Designer: ${d.designerName}', style: GoogleFonts.inter(fontSize: 12)),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.timer_outlined, size: 14, color: d.isOverdue ? AppColors.error : Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          d.clientReviewSlaDeadline != null
                              ? 'SLA: ${d.clientReviewSlaDeadline!.day}/${d.clientReviewSlaDeadline!.month} (${d.isOverdue ? "OVERDUE" : "On Track"})'
                              : 'SLA: Not Assigned',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: d.isOverdue ? AppColors.error : null,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),

              // Actions
              if (d.status == DesignReviewStatus.underClientReview || d.status == DesignReviewStatus.sentToClient) ...[
                ElevatedButton.icon(
                  onPressed: () => _handleQuickApprove(d),
                  icon: const Icon(Icons.check_circle_outline_rounded, size: 15),
                  label: const Text('Client Approve'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.success,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
                const SizedBox(width: 8),
              ],
              OutlinedButton.icon(
                onPressed: () => _handleInteractiveReview(d),
                icon: const Icon(Icons.rate_review_outlined, size: 15),
                label: const Text('Review & Sign-Off'),
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.visibility_outlined, size: 18),
                tooltip: 'Preview Canvas & Pins',
                onPressed: () => _handlePreview(d),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
