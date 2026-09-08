import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../models/labour_models.dart';

class DailyChecklistModal extends StatefulWidget {
  final ServiceBooking booking;
  final Function(List<DailyChecklistItem> updatedChecklist, String supervisorName, String notes) onSignOff;

  const DailyChecklistModal({
    super.key,
    required this.booking,
    required this.onSignOff,
  });

  @override
  State<DailyChecklistModal> createState() => _DailyChecklistModalState();
}

class _DailyChecklistModalState extends State<DailyChecklistModal> {
  late List<DailyChecklistItem> _checklist;
  final TextEditingController _workDoneNotesController = TextEditingController(
    text: 'Completed 45 sq.ft carcass assembly and edge-banding. Tested all soft-close channels. Zero visual snags.',
  );
  final TextEditingController _supervisorNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _checklist = List.from(widget.booking.dailyChecklist);
    _supervisorNameController.text = widget.booking.supervisorSignOffName.isNotEmpty
        ? widget.booking.supervisorSignOffName
        : widget.booking.supervisorName;
  }

  @override
  Widget build(BuildContext context) {
    final surfaceColor = AppColors.getSurface(context);
    final backgroundColor = AppColors.getBackground(context);
    final borderColor = AppColors.getBorder(context);
    final textPrimaryColor = AppColors.getTextPrimary(context);
    final textSecondaryColor = AppColors.getTextSecondary(context);
    final textMutedColor = AppColors.getTextMuted(context);

    final allChecked = _checklist.isNotEmpty && _checklist.every((c) => c.isCompleted);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Container(
        width: 700,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.88,
        ),
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: borderColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(19)),
                border: Border(bottom: BorderSide(color: borderColor.withValues(alpha: 0.8))),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.fact_check_rounded, color: AppColors.primary, size: 22),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Daily Task & Quality Sign-off: ${widget.booking.bookingNumber}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: textPrimaryColor,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${widget.booking.projectName} • Worker: ${widget.booking.tradesmanName}',
                          style: TextStyle(fontSize: 12, color: textSecondaryColor),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(Icons.close, color: textMutedColor),
                  ),
                ],
              ),
            ),

            // Modal Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // GPS Check-in verification box
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981).withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.25)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.gps_fixed_rounded, size: 18, color: Color(0xFF10B981)),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Verified Site Attendance: ${widget.booking.gpsCheckInStamp}',
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF10B981)),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 18),

                    // Trade Quality Checklist
                    Text(
                      'Trade Quality & Safety Verification Items',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: textPrimaryColor),
                    ),
                    const SizedBox(height: 10),

                    ...List.generate(_checklist.length, (idx) {
                      final item = _checklist[idx];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: item.isCompleted ? const Color(0xFF10B981).withValues(alpha: 0.05) : backgroundColor,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: item.isCompleted ? const Color(0xFF10B981).withValues(alpha: 0.3) : borderColor,
                          ),
                        ),
                        child: Row(
                          children: [
                            Checkbox(
                              value: item.isCompleted,
                              activeColor: const Color(0xFF10B981),
                              onChanged: (val) {
                                setState(() {
                                  _checklist[idx] = item.copyWith(isCompleted: val ?? false);
                                });
                              },
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.title,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: item.isCompleted ? textPrimaryColor : textSecondaryColor,
                                      decoration: item.isCompleted ? TextDecoration.none : null,
                                    ),
                                  ),
                                  if (item.notes != null)
                                    Text(
                                      'Note: ${item.notes}',
                                      style: TextStyle(fontSize: 11, fontStyle: FontStyle.italic, color: textMutedColor),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }),

                    const SizedBox(height: 16),

                    // Work Done Description & Measurement Log
                    Text(
                      'Supervisor Site Inspection & Measurement Remarks',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: textPrimaryColor),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _workDoneNotesController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: 'Enter specific measurements executed, material brands verified, and remarks...',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        filled: true,
                        fillColor: backgroundColor,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Supervisor Digital Sign-off
                    Text(
                      'Supervisor Digital Authentication',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: textPrimaryColor),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _supervisorNameController,
                      decoration: InputDecoration(
                        labelText: 'Supervisor Full Name (Digital Signature)',
                        prefixIcon: const Icon(Icons.draw_outlined, size: 18),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        filled: true,
                        fillColor: backgroundColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Modal Footer
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(19)),
                border: Border(top: BorderSide(color: borderColor.withValues(alpha: 0.8))),
              ),
              child: Row(
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Cancel'),
                  ),
                  const Spacer(),
                  ElevatedButton.icon(
                    onPressed: allChecked && _supervisorNameController.text.isNotEmpty
                        ? () {
                            widget.onSignOff(_checklist, _supervisorNameController.text, _workDoneNotesController.text);
                            Navigator.of(context).pop();
                          }
                        : null,
                    icon: const Icon(Icons.verified_rounded, size: 16),
                    label: const Text('Sign-off & Verify Daily Work'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF10B981),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
