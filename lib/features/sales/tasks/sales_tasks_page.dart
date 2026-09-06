import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../models/sales_models.dart';
import '../models/sales_mock_data.dart';
import '../widgets/sales_header.dart';

class SalesTasksPage extends StatefulWidget {
  const SalesTasksPage({super.key});

  @override
  State<SalesTasksPage> createState() => _SalesTasksPageState();
}

class _SalesTasksPageState extends State<SalesTasksPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  SalesDateFilter _selectedDateFilter = SalesDateFilter.thisMonth;
  late List<SiteSurveyRecordItem> _surveys;
  late List<SalesFollowupTaskItem> _tasks;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _surveys = List<SiteSurveyRecordItem>.from(SalesMockData.siteSurveys);
    _tasks = List<SalesFollowupTaskItem>.from(SalesMockData.followupTasks);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 6),
            child: SalesHeader(
              title: 'Sales Tasks & Pre-Sales Site Surveys',
              subtitle: 'Precision 3D laser dimensions (L x W x H), CAD files, Vastu notes & closer SLAs',
              icon: Icons.checklist_rtl_rounded,
              activeFilter: _selectedDateFilter,
              onFilterChanged: (filter) => setState(() => _selectedDateFilter = filter),
              additionalFilters: [
                OutlinedButton.icon(
                  icon: const Icon(Icons.add_task_outlined, size: 14),
                  label: const Text('Add Task', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                  ),
                  onPressed: () => _showAddTaskModal(context),
                ),
              ],
              primaryAction: ElevatedButton.icon(
                icon: const Icon(Icons.straighten, size: 14),
                label: const Text('Log Survey', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                  elevation: 0,
                ),
                onPressed: () => _showAddSurveyModal(context),
              ),
            ),
          ),

          // Tabs
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              height: 36,
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder)),
              ),
              child: TabBar(
                controller: _tabController,
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                labelColor: const Color(0xFF2563EB),
                unselectedLabelColor: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                labelStyle: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700),
                tabs: const [
                  Tab(icon: Icon(Icons.architecture_outlined, size: 14), text: 'Laser Site Surveys'),
                  Tab(icon: Icon(Icons.checklist_rtl_rounded, size: 14), text: 'Follow-up Task Queue'),
                ],
              ),
            ),
          ),

          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildSurveysTab(context, isDark),
                _buildTasksTab(context, isDark),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSurveysTab(BuildContext context, bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
            ),
            child: Row(
              children: [
                const Icon(Icons.straighten, color: Color(0xFF10B981), size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Standardized Pre-Sales Laser Measurement Protocol',
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                        ),
                      ),
                      Text(
                        'Architects upload precision laser scans (L x W x H), beam drops & Vastu alignments before quotation release.',
                        style: TextStyle(fontSize: 10.5, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          ..._surveys.map((survey) {
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                survey.clientName,
                                style: TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w800,
                                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF10B981).withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(3),
                                ),
                                child: Text(
                                  survey.surveyId,
                                  style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: Color(0xFF059669)),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 1.5),
                          Text(
                            'Surveyed by ${survey.surveyorName} • ${survey.surveyDate} • ${survey.siteAddress}',
                            style: TextStyle(fontSize: 10, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                          ),
                        ],
                      ),
                      OutlinedButton.icon(
                        icon: const Icon(Icons.file_download_outlined, size: 12),
                        label: const Text('Export CAD', style: TextStyle(fontSize: 10)),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        ),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Downloading survey bundle for ${survey.clientName}')),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  Text(
                    'Laser Room Dimensions (L x W x H):',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final tableWidth = math.max(constraints.maxWidth, 660.0);
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: SizedBox(
                          width: tableWidth,
                          child: Table(
                            columnWidths: const {
                              0: FlexColumnWidth(2.0),
                              1: FlexColumnWidth(1.8),
                              2: FlexColumnWidth(1.4),
                              3: FlexColumnWidth(2.4),
                            },
                            children: [
                              TableRow(
                                decoration: BoxDecoration(
                                  color: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                                  borderRadius: BorderRadius.circular(3),
                                ),
                                children: const [
                                  _Th('Room / Zone'),
                                  _Th('Dimensions (L x W)'),
                                  _Th('Ceiling Height'),
                                  _Th('Plumbing & Notes'),
                                ],
                              ),
                              ...survey.roomMeasurements.map((m) {
                                return TableRow(
                                  decoration: BoxDecoration(
                                    border: Border(bottom: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder)),
                                  ),
                                  children: [
                                    _Td(m.roomName, isBold: true),
                                    _Td("${m.lengthFeet}' × ${m.widthFeet}'"),
                                    _Td("${m.ceilingHeightFeet}'"),
                                    _Td(m.notes),
                                  ],
                                );
                              }),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 8),

                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkSurfaceSubtle : const Color(0xFFFEF3C7).withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: const Color(0xFFF59E0B).withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.explore_outlined, color: Color(0xFFD97706), size: 15),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            'Vastu: ${survey.vastuFacing} • Budget Limit: ${survey.clientBudgetConstraint}',
                            style: TextStyle(
                              fontSize: 10,
                              color: isDark ? const Color(0xFFFDE68A) : const Color(0xFF92400E),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildTasksTab(BuildContext context, bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sales Closer Task Queue & SLA Monitor',
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      'Follow-up calls, BOQ commitments and site visit preparations',
                      style: TextStyle(fontSize: 11, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEF4444).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text('2 Overdue', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFFDC2626))),
                ),
              ],
            ),
            const SizedBox(height: 12),

            LayoutBuilder(
              builder: (context, constraints) {
                final tableWidth = math.max(constraints.maxWidth, 740.0);
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: tableWidth,
                    child: Table(
                      columnWidths: const {
                        0: FlexColumnWidth(2.8),
                        1: FlexColumnWidth(1.6),
                        2: FlexColumnWidth(1.0),
                        3: FlexColumnWidth(1.3),
                        4: FlexColumnWidth(1.0),
                      },
                      children: [
                        TableRow(
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          children: const [
                            _Th('Action Item / Task'),
                            _Th('Client Name'),
                            _Th('Priority'),
                            _Th('Due Time'),
                            _Th('Status'),
                          ],
                        ),
                        ..._tasks.map((task) {
                          return TableRow(
                            decoration: BoxDecoration(
                              border: Border(bottom: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder)),
                            ),
                            children: [
                              _Td(task.title, isBold: true),
                              _Td(task.clientName),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                                  decoration: BoxDecoration(
                                    color: task.priorityColor.withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                  child: Text(
                                    task.priority.toUpperCase(),
                                    style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: task.priorityColor),
                                  ),
                                ),
                              ),
                              _Td(task.dueTime),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: task.isCompleted ? const Color(0xFF10B981) : const Color(0xFF2563EB),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      final idx = _tasks.indexOf(task);
                                      _tasks[idx] = task.copyWith(isCompleted: !task.isCompleted);
                                    });
                                  },
                                  child: Text(task.isCompleted ? 'Done' : 'Mark', style: const TextStyle(fontSize: 9.5)),
                                ),
                              ),
                            ],
                          );
                        }),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showAddSurveyModal(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    InputDecoration modalInputDeco(String label) {
      return InputDecoration(
        labelText: label,
        labelStyle: TextStyle(fontSize: 11.5, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
        isDense: true,
        filled: true,
        fillColor: isDark ? AppColors.darkSurfaceSubtle : const Color(0xFFF8FAFC),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: Color(0xFF2563EB), width: 1.4),
        ),
      );
    }

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
        title: Text(
          'Log Laser Measurement Survey',
          style: TextStyle(
            fontSize: 14.5,
            fontWeight: FontWeight.w700,
            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
          ),
        ),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                decoration: modalInputDeco('Client / Project Name *'),
              ),
              const SizedBox(height: 10),
              TextFormField(
                style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                decoration: modalInputDeco('Architect / Surveyor Name *'),
              ),
              const SizedBox(height: 10),
              TextFormField(
                maxLines: 2,
                style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                decoration: modalInputDeco('Vastu & Direction Notes'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(fontSize: 11.5)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2563EB),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Laser measurement dossier saved.')));
            },
            child: const Text('Save Survey', style: TextStyle(fontSize: 11.5)),
          ),
        ],
      ),
    );
  }

  void _showAddTaskModal(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    InputDecoration modalInputDeco(String label) {
      return InputDecoration(
        labelText: label,
        labelStyle: TextStyle(fontSize: 11.5, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
        isDense: true,
        filled: true,
        fillColor: isDark ? AppColors.darkSurfaceSubtle : const Color(0xFFF8FAFC),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: Color(0xFF2563EB), width: 1.4),
        ),
      );
    }

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
        title: Text(
          'Create Follow-up Task',
          style: TextStyle(
            fontSize: 14.5,
            fontWeight: FontWeight.w700,
            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
          ),
        ),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                decoration: modalInputDeco('Task Title *'),
              ),
              const SizedBox(height: 10),
              TextFormField(
                style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                decoration: modalInputDeco('Client Name *'),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                initialValue: 'High Priority',
                style: TextStyle(fontSize: 11.5, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                dropdownColor: isDark ? AppColors.darkSurface : Colors.white,
                decoration: modalInputDeco('Priority Level'),
                items: ['Normal Priority', 'High Priority', 'Urgent Overdue'].map((p) => DropdownMenuItem(value: p, child: Text(p))).toList(),
                onChanged: (_) {},
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(fontSize: 11.5)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2563EB),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Sales task added.')));
            },
            child: const Text('Add Task', style: TextStyle(fontSize: 11.5)),
          ),
        ],
      ),
    );
  }
}

class _Th extends StatelessWidget {
  final String text;
  const _Th(this.text);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 6),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
        ),
      ),
    );
  }
}

class _Td extends StatelessWidget {
  final String text;
  final bool isBold;
  const _Td(this.text, {this.isBold = false});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10.5,
          fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
        ),
      ),
    );
  }
}
