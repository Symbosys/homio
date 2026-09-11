import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../models/organization_models.dart';

class OrgStatusBadge extends StatelessWidget {
  final String label;
  final Color color;
  final Color backgroundColor;
  final IconData? icon;

  const OrgStatusBadge({
    super.key,
    required this.label,
    required this.color,
    required this.backgroundColor,
    this.icon,
  });

  factory OrgStatusBadge.forOrgStatus(OrgStatus status, bool isDark) {
    switch (status) {
      case OrgStatus.active:
        return OrgStatusBadge(
          label: 'Active',
          color: isDark ? const Color(0xFF34D399) : const Color(0xFF059669),
          backgroundColor: isDark ? const Color(0xFF064E3B).withValues(alpha: 0.3) : const Color(0xFFD1FAE5),
          icon: Icons.check_circle_outline_rounded,
        );
      case OrgStatus.inactive:
        return OrgStatusBadge(
          label: 'Inactive',
          color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
          backgroundColor: isDark ? const Color(0xFF334155).withValues(alpha: 0.3) : const Color(0xFFF1F5F9),
          icon: Icons.pause_circle_outline_rounded,
        );
      case OrgStatus.archived:
        return OrgStatusBadge(
          label: 'Archived',
          color: isDark ? const Color(0xFFFBBF24) : const Color(0xFFD97706),
          backgroundColor: isDark ? const Color(0xFF78350F).withValues(alpha: 0.3) : const Color(0xFFFEF3C7),
          icon: Icons.archive_outlined,
        );
    }
  }

  factory OrgStatusBadge.forAccountStatus(AccountStatus status, bool isDark) {
    switch (status) {
      case AccountStatus.active:
        return OrgStatusBadge(
          label: 'Active',
          color: isDark ? const Color(0xFF34D399) : const Color(0xFF059669),
          backgroundColor: isDark ? const Color(0xFF064E3B).withValues(alpha: 0.3) : const Color(0xFFD1FAE5),
          icon: Icons.verified_user_outlined,
        );
      case AccountStatus.invited:
        return OrgStatusBadge(
          label: 'Invited',
          color: isDark ? const Color(0xFF60A5FA) : const Color(0xFF2563EB),
          backgroundColor: isDark ? const Color(0xFF1E3A8A).withValues(alpha: 0.3) : const Color(0xFFDBEAFE),
          icon: Icons.mail_outline_rounded,
        );
      case AccountStatus.pendingActivation:
        return OrgStatusBadge(
          label: 'Pending',
          color: isDark ? const Color(0xFFFBBF24) : const Color(0xFFD97706),
          backgroundColor: isDark ? const Color(0xFF78350F).withValues(alpha: 0.3) : const Color(0xFFFEF3C7),
          icon: Icons.hourglass_top_rounded,
        );
      case AccountStatus.suspended:
        return OrgStatusBadge(
          label: 'Suspended',
          color: isDark ? const Color(0xFFF87171) : const Color(0xFFDC2626),
          backgroundColor: isDark ? const Color(0xFF7F1D1D).withValues(alpha: 0.3) : const Color(0xFFFEE2E2),
          icon: Icons.block_rounded,
        );
      case AccountStatus.deactivated:
        return OrgStatusBadge(
          label: 'Deactivated',
          color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
          backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
          icon: Icons.person_off_outlined,
        );
    }
  }

  factory OrgStatusBadge.forRoleType(RoleType type, bool isDark) {
    if (type == RoleType.system) {
      return OrgStatusBadge(
        label: 'System Role',
        color: isDark ? const Color(0xFFA78BFA) : const Color(0xFF7C3AED),
        backgroundColor: isDark ? const Color(0xFF4C1D95).withValues(alpha: 0.3) : const Color(0xFFEDE9FE),
        icon: Icons.lock_outline_rounded,
      );
    } else {
      return OrgStatusBadge(
        label: 'Custom Role',
        color: isDark ? const Color(0xFF38BDF8) : const Color(0xFF0284C7),
        backgroundColor: isDark ? const Color(0xFF0C4A6E).withValues(alpha: 0.3) : const Color(0xFFE0F2FE),
        icon: Icons.tune_rounded,
      );
    }
  }

  factory OrgStatusBadge.forScope(AccessScopeLevel level, bool isDark) {
    switch (level) {
      case AccessScopeLevel.organization:
        return OrgStatusBadge(
          label: 'Global (All)',
          color: isDark ? const Color(0xFFA78BFA) : const Color(0xFF7C3AED),
          backgroundColor: isDark ? const Color(0xFF4C1D95).withValues(alpha: 0.3) : const Color(0xFFEDE9FE),
          icon: Icons.public_rounded,
        );
      case AccessScopeLevel.department:
        return OrgStatusBadge(
          label: 'Department',
          color: isDark ? const Color(0xFF60A5FA) : const Color(0xFF2563EB),
          backgroundColor: isDark ? const Color(0xFF1E3A8A).withValues(alpha: 0.3) : const Color(0xFFDBEAFE),
          icon: Icons.apartment_rounded,
        );
      case AccessScopeLevel.ownTeam:
        return OrgStatusBadge(
          label: 'Own Team',
          color: isDark ? const Color(0xFF34D399) : const Color(0xFF059669),
          backgroundColor: isDark ? const Color(0xFF064E3B).withValues(alpha: 0.3) : const Color(0xFFD1FAE5),
          icon: Icons.groups_rounded,
        );
      case AccessScopeLevel.ownRecords:
      case AccessScopeLevel.assignedRecords:
        return OrgStatusBadge(
          label: 'Isolated',
          color: isDark ? const Color(0xFFFBBF24) : const Color(0xFFD97706),
          backgroundColor: isDark ? const Color(0xFF78350F).withValues(alpha: 0.3) : const Color(0xFFFEF3C7),
          icon: Icons.lock_person_rounded,
        );
      default:
        return OrgStatusBadge(
          label: level.displayName,
          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
          backgroundColor: isDark ? const Color(0xFF334155).withValues(alpha: 0.3) : const Color(0xFFF1F5F9),
          icon: Icons.shield_outlined,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: color),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}
