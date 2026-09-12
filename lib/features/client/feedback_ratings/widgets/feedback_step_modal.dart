import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/responsive/breakpoints.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../models/feedback_models.dart';
import 'rating_stars_input.dart';

/// 5-Step mobile-optimized feedback submission modal dialog / bottom sheet
class FeedbackStepModal extends StatefulWidget {
  final PendingFeedbackPrompt? prompt;
  final VoidCallback? onSubmitted;

  const FeedbackStepModal({
    super.key,
    this.prompt,
    this.onSubmitted,
  });

  static Future<void> show(
    BuildContext context, {
    PendingFeedbackPrompt? prompt,
    VoidCallback? onSubmitted,
  }) {
    final isMobile = Breakpoints.isCompact(context);
    if (isMobile) {
      return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => FractionallySizedBox(
          heightFactor: 0.92,
          child: FeedbackStepModal(prompt: prompt, onSubmitted: onSubmitted),
        ),
      );
    }
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 580, maxHeight: 720),
          child: FeedbackStepModal(prompt: prompt, onSubmitted: onSubmitted),
        ),
      ),
    );
  }

  @override
  State<FeedbackStepModal> createState() => _FeedbackStepModalState();
}

class _FeedbackStepModalState extends State<FeedbackStepModal> {
  int _currentStep = 0; // 0: Overall, 1: Categories, 2: Comments & Tags, 3: Review, 4: Success

  double _overallRating = 5.0;

  late final List<FeedbackCategoryRating> _categoryRatings;

  final TextEditingController _commentController = TextEditingController();
  final Set<String> _selectedTags = <String>{};
  String _recommendation = 'Yes'; // 'Yes', 'Neutral', 'No'

  final List<FeedbackTag> _availableTags = const [
    FeedbackTag(label: 'Great Communication', isPositive: true),
    FeedbackTag(label: 'High Quality', isPositive: true),
    FeedbackTag(label: 'On Time', isPositive: true),
    FeedbackTag(label: 'Professional Team', isPositive: true),
    FeedbackTag(label: 'Good Design', isPositive: true),
    FeedbackTag(label: 'Helpful Support', isPositive: true),
    FeedbackTag(label: 'Fast Response', isPositive: true),
    FeedbackTag(label: 'Clean Site', isPositive: true),
    FeedbackTag(label: 'Laser Precision', isPositive: true),
    FeedbackTag(label: 'Communication Could Improve', isPositive: false),
    FeedbackTag(label: 'Timeline Concern', isPositive: false),
    FeedbackTag(label: 'Quality Concern', isPositive: false),
  ];

  @override
  void initState() {
    super.initState();
    _categoryRatings = [
      FeedbackCategoryRating(
        key: 'Quality',
        title: 'QUALITY',
        question: 'How satisfied were you with the quality of work?',
        score: 5.0,
      ),
      FeedbackCategoryRating(
        key: 'Timeline',
        title: 'TIMELINE',
        question: 'How satisfied were you with the timeline adherence?',
        score: 5.0,
      ),
      FeedbackCategoryRating(
        key: 'Communication',
        title: 'COMMUNICATION',
        question: 'How satisfied were you with team updates & communication?',
        score: 5.0,
      ),
      FeedbackCategoryRating(
        key: 'Professionalism',
        title: 'BEHAVIOUR & PROFESSIONALISM',
        question: 'How courteous, punctual and professional was the team?',
        score: 5.0,
      ),
      FeedbackCategoryRating(
        key: 'Value',
        title: 'VALUE & SATISFACTION',
        question: 'How satisfied are you with the overall value delivered?',
        score: 5.0,
      ),
    ];
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < 3) {
      setState(() => _currentStep++);
    } else if (_currentStep == 3) {
      // Submit
      final catMap = {for (final c in _categoryRatings) c.key: c.score};
      FeedbackRepository.instance.submitFeedback(
        prompt: widget.prompt,
        title: widget.prompt?.title ?? 'Full Project Milestone Experience',
        targetEntity: widget.prompt?.providerName ?? 'HOMIO Project Execution Team',
        targetType: widget.prompt?.targetType ?? 'Project',
        overallScore: _overallRating,
        categoryScores: catMap,
        comments: _commentController.text,
        tags: _selectedTags.map((t) => '#${t.replaceAll(' ', '')}').toList(),
        recommendation: _recommendation,
      );
      widget.onSubmitted?.call();
      setState(() => _currentStep = 4);
    }
  }

  void _prevStep() {
    if (_currentStep > 0 && _currentStep < 4) {
      setState(() => _currentStep--);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : Colors.grey.shade200,
        ),
      ),
      child: Column(
        children: [
          // Header Bar
          _buildHeader(isDark),

          // Stepper Indicator (if not on success step)
          if (_currentStep < 4) _buildStepIndicator(isDark),

          // Scrollable Step Body
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: _buildCurrentStepContent(isDark),
            ),
          ),

          // Bottom Action Bar (if not on success step)
          if (_currentStep < 4) _buildBottomActions(isDark),
        ],
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: isDark ? AppColors.darkBorder : Colors.grey.shade200,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFF59E0B).withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.rate_review_rounded, size: 20, color: Color(0xFFF59E0B)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.prompt != null ? widget.prompt!.title : 'Rate Your Experience',
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  widget.prompt?.categoryLabel ?? 'STRUCTURED CUSTOMER FEEDBACK',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close_rounded, size: 20),
            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
          ),
        ],
      ),
    );
  }

  Widget _buildStepIndicator(bool isDark) {
    final stepLabels = ['Overall', 'Categories', 'Comments', 'Review'];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurfaceElevated : const Color(0xFFF8FAFC),
        border: Border(
          bottom: BorderSide(
            color: isDark ? AppColors.darkBorder : Colors.grey.shade200,
          ),
        ),
      ),
      child: Row(
        children: List.generate(stepLabels.length, (idx) {
          final isCompleted = _currentStep > idx;
          final isCurrent = _currentStep == idx;

          return Expanded(
            child: Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isCompleted
                        ? const Color(0xFF10B981)
                        : (isCurrent ? AppColors.primary : (isDark ? AppColors.darkBorder : Colors.grey.shade300)),
                  ),
                  alignment: Alignment.center,
                  child: isCompleted
                      ? const Icon(Icons.check_rounded, size: 14, color: Colors.white)
                      : Text(
                          '${idx + 1}',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: isCurrent ? Colors.white : Colors.grey.shade600,
                          ),
                        ),
                ),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    stepLabels[idx],
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w500,
                      color: isCurrent
                          ? (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)
                          : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (idx < stepLabels.length - 1)
                  Expanded(
                    child: Container(
                      height: 2,
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      color: isCompleted
                          ? const Color(0xFF10B981)
                          : (isDark ? AppColors.darkBorder : Colors.grey.shade300),
                    ),
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildCurrentStepContent(bool isDark) {
    switch (_currentStep) {
      case 0:
        return _buildStep1Overall(isDark);
      case 1:
        return _buildStep2Categories(isDark);
      case 2:
        return _buildStep3CommentsTags(isDark);
      case 3:
        return _buildStep4Review(isDark);
      case 4:
        return _buildStep5Success(isDark);
      default:
        return const SizedBox();
    }
  }

  // STEP 1: OVERALL RATING
  Widget _buildStep1Overall(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 12),
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFFF59E0B).withValues(alpha: 0.12),
          ),
          child: const Icon(Icons.star_rounded, size: 42, color: Color(0xFFF59E0B)),
        ),
        const SizedBox(height: 16),
        Text(
          'How would you rate your overall experience?',
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          widget.prompt != null
              ? '${widget.prompt!.subtitle}\nYour feedback directly helps maintain strict quality standards.'
              : 'Your feedback helps us continuously elevate the HOMIO construction and interior experience.',
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            fontSize: 13,
            height: 1.45,
            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
          ),
        ),
        const SizedBox(height: 32),

        // Large Accessible Rating Stars
        RatingStarsInput(
          value: _overallRating,
          starSize: 44,
          alignment: MainAxisAlignment.center,
          onChanged: (newVal) => setState(() => _overallRating = newVal),
        ),
        const SizedBox(height: 24),

        // Descriptive sentiment quote
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurfaceElevated : const Color(0xFFF8FAFC),
            borderRadius: AppRadius.md,
            border: Border.all(
              color: isDark ? AppColors.darkBorder : Colors.grey.shade200,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.lightbulb_outline_rounded,
                size: 16,
                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  'Next: Rate specific parameters like Quality, Timeline & Communication',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // STEP 2: CATEGORY RATINGS
  Widget _buildStep2Categories(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Category Breakdown',
          style: GoogleFonts.inter(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Please score each dimension to provide granular feedback.',
          style: GoogleFonts.inter(
            fontSize: 13,
            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
          ),
        ),
        const SizedBox(height: 20),

        ..._categoryRatings.map((cat) {
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurfaceElevated : const Color(0xFFF8FAFC),
              borderRadius: AppRadius.md,
              border: Border.all(
                color: isDark ? AppColors.darkBorder : Colors.grey.shade200,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      cat.title,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.6,
                        color: AppColors.primary,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${cat.score.toStringAsFixed(0)} / 5',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: RatingStarsInput.getColorForScore(cat.score),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  cat.question,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                RatingStarsInput(
                  value: cat.score,
                  starSize: 26,
                  showLabel: false,
                  onChanged: (newVal) => setState(() => cat.score = newVal),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  // STEP 3: COMMENTS, TAGS & RECOMMENDATION
  Widget _buildStep3CommentsTags(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Additional Comments & Tags',
          style: GoogleFonts.inter(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Tell us what went well or what we could improve for future milestones.',
          style: GoogleFonts.inter(
            fontSize: 13,
            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
          ),
        ),
        const SizedBox(height: 16),

        // Textarea
        TextField(
          controller: _commentController,
          maxLines: 4,
          style: GoogleFonts.inter(
            fontSize: 14,
            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
          ),
          decoration: InputDecoration(
            hintText: 'Share any notes regarding workmanship, responsiveness, punctuality...',
            hintStyle: GoogleFonts.inter(
              fontSize: 13,
              color: isDark ? AppColors.darkTextSecondary : Colors.grey.shade400,
            ),
            filled: true,
            fillColor: isDark ? AppColors.darkSurfaceElevated : Colors.grey.shade50,
            border: OutlineInputBorder(
              borderRadius: AppRadius.md,
              borderSide: BorderSide(
                color: isDark ? AppColors.darkBorder : Colors.grey.shade300,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: AppRadius.md,
              borderSide: BorderSide(
                color: isDark ? AppColors.darkBorder : Colors.grey.shade300,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: AppRadius.md,
              borderSide: BorderSide(color: AppColors.primary, width: 1.5),
            ),
          ),
        ),
        const SizedBox(height: 20),

        // Quick Tags
        Text(
          'Quick Selectable Tags',
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _availableTags.map((tag) {
            final isSelected = _selectedTags.contains(tag.label);
            return FilterChip(
              label: Text(
                tag.label,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected
                      ? (tag.isPositive ? const Color(0xFF059669) : const Color(0xFFDC2626))
                      : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                ),
              ),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedTags.add(tag.label);
                  } else {
                    _selectedTags.remove(tag.label);
                  }
                });
              },
              backgroundColor: isDark ? AppColors.darkSurfaceElevated : Colors.grey.shade100,
              selectedColor: tag.isPositive
                  ? const Color(0xFF10B981).withValues(alpha: 0.18)
                  : const Color(0xFFEF4444).withValues(alpha: 0.18),
              checkmarkColor: tag.isPositive ? const Color(0xFF059669) : const Color(0xFFDC2626),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: isSelected
                      ? (tag.isPositive ? const Color(0xFF10B981) : const Color(0xFFEF4444))
                      : (isDark ? AppColors.darkBorder : Colors.grey.shade300),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 24),

        // Would you recommend HOMIO?
        Text(
          'Would you recommend HOMIO to friends & family?',
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _buildRecommendPill('Yes', Icons.thumb_up_alt_rounded, const Color(0xFF10B981), isDark),
            const SizedBox(width: 10),
            _buildRecommendPill('Neutral', Icons.thumbs_up_down_rounded, const Color(0xFFF59E0B), isDark),
            const SizedBox(width: 10),
            _buildRecommendPill('No', Icons.thumb_down_alt_rounded, const Color(0xFFEF4444), isDark),
          ],
        ),
      ],
    );
  }

  Widget _buildRecommendPill(String value, IconData icon, Color color, bool isDark) {
    final isSelected = _recommendation == value;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _recommendation = value),
        borderRadius: AppRadius.md,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? color.withValues(alpha: 0.15)
                : (isDark ? AppColors.darkSurfaceElevated : Colors.grey.shade100),
            borderRadius: AppRadius.md,
            border: Border.all(
              color: isSelected ? color : (isDark ? AppColors.darkBorder : Colors.grey.shade300),
              width: isSelected ? 1.5 : 1.0,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 16, color: isSelected ? color : Colors.grey),
              const SizedBox(width: 6),
              Text(
                value,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected ? color : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // STEP 4: REVIEW
  Widget _buildStep4Review(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Review Your Feedback',
          style: GoogleFonts.inter(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Please verify your scores and comments before final submission.',
          style: GoogleFonts.inter(
            fontSize: 13,
            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
          ),
        ),
        const SizedBox(height: 16),

        // Summary Card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurfaceElevated : const Color(0xFFF8FAFC),
            borderRadius: AppRadius.lg,
            border: Border.all(
              color: isDark ? AppColors.darkBorder : Colors.grey.shade200,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Overall Rating:',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                    ),
                  ),
                  const Spacer(),
                  const Icon(Icons.star_rounded, size: 18, color: Color(0xFFF59E0B)),
                  const SizedBox(width: 4),
                  Text(
                    '${_overallRating.toStringAsFixed(1)} / 5',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFFF59E0B),
                    ),
                  ),
                ],
              ),
              const Divider(height: 20),

              // Category Scores
              ..._categoryRatings.map((cat) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  child: Row(
                    children: [
                      Text(
                        cat.key,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${cat.score.toStringAsFixed(1)} ★',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                        ),
                      ),
                    ],
                  ),
                );
              }),
              const Divider(height: 20),

              // Comments
              Text(
                'Comments:',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _commentController.text.trim().isEmpty
                    ? 'No specific written comments provided.'
                    : '"${_commentController.text.trim()}"',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontStyle: FontStyle.italic,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                ),
              ),
              const SizedBox(height: 12),

              // Selected Tags
              if (_selectedTags.isNotEmpty) ...[
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: _selectedTags.map((t) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '#$t',
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 12),
              ],

              // Recommendation
              Row(
                children: [
                  Text(
                    'Recommends HOMIO:',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    _recommendation,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: _recommendation == 'Yes' ? const Color(0xFF10B981) : const Color(0xFFF59E0B),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // STEP 5: SUCCESS
  Widget _buildStep5Success(bool isDark) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 24),
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFF10B981).withValues(alpha: 0.15),
          ),
          child: const Icon(Icons.check_circle_rounded, size: 50, color: Color(0xFF10B981)),
        ),
        const SizedBox(height: 20),
        Text(
          'Thank You!',
          style: GoogleFonts.inter(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Your feedback has been successfully submitted and logged in your project quality record.',
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            fontSize: 14,
            height: 1.5,
            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
          ),
        ),
        const SizedBox(height: 32),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: AppRadius.md),
              elevation: 0,
            ),
            child: Text(
              'Back to Feedback Center',
              style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700),
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildBottomActions(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.darkBorder : Colors.grey.shade200,
          ),
        ),
      ),
      child: Row(
        children: [
          if (_currentStep > 0) ...[
            OutlinedButton(
              onPressed: _prevStep,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: AppRadius.md),
                side: BorderSide(
                  color: isDark ? AppColors.darkBorder : Colors.grey.shade300,
                ),
              ),
              child: Text(
                'Back',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                ),
              ),
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: ElevatedButton(
              onPressed: _nextStep,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 13),
                shape: RoundedRectangleBorder(borderRadius: AppRadius.md),
                elevation: 0,
              ),
              child: Text(
                _currentStep == 3 ? 'Submit Feedback' : 'Continue',
                style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
