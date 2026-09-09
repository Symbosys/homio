// Homio CRM — Universal Status Badge for Communication

import 'package:flutter/material.dart';
import '../models/communication_models.dart';

class CommStatusBadge extends StatelessWidget {
  final String label;
  final Color color;
  final IconData? icon;
  final bool isPill;

  const CommStatusBadge({
    super.key,
    required this.label,
    required this.color,
    this.icon,
    this.isPill = true,
  });

  factory CommStatusBadge.fromConversationStatus(ConversationStatus status) {
    return CommStatusBadge(
      label: status.label,
      color: status.color,
    );
  }

  factory CommStatusBadge.fromPriority(ConversationPriority priority) {
    return CommStatusBadge(
      label: priority.label,
      color: priority.color,
      icon: priority == ConversationPriority.urgent ? Icons.priority_high : null,
    );
  }

  factory CommStatusBadge.fromMessageStatus(MessageStatus status) {
    return CommStatusBadge(
      label: status.label,
      color: status.color,
      icon: status.icon,
    );
  }

  factory CommStatusBadge.fromBroadcastStatus(BroadcastStatus status) {
    return CommStatusBadge(
      label: status.label,
      color: status.color,
    );
  }

  factory CommStatusBadge.fromTemplateStatus(TemplateStatus status) {
    return CommStatusBadge(
      label: status.label,
      color: status.color,
    );
  }

  factory CommStatusBadge.fromDripStatus(DripCampaignStatus status) {
    return CommStatusBadge(
      label: status.label,
      color: status.color,
    );
  }

  factory CommStatusBadge.fromScheduledStatus(ScheduledMessageStatus status) {
    return CommStatusBadge(
      label: status.label,
      color: status.color,
    );
  }

  factory CommStatusBadge.fromCrmStage(CustomerCrmStage stage) {
    return CommStatusBadge(
      label: stage.label,
      color: stage.color,
    );
  }

  factory CommStatusBadge.fromChannel(CommunicationChannel channel) {
    return CommStatusBadge(
      label: channel.label,
      color: channel.color,
      icon: channel.icon,
    );
  }

  factory CommStatusBadge.fromWhatsAppConnection(WhatsAppConnectionStatus status) {
    return CommStatusBadge(
      label: status.label,
      color: status.color,
      icon: status == WhatsAppConnectionStatus.connected ? Icons.check_circle : Icons.warning_amber_rounded,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(isPill ? 12 : 4),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 0.8,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 11,
              color: color,
            ),
            const SizedBox(width: 4),
          ] else ...[
            Container(
              width: 5,
              height: 5,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
              letterSpacing: 0.1,
            ),
          ),
        ],
      ),
    );
  }
}
