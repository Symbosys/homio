import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/responsive/breakpoints.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../models/profile_models.dart';

/// Modal dialog for updating personal details
class EditProfileModal extends StatefulWidget {
  const EditProfileModal({super.key});

  static Future<void> show(BuildContext context) {
    final isMobile = Breakpoints.isCompact(context);
    if (isMobile) {
      return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => const FractionallySizedBox(
          heightFactor: 0.88,
          child: EditProfileModal(),
        ),
      );
    }
    return showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520, maxHeight: 620),
          child: const EditProfileModal(),
        ),
      ),
    );
  }

  @override
  State<EditProfileModal> createState() => _EditProfileModalState();
}

class _EditProfileModalState extends State<EditProfileModal> {
  final _formKey = GlobalKey<FormState>();
  final _repo = ProfileRepository.instance;

  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _altPhoneController;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(text: _repo.profile.firstName);
    _lastNameController = TextEditingController(text: _repo.profile.lastName);
    _emailController = TextEditingController(text: _repo.profile.email);
    _phoneController = TextEditingController(text: _repo.profile.mobile);
    _altPhoneController = TextEditingController(text: _repo.profile.alternateMobile);
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _altPhoneController.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      _repo.updatePersonalDetails(
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        email: _emailController.text.trim(),
        mobile: _phoneController.text.trim(),
        alternateMobile: _altPhoneController.text.trim(),
      );
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile details updated successfully.'),
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
                  'Edit Personal Information',
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
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'First Name *',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                                ),
                              ),
                              const SizedBox(height: 6),
                              TextFormField(
                                controller: _firstNameController,
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
                                'Last Name *',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                                ),
                              ),
                              const SizedBox(height: 6),
                              TextFormField(
                                controller: _lastNameController,
                                style: GoogleFonts.inter(fontSize: 13),
                                decoration: _inputDecoration(isDark),
                                validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Mobile
                    Text(
                      'Primary Mobile Number *',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      style: GoogleFonts.inter(fontSize: 13),
                      decoration: _inputDecoration(isDark, prefixIcon: Icons.phone_android_rounded),
                      validator: (v) => v == null || v.trim().length < 10 ? 'Enter valid mobile' : null,
                    ),
                    const SizedBox(height: 16),

                    // Email
                    Text(
                      'Email Address *',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: GoogleFonts.inter(fontSize: 13),
                      decoration: _inputDecoration(isDark, prefixIcon: Icons.email_outlined),
                      validator: (v) => v == null || !v.contains('@') ? 'Enter valid email' : null,
                    ),
                    const SizedBox(height: 16),

                    // Alternate Phone
                    Text(
                      'Alternate Mobile (Optional)',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _altPhoneController,
                      keyboardType: TextInputType.phone,
                      style: GoogleFonts.inter(fontSize: 13),
                      decoration: _inputDecoration(isDark, prefixIcon: Icons.phone_rounded),
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
                  'Save Profile Details',
                  style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(bool isDark, {IconData? prefixIcon}) {
    return InputDecoration(
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      prefixIcon: prefixIcon != null ? Icon(prefixIcon, size: 16) : null,
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
