import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/utils/toast_service.dart';
import '../../../core/utils/web_image_picker/web_image_picker.dart';
import '../../../permission/gallery_permission.dart';
import '../data/models/hrms_employee_api_model.dart';
import '../data/models/hrms_salary_api_model.dart';
import '../presentation/queries/hrms_queries.dart';

class SalaryRevisionDialog extends StatefulWidget {
  final HrmsEmployeeApiModel employee;
  final HrmsSalaryApiModel? currentSalary;
  final VoidCallback? onSalarySaved;

  const SalaryRevisionDialog({
    super.key,
    required this.employee,
    this.currentSalary,
    this.onSalarySaved,
  });

  static void show(
    BuildContext context, {
    required HrmsEmployeeApiModel employee,
    HrmsSalaryApiModel? currentSalary,
    VoidCallback? onSalarySaved,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 780, maxHeight: 720),
          child: SalaryRevisionDialog(
            employee: employee,
            currentSalary: currentSalary,
            onSalarySaved: onSalarySaved,
          ),
        ),
      ),
    );
  }

  @override
  State<SalaryRevisionDialog> createState() => _SalaryRevisionDialogState();
}

class _SalaryRevisionDialogState extends State<SalaryRevisionDialog> {
  final _formKey = GlobalKey<FormState>();

  late DateTime _effectiveFrom;
  final DateTime _revisionDate = DateTime.now();
  String _selectedReason = 'ANNUAL_INCREMENT';
  final String _payFrequency = 'MONTHLY';
  final String _currency = 'INR';

  // Amount controllers
  final _annualCtcCtrl = TextEditingController();
  final _monthlyGrossCtrl = TextEditingController();
  final _basicSalaryCtrl = TextEditingController();
  final _hraCtrl = TextEditingController();
  final _daCtrl = TextEditingController(text: '0');
  final _conveyanceCtrl = TextEditingController(text: '0');
  final _specialAllowanceCtrl = TextEditingController();
  final _medicalCtrl = TextEditingController(text: '0');
  final _otherAllowancesCtrl = TextEditingController(text: '0');

  final _pfEmployeeCtrl = TextEditingController(text: '1800');
  final _esiEmployeeCtrl = TextEditingController(text: '0');
  final _ptCtrl = TextEditingController(text: '200');
  final _tdsCtrl = TextEditingController(text: '0');

  final _pfEmployerCtrl = TextEditingController(text: '1800');
  final _esiEmployerCtrl = TextEditingController(text: '0');
  final _gratuityCtrl = TextEditingController(text: '0');
  final _insuranceCtrl = TextEditingController(text: '0');

  final _percentageHikeCtrl = TextEditingController();
  final _remarksCtrl = TextEditingController();

  Uint8List? _documentBytes;
  String? _documentFileName;
  bool _isSubmitting = false;

  final List<Map<String, String>> _revisionReasons = [
    {'value': 'ANNUAL_INCREMENT', 'label': 'Annual Appraisal / Increment'},
    {'value': 'PROMOTION', 'label': 'Job Promotion Bump'},
    {'value': 'NEW_HIRE', 'label': 'Initial Compensation (New Hire)'},
    {'value': 'CONFIRMATION', 'label': 'Probation Confirmation'},
    {'value': 'MARKET_CORRECTION', 'label': 'Market Parity Correction'},
    {'value': 'SPECIAL_ALLOWANCE_REVISION', 'label': 'Special Allowance Adjustment'},
    {'value': 'DEMOTION', 'label': 'Compensation Demotion'},
    {'value': 'TRANSFER', 'label': 'Branch / Entity Transfer'},
    {'value': 'OTHER', 'label': 'Other Special Adjustment'},
  ];

  @override
  void initState() {
    super.initState();
    _effectiveFrom = DateTime.now();

    final prev = widget.currentSalary ?? widget.employee.currentSalary;
    if (prev != null) {
      _annualCtcCtrl.text = prev.annualCtc.toInt().toString();
      _monthlyGrossCtrl.text = prev.monthlyGross.toInt().toString();
      _basicSalaryCtrl.text = prev.basicSalary.toInt().toString();
      _hraCtrl.text = prev.hra.toInt().toString();
      _specialAllowanceCtrl.text = prev.specialAllowance.toInt().toString();
      _daCtrl.text = prev.dearnessAllowance.toInt().toString();
      _conveyanceCtrl.text = prev.conveyanceAllowance.toInt().toString();
      _medicalCtrl.text = prev.medicalAllowance.toInt().toString();
      _otherAllowancesCtrl.text = prev.otherAllowances.toInt().toString();
      _pfEmployeeCtrl.text = prev.pfEmployee.toInt().toString();
      _esiEmployeeCtrl.text = prev.esiEmployee.toInt().toString();
      _ptCtrl.text = prev.professionalTax.toInt().toString();
      _tdsCtrl.text = prev.tdsMonthly.toInt().toString();
      _pfEmployerCtrl.text = prev.pfEmployer.toInt().toString();
      _esiEmployerCtrl.text = prev.esiEmployer.toInt().toString();
      _gratuityCtrl.text = prev.gratuityMonthly.toInt().toString();
      _insuranceCtrl.text = prev.insuranceMonthly.toInt().toString();
    } else {
      _selectedReason = 'NEW_HIRE';
      _annualCtcCtrl.text = '600000';
      _autoDistributeFromCtc(600000);
    }
  }

  void _autoDistributeFromCtc(double ctc) {
    final monthlyGross = ctc / 12;
    final basic = monthlyGross * 0.50;
    final hra = basic * 0.40;
    final special = (monthlyGross - basic - hra).clamp(0, double.infinity);

    _monthlyGrossCtrl.text = monthlyGross.toInt().toString();
    _basicSalaryCtrl.text = basic.toInt().toString();
    _hraCtrl.text = hra.toInt().toString();
    _specialAllowanceCtrl.text = special.toInt().toString();
    _calculateHike(ctc);
  }

  void _calculateHike(double newCtc) {
    final prev = widget.currentSalary ?? widget.employee.currentSalary;
    if (prev != null && prev.annualCtc > 0) {
      final hike = ((newCtc - prev.annualCtc) / prev.annualCtc) * 100;
      _percentageHikeCtrl.text = hike.toStringAsFixed(2);
    }
  }

  @override
  void dispose() {
    _annualCtcCtrl.dispose();
    _monthlyGrossCtrl.dispose();
    _basicSalaryCtrl.dispose();
    _hraCtrl.dispose();
    _daCtrl.dispose();
    _conveyanceCtrl.dispose();
    _specialAllowanceCtrl.dispose();
    _medicalCtrl.dispose();
    _otherAllowancesCtrl.dispose();
    _pfEmployeeCtrl.dispose();
    _esiEmployeeCtrl.dispose();
    _ptCtrl.dispose();
    _tdsCtrl.dispose();
    _pfEmployerCtrl.dispose();
    _esiEmployerCtrl.dispose();
    _gratuityCtrl.dispose();
    _insuranceCtrl.dispose();
    _percentageHikeCtrl.dispose();
    _remarksCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDocumentImage(ImageSource source) async {
    try {
      if (kIsWeb) {
        final webPicked = await pickImageWeb();
        if (webPicked != null) {
          setState(() {
            _documentBytes = webPicked.bytes;
            _documentFileName = webPicked.name;
          });
        }
        return;
      }

      final hasPermission = await GalleryPermission.request();
      if (!hasPermission) {
        ToastService.showError('Permission denied to access photo gallery.');
        return;
      }

      final picker = ImagePicker();
      final picked = await picker.pickImage(
        source: source,
        maxWidth: 2048,
        maxHeight: 2048,
        imageQuality: 85,
      );
      if (picked != null) {
        final bytes = await picked.readAsBytes();
        setState(() {
          _documentBytes = bytes;
          _documentFileName = picked.name;
        });
      }
    } catch (e) {
      ToastService.showError('Failed to pick document image: $e');
    }
  }

  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E2330) : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.lgVal)),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Attach Increment / Salary Letter',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                ),
                Text(
                  'Upload scan or photo of the official appraisal document (PNG, JPG, WEBP)',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: AppRadius.sm,
                    ),
                    child: const Icon(Icons.photo_library_outlined, color: AppColors.primary, size: 22),
                  ),
                  title: Text('Choose from Photo Gallery', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600, fontSize: 13)),
                  subtitle: Text('Select an image from device gallery or files', style: GoogleFonts.plusJakartaSans(fontSize: 11)),
                  onTap: () {
                    Navigator.of(ctx).pop();
                    _pickDocumentImage(ImageSource.gallery);
                  },
                ),
                if (!kIsWeb)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981).withValues(alpha: 0.1),
                        borderRadius: AppRadius.sm,
                      ),
                      child: const Icon(Icons.camera_alt_outlined, color: Color(0xFF10B981), size: 22),
                    ),
                    title: Text('Capture with Camera', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600, fontSize: 13)),
                    subtitle: Text('Snap a real-time photo of physical paperwork', style: GoogleFonts.plusJakartaSans(fontSize: 11)),
                    onTap: () {
                      Navigator.of(ctx).pop();
                      _pickDocumentImage(ImageSource.camera);
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _previewSelectedImage() {
    if (_documentBytes == null) return;
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800, maxHeight: 800),
          child: Stack(
            alignment: Alignment.topRight,
            children: [
              InteractiveViewer(
                minScale: 0.5,
                maxScale: 4.0,
                child: Center(
                  child: ClipRRect(
                    borderRadius: AppRadius.md,
                    child: Image.memory(
                      _documentBytes!,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundColor: Colors.black.withValues(alpha: 0.7),
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.white, size: 20),
                    onPressed: () => Navigator.of(ctx).pop(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _clearSelectedImage() {
    setState(() {
      _documentBytes = null;
      _documentFileName = null;
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    final payload = <String, dynamic>{
      'effectiveFrom': DateFormat('yyyy-MM-dd').format(_effectiveFrom),
      'revisionReason': _selectedReason,
      'revisionDate': DateFormat('yyyy-MM-dd').format(_revisionDate),
      'currency': _currency,
      'payFrequency': _payFrequency,
      'annualCtc': double.tryParse(_annualCtcCtrl.text) ?? 0,
      'monthlyGross': double.tryParse(_monthlyGrossCtrl.text) ?? 0,
      'basicSalary': double.tryParse(_basicSalaryCtrl.text) ?? 0,
      'hra': double.tryParse(_hraCtrl.text) ?? 0,
      'dearnessAllowance': double.tryParse(_daCtrl.text) ?? 0,
      'conveyanceAllowance': double.tryParse(_conveyanceCtrl.text) ?? 0,
      'specialAllowance': double.tryParse(_specialAllowanceCtrl.text) ?? 0,
      'medicalAllowance': double.tryParse(_medicalCtrl.text) ?? 0,
      'otherAllowances': double.tryParse(_otherAllowancesCtrl.text) ?? 0,
      'pfEmployee': double.tryParse(_pfEmployeeCtrl.text) ?? 0,
      'esiEmployee': double.tryParse(_esiEmployeeCtrl.text) ?? 0,
      'professionalTax': double.tryParse(_ptCtrl.text) ?? 0,
      'tdsMonthly': double.tryParse(_tdsCtrl.text) ?? 0,
      'pfEmployer': double.tryParse(_pfEmployerCtrl.text) ?? 0,
      'esiEmployer': double.tryParse(_esiEmployerCtrl.text) ?? 0,
      'gratuityMonthly': double.tryParse(_gratuityCtrl.text) ?? 0,
      'insuranceMonthly': double.tryParse(_insuranceCtrl.text) ?? 0,
      if (_percentageHikeCtrl.text.isNotEmpty)
        'percentageHike': double.tryParse(_percentageHikeCtrl.text),
      if (_remarksCtrl.text.isNotEmpty) 'remarks': _remarksCtrl.text.trim(),
    };

    final mutation = hrmsQueries.getCreateSalaryRevisionMutation(
      onSuccess: (_) {
        if (mounted) {
          Navigator.of(context).pop();
          if (widget.onSalarySaved != null) widget.onSalarySaved!();
        }
      },
    );

    await mutation.mutate((
      employeeId: widget.employee.id,
      data: payload,
      documentBytes: (_documentBytes != null && _documentBytes!.isNotEmpty) ? _documentBytes : null,
      documentFileName: (_documentBytes != null && _documentBytes!.isNotEmpty) ? _documentFileName : null,
    ));

    if (mounted) setState(() => _isSubmitting = false);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF131722) : Colors.white,
        borderRadius: AppRadius.lg,
        border: Border.all(
          color: isDark ? Colors.white.withValues(alpha: 0.08) : Colors.black.withValues(alpha: 0.08),
        ),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            // Modal Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1B202E) : const Color(0xFFF8FAFC),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.lgVal)),
                border: Border(
                  bottom: BorderSide(
                    color: isDark ? Colors.white.withValues(alpha: 0.06) : Colors.black.withValues(alpha: 0.06),
                  ),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.12),
                      borderRadius: AppRadius.sm,
                    ),
                    child: const Icon(Icons.payments_rounded, color: AppColors.primary, size: 20),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Record Salary Structure / Revision',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: isDark ? Colors.white : const Color(0xFF0F172A),
                          ),
                        ),
                        Text(
                          'Employee: ${widget.employee.fullName} (${widget.employee.employeeCode}) • Automatic SCD Type 2 period closing',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, size: 20),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),

            // Modal Body
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Revision Context Section
                    _buildSectionHeader('1. Revision Metadata & Effective Period', Icons.calendar_month_outlined, isDark),
                    const SizedBox(height: AppSpacing.sm),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            initialValue: _selectedReason,
                            decoration: _inputDecoration('Revision Reason', isDark),
                            dropdownColor: isDark ? const Color(0xFF1E2330) : Colors.white,
                            items: _revisionReasons.map((r) {
                              return DropdownMenuItem(
                                value: r['value'],
                                child: Text(r['label']!, style: GoogleFonts.plusJakartaSans(fontSize: 13)),
                              );
                            }).toList(),
                            onChanged: (val) {
                              if (val != null) setState(() => _selectedReason = val);
                            },
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              final picked = await showDatePicker(
                                context: context,
                                initialDate: _effectiveFrom,
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                              );
                              if (picked != null) setState(() => _effectiveFrom = picked);
                            },
                            child: InputDecorator(
                              decoration: _inputDecoration('Effective From Date *', isDark),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    DateFormat('dd MMM yyyy').format(_effectiveFrom),
                                    style: GoogleFonts.plusJakartaSans(fontSize: 13),
                                  ),
                                  const Icon(Icons.event_outlined, size: 18),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: AppSpacing.lg),

                    // Key Aggregates
                    _buildSectionHeader('2. Key Compensation Figures (Annual CTC & Monthly Gross)', Icons.attach_money_rounded, isDark),
                    const SizedBox(height: AppSpacing.sm),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _annualCtcCtrl,
                            keyboardType: TextInputType.number,
                            decoration: _inputDecoration('Annual CTC (₹) *', isDark, prefix: '₹ '),
                            validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                            onChanged: (val) {
                              final ctc = double.tryParse(val);
                              if (ctc != null && ctc > 0) _autoDistributeFromCtc(ctc);
                            },
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: TextFormField(
                            controller: _monthlyGrossCtrl,
                            keyboardType: TextInputType.number,
                            decoration: _inputDecoration('Monthly Gross (₹) *', isDark, prefix: '₹ '),
                            validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: TextFormField(
                            controller: _percentageHikeCtrl,
                            keyboardType: TextInputType.number,
                            decoration: _inputDecoration('Percentage Hike (%)', isDark, suffix: '%'),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: AppSpacing.lg),

                    // Earnings Breakdown
                    _buildSectionHeader('3. Monthly Earnings Breakdown', Icons.trending_up_rounded, isDark),
                    const SizedBox(height: AppSpacing.sm),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _basicSalaryCtrl,
                            keyboardType: TextInputType.number,
                            decoration: _inputDecoration('Basic Salary (₹) *', isDark),
                            validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: TextFormField(
                            controller: _hraCtrl,
                            keyboardType: TextInputType.number,
                            decoration: _inputDecoration('HRA (₹) *', isDark),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: TextFormField(
                            controller: _specialAllowanceCtrl,
                            keyboardType: TextInputType.number,
                            decoration: _inputDecoration('Special Allowance (₹)', isDark),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _daCtrl,
                            keyboardType: TextInputType.number,
                            decoration: _inputDecoration('Dearness Allowance (₹)', isDark),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: TextFormField(
                            controller: _conveyanceCtrl,
                            keyboardType: TextInputType.number,
                            decoration: _inputDecoration('Conveyance Allowance (₹)', isDark),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: TextFormField(
                            controller: _medicalCtrl,
                            keyboardType: TextInputType.number,
                            decoration: _inputDecoration('Medical Allowance (₹)', isDark),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: TextFormField(
                            controller: _otherAllowancesCtrl,
                            keyboardType: TextInputType.number,
                            decoration: _inputDecoration('Other Allowances (₹)', isDark),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: AppSpacing.lg),

                    // Deductions & Employer Retirals
                    _buildSectionHeader('4. Monthly Deductions & Employer Retirals', Icons.savings_outlined, isDark),
                    const SizedBox(height: AppSpacing.sm),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _pfEmployeeCtrl,
                            keyboardType: TextInputType.number,
                            decoration: _inputDecoration('PF (Employee Share)', isDark),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: TextFormField(
                            controller: _esiEmployeeCtrl,
                            keyboardType: TextInputType.number,
                            decoration: _inputDecoration('ESI (Employee Share)', isDark),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: TextFormField(
                            controller: _ptCtrl,
                            keyboardType: TextInputType.number,
                            decoration: _inputDecoration('Professional Tax (PT)', isDark),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: TextFormField(
                            controller: _tdsCtrl,
                            keyboardType: TextInputType.number,
                            decoration: _inputDecoration('TDS / Tax (Monthly)', isDark),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _pfEmployerCtrl,
                            keyboardType: TextInputType.number,
                            decoration: _inputDecoration('PF (Employer Share)', isDark),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: TextFormField(
                            controller: _esiEmployerCtrl,
                            keyboardType: TextInputType.number,
                            decoration: _inputDecoration('ESI (Employer Share)', isDark),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: TextFormField(
                            controller: _gratuityCtrl,
                            keyboardType: TextInputType.number,
                            decoration: _inputDecoration('Gratuity (Monthly)', isDark),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: TextFormField(
                            controller: _insuranceCtrl,
                            keyboardType: TextInputType.number,
                            decoration: _inputDecoration('Insurance (Monthly)', isDark),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: AppSpacing.lg),

                    // Document Upload & Remarks
                    _buildSectionHeader('5. Increment Letter & Appraisal Remarks', Icons.description_outlined, isDark),
                    const SizedBox(height: AppSpacing.sm),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 3,
                          child: TextFormField(
                            controller: _remarksCtrl,
                            maxLines: 3,
                            decoration: _inputDecoration('Audit Remarks / Justification (e.g. Board approved Q3 appraisal)', isDark),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          flex: 2,
                          child: _documentBytes != null
                              ? Container(
                                  padding: const EdgeInsets.all(AppSpacing.sm),
                                  decoration: BoxDecoration(
                                    color: isDark ? const Color(0xFF1E2330) : const Color(0xFFF1F5F9),
                                    borderRadius: AppRadius.sm,
                                    border: Border.all(
                                      color: AppColors.primary.withValues(alpha: 0.3),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      // Image Thumbnail with zoom trigger
                                      GestureDetector(
                                        onTap: _previewSelectedImage,
                                        child: ClipRRect(
                                          borderRadius: AppRadius.xs,
                                          child: Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              Image.memory(
                                                _documentBytes!,
                                                width: 56,
                                                height: 56,
                                                fit: BoxFit.cover,
                                              ),
                                              Container(
                                                width: 56,
                                                height: 56,
                                                color: Colors.black.withValues(alpha: 0.25),
                                                child: const Icon(Icons.zoom_in_rounded, color: Colors.white, size: 20),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: AppSpacing.sm),
                                      // Image Metadata & Action Links
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              _documentFileName ?? 'Letter Image',
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.plusJakartaSans(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w700,
                                                color: isDark ? Colors.white : const Color(0xFF0F172A),
                                              ),
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              '${(_documentBytes!.lengthInBytes / 1024).toStringAsFixed(1)} KB • Attached',
                                              style: GoogleFonts.plusJakartaSans(
                                                fontSize: 10,
                                                color: const Color(0xFF10B981),
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Row(
                                              children: [
                                                InkWell(
                                                  onTap: _showImagePickerOptions,
                                                  child: Text(
                                                    'Change',
                                                    style: GoogleFonts.plusJakartaSans(
                                                      fontSize: 11,
                                                      fontWeight: FontWeight.w600,
                                                      color: AppColors.primary,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 12),
                                                InkWell(
                                                  onTap: _clearSelectedImage,
                                                  child: Text(
                                                    'Remove',
                                                    style: GoogleFonts.plusJakartaSans(
                                                      fontSize: 11,
                                                      fontWeight: FontWeight.w600,
                                                      color: Colors.redAccent,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : InkWell(
                                  onTap: _showImagePickerOptions,
                                  borderRadius: AppRadius.sm,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
                                    decoration: BoxDecoration(
                                      color: isDark ? const Color(0xFF1E2330) : const Color(0xFFF1F5F9),
                                      borderRadius: AppRadius.sm,
                                      border: Border.all(
                                        color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.black.withValues(alpha: 0.1),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: AppColors.primary.withValues(alpha: 0.1),
                                            borderRadius: AppRadius.xs,
                                          ),
                                          child: const Icon(Icons.add_photo_alternate_rounded, color: AppColors.primary, size: 20),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                'Attach Letter Image',
                                                style: GoogleFonts.plusJakartaSans(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w700,
                                                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                                                ),
                                              ),
                                              Text(
                                                'PNG, JPG, WEBP from gallery',
                                                style: GoogleFonts.plusJakartaSans(
                                                  fontSize: 10,
                                                  color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Modal Footer Actions
            Container(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF181D2A) : const Color(0xFFF8FAFC),
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(AppRadius.lgVal)),
                border: Border(
                  top: BorderSide(
                    color: isDark ? Colors.white.withValues(alpha: 0.06) : Colors.black.withValues(alpha: 0.06),
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _isSubmitting ? null : () => Navigator.of(context).pop(),
                    child: Text('Cancel', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600)),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
                    ),
                    onPressed: _isSubmitting ? null : _submit,
                    icon: _isSubmitting
                        ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : const Icon(Icons.check_rounded, size: 18),
                    label: Text(
                      _isSubmitting ? 'Recording...' : 'Commit Revision',
                      style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
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

  Widget _buildSectionHeader(String title, IconData icon, bool isDark) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.primary),
        const SizedBox(width: 8),
        Text(
          title,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: isDark ? Colors.white : const Color(0xFF0F172A),
          ),
        ),
      ],
    );
  }

  InputDecoration _inputDecoration(String label, bool isDark, {String? prefix, String? suffix}) {
    return InputDecoration(
      labelText: label,
      labelStyle: GoogleFonts.plusJakartaSans(
        fontSize: 12,
        color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
      ),
      prefixText: prefix,
      suffixText: suffix,
      filled: true,
      fillColor: isDark ? const Color(0xFF1E2330) : const Color(0xFFF1F5F9),
      border: OutlineInputBorder(
        borderRadius: AppRadius.sm,
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: AppRadius.sm,
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    );
  }
}
