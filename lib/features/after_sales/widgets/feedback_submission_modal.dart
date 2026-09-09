import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../models/after_sales_models.dart';
import '../models/after_sales_mock_data.dart';

class FeedbackSubmissionModal extends StatefulWidget {
  final ServiceRequest? request;
  final ValueChanged<CustomerFeedback> onFeedbackSubmitted;

  const FeedbackSubmissionModal({
    super.key,
    this.request,
    required this.onFeedbackSubmitted,
  });

  @override
  State<FeedbackSubmissionModal> createState() => _FeedbackSubmissionModalState();
}

class _FeedbackSubmissionModalState extends State<FeedbackSubmissionModal> {
  final _formKey = GlobalKey<FormState>();

  late ServiceRequest _selectedReq;
  double _overallRating = 5.0;
  double _qualityRating = 5.0;
  double _timelinessRating = 5.0;
  double _professionalismRating = 5.0;
  double _communicationRating = 5.0;
  double _resolutionRating = 5.0;

  IssueResolutionAnswer _issueResolvedAnswer = IssueResolutionAnswer.yes;
  final TextEditingController _whatWentWellCtrl = TextEditingController(text: 'Punctual, polite technicians and clean finishing.');
  final TextEditingController _whatCouldImproveCtrl = TextEditingController();
  final TextEditingController _commentsCtrl = TextEditingController(text: 'Extremely pleased with the after-sales support provided by Homio.');

  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _selectedReq = widget.request ?? AfterSalesMockData.serviceRequests.first;
  }

  @override
  void dispose() {
    _whatWentWellCtrl.dispose();
    _whatCouldImproveCtrl.dispose();
    _commentsCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final surfaceColor = AppColors.getSurface(context);
    final backgroundColor = AppColors.getBackground(context);
    final borderColor = AppColors.getBorder(context);
    final textPrimaryColor = AppColors.getTextPrimary(context);
    final textSecondaryColor = AppColors.getTextSecondary(context);

    final isLowRating = _overallRating < 3.0 || _issueResolvedAnswer == IssueResolutionAnswer.no;

    return Dialog(
      backgroundColor: surfaceColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 740,
        height: 700,
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.amber.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.star_rate_rounded, color: Colors.amber, size: 24),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Record Customer CSAT & Service Feedback', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: textPrimaryColor)),
                          Text('5-Pillar evaluation with automated manager escalation on scores < 3.0', style: TextStyle(fontSize: 12, color: textSecondaryColor)),
                        ],
                      ),
                    ],
                  ),
                  IconButton(icon: const Icon(Icons.close_rounded), onPressed: () => Navigator.pop(context)),
                ],
              ),
              const Divider(height: 24),

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Customer & Project Info Pill
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: backgroundColor,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: borderColor),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.person_outline, size: 18, color: AppColors.primary),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                '${_selectedReq.customerName} • ${_selectedReq.projectName} • Service Ref: ${_selectedReq.requestNumber}',
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: textPrimaryColor),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Overall Score
                      Center(
                        child: Column(
                          children: [
                            Text(
                              'Overall Experience Rating',
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: textPrimaryColor),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(5, (i) {
                                final starVal = (i + 1).toDouble();
                                return IconButton(
                                  icon: Icon(
                                    starVal <= _overallRating ? Icons.star_rounded : Icons.star_outline_rounded,
                                    color: Colors.amber,
                                    size: 32,
                                  ),
                                  onPressed: () => setState(() => _overallRating = starVal),
                                );
                              }),
                            ),
                            Text(
                              '${_overallRating.toStringAsFixed(1)} / 5.0 Stars',
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.amber),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Resolution Question
                      Text('Was your service issue satisfactorily resolved? *', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: textPrimaryColor)),
                      const SizedBox(height: 8),
                      Row(
                        children: IssueResolutionAnswer.values.map((ans) {
                          final isSelected = _issueResolvedAnswer == ans;
                          return Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4),
                              child: ChoiceChip(
                                label: Center(child: Text(ans.label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: isSelected ? Colors.white : textPrimaryColor))),
                                selected: isSelected,
                                selectedColor: ans == IssueResolutionAnswer.yes ? const Color(0xFF10B981) : (ans == IssueResolutionAnswer.partially ? Colors.orange : Colors.red),
                                onSelected: (_) => setState(() => _issueResolvedAnswer = ans),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 18),

                      // Low Rating Warning Box
                      if (isLowRating) ...[
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.red.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.warning_amber_rounded, color: Colors.red, size: 22),
                              SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'AUTOMATIC ESCALATION TRIGGER: This feedback will automatically notify the Service Manager and create an urgent follow-up task.',
                                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 18),
                      ],

                      // 5-Pillar Scorecards
                      Text('Detailed 5-Pillar Service Quality Evaluation', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: textPrimaryColor)),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(color: backgroundColor, borderRadius: BorderRadius.circular(10), border: Border.all(color: borderColor)),
                        child: Column(
                          children: [
                            _buildRatingSlider('Work Quality & Craftsmanship', _qualityRating, (v) => setState(() => _qualityRating = v), textPrimaryColor),
                            _buildRatingSlider('Timeliness & SLA Adherence', _timelinessRating, (v) => setState(() => _timelinessRating = v), textPrimaryColor),
                            _buildRatingSlider('Technician Professionalism', _professionalismRating, (v) => setState(() => _professionalismRating = v), textPrimaryColor),
                            _buildRatingSlider('Service Communication', _communicationRating, (v) => setState(() => _communicationRating = v), textPrimaryColor),
                            _buildRatingSlider('Resolution Effectiveness', _resolutionRating, (v) => setState(() => _resolutionRating = v), textPrimaryColor),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Qualitative text fields
                      TextFormField(
                        controller: _whatWentWellCtrl,
                        decoration: InputDecoration(
                          labelText: 'What went well with the service?',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          filled: true,
                          fillColor: backgroundColor,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _whatCouldImproveCtrl,
                        decoration: InputDecoration(
                          labelText: 'What could be improved in future visits?',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          filled: true,
                          fillColor: backgroundColor,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _commentsCtrl,
                        maxLines: 2,
                        decoration: InputDecoration(
                          labelText: 'Overall Customer Comments / Testimonial *',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          filled: true,
                          fillColor: backgroundColor,
                          contentPadding: const EdgeInsets.all(12),
                        ),
                        validator: (val) => (val == null || val.trim().isEmpty) ? 'Please leave comments' : null,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Actions
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: _isSubmitting ? null : _submitFeedback,
                    icon: _isSubmitting
                        ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : const Icon(Icons.check_circle_rounded, size: 18),
                    label: Text(_isSubmitting ? 'RECORDING...' : 'SUBMIT CSAT FEEDBACK'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isLowRating ? Colors.red.shade700 : const Color(0xFF10B981),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      elevation: 0,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRatingSlider(String title, double value, ValueChanged<double> onChanged, Color textPrimary) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(flex: 4, child: Text(title, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: textPrimary))),
          Expanded(
            flex: 5,
            child: Slider(
              value: value,
              min: 1.0,
              max: 5.0,
              divisions: 8,
              activeColor: Colors.amber,
              onChanged: onChanged,
            ),
          ),
          SizedBox(
            width: 45,
            child: Text('${value.toStringAsFixed(1)} ★', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12, color: Colors.amber)),
          ),
        ],
      ),
    );
  }

  void _submitFeedback() {
    if (!_formKey.currentState!.validate()) return;

    final nav = Navigator.of(context);
    setState(() => _isSubmitting = true);

    Future.delayed(const Duration(milliseconds: 350), () {
      final isLow = _overallRating < 3.0 || _issueResolvedAnswer == IssueResolutionAnswer.no;

      final feedback = CustomerFeedback(
        id: 'FDB-2026-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
        feedbackNumber: 'CSAT-${8800 + DateTime.now().millisecond % 50}',
        customerId: _selectedReq.customerId,
        customerName: _selectedReq.customerName,
        customerPhone: _selectedReq.customerPhone,
        projectId: _selectedReq.projectId,
        projectName: _selectedReq.projectName,
        serviceRequestId: _selectedReq.id,
        touchpoint: 'Post-Service Resolution',
        submittedDate: DateTime.now(),
        overallRating: _overallRating,
        qualityRating: _qualityRating,
        timelinessRating: _timelinessRating,
        professionalismRating: _professionalismRating,
        communicationRating: _communicationRating,
        resolutionRating: _resolutionRating,
        issueResolvedAnswer: _issueResolvedAnswer,
        whatWentWell: _whatWentWellCtrl.text.trim(),
        whatCouldImprove: _whatCouldImproveCtrl.text.trim(),
        customerComments: _commentsCtrl.text.trim(),
        isEscalated: isLow,
        escalationReason: isLow ? 'Low rating (<3.0) or unresolved issue flagged.' : null,
      );

      widget.onFeedbackSubmitted(feedback);
      nav.pop();
    });
  }
}
