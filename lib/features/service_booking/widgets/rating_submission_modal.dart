import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../models/labour_models.dart';

class RatingSubmissionModal extends StatefulWidget {
  final ServiceBooking booking;
  final Function(LabourRatingRecord rating) onRatingSubmitted;

  const RatingSubmissionModal({
    super.key,
    required this.booking,
    required this.onRatingSubmitted,
  });

  @override
  State<RatingSubmissionModal> createState() => _RatingSubmissionModalState();
}

class _RatingSubmissionModalState extends State<RatingSubmissionModal> {
  String _reviewerRole = 'Customer';
  String _reviewerName = '';
  double _quality = 5.0;
  double _timeline = 5.0;
  double _behaviour = 5.0;
  double _reliability = 5.0;
  final TextEditingController _reviewCtrl = TextEditingController();
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _reviewerName = widget.booking.clientName;
    _reviewCtrl.text = 'Very satisfied with the workmanship and site cleanliness.';
  }

  @override
  void dispose() {
    _reviewCtrl.dispose();
    super.dispose();
  }

  double get _overallScore => (_quality + _timeline + _behaviour + _reliability) / 4.0;

  @override
  Widget build(BuildContext context) {
    final surfaceColor = AppColors.getSurface(context);
    final backgroundColor = AppColors.getBackground(context);
    final textPrimaryColor = AppColors.getTextPrimary(context);
    final textSecondaryColor = AppColors.getTextSecondary(context);

    return Dialog(
      backgroundColor: surfaceColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 540,
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
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
                      color: Colors.amber.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.star_rounded, color: Colors.amber, size: 24),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'MULTI-DIMENSIONAL RATING & FEEDBACK',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.8,
                            color: textSecondaryColor,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Rate ${widget.booking.tradesmanName} (${widget.booking.trade.label})',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: textPrimaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded, size: 20),
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // Reviewer Role Switcher
              Text('Rating Submitted By *', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: textSecondaryColor)),
              const SizedBox(height: 6),
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(value: 'Customer', label: Text('Customer / Client'), icon: Icon(Icons.person_outline, size: 16)),
                  ButtonSegment(value: 'Site Supervisor', label: Text('Site Supervisor'), icon: Icon(Icons.engineering_outlined, size: 16)),
                  ButtonSegment(value: 'Service Manager', label: Text('Service Lead'), icon: Icon(Icons.verified_user_outlined, size: 16)),
                ],
                selected: {_reviewerRole},
                onSelectionChanged: (val) {
                  setState(() {
                    _reviewerRole = val.first;
                    if (_reviewerRole == 'Customer') {
                      _reviewerName = widget.booking.clientName;
                    } else if (_reviewerRole == 'Site Supervisor') {
                      _reviewerName = widget.booking.supervisorName;
                    } else {
                      _reviewerName = 'Operations Lead';
                    }
                  });
                },
              ),
              const SizedBox(height: 18),

              // 4 Scoring Sliders
              _buildRatingSlider('1. Craftsmanship & Work Quality', _quality, (v) => setState(() => _quality = v), textPrimaryColor, textSecondaryColor),
              _buildRatingSlider('2. Timeline & Punctuality', _timeline, (v) => setState(() => _timeline = v), textPrimaryColor, textSecondaryColor),
              _buildRatingSlider('3. Behaviour & Professional Conduct', _behaviour, (v) => setState(() => _behaviour = v), textPrimaryColor, textSecondaryColor),
              _buildRatingSlider('4. Site Reliability & SOP Adherence', _reliability, (v) => setState(() => _reliability = v), textPrimaryColor, textSecondaryColor),

              const SizedBox(height: 10),

              // Composite Score Badge
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _overallScore >= 4.0 ? const Color(0xFF10B981).withValues(alpha: 0.1) : Colors.amber.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: _overallScore >= 4.0 ? const Color(0xFF10B981).withValues(alpha: 0.3) : Colors.amber.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Computed Composite CSAT Score:', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                    Row(
                      children: [
                        const Icon(Icons.star_rounded, size: 20, color: Colors.amber),
                        const SizedBox(width: 4),
                        Text(
                          '${_overallScore.toStringAsFixed(2)} / 5.0',
                          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Review Feedback Text
              Text('Detailed Review Remarks *', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: textSecondaryColor)),
              const SizedBox(height: 6),
              TextField(
                controller: _reviewCtrl,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Share feedback regarding site conduct, craftsmanship, or punctuality...',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  filled: true,
                  fillColor: backgroundColor,
                  contentPadding: const EdgeInsets.all(12),
                ),
              ),
              const SizedBox(height: 24),

              // Submit Action
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: _isSubmitting
                      ? null
                      : () {
                          final nav = Navigator.of(context);
                          setState(() => _isSubmitting = true);
                          Future.delayed(const Duration(milliseconds: 400), () {
                            final rating = LabourRatingRecord(
                              id: 'RTG-${DateTime.now().millisecondsSinceEpoch}',
                              bookingId: widget.booking.id,
                              bookingNumber: widget.booking.bookingNumber,
                              workerId: widget.booking.tradesmanId,
                              workerName: widget.booking.tradesmanName,
                              trade: widget.booking.trade,
                              reviewerName: _reviewerName,
                              reviewerRole: _reviewerRole,
                              qualityScore: _quality,
                              timelineScore: _timeline,
                              behaviourScore: _behaviour,
                              reliabilityScore: _reliability,
                              overallScore: _overallScore,
                              reviewNotes: _reviewCtrl.text.trim(),
                              date: DateTime.now(),
                              isAlertTriggered: _overallScore < 3.0,
                            );
                            widget.onRatingSubmitted(rating);
                            nav.pop();
                          });
                        },
                  icon: _isSubmitting
                      ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Icon(Icons.star_rounded, size: 20),
                  label: Text(_isSubmitting ? 'RECORDING RATING...' : 'PUBLISH VERIFIED RATING'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber.shade700,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    elevation: 0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRatingSlider(String title, double value, ValueChanged<double> onChanged, Color textColor, Color labelColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: labelColor)),
            Text('${value.toStringAsFixed(1)} ★', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12, color: textColor)),
          ],
        ),
        Slider(
          value: value,
          min: 1.0,
          max: 5.0,
          divisions: 8,
          activeColor: Colors.amber,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
