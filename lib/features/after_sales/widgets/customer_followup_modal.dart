import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../models/after_sales_models.dart';
import '../models/after_sales_mock_data.dart';

class CustomerFollowupModal extends StatefulWidget {
  final ServiceFollowUp? initialFollowUp;
  final ValueChanged<ServiceFollowUp> onFollowUpLogged;

  const CustomerFollowupModal({
    super.key,
    this.initialFollowUp,
    required this.onFollowUpLogged,
  });

  @override
  State<CustomerFollowupModal> createState() => _CustomerFollowupModalState();
}

class _CustomerFollowupModalState extends State<CustomerFollowupModal> {
  final _formKey = GlobalKey<FormState>();

  late ServiceRequest _selectedCustomerSource;
  FollowUpType _type = FollowUpType.postHandoverCheckin;
  FollowUpOutcome _outcome = FollowUpOutcome.connected;
  String _channel = 'Phone';
  final TextEditingController _reasonCtrl = TextEditingController(text: 'Routine post-handover living experience & warranty check-in');
  final TextEditingController _objectiveCtrl = TextEditingController(text: 'Check on modular kitchen and wardrobe satisfaction');
  final TextEditingController _notesCtrl = TextEditingController();
  DateTime _nextDate = DateTime.now().add(const Duration(days: 14));
  double _satisfactionRating = 5.0;
  bool _isLogging = false;

  @override
  void initState() {
    super.initState();
    _selectedCustomerSource = AfterSalesMockData.serviceRequests.first;
    if (widget.initialFollowUp != null) {
      final f = widget.initialFollowUp!;
      _type = f.followUpType;
      _outcome = f.outcome;
      _channel = f.channel;
      _reasonCtrl.text = f.reason;
      _objectiveCtrl.text = f.objective;
      _notesCtrl.text = f.notes;
      if (f.satisfactionRating != null) _satisfactionRating = f.satisfactionRating!;
    }
  }

  @override
  void dispose() {
    _reasonCtrl.dispose();
    _objectiveCtrl.dispose();
    _notesCtrl.dispose();
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
        width: 720,
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
                          color: const Color(0xFF8B5CF6).withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.loyalty_rounded, color: Color(0xFF8B5CF6), size: 22),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Log Customer Retention Follow-up', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: textPrimaryColor)),
                          Text('Proactive relationship touchpoint, AMC advisory & satisfaction audit', style: TextStyle(fontSize: 12, color: textSecondaryColor)),
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
                      // Customer / Project Selector
                      DropdownButtonFormField<String>(
                        initialValue: _selectedCustomerSource.projectId,
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
                            child: Text('${req.customerName} • ${req.projectName} (${req.customerPhone})'),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) {
                            final match = AfterSalesMockData.serviceRequests.firstWhere((r) => r.projectId == val);
                            setState(() => _selectedCustomerSource = match);
                          }
                        },
                      ),
                      const SizedBox(height: 14),

                      // Follow-up Type & Channel
                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: DropdownButtonFormField<FollowUpType>(
                              initialValue: _type,
                              decoration: InputDecoration(
                                labelText: 'Follow-up Type *',
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                filled: true,
                                fillColor: backgroundColor,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              ),
                              items: FollowUpType.values.map((t) {
                                return DropdownMenuItem(value: t, child: Text(t.label, style: const TextStyle(fontSize: 12)));
                              }).toList(),
                              onChanged: (val) {
                                if (val != null) setState(() => _type = val);
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 2,
                            child: DropdownButtonFormField<String>(
                              initialValue: _channel,
                              decoration: InputDecoration(
                                labelText: 'Channel *',
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                filled: true,
                                fillColor: backgroundColor,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              ),
                              items: const [
                                DropdownMenuItem(value: 'Phone', child: Text('Direct Phone Call')),
                                DropdownMenuItem(value: 'WhatsApp', child: Text('WhatsApp Chat')),
                                DropdownMenuItem(value: 'Email', child: Text('Email Update')),
                                DropdownMenuItem(value: 'In-Person', child: Text('On-Site Visit')),
                              ],
                              onChanged: (val) {
                                if (val != null) setState(() => _channel = val);
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // Objective
                      TextFormField(
                        controller: _objectiveCtrl,
                        decoration: InputDecoration(
                          labelText: 'Touchpoint Objective *',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          filled: true,
                          fillColor: backgroundColor,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        ),
                        validator: (val) => (val == null || val.trim().isEmpty) ? 'Enter objective' : null,
                      ),
                      const SizedBox(height: 14),

                      // Call Outcome
                      DropdownButtonFormField<FollowUpOutcome>(
                        initialValue: _outcome,
                        decoration: InputDecoration(
                          labelText: 'Call / Interaction Outcome *',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          filled: true,
                          fillColor: backgroundColor,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        ),
                        items: FollowUpOutcome.values.map((o) {
                          return DropdownMenuItem(
                            value: o,
                            child: Text(o.label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: o.color)),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => _outcome = val);
                        },
                      ),
                      const SizedBox(height: 14),

                      // Detailed Conversation Notes
                      TextFormField(
                        controller: _notesCtrl,
                        maxLines: 3,
                        decoration: InputDecoration(
                          labelText: 'Conversation Summary & Customer Feedback Notes *',
                          hintText: 'Record verbatim feedback, client mood, upcoming needs or expansion plans...',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          filled: true,
                          fillColor: backgroundColor,
                          contentPadding: const EdgeInsets.all(12),
                        ),
                        validator: (val) => (val == null || val.trim().isEmpty) ? 'Enter notes' : null,
                      ),
                      const SizedBox(height: 14),

                      // Next Follow-up Date Picker & Satisfaction Rating
                      Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () async {
                                final picked = await showDatePicker(
                                  context: context,
                                  initialDate: _nextDate,
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime.now().add(const Duration(days: 365)),
                                );
                                if (picked != null) setState(() => _nextDate = picked);
                              },
                              child: InputDecorator(
                                decoration: InputDecoration(
                                  labelText: 'Next Scheduled Action Date',
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                  filled: true,
                                  fillColor: backgroundColor,
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                ),
                                child: Text('${_nextDate.day}/${_nextDate.month}/${_nextDate.year}'),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: backgroundColor,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: AppColors.getBorder(context)),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('CSAT: ${_satisfactionRating.toStringAsFixed(1)} ★', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: Colors.amber)),
                                  Row(
                                    children: List.generate(5, (i) {
                                      final star = (i + 1).toDouble();
                                      return InkWell(
                                        onTap: () => setState(() => _satisfactionRating = star),
                                        child: Icon(
                                          star <= _satisfactionRating ? Icons.star_rounded : Icons.star_outline_rounded,
                                          color: Colors.amber,
                                          size: 20,
                                        ),
                                      );
                                    }),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
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
                  OutlinedButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: _isLogging ? null : _logFollowUp,
                    icon: _isLogging
                        ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : const Icon(Icons.check_circle_rounded, size: 18),
                    label: Text(_isLogging ? 'SAVING...' : 'LOG RETENTION CALL'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8B5CF6),
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

  void _logFollowUp() {
    if (!_formKey.currentState!.validate()) return;

    final nav = Navigator.of(context);
    setState(() => _isLogging = true);

    Future.delayed(const Duration(milliseconds: 350), () {
      final followUp = ServiceFollowUp(
        id: 'RET-2026-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
        customerId: _selectedCustomerSource.customerId,
        customerName: _selectedCustomerSource.customerName,
        customerPhone: _selectedCustomerSource.customerPhone,
        customerEmail: _selectedCustomerSource.customerEmail,
        projectId: _selectedCustomerSource.projectId,
        projectName: _selectedCustomerSource.projectName,
        handoverDate: _selectedCustomerSource.handoverDate,
        followUpType: _type,
        reason: _reasonCtrl.text.trim(),
        assignedEmployee: 'Priya Service Telecaller',
        scheduledDate: DateTime.now(),
        conductedDate: DateTime.now(),
        preferredTime: '11:00 AM',
        channel: _channel,
        objective: _objectiveCtrl.text.trim(),
        notes: _notesCtrl.text.trim(),
        outcome: _outcome,
        nextFollowUpDate: _nextDate,
        satisfactionRating: _satisfactionRating,
      );

      widget.onFollowUpLogged(followUp);
      nav.pop();
    });
  }
}
