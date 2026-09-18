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
import 'package:cached_query_flutter/cached_query_flutter.dart';
import '../data/models/hrms_employee_api_model.dart';
import '../presentation/queries/hrms_queries.dart';

class EmployeeRegistrationDialog extends StatefulWidget {
  final HrmsEmployeeApiModel? employee;
  final VoidCallback? onEmployeeSaved;

  const EmployeeRegistrationDialog({
    super.key,
    this.employee,
    this.onEmployeeSaved,
  });

  static void show(
    BuildContext context, {
    HrmsEmployeeApiModel? employee,
    VoidCallback? onEmployeeSaved,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 820, maxHeight: 720),
          child: EmployeeRegistrationDialog(
            employee: employee,
            onEmployeeSaved: onEmployeeSaved,
          ),
        ),
      ),
    );
  }

  @override
  State<EmployeeRegistrationDialog> createState() => _EmployeeRegistrationDialogState();
}

class _EmployeeRegistrationDialogState extends State<EmployeeRegistrationDialog>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late TabController _tabController;

  // Identity & Personal
  final _employeeCodeCtrl = TextEditingController();
  final _firstNameCtrl = TextEditingController();
  final _middleNameCtrl = TextEditingController();
  final _lastNameCtrl = TextEditingController();
  final _displayNameCtrl = TextEditingController();
  String _gender = 'MALE';
  DateTime? _dateOfBirth;
  String _maritalStatus = 'SINGLE';
  String _bloodGroup = 'O_POSITIVE';
  List<int>? _avatarBytes;
  String? _avatarFileName;

  // Contact Information
  final _workEmailCtrl = TextEditingController();
  final _personalEmailCtrl = TextEditingController();
  final _workPhoneCtrl = TextEditingController();
  final _personalPhoneCtrl = TextEditingController();

  // Emergency Contact
  final _emergencyNameCtrl = TextEditingController();
  final _emergencyRelationCtrl = TextEditingController();
  final _emergencyPhoneCtrl = TextEditingController();

  // Current Address
  final _currentAddressCtrl = TextEditingController();
  final _currentCityCtrl = TextEditingController();
  final _currentStateCtrl = TextEditingController();
  final _currentCountryCtrl = TextEditingController(text: 'IN');
  final _currentPincodeCtrl = TextEditingController();

  // Permanent Address
  final _permanentAddressCtrl = TextEditingController();
  final _permanentCityCtrl = TextEditingController();
  final _permanentStateCtrl = TextEditingController();
  final _permanentCountryCtrl = TextEditingController(text: 'IN');
  final _permanentPincodeCtrl = TextEditingController();
  bool _sameAsCurrentAddress = false;

  // Job & Employment
  final _designationCtrl = TextEditingController();
  final _workLocationCtrl = TextEditingController();
  String _employmentType = 'FULL_TIME';
  String _employmentStatus = 'ACTIVE';
  String? _reportingManagerId;
  String? _departmentId;
  String? _teamId;
  String _departmentRole = 'MEMBER';
  DateTime _joiningDate = DateTime.now();
  DateTime? _probationEndDate;
  DateTime? _confirmationDate;
  int _noticePeriodDays = 30;

  // Statutory & Compliance
  final _panCtrl = TextEditingController();
  final _aadhaarCtrl = TextEditingController();
  final _uanCtrl = TextEditingController();
  final _pfCtrl = TextEditingController();
  final _esiCtrl = TextEditingController();
  final _passportCtrl = TextEditingController();
  String _taxRegime = 'NEW';

  // Bank Details
  final _bankHolderCtrl = TextEditingController();
  final _bankAccountCtrl = TextEditingController();
  final _bankNameCtrl = TextEditingController();
  final _bankIfscCtrl = TextEditingController();
  final _bankBranchCtrl = TextEditingController();

  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);

    final emp = widget.employee;
    if (emp != null) {
      _employeeCodeCtrl.text = emp.employeeCode;
      _firstNameCtrl.text = emp.firstName;
      _middleNameCtrl.text = emp.middleName ?? '';
      _lastNameCtrl.text = emp.lastName ?? '';
      _displayNameCtrl.text = emp.displayName ?? '';
      _gender = emp.gender ?? 'MALE';
      _dateOfBirth = emp.dateOfBirth;
      _maritalStatus = emp.maritalStatus ?? 'SINGLE';
      _bloodGroup = emp.bloodGroup ?? 'O_POSITIVE';

      _workEmailCtrl.text = emp.workEmail ?? '';
      _personalEmailCtrl.text = emp.personalEmail ?? '';
      _workPhoneCtrl.text = emp.workPhone ?? '';
      _personalPhoneCtrl.text = emp.personalPhone ?? '';

      _emergencyNameCtrl.text = emp.emergencyContactName ?? '';
      _emergencyRelationCtrl.text = emp.emergencyContactRelationship ?? '';
      _emergencyPhoneCtrl.text = emp.emergencyContactPhone ?? '';

      _currentAddressCtrl.text = emp.currentAddress ?? '';
      _currentCityCtrl.text = emp.currentCity ?? '';
      _currentStateCtrl.text = emp.currentState ?? '';
      _currentCountryCtrl.text = emp.currentCountry;
      _currentPincodeCtrl.text = emp.currentPincode ?? '';

      _permanentAddressCtrl.text = emp.permanentAddress ?? '';
      _permanentCityCtrl.text = emp.permanentCity ?? '';
      _permanentStateCtrl.text = emp.permanentState ?? '';
      _permanentCountryCtrl.text = emp.permanentCountry;
      _permanentPincodeCtrl.text = emp.permanentPincode ?? '';

      _designationCtrl.text = emp.designation;
      _workLocationCtrl.text = emp.workLocation ?? '';
      _employmentType = emp.employmentType;
      _employmentStatus = emp.employmentStatus;
      _reportingManagerId = emp.reportingManagerId;
      _departmentId = emp.department?.id;
      _teamId = emp.team?.id;
      _departmentRole = emp.departmentRole ?? 'MEMBER';
      _joiningDate = emp.joiningDate;
      _probationEndDate = emp.probationEndDate;
      _confirmationDate = emp.confirmationDate;
      _noticePeriodDays = emp.noticePeriodDays;

      _panCtrl.text = emp.panNumber ?? '';
      _aadhaarCtrl.text = emp.aadhaarNumber ?? '';
      _uanCtrl.text = emp.uanNumber ?? '';
      _pfCtrl.text = emp.pfNumber ?? '';
      _esiCtrl.text = emp.esiNumber ?? '';
      _passportCtrl.text = emp.passportNumber ?? '';
      _taxRegime = emp.taxRegime;

      _bankHolderCtrl.text = emp.bankAccountHolderName ?? '';
      _bankAccountCtrl.text = emp.bankAccountNumber ?? '';
      _bankNameCtrl.text = emp.bankName ?? '';
      _bankIfscCtrl.text = emp.bankIfscCode ?? '';
      _bankBranchCtrl.text = emp.bankBranchName ?? '';
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _employeeCodeCtrl.dispose();
    _firstNameCtrl.dispose();
    _middleNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _displayNameCtrl.dispose();
    _workEmailCtrl.dispose();
    _personalEmailCtrl.dispose();
    _workPhoneCtrl.dispose();
    _personalPhoneCtrl.dispose();
    _emergencyNameCtrl.dispose();
    _emergencyRelationCtrl.dispose();
    _emergencyPhoneCtrl.dispose();
    _currentAddressCtrl.dispose();
    _currentCityCtrl.dispose();
    _currentStateCtrl.dispose();
    _currentCountryCtrl.dispose();
    _currentPincodeCtrl.dispose();
    _permanentAddressCtrl.dispose();
    _permanentCityCtrl.dispose();
    _permanentStateCtrl.dispose();
    _permanentCountryCtrl.dispose();
    _permanentPincodeCtrl.dispose();
    _designationCtrl.dispose();
    _workLocationCtrl.dispose();
    _panCtrl.dispose();
    _aadhaarCtrl.dispose();
    _uanCtrl.dispose();
    _pfCtrl.dispose();
    _esiCtrl.dispose();
    _passportCtrl.dispose();
    _bankHolderCtrl.dispose();
    _bankAccountCtrl.dispose();
    _bankNameCtrl.dispose();
    _bankIfscCtrl.dispose();
    _bankBranchCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickAvatar() async {
    try {
      if (kIsWeb) {
        final webPicked = await pickImageWeb();
        if (webPicked != null) {
          setState(() {
            _avatarBytes = webPicked.bytes;
            _avatarFileName = webPicked.name;
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
      final picked = await picker.pickImage(source: ImageSource.gallery, maxWidth: 600, maxHeight: 600);
      if (picked != null) {
        final bytes = await picked.readAsBytes();
        setState(() {
          _avatarBytes = bytes;
          _avatarFileName = picked.name;
        });
      }
    } catch (e) {
      ToastService.showError('Failed to pick avatar: $e');
    }
  }

  void _syncPermanentAddress(bool? value) {
    setState(() {
      _sameAsCurrentAddress = value ?? false;
      if (_sameAsCurrentAddress) {
        _permanentAddressCtrl.text = _currentAddressCtrl.text;
        _permanentCityCtrl.text = _currentCityCtrl.text;
        _permanentStateCtrl.text = _currentStateCtrl.text;
        _permanentCountryCtrl.text = _currentCountryCtrl.text;
        _permanentPincodeCtrl.text = _currentPincodeCtrl.text;
      }
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please correct highlighted validation errors')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    final payload = <String, dynamic>{
      if (_employeeCodeCtrl.text.isNotEmpty) 'employeeCode': _employeeCodeCtrl.text.trim(),
      'firstName': _firstNameCtrl.text.trim(),
      if (_middleNameCtrl.text.isNotEmpty) 'middleName': _middleNameCtrl.text.trim(),
      if (_lastNameCtrl.text.isNotEmpty) 'lastName': _lastNameCtrl.text.trim(),
      if (_displayNameCtrl.text.isNotEmpty) 'displayName': _displayNameCtrl.text.trim(),
      'gender': _gender,
      if (_dateOfBirth != null) 'dateOfBirth': DateFormat('yyyy-MM-dd').format(_dateOfBirth!),
      'maritalStatus': _maritalStatus,
      'bloodGroup': _bloodGroup,
      if (_workEmailCtrl.text.isNotEmpty) 'workEmail': _workEmailCtrl.text.trim(),
      if (_personalEmailCtrl.text.isNotEmpty) 'personalEmail': _personalEmailCtrl.text.trim(),
      if (_workPhoneCtrl.text.isNotEmpty) 'workPhone': _workPhoneCtrl.text.trim(),
      if (_personalPhoneCtrl.text.isNotEmpty) 'personalPhone': _personalPhoneCtrl.text.trim(),
      if (_emergencyNameCtrl.text.isNotEmpty) 'emergencyContactName': _emergencyNameCtrl.text.trim(),
      if (_emergencyRelationCtrl.text.isNotEmpty)
        'emergencyContactRelationship': _emergencyRelationCtrl.text.trim(),
      if (_emergencyPhoneCtrl.text.isNotEmpty) 'emergencyContactPhone': _emergencyPhoneCtrl.text.trim(),
      if (_currentAddressCtrl.text.isNotEmpty) 'currentAddress': _currentAddressCtrl.text.trim(),
      if (_currentCityCtrl.text.isNotEmpty) 'currentCity': _currentCityCtrl.text.trim(),
      if (_currentStateCtrl.text.isNotEmpty) 'currentState': _currentStateCtrl.text.trim(),
      'currentCountry': _currentCountryCtrl.text.trim(),
      if (_currentPincodeCtrl.text.isNotEmpty) 'currentPincode': _currentPincodeCtrl.text.trim(),
      if (_permanentAddressCtrl.text.isNotEmpty) 'permanentAddress': _permanentAddressCtrl.text.trim(),
      if (_permanentCityCtrl.text.isNotEmpty) 'permanentCity': _permanentCityCtrl.text.trim(),
      if (_permanentStateCtrl.text.isNotEmpty) 'permanentState': _permanentStateCtrl.text.trim(),
      'permanentCountry': _permanentCountryCtrl.text.trim(),
      if (_permanentPincodeCtrl.text.isNotEmpty) 'permanentPincode': _permanentPincodeCtrl.text.trim(),
      'employmentType': _employmentType,
      'employmentStatus': _employmentStatus,
      'designation': _designationCtrl.text.trim(),
      if (_workLocationCtrl.text.isNotEmpty) 'workLocation': _workLocationCtrl.text.trim(),
      if (_reportingManagerId != null && _reportingManagerId!.isNotEmpty)
        'reportingManagerId': _reportingManagerId,
      'departmentId': _departmentId,
      'teamId': _teamId,
      'departmentRole': _departmentRole,
      'joiningDate': DateFormat('yyyy-MM-dd').format(_joiningDate),
      if (_probationEndDate != null)
        'probationEndDate': DateFormat('yyyy-MM-dd').format(_probationEndDate!),
      if (_confirmationDate != null)
        'confirmationDate': DateFormat('yyyy-MM-dd').format(_confirmationDate!),
      'noticePeriodDays': _noticePeriodDays,
      if (_panCtrl.text.isNotEmpty) 'panNumber': _panCtrl.text.trim().toUpperCase(),
      if (_aadhaarCtrl.text.isNotEmpty) 'aadhaarNumber': _aadhaarCtrl.text.trim(),
      if (_uanCtrl.text.isNotEmpty) 'uanNumber': _uanCtrl.text.trim(),
      if (_pfCtrl.text.isNotEmpty) 'pfNumber': _pfCtrl.text.trim(),
      if (_esiCtrl.text.isNotEmpty) 'esiNumber': _esiCtrl.text.trim(),
      if (_passportCtrl.text.isNotEmpty) 'passportNumber': _passportCtrl.text.trim(),
      'taxRegime': _taxRegime,
      if (_bankHolderCtrl.text.isNotEmpty) 'bankAccountHolderName': _bankHolderCtrl.text.trim(),
      if (_bankAccountCtrl.text.isNotEmpty) 'bankAccountNumber': _bankAccountCtrl.text.trim(),
      if (_bankNameCtrl.text.isNotEmpty) 'bankName': _bankNameCtrl.text.trim(),
      if (_bankIfscCtrl.text.isNotEmpty) 'bankIfscCode': _bankIfscCtrl.text.trim().toUpperCase(),
      if (_bankBranchCtrl.text.isNotEmpty) 'bankBranchName': _bankBranchCtrl.text.trim(),
    };

    if (widget.employee == null) {
      // Create mutation
      final mutation = hrmsQueries.getCreateEmployeeMutation(
        onSuccess: (_) {
          if (mounted) {
            Navigator.of(context).pop();
            if (widget.onEmployeeSaved != null) widget.onEmployeeSaved!();
          }
        },
      );
      await mutation.mutate((
        data: payload,
        avatarBytes: _avatarBytes,
        avatarFileName: _avatarFileName,
      ));
    } else {
      // Update mutation
      final mutation = hrmsQueries.getUpdateEmployeeMutation(
        onSuccess: (_) {
          if (mounted) {
            Navigator.of(context).pop();
            if (widget.onEmployeeSaved != null) widget.onEmployeeSaved!();
          }
        },
      );
      await mutation.mutate((
        id: widget.employee!.id,
        data: payload,
        avatarBytes: _avatarBytes,
        avatarFileName: _avatarFileName,
      ));
    }

    if (mounted) setState(() => _isSubmitting = false);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isEdit = widget.employee != null;

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
                    child: const Icon(Icons.person_add_alt_1_rounded, color: AppColors.primary, size: 20),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isEdit ? 'Edit Employee Dossier' : 'Onboard New Employee Profile',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: isDark ? Colors.white : const Color(0xFF0F172A),
                          ),
                        ),
                        Text(
                          'Complete all demographic, employment, statutory, and banking data fields',
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

            // Tab Navigation
            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: isDark ? Colors.white.withValues(alpha: 0.06) : Colors.black.withValues(alpha: 0.06),
                  ),
                ),
              ),
              child: TabBar(
                controller: _tabController,
                isScrollable: true,
                labelColor: AppColors.primary,
                unselectedLabelColor: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                indicatorColor: AppColors.primary,
                indicatorWeight: 2.5,
                labelStyle: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w600),
                tabs: const [
                  Tab(icon: Icon(Icons.badge_outlined, size: 16), text: '1. Identity & Bio'),
                  Tab(icon: Icon(Icons.contact_phone_outlined, size: 16), text: '2. Contacts & Emergency'),
                  Tab(icon: Icon(Icons.home_outlined, size: 16), text: '3. Dual Addresses'),
                  Tab(icon: Icon(Icons.work_outline_rounded, size: 16), text: '4. Job & Hierarchy'),
                  Tab(icon: Icon(Icons.verified_user_outlined, size: 16), text: '5. Compliance & Tax'),
                  Tab(icon: Icon(Icons.account_balance_outlined, size: 16), text: '6. Bank Payout'),
                ],
              ),
            ),

            // Tab Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildIdentityTab(isDark),
                  _buildContactsTab(isDark),
                  _buildAddressesTab(isDark),
                  _buildJobHierarchyTab(isDark),
                  _buildComplianceTab(isDark),
                  _buildBankTab(isDark),
                ],
              ),
            ),

            // Footer Actions
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      if (_tabController.index > 0)
                        OutlinedButton(
                          onPressed: () => setState(() => _tabController.animateTo(_tabController.index - 1)),
                          child: const Text('Previous Step'),
                        ),
                      const SizedBox(width: AppSpacing.sm),
                      if (_tabController.index < 5)
                        OutlinedButton(
                          onPressed: () => setState(() => _tabController.animateTo(_tabController.index + 1)),
                          child: const Text('Next Step'),
                        ),
                    ],
                  ),
                  Row(
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
                          _isSubmitting
                              ? 'Saving...'
                              : (isEdit ? 'Update Employee' : 'Onboard Employee'),
                          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
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
    );
  }

  // 1. Identity & Bio Tab
  Widget _buildIdentityTab(bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar Picker
              InkWell(
                onTap: _pickAvatar,
                borderRadius: BorderRadius.circular(40),
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 38,
                      backgroundColor: AppColors.primary.withValues(alpha: 0.15),
                      backgroundImage: _avatarBytes != null
                          ? MemoryImage(Uint8List.fromList(_avatarBytes!))
                          : (widget.employee?.avatarUrl != null ? NetworkImage(widget.employee!.avatarUrl!) : null) as ImageProvider?,
                      child: (_avatarBytes == null && widget.employee?.avatarUrl == null)
                          ? const Icon(Icons.person, size: 36, color: AppColors.primary)
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: CircleAvatar(
                        radius: 13,
                        backgroundColor: AppColors.primary,
                        child: const Icon(Icons.camera_alt_rounded, size: 14, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Profile Picture / Headshot',
                      style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w700),
                    ),
                    Text(
                      'Upload employee face photo (PNG, JPG or WEBP max 5MB). Automatically stored in cloud storage.',
                      style: GoogleFonts.plusJakartaSans(fontSize: 12, color: const Color(0xFF64748B)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),

          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _firstNameCtrl,
                  decoration: _inputDecoration('First Name *', isDark),
                  validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: TextFormField(
                  controller: _middleNameCtrl,
                  decoration: _inputDecoration('Middle Name', isDark),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: TextFormField(
                  controller: _lastNameCtrl,
                  decoration: _inputDecoration('Last Name', isDark),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _displayNameCtrl,
                  decoration: _inputDecoration('Display / Preferred Name', isDark),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: _gender,
                  decoration: _inputDecoration('Gender', isDark),
                  dropdownColor: isDark ? const Color(0xFF1E2330) : Colors.white,
                  items: const [
                    DropdownMenuItem(value: 'MALE', child: Text('Male')),
                    DropdownMenuItem(value: 'FEMALE', child: Text('Female')),
                    DropdownMenuItem(value: 'NON_BINARY', child: Text('Non-Binary')),
                    DropdownMenuItem(value: 'OTHER', child: Text('Other')),
                    DropdownMenuItem(value: 'PREFER_NOT_TO_SAY', child: Text('Prefer Not To Say')),
                  ],
                  onChanged: (v) => setState(() => _gender = v ?? 'MALE'),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: InkWell(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: _dateOfBirth ?? DateTime(1995, 1, 1),
                      firstDate: DateTime(1940),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) setState(() => _dateOfBirth = picked);
                  },
                  child: InputDecorator(
                    decoration: _inputDecoration('Date of Birth', isDark),
                    child: Text(
                      _dateOfBirth != null ? DateFormat('dd MMM yyyy').format(_dateOfBirth!) : 'Select Date',
                      style: GoogleFonts.plusJakartaSans(fontSize: 13),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: _maritalStatus,
                  decoration: _inputDecoration('Marital Status', isDark),
                  dropdownColor: isDark ? const Color(0xFF1E2330) : Colors.white,
                  items: const [
                    DropdownMenuItem(value: 'SINGLE', child: Text('Single')),
                    DropdownMenuItem(value: 'MARRIED', child: Text('Married')),
                    DropdownMenuItem(value: 'DIVORCED', child: Text('Divorced')),
                    DropdownMenuItem(value: 'WIDOWED', child: Text('Widowed')),
                  ],
                  onChanged: (v) => setState(() => _maritalStatus = v ?? 'SINGLE'),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: _bloodGroup,
                  decoration: _inputDecoration('Blood Group', isDark),
                  dropdownColor: isDark ? const Color(0xFF1E2330) : Colors.white,
                  items: const [
                    DropdownMenuItem(value: 'A_POSITIVE', child: Text('A+')),
                    DropdownMenuItem(value: 'A_NEGATIVE', child: Text('A-')),
                    DropdownMenuItem(value: 'B_POSITIVE', child: Text('B+')),
                    DropdownMenuItem(value: 'B_NEGATIVE', child: Text('B-')),
                    DropdownMenuItem(value: 'AB_POSITIVE', child: Text('AB+')),
                    DropdownMenuItem(value: 'AB_NEGATIVE', child: Text('AB-')),
                    DropdownMenuItem(value: 'O_POSITIVE', child: Text('O+')),
                    DropdownMenuItem(value: 'O_NEGATIVE', child: Text('O-')),
                  ],
                  onChanged: (v) => setState(() => _bloodGroup = v ?? 'O_POSITIVE'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 2. Contacts & Emergency Tab
  Widget _buildContactsTab(bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeading('Official & Personal Contact Lines', Icons.mail_outline_rounded, isDark),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _workEmailCtrl,
                  decoration: _inputDecoration('Work Email Address', isDark),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: TextFormField(
                  controller: _personalEmailCtrl,
                  decoration: _inputDecoration('Personal Email Address', isDark),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _workPhoneCtrl,
                  decoration: _inputDecoration('Work Phone / Extension', isDark),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: TextFormField(
                  controller: _personalPhoneCtrl,
                  decoration: _inputDecoration('Personal Mobile Number', isDark),
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.lg),
          _buildHeading('Emergency Contact Information', Icons.emergency_rounded, isDark),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _emergencyNameCtrl,
                  decoration: _inputDecoration('Emergency Contact Name', isDark),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: TextFormField(
                  controller: _emergencyRelationCtrl,
                  decoration: _inputDecoration('Relationship (e.g. Spouse, Father)', isDark),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: TextFormField(
                  controller: _emergencyPhoneCtrl,
                  decoration: _inputDecoration('Emergency Contact Phone', isDark),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 3. Dual Addresses Tab
  Widget _buildAddressesTab(bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeading('Current Residential Address', Icons.location_on_outlined, isDark),
          const SizedBox(height: AppSpacing.sm),
          TextFormField(
            controller: _currentAddressCtrl,
            decoration: _inputDecoration('Street Address / Apartment', isDark),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _currentCityCtrl,
                  decoration: _inputDecoration('City', isDark),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: TextFormField(
                  controller: _currentStateCtrl,
                  decoration: _inputDecoration('State', isDark),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: TextFormField(
                  controller: _currentPincodeCtrl,
                  decoration: _inputDecoration('Pincode / Postal Code', isDark),
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.lg),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildHeading('Permanent Address', Icons.home_work_outlined, isDark),
              Row(
                children: [
                  Checkbox(
                    value: _sameAsCurrentAddress,
                    onChanged: _syncPermanentAddress,
                    activeColor: AppColors.primary,
                  ),
                  Text('Same as Current Address', style: GoogleFonts.plusJakartaSans(fontSize: 12)),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          TextFormField(
            controller: _permanentAddressCtrl,
            decoration: _inputDecoration('Permanent Street Address', isDark),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _permanentCityCtrl,
                  decoration: _inputDecoration('Permanent City', isDark),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: TextFormField(
                  controller: _permanentStateCtrl,
                  decoration: _inputDecoration('Permanent State', isDark),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: TextFormField(
                  controller: _permanentPincodeCtrl,
                  decoration: _inputDecoration('Permanent Pincode', isDark),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 4. Job & Hierarchy Tab
  Widget _buildJobHierarchyTab(bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _employeeCodeCtrl,
                  decoration: _inputDecoration('Employee Code (Leave empty to auto-generate)', isDark),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: TextFormField(
                  controller: _designationCtrl,
                  decoration: _inputDecoration('Designation / Job Title *', isDark),
                  validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: _employmentType,
                  decoration: _inputDecoration('Employment Type', isDark),
                  dropdownColor: isDark ? const Color(0xFF1E2330) : Colors.white,
                  items: const [
                    DropdownMenuItem(value: 'FULL_TIME', child: Text('Full-Time Permanent')),
                    DropdownMenuItem(value: 'PART_TIME', child: Text('Part-Time')),
                    DropdownMenuItem(value: 'CONTRACT', child: Text('Contractual')),
                    DropdownMenuItem(value: 'INTERN', child: Text('Internship')),
                    DropdownMenuItem(value: 'PROBATIONARY', child: Text('Probationary')),
                    DropdownMenuItem(value: 'FREELANCE', child: Text('Freelance / Retainer')),
                  ],
                  onChanged: (v) => setState(() => _employmentType = v ?? 'FULL_TIME'),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: _employmentStatus,
                  decoration: _inputDecoration('Status', isDark),
                  dropdownColor: isDark ? const Color(0xFF1E2330) : Colors.white,
                  items: const [
                    DropdownMenuItem(value: 'ACTIVE', child: Text('Active')),
                    DropdownMenuItem(value: 'PROBATION', child: Text('On Probation')),
                    DropdownMenuItem(value: 'NOTICE_PERIOD', child: Text('Serving Notice')),
                    DropdownMenuItem(value: 'ON_LEAVE', child: Text('Extended Leave')),
                    DropdownMenuItem(value: 'RESIGNED', child: Text('Resigned')),
                    DropdownMenuItem(value: 'TERMINATED', child: Text('Terminated')),
                  ],
                  onChanged: (v) => setState(() => _employmentStatus = v ?? 'ACTIVE'),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _workLocationCtrl,
                  decoration: _inputDecoration('Work Location / Facility (e.g. Mumbai HQ)', isDark),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: InkWell(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: _joiningDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) setState(() => _joiningDate = picked);
                  },
                  child: InputDecorator(
                    decoration: _inputDecoration('Joining Date *', isDark),
                    child: Text(DateFormat('dd MMM yyyy').format(_joiningDate), style: GoogleFonts.plusJakartaSans(fontSize: 13)),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: _probationEndDate ?? DateTime.now().add(const Duration(days: 90)),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) setState(() => _probationEndDate = picked);
                  },
                  child: InputDecorator(
                    decoration: _inputDecoration('Probation End Date', isDark),
                    child: Text(_probationEndDate != null ? DateFormat('dd MMM yyyy').format(_probationEndDate!) : 'None',
                        style: GoogleFonts.plusJakartaSans(fontSize: 13)),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: DropdownButtonFormField<int>(
                  initialValue: _noticePeriodDays,
                  decoration: _inputDecoration('Notice Period', isDark),
                  dropdownColor: isDark ? const Color(0xFF1E2330) : Colors.white,
                  items: const [
                    DropdownMenuItem(value: 0, child: Text('Immediate (0 days)')),
                    DropdownMenuItem(value: 15, child: Text('15 Days')),
                    DropdownMenuItem(value: 30, child: Text('30 Days (1 Month)')),
                    DropdownMenuItem(value: 60, child: Text('60 Days (2 Months)')),
                    DropdownMenuItem(value: 90, child: Text('90 Days (3 Months)')),
                  ],
                  onChanged: (v) => setState(() => _noticePeriodDays = v ?? 30),
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.lg),
          _buildHeading('Department, Team & Role Allocation', Icons.account_tree_outlined, isDark),
          const SizedBox(height: AppSpacing.sm),

          // Department & Team Row
          QueryBuilder(
            query: hrmsQueries.getDepartmentsQuery(limit: 100),
            builder: (context, deptState) {
              final departments = deptState.data?.items ?? [];

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Department Selector
                      Expanded(
                        child: DropdownButtonFormField<String?>(
                          initialValue: _departmentId,
                          decoration: _inputDecoration('Assigned Department', isDark),
                          dropdownColor: isDark ? const Color(0xFF1E2330) : Colors.white,
                          isExpanded: true,
                          items: [
                            const DropdownMenuItem<String?>(
                              value: null,
                              child: Text('Unassigned / No Department'),
                            ),
                            ...departments.map((d) => DropdownMenuItem<String?>(
                                  value: d.id,
                                  child: Text('${d.name} (${d.code})', overflow: TextOverflow.ellipsis),
                                )),
                          ],
                          onChanged: (newDeptId) {
                            setState(() {
                              _departmentId = newDeptId;
                              _teamId = null; // Clear team when department changes
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),

                      // Team Selector (Dependent on selected department)
                      Expanded(
                        child: _departmentId == null
                            ? InputDecorator(
                                decoration: _inputDecoration('Project Team', isDark),
                                child: Text('Select department first',
                                    style: GoogleFonts.plusJakartaSans(
                                        fontSize: 13,
                                        color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8))),
                              )
                            : QueryBuilder(
                                query: hrmsQueries.getDepartmentTeamsQuery(_departmentId!),
                                builder: (context, teamState) {
                                  final teams = teamState.data ?? [];

                                  return DropdownButtonFormField<String?>(
                                    initialValue: _teamId,
                                    decoration: _inputDecoration('Project Team', isDark),
                                    dropdownColor: isDark ? const Color(0xFF1E2330) : Colors.white,
                                    isExpanded: true,
                                    items: [
                                      const DropdownMenuItem<String?>(
                                        value: null,
                                        child: Text('No Specific Team'),
                                      ),
                                      ...teams.map((t) => DropdownMenuItem<String?>(
                                            value: t.id,
                                            child: Text('${t.name} (${t.code})', overflow: TextOverflow.ellipsis),
                                          )),
                                    ],
                                    onChanged: (newTeamId) {
                                      setState(() => _teamId = newTeamId);
                                    },
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Department Role Selector
                  DropdownButtonFormField<String>(
                    initialValue: _departmentRole,
                    decoration: _inputDecoration('Department Role', isDark),
                    dropdownColor: isDark ? const Color(0xFF1E2330) : Colors.white,
                    items: const [
                      DropdownMenuItem(value: 'MEMBER', child: Text('Team Member')),
                      DropdownMenuItem(value: 'TEAM_LEAD', child: Text('Team Lead')),
                      DropdownMenuItem(value: 'HEAD_OF_DEPARTMENT', child: Text('Head of Department')),
                      DropdownMenuItem(value: 'DEPUTY_LEAD', child: Text('Deputy Lead')),
                      DropdownMenuItem(value: 'COORDINATOR', child: Text('Project Coordinator')),
                      DropdownMenuItem(value: 'CONSULTANT', child: Text('External Consultant')),
                      DropdownMenuItem(value: 'INTERN', child: Text('Department Intern')),
                    ],
                    onChanged: (v) => setState(() => _departmentRole = v ?? 'MEMBER'),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  // 5. Compliance & Tax Tab
  Widget _buildComplianceTab(bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _panCtrl,
                  decoration: _inputDecoration('PAN Number (e.g. ABCDE1234F)', isDark),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: TextFormField(
                  controller: _aadhaarCtrl,
                  decoration: _inputDecoration('Aadhaar Number (12 digits)', isDark),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _uanCtrl,
                  decoration: _inputDecoration('UAN Number (Universal EPFO)', isDark),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: TextFormField(
                  controller: _pfCtrl,
                  decoration: _inputDecoration('Provident Fund (PF) Member ID', isDark),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _esiCtrl,
                  decoration: _inputDecoration('ESI Number', isDark),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: TextFormField(
                  controller: _passportCtrl,
                  decoration: _inputDecoration('Passport Number', isDark),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: _taxRegime,
                  decoration: _inputDecoration('Income Tax Regime', isDark),
                  dropdownColor: isDark ? const Color(0xFF1E2330) : Colors.white,
                  items: const [
                    DropdownMenuItem(value: 'NEW', child: Text('New Tax Regime (Default)')),
                    DropdownMenuItem(value: 'OLD', child: Text('Old Tax Regime')),
                  ],
                  onChanged: (v) => setState(() => _taxRegime = v ?? 'NEW'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 6. Bank Payout Tab
  Widget _buildBankTab(bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _bankHolderCtrl,
                  decoration: _inputDecoration('Account Holder Name', isDark),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: TextFormField(
                  controller: _bankAccountCtrl,
                  decoration: _inputDecoration('Bank Account Number', isDark),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _bankNameCtrl,
                  decoration: _inputDecoration('Bank Name (e.g. HDFC Bank)', isDark),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: TextFormField(
                  controller: _bankIfscCtrl,
                  decoration: _inputDecoration('IFSC / SWIFT Code', isDark),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: TextFormField(
                  controller: _bankBranchCtrl,
                  decoration: _inputDecoration('Branch Name', isDark),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeading(String title, IconData icon, bool isDark) {
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

  InputDecoration _inputDecoration(String label, bool isDark) {
    return InputDecoration(
      labelText: label,
      labelStyle: GoogleFonts.plusJakartaSans(
        fontSize: 12,
        color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
      ),
      filled: true,
      fillColor: isDark ? const Color(0xFF1E2330) : const Color(0xFFF1F5F9),
      border: OutlineInputBorder(borderRadius: AppRadius.sm, borderSide: BorderSide.none),
      focusedBorder: OutlineInputBorder(
        borderRadius: AppRadius.sm,
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    );
  }
}
