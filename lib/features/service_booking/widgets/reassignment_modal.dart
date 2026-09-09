import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../models/labour_models.dart';
import '../models/labour_mock_data.dart';

class ReassignmentModal extends StatefulWidget {
  final ServiceBooking booking;
  final Function(ReassignmentRecord record, LabourProfile replacementWorker) onReassigned;

  const ReassignmentModal({
    super.key,
    required this.booking,
    required this.onReassigned,
  });

  @override
  State<ReassignmentModal> createState() => _ReassignmentModalState();
}

class _ReassignmentModalState extends State<ReassignmentModal> {
  LabourProfile? _selectedReplacement;
  final TextEditingController _reasonCtrl = TextEditingController();
  final TextEditingController _workCompletedBeforeCtrl = TextEditingController();
  final TextEditingController _outstandingWorkCtrl = TextEditingController();
  double _additionalCost = 0.0;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _reasonCtrl.text = widget.booking.isDelayed
        ? widget.booking.delayReason
        : 'Worker medical emergency / site delay. Immediate replacement required.';
    _workCompletedBeforeCtrl.text = '${widget.booking.progressPercent.toInt()}% of carcass and rough work completed.';
    _outstandingWorkCtrl.text = 'Final assembly, hardware alignment, and polish touch-up.';

    // Pick a replacement candidate with the same trade who is available
    final candidates = LabourMockData.profiles.where((w) =>
        w.trade == widget.booking.trade &&
        w.id != widget.booking.tradesmanId &&
        w.labourStatus != LabourStatus.blacklisted).toList();
    if (candidates.isNotEmpty) {
      _selectedReplacement = candidates.first;
    }
  }

  @override
  void dispose() {
    _reasonCtrl.dispose();
    _workCompletedBeforeCtrl.dispose();
    _outstandingWorkCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final surfaceColor = AppColors.getSurface(context);
    final backgroundColor = AppColors.getBackground(context);
    final borderColor = AppColors.getBorder(context);
    final textPrimaryColor = AppColors.getTextPrimary(context);
    final textSecondaryColor = AppColors.getTextSecondary(context);

    final matchingCandidates = LabourMockData.profiles.where((w) =>
        w.trade == widget.booking.trade &&
        w.id != widget.booking.tradesmanId &&
        w.labourStatus != LabourStatus.blacklisted).toList();

    return Dialog(
      backgroundColor: surfaceColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 600,
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
                      color: Colors.orange.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.swap_horiz_rounded, color: Colors.orange, size: 24),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'WORKFORCE REASSIGNMENT WORKFLOW',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.8,
                            color: textSecondaryColor,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Job ${widget.booking.bookingNumber} • ${widget.booking.projectName}',
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
              const SizedBox(height: 16),

              // Historical Preservation Notice
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.history_rounded, color: Colors.blue, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Audit Rule: Original worker history (${widget.booking.tradesmanName}) will be preserved in job archive. New worker will be allocated for remaining scope.',
                        style: TextStyle(fontSize: 11, color: Colors.blue.shade800),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Current Labour Card vs Replacement
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: backgroundColor,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: borderColor),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('CURRENT WORKER', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: textSecondaryColor)),
                          const SizedBox(height: 4),
                          Text(widget.booking.tradesmanName, style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: textPrimaryColor)),
                          Text('ID: ${widget.booking.tradesmanId}', style: TextStyle(fontSize: 11, color: textSecondaryColor)),
                          const SizedBox(height: 4),
                          Text('Completed: ${widget.booking.progressPercent.toInt()}%', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 11, color: AppColors.primary)),
                        ],
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Icon(Icons.arrow_forward_rounded, color: Colors.grey),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('REPLACEMENT CANDIDATE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.primary)),
                          const SizedBox(height: 4),
                          Text(
                            _selectedReplacement?.legalName ?? 'Select below',
                            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: textPrimaryColor),
                          ),
                          Text(
                            _selectedReplacement != null ? '${_selectedReplacement!.rating} ★ • ${_selectedReplacement!.completedJobs} Jobs' : '',
                            style: TextStyle(fontSize: 11, color: textSecondaryColor),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _selectedReplacement != null ? 'Daily: ₹${_selectedReplacement!.dailyRate.toInt()}' : '',
                            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 11, color: Color(0xFF10B981)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Candidate Selector
              Text('Select Verified Replacement Tradesman *', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: textSecondaryColor)),
              const SizedBox(height: 6),
              DropdownButtonFormField<LabourProfile>(
                initialValue: _selectedReplacement,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  filled: true,
                  fillColor: backgroundColor,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
                items: matchingCandidates.map((c) {
                  return DropdownMenuItem(
                    value: c,
                    child: Text('${c.legalName} (${c.rating} ★, ${c.city} - ${c.distanceKm} km away)'),
                  );
                }).toList(),
                onChanged: (val) => setState(() => _selectedReplacement = val),
              ),
              const SizedBox(height: 14),

              // Reassignment Reason
              Text('Reassignment Justification / Reason *', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: textSecondaryColor)),
              const SizedBox(height: 6),
              TextField(
                controller: _reasonCtrl,
                maxLines: 2,
                decoration: InputDecoration(
                  hintText: 'State reason (e.g. Labour delay, illness, abandoned, or supervisor replacement request)...',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  filled: true,
                  fillColor: backgroundColor,
                  contentPadding: const EdgeInsets.all(12),
                ),
              ),
              const SizedBox(height: 14),

              // Work Completed vs Outstanding
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Work Completed Before Transfer', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: textSecondaryColor)),
                        const SizedBox(height: 6),
                        TextField(
                          controller: _workCompletedBeforeCtrl,
                          decoration: InputDecoration(
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
                        Text('Outstanding Work Assigned', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: textSecondaryColor)),
                        const SizedBox(height: 6),
                        TextField(
                          controller: _outstandingWorkCtrl,
                          decoration: InputDecoration(
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
              const SizedBox(height: 14),

              // Additional Cost
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Additional Replacement Cost (if applicable)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: textSecondaryColor)),
                        const SizedBox(height: 6),
                        TextField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            prefixText: '₹ ',
                            hintText: '0.00',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                            filled: true,
                            fillColor: backgroundColor,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          ),
                          onChanged: (val) {
                            setState(() => _additionalCost = double.tryParse(val) ?? 0.0);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Confirm Reassignment
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: (_selectedReplacement == null || _isProcessing)
                      ? null
                      : () {
                          final nav = Navigator.of(context);
                          setState(() => _isProcessing = true);
                          Future.delayed(const Duration(milliseconds: 400), () {
                            final record = ReassignmentRecord(
                              id: 'REASS-${DateTime.now().millisecondsSinceEpoch}',
                              jobId: widget.booking.id,
                              previousWorkerId: widget.booking.tradesmanId,
                              previousWorkerName: widget.booking.tradesmanName,
                              replacementWorkerId: _selectedReplacement!.id,
                              replacementWorkerName: _selectedReplacement!.legalName,
                              reason: _reasonCtrl.text.trim(),
                              workCompletedBefore: _workCompletedBeforeCtrl.text.trim(),
                              outstandingWork: _outstandingWorkCtrl.text.trim(),
                              additionalCost: _additionalCost,
                              approvedBy: widget.booking.supervisorName,
                              timestamp: DateTime.now(),
                            );
                            widget.onReassigned(record, _selectedReplacement!);
                            nav.pop();
                          });
                        },
                  icon: _isProcessing
                      ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Icon(Icons.check_circle_outline, size: 20),
                  label: Text(_isProcessing ? 'PROCESSING TRANSFER...' : 'AUTHORIZE WORKFORCE REASSIGNMENT'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange.shade800,
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
