import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../models/marketplace_enums.dart';
import '../../models/labour_models.dart';
import '../../services/order_service.dart';

/// Interactive booking dialog for scheduling labour or service packages
class HireBookingDialog extends StatefulWidget {
  final LabourWorkerProfile? worker;
  final LabourServicePackage? package;

  const HireBookingDialog({
    super.key,
    this.worker,
    this.package,
  }) : assert(worker != null || package != null);

  static Future<bool?> showForWorker(BuildContext context, LabourWorkerProfile worker) {
    return showDialog<bool>(
      context: context,
      builder: (_) => HireBookingDialog(worker: worker),
    );
  }

  static Future<bool?> showForPackage(BuildContext context, LabourServicePackage package) {
    return showDialog<bool>(
      context: context,
      builder: (_) => HireBookingDialog(package: package),
    );
  }

  @override
  State<HireBookingDialog> createState() => _HireBookingDialogState();
}

class _HireBookingDialogState extends State<HireBookingDialog> {
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  String _selectedSlot = '09:00 AM - 01:00 PM (Morning Slot)';
  final TextEditingController _addressCtrl = TextEditingController(
    text: 'Penthouse B-1402, Embassy Boulevard, Bellary Road, Bengaluru',
  );
  final TextEditingController _notesCtrl = TextEditingController();
  bool _isSubmitting = false;

  final List<String> _timeSlots = [
    '09:00 AM - 01:00 PM (Morning Slot)',
    '02:00 PM - 06:00 PM (Afternoon Slot)',
    'Full Day (09:00 AM - 05:00 PM)',
  ];

  @override
  void dispose() {
    _addressCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  void _handleConfirm() async {
    setState(() => _isSubmitting = true);
    await Future.delayed(const Duration(milliseconds: 600));

    if (!mounted) return;

    final title = widget.package?.title ?? 'Full Day Trade Booking';
    final workerId = widget.worker?.id ?? 'wkr-001';
    final workerName = widget.worker?.name ?? 'Assigned Master Craftsman';
    final workerPhoto = widget.worker?.photoUrl ??
        'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=800&auto=format&fit=crop&q=80';
    final trade = widget.worker?.trade ?? widget.package?.trade ?? LabourTradeCategory.masterCarpenter;
    final totalAmount = widget.package?.fixedPrice ?? widget.worker?.dailyWage ?? 1500.0;

    OrderService().bookLabourService(
      workerId: workerId,
      workerName: workerName,
      workerPhoto: workerPhoto,
      trade: trade,
      serviceTitle: title,
      scheduledDate: _selectedDate,
      timeSlot: _selectedSlot,
      totalAmount: totalAmount,
      siteAddress: _addressCtrl.text.trim(),
      specialInstructions: _notesCtrl.text.trim().isNotEmpty ? _notesCtrl.text.trim() : null,
    );

    setState(() => _isSubmitting = false);
    Navigator.of(context).pop(true);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF10B981),
        content: Text(
          'Booking confirmed for ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}! Worker assigned.',
          style: GoogleFonts.plusJakartaSans(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final textMuted = isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted;

    final headerTitle = widget.package?.title ?? 'Hire ${widget.worker!.name}';
    final amount = widget.package?.fixedPrice ?? widget.worker!.dailyWage;

    return Dialog(
      backgroundColor: surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: border),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        constraints: const BoxConstraints(maxWidth: 480),
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
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.engineering_rounded, color: Color(0xFF10B981), size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Schedule Service Appointment',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: textPrimary,
                          ),
                        ),
                        Text(
                          headerTitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.plusJakartaSans(fontSize: 12, color: textMuted),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),

              const SizedBox(height: 16),
              Divider(color: border, height: 1),
              const SizedBox(height: 16),

              // Date Picker
              Text(
                'Select Scheduled Date',
                style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w700, color: textPrimary),
              ),
              const SizedBox(height: 6),
              InkWell(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 30)),
                  );
                  if (picked != null) setState(() => _selectedDate = picked);
                },
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: border),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${_selectedDate.day} / ${_selectedDate.month} / ${_selectedDate.year}',
                        style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w600, color: textPrimary),
                      ),
                      const Icon(Icons.calendar_today_rounded, size: 16, color: Color(0xFF10B981)),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 14),

              // Time Slot
              Text(
                'Arrival Time Slot',
                style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w700, color: textPrimary),
              ),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                initialValue: _selectedSlot,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
                items: _timeSlots
                    .map((s) => DropdownMenuItem(value: s, child: Text(s, style: GoogleFonts.plusJakartaSans(fontSize: 12))))
                    .toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedSlot = val);
                },
              ),

              const SizedBox(height: 14),

              // Site Address
              Text(
                'Project / Site Address',
                style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w700, color: textPrimary),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _addressCtrl,
                maxLines: 2,
                style: GoogleFonts.plusJakartaSans(fontSize: 12, color: textPrimary),
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  contentPadding: const EdgeInsets.all(12),
                ),
              ),

              const SizedBox(height: 14),

              // Special Notes
              Text(
                'Scope Instructions / Special Notes (Optional)',
                style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w700, color: textPrimary),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _notesCtrl,
                maxLines: 2,
                style: GoogleFonts.plusJakartaSans(fontSize: 12, color: textPrimary),
                decoration: InputDecoration(
                  hintText: 'e.g. Bring laser leveling equipment, ceiling height is 10.5 ft...',
                  hintStyle: GoogleFonts.plusJakartaSans(fontSize: 12, color: textMuted),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  contentPadding: const EdgeInsets.all(12),
                ),
              ),

              const SizedBox(height: 20),

              // Total fee & Confirm
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Estimated Total Fee', style: GoogleFonts.plusJakartaSans(fontSize: 11, color: textMuted)),
                      Text(
                        '₹${amount.toStringAsFixed(0)}',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF10B981),
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: _isSubmitting ? null : _handleConfirm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF10B981),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: _isSubmitting
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                          )
                        : Text(
                            'Confirm & Schedule',
                            style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800),
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
}
