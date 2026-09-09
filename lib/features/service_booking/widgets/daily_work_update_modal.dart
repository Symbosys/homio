import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../models/labour_models.dart';

class DailyWorkUpdateModal extends StatefulWidget {
  final ServiceBooking booking;
  final Function(DailyWorkUpdate update) onUpdateSubmitted;

  const DailyWorkUpdateModal({
    super.key,
    required this.booking,
    required this.onUpdateSubmitted,
  });

  @override
  State<DailyWorkUpdateModal> createState() => _DailyWorkUpdateModalState();
}

class _DailyWorkUpdateModalState extends State<DailyWorkUpdateModal> {
  double _hoursWorked = 8.0;
  double _progressPercentage = 65.0;
  final TextEditingController _workCompletedCtrl = TextEditingController();
  final TextEditingController _workRemainingCtrl = TextEditingController();
  final TextEditingController _blockersCtrl = TextEditingController();
  final TextEditingController _materialsCtrl = TextEditingController();
  final List<String> _attachedPhotos = [];
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _progressPercentage = widget.booking.progressPercent;
    _workCompletedCtrl.text = 'Completed today\'s scheduled task as per drawing.';
  }

  @override
  void dispose() {
    _workCompletedCtrl.dispose();
    _workRemainingCtrl.dispose();
    _blockersCtrl.dispose();
    _materialsCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final surfaceColor = AppColors.getSurface(context);
    final backgroundColor = AppColors.getBackground(context);
    final borderColor = AppColors.getBorder(context);
    final textPrimaryColor = AppColors.getTextPrimary(context);
    final textSecondaryColor = AppColors.getTextSecondary(context);

    return Dialog(
      backgroundColor: surfaceColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 560,
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
                      color: AppColors.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.history_edu_rounded, color: AppColors.primary, size: 24),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'DAILY SITE PROGRESS LOG',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.8,
                            color: textSecondaryColor,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          widget.booking.bookingNumber,
                          style: TextStyle(
                            fontSize: 17,
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

              // Hours Worked Counter
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: borderColor),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Hours Worked Today', style: TextStyle(fontWeight: FontWeight.w700, color: textPrimaryColor, fontSize: 13)),
                        const SizedBox(height: 2),
                        Text('Standard shift: 8 Hours', style: TextStyle(color: textSecondaryColor, fontSize: 11)),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: _hoursWorked > 1.0 ? () => setState(() => _hoursWorked -= 0.5) : null,
                          icon: const Icon(Icons.remove_circle_outline_rounded),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: surfaceColor,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: borderColor),
                          ),
                          child: Text(
                            '${_hoursWorked.toStringAsFixed(1)} hrs',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: textPrimaryColor),
                          ),
                        ),
                        IconButton(
                          onPressed: _hoursWorked < 16.0 ? () => setState(() => _hoursWorked += 0.5) : null,
                          icon: const Icon(Icons.add_circle_outline_rounded, color: AppColors.primary),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // Progress % Slider
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Overall Job Progress', style: TextStyle(fontWeight: FontWeight.w700, color: textPrimaryColor, fontSize: 13)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '${_progressPercentage.toInt()}% Completed',
                      style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w800, fontSize: 13),
                    ),
                  ),
                ],
              ),
              Slider(
                value: _progressPercentage,
                min: 0.0,
                max: 100.0,
                divisions: 20,
                activeColor: AppColors.primary,
                label: '${_progressPercentage.toInt()}%',
                onChanged: (val) => setState(() => _progressPercentage = val),
              ),
              const SizedBox(height: 14),

              // Work Completed
              Text('Work Executed Today *', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: textSecondaryColor)),
              const SizedBox(height: 6),
              TextField(
                controller: _workCompletedCtrl,
                maxLines: 2,
                decoration: InputDecoration(
                  hintText: 'Describe items executed, measurements, or parts assembled...',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  filled: true,
                  fillColor: backgroundColor,
                  contentPadding: const EdgeInsets.all(12),
                ),
              ),
              const SizedBox(height: 14),

              // Work Remaining
              Text('Work Remaining For Next Shift', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: textSecondaryColor)),
              const SizedBox(height: 6),
              TextField(
                controller: _workRemainingCtrl,
                maxLines: 2,
                decoration: InputDecoration(
                  hintText: 'Next tasks to be completed tomorrow...',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  filled: true,
                  fillColor: backgroundColor,
                  contentPadding: const EdgeInsets.all(12),
                ),
              ),
              const SizedBox(height: 14),

              // Blockers & Materials
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Site Blockers / Issues', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: textSecondaryColor)),
                        const SizedBox(height: 6),
                        TextField(
                          controller: _blockersCtrl,
                          decoration: InputDecoration(
                            hintText: 'e.g. Awaiting paint dry...',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                            filled: true,
                            fillColor: backgroundColor,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Materials Needed', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: textSecondaryColor)),
                        const SizedBox(height: 6),
                        TextField(
                          controller: _materialsCtrl,
                          decoration: InputDecoration(
                            hintText: 'e.g. 2 boxes 35mm screws',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                            filled: true,
                            fillColor: backgroundColor,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Site Photos Upload
              Text('Site Progress Photos', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: textSecondaryColor)),
              const SizedBox(height: 8),
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        _attachedPhotos.add('https://images.unsplash.com/photo-1503387762-592deb58ef4e?w=500');
                      });
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        color: backgroundColor,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: borderColor, style: BorderStyle.solid),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_a_photo_rounded, size: 22, color: AppColors.primary),
                          const SizedBox(height: 2),
                          Text('Add', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.primary)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ..._attachedPhotos.map((url) {
                    return Container(
                      margin: const EdgeInsets.only(right: 10),
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: borderColor),
                        image: DecorationImage(image: NetworkImage(url), fit: BoxFit.cover),
                      ),
                    );
                  }),
                ],
              ),
              const SizedBox(height: 24),

              // Submit Button
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
                            final update = DailyWorkUpdate(
                              id: 'UPD-${DateTime.now().millisecondsSinceEpoch}',
                              jobId: widget.booking.id,
                              workDate: DateTime.now(),
                              hoursWorked: _hoursWorked,
                              workCompleted: _workCompletedCtrl.text.trim(),
                              workRemaining: _workRemainingCtrl.text.trim(),
                              progressPercentage: _progressPercentage,
                              blockers: _blockersCtrl.text.trim(),
                              materialRequirements: _materialsCtrl.text.trim(),
                              photoUrls: _attachedPhotos.isNotEmpty
                                  ? _attachedPhotos
                                  : ['https://images.unsplash.com/photo-1581094288338-2314dddb7ece?w=500'],
                              submittedBy: widget.booking.tradesmanName,
                              submittedAt: DateTime.now(),
                            );
                            widget.onUpdateSubmitted(update);
                            nav.pop();
                          });
                        },
                  icon: _isSubmitting
                      ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Icon(Icons.send_rounded, size: 18),
                  label: Text(_isSubmitting ? 'SAVING PROGRESS...' : 'SUBMIT DAILY WORK UPDATE'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
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
}
