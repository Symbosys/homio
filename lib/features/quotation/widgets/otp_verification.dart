import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';

/// OTP Verification widget for Customer Self-Estimator with resend countdown.
class OtpVerification extends StatefulWidget {
  final String phone;
  final VoidCallback onVerified;
  final VoidCallback onChangePhone;

  const OtpVerification({
    super.key,
    required this.phone,
    required this.onVerified,
    required this.onChangePhone,
  });

  @override
  State<OtpVerification> createState() => _OtpVerificationState();
}

class _OtpVerificationState extends State<OtpVerification> {
  final List<TextEditingController> _controllers = List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());
  int _countdown = 30;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() => _countdown = 30);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      if (_countdown > 0) {
        setState(() => _countdown--);
      } else {
        t.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var c in _controllers) {
      c.dispose();
    }
    for (var f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _checkOtp() {
    final entered = _controllers.map((c) => c.text).join();
    if (entered.length == 4) {
      // Demo acceptance: '1234' or any 4 digits
      widget.onVerified();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: AppRadius.lg,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          width: 0.8,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.phonelink_lock_rounded, size: 28, color: AppColors.primary),
          ),
          const SizedBox(height: 14),
          Text(
            'Verify Mobile Number',
            style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Enter 4-digit code sent to ${widget.phone}',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                ),
              ),
              const SizedBox(width: 6),
              InkWell(
                onTap: widget.onChangePhone,
                child: Text(
                  'Change',
                  style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // 4-box OTP input
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(4, (index) {
              return Container(
                width: 45,
                height: 50,
                margin: const EdgeInsets.symmetric(horizontal: 6),
                child: TextField(
                  controller: _controllers[index],
                  focusNode: _focusNodes[index],
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  maxLength: 1,
                  style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w700),
                  decoration: InputDecoration(
                    counterText: '',
                    border: OutlineInputBorder(borderRadius: AppRadius.sm),
                    contentPadding: EdgeInsets.zero,
                  ),
                  onChanged: (val) {
                    if (val.isNotEmpty && index < 3) {
                      _focusNodes[index + 1].requestFocus();
                    } else if (val.isEmpty && index > 0) {
                      _focusNodes[index - 1].requestFocus();
                    }
                    _checkOtp();
                  },
                ),
              );
            }),
          ),
          const SizedBox(height: 16),

          // Resend or countdown
          if (_countdown > 0)
            Text(
              'Resend code in ${_countdown}s',
              style: GoogleFonts.inter(fontSize: 12, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
            )
          else
            TextButton.icon(
              onPressed: _startTimer,
              icon: const Icon(Icons.refresh_rounded, size: 14),
              label: Text('Resend OTP', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600)),
            ),
          const SizedBox(height: 16),

          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () {
                // Quick verify for demo
                widget.onVerified();
              },
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
              ),
              child: Text('Verify & View Instant Estimate', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }
}
