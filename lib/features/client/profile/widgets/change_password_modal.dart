import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/responsive/breakpoints.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';

/// Modal dialog for changing customer password with real-time requirements checks
class ChangePasswordModal extends StatefulWidget {
  const ChangePasswordModal({super.key});

  static Future<void> show(BuildContext context) {
    final isMobile = Breakpoints.isCompact(context);
    if (isMobile) {
      return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => const FractionallySizedBox(
          heightFactor: 0.88,
          child: ChangePasswordModal(),
        ),
      );
    }
    return showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520, maxHeight: 660),
          child: const ChangePasswordModal(),
        ),
      ),
    );
  }

  @override
  State<ChangePasswordModal> createState() => _ChangePasswordModalState();
}

class _ChangePasswordModalState extends State<ChangePasswordModal> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _currentPassController = TextEditingController();
  final TextEditingController _newPassController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();

  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  bool get _hasMinLength => _newPassController.text.length >= 8;
  bool get _hasUpper => _newPassController.text.contains(RegExp(r'[A-Z]'));
  bool get _hasLower => _newPassController.text.contains(RegExp(r'[a-z]'));
  bool get _hasNumber => _newPassController.text.contains(RegExp(r'[0-9]'));
  bool get _hasSpecial => _newPassController.text.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

  bool get _allRequirementsMet =>
      _hasMinLength && _hasUpper && _hasLower && _hasNumber && _hasSpecial;

  @override
  void dispose() {
    _currentPassController.dispose();
    _newPassController.dispose();
    _confirmPassController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate() && _allRequirementsMet) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password changed successfully. New session authorized.'),
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
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEF4444).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.lock_reset_rounded, size: 20, color: Color(0xFFEF4444)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Change Password',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                        ),
                      ),
                      Text(
                        'Ensure your account security with a strong credential',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
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
                    // Current Password
                    Text(
                      'Current Password *',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _currentPassController,
                      obscureText: _obscureCurrent,
                      style: GoogleFonts.inter(fontSize: 13),
                      decoration: _inputDecoration(
                        isDark,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureCurrent ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                            size: 18,
                          ),
                          onPressed: () => setState(() => _obscureCurrent = !_obscureCurrent),
                        ),
                      ),
                      validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 16),

                    // New Password
                    Text(
                      'New Password *',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _newPassController,
                      obscureText: _obscureNew,
                      onChanged: (_) => setState(() {}),
                      style: GoogleFonts.inter(fontSize: 13),
                      decoration: _inputDecoration(
                        isDark,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureNew ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                            size: 18,
                          ),
                          onPressed: () => setState(() => _obscureNew = !_obscureNew),
                        ),
                      ),
                      validator: (v) => v == null || !_allRequirementsMet
                          ? 'Password does not meet requirements'
                          : null,
                    ),
                    const SizedBox(height: 14),

                    // Password Requirements Checklist
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkSurfaceElevated : const Color(0xFFF8FAFC),
                        borderRadius: AppRadius.md,
                        border: Border.all(
                          color: isDark ? AppColors.darkBorder : Colors.grey.shade200,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Password Requirements:',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          _buildRuleRow('Minimum 8 characters', _hasMinLength, isDark),
                          _buildRuleRow('At least 1 uppercase letter (A-Z)', _hasUpper, isDark),
                          _buildRuleRow('At least 1 lowercase letter (a-z)', _hasLower, isDark),
                          _buildRuleRow('At least 1 numeric digit (0-9)', _hasNumber, isDark),
                          _buildRuleRow('At least 1 special character (!@#\$%^&*)', _hasSpecial, isDark),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Confirm Password
                    Text(
                      'Confirm New Password *',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _confirmPassController,
                      obscureText: _obscureConfirm,
                      style: GoogleFonts.inter(fontSize: 13),
                      decoration: _inputDecoration(
                        isDark,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirm ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                            size: 18,
                          ),
                          onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
                        ),
                      ),
                      validator: (v) => v != _newPassController.text ? 'Passwords do not match' : null,
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
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  shape: RoundedRectangleBorder(borderRadius: AppRadius.md),
                  elevation: 0,
                ),
                child: Text(
                  'Update Password',
                  style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRuleRow(String text, bool isMet, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(
            isMet ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
            size: 14,
            color: isMet ? const Color(0xFF10B981) : Colors.grey,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: GoogleFonts.inter(
              fontSize: 11,
              color: isMet
                  ? (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)
                  : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
              fontWeight: isMet ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(bool isDark, {Widget? suffixIcon}) {
    return InputDecoration(
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      suffixIcon: suffixIcon,
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
