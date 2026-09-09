import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../models/after_sales_models.dart';
import '../models/after_sales_mock_data.dart';

class CreateComplaintModal extends StatefulWidget {
  final ValueChanged<Complaint> onComplaintCreated;

  const CreateComplaintModal({
    super.key,
    required this.onComplaintCreated,
  });

  @override
  State<CreateComplaintModal> createState() => _CreateComplaintModalState();
}

class _CreateComplaintModalState extends State<CreateComplaintModal> {
  final _formKey = GlobalKey<FormState>();

  late ServiceRequest _selectedProjectSource;
  String _complaintType = 'Workmanship & Quality Defect';
  ComplaintSeverity _severity = ComplaintSeverity.severe;
  final TextEditingController _subjectCtrl = TextEditingController();
  final TextEditingController _descCtrl = TextEditingController();
  final TextEditingController _areaRoomCtrl = TextEditingController(text: 'Kitchen Area');
  final TextEditingController _locationCtrl = TextEditingController(text: 'Base cabinet counter interface');
  final TextEditingController _impactCtrl = TextEditingController();
  final TextEditingController _expectedResolutionCtrl = TextEditingController();

  // Snag list builder
  final List<SnagItem> _snags = [];
  final TextEditingController _snagDescCtrl = TextEditingController();
  final TextEditingController _snagRoomCtrl = TextEditingController(text: 'Kitchen');
  final TextEditingController _snagTeamCtrl = TextEditingController(text: 'Modular Carpentry Team');
  final ServicePriority _snagPriority = ServicePriority.high;

  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _selectedProjectSource = AfterSalesMockData.serviceRequests.first;
    _snags.add(
      SnagItem(
        id: 'SNG-${DateTime.now().millisecondsSinceEpoch}-1',
        snagNumber: 'SNG-01',
        complaintId: 'TEMP',
        roomArea: 'Kitchen',
        specificLocation: 'Countertop drawer alignment',
        description: 'Uneven vertical reveal gap between cabinet drawer fronts.',
        photoUrl: 'https://images.unsplash.com/photo-1556911220-e15b29be8c8f?w=400',
        responsibleTeam: 'Modular Carpentry Team',
        assignedPerson: 'Dinesh Carpenter Lead',
        priority: ServicePriority.high,
        targetDate: DateTime.now().add(const Duration(days: 2)),
        status: SnagItemStatus.identified,
      ),
    );
  }

  @override
  void dispose() {
    _subjectCtrl.dispose();
    _descCtrl.dispose();
    _areaRoomCtrl.dispose();
    _locationCtrl.dispose();
    _impactCtrl.dispose();
    _expectedResolutionCtrl.dispose();
    _snagDescCtrl.dispose();
    _snagRoomCtrl.dispose();
    _snagTeamCtrl.dispose();
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
        width: 820,
        height: 740,
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Modal Title
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.red.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.report_problem_rounded, color: Colors.red, size: 22),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Register Formal Customer Complaint & Snag Dossier', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: textPrimaryColor)),
                          Text('Supports multi-snag item breakdown, severity scoring, and manager escalation', style: TextStyle(fontSize: 12, color: textSecondaryColor)),
                        ],
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const Divider(height: 24),

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Project Selector
                      DropdownButtonFormField<String>(
                        initialValue: _selectedProjectSource.projectId,
                        decoration: InputDecoration(
                          labelText: 'Select Customer & Handover Project *',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          filled: true,
                          fillColor: backgroundColor,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        ),
                        items: AfterSalesMockData.serviceRequests.map((req) {
                          return DropdownMenuItem(
                            value: req.projectId,
                            child: Text('${req.projectName} — ${req.customerName} (${req.projectId})'),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) {
                            final match = AfterSalesMockData.serviceRequests.firstWhere((r) => r.projectId == val);
                            setState(() => _selectedProjectSource = match);
                          }
                        },
                      ),
                      const SizedBox(height: 16),

                      // Complaint Type & Severity
                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: DropdownButtonFormField<String>(
                              initialValue: _complaintType,
                              decoration: InputDecoration(
                                labelText: 'Complaint Type *',
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                filled: true,
                                fillColor: backgroundColor,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              ),
                              items: const [
                                DropdownMenuItem(value: 'Workmanship & Quality Defect', child: Text('Workmanship & Quality Defect')),
                                DropdownMenuItem(value: 'Material & Waterproofing Defect', child: Text('Material & Waterproofing Defect')),
                                DropdownMenuItem(value: 'Design & Dimension Discrepancy', child: Text('Design & Dimension Discrepancy')),
                                DropdownMenuItem(value: 'Installation & Fitment', child: Text('Installation & Fitment')),
                                DropdownMenuItem(value: 'Service Delay & Response SLA', child: Text('Service Delay & Response SLA')),
                                DropdownMenuItem(value: 'Billing & Commercial Issue', child: Text('Billing & Commercial Issue')),
                              ],
                              onChanged: (val) {
                                if (val != null) setState(() => _complaintType = val);
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 2,
                            child: DropdownButtonFormField<ComplaintSeverity>(
                              initialValue: _severity,
                              decoration: InputDecoration(
                                labelText: 'Severity Level *',
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                filled: true,
                                fillColor: backgroundColor,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              ),
                              items: ComplaintSeverity.values.map((s) {
                                return DropdownMenuItem(
                                  value: s,
                                  child: Text(s.label, style: TextStyle(fontSize: 12, color: s.color, fontWeight: FontWeight.w700)),
                                );
                              }).toList(),
                              onChanged: (val) {
                                if (val != null) setState(() => _severity = val);
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // Subject & Description
                      TextFormField(
                        controller: _subjectCtrl,
                        decoration: InputDecoration(
                          labelText: 'Complaint Subject *',
                          hintText: 'e.g. Kitchen Island Quartz Countertop Joint Gap & Cabinet Alignment',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          filled: true,
                          fillColor: backgroundColor,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        ),
                        validator: (val) => (val == null || val.trim().isEmpty) ? 'Please specify subject' : null,
                      ),
                      const SizedBox(height: 14),

                      TextFormField(
                        controller: _descCtrl,
                        maxLines: 3,
                        decoration: InputDecoration(
                          labelText: 'Comprehensive Complaint Narrative *',
                          hintText: 'Provide complete details of client feedback, frustration points, and historical context...',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          filled: true,
                          fillColor: backgroundColor,
                          contentPadding: const EdgeInsets.all(14),
                        ),
                        validator: (val) => (val == null || val.trim().isEmpty) ? 'Please enter narrative' : null,
                      ),
                      const SizedBox(height: 14),

                      // Area / Room & Location
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _areaRoomCtrl,
                              decoration: InputDecoration(
                                labelText: 'Area / Room',
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
                              controller: _locationCtrl,
                              decoration: InputDecoration(
                                labelText: 'Specific Location',
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

                      // Customer Impact & Expected Resolution
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _impactCtrl,
                              decoration: InputDecoration(
                                labelText: 'Customer Impact & Risk',
                                hintText: 'e.g. Inconvenience in cooking, potential damage to timber floor...',
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
                              controller: _expectedResolutionCtrl,
                              decoration: InputDecoration(
                                labelText: 'Expected Resolution & Sign-off Goal',
                                hintText: 'e.g. Re-grouting with Tenax epoxy and leveling drawer fronts...',
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                filled: true,
                                fillColor: backgroundColor,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Section 3: Nested Snags Builder
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: backgroundColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: borderColor),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.format_list_bulleted_rounded, size: 18, color: AppColors.primary),
                                    const SizedBox(width: 8),
                                    Text(
                                      'INDIVIDUAL SNAG ITEMS (${_snags.length})',
                                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: textPrimaryColor, letterSpacing: 0.5),
                                    ),
                                  ],
                                ),
                                const Text(
                                  'Each snag has individual status and team assignment',
                                  style: TextStyle(fontSize: 10, color: Color(0xFF10B981), fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),

                            // List of added snags
                            ..._snags.asMap().entries.map((entry) {
                              final idx = entry.key;
                              final snag = entry.value;
                              return Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: surfaceColor,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: borderColor),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: AppColors.primary.withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text('SNAG ${idx + 1}', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 10, color: AppColors.primary)),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(snag.description, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: textPrimaryColor)),
                                          Text('${snag.roomArea} • ${snag.responsibleTeam} • Priority: ${snag.priority.name.toUpperCase()}', style: TextStyle(fontSize: 10, color: textSecondaryColor)),
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete_outline, size: 18, color: Colors.red),
                                      onPressed: () => setState(() => _snags.removeAt(idx)),
                                    ),
                                  ],
                                ),
                              );
                            }),

                            const SizedBox(height: 8),
                            // Quick Add Snag Inputs
                            Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: TextField(
                                    controller: _snagDescCtrl,
                                    decoration: InputDecoration(
                                      hintText: 'Enter snag defect description...',
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                      filled: true,
                                      fillColor: surfaceColor,
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  flex: 2,
                                  child: TextField(
                                    controller: _snagRoomCtrl,
                                    decoration: InputDecoration(
                                      hintText: 'Room / Area',
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                      filled: true,
                                      fillColor: surfaceColor,
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                OutlinedButton.icon(
                                  onPressed: () {
                                    final desc = _snagDescCtrl.text.trim();
                                    if (desc.isNotEmpty) {
                                      setState(() {
                                        _snags.add(
                                          SnagItem(
                                            id: 'SNG-${DateTime.now().millisecondsSinceEpoch}',
                                            snagNumber: 'SNG-0${_snags.length + 1}',
                                            complaintId: 'NEW',
                                            roomArea: _snagRoomCtrl.text.trim().isEmpty ? 'General Area' : _snagRoomCtrl.text.trim(),
                                            specificLocation: 'Assigned location',
                                            description: desc,
                                            photoUrl: 'https://images.unsplash.com/photo-1556911220-e15b29be8c8f?w=400',
                                            responsibleTeam: _snagTeamCtrl.text.trim(),
                                            assignedPerson: 'Lead Technician',
                                            priority: _snagPriority,
                                            targetDate: DateTime.now().add(const Duration(days: 3)),
                                            status: SnagItemStatus.identified,
                                          ),
                                        );
                                        _snagDescCtrl.clear();
                                      });
                                    }
                                  },
                                  icon: const Icon(Icons.add, size: 16),
                                  label: const Text('Add Snag'),
                                  style: OutlinedButton.styleFrom(
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: _isSubmitting ? null : _submitComplaint,
                    icon: _isSubmitting
                        ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : const Icon(Icons.send_rounded, size: 18),
                    label: Text(_isSubmitting ? 'LOGGING COMPLAINT...' : 'LOG COMPLAINT & ESCALATE'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade700,
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

  void _submitComplaint() {
    if (!_formKey.currentState!.validate()) return;

    final nav = Navigator.of(context);
    setState(() => _isSubmitting = true);

    Future.delayed(const Duration(milliseconds: 350), () {
      final complaint = Complaint(
        id: 'CMP-2026-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
        complaintNumber: 'CMP-${1040 + DateTime.now().millisecond % 50}',
        customerId: _selectedProjectSource.customerId,
        customerName: _selectedProjectSource.customerName,
        customerPhone: _selectedProjectSource.customerPhone,
        customerEmail: _selectedProjectSource.customerEmail,
        projectId: _selectedProjectSource.projectId,
        projectName: _selectedProjectSource.projectName,
        siteAddress: _selectedProjectSource.siteAddress,
        projectManager: _selectedProjectSource.projectManager,
        supervisor: _selectedProjectSource.supervisor,
        handoverDate: _selectedProjectSource.handoverDate,
        complaintType: _complaintType,
        subject: _subjectCtrl.text.trim(),
        description: _descCtrl.text.trim(),
        areaRoom: _areaRoomCtrl.text.trim(),
        specificLocation: _locationCtrl.text.trim(),
        issueDate: DateTime.now(),
        severity: _severity,
        customerImpact: _impactCtrl.text.trim().isEmpty ? 'Dissatisfaction reported.' : _impactCtrl.text.trim(),
        expectedResolution: _expectedResolutionCtrl.text.trim().isEmpty ? 'Full inspection and repair.' : _expectedResolutionCtrl.text.trim(),
        status: ComplaintStatus.raised,
        assignedToName: 'Amit Service Manager',
        assignedToRole: 'Regional Service Lead',
        createdDate: DateTime.now(),
        dueDate: DateTime.now().add(const Duration(days: 2)),
        escalationLevel: 'Service Manager Review',
        inspectionRequired: true,
        snags: _snags,
      );

      widget.onComplaintCreated(complaint);
      nav.pop();
    });
  }
}
