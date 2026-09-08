import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';

/// Modal dialog for Geofence Punch In / Punch Out with GPS & selfie verification hooks.
class AttendancePunchModal extends StatefulWidget {
  final bool isClockingIn;
  final String defaultLocation;
  final VoidCallback onPunchConfirmed;

  const AttendancePunchModal({
    super.key,
    required this.isClockingIn,
    this.defaultLocation = 'HQ — DLF Phase 5 Hub (100m Geofence)',
    required this.onPunchConfirmed,
  });

  static void show(
    BuildContext context, {
    required bool isClockingIn,
    String defaultLocation = 'HQ — DLF Phase 5 Hub (100m Geofence)',
    required VoidCallback onPunchConfirmed,
  }) {
    showDialog(
      context: context,
      builder: (context) => AttendancePunchModal(
        isClockingIn: isClockingIn,
        defaultLocation: defaultLocation,
        onPunchConfirmed: onPunchConfirmed,
      ),
    );
  }

  @override
  State<AttendancePunchModal> createState() => _AttendancePunchModalState();
}

class _AttendancePunchModalState extends State<AttendancePunchModal> {
  bool _isLocating = true;
  bool _geofencePassed = false;
  bool _selfieCaptured = false;
  final double _distanceFromCenter = 38.4; // meters

  @override
  void initState() {
    super.initState();
    _simulateGpsCheck();
  }

  void _simulateGpsCheck() async {
    await Future.delayed(const Duration(milliseconds: 600));
    if (mounted) {
      setState(() {
        _isLocating = false;
        _geofencePassed = true; // within 100m geofence radius
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AlertDialog(
      backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.md),
      contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
      titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: (widget.isClockingIn ? const Color(0xFF10B981) : const Color(0xFFEF4444)).withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              widget.isClockingIn ? Icons.login_rounded : Icons.logout_rounded,
              size: 20,
              color: widget.isClockingIn ? const Color(0xFF10B981) : const Color(0xFFEF4444),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            widget.isClockingIn ? 'Punch In Verification' : 'Punch Out Confirmation',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            ),
          ),
        ],
      ),
      content: SizedBox(
        width: 440,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.isClockingIn
                  ? 'Verify your geofenced GPS location and confirm biometric selfie before clocking in.'
                  : 'End your working shift and record final punch timestamp.',
              style: GoogleFonts.inter(
                fontSize: 12,
                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              ),
            ),
            const SizedBox(height: 16),

            // Step 1: GPS Geofence Check
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurfaceSubtle : const Color(0xFFF8FAFC),
                borderRadius: AppRadius.sm,
                border: Border.all(
                  color: _geofencePassed
                      ? const Color(0xFF10B981).withValues(alpha: 0.5)
                      : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                ),
              ),
              child: Row(
                children: [
                  if (_isLocating)
                    const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  else
                    Icon(
                      _geofencePassed ? Icons.check_circle_rounded : Icons.error_rounded,
                      size: 18,
                      color: _geofencePassed ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                    ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Geofence Telemetry',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _isLocating
                              ? 'Acquiring high-precision GPS coordinates...'
                              : 'Verified at HQ Hub ($_distanceFromCenter m from center point)',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Step 2: Biometric / Selfie Hook
            if (widget.isClockingIn)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurfaceSubtle : const Color(0xFFF8FAFC),
                  borderRadius: AppRadius.sm,
                  border: Border.all(
                    color: _selfieCaptured
                        ? const Color(0xFF10B981).withValues(alpha: 0.5)
                        : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      _selfieCaptured ? Icons.check_circle_rounded : Icons.camera_alt_outlined,
                      size: 18,
                      color: _selfieCaptured ? const Color(0xFF10B981) : const Color(0xFF64748B),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Selfie Verification',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _selfieCaptured
                                ? 'Selfie captured and verified with AI facial check.'
                                : 'Take a real-time selfie to verify presence.',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    TextButton(
                      onPressed: () {
                        setState(() => _selfieCaptured = true);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Biometric selfie verified successfully',
                              style: GoogleFonts.inter(fontSize: 12),
                            ),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                      child: Text(
                        _selfieCaptured ? 'Retake' : 'Capture',
                        style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
      actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel', style: GoogleFonts.inter(fontSize: 12)),
        ),
        ElevatedButton.icon(
          onPressed: (_isLocating || (widget.isClockingIn && !_selfieCaptured))
              ? null
              : () {
                  widget.onPunchConfirmed();
                  Navigator.pop(context);
                },
          icon: Icon(
            widget.isClockingIn ? Icons.check_circle_outline : Icons.power_settings_new_rounded,
            size: 16,
          ),
          label: Text(
            widget.isClockingIn ? 'Confirm Clock In' : 'Confirm Clock Out',
            style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: widget.isClockingIn ? const Color(0xFF10B981) : const Color(0xFFEF4444),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
          ),
        ),
      ],
    );
  }
}
