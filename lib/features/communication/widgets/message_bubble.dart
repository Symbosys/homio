// Homio CRM — Enterprise Chat Message Bubble

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../models/communication_models.dart';

class MessageBubble extends StatelessWidget {
  final ChatMessage message;
  final VoidCallback? onRetry;
  final ValueChanged<String>? onButtonClicked;

  const MessageBubble({
    super.key,
    required this.message,
    this.onRetry,
    this.onButtonClicked,
  });

  String _formatTime(DateTime dt) {
    final hour = dt.hour.toString().padLeft(2, '0');
    final minute = dt.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final isOutgoing = message.direction == MessageDirection.outgoing;
    final isInternal = message.isInternalNote || message.direction == MessageDirection.internal;

    if (isInternal) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFFEF3C7).withValues(alpha: isDark ? 0.15 : 0.8),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: const Color(0xFFF59E0B).withValues(alpha: 0.5),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.lock, size: 13, color: Color(0xFFD97706)),
                const SizedBox(width: 6),
                Text(
                  'INTERNAL NOTE • ${message.senderName} (${message.senderRole ?? "Team"})',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFD97706),
                  ),
                ),
                const Spacer(),
                Text(
                  _formatTime(message.timestamp),
                  style: TextStyle(
                    fontSize: 10,
                    color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              message.content,
              style: TextStyle(
                fontSize: 13,
                color: isDark ? AppColors.darkTextPrimary : const Color(0xFF78350F),
              ),
            ),
          ],
        ),
      );
    }

    return Align(
      alignment: isOutgoing ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: (MediaQuery.of(context).size.width * 0.65).clamp(280.0, 520.0),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isOutgoing
              ? (isDark ? const Color(0xFF1E3A8A).withValues(alpha: 0.5) : const Color(0xFFEFF6FF))
              : (isDark ? AppColors.darkSurface : AppColors.lightSurface),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(12),
            topRight: const Radius.circular(12),
            bottomLeft: Radius.circular(isOutgoing ? 12 : 2),
            bottomRight: Radius.circular(isOutgoing ? 2 : 12),
          ),
          border: Border.all(
            color: isOutgoing
                ? (isDark ? const Color(0xFF3B82F6).withValues(alpha: 0.4) : const Color(0xFFBFDBFE))
                : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: isOutgoing ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            // Sender name & role for incoming messages or team replies
            if (!isOutgoing) ...[
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    message.senderName,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  if (message.senderRole != null) ...[
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        message.senderRole!,
                        style: const TextStyle(fontSize: 9, color: AppColors.primary),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 4),
            ],

            // Message Attachments Preview
            if (message.attachments.isNotEmpty) ...[
              ...message.attachments.map((att) {
                final isImg = att.fileType.contains('image');
                if (isImg) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                      ),
                    ),
                    child: Image.network(
                      att.url,
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 120,
                        color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
                        child: const Center(
                          child: Icon(Icons.broken_image, color: Colors.grey),
                        ),
                      ),
                    ),
                  );
                }

                // Document / PDF preview
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkBackground : Colors.white,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.picture_as_pdf, color: Color(0xFFEF4444), size: 28),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              att.fileName,
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              att.formattedSize,
                              style: TextStyle(
                                fontSize: 10,
                                color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.download_for_offline_outlined, size: 18),
                        onPressed: () {},
                      ),
                    ],
                  ),
                );
              }),
            ],

            // Content text
            if (message.content.isNotEmpty)
              Text(
                message.content,
                style: TextStyle(
                  fontSize: 13,
                  height: 1.35,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                ),
              ),

            // CTA Buttons if template has actions
            if (message.ctaButtons != null && message.ctaButtons!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: message.ctaButtons!.map((btn) {
                  return ActionChip(
                    label: Text(
                      btn.title,
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                    ),
                    avatar: Icon(
                      btn.type == 'payment'
                          ? Icons.currency_rupee
                          : (btn.type == 'meeting' ? Icons.calendar_today : Icons.open_in_new),
                      size: 13,
                    ),
                    onPressed: () => onButtonClicked?.call(btn.title),
                  );
                }).toList(),
              ),
            ],

            const SizedBox(height: 4),

            // Timestamp + Status ticks
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _formatTime(message.timestamp),
                  style: TextStyle(
                    fontSize: 10,
                    color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                  ),
                ),
                if (isOutgoing) ...[
                  const SizedBox(width: 4),
                  Icon(
                    message.status.icon,
                    size: 13,
                    color: message.status.color,
                  ),
                ],
                if (message.status == MessageStatus.failed && onRetry != null) ...[
                  const SizedBox(width: 6),
                  InkWell(
                    onTap: onRetry,
                    child: const Text(
                      'Retry',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFEF4444),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
