import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../models/after_sales_models.dart';
import '../models/after_sales_mock_data.dart';

class ScheduleVisitModal extends StatefulWidget {
  final ServiceRequest? initialRequest;
  final ValueChanged<ServiceVisit> onVisitScheduled;

  const ScheduleVisitModal({
    super.key,
    this.initialRequest,
    required this.onVisitScheduled,
  });

  @override
  State<ScheduleVisitModal> createState() => _ScheduleVisitModalState();
}

class _ScheduleVisitModalState extends State<ScheduleVisitModal> {
  final _formKey = GlobalKey<FormState>();

  late ServiceRequest _selectedReq;
  VisitType _visitType = VisitType.correctiveRepair;
  final TextEditingController _purposeCtrl = TextEditingController();
  final TextEditingController _instructionsCtrl = TextEditingController(text: 'Bring shoe covers and drop cloth. Verify client issue before starting.');
  final TextEditingController _toolsCtrl = TextEditingController(text: 'Cordless drill, Laser level, Torx bit set, Drop cloth');
  final TextEditingController _materialsCtrl = TextEditingController(text: 'Replacement hardware parts, silicone sealant');

  DateTime _visitDate = DateTime.now().add(const Duration(days: 1));
  String _startTime = '10:00 AM';
  final String _endTime = '11:30 AM';
  String _assignedEmployee = 'Suresh Gowda (Supervisor)';
  String _assignedTechnician = 'Dinesh Carpenter Lead';

  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _selectedReq = widget.initialRequest ?? AfterSalesMockData.serviceRequests.first;
    _purposeCtrl.text = 'Investigate and resolve: ${_selectedReq.subject}';
  }

  @override
  void dispose() {
    _purposeCtrl.dispose();
    _instructionsCtrl.dispose();
    _toolsCtrl.dispose();
    _materialsCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final surfaceColor = AppColors.getSurface(context);
    final backgroundColor = AppColors.getBackground(context);
    final textPrimaryColor = AppColors.getTextPrimary(context);
    final textSecondaryColor = AppColors.getTextSecondary(context);

    return Dialog(
      backgroundColor: surfaceColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 760,
        height: 680,
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0284C7).withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.calendar_month_rounded, color: Color(0xFF0284C7), size: 22),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Schedule On-Site Service Visit', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: textPrimaryColor)),
                          Text('Dispatches technician with mobile GPS check-in & inspection checklist', style: TextStyle(fontSize: 12, color: textSecondaryColor)),
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
                      // Linked Request Selector
                      DropdownButtonFormField<String>(
                        initialValue: _selectedReq.id,
                        decoration: InputDecoration(
                          labelText: 'Linked Service Request *',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          filled: true,
                          fillColor: backgroundColor,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        ),
                        items: AfterSalesMockData.serviceRequests.map((req) {
                          return DropdownMenuItem(
                            value: req.id,
                            child: Text('${req.requestNumber} — ${req.customerName} (${req.projectName})'),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) {
                            final match = AfterSalesMockData.serviceRequests.firstWhere((r) => r.id == val);
                            setState(() {
                              _selectedReq = match;
                              _purposeCtrl.text = 'Investigate and resolve: ${match.subject}';
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 14),

                      // Visit Type & Date
                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: DropdownButtonFormField<VisitType>(
                              initialValue: _visitType,
                              decoration: InputDecoration(
                                labelText: 'Visit Type *',
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                filled: true,
                                fillColor: backgroundColor,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              ),
                              items: VisitType.values.map((v) {
                                return DropdownMenuItem(value: v, child: Text(v.label, style: const TextStyle(fontSize: 12)));
                              }).toList(),
                              onChanged: (val) {
                                if (val != null) setState(() => _visitType = val);
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 2,
                            child: InkWell(
                              onTap: () async {
                                final picked = await showDatePicker(
                                  context: context,
                                  initialDate: _visitDate,
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime.now().add(const Duration(days: 60)),
                                );
                                if (picked != null) setState(() => _visitDate = picked);
                              },
                              child: InputDecorator(
                                decoration: InputDecoration(
                                  labelText: 'Visit Date',
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                  filled: true,
                                  fillColor: backgroundColor,
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                ),
                                child: Text('${_visitDate.day}/${_visitDate.month}/${_visitDate.year}'),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 2,
                            child: DropdownButtonFormField<String>(
                              initialValue: _startTime,
                              decoration: InputDecoration(
                                labelText: 'Start Time',
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                filled: true,
                                fillColor: backgroundColor,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              ),
                              items: const [
                                DropdownMenuItem(value: '09:00 AM', child: Text('09:00 AM')),
                                DropdownMenuItem(value: '10:00 AM', child: Text('10:00 AM')),
                                DropdownMenuItem(value: '02:00 PM', child: Text('02:00 PM')),
                                DropdownMenuItem(value: '04:00 PM', child: Text('04:00 PM')),
                              ],
                              onChanged: (val) {
                                if (val != null) setState(() => _startTime = val);
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // Assigned Supervisor & Lead Technician
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              initialValue: _assignedEmployee,
                              decoration: InputDecoration(
                                labelText: 'Supervising Engineer / Manager *',
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                filled: true,
                                fillColor: backgroundColor,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              ),
                              items: const [
                                DropdownMenuItem(value: 'Suresh Gowda (Supervisor)', child: Text('Suresh Gowda (Supervisor)')),
                                DropdownMenuItem(value: 'Amit Service Manager', child: Text('Amit Service Manager')),
                                DropdownMenuItem(value: 'Deepak Patil (Supervisor)', child: Text('Deepak Patil (Supervisor)')),
                                DropdownMenuItem(value: 'Rakesh Sharma (Supervisor)', child: Text('Rakesh Sharma (Supervisor)')),
                              ],
                              onChanged: (val) {
                                if (val != null) setState(() => _assignedEmployee = val);
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              initialValue: _assignedTechnician,
                              decoration: InputDecoration(
                                labelText: 'Lead Field Technician *',
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                filled: true,
                                fillColor: backgroundColor,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              ),
                              items: const [
                                DropdownMenuItem(value: 'Dinesh Carpenter Lead', child: Text('Dinesh (Carpentry)')),
                                DropdownMenuItem(value: 'Santosh Electrician', child: Text('Santosh (Electrical/MEP)')),
                                DropdownMenuItem(value: 'Harish Civil Engineer', child: Text('Harish (Waterproofing)')),
                                DropdownMenuItem(value: 'Karthik Plumber', child: Text('Karthik (Plumbing)')),
                                DropdownMenuItem(value: 'Ramesh Painter Lead', child: Text('Ramesh (PU Polish & Paint)')),
                              ],
                              onChanged: (val) {
                                if (val != null) setState(() => _assignedTechnician = val);
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // Purpose
                      TextFormField(
                        controller: _purposeCtrl,
                        decoration: InputDecoration(
                          labelText: 'Visit Purpose & Scope *',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          filled: true,
                          fillColor: backgroundColor,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        ),
                        validator: (val) => (val == null || val.trim().isEmpty) ? 'Please enter purpose' : null,
                      ),
                      const SizedBox(height: 14),

                      // Required Tools & Materials
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _toolsCtrl,
                              decoration: InputDecoration(
                                labelText: 'Required Equipment & Tools',
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                filled: true,
                                fillColor: backgroundColor,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              controller: _materialsCtrl,
                              decoration: InputDecoration(
                                labelText: 'Required Parts & Materials',
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                filled: true,
                                fillColor: backgroundColor,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // Special Instructions
                      TextFormField(
                        controller: _instructionsCtrl,
                        maxLines: 2,
                        decoration: InputDecoration(
                          labelText: 'Site Access & Preparation Instructions',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          filled: true,
                          fillColor: backgroundColor,
                          contentPadding: const EdgeInsets.all(12),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Actions
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: _isSubmitting ? null : _scheduleVisit,
                    icon: _isSubmitting
                        ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : const Icon(Icons.send_rounded, size: 18),
                    label: Text(_isSubmitting ? 'DISPATCHING...' : 'CONFIRM & DISPATCH VISIT'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0284C7),
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
      ),
    );
  }

  void _scheduleVisit() {
    if (!_formKey.currentState!.validate()) return;

    final nav = Navigator.of(context);
    setState(() => _isSubmitting = true);

    Future.delayed(const Duration(milliseconds: 350), () {
      final visit = ServiceVisit(
        id: 'VST-2026-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
        visitNumber: 'VST-${_selectedReq.customerName.substring(0, 3).toUpperCase()}-${DateTime.now().millisecond}',
        serviceRequestId: _selectedReq.id,
        customerId: _selectedReq.customerId,
        customerName: _selectedReq.customerName,
        customerPhone: _selectedReq.customerPhone,
        projectId: _selectedReq.projectId,
        projectName: _selectedReq.projectName,
        siteAddress: _selectedReq.siteAddress,
        visitType: _visitType,
        purpose: _purposeCtrl.text.trim(),
        visitDate: _visitDate,
        startTime: _startTime,
        endTime: _endTime,
        assignedEmployee: _assignedEmployee,
        assignedTechnician: _assignedTechnician,
        contactPerson: _selectedReq.customerName,
        contactNumber: _selectedReq.customerPhone,
        specialInstructions: _instructionsCtrl.text.trim(),
        requiredTools: _toolsCtrl.text.split(',').map((s) => s.trim()).toList(),
        requiredMaterials: _materialsCtrl.text.split(',').map((s) => s.trim()).toList(),
        status: ServiceVisitStatus.scheduled,
        checklist: [
          const VisitChecklistItem(id: 'CHK-01', title: 'Verify client reported issue on site', isChecked: false),
          const VisitChecklistItem(id: 'CHK-02', title: 'Inspect surrounding woodwork/fixtures', isChecked: false),
          const VisitChecklistItem(id: 'CHK-03', title: 'Perform corrective service or replacement', isChecked: false),
          const VisitChecklistItem(id: 'CHK-04', title: 'Clean site & collect debris', isChecked: false),
          const VisitChecklistItem(id: 'CHK-05', title: 'Demonstrate function and get client signature', isChecked: false),
        ],
      );

      widget.onVisitScheduled(visit);
      nav.pop();
    });
  }
}
