import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../models/execution_models.dart';
import '../models/execution_mock_data.dart';
import '../widgets/execution_header.dart';
import '../widgets/execution_metric_card.dart';
import '../widgets/snag_ticket_modal.dart';

class ExecutionComplaintsPage extends StatefulWidget {
  const ExecutionComplaintsPage({super.key});

  @override
  State<ExecutionComplaintsPage> createState() => _ExecutionComplaintsPageState();
}

class _ExecutionComplaintsPageState extends State<ExecutionComplaintsPage> {
  late List<ProjectMaster> _projects;
  String? _selectedProjectId;
  SnagCategory? _selectedCategory;
  SnagStatus? _selectedStatus;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _projects = List.from(ExecutionMockData.projects);
    if (_projects.isNotEmpty) {
      _selectedProjectId = _projects.first.id;
    }
  }

  ProjectMaster? get _currentProject {
    if (_projects.isEmpty) return null;
    return _projects.firstWhere(
      (p) => p.id == _selectedProjectId,
      orElse: () => _projects.first,
    );
  }

  List<SnagTicket> get _filteredTickets {
    final proj = _currentProject;
    if (proj == null) return [];

    return proj.snags.where((s) {
      if (_selectedCategory != null && s.category != _selectedCategory) return false;
      if (_selectedStatus != null && s.status != _selectedStatus) return false;
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final match = s.title.toLowerCase().contains(q) ||
            s.roomOrArea.toLowerCase().contains(q) ||
            s.assignedContractor.toLowerCase().contains(q) ||
            s.ticketNumber.toLowerCase().contains(q);
        if (!match) return false;
      }
      return true;
    }).toList();
  }

  void _handleCreateSnag() {
    final proj = _currentProject;
    if (proj == null) return;

    SnagTicketModal.show(
      context: context,
      project: proj,
      onSave: (newTicket) {
        setState(() {
          proj.snags.insert(0, newTicket);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Snag ticket ${newTicket.ticketNumber} created & contractor notified.'),
            backgroundColor: AppColors.primary,
          ),
        );
      },
    );
  }

  void _handleInspectSnag(SnagTicket ticket) {
    final proj = _currentProject;
    if (proj == null) return;

    SnagTicketModal.show(
      context: context,
      project: proj,
      initialTicket: ticket,
      onSave: (updated) {
        setState(() {
          final idx = proj.snags.indexWhere((s) => s.id == updated.id);
          if (idx != -1) {
            proj.snags[idx] = updated;
          }
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Snag ticket ${updated.ticketNumber} updated.'),
            backgroundColor: AppColors.success,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final proj = _currentProject;
    final snags = _filteredTickets;

    // Snag KPIs
    final totalCount = proj?.snags.length ?? 0;
    final openCount = proj?.snags.where((s) => s.status == SnagStatus.open || s.status == SnagStatus.inProgress).length ?? 0;
    final overdueCount = proj?.snags.where((s) => s.isOverdue).length ?? 0;
    final verifiedCount = proj?.snags.where((s) => s.status == SnagStatus.clientVerified).length ?? 0;
    final resolutionRate = totalCount > 0 ? ((verifiedCount / totalCount) * 100).toInt() : 100;

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            ExecutionHeader(
              title: 'Client Complaints & Snag Punch-List',
              subtitle: 'Multi-category snagging, SLA timers, before/after visual proof & OTP sign-off',
              primaryActionLabel: 'Raise Snag Ticket',
              primaryActionIcon: Icons.report_problem_outlined,
              onPrimaryAction: _handleCreateSnag,
              searchHint: 'Search ticket #, area, contractor...',
              onSearchChanged: (val) => setState(() => _searchQuery = val),
              actions: [
                OutlinedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Exporting Snag Punch-List PDF for contractor with photos...')),
                    );
                  },
                  icon: const Icon(Icons.picture_as_pdf_outlined, size: 18),
                  label: const Text('Export Punch-List PDF'),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Top Metric Cards
            Row(
              children: [
                Expanded(
                  child: ExecutionMetricCard(
                    title: 'Total Snags Raised',
                    value: '$totalCount',
                    subtitle: 'Across all project areas',
                    icon: Icons.checklist_rtl_outlined,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: ExecutionMetricCard(
                    title: 'Pending Resolution',
                    value: '$openCount',
                    subtitle: 'Open or currently in-progress',
                    icon: Icons.pending_actions_outlined,
                    color: AppColors.warning,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: ExecutionMetricCard(
                    title: 'SLA Breached / Overdue',
                    value: '$overdueCount',
                    subtitle: 'Past assigned deadline',
                    icon: Icons.alarm_off_outlined,
                    color: AppColors.error,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: ExecutionMetricCard(
                    title: 'Resolution Rate',
                    value: '$resolutionRate%',
                    subtitle: '$verifiedCount client verified',
                    icon: Icons.verified_outlined,
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
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                ),
              ),
              child: Wrap(
                spacing: 16,
                runSpacing: 12,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  // Project Selector
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.apartment, size: 18, color: AppColors.primary),
                      const SizedBox(width: 8),
                      DropdownButton<String>(
                        value: _selectedProjectId,
                        underline: const SizedBox(),
                        items: _projects.map((p) {
                          return DropdownMenuItem(
                            value: p.id,
                            child: Text(
                              '${p.projectName} (${p.projectCode})',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          );
                        }).toList(),
                        onChanged: (v) {
                          if (v != null) setState(() => _selectedProjectId = v);
                        },
                      ),
                    ],
                  ),
                  // Category filter
                  DropdownButton<SnagCategory?>(
                    value: _selectedCategory,
                    hint: const Text('All Categories'),
                    underline: const SizedBox(),
                    items: [
                      const DropdownMenuItem(value: null, child: Text('All Snag Categories')),
                      ...SnagCategory.values.map(
                        (c) => DropdownMenuItem(value: c, child: Text(c.label)),
                      ),
                    ],
                    onChanged: (v) => setState(() => _selectedCategory = v),
                  ),
                  // Status filter
                  DropdownButton<SnagStatus?>(
                    value: _selectedStatus,
                    hint: const Text('All Statuses'),
                    underline: const SizedBox(),
                    items: [
                      const DropdownMenuItem(value: null, child: Text('All Statuses')),
                      ...SnagStatus.values.map(
                        (s) => DropdownMenuItem(value: s, child: Text(s.label)),
                      ),
                    ],
                    onChanged: (v) => setState(() => _selectedStatus = v),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Snag Tickets Table / Cards
            if (snags.isEmpty)
              Container(
                padding: const EdgeInsets.all(48),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkCard : AppColors.lightCard,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.verified, size: 48, color: AppColors.success),
                    const SizedBox(height: 12),
                    Text(
                      'No snag tickets found matching the criteria.',
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    const Text('Project quality is pristine or all tickets are resolved.'),
                  ],
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: snags.length,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (context, idx) {
                  final ticket = snags[idx];
                  return _buildTicketRow(ticket, isDark, theme);
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTicketRow(SnagTicket ticket, bool isDark, ThemeData theme) {
    return InkWell(
      onTap: () => _handleInspectSnag(ticket),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : AppColors.lightCard,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: ticket.isOverdue
                ? AppColors.error.withValues(alpha: 0.7)
                : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
            width: ticket.isOverdue ? 1.5 : 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Severity indicator bar
            Container(
              width: 5,
              height: 60,
              decoration: BoxDecoration(
                color: _getSeverityColor(ticket.severity),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: 14),

            // Ticket Details
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
                          ticket.ticketNumber,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          ticket.category.label,
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '📍 ${ticket.roomOrArea}',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? AppColors.darkMutedText : AppColors.lightMutedText,
                        ),
                      ),
                      if (ticket.isOverdue) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.error.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.alarm_off, size: 12, color: AppColors.error),
                              SizedBox(width: 4),
                              Text(
                                'SLA BREACHED',
                                style: TextStyle(
                                  color: AppColors.error,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    ticket.title,
                    style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Assigned: ${ticket.assignedContractor} • SLA Deadline: ${ticket.slaDeadline.day}/${ticket.slaDeadline.month}/${ticket.slaDeadline.year}',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? AppColors.darkMutedText : AppColors.lightMutedText,
                    ),
                  ),
                ],
              ),
            ),

            // Status Badge
            _buildStatusBadge(ticket.status),
            const SizedBox(width: 14),

            // Chevron
            const Icon(Icons.chevron_right, color: AppColors.primary),
          ],
        ),
      ),
    );
  }

  Color _getSeverityColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.critical:
        return AppColors.error;
      case TaskPriority.high:
        return Colors.deepOrange;
      case TaskPriority.medium:
        return AppColors.warning;
      case TaskPriority.low:
        return AppColors.info;
    }
  }

  Widget _buildStatusBadge(SnagStatus status) {
    Color bg;
    Color fg;
    switch (status) {
      case SnagStatus.open:
        bg = AppColors.error.withValues(alpha: 0.15);
        fg = AppColors.error;
        break;
      case SnagStatus.inProgress:
        bg = AppColors.warning.withValues(alpha: 0.15);
        fg = AppColors.warning;
        break;
      case SnagStatus.underReview:
        bg = AppColors.info.withValues(alpha: 0.15);
        fg = AppColors.info;
        break;
      case SnagStatus.resolvedOnTime:
        bg = AppColors.success.withValues(alpha: 0.15);
        fg = AppColors.success;
        break;
      case SnagStatus.resolvedDelayed:
        bg = Colors.deepOrange.withValues(alpha: 0.15);
        fg = Colors.deepOrange;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status.label,
        style: TextStyle(color: fg, fontSize: 11, fontWeight: FontWeight.bold),
      ),
    );
  }
}
