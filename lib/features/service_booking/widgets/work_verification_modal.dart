import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../models/labour_models.dart';

class WorkVerificationModal extends StatefulWidget {
  final ServiceBooking booking;
  final Function(WorkVerificationRecord verification, BookingStatus newStatus) onVerified;

  const WorkVerificationModal({
    super.key,
    required this.booking,
    required this.onVerified,
  });

  @override
  State<WorkVerificationModal> createState() => _WorkVerificationModalState();
}

class _WorkVerificationModalState extends State<WorkVerificationModal> {
  String _selectedAction = 'Approve'; // 'Approve', 'Request Correction', 'Reject'
  double _qualityScore = 5.0;
  final TextEditingController _notesCtrl = TextEditingController();
  final TextEditingController _correctionInstructionsCtrl = TextEditingController();
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _notesCtrl.text = 'Work inspected on site. Dimensions and finish align with approved drawings.';
    _correctionInstructionsCtrl.text = 'Re-align drawer 2 soft-close clip and touch up minor edge chip with matching wax filler.';
  }

  @override
  void dispose() {
    _notesCtrl.dispose();
    _correctionInstructionsCtrl.dispose();
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
        width: 580,
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
                      color: const Color(0xFF10B981).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.fact_check_rounded, color: Color(0xFF10B981), size: 24),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'SUPERVISOR WORK VERIFICATION',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.8,
                            color: textSecondaryColor,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${widget.booking.bookingNumber} • ${widget.booking.projectName}',
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

              // Checklist Review Summary
              Text('Checklist Verification', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: textSecondaryColor)),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: borderColor),
                ),
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: widget.booking.dailyChecklist.length,
                  separatorBuilder: (context, index) => Divider(height: 1, color: borderColor),
                  itemBuilder: (context, index) {
                    final item = widget.booking.dailyChecklist[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      child: Row(
                        children: [
                          Icon(
                            item.isCompleted ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                            color: item.isCompleted ? const Color(0xFF10B981) : Colors.grey,
                            size: 18,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(item.title, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: textPrimaryColor)),
                          ),
                          if (item.notes != null)
                            Text(item.notes!, style: TextStyle(fontSize: 10, color: textSecondaryColor)),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 18),

              // Action Selector Segment
              Text('Verification Assessment *', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: textSecondaryColor)),
              const SizedBox(height: 8),
              Row(
                children: [
                  _buildActionChip('Approve', 'Approve & Release Payment', const Color(0xFF10B981), Icons.check_circle_outline),
                  const SizedBox(width: 10),
                  _buildActionChip('Request Correction', 'Correction Required', const Color(0xFFF59E0B), Icons.build_circle_outlined),
                  const SizedBox(width: 10),
                  _buildActionChip('Reject', 'Reject Work', const Color(0xFFEF4444), Icons.cancel_outlined),
                ],
              ),
              const SizedBox(height: 18),

              // Quality Score (if Approving)
              if (_selectedAction == 'Approve') ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Supervisor Quality Rating', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: textSecondaryColor)),
                    Text('$_qualityScore / 5.0 ★', style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.primary)),
                  ],
                ),
                Slider(
                  value: _qualityScore,
                  min: 1.0,
                  max: 5.0,
                  divisions: 8,
                  activeColor: AppColors.primary,
                  label: '$_qualityScore ★',
                  onChanged: (val) => setState(() => _qualityScore = val),
                ),
                const SizedBox(height: 10),
              ],

              // Correction Instructions (if Correction Required)
              if (_selectedAction == 'Request Correction') ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.amber.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.amber.withValues(alpha: 0.3)),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.amber, size: 18),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Correction instructions will be notified to the worker. A new re-inspection cycle will be scheduled.',
                          style: TextStyle(fontSize: 11, color: Colors.amber),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Text('Correction Instructions for Labour *', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: textSecondaryColor)),
                const SizedBox(height: 6),
                TextField(
                  controller: _correctionInstructionsCtrl,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Specific defects to fix before re-inspection...',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    filled: true,
                    fillColor: backgroundColor,
                    contentPadding: const EdgeInsets.all(12),
                  ),
                ),
                const SizedBox(height: 14),
              ],

              // General Assessment Remarks
              Text('Verification Notes *', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: textSecondaryColor)),
              const SizedBox(height: 6),
              TextField(
                controller: _notesCtrl,
                maxLines: 2,
                decoration: InputDecoration(
                  hintText: 'Supervisor inspection summary...',
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
                  onPressed: _isProcessing
                      ? null
                      : () {
                          final nav = Navigator.of(context);
                          setState(() => _isProcessing = true);
                          Future.delayed(const Duration(milliseconds: 400), () {
                            final record = WorkVerificationRecord(
                              id: 'VERIF-${DateTime.now().millisecondsSinceEpoch}',
                              jobId: widget.booking.id,
                              supervisorName: widget.booking.supervisorName,
                              status: _selectedAction,
                              assessmentNotes: _notesCtrl.text.trim(),
                              correctionInstructions: _selectedAction == 'Request Correction' ? _correctionInstructionsCtrl.text.trim() : '',
                              correctionCycleCount: _selectedAction == 'Request Correction' ? 1 : 0,
                              verifiedAt: DateTime.now(),
                              qualityScore: _qualityScore,
                            );

                            BookingStatus newStatus;
                            if (_selectedAction == 'Approve') {
                              newStatus = BookingStatus.completed;
                            } else if (_selectedAction == 'Request Correction') {
                              newStatus = BookingStatus.inProgress;
                            } else {
                              newStatus = BookingStatus.disputed;
                            }

                            widget.onVerified(record, newStatus);
                            nav.pop();
                          });
                        },
                  icon: _isProcessing
                      ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : Icon(
                          _selectedAction == 'Approve'
                              ? Icons.verified_rounded
                              : (_selectedAction == 'Request Correction' ? Icons.replay_rounded : Icons.close_rounded),
                          size: 18,
                        ),
                  label: Text(
                    _isProcessing
                        ? 'SAVING VERIFICATION...'
                        : (_selectedAction == 'Approve'
                            ? 'APPROVE WORK & AUTHORIZE SETTLEMENT'
                            : (_selectedAction == 'Request Correction' ? 'SEND CORRECTION NOTICE TO WORKER' : 'REJECT WORK COMPLETION')),
                    style: const TextStyle(fontWeight: FontWeight.w800, letterSpacing: 0.5),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _selectedAction == 'Approve'
                        ? const Color(0xFF10B981)
                        : (_selectedAction == 'Request Correction' ? const Color(0xFFF59E0B) : const Color(0xFFEF4444)),
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

  Widget _buildActionChip(String value, String label, Color color, IconData icon) {
    final isSelected = _selectedAction == value;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _selectedAction = value),
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          decoration: BoxDecoration(
            color: isSelected ? color.withValues(alpha: 0.12) : AppColors.getBackground(context),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected ? color : AppColors.getBorder(context),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Column(
            children: [
              Icon(icon, color: isSelected ? color : Colors.grey, size: 22),
              const SizedBox(height: 6),
              Text(
                value,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: isSelected ? color : AppColors.getTextPrimary(context),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
