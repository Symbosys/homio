import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../data/designs_repository.dart';
import '../domain/design_enums.dart';
import '../domain/design_models.dart';
import '../widgets/design_header.dart';
import '../widgets/design_metric_card.dart';
import '../widgets/design_shared_widgets.dart';
import '../widgets/handover_package_modal.dart';

/// Screen 5: Design-to-Execution Handover (`/designs/handover` / `/designs/execution-handover`).
/// Manages Good-for-Construction (GFC) asset packages, engineering verification checklists,
/// site PM acknowledgment loops, and automated dispatch to the Execution module.
class DesignHandoverPage extends StatefulWidget {
  const DesignHandoverPage({super.key});

  @override
  State<DesignHandoverPage> createState() => _DesignHandoverPageState();
}

class _DesignHandoverPageState extends State<DesignHandoverPage> {
  final DesignsRepository _repo = DesignsRepository();

  String? _selectedProjectCode;
  String _searchQuery = '';

  List<DesignHandover> get _filteredHandovers {
    return _repo.handovers.where((h) {
      if (_selectedProjectCode != null && h.projectCode != _selectedProjectCode) return false;
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final match = h.handoverName.toLowerCase().contains(q) ||
            h.packageVersion.toLowerCase().contains(q) ||
            h.executionManager.toLowerCase().contains(q) ||
            h.projectCode.toLowerCase().contains(q);
        if (!match) return false;
      }
      return true;
    }).toList();
  }

  void _handleCreatePackage() {
    final projectCode = _selectedProjectCode ?? 'PRJ-104';
    final project = _repo.getProjectByCode(projectCode);
    final approvedDeliverables = _repo.getDeliverablesForProject(projectCode).where((d) => d.isApproved || d.status == DesignReviewStatus.approved).toList();

    HandoverPackageModal.show(
      context: context,
      approvedDeliverables: approvedDeliverables,
      projectCode: projectCode,
      projectName: project?.name ?? 'Skyline Penthouse 402',
      onCreateHandover: (package) {
        setState(() {
          _repo.createHandoverPackage(package);
        });
      },
    );
  }

  void _handleDispatchToExecution(DesignHandover h) {
    if (!h.isAllChecklistSatisfied) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Row(
            children: [
              const Icon(Icons.warning_amber_rounded, color: AppColors.warning),
              const SizedBox(width: 8),
              Text('Incomplete GFC Checklist', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700)),
            ],
          ),
          content: Text(
            'Only ${h.satisfiedChecklistCount} of ${h.checklist.length} checklist items are verified. Are you sure you want to dispatch this GFC package to site execution?',
            style: GoogleFonts.inter(fontSize: 13),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                setState(() {
                  _repo.sendToExecution(h.id);
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Handover Package "${h.packageVersion}" dispatched to Site Lead PM ${h.executionManager}!'),
                    backgroundColor: AppColors.success,
                  ),
                );
              },
              child: const Text('Dispatch Anyway'),
            ),
          ],
        ),
      );
      return;
    }

    setState(() {
      _repo.sendToExecution(h.id);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Handover Package "${h.packageVersion}" dispatched to Site Lead PM ${h.executionManager}!'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _handleSiteAcknowledgement(DesignHandover h, bool isAccepted) {
    if (isAccepted) {
      setState(() {
        _repo.acknowledgeHandover(h.id, true);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Handover Package "${h.packageVersion}" ACCEPTED by site team! Execution WBS unlocked.'),
          backgroundColor: AppColors.success,
        ),
      );
    } else {
      final rejectReasonCtrl = TextEditingController();
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Site Rejection / Revision Note', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Specify engineering issues found on site:', style: GoogleFonts.inter(fontSize: 12)),
              const SizedBox(height: 8),
              TextField(
                controller: rejectReasonCtrl,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'e.g., Plumbing stack location clashes with bathroom riser...',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
                style: const TextStyle(fontSize: 13),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                if (rejectReasonCtrl.text.trim().isNotEmpty) {
                  setState(() {
                    _repo.acknowledgeHandover(h.id, false, rejectReason: rejectReasonCtrl.text.trim());
                  });
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Site Revision Requested. Handed back to Lead Architect.'), backgroundColor: AppColors.error),
                  );
                }
              },
              child: const Text('Submit Site Rejection'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final handovers = _filteredHandovers;
    final projects = _repo.projects;

    // Metrics
    final totalPackages = _repo.handovers.length;
    final pendingCount = _repo.handovers.where((h) => h.status == HandoverStatus.pendingReview).length;
    final acceptedCount = _repo.handovers.where((h) => h.status == HandoverStatus.accepted).length;
    final draftCount = _repo.handovers.where((h) => h.status == HandoverStatus.draft).length;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Page Header
            DesignHeader(
              title: 'Design-to-Execution Handover',
              subtitle: 'Good-For-Construction (GFC) asset packages, engineering verification checklists & site PM release',
              primaryActionLabel: 'New Handover Package',
              primaryActionIcon: Icons.handshake_outlined,
              onPrimaryAction: _handleCreatePackage,
              searchHint: 'Search package name, version, project, site manager...',
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

            // Top KPI Row
            Row(
              children: [
                Expanded(
                  child: DesignMetricCard(
                    title: 'Total Handover Packages',
                    value: '$totalPackages',
                    subtitle: 'GFC bundles generated',
                    icon: Icons.inventory_2_outlined,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: DesignMetricCard(
                    title: 'Dispatched to Site',
                    value: '$pendingCount',
                    subtitle: 'Under site PM review',
                    icon: Icons.send_and_archive_rounded,
                    color: AppColors.warning,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: DesignMetricCard(
                    title: 'Site Accepted & Active',
                    value: '$acceptedCount',
                    subtitle: 'Good for execution',
                    icon: Icons.verified_user_rounded,
                    color: AppColors.success,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: DesignMetricCard(
                    title: 'Draft Packages',
                    value: '$draftCount',
                    subtitle: 'Assembling drawings',
                    icon: Icons.edit_note_rounded,
                    color: const Color(0xFF6366F1),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Packages Stream
            if (handovers.isEmpty)
              const DesignEmptyState(
                icon: Icons.handshake_outlined,
                title: 'No Handover Packages Found',
                message: 'Assemble approved drawings into a Good-for-Construction package to initiate site handover.',
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: handovers.length,
                separatorBuilder: (context, index) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final h = handovers[index];
                  return _buildHandoverPackageCard(h, isDark);
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildHandoverPackageCard(DesignHandover h, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: h.status == HandoverStatus.accepted
              ? AppColors.success.withValues(alpha: 0.4)
              : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
          width: h.status == HandoverStatus.accepted ? 1.5 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  h.packageVersion,
                  style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.primary),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      h.handoverName,
                      style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                    Text(
                      '${h.projectCode} — ${h.projectName} • Dispatched: ${h.submittedDate.day}/${h.submittedDate.month}/${h.submittedDate.year}',
                      style: GoogleFonts.inter(fontSize: 12, color: isDark ? AppColors.darkMutedText : AppColors.lightMutedText),
                    ),
                  ],
                ),
              ),
              DesignHandoverBadge(status: h.status),
            ],
          ),
          const SizedBox(height: 16),

          // Checklist and Deliverables Summary Box
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF131924) : const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'GFC Engineering Checklist (${h.satisfiedChecklistCount}/${h.checklist.length} Verified)',
                      style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700),
                    ),
                    Text(
                      '${h.includedDeliverableIds.length} Deliverables Bundled',
                      style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primary),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 10,
                  runSpacing: 6,
                  children: h.checklist.map((item) {
                    return InkWell(
                      onTap: () {
                        setState(() {
                          _repo.toggleHandoverChecklistItem(h.id, item.id, !item.isSatisfied);
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: item.isSatisfied
                              ? AppColors.success.withValues(alpha: 0.12)
                              : Colors.grey.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: item.isSatisfied ? AppColors.success.withValues(alpha: 0.4) : Colors.grey.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              item.isSatisfied ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                              size: 14,
                              color: item.isSatisfied ? AppColors.success : Colors.grey,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              item.title,
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                fontWeight: item.isSatisfied ? FontWeight.w600 : FontWeight.w500,
                                color: item.isSatisfied ? (isDark ? Colors.white : Colors.black87) : Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Rejection note if applicable
          if (h.status == HandoverStatus.changesRequested && h.rejectedReason != null) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.error_outline_rounded, color: AppColors.error, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Site PM Revision Request: ${h.rejectedReason}',
                      style: GoogleFonts.inter(fontSize: 12, color: AppColors.error, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
          ],

          // Footer Row
          Row(
            children: [
              Icon(Icons.engineering_outlined, size: 16, color: Colors.grey),
              const SizedBox(width: 6),
              Text(
                'Execution Lead PM: ${h.executionManager}',
                style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600),
              ),
              const Spacer(),

              // Action buttons based on status
              if (h.status == HandoverStatus.draft)
                ElevatedButton.icon(
                  onPressed: () => _handleDispatchToExecution(h),
                  icon: const Icon(Icons.send_rounded, size: 16),
                  label: const Text('Dispatch to Execution'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  ),
                )
              else if (h.status == HandoverStatus.pendingReview) ...[
                ElevatedButton.icon(
                  onPressed: () => _handleSiteAcknowledgement(h, true),
                  icon: const Icon(Icons.verified_rounded, size: 16),
                  label: const Text('Site PM Accept GFC'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.success,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  ),
                ),
                const SizedBox(width: 8),
                OutlinedButton.icon(
                  onPressed: () => _handleSiteAcknowledgement(h, false),
                  icon: const Icon(Icons.published_with_changes_rounded, size: 16),
                  label: const Text('Request Site Changes'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.error,
                    side: const BorderSide(color: AppColors.error),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
