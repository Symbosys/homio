import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../models/operations_models.dart';

class VendorRatingModal extends StatefulWidget {
  final String vendorName;
  final String projectName;
  final ValueChanged<VendorScorecard> onSaveScorecard;

  const VendorRatingModal({
    super.key,
    required this.vendorName,
    required this.projectName,
    required this.onSaveScorecard,
  });

  @override
  State<VendorRatingModal> createState() => _VendorRatingModalState();
}

class _VendorRatingModalState extends State<VendorRatingModal> {
  double _rateScore = 8.5;
  double _qualityScore = 9.0;
  double _trustScore = 8.5;
  double _timelineScore = 8.0;
  double _warrantyScore = 8.5;
  final TextEditingController _feedbackCtrl = TextEditingController(
    text: 'High quality material delivered in good condition with calibrated thickness.',
  );

  double get _overallRating =>
      ((_rateScore + _qualityScore + _trustScore + _timelineScore + _warrantyScore) / 10).clamp(1.0, 5.0);

  @override
  void dispose() {
    _feedbackCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Container(
        width: 580,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.star_rounded,
                      color: AppColors.primary, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Vendor Performance & Feedback Scorecard',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        'Vendor: ${widget.vendorName} • Project: ${widget.projectName}',
                        style: TextStyle(
                          fontSize: 11,
                          color: isDark ? AppColors.darkSubtext : AppColors.lightTextSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Sliders for 5 Key Comparison Criteria
            _buildScoreSlider('Rate Competitiveness (1–10)', _rateScore, (v) => setState(() => _rateScore = v)),
            _buildScoreSlider('Material Quality & IS Compliance (1–10)', _qualityScore, (v) => setState(() => _qualityScore = v)),
            _buildScoreSlider('Trust & Reliability (1–10)', _trustScore, (v) => setState(() => _trustScore = v)),
            _buildScoreSlider('Timeline & Lead Time Punctuality (1–10)', _timelineScore, (v) => setState(() => _timelineScore = v)),
            _buildScoreSlider('Warranty & Replacement Honor (1–10)', _warrantyScore, (v) => setState(() => _warrantyScore = v)),
            const SizedBox(height: 12),

            // Computed Overall Rating
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Composite Overall Rating:',
                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, color: AppColors.gold, size: 18),
                      const SizedBox(width: 4),
                      Text(
                        '${_overallRating.toStringAsFixed(1)} / 5.0',
                        style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Free-text Feedback
            TextFormField(
              controller: _feedbackCtrl,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: 'Qualitative Vendor Feedback *',
                hintText: 'Notes on packaging, transit damages, site behavior, or billing ease',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 10),
                FilledButton.icon(
                  onPressed: () {
                    widget.onSaveScorecard(
                      VendorScorecard(
                        rateScore: _rateScore,
                        qualityScore: _qualityScore,
                        trustScore: _trustScore,
                        timelineScore: _timelineScore,
                        warrantyScore: _warrantyScore,
                        overallRating: _overallRating,
                        feedback: _feedbackCtrl.text.trim(),
                        evaluatedBy: 'Amit Kumar',
                        evaluatedDate: DateTime.now(),
                      ),
                    );
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.save_rounded, size: 16),
                  label: const Text('Save Scorecard'),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreSlider(String label, double value, ValueChanged<double> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
          ),
          Expanded(
            flex: 5,
            child: Slider(
              value: value,
              min: 1.0,
              max: 10.0,
              divisions: 18,
              label: value.toStringAsFixed(1),
              onChanged: onChanged,
            ),
          ),
          SizedBox(
            width: 36,
            child: Text(
              value.toStringAsFixed(1),
              textAlign: TextAlign.right,
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
