import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_radius.dart';
import '../data/hrms_repository.dart';
import '../domain/hrms_domain_models.dart';
import '../domain/hrms_enums.dart';

class TravelLogDialog extends StatefulWidget {
  final VoidCallback? onTravelLogged;

  const TravelLogDialog({super.key, this.onTravelLogged});

  static void show(BuildContext context, {VoidCallback? onTravelLogged}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 620),
          child: TravelLogDialog(onTravelLogged: onTravelLogged),
        ),
      ),
    );
  }

  @override
  State<TravelLogDialog> createState() => _TravelLogDialogState();
}

class _TravelLogDialogState extends State<TravelLogDialog> {
  final _repo = HrmsRepository();

  final _originCtrl = TextEditingController(text: 'Homio HQ BKC');
  final _destCtrl = TextEditingController(text: 'Sky Villas Worli Penthouse Site');
  final _distanceCtrl = TextEditingController(text: '18.5');
  final _purposeCtrl = TextEditingController(text: 'MEP electrical wiring snag audit & slab dry-lay check');
  final _projectCtrl = TextEditingController(text: 'Worli Sky Penthouse 4401');

  String _selectedEmployeeId = 'emp_008';
  TravelMode _selectedMode = TravelMode.bike;
  bool _hasDepartureSelfie = true;
  bool _hasArrivalSelfie = true;

  @override
  void dispose() {
    _originCtrl.dispose();
    _destCtrl.dispose();
    _distanceCtrl.dispose();
    _purposeCtrl.dispose();
    _projectCtrl.dispose();
    super.dispose();
  }

  double get _ratePerKm {
    switch (_selectedMode) {
      case TravelMode.bike:
        return _repo.policyConfig.bikeMileageRatePerKm;
      case TravelMode.car:
        return _repo.policyConfig.carMileageRatePerKm;
      case TravelMode.publicTransport:
        return 2.5;
      case TravelMode.auto:
        return 8.0;
      case TravelMode.walking:
        return 0.0;
    }
  }

  double get _totalClaim {
    final dist = double.tryParse(_distanceCtrl.text) ?? 0.0;
    return dist * _ratePerKm;
  }

  void _submit() {
    final emp = _repo.getEmployeeById(_selectedEmployeeId);
    if (emp == null) return;

    final dist = double.tryParse(_distanceCtrl.text) ?? 0.0;
    if (dist <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter valid distance in KM.')));
      return;
    }

    final record = FieldTravelRecord(
      id: 'trv_${DateTime.now().millisecondsSinceEpoch}',
      employeeId: emp.id,
      employeeName: emp.fullName,
      employeeCode: emp.employeeCode,
      date: DateTime.now(),
      originName: _originCtrl.text.trim(),
      originLat: 19.0657,
      originLng: 72.8687,
      departureTime: DateTime.now().subtract(const Duration(hours: 2)),
      destinationName: _destCtrl.text.trim(),
      destinationLat: 19.0176,
      destinationLng: 72.8151,
      arrivalTime: DateTime.now().subtract(const Duration(hours: 1)),
      distanceKm: dist,
      approvedKm: dist,
      ratePerKm: _ratePerKm,
      totalAmount: _totalClaim,
      travelMode: _selectedMode,
      purpose: _purposeCtrl.text.trim(),
      clientProjectName: _projectCtrl.text.trim(),
      status: ApprovalStatus.pending,
      originSelfieUrl: _hasDepartureSelfie ? 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150' : null,
      arrivalSelfieUrl: _hasArrivalSelfie ? 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150' : null,
    );

    _repo.logTravel(record);
    widget.onTravelLogged?.call();
    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Field travel log submitted! Claim: ₹${record.totalAmount.toStringAsFixed(2)}'),
        backgroundColor: const Color(0xFF10B981),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final employees = _repo.employees;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF131722) : Colors.white,
        borderRadius: AppRadius.lg,
        border: Border.all(
          color: isDark ? Colors.white.withValues(alpha: 0.08) : Colors.black.withValues(alpha: 0.06),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: isDark ? Colors.white10 : Colors.black12)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF3B82F6).withValues(alpha: 0.12),
                        borderRadius: AppRadius.sm,
                      ),
                      child: const Icon(Icons.add_road_outlined, size: 18, color: Color(0xFF3B82F6)),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Log Field Travel & GPS Mileage',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close, size: 20),
                ),
              ],
            ),
          ),

          // Form Body
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _label('Field Personnel', isDark),
                Container(
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1B202E) : const Color(0xFFF8FAFC),
                    borderRadius: AppRadius.md,
                    border: Border.all(color: isDark ? Colors.white12 : Colors.black12),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedEmployeeId,
                      isExpanded: true,
                      dropdownColor: isDark ? const Color(0xFF1A1F2C) : Colors.white,
                      items: employees.map((e) {
                        return DropdownMenuItem(value: e.id, child: Text('${e.fullName} (${e.role})'));
                      }).toList(),
                      onChanged: (v) => setState(() => _selectedEmployeeId = v!),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),

                Row(
                  children: [
                    Expanded(child: _field('Origin Point', _originCtrl, 'e.g. BKC HQ', isDark)),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(child: _field('Destination Site', _destCtrl, 'e.g. Worli Penthouse', isDark)),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),

                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _label('Vehicle Mode', isDark),
                          Container(
                            height: 40,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: isDark ? const Color(0xFF1B202E) : const Color(0xFFF8FAFC),
                              borderRadius: AppRadius.md,
                              border: Border.all(color: isDark ? Colors.white12 : Colors.black12),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<TravelMode>(
                                value: _selectedMode,
                                isExpanded: true,
                                dropdownColor: isDark ? const Color(0xFF1A1F2C) : Colors.white,
                                items: TravelMode.values.map((m) {
                                  return DropdownMenuItem(value: m, child: Text(m.label));
                                }).toList(),
                                onChanged: (v) => setState(() => _selectedMode = v!),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      flex: 2,
                      child: _field('Distance (KM)', _distanceCtrl, '18.5', isDark, onChanged: (_) => setState(() {})),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),

                // Rate & Claim calculation pill
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981).withValues(alpha: 0.1),
                    borderRadius: AppRadius.md,
                    border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.2)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Policy Rate: ₹$_ratePerKm / KM',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF10B981),
                        ),
                      ),
                      Text(
                        'Reimbursement Claim: ₹${_totalClaim.toStringAsFixed(2)}',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF10B981),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),

                // Selfies toggle simulation
                Row(
                  children: [
                    Expanded(
                      child: CheckboxListTile(
                        value: _hasDepartureSelfie,
                        onChanged: (v) => setState(() => _hasDepartureSelfie = v ?? false),
                        title: Text('Departure Selfie', style: GoogleFonts.plusJakartaSans(fontSize: 11)),
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                    ),
                    Expanded(
                      child: CheckboxListTile(
                        value: _hasArrivalSelfie,
                        onChanged: (v) => setState(() => _hasArrivalSelfie = v ?? false),
                        title: Text('Arrival Selfie', style: GoogleFonts.plusJakartaSans(fontSize: 11)),
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                    ),
                  ],
                ),

                _field('Purpose of Site Visit', _purposeCtrl, 'e.g. Contractor audit', isDark),
              ],
            ),
          ),

          // Actions
          Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: isDark ? Colors.white10 : Colors.black12)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Cancel', style: GoogleFonts.plusJakartaSans(fontSize: 12)),
                ),
                const SizedBox(width: AppSpacing.sm),
                ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3B82F6),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  ),
                  child: Text('Submit Travel Claim', style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _field(String label, TextEditingController ctrl, String hint, bool isDark, {ValueChanged<String>? onChanged}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label(label, isDark),
        Container(
          height: 38,
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1B202E) : const Color(0xFFF8FAFC),
            borderRadius: AppRadius.md,
            border: Border.all(color: isDark ? Colors.white12 : Colors.black12),
          ),
          child: TextField(
            controller: ctrl,
            onChanged: onChanged,
            style: GoogleFonts.plusJakartaSans(fontSize: 12, color: isDark ? Colors.white : const Color(0xFF0F172A)),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: GoogleFonts.plusJakartaSans(fontSize: 12, color: const Color(0xFF94A3B8)),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            ),
          ),
        ),
      ],
    );
  }

  Widget _label(String text, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        text,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569),
        ),
      ),
    );
  }
}
