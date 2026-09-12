import 'package:flutter/material.dart';

// ============================================================================
// 1. CUSTOMER ACTION ITEM MODEL
// ============================================================================

enum ActionItemType { approval, payment, quotation, meeting, material }

class CustomerActionItem {
  final String id;
  final String title;
  final String subtitle;
  final String description;
  final String timestamp;
  final String? deadline;
  final String projectName;
  final String projectId;
  final String actionLabel;
  final ActionItemType type;
  final String? amount;
  final String routePath;

  const CustomerActionItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.timestamp,
    this.deadline,
    required this.projectName,
    required this.projectId,
    required this.actionLabel,
    required this.type,
    this.amount,
    required this.routePath,
  });
}

// ============================================================================
// 2. RECENT ACTIVITY ITEM MODEL
// ============================================================================

class CustomerActivityItem {
  final String id;
  final String timestamp;
  final String relativeTime;
  final String title;
  final String description;
  final String? stage;
  final String? actor;
  final bool hasAttachments;
  final int attachmentCount;
  final IconData icon;
  final Color iconColor;

  const CustomerActivityItem({
    required this.id,
    required this.timestamp,
    required this.relativeTime,
    required this.title,
    required this.description,
    this.stage,
    this.actor,
    this.hasAttachments = false,
    this.attachmentCount = 0,
    required this.icon,
    required this.iconColor,
  });
}

// ============================================================================
// 3. PROJECT STAGE & MILESTONE MODELS
// ============================================================================

enum MilestoneStatus {
  completed('Completed', Color(0xFF10B981), Icons.check_circle_rounded),
  inProgress('In Progress', Color(0xFF3B82F6), Icons.timelapse_rounded),
  pendingApproval('Approval Required', Color(0xFFF59E0B), Icons.pending_actions_rounded),
  upcoming('Upcoming', Color(0xFF64748B), Icons.radio_button_unchecked_rounded),
  delayed('Delayed', Color(0xFFEF4444), Icons.warning_amber_rounded);

  final String label;
  final Color color;
  final IconData icon;
  const MilestoneStatus(this.label, this.color, this.icon);
}

class CustomerMilestone {
  final String id;
  final String title;
  final String description;
  final MilestoneStatus status;
  final double progress;
  final String? dueDate;
  final String? completedDate;
  final bool requiresCustomerApproval;
  final List<String> documents;

  const CustomerMilestone({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.progress,
    this.dueDate,
    this.completedDate,
    this.requiresCustomerApproval = false,
    this.documents = const [],
  });
}

class CustomerProjectStage {
  final String id;
  final String name;
  final String status;
  final double progress;
  final String completedDateOrEta;
  final int totalTasks;
  final int completedTasks;
  final bool isCurrent;

  const CustomerProjectStage({
    required this.id,
    required this.name,
    required this.status,
    required this.progress,
    required this.completedDateOrEta,
    required this.totalTasks,
    required this.completedTasks,
    this.isCurrent = false,
  });
}

// ============================================================================
// 4. CUSTOMER PROJECT MODEL
// ============================================================================

class CustomerProject {
  final String id;
  final String name;
  final String type;
  final String location;
  final String fullAddress;
  final String area;
  final String carpetArea;
  final String rooms;
  final String status;
  final double overallProgress;
  final String currentStage;
  final String nextMilestone;
  final String startDate;
  final String expectedCompletion;
  final String lastUpdated;
  final String pmName;
  final String pmPhone;
  final String pmAvatar;
  final String designerName;
  final String siteLeadName;
  final double totalValue;
  final double paidAmount;
  final double pendingAmount;
  final String imageUrl;
  final List<CustomerProjectStage> stages;
  final List<CustomerMilestone> milestones;
  final List<CustomerActivityItem> activityLog;

  const CustomerProject({
    required this.id,
    required this.name,
    required this.type,
    required this.location,
    required this.fullAddress,
    required this.area,
    required this.carpetArea,
    required this.rooms,
    required this.status,
    required this.overallProgress,
    required this.currentStage,
    required this.nextMilestone,
    required this.startDate,
    required this.expectedCompletion,
    required this.lastUpdated,
    required this.pmName,
    required this.pmPhone,
    required this.pmAvatar,
    required this.designerName,
    required this.siteLeadName,
    required this.totalValue,
    required this.paidAmount,
    required this.pendingAmount,
    required this.imageUrl,
    required this.stages,
    required this.milestones,
    required this.activityLog,
  });
}

// ============================================================================
// 5. ENQUIRY MODELS
// ============================================================================

class CustomerMeeting {
  final String id;
  final String title;
  final String type; // Online Google Meet, Office Visit, Site Visit
  final String date;
  final String time;
  final String assignedPerson;
  final String status;
  final String? meetingUrl;
  final String? location;
  final String notes;

  const CustomerMeeting({
    required this.id,
    required this.title,
    required this.type,
    required this.date,
    required this.time,
    required this.assignedPerson,
    required this.status,
    this.meetingUrl,
    this.location,
    this.notes = '',
  });
}

class CustomerEnquiry {
  final String id;
  final String projectType;
  final String location;
  final String fullAddress;
  final String createdDate;
  final String stage;
  final String status;
  final String assignedPerson;
  final String assignedRole;
  final String assignedPhone;
  final String nextFollowUp;
  final String nextFollowUpPurpose;
  final String meetingStatus;
  final String quotationStatus;
  final String? linkedQuotationId;
  final String budgetRange;
  final String expectedTimeline;
  final String propertyType;
  final String carpetArea;
  final String builtUpArea;
  final int bedrooms;
  final int bathrooms;
  final int floors;
  final String stylePreference;
  final String serviceRequired;
  final String preferredMeetingType;
  final String clientName;
  final String clientPhone;
  final String clientEmail;
  final String notes;
  final List<String> stages;
  final int currentStageIndex;
  final List<CustomerMeeting> meetings;
  final List<CustomerActivityItem> activityLog;

  const CustomerEnquiry({
    required this.id,
    required this.projectType,
    required this.location,
    required this.fullAddress,
    required this.createdDate,
    required this.stage,
    required this.status,
    required this.assignedPerson,
    required this.assignedRole,
    required this.assignedPhone,
    required this.nextFollowUp,
    required this.nextFollowUpPurpose,
    required this.meetingStatus,
    required this.quotationStatus,
    this.linkedQuotationId,
    required this.budgetRange,
    required this.expectedTimeline,
    required this.propertyType,
    required this.carpetArea,
    required this.builtUpArea,
    required this.bedrooms,
    required this.bathrooms,
    required this.floors,
    required this.stylePreference,
    required this.serviceRequired,
    required this.preferredMeetingType,
    required this.clientName,
    required this.clientPhone,
    required this.clientEmail,
    required this.notes,
    required this.stages,
    required this.currentStageIndex,
    required this.meetings,
    required this.activityLog,
  });
}

// ============================================================================
// 6. QUOTATION MODELS
// ============================================================================

class CustomerBoqItem {
  final String id;
  final String name;
  final String category;
  final String room;
  final String description;
  final String specification;
  final String brand;
  final String material;
  final String finish;
  final int quantity;
  final String unit;
  final double rate;
  final double amount;

  const CustomerBoqItem({
    required this.id,
    required this.name,
    required this.category,
    required this.room,
    required this.description,
    required this.specification,
    required this.brand,
    required this.material,
    required this.finish,
    required this.quantity,
    required this.unit,
    required this.rate,
    required this.amount,
  });
}

class CustomerRoomCost {
  final String roomName;
  final double amount;
  final int itemCount;
  final IconData icon;

  const CustomerRoomCost({
    required this.roomName,
    required this.amount,
    required this.itemCount,
    required this.icon,
  });
}

class CustomerPaymentMilestone {
  final String title;
  final double percentage;
  final double amount;
  final String milestoneDescription;
  final String triggerCondition;
  final bool isPaid;

  const CustomerPaymentMilestone({
    required this.title,
    required this.percentage,
    required this.amount,
    required this.milestoneDescription,
    required this.triggerCondition,
    this.isPaid = false,
  });
}

class CustomerQuotation {
  final String id;
  final String enquiryId;
  final String projectId;
  final String projectTitle;
  final String date;
  final String validUntil;
  final int validityDaysRemaining;
  final String status;
  final String clientName;
  final String clientAddress;
  final String designerName;
  final String executiveSummary;
  final String projectScope;
  final double subtotal;
  final double discount;
  final double taxAmount;
  final double totalAmount;
  final List<CustomerRoomCost> roomCosts;
  final List<CustomerBoqItem> boqItems;
  final List<CustomerPaymentMilestone> paymentSchedule;
  final String warrantyInfo;
  final List<String> terms;
  final String? acceptedTimestamp;

  const CustomerQuotation({
    required this.id,
    required this.enquiryId,
    required this.projectId,
    required this.projectTitle,
    required this.date,
    required this.validUntil,
    required this.validityDaysRemaining,
    required this.status,
    required this.clientName,
    required this.clientAddress,
    required this.designerName,
    required this.executiveSummary,
    required this.projectScope,
    required this.subtotal,
    required this.discount,
    required this.taxAmount,
    required this.totalAmount,
    required this.roomCosts,
    required this.boqItems,
    required this.paymentSchedule,
    required this.warrantyInfo,
    required this.terms,
    this.acceptedTimestamp,
  });

  CustomerQuotation copyWith({
    String? status,
    String? acceptedTimestamp,
  }) {
    return CustomerQuotation(
      id: id,
      enquiryId: enquiryId,
      projectId: projectId,
      projectTitle: projectTitle,
      date: date,
      validUntil: validUntil,
      validityDaysRemaining: validityDaysRemaining,
      status: status ?? this.status,
      clientName: clientName,
      clientAddress: clientAddress,
      designerName: designerName,
      executiveSummary: executiveSummary,
      projectScope: projectScope,
      subtotal: subtotal,
      discount: discount,
      taxAmount: taxAmount,
      totalAmount: totalAmount,
      roomCosts: roomCosts,
      boqItems: boqItems,
      paymentSchedule: paymentSchedule,
      warrantyInfo: warrantyInfo,
      terms: terms,
      acceptedTimestamp: acceptedTimestamp ?? this.acceptedTimestamp,
    );
  }
}

// ============================================================================
// 7. ASSIGNED TEAM MODELS
// ============================================================================

enum TeamDepartment {
  leadership('Project Leadership', Color(0xFF4F46E5), Icons.admin_panel_settings_rounded),
  design('Design & Architecture', Color(0xFF8B5CF6), Icons.palette_rounded),
  execution('Site Execution & Engineering', Color(0xFF10B981), Icons.construction_rounded),
  support('Client Success & Operations', Color(0xFF06B6D4), Icons.headset_mic_rounded);

  final String label;
  final Color color;
  final IconData icon;
  const TeamDepartment(this.label, this.color, this.icon);
}

enum TeamDutyStatus {
  available('Available', Color(0xFF10B981), Icons.check_circle_outline_rounded),
  onSite('On-Site Active', Color(0xFF3B82F6), Icons.location_on_outlined),
  inStudio('In Design Studio', Color(0xFFF59E0B), Icons.palette_outlined);

  final String label;
  final Color color;
  final IconData icon;
  const TeamDutyStatus(this.label, this.color, this.icon);
}

class CustomerTeamMember {
  final String id;
  final String name;
  final String role;
  final TeamDepartment department;
  final String initials;
  final Color avatarColor;
  final TeamDutyStatus dutyStatus;
  final int experienceYears;
  final int completedProjects;
  final double rating;
  final int reviewCount;
  final String phoneNumber;
  final String whatsappNumber;
  final String email;
  final String qualification;
  final List<String> responsibilities;
  final String activeFocus;
  final String schedule;
  final bool isPrimary;

  const CustomerTeamMember({
    required this.id,
    required this.name,
    required this.role,
    required this.department,
    required this.initials,
    required this.avatarColor,
    required this.dutyStatus,
    required this.experienceYears,
    required this.completedProjects,
    required this.rating,
    required this.reviewCount,
    required this.phoneNumber,
    required this.whatsappNumber,
    required this.email,
    required this.qualification,
    required this.responsibilities,
    required this.activeFocus,
    required this.schedule,
    this.isPrimary = false,
  });
}

// ============================================================================
// 8. SITE PROGRESS MODELS
// ============================================================================

enum SiteMediaType { photo, video }

class SiteMediaItem {
  final String id;
  final String title;
  final String caption;
  final SiteMediaType type;
  final String? duration;
  final String zone;
  final String timestamp;
  final String uploader;
  final Color placeholderGradientStart;
  final Color placeholderGradientEnd;

  const SiteMediaItem({
    required this.id,
    required this.title,
    required this.caption,
    required this.type,
    this.duration,
    required this.zone,
    required this.timestamp,
    required this.uploader,
    required this.placeholderGradientStart,
    required this.placeholderGradientEnd,
  });
}

class CustomerSiteUpdate {
  final String id;
  final String title;
  final String stage;
  final String milestone;
  final String timestamp;
  final String relativeTime;
  final String authorName;
  final String authorRole;
  final String description;
  final List<SiteMediaItem> media;
  final List<String> tags;
  final List<String> completedTasks;
  final List<String> pendingTasks;

  const CustomerSiteUpdate({
    required this.id,
    required this.title,
    required this.stage,
    required this.milestone,
    required this.timestamp,
    required this.relativeTime,
    required this.authorName,
    required this.authorRole,
    required this.description,
    required this.media,
    required this.tags,
    this.completedTasks = const [],
    this.pendingTasks = const [],
  });

  int get photoCount => media.where((m) => m.type == SiteMediaType.photo).length;
  int get videoCount => media.where((m) => m.type == SiteMediaType.video).length;
}

// ============================================================================
// 9. STAGE & WORK APPROVAL MODELS
// ============================================================================

class ApprovalRevisionHistoryItem {
  final String version;
  final String date;
  final String title;
  final String notes;
  final String status;
  final String actor;

  const ApprovalRevisionHistoryItem({
    required this.version,
    required this.date,
    required this.title,
    required this.notes,
    required this.status,
    required this.actor,
  });
}

class CustomerApprovalItem {
  final String id;
  final String title;
  final String subtitle;
  final String stage;
  final String category;
  final String submittedBy;
  final String submittedRole;
  final String submissionDate;
  final String? deadline;
  String status; // 'Pending', 'Approved', 'Changes Requested', 'Rejected', 'Expired'
  String version;
  final String? trancheAmount;
  final String? linkedDesignId;
  final String previewType; // 'render', 'cad', 'document'
  final String previewTitle;
  final List<String> specifications;
  final String engineeringNote;
  final List<ApprovalRevisionHistoryItem> revisionHistory;
  String? approvalTimestamp;

  CustomerApprovalItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.stage,
    required this.category,
    required this.submittedBy,
    required this.submittedRole,
    required this.submissionDate,
    this.deadline,
    required this.status,
    required this.version,
    this.trancheAmount,
    this.linkedDesignId,
    required this.previewType,
    required this.previewTitle,
    required this.specifications,
    required this.engineeringNote,
    required this.revisionHistory,
    this.approvalTimestamp,
  });

  bool get isPending => status == 'Pending';
  bool get isApproved => status == 'Approved';
  bool get isChangesRequested => status == 'Changes Requested';
}

// ============================================================================
// 10. DESIGN & CAD VAULT MODELS
// ============================================================================

class DesignCommentItem {
  final String id;
  final String author;
  final String authorRole;
  final String timestamp;
  final String text;
  final bool isClient;

  const DesignCommentItem({
    required this.id,
    required this.author,
    required this.authorRole,
    required this.timestamp,
    required this.text,
    this.isClient = false,
  });
}

class CustomerDesignFile {
  final String id;
  final String title;
  final String roomZone;
  final String category; // '3D Designs', 'CAD Drawings', 'Floor Plans', 'Working Drawings', 'Renders', 'Material Specifications'
  final String fileFormat; // 'JPG', 'PNG', 'PDF', 'DWG'
  final String fileSize;
  String version;
  final String uploadedDate;
  String updatedDate;
  final String stage;
  String status; // 'Pending Approval', 'Approved', 'Under Review', 'Changes Requested'
  final String uploader;
  bool isApproved;
  final bool downloadAllowed;
  final Color? previewGradientStart;
  final Color? previewGradientEnd;
  final List<String> specifications;
  final List<DesignCommentItem> comments;
  final List<String> versions;
  final String? linkedApprovalId;

  CustomerDesignFile({
    required this.id,
    required this.title,
    required this.roomZone,
    required this.category,
    required this.fileFormat,
    required this.fileSize,
    required this.version,
    required this.uploadedDate,
    required this.updatedDate,
    required this.stage,
    required this.status,
    required this.uploader,
    this.isApproved = false,
    this.downloadAllowed = true,
    this.previewGradientStart,
    this.previewGradientEnd,
    required this.specifications,
    required this.comments,
    required this.versions,
    this.linkedApprovalId,
  });
}

// ============================================================================
// 12. PROJECT CHAT & MEETINGS MODELS
// ============================================================================

enum ChatAttachmentType { photo, document, cad, invoice }

class ChatAttachment {
  final String name;
  final ChatAttachmentType type;
  final String size;
  final IconData icon;

  const ChatAttachment({
    required this.name,
    required this.type,
    required this.size,
    required this.icon,
  });
}

class CustomerChatMessage {
  final String id;
  final String senderName;
  final String senderRole;
  final String senderAvatar;
  final Color avatarColor;
  final String message;
  final String timestamp;
  final String dateGroup;
  final bool isClient;
  final List<ChatAttachment> attachments;
  final String? contextTag;
  final bool isSystemMessage;

  CustomerChatMessage({
    required this.id,
    required this.senderName,
    required this.senderRole,
    required this.senderAvatar,
    required this.avatarColor,
    required this.message,
    required this.timestamp,
    required this.dateGroup,
    this.isClient = false,
    this.attachments = const [],
    this.contextTag,
    this.isSystemMessage = false,
  });
}

enum CustomerMeetingType {
  online('Online Meeting', Icons.videocam_rounded, Color(0xFF6366F1)),
  site('Site Inspection', Icons.location_on_rounded, Color(0xFF10B981)),
  office('Office Visit', Icons.apartment_rounded, Color(0xFFF59E0B));

  final String label;
  final IconData icon;
  final Color color;
  const CustomerMeetingType(this.label, this.icon, this.color);
}

class CustomerProjectMeeting {
  final String id;
  final String title;
  final CustomerMeetingType type;
  String date;
  String timeSlot;
  final String duration;
  final String locationOrLink;
  final String attendeeName;
  final String attendeeRole;
  final String purpose;
  final String? notes;
  String status; // 'Scheduled', 'Confirmed', 'Completed', 'Cancelled', 'Rescheduled'
  final String? agenda;
  final String? minutesOfMeeting;
  final List<String> actionItems;

  CustomerProjectMeeting({
    required this.id,
    required this.title,
    required this.type,
    required this.date,
    required this.timeSlot,
    required this.duration,
    required this.locationOrLink,
    required this.attendeeName,
    required this.attendeeRole,
    required this.purpose,
    this.notes,
    required this.status,
    this.agenda,
    this.minutesOfMeeting,
    this.actionItems = const [],
  });

  bool get isUpcoming => status == 'Scheduled' || status == 'Confirmed' || status == 'Rescheduled';
  bool get isCompleted => status == 'Completed';
}

// ============================================================================
// 13. BILLING & PAYMENTS MODELS
// ============================================================================

enum PaymentTrancheStatus { paid, dueNow, upcoming, overdue }

class CustomerPaymentTranche {
  final String id;
  final int stageNumber;
  final String stageTitle;
  final String description;
  final double amount;
  final double gstAmount;
  final double totalAmount;
  final String dueDate;
  String? paidDate;
  PaymentTrancheStatus status;
  String? transactionRef;
  final String invoiceNumber;
  final String category; // 'Design Fees', 'Materials', 'Execution', 'Supervision'

  CustomerPaymentTranche({
    required this.id,
    required this.stageNumber,
    required this.stageTitle,
    required this.description,
    required this.amount,
    required this.gstAmount,
    required this.totalAmount,
    required this.dueDate,
    this.paidDate,
    required this.status,
    this.transactionRef,
    required this.invoiceNumber,
    required this.category,
  });

  bool get isPaid => status == PaymentTrancheStatus.paid;
  bool get isDueNow => status == PaymentTrancheStatus.dueNow;
  bool get isOverdue => status == PaymentTrancheStatus.overdue;
  bool get isUpcoming => status == PaymentTrancheStatus.upcoming;
}

class InvoiceLineItem {
  final int itemNo;
  final String description;
  final double quantity;
  final String unit;
  final double rate;
  final double amount;

  const InvoiceLineItem({
    required this.itemNo,
    required this.description,
    required this.quantity,
    required this.unit,
    required this.rate,
    required this.amount,
  });
}

class CustomerInvoice {
  final String invoiceNumber;
  final String title;
  final String issueDate;
  final String dueDate;
  final String stageName;
  final double taxableAmount;
  final double gstAmount;
  final double totalAmount;
  final bool isPaid;
  final String pdfFileName;
  final List<InvoiceLineItem> lineItems;

  const CustomerInvoice({
    required this.invoiceNumber,
    required this.title,
    required this.issueDate,
    required this.dueDate,
    required this.stageName,
    required this.taxableAmount,
    required this.gstAmount,
    required this.totalAmount,
    required this.isPaid,
    required this.pdfFileName,
    required this.lineItems,
  });
}

class CustomerPaymentReceipt {
  final String receiptId;
  final String paymentId;
  final double amount;
  final String paidDate;
  final String paymentMethod;
  final String transactionRef;
  final String trancheTitle;
  final String status;

  const CustomerPaymentReceipt({
    required this.receiptId,
    required this.paymentId,
    required this.amount,
    required this.paidDate,
    required this.paymentMethod,
    required this.transactionRef,
    required this.trancheTitle,
    this.status = 'Success',
  });
}

// ============================================================================
// 14. MATERIALS WORKSPACE MODELS
// ============================================================================

class MaterialTimelineStep {
  final String title;
  final String? timestamp;
  final bool isCompleted;
  final bool isCurrent;

  const MaterialTimelineStep({
    required this.title,
    this.timestamp,
    required this.isCompleted,
    this.isCurrent = false,
  });
}

class CustomerMaterialItem {
  final String id;
  final String name;
  final String brand;
  final String category;
  final String specification;
  final String finish;
  final double quantity;
  final String unit;
  final String projectArea;
  final String stage;
  String status; // 'Suggested', 'Selected', 'Pending Approval', 'Approved', 'Ordered', 'Dispatched', 'Delivered', 'Cancelled'
  final Color imageGradientStart;
  final Color imageGradientEnd;
  bool isApprovalRequired;
  final List<MaterialTimelineStep> orderTimeline;
  final String? expectedDelivery;
  final String? actualDelivery;
  final String? vendorName;
  final String? notes;

  CustomerMaterialItem({
    required this.id,
    required this.name,
    required this.brand,
    required this.category,
    required this.specification,
    required this.finish,
    required this.quantity,
    required this.unit,
    required this.projectArea,
    required this.stage,
    required this.status,
    required this.imageGradientStart,
    required this.imageGradientEnd,
    this.isApprovalRequired = false,
    required this.orderTimeline,
    this.expectedDelivery,
    this.actualDelivery,
    this.vendorName,
    this.notes,
  });

  bool get isApproved => status == 'Approved' || status == 'Ordered' || status == 'Dispatched' || status == 'Delivered';
  bool get isDelivered => status == 'Delivered';
}

// ============================================================================
// 15. COMPLAINTS & SUPPORT MODELS
// ============================================================================

class ComplaintAttachment {
  final String name;
  final String type;
  final String size;

  const ComplaintAttachment({
    required this.name,
    required this.type,
    required this.size,
  });
}

class ComplaintActivityItem {
  final String timestamp;
  final String actor;
  final String action;
  final String note;

  const ComplaintActivityItem({
    required this.timestamp,
    required this.actor,
    required this.action,
    required this.note,
  });
}

class ComplaintMessageItem {
  final String id;
  final String author;
  final String role;
  final String timestamp;
  final String text;
  final bool isClient;

  const ComplaintMessageItem({
    required this.id,
    required this.author,
    required this.role,
    required this.timestamp,
    required this.text,
    this.isClient = false,
  });
}

class CustomerComplaint {
  final String id;
  final String title;
  final String category;
  final String priority;
  String status; // 'Open', 'Under Review', 'In Progress', 'Resolved', 'Reopened'
  final String createdDate;
  String lastUpdated;
  final String? relatedStage;
  final String? relatedRoom;
  final String description;
  final List<ComplaintAttachment> attachments;
  final String assignedContactName;
  final String assignedContactRole;
  String? resolutionNotes;
  String? resolvedDate;
  int? ratingScore;
  String? feedbackComments;
  final List<ComplaintActivityItem> activityLog;
  final List<ComplaintMessageItem> messages;

  CustomerComplaint({
    required this.id,
    required this.title,
    required this.category,
    required this.priority,
    required this.status,
    required this.createdDate,
    required this.lastUpdated,
    this.relatedStage,
    this.relatedRoom,
    required this.description,
    this.attachments = const [],
    required this.assignedContactName,
    required this.assignedContactRole,
    this.resolutionNotes,
    this.resolvedDate,
    this.ratingScore,
    this.feedbackComments,
    required this.activityLog,
    required this.messages,
  });

  bool get isOpen => status == 'Open' || status == 'Under Review' || status == 'In Progress' || status == 'Reopened';
  bool get isResolved => status == 'Resolved';
}

// ============================================================================
// 16. REALISTIC MOCK REPOSITORY FOR CUSTOMER EXPERIENCE
// ============================================================================

abstract class ClientDataRepository {
  // Active primary project
  static const CustomerProject activeProject = CustomerProject(
    id: 'HOM-PROJ-2026-0084',
    name: '3BHK Residence',
    type: 'Turnkey Interior & Architecture',
    location: 'Dhanbad, Jharkhand',
    fullAddress: 'Flat 402, Tower B, Royal Palms, Saraidhela, Dhanbad - 826004',
    area: '1,650 sq.ft',
    carpetArea: '1,420 sq.ft',
    rooms: '3 Bedrooms, 3 Baths, Living, Dining, Modular Kitchen, 2 Balconies',
    status: 'Execution in Progress',
    overallProgress: 0.68,
    currentStage: 'Electrical Work',
    nextMilestone: 'False Ceiling & Gypsum',
    startDate: '12 Aug 2026',
    expectedCompletion: '25 Nov 2026',
    lastUpdated: 'Today, 10:45 AM',
    pmName: 'Vikram Malhotra',
    pmPhone: '+91 98765 43210',
    pmAvatar: 'VM',
    designerName: 'Pooja Hegde',
    siteLeadName: 'Rajesh Verma',
    totalValue: 1850000.0,
    paidAmount: 1100000.0,
    pendingAmount: 750000.0,
    imageUrl: 'https://images.unsplash.com/photo-1618221195710-dd6b41faaea6?w=800&q=80',
    stages: [
      CustomerProjectStage(
        id: 'stg_1',
        name: 'Planning & Site Survey',
        status: 'Completed',
        progress: 1.0,
        completedDateOrEta: 'Completed 15 Aug 2026',
        totalTasks: 5,
        completedTasks: 5,
      ),
      CustomerProjectStage(
        id: 'stg_2',
        name: '3D Design & Blueprints',
        status: 'Completed',
        progress: 1.0,
        completedDateOrEta: 'Completed 05 Sep 2026',
        totalTasks: 8,
        completedTasks: 8,
      ),
      CustomerProjectStage(
        id: 'stg_3',
        name: 'Client Sign-Off & BOQ',
        status: 'Completed',
        progress: 1.0,
        completedDateOrEta: 'Completed 10 Sep 2026',
        totalTasks: 4,
        completedTasks: 4,
      ),
      CustomerProjectStage(
        id: 'stg_4',
        name: 'Material Procurement',
        status: 'Completed',
        progress: 1.0,
        completedDateOrEta: 'Completed 18 Sep 2026',
        totalTasks: 12,
        completedTasks: 12,
      ),
      CustomerProjectStage(
        id: 'stg_5',
        name: 'Execution & Installation',
        status: 'In Progress',
        progress: 0.68,
        completedDateOrEta: 'Expected 10 Nov 2026',
        totalTasks: 27,
        completedTasks: 18,
        isCurrent: true,
      ),
      CustomerProjectStage(
        id: 'stg_6',
        name: 'Snagging & Deep Cleaning',
        status: 'Upcoming',
        progress: 0.0,
        completedDateOrEta: 'Expected 18 Nov 2026',
        totalTasks: 6,
        completedTasks: 0,
      ),
      CustomerProjectStage(
        id: 'stg_7',
        name: 'Handover & 10-Yr Warranty',
        status: 'Upcoming',
        progress: 0.0,
        completedDateOrEta: 'Expected 25 Nov 2026',
        totalTasks: 4,
        completedTasks: 0,
      ),
    ],
    milestones: [
      CustomerMilestone(
        id: 'ms_1',
        title: 'Civil Demolition & Wall Prep',
        description: 'Kitchen partition removal & surface leveling completed with zero structural compromise.',
        status: MilestoneStatus.completed,
        progress: 1.0,
        completedDate: '24 Aug 2026',
        documents: ['Civil_Signoff.pdf', 'Inspection_Photo_Pack.zip'],
      ),
      CustomerMilestone(
        id: 'ms_2',
        title: 'Concealed Plumbing & Sanitary Lines',
        description: 'Astral CPVC pressure testing passed at 10 bar without leakage.',
        status: MilestoneStatus.completed,
        progress: 1.0,
        completedDate: '02 Sep 2026',
        documents: ['Pressure_Test_Certificate.pdf'],
      ),
      CustomerMilestone(
        id: 'ms_3',
        title: 'Electrical Concealed Conduiting & Wiring',
        description: 'Finolex FR wires laid with Schneider modular metal boxes. MCB distribution board wired.',
        status: MilestoneStatus.inProgress,
        progress: 0.72,
        dueDate: '16 Sep 2026',
        requiresCustomerApproval: true,
        documents: ['Electrical_Switch_Plan_v2.pdf'],
      ),
      CustomerMilestone(
        id: 'ms_4',
        title: 'False Ceiling & Gypsum Framing',
        description: 'Saint-Gobain channel framework with cove lighting channels ready for boarding.',
        status: MilestoneStatus.pendingApproval,
        progress: 0.45,
        dueDate: '22 Sep 2026',
        requiresCustomerApproval: true,
        documents: ['False_Ceiling_Sectional_Drawing.pdf'],
      ),
      CustomerMilestone(
        id: 'ms_5',
        title: 'Modular Carpentry & Plywood Carcass',
        description: 'Greenply 710 BWP plywood carcass assembly for kitchen and 3 master wardrobes.',
        status: MilestoneStatus.upcoming,
        progress: 0.0,
        dueDate: '10 Oct 2026',
      ),
      CustomerMilestone(
        id: 'ms_6',
        title: 'Asian Paints Royale Luxury Painting',
        description: '3-coat wall putty, primer, and luxury velvet matte finish paint application.',
        status: MilestoneStatus.upcoming,
        progress: 0.0,
        dueDate: '30 Oct 2026',
      ),
      CustomerMilestone(
        id: 'ms_7',
        title: 'Final Deep Clean & Ceremonial Handover',
        description: 'Deep sanitization, snag sign-off, key handover kit, and warranty registration.',
        status: MilestoneStatus.upcoming,
        progress: 0.0,
        dueDate: '25 Nov 2026',
      ),
    ],
    activityLog: [
      CustomerActivityItem(
        id: 'act_1',
        timestamp: 'Today, 10:45 AM',
        relativeTime: 'Today',
        title: 'Electrical conduit updated to 72%',
        description: 'Site Supervisor Rajesh Verma uploaded 4 progress photos for the master bedroom switch layout.',
        stage: 'Electrical Work',
        actor: 'Rajesh Verma (Site Supervisor)',
        hasAttachments: true,
        attachmentCount: 4,
        icon: Icons.electrical_services_rounded,
        iconColor: Color(0xFF3B82F6),
      ),
      CustomerActivityItem(
        id: 'act_2',
        timestamp: 'Yesterday, 04:30 PM',
        relativeTime: 'Yesterday',
        title: 'Living Room 3D Design submitted',
        description: 'Senior Designer Pooja Hegde submitted the revised Scandinavian wood slat TV wall for your review.',
        stage: '3D Design',
        actor: 'Pooja Hegde (Senior Designer)',
        hasAttachments: true,
        attachmentCount: 2,
        icon: Icons.view_in_ar_rounded,
        iconColor: Color(0xFF8B5CF6),
      ),
      CustomerActivityItem(
        id: 'act_3',
        timestamp: '10 Sep 2026, 02:15 PM',
        relativeTime: '10 Sep',
        title: 'Milestone payment received',
        description: 'Payment of ₹50,000 received via UPI for Civil & Plumbing sign-off. Tax invoice generated.',
        stage: 'Billing',
        actor: 'Homio Accounts',
        icon: Icons.check_circle_rounded,
        iconColor: Color(0xFF10B981),
      ),
      CustomerActivityItem(
        id: 'act_4',
        timestamp: '08 Sep 2026, 11:00 AM',
        relativeTime: '08 Sep',
        title: 'Virtual Review Meeting Completed',
        description: 'Discussed false ceiling cove lighting temperature (3000K Warm White agreed) with PM Vikram Malhotra.',
        stage: 'Meeting',
        actor: 'Vikram Malhotra (Project Manager)',
        icon: Icons.video_camera_front_rounded,
        iconColor: Color(0xFF06B6D4),
      ),
    ],
  );

  // Secondary project for multi-project switching
  static const CustomerProject secondaryProject = CustomerProject(
    id: 'HOM-PROJ-2026-0102',
    name: '2BHK Renovation',
    type: 'Renovation & Modular Kitchen',
    location: 'Ranchi, Jharkhand',
    fullAddress: 'Flat 201, Shanti Niketan, Kanke Road, Ranchi - 834008',
    area: '1,100 sq.ft',
    carpetArea: '920 sq.ft',
    rooms: '2 Bedrooms, 2 Baths, Living, Kitchen',
    status: 'Upcoming / Booking Confirmed',
    overallProgress: 0.15,
    currentStage: 'Planning & Site Survey',
    nextMilestone: 'Floor Plan CAD Finalization',
    startDate: '01 Oct 2026',
    expectedCompletion: '15 Jan 2027',
    lastUpdated: '11 Sep 2026',
    pmName: 'Arjun Verma',
    pmPhone: '+91 98350 11223',
    pmAvatar: 'AV',
    designerName: 'Sneha Roy',
    siteLeadName: 'Kunal Sen',
    totalValue: 980000.0,
    paidAmount: 150000.0,
    pendingAmount: 830000.0,
    imageUrl: 'https://images.unsplash.com/photo-1556911220-e15b29be8c8f?w=800&q=80',
    stages: [],
    milestones: [],
    activityLog: [],
  );

  static List<CustomerProject> get allProjects => [activeProject, secondaryProject];

  // High-Priority Action Items
  static const List<CustomerActionItem> actionItems = [
    CustomerActionItem(
      id: 'act_req_1',
      title: 'Approval Required',
      subtitle: 'Living Room 3D Design',
      description: 'Your designer Pooja Hegde submitted a revised 3D concept for the TV accent wall and cove lighting.',
      timestamp: 'Today, 10:30 AM',
      deadline: 'Requires Sign-Off by 15 Sep',
      projectName: '3BHK Residence',
      projectId: 'HOM-PROJ-2026-0084',
      actionLabel: 'Review Design',
      type: ActionItemType.approval,
      routePath: '/client/designs',
    ),
    CustomerActionItem(
      id: 'act_req_2',
      title: 'Payment Due',
      subtitle: 'Execution Milestone Payment',
      description: 'Stage 3 execution milestone of ₹75,000 is ready for settlement following electrical conduit sign-off.',
      timestamp: 'Due: 20 Sep 2026',
      deadline: 'Due in 8 days',
      projectName: '3BHK Residence',
      projectId: 'HOM-PROJ-2026-0084',
      actionLabel: 'Pay ₹75,000',
      type: ActionItemType.payment,
      amount: '₹75,000',
      routePath: '/client/payments',
    ),
    CustomerActionItem(
      id: 'act_req_3',
      title: 'Quotation Awaiting Acceptance',
      subtitle: 'Quotation #HOM-2026-0184',
      description: 'Official Turnkey Quotation for ₹12,80,000 has been issued. Valid for 5 days.',
      timestamp: 'Expires 30 Sep 2026',
      deadline: 'Valid for 5 days',
      projectName: '3BHK Interior Design',
      projectId: 'HOM-PROJ-2026-0084',
      actionLabel: 'View Quotation',
      type: ActionItemType.quotation,
      amount: '₹12,80,000',
      routePath: '/client/quotations',
    ),
  ];

  // Primary Enquiry
  static const CustomerEnquiry primaryEnquiry = CustomerEnquiry(
    id: 'ENQ-2026-0148',
    projectType: '3BHK Interior Design & Turnkey Execution',
    location: 'Dhanbad, Jharkhand',
    fullAddress: 'Flat 402, Royal Palms, Saraidhela, Dhanbad - 826004',
    createdDate: '28 Aug 2026',
    stage: 'Qualified',
    status: 'Active',
    assignedPerson: 'Rahul Sharma',
    assignedRole: 'Senior Design Consultant',
    assignedPhone: '+91 98111 22334',
    nextFollowUp: '18 Sep 2026',
    nextFollowUpPurpose: 'Quotation commercial walkthrough & material sample selection',
    meetingStatus: 'Meeting Completed',
    quotationStatus: 'Quotation Sent',
    linkedQuotationId: 'HOM-2026-0184',
    budgetRange: '₹15,00,000 – ₹20,00,000',
    expectedTimeline: '3 Months (Turnkey)',
    propertyType: 'Residential Apartment',
    carpetArea: '1,420 sq.ft',
    builtUpArea: '1,650 sq.ft',
    bedrooms: 3,
    bathrooms: 3,
    floors: 1,
    stylePreference: 'Modern Minimalist with Warm Scandinavian Wood Accents',
    serviceRequired: 'Turnkey Interior (Modular Woodwork, False Ceiling, Electrical & Decor)',
    preferredMeetingType: 'Online Google Meet',
    clientName: 'Amit Kumar',
    clientPhone: '+91 98765 01234',
    clientEmail: 'amit.kumar@example.com',
    notes: 'Prioritize concealed warm-white architectural lighting, Hafele soft-close kitchen hardware, and scratch-resistant acrylic wardrobe shutters.',
    stages: [
      'New Enquiry',
      'Qualified',
      'Meeting Done',
      'Quotation Sent',
      'Booking',
      'Project Handover',
    ],
    currentStageIndex: 3, // Quotation Sent
    meetings: [
      CustomerMeeting(
        id: 'mtg_1',
        title: 'Initial Concept & Space Planning',
        type: 'Online Google Meet',
        date: '02 Sep 2026',
        time: '11:00 AM – 12:00 PM',
        assignedPerson: 'Rahul Sharma (Design Consultant)',
        status: 'Completed',
        notes: 'Reviewed floor plan, identified open-kitchen requirements, finalized Scandinavian palette.',
      ),
      CustomerMeeting(
        id: 'mtg_2',
        title: 'Quotation & Material Walkthrough',
        type: 'Online Google Meet',
        date: '18 Sep 2026',
        time: '11:30 AM – 12:30 PM',
        assignedPerson: 'Rahul Sharma (Design Consultant)',
        status: 'Upcoming',
        meetingUrl: 'https://meet.google.com/homio-review-amit',
        notes: 'Review detailed BOQ, Hafele hardware options, and confirm booking schedule.',
      ),
    ],
    activityLog: [
      CustomerActivityItem(
        id: 'enq_act_1',
        timestamp: '10 Sep 2026, 03:00 PM',
        relativeTime: '10 Sep',
        title: 'Quotation #HOM-2026-0184 Generated & Sent',
        description: 'Complete room-wise BOQ of ₹12,80,000 uploaded for client review.',
        stage: 'Quotation Sent',
        actor: 'Rahul Sharma',
        icon: Icons.receipt_long_rounded,
        iconColor: Color(0xFF10B981),
      ),
      CustomerActivityItem(
        id: 'enq_act_2',
        timestamp: '02 Sep 2026, 12:00 PM',
        relativeTime: '02 Sep',
        title: 'Initial Consultation Meeting Completed',
        description: 'Client brief documented; room dimensions verified against builder CAD floor plans.',
        stage: 'Meeting Done',
        actor: 'Rahul Sharma',
        icon: Icons.check_circle_rounded,
        iconColor: Color(0xFF3B82F6),
      ),
      CustomerActivityItem(
        id: 'enq_act_3',
        timestamp: '29 Aug 2026, 11:30 AM',
        relativeTime: '29 Aug',
        title: 'Lead Qualified & Assigned',
        description: 'Budget range confirmed within ₹15L-₹20L turnkey bracket.',
        stage: 'Qualified',
        actor: 'Homio Sales Desk',
        icon: Icons.verified_user_rounded,
        iconColor: Color(0xFF6366F1),
      ),
      CustomerActivityItem(
        id: 'enq_act_4',
        timestamp: '28 Aug 2026, 09:15 AM',
        relativeTime: '28 Aug',
        title: 'Enquiry Registered Online',
        description: 'Online requirement form submitted via Homio Portal.',
        stage: 'New Enquiry',
        actor: 'Amit Kumar',
        icon: Icons.assignment_turned_in_rounded,
        iconColor: Color(0xFF0D9488),
      ),
    ],
  );

  static const CustomerEnquiry secondaryEnquiry = CustomerEnquiry(
    id: 'ENQ-2026-0092',
    projectType: 'Commercial Workspace Architecture',
    location: 'Bokaro Steel City',
    fullAddress: 'Sector 4, City Center, Bokaro',
    createdDate: '15 Jul 2026',
    stage: 'Converted to Project',
    status: 'Converted',
    assignedPerson: 'Pooja Hegde',
    assignedRole: 'Principal Architect',
    assignedPhone: '+91 98222 33445',
    nextFollowUp: 'None',
    nextFollowUpPurpose: 'Project already in active execution',
    meetingStatus: 'Completed',
    quotationStatus: 'Accepted',
    linkedQuotationId: 'HOM-2026-0098',
    budgetRange: '₹25,00,000+',
    expectedTimeline: '4 Months',
    propertyType: 'Commercial Office',
    carpetArea: '2,200 sq.ft',
    builtUpArea: '2,500 sq.ft',
    bedrooms: 0,
    bathrooms: 4,
    floors: 1,
    stylePreference: 'Industrial Modern with Glass Partitions',
    serviceRequired: 'Turnkey Commercial Interior',
    preferredMeetingType: 'Site Visit',
    clientName: 'Amit Kumar',
    clientPhone: '+91 98765 01234',
    clientEmail: 'amit.kumar@example.com',
    notes: 'Conference room soundproofing, 30 ergonomic workstations, and server room MEP.',
    stages: [
      'New Enquiry',
      'Qualified',
      'Meeting Done',
      'Quotation Sent',
      'Booking',
      'Project Handover',
    ],
    currentStageIndex: 4,
    meetings: [],
    activityLog: [],
  );

  static List<CustomerEnquiry> get allEnquiries => [primaryEnquiry, secondaryEnquiry];

  // Primary Quotation
  static const CustomerQuotation primaryQuotation = CustomerQuotation(
    id: 'HOM-2026-0184',
    enquiryId: 'ENQ-2026-0148',
    projectId: 'HOM-PROJ-2026-0084',
    projectTitle: '3BHK Turnkey Interior Architecture Proposal',
    date: '10 Sep 2026',
    validUntil: '30 Sep 2026',
    validityDaysRemaining: 5,
    status: 'Awaiting Acceptance',
    clientName: 'Amit Kumar',
    clientAddress: 'Flat 402, Royal Palms, Saraidhela, Dhanbad',
    designerName: 'Pooja Hegde (Senior Interior Designer)',
    executiveSummary:
        'Homio is pleased to present the comprehensive turnkey interior proposal for your 3BHK residence. '
        'This proposal integrates custom European-style modular cabinetry, calibrated false ceiling profiles with concealed warm cove illumination, '
        'and premium acoustic finishes engineered for durability and sophistication.',
    projectScope:
        'Full turnkey interior covering civil wall realignment, plumbing retrofitting, copper wire concealed electrical infrastructure, '
        'cove false ceiling with Saint-Gobain gypsum, modular kitchen with Hafele Tandem drawers, 3 floor-to-ceiling wardrobes with acrylic shutters, '
        'living room acoustic media console, and Asian Paints Royale velvet finish on all walls.',
    subtotal: 1180000.0,
    discount: 50000.0,
    taxAmount: 150000.0,
    totalAmount: 1280000.0,
    roomCosts: [
      CustomerRoomCost(roomName: 'Living Room', amount: 240000.0, itemCount: 5, icon: Icons.weekend_rounded),
      CustomerRoomCost(roomName: 'Master Bedroom', amount: 210000.0, itemCount: 4, icon: Icons.king_bed_rounded),
      CustomerRoomCost(roomName: 'Modular Kitchen', amount: 320000.0, itemCount: 6, icon: Icons.countertops_rounded),
      CustomerRoomCost(roomName: 'Bedroom 2 (Kid\'s)', amount: 160000.0, itemCount: 3, icon: Icons.bedroom_child_rounded),
      CustomerRoomCost(roomName: 'Dining & Foyer', amount: 110000.0, itemCount: 3, icon: Icons.dining_rounded),
      CustomerRoomCost(roomName: 'Balcony & Bathrooms', amount: 140000.0, itemCount: 4, icon: Icons.balcony_rounded),
    ],
    boqItems: [
      CustomerBoqItem(
        id: 'boq_1',
        name: 'Modular TV Console & Acoustic Fluted Wall',
        category: 'Living Room Woodwork',
        room: 'Living Room',
        description: 'Floating TV ledge with charcoal fluted panel backing & profile LED strip lighting.',
        specification: '18mm Greenply BWP 710 Plywood with 1mm Merino Matte Laminate and Charcoal Louvers.',
        brand: 'Greenply / Merino',
        material: 'Marine Grade Plywood (IS:710)',
        finish: 'Matte Walnut & Slate Charcoal',
        quantity: 1,
        unit: 'Set',
        rate: 85000.0,
        amount: 85000.0,
      ),
      CustomerBoqItem(
        id: 'boq_2',
        name: 'Designer Gypsum False Ceiling & Cove',
        category: 'Ceiling & Lighting',
        room: 'Living Room',
        description: 'Perimeter step cove false ceiling with Philips 3000K warm LED strips & recessed COB spotlights.',
        specification: '12.5mm Saint-Gobain Gypboard with GI channel framework and mesh jointing tape.',
        brand: 'Saint-Gobain / Philips',
        material: 'Gypsum Board & GI Framing',
        finish: 'White Satin Putty & Primer',
        quantity: 360,
        unit: 'Sq.Ft',
        rate: 135.0,
        amount: 48600.0,
      ),
      CustomerBoqItem(
        id: 'boq_3',
        name: 'Parallel Acrylic Modular Kitchen System',
        category: 'Kitchen Cabinetry',
        room: 'Modular Kitchen',
        description: 'Upper hydraulic cabinets, lower Tandem box pull-outs, tall pantry unit, and spice rack.',
        specification: '18mm Greenply HDHMR with anti-scratch seamless high-gloss acrylic shutter facings.',
        brand: 'Hafele / Greenply',
        material: 'High Density Moisture Resistant Board',
        finish: 'Champagne Gloss Acrylic',
        quantity: 1,
        unit: 'Complete Set',
        rate: 220000.0,
        amount: 220000.0,
      ),
      CustomerBoqItem(
        id: 'boq_4',
        name: 'Kalinga Stone Quartz Countertop & Dado',
        category: 'Countertop',
        room: 'Modular Kitchen',
        description: '18mm engineered quartz counter with chamfered bullnose edge and seamless sink cutout.',
        specification: 'Stain-resistant antimicrobial quartz stone with 40mm sandwich profile.',
        brand: 'KalingaStone',
        material: 'Engineered Quartz',
        finish: 'Polished Calacatta Gold',
        quantity: 65,
        unit: 'Sq.Ft',
        rate: 450.0,
        amount: 29250.0,
      ),
      CustomerBoqItem(
        id: 'boq_5',
        name: 'Floor-to-Ceiling Wardrobe with Loft',
        category: 'Bedroom Woodwork',
        room: 'Master Bedroom',
        description: '8-ft wardrobe with soft-close hinges, internal valet drawers, tie rack, and sensor LED lights.',
        specification: '18mm BWP Marine Plywood with internal fabric-feel laminate and external matte acrylic.',
        brand: 'Greenply / Hettich',
        material: 'Marine Grade Plywood',
        finish: 'Warm Cashmere & Brushed Brass Handles',
        quantity: 72,
        unit: 'Sq.Ft',
        rate: 1850.0,
        amount: 133200.0,
      ),
    ],
    paymentSchedule: [
      CustomerPaymentMilestone(
        title: 'Booking Advance (Token)',
        percentage: 10.0,
        amount: 128000.0,
        milestoneDescription: 'Locks project team, 3D CAD modeling, and site survey timeline.',
        triggerCondition: 'Upon Quotation Acceptance',
        isPaid: true,
      ),
      CustomerPaymentMilestone(
        title: 'Design Finalization & Material Sign-Off',
        percentage: 40.0,
        amount: 512000.0,
        milestoneDescription: 'Factory plywood procurement, hardware ordering, and civil demolition kick-off.',
        triggerCondition: '3D Render Approval & Material Selection',
        isPaid: false,
      ),
      CustomerPaymentMilestone(
        title: 'Mid-Stage Factory Dispatch & Installation',
        percentage: 40.0,
        amount: 512000.0,
        milestoneDescription: 'Modular furniture arrival at site, false ceiling framing & conduit completion.',
        triggerCondition: 'On Site Delivery of Finished Woodwork',
        isPaid: false,
      ),
      CustomerPaymentMilestone(
        title: 'Handover & Final Sign-Off',
        percentage: 10.0,
        amount: 128000.0,
        milestoneDescription: 'Quality inspection checklist sign-off, deep cleaning, and 10-Yr warranty certificate.',
        triggerCondition: 'Ceremonial Key Handover',
        isPaid: false,
      ),
    ],
    warrantyInfo: '10-Year Comprehensive Anti-Borer & Anti-Termite Marine Plywood Warranty + 1-Year Free Maintenance Service Visits.',
    terms: [
      'Quotation prices are locked and guaranteed for 30 calendar days from the date of issue.',
      'Includes 3 free 3D design iterations; structural wall modifications are subject to municipal building bylaws.',
      'Payment milestones are strictly tied to digital sign-off and visual site verification.',
      'All hardware components carry original manufacturer warranty (Hafele / Hettich 10-year mechanical guarantee).',
    ],
  );

  static List<CustomerQuotation> get allQuotations => [primaryQuotation];

  // ============================================================================
  // SYNCHRONIZED STATE NOTIFIER & REPOSITORY DATA
  // ============================================================================

  static final ValueNotifier<int> stateVersionNotifier = ValueNotifier<int>(0);

  // 1. Assigned Team Members
  static final List<CustomerTeamMember> teamMembers = [
    const CustomerTeamMember(
      id: 'tm_1',
      name: 'Rahul Sharma',
      role: 'Senior Project Manager',
      department: TeamDepartment.leadership,
      initials: 'RS',
      avatarColor: Color(0xFF4F46E5),
      dutyStatus: TeamDutyStatus.available,
      experienceYears: 10,
      completedProjects: 52,
      rating: 4.96,
      reviewCount: 48,
      phoneNumber: '+91 98111 22334',
      whatsappNumber: '+91 98111 22334',
      email: 'rahul.s@homio.in',
      qualification: 'B.Arch • PMP Certified Project Lead',
      responsibilities: [
        'Overall project lifecycle, master timeline tracking, and client milestone approvals',
        'Direct coordination between design studio, procurement logistics, and on-site supervisor',
      ],
      activeFocus: 'Stage 5 electrical conduit completion & false ceiling sign-off',
      schedule: 'Available Mon–Sat (9:00 AM – 7:00 PM) • Dedicated Single Point of Contact',
      isPrimary: true,
    ),
    const CustomerTeamMember(
      id: 'tm_2',
      name: 'Priya Mehta',
      role: 'Senior Interior Designer & Lead Architect',
      department: TeamDepartment.design,
      initials: 'PM',
      avatarColor: Color(0xFF8B5CF6),
      dutyStatus: TeamDutyStatus.inStudio,
      experienceYears: 8,
      completedProjects: 38,
      rating: 4.94,
      reviewCount: 35,
      phoneNumber: '+91 98203 11842',
      whatsappNumber: '+91 98203 11842',
      email: 'priya.m@homio.in',
      qualification: 'M.Des (NID Ahmedabad) • IIID Registered',
      responsibilities: [
        'Space planning, bespoke furniture aesthetics, 3D renders, and finish palettes',
        'Client design approval consultations, Italian marble matching & lighting schematics',
      ],
      activeFocus: 'Living Room TV accent wall v3 & Master bedroom walk-in closet',
      schedule: 'Studio Mon–Sat • Weekly Site Walkthrough (Thu 3:00 PM)',
      isPrimary: true,
    ),
    const CustomerTeamMember(
      id: 'tm_3',
      name: 'Amit Verma',
      role: 'Site Execution Lead & Civil Supervisor',
      department: TeamDepartment.execution,
      initials: 'AV',
      avatarColor: Color(0xFF10B981),
      dutyStatus: TeamDutyStatus.onSite,
      experienceYears: 12,
      completedProjects: 65,
      rating: 4.91,
      reviewCount: 59,
      phoneNumber: '+91 98190 77319',
      whatsappNumber: '+91 98190 77319',
      email: 'amit.v@homio.in',
      qualification: 'B.Tech Civil • Construction Safety Certified',
      responsibilities: [
        'Daily on-site supervision of carpenters, MEP contractors, and civil masons',
        'Daily photographic site updates, laser leveling, and material inspection',
      ],
      activeFocus: 'Concealed copper electrical conduit & false ceiling GI framework',
      schedule: 'Full-time On-Site Mon–Sat (8:30 AM – 6:30 PM)',
      isPrimary: true,
    ),
    const CustomerTeamMember(
      id: 'tm_4',
      name: 'Rohan Deshpande',
      role: 'Lead 3D Visualizer & CAD Specialist',
      department: TeamDepartment.design,
      initials: 'RD',
      avatarColor: Color(0xFF06B6D4),
      dutyStatus: TeamDutyStatus.inStudio,
      experienceYears: 6,
      completedProjects: 44,
      rating: 4.95,
      reviewCount: 40,
      phoneNumber: '+91 98205 66723',
      whatsappNumber: '+91 98205 66723',
      email: 'rohan.d@homio.in',
      qualification: 'B.Voc Interior CAD • Autodesk 3ds Max Certified',
      responsibilities: [
        'Photorealistic 4K 3D renders, CAD floor plans, and working drawings',
        'Client revision turnarounds within 24 hours of change requests',
      ],
      activeFocus: 'Modular Kitchen plumbing details and 3D walkthrough rendering',
      schedule: 'Design Studio Mon–Fri (10:00 AM – 7:00 PM)',
    ),
    const CustomerTeamMember(
      id: 'tm_5',
      name: 'Amitabh Sen',
      role: 'Procurement & Logistics Coordinator',
      department: TeamDepartment.execution,
      initials: 'AS',
      avatarColor: Color(0xFFF59E0B),
      dutyStatus: TeamDutyStatus.onSite,
      experienceYears: 5,
      completedProjects: 26,
      rating: 4.88,
      reviewCount: 22,
      phoneNumber: '+91 98208 99144',
      whatsappNumber: '+91 98208 99144',
      email: 'amitabh.s@homio.in',
      qualification: 'B.Com • Supply Chain & Material Intake Certified',
      responsibilities: [
        'Direct factory dispatch, Greenply 710 BWP plywood & Hafele hardware delivery',
        'Transit tracking, warehouse intake, and on-site material protection',
      ],
      activeFocus: 'Saint-Gobain gypsum channel intake & Asian Paints primer dispatch',
      schedule: 'Field Operations Mon–Sat (9:00 AM – 6:00 PM)',
    ),
    const CustomerTeamMember(
      id: 'tm_6',
      name: 'Neha Kapoor',
      role: 'Client Relationship & Success Specialist',
      department: TeamDepartment.support,
      initials: 'NK',
      avatarColor: Color(0xFFEC4899),
      dutyStatus: TeamDutyStatus.available,
      experienceYears: 7,
      completedProjects: 70,
      rating: 4.98,
      reviewCount: 62,
      phoneNumber: '+91 98333 44556',
      whatsappNumber: '+91 98333 44556',
      email: 'neha.k@homio.in',
      qualification: 'MBA Hospitality & Customer Experience',
      responsibilities: [
        'Direct homeowner concierge, payment milestone assistance, and query resolution',
        'Warranty certificate registration and after-sales satisfaction tracking',
      ],
      activeFocus: 'Smooth handover documentation & stage approval onboarding',
      schedule: 'Dedicated Support Desk Mon–Sat (9:00 AM – 8:00 PM)',
    ),
  ];

  // 2. Live Site Updates Feed
  static final List<CustomerSiteUpdate> siteUpdates = [
    const CustomerSiteUpdate(
      id: 'upd_1',
      title: 'Concealed Electrical Wiring & Modular Boxes Laid',
      stage: 'Stage 5: Execution',
      milestone: 'Electrical Conduiting',
      timestamp: 'Today, 10:30 AM',
      relativeTime: 'Today',
      authorName: 'Amit Verma',
      authorRole: 'Site Execution Lead',
      description:
          'Heavy-duty 25mm PVC conduits embedded in brick masonry across the Living Room and Master Bedroom. '
          'Finolex FR copper cables pulled with dedicated 16A AC lines and Schneider modular gang boxes laser-leveled.',
      media: [
        SiteMediaItem(
          id: 'med_1',
          title: 'Concealed PVC Conduits in Living Room TV Wall',
          caption: 'Laser-levelled conduit channelling with metal modular boxes anchored into masonry.',
          type: SiteMediaType.photo,
          zone: 'Living Room',
          timestamp: 'Today, 10:15 AM',
          uploader: 'Amit Verma',
          placeholderGradientStart: Color(0xFF1E293B),
          placeholderGradientEnd: Color(0xFF334155),
        ),
        SiteMediaItem(
          id: 'med_2',
          title: 'Finolex FR Copper Cable Pulling & Labeling',
          caption: 'Phase, neutral and earth wires pulled through false ceiling drops with circuit tags.',
          type: SiteMediaType.photo,
          zone: 'Master Bedroom',
          timestamp: 'Today, 10:20 AM',
          uploader: 'Amit Verma',
          placeholderGradientStart: Color(0xFF0F172A),
          placeholderGradientEnd: Color(0xFF1E293B),
        ),
        SiteMediaItem(
          id: 'med_3',
          title: 'Walkthrough Video: Living Room Electrical Run',
          caption: '30-second site video showing all 8 dual switchboard placements and distribution run.',
          type: SiteMediaType.video,
          duration: '0:34',
          zone: 'Living Room',
          timestamp: 'Today, 10:28 AM',
          uploader: 'Amit Verma',
          placeholderGradientStart: Color(0xFF312E81),
          placeholderGradientEnd: Color(0xFF4338CA),
        ),
      ],
      tags: ['Electrical', 'Living Room', 'Quality Verified'],
      completedTasks: [
        'Concealed wall channelling completed across all 3 bedrooms & living area',
        'Finolex FR copper wires pulled with safety earth loop verification',
        'Schneider modular gang boxes anchored and laser-leveled',
      ],
      pendingTasks: [
        'Main distribution board MCB wiring and circuit breaker grouping',
        'Megger insulation resistance test before plaster sealing',
      ],
    ),
    const CustomerSiteUpdate(
      id: 'upd_2',
      title: 'Saint-Gobain False Ceiling Channel Framework Erected',
      stage: 'Stage 5: Execution',
      milestone: 'False Ceiling & Gypsum',
      timestamp: 'Yesterday, 04:15 PM',
      relativeTime: 'Yesterday',
      authorName: 'Amit Verma',
      authorRole: 'Site Execution Lead',
      description:
          'Perimeter GI channels and intermediate brackets anchored with metal expansion fasteners at 450mm centers. '
          'Recessed perimeter cove lighting profile aligned to ensure continuous 3000K warm wash without shadows.',
      media: [
        SiteMediaItem(
          id: 'med_4',
          title: 'Perimeter GI Suspension Grid Framework',
          caption: 'Saint-Gobain genuine galvanised intermediate channels hung with laser waterline calibration.',
          type: SiteMediaType.photo,
          zone: 'Living & Dining',
          timestamp: 'Yesterday, 03:45 PM',
          uploader: 'Amit Verma',
          placeholderGradientStart: Color(0xFF1E1B4B),
          placeholderGradientEnd: Color(0xFF3730A3),
        ),
        SiteMediaItem(
          id: 'med_5',
          title: 'Cove Recess Detail for Strip Lighting',
          caption: '75mm stepped vertical cove ledge prepared for indirect warm illumination.',
          type: SiteMediaType.photo,
          zone: 'Living Room',
          timestamp: 'Yesterday, 04:05 PM',
          uploader: 'Amit Verma',
          placeholderGradientStart: Color(0xFF18181B),
          placeholderGradientEnd: Color(0xFF27272A),
        ),
      ],
      tags: ['Ceiling', 'Framework', 'Living Room'],
      completedTasks: [
        'Ceiling level marking via 360-degree laser waterline',
        'GI channel suspension grid secured into RCC slab with rawl bolts',
      ],
      pendingTasks: [
        '12.5mm Saint-Gobain Gyproc board fastening with drywall screws',
        'Fiber tape jointing and Gyproc joint filler compound coats',
      ],
    ),
    const CustomerSiteUpdate(
      id: 'upd_3',
      title: 'Astral CPVC Sanitary & Plumbing Pressure Testing Certified',
      stage: 'Stage 4: Civil & MEP',
      milestone: 'Sanitary & Plumbing',
      timestamp: '02 Sep 2026, 03:00 PM',
      relativeTime: '02 Sep',
      authorName: 'Amit Verma',
      authorRole: 'Site Execution Lead',
      description:
          'All concealed hot and cold water lines tested under 10 bar hydraulic pressure for 24 continuous hours. '
          'Zero pressure drop recorded. Diverter alignments confirmed for Grohe concealed bodies.',
      media: [
        SiteMediaItem(
          id: 'med_6',
          title: '10-Bar Hydraulic Gauge Test Verification',
          caption: 'Pressure gauge sealed at 10.2 bar with zero drop over a full 24-hour cycle.',
          type: SiteMediaType.photo,
          zone: 'Master Bathroom',
          timestamp: '02 Sep, 02:45 PM',
          uploader: 'Amit Verma',
          placeholderGradientStart: Color(0xFF042F2E),
          placeholderGradientEnd: Color(0xFF115E59),
        ),
      ],
      tags: ['Plumbing', 'Pressure Test Passed', 'Certified'],
      completedTasks: [
        'Concealed Astral CPVC hot/cold water pipeline installation',
        '24-hour 10 bar hydraulic pressure test successfully certified',
      ],
      pendingTasks: [
        'Plaster covering of plumbing wall channels',
      ],
    ),
  ];

  // 3. Stage & Work Approval Packages
  static final List<CustomerApprovalItem> approvalPackages = [
    CustomerApprovalItem(
      id: 'appr_design_1',
      title: 'Living Room 3D Design & TV Accent Wall',
      subtitle: 'Scandinavian warm oak fluted panel with cove illumination and floating acoustic media unit',
      stage: '02 Design & Approvals',
      category: '3D Architectural Render',
      submittedBy: 'Priya Mehta',
      submittedRole: 'Senior Interior Designer',
      submissionDate: 'Today, 11:00 AM',
      deadline: 'Review required by 15 Sep 2026',
      status: 'Pending',
      version: 'v3',
      linkedDesignId: 'des_1',
      previewType: 'render',
      previewTitle: 'Living Room 4K Photorealistic Render (v3 Final Proposal)',
      specifications: [
        '18mm Greenply BWP Plywood backing finished in Natural Scandinavian Oak Veneer',
        'Charcoal matte acoustic fluted louvers behind floating low-profile console',
        'Concealed Philips 3000K warm LED profile lighting strip with remote dimming',
        'Häfele soft-close push-to-open drawer runners with 30kg load capacity',
      ],
      engineeringNote:
          'Client feedback from v2 integrated: wood tone adjusted to lighter Scandinavian oak, and TV wall mount '
          'height recalibrated for 65-inch screen at an ergonomic 42-inch eye level.',
      revisionHistory: const [
        ApprovalRevisionHistoryItem(
          version: 'v1',
          date: '01 Sep 2026',
          title: 'Initial Concept Submitted',
          notes: 'First 3D visual concept shared with dark walnut wood tone.',
          status: 'Changes Requested',
          actor: 'Priya Mehta',
        ),
        ApprovalRevisionHistoryItem(
          version: 'v2',
          date: '04 Sep 2026',
          title: 'Revision with Matte Veneer',
          notes: 'Homeowner requested lighter Scandinavian palette with warm indirect lighting.',
          status: 'Changes Requested',
          actor: 'Amit Kumar (Client)',
        ),
        ApprovalRevisionHistoryItem(
          version: 'v3',
          date: '12 Sep 2026',
          title: 'Final Calibrated Proposal',
          notes: 'Lighter oak veneer applied with warm cove profile and hidden cable raceway.',
          status: 'Pending Review',
          actor: 'Priya Mehta',
        ),
      ],
    ),
    CustomerApprovalItem(
      id: 'appr_stage_5',
      title: 'Stage 5: Bespoke Modular Kitchen Fabrication',
      subtitle: 'Lower carcase, Häfele tandem boxes, and KalingaStone Calacatta quartz countertop installation',
      stage: '05 Execution',
      category: 'Carpentry & Joinery Sign-Off',
      submittedBy: 'Amit Verma',
      submittedRole: 'Site Execution Lead',
      submissionDate: '10 Sep 2026',
      deadline: 'Sign-off required by 18 Sep 2026',
      status: 'Pending',
      version: 'v1',
      trancheAmount: '₹75,000',
      previewType: 'cad',
      previewTitle: 'Modular Kitchen Workshop Fabrication & Elevation Drawings',
      specifications: [
        '18mm Greenply HDHMR moisture-resistant core with anti-scratch champagne acrylic',
        'Häfele soft-close Tandem drawer system with 30kg load capacity per tier',
        'KalingaStone Calacatta Gold 18mm engineered quartz counter with 40mm sandwich fascia',
        'Anti-stain nano-sealant cured on quartz joints with zero porosity',
      ],
      engineeringNote:
          'Internal QA verified: laser level alignment within ±0.5mm tolerance, board moisture tested at 8.2% (Standard < 10.5%). '
          'Client digital sign-off releases Stage 5 milestone and authorizes countertop assembly.',
      revisionHistory: const [
        ApprovalRevisionHistoryItem(
          version: 'v1',
          date: '10 Sep 2026',
          title: 'Workshop Joinery Pack Submitted',
          notes: 'Comprehensive technical fabrication dossier and material test certificates attached.',
          status: 'Pending Review',
          actor: 'Amit Verma',
        ),
      ],
    ),
    CustomerApprovalItem(
      id: 'appr_stage_4',
      title: 'Italian Statuario Marble Polish Grade-A Upgrade',
      subtitle: 'Diamond mirror polish and Tenax epoxy nano-grouting across Living & Foyer',
      stage: '04 Procurement & Finishes',
      category: 'Surface Finishes Upgrade',
      submittedBy: 'Rahul Sharma',
      submittedRole: 'Senior Project Manager',
      submissionDate: '01 Sep 2026',
      status: 'Approved',
      version: 'v1',
      trancheAmount: '₹45,000',
      previewType: 'document',
      previewTitle: 'Statuario Polish & Nano-Sealer QA Certificate',
      specifications: [
        '7-step Italian diamond grit polishing (grit 400 to 3000 mirror shine)',
        'Tenax transparent epoxy resin joint filler with color-matched marble dust',
        'Lithofin stain-stop nano-impregnation applied to prevent wine/oil discoloration',
      ],
      engineeringNote:
          'Digital sign-off completed by Amit Kumar on 05 Sep. Gloss reading verified at 94 GU (Grade A specification).',
      revisionHistory: const [
        ApprovalRevisionHistoryItem(
          version: 'v1',
          date: '01 Sep 2026',
          title: 'Specification Submitted',
          notes: 'Diamond polish proposal with Tenax epoxy joint filler sample.',
          status: 'Approved',
          actor: 'Rahul Sharma',
        ),
        ApprovalRevisionHistoryItem(
          version: 'v1',
          date: '05 Sep 2026',
          title: 'Sign-Off Certified',
          notes: 'Client digitally signed off. Execution team completed floor protection sheet cover.',
          status: 'Approved',
          actor: 'Amit Kumar (Client)',
        ),
      ],
      approvalTimestamp: '05 Sep 2026, 02:30 PM',
    ),
  ];

  // 4. Design & CAD Vault Library
  static final List<CustomerDesignFile> designFiles = [
    CustomerDesignFile(
      id: 'des_1',
      title: 'Living Room 3D Design & TV Accent Wall',
      roomZone: 'Living Room',
      category: '3D Designs',
      fileFormat: 'JPG',
      fileSize: '4.8 MB',
      version: 'v3',
      uploadedDate: 'Today, 11:00 AM',
      updatedDate: 'Today',
      stage: 'Design & Approvals',
      status: 'Pending Approval',
      uploader: 'Priya Mehta (Designer)',
      isApproved: false,
      downloadAllowed: true,
      previewGradientStart: const Color(0xFF1E1B4B),
      previewGradientEnd: const Color(0xFF4338CA),
      specifications: [
        '4K Photorealistic Render (3840 x 2160)',
        'Natural Scandinavian Oak & Slate Fluted Louvers',
        'Philips 3000K Warm Cove Illumination',
        'Hidden cable raceway & floating acoustic TV ledge',
      ],
      comments: [
        const DesignCommentItem(
          id: 'c_1',
          author: 'Priya Mehta',
          authorRole: 'Senior Designer',
          timestamp: 'Today, 11:05 AM',
          text: 'Hi Amit, I have calibrated the teak wood to a light Scandinavian oak veneer and widened the cove recess as discussed.',
        ),
      ],
      versions: ['v1', 'v2', 'v3'],
      linkedApprovalId: 'appr_design_1',
    ),
    CustomerDesignFile(
      id: 'des_2',
      title: 'Master Bedroom Walk-In Wardrobe & Moodboard',
      roomZone: 'Master Bedroom',
      category: '3D Designs',
      fileFormat: 'PNG',
      fileSize: '5.2 MB',
      version: 'v2',
      uploadedDate: '08 Sep 2026',
      updatedDate: '08 Sep',
      stage: 'Design & Approvals',
      status: 'Approved',
      uploader: 'Priya Mehta (Designer)',
      isApproved: true,
      downloadAllowed: true,
      previewGradientStart: const Color(0xFF312E81),
      previewGradientEnd: const Color(0xFF6366F1),
      specifications: [
        'Smoked bronze glass wardrobe shutters with anodized aluminum frame',
        'Integrated vertical LED profile warm sensor lighting',
        'Full-height valet mirror with soft-touch backlit halo',
      ],
      comments: [
        const DesignCommentItem(
          id: 'c_2',
          author: 'Amit Kumar',
          authorRole: 'Homeowner',
          timestamp: '08 Sep, 04:00 PM',
          text: 'Love the smoked glass look! Approved.',
          isClient: true,
        ),
      ],
      versions: ['v1', 'v2'],
    ),
    CustomerDesignFile(
      id: 'des_3',
      title: 'Parallel Modular Kitchen 3D View',
      roomZone: 'Modular Kitchen',
      category: '3D Designs',
      fileFormat: 'JPG',
      fileSize: '4.1 MB',
      version: 'v2',
      uploadedDate: '04 Sep 2026',
      updatedDate: '05 Sep',
      stage: 'Design & Approvals',
      status: 'Approved',
      uploader: 'Priya Mehta (Designer)',
      isApproved: true,
      downloadAllowed: true,
      previewGradientStart: const Color(0xFF0F172A),
      previewGradientEnd: const Color(0xFF0D9488),
      specifications: [
        'Champagne high-gloss seamless acrylic shutter facings',
        'KalingaStone Calacatta Gold 18mm quartz counter',
        'Hafele pull-out pantry tall unit with spice rack',
      ],
      comments: [],
      versions: ['v1', 'v2'],
    ),
    CustomerDesignFile(
      id: 'des_4',
      title: 'Electrical Conduit & Switch Layout Plan',
      roomZone: 'Full Residence',
      category: 'CAD Drawings',
      fileFormat: 'PDF',
      fileSize: '2.4 MB',
      version: 'v2',
      uploadedDate: '02 Sep 2026',
      updatedDate: '06 Sep',
      stage: 'Execution',
      status: 'Approved',
      uploader: 'Rohan Deshpande (CAD Lead)',
      isApproved: true,
      downloadAllowed: true,
      specifications: [
        'Concealed switchboard elevations with laser heights',
        'Two-way bedroom switch matrix and 16A appliance points',
        'Schneider modular gang plate layout schedule',
      ],
      comments: [],
      versions: ['v1', 'v2'],
    ),
    CustomerDesignFile(
      id: 'des_5',
      title: 'False Ceiling Gypsum Framing & Section Drawing',
      roomZone: 'Living & Dining',
      category: 'CAD Drawings',
      fileFormat: 'PDF',
      fileSize: '3.1 MB',
      version: 'v2',
      uploadedDate: '03 Sep 2026',
      updatedDate: '07 Sep',
      stage: 'Execution',
      status: 'Approved',
      uploader: 'Rohan Deshpande (CAD Lead)',
      isApproved: true,
      downloadAllowed: true,
      specifications: [
        'Saint-Gobain channel center spacing 450mm structural cross-sections',
        '12.5mm gypsum board fastening and cove LED driver access hatches',
      ],
      comments: [],
      versions: ['v1', 'v2'],
    ),
    CustomerDesignFile(
      id: 'des_6',
      title: 'Full Residence 2D Architectural Furniture Layout',
      roomZone: 'Full Residence',
      category: 'Floor Plans',
      fileFormat: 'PDF',
      fileSize: '1.8 MB',
      version: 'v3',
      uploadedDate: '28 Aug 2026',
      updatedDate: '30 Aug',
      stage: 'Planning & Survey',
      status: 'Approved',
      uploader: 'Rahul Sharma (PM)',
      isApproved: true,
      downloadAllowed: true,
      specifications: [
        '1,420 sq.ft carpet area architectural plan with all room dimensions',
        'Clear walkway clearances (minimum 36 inches around dining and beds)',
      ],
      comments: [],
      versions: ['v1', 'v2', 'v3'],
    ),
    CustomerDesignFile(
      id: 'des_7',
      title: 'Modular Kitchen Workshop Joinery Drawings',
      roomZone: 'Modular Kitchen',
      category: 'Working Drawings',
      fileFormat: 'DWG',
      fileSize: '6.5 MB',
      version: 'v1',
      uploadedDate: '08 Sep 2026',
      updatedDate: '08 Sep',
      stage: 'Execution',
      status: 'Under Review',
      uploader: 'Rohan Deshpande (CAD Lead)',
      isApproved: false,
      downloadAllowed: true,
      specifications: [
        'Factory CNC cutting optimization for Greenply HDHMR boards',
        'Hafele drawer slide clearance tolerances and hinge pocket drill depths',
      ],
      comments: [],
      versions: ['v1'],
    ),
    CustomerDesignFile(
      id: 'des_8',
      title: 'Turnkey Material & Hardware Specification Dossier',
      roomZone: 'Full Residence',
      category: 'Material Specifications',
      fileFormat: 'PDF',
      fileSize: '5.6 MB',
      version: 'v1',
      uploadedDate: '26 Aug 2026',
      updatedDate: '26 Aug',
      stage: 'Procurement',
      status: 'Approved',
      uploader: 'Amitabh Sen (Procurement)',
      isApproved: true,
      downloadAllowed: true,
      specifications: [
        'Greenply BWP 710 lab test moisture certificates',
        'Hafele 10-Year mechanical guarantee documentation',
        'Saint-Gobain Gyproc authentic QR verification codes',
      ],
      comments: [],
      versions: ['v1'],
    ),
  ];

  // ============================================================================
  // SYNCHRONIZED STATE MUTATIONS
  // ============================================================================

  static void approveDesign(String designId) {
    for (final des in designFiles) {
      if (des.id == designId) {
        des.isApproved = true;
        des.status = 'Approved';
        des.updatedDate = 'Today';
        break;
      }
    }

    for (final appr in approvalPackages) {
      if (appr.linkedDesignId == designId || appr.id == 'appr_design_1') {
        appr.status = 'Approved';
        appr.approvalTimestamp = 'Today, 11:45 AM';
      }
    }

    activeProject.activityLog.insert(
      0,
      CustomerActivityItem(
        id: 'act_${DateTime.now().millisecondsSinceEpoch}',
        timestamp: 'Today, Just now',
        relativeTime: 'Just now',
        title: 'Living Room 3D Design Approved',
        description: 'You digitally approved revision v3. The design is now locked and authorized for execution.',
        stage: '02 Design',
        actor: 'Amit Kumar (You)',
        icon: Icons.verified_rounded,
        iconColor: const Color(0xFF10B981),
      ),
    );

    actionItems.removeWhere((item) => item.id == 'act_req_1');
    stateVersionNotifier.value++;
  }

  static void requestDesignChanges(String designId, String reason, String comments) {
    for (final des in designFiles) {
      if (des.id == designId) {
        des.status = 'Changes Requested';
        des.updatedDate = 'Today';
        des.comments.add(
          DesignCommentItem(
            id: 'comm_${DateTime.now().millisecondsSinceEpoch}',
            author: 'Amit Kumar',
            authorRole: 'Homeowner',
            timestamp: 'Today, Just now',
            text: '$reason: $comments',
            isClient: true,
          ),
        );
        break;
      }
    }

    for (final appr in approvalPackages) {
      if (appr.linkedDesignId == designId || appr.id == 'appr_design_1') {
        appr.status = 'Changes Requested';
      }
    }

    activeProject.activityLog.insert(
      0,
      CustomerActivityItem(
        id: 'act_${DateTime.now().millisecondsSinceEpoch}',
        timestamp: 'Today, Just now',
        relativeTime: 'Just now',
        title: 'Changes Requested on 3D Design',
        description: 'Reason: $reason. Designer Priya Mehta notified for 24-hour turnaround.',
        stage: '02 Design',
        actor: 'Amit Kumar (You)',
        icon: Icons.edit_note_rounded,
        iconColor: const Color(0xFFF59E0B),
      ),
    );

    stateVersionNotifier.value++;
  }

  static void approveStageWork(String approvalId) {
    for (final appr in approvalPackages) {
      if (appr.id == approvalId) {
        appr.status = 'Approved';
        appr.approvalTimestamp = 'Today, Just now';

        activeProject.activityLog.insert(
          0,
          CustomerActivityItem(
            id: 'act_${DateTime.now().millisecondsSinceEpoch}',
            timestamp: 'Today, Just now',
            relativeTime: 'Just now',
            title: '${appr.title} Approved',
            description: 'Milestone sign-off certified. Next execution work authorized.',
            stage: appr.stage,
            actor: 'Amit Kumar (You)',
            icon: Icons.verified_rounded,
            iconColor: const Color(0xFF10B981),
          ),
        );
        break;
      }
    }

    stateVersionNotifier.value++;
  }

  static void requestStageChanges(String approvalId, String reason, String comments) {
    for (final appr in approvalPackages) {
      if (appr.id == approvalId) {
        appr.status = 'Changes Requested';

        activeProject.activityLog.insert(
          0,
          CustomerActivityItem(
            id: 'act_${DateTime.now().millisecondsSinceEpoch}',
            timestamp: 'Today, Just now',
            relativeTime: 'Just now',
            title: 'Inspection Requested: ${appr.title}',
            description: '$reason: $comments. Site supervisor Amit Verma notified.',
            stage: appr.stage,
            actor: 'Amit Kumar (You)',
            icon: Icons.warning_amber_rounded,
            iconColor: const Color(0xFFEF4444),
          ),
        );
        break;
      }
    }

    stateVersionNotifier.value++;
  }

  static void addDesignComment(String designId, String text) {
    for (final des in designFiles) {
      if (des.id == designId) {
        des.comments.add(
          DesignCommentItem(
            id: 'comm_${DateTime.now().millisecondsSinceEpoch}',
            author: 'Amit Kumar',
            authorRole: 'Homeowner',
            timestamp: 'Today, Just now',
            text: text,
            isClient: true,
          ),
        );
        break;
      }
    }
    stateVersionNotifier.value++;
  }

  // ============================================================================
  // 17. CHAT & MEETINGS REPOSITORY DATA & ACTIONS
  // ============================================================================

  static final List<CustomerChatMessage> chatMessages = [
    CustomerChatMessage(
      id: 'msg_1',
      senderName: 'HOMIO System',
      senderRole: 'System',
      senderAvatar: 'HS',
      avatarColor: const Color(0xFF64748B),
      message: 'Project kickoff & site survey certified for 3BHK Residence, Royal Palms, Saraidhela, Dhanbad.',
      timestamp: '01 Sep, 10:00 AM',
      dateGroup: '01 Sep 2026',
      isSystemMessage: true,
    ),
    CustomerChatMessage(
      id: 'msg_2',
      senderName: 'HOMIO System',
      senderRole: 'System',
      senderAvatar: 'HS',
      avatarColor: const Color(0xFF8B5CF6),
      message: 'Design Approval: Living Room 3D concept revision v3 submitted by Senior Designer Priya Mehta for your sign-off.',
      timestamp: '10 Sep, 11:30 AM',
      dateGroup: '10 Sep 2026',
      contextTag: 'DESIGN APPROVAL • Living Room v3',
      isSystemMessage: true,
    ),
    CustomerChatMessage(
      id: 'msg_3',
      senderName: 'Rahul Sharma',
      senderRole: 'Project Manager',
      senderAvatar: 'RS',
      avatarColor: const Color(0xFF4F46E5),
      message: 'Hello Amit! Electrical concealed conduit work in the living room and master suite is completed today. Our internal QA team has verified the switchboard coordinates.',
      timestamp: 'Yesterday, 04:15 PM',
      dateGroup: 'Yesterday',
      attachments: [
        const ChatAttachment(
          name: 'Master_Bedroom_Conduit_Inspection.jpg',
          type: ChatAttachmentType.photo,
          size: '2.4 MB',
          icon: Icons.photo_library_rounded,
        ),
      ],
    ),
    CustomerChatMessage(
      id: 'msg_4',
      senderName: 'Amit Kumar',
      senderRole: 'Homeowner',
      senderAvatar: 'AK',
      avatarColor: const Color(0xFF10B981),
      message: 'Thank you Rahul. The conduits look well routed. Could you confirm when the false ceiling channel framing starts?',
      timestamp: 'Yesterday, 05:20 PM',
      dateGroup: 'Yesterday',
      isClient: true,
    ),
    CustomerChatMessage(
      id: 'msg_5',
      senderName: 'Priya Mehta',
      senderRole: 'Senior Interior Designer',
      senderAvatar: 'PM',
      avatarColor: const Color(0xFF8B5CF6),
      message: 'Hi Amit! The Saint-Gobain channel framework begins on Tuesday. I have also scheduled an online design review for us on Friday at 11:00 AM to align on cove lighting color temperature.',
      timestamp: 'Today, 09:15 AM',
      dateGroup: 'Today',
      contextTag: 'MEETING • Design Review Friday 11:00 AM',
    ),
    CustomerChatMessage(
      id: 'msg_6',
      senderName: 'Amit Verma',
      senderRole: 'Site Execution Supervisor',
      senderAvatar: 'AV',
      avatarColor: const Color(0xFF10B981),
      message: 'Site Update: Astral CPVC plumbing lines passed hydro-pressure testing at 10 bar without pressure loss. Drainage slopes in both bathrooms re-checked.',
      timestamp: 'Today, 10:45 AM',
      dateGroup: 'Today',
      attachments: [
        const ChatAttachment(
          name: 'Plumbing_Pressure_Test_Certificate.pdf',
          type: ChatAttachmentType.document,
          size: '1.2 MB',
          icon: Icons.picture_as_pdf_rounded,
        ),
      ],
    ),
    CustomerChatMessage(
      id: 'msg_7',
      senderName: 'HOMIO Accounts Desk',
      senderRole: 'Commercials',
      senderAvatar: 'AC',
      avatarColor: const Color(0xFFF59E0B),
      message: 'Payment Request generated for Execution Milestone 02 (₹75,000 + GST). Due date: 20 Sep 2026.',
      timestamp: 'Today, 11:00 AM',
      dateGroup: 'Today',
      contextTag: 'PAYMENT REQUEST • Milestone 02 (₹75,000)',
      isSystemMessage: true,
    ),
  ];

  static void sendChatMessage(String text, {ChatAttachment? attachment, String? contextTag}) {
    chatMessages.add(
      CustomerChatMessage(
        id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
        senderName: 'Amit Kumar',
        senderRole: 'Homeowner',
        senderAvatar: 'AK',
        avatarColor: const Color(0xFF10B981),
        message: text,
        timestamp: 'Today, Just now',
        dateGroup: 'Today',
        isClient: true,
        attachments: attachment != null ? [attachment] : const [],
        contextTag: contextTag,
      ),
    );

    activeProject.activityLog.insert(
      0,
      CustomerActivityItem(
        id: 'act_${DateTime.now().millisecondsSinceEpoch}',
        timestamp: 'Today, Just now',
        relativeTime: 'Just now',
        title: 'Message sent to Project Team',
        description: text,
        stage: '05 Execution',
        actor: 'Amit Kumar (You)',
        icon: Icons.chat_bubble_outline_rounded,
        iconColor: const Color(0xFF6366F1),
      ),
    );

    stateVersionNotifier.value++;
  }

  static final List<CustomerProjectMeeting> projectMeetings = [
    CustomerProjectMeeting(
      id: 'meet_1',
      title: 'False Ceiling & Cove Lighting Design Review',
      type: CustomerMeetingType.online,
      date: '18 Sep 2026',
      timeSlot: '11:00 AM',
      duration: '45 mins',
      locationOrLink: 'https://meet.google.com/hom-proj-0084',
      attendeeName: 'Priya Mehta',
      attendeeRole: 'Senior Interior Designer',
      purpose: 'Review 3000K warm magnetic track lighting layout and approve kitchen pocket door clearances.',
      notes: 'Priya will share the 3D model with daylight simulation during the call.',
      status: 'Scheduled',
      agenda: '1. False ceiling sectional drawings review\n2. Magnetic track driver placement\n3. Q&A on living room wood slat wall',
    ),
    CustomerProjectMeeting(
      id: 'meet_2',
      title: 'Civil Demolition & CPVC Hydro-Pressure Walkthrough',
      type: CustomerMeetingType.site,
      date: '10 Sep 2026',
      timeSlot: '03:30 PM',
      duration: '60 mins',
      locationOrLink: 'Flat 402, Royal Palms, Saraidhela, Dhanbad',
      attendeeName: 'Amit Verma',
      attendeeRole: 'Site Execution Supervisor',
      purpose: 'On-site physical inspection of removed kitchen partition wall and CPVC line pressure test.',
      notes: 'Amit Verma verified pressure gauge reading at 10 bar.',
      status: 'Completed',
      minutesOfMeeting: 'Partition wall cleared without structural damage. CPVC joints held at 10 bar for 4 hours. Supervisor authorized electrical teams to begin concealed wall grooving.',
      actionItems: ['Commence switchboard conduits', 'Set floor marking for island kitchen counter'],
    ),
    CustomerProjectMeeting(
      id: 'meet_3',
      title: 'Physical Material & Veneer Sample Selection',
      type: CustomerMeetingType.office,
      date: '22 Sep 2026',
      timeSlot: '02:00 PM',
      duration: '60 mins',
      locationOrLink: 'HOMIO Experience Centre, Saraidhela, Dhanbad',
      attendeeName: 'Priya Mehta & Amitabh Sen',
      attendeeRole: 'Design & Procurement Leads',
      purpose: 'Touch and feel physical samples of Italian Walnut veneer, Calacatta quartz, and matte wardrobe glass.',
      status: 'Confirmed',
    ),
  ];

  static void bookMeeting({
    required String title,
    required CustomerMeetingType type,
    required String date,
    required String timeSlot,
    required String purpose,
    String? notes,
    required String attendeeName,
    required String attendeeRole,
  }) {
    projectMeetings.insert(
      0,
      CustomerProjectMeeting(
        id: 'meet_${DateTime.now().millisecondsSinceEpoch}',
        title: title,
        type: type,
        date: date,
        timeSlot: timeSlot,
        duration: '45 mins',
        locationOrLink: type == CustomerMeetingType.online
            ? 'https://meet.google.com/hom-proj-0084'
            : 'Flat 402, Royal Palms, Dhanbad',
        attendeeName: attendeeName,
        attendeeRole: attendeeRole,
        purpose: purpose,
        notes: notes,
        status: 'Scheduled',
      ),
    );

    activeProject.activityLog.insert(
      0,
      CustomerActivityItem(
        id: 'act_${DateTime.now().millisecondsSinceEpoch}',
        timestamp: 'Today, Just now',
        relativeTime: 'Just now',
        title: 'Meeting Scheduled: $title',
        description: '$date at $timeSlot with $attendeeName ($attendeeRole).',
        stage: '05 Execution',
        actor: 'Amit Kumar (You)',
        icon: Icons.calendar_today_rounded,
        iconColor: const Color(0xFF0EA5E9),
      ),
    );

    stateVersionNotifier.value++;
  }

  static void cancelMeeting(String meetingId) {
    for (final m in projectMeetings) {
      if (m.id == meetingId) {
        m.status = 'Cancelled';
        break;
      }
    }
    stateVersionNotifier.value++;
  }

  static void rescheduleMeeting(String meetingId, String newDate, String newTime) {
    for (final m in projectMeetings) {
      if (m.id == meetingId) {
        m.date = newDate;
        m.timeSlot = newTime;
        m.status = 'Rescheduled';
        break;
      }
    }
    stateVersionNotifier.value++;
  }

  // ============================================================================
  // 18. BILLING & PAYMENTS REPOSITORY DATA & ACTIONS
  // ============================================================================

  static final List<CustomerPaymentTranche> paymentTranches = [
    CustomerPaymentTranche(
      id: 'trn_1',
      stageNumber: 1,
      stageTitle: 'Booking & Architecture Advance (10%)',
      description: 'Initial token sign-off, comprehensive site 3D survey & master planning drawings.',
      amount: 150000.0,
      gstAmount: 27000.0,
      totalAmount: 177000.0,
      dueDate: '15 Aug 2026',
      paidDate: '15 Aug 2026',
      status: PaymentTrancheStatus.paid,
      transactionRef: 'HOM-TXN-2026-0815-9921',
      invoiceNumber: 'INV-2026-0012',
      category: 'Design Fees',
    ),
    CustomerPaymentTranche(
      id: 'trn_2',
      stageNumber: 2,
      stageTitle: '3D Photorealistic Concept & Detailed BOQ (15%)',
      description: 'Full 3D visualization sign-off, CAD working blueprints & itemized turnkey contract BOQ.',
      amount: 250000.0,
      gstAmount: 45000.0,
      totalAmount: 295000.0,
      dueDate: '05 Sep 2026',
      paidDate: '05 Sep 2026',
      status: PaymentTrancheStatus.paid,
      transactionRef: 'HOM-TXN-2026-0905-1483',
      invoiceNumber: 'INV-2026-0028',
      category: 'Design Fees',
    ),
    CustomerPaymentTranche(
      id: 'trn_3',
      stageNumber: 3,
      stageTitle: 'Civil Demolition & Core MEP Rough-Ins (40%)',
      description: 'Kitchen partition demolition, core civil prep, concealed CPVC plumbing & primary electrical wiring.',
      amount: 700000.0,
      gstAmount: 126000.0,
      totalAmount: 826000.0,
      dueDate: '10 Sep 2026',
      paidDate: '10 Sep 2026',
      status: PaymentTrancheStatus.paid,
      transactionRef: 'HOM-TXN-2026-0910-8402',
      invoiceNumber: 'INV-2026-0035',
      category: 'Execution',
    ),
    CustomerPaymentTranche(
      id: 'trn_4',
      stageNumber: 4,
      stageTitle: 'Execution Milestone 02 — Electrical & Modular Carcass (10%)',
      description: 'Modular switch boxes, MCB distribution board wiring, and Greenply BWP 710 kitchen carcass fabrication.',
      amount: 75000.0,
      gstAmount: 13500.0,
      totalAmount: 88500.0,
      dueDate: '20 Sep 2026',
      status: PaymentTrancheStatus.dueNow,
      invoiceNumber: 'INV-2026-0042',
      category: 'Execution',
    ),
    CustomerPaymentTranche(
      id: 'trn_5',
      stageNumber: 5,
      stageTitle: 'False Ceiling Framing & Modular Wardrobe Joinery (15%)',
      description: 'Saint-Gobain Gyproc false ceiling channels and factory CNC cutting for master suite wardrobes.',
      amount: 300000.0,
      gstAmount: 54000.0,
      totalAmount: 354000.0,
      dueDate: '15 Oct 2026',
      status: PaymentTrancheStatus.upcoming,
      invoiceNumber: 'INV-2026-0051',
      category: 'Materials',
    ),
    CustomerPaymentTranche(
      id: 'trn_6',
      stageNumber: 6,
      stageTitle: 'Luxury Painting & Hardwood Decking (10%)',
      description: 'Asian Paints Royale Luxury Velvet matte painting and Brazilian Ipe hardwood balcony lounge decking.',
      amount: 250000.0,
      gstAmount: 45000.0,
      totalAmount: 295000.0,
      dueDate: '05 Nov 2026',
      status: PaymentTrancheStatus.upcoming,
      invoiceNumber: 'INV-2026-0060',
      category: 'Execution',
    ),
    CustomerPaymentTranche(
      id: 'trn_7',
      stageNumber: 7,
      stageTitle: 'Snagging Clearance & 10-Year Warranty Handover (10%)',
      description: 'Zero-snag sign-off certification, deep sanitization, ceremony key handover kit & legal warranty dossier.',
      amount: 125000.0,
      gstAmount: 22500.0,
      totalAmount: 147500.0,
      dueDate: '25 Nov 2026',
      status: PaymentTrancheStatus.upcoming,
      invoiceNumber: 'INV-2026-0072',
      category: 'Supervision',
    ),
  ];

  static final List<CustomerInvoice> invoices = [
    const CustomerInvoice(
      invoiceNumber: 'INV-2026-0042',
      title: 'Execution Milestone 02 — Electrical & Modular Carcass',
      issueDate: '12 Sep 2026',
      dueDate: '20 Sep 2026',
      stageName: 'Stage 05 Execution & Installation',
      taxableAmount: 75000.0,
      gstAmount: 13500.0,
      totalAmount: 88500.0,
      isPaid: false,
      pdfFileName: 'Tax_Invoice_HOM_INV_2026_0042.pdf',
      lineItems: [
        InvoiceLineItem(
          itemNo: 1,
          description: 'Finolex FR Flame Retardant 2.5 sq.mm electrical circuit conduits & wall grooving',
          quantity: 1,
          unit: 'Lot',
          rate: 45000.0,
          amount: 45000.0,
        ),
        InvoiceLineItem(
          itemNo: 2,
          description: 'Schneider Electric modular metal distribution back-boxes & MCB line setup',
          quantity: 12,
          unit: 'Units',
          rate: 1250.0,
          amount: 15000.0,
        ),
        InvoiceLineItem(
          itemNo: 3,
          description: 'Certified Greenply BWP 710 kitchen lower carcase carpentry fabrication prep',
          quantity: 1,
          unit: 'Lot',
          rate: 15000.0,
          amount: 15000.0,
        ),
      ],
    ),
    const CustomerInvoice(
      invoiceNumber: 'INV-2026-0035',
      title: 'Civil Demolition & Core MEP Rough-Ins (Stage 3)',
      issueDate: '08 Sep 2026',
      dueDate: '10 Sep 2026',
      stageName: 'Stage 04 Procurement & Civil Prep',
      taxableAmount: 700000.0,
      gstAmount: 126000.0,
      totalAmount: 826000.0,
      isPaid: true,
      pdfFileName: 'Tax_Invoice_HOM_INV_2026_0035.pdf',
      lineItems: [
        InvoiceLineItem(
          itemNo: 1,
          description: 'Civil kitchen partition wall dismantling, rubble clearing & floor leveling',
          quantity: 1,
          unit: 'Lot',
          rate: 350000.0,
          amount: 350000.0,
        ),
        InvoiceLineItem(
          itemNo: 2,
          description: 'Astral CPVC core water inlet/drainage pipes with 10-bar pressure certification',
          quantity: 1,
          unit: 'Lot',
          rate: 350000.0,
          amount: 350000.0,
        ),
      ],
    ),
    const CustomerInvoice(
      invoiceNumber: 'INV-2026-0028',
      title: '3D Concept Design & Turnkey BOQ Sign-Off',
      issueDate: '01 Sep 2026',
      dueDate: '05 Sep 2026',
      stageName: 'Stage 02 3D Designs & Blueprints',
      taxableAmount: 250000.0,
      gstAmount: 45000.0,
      totalAmount: 295000.0,
      isPaid: true,
      pdfFileName: 'Tax_Invoice_HOM_INV_2026_0028.pdf',
      lineItems: [
        InvoiceLineItem(
          itemNo: 1,
          description: 'Full residence 4K photorealistic 3D architectural render suite (Living, Kitchen, Master Suite)',
          quantity: 1,
          unit: 'Dossier',
          rate: 150000.0,
          amount: 150000.0,
        ),
        InvoiceLineItem(
          itemNo: 2,
          description: 'Detailed CAD architectural construction drawings, MEP routes & contract BOQ schedules',
          quantity: 1,
          unit: 'Dossier',
          rate: 100000.0,
          amount: 100000.0,
        ),
      ],
    ),
  ];

  static final List<CustomerPaymentReceipt> paymentReceipts = [
    const CustomerPaymentReceipt(
      receiptId: 'REC-2026-0084-03',
      paymentId: 'HOM-TXN-2026-0910-8402',
      amount: 826000.0,
      paidDate: '10 Sep 2026, 02:15 PM',
      paymentMethod: 'Instant UPI (HDFC Bank)',
      transactionRef: 'UPI/229048291048/HOMIO_CORP',
      trancheTitle: 'Civil Demolition & Core MEP Rough-Ins',
    ),
    const CustomerPaymentReceipt(
      receiptId: 'REC-2026-0084-02',
      paymentId: 'HOM-TXN-2026-0905-1483',
      amount: 295000.0,
      paidDate: '05 Sep 2026, 11:40 AM',
      paymentMethod: 'NEFT / Net Banking (ICICI Bank)',
      transactionRef: 'NEFT/ICIC2026090500192',
      trancheTitle: '3D Photorealistic Concept & Detailed BOQ',
    ),
    const CustomerPaymentReceipt(
      receiptId: 'REC-2026-0084-01',
      paymentId: 'HOM-TXN-2026-0815-9921',
      amount: 177000.0,
      paidDate: '15 Aug 2026, 04:30 PM',
      paymentMethod: 'Credit Card (Visa Signature)',
      transactionRef: 'AUTH_89104910284',
      trancheTitle: 'Booking & Architecture Advance',
    ),
  ];

  static void payTranche(String trancheId, String paymentMethod) {
    for (final trn in paymentTranches) {
      if (trn.id == trancheId) {
        trn.status = PaymentTrancheStatus.paid;
        trn.paidDate = 'Today, Just now';
        trn.transactionRef = 'HOM-TXN-${DateTime.now().millisecondsSinceEpoch}';

        paymentReceipts.insert(
          0,
          CustomerPaymentReceipt(
            receiptId: 'REC-2026-0084-${paymentReceipts.length + 1}',
            paymentId: trn.transactionRef!,
            amount: trn.totalAmount,
            paidDate: 'Today, Just now',
            paymentMethod: paymentMethod,
            transactionRef: trn.transactionRef!,
            trancheTitle: trn.stageTitle,
          ),
        );

        activeProject.activityLog.insert(
          0,
          CustomerActivityItem(
            id: 'act_${DateTime.now().millisecondsSinceEpoch}',
            timestamp: 'Today, Just now',
            relativeTime: 'Just now',
            title: 'Payment of ₹${trn.totalAmount.toInt()} Received',
            description: 'Payment for "${trn.stageTitle}" processed via $paymentMethod. Tax receipt generated.',
            stage: 'Billing & Commercials',
            actor: 'Amit Kumar (You)',
            icon: Icons.check_circle_rounded,
            iconColor: const Color(0xFF10B981),
          ),
        );
        break;
      }
    }

    stateVersionNotifier.value++;
  }

  // ============================================================================
  // 19. MATERIALS REPOSITORY DATA & ACTIONS
  // ============================================================================

  static final List<CustomerMaterialItem> projectMaterials = [
    CustomerMaterialItem(
      id: 'mat_1',
      name: 'CenturyPly Club Prime BWP Plywood 18mm',
      brand: 'CenturyPly',
      category: 'Wood / Plywood',
      specification: '18mm BWP Marine Grade IS:710, Boiling Water Proof & Termite Resistant with 30-Year Guarantee',
      finish: 'Calibrated Smooth Core',
      quantity: 24.0,
      unit: 'Sheets',
      projectArea: 'Modular Kitchen Carcass',
      stage: '05 Execution',
      status: 'Pending Approval',
      imageGradientStart: const Color(0xFF78350F),
      imageGradientEnd: const Color(0xFF451A03),
      isApprovalRequired: true,
      orderTimeline: const [
        MaterialTimelineStep(title: 'Requested by Designer', timestamp: '08 Sep 2026', isCompleted: true),
        MaterialTimelineStep(title: 'Vendor Selected (Greenlam Central)', timestamp: '10 Sep 2026', isCompleted: true),
        MaterialTimelineStep(title: 'Pending Client Sign-Off', timestamp: 'Active', isCompleted: false, isCurrent: true),
        MaterialTimelineStep(title: 'Dispatch from Warehouse', isCompleted: false),
        MaterialTimelineStep(title: 'Site Delivery & Stacking', isCompleted: false),
      ],
      expectedDelivery: '18 Sep 2026',
      vendorName: 'Greenply Authorised Regional Depot, Dhanbad',
      notes: 'Requires client sign-off on 18mm thickness specification before delivery dispatch.',
    ),
    CustomerMaterialItem(
      id: 'mat_2',
      name: 'Italian Statuario Marble Slabs 20mm',
      brand: 'A-Class Marble',
      category: 'Tiles & Marble',
      specification: '20mm Mirror Polished Italian Statuario book-matched natural marble slabs with grey veining',
      finish: 'Mirror High-Gloss Finish',
      quantity: 350.0,
      unit: 'sq.ft',
      projectArea: 'Living Room & Dining Foyer',
      stage: '04 Procurement',
      status: 'Ordered',
      imageGradientStart: const Color(0xFF334155),
      imageGradientEnd: const Color(0xFF0F172A),
      isApprovalRequired: false,
      orderTimeline: const [
        MaterialTimelineStep(title: 'Requested by Designer', timestamp: '24 Aug 2026', isCompleted: true),
        MaterialTimelineStep(title: 'Client Approved', timestamp: '28 Aug 2026', isCompleted: true),
        MaterialTimelineStep(title: 'Ordered from Italian Quarry Depot', timestamp: '02 Sep 2026', isCompleted: true),
        MaterialTimelineStep(title: 'Dispatched (In Transit to Dhanbad)', timestamp: '11 Sep 2026', isCompleted: true, isCurrent: true),
        MaterialTimelineStep(title: 'Site Delivery & Polishing Prep', isCompleted: false),
      ],
      expectedDelivery: '22 Sep 2026',
      vendorName: 'A-Class Marble International',
    ),
    CustomerMaterialItem(
      id: 'mat_3',
      name: 'Hafele Soft-Close Tandem Drawer Systems',
      brand: 'Hafele',
      category: 'Hardware & Fittings',
      specification: 'Matrix Box S35 luxury undermount drawer slides with integrated silent soft-close dampeners (35kg rating)',
      finish: 'Anthracite Metallic',
      quantity: 14.0,
      unit: 'Sets',
      projectArea: 'Modular Kitchen Drawers',
      stage: '05 Execution',
      status: 'Dispatched',
      imageGradientStart: const Color(0xFF1E293B),
      imageGradientEnd: const Color(0xFF0F172A),
      orderTimeline: const [
        MaterialTimelineStep(title: 'Requested by Designer', timestamp: '01 Sep 2026', isCompleted: true),
        MaterialTimelineStep(title: 'Client Approved', timestamp: '05 Sep 2026', isCompleted: true),
        MaterialTimelineStep(title: 'Ordered from Hafele India', timestamp: '07 Sep 2026', isCompleted: true),
        MaterialTimelineStep(title: 'Dispatched via BlueDart Express', timestamp: '11 Sep 2026', isCompleted: true, isCurrent: true),
        MaterialTimelineStep(title: 'Site Delivery', isCompleted: false),
      ],
      expectedDelivery: '16 Sep 2026',
      vendorName: 'Hafele Direct Corporate Channel',
    ),
    CustomerMaterialItem(
      id: 'mat_4',
      name: 'Finolex FR Flame Retardant Copper Wires',
      brand: 'Finolex',
      category: 'Electrical & Lighting',
      specification: '1.5 sq.mm & 2.5 sq.mm multi-strand electrolytic copper wire with flame retardant PVC insulation (IS:694)',
      finish: 'Industrial Standard',
      quantity: 12.0,
      unit: 'Coils',
      projectArea: 'Full Residence Circuits',
      stage: '05 Execution',
      status: 'Delivered',
      imageGradientStart: const Color(0xFF1E3A8A),
      imageGradientEnd: const Color(0xFF172554),
      orderTimeline: const [
        MaterialTimelineStep(title: 'Requested by Engineer', timestamp: '20 Aug 2026', isCompleted: true),
        MaterialTimelineStep(title: 'Approved by Client', timestamp: '22 Aug 2026', isCompleted: true),
        MaterialTimelineStep(title: 'Ordered & Billed', timestamp: '25 Aug 2026', isCompleted: true),
        MaterialTimelineStep(title: 'Dispatched', timestamp: '28 Aug 2026', isCompleted: true),
        MaterialTimelineStep(title: 'Delivered & Stored at Site', timestamp: '02 Sep 2026', isCompleted: true),
      ],
      actualDelivery: '02 Sep 2026',
      vendorName: 'Finolex Regional Authorized Distributor',
    ),
    CustomerMaterialItem(
      id: 'mat_5',
      name: 'Asian Paints Royale Luxury Velvet Emulsion',
      brand: 'Asian Paints',
      category: 'Luxury Paint',
      specification: 'Royale Luxury Interior Velvet Matte Emulsion with Teflon Surface Protector and anti-bacterial formulation',
      finish: 'Velvet Matte Sheen',
      quantity: 40.0,
      unit: 'Litres',
      projectArea: 'All Bedrooms & Living Lounge',
      stage: '05 Execution',
      status: 'Suggested',
      imageGradientStart: const Color(0xFF831843),
      imageGradientEnd: const Color(0xFF500724),
      orderTimeline: const [
        MaterialTimelineStep(title: 'Suggested in 3D Color Palette', timestamp: '10 Sep 2026', isCompleted: true, isCurrent: true),
        MaterialTimelineStep(title: 'Physical Shade Swatch Card Review', isCompleted: false),
        MaterialTimelineStep(title: 'Client Sign-Off', isCompleted: false),
        MaterialTimelineStep(title: 'Order & Tinting', isCompleted: false),
        MaterialTimelineStep(title: 'Site Delivery', isCompleted: false),
      ],
      notes: 'Shade swatches #L122 Morning Mist and #N402 Smoked Sand to be verified during Friday meeting.',
    ),
    CustomerMaterialItem(
      id: 'mat_6',
      name: 'Saint-Gobain Gyproc False Ceiling GI Channel Grid',
      brand: 'Saint-Gobain',
      category: 'False Ceiling',
      specification: 'Corrosion resistant galvanized steel perimeter channel grid (0.5mm BMT) with knurled ceiling sections',
      finish: 'Galvanized Zinc Coated',
      quantity: 80.0,
      unit: 'Lengths',
      projectArea: 'Living, Dining & Master Bedroom',
      stage: '05 Execution',
      status: 'Approved',
      imageGradientStart: const Color(0xFF14532D),
      imageGradientEnd: const Color(0xFF052E16),
      orderTimeline: const [
        MaterialTimelineStep(title: 'Requested by PM', timestamp: '02 Sep 2026', isCompleted: true),
        MaterialTimelineStep(title: 'Client Approved', timestamp: '05 Sep 2026', isCompleted: true),
        MaterialTimelineStep(title: 'Ordered from Gyproc', timestamp: '08 Sep 2026', isCompleted: true),
        MaterialTimelineStep(title: 'Dispatched to Site', timestamp: '11 Sep 2026', isCompleted: true, isCurrent: true),
        MaterialTimelineStep(title: 'Site Delivery & Channel Fixing', isCompleted: false),
      ],
      expectedDelivery: '15 Sep 2026',
      vendorName: 'Saint-Gobain Gyproc Direct',
    ),
  ];

  static void approveMaterial(String materialId) {
    for (final m in projectMaterials) {
      if (m.id == materialId) {
        m.status = 'Approved';
        m.isApprovalRequired = false;

        activeProject.activityLog.insert(
          0,
          CustomerActivityItem(
            id: 'act_${DateTime.now().millisecondsSinceEpoch}',
            timestamp: 'Today, Just now',
            relativeTime: 'Just now',
            title: 'Material Approved: ${m.name}',
            description: 'Approved for site fabrication and warehouse dispatch.',
            stage: m.stage,
            actor: 'Amit Kumar (You)',
            icon: Icons.verified_rounded,
            iconColor: const Color(0xFF10B981),
          ),
        );
        break;
      }
    }

    stateVersionNotifier.value++;
  }

  static void requestMaterialChange(String materialId, String reason, String notes) {
    for (final m in projectMaterials) {
      if (m.id == materialId) {
        m.status = 'Suggested';
        m.isApprovalRequired = false;

        activeProject.activityLog.insert(
          0,
          CustomerActivityItem(
            id: 'act_${DateTime.now().millisecondsSinceEpoch}',
            timestamp: 'Today, Just now',
            relativeTime: 'Just now',
            title: 'Change Requested on ${m.name}',
            description: '$reason: $notes. Procurement lead Amitabh Sen notified.',
            stage: m.stage,
            actor: 'Amit Kumar (You)',
            icon: Icons.edit_note_rounded,
            iconColor: const Color(0xFFF59E0B),
          ),
        );
        break;
      }
    }

    stateVersionNotifier.value++;
  }

  static void submitMaterialRequest({
    required String name,
    required String category,
    required double quantity,
    required String unit,
    required String projectArea,
    String? preferredBrand,
    String? notes,
  }) {
    projectMaterials.insert(
      0,
      CustomerMaterialItem(
        id: 'mat_${DateTime.now().millisecondsSinceEpoch}',
        name: name,
        brand: preferredBrand ?? 'Client Requested Brand',
        category: category,
        specification: 'Homeowner specified material request. Under review with design team.',
        finish: 'Per Approved Specification',
        quantity: quantity,
        unit: unit,
        projectArea: projectArea,
        stage: '05 Execution',
        status: 'Suggested',
        imageGradientStart: const Color(0xFF4F46E5),
        imageGradientEnd: const Color(0xFF312E81),
        isApprovalRequired: false,
        orderTimeline: const [
          MaterialTimelineStep(title: 'Requested by Homeowner', timestamp: 'Today', isCompleted: true, isCurrent: true),
          MaterialTimelineStep(title: 'Procurement Feasibility Review', isCompleted: false),
          MaterialTimelineStep(title: 'Rate Quotation', isCompleted: false),
        ],
        notes: notes,
      ),
    );

    activeProject.activityLog.insert(
      0,
      CustomerActivityItem(
        id: 'act_${DateTime.now().millisecondsSinceEpoch}',
        timestamp: 'Today, Just now',
        relativeTime: 'Just now',
        title: 'Material Request Submitted: $name',
        description: 'Quantity: $quantity $unit for $projectArea.',
        stage: '05 Execution',
        actor: 'Amit Kumar (You)',
        icon: Icons.add_shopping_cart_rounded,
        iconColor: const Color(0xFF6366F1),
      ),
    );

    stateVersionNotifier.value++;
  }

  // ============================================================================
  // 20. COMPLAINTS & SUPPORT REPOSITORY DATA & ACTIONS
  // ============================================================================

  static final List<CustomerComplaint> complaints = [
    CustomerComplaint(
      id: 'CMP-2026-0048',
      title: 'Kitchen Lower Carcase Alignment Tolerance',
      category: 'Execution & Workmanship',
      priority: 'Medium',
      status: 'In Progress',
      createdDate: '10 Sep 2026',
      lastUpdated: 'Today, 09:30 AM',
      relatedStage: 'Stage 05 Execution',
      relatedRoom: 'Modular Kitchen',
      description: 'The bottom left cabinet door adjacent to the dishwasher niche has a 3mm uneven gap and does not close completely flush with the surrounding carcase frame.',
      attachments: const [
        ComplaintAttachment(name: 'Kitchen_Hinge_Gap_Photo_01.jpg', type: 'photo', size: '2.8 MB'),
        ComplaintAttachment(name: 'Kitchen_Hinge_Gap_Photo_02.jpg', type: 'photo', size: '3.1 MB'),
      ],
      assignedContactName: 'Amit Verma',
      assignedContactRole: 'Site Execution Supervisor',
      activityLog: [
        const ComplaintActivityItem(timestamp: '10 Sep, 02:00 PM', actor: 'Amit Kumar', action: 'Ticket Raised', note: 'Issue submitted with 2 photo attachments.'),
        const ComplaintActivityItem(timestamp: '10 Sep, 03:30 PM', actor: 'Homio Care', action: 'Assigned', note: 'Assigned to Site Execution Supervisor Amit Verma.'),
        const ComplaintActivityItem(timestamp: '11 Sep, 11:00 AM', actor: 'Amit Verma', action: 'Site Inspection', note: 'Hinge mounting screws checked on site. Carpenter team scheduled to re-align on Thursday with zero extra charge.'),
      ],
      messages: [
        const ComplaintMessageItem(
          id: 'cmsg_1',
          author: 'Amit Verma',
          role: 'Site Supervisor',
          timestamp: '11 Sep, 11:15 AM',
          text: 'Hi Amit, I personally inspected the kitchen corner hinge today. The soft-close plate needs an adjustment offset of 2.5mm. Our master carpenter will correct this during Thursday joinery fitting.',
        ),
        const ComplaintMessageItem(
          id: 'cmsg_2',
          author: 'Amit Kumar',
          role: 'Homeowner',
          timestamp: '11 Sep, 02:30 PM',
          text: 'Thank you Amit Verma. Please ensure the magnetic catch is also tested once adjusted.',
          isClient: true,
        ),
      ],
    ),
    CustomerComplaint(
      id: 'CMP-2026-0039',
      title: 'Balcony Deck Drainage Water Slope Adjustment',
      category: 'Execution & Workmanship',
      priority: 'High',
      status: 'Resolved',
      createdDate: '28 Aug 2026',
      lastUpdated: '02 Sep 2026',
      relatedStage: 'Stage 04 Civil Prep',
      relatedRoom: 'Balcony Deck',
      description: 'Minor rainwater accumulation noticed near outer railing corner following monsoon shower. Water was draining slowly toward the drain spout.',
      attachments: const [
        ComplaintAttachment(name: 'Balcony_Water_Puddle_28Aug.jpg', type: 'photo', size: '1.9 MB'),
      ],
      assignedContactName: 'Amit Verma',
      assignedContactRole: 'Site Execution Supervisor',
      resolutionNotes: 'Civil masonry team dismantled outer tile edge, re-laid mortar gradient with a 1:50 drop toward the primary drain trap, and re-waterproofed with Dr. Fixit 101. Tested with 50-litre flood test with zero pooling.',
      resolvedDate: '02 Sep 2026',
      ratingScore: 5,
      feedbackComments: 'Resolved quickly within 48 hours! The water now drains smoothly during heavy rain.',
      activityLog: [
        const ComplaintActivityItem(timestamp: '28 Aug, 05:00 PM', actor: 'Amit Kumar', action: 'Ticket Raised', note: 'Drainage pooling reported.'),
        const ComplaintActivityItem(timestamp: '29 Aug, 09:00 AM', actor: 'Amit Verma', action: 'Inspected', note: 'Slope corrected with masonry team.'),
        const ComplaintActivityItem(timestamp: '02 Sep, 12:00 PM', actor: 'Amit Kumar', action: 'Resolution Verified', note: 'Customer rated 5-stars and closed ticket.'),
      ],
      messages: [],
    ),
    CustomerComplaint(
      id: 'CMP-2026-0021',
      title: 'Living Room 3D Accent Wall Fluted Texture Tone',
      category: 'Design & Aesthetics',
      priority: 'Low',
      status: 'Resolved',
      createdDate: '18 Aug 2026',
      lastUpdated: '20 Aug 2026',
      relatedStage: 'Stage 02 3D Design',
      relatedRoom: 'Living Room',
      description: 'Requested darker fluted walnut finish instead of light oak shown in initial 3D render draft v1.',
      assignedContactName: 'Priya Mehta',
      assignedContactRole: 'Senior Interior Designer',
      resolutionNotes: 'Updated 3D CAD shader with Italian Smoked Fluted Walnut (#WN-402) and re-rendered in 4K UHD. Approved as Revision v2.',
      resolvedDate: '20 Aug 2026',
      ratingScore: 5,
      feedbackComments: 'Priya updated this within 24 hours. The dark walnut tone looks spectacular!',
      activityLog: [
        const ComplaintActivityItem(timestamp: '18 Aug', actor: 'Amit Kumar', action: 'Change Requested', note: 'Dark walnut preference expressed.'),
        const ComplaintActivityItem(timestamp: '20 Aug', actor: 'Priya Mehta', action: 'Render Updated', note: 'Uploaded 3D Revision v2.'),
      ],
      messages: [],
    ),
  ];

  static void raiseComplaint({
    required String title,
    required String category,
    required String description,
    required String priority,
    String? relatedStage,
    String? relatedRoom,
  }) {
    final newId = 'CMP-2026-00${complaints.length + 50}';

    complaints.insert(
      0,
      CustomerComplaint(
        id: newId,
        title: title,
        category: category,
        priority: priority,
        status: 'Open',
        createdDate: 'Today, Just now',
        lastUpdated: 'Today, Just now',
        relatedStage: relatedStage,
        relatedRoom: relatedRoom,
        description: description,
        assignedContactName: 'Amit Verma',
        assignedContactRole: 'Site Execution Supervisor',
        activityLog: [
          ComplaintActivityItem(
            timestamp: 'Today, Just now',
            actor: 'Amit Kumar (You)',
            action: 'Ticket Raised',
            note: 'Ticket submitted under 48-Hour SLA guarantee.',
          ),
        ],
        messages: [],
      ),
    );

    activeProject.activityLog.insert(
      0,
      CustomerActivityItem(
        id: 'act_${DateTime.now().millisecondsSinceEpoch}',
        timestamp: 'Today, Just now',
        relativeTime: 'Just now',
        title: 'Support Ticket Raised: $title',
        description: 'Priority: $priority. Category: $category. Assigned to supervisor Amit Verma.',
        stage: relatedStage ?? '05 Execution',
        actor: 'Amit Kumar (You)',
        icon: Icons.support_agent_rounded,
        iconColor: const Color(0xFFEF4444),
      ),
    );

    stateVersionNotifier.value++;
  }

  static void submitComplaintFeedback(String complaintId, int rating, String feedback) {
    for (final c in complaints) {
      if (c.id == complaintId) {
        c.ratingScore = rating;
        c.feedbackComments = feedback;
        c.status = 'Resolved';
        c.lastUpdated = 'Today, Just now';
        break;
      }
    }
    stateVersionNotifier.value++;
  }

  static void reopenComplaint(String complaintId, String reason) {
    for (final c in complaints) {
      if (c.id == complaintId) {
        c.status = 'Reopened';
        c.lastUpdated = 'Today, Just now';
        c.activityLog.insert(
          0,
          ComplaintActivityItem(
            timestamp: 'Today, Just now',
            actor: 'Amit Kumar (You)',
            action: 'Ticket Reopened',
            note: 'Reason: $reason',
          ),
        );
        break;
      }
    }
    stateVersionNotifier.value++;
  }

  static void sendComplaintMessage(String complaintId, String text) {
    for (final c in complaints) {
      if (c.id == complaintId) {
        c.messages.add(
          ComplaintMessageItem(
            id: 'cmsg_${DateTime.now().millisecondsSinceEpoch}',
            author: 'Amit Kumar',
            role: 'Homeowner',
            timestamp: 'Today, Just now',
            text: text,
            isClient: true,
          ),
        );
        c.lastUpdated = 'Today, Just now';
        break;
      }
    }
    stateVersionNotifier.value++;
  }
}
