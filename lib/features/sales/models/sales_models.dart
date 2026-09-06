import 'package:flutter/material.dart';

/// Common date filtering enum across Sales screens
enum SalesDateFilter {
  today,
  thisWeek,
  thisMonth,
  thisQuarter,
  thisYear,
}

extension SalesDateFilterExt on SalesDateFilter {
  String get label {
    switch (this) {
      case SalesDateFilter.today:
        return 'Today';
      case SalesDateFilter.thisWeek:
        return 'This Week';
      case SalesDateFilter.thisMonth:
        return 'This Month';
      case SalesDateFilter.thisQuarter:
        return 'This Quarter';
      case SalesDateFilter.thisYear:
        return 'This Year';
    }
  }
}

/// Generic KPI metric model for Sales
class SalesKpiMetric {
  final String id;
  final String title;
  final String value;
  final String changeText;
  final bool isPositive;
  final IconData icon;
  final Color color;
  final String? subtitle;

  const SalesKpiMetric({
    required this.id,
    required this.title,
    required this.value,
    required this.changeText,
    required this.isPositive,
    required this.icon,
    required this.color,
    this.subtitle,
  });
}

// ============================================================================
// 1. LEAD & FUNNEL MODELS
// ============================================================================

enum FunnelListType {
  interiorClient,
  designerRecruitment,
  vendorPartnership,
}

extension FunnelListTypeExt on FunnelListType {
  String get title {
    switch (this) {
      case FunnelListType.interiorClient:
        return 'Interior Client Funnel';
      case FunnelListType.designerRecruitment:
        return 'Designer Recruitment Funnel';
      case FunnelListType.vendorPartnership:
        return 'Vendor Partnership Funnel';
    }
  }
}

class SalesFunnelStage {
  final String id;
  final String name;
  final int stageIndex;
  final Color color;
  final String description;

  const SalesFunnelStage({
    required this.id,
    required this.name,
    required this.stageIndex,
    required this.color,
    required this.description,
  });
}

class SalesLeadItem {
  final String id;
  final String clientName;
  final String phone;
  final String email;
  final String siteAddress;
  final String projectType; // e.g. '4BHK Villa', '3BHK Modular', 'Penthouse'
  final String workDescription; // 'Full Turnkey', 'Modular Kitchen & Woodwork', 'False Ceiling'
  final double budgetAmount; // in Lakhs
  final String stageId;
  final String source; // 'Meta Ads', 'Google Ads', 'Website Form', 'Referral'
  final String assignedConsultant;
  final String meetingPreference; // 'Site Visit', 'Experience Center / Office', 'Zoom / Online'
  final String createdDate;
  final String nextFollowupTime;
  final bool isFollowupOverdue;
  final String? lastCallAudioUrl;
  final String? primaryObjection;
  final String? decliningReason;
  final List<String> tags;

  const SalesLeadItem({
    required this.id,
    required this.clientName,
    required this.phone,
    required this.email,
    required this.siteAddress,
    required this.projectType,
    required this.workDescription,
    required this.budgetAmount,
    required this.stageId,
    required this.source,
    required this.assignedConsultant,
    required this.meetingPreference,
    required this.createdDate,
    required this.nextFollowupTime,
    required this.isFollowupOverdue,
    this.lastCallAudioUrl,
    this.primaryObjection,
    this.decliningReason,
    this.tags = const [],
  });

  SalesLeadItem copyWith({
    String? stageId,
    String? nextFollowupTime,
    bool? isFollowupOverdue,
    String? primaryObjection,
    String? decliningReason,
  }) {
    return SalesLeadItem(
      id: id,
      clientName: clientName,
      phone: phone,
      email: email,
      siteAddress: siteAddress,
      projectType: projectType,
      workDescription: workDescription,
      budgetAmount: budgetAmount,
      stageId: stageId ?? this.stageId,
      source: source,
      assignedConsultant: assignedConsultant,
      meetingPreference: meetingPreference,
      createdDate: createdDate,
      nextFollowupTime: nextFollowupTime ?? this.nextFollowupTime,
      isFollowupOverdue: isFollowupOverdue ?? this.isFollowupOverdue,
      lastCallAudioUrl: lastCallAudioUrl,
      primaryObjection: primaryObjection ?? this.primaryObjection,
      decliningReason: decliningReason ?? this.decliningReason,
      tags: tags,
    );
  }
}

// ============================================================================
// 2. WHATSAPP API & INBOX MODELS
// ============================================================================

class WhatsAppMessageBubble {
  final String id;
  final String sender; // 'client' or 'agent' or 'ai'
  final String text;
  final String timestamp;
  final bool isRead;
  final String? mediaUrl;
  final String? mediaCaption;

  const WhatsAppMessageBubble({
    required this.id,
    required this.sender,
    required this.text,
    required this.timestamp,
    required this.isRead,
    this.mediaUrl,
    this.mediaCaption,
  });
}

class WhatsAppChatThread {
  final String id;
  final String contactName;
  final String phone;
  final String lastMessage;
  final String lastMessageTime;
  final int unreadCount;
  final String stageTag;
  final Color stageColor;
  final List<WhatsAppMessageBubble> messages;

  const WhatsAppChatThread({
    required this.id,
    required this.contactName,
    required this.phone,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.unreadCount,
    required this.stageTag,
    required this.stageColor,
    required this.messages,
  });
}

class BroadcastCampaignItem {
  final String id;
  final String name;
  final String templateName;
  final String targetAudience;
  final int recipientCount;
  final int deliveredCount;
  final int readCount;
  final int repliedCount;
  final String scheduledDate;
  final String status; // 'Active', 'Scheduled', 'Completed'
  final Color statusColor;

  const BroadcastCampaignItem({
    required this.id,
    required this.name,
    required this.templateName,
    required this.targetAudience,
    required this.recipientCount,
    required this.deliveredCount,
    required this.readCount,
    required this.repliedCount,
    required this.scheduledDate,
    required this.status,
    required this.statusColor,
  });
}

// ============================================================================
// 3. AI CALLING & AUTODIALER MODELS
// ============================================================================

class AiCallRecordItem {
  final String callId;
  final String leadId;
  final String clientName;
  final String phone;
  final String callDate;
  final String duration;
  final String qualificationStatus; // 'Qualified', 'Unresponsive', 'Callback Requested', 'Rejected'
  final Color statusColor;
  final String sentiment; // 'Positive (88%)', 'Neutral', 'Hesitant', 'Price Sensitive'
  final Color sentimentColor;
  final String fullTranscript;
  final String recordingUrl;

  const AiCallRecordItem({
    required this.callId,
    required this.leadId,
    required this.clientName,
    required this.phone,
    required this.callDate,
    required this.duration,
    required this.qualificationStatus,
    required this.statusColor,
    required this.sentiment,
    required this.sentimentColor,
    required this.fullTranscript,
    required this.recordingUrl,
  });
}

// ============================================================================
// 4. MEETING CALENDAR MODELS
// ============================================================================

class MeetingScheduleSlot {
  final String id;
  final String clientName;
  final String leadId;
  final String meetingFormat; // 'Site Visit', 'Experience Center', 'Zoom Virtual'
  final IconData formatIcon;
  final Color formatColor;
  final String date;
  final String timeRange; // '11:00 AM - 12:30 PM'
  final String locationOrLink;
  final String assignedDesigner;
  final String status; // 'Scheduled', 'Attended', 'Rescheduled', 'No-Show'
  final Color statusColor;
  final bool reminder24hSent;
  final bool reminderMorningSent;
  final bool reminder1hSent;

  const MeetingScheduleSlot({
    required this.id,
    required this.clientName,
    required this.leadId,
    required this.meetingFormat,
    required this.formatIcon,
    required this.formatColor,
    required this.date,
    required this.timeRange,
    required this.locationOrLink,
    required this.assignedDesigner,
    required this.status,
    required this.statusColor,
    required this.reminder24hSent,
    required this.reminderMorningSent,
    required this.reminder1hSent,
  });
}

// ============================================================================
// 5. SALES TASKS & SITE SURVEY MODELS
// ============================================================================

class RoomMeasurementEntry {
  final String roomName;
  final double lengthFeet;
  final double widthFeet;
  final double ceilingHeightFeet;
  final String notes;

  const RoomMeasurementEntry({
    required this.roomName,
    required this.lengthFeet,
    required this.widthFeet,
    required this.ceilingHeightFeet,
    required this.notes,
  });
}

class SiteSurveyRecordItem {
  final String surveyId;
  final String leadId;
  final String clientName;
  final String siteAddress;
  final String surveyDate;
  final String surveyorName;
  final List<RoomMeasurementEntry> roomMeasurements;
  final bool hasFloorplanAttached;
  final String floorplanName;
  final String vastuFacing; // 'North-East', 'East', 'North', 'West'
  final List<String> scopeChecklist;
  final String clientBudgetConstraint;

  const SiteSurveyRecordItem({
    required this.surveyId,
    required this.leadId,
    required this.clientName,
    required this.siteAddress,
    required this.surveyDate,
    required this.surveyorName,
    required this.roomMeasurements,
    required this.hasFloorplanAttached,
    required this.floorplanName,
    required this.vastuFacing,
    required this.scopeChecklist,
    required this.clientBudgetConstraint,
  });
}

class SalesFollowupTaskItem {
  final String id;
  final String title;
  final String leadId;
  final String clientName;
  final String dueTime;
  final String priority; // 'Urgent', 'High', 'Medium'
  final Color priorityColor;
  final bool isCompleted;

  const SalesFollowupTaskItem({
    required this.id,
    required this.title,
    required this.leadId,
    required this.clientName,
    required this.dueTime,
    required this.priority,
    required this.priorityColor,
    required this.isCompleted,
  });

  SalesFollowupTaskItem copyWith({bool? isCompleted}) {
    return SalesFollowupTaskItem(
      id: id,
      title: title,
      leadId: leadId,
      clientName: clientName,
      dueTime: dueTime,
      priority: priority,
      priorityColor: priorityColor,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
