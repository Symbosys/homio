import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../data/models/platform_org_model.dart';
import '../queries/platform_queries.dart';
import 'logo_picker_field.dart';

class EditOrganizationDialog extends StatefulWidget {
  final PlatformOrgModel organization;
  final PlatformQueries queries;

  const EditOrganizationDialog({
    super.key,
    required this.organization,
    required this.queries,
  });

  static Future<bool?> show(
    BuildContext context, {
    required PlatformOrgModel organization,
    required PlatformQueries queries,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => EditOrganizationDialog(
        organization: organization,
        queries: queries,
      ),
    );
  }

  @override
  State<EditOrganizationDialog> createState() => _EditOrganizationDialogState();
}

class _EditOrganizationDialogState extends State<EditOrganizationDialog> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _legalNameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _websiteController;
  late final TextEditingController _taxIdController;
  late final TextEditingController _cityController;
  late final TextEditingController _stateController;
  late final TextEditingController _addressController;
  late final TextEditingController _pincodeController;

  Uint8List? _newLogoBytes;
  String? _newLogoFileName;
  bool _isSubmitting = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    final org = widget.organization;
    _nameController = TextEditingController(text: org.name);
    _legalNameController = TextEditingController(text: org.legalName ?? '');
    _emailController = TextEditingController(text: org.email ?? '');
    _phoneController = TextEditingController(text: org.phone ?? '');
    _websiteController = TextEditingController(text: org.website ?? '');
    _taxIdController = TextEditingController(text: org.taxId ?? '');
    _cityController = TextEditingController(text: org.city ?? '');
    _stateController = TextEditingController(text: org.state ?? '');
    _addressController = TextEditingController();
    _pincodeController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _legalNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _websiteController.dispose();
    _taxIdController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _addressController.dispose();
    _pincodeController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
      _error = null;
    });

    try {
      final updatePayload = <String, dynamic>{
        'name': _nameController.text.trim(),
        'legalName': _legalNameController.text.trim().isNotEmpty
            ? _legalNameController.text.trim()
            : null,
        'email': _emailController.text.trim().isNotEmpty
            ? _emailController.text.trim().toLowerCase()
            : null,
        'phone': _phoneController.text.trim().isNotEmpty ? _phoneController.text.trim() : null,
        'website': _websiteController.text.trim().isNotEmpty ? _websiteController.text.trim() : null,
        'taxId': _taxIdController.text.trim().isNotEmpty ? _taxIdController.text.trim() : null,
        'city': _cityController.text.trim().isNotEmpty ? _cityController.text.trim() : null,
        'state': _stateController.text.trim().isNotEmpty ? _stateController.text.trim() : null,
        if (_addressController.text.trim().isNotEmpty)
          'address': _addressController.text.trim(),
        if (_pincodeController.text.trim().isNotEmpty)
          'pincode': _pincodeController.text.trim(),
      };

      final mutation = widget.queries.getUpdateOrgMutation(
        onUpdated: (_) {
          if (mounted) {
            Navigator.of(context).pop(true);
          }
        },
      );

      final result = await mutation.mutate((
        id: widget.organization.id,
        data: updatePayload,
        logoBytes: _newLogoBytes,
        logoFileName: _newLogoFileName,
      ));

      if (result.error != null && mounted) {
        setState(() {
          _error = result.error.toString();
          _isSubmitting = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString().replaceAll('Exception:', '').trim();
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 680, maxHeight: 720),
        child: Column(
          children: [
            // Modal Header
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 20, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF8B5CF6).withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.business_rounded, color: Color(0xFF8B5CF6), size: 20),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Edit Organization',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: isDark ? Colors.white : const Color(0xFF0F172A),
                            ),
                          ),
                          Text(
                            'Update organization profile, contact information, and logo',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: _isSubmitting ? null : () => Navigator.of(context).pop(false),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),

            // Scrollable Form Body
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (_error != null) ...[
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.red.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
                          ),
                          child: Text(_error!, style: const TextStyle(color: Colors.red)),
                        ),
                        const SizedBox(height: 16),
                      ],

                      // Logo Upload Section
                      Text(
                        'Organization Logo',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(height: 10),
                      LogoPickerField(
                        initialUrl: widget.organization.logoUrl,
                        selectedBytes: _newLogoBytes,
                        selectedFileName: _newLogoFileName,
                        onImageSelected: (bytes, name) {
                          setState(() {
                            _newLogoBytes = bytes;
                            _newLogoFileName = name;
                          });
                        },
                        onImageRemoved: () {
                          setState(() {
                            _newLogoBytes = null;
                            _newLogoFileName = null;
                          });
                        },
                      ),
                      const SizedBox(height: 20),

                      // Name & Legal Name
                      Row(
                        children: [
                          Expanded(
                            child: AppTextField(
                              controller: _nameController,
                              label: 'Studio / Business Name',
                              prefixIcon: Icons.apartment_rounded,
                              validator: (val) => val == null || val.trim().isEmpty
                                  ? 'Name is required'
                                  : null,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: AppTextField(
                              controller: _legalNameController,
                              label: 'Legal Registered Name',
                              prefixIcon: Icons.gavel_rounded,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // Email & Phone
                      Row(
                        children: [
                          Expanded(
                            child: AppTextField(
                              controller: _emailController,
                              label: 'Official Email',
                              prefixIcon: Icons.email_rounded,
                              keyboardType: TextInputType.emailAddress,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: AppTextField(
                              controller: _phoneController,
                              label: 'Contact Phone',
                              prefixIcon: Icons.phone_rounded,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // Website & Tax ID
                      Row(
                        children: [
                          Expanded(
                            child: AppTextField(
                              controller: _websiteController,
                              label: 'Website',
                              hintText: 'https://studioaranya.com',
                              prefixIcon: Icons.language_rounded,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: AppTextField(
                              controller: _taxIdController,
                              label: 'GSTIN / Tax ID',
                              prefixIcon: Icons.receipt_long_rounded,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // City, State, Pincode
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: AppTextField(
                              controller: _cityController,
                              label: 'City',
                              prefixIcon: Icons.location_city_rounded,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 2,
                            child: AppTextField(
                              controller: _stateController,
                              label: 'State',
                              prefixIcon: Icons.map_rounded,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 1,
                            child: AppTextField(
                              controller: _pincodeController,
                              label: 'Pincode',
                              prefixIcon: Icons.pin_drop_rounded,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // Address
                      AppTextField(
                        controller: _addressController,
                        label: 'Street Address',
                        prefixIcon: Icons.home_work_rounded,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Modal Footer Actions
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: _isSubmitting ? null : () => Navigator.of(context).pop(false),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                    width: 160,
                    child: AppButton(
                      text: 'Save Changes',
                      size: AppButtonSize.medium,
                      isLoading: _isSubmitting,
                      onPressed: _handleSave,
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
