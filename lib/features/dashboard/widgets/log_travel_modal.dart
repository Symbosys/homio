import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';

/// Modal dialog for logging a field visit or GPS trip with mileage reimbursement calculation.
class LogTravelModal extends StatefulWidget {
  final double mileageRatePerKm;
  final Function({
    required String clientName,
    required String projectName,
    required String fromLocation,
    required String toLocation,
    required double distanceKm,
    required String purpose,
  }) onLogTrip;

  const LogTravelModal({
    super.key,
    this.mileageRatePerKm = 12.0,
    required this.onLogTrip,
  });

  static void show(
    BuildContext context, {
    double mileageRatePerKm = 12.0,
    required Function({
      required String clientName,
      required String projectName,
      required String fromLocation,
      required String toLocation,
      required double distanceKm,
      required String purpose,
    }) onLogTrip,
  }) {
    showDialog(
      context: context,
      builder: (context) => LogTravelModal(
        mileageRatePerKm: mileageRatePerKm,
        onLogTrip: onLogTrip,
      ),
    );
  }

  @override
  State<LogTravelModal> createState() => _LogTravelModalState();
}

class _LogTravelModalState extends State<LogTravelModal> {
  final _clientCtrl = TextEditingController();
  final _projectCtrl = TextEditingController();
  final _fromCtrl = TextEditingController(text: 'HQ — DLF Phase 5 Hub');
  final _toCtrl = TextEditingController();
  final _distanceCtrl = TextEditingController(text: '15.0');
  String _purpose = 'Site Measurement';

  final List<String> _purposes = [
    'Site Measurement',
    'Framing & Structure Inspection',
    'Client Design Consultation',
    'Material Quality Signoff',
    'Snaglist Handover Inspection',
  ];

  @override
  void dispose() {
    _clientCtrl.dispose();
    _projectCtrl.dispose();
    _fromCtrl.dispose();
    _toCtrl.dispose();
    _distanceCtrl.dispose();
    super.dispose();
  }

  double get _estimatedKm => double.tryParse(_distanceCtrl.text.trim()) ?? 0.0;
  double get _estimatedReimbursement => _estimatedKm * widget.mileageRatePerKm;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AlertDialog(
      backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.md),
      contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
      titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF2563EB).withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.add_road_rounded, size: 20, color: Color(0xFF2563EB)),
          ),
          const SizedBox(width: 12),
          Text(
            'Log Field Visit & Mileage Claim',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            ),
          ),
        ],
      ),
      content: SizedBox(
        width: 440,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Record client site visit for odometer tracking and automatic company fuel reimbursement.',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                ),
              ),
              const SizedBox(height: 16),

              // Client Name
              _buildFieldLabel('Client Name', isDark),
              TextField(
                controller: _clientCtrl,
                style: GoogleFonts.inter(fontSize: 12),
                decoration: _inputDecoration('e.g. Rahul Sharma', isDark),
              ),
              const SizedBox(height: 12),

              // Project Name
              _buildFieldLabel('Project / Site Name', isDark),
              TextField(
                controller: _projectCtrl,
                style: GoogleFonts.inter(fontSize: 12),
                decoration: _inputDecoration('e.g. DLF Phase 5 Villa #104', isDark),
              ),
              const SizedBox(height: 12),

              // From & To
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildFieldLabel('Departure Location', isDark),
                        TextField(
                          controller: _fromCtrl,
                          style: GoogleFonts.inter(fontSize: 12),
                          decoration: _inputDecoration('Origin point', isDark),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildFieldLabel('Destination Site', isDark),
                        TextField(
                          controller: _toCtrl,
                          style: GoogleFonts.inter(fontSize: 12),
                          decoration: _inputDecoration('e.g. Sobha City #402', isDark),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Distance & Purpose
              Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildFieldLabel('Distance (KM)', isDark),
                        TextField(
                          controller: _distanceCtrl,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          style: GoogleFonts.inter(fontSize: 12),
                          decoration: _inputDecoration('15.0', isDark),
                          onChanged: (_) => setState(() {}),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 6,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildFieldLabel('Visit Purpose', isDark),
                        Container(
                          height: 38,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.darkSurfaceSubtle : const Color(0xFFF8FAFC),
                            borderRadius: AppRadius.sm,
                            border: Border.all(
                              color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                            ),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _purpose,
                              isExpanded: true,
                              dropdownColor: isDark ? AppColors.darkSurfaceElevated : Colors.white,
                              style: GoogleFonts.inter(
                                fontSize: 11.5,
                                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                              ),
                              items: _purposes.map((p) {
                                return DropdownMenuItem(value: p, child: Text(p, maxLines: 1, overflow: TextOverflow.ellipsis));
                              }).toList(),
                              onChanged: (val) {
                                if (val != null) setState(() => _purpose = val);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Reimbursement Calculation Card
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : const Color(0xFFEFF6FF),
                  borderRadius: AppRadius.sm,
                  border: Border.all(
                    color: const Color(0xFF2563EB).withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Company Rate: ₹${widget.mileageRatePerKm.toStringAsFixed(0)} / KM',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: isDark ? const Color(0xFF93C5FD) : const Color(0xFF1E40AF),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Estimated Fuel Reimbursement',
                          style: GoogleFonts.inter(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white : const Color(0xFF1E3A8A),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '₹${_estimatedReimbursement.toStringAsFixed(2)}',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF2563EB),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel', style: GoogleFonts.inter(fontSize: 12)),
        ),
        ElevatedButton(
          onPressed: () {
            if (_clientCtrl.text.trim().isEmpty) {
              _clientCtrl.text = 'Site Client';
            }
            if (_projectCtrl.text.trim().isEmpty) {
              _projectCtrl.text = 'Field Operations Hub';
            }
            widget.onLogTrip(
              clientName: _clientCtrl.text.trim(),
              projectName: _projectCtrl.text.trim(),
              fromLocation: _fromCtrl.text.trim(),
              toLocation: _toCtrl.text.trim().isEmpty ? 'Client Site' : _toCtrl.text.trim(),
              distanceKm: _estimatedKm,
              purpose: _purpose,
            );
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2563EB),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
          ),
          child: Text(
            'Record Trip Claim',
            style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }

  Widget _buildFieldLabel(String label, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint, bool isDark) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.inter(fontSize: 12, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
      border: OutlineInputBorder(borderRadius: AppRadius.sm),
    );
  }
}
