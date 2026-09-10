import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/responsive/breakpoints.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_radius.dart';
import '../data/hrms_repository.dart';
import '../domain/hrms_domain_models.dart';
import '../domain/hrms_enums.dart';
import '../widgets/hrms_header.dart';
import '../widgets/hrms_metric_card.dart';
import '../widgets/hrms_data_table.dart';
import '../widgets/performance_review_dialog.dart';

class HrmsPerformancePage extends StatefulWidget {
  const HrmsPerformancePage({super.key});

  @override
  State<HrmsPerformancePage> createState() => _HrmsPerformancePageState();
}

class _HrmsPerformancePageState extends State<HrmsPerformancePage> with SingleTickerProviderStateMixin {
  final _repo = HrmsRepository();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _repo.addListener(_onRepoChanged);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _repo.removeListener(_onRepoChanged);
    super.dispose();
  }

  void _onRepoChanged() {
    if (mounted) setState(() {});
  }

  void _openAddGoalDialog() {
    final titleCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    final targetCtrl = TextEditingController(text: '100');
    final unitCtrl = TextEditingController(text: 'INR Lacs');
    String selectedEmpId = _repo.employees.first.id;

    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500),
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF131722) : Colors.white,
            borderRadius: AppRadius.lg,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Create Employee OKR Goal', style: GoogleFonts.plusJakartaSans(fontSize: 15, fontWeight: FontWeight.w700)),
              const SizedBox(height: AppSpacing.sm),
              DropdownButtonFormField<String>(
                initialValue: selectedEmpId,
                decoration: const InputDecoration(labelText: 'Assigned Personnel'),
                items: _repo.employees.map((e) => DropdownMenuItem(value: e.id, child: Text(e.fullName))).toList(),
                onChanged: (v) => selectedEmpId = v!,
              ),
              const SizedBox(height: AppSpacing.sm),
              TextField(
                controller: titleCtrl,
                decoration: const InputDecoration(labelText: 'Goal Title', hintText: 'e.g. Turnkey Villa Sales Target'),
              ),
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: targetCtrl,
                      decoration: const InputDecoration(labelText: 'Target Value', hintText: '250'),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: TextField(
                      controller: unitCtrl,
                      decoration: const InputDecoration(labelText: 'Metric Unit', hintText: 'INR Lacs'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              TextField(
                controller: descCtrl,
                maxLines: 2,
                decoration: const InputDecoration(labelText: 'Detailed Objectives & Milestones'),
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
                  const SizedBox(width: AppSpacing.sm),
                  ElevatedButton(
                    onPressed: () {
                      if (titleCtrl.text.isEmpty) return;
                      _repo.addGoal(
                        Goal(
                          id: 'goal_${DateTime.now().millisecondsSinceEpoch}',
                          employeeId: selectedEmpId,
                          title: titleCtrl.text.trim(),
                          description: descCtrl.text.trim(),
                          category: 'Corporate Growth',
                          targetValue: double.tryParse(targetCtrl.text) ?? 100.0,
                          currentValue: 0.0,
                          metricUnit: unitCtrl.text.trim(),
                          startDate: DateTime.now(),
                          dueDate: DateTime.now().add(const Duration(days: 90)),
                        ),
                      );
                      Navigator.of(ctx).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('OKR Goal created and assigned!')),
                      );
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
                    child: const Text('Save Goal'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isCompact = MediaQuery.of(context).size.width < 768;

    final goals = _repo.goals;
    final reviews = _repo.performanceReviews;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0B0E14) : const Color(0xFFF1F5F9),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isCompact ? AppSpacing.md : AppSpacing.lg),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: Breakpoints.maxContentWidth),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                HrmsHeader(
                  title: 'Performance Management & OKRs Appraisal',
                  subtitle: 'Corporate milestone tracking, quarterly appraisal scorecards, KPI rating rubrics & merit promotion workflows',
                  icon: Icons.insights_rounded,
                  badgeText: 'Q3 APPRAISAL RUNNING',
                  badgeColor: const Color(0xFF8B5CF6),
                  actions: [
                    OutlinedButton.icon(
                      onPressed: _openAddGoalDialog,
                      style: OutlinedButton.styleFrom(
                        visualDensity: VisualDensity.compact,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      icon: const Icon(Icons.add_task, size: 16),
                      label: Text('New OKR Goal', style: GoogleFonts.plusJakartaSans(fontSize: 12)),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => PerformanceReviewDialog.show(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8B5CF6),
                        foregroundColor: Colors.white,
                        visualDensity: VisualDensity.compact,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      ),
                      icon: const Icon(Icons.rate_review_outlined, size: 16),
                      label: Text('Conduct Appraisal', style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),

                // Metrics
                _buildMetrics(context, goals, reviews, isCompact),
                const SizedBox(height: AppSpacing.md),

                // Tab Bar
                Container(
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF131722) : Colors.white,
                    borderRadius: AppRadius.lg,
                    border: Border.all(color: isDark ? Colors.white.withValues(alpha: 0.08) : Colors.black.withValues(alpha: 0.06)),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    labelColor: const Color(0xFF8B5CF6),
                    unselectedLabelColor: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                    indicatorColor: const Color(0xFF8B5CF6),
                    tabs: const [
                      Tab(icon: Icon(Icons.track_changes, size: 16), text: 'OKR Goals & Deliverables'),
                      Tab(icon: Icon(Icons.grading_rounded, size: 16), text: 'Appraisal Reviews & Scorecards'),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),

                // Tab Content
                SizedBox(
                  height: 600,
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      // Tab 1: OKR Goals
                      _buildGoalsTab(goals, isDark),

                      // Tab 2: Appraisal Reviews Table
                      _buildReviewsTab(reviews, isDark),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMetrics(BuildContext context, List<Goal> goals, List<PerformanceReview> reviews, bool isCompact) {
    final avgScore = reviews.isNotEmpty
        ? (reviews.fold<double>(0.0, (s, r) => s + r.overallScore) / reviews.length).toStringAsFixed(1)
        : '4.6';

    final cards = [
      HrmsMetricCard(
        title: 'Average Org Rating',
        value: '$avgScore / 5.0',
        subtitle: 'High-Performance Benchmark',
        icon: Icons.star_rounded,
        accentColor: const Color(0xFFF59E0B),
      ),
      HrmsMetricCard(
        title: 'Active OKR Goals',
        value: '${goals.length} Strategic Goals',
        subtitle: '85% Average Progress',
        icon: Icons.track_changes_rounded,
        accentColor: const Color(0xFF3B82F6),
      ),
      HrmsMetricCard(
        title: 'Merit Increments Approved',
        value: '2 Top Performers',
        subtitle: 'Promotions Queued',
        icon: Icons.workspace_premium_rounded,
        accentColor: const Color(0xFF10B981),
      ),
      HrmsMetricCard(
        title: 'Reviews Conducted',
        value: '${reviews.length} Appraisals',
        subtitle: 'Q3 Assessment Cycle',
        icon: Icons.fact_check_rounded,
        accentColor: const Color(0xFF8B5CF6),
      ),
    ];

    if (isCompact) {
      return Column(children: cards.map((c) => Padding(padding: const EdgeInsets.only(bottom: 8), child: c)).toList());
    }
    return Row(children: cards.map((c) => Expanded(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 4), child: c))).toList());
  }

  Widget _buildGoalsTab(List<Goal> goals, bool isDark) {
    return ListView.separated(
      itemCount: goals.length,
      separatorBuilder: (ctx, idx) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final g = goals[index];
        final pct = (g.progressPercentage).clamp(0.0, 100.0);
        final color = pct >= 100.0 ? const Color(0xFF10B981) : const Color(0xFF3B82F6);

        return Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF131722) : Colors.white,
            borderRadius: AppRadius.lg,
            border: Border.all(color: isDark ? Colors.white.withValues(alpha: 0.08) : Colors.black.withValues(alpha: 0.06)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.12),
                          borderRadius: AppRadius.sm,
                        ),
                        child: Text(g.category, style: GoogleFonts.plusJakartaSans(fontSize: 10, fontWeight: FontWeight.w700, color: color)),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        g.title,
                        style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w700, color: isDark ? Colors.white : const Color(0xFF0F172A)),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: g.status.color.withValues(alpha: 0.12),
                      borderRadius: AppRadius.full,
                    ),
                    child: Text(
                      g.status.label,
                      style: GoogleFonts.plusJakartaSans(fontSize: 10, fontWeight: FontWeight.w600, color: g.status.color),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                g.description,
                style: GoogleFonts.plusJakartaSans(fontSize: 12, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
              ),
              const SizedBox(height: AppSpacing.md),

              // Progress Bar & Numbers
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Pacing: ${g.currentValue.toStringAsFixed(1)} / ${g.targetValue.toStringAsFixed(1)} ${g.metricUnit}',
                    style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w600, color: isDark ? Colors.white70 : const Color(0xFF334155)),
                  ),
                  Text(
                    '${pct.toStringAsFixed(0)}%',
                    style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w800, color: color),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: pct / 100.0,
                  backgroundColor: isDark ? Colors.white10 : Colors.black12,
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                  minHeight: 6,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildReviewsTab(List<PerformanceReview> reviews, bool isDark) {
    return HrmsDataTable(
      columns: const [
        HrmsDataColumn(title: 'EMPLOYEE & DEPT'),
        HrmsDataColumn(title: 'REVIEW PERIOD & CADENCE'),
        HrmsDataColumn(title: 'OVERALL SCORE'),
        HrmsDataColumn(title: 'KEY KPI HIGHLIGHTS'),
        HrmsDataColumn(title: 'MANAGEMENT RECOMMENDATION'),
      ],
      currentPage: 1,
      totalPages: 1,
      totalRecords: reviews.length,
      rows: reviews.map((r) {
        return [
          // Employee
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(r.employeeName, style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700, color: isDark ? Colors.white : const Color(0xFF0F172A))),
              Text(r.departmentName, style: GoogleFonts.plusJakartaSans(fontSize: 10, color: const Color(0xFF94A3B8))),
            ],
          ),

          // Period
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(r.reviewPeriod, style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w600)),
              Text(r.reviewType.label, style: GoogleFonts.plusJakartaSans(fontSize: 10, color: const Color(0xFF94A3B8))),
            ],
          ),

          // Score Badge
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.star, size: 16, color: Color(0xFFF59E0B)),
              const SizedBox(width: 4),
              Text('${r.overallScore} / 5.0', style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w800, color: const Color(0xFFF59E0B))),
            ],
          ),

          // KPI scores preview
          Text(
            r.kpiScores.entries.map((e) => '${e.key}: ${e.value}').join(', '),
            style: GoogleFonts.plusJakartaSans(fontSize: 10, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          // Recommendation
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: const Color(0xFF8B5CF6).withValues(alpha: 0.12),
              borderRadius: AppRadius.sm,
            ),
            child: Text(
              r.recommendation,
              style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w600, color: const Color(0xFF8B5CF6)),
            ),
          ),
        ];
      }).toList(),
    );
  }
}
