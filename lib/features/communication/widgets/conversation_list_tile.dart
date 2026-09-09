// Homio CRM — Enterprise Conversation List Tile

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../models/communication_models.dart';
import 'comm_status_badge.dart';

class ConversationListTile extends StatelessWidget {
  final Conversation conversation;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback? onToggleStarred;

  const ConversationListTile({
    super.key,
    required this.conversation,
    required this.isSelected,
    required this.onTap,
    this.onToggleStarred,
  });

  String _formatSnippetTime(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);

    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    if (diff.inHours < 24) return '${diff.inHours}h';
    if (diff.inDays < 7) return '${diff.inDays}d';
    return '${dt.day}/${dt.month}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final ctx = conversation.customerContext;

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: isDark ? 0.16 : 0.08)
              : (isDark ? AppColors.darkSurface : AppColors.lightSurface),
          border: Border(
            left: BorderSide(
              color: isSelected ? AppColors.primary : Colors.transparent,
              width: 3.5,
            ),
            bottom: BorderSide(
              color: isDark ? AppColors.darkBorder.withValues(alpha: 0.6) : AppColors.lightBorder.withValues(alpha: 0.6),
              width: 0.8,
            ),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar with channel icon badge
            Stack(
              clipBehavior: Clip.none,
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: AppColors.primary.withValues(alpha: 0.12),
                  child: Text(
                    ctx.customerName.substring(0, ctx.customerName.length >= 2 ? 2 : 1).toUpperCase(),
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                Positioned(
                  bottom: -2,
                  right: -2,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkSurface : Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      conversation.channel.icon,
                      size: 12,
                      color: conversation.channel.color,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),

            // Middle Column: Name, last message snippet, stage
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          ctx.customerName,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: conversation.unreadCount > 0 ? FontWeight.w700 : FontWeight.w600,
                            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (conversation.priority == ConversationPriority.urgent) ...[
                        const SizedBox(width: 4),
                        const Icon(Icons.error_outline, size: 13, color: Color(0xFFEF4444)),
                      ],
                      const SizedBox(width: 6),
                      Text(
                        _formatSnippetTime(conversation.lastMessageTime),
                        style: TextStyle(
                          fontSize: 10,
                          color: conversation.unreadCount > 0
                              ? AppColors.primary
                              : (isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                          fontWeight: conversation.unreadCount > 0 ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    conversation.lastMessage,
                    style: TextStyle(
                      fontSize: 12,
                      height: 1.25,
                      fontWeight: conversation.unreadCount > 0 ? FontWeight.w600 : FontWeight.normal,
                      color: conversation.unreadCount > 0
                          ? (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)
                          : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      CommStatusBadge.fromCrmStage(ctx.crmStage),
                      const Spacer(),
                      if (conversation.unreadCount > 0)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '${conversation.unreadCount}',
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      if (onToggleStarred != null) ...[
                        const SizedBox(width: 4),
                        InkWell(
                          onTap: onToggleStarred,
                          child: Icon(
                            conversation.isStarred ? Icons.star : Icons.star_border,
                            size: 16,
                            color: conversation.isStarred ? const Color(0xFFF59E0B) : (isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
