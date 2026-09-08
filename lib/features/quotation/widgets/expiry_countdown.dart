import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';

/// Live countdown timer component showing remaining duration with visual urgency states.
class ExpiryCountdown extends StatefulWidget {
  final DateTime expiryDate;
  final bool isCompact;
  final VoidCallback? onExpired;

  const ExpiryCountdown({
    super.key,
    required this.expiryDate,
    this.isCompact = false,
    this.onExpired,
  });

  @override
  State<ExpiryCountdown> createState() => _ExpiryCountdownState();
}

class _ExpiryCountdownState extends State<ExpiryCountdown> {
  Timer? _timer;
  late Duration _remaining;

  @override
  void initState() {
    super.initState();
    _remaining = widget.expiryDate.difference(DateTime.now());
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        _remaining = widget.expiryDate.difference(DateTime.now());
        if (_remaining.isNegative && widget.onExpired != null) {
          widget.onExpired!();
          timer.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isExpired = _remaining.isNegative;

    Color urgencyColor;
    String statusText;

    if (isExpired) {
      urgencyColor = AppColors.error;
      statusText = 'Expired';
    } else if (_remaining.inHours < 24) {
      urgencyColor = const Color(0xFFEF4444); // Urgent red
      statusText = '${_remaining.inHours}h ${_remaining.inMinutes % 60}m remaining';
    } else if (_remaining.inDays <= 3) {
      urgencyColor = const Color(0xFFF59E0B); // Amber warning
      statusText = '${_remaining.inDays}d ${_remaining.inHours % 24}h remaining';
    } else {
      urgencyColor = AppColors.success; // Safe green
      statusText = '${_remaining.inDays} days remaining';
    }

    if (widget.isCompact) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: urgencyColor.withValues(alpha: isDark ? 0.2 : 0.1),
          borderRadius: AppRadius.sm,
          border: Border.all(color: urgencyColor.withValues(alpha: 0.3), width: 0.8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.timer_outlined, size: 11, color: urgencyColor),
            const SizedBox(width: 4),
            Text(
              statusText,
              style: GoogleFonts.inter(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: urgencyColor,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: urgencyColor.withValues(alpha: isDark ? 0.15 : 0.08),
        borderRadius: AppRadius.md,
        border: Border.all(color: urgencyColor.withValues(alpha: 0.3), width: 0.8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isExpired ? Icons.timer_off_rounded : Icons.alarm_rounded,
            size: 14,
            color: urgencyColor,
          ),
          const SizedBox(width: 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'DISCOUNT VALIDITY',
                style: GoogleFonts.inter(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  color: urgencyColor,
                  letterSpacing: 0.5,
                ),
              ),
              Text(
                statusText,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: urgencyColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
