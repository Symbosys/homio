import 'package:flutter/material.dart';

/// CRM lead funnel stages defined by HOMIO Interior Design PRD
enum CrmStage {
  newEnquiry,
  qualified,
  meetingDone,
  bookedClient,
  notResponding,
  notQualified,
  notInterested,
}

extension CrmStageExt on CrmStage {
  String get id {
    switch (this) {
      case CrmStage.newEnquiry:
        return 'new_enquiry';
      case CrmStage.qualified:
        return 'qualified';
      case CrmStage.meetingDone:
        return 'meeting_done';
      case CrmStage.bookedClient:
        return 'booked_client';
      case CrmStage.notResponding:
        return 'not_responding';
      case CrmStage.notQualified:
        return 'not_qualified';
      case CrmStage.notInterested:
        return 'not_interested';
    }
  }

  String get label {
    switch (this) {
      case CrmStage.newEnquiry:
        return 'New Enquiry';
      case CrmStage.qualified:
        return 'Qualified';
      case CrmStage.meetingDone:
        return 'Meeting Done';
      case CrmStage.bookedClient:
        return 'Booked Client';
      case CrmStage.notResponding:
        return 'Not Responding';
      case CrmStage.notQualified:
        return 'Not Qualified';
      case CrmStage.notInterested:
        return 'Not Interested';
    }
  }

  String get displayName => label;

  Color get color {
    switch (this) {
      case CrmStage.newEnquiry:
        return const Color(0xFF3B82F6); // Blue
      case CrmStage.qualified:
        return const Color(0xFF8B5CF6); // Purple
      case CrmStage.meetingDone:
        return const Color(0xFF0EA5E9); // Cyan / Sky
      case CrmStage.bookedClient:
        return const Color(0xFF10B981); // Green
      case CrmStage.notResponding:
        return const Color(0xFFF59E0B); // Amber
      case CrmStage.notQualified:
        return const Color(0xFF6B7280); // Gray
      case CrmStage.notInterested:
        return const Color(0xFFEF4444); // Red
    }
  }

  IconData get icon {
    switch (this) {
      case CrmStage.newEnquiry:
        return Icons.mark_email_unread_outlined;
      case CrmStage.qualified:
        return Icons.verified_outlined;
      case CrmStage.meetingDone:
        return Icons.handshake_outlined;
      case CrmStage.bookedClient:
        return Icons.check_circle_outline_rounded;
      case CrmStage.notResponding:
        return Icons.hourglass_top_rounded;
      case CrmStage.notQualified:
        return Icons.block_flipped;
      case CrmStage.notInterested:
        return Icons.thumb_down_outlined;
    }
  }
}

/// Lead source channel
enum LeadSourceType {
  metaLeadAds,
  googleAds,
  googleSearch,
  websiteForm,
  whatsApp,
  referral,
  direct,
  manual,
}

extension LeadSourceTypeExt on LeadSourceType {
  String get label {
    switch (this) {
      case LeadSourceType.metaLeadAds:
        return 'Meta Lead Ads';
      case LeadSourceType.googleAds:
        return 'Google Ads';
      case LeadSourceType.googleSearch:
        return 'Google Search (Organic)';
      case LeadSourceType.websiteForm:
        return 'Website React Form';
      case LeadSourceType.whatsApp:
        return 'WhatsApp Inbound';
      case LeadSourceType.referral:
        return 'Client Referral';
      case LeadSourceType.direct:
        return 'Direct Walk-in';
      case LeadSourceType.manual:
        return 'Manual Telecaller Entry';
    }
  }

  String get displayName => label;

  IconData get icon {
    switch (this) {
      case LeadSourceType.metaLeadAds:
        return Icons.campaign_rounded;
      case LeadSourceType.googleAds:
      case LeadSourceType.googleSearch:
        return Icons.travel_explore_rounded;
      case LeadSourceType.websiteForm:
        return Icons.language_rounded;
      case LeadSourceType.whatsApp:
        return Icons.chat_bubble_outline_rounded;
      case LeadSourceType.referral:
        return Icons.people_outline_rounded;
      case LeadSourceType.direct:
        return Icons.storefront_rounded;
      case LeadSourceType.manual:
        return Icons.edit_note_rounded;
    }
  }
}

/// Interior Project Scope / Work Types specified in PRD
enum LeadWorkType {
  fullTurnkey,
  woodwork,
  falseCeiling,
  modularKitchen,
}

extension LeadWorkTypeExt on LeadWorkType {
  String get label {
    switch (this) {
      case LeadWorkType.fullTurnkey:
        return 'Full Turnkey Execution';
      case LeadWorkType.woodwork:
        return 'Woodwork & Wardrobes';
      case LeadWorkType.falseCeiling:
        return 'False Ceiling & Electricals';
      case LeadWorkType.modularKitchen:
        return 'Modular Kitchen';
    }
  }

  String get displayName => label;
}

/// Meeting Type Preference
enum MeetingPreferenceType {
  online,
  siteVisit,
  officeVisit,
}

extension MeetingPreferenceTypeExt on MeetingPreferenceType {
  String get label {
    switch (this) {
      case MeetingPreferenceType.online:
        return 'Online (Zoom / Meet)';
      case MeetingPreferenceType.siteVisit:
        return 'Site Visit';
      case MeetingPreferenceType.officeVisit:
        return 'Experience Center / Office Visit';
    }
  }

  String get displayName => label;

  IconData get icon {
    switch (this) {
      case MeetingPreferenceType.online:
        return Icons.videocam_outlined;
      case MeetingPreferenceType.siteVisit:
        return Icons.location_on_outlined;
      case MeetingPreferenceType.officeVisit:
        return Icons.business_outlined;
    }
  }

  Color get color {
    switch (this) {
      case MeetingPreferenceType.online:
        return Colors.blue;
      case MeetingPreferenceType.siteVisit:
        return Colors.orange;
      case MeetingPreferenceType.officeVisit:
        return Colors.teal;
    }
  }
}

/// Lead Allocation Algorithm Method
enum AssignmentMethod {
  manual,
  roundRobin,
  ruleBased,
  ai,
}

extension AssignmentMethodExt on AssignmentMethod {
  String get label {
    switch (this) {
      case AssignmentMethod.manual:
        return 'Manual Selection';
      case AssignmentMethod.roundRobin:
        return 'Round Robin Auto-Distribute';
      case AssignmentMethod.ruleBased:
        return 'Rule-Based (Pincode / Budget)';
      case AssignmentMethod.ai:
        return 'AI Matchmaking';
    }
  }

  String get displayName => label;
}

/// Sales Follow-Up Types
enum CrmFollowUpType {
  call,
  whatsApp,
  email,
  meeting,
  siteVisit,
  quotationFollowUp,
  paymentFollowUp,
  general,
}

extension CrmFollowUpTypeExt on CrmFollowUpType {
  String get label {
    switch (this) {
      case CrmFollowUpType.call:
        return 'Phone Call';
      case CrmFollowUpType.whatsApp:
        return 'WhatsApp Message';
      case CrmFollowUpType.email:
        return 'Email Follow-up';
      case CrmFollowUpType.meeting:
        return 'In-Person Meeting';
      case CrmFollowUpType.siteVisit:
        return 'Site Measurement Visit';
      case CrmFollowUpType.quotationFollowUp:
        return 'Quotation Discussion';
      case CrmFollowUpType.paymentFollowUp:
        return 'Token Advance Follow-up';
      case CrmFollowUpType.general:
        return 'General Touchpoint';
    }
  }

  String get displayName => label;

  IconData get icon {
    switch (this) {
      case CrmFollowUpType.call:
        return Icons.phone_outlined;
      case CrmFollowUpType.whatsApp:
        return Icons.chat_outlined;
      case CrmFollowUpType.email:
        return Icons.mail_outline_rounded;
      case CrmFollowUpType.meeting:
        return Icons.handshake_outlined;
      case CrmFollowUpType.siteVisit:
        return Icons.square_foot_outlined;
      case CrmFollowUpType.quotationFollowUp:
        return Icons.request_quote_outlined;
      case CrmFollowUpType.paymentFollowUp:
        return Icons.currency_rupee_rounded;
      case CrmFollowUpType.general:
        return Icons.event_note_outlined;
    }
  }

  Color get color {
    switch (this) {
      case CrmFollowUpType.call:
        return const Color(0xFF3B82F6);
      case CrmFollowUpType.whatsApp:
        return const Color(0xFF10B981);
      case CrmFollowUpType.email:
        return const Color(0xFF8B5CF6);
      case CrmFollowUpType.meeting:
        return const Color(0xFF0EA5E9);
      case CrmFollowUpType.siteVisit:
        return const Color(0xFFF59E0B);
      case CrmFollowUpType.quotationFollowUp:
        return const Color(0xFF6366F1);
      case CrmFollowUpType.paymentFollowUp:
        return const Color(0xFFEC4899);
      case CrmFollowUpType.general:
        return const Color(0xFF64748B);
    }
  }
}

/// Call Log Direction
enum CallDirection {
  inbound,
  outbound,
}

extension CallDirectionExt on CallDirection {
  String get label => this == CallDirection.inbound ? 'Inbound' : 'Outbound';
  String get displayName => label;
}

/// Call Log Type
enum CallCategory {
  manualCall,
  aiCall,
  ivrReminder,
}

extension CallCategoryExt on CallCategory {
  String get label {
    switch (this) {
      case CallCategory.manualCall:
        return 'Manual Call';
      case CallCategory.aiCall:
        return 'AI Autodialer';
      case CallCategory.ivrReminder:
        return 'IVR Reminder';
    }
  }

  String get displayName => label;
}

/// Call Outcomes
enum CallOutcome {
  connected,
  noAnswer,
  busy,
  wrongNumber,
  interested,
  notInterested,
  followUpRequired,
  meetingBooked,
  qualified,
  notQualified,
}

extension CallOutcomeExt on CallOutcome {
  String get label {
    switch (this) {
      case CallOutcome.connected:
        return 'Connected';
      case CallOutcome.noAnswer:
        return 'No Answer / Ringing';
      case CallOutcome.busy:
        return 'Busy / Line In Use';
      case CallOutcome.wrongNumber:
        return 'Invalid / Wrong Number';
      case CallOutcome.interested:
        return 'Interested in Turnkey';
      case CallOutcome.notInterested:
        return 'Not Interested';
      case CallOutcome.followUpRequired:
        return 'Callback Requested';
      case CallOutcome.meetingBooked:
        return 'Meeting Booked';
      case CallOutcome.qualified:
        return 'Qualified Lead';
      case CallOutcome.notQualified:
        return 'Out of Territory / Budget';
    }
  }

  String get displayName => label;

  Color get color {
    switch (this) {
      case CallOutcome.connected:
      case CallOutcome.meetingBooked:
      case CallOutcome.qualified:
        return const Color(0xFF10B981); // Green
      case CallOutcome.interested:
      case CallOutcome.followUpRequired:
        return const Color(0xFF3B82F6); // Blue
      case CallOutcome.noAnswer:
      case CallOutcome.busy:
        return const Color(0xFFF59E0B); // Amber
      case CallOutcome.notInterested:
      case CallOutcome.wrongNumber:
      case CallOutcome.notQualified:
        return const Color(0xFFEF4444); // Red
    }
  }
}

/// Sales Task Status
enum CrmTaskStatus {
  todo,
  pending,
  inProgress,
  waiting,
  completed,
  cancelled,
}

extension CrmTaskStatusExt on CrmTaskStatus {
  String get label {
    switch (this) {
      case CrmTaskStatus.todo:
      case CrmTaskStatus.pending:
        return 'To Do';
      case CrmTaskStatus.inProgress:
        return 'In Progress';
      case CrmTaskStatus.waiting:
        return 'Waiting / Blocked';
      case CrmTaskStatus.completed:
        return 'Completed';
      case CrmTaskStatus.cancelled:
        return 'Cancelled';
    }
  }

  String get displayName => label;

  IconData get icon {
    switch (this) {
      case CrmTaskStatus.todo:
      case CrmTaskStatus.pending:
        return Icons.radio_button_unchecked_rounded;
      case CrmTaskStatus.inProgress:
        return Icons.timelapse_rounded;
      case CrmTaskStatus.waiting:
        return Icons.pause_circle_outline_rounded;
      case CrmTaskStatus.completed:
        return Icons.check_circle_rounded;
      case CrmTaskStatus.cancelled:
        return Icons.cancel_outlined;
    }
  }

  Color get color {
    switch (this) {
      case CrmTaskStatus.todo:
      case CrmTaskStatus.pending:
        return const Color(0xFF64748B);
      case CrmTaskStatus.inProgress:
        return const Color(0xFF3B82F6);
      case CrmTaskStatus.waiting:
        return const Color(0xFFF59E0B);
      case CrmTaskStatus.completed:
        return const Color(0xFF10B981);
      case CrmTaskStatus.cancelled:
        return const Color(0xFFEF4444);
    }
  }
}

/// Sales Automation Trigger Event
enum AutomationTrigger {
  leadCreated,
  leadAssigned,
  stageChanged,
  leadQualified,
  meetingScheduled,
  meetingCompleted,
  quotationSent,
  bookingCompleted,
  noResponse,
  followUpDue,
  followUpMissed,
}

extension AutomationTriggerExt on AutomationTrigger {
  String get label {
    switch (this) {
      case AutomationTrigger.leadCreated:
        return 'Lead Ingested / Created';
      case AutomationTrigger.leadAssigned:
        return 'Lead Assigned to Salesperson';
      case AutomationTrigger.stageChanged:
        return 'Funnel Stage Changed';
      case AutomationTrigger.leadQualified:
        return 'Lead Auto/Manually Qualified';
      case AutomationTrigger.meetingScheduled:
        return 'Meeting Confirmed / Scheduled';
      case AutomationTrigger.meetingCompleted:
        return 'Meeting Marked Completed';
      case AutomationTrigger.quotationSent:
        return 'Quotation Created & Sent';
      case AutomationTrigger.bookingCompleted:
        return 'Booking Token Signed & Closed';
      case AutomationTrigger.noResponse:
        return 'Lead Not Responding (48 Hours)';
      case AutomationTrigger.followUpDue:
        return 'Follow-up Due Reminder';
      case AutomationTrigger.followUpMissed:
        return 'Follow-up SLA Missed / Escalate';
    }
  }

  String get displayName => label;
}
