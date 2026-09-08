import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../models/labour_models.dart';

class HireLabourModal extends StatefulWidget {
  final LabourProfile? selectedWorker;
  final Function(ServiceBooking newBooking) onBookingCreated;

  const HireLabourModal({
    super.key,
    this.selectedWorker,
    required this.onBookingCreated,
  });

  @override
  State<HireLabourModal> createState() => _HireLabourModalState();
}

class _HireLabourModalState extends State<HireLabourModal> {
  final _formKey = GlobalKey<FormState>();

  String _selectedProjectId = 'PRJ-104';
  String _selectedProjectName = 'PRJ-104 - 4BHK DLF Phase 5';
  final String _selectedClientId = 'CLI-801';
  String _selectedClientName = 'Vikram Malhotra';
  String _selectedSupervisor = 'Amit Joshi (Site Supervisor)';

  TradeType _trade = TradeType.carpentry;
  int _tradesmenCount = 1;
  int _durationDays = 5;
  final String _rateModel = 'Daily Shift Rate';
  double _dealValue = 18500.0;
  final double _advancePercentage = 25.0; // 25% advance
  final TextEditingController _scopeController = TextEditingController(
    text: 'Custom wardrobe framing, laminate bonding & soft-close channel installation as per 2D drawing WD-04.',
  );
  final TextEditingController _locationController = TextEditingController(
    text: 'DLF Phase 5, Tower 4, Flat 1402, Gurugram',
  );

  bool _enableAutoReassign = true;
  bool _termsAccepted = false;

  @override
  void initState() {
    super.initState();
    if (widget.selectedWorker != null) {
      _trade = widget.selectedWorker!.trade;
      _calculateDealValue();
    }
  }

  void _calculateDealValue() {
    if (widget.selectedWorker != null) {
      if (_rateModel == 'Daily Shift Rate') {
        _dealValue = widget.selectedWorker!.dailyRate * _tradesmenCount * _durationDays;
      } else {
        _dealValue = widget.selectedWorker!.sqftRate * 250; // assuming standard 250 sq.ft job
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final surfaceColor = AppColors.getSurface(context);
    final backgroundColor = AppColors.getBackground(context);
    final borderColor = AppColors.getBorder(context);
    final textPrimaryColor = AppColors.getTextPrimary(context);
    final textSecondaryColor = AppColors.getTextSecondary(context);
    final textMutedColor = AppColors.getTextMuted(context);

    final advanceAmount = (_dealValue * (_advancePercentage / 100.0));
    final balanceAmount = _dealValue - advanceAmount;
    final platformCommission = _dealValue * 0.10; // 10% platform fee

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Container(
        width: 720,
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
            // Modal Header
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
                    child: const Icon(Icons.handshake_rounded, color: AppColors.primary, size: 22),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.selectedWorker != null
                              ? 'Book Worker: ${widget.selectedWorker!.legalName}'
                              : 'Dispatch Open Labour Request',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: textPrimaryColor,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          widget.selectedWorker != null
                              ? '${widget.selectedWorker!.trade.label} • Rate: ₹${widget.selectedWorker!.dailyRate.toStringAsFixed(0)}/day'
                              : 'Broadcast booking to verified nearby tradesmen within 10 km',
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

            // Modal Body
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Section 1: Project & Supervisor Association
                      Text(
                        '1. Project & Site Assignment',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: textPrimaryColor),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              initialValue: _selectedProjectId,
                              decoration: InputDecoration(
                                labelText: 'Target Project',
                                prefixIcon: const Icon(Icons.apartment_rounded, size: 18),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                filled: true,
                                fillColor: backgroundColor,
                              ),
                              items: const [
                                DropdownMenuItem(value: 'PRJ-104', child: Text('PRJ-104 - 4BHK DLF Phase 5')),
                                DropdownMenuItem(value: 'PRJ-105', child: Text('PRJ-105 - Golf Links Luxury Villa')),
                                DropdownMenuItem(value: 'PRJ-106', child: Text('PRJ-106 - Bandra Penthouse')),
                                DropdownMenuItem(value: 'PRJ-107', child: Text('PRJ-107 - Whitefield Tech Villa')),
                              ],
                              onChanged: (val) {
                                if (val != null) {
                                  setState(() {
                                    _selectedProjectId = val;
                                    if (val == 'PRJ-104') {
                                      _selectedProjectName = 'PRJ-104 - 4BHK DLF Phase 5';
                                      _selectedClientName = 'Vikram Malhotra';
                                      _selectedSupervisor = 'Amit Joshi (Site Supervisor)';
                                      _locationController.text = 'DLF Phase 5, Tower 4, Flat 1402, Gurugram';
                                    } else if (val == 'PRJ-105') {
                                      _selectedProjectName = 'PRJ-105 - Golf Links Luxury Villa';
                                      _selectedClientName = 'Sanjay Singhania';
                                      _selectedSupervisor = 'Rohit Verma (Site Supervisor)';
                                      _locationController.text = 'Golf Links, Bungalow 42, New Delhi';
                                    } else if (val == 'PRJ-106') {
                                      _selectedProjectName = 'PRJ-106 - Bandra Sea-Facing Penthouse';
                                      _selectedClientName = 'Pooja Hegde';
                                      _selectedSupervisor = 'Pradeep Patil (Site Supervisor)';
                                      _locationController.text = 'Carter Road, Bandra West, Mumbai';
                                    } else {
                                      _selectedProjectName = 'PRJ-107 - Whitefield Tech Executive Villa';
                                      _selectedClientName = 'Rohan Deshmukh';
                                      _selectedSupervisor = 'Kiran Gowda (Site Supervisor)';
                                      _locationController.text = 'EPIP Zone, Whitefield, Bangalore';
                                    }
                                  });
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              initialValue: _selectedSupervisor,
                              readOnly: true,
                              decoration: InputDecoration(
                                labelText: 'Assigned Site Supervisor',
                                prefixIcon: const Icon(Icons.engineering_outlined, size: 18),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                filled: true,
                                fillColor: backgroundColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _locationController,
                        decoration: InputDecoration(
                          labelText: 'Site Location / Delivery Address',
                          prefixIcon: const Icon(Icons.location_on_outlined, size: 18),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          filled: true,
                          fillColor: backgroundColor,
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Section 2: Scope & Duration
                      Text(
                        '2. Scope of Work & Duration',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: textPrimaryColor),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _scopeController,
                        maxLines: 2,
                        decoration: InputDecoration(
                          labelText: 'Detailed Scope Description',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          filled: true,
                          fillColor: backgroundColor,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<int>(
                              initialValue: _tradesmenCount,
                              decoration: InputDecoration(
                                labelText: 'Number of Tradesmen',
                                prefixIcon: const Icon(Icons.groups_outlined, size: 18),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                filled: true,
                                fillColor: backgroundColor,
                              ),
                              items: [1, 2, 3, 4, 5].map((cnt) {
                                return DropdownMenuItem(value: cnt, child: Text('$cnt Tradesman / Workers'));
                              }).toList(),
                              onChanged: (val) {
                                if (val != null) {
                                  _tradesmenCount = val;
                                  _calculateDealValue();
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: DropdownButtonFormField<int>(
                              initialValue: _durationDays,
                              decoration: InputDecoration(
                                labelText: 'Estimated Duration (Days)',
                                prefixIcon: const Icon(Icons.calendar_month_outlined, size: 18),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                filled: true,
                                fillColor: backgroundColor,
                              ),
                              items: [1, 2, 3, 5, 7, 10, 14, 21, 30].map((days) {
                                return DropdownMenuItem(value: days, child: Text('$days Working Days'));
                              }).toList(),
                              onChanged: (val) {
                                if (val != null) {
                                  _durationDays = val;
                                  _calculateDealValue();
                                }
                              },
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Section 3: Commercials & Payout Split
                      Text(
                        '3. Commercial Calculation & Wage Release',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: textPrimaryColor),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: backgroundColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: borderColor),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Total Estimated Deal Value:', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: textPrimaryColor)),
                                Text('₹${_dealValue.toStringAsFixed(0)}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: textPrimaryColor)),
                              ],
                            ),
                            const Divider(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Advance Payout (${_advancePercentage.toStringAsFixed(0)}% upon site check-in):', style: TextStyle(fontSize: 12, color: textSecondaryColor)),
                                Text('₹${advanceAmount.toStringAsFixed(0)}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF10B981))),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Balance Payable (Post Supervisor Sign-off):', style: TextStyle(fontSize: 12, color: textSecondaryColor)),
                                Text('₹${balanceAmount.toStringAsFixed(0)}', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: textPrimaryColor)),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Platform Assurance & Safety Fee (10%):', style: TextStyle(fontSize: 12, color: textSecondaryColor)),
                                Text('₹${platformCommission.toStringAsFixed(0)}', style: TextStyle(fontSize: 12, color: textMutedColor)),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Auto-Reassign Toggle & Terms
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF3B82F6).withValues(alpha: 0.06),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFF3B82F6).withValues(alpha: 0.2)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.timer_outlined, size: 20, color: Color(0xFF3B82F6)),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                '15-Minute SLA Auto-Reassign: If the selected worker does not accept within 15 minutes, broadcast automatically to the next best-rated tradesman.',
                                style: TextStyle(fontSize: 11, color: textPrimaryColor),
                              ),
                            ),
                            Switch(
                              value: _enableAutoReassign,
                              activeTrackColor: AppColors.primary,
                              onChanged: (val) => setState(() => _enableAutoReassign = val),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 14),

                      CheckboxListTile(
                        contentPadding: EdgeInsets.zero,
                        value: _termsAccepted,
                        activeColor: AppColors.primary,
                        title: Text(
                          'I accept the Homio Labour Marketplace Terms, Daily Checklist Sign-off rules, and binding Legal Protection Policy.',
                          style: TextStyle(fontSize: 12, color: textSecondaryColor),
                        ),
                        onChanged: (val) => setState(() => _termsAccepted = val ?? false),
                      ),
                    ],
                  ),
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
                    onPressed: _termsAccepted
                        ? () {
                            final newBooking = ServiceBooking(
                              id: 'BK-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
                              bookingNumber: 'HOM-SB-2024-${DateTime.now().millisecondsSinceEpoch.toString().substring(10)}',
                              projectId: _selectedProjectId,
                              projectName: _selectedProjectName,
                              clientId: _selectedClientId,
                              clientName: _selectedClientName,
                              supervisorId: 'SUP-401',
                              supervisorName: _selectedSupervisor,
                              tradesmanId: widget.selectedWorker?.id ?? 'LBR-AUTO',
                              tradesmanName: widget.selectedWorker?.legalName ?? 'Broadcast Auto-Assign',
                              tradesmanPhone: widget.selectedWorker?.phone ?? '+91 98100 00000',
                              trade: _trade,
                              scopeDescription: _scopeController.text,
                              tradesmenCount: _tradesmenCount,
                              dealValue: _dealValue,
                              advancePaid: advanceAmount,
                              balanceDue: balanceAmount,
                              platformCommission: platformCommission,
                              status: BookingStatus.requested,
                              startDate: DateTime.now(),
                              endDate: DateTime.now().add(Duration(days: _durationDays)),
                              siteLocation: _locationController.text,
                              gpsCheckInStamp: 'Pending GPS site arrival',
                              termsAccepted: true,
                              autoReassignTimer: '15:00',
                              dailyChecklist: [
                                const DailyChecklistItem(id: 'CHK-1', title: 'Site dimensions & drawing alignment verification', isCompleted: false),
                                const DailyChecklistItem(id: 'CHK-2', title: 'Raw material grade & toolset inspection', isCompleted: false),
                                const DailyChecklistItem(id: 'CHK-3', title: 'Daily progress execution & snag-free clean site handover', isCompleted: false),
                              ],
                            );
                            widget.onBookingCreated(newBooking);
                            Navigator.of(context).pop();
                          }
                        : null,
                    icon: const Icon(Icons.send_rounded, size: 16),
                    label: const Text('Confirm & Dispatch Booking'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
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
