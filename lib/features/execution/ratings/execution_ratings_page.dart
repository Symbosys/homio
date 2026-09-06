import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../models/execution_models.dart';
import '../models/execution_mock_data.dart';
import '../widgets/execution_header.dart';
import '../widgets/execution_metric_card.dart';
import '../widgets/stakeholder_rating_modal.dart';

class ExecutionRatingsPage extends StatefulWidget {
  const ExecutionRatingsPage({super.key});

  @override
  State<ExecutionRatingsPage> createState() => _ExecutionRatingsPageState();
}

class _ExecutionRatingsPageState extends State<ExecutionRatingsPage> {
  late List<ProjectMaster> _projects;
  String? _selectedProjectId;
  StakeholderType? _filterType;

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

  List<StakeholderRating> get _filteredRatings {
    final proj = _currentProject;
    if (proj == null) return [];

    return proj.ratings.where((r) {
      if (_filterType != null && r.type != _filterType) return false;
      return true;
    }).toList();
  }

  void _handleAddRating() {
    final proj = _currentProject;
    if (proj == null) return;

    StakeholderRatingModal.show(
      context: context,
      project: proj,
      onSubmit: (newRating) {
        setState(() {
          proj.ratings.insert(0, newRating);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Quality rating for ${newRating.stakeholderName} logged!'),
            backgroundColor: AppColors.success,
          ),
        );
      },
    );
  }

  void _handleEditRating(StakeholderRating rating) {
    final proj = _currentProject;
    if (proj == null) return;

    StakeholderRatingModal.show(
      context: context,
      project: proj,
      initialRating: rating,
      onSubmit: (updated) {
        setState(() {
          final idx = proj.ratings.indexWhere((r) => r.id == updated.id);
          if (idx != -1) {
            proj.ratings[idx] = updated;
          }
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Rating for ${updated.stakeholderName} updated.'),
            backgroundColor: AppColors.primary,
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
    final ratings = _filteredRatings;

    // Averages
    double totalScoreSum = 0;
    int ratedCount = proj?.ratings.length ?? 0;
    if (proj != null) {
      for (final r in proj.ratings) {
        totalScoreSum += r.overallScore;
      }
    }
    final overallAvg = ratedCount > 0 ? totalScoreSum / ratedCount : 4.5;

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            ExecutionHeader(
              title: '360° Multi-Stakeholder Quality Ratings',
              subtitle: 'Performance scorecards for site supervisors, contractors, vendors, and interior designers',
              primaryActionLabel: 'Log Quality Rating',
              primaryActionIcon: Icons.star_rate_outlined,
              onPrimaryAction: _handleAddRating,
              actions: [
                OutlinedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Exporting Stakeholder Performance Report Card PDF...')),
                    );
                  },
                  icon: const Icon(Icons.picture_as_pdf_outlined, size: 18),
                  label: const Text('Export Report Card'),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Metrics Cards
            Row(
              children: [
                Expanded(
                  child: ExecutionMetricCard(
                    title: 'Overall Quality Index',
                    value: '${overallAvg.toStringAsFixed(1)} ★',
                    subtitle: 'Across all active stakeholders',
                    icon: Icons.stars,
                    color: AppColors.warning,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: ExecutionMetricCard(
                    title: 'Total Audits Logged',
                    value: '$ratedCount',
                    subtitle: 'Multi-criteria evaluations',
                    icon: Icons.assignment_turned_in_outlined,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: ExecutionMetricCard(
                    title: 'Top Performing Trade',
                    value: 'Carpentry',
                    subtitle: '4.8 ★ average score',
                    icon: Icons.thumb_up_alt_outlined,
                    color: AppColors.success,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: ExecutionMetricCard(
                    title: 'Action Required',
                    value: 'Civil Masonry',
                    subtitle: '3.6 ★ timeliness score',
                    icon: Icons.warning_amber_rounded,
                    color: AppColors.error,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Project & Stakeholder Role Filter Bar
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
                  const SizedBox(width: 12),
                  // Stakeholder Filter Chips
                  FilterChip(
                    label: const Text('All Roles'),
                    selected: _filterType == null,
                    selectedColor: AppColors.primary.withValues(alpha: 0.15),
                    onSelected: (_) => setState(() => _filterType = null),
                  ),
                  ...StakeholderType.values.map((type) {
                    final isSel = _filterType == type;
                    return FilterChip(
                      label: Text(type.label),
                      selected: isSel,
                      selectedColor: AppColors.primary.withValues(alpha: 0.15),
                      checkmarkColor: AppColors.primary,
                      onSelected: (_) => setState(() => _filterType = isSel ? null : type),
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Rating Cards Grid
            if (ratings.isEmpty)
              Container(
                padding: const EdgeInsets.all(48),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkCard : AppColors.lightCard,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.rate_review_outlined, size: 48, color: AppColors.primary),
                    const SizedBox(height: 12),
                    Text(
                      'No stakeholder evaluations logged for this selection.',
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    const Text('Click "Log Quality Rating" to score a supervisor, contractor, or vendor.'),
                  ],
                ),
              )
            else
              LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth > 900;
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: isWide ? 2 : 1,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      mainAxisExtent: 310,
                    ),
                    itemCount: ratings.length,
                    itemBuilder: (context, idx) {
                      final r = ratings[idx];
                      return _buildRatingCard(r, isDark, theme);
                    },
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingCard(StakeholderRating rating, bool isDark, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Name, Type, Score
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                child: Icon(_getRoleIcon(rating.type), color: AppColors.primary, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      rating.stakeholderName,
                      style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '${rating.type.label} • ${rating.roleTitle}',
                      style: TextStyle(
                        fontSize: 11,
                        color: isDark ? AppColors.darkMutedText : AppColors.lightMutedText,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.warning.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.star, color: AppColors.warning, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      rating.overallScore.toStringAsFixed(1),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: AppColors.warning,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(),
          const SizedBox(height: 8),

          // Criteria breakdown
          Column(
            children: rating.criteriaScores.entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: Text(
                        entry.key,
                        style: const TextStyle(fontSize: 12),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(3),
                        child: LinearProgressIndicator(
                          value: entry.value / 5.0,
                          minHeight: 5,
                          backgroundColor: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                          color: entry.value >= 4.0
                              ? AppColors.success
                              : (entry.value >= 3.0 ? AppColors.warning : AppColors.error),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 28,
                      child: Text(
                        entry.value.toStringAsFixed(1),
                        textAlign: TextAlign.end,
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
          const Spacer(),

          // Feedback quote & Edit button
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '"${rating.feedback}"',
              style: const TextStyle(fontSize: 11, fontStyle: FontStyle.italic),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Rated by ${rating.ratedBy} on ${rating.ratedAt.day}/${rating.ratedAt.month}/${rating.ratedAt.year}',
                style: TextStyle(
                  fontSize: 10,
                  color: isDark ? AppColors.darkMutedText : AppColors.lightMutedText,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit_outlined, size: 16),
                onPressed: () => _handleEditRating(rating),
                tooltip: 'Edit Scorecard',
              ),
            ],
          ),
        ],
      ),
    );
  }

  IconData _getRoleIcon(StakeholderType type) {
    switch (type) {
      case StakeholderType.siteSupervisor:
        return Icons.person_pin;
      case StakeholderType.labourContractor:
        return Icons.handyman_outlined;
      case StakeholderType.materialVendor:
        return Icons.local_shipping_outlined;
      case StakeholderType.interiorDesigner:
        return Icons.brush_outlined;
    }
  }
}
