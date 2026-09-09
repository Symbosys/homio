// Homio CRM — Enterprise Communication Domain Models
// Complete domain entities, enums, and data contracts for communication workflows.

import 'package:flutter/material.dart';

/// Supported communication channels
enum CommunicationChannel {
  whatsapp('WhatsApp', Icons.chat_outlined, Color(0xFF25D366)),
  sms('SMS', Icons.textsms_outlined, Color(0xFF3B82F6)),
  email('Email', Icons.email_outlined, Color(0xFF8B5CF6));

  final String label;
  final IconData icon;
  final Color color;

  const CommunicationChannel(this.label, this.icon, this.color);
}

/// Status of customer conversation thread
enum ConversationStatus {
  open('Open', Color(0xFF10B981)),
  pending('Pending', Color(0xFFF59E0B)),
  resolved('Resolved', Color(0xFF6B7280)),
  archived('Archived', Color(0xFF9CA3AF));

  final String label;
  final Color color;

  const ConversationStatus(this.label, this.color);
}

/// Priority of customer conversation
enum ConversationPriority {
  low('Low', Color(0xFF94A3B8)),
  normal('Normal', Color(0xFF3B82F6)),
  high('High', Color(0xFFF97316)),
  urgent('Urgent', Color(0xFFEF4444));

  final String label;
  final Color color;

  const ConversationPriority(this.label, this.color);
}

/// Flow direction of message
enum MessageDirection {
  incoming('Incoming'),
  outgoing('Outgoing'),
  internal('Internal Note');

  final String label;
  const MessageDirection(this.label);
}

/// Delivery status progression of a message
enum MessageStatus {
  draft('Draft', Icons.edit_note, Color(0xFF94A3B8)),
  queued('Queued', Icons.hourglass_top, Color(0xFFCBD5E1)),
  sending('Sending', Icons.sync, Color(0xFF60A5FA)),
  sent('Sent', Icons.check, Color(0xFF93C5FD)),
  delivered('Delivered', Icons.done_all, Color(0xFF94A3B8)),
  read('Read', Icons.done_all, Color(0xFF2563EB)),
  failed('Failed', Icons.error_outline, Color(0xFFEF4444));

  final String label;
  final IconData icon;
  final Color color;

  const MessageStatus(this.label, this.icon, this.color);
}

/// Content payload format
enum MessageContentType {
  text('Text', Icons.text_snippet_outlined),
  image('Image', Icons.image_outlined),
  video('Video', Icons.videocam_outlined),
  document('Document', Icons.description_outlined),
  audio('Audio', Icons.audiotrack_outlined),
  voiceNote('Voice Note', Icons.mic_outlined),
  link('Link', Icons.link_outlined),
  template('Template', Icons.dynamic_form_outlined),
  paymentLink('Payment Link', Icons.currency_rupee_outlined),
  meetingLink('Meeting Invite', Icons.event_outlined),
  location('Location', Icons.location_on_outlined);

  final String label;
  final IconData icon;

  const MessageContentType(this.label, this.icon);
}

/// CRM Stage associated with the contact
enum CustomerCrmStage {
  newLead('New Lead', Color(0xFF3B82F6)),
  qualified('Qualified Lead', Color(0xFF6366F1)),
  meetingScheduled('Meeting Scheduled', Color(0xFF8B5CF6)),
  meetingCompleted('Meeting Completed', Color(0xFFA855F7)),
  booked('Booked / Signed', Color(0xFFEC4899)),
  activeProject('Active Project', Color(0xFFF59E0B)),
  execution('Execution Phase', Color(0xFFEAB308)),
  payment('Payment Milestone', Color(0xFF10B981)),
  afterSales('After-Sales Care', Color(0xFF14B8A6));

  final String label;
  final Color color;

  const CustomerCrmStage(this.label, this.color);
}

/// Broadcast campaign status
enum BroadcastStatus {
  draft('Draft', Color(0xFF94A3B8)),
  scheduled('Scheduled', Color(0xFF3B82F6)),
  queued('Queued', Color(0xFF8B5CF6)),
  processing('Processing', Color(0xFFF59E0B)),
  sending('Sending', Color(0xFFEAB308)),
  completed('Completed', Color(0xFF10B981)),
  paused('Paused', Color(0xFF64748B)),
  cancelled('Cancelled', Color(0xFFEF4444)),
  failed('Failed', Color(0xFFDC2626));

  final String label;
  final Color color;

  const BroadcastStatus(this.label, this.color);
}

/// WhatsApp/SMS template approval status
enum TemplateStatus {
  draft('Draft', Color(0xFF94A3B8)),
  pendingApproval('Pending Approval', Color(0xFFF59E0B)),
  approved('Approved', Color(0xFF10B981)),
  rejected('Rejected', Color(0xFFEF4444)),
  disabled('Disabled', Color(0xFF64748B)),
  archived('Archived', Color(0xFF9CA3AF));

  final String label;
  final Color color;

  const TemplateStatus(this.label, this.color);
}

/// Categorization of message templates
enum TemplateCategory {
  leadWelcome('Lead Welcome'),
  leadQualification('Lead Qualification'),
  meetingConfirmation('Meeting Confirmation'),
  meetingReminder('Meeting Reminder'),
  siteProgressUpdate('Site Progress Update'),
  paymentReminder('Payment Milestone Reminder'),
  quotationShared('Quotation Shared'),
  afterSalesService('After-Sales Service'),
  festiveGreeting('Festive & Relationship'),
  generalAnnouncement('General Announcement');

  final String label;
  const TemplateCategory(this.label);
}

/// Drip automation workflow status
enum DripCampaignStatus {
  draft('Draft', Color(0xFF94A3B8)),
  active('Active', Color(0xFF10B981)),
  paused('Paused', Color(0xFFF59E0B)),
  completed('Completed', Color(0xFF6366F1)),
  archived('Archived', Color(0xFF64748B)),
  error('Error Alert', Color(0xFFEF4444));

  final String label;
  final Color color;

  const DripCampaignStatus(this.label, this.color);
}

/// Types of nodes inside drip campaign visual canvas
enum DripNodeType {
  sendWhatsApp('Send WhatsApp', Icons.chat, Color(0xFF25D366)),
  sendTemplate('Send Template', Icons.dynamic_form, Color(0xFF10B981)),
  sendSms('Send SMS', Icons.textsms, Color(0xFF3B82F6)),
  sendEmail('Send Email', Icons.email, Color(0xFF8B5CF6)),
  sendPaymentLink('Send Payment Link', Icons.currency_rupee, Color(0xFFF59E0B)),
  waitDuration('Wait Time', Icons.hourglass_bottom, Color(0xFF64748B)),
  waitUntilDate('Wait Until Date', Icons.event_available, Color(0xFF475569)),
  conditionCheck('Condition Check', Icons.help_outline, Color(0xFFEC4899)),
  branchIfElse('If / Else Branch', Icons.alt_route, Color(0xFFA855F7)),
  assignEmployee('Assign Agent', Icons.person_add_alt_1, Color(0xFF06B6D4)),
  addTag('Add Tag', Icons.label_outline, Color(0xFF0284C7)),
  createTask('Create CRM Task', Icons.task_alt, Color(0xFFD97706)),
  endWorkflow('End Campaign', Icons.stop_circle_outlined, Color(0xFFEF4444));

  final String label;
  final IconData icon;
  final Color color;

  const DripNodeType(this.label, this.icon, this.color);
}

/// Triggers for initiating automation sequences
enum DripTriggerType {
  leadCreated('New Lead Captured'),
  leadStageChanged('Lead Stage Transition'),
  meetingScheduled('Meeting Scheduled'),
  meetingCompleted('Design Consultation Completed'),
  quotationSent('Quotation Shared With Client'),
  bookingCompleted('Token Booking Confirmed'),
  paymentDue('Milestone Payment Due'),
  siteMilestoneReached('Site Milestone Completed'),
  inactiveCustomer('Inactivity for 7+ Days');

  final String label;
  const DripTriggerType(this.label);
}

/// Status of individual scheduled messages
enum ScheduledMessageStatus {
  scheduled('Scheduled', Color(0xFF3B82F6)),
  processing('Processing', Color(0xFFF59E0B)),
  sent('Sent', Color(0xFF10B981)),
  failed('Failed', Color(0xFFEF4444)),
  cancelled('Cancelled', Color(0xFF64748B));

  final String label;
  final Color color;

  const ScheduledMessageStatus(this.label, this.color);
}

/// Cloud WhatsApp API connection state
enum WhatsAppConnectionStatus {
  connected('Connected & Active', Color(0xFF10B981)),
  connecting('Establishing Handshake', Color(0xFFF59E0B)),
  disconnected('Disconnected', Color(0xFF64748B)),
  authRequired('Meta Auth Token Expired', Color(0xFFEF4444)),
  configError('Webhook Misconfigured', Color(0xFFF97316)),
  serviceError('Meta Cloud Outage', Color(0xFFDC2626));

  final String label;
  final Color color;

  const WhatsAppConnectionStatus(this.label, this.color);
}

/// Message Attachment Model
class MessageAttachment {
  final String id;
  final String fileName;
  final String fileType; // pdf, jpg, png, mp4, etc.
  final int fileSize; // in bytes
  final String url;
  final String? thumbnailUrl;
  final int? durationSeconds;

  const MessageAttachment({
    required this.id,
    required this.fileName,
    required this.fileType,
    required this.fileSize,
    required this.url,
    this.thumbnailUrl,
    this.durationSeconds,
  });

  String get formattedSize {
    if (fileSize < 1024) return '$fileSize B';
    if (fileSize < 1024 * 1024) return '${(fileSize / 1024).toStringAsFixed(1)} KB';
    return '${(fileSize / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}

/// Interactive CTA button on WhatsApp templates
class TemplateButton {
  final String id;
  final String title;
  final String type; // quickReply, url, call, payment, meeting
  final String? payload;
  final String? url;

  const TemplateButton({
    required this.id,
    required this.title,
    required this.type,
    this.payload,
    this.url,
  });
}

/// Template dynamic variable definition
class TemplateVariable {
  final String key;
  final String label;
  final String defaultValue;
  final String sourceField;
  final String sampleValue;
  final bool isRequired;

  const TemplateVariable({
    required this.key,
    required this.label,
    required this.defaultValue,
    required this.sourceField,
    required this.sampleValue,
    this.isRequired = true,
  });
}

/// Single Message Item
class ChatMessage {
  final String id;
  final String conversationId;
  final MessageDirection direction;
  final String senderName;
  final String? senderAvatar;
  final String? senderRole; // e.g., Senior Architect, Client, Bot
  final String content;
  final MessageContentType contentType;
  final MessageStatus status;
  final DateTime timestamp;
  final DateTime? deliveredAt;
  final DateTime? readAt;
  final List<MessageAttachment> attachments;
  final String? templateName;
  final Map<String, String>? templateVariables;
  final String? campaignId;
  final bool isInternalNote;
  final String? replyToMessageId;
  final String? failureReason;
  final List<TemplateButton>? ctaButtons;

  const ChatMessage({
    required this.id,
    required this.conversationId,
    required this.direction,
    required this.senderName,
    this.senderAvatar,
    this.senderRole,
    required this.content,
    this.contentType = MessageContentType.text,
    this.status = MessageStatus.sent,
    required this.timestamp,
    this.deliveredAt,
    this.readAt,
    this.attachments = const [],
    this.templateName,
    this.templateVariables,
    this.campaignId,
    this.isInternalNote = false,
    this.replyToMessageId,
    this.failureReason,
    this.ctaButtons,
  });

  ChatMessage copyWith({
    String? id,
    String? conversationId,
    MessageDirection? direction,
    String? senderName,
    String? senderAvatar,
    String? senderRole,
    String? content,
    MessageContentType? contentType,
    MessageStatus? status,
    DateTime? timestamp,
    DateTime? deliveredAt,
    DateTime? readAt,
    List<MessageAttachment>? attachments,
    String? templateName,
    Map<String, String>? templateVariables,
    String? campaignId,
    bool? isInternalNote,
    String? replyToMessageId,
    String? failureReason,
    List<TemplateButton>? ctaButtons,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      conversationId: conversationId ?? this.conversationId,
      direction: direction ?? this.direction,
      senderName: senderName ?? this.senderName,
      senderAvatar: senderAvatar ?? this.senderAvatar,
      senderRole: senderRole ?? this.senderRole,
      content: content ?? this.content,
      contentType: contentType ?? this.contentType,
      status: status ?? this.status,
      timestamp: timestamp ?? this.timestamp,
      deliveredAt: deliveredAt ?? this.deliveredAt,
      readAt: readAt ?? this.readAt,
      attachments: attachments ?? this.attachments,
      templateName: templateName ?? this.templateName,
      templateVariables: templateVariables ?? this.templateVariables,
      campaignId: campaignId ?? this.campaignId,
      isInternalNote: isInternalNote ?? this.isInternalNote,
      replyToMessageId: replyToMessageId ?? this.replyToMessageId,
      failureReason: failureReason ?? this.failureReason,
      ctaButtons: ctaButtons ?? this.ctaButtons,
    );
  }
}

/// 360-degree CRM Context for Active Conversation
class CustomerContext {
  final String customerId;
  final String customerName;
  final String customerPhone;
  final String customerEmail;
  final String city;
  final String? avatarUrl;
  final CustomerCrmStage crmStage;
  final String? leadId;
  final String leadSource;
  final String budgetRange;
  final String propertyType; // 3BHK Villa, Penthouse, 2BHK Apartment
  final String assignedEmployeeName;
  final String assignedEmployeeId;
  final String? assignedDesignerName;
  final String? projectId;
  final String? projectName;
  final String? projectStatus;
  final double contractValue;
  final double totalInvoiced;
  final double totalPaid;
  final double balanceDue;
  final DateTime? nextMeetingDate;
  final String? nextMeetingType;
  final List<String> tags;
  final List<String> recentMilestones;

  const CustomerContext({
    required this.customerId,
    required this.customerName,
    required this.customerPhone,
    required this.customerEmail,
    required this.city,
    this.avatarUrl,
    required this.crmStage,
    this.leadId,
    this.leadSource = 'Direct Web',
    this.budgetRange = '₹25L - ₹35L',
    this.propertyType = '3BHK Apartment',
    required this.assignedEmployeeName,
    required this.assignedEmployeeId,
    this.assignedDesignerName,
    this.projectId,
    this.projectName,
    this.projectStatus,
    this.contractValue = 0.0,
    this.totalInvoiced = 0.0,
    this.totalPaid = 0.0,
    this.balanceDue = 0.0,
    this.nextMeetingDate,
    this.nextMeetingType,
    this.tags = const [],
    this.recentMilestones = const [],
  });
}

/// Conversation Thread Entity
class Conversation {
  final String id;
  final CustomerContext customerContext;
  final CommunicationChannel channel;
  final ConversationStatus status;
  final ConversationPriority priority;
  final String assignedEmployeeName;
  final String assignedEmployeeId;
  final List<String> tags;
  final bool isStarred;
  final int unreadCount;
  final String lastMessage;
  final DateTime lastMessageTime;
  final DateTime createdAt;
  final List<ChatMessage> messages;

  const Conversation({
    required this.id,
    required this.customerContext,
    this.channel = CommunicationChannel.whatsapp,
    this.status = ConversationStatus.open,
    this.priority = ConversationPriority.normal,
    required this.assignedEmployeeName,
    required this.assignedEmployeeId,
    this.tags = const [],
    this.isStarred = false,
    this.unreadCount = 0,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.createdAt,
    this.messages = const [],
  });

  Conversation copyWith({
    String? id,
    CustomerContext? customerContext,
    CommunicationChannel? channel,
    ConversationStatus? status,
    ConversationPriority? priority,
    String? assignedEmployeeName,
    String? assignedEmployeeId,
    List<String>? tags,
    bool? isStarred,
    int? unreadCount,
    String? lastMessage,
    DateTime? lastMessageTime,
    DateTime? createdAt,
    List<ChatMessage>? messages,
  }) {
    return Conversation(
      id: id ?? this.id,
      customerContext: customerContext ?? this.customerContext,
      channel: channel ?? this.channel,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      assignedEmployeeName: assignedEmployeeName ?? this.assignedEmployeeName,
      assignedEmployeeId: assignedEmployeeId ?? this.assignedEmployeeId,
      tags: tags ?? this.tags,
      isStarred: isStarred ?? this.isStarred,
      unreadCount: unreadCount ?? this.unreadCount,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      createdAt: createdAt ?? this.createdAt,
      messages: messages ?? this.messages,
    );
  }
}

/// Broadcast Campaign
class Broadcast {
  final String id;
  final String title;
  final CommunicationChannel channel;
  final String audienceFilter;
  final int targetCount;
  final int sentCount;
  final int deliveredCount;
  final int readCount;
  final int failedCount;
  final String templateId;
  final String templateName;
  final BroadcastStatus status;
  final DateTime scheduledAt;
  final DateTime? completedAt;
  final String createdBy;
  final String? mediaUrl;
  final String rawMessage;

  const Broadcast({
    required this.id,
    required this.title,
    this.channel = CommunicationChannel.whatsapp,
    required this.audienceFilter,
    required this.targetCount,
    this.sentCount = 0,
    this.deliveredCount = 0,
    this.readCount = 0,
    this.failedCount = 0,
    required this.templateId,
    required this.templateName,
    required this.status,
    required this.scheduledAt,
    this.completedAt,
    required this.createdBy,
    this.mediaUrl,
    required this.rawMessage,
  });

  double get deliveryRate => targetCount == 0 ? 0.0 : (deliveredCount / targetCount);
  double get readRate => deliveredCount == 0 ? 0.0 : (readCount / deliveredCount);
}

/// Bulk Message CSV/Excel Upload Job
class BulkMessageJob {
  final String id;
  final String title;
  final String fileName;
  final int totalRows;
  final int validRows;
  final int invalidRows;
  final int duplicateRows;
  final CommunicationChannel channel;
  final String templateId;
  final String status; // Pending, Processing, Completed, Cancelled
  final DateTime createdAt;
  final DateTime? scheduledAt;
  final int processedCount;
  final int successCount;
  final int failureCount;

  const BulkMessageJob({
    required this.id,
    required this.title,
    required this.fileName,
    required this.totalRows,
    required this.validRows,
    required this.invalidRows,
    required this.duplicateRows,
    this.channel = CommunicationChannel.whatsapp,
    required this.templateId,
    required this.status,
    required this.createdAt,
    this.scheduledAt,
    this.processedCount = 0,
    this.successCount = 0,
    this.failureCount = 0,
  });
}

/// Reusable Message Template
class MessageTemplate {
  final String id;
  final String name;
  final String code; // e.g. homio_lead_welcome_v2
  final TemplateCategory category;
  final CommunicationChannel channel;
  final String language; // en, hi, te, ta, kn
  final TemplateStatus status;
  final String headerType; // NONE, TEXT, IMAGE, VIDEO, DOCUMENT
  final String? headerText;
  final String? headerMediaUrl;
  final String bodyText;
  final String? footerText;
  final List<TemplateVariable> variables;
  final List<TemplateButton> buttons;
  final int usageCount;
  final DateTime lastUsedAt;
  final DateTime updatedAt;
  final String createdBy;

  const MessageTemplate({
    required this.id,
    required this.name,
    required this.code,
    required this.category,
    this.channel = CommunicationChannel.whatsapp,
    this.language = 'en',
    required this.status,
    this.headerType = 'NONE',
    this.headerText,
    this.headerMediaUrl,
    required this.bodyText,
    this.footerText,
    this.variables = const [],
    this.buttons = const [],
    this.usageCount = 0,
    required this.lastUsedAt,
    required this.updatedAt,
    required this.createdBy,
  });

  /// Generate sample rendered text replacing variables
  String get renderedSample {
    var result = bodyText;
    for (final v in variables) {
      result = result.replaceAll('{{${v.key}}}', v.sampleValue);
    }
    return result;
  }
}

/// Single Scheduled Outbound Message
class ScheduledMessage {
  final String id;
  final String recipientName;
  final String recipientPhone;
  final CommunicationChannel channel;
  final String? templateId;
  final String? templateName;
  final String content;
  final DateTime scheduledFor;
  final String timezone;
  final ScheduledMessageStatus status;
  final String createdBy;
  final bool isInternalNote;
  final String? customerId;
  final String? projectId;
  final String? attachmentUrl;

  const ScheduledMessage({
    required this.id,
    required this.recipientName,
    required this.recipientPhone,
    this.channel = CommunicationChannel.whatsapp,
    this.templateId,
    this.templateName,
    required this.content,
    required this.scheduledFor,
    this.timezone = 'Asia/Kolkata (IST)',
    required this.status,
    required this.createdBy,
    this.isInternalNote = false,
    this.customerId,
    this.projectId,
    this.attachmentUrl,
  });
}

/// Node inside a visual Drip Automation Graph
class DripNode {
  final String id;
  final DripNodeType type;
  final String title;
  final String description;
  final Map<String, dynamic> config;
  final double posX;
  final double posY;
  final List<String> nextNodeIds;
  final String? fallbackNodeId;

  const DripNode({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    this.config = const {},
    required this.posX,
    required this.posY,
    this.nextNodeIds = const [],
    this.fallbackNodeId,
  });

  DripNode copyWith({
    String? id,
    DripNodeType? type,
    String? title,
    String? description,
    Map<String, dynamic>? config,
    double? posX,
    double? posY,
    List<String>? nextNodeIds,
    String? fallbackNodeId,
  }) {
    return DripNode(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      description: description ?? this.description,
      config: config ?? this.config,
      posX: posX ?? this.posX,
      posY: posY ?? this.posY,
      nextNodeIds: nextNodeIds ?? this.nextNodeIds,
      fallbackNodeId: fallbackNodeId ?? this.fallbackNodeId,
    );
  }
}

/// Drip Automation Campaign
class DripCampaign {
  final String id;
  final String name;
  final String description;
  final DripTriggerType triggerType;
  final DripCampaignStatus status;
  final String targetAudienceDesc;
  final List<DripNode> nodes;
  final int enrolledCount;
  final int activeCount;
  final int completedCount;
  final int failedCount;
  final double conversionRate;
  final DateTime createdAt;
  final DateTime updatedAt;

  const DripCampaign({
    required this.id,
    required this.name,
    required this.description,
    required this.triggerType,
    required this.status,
    required this.targetAudienceDesc,
    required this.nodes,
    this.enrolledCount = 0,
    this.activeCount = 0,
    this.completedCount = 0,
    this.failedCount = 0,
    this.conversionRate = 0.0,
    required this.createdAt,
    required this.updatedAt,
  });
}

/// Audit Log Record for Communication History
class CommunicationRecord {
  final String id;
  final DateTime timestamp;
  final String customerName;
  final String customerPhone;
  final String customerId;
  final CommunicationChannel channel;
  final MessageDirection direction;
  final String actorType; // employee, bot, system
  final String actorName;
  final MessageContentType contentType;
  final String previewText;
  final MessageStatus status;
  final String sourceModule; // manual, broadcast, bulk, drip, chatbot, scheduled
  final String? relatedEntityId;
  final String? relatedEntityType; // lead, project, invoice, quotation, meeting
  final String? failureReason;
  final String? templateCode;

  const CommunicationRecord({
    required this.id,
    required this.timestamp,
    required this.customerName,
    required this.customerPhone,
    required this.customerId,
    required this.channel,
    required this.direction,
    required this.actorType,
    required this.actorName,
    required this.contentType,
    required this.previewText,
    required this.status,
    required this.sourceModule,
    this.relatedEntityId,
    this.relatedEntityType,
    this.failureReason,
    this.templateCode,
  });
}

/// WhatsApp Business API Account Connectivity State
class WhatsAppAccount {
  final String businessName;
  final String phoneNumber;
  final String displayPhoneNumber;
  final String wabaId;
  final WhatsAppConnectionStatus status;
  final String qualityRating; // GREEN, YELLOW, RED
  final String messagingTier; // 1K, 10K, 100K, Unlimited
  final String webhookStatus;
  final DateTime lastSyncTime;
  final int dailyLimit;
  final int currentUsage;

  const WhatsAppAccount({
    required this.businessName,
    required this.phoneNumber,
    required this.displayPhoneNumber,
    required this.wabaId,
    required this.status,
    required this.qualityRating,
    required this.messagingTier,
    required this.webhookStatus,
    required this.lastSyncTime,
    required this.dailyLimit,
    required this.currentUsage,
  });
}

/// Chatbot / AI Lead Qualifier Configuration
class ChatbotConfig {
  final String botName;
  final bool isEnabled;
  final String welcomeMessage;
  final String fallbackMessage;
  final int faqsCount;
  final int qualificationQuestionsCount;
  final String escalateToRole;
  final bool workingHoursOnly;
  final int activeConversationsCount;
  final int escalatedTodayCount;
  final List<String> handoverKeywords;

  const ChatbotConfig({
    required this.botName,
    required this.isEnabled,
    required this.welcomeMessage,
    required this.fallbackMessage,
    required this.faqsCount,
    required this.qualificationQuestionsCount,
    required this.escalateToRole,
    required this.workingHoursOnly,
    required this.activeConversationsCount,
    required this.escalatedTodayCount,
    required this.handoverKeywords,
  });
}

/// Module-Wide KPI Summary
class CommunicationKpiSummary {
  final int totalConversationsToday;
  final int openConversations;
  final int avgResponseMinutes;
  final int unreadMessages;
  final int broadcastsActive;
  final int templatesApproved;
  final int dripsActive;
  final double whatsappDeliveryRate;

  const CommunicationKpiSummary({
    required this.totalConversationsToday,
    required this.openConversations,
    required this.avgResponseMinutes,
    required this.unreadMessages,
    required this.broadcastsActive,
    required this.templatesApproved,
    required this.dripsActive,
    required this.whatsappDeliveryRate,
  });
}
