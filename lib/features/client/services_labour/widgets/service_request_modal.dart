import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/responsive/breakpoints.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../models/service_labour_models.dart';

/// Multi-step / structured service booking request modal dialog
class ServiceRequestModal extends StatefulWidget {
  final LabourServiceProvider provider;
  final VoidCallback onSubmitted;

  const ServiceRequestModal({
    super.key,
    required this.provider,
    required this.onSubmitted,
  });

  static Future<void> show(
    BuildContext context, {
    required LabourServiceProvider provider,
    required VoidCallback onSubmitted,
  }) {
    final isMobile = Breakpoints.isCompact(context);
    if (isMobile) {
      return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => FractionallySizedBox(
          heightFactor: 0.94,
          child: ServiceRequestModal(provider: provider, onSubmitted: onSubmitted),
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
          constraints: const BoxConstraints(maxWidth: 600, maxHeight: 760),
          child: ServiceRequestModal(provider: provider, onSubmitted: onSubmitted),
        ),
      ),
    );
  }

  @override
  State<ServiceRequestModal> createState() => _ServiceRequestModalState();
}

class _ServiceRequestModalState extends State<ServiceRequestModal> {
  int _step = 0; // 0: Form, 1: Summary Review, 2: Success

  final _formKey = GlobalKey<FormState>();

  late String _serviceType;
  String _selectedProject = '3BHK Luxury Residence';
  int _workerCount = 2;
  final TextEditingController _descController = TextEditingController(
    text: 'Need carpentry work for modular kitchen cabinets and Hafele hinges installation.',
  );
  final String _selectedAddress =
      'Tower 4, Flat 1202, Palm Heights, Saraidhela, Dhanbad, Jharkhand 828127 (Project Site)';
  final String _startDate = '22 Sep 2026';
  final String _startTime = '10:00 AM';
  String _estimatedDuration = '3 Days';
  bool _materialRequired = false;

  @override
  void initState() {
    super.initState();
    _serviceType = widget.provider.trade;
  }

  @override
  void dispose() {
    _descController.dispose();
    super.dispose();
  }

  int get _calculatedBudget => widget.provider.dailyRate * _workerCount * 3;

  void _submit() {
    ServiceRepository.instance.createBooking(
      provider: widget.provider,
      serviceType: _serviceType,
      projectName: _selectedProject,
      projectId: 'proj_3bhk_dhanbad',
      workerCount: _workerCount,
      workDescription: _descController.text.trim(),
      propertyAddress: _selectedAddress,
      startDate: _startDate,
      startTime: _startTime,
      estimatedDuration: _estimatedDuration,
      dealValue: _calculatedBudget,
    );
    widget.onSubmitted();
    setState(() => _step = 2);
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
          // Header
          _buildHeader(isDark),

          // Scrollable Body
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: _step == 0
                  ? _buildForm(isDark)
                  : (_step == 1 ? _buildReview(isDark) : _buildSuccess(isDark)),
            ),
          ),

          // Bottom Bar
          if (_step < 2) _buildBottomBar(isDark),
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
              color: AppColors.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.handyman_rounded, size: 20, color: AppColors.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Book ${widget.provider.trade}',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                  ),
                ),
                Text(
                  'Dedicated Technician: ${widget.provider.name} (₹${widget.provider.dailyRate}/Day)',
                  style: GoogleFonts.inter(
                    fontSize: 11,
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

  Widget _buildForm(bool isDark) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Project Linkage
          Text(
            'Associate with Project / Property',
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            ),
          ),
          const SizedBox(height: 6),
          DropdownButtonFormField<String>(
            initialValue: _selectedProject,
            dropdownColor: isDark ? AppColors.darkCard : Colors.white,
            decoration: _inputDecoration(isDark),
            items: const [
              DropdownMenuItem(
                value: '3BHK Luxury Residence',
                child: Text('3BHK Luxury Residence (Active Project)'),
              ),
              DropdownMenuItem(
                value: '2BHK Renovation',
                child: Text('2BHK Renovation (Completed)'),
              ),
              DropdownMenuItem(
                value: 'Direct Standalone Home',
                child: Text('Direct Standalone Property (No Project)'),
              ),
            ],
            onChanged: (val) => setState(() => _selectedProject = val!),
          ),
          const SizedBox(height: 16),

          // Worker count
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Number of Workers',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [1, 2, 3, 4].map((count) {
                        final isSel = _workerCount == count;
                        return Padding(
                          padding: const EdgeInsets.only(right: 6),
                          child: InkWell(
                            onTap: () => setState(() => _workerCount = count),
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(
                                color: isSel
                                    ? AppColors.primary
                                    : (isDark ? AppColors.darkSurfaceElevated : Colors.grey.shade100),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: isSel
                                      ? AppColors.primary
                                      : (isDark ? AppColors.darkBorder : Colors.grey.shade300),
                                ),
                              ),
                              child: Text(
                                '$count',
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: isSel
                                      ? Colors.white
                                      : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Estimated Duration',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<String>(
                      initialValue: _estimatedDuration,
                      dropdownColor: isDark ? AppColors.darkCard : Colors.white,
                      decoration: _inputDecoration(isDark),
                      items: const [
                        DropdownMenuItem(value: '1 Day', child: Text('1 Day')),
                        DropdownMenuItem(value: '2 Days', child: Text('2 Days')),
                        DropdownMenuItem(value: '3 Days', child: Text('3 Days')),
                        DropdownMenuItem(value: '1 Week', child: Text('1 Week')),
                      ],
                      onChanged: (val) => setState(() => _estimatedDuration = val!),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Work description
          Text(
            'Describe the Work Required *',
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Please include room/area, approximate scope and any special material requirements.',
            style: GoogleFonts.inter(
              fontSize: 11,
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
            ),
          ),
          const SizedBox(height: 6),
          TextFormField(
            controller: _descController,
            maxLines: 3,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            ),
            decoration: _inputDecoration(isDark),
            validator: (val) => val == null || val.trim().isEmpty ? 'Please describe the work required' : null,
          ),
          const SizedBox(height: 16),

          // Site Address
          Text(
            'Site Execution Address *',
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurfaceElevated : const Color(0xFFF8FAFC),
              borderRadius: AppRadius.md,
              border: Border.all(
                color: isDark ? AppColors.darkBorder : Colors.grey.shade200,
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.home_work_rounded, size: 20, color: Color(0xFF10B981)),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    _selectedAddress,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Start Date & Time
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Preferred Start Date',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkSurfaceElevated : Colors.grey.shade50,
                        borderRadius: AppRadius.md,
                        border: Border.all(
                          color: isDark ? AppColors.darkBorder : Colors.grey.shade300,
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.event_rounded, size: 16, color: AppColors.primary),
                          const SizedBox(width: 8),
                          Text(
                            _startDate,
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                            ),
                          ),
                        ],
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
                    Text(
                      'Preferred Time Slot',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkSurfaceElevated : Colors.grey.shade50,
                        borderRadius: AppRadius.md,
                        border: Border.all(
                          color: isDark ? AppColors.darkBorder : Colors.grey.shade300,
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.schedule_rounded, size: 16, color: Color(0xFFF59E0B)),
                          const SizedBox(width: 8),
                          Text(
                            _startTime,
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Materials Required Toggle
          SwitchListTile.adaptive(
            contentPadding: EdgeInsets.zero,
            title: Text(
              'Include Materials Procurement by HOMIO',
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
              ),
            ),
            subtitle: Text(
              'If turned off, you supply raw materials and technician provides specialized tools.',
              style: GoogleFonts.inter(
                fontSize: 11,
                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              ),
            ),
            value: _materialRequired,
            activeThumbColor: AppColors.primary,
            onChanged: (val) => setState(() => _materialRequired = val),
          ),
        ],
      ),
    );
  }

  Widget _buildReview(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Review Service Request',
          style: GoogleFonts.inter(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Please verify your booking details before sending to dispatch.',
          style: GoogleFonts.inter(
            fontSize: 13,
            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
          ),
        ),
        const SizedBox(height: 16),

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
              _buildReviewRow('Professional', widget.provider.name, isDark),
              _buildReviewRow('Trade Specialization', widget.provider.trade, isDark),
              _buildReviewRow('Workers Requested', '$_workerCount Technicians', isDark),
              _buildReviewRow('Target Project', _selectedProject, isDark),
              _buildReviewRow('Start Schedule', '$_startDate at $_startTime', isDark),
              _buildReviewRow('Estimated Duration', _estimatedDuration, isDark),
              _buildReviewRow(
                'Materials',
                _materialRequired ? 'HOMIO Sourced & Delivered' : 'Client Provided',
                isDark,
              ),
              const Divider(height: 20),
              _buildReviewRow(
                'Estimated Labour Deal Value',
                '₹$_calculatedBudget (₹${widget.provider.dailyRate}/day × $_workerCount × 3 days)',
                isDark,
                isBold: true,
                color: const Color(0xFF10B981),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSuccess(bool isDark) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 20),
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFF10B981).withValues(alpha: 0.15),
          ),
          child: const Icon(Icons.check_circle_rounded, size: 48, color: Color(0xFF10B981)),
        ),
        const SizedBox(height: 16),
        Text(
          'Service Request Submitted',
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Request ID: SRV-2026-00483',
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'We have notified ${widget.provider.name} and your site supervisor. You can track check-in and daily photo updates in your Bookings tab.',
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            fontSize: 13,
            height: 1.45,
            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
          ),
        ),
        const SizedBox(height: 28),
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
              'Track My Bookings',
              style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReviewRow(String label, String value, bool isDark, {bool isBold = false, Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 12,
                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: isBold ? FontWeight.w800 : FontWeight.w600,
                color: color ?? (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
              ),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(bool isDark) {
    return InputDecoration(
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
    );
  }

  Widget _buildBottomBar(bool isDark) {
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
          if (_step == 1) ...[
            OutlinedButton(
              onPressed: () => setState(() => _step = 0),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: AppRadius.md),
                side: BorderSide(
                  color: isDark ? AppColors.darkBorder : Colors.grey.shade300,
                ),
              ),
              child: Text(
                'Edit',
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
              onPressed: () {
                if (_step == 0) {
                  if (_formKey.currentState!.validate()) {
                    setState(() => _step = 1);
                  }
                } else if (_step == 1) {
                  _submit();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 13),
                shape: RoundedRectangleBorder(borderRadius: AppRadius.md),
                elevation: 0,
              ),
              child: Text(
                _step == 0 ? 'Continue to Summary' : 'Confirm & Dispatch Labour',
                style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
