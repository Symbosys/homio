import 'package:flutter/material.dart';

enum CampaignStatus {
  scheduled(label: 'Scheduled', color: Color(0xFF3B82F6), icon: Icons.schedule_rounded),
  sending(label: 'Sending', color: Color(0xFFF59E0B), icon: Icons.sync_rounded),
  sent(label: 'Completed', color: Color(0xFF10B981), icon: Icons.check_circle_rounded),
  draft(label: 'Draft', color: Color(0xFF64748B), icon: Icons.edit_note_rounded),
  cancelled(label: 'Cancelled', color: Color(0xFFEF4444), icon: Icons.cancel_rounded);

  final String label;
  final Color color;
  final IconData icon;

  const CampaignStatus({
    required this.label,
    required this.color,
    required this.icon,
  });
}

enum BroadcastChannel {
  whatsapp(label: 'WhatsApp Cloud API', icon: Icons.chat_rounded, color: Color(0xFF25D366)),
  sms(label: 'Transactional SMS', icon: Icons.sms_rounded, color: Color(0xFF3B82F6)),
  omnichannel(label: 'Omnichannel (WA + SMS)', icon: Icons.hub_rounded, color: Color(0xFF8B5CF6));

  final String label;
  final IconData icon;
  final Color color;

  const BroadcastChannel({
    required this.label,
    required this.icon,
    required this.color,
  });
}

class BroadcastCampaign {
  final String id;
  String name;
  String templateName;
  String messageBody;
  String audienceSegment;
  int recipientCount;
  BroadcastChannel channel;
  CampaignStatus status;
  DateTime? scheduledAt;
  DateTime? sentAt;
  int deliveredCount;
  int readCount;
  int repliedCount;
  int failedCount;
  String? headerImageUrl;
  List<String> dynamicVariables;
  List<String> tags;

  BroadcastCampaign({
    required this.id,
    required this.name,
    required this.templateName,
    required this.messageBody,
    required this.audienceSegment,
    required this.recipientCount,
    this.channel = BroadcastChannel.whatsapp,
    required this.status,
    this.scheduledAt,
    this.sentAt,
    this.deliveredCount = 0,
    this.readCount = 0,
    this.repliedCount = 0,
    this.failedCount = 0,
    this.headerImageUrl,
    this.dynamicVariables = const [],
    this.tags = const [],
  });

  double get deliveryRate => recipientCount > 0 ? (deliveredCount / recipientCount) * 100 : 0.0;
  double get readRate => deliveredCount > 0 ? (readCount / deliveredCount) * 100 : 0.0;
  double get replyRate => readCount > 0 ? (repliedCount / readCount) * 100 : 0.0;
}

class WhatsAppTemplateOption {
  final String id;
  final String name;
  final String category; // MARKETING, UTILITY, AUTHENTICATION
  final String language;
  final String bodyText;
  final List<String> placeholders;
  final bool hasHeaderImage;

  const WhatsAppTemplateOption({
    required this.id,
    required this.name,
    required this.category,
    this.language = 'en_IN',
    required this.bodyText,
    required this.placeholders,
    this.hasHeaderImage = false,
  });
}
