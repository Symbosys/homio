import 'package:flutter/material.dart';
import '../../../core/layout/adaptive_layout.dart';
import '../../../core/theme/app_colors.dart';
import '../../dashboard/widgets/state_feedback_widgets.dart';
import '../data/sales_repository.dart';
import '../domain/sales_domain_models.dart';
import '../domain/sales_enums.dart';
import '../widgets/crm_header.dart';
import '../widgets/lead_detail_360_modal.dart';

/// Screen 5: Follow-ups Hub
/// Daily execution console for Sales Reps & SDRs to manage overdue,
/// due today, and scheduled phone, WhatsApp, email, and site visits.
class SalesFollowupsPage extends StatefulWidget {
  const SalesFollowupsPage({super.key});

  @override
  State<SalesFollowupsPage> createState() => _SalesFollowupsPageState();
}

class _SalesFollowupsPageState extends State<SalesFollowupsPage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  bool _isLoading = true;
  bool _isActionLoading = false;
  String _selectedScope = 'All Organization';
  String _selectedStatus = 'Pending';
  CrmFollowUpType? _selectedType;

  List<FollowUpRecord> _followups = [];

  @override
  void initState() {
    super.initState();
    _loadFollowUps();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadFollowUps({bool preserveScroll = true}) async {
    final double savedOffset = _scrollController.hasClients ? _scrollController.offset : 0.0;
    setState(() => _isLoading = true);

    final results = await SalesRepository.instance.getFollowUps(
      type: _selectedType,
      status: _selectedStatus == 'All' ? null : _selectedStatus,
    );

    if (!mounted) return;
    setState(() {
      _followups = results;
      _isLoading = false;
    });

    if (preserveScroll) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          final max = _scrollController.position.maxScrollExtent;
          _scrollController.jumpTo(savedOffset.clamp(0.0, max));
        }
      });
    }
  }

  Future<void> _toggleComplete(FollowUpRecord f) async {
    final double savedOffset = _scrollController.hasClients ? _scrollController.offset : 0.0;
    setState(() => _isActionLoading = true);

    await SalesRepository.instance.toggleFollowUpComplete(f.id);
    await _loadFollowUps(preserveScroll: false);
    if (!mounted) return;
    setState(() => _isActionLoading = false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(savedOffset.clamp(0.0, _scrollController.position.maxScrollExtent));
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Follow-up for ${f.clientName} marked as ${f.isCompleted ? "Pending" : "Completed"}'),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showRescheduleDialog(FollowUpRecord f) {
    DateTime selectedDate = DateTime.now().add(const Duration(days: 1));
    TimeOfDay selectedTime = const TimeOfDay(hour: 11, minute: 0);

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDlgState) => AlertDialog(
          title: Text('Reschedule Follow-up for ${f.clientName}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.calendar_today_rounded, color: AppColors.primary),
                title: Text('${selectedDate.day}/${selectedDate.month}/${selectedDate.year}'),
                trailing: const Icon(Icons.edit_calendar_rounded),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 90)),
                  );
                  if (picked != null) setDlgState(() => selectedDate = picked);
                },
              ),
              ListTile(
                leading: const Icon(Icons.access_time_rounded, color: AppColors.primary),
                title: Text(selectedTime.format(context)),
                trailing: const Icon(Icons.access_time),
                onTap: () async {
                  final picked = await showTimePicker(
                    context: context,
                    initialTime: selectedTime,
                  );
                  if (picked != null) setDlgState(() => selectedTime = picked);
                },
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            FilledButton(
              onPressed: () async {
                Navigator.pop(ctx);
                final dateStr = '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}';
                final timeStr = selectedTime.format(context);
                await SalesRepository.instance.rescheduleFollowUp(f.id, dateStr, timeStr);
                _loadFollowUps(preserveScroll: true);
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Follow-up rescheduled to $dateStr at $timeStr'),
                    backgroundColor: AppColors.primary,
                  ),
                );
              },
              child: const Text('Confirm Reschedule'),
            ),
          ],
        ),
      ),
    );
  }

  void _openLeadDetail(String leadId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => LeadDetail360Modal(
        leadId: leadId,
        onLeadUpdated: () => _loadFollowUps(preserveScroll: true),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenType = AdaptiveLayout.getScreenType(context);
    final isDesktop = screenType == ScreenType.desktop || screenType == ScreenType.laptop;

    // Follow-up statistics
    final overdueCount = _followups.where((f) => f.dueDate.toLowerCase().contains('yesterday') && !f.isCompleted).length;
    final todayCount = _followups.where((f) => f.dueDate.toLowerCase().contains('today') && !f.isCompleted).length;
    final completedCount = _followups.where((f) => f.isCompleted).length;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: Column(
        children: [
          // Header
          CrmHeader(
            title: 'Follow-ups & Cadence Hub',
            subtitle: 'Schedule, execute, and monitor phone, WhatsApp, email, and site visit follow-ups.',
            scope: _selectedScope,
            onScopeChanged: (val) {
              setState(() => _selectedScope = val);
              _loadFollowUps(preserveScroll: true);
            },
            onRefresh: () => _loadFollowUps(preserveScroll: true),
            actionButtons: [
              FilledButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Quick schedule follow-up dialog launched')),
                  );
                },
                icon: const Icon(Icons.add_task_rounded, size: 18),
                label: const Text('Schedule Follow-up'),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
              ),
            ],
          ),

          DashboardInlineLoadingIndicator(isLoading: _isActionLoading),

          // Main View Body
          Expanded(
            child: _isLoading && _followups.isEmpty
                ? const DashboardSkeleton(itemCount: 6, height: 75)
                : RefreshIndicator(
                    onRefresh: () => _loadFollowUps(preserveScroll: true),
                    child: SingleChildScrollView(
                      key: const PageStorageKey('sales_followups_page_scroll'),
                      controller: _scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // KPI Metric Strip
                          _buildKpiStrip(overdueCount, todayCount, completedCount, _followups.length, isDark, isDesktop),
                          const SizedBox(height: 16),

                          // Filter Bar
                          _buildFilterBar(isDark),
                          const SizedBox(height: 16),

                          // Follow-ups List
                          _buildFollowupList(isDark),
                          const SizedBox(height: 48),
                        ],
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildKpiStrip(int overdue, int today, int completed, int total, bool isDark, bool isDesktop) {
    final cards = [
      _buildMiniKpi(
        title: 'Overdue Follow-ups',
        value: '$overdue Overdue',
        subtitle: 'Immediate action required',
        icon: Icons.warning_amber_rounded,
        color: Colors.redAccent,
        isDark: isDark,
      ),
      _buildMiniKpi(
        title: 'Due Today',
        value: '$today Calls / Tasks',
        subtitle: 'Scheduled for today',
        icon: Icons.today_rounded,
        color: Colors.blue,
        isDark: isDark,
      ),
      _buildMiniKpi(
        title: 'Completed',
        value: '$completed Done',
        subtitle: 'Successfully closed cadences',
        icon: Icons.task_alt_rounded,
        color: Colors.green,
        isDark: isDark,
      ),
      _buildMiniKpi(
        title: 'Total Active Cadences',
        value: '$total Registered',
        subtitle: 'Full pipeline cadence queue',
        icon: Icons.format_list_bulleted_rounded,
        color: AppColors.primary,
        isDark: isDark,
      ),
    ];

    if (isDesktop) {
      return Row(
        children: cards.map((c) => Expanded(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 6), child: c))).toList(),
      );
    } else {
      return Column(
        children: cards.map((c) => Padding(padding: const EdgeInsets.only(bottom: 10), child: c)).toList(),
      );
    }
  }

  Widget _buildMiniKpi({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 2),
                Text(subtitle, style: TextStyle(fontSize: 10, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Wrap(
        spacing: 12,
        runSpacing: 10,
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              // Status selector
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(value: 'Pending', label: Text('Pending', style: TextStyle(fontSize: 12))),
                  ButtonSegment(value: 'Completed', label: Text('Completed', style: TextStyle(fontSize: 12))),
                  ButtonSegment(value: 'All', label: Text('All', style: TextStyle(fontSize: 12))),
                ],
                selected: {_selectedStatus},
                onSelectionChanged: (set) {
                  setState(() => _selectedStatus = set.first);
                  _loadFollowUps(preserveScroll: true);
                },
                style: SegmentedButton.styleFrom(visualDensity: VisualDensity.compact),
              ),

              // Type Filter
              DropdownButtonHideUnderline(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButton<CrmFollowUpType?>(
                    value: _selectedType,
                    isDense: true,
                    hint: const Text('All Types', style: TextStyle(fontSize: 12)),
                    items: [
                      const DropdownMenuItem(value: null, child: Text('All Types', style: TextStyle(fontSize: 12))),
                      ...CrmFollowUpType.values.map(
                        (t) => DropdownMenuItem(
                          value: t,
                          child: Text(t.displayName, style: const TextStyle(fontSize: 12)),
                        ),
                      ),
                    ],
                    onChanged: (val) {
                      setState(() => _selectedType = val);
                      _loadFollowUps(preserveScroll: true);
                    },
                  ),
                ),
              ),
            ],
          ),
          Text(
            '${_followups.length} follow-ups in queue',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFollowupList(bool isDark) {
    if (_followups.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
        ),
        child: Column(
          children: [
            Icon(Icons.check_circle_outline_rounded, size: 48, color: Colors.grey.shade400),
            const SizedBox(height: 12),
            const Text('No follow-ups match selected filter', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            const SizedBox(height: 4),
            Text('All cadences are up to date!', style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
          ],
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _followups.length,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (context, idx) {
        final f = _followups[idx];
        final isOverdue = f.dueDate.toLowerCase().contains('yesterday') && !f.isCompleted;
        final isToday = f.dueDate.toLowerCase().contains('today') && !f.isCompleted;

        return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isOverdue
                  ? Colors.redAccent.withValues(alpha: 0.5)
                  : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Checkbox to complete
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Checkbox(
                  value: f.isCompleted,
                  onChanged: (val) => _toggleComplete(f),
                  activeColor: AppColors.success,
                ),
              ),
              const SizedBox(width: 8),

              // Type Icon
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: f.type.color.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(f.type.icon, color: f.type.color, size: 18),
              ),
              const SizedBox(width: 14),

              // Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        InkWell(
                          onTap: () => _openLeadDetail(f.leadId),
                          child: Text(
                            f.clientName,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              decoration: f.isCompleted ? TextDecoration.lineThrough : null,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: isDark ? Colors.white10 : Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            f.leadId,
                            style: TextStyle(
                              fontSize: 10,
                              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                            ),
                          ),
                        ),
                        const Spacer(),
                        if (isOverdue)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.redAccent.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text('OVERDUE', style: TextStyle(color: Colors.redAccent, fontSize: 10, fontWeight: FontWeight.bold)),
                          )
                        else if (isToday)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.blue.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text('TODAY', style: TextStyle(color: Colors.blue, fontSize: 10, fontWeight: FontWeight.bold)),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      f.note,
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.access_time_rounded, size: 13, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                        const SizedBox(width: 4),
                        Text(
                          '${f.dueDate} at ${f.dueTime}',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: isOverdue ? Colors.redAccent : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Icon(Icons.person_outline_rounded, size: 13, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                        const SizedBox(width: 4),
                        Text(
                          f.assignedRep,
                          style: TextStyle(fontSize: 11, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Action Buttons
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.phone_outlined, size: 18, color: Colors.blue),
                    tooltip: 'Call',
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Calling ${f.clientName} (${f.phone})...')),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.chat_bubble_outline_rounded, size: 18, color: Colors.green),
                    tooltip: 'WhatsApp',
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('WhatsApp ${f.clientName}...')),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit_calendar_rounded, size: 18, color: Colors.orange),
                    tooltip: 'Reschedule',
                    onPressed: () => _showRescheduleDialog(f),
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
