import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../models/after_sales_models.dart';

class FieldVisitExecutionModal extends StatefulWidget {
  final ServiceVisit visit;
  final ValueChanged<ServiceVisit> onVisitUpdated;

  const FieldVisitExecutionModal({
    super.key,
    required this.visit,
    required this.onVisitUpdated,
  });

  @override
  State<FieldVisitExecutionModal> createState() => _FieldVisitExecutionModalState();
}

class _FieldVisitExecutionModalState extends State<FieldVisitExecutionModal> {
  late ServiceVisitStatus _status;
  VisitCheckInRecord? _checkInRecord;
  late List<VisitChecklistItem> _checklist;
  final TextEditingController _diagnosisCtrl = TextEditingController(text: 'Inspected component. Verified operational wear.');
  final TextEditingController _workPerformedCtrl = TextEditingController(text: 'Replaced defective part with OEM replacement and adjusted tolerances.');
  final TextEditingController _materialsUsedCtrl = TextEditingController(text: '1x Replacement Unit, fastening screws, lubricant');
  double _labourHours = 1.5;
  double _clientRating = 5.0;
  bool _clientSignedOff = false;
  bool _isProcessingCheckIn = false;
  bool _isCompleting = false;

  @override
  void initState() {
    super.initState();
    _status = widget.visit.status;
    _checkInRecord = widget.visit.checkInRecord;
    _checklist = widget.visit.checklist.map((c) => c.copyWith()).toList();
    if (_checklist.isEmpty) {
      _checklist = [
        const VisitChecklistItem(id: 'CHK-1', title: 'Customer issue verified in person', isChecked: true),
        const VisitChecklistItem(id: 'CHK-2', title: 'Site condition & safety check completed', isChecked: true),
        const VisitChecklistItem(id: 'CHK-3', title: 'Warranty validity verified on site', isChecked: true),
        const VisitChecklistItem(id: 'CHK-4', title: 'Root cause identified and explained to client', isChecked: false),
        const VisitChecklistItem(id: 'CHK-5', title: 'Corrective repair or replacement executed', isChecked: false),
        const VisitChecklistItem(id: 'CHK-6', title: 'Cleanliness check & debris disposal', isChecked: false),
        const VisitChecklistItem(id: 'CHK-7', title: 'Customer sign-off & demonstration', isChecked: false),
      ];
    }
  }

  @override
  void dispose() {
    _diagnosisCtrl.dispose();
    _workPerformedCtrl.dispose();
    _materialsUsedCtrl.dispose();
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
        width: 680,
        height: 720,
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Bar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: _status.color.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(Icons.car_repair_rounded, color: _status.color, size: 22),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Field Technician Visit Execution', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: textPrimaryColor)),
                        Text('${widget.visit.visitNumber} • ${widget.visit.customerName} (${widget.visit.projectName})', style: TextStyle(fontSize: 12, color: textSecondaryColor)),
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
                    // Step 1: GPS Geo-Fenced Check-In
                    _buildCheckInCard(backgroundColor, borderColor, textPrimaryColor, textSecondaryColor),
                    const SizedBox(height: 20),

                    // Step 2: Inspection Checklist
                    Text('On-Site Verification Checklist (${_checklist.where((c) => c.isChecked).length}/${_checklist.length})', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: textPrimaryColor)),
                    const SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        color: backgroundColor,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: borderColor),
                      ),
                      child: ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _checklist.length,
                        separatorBuilder: (context, index) => Divider(height: 1, color: borderColor),
                        itemBuilder: (context, index) {
                          final item = _checklist[index];
                          return CheckboxListTile(
                            value: item.isChecked,
                            dense: true,
                            activeColor: const Color(0xFF10B981),
                            title: Text(item.title, style: TextStyle(fontSize: 12, fontWeight: item.isChecked ? FontWeight.w600 : FontWeight.w500, color: textPrimaryColor)),
                            onChanged: (val) {
                              setState(() {
                                _checklist[index] = item.copyWith(isChecked: val ?? false);
                              });
                            },
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Step 3: Work Log & Material Usage
                    Text('Service Execution Report & Materials Used', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: textPrimaryColor)),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _diagnosisCtrl,
                      decoration: InputDecoration(
                        labelText: 'Root Cause Diagnosis *',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        filled: true,
                        fillColor: backgroundColor,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _workPerformedCtrl,
                      maxLines: 2,
                      decoration: InputDecoration(
                        labelText: 'Work Performed Summary *',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        filled: true,
                        fillColor: backgroundColor,
                        contentPadding: const EdgeInsets.all(12),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: TextFormField(
                            controller: _materialsUsedCtrl,
                            decoration: InputDecoration(
                              labelText: 'Materials / Parts Consumed',
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                              filled: true,
                              fillColor: backgroundColor,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 2,
                          child: DropdownButtonFormField<double>(
                            initialValue: _labourHours,
                            decoration: InputDecoration(
                              labelText: 'Labour Hours',
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                              filled: true,
                              fillColor: backgroundColor,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            ),
                            items: const [
                              DropdownMenuItem(value: 0.5, child: Text('0.5 Hour')),
                              DropdownMenuItem(value: 1.0, child: Text('1.0 Hour')),
                              DropdownMenuItem(value: 1.5, child: Text('1.5 Hours')),
                              DropdownMenuItem(value: 2.0, child: Text('2.0 Hours')),
                              DropdownMenuItem(value: 3.0, child: Text('3.0 Hours')),
                            ],
                            onChanged: (val) {
                              if (val != null) setState(() => _labourHours = val);
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Step 4: Customer Confirmation & Rating
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.draw_rounded, color: Colors.green, size: 20),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Customer Sign-off & On-Site CSAT',
                                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.green.shade800),
                                  ),
                                ],
                              ),
                              Switch(
                                value: _clientSignedOff,
                                activeThumbColor: Colors.green,
                                onChanged: (val) => setState(() => _clientSignedOff = val),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            _clientSignedOff
                                ? 'Client ${widget.visit.customerName} verified satisfaction and signed off.'
                                : 'Toggle switch to record digital customer confirmation signature.',
                            style: TextStyle(fontSize: 11, color: textSecondaryColor),
                          ),
                          if (_clientSignedOff) ...[
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Text('Client Rating: ', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: textPrimaryColor)),
                                ...List.generate(5, (i) {
                                  final starVal = (i + 1).toDouble();
                                  return IconButton(
                                    icon: Icon(
                                      starVal <= _clientRating ? Icons.star_rounded : Icons.star_outline_rounded,
                                      color: Colors.amber,
                                      size: 22,
                                    ),
                                    onPressed: () => setState(() => _clientRating = starVal),
                                  );
                                }),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Footer Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: _isCompleting ? null : _completeVisit,
                  icon: _isCompleting
                      ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Icon(Icons.check_circle_rounded, size: 18),
                  label: Text(_isCompleting ? 'SAVING...' : 'COMPLETE & SIGN-OFF VISIT'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF10B981),
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
    );
  }

  Widget _buildCheckInCard(Color bg, Color border, Color textPrimary, Color textSecondary) {
    if (_checkInRecord != null) {
      return Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.blue.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            const Icon(Icons.gps_fixed_rounded, color: Colors.blue, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('GPS CHECK-IN VERIFIED ON SITE', style: TextStyle(color: Colors.blue, fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 0.5)),
                  const SizedBox(height: 2),
                  Text(_checkInRecord!.siteAddress, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: textPrimary)),
                  Text(
                    'Checked in at ${_checkInRecord!.checkInTime.hour}:${_checkInRecord!.checkInTime.minute.toString().padLeft(2, '0')} • Geo-fence valid within 25m',
                    style: TextStyle(fontSize: 10, color: textSecondary),
                  ),
                ],
              ),
            ),
            const Icon(Icons.check_circle_rounded, color: Colors.blue, size: 20),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.location_on_outlined, size: 24, color: AppColors.primary),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('On-Site GPS & Biometric Check-In', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: textPrimary)),
                  Text('Simulate GPS coordinate capture at ${widget.visit.siteAddress}', style: TextStyle(fontSize: 11, color: textSecondary)),
                ],
              ),
            ],
          ),
          ElevatedButton.icon(
            onPressed: _isProcessingCheckIn ? null : _simulateCheckIn,
            icon: _isProcessingCheckIn
                ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : const Icon(Icons.fingerprint_rounded, size: 16),
            label: Text(_isProcessingCheckIn ? 'VERIFYING...' : 'CHECK IN NOW'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ],
      ),
    );
  }

  void _simulateCheckIn() {
    setState(() => _isProcessingCheckIn = true);
    final messenger = ScaffoldMessenger.of(context);
    Future.delayed(const Duration(milliseconds: 400), () {
      if (!mounted) return;
      setState(() {
        _isProcessingCheckIn = false;
        _status = ServiceVisitStatus.checkedIn;
        _checkInRecord = VisitCheckInRecord(
          checkInTime: DateTime.now(),
          latitude: 12.9716,
          longitude: 77.5946,
          siteAddress: widget.visit.siteAddress,
          isGeofenceValid: true,
          selfiePhotoUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200',
        );
      });
      messenger.showSnackBar(
        const SnackBar(content: Text('GPS check-in verified. Geo-fence valid within 25m.')),
      );
    });
  }

  void _completeVisit() {
    final nav = Navigator.of(context);
    setState(() => _isCompleting = true);

    Future.delayed(const Duration(milliseconds: 350), () {
      final updated = widget.visit.copyWith(
        status: ServiceVisitStatus.completed,
        outcome: 'Visit completed successfully. Client sign-off obtained.',
        checkInRecord: _checkInRecord,
        checklist: _checklist,
        report: VisitReport(
          arrivalTime: _checkInRecord?.checkInTime ?? DateTime.now().subtract(const Duration(hours: 1)),
          completionTime: DateTime.now(),
          diagnosis: _diagnosisCtrl.text.trim(),
          workPerformed: _workPerformedCtrl.text.trim(),
          materialsUsed: _materialsUsedCtrl.text.trim(),
          labourHours: _labourHours,
          customerSignatureName: widget.visit.customerName,
          customerConfirmed: _clientSignedOff,
          rating: _clientRating,
        ),
      );

      widget.onVisitUpdated(updated);
      nav.pop();
    });
  }
}
