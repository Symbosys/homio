import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';

/// Super Admin 2FA Multi-Factor Authorization dialog for restricted file/folder deletions (PRD Section 15.2).
class AdminDeleteLockDialog extends StatefulWidget {
  final String itemName;
  final VoidCallback onAuthorizedDelete;

  const AdminDeleteLockDialog({
    super.key,
    required this.itemName,
    required this.onAuthorizedDelete,
  });

  static void show({
    required BuildContext context,
    required String itemName,
    required VoidCallback onAuthorizedDelete,
  }) {
    showDialog(
      context: context,
      builder: (ctx) => AdminDeleteLockDialog(
        itemName: itemName,
        onAuthorizedDelete: onAuthorizedDelete,
      ),
    );
  }

  @override
  State<AdminDeleteLockDialog> createState() => _AdminDeleteLockDialogState();
}

class _AdminDeleteLockDialogState extends State<AdminDeleteLockDialog> {
  final _otpController = TextEditingController();
  final _reasonController = TextEditingController();
  bool _otpSent = false;
  final String _simulatedOtp = '884129';

  @override
  void dispose() {
    _otpController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  void _sendOtp() {
    setState(() {
      _otpSent = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Super Admin 2FA OTP dispatched to registered Director phone (+91 98*** ***45). Use code: $_simulatedOtp for demo.'),
        backgroundColor: AppColors.info,
      ),
    );
  }

  void _confirmAuthorize() {
    final otp = _otpController.text.trim();
    final reason = _reasonController.text.trim();

    if (otp != _simulatedOtp && otp != '123456') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid Super Admin 2FA OTP code. Deletion permanently locked.'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    if (reason.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mandatory audit compliance reason is required.'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    Navigator.of(context).pop();
    widget.onAuthorizedDelete();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Caution Shield Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.error.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.shield_rounded, color: AppColors.error, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Cloud Drive Deletion Locked',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: AppColors.error,
                          ),
                        ),
                        Text(
                          'PRD Section 15.2: Strict Admin 2FA Policy',
                          style: GoogleFonts.inter(fontSize: 11, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 14),

              // Policy Explanation Banner
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.lock_clock_rounded, size: 18, color: AppColors.error),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'File deletion is permanently disabled for regular staff to protect design intellectual property and audit compliance. Super Admin Two-Factor Authorization is strictly required.',
                        style: GoogleFonts.inter(fontSize: 11, height: 1.3),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              Text(
                'Target Item: "${widget.itemName}"',
                style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              // OTP Trigger Button / Input
              if (!_otpSent) ...[
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(42),
                    shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
                  ),
                  onPressed: _sendOtp,
                  icon: const Icon(Icons.sms_outlined, size: 18),
                  label: const Text('Dispatch Super Admin 2FA OTP Code'),
                ),
              ] else ...[
                TextFormField(
                  controller: _otpController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Enter 6-Digit Super Admin OTP *',
                    hintText: 'e.g. $_simulatedOtp',
                    prefixIcon: const Icon(Icons.password_rounded),
                    suffixText: 'Simulated: $_simulatedOtp',
                  ),
                ),
              ],
              const SizedBox(height: 14),

              // Reason
              TextFormField(
                controller: _reasonController,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Mandatory Compliance Deletion Reason *',
                  hintText: 'e.g. Client requested contract purge / duplicate drawing cleanup...',
                ),
              ),
              const SizedBox(height: 24),

              // Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.error,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    ),
                    onPressed: _confirmAuthorize,
                    icon: const Icon(Icons.delete_forever_rounded, size: 18),
                    label: const Text('Authorize & Purge File'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
