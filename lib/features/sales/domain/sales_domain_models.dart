import 'package:flutter/material.dart';
import 'sales_enums.dart';

/// Single Lead Activity / Audit Trail Record
class LeadActivityItem {
  final String id;
  final DateTime timestamp;
  final String employeeName;
  final String action;
  final String details;
  final String source; // 'System', 'WhatsApp', 'Calling', 'Manual'
  final IconData icon;
  final Color iconColor;

  const LeadActivityItem({
    required this.id,
    required this.timestamp,
    required this.employeeName,
    required this.action,
    required this.details,
    required this.source,
    required this.icon,
    required this.iconColor,
  });
}

/// Comprehensive CRM Lead Item
class LeadItem {
  final String id;
  final String clientName;
  final String phone;
  final String? alternatePhone;
  final String email;
  final String city;
  final String state;
  final String pincode;
  final String address;
  final String projectType; // e.g. '4BHK Villa', '3BHK Highrise Apartment', 'Penthouse'
  final LeadWorkType workType;
  final double areaSqFt;
  final double budgetAmount; // in Lakhs (e.g. 35.0 = ₹35 Lakhs)
  final String budgetConfidence; // 'Confirmed', 'Flexible', 'Strict'
  final CrmStage stage;
  final LeadSourceType source;
  final String assignedTo;
  final String assignedDepartment;
  final AssignmentMethod assignmentMethod;
  final MeetingPreferenceType meetingPreference;
  final DateTime createdDate;
  final DateTime lastContactDate;
  final String? nextFollowupDate;
  final double leadScore; // 0 - 100
  final bool isQualified;
  final String? qualificationReason;
  final String? primaryObjection;
  final String? decliningReason;
  final List<String> tags;
  final bool isDuplicate;
  final List<LeadActivityItem> activities;

  const LeadItem({
    required this.id,
    required this.clientName,
    required this.phone,
    this.alternatePhone,
    required this.email,
    required this.city,
    required this.state,
    required this.pincode,
    required this.address,
    required this.projectType,
    required this.workType,
    required this.areaSqFt,
    required this.budgetAmount,
    required this.budgetConfidence,
    required this.stage,
    required this.source,
    required this.assignedTo,
    this.assignedDepartment = 'Sales & Design Consultation',
    this.assignmentMethod = AssignmentMethod.roundRobin,
    required this.meetingPreference,
    required this.createdDate,
    required this.lastContactDate,
    this.nextFollowupDate,
    required this.leadScore,
    required this.isQualified,
    this.qualificationReason,
    this.primaryObjection,
    this.decliningReason,
    this.tags = const [],
    this.isDuplicate = false,
    this.activities = const [],
  });

  LeadItem copyWith({
    CrmStage? stage,
    String? assignedTo,
    AssignmentMethod? assignmentMethod,
    String? nextFollowupDate,
    bool? isQualified,
    String? qualificationReason,
    String? primaryObjection,
    String? decliningReason,
    List<String>? tags,
    List<LeadActivityItem>? activities,
  }) {
    return LeadItem(
      id: id,
      clientName: clientName,
      phone: phone,
      alternatePhone: alternatePhone,
      email: email,
      city: city,
      state: state,
      pincode: pincode,
      address: address,
      projectType: projectType,
      workType: workType,
      areaSqFt: areaSqFt,
      budgetAmount: budgetAmount,
      budgetConfidence: budgetConfidence,
      stage: stage ?? this.stage,
      source: source,
      assignedTo: assignedTo ?? this.assignedTo,
      assignedDepartment: assignedDepartment,
      assignmentMethod: assignmentMethod ?? this.assignmentMethod,
      meetingPreference: meetingPreference,
      createdDate: createdDate,
      lastContactDate: DateTime.now(),
      nextFollowupDate: nextFollowupDate ?? this.nextFollowupDate,
      leadScore: leadScore,
      isQualified: isQualified ?? this.isQualified,
      qualificationReason: qualificationReason ?? this.qualificationReason,
      primaryObjection: primaryObjection ?? this.primaryObjection,
      decliningReason: decliningReason ?? this.decliningReason,
      tags: tags ?? this.tags,
      isDuplicate: isDuplicate,
      activities: activities ?? this.activities,
    );
  }
}

/// Customer 360 Record
class CustomerItem {
  final String id;
  final String leadOriginId;
  final String name;
  final String phone;
  final String? alternatePhone;
  final String email;
  final String address;
  final String city;
  final String pincode;
  final String? companyName;
  final int activeProjectsCount;
  final double totalContractValueLakhs;
  final double outstandingDuesLakhs;
  final String salesOwner;
  final String relationshipManager;
  final String status; // 'Active Execution', 'Design Approval', 'Handover', 'Warranty'
  final DateTime lastContact;
  final List<String> tags;
  final int complaintsCount;
  final double satisfactionRating;

  const CustomerItem({
    required this.id,
    required this.leadOriginId,
    required this.name,
    required this.phone,
    this.alternatePhone,
    required this.email,
    required this.address,
    required this.city,
    required this.pincode,
    this.companyName,
    required this.activeProjectsCount,
    required this.totalContractValueLakhs,
    required this.outstandingDuesLakhs,
    required this.salesOwner,
    required this.relationshipManager,
    required this.status,
    required this.lastContact,
    required this.tags,
    this.complaintsCount = 0,
    this.satisfactionRating = 4.8,
  });

  double get totalContractValue => totalContractValueLakhs;
  double get totalOutstanding => outstandingDuesLakhs;
  double get totalPaid => totalContractValueLakhs - outstandingDuesLakhs;
  String get handoverTargetDate => 'Oct 2026';
  String get projectManager => relationshipManager;
  String get projectName => tags.isNotEmpty ? tags.first : 'Turnkey Residence';
}

/// Dynamic Form Field Configuration
class DynamicFormField {
  final String id;
  final String label;
  final String key;
  final String type; // 'text', 'number', 'currency', 'phone', 'email', 'dropdown', 'location'
  final bool isRequired;
  final String placeholder;
  final String helpText;
  final List<String> options;
  final int order;

  String get name => label;

  const DynamicFormField({
    required this.id,
    required this.label,
    this.key = '',
    required this.type,
    required this.isRequired,
    this.placeholder = '',
    this.helpText = '',
    this.options = const [],
    this.order = 0,
  });
}

/// Multi-funnel Configuration
class FunnelConfig {
  final String id;
  final String name;
  final String description;
  final List<String> stageLabels;
  final List<DynamicFormField> formFields;
  final int activeLeadsCount;

  List<String> get stages => stageLabels;
  String get embedSlug => id.toLowerCase().replaceAll('_', '-');

  const FunnelConfig({
    required this.id,
    required this.name,
    required this.description,
    required this.stageLabels,
    required this.formFields,
    required this.activeLeadsCount,
  });

  FunnelConfig copyWith({
    String? name,
    String? description,
    List<String>? stageLabels,
    List<DynamicFormField>? formFields,
    int? activeLeadsCount,
  }) {
    return FunnelConfig(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      stageLabels: stageLabels ?? this.stageLabels,
      formFields: formFields ?? this.formFields,
      activeLeadsCount: activeLeadsCount ?? this.activeLeadsCount,
    );
  }
}

/// Follow-up Task Record
class FollowUpRecord {
  final String id;
  final String leadId;
  final String clientName;
  final String phone;
  final String? customerName;
  final String assignedTo;
  final CrmFollowUpType type;
  final String dueDate;
  final String dueTime;
  final String priority; // 'Urgent', 'High', 'Medium', 'Low'
  final String status; // 'Pending', 'Completed', 'Overdue', 'Rescheduled'
  final String notes;
  final String sentiment; // 'hot', 'warm', 'cold'
  final bool isDone;

  bool get isCompleted => isDone;
  String get note => notes;
  String get assignedRep => assignedTo;

  const FollowUpRecord({
    required this.id,
    required this.leadId,
    required this.clientName,
    required this.phone,
    this.customerName,
    required this.assignedTo,
    required this.type,
    required this.dueDate,
    required this.dueTime,
    required this.priority,
    required this.status,
    required this.notes,
    required this.sentiment,
    required this.isDone,
  });

  FollowUpRecord copyWith({
    bool? isDone,
    bool? isCompleted,
    String? status,
    String? dueDate,
    String? dueTime,
  }) {
    return FollowUpRecord(
      id: id,
      leadId: leadId,
      clientName: clientName,
      phone: phone,
      customerName: customerName,
      assignedTo: assignedTo,
      type: type,
      dueDate: dueDate ?? this.dueDate,
      dueTime: dueTime ?? this.dueTime,
      priority: priority,
      status: status ?? this.status,
      notes: notes,
      sentiment: sentiment,
      isDone: isCompleted ?? isDone ?? this.isDone,
    );
  }
}

/// Call Log Entry
class CallLogRecord {
  final String id;
  final String leadId;
  final String clientName;
  final String phone;
  final String employeeName;
  final CallDirection direction;
  final CallCategory category;
  final int durationSeconds;
  final CallOutcome outcome;
  final String recordingUrl;
  final String transcript;
  final String aiSummary;
  final List<String> keyPoints;
  final String nextAction;
  final double sentimentScore; // 0.0 - 1.0
  final DateTime callTime;

  const CallLogRecord({
    required this.id,
    required this.leadId,
    required this.clientName,
    required this.phone,
    required this.employeeName,
    required this.direction,
    required this.category,
    required this.durationSeconds,
    required this.outcome,
    required this.recordingUrl,
    required this.transcript,
    required this.aiSummary,
    required this.keyPoints,
    required this.nextAction,
    required this.sentimentScore,
    required this.callTime,
  });

  DateTime get timestamp => callTime;
}

/// Meeting / Consultation Record
class MeetingRecord {
  final String id;
  final String leadId;
  final String clientName;
  final String phone;
  final MeetingPreferenceType meetingType;
  final DateTime date;
  final String startTime;
  final String endTime;
  final String salesperson;
  final String designer;
  final String locationOrLink;
  final String meetingRoom;
  final String agenda;
  final String notes;
  final bool isCompleted;
  final bool reminder24hSent;
  final bool reminderMorningSent;
  final bool reminder1hSent;

  MeetingRecord({
    required this.id,
    required this.leadId,
    required this.clientName,
    this.phone = '',
    required this.meetingType,
    DateTime? date,
    required this.startTime,
    required this.endTime,
    String? salesperson,
    String? designer,
    String? locationOrLink,
    String? location,
    String? assignedRep,
    this.meetingRoom = '',
    required this.agenda,
    this.notes = '',
    this.isCompleted = false,
    this.reminder24hSent = true,
    this.reminderMorningSent = true,
    this.reminder1hSent = false,
  })  : date = date ?? DateTime.now(),
        salesperson = salesperson ?? assignedRep ?? '',
        designer = designer ?? '',
        locationOrLink = locationOrLink ?? location ?? '';

  String get location => locationOrLink.isNotEmpty ? locationOrLink : meetingRoom;
  String get assignedRep => salesperson.isNotEmpty ? salesperson : designer;

  MeetingRecord copyWith({
    bool? isCompleted,
    DateTime? date,
    String? startTime,
    String? endTime,
  }) {
    return MeetingRecord(
      id: id,
      leadId: leadId,
      clientName: clientName,
      phone: phone,
      meetingType: meetingType,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      salesperson: salesperson,
      designer: designer,
      locationOrLink: locationOrLink,
      meetingRoom: meetingRoom,
      agenda: agenda,
      notes: notes,
      isCompleted: isCompleted ?? this.isCompleted,
      reminder24hSent: reminder24hSent,
      reminderMorningSent: reminderMorningSent,
      reminder1hSent: reminder1hSent,
    );
  }
}

/// Sales Task Item
class SalesTaskItem {
  final String id;
  final String title;
  final String description;
  final String leadId;
  final String clientName;
  final String? customerName;
  final String assignedTo;
  final String priority; // 'Urgent', 'High', 'Medium', 'Low'
  final CrmTaskStatus status;
  final String dueDate;
  final String dueTime;
  final List<String> checklist;
  final List<String> notes;

  String get leadName => clientName;
  List<String> get subtasks => checklist;

  const SalesTaskItem({
    required this.id,
    required this.title,
    this.description = '',
    required this.leadId,
    String? clientName,
    String? leadName,
    this.customerName,
    required this.assignedTo,
    required this.priority,
    required this.status,
    required this.dueDate,
    this.dueTime = '18:00',
    List<String>? checklist,
    List<String>? subtasks,
    this.notes = const [],
  })  : clientName = clientName ?? leadName ?? 'Client',
        checklist = checklist ?? subtasks ?? const [];

  SalesTaskItem copyWith({
    CrmTaskStatus? status,
    String? dueDate,
    String? dueTime,
    String? assignedTo,
  }) {
    return SalesTaskItem(
      id: id,
      title: title,
      description: description,
      leadId: leadId,
      clientName: clientName,
      customerName: customerName,
      assignedTo: assignedTo ?? this.assignedTo,
      priority: priority,
      status: status ?? this.status,
      dueDate: dueDate ?? this.dueDate,
      dueTime: dueTime ?? this.dueTime,
      checklist: checklist,
      notes: notes,
    );
  }
}

/// Sales Automation Rule
class AutomationWorkflow {
  final String id;
  final String title;
  final String description;
  final AutomationTrigger trigger;
  final String conditionSummary;
  final String actionSummary;
  final bool isActive;
  final int runsToday;
  final int successfulRuns;
  final int failedRuns;

  const AutomationWorkflow({
    required this.id,
    String? title,
    String? name,
    this.description = '',
    required this.trigger,
    String? conditionSummary,
    String? conditions,
    String? actionSummary,
    String? actions,
    required this.isActive,
    this.runsToday = 0,
    this.successfulRuns = 0,
    this.failedRuns = 0,
    int? executionCount,
    String? lastTriggered,
  })  : title = title ?? name ?? '',
        conditionSummary = conditionSummary ?? conditions ?? '',
        actionSummary = actionSummary ?? actions ?? '';

  String get name => title;
  String get conditions => conditionSummary;
  String get actions => actionSummary;
  int get executionCount => successfulRuns + failedRuns;
  String get lastTriggered => 'Today';

  AutomationWorkflow copyWith({bool? isActive}) {
    return AutomationWorkflow(
      id: id,
      title: title,
      description: description,
      trigger: trigger,
      conditionSummary: conditionSummary,
      actionSummary: actionSummary,
      isActive: isActive ?? this.isActive,
      runsToday: runsToday,
      successfulRuns: successfulRuns,
      failedRuns: failedRuns,
    );
  }
}

/// Sales Employee Performance Ranking
class SalesTeamMemberMetric {
  final String employeeName;
  final String role;
  final int rank;
  final int leadsAssigned;
  final int callsCompleted;
  final int talkTimeMinutes;
  final int meetingsHosted;
  final int bookingsClosed;
  final double revenueGeneratedLakhs;
  final double conversionRate;

  const SalesTeamMemberMetric({
    required this.employeeName,
    required this.role,
    required this.rank,
    required this.leadsAssigned,
    required this.callsCompleted,
    required this.talkTimeMinutes,
    required this.meetingsHosted,
    required this.bookingsClosed,
    required this.revenueGeneratedLakhs,
    required this.conversionRate,
  });
}

/// CRM Overview Aggregated Summary
class SalesOverviewSummary {
  final int newLeads;
  final double newLeadsGrowthPercent;
  final int todayFollowups;
  final int pendingFollowups;
  final int meetingsScheduled;
  final int meetingsCompleted;
  final int bookingsClosed;
  final double bookingValueLakhs;
  final double conversionRate;

  // Monthly Booking Target Metrics
  final double monthlyBookingTargetCr; // e.g. 1.50
  final double actualBookingLakhs; // e.g. 96.5
  final double targetAchievementPercent; // 64.3%
  final double remainingTargetLakhs; // 53.5

  // Funnel Stage Counts
  final Map<String, int> funnelCounts; // 'new_enquiry': 124, 'qualified': 82, 'meeting_done': 45, 'booked_client': 18

  // Pipeline Distribution
  final Map<String, int> distributionCounts; // Stage -> count

  // Team Leaderboard
  final List<SalesTeamMemberMetric> teamRankings;

  // Activity Feed
  final List<LeadActivityItem> recentActivities;

  const SalesOverviewSummary({
    required this.newLeads,
    required this.newLeadsGrowthPercent,
    required this.todayFollowups,
    required this.pendingFollowups,
    required this.meetingsScheduled,
    required this.meetingsCompleted,
    required this.bookingsClosed,
    required this.bookingValueLakhs,
    required this.conversionRate,
    required this.monthlyBookingTargetCr,
    required this.actualBookingLakhs,
    required this.targetAchievementPercent,
    required this.remainingTargetLakhs,
    required this.funnelCounts,
    required this.distributionCounts,
    required this.teamRankings,
    required this.recentActivities,
  });
}
