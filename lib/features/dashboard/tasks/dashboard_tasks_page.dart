import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../models/dashboard_mock_data.dart';
import '../models/dashboard_models.dart';
import '../widgets/compact_data_table.dart';
import '../widgets/dashboard_charts.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/dashboard_metric_card.dart';

/// Today's Tasks & Followups screen with interactive checklist,
/// calling queue, priority breakdown charts, and quick task creation.
class DashboardTasksPage extends StatefulWidget {
  const DashboardTasksPage({super.key});

  @override
  State<DashboardTasksPage> createState() => _DashboardTasksPageState();
}

class _DashboardTasksPageState extends State<DashboardTasksPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  DashboardDateFilter _dateFilter = DashboardDateFilter.today;
  String _selectedPriority = 'All';
  String _searchQuery = '';
  final List<DashboardTaskItem> _tasks = List.from(DashboardMockData.tasks);
  final List<DashboardFollowupItem> _followups = List.from(DashboardMockData.followups);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _toggleTaskCompletion(int index) {
    setState(() {
      final task = _tasks[index];
      _tasks[index] = task.copyWith(isCompleted: !task.isCompleted);
    });
  }

  void _openCreateTaskDialog() {
    final titleController = TextEditingController();
    final clientController = TextEditingController();
    String priority = 'high';
    String category = 'Design Review';

    showDialog(
      context: context,
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
              shape: RoundedRectangleBorder(borderRadius: AppRadius.md),
              titlePadding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              contentPadding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              title: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.12),
                      borderRadius: AppRadius.sm,
                    ),
                    child: const Icon(Icons.add_task, size: 16, color: AppColors.primary),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Create New Task',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : AppColors.lightTextPrimary,
                    ),
                  ),
                ],
              ),
              content: SizedBox(
                width: 420,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Task Title',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    TextField(
                      controller: titleController,
                      style: GoogleFonts.inter(fontSize: 12),
                      decoration: InputDecoration(
                        hintText: 'e.g., Send updated 3D CAD elevations',
                        hintStyle: GoogleFonts.inter(fontSize: 12),
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        border: OutlineInputBorder(borderRadius: AppRadius.sm),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Client / Project Name',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    TextField(
                      controller: clientController,
                      style: GoogleFonts.inter(fontSize: 12),
                      decoration: InputDecoration(
                        hintText: 'e.g., Villa Sapphire / Mr. Rohit Sharma',
                        hintStyle: GoogleFonts.inter(fontSize: 12),
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        border: OutlineInputBorder(borderRadius: AppRadius.sm),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Priority',
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              DropdownButtonFormField<String>(
                                initialValue: priority,
                                isDense: true,
                                style: GoogleFonts.inter(
                                  fontSize: 11.5,
                                  color: isDark ? Colors.white : Colors.black,
                                ),
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                  border: OutlineInputBorder(borderRadius: AppRadius.sm),
                                ),
                                items: const [
                                  DropdownMenuItem(value: 'urgent', child: Text('Urgent')),
                                  DropdownMenuItem(value: 'high', child: Text('High')),
                                  DropdownMenuItem(value: 'medium', child: Text('Medium')),
                                  DropdownMenuItem(value: 'low', child: Text('Low')),
                                ],
                                onChanged: (val) {
                                  if (val != null) setDialogState(() => priority = val);
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Category',
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              DropdownButtonFormField<String>(
                                initialValue: category,
                                isDense: true,
                                style: GoogleFonts.inter(
                                  fontSize: 11.5,
                                  color: isDark ? Colors.white : Colors.black,
                                ),
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                  border: OutlineInputBorder(borderRadius: AppRadius.sm),
                                ),
                                items: const [
                                  DropdownMenuItem(value: 'Design Review', child: Text('Design')),
                                  DropdownMenuItem(value: 'Site Inspection', child: Text('Site')),
                                  DropdownMenuItem(value: 'Client Meeting', child: Text('Client')),
                                  DropdownMenuItem(value: 'Billing', child: Text('Billing')),
                                ],
                                onChanged: (val) {
                                  if (val != null) setDialogState(() => category = val);
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Cancel',
                    style: GoogleFonts.inter(fontSize: 12, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (titleController.text.trim().isNotEmpty) {
                      setState(() {
                        _tasks.insert(
                          0,
                          DashboardTaskItem(
                            id: 'tsk-${DateTime.now().millisecondsSinceEpoch}',
                            title: titleController.text.trim(),
                            clientName: clientController.text.trim().isEmpty ? 'General Ops' : clientController.text.trim(),
                            dueTime: 'Today 05:00 PM',
                            priority: priority,
                            category: category,
                            isCompleted: false,
                            assignedTo: 'You',
                          ),
                        );
                      });
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Task added successfully', style: GoogleFonts.inter(fontSize: 12)),
                          duration: const Duration(seconds: 2),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
                  ),
                  child: Text('Save Task', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _logFollowupOutcome(DashboardFollowupItem item) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Followup logged for ${item.clientName}', style: GoogleFonts.inter(fontSize: 12)),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 768;
    final isTablet = width >= 768 && width < 1100;

    final filteredTasks = _tasks.where((t) {
      final matchesPriority = _selectedPriority == 'All' || t.priority.toLowerCase() == _selectedPriority.toLowerCase();
      final matchesSearch = _searchQuery.isEmpty ||
          t.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          t.clientName.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesPriority && matchesSearch;
    }).toList();

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 12 : 20,
            vertical: 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              DashboardHeader(
                title: "Today's Tasks & Followups",
                subtitle: 'Manage time-sensitive client deliverables, scheduled followups & call pipeline',
                icon: Icons.checklist_rtl_outlined,
                activeFilter: _dateFilter,
                onFilterChanged: (val) => setState(() => _dateFilter = val),
                primaryAction: ElevatedButton.icon(
                  onPressed: _openCreateTaskDialog,
                  icon: const Icon(Icons.add, size: 14),
                  label: Text(
                    'New Task',
                    style: GoogleFonts.inter(fontSize: 11.5, fontWeight: FontWeight.w600),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                    shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
                  ),
                ),
              ),

              // KPI Metrics
              _buildKpis(isMobile, isTablet),
              const SizedBox(height: 18),

              // Charts Row: Priority Distribution Bar & Followup Conversion Trend
              _buildChartsRow(isDark, isMobile, isTablet),
              const SizedBox(height: 18),

              // Search & Filter Toolbar
              _buildToolbar(isDark, isMobile),
              const SizedBox(height: 14),

              // Tabs & Content Card
              _buildTabsSection(isDark, filteredTasks),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildKpis(bool isMobile, bool isTablet) {
    final kpis = DashboardMockData.taskKpis;
    final crossAxisCount = isMobile ? 1 : (isTablet ? 2 : 4);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisExtent: 118,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: kpis.length,
      itemBuilder: (context, index) {
        return DashboardMetricCard(metric: kpis[index]);
      },
    );
  }

  Widget _buildChartsRow(bool isDark, bool isMobile, bool isTablet) {
    if (isMobile || isTablet) {
      return Column(
        children: [
          DashboardTaskPriorityBarChart(tasks: _tasks),
          const SizedBox(height: 16),
          DashboardFollowupConversionChart(points: DashboardMockData.followupConversionTrend),
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 5,
          child: DashboardTaskPriorityBarChart(tasks: _tasks),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 5,
          child: DashboardFollowupConversionChart(points: DashboardMockData.followupConversionTrend),
        ),
      ],
    );
  }

  Widget _buildToolbar(bool isDark, bool isMobile) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: AppRadius.md,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildSearchInput(isDark),
                const SizedBox(height: 10),
                _buildPriorityChips(isDark),
              ],
            )
          : Row(
              children: [
                Expanded(flex: 4, child: _buildSearchInput(isDark)),
                const SizedBox(width: 14),
                Expanded(flex: 6, child: _buildPriorityChips(isDark)),
              ],
            ),
    );
  }

  Widget _buildSearchInput(bool isDark) {
    return SizedBox(
      height: 34,
      child: TextField(
        onChanged: (val) => setState(() => _searchQuery = val),
        style: GoogleFonts.inter(fontSize: 12, color: isDark ? Colors.white : AppColors.lightTextPrimary),
        decoration: InputDecoration(
          hintText: 'Search tasks, clients, projects...',
          hintStyle: GoogleFonts.inter(fontSize: 11.5, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
          prefixIcon: const Icon(Icons.search, size: 16),
          contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
          filled: true,
          fillColor: isDark ? AppColors.darkBackground : const Color(0xFFF8FAFC),
          border: OutlineInputBorder(
            borderRadius: AppRadius.sm,
            borderSide: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: AppRadius.sm,
            borderSide: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
          ),
        ),
      ),
    );
  }

  Widget _buildPriorityChips(bool isDark) {
    final priorities = ['All', 'Urgent', 'High', 'Medium', 'Low'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: priorities.map((p) {
          final isSelected = _selectedPriority.toLowerCase() == p.toLowerCase();
          return Padding(
            padding: const EdgeInsets.only(right: 6),
            child: ChoiceChip(
              label: Text(
                p,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected
                      ? Colors.white
                      : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                ),
              ),
              selected: isSelected,
              selectedColor: AppColors.primary,
              backgroundColor: isDark ? AppColors.darkBackground : const Color(0xFFF1F5F9),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: isSelected
                      ? AppColors.primary
                      : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                ),
              ),
              onSelected: (selected) {
                if (selected) setState(() => _selectedPriority = p);
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTabsSection(bool isDark, List<DashboardTaskItem> filteredTasks) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: AppRadius.md,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Tab bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TabBar(
                    controller: _tabController,
                    isScrollable: true,
                    tabAlignment: TabAlignment.start,
                    labelColor: AppColors.primary,
                    unselectedLabelColor: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    labelStyle: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600),
                    unselectedLabelStyle: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500),
                    indicatorColor: AppColors.primary,
                    indicatorSize: TabBarIndicatorSize.label,
                    dividerColor: Colors.transparent,
                    tabs: [
                      Tab(text: "Today's Task Checklist (${filteredTasks.length})"),
                      Tab(text: "Followup Call Queue (${_followups.length})"),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Tab content
          SizedBox(
            height: 480,
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildTasksTab(isDark, filteredTasks),
                _buildFollowupsTab(isDark),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTasksTab(bool isDark, List<DashboardTaskItem> tasks) {
    if (tasks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.done_all, size: 36, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
            const SizedBox(height: 8),
            Text(
              'No tasks matching current filter',
              style: GoogleFonts.inter(fontSize: 12, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 6),
      itemCount: tasks.length,
      separatorBuilder: (_, _) => Divider(
        height: 1,
        color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
      ),
      itemBuilder: (context, index) {
        final task = tasks[index];
        return InkWell(
          onTap: () {
            final origIndex = _tasks.indexWhere((t) => t.id == task.id);
            if (origIndex != -1) _toggleTaskCompletion(origIndex);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                Checkbox(
                  value: task.isCompleted,
                  activeColor: const Color(0xFF10B981),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                  visualDensity: VisualDensity.compact,
                  onChanged: (_) {
                    final origIndex = _tasks.indexWhere((t) => t.id == task.id);
                    if (origIndex != -1) _toggleTaskCompletion(origIndex);
                  },
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.title,
                        style: GoogleFonts.inter(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                          color: task.isCompleted
                              ? (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)
                              : (isDark ? Colors.white : AppColors.lightTextPrimary),
                        ),
                      ),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          Icon(Icons.business_outlined, size: 12, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                          const SizedBox(width: 4),
                          Text(
                            task.clientName,
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Icon(Icons.schedule, size: 12, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                          const SizedBox(width: 4),
                          Text(
                            task.dueTime,
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                            decoration: BoxDecoration(
                              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              task.category,
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                DashboardBadge(
                  label: task.priority.toUpperCase(),
                  color: task.priorityColor,
                ),
                PopupMenuButton<String>(
                  icon: Icon(Icons.more_vert, size: 16, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                  padding: EdgeInsets.zero,
                  itemBuilder: (context) => [
                    const PopupMenuItem(value: 'edit', child: Text('Edit Task', style: TextStyle(fontSize: 12))),
                    const PopupMenuItem(value: 'reschedule', child: Text('Reschedule', style: TextStyle(fontSize: 12))),
                    const PopupMenuItem(value: 'delete', child: Text('Delete', style: TextStyle(fontSize: 12, color: Colors.red))),
                  ],
                  onSelected: (val) {
                    if (val == 'delete') {
                      setState(() => _tasks.removeWhere((t) => t.id == task.id));
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFollowupsTab(bool isDark) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 6),
      itemCount: _followups.length,
      separatorBuilder: (_, _) => Divider(
        height: 1,
        color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
      ),
      itemBuilder: (context, index) {
        final item = _followups[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF2563EB).withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.phone_in_talk, size: 16, color: Color(0xFF2563EB)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          item.clientName,
                          style: GoogleFonts.inter(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white : AppColors.lightTextPrimary,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '•  ${item.phone}',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          item.scheduledTime,
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF2563EB),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${item.projectName} — "${item.notes}"',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              DashboardBadge(
                label: item.sentiment.toUpperCase(),
                color: item.sentimentColor,
              ),
              const SizedBox(width: 8),
              OutlinedButton.icon(
                onPressed: () => _logFollowupOutcome(item),
                icon: const Icon(Icons.check, size: 12),
                label: Text('Log Call', style: GoogleFonts.inter(fontSize: 11)),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  visualDensity: VisualDensity.compact,
                  side: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
