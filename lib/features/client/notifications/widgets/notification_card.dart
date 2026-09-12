import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../models/notification_models.dart';

/// Card presenting a customer notification item
class NotificationCard extends StatelessWidget {
  final CustomerNotificationItem item;
  final VoidCallback onMarkAsRead;
  final VoidCallback onDelete;

  const NotificationCard({
    super.key,
    required this.item,
    required this.onMarkAsRead,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: !item.isRead
            ? (isDark
                ? item.iconColor.withValues(alpha: 0.08)
                : item.iconColor.withValues(alpha: 0.04))
            : (isDark ? AppColors.darkCard : Colors.white),
        borderRadius: AppRadius.lg,
        border: Border.all(
          color: !item.isRead
              ? item.iconColor.withValues(alpha: 0.35)
              : (isDark ? AppColors.darkBorder : Colors.grey.shade200),
          width: !item.isRead ? 1.5 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: Category + Unread Dot + Timestamp
            Row(
              children: [
                // Unread dot
                if (!item.isRead) ...[
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: item.iconColor,
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
                // Category badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                  decoration: BoxDecoration(
                    color: item.iconColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    item.category.label.toUpperCase(),
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                      color: item.iconColor,
                    ),
                  ),
                ),
                if (item.isUrgent) ...[
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEF4444).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'ACTION REQUIRED',
                      style: GoogleFonts.inter(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFFEF4444),
                      ),
                    ),
                  ),
                ],
                const Spacer(),
                Text(
                  item.timestamp,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Content Row: Icon + Title & Description
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: item.iconColor.withValues(alpha: 0.12),
                  ),
                  child: Icon(item.icon, size: 20, color: item.iconColor),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: !item.isRead ? FontWeight.w800 : FontWeight.w600,
                          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.description,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          height: 1.4,
                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Bottom Actions: [Contextual Action] + Mark as Read / Dismiss
            Row(
              children: [
                if (!item.isRead)
                  TextButton.icon(
                    onPressed: onMarkAsRead,
                    icon: const Icon(Icons.done_rounded, size: 15),
                    label: Text(
                      'Mark as read',
                      style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600),
                    ),
                    style: TextButton.styleFrom(
                      foregroundColor: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    ),
                  ),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: () {
                    onMarkAsRead();
                    context.go(item.routePath);
                  },
                  icon: const Icon(Icons.arrow_forward_rounded, size: 14),
                  label: Text(
                    item.actionLabel,
                    style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: item.iconColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: AppRadius.md),
                    elevation: 0,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
