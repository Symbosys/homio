import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/responsive/breakpoints.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../models/profile_models.dart';

/// Modal dialog for adding or editing an address in the customer address book
class AddEditAddressModal extends StatefulWidget {
  final CustomerAddress? address;

  const AddEditAddressModal({super.key, this.address});

  static Future<void> show(BuildContext context, {CustomerAddress? address}) {
    final isMobile = Breakpoints.isCompact(context);
    if (isMobile) {
      return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => FractionallySizedBox(
          heightFactor: 0.92,
          child: AddEditAddressModal(address: address),
        ),
      );
    }
    return showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 580, maxHeight: 720),
          child: AddEditAddressModal(address: address),
        ),
      ),
    );
  }

  @override
  State<AddEditAddressModal> createState() => _AddEditAddressModalState();
}

class _AddEditAddressModalState extends State<AddEditAddressModal> {
  final _formKey = GlobalKey<FormState>();
  final _repo = ProfileRepository.instance;

  late String _addressType;
  late final TextEditingController _line1Controller;
  late final TextEditingController _line2Controller;
  late final TextEditingController _localityController;
  late final TextEditingController _cityController;
  late final TextEditingController _stateController;
  late final TextEditingController _pinController;
  late final TextEditingController _landmarkController;
  late final TextEditingController _contactPersonController;
  late final TextEditingController _contactPhoneController;
  late bool _isDefault;

  @override
  void initState() {
    super.initState();
    final a = widget.address;
    _addressType = a?.title ?? 'Home';
    _line1Controller = TextEditingController(text: a?.addressLine1 ?? '');
    _line2Controller = TextEditingController(text: a?.addressLine2 ?? '');
    _localityController = TextEditingController(text: a?.locality ?? '');
    _cityController = TextEditingController(text: a?.city ?? 'Dhanbad');
    _stateController = TextEditingController(text: a?.state ?? 'Jharkhand');
    _pinController = TextEditingController(text: a?.pinCode ?? '828127');
    _landmarkController = TextEditingController(text: a?.landmark ?? '');
    _contactPersonController = TextEditingController(text: a?.contactPerson ?? 'Amit Kumar');
    _contactPhoneController = TextEditingController(text: a?.contactPhone ?? '+91 98765 43210');
    _isDefault = a?.isDefault ?? false;
  }

  @override
  void dispose() {
    _line1Controller.dispose();
    _line2Controller.dispose();
    _localityController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _pinController.dispose();
    _landmarkController.dispose();
    _contactPersonController.dispose();
    _contactPhoneController.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      if (widget.address == null) {
        final newAddress = CustomerAddress(
          id: 'addr_${DateTime.now().millisecondsSinceEpoch}',
          title: _addressType,
          addressLine1: _line1Controller.text.trim(),
          addressLine2: _line2Controller.text.trim(),
          locality: _localityController.text.trim(),
          city: _cityController.text.trim(),
          state: _stateController.text.trim(),
          pinCode: _pinController.text.trim(),
          landmark: _landmarkController.text.trim(),
          contactPerson: _contactPersonController.text.trim(),
          contactPhone: _contactPhoneController.text.trim(),
          isDefault: _isDefault,
        );
        _repo.addAddress(newAddress);
      } else {
        final updated = CustomerAddress(
          id: widget.address!.id,
          title: _addressType,
          addressLine1: _line1Controller.text.trim(),
          addressLine2: _line2Controller.text.trim(),
          locality: _localityController.text.trim(),
          city: _cityController.text.trim(),
          state: _stateController.text.trim(),
          pinCode: _pinController.text.trim(),
          landmark: _landmarkController.text.trim(),
          contactPerson: _contactPersonController.text.trim(),
          contactPhone: _contactPhoneController.text.trim(),
          isDefault: _isDefault,
        );
        _repo.updateAddress(updated);
      }
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Address saved successfully in your address book.'),
          backgroundColor: Color(0xFF10B981),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : Colors.grey.shade200,
        ),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: isDark ? AppColors.darkBorder : Colors.grey.shade200,
                ),
              ),
            ),
            child: Row(
              children: [
                Text(
                  widget.address == null ? 'Add New Address' : 'Edit Address',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close_rounded, size: 20),
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                ),
              ],
            ),
          ),

          // Body Form
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Address Type Selector
                    Text(
                      'Address Type',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: ['Home', 'Project Site', 'Office', 'Other'].map((type) {
                        final isSel = _addressType == type;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text(type),
                            selected: isSel,
                            selectedColor: AppColors.primary,
                            onSelected: (_) => setState(() => _addressType = type),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),

                    // Address Line 1
                    Text(
                      'Address Line 1 (Flat, House No., Building) *',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _line1Controller,
                      style: GoogleFonts.inter(fontSize: 13),
                      decoration: _inputDecoration(isDark, hint: 'e.g. Tower 4, Flat 1202'),
                      validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 14),

                    // Address Line 2
                    Text(
                      'Address Line 2 (Society / Apartment / Road)',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _line2Controller,
                      style: GoogleFonts.inter(fontSize: 13),
                      decoration: _inputDecoration(isDark, hint: 'e.g. Palm Heights Luxury Enclave'),
                    ),
                    const SizedBox(height: 14),

                    // Locality & Landmark
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Locality / Area *',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                                ),
                              ),
                              const SizedBox(height: 6),
                              TextFormField(
                                controller: _localityController,
                                style: GoogleFonts.inter(fontSize: 13),
                                decoration: _inputDecoration(isDark, hint: 'Saraidhela'),
                                validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Landmark',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                                ),
                              ),
                              const SizedBox(height: 6),
                              TextFormField(
                                controller: _landmarkController,
                                style: GoogleFonts.inter(fontSize: 13),
                                decoration: _inputDecoration(isDark, hint: 'Near Big Bazaar'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // City & State & PIN
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'City *',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                                ),
                              ),
                              const SizedBox(height: 6),
                              TextFormField(
                                controller: _cityController,
                                style: GoogleFonts.inter(fontSize: 13),
                                decoration: _inputDecoration(isDark),
                                validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'State *',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                                ),
                              ),
                              const SizedBox(height: 6),
                              TextFormField(
                                controller: _stateController,
                                style: GoogleFonts.inter(fontSize: 13),
                                decoration: _inputDecoration(isDark),
                                validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'PIN Code *',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                                ),
                              ),
                              const SizedBox(height: 6),
                              TextFormField(
                                controller: _pinController,
                                keyboardType: TextInputType.number,
                                style: GoogleFonts.inter(fontSize: 13),
                                decoration: _inputDecoration(isDark),
                                validator: (v) => v == null || v.trim().length < 6 ? '6 digits' : null,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Contact Name & Phone
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Contact Person *',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                                ),
                              ),
                              const SizedBox(height: 6),
                              TextFormField(
                                controller: _contactPersonController,
                                style: GoogleFonts.inter(fontSize: 13),
                                decoration: _inputDecoration(isDark),
                                validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Contact Number *',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                                ),
                              ),
                              const SizedBox(height: 6),
                              TextFormField(
                                controller: _contactPhoneController,
                                keyboardType: TextInputType.phone,
                                style: GoogleFonts.inter(fontSize: 13),
                                decoration: _inputDecoration(isDark),
                                validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Default Address Toggle
                    SwitchListTile.adaptive(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        'Set as Default Delivery & Site Address',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                        ),
                      ),
                      value: _isDefault,
                      activeThumbColor: AppColors.primary,
                      onChanged: (v) => setState(() => _isDefault = v),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Bottom Bar
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCard : Colors.white,
              border: Border(
                top: BorderSide(
                  color: isDark ? AppColors.darkBorder : Colors.grey.shade200,
                ),
              ),
            ),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  shape: RoundedRectangleBorder(borderRadius: AppRadius.md),
                  elevation: 0,
                ),
                child: Text(
                  widget.address == null ? 'Add Address' : 'Save Changes',
                  style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(bool isDark, {String? hint}) {
    return InputDecoration(
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      hintText: hint,
      hintStyle: GoogleFonts.inter(
        fontSize: 12,
        color: isDark ? AppColors.darkTextSecondary : Colors.grey.shade400,
      ),
      filled: true,
      fillColor: isDark ? AppColors.darkSurfaceElevated : Colors.grey.shade50,
      border: OutlineInputBorder(
        borderRadius: AppRadius.md,
        borderSide: BorderSide(
          color: isDark ? AppColors.darkBorder : Colors.grey.shade300,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: AppRadius.md,
        borderSide: BorderSide(
          color: isDark ? AppColors.darkBorder : Colors.grey.shade300,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: AppRadius.md,
        borderSide: BorderSide(color: AppColors.primary, width: 1.5),
      ),
    );
  }
}
