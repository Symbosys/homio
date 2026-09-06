import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../models/execution_models.dart';

class StakeholderRatingModal extends StatefulWidget {
  final ProjectMaster project;
  final StakeholderRating? initialRating;
  final void Function(StakeholderRating rating) onSubmit;

  const StakeholderRatingModal({
    super.key,
    required this.project,
    this.initialRating,
    required this.onSubmit,
  });

  static Future<void> show({
    required BuildContext context,
    required ProjectMaster project,
    StakeholderRating? initialRating,
    required void Function(StakeholderRating rating) onSubmit,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => StakeholderRatingModal(
        project: project,
        initialRating: initialRating,
        onSubmit: onSubmit,
      ),
    );
  }

  @override
  State<StakeholderRatingModal> createState() => _StakeholderRatingModalState();
}

class _StakeholderRatingModalState extends State<StakeholderRatingModal> {
  final _formKey = GlobalKey<FormState>();
  late StakeholderType _selectedType;
  final _nameController = TextEditingController();
  final _roleController = TextEditingController();
  final _feedbackController = TextEditingController();

  // Ratings for 4 criteria (1 to 5)
  double _score1 = 4.0;
  double _score2 = 4.0;
  double _score3 = 4.0;
  double _score4 = 5.0;

  @override
  void initState() {
    super.initState();
    if (widget.initialRating != null) {
      final r = widget.initialRating!;
      _selectedType = r.type;
      _nameController.text = r.stakeholderName;
      _roleController.text = r.roleTitle;
      _feedbackController.text = r.feedback;
      _score1 = r.criteriaScores['Quality of Work'] ?? 4.0;
      _score2 = r.criteriaScores['Timeliness & Speed'] ?? 4.0;
      _score3 = r.criteriaScores['Communication & Coordination'] ?? 4.0;
      _score4 = r.criteriaScores['Safety & Cleanliness'] ?? 4.0;
    } else {
      _selectedType = StakeholderType.labourContractor;
      _nameController.text = 'Rajesh Sharma Construction';
      _roleController.text = 'Lead Civil & Masonry Contractor';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _roleController.dispose();
    _feedbackController.dispose();
    super.dispose();
  }

  List<String> get _criteriaLabels {
    switch (_selectedType) {
      case StakeholderType.siteSupervisor:
        return [
          'Daily Progress & Logs',
          'Snag Resolution Speed',
          'Punctuality & Site Presence',
          'Labour Coordination',
        ];
      case StakeholderType.labourContractor:
        return [
          'Craftsmanship Quality',
          'Execution Speed',
          'Safety & Site Cleanliness',
          'Blueprint Adherence',
        ];
      case StakeholderType.materialVendor:
        return [
          'Delivery Timeliness',
          'Material Grade Accuracy',
          'Packaging & Damage Control',
          'Invoicing Transparency',
        ];
      case StakeholderType.interiorDesigner:
        return [
          'Drawing Accuracy & Details',
          'Site Coordination',
          'Response Time on RFIs',
          'Client Expectation Alignment',
        ];
    }
  }

  double get _calculatedAverage => (_score1 + _score2 + _score3 + _score4) / 4.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final labels = _criteriaLabels;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 640),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.rate_review_outlined,
                        color: AppColors.primary,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.initialRating != null
                                ? 'Edit Stakeholder Rating'
                                : '360° Stakeholder Quality Score',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Project: ${widget.project.projectName} (${widget.project.projectCode})',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: isDark ? AppColors.darkMutedText : AppColors.lightMutedText,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Divider(),
                const SizedBox(height: 16),

                // Stakeholder Type Selector
                Text(
                  'Stakeholder Category *',
                  style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: StakeholderType.values.map((type) {
                    final selected = _selectedType == type;
                    return ChoiceChip(
                      label: Text(type.label),
                      selected: selected,
                      selectedColor: AppColors.primary.withValues(alpha: 0.15),
                      labelStyle: TextStyle(
                        fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                        color: selected
                            ? AppColors.primary
                            : (isDark ? AppColors.darkText : AppColors.lightText),
                      ),
                      onSelected: (val) {
                        if (val) setState(() => _selectedType = type);
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),

                // Stakeholder Name & Role
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Stakeholder / Agency Name *',
                          prefixIcon: Icon(Icons.person_outline, size: 20),
                        ),
                        validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _roleController,
                        decoration: const InputDecoration(
                          labelText: 'Role / Trade Scope *',
                          prefixIcon: Icon(Icons.work_outline, size: 20),
                        ),
                        validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Performance Evaluation Matrix
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkCard : AppColors.lightCard,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Performance Scoring Matrix',
                            style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
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
                                  'Avg: ${_calculatedAverage.toStringAsFixed(1)} / 5.0',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    color: AppColors.warning,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildRatingRow(labels[0], _score1, (v) => setState(() => _score1 = v)),
                      const SizedBox(height: 10),
                      _buildRatingRow(labels[1], _score2, (v) => setState(() => _score2 = v)),
                      const SizedBox(height: 10),
                      _buildRatingRow(labels[2], _score3, (v) => setState(() => _score3 = v)),
                      const SizedBox(height: 10),
                      _buildRatingRow(labels[3], _score4, (v) => setState(() => _score4 = v)),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Feedback Notes
                TextFormField(
                  controller: _feedbackController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Observations, Commendations & Improvement Notes *',
                    hintText: 'e.g. Excellent finishing on tiles, but delayed delivery on batch 2...',
                    alignLabelWithHint: true,
                  ),
                  validator: (v) => v == null || v.trim().isEmpty ? 'Feedback is required' : null,
                ),
                const SizedBox(height: 24),

                // Actions
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton.icon(
                      onPressed: _handleSubmit,
                      icon: const Icon(Icons.check_circle_outline, size: 18),
                      label: const Text('Save Quality Rating'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRatingRow(String title, double value, ValueChanged<double> onChanged) {
    return Row(
      children: [
        Expanded(
          flex: 4,
          child: Text(
            title,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
          ),
        ),
        Expanded(
          flex: 4,
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 4,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
            ),
            child: Slider(
              value: value,
              min: 1.0,
              max: 5.0,
              divisions: 8,
              label: value.toStringAsFixed(1),
              onChanged: onChanged,
            ),
          ),
        ),
        SizedBox(
          width: 44,
          child: Text(
            '${value.toStringAsFixed(1)} ★',
            textAlign: TextAlign.end,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
              color: AppColors.warning,
            ),
          ),
        ),
      ],
    );
  }

  void _handleSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      final labels = _criteriaLabels;
      final rating = StakeholderRating(
        id: widget.initialRating?.id ?? 'RATE-${DateTime.now().millisecondsSinceEpoch}',
        projectId: widget.project.id,
        stakeholderName: _nameController.text.trim(),
        roleTitle: _roleController.text.trim(),
        type: _selectedType,
        overallScore: _calculatedAverage,
        criteriaScores: {
          labels[0]: _score1,
          labels[1]: _score2,
          labels[2]: _score3,
          labels[3]: _score4,
        },
        feedback: _feedbackController.text.trim(),
        ratedBy: 'Lead Project Manager',
        ratedAt: DateTime.now(),
      );

      widget.onSubmit(rating);
      Navigator.of(context).pop();
    }
  }
}
