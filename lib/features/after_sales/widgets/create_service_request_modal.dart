import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../models/after_sales_models.dart';
import '../models/after_sales_mock_data.dart';

class CreateServiceRequestModal extends StatefulWidget {
  final ValueChanged<ServiceRequest> onRequestCreated;

  const CreateServiceRequestModal({
    super.key,
    required this.onRequestCreated,
  });

  @override
  State<CreateServiceRequestModal> createState() => _CreateServiceRequestModalState();
}

class _CreateServiceRequestModalState extends State<CreateServiceRequestModal> {
  final _formKey = GlobalKey<FormState>();

  // Selected project for auto-population
  late ServiceRequest _sampleSource;
  late String _selectedProjectId;
  String _customerName = '';
  String _customerPhone = '';
  String _customerEmail = '';
  String _siteAddress = '';
  String _projectManager = '';
  String _supervisor = '';
  DateTime _handoverDate = DateTime.now();

  String _requestType = 'Defect Rectification';
  ServiceCategory _category = ServiceCategory.carpentry;
  ServicePriority _priority = ServicePriority.high;
  final TextEditingController _subjectCtrl = TextEditingController();
  final TextEditingController _descCtrl = TextEditingController();
  final TextEditingController _areaRoomCtrl = TextEditingController(text: 'Master Bedroom Suite');
  final TextEditingController _locationCtrl = TextEditingController(text: 'Wardrobe Shutter Bay 1');
  final TextEditingController _expectationCtrl = TextEditingController();
  final TextEditingController _availabilityCtrl = TextEditingController(text: 'Client available in morning hours.');
  DateTime _preferredDate = DateTime.now().add(const Duration(days: 1));
  String _preferredTime = '10:00 AM - 12:00 PM';
  String _preferredChannel = 'WhatsApp';
  bool _isWarrantyCovered = true;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _sampleSource = AfterSalesMockData.serviceRequests.first;
    _applyProjectSource(_sampleSource);
  }

  void _applyProjectSource(ServiceRequest req) {
    _selectedProjectId = req.projectId;
    _customerName = req.customerName;
    _customerPhone = req.customerPhone;
    _customerEmail = req.customerEmail;
    _siteAddress = req.siteAddress;
    _projectManager = req.projectManager;
    _supervisor = req.supervisor;
    _handoverDate = req.handoverDate;
  }

  @override
  void dispose() {
    _subjectCtrl.dispose();
    _descCtrl.dispose();
    _areaRoomCtrl.dispose();
    _locationCtrl.dispose();
    _expectationCtrl.dispose();
    _availabilityCtrl.dispose();
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
        width: 800,
        height: 720,
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
                          color: AppColors.primary.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.add_task_rounded, color: AppColors.primary, size: 22),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Raise New Service Request',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: textPrimaryColor),
                          ),
                          Text(
                            'Auto-linked to verified Customer, Handover & Active Project Warranties',
                            style: TextStyle(fontSize: 12, color: textSecondaryColor),
                          ),
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

              // Scrollable Form Body
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Section 1: Customer & Project Linkage (Auto-populated)
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
                                const Text(
                                  'PROJECT & CUSTOMER CONTEXT',
                                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 0.6, color: AppColors.primary),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: Colors.green.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Text(
                                    '10-YR STRUCTURAL & 1-YR COMPREHENSIVE ACTIVE',
                                    style: TextStyle(color: Colors.green, fontSize: 10, fontWeight: FontWeight.w700),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),

                            // Project Selector
                            DropdownButtonFormField<String>(
                              initialValue: _selectedProjectId,
                              decoration: InputDecoration(
                                labelText: 'Select Handover Project *',
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                filled: true,
                                fillColor: surfaceColor,
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
                                  setState(() => _applyProjectSource(match));
                                }
                              },
                            ),
                            const SizedBox(height: 12),

                            // Read-only populated context pills
                            Row(
                              children: [
                                Expanded(child: _buildContextPill('Client', _customerName, Icons.person_outline, textPrimaryColor, textSecondaryColor)),
                                const SizedBox(width: 8),
                                Expanded(child: _buildContextPill('Phone', _customerPhone, Icons.phone_outlined, textPrimaryColor, textSecondaryColor)),
                                const SizedBox(width: 8),
                                Expanded(child: _buildContextPill('Project Manager', _projectManager, Icons.badge_outlined, textPrimaryColor, textSecondaryColor)),
                                const SizedBox(width: 8),
                                Expanded(child: _buildContextPill('Supervisor', _supervisor, Icons.engineering_outlined, textPrimaryColor, textSecondaryColor)),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Site Address: $_siteAddress (Handed over on: ${_handoverDate.day}/${_handoverDate.month}/${_handoverDate.year})',
                              style: TextStyle(fontSize: 11, color: textSecondaryColor),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Section 2: Request Classification & SLA
                      Text('Service Details & Categorization', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: textPrimaryColor)),
                      const SizedBox(height: 12),

                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: DropdownButtonFormField<ServiceCategory>(
                              initialValue: _category,
                              decoration: InputDecoration(
                                labelText: 'Service Category *',
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                filled: true,
                                fillColor: backgroundColor,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              ),
                              items: ServiceCategory.values.map((cat) {
                                return DropdownMenuItem(
                                  value: cat,
                                  child: Row(
                                    children: [
                                      Icon(cat.icon, size: 16, color: cat.color),
                                      const SizedBox(width: 8),
                                      Text(cat.label, style: const TextStyle(fontSize: 12)),
                                    ],
                                  ),
                                );
                              }).toList(),
                              onChanged: (val) {
                                if (val != null) setState(() => _category = val);
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 2,
                            child: DropdownButtonFormField<ServicePriority>(
                              initialValue: _priority,
                              decoration: InputDecoration(
                                labelText: 'Operational Priority *',
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                filled: true,
                                fillColor: backgroundColor,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              ),
                              items: ServicePriority.values.map((p) {
                                return DropdownMenuItem(
                                  value: p,
                                  child: Text(p.label, style: TextStyle(fontSize: 12, color: p.color, fontWeight: FontWeight.w600)),
                                );
                              }).toList(),
                              onChanged: (val) {
                                if (val != null) setState(() => _priority = val);
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 2,
                            child: DropdownButtonFormField<String>(
                              initialValue: _requestType,
                              decoration: InputDecoration(
                                labelText: 'Request Nature *',
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                filled: true,
                                fillColor: backgroundColor,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              ),
                              items: const [
                                DropdownMenuItem(value: 'Defect Rectification', child: Text('Defect Rectification')),
                                DropdownMenuItem(value: 'Routine Service', child: Text('Routine Service')),
                                DropdownMenuItem(value: 'Warranty Emergency', child: Text('Warranty Emergency')),
                                DropdownMenuItem(value: 'Chargeable Touchup', child: Text('Chargeable Touchup')),
                                DropdownMenuItem(value: 'Hardware Adjustment', child: Text('Hardware Adjustment')),
                              ],
                              onChanged: (val) {
                                if (val != null) setState(() => _requestType = val);
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // Subject Line
                      TextFormField(
                        controller: _subjectCtrl,
                        decoration: InputDecoration(
                          labelText: 'Subject / Issue Headline *',
                          hintText: 'e.g. Master Bedroom Wardrobe Hydraulic Shutter Stuck',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          filled: true,
                          fillColor: backgroundColor,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        ),
                        validator: (val) => (val == null || val.trim().isEmpty) ? 'Please enter a subject' : null,
                      ),
                      const SizedBox(height: 14),

                      // Detailed Description
                      TextFormField(
                        controller: _descCtrl,
                        maxLines: 3,
                        decoration: InputDecoration(
                          labelText: 'Detailed Technical Description *',
                          hintText: 'Describe the symptom, observations, sound, or physical defect noticed by customer...',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          filled: true,
                          fillColor: backgroundColor,
                          contentPadding: const EdgeInsets.all(14),
                        ),
                        validator: (val) => (val == null || val.trim().isEmpty) ? 'Please provide a detailed description' : null,
                      ),
                      const SizedBox(height: 14),

                      // Room & Specific Location
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _areaRoomCtrl,
                              decoration: InputDecoration(
                                labelText: 'Area / Room *',
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
                                labelText: 'Specific Location / Component *',
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

                      // Preferred Visit Date & Time
                      Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () async {
                                final picked = await showDatePicker(
                                  context: context,
                                  initialDate: _preferredDate,
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime.now().add(const Duration(days: 60)),
                                );
                                if (picked != null) setState(() => _preferredDate = picked);
                              },
                              child: InputDecorator(
                                decoration: InputDecoration(
                                  labelText: 'Preferred Visit Date',
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                  filled: true,
                                  fillColor: backgroundColor,
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('${_preferredDate.day}/${_preferredDate.month}/${_preferredDate.year}'),
                                    const Icon(Icons.calendar_month, size: 16),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              initialValue: _preferredTime,
                              decoration: InputDecoration(
                                labelText: 'Preferred Time Window',
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                filled: true,
                                fillColor: backgroundColor,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                              ),
                              items: const [
                                DropdownMenuItem(value: '09:00 AM - 11:00 AM', child: Text('09:00 AM - 11:00 AM')),
                                DropdownMenuItem(value: '10:00 AM - 12:00 PM', child: Text('10:00 AM - 12:00 PM')),
                                DropdownMenuItem(value: '02:00 PM - 04:00 PM', child: Text('02:00 PM - 04:00 PM')),
                                DropdownMenuItem(value: '04:00 PM - 06:00 PM', child: Text('04:00 PM - 06:00 PM')),
                              ],
                              onChanged: (val) {
                                if (val != null) setState(() => _preferredTime = val);
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              initialValue: _preferredChannel,
                              decoration: InputDecoration(
                                labelText: 'Contact Channel',
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                filled: true,
                                fillColor: backgroundColor,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                              ),
                              items: const [
                                DropdownMenuItem(value: 'WhatsApp', child: Text('WhatsApp Channel')),
                                DropdownMenuItem(value: 'Phone', child: Text('Direct Phone Call')),
                                DropdownMenuItem(value: 'Email', child: Text('Email Updates')),
                              ],
                              onChanged: (val) {
                                if (val != null) setState(() => _preferredChannel = val);
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // Availability & Notes
                      TextFormField(
                        controller: _availabilityCtrl,
                        decoration: InputDecoration(
                          labelText: 'Customer Availability & Access Instructions',
                          hintText: 'e.g. Guard pass required at gate, owner available until 1pm...',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          filled: true,
                          fillColor: backgroundColor,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Warranty Coverage Toggle
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: _isWarrantyCovered ? Colors.green.withValues(alpha: 0.08) : Colors.orange.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: _isWarrantyCovered ? Colors.green.withValues(alpha: 0.3) : Colors.orange.withValues(alpha: 0.3)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(_isWarrantyCovered ? Icons.verified_rounded : Icons.info_outline, color: _isWarrantyCovered ? Colors.green : Colors.orange, size: 20),
                                const SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _isWarrantyCovered ? 'Covered under Active Warranty' : 'Billable / Out of Warranty Service',
                                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: _isWarrantyCovered ? Colors.green.shade800 : Colors.orange.shade800),
                                    ),
                                    Text(
                                      _isWarrantyCovered ? 'Parts & technician labour 100% free under Homio comprehensive policy' : 'Requires commercial estimate approval from customer before dispatch',
                                      style: TextStyle(fontSize: 11, color: textSecondaryColor),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Switch(
                              value: _isWarrantyCovered,
                              activeThumbColor: Colors.green,
                              onChanged: (val) => setState(() => _isWarrantyCovered = val),
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
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: _isSubmitting ? null : _submitForm,
                    icon: _isSubmitting
                        ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : const Icon(Icons.check_circle_outline, size: 18),
                    label: Text(_isSubmitting ? 'CREATING...' : 'CREATE SERVICE REQUEST'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
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

  Widget _buildContextPill(String label, String value, IconData icon, Color textPrimary, Color textSecondary) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.getSurface(context),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, size: 15, color: AppColors.primary),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(fontSize: 9, color: textSecondary, fontWeight: FontWeight.w600)),
                Text(value, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: textPrimary), maxLines: 1, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) return;

    final nav = Navigator.of(context);
    setState(() => _isSubmitting = true);

    Future.delayed(const Duration(milliseconds: 350), () {
      final newReq = ServiceRequest(
        id: 'REQ-2026-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
        requestNumber: 'SR-${_customerName.substring(0, 3).toUpperCase()}-${DateTime.now().millisecond}',
        customerId: _sampleSource.customerId,
        customerName: _customerName,
        customerPhone: _customerPhone,
        customerEmail: _customerEmail,
        preferredChannel: _preferredChannel,
        projectId: _selectedProjectId,
        projectName: _sampleSource.projectName,
        projectType: _sampleSource.projectType,
        siteAddress: _siteAddress,
        handoverDate: _handoverDate,
        projectManager: _projectManager,
        supervisor: _supervisor,
        requestType: _requestType,
        category: _category,
        subject: _subjectCtrl.text.trim(),
        description: _descCtrl.text.trim(),
        areaRoom: _areaRoomCtrl.text.trim(),
        specificLocation: _locationCtrl.text.trim(),
        issueDate: DateTime.now(),
        priority: _priority,
        status: ServiceRequestStatus.newRequest,
        customerExpectation: _expectationCtrl.text.trim().isEmpty ? 'Complete repair with sign-off.' : _expectationCtrl.text.trim(),
        preferredServiceDate: _preferredDate,
        preferredTime: _preferredTime,
        availabilityNotes: _availabilityCtrl.text.trim(),
        assignedToName: 'Unassigned',
        assignedToRole: 'Pending Dispatch',
        createdDate: DateTime.now(),
        dueDate: DateTime.now().add(_priority.slaDuration),
        lastActivity: DateTime.now(),
        isWarrantyCovered: _isWarrantyCovered,
        billingStatus: _isWarrantyCovered ? BillingStatus.warrantyCovered : BillingStatus.chargeable,
      );

      widget.onRequestCreated(newReq);
      nav.pop();
    });
  }
}
