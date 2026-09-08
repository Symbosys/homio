import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../domain/sales_enums.dart';
import '../domain/sales_domain_models.dart';
import '../data/sales_repository.dart';

/// Multi-section Create Lead Dialog with Duplicate Detection & Pincode Qualification
class CreateLeadDialog extends StatefulWidget {
  final ValueChanged<LeadItem> onLeadCreated;

  const CreateLeadDialog({super.key, required this.onLeadCreated});

  static Future<void> show(BuildContext context, {required ValueChanged<LeadItem> onLeadCreated}) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => CreateLeadDialog(onLeadCreated: onLeadCreated),
    );
  }

  @override
  State<CreateLeadDialog> createState() => _CreateLeadDialogState();
}

class _CreateLeadDialogState extends State<CreateLeadDialog> {
  final _formKey = GlobalKey<FormState>();

  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _altPhoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _cityCtrl = TextEditingController(text: 'Gurugram');
  final _pincodeCtrl = TextEditingController(text: '122002');
  final _areaCtrl = TextEditingController(text: '2800');
  final _budgetCtrl = TextEditingController(text: '35.0');
  final _objectionCtrl = TextEditingController();

  LeadWorkType _workType = LeadWorkType.fullTurnkey;
  LeadSourceType _source = LeadSourceType.metaLeadAds;
  MeetingPreferenceType _meetingPref = MeetingPreferenceType.siteVisit;
  String _propertyType = '4BHK Luxury Apartment';
  String _assignedTo = 'Ananya Verma';
  AssignmentMethod _assignmentMethod = AssignmentMethod.roundRobin;
  final String _budgetConfidence = 'Confirmed';

  LeadItem? _duplicateFound;
  bool _isAutoQualified = true;

  @override
  void initState() {
    super.initState();
    _phoneCtrl.addListener(_checkDuplicate);
    _emailCtrl.addListener(_checkDuplicate);
    _pincodeCtrl.addListener(_updateQualification);
    _budgetCtrl.addListener(_updateQualification);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _altPhoneCtrl.dispose();
    _emailCtrl.dispose();
    _addressCtrl.dispose();
    _cityCtrl.dispose();
    _pincodeCtrl.dispose();
    _areaCtrl.dispose();
    _budgetCtrl.dispose();
    _objectionCtrl.dispose();
    super.dispose();
  }

  void _checkDuplicate() {
    final phone = _phoneCtrl.text.trim();
    final email = _emailCtrl.text.trim();
    final name = _nameCtrl.text.trim();

    if (phone.length >= 8 || email.contains('@')) {
      final dup = SalesRepository.instance.checkDuplicateLead(
        phone: phone,
        email: email,
        name: name,
      );
      if (dup?.id != _duplicateFound?.id) {
        setState(() => _duplicateFound = dup);
      }
    } else if (_duplicateFound != null) {
      setState(() => _duplicateFound = null);
    }
  }

  void _updateQualification() {
    final pin = _pincodeCtrl.text.trim();
    final budget = double.tryParse(_budgetCtrl.text.trim()) ?? 0.0;
    final qualified = SalesRepository.instance.evaluateLeadQualification(
      pincode: pin,
      budgetAmount: budget,
    );
    if (qualified != _isAutoQualified) {
      setState(() => _isAutoQualified = qualified);
    }
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final budget = double.tryParse(_budgetCtrl.text.trim()) ?? 30.0;
    final area = double.tryParse(_areaCtrl.text.trim()) ?? 2000.0;

    final newLead = LeadItem(
      id: 'HOM-LD-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      clientName: _nameCtrl.text.trim(),
      phone: _phoneCtrl.text.trim(),
      alternatePhone: _altPhoneCtrl.text.trim().isNotEmpty ? _altPhoneCtrl.text.trim() : null,
      email: _emailCtrl.text.trim(),
      city: _cityCtrl.text.trim(),
      state: 'Delhi NCR',
      pincode: _pincodeCtrl.text.trim(),
      address: _addressCtrl.text.trim().isNotEmpty ? _addressCtrl.text.trim() : 'DLF Phase 5 Hub',
      projectType: _propertyType,
      workType: _workType,
      areaSqFt: area,
      budgetAmount: budget,
      budgetConfidence: _budgetConfidence,
      stage: _isAutoQualified ? CrmStage.qualified : CrmStage.newEnquiry,
      source: _source,
      assignedTo: _assignedTo,
      assignmentMethod: _assignmentMethod,
      meetingPreference: _meetingPref,
      createdDate: DateTime.now(),
      lastContactDate: DateTime.now(),
      nextFollowupDate: 'Today, 04:00 PM',
      leadScore: _isAutoQualified ? 85.0 : 45.0,
      isQualified: _isAutoQualified,
      qualificationReason: _isAutoQualified
          ? 'Serviceable pincode ${_pincodeCtrl.text.trim()} & verified ₹${budget}L budget'
          : 'Under review for budget or territory alignment',
      primaryObjection: _objectionCtrl.text.trim().isNotEmpty ? _objectionCtrl.text.trim() : null,
      tags: [_workType.label, _isAutoQualified ? 'Auto-Qualified' : 'Pending Verification'],
      activities: [
        LeadActivityItem(
          id: 'ACT-NEW',
          timestamp: DateTime.now(),
          employeeName: 'Current User',
          action: 'Lead Created in CRM',
          details: 'Ingested via manual sales entry dialog',
          source: 'Manual',
          icon: Icons.add_circle_outline_rounded,
          iconColor: Colors.blue,
        ),
      ],
    );

    final created = await SalesRepository.instance.createLead(newLead);
    widget.onLeadCreated(created);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AlertDialog(
      backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.md),
      contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
      titlePadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.person_add_alt_1_rounded, size: 20, color: AppColors.primary),
              ),
              const SizedBox(width: 12),
              Text(
                'Create New CRM Lead',
                style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ],
          ),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close_rounded, size: 20),
          ),
        ],
      ),
      content: SizedBox(
        width: 600,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Duplicate Warning Banner
                if (_duplicateFound != null) ...[
                  Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEF4444).withValues(alpha: 0.12),
                      borderRadius: AppRadius.sm,
                      border: Border.all(color: const Color(0xFFEF4444).withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.warning_amber_rounded, size: 20, color: Color(0xFFEF4444)),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Possible Duplicate Lead Found!',
                                style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: const Color(0xFFEF4444)),
                              ),
                              Text(
                                'Matches ID: ${_duplicateFound!.id} (${_duplicateFound!.clientName} - ${_duplicateFound!.phone})',
                                style: GoogleFonts.inter(fontSize: 11, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                // 2. Client Contact Information
                _sectionHeading('1. Client Contact Information'),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      flex: 6,
                      child: _textField(
                        controller: _nameCtrl,
                        label: 'Client Name *',
                        hint: 'e.g. Dr. Alok Gupta',
                        isDark: isDark,
                        validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 6,
                      child: _textField(
                        controller: _phoneCtrl,
                        label: 'Primary Phone *',
                        hint: '+91 98100 XXXXX',
                        isDark: isDark,
                        validator: (v) => v == null || v.trim().length < 8 ? 'Valid phone required' : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: _textField(
                        controller: _emailCtrl,
                        label: 'Email Address *',
                        hint: 'client@example.com',
                        isDark: isDark,
                        validator: (v) => v == null || !v.contains('@') ? 'Valid email required' : null,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _textField(
                        controller: _altPhoneCtrl,
                        label: 'Alternate Contact',
                        hint: 'Spouse / Assistant Phone',
                        isDark: isDark,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: _textField(
                        controller: _pincodeCtrl,
                        label: 'Site Pincode *',
                        hint: '122002',
                        isDark: isDark,
                        validator: (v) => v == null || v.length < 6 ? '6-digit PIN' : null,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 4,
                      child: _textField(
                        controller: _cityCtrl,
                        label: 'City *',
                        hint: 'Gurugram',
                        isDark: isDark,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 4,
                      child: Container(
                        padding: const EdgeInsets.only(top: 18),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          decoration: BoxDecoration(
                            color: _isAutoQualified ? const Color(0xFF10B981).withValues(alpha: 0.12) : const Color(0xFFF59E0B).withValues(alpha: 0.12),
                            borderRadius: AppRadius.sm,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                _isAutoQualified ? Icons.check_circle_rounded : Icons.info_outline_rounded,
                                size: 14,
                                color: _isAutoQualified ? const Color(0xFF10B981) : const Color(0xFFD97706),
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  _isAutoQualified ? 'Territory OK' : 'Out of Territory',
                                  style: GoogleFonts.inter(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: _isAutoQualified ? const Color(0xFF10B981) : const Color(0xFFD97706),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                _textField(
                  controller: _addressCtrl,
                  label: 'Property Address / Society',
                  hint: 'e.g. Tower 3, Apt 902, Experion Windchants, Sector 112',
                  isDark: isDark,
                ),

                const SizedBox(height: 16),
                // 3. Project & Scope Details
                _sectionHeading('2. Project & Interior Scope'),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      flex: 6,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _fieldLabel('Property Type', isDark),
                          DropdownButtonFormField<String>(
                            initialValue: _propertyType,
                            isDense: true,
                            decoration: _inputDecoration(isDark),
                            dropdownColor: isDark ? AppColors.darkSurfaceElevated : Colors.white,
                            items: const [
                              DropdownMenuItem(value: '4BHK Luxury Apartment', child: Text('4BHK Luxury Apartment')),
                              DropdownMenuItem(value: '3BHK Highrise Apartment', child: Text('3BHK Highrise Apartment')),
                              DropdownMenuItem(value: 'Penthouse / Duplex', child: Text('Penthouse / Duplex')),
                              DropdownMenuItem(value: 'Independent Villa / Kothi', child: Text('Independent Villa / Kothi')),
                            ],
                            onChanged: (v) {
                              if (v != null) setState(() => _propertyType = v);
                            },
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
                          _fieldLabel('Scope of Work', isDark),
                          DropdownButtonFormField<LeadWorkType>(
                            initialValue: _workType,
                            isDense: true,
                            decoration: _inputDecoration(isDark),
                            dropdownColor: isDark ? AppColors.darkSurfaceElevated : Colors.white,
                            items: LeadWorkType.values.map((w) {
                              return DropdownMenuItem(value: w, child: Text(w.label));
                            }).toList(),
                            onChanged: (v) {
                              if (v != null) setState(() => _workType = v);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: _textField(
                        controller: _areaCtrl,
                        label: 'Area (Sq.Ft)',
                        hint: '2800',
                        keyboardType: TextInputType.number,
                        isDark: isDark,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _textField(
                        controller: _budgetCtrl,
                        label: 'Estimated Budget (₹ Lakhs) *',
                        hint: '35.0',
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        isDark: isDark,
                        validator: (v) => v == null || v.isEmpty ? 'Budget required' : null,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),
                // 4. Source & Assignment
                _sectionHeading('3. Source, Meeting & Assignment'),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _fieldLabel('Lead Ingestion Source', isDark),
                          DropdownButtonFormField<LeadSourceType>(
                            initialValue: _source,
                            isDense: true,
                            decoration: _inputDecoration(isDark),
                            dropdownColor: isDark ? AppColors.darkSurfaceElevated : Colors.white,
                            items: LeadSourceType.values.map((s) {
                              return DropdownMenuItem(
                                value: s,
                                child: Row(
                                  children: [
                                    Icon(s.icon, size: 14, color: AppColors.primary),
                                    const SizedBox(width: 6),
                                    Text(s.label),
                                  ],
                                ),
                              );
                            }).toList(),
                            onChanged: (v) {
                              if (v != null) setState(() => _source = v);
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _fieldLabel('Meeting Preference', isDark),
                          DropdownButtonFormField<MeetingPreferenceType>(
                            initialValue: _meetingPref,
                            isDense: true,
                            decoration: _inputDecoration(isDark),
                            dropdownColor: isDark ? AppColors.darkSurfaceElevated : Colors.white,
                            items: MeetingPreferenceType.values.map((m) {
                              return DropdownMenuItem(value: m, child: Text(m.label));
                            }).toList(),
                            onChanged: (v) {
                              if (v != null) setState(() => _meetingPref = v);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _fieldLabel('Assigned Consultant', isDark),
                          DropdownButtonFormField<String>(
                            initialValue: _assignedTo,
                            isDense: true,
                            decoration: _inputDecoration(isDark),
                            dropdownColor: isDark ? AppColors.darkSurfaceElevated : Colors.white,
                            items: const [
                              DropdownMenuItem(value: 'Ananya Verma', child: Text('Ananya Verma (Luxury Turnkey)')),
                              DropdownMenuItem(value: 'Rajesh Patel', child: Text('Rajesh Patel (Senior Closer)')),
                              DropdownMenuItem(value: 'Vikram Malhotra', child: Text('Vikram Malhotra (Sales Head)')),
                              DropdownMenuItem(value: 'Priya Sharma', child: Text('Priya Sharma (Modular Kitchens)')),
                            ],
                            onChanged: (v) {
                              if (v != null) setState(() => _assignedTo = v);
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _fieldLabel('Assignment Method', isDark),
                          DropdownButtonFormField<AssignmentMethod>(
                            initialValue: _assignmentMethod,
                            isDense: true,
                            decoration: _inputDecoration(isDark),
                            dropdownColor: isDark ? AppColors.darkSurfaceElevated : Colors.white,
                            items: AssignmentMethod.values.map((a) {
                              return DropdownMenuItem(value: a, child: Text(a.label));
                            }).toList(),
                            onChanged: (v) {
                              if (v != null) setState(() => _assignmentMethod = v);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel', style: GoogleFonts.inter(fontSize: 12)),
        ),
        ElevatedButton(
          onPressed: _submit,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
          ),
          child: Text(
            _duplicateFound != null ? 'Create Anyway' : 'Save & Ingest Lead',
            style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }

  Widget _sectionHeading(String title) {
    return Text(
      title,
      style: GoogleFonts.inter(fontSize: 12.5, fontWeight: FontWeight.w700, color: AppColors.primary),
    );
  }

  Widget _fieldLabel(String text, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        text,
        style: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
        ),
      ),
    );
  }

  Widget _textField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required bool isDark,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _fieldLabel(label, isDark),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          style: GoogleFonts.inter(fontSize: 12),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.inter(fontSize: 11.5, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
            border: OutlineInputBorder(borderRadius: AppRadius.sm),
          ),
        ),
      ],
    );
  }

  InputDecoration _inputDecoration(bool isDark) {
    return InputDecoration(
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
      border: OutlineInputBorder(borderRadius: AppRadius.sm),
    );
  }
}
