import 'package:flutter/material.dart';

// ============================================================================
// ENUMS FOR AFTER-SALES LIFECYCLE
// ============================================================================

enum ServiceCategory {
  carpentry,
  electrical,
  plumbing,
  civil,
  furniture,
  hardware,
  finishSurface,
  installation,
  other;

  String get label {
    switch (this) {
      case ServiceCategory.carpentry:
        return 'Carpentry & Modular Fitments';
      case ServiceCategory.electrical:
        return 'Electrical & MEP';
      case ServiceCategory.plumbing:
        return 'Plumbing & Sanitary';
      case ServiceCategory.civil:
        return 'Civil & Masonry';
      case ServiceCategory.furniture:
        return 'Furniture & Upholstery';
      case ServiceCategory.hardware:
        return 'Hardware & Architectural Fittings';
      case ServiceCategory.finishSurface:
        return 'Paint, Polish & Surface Finishes';
      case ServiceCategory.installation:
        return 'Appliance & Fixture Installation';
      case ServiceCategory.other:
        return 'General / Miscellaneous';
    }
  }

  IconData get icon {
    switch (this) {
      case ServiceCategory.carpentry:
        return Icons.carpenter_outlined;
      case ServiceCategory.electrical:
        return Icons.electric_bolt_outlined;
      case ServiceCategory.plumbing:
        return Icons.plumbing_outlined;
      case ServiceCategory.civil:
        return Icons.foundation_outlined;
      case ServiceCategory.furniture:
        return Icons.chair_outlined;
      case ServiceCategory.hardware:
        return Icons.build_circle_outlined;
      case ServiceCategory.finishSurface:
        return Icons.format_paint_outlined;
      case ServiceCategory.installation:
        return Icons.home_repair_service_outlined;
      case ServiceCategory.other:
        return Icons.miscellaneous_services_outlined;
    }
  }

  Color get color {
    switch (this) {
      case ServiceCategory.carpentry:
        return const Color(0xFFD97706);
      case ServiceCategory.electrical:
        return const Color(0xFFF59E0B);
      case ServiceCategory.plumbing:
        return const Color(0xFF0284C7);
      case ServiceCategory.civil:
        return const Color(0xFF78716C);
      case ServiceCategory.furniture:
        return const Color(0xFF8B5CF6);
      case ServiceCategory.hardware:
        return const Color(0xFF475569);
      case ServiceCategory.finishSurface:
        return const Color(0xFFEC4899);
      case ServiceCategory.installation:
        return const Color(0xFF10B981);
      case ServiceCategory.other:
        return const Color(0xFF6B7280);
    }
  }

  String get displayName => label;
}

// Backward compatibility alias
typedef SnagCategory = ServiceCategory;

enum ServicePriority {
  low,
  normal,
  medium,
  high,
  urgent,
  critical;

  String get label {
    switch (this) {
      case ServicePriority.low:
        return 'Low (7d SLA)';
      case ServicePriority.normal:
      case ServicePriority.medium:
        return 'Normal (48h SLA)';
      case ServicePriority.high:
        return 'High (24h SLA)';
      case ServicePriority.urgent:
        return 'Urgent (12h SLA)';
      case ServicePriority.critical:
        return 'Critical (4h Emergency SLA)';
    }
  }

  Color get color {
    switch (this) {
      case ServicePriority.low:
        return const Color(0xFF6B7280);
      case ServicePriority.normal:
      case ServicePriority.medium:
        return const Color(0xFF3B82F6);
      case ServicePriority.high:
        return const Color(0xFFF59E0B);
      case ServicePriority.urgent:
        return const Color(0xFFEA580C);
      case ServicePriority.critical:
        return const Color(0xFFDC2626);
    }
  }

  Duration get slaDuration {
    switch (this) {
      case ServicePriority.low:
        return const Duration(days: 7);
      case ServicePriority.normal:
      case ServicePriority.medium:
        return const Duration(hours: 48);
      case ServicePriority.high:
        return const Duration(hours: 24);
      case ServicePriority.urgent:
        return const Duration(hours: 12);
      case ServicePriority.critical:
        return const Duration(hours: 4);
    }
  }

  String get displayName => label;
}

// Backward compatibility alias
typedef SnagPriority = ServicePriority;

enum ServiceRequestStatus {
  newRequest,
  acknowledged,
  assigned,
  scheduled,
  inProgress,
  waitingCustomer,
  waitingInternal,
  resolved,
  closed,
  cancelled,
  reopened;

  String get label {
    switch (this) {
      case ServiceRequestStatus.newRequest:
        return 'New Request';
      case ServiceRequestStatus.acknowledged:
        return 'Acknowledged';
      case ServiceRequestStatus.assigned:
        return 'Assigned';
      case ServiceRequestStatus.scheduled:
        return 'Visit Scheduled';
      case ServiceRequestStatus.inProgress:
        return 'In Progress';
      case ServiceRequestStatus.waitingCustomer:
        return 'Waiting on Customer';
      case ServiceRequestStatus.waitingInternal:
        return 'Waiting on Parts / Team';
      case ServiceRequestStatus.resolved:
        return 'Resolved';
      case ServiceRequestStatus.closed:
        return 'Closed';
      case ServiceRequestStatus.cancelled:
        return 'Cancelled';
      case ServiceRequestStatus.reopened:
        return 'Reopened';
    }
  }

  Color get color {
    switch (this) {
      case ServiceRequestStatus.newRequest:
        return const Color(0xFF3B82F6);
      case ServiceRequestStatus.acknowledged:
        return const Color(0xFF6366F1);
      case ServiceRequestStatus.assigned:
        return const Color(0xFF8B5CF6);
      case ServiceRequestStatus.scheduled:
        return const Color(0xFF0284C7);
      case ServiceRequestStatus.inProgress:
        return const Color(0xFFF59E0B);
      case ServiceRequestStatus.waitingCustomer:
        return const Color(0xFFEAB308);
      case ServiceRequestStatus.waitingInternal:
        return const Color(0xFFF97316);
      case ServiceRequestStatus.resolved:
        return const Color(0xFF10B981);
      case ServiceRequestStatus.closed:
        return const Color(0xFF059669);
      case ServiceRequestStatus.cancelled:
        return const Color(0xFF6B7280);
      case ServiceRequestStatus.reopened:
        return const Color(0xFFEF4444);
    }
  }
}

enum ComplaintSeverity {
  minor,
  moderate,
  severe,
  critical;

  String get label {
    switch (this) {
      case ComplaintSeverity.minor:
        return 'Minor Cosmetic Snag';
      case ComplaintSeverity.moderate:
        return 'Moderate Functional Defect';
      case ComplaintSeverity.severe:
        return 'Severe Project / Material Defect';
      case ComplaintSeverity.critical:
        return 'Critical Safety / Water Ingress';
    }
  }

  Color get color {
    switch (this) {
      case ComplaintSeverity.minor:
        return const Color(0xFF6B7280);
      case ComplaintSeverity.moderate:
        return const Color(0xFFF59E0B);
      case ComplaintSeverity.severe:
        return const Color(0xFFEA580C);
      case ComplaintSeverity.critical:
        return const Color(0xFFDC2626);
    }
  }
}

enum ComplaintStatus {
  raised,
  acknowledged,
  reviewed,
  assigned,
  inspectionRequired,
  workAssigned,
  inCorrection,
  internalVerification,
  customerConfirmation,
  resolved,
  closed,
  escalated;

  String get label {
    switch (this) {
      case ComplaintStatus.raised:
        return 'Complaint Raised';
      case ComplaintStatus.acknowledged:
        return 'Acknowledged';
      case ComplaintStatus.reviewed:
        return 'Under Review';
      case ComplaintStatus.assigned:
        return 'Assigned to Lead';
      case ComplaintStatus.inspectionRequired:
        return 'Inspection Visit Needed';
      case ComplaintStatus.workAssigned:
        return 'Correction Work Assigned';
      case ComplaintStatus.inCorrection:
        return 'Correction in Progress';
      case ComplaintStatus.internalVerification:
        return 'Pending Internal Sign-off';
      case ComplaintStatus.customerConfirmation:
        return 'Awaiting Customer Sign-off';
      case ComplaintStatus.resolved:
        return 'Resolved';
      case ComplaintStatus.closed:
        return 'Closed & Archived';
      case ComplaintStatus.escalated:
        return 'Escalated to Management';
    }
  }

  Color get color {
    switch (this) {
      case ComplaintStatus.raised:
        return const Color(0xFFEF4444);
      case ComplaintStatus.acknowledged:
        return const Color(0xFFF97316);
      case ComplaintStatus.reviewed:
        return const Color(0xFF8B5CF6);
      case ComplaintStatus.assigned:
        return const Color(0xFF3B82F6);
      case ComplaintStatus.inspectionRequired:
        return const Color(0xFFD97706);
      case ComplaintStatus.workAssigned:
        return const Color(0xFF0284C7);
      case ComplaintStatus.inCorrection:
        return const Color(0xFFF59E0B);
      case ComplaintStatus.internalVerification:
        return const Color(0xFF6366F1);
      case ComplaintStatus.customerConfirmation:
        return const Color(0xFFEAB308);
      case ComplaintStatus.resolved:
        return const Color(0xFF10B981);
      case ComplaintStatus.closed:
        return const Color(0xFF059669);
      case ComplaintStatus.escalated:
        return const Color(0xFF991B1B);
    }
  }
}

enum SnagItemStatus {
  identified,
  assigned,
  inProgress,
  pendingVerification,
  resolved,
  closed;

  String get label {
    switch (this) {
      case SnagItemStatus.identified:
        return 'Identified';
      case SnagItemStatus.assigned:
        return 'Assigned';
      case SnagItemStatus.inProgress:
        return 'In Progress';
      case SnagItemStatus.pendingVerification:
        return 'Pending Verification';
      case SnagItemStatus.resolved:
        return 'Resolved';
      case SnagItemStatus.closed:
        return 'Closed';
    }
  }

  Color get color {
    switch (this) {
      case SnagItemStatus.identified:
        return const Color(0xFFEF4444);
      case SnagItemStatus.assigned:
        return const Color(0xFF3B82F6);
      case SnagItemStatus.inProgress:
        return const Color(0xFFF59E0B);
      case SnagItemStatus.pendingVerification:
        return const Color(0xFF8B5CF6);
      case SnagItemStatus.resolved:
        return const Color(0xFF10B981);
      case SnagItemStatus.closed:
        return const Color(0xFF059669);
    }
  }
}

enum WarrantyCategory {
  structural10Yr,
  comprehensive1Yr,
  hardwareModular,
  surfacePUFinish,
  appliances;

  String get label {
    switch (this) {
      case WarrantyCategory.structural10Yr:
        return '10-Yr Structural & Waterproofing Warranty';
      case WarrantyCategory.comprehensive1Yr:
        return '1-Yr Comprehensive Fitment Warranty';
      case WarrantyCategory.hardwareModular:
        return '5-Yr Modular Hardware & Hinges Warranty';
      case WarrantyCategory.surfacePUFinish:
        return '2-Yr PU Paint & Polish Finish Warranty';
      case WarrantyCategory.appliances:
        return 'OEM Appliance Warranty';
    }
  }
}

enum WarrantyStatus {
  notStarted,
  active,
  active1YrComprehensive,
  expiringSoon,
  expired,
  claimRaised,
  claimUnderReview,
  approved,
  rejected,
  closed;

  String get label {
    switch (this) {
      case WarrantyStatus.notStarted:
        return 'Not Started';
      case WarrantyStatus.active:
      case WarrantyStatus.active1YrComprehensive:
        return 'Active Coverage';
      case WarrantyStatus.expiringSoon:
        return 'Expiring Soon (< 30 Days)';
      case WarrantyStatus.expired:
        return 'Warranty Expired';
      case WarrantyStatus.claimRaised:
        return 'Claim Raised';
      case WarrantyStatus.claimUnderReview:
        return 'Claim Under Review';
      case WarrantyStatus.approved:
        return 'Claim Approved';
      case WarrantyStatus.rejected:
        return 'Claim Rejected';
      case WarrantyStatus.closed:
        return 'Closed';
    }
  }

  String get displayName => label;

  bool get isCovered =>
      this == WarrantyStatus.active ||
      this == WarrantyStatus.active1YrComprehensive ||
      this == WarrantyStatus.expiringSoon ||
      this == WarrantyStatus.claimRaised ||
      this == WarrantyStatus.claimUnderReview ||
      this == WarrantyStatus.approved;

  Color get color {
    switch (this) {
      case WarrantyStatus.notStarted:
        return const Color(0xFF6B7280);
      case WarrantyStatus.active:
      case WarrantyStatus.active1YrComprehensive:
        return const Color(0xFF10B981);
      case WarrantyStatus.expiringSoon:
        return const Color(0xFFF59E0B);
      case WarrantyStatus.expired:
        return const Color(0xFF6B7280);
      case WarrantyStatus.claimRaised:
        return const Color(0xFF3B82F6);
      case WarrantyStatus.claimUnderReview:
        return const Color(0xFF8B5CF6);
      case WarrantyStatus.approved:
        return const Color(0xFF059669);
      case WarrantyStatus.rejected:
        return const Color(0xFFEF4444);
      case WarrantyStatus.closed:
        return const Color(0xFF9CA3AF);
    }
  }
}

enum ServiceVisitStatus {
  requested,
  scheduled,
  confirmed,
  enRoute,
  checkedIn,
  inProgress,
  completed,
  rescheduled,
  cancelled,
  noShow;

  String get label {
    switch (this) {
      case ServiceVisitStatus.requested:
        return 'Requested';
      case ServiceVisitStatus.scheduled:
        return 'Scheduled';
      case ServiceVisitStatus.confirmed:
        return 'Customer Confirmed';
      case ServiceVisitStatus.enRoute:
        return 'Technician En Route';
      case ServiceVisitStatus.checkedIn:
        return 'Checked In on Site';
      case ServiceVisitStatus.inProgress:
        return 'Work In Progress';
      case ServiceVisitStatus.completed:
        return 'Visit Completed';
      case ServiceVisitStatus.rescheduled:
        return 'Rescheduled';
      case ServiceVisitStatus.cancelled:
        return 'Cancelled';
      case ServiceVisitStatus.noShow:
        return 'Customer / Tech No Show';
    }
  }

  Color get color {
    switch (this) {
      case ServiceVisitStatus.requested:
        return const Color(0xFF6B7280);
      case ServiceVisitStatus.scheduled:
        return const Color(0xFF3B82F6);
      case ServiceVisitStatus.confirmed:
        return const Color(0xFF6366F1);
      case ServiceVisitStatus.enRoute:
        return const Color(0xFFF59E0B);
      case ServiceVisitStatus.checkedIn:
        return const Color(0xFF0284C7);
      case ServiceVisitStatus.inProgress:
        return const Color(0xFFD97706);
      case ServiceVisitStatus.completed:
        return const Color(0xFF10B981);
      case ServiceVisitStatus.rescheduled:
        return const Color(0xFFEAB308);
      case ServiceVisitStatus.cancelled:
        return const Color(0xFF9CA3AF);
      case ServiceVisitStatus.noShow:
        return const Color(0xFFEF4444);
    }
  }
}

enum VisitType {
  inspection,
  diagnosis,
  correctiveRepair,
  warrantyService,
  routineMaintenance,
  finalSignOff;

  String get label {
    switch (this) {
      case VisitType.inspection:
        return 'Initial Inspection';
      case VisitType.diagnosis:
        return 'Technical Diagnosis';
      case VisitType.correctiveRepair:
        return 'Corrective Repair Work';
      case VisitType.warrantyService:
        return 'Warranty Replacement';
      case VisitType.routineMaintenance:
        return 'Preventative Maintenance';
      case VisitType.finalSignOff:
        return 'Supervisor Final Sign-off';
    }
  }
}

enum FollowUpType {
  postHandoverCheckin,
  serviceFollowUp,
  complaintFollowUp,
  warrantyFollowUp,
  feedbackRequest,
  satisfactionCheck,
  repeatServiceOpportunity,
  maintenanceReminder,
  projectAnniversary,
  generalCall;

  String get label {
    switch (this) {
      case FollowUpType.postHandoverCheckin:
        return '30-Day Post-Handover Check-in';
      case FollowUpType.serviceFollowUp:
        return 'Post-Service Resolution Follow-up';
      case FollowUpType.complaintFollowUp:
        return 'Escalated Complaint Check';
      case FollowUpType.warrantyFollowUp:
        return 'Warranty Expiry Advisory';
      case FollowUpType.feedbackRequest:
        return 'CSAT Feedback & Google Review Call';
      case FollowUpType.satisfactionCheck:
        return 'Quarterly Relationship Touchpoint';
      case FollowUpType.repeatServiceOpportunity:
        return 'Expansion / Repeat Service Pitch';
      case FollowUpType.maintenanceReminder:
        return 'Annual Maintenance Contract (AMC) Reminder';
      case FollowUpType.projectAnniversary:
        return '1-Year Project Handover Anniversary';
      case FollowUpType.generalCall:
        return 'General Courtesy Call';
    }
  }
}

enum FollowUpOutcome {
  connected,
  noAnswer,
  callbackRequested,
  resolved,
  interested,
  notInterested,
  complaintRaised,
  serviceRequired,
  feedbackGiven,
  followUpRequired,
  wrongNumber;

  String get label {
    switch (this) {
      case FollowUpOutcome.connected:
        return 'Connected & Satisfied';
      case FollowUpOutcome.noAnswer:
        return 'No Answer / Unreachable';
      case FollowUpOutcome.callbackRequested:
        return 'Callback Requested';
      case FollowUpOutcome.resolved:
        return 'Issue Resolved Successfully';
      case FollowUpOutcome.interested:
        return 'Interested in Repeat Service / AMC';
      case FollowUpOutcome.notInterested:
        return 'Not Interested';
      case FollowUpOutcome.complaintRaised:
        return 'New Complaint Logged';
      case FollowUpOutcome.serviceRequired:
        return 'Service Request Created';
      case FollowUpOutcome.feedbackGiven:
        return 'Feedback & Review Captured';
      case FollowUpOutcome.followUpRequired:
        return 'Further Follow-up Scheduled';
      case FollowUpOutcome.wrongNumber:
        return 'Wrong Number / Disconnected';
    }
  }

  Color get color {
    switch (this) {
      case FollowUpOutcome.connected:
      case FollowUpOutcome.resolved:
      case FollowUpOutcome.feedbackGiven:
        return const Color(0xFF10B981);
      case FollowUpOutcome.interested:
        return const Color(0xFF3B82F6);
      case FollowUpOutcome.callbackRequested:
      case FollowUpOutcome.followUpRequired:
        return const Color(0xFFF59E0B);
      case FollowUpOutcome.noAnswer:
      case FollowUpOutcome.notInterested:
        return const Color(0xFF6B7280);
      case FollowUpOutcome.complaintRaised:
      case FollowUpOutcome.serviceRequired:
      case FollowUpOutcome.wrongNumber:
        return const Color(0xFFEF4444);
    }
  }
}

enum BillingStatus {
  warrantyCovered,
  freeService,
  chargeable,
  partiallyChargeable,
  pendingCommercialApproval;

  String get label {
    switch (this) {
      case BillingStatus.warrantyCovered:
        return '100% Warranty Covered (₹0)';
      case BillingStatus.freeService:
        return 'Complimentary Goodwill Service (₹0)';
      case BillingStatus.chargeable:
        return 'Fully Billable / Chargeable';
      case BillingStatus.partiallyChargeable:
        return 'Partially Billable (Material Only)';
      case BillingStatus.pendingCommercialApproval:
        return 'Pending Commercial Approval';
    }
  }

  Color get color {
    switch (this) {
      case BillingStatus.warrantyCovered:
      case BillingStatus.freeService:
        return const Color(0xFF10B981);
      case BillingStatus.chargeable:
        return const Color(0xFFF59E0B);
      case BillingStatus.partiallyChargeable:
        return const Color(0xFF0284C7);
      case BillingStatus.pendingCommercialApproval:
        return const Color(0xFF8B5CF6);
    }
  }
}

enum IssueResolutionAnswer {
  yes,
  partially,
  no;

  String get label {
    switch (this) {
      case IssueResolutionAnswer.yes:
        return 'Yes, Completely Resolved';
      case IssueResolutionAnswer.partially:
        return 'Partially Resolved';
      case IssueResolutionAnswer.no:
        return 'No, Still Pending';
    }
  }
}

// Backward compatibility legacy enums
enum SnagStatus {
  open,
  dispatched,
  inProgress,
  resolved,
  warrantyDenied;

  String get displayName => name;
}

enum CallStatus {
  scheduled,
  completed,
  noAnswer,
  rescheduled;

  String get displayName => name;
}

enum ReferralRewardStatus {
  eligible,
  credited,
  claimed;

  String get displayName => name;
}

// ============================================================================
// CORE ENTITY DATA MODELS
// ============================================================================

class ServiceAttachment {
  final String id;
  final String fileName;
  final String fileType;
  final String fileSize;
  final String uploadedBy;
  final DateTime uploadedDate;
  final String category;
  final String fileUrl;

  const ServiceAttachment({
    required this.id,
    required this.fileName,
    required this.fileType,
    required this.fileSize,
    required this.uploadedBy,
    required this.uploadedDate,
    required this.category,
    required this.fileUrl,
  });
}

class InternalNote {
  final String id;
  final String authorName;
  final String authorRole;
  final DateTime timestamp;
  final String note;

  const InternalNote({
    required this.id,
    required this.authorName,
    required this.authorRole,
    required this.timestamp,
    required this.note,
  });
}

class ServiceTask {
  final String id;
  final String title;
  final String description;
  final String assignee;
  final ServicePriority priority;
  final DateTime dueDate;
  final bool isCompleted;
  final DateTime? completedDate;

  const ServiceTask({
    required this.id,
    required this.title,
    required this.description,
    required this.assignee,
    required this.priority,
    required this.dueDate,
    this.isCompleted = false,
    this.completedDate,
  });
}

class ServiceRequest {
  final String id;
  final String requestNumber;
  final String customerId;
  final String customerName;
  final String customerPhone;
  final String customerEmail;
  final String preferredChannel;

  // Project Context
  final String projectId;
  final String projectName;
  final String projectType;
  final String siteAddress;
  final DateTime handoverDate;
  final String projectManager;
  final String supervisor;

  // Request Details
  final String requestType;
  final ServiceCategory category;
  final String subject;
  final String description;
  final String areaRoom;
  final String specificLocation;
  final DateTime issueDate;
  final ServicePriority priority;
  final ServiceRequestStatus status;
  final String customerExpectation;
  final DateTime preferredServiceDate;
  final String preferredTime;
  final String availabilityNotes;
  final String additionalRemarks;

  // Operational Assignment
  final String assignedToName;
  final String assignedToRole;
  final DateTime? assignedDate;
  final String? previousAssignee;
  final String? reassignmentReason;

  // Timestamps & SLAs
  final DateTime createdDate;
  final DateTime dueDate;
  final DateTime lastActivity;
  final DateTime? nextFollowUpDate;
  final DateTime? resolvedDate;
  final DateTime? closedDate;

  // Commercial & Warranty
  final bool isWarrantyCovered;
  final String? warrantyId;
  final BillingStatus billingStatus;
  final double estimatedCost;
  final bool paymentLinkSent;
  final bool isPaid;

  // Sub-items
  final List<ServiceTask> tasks;
  final List<ServiceAttachment> attachments;
  final List<InternalNote> internalNotes;
  final List<String> visitIds;
  final String? complaintId;
  final double? rating;
  final bool isReopened;
  final String? reopenReason;

  const ServiceRequest({
    required this.id,
    required this.requestNumber,
    required this.customerId,
    required this.customerName,
    required this.customerPhone,
    required this.customerEmail,
    required this.preferredChannel,
    required this.projectId,
    required this.projectName,
    required this.projectType,
    required this.siteAddress,
    required this.handoverDate,
    required this.projectManager,
    required this.supervisor,
    required this.requestType,
    required this.category,
    required this.subject,
    required this.description,
    required this.areaRoom,
    required this.specificLocation,
    required this.issueDate,
    required this.priority,
    required this.status,
    required this.customerExpectation,
    required this.preferredServiceDate,
    required this.preferredTime,
    required this.availabilityNotes,
    this.additionalRemarks = '',
    required this.assignedToName,
    required this.assignedToRole,
    this.assignedDate,
    this.previousAssignee,
    this.reassignmentReason,
    required this.createdDate,
    required this.dueDate,
    required this.lastActivity,
    this.nextFollowUpDate,
    this.resolvedDate,
    this.closedDate,
    this.isWarrantyCovered = true,
    this.warrantyId,
    this.billingStatus = BillingStatus.warrantyCovered,
    this.estimatedCost = 0.0,
    this.paymentLinkSent = false,
    this.isPaid = true,
    this.tasks = const [],
    this.attachments = const [],
    this.internalNotes = const [],
    this.visitIds = const [],
    this.complaintId,
    this.rating,
    this.isReopened = false,
    this.reopenReason,
  });

  bool get isOverdue =>
      status != ServiceRequestStatus.resolved &&
      status != ServiceRequestStatus.closed &&
      DateTime.now().isAfter(dueDate);

  ServiceRequest copyWith({
    String? id,
    String? requestNumber,
    String? customerId,
    String? customerName,
    String? customerPhone,
    String? customerEmail,
    String? preferredChannel,
    String? projectId,
    String? projectName,
    String? projectType,
    String? siteAddress,
    DateTime? handoverDate,
    String? projectManager,
    String? supervisor,
    String? requestType,
    ServiceCategory? category,
    String? subject,
    String? description,
    String? areaRoom,
    String? specificLocation,
    DateTime? issueDate,
    ServicePriority? priority,
    ServiceRequestStatus? status,
    String? customerExpectation,
    DateTime? preferredServiceDate,
    String? preferredTime,
    String? availabilityNotes,
    String? additionalRemarks,
    String? assignedToName,
    String? assignedToRole,
    DateTime? assignedDate,
    String? previousAssignee,
    String? reassignmentReason,
    DateTime? createdDate,
    DateTime? dueDate,
    DateTime? lastActivity,
    DateTime? nextFollowUpDate,
    DateTime? resolvedDate,
    DateTime? closedDate,
    bool? isWarrantyCovered,
    String? warrantyId,
    BillingStatus? billingStatus,
    double? estimatedCost,
    bool? paymentLinkSent,
    bool? isPaid,
    List<ServiceTask>? tasks,
    List<ServiceAttachment>? attachments,
    List<InternalNote>? internalNotes,
    List<String>? visitIds,
    String? complaintId,
    double? rating,
    bool? isReopened,
    String? reopenReason,
  }) {
    return ServiceRequest(
      id: id ?? this.id,
      requestNumber: requestNumber ?? this.requestNumber,
      customerId: customerId ?? this.customerId,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      customerEmail: customerEmail ?? this.customerEmail,
      preferredChannel: preferredChannel ?? this.preferredChannel,
      projectId: projectId ?? this.projectId,
      projectName: projectName ?? this.projectName,
      projectType: projectType ?? this.projectType,
      siteAddress: siteAddress ?? this.siteAddress,
      handoverDate: handoverDate ?? this.handoverDate,
      projectManager: projectManager ?? this.projectManager,
      supervisor: supervisor ?? this.supervisor,
      requestType: requestType ?? this.requestType,
      category: category ?? this.category,
      subject: subject ?? this.subject,
      description: description ?? this.description,
      areaRoom: areaRoom ?? this.areaRoom,
      specificLocation: specificLocation ?? this.specificLocation,
      issueDate: issueDate ?? this.issueDate,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      customerExpectation: customerExpectation ?? this.customerExpectation,
      preferredServiceDate: preferredServiceDate ?? this.preferredServiceDate,
      preferredTime: preferredTime ?? this.preferredTime,
      availabilityNotes: availabilityNotes ?? this.availabilityNotes,
      additionalRemarks: additionalRemarks ?? this.additionalRemarks,
      assignedToName: assignedToName ?? this.assignedToName,
      assignedToRole: assignedToRole ?? this.assignedToRole,
      assignedDate: assignedDate ?? this.assignedDate,
      previousAssignee: previousAssignee ?? this.previousAssignee,
      reassignmentReason: reassignmentReason ?? this.reassignmentReason,
      createdDate: createdDate ?? this.createdDate,
      dueDate: dueDate ?? this.dueDate,
      lastActivity: lastActivity ?? this.lastActivity,
      nextFollowUpDate: nextFollowUpDate ?? this.nextFollowUpDate,
      resolvedDate: resolvedDate ?? this.resolvedDate,
      closedDate: closedDate ?? this.closedDate,
      isWarrantyCovered: isWarrantyCovered ?? this.isWarrantyCovered,
      warrantyId: warrantyId ?? this.warrantyId,
      billingStatus: billingStatus ?? this.billingStatus,
      estimatedCost: estimatedCost ?? this.estimatedCost,
      paymentLinkSent: paymentLinkSent ?? this.paymentLinkSent,
      isPaid: isPaid ?? this.isPaid,
      tasks: tasks ?? this.tasks,
      attachments: attachments ?? this.attachments,
      internalNotes: internalNotes ?? this.internalNotes,
      visitIds: visitIds ?? this.visitIds,
      complaintId: complaintId ?? this.complaintId,
      rating: rating ?? this.rating,
      isReopened: isReopened ?? this.isReopened,
      reopenReason: reopenReason ?? this.reopenReason,
    );
  }
}

// Snag item inside a complaint
class SnagItem {
  final String id;
  final String snagNumber;
  final String complaintId;
  final String roomArea;
  final String specificLocation;
  final String description;
  final String photoUrl;
  final String? resolutionPhotoUrl;
  final String responsibleTeam;
  final String assignedPerson;
  final ServicePriority priority;
  final DateTime targetDate;
  final SnagItemStatus status;
  final String? resolutionNotes;
  final bool isCustomerConfirmed;

  const SnagItem({
    required this.id,
    required this.snagNumber,
    required this.complaintId,
    required this.roomArea,
    required this.specificLocation,
    required this.description,
    required this.photoUrl,
    this.resolutionPhotoUrl,
    required this.responsibleTeam,
    required this.assignedPerson,
    required this.priority,
    required this.targetDate,
    required this.status,
    this.resolutionNotes,
    this.isCustomerConfirmed = false,
  });

  SnagItem copyWith({
    String? id,
    String? snagNumber,
    String? complaintId,
    String? roomArea,
    String? specificLocation,
    String? description,
    String? photoUrl,
    String? resolutionPhotoUrl,
    String? responsibleTeam,
    String? assignedPerson,
    ServicePriority? priority,
    DateTime? targetDate,
    SnagItemStatus? status,
    String? resolutionNotes,
    bool? isCustomerConfirmed,
  }) {
    return SnagItem(
      id: id ?? this.id,
      snagNumber: snagNumber ?? this.snagNumber,
      complaintId: complaintId ?? this.complaintId,
      roomArea: roomArea ?? this.roomArea,
      specificLocation: specificLocation ?? this.specificLocation,
      description: description ?? this.description,
      photoUrl: photoUrl ?? this.photoUrl,
      resolutionPhotoUrl: resolutionPhotoUrl ?? this.resolutionPhotoUrl,
      responsibleTeam: responsibleTeam ?? this.responsibleTeam,
      assignedPerson: assignedPerson ?? this.assignedPerson,
      priority: priority ?? this.priority,
      targetDate: targetDate ?? this.targetDate,
      status: status ?? this.status,
      resolutionNotes: resolutionNotes ?? this.resolutionNotes,
      isCustomerConfirmed: isCustomerConfirmed ?? this.isCustomerConfirmed,
    );
  }
}

class Complaint {
  final String id;
  final String complaintNumber;
  final String customerId;
  final String customerName;
  final String customerPhone;
  final String customerEmail;

  final String projectId;
  final String projectName;
  final String siteAddress;
  final String projectManager;
  final String supervisor;
  final DateTime handoverDate;

  final String complaintType;
  final String subject;
  final String description;
  final String areaRoom;
  final String specificLocation;
  final DateTime issueDate;
  final ComplaintSeverity severity;
  final String customerImpact;
  final String expectedResolution;
  final ComplaintStatus status;

  final String assignedToName;
  final String assignedToRole;
  final DateTime createdDate;
  final DateTime dueDate;
  final DateTime? resolvedDate;
  final DateTime? closedDate;

  final String escalationLevel;
  final List<SnagItem> snags;
  final bool inspectionRequired;
  final String? visitId;
  final String? internalVerificationNotes;
  final bool isCustomerConfirmed;

  const Complaint({
    required this.id,
    required this.complaintNumber,
    required this.customerId,
    required this.customerName,
    required this.customerPhone,
    required this.customerEmail,
    required this.projectId,
    required this.projectName,
    required this.siteAddress,
    required this.projectManager,
    required this.supervisor,
    required this.handoverDate,
    required this.complaintType,
    required this.subject,
    required this.description,
    required this.areaRoom,
    required this.specificLocation,
    required this.issueDate,
    required this.severity,
    required this.customerImpact,
    required this.expectedResolution,
    required this.status,
    required this.assignedToName,
    required this.assignedToRole,
    required this.createdDate,
    required this.dueDate,
    this.resolvedDate,
    this.closedDate,
    required this.escalationLevel,
    this.snags = const [],
    this.inspectionRequired = true,
    this.visitId,
    this.internalVerificationNotes,
    this.isCustomerConfirmed = false,
  });

  int get ageInDays => DateTime.now().difference(createdDate).inDays;

  bool get isOverdue =>
      status != ComplaintStatus.resolved &&
      status != ComplaintStatus.closed &&
      DateTime.now().isAfter(dueDate);

  Complaint copyWith({
    String? id,
    String? complaintNumber,
    String? customerId,
    String? customerName,
    String? customerPhone,
    String? customerEmail,
    String? projectId,
    String? projectName,
    String? siteAddress,
    String? projectManager,
    String? supervisor,
    DateTime? handoverDate,
    String? complaintType,
    String? subject,
    String? description,
    String? areaRoom,
    String? specificLocation,
    DateTime? issueDate,
    ComplaintSeverity? severity,
    String? customerImpact,
    String? expectedResolution,
    ComplaintStatus? status,
    String? assignedToName,
    String? assignedToRole,
    DateTime? createdDate,
    DateTime? dueDate,
    DateTime? resolvedDate,
    DateTime? closedDate,
    String? escalationLevel,
    List<SnagItem>? snags,
    bool? inspectionRequired,
    String? visitId,
    String? internalVerificationNotes,
    bool? isCustomerConfirmed,
  }) {
    return Complaint(
      id: id ?? this.id,
      complaintNumber: complaintNumber ?? this.complaintNumber,
      customerId: customerId ?? this.customerId,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      customerEmail: customerEmail ?? this.customerEmail,
      projectId: projectId ?? this.projectId,
      projectName: projectName ?? this.projectName,
      siteAddress: siteAddress ?? this.siteAddress,
      projectManager: projectManager ?? this.projectManager,
      supervisor: supervisor ?? this.supervisor,
      handoverDate: handoverDate ?? this.handoverDate,
      complaintType: complaintType ?? this.complaintType,
      subject: subject ?? this.subject,
      description: description ?? this.description,
      areaRoom: areaRoom ?? this.areaRoom,
      specificLocation: specificLocation ?? this.specificLocation,
      issueDate: issueDate ?? this.issueDate,
      severity: severity ?? this.severity,
      customerImpact: customerImpact ?? this.customerImpact,
      expectedResolution: expectedResolution ?? this.expectedResolution,
      status: status ?? this.status,
      assignedToName: assignedToName ?? this.assignedToName,
      assignedToRole: assignedToRole ?? this.assignedToRole,
      createdDate: createdDate ?? this.createdDate,
      dueDate: dueDate ?? this.dueDate,
      resolvedDate: resolvedDate ?? this.resolvedDate,
      closedDate: closedDate ?? this.closedDate,
      escalationLevel: escalationLevel ?? this.escalationLevel,
      snags: snags ?? this.snags,
      inspectionRequired: inspectionRequired ?? this.inspectionRequired,
      visitId: visitId ?? this.visitId,
      internalVerificationNotes: internalVerificationNotes ?? this.internalVerificationNotes,
      isCustomerConfirmed: isCustomerConfirmed ?? this.isCustomerConfirmed,
    );
  }
}

class WarrantyRecord {
  final String id;
  final String warrantyNumber;
  final String customerId;
  final String customerName;
  final String customerPhone;
  final String projectId;
  final String projectName;
  final DateTime handoverDate;
  final String milestoneRef;

  final WarrantyCategory category;
  final String coveredItemWork;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final WarrantyStatus status;

  final String termsSummary;
  final List<String> inclusions;
  final List<String> exclusions;
  final String policyDocumentUrl;
  final int claimsCount;
  final String relatedInvoiceNumber;

  const WarrantyRecord({
    required this.id,
    required this.warrantyNumber,
    required this.customerId,
    required this.customerName,
    required this.customerPhone,
    required this.projectId,
    required this.projectName,
    required this.handoverDate,
    required this.milestoneRef,
    required this.category,
    required this.coveredItemWork,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.termsSummary,
    this.inclusions = const [],
    this.exclusions = const [],
    required this.policyDocumentUrl,
    this.claimsCount = 0,
    required this.relatedInvoiceNumber,
  });

  int get daysRemaining => endDate.difference(DateTime.now()).inDays;
  bool get isExpiringSoon => daysRemaining > 0 && daysRemaining <= 30;
}

class WarrantyClaim {
  final String id;
  final String claimNumber;
  final String warrantyId;
  final String warrantyNumber;
  final String customerId;
  final String customerName;
  final String projectId;
  final String projectName;

  final String issueArea;
  final DateTime issueDate;
  final String description;
  final List<String> evidenceUrls;
  final String requestedResolution;
  final DateTime claimDate;
  final WarrantyStatus status;

  final String? reviewerName;
  final DateTime? reviewDate;
  final String? rejectionReason;
  final double approvedCoverageAmount;

  const WarrantyClaim({
    required this.id,
    required this.claimNumber,
    required this.warrantyId,
    required this.warrantyNumber,
    required this.customerId,
    required this.customerName,
    required this.projectId,
    required this.projectName,
    required this.issueArea,
    required this.issueDate,
    required this.description,
    this.evidenceUrls = const [],
    required this.requestedResolution,
    required this.claimDate,
    required this.status,
    this.reviewerName,
    this.reviewDate,
    this.rejectionReason,
    this.approvedCoverageAmount = 0.0,
  });
}

class VisitCheckInRecord {
  final DateTime checkInTime;
  final double latitude;
  final double longitude;
  final String siteAddress;
  final bool isGeofenceValid;
  final String selfiePhotoUrl;

  const VisitCheckInRecord({
    required this.checkInTime,
    required this.latitude,
    required this.longitude,
    required this.siteAddress,
    required this.isGeofenceValid,
    required this.selfiePhotoUrl,
  });
}

class VisitChecklistItem {
  final String id;
  final String title;
  final bool isChecked;
  final String? remarks;

  const VisitChecklistItem({
    required this.id,
    required this.title,
    this.isChecked = false,
    this.remarks,
  });

  VisitChecklistItem copyWith({
    String? id,
    String? title,
    bool? isChecked,
    String? remarks,
  }) {
    return VisitChecklistItem(
      id: id ?? this.id,
      title: title ?? this.title,
      isChecked: isChecked ?? this.isChecked,
      remarks: remarks ?? this.remarks,
    );
  }
}

class VisitReport {
  final DateTime arrivalTime;
  final DateTime completionTime;
  final String diagnosis;
  final String workPerformed;
  final String materialsUsed;
  final double labourHours;
  final List<String> beforePhotoUrls;
  final List<String> afterPhotoUrls;
  final String customerSignatureName;
  final bool customerConfirmed;
  final double rating;
  final String internalRemarks;

  const VisitReport({
    required this.arrivalTime,
    required this.completionTime,
    required this.diagnosis,
    required this.workPerformed,
    required this.materialsUsed,
    required this.labourHours,
    this.beforePhotoUrls = const [],
    this.afterPhotoUrls = const [],
    required this.customerSignatureName,
    this.customerConfirmed = true,
    this.rating = 5.0,
    this.internalRemarks = '',
  });
}

class ServiceVisit {
  final String id;
  final String visitNumber;
  final String serviceRequestId;
  final String? complaintId;
  final String customerId;
  final String customerName;
  final String customerPhone;
  final String projectId;
  final String projectName;
  final String siteAddress;

  final VisitType visitType;
  final String purpose;
  final DateTime visitDate;
  final String startTime;
  final String endTime;
  final String assignedEmployee;
  final String assignedTechnician;
  final String contactPerson;
  final String contactNumber;
  final String specialInstructions;

  final List<String> requiredTools;
  final List<String> requiredMaterials;
  final ServiceVisitStatus status;
  final String outcome;

  final VisitCheckInRecord? checkInRecord;
  final List<VisitChecklistItem> checklist;
  final VisitReport? report;

  const ServiceVisit({
    required this.id,
    required this.visitNumber,
    required this.serviceRequestId,
    this.complaintId,
    required this.customerId,
    required this.customerName,
    required this.customerPhone,
    required this.projectId,
    required this.projectName,
    required this.siteAddress,
    required this.visitType,
    required this.purpose,
    required this.visitDate,
    required this.startTime,
    required this.endTime,
    required this.assignedEmployee,
    required this.assignedTechnician,
    required this.contactPerson,
    required this.contactNumber,
    this.specialInstructions = '',
    this.requiredTools = const [],
    this.requiredMaterials = const [],
    required this.status,
    this.outcome = 'Pending Visit Execution',
    this.checkInRecord,
    this.checklist = const [],
    this.report,
  });

  ServiceVisit copyWith({
    String? id,
    String? visitNumber,
    String? serviceRequestId,
    String? complaintId,
    String? customerId,
    String? customerName,
    String? customerPhone,
    String? projectId,
    String? projectName,
    String? siteAddress,
    VisitType? visitType,
    String? purpose,
    DateTime? visitDate,
    String? startTime,
    String? endTime,
    String? assignedEmployee,
    String? assignedTechnician,
    String? contactPerson,
    String? contactNumber,
    String? specialInstructions,
    List<String>? requiredTools,
    List<String>? requiredMaterials,
    ServiceVisitStatus? status,
    String? outcome,
    VisitCheckInRecord? checkInRecord,
    List<VisitChecklistItem>? checklist,
    VisitReport? report,
  }) {
    return ServiceVisit(
      id: id ?? this.id,
      visitNumber: visitNumber ?? this.visitNumber,
      serviceRequestId: serviceRequestId ?? this.serviceRequestId,
      complaintId: complaintId ?? this.complaintId,
      customerId: customerId ?? this.customerId,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      projectId: projectId ?? this.projectId,
      projectName: projectName ?? this.projectName,
      siteAddress: siteAddress ?? this.siteAddress,
      visitType: visitType ?? this.visitType,
      purpose: purpose ?? this.purpose,
      visitDate: visitDate ?? this.visitDate,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      assignedEmployee: assignedEmployee ?? this.assignedEmployee,
      assignedTechnician: assignedTechnician ?? this.assignedTechnician,
      contactPerson: contactPerson ?? this.contactPerson,
      contactNumber: contactNumber ?? this.contactNumber,
      specialInstructions: specialInstructions ?? this.specialInstructions,
      requiredTools: requiredTools ?? this.requiredTools,
      requiredMaterials: requiredMaterials ?? this.requiredMaterials,
      status: status ?? this.status,
      outcome: outcome ?? this.outcome,
      checkInRecord: checkInRecord ?? this.checkInRecord,
      checklist: checklist ?? this.checklist,
      report: report ?? this.report,
    );
  }
}

class ServiceFollowUp {
  final String id;
  final String customerId;
  final String customerName;
  final String customerPhone;
  final String customerEmail;
  final String projectId;
  final String projectName;
  final DateTime handoverDate;

  final FollowUpType followUpType;
  final String reason;
  final String assignedEmployee;
  final DateTime scheduledDate;
  final DateTime? conductedDate;
  final String preferredTime;
  final String channel;
  final String objective;

  final String notes;
  final FollowUpOutcome outcome;
  final DateTime? nextFollowUpDate;
  final double? satisfactionRating;

  const ServiceFollowUp({
    required this.id,
    required this.customerId,
    required this.customerName,
    required this.customerPhone,
    required this.customerEmail,
    required this.projectId,
    required this.projectName,
    required this.handoverDate,
    required this.followUpType,
    required this.reason,
    required this.assignedEmployee,
    required this.scheduledDate,
    this.conductedDate,
    required this.preferredTime,
    required this.channel,
    required this.objective,
    this.notes = '',
    required this.outcome,
    this.nextFollowUpDate,
    this.satisfactionRating,
  });

  bool get isDueToday {
    final now = DateTime.now();
    return scheduledDate.year == now.year &&
        scheduledDate.month == now.month &&
        scheduledDate.day == now.day;
  }

  bool get isOverdue =>
      conductedDate == null &&
      DateTime.now().isAfter(scheduledDate.add(const Duration(days: 1)));

  ServiceFollowUp copyWith({
    String? id,
    String? customerId,
    String? customerName,
    String? customerPhone,
    String? customerEmail,
    String? projectId,
    String? projectName,
    DateTime? handoverDate,
    FollowUpType? followUpType,
    String? reason,
    String? assignedEmployee,
    DateTime? scheduledDate,
    DateTime? conductedDate,
    String? preferredTime,
    String? channel,
    String? objective,
    String? notes,
    FollowUpOutcome? outcome,
    DateTime? nextFollowUpDate,
    double? satisfactionRating,
  }) {
    return ServiceFollowUp(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      customerEmail: customerEmail ?? this.customerEmail,
      projectId: projectId ?? this.projectId,
      projectName: projectName ?? this.projectName,
      handoverDate: handoverDate ?? this.handoverDate,
      followUpType: followUpType ?? this.followUpType,
      reason: reason ?? this.reason,
      assignedEmployee: assignedEmployee ?? this.assignedEmployee,
      scheduledDate: scheduledDate ?? this.scheduledDate,
      conductedDate: conductedDate ?? this.conductedDate,
      preferredTime: preferredTime ?? this.preferredTime,
      channel: channel ?? this.channel,
      objective: objective ?? this.objective,
      notes: notes ?? this.notes,
      outcome: outcome ?? this.outcome,
      nextFollowUpDate: nextFollowUpDate ?? this.nextFollowUpDate,
      satisfactionRating: satisfactionRating ?? this.satisfactionRating,
    );
  }
}

class CustomerFeedback {
  final String id;
  final String feedbackNumber;
  final String customerId;
  final String customerName;
  final String customerPhone;
  final String projectId;
  final String projectName;
  final String? serviceRequestId;
  final String? visitId;
  final String touchpoint;
  final DateTime submittedDate;

  // 5-Pillar CSAT (1-5 scale)
  final double overallRating;
  final double qualityRating;
  final double timelinessRating;
  final double professionalismRating;
  final double communicationRating;
  final double resolutionRating;

  final IssueResolutionAnswer issueResolvedAnswer;
  final String whatWentWell;
  final String whatCouldImprove;
  final String customerComments;

  final bool isEscalated;
  final String? escalationReason;
  final String? managerFollowUpNotes;
  final bool isResolved;
  final String? resolutionNotes;

  DateTime get createdAt => submittedDate;
  String get feedbackNotes => customerComments.isNotEmpty
      ? customerComments
      : (whatWentWell.isNotEmpty ? whatWentWell : whatCouldImprove);
  double get qualityScore => qualityRating;
  double get timelinessScore => timelinessRating;
  double get professionalismScore => professionalismRating;
  double get communicationScore => communicationRating;
  double get resolutionScore => resolutionRating;
  bool get escalatedToManager => isEscalated;

  const CustomerFeedback({
    required this.id,
    required this.feedbackNumber,
    required this.customerId,
    required this.customerName,
    required this.customerPhone,
    required this.projectId,
    required this.projectName,
    this.serviceRequestId,
    this.visitId,
    required this.touchpoint,
    required this.submittedDate,
    required this.overallRating,
    required this.qualityRating,
    required this.timelinessRating,
    required this.professionalismRating,
    required this.communicationRating,
    required this.resolutionRating,
    required this.issueResolvedAnswer,
    this.whatWentWell = '',
    this.whatCouldImprove = '',
    this.customerComments = '',
    this.isEscalated = false,
    this.escalationReason,
    this.managerFollowUpNotes,
    this.isResolved = false,
    this.resolutionNotes,
  });

  bool get isNegative => overallRating < 3.0 || issueResolvedAnswer == IssueResolutionAnswer.no;

  CustomerFeedback copyWith({
    String? id,
    String? feedbackNumber,
    String? customerId,
    String? customerName,
    String? customerPhone,
    String? projectId,
    String? projectName,
    String? serviceRequestId,
    String? visitId,
    String? touchpoint,
    DateTime? submittedDate,
    double? overallRating,
    double? qualityRating,
    double? timelinessRating,
    double? professionalismRating,
    double? communicationRating,
    double? resolutionRating,
    IssueResolutionAnswer? issueResolvedAnswer,
    String? whatWentWell,
    String? whatCouldImprove,
    String? customerComments,
    bool? isEscalated,
    String? escalationReason,
    String? managerFollowUpNotes,
    bool? isResolved,
    String? resolutionNotes,
  }) {
    return CustomerFeedback(
      id: id ?? this.id,
      feedbackNumber: feedbackNumber ?? this.feedbackNumber,
      customerId: customerId ?? this.customerId,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      projectId: projectId ?? this.projectId,
      projectName: projectName ?? this.projectName,
      serviceRequestId: serviceRequestId ?? this.serviceRequestId,
      visitId: visitId ?? this.visitId,
      touchpoint: touchpoint ?? this.touchpoint,
      submittedDate: submittedDate ?? this.submittedDate,
      overallRating: overallRating ?? this.overallRating,
      qualityRating: qualityRating ?? this.qualityRating,
      timelinessRating: timelinessRating ?? this.timelinessRating,
      professionalismRating: professionalismRating ?? this.professionalismRating,
      communicationRating: communicationRating ?? this.communicationRating,
      resolutionRating: resolutionRating ?? this.resolutionRating,
      issueResolvedAnswer: issueResolvedAnswer ?? this.issueResolvedAnswer,
      whatWentWell: whatWentWell ?? this.whatWentWell,
      whatCouldImprove: whatCouldImprove ?? this.whatCouldImprove,
      customerComments: customerComments ?? this.customerComments,
      isEscalated: isEscalated ?? this.isEscalated,
      escalationReason: escalationReason ?? this.escalationReason,
      managerFollowUpNotes: managerFollowUpNotes ?? this.managerFollowUpNotes,
      isResolved: isResolved ?? this.isResolved,
      resolutionNotes: resolutionNotes ?? this.resolutionNotes,
    );
  }
}

class EstimateItem {
  final String description;
  final double quantity;
  final String unit;
  final double rate;
  final double labourCost;
  final double materialCost;
  final bool isWarrantyWaived;

  const EstimateItem({
    required this.description,
    required this.quantity,
    required this.unit,
    required this.rate,
    required this.labourCost,
    required this.materialCost,
    this.isWarrantyWaived = false,
  });

  double get subtotal => (quantity * rate) + labourCost + materialCost;
  double get billableAmount => isWarrantyWaived ? 0.0 : subtotal;
}

class ServiceEstimate {
  final String id;
  final String estimateNumber;
  final String serviceRequestId;
  final String customerName;
  final String projectName;
  final List<EstimateItem> items;
  final double discount;
  final double taxRate;
  final DateTime generatedDate;
  final DateTime validityDate;
  final bool isApprovedByCustomer;
  final String paymentLink;
  final bool isPaid;

  const ServiceEstimate({
    required this.id,
    required this.estimateNumber,
    required this.serviceRequestId,
    required this.customerName,
    required this.projectName,
    required this.items,
    this.discount = 0.0,
    this.taxRate = 0.18,
    required this.generatedDate,
    required this.validityDate,
    this.isApprovedByCustomer = false,
    required this.paymentLink,
    this.isPaid = false,
  });

  double get grossAmount => items.fold(0.0, (sum, i) => sum + i.billableAmount);
  double get netBeforeTax => (grossAmount - discount).clamp(0.0, double.infinity);
  double get taxAmount => netBeforeTax * taxRate;
  double get totalPayable => netBeforeTax + taxAmount;
}

// Backward compatibility legacy classes
class SnagTicket {
  final String id;
  final String ticketNumber;
  final String projectId;
  final String projectName;
  final String clientName;
  final String clientPhone;
  final DateTime handoverDate;
  final ServiceCategory category;
  final ServicePriority priority;
  final WarrantyStatus warrantyStatus;
  final String title;
  final String description;
  final DateTime reportedDate;
  final DateTime slaDeadline;
  final String? assignedTechnician;
  final String? technicianPhone;
  final SnagStatus status;
  final String? beforePhotoUrl;
  final String? afterPhotoUrl;
  final bool clientSignoff;
  final DateTime? resolvedDate;
  final String? resolutionNotes;

  const SnagTicket({
    required this.id,
    required this.ticketNumber,
    required this.projectId,
    required this.projectName,
    required this.clientName,
    required this.clientPhone,
    required this.handoverDate,
    required this.category,
    required this.priority,
    required this.warrantyStatus,
    required this.title,
    required this.description,
    required this.reportedDate,
    required this.slaDeadline,
    this.assignedTechnician,
    this.technicianPhone,
    required this.status,
    this.beforePhotoUrl,
    this.afterPhotoUrl,
    this.clientSignoff = false,
    this.resolvedDate,
    this.resolutionNotes,
  });
  bool get isOverdue => DateTime.now().isAfter(slaDeadline) && status != SnagStatus.resolved;

  SnagTicket copyWith({
    String? id,
    String? ticketNumber,
    String? projectId,
    String? projectName,
    String? clientName,
    String? clientPhone,
    DateTime? handoverDate,
    ServiceCategory? category,
    ServicePriority? priority,
    WarrantyStatus? warrantyStatus,
    String? title,
    String? description,
    DateTime? reportedDate,
    DateTime? slaDeadline,
    String? assignedTechnician,
    String? technicianPhone,
    SnagStatus? status,
    String? beforePhotoUrl,
    String? afterPhotoUrl,
    bool? clientSignoff,
    DateTime? resolvedDate,
    String? resolutionNotes,
  }) {
    return SnagTicket(
      id: id ?? this.id,
      ticketNumber: ticketNumber ?? this.ticketNumber,
      projectId: projectId ?? this.projectId,
      projectName: projectName ?? this.projectName,
      clientName: clientName ?? this.clientName,
      clientPhone: clientPhone ?? this.clientPhone,
      handoverDate: handoverDate ?? this.handoverDate,
      category: category ?? this.category,
      priority: priority ?? this.priority,
      warrantyStatus: warrantyStatus ?? this.warrantyStatus,
      title: title ?? this.title,
      description: description ?? this.description,
      reportedDate: reportedDate ?? this.reportedDate,
      slaDeadline: slaDeadline ?? this.slaDeadline,
      assignedTechnician: assignedTechnician ?? this.assignedTechnician,
      technicianPhone: technicianPhone ?? this.technicianPhone,
      status: status ?? this.status,
      beforePhotoUrl: beforePhotoUrl ?? this.beforePhotoUrl,
      afterPhotoUrl: afterPhotoUrl ?? this.afterPhotoUrl,
      clientSignoff: clientSignoff ?? this.clientSignoff,
      resolvedDate: resolvedDate ?? this.resolvedDate,
      resolutionNotes: resolutionNotes ?? this.resolutionNotes,
    );
  }
}

class RetentionCallRecord {
  final String id;
  final String clientId;
  final String clientName;
  final String clientPhone;
  final String projectName;
  final DateTime handoverDate;
  final DateTime scheduledDate;
  final DateTime? conductedDate;
  final CallStatus callStatus;
  final double? csatScore;
  final double? designQualityRating;
  final double? timelineRating;
  final double? behaviourRating;
  final String? callerName;
  final String? feedbackNotes;
  final bool reviewLinkSent;
  final bool reviewPosted;
  final String? referralLeadName;
  final String? referralLeadPhone;
  final ReferralRewardStatus? referralRewardStatus;

  const RetentionCallRecord({
    required this.id,
    required this.clientId,
    required this.clientName,
    required this.clientPhone,
    required this.projectName,
    required this.handoverDate,
    required this.scheduledDate,
    this.conductedDate,
    required this.callStatus,
    this.csatScore,
    this.designQualityRating,
    this.timelineRating,
    this.behaviourRating,
    this.callerName,
    this.feedbackNotes,
    this.reviewLinkSent = false,
    this.reviewPosted = false,
    this.referralLeadName,
    this.referralLeadPhone,
    this.referralRewardStatus,
  });

  bool get isHighSatisfaction => (csatScore ?? 0) >= 4.0;

  RetentionCallRecord copyWith({
    String? id,
    String? clientId,
    String? clientName,
    String? clientPhone,
    String? projectName,
    DateTime? handoverDate,
    DateTime? scheduledDate,
    DateTime? conductedDate,
    CallStatus? callStatus,
    double? csatScore,
    double? designQualityRating,
    double? timelineRating,
    double? behaviourRating,
    String? callerName,
    String? feedbackNotes,
    bool? reviewLinkSent,
    bool? reviewPosted,
    String? referralLeadName,
    String? referralLeadPhone,
    ReferralRewardStatus? referralRewardStatus,
  }) {
    return RetentionCallRecord(
      id: id ?? this.id,
      clientId: clientId ?? this.clientId,
      clientName: clientName ?? this.clientName,
      clientPhone: clientPhone ?? this.clientPhone,
      projectName: projectName ?? this.projectName,
      handoverDate: handoverDate ?? this.handoverDate,
      scheduledDate: scheduledDate ?? this.scheduledDate,
      conductedDate: conductedDate ?? this.conductedDate,
      callStatus: callStatus ?? this.callStatus,
      csatScore: csatScore ?? this.csatScore,
      designQualityRating: designQualityRating ?? this.designQualityRating,
      timelineRating: timelineRating ?? this.timelineRating,
      behaviourRating: behaviourRating ?? this.behaviourRating,
      callerName: callerName ?? this.callerName,
      feedbackNotes: feedbackNotes ?? this.feedbackNotes,
      reviewLinkSent: reviewLinkSent ?? this.reviewLinkSent,
      reviewPosted: reviewPosted ?? this.reviewPosted,
      referralLeadName: referralLeadName ?? this.referralLeadName,
      referralLeadPhone: referralLeadPhone ?? this.referralLeadPhone,
      referralRewardStatus: referralRewardStatus ?? this.referralRewardStatus,
    );
  }
}
