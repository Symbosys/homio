import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_radius.dart';
import '../domain/hrms_enums.dart';

class HrmsStatusBadge extends StatelessWidget {
  final String label;
  final Color color;
  final IconData? icon;
  final bool isOutline;

  const HrmsStatusBadge({
    super.key,
    required this.label,
    required this.color,
    this.icon,
    this.isOutline = false,
  });

  factory HrmsStatusBadge.employee(EmployeeStatus status) {
    return HrmsStatusBadge(
      label: status.label,
      color: status.color,
      icon: status.icon,
    );
  }

  factory HrmsStatusBadge.attendance(AttendanceStatus status) {
    return HrmsStatusBadge(
      label: status.label,
      color: status.color,
    );
  }

  factory HrmsStatusBadge.geofence(GeofenceStatus status) {
    return HrmsStatusBadge(
      label: status.label,
      color: status.color,
    );
  }

  factory HrmsStatusBadge.leave(LeaveType type) {
    return HrmsStatusBadge(
      label: type.label,
      color: type.color,
    );
  }

  factory HrmsStatusBadge.approval(ApprovalStatus status) {
    return HrmsStatusBadge(
      label: status.label,
      color: status.color,
    );
  }

  factory HrmsStatusBadge.payroll(PayrollStatus status) {
    return HrmsStatusBadge(
      label: status.label,
      color: status.color,
    );
  }

  factory HrmsStatusBadge.clearance(ClearanceStatus status) {
    return HrmsStatusBadge(
      label: status.label,
      color: status.color,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isOutline ? Colors.transparent : color.withValues(alpha: isDark ? 0.18 : 0.12),
        borderRadius: AppRadius.full,
        border: Border.all(
          color: color.withValues(alpha: isDark ? 0.35 : 0.25),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: color),
            const SizedBox(width: 4),
          ] else ...[
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 5),
          ],
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
