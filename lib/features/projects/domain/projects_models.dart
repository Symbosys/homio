import 'package:flutter/material.dart';
import 'projects_enums.dart';

// =============================================================================
// PROJECT AREA — Room / space within a project
// =============================================================================
class ProjectArea {
  final String id;
  final String name;
  final double length;
  final double width;
  final double height;
  final double areaSqFt;
  final AreaUnit unit;
  final String floor;
  final String roomType;
  final String description;
  final List<String> images;

  const ProjectArea({
    required this.id,
    required this.name,
    this.length = 0,
    this.width = 0,
    this.height = 0,
    this.areaSqFt = 0,
    this.unit = AreaUnit.sqFt,
    this.floor = 'Ground',
    this.roomType = 'Other',
    this.description = '',
    this.images = const [],
  });

  ProjectArea copyWith({
    String? id,
    String? name,
    double? length,
    double? width,
    double? height,
    double? areaSqFt,
    AreaUnit? unit,
    String? floor,
    String? roomType,
    String? description,
    List<String>? images,
  }) {
    return ProjectArea(
      id: id ?? this.id,
      name: name ?? this.name,
      length: length ?? this.length,
      width: width ?? this.width,
      height: height ?? this.height,
      areaSqFt: areaSqFt ?? this.areaSqFt,
      unit: unit ?? this.unit,
      floor: floor ?? this.floor,
      roomType: roomType ?? this.roomType,
      description: description ?? this.description,
      images: images ?? this.images,
    );
  }
}

// =============================================================================
// PROJECT TEAM MEMBER
// =============================================================================
class ProjectTeamMember {
  final String userId;
  final String name;
  final String role;
  final DateTime assignmentDate;
  final String responsibilities;

  const ProjectTeamMember({
    required this.userId,
    required this.name,
    required this.role,
    required this.assignmentDate,
    this.responsibilities = '',
  });
}

// =============================================================================
// MILESTONE CHECKLIST ITEM
// =============================================================================
class MilestoneChecklistItem {
  final String id;
  final String label;
  final String? assignee;
  final DateTime? dueDate;
  final bool isDone;

  const MilestoneChecklistItem({
    required this.id,
    required this.label,
    this.assignee,
    this.dueDate,
    this.isDone = false,
  });

  MilestoneChecklistItem copyWith({
    String? id,
    String? label,
    String? assignee,
    DateTime? dueDate,
    bool? isDone,
  }) {
    return MilestoneChecklistItem(
      id: id ?? this.id,
      label: label ?? this.label,
      assignee: assignee ?? this.assignee,
      dueDate: dueDate ?? this.dueDate,
      isDone: isDone ?? this.isDone,
    );
  }
}

// =============================================================================
// TASK DEPENDENCY
// =============================================================================
class TaskDependency {
  final String fromTaskId;
  final String toTaskId;
  final String type;

  const TaskDependency({
    required this.fromTaskId,
    required this.toTaskId,
    this.type = 'finish-to-start',
  });
}

// =============================================================================
// PROJECT MILESTONE
// =============================================================================
class ProjectMilestone {
  final String id;
  final String projectId;
  final String name;
  final ProjectStage stage;
  final String description;
  final DateTime startDate;
  final DateTime dueDate;
  final double completionPercent;
  final MilestoneStatus status;
  final String assignee;
  final ProjectTaskPriority priority;
  final List<String> taskIds;
  final bool approvalRequired;
  final bool paymentRequired;
  final double budgetLakhs;
  final List<MilestoneChecklistItem> checklist;
  final List<String> attachments;

  const ProjectMilestone({
    required this.id,
    required this.projectId,
    required this.name,
    required this.stage,
    this.description = '',
    required this.startDate,
    required this.dueDate,
    this.completionPercent = 0,
    this.status = MilestoneStatus.notStarted,
    this.assignee = '',
    this.priority = ProjectTaskPriority.medium,
    this.taskIds = const [],
    this.approvalRequired = false,
    this.paymentRequired = false,
    this.budgetLakhs = 0,
    this.checklist = const [],
    this.attachments = const [],
  });

  bool get isOverdue =>
      status != MilestoneStatus.completed &&
      status != MilestoneStatus.cancelled &&
      dueDate.isBefore(DateTime.now());

  int get delayDays {
    if (!isOverdue) return 0;
    return DateTime.now().difference(dueDate).inDays;
  }

  int get totalChecklistItems => checklist.length;
  int get completedChecklistItems => checklist.where((c) => c.isDone).length;

  ProjectMilestone copyWith({
    String? id,
    String? projectId,
    String? name,
    ProjectStage? stage,
    String? description,
    DateTime? startDate,
    DateTime? dueDate,
    double? completionPercent,
    MilestoneStatus? status,
    String? assignee,
    ProjectTaskPriority? priority,
    List<String>? taskIds,
    bool? approvalRequired,
    bool? paymentRequired,
    double? budgetLakhs,
    List<MilestoneChecklistItem>? checklist,
    List<String>? attachments,
  }) {
    return ProjectMilestone(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      name: name ?? this.name,
      stage: stage ?? this.stage,
      description: description ?? this.description,
      startDate: startDate ?? this.startDate,
      dueDate: dueDate ?? this.dueDate,
      completionPercent: completionPercent ?? this.completionPercent,
      status: status ?? this.status,
      assignee: assignee ?? this.assignee,
      priority: priority ?? this.priority,
      taskIds: taskIds ?? this.taskIds,
      approvalRequired: approvalRequired ?? this.approvalRequired,
      paymentRequired: paymentRequired ?? this.paymentRequired,
      budgetLakhs: budgetLakhs ?? this.budgetLakhs,
      checklist: checklist ?? this.checklist,
      attachments: attachments ?? this.attachments,
    );
  }
}

// =============================================================================
// PROJECT TASK
// =============================================================================
class ProjectTask {
  final String id;
  final String projectId;
  final String? milestoneId;
  final String name;
  final String description;
  final String areaRoom;
  final String assignee;
  final ProjectTaskPriority priority;
  final ProjectTaskStatus status;
  final DateTime startDate;
  final DateTime dueDate;
  final double estimatedHours;
  final double actualHours;
  final List<TaskDependency> dependencies;
  final List<String> checklist;
  final List<bool> checklistChecked;
  final List<String> attachments;
  final List<String> comments;
  final bool isRescheduled;
  final DateTime? originalDueDate;
  final String? rescheduleReason;
  final String? rescheduledBy;
  final DateTime? rescheduledAt;

  const ProjectTask({
    required this.id,
    required this.projectId,
    this.milestoneId,
    required this.name,
    this.description = '',
    this.areaRoom = '',
    this.assignee = '',
    this.priority = ProjectTaskPriority.medium,
    this.status = ProjectTaskStatus.toDo,
    required this.startDate,
    required this.dueDate,
    this.estimatedHours = 0,
    this.actualHours = 0,
    this.dependencies = const [],
    this.checklist = const [],
    this.checklistChecked = const [],
    this.attachments = const [],
    this.comments = const [],
    this.isRescheduled = false,
    this.originalDueDate,
    this.rescheduleReason,
    this.rescheduledBy,
    this.rescheduledAt,
  });

  bool get isOverdue =>
      status != ProjectTaskStatus.completed &&
      status != ProjectTaskStatus.cancelled &&
      dueDate.isBefore(DateTime.now());

  bool get isDueToday {
    final now = DateTime.now();
    return dueDate.year == now.year &&
        dueDate.month == now.month &&
        dueDate.day == now.day;
  }

  bool get isDueSoon {
    if (isOverdue || isDueToday) return false;
    return dueDate.difference(DateTime.now()).inDays <= 3;
  }

  int get delayDays {
    if (!isOverdue) return 0;
    return DateTime.now().difference(dueDate).inDays;
  }

  int get completedChecklistCount => checklistChecked.where((c) => c).length;
  double get checklistProgress =>
      checklist.isEmpty ? 0 : completedChecklistCount / checklist.length;

  ProjectTask copyWith({
    String? id,
    String? projectId,
    String? milestoneId,
    String? name,
    String? description,
    String? areaRoom,
    String? assignee,
    ProjectTaskPriority? priority,
    ProjectTaskStatus? status,
    DateTime? startDate,
    DateTime? dueDate,
    double? estimatedHours,
    double? actualHours,
    List<TaskDependency>? dependencies,
    List<String>? checklist,
    List<bool>? checklistChecked,
    List<String>? attachments,
    List<String>? comments,
    bool? isRescheduled,
    DateTime? originalDueDate,
    String? rescheduleReason,
    String? rescheduledBy,
    DateTime? rescheduledAt,
  }) {
    return ProjectTask(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      milestoneId: milestoneId ?? this.milestoneId,
      name: name ?? this.name,
      description: description ?? this.description,
      areaRoom: areaRoom ?? this.areaRoom,
      assignee: assignee ?? this.assignee,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      startDate: startDate ?? this.startDate,
      dueDate: dueDate ?? this.dueDate,
      estimatedHours: estimatedHours ?? this.estimatedHours,
      actualHours: actualHours ?? this.actualHours,
      dependencies: dependencies ?? this.dependencies,
      checklist: checklist ?? this.checklist,
      checklistChecked: checklistChecked ?? this.checklistChecked,
      attachments: attachments ?? this.attachments,
      comments: comments ?? this.comments,
      isRescheduled: isRescheduled ?? this.isRescheduled,
      originalDueDate: originalDueDate ?? this.originalDueDate,
      rescheduleReason: rescheduleReason ?? this.rescheduleReason,
      rescheduledBy: rescheduledBy ?? this.rescheduledBy,
      rescheduledAt: rescheduledAt ?? this.rescheduledAt,
    );
  }
}

// =============================================================================
// SITE VISIT
// =============================================================================
class SiteVisit {
  final String id;
  final String projectId;
  final String clientName;
  final SiteVisitType visitType;
  final DateTime date;
  final String startTime;
  final String endTime;
  final String assignedEmployee;
  final String purpose;
  final String siteAddress;
  final double? gpsLat;
  final double? gpsLng;
  final String contactPerson;
  final String contactNumber;
  final String? selfieUrl;
  final List<String> images;
  final List<String> videos;
  final List<String> documents;
  final SiteVisitOutcome outcome;
  final String notes;
  final String? issuesFound;
  final String? workRequired;
  final DateTime? nextVisitDate;
  final bool followUpRequired;

  const SiteVisit({
    required this.id,
    required this.projectId,
    this.clientName = '',
    required this.visitType,
    required this.date,
    this.startTime = '',
    this.endTime = '',
    this.assignedEmployee = '',
    this.purpose = '',
    this.siteAddress = '',
    this.gpsLat,
    this.gpsLng,
    this.contactPerson = '',
    this.contactNumber = '',
    this.selfieUrl,
    this.images = const [],
    this.videos = const [],
    this.documents = const [],
    this.outcome = SiteVisitOutcome.pending,
    this.notes = '',
    this.issuesFound,
    this.workRequired,
    this.nextVisitDate,
    this.followUpRequired = false,
  });

  bool get isCompleted => outcome == SiteVisitOutcome.completed;

  SiteVisit copyWith({
    String? id,
    String? projectId,
    String? clientName,
    SiteVisitType? visitType,
    DateTime? date,
    String? startTime,
    String? endTime,
    String? assignedEmployee,
    String? purpose,
    String? siteAddress,
    double? gpsLat,
    double? gpsLng,
    String? contactPerson,
    String? contactNumber,
    String? selfieUrl,
    List<String>? images,
    List<String>? videos,
    List<String>? documents,
    SiteVisitOutcome? outcome,
    String? notes,
    String? issuesFound,
    String? workRequired,
    DateTime? nextVisitDate,
    bool? followUpRequired,
  }) {
    return SiteVisit(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      clientName: clientName ?? this.clientName,
      visitType: visitType ?? this.visitType,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      assignedEmployee: assignedEmployee ?? this.assignedEmployee,
      purpose: purpose ?? this.purpose,
      siteAddress: siteAddress ?? this.siteAddress,
      gpsLat: gpsLat ?? this.gpsLat,
      gpsLng: gpsLng ?? this.gpsLng,
      contactPerson: contactPerson ?? this.contactPerson,
      contactNumber: contactNumber ?? this.contactNumber,
      selfieUrl: selfieUrl ?? this.selfieUrl,
      images: images ?? this.images,
      videos: videos ?? this.videos,
      documents: documents ?? this.documents,
      outcome: outcome ?? this.outcome,
      notes: notes ?? this.notes,
      issuesFound: issuesFound ?? this.issuesFound,
      workRequired: workRequired ?? this.workRequired,
      nextVisitDate: nextVisitDate ?? this.nextVisitDate,
      followUpRequired: followUpRequired ?? this.followUpRequired,
    );
  }
}

// =============================================================================
// SITE PROGRESS ENTRY
// =============================================================================
class SiteProgressEntry {
  final String id;
  final String projectId;
  final String areaRoom;
  final DateTime progressDate;
  final String progressTime;
  final String submittedBy;
  final String workStage;
  final double progressPercent;
  final String description;
  final String workCompleted;
  final String workPending;
  final String issues;
  final String nextAction;
  final List<String> images;
  final List<String> videos;
  final FileVisibility visibility;
  final SiteProgressApprovalStatus approvalStatus;

  const SiteProgressEntry({
    required this.id,
    required this.projectId,
    this.areaRoom = '',
    required this.progressDate,
    this.progressTime = '',
    this.submittedBy = '',
    this.workStage = '',
    this.progressPercent = 0,
    this.description = '',
    this.workCompleted = '',
    this.workPending = '',
    this.issues = '',
    this.nextAction = '',
    this.images = const [],
    this.videos = const [],
    this.visibility = FileVisibility.internal,
    this.approvalStatus = SiteProgressApprovalStatus.submitted,
  });

  int get totalMediaCount => images.length + videos.length;

  SiteProgressEntry copyWith({
    String? id,
    String? projectId,
    String? areaRoom,
    DateTime? progressDate,
    String? progressTime,
    String? submittedBy,
    String? workStage,
    double? progressPercent,
    String? description,
    String? workCompleted,
    String? workPending,
    String? issues,
    String? nextAction,
    List<String>? images,
    List<String>? videos,
    FileVisibility? visibility,
    SiteProgressApprovalStatus? approvalStatus,
  }) {
    return SiteProgressEntry(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      areaRoom: areaRoom ?? this.areaRoom,
      progressDate: progressDate ?? this.progressDate,
      progressTime: progressTime ?? this.progressTime,
      submittedBy: submittedBy ?? this.submittedBy,
      workStage: workStage ?? this.workStage,
      progressPercent: progressPercent ?? this.progressPercent,
      description: description ?? this.description,
      workCompleted: workCompleted ?? this.workCompleted,
      workPending: workPending ?? this.workPending,
      issues: issues ?? this.issues,
      nextAction: nextAction ?? this.nextAction,
      images: images ?? this.images,
      videos: videos ?? this.videos,
      visibility: visibility ?? this.visibility,
      approvalStatus: approvalStatus ?? this.approvalStatus,
    );
  }
}

// =============================================================================
// APPROVAL COMMENT
// =============================================================================
class ApprovalComment {
  final String id;
  final String approvalId;
  final String userId;
  final String userName;
  final String text;
  final DateTime timestamp;
  final List<String> files;

  const ApprovalComment({
    required this.id,
    required this.approvalId,
    required this.userId,
    this.userName = '',
    required this.text,
    required this.timestamp,
    this.files = const [],
  });
}

// =============================================================================
// WORK APPROVAL
// =============================================================================
class WorkApproval {
  final String id;
  final String projectId;
  final String projectName;
  final String? milestoneId;
  final String milestoneName;
  final ApprovalType type;
  final String clientName;
  final String submittedBy;
  final DateTime submittedDate;
  final ApprovalStatus status;
  final String description;
  final List<String> files;
  final List<String> images;
  final List<String> videos;
  final List<ApprovalComment> comments;
  final DateTime? dueDate;
  final String message;
  final DateTime? approvedDate;
  final String? approvedBy;
  final DateTime? rejectedDate;
  final String? rejectedBy;
  final String? rejectionReason;

  const WorkApproval({
    required this.id,
    required this.projectId,
    this.projectName = '',
    this.milestoneId,
    this.milestoneName = '',
    required this.type,
    this.clientName = '',
    this.submittedBy = '',
    required this.submittedDate,
    this.status = ApprovalStatus.pending,
    this.description = '',
    this.files = const [],
    this.images = const [],
    this.videos = const [],
    this.comments = const [],
    this.dueDate,
    this.message = '',
    this.approvedDate,
    this.approvedBy,
    this.rejectedDate,
    this.rejectedBy,
    this.rejectionReason,
  });

  bool get isOverdue =>
      status == ApprovalStatus.pending &&
      dueDate != null &&
      dueDate!.isBefore(DateTime.now());

  WorkApproval copyWith({
    String? id,
    String? projectId,
    String? projectName,
    String? milestoneId,
    String? milestoneName,
    ApprovalType? type,
    String? clientName,
    String? submittedBy,
    DateTime? submittedDate,
    ApprovalStatus? status,
    String? description,
    List<String>? files,
    List<String>? images,
    List<String>? videos,
    List<ApprovalComment>? comments,
    DateTime? dueDate,
    String? message,
    DateTime? approvedDate,
    String? approvedBy,
    DateTime? rejectedDate,
    String? rejectedBy,
    String? rejectionReason,
  }) {
    return WorkApproval(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      projectName: projectName ?? this.projectName,
      milestoneId: milestoneId ?? this.milestoneId,
      milestoneName: milestoneName ?? this.milestoneName,
      type: type ?? this.type,
      clientName: clientName ?? this.clientName,
      submittedBy: submittedBy ?? this.submittedBy,
      submittedDate: submittedDate ?? this.submittedDate,
      status: status ?? this.status,
      description: description ?? this.description,
      files: files ?? this.files,
      images: images ?? this.images,
      videos: videos ?? this.videos,
      comments: comments ?? this.comments,
      dueDate: dueDate ?? this.dueDate,
      message: message ?? this.message,
      approvedDate: approvedDate ?? this.approvedDate,
      approvedBy: approvedBy ?? this.approvedBy,
      rejectedDate: rejectedDate ?? this.rejectedDate,
      rejectedBy: rejectedBy ?? this.rejectedBy,
      rejectionReason: rejectionReason ?? this.rejectionReason,
    );
  }
}

// =============================================================================
// CUSTOMER FEEDBACK
// =============================================================================
class CustomerFeedback {
  final double rating;
  final String feedback;
  final bool satisfied;
  final String additionalComment;

  const CustomerFeedback({
    this.rating = 0,
    this.feedback = '',
    this.satisfied = false,
    this.additionalComment = '',
  });
}

// =============================================================================
// COMPLAINT RESOLUTION
// =============================================================================
class ComplaintResolution {
  final String description;
  final String resolvedBy;
  final DateTime resolvedDate;
  final List<String> images;
  final List<String> documents;
  final bool customerConfirmed;

  const ComplaintResolution({
    required this.description,
    required this.resolvedBy,
    required this.resolvedDate,
    this.images = const [],
    this.documents = const [],
    this.customerConfirmed = false,
  });
}

// =============================================================================
// COMPLAINT
// =============================================================================
class Complaint {
  final String id;
  final String projectId;
  final String projectName;
  final String clientId;
  final String clientName;
  final ComplaintType type;
  final String title;
  final String description;
  final ComplaintPriority priority;
  final String areaRoom;
  final DateTime date;
  final String reportedBy;
  final String assignedTo;
  final ComplaintStatus status;
  final DateTime? expectedResolution;
  final ComplaintResolution? resolution;
  final CustomerFeedback? customerFeedback;
  final List<String> images;
  final List<String> videos;
  final List<String> documents;
  final List<String> comments;
  final int escalationLevel;

  const Complaint({
    required this.id,
    required this.projectId,
    this.projectName = '',
    this.clientId = '',
    this.clientName = '',
    required this.type,
    required this.title,
    required this.description,
    this.priority = ComplaintPriority.medium,
    this.areaRoom = '',
    required this.date,
    this.reportedBy = '',
    this.assignedTo = '',
    this.status = ComplaintStatus.open,
    this.expectedResolution,
    this.resolution,
    this.customerFeedback,
    this.images = const [],
    this.videos = const [],
    this.documents = const [],
    this.comments = const [],
    this.escalationLevel = 0,
  });

  bool get isOverdue =>
      status != ComplaintStatus.resolved &&
      status != ComplaintStatus.closed &&
      expectedResolution != null &&
      expectedResolution!.isBefore(DateTime.now());

  bool get isResolved =>
      status == ComplaintStatus.resolved || status == ComplaintStatus.closed;

  Complaint copyWith({
    String? id,
    String? projectId,
    String? projectName,
    String? clientId,
    String? clientName,
    ComplaintType? type,
    String? title,
    String? description,
    ComplaintPriority? priority,
    String? areaRoom,
    DateTime? date,
    String? reportedBy,
    String? assignedTo,
    ComplaintStatus? status,
    DateTime? expectedResolution,
    ComplaintResolution? resolution,
    CustomerFeedback? customerFeedback,
    List<String>? images,
    List<String>? videos,
    List<String>? documents,
    List<String>? comments,
    int? escalationLevel,
  }) {
    return Complaint(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      projectName: projectName ?? this.projectName,
      clientId: clientId ?? this.clientId,
      clientName: clientName ?? this.clientName,
      type: type ?? this.type,
      title: title ?? this.title,
      description: description ?? this.description,
      priority: priority ?? this.priority,
      areaRoom: areaRoom ?? this.areaRoom,
      date: date ?? this.date,
      reportedBy: reportedBy ?? this.reportedBy,
      assignedTo: assignedTo ?? this.assignedTo,
      status: status ?? this.status,
      expectedResolution: expectedResolution ?? this.expectedResolution,
      resolution: resolution ?? this.resolution,
      customerFeedback: customerFeedback ?? this.customerFeedback,
      images: images ?? this.images,
      videos: videos ?? this.videos,
      documents: documents ?? this.documents,
      comments: comments ?? this.comments,
      escalationLevel: escalationLevel ?? this.escalationLevel,
    );
  }
}

// =============================================================================
// MATERIAL EXPENSE
// =============================================================================
class MaterialExpense {
  final String id;
  final String projectId;
  final DateTime date;
  final String vendor;
  final String material;
  final String invoiceNumber;
  final double amount;
  final double paid;
  final double due;
  final DateTime? paymentDate;
  final String notes;
  final double commissionPercent;

  const MaterialExpense({
    required this.id,
    required this.projectId,
    required this.date,
    this.vendor = '',
    this.material = '',
    this.invoiceNumber = '',
    this.amount = 0,
    this.paid = 0,
    this.due = 0,
    this.paymentDate,
    this.notes = '',
    this.commissionPercent = 0,
  });

  double get calculatedCommission => amount * (commissionPercent / 100);

  PaymentStatus get paymentStatus {
    if (paid >= amount) return PaymentStatus.paid;
    if (paid > 0) return PaymentStatus.partiallyPaid;
    if (paymentDate != null && paymentDate!.isBefore(DateTime.now())) {
      return PaymentStatus.overdue;
    }
    return PaymentStatus.unpaid;
  }
}

// =============================================================================
// LABOUR EXPENSE
// =============================================================================
class LabourExpense {
  final String id;
  final String projectId;
  final DateTime date;
  final String labourName;
  final String work;
  final double amount;
  final double paid;
  final double due;
  final DateTime? paymentDate;
  final String notes;
  final double commissionPercent;

  const LabourExpense({
    required this.id,
    required this.projectId,
    required this.date,
    this.labourName = '',
    this.work = '',
    this.amount = 0,
    this.paid = 0,
    this.due = 0,
    this.paymentDate,
    this.notes = '',
    this.commissionPercent = 0,
  });

  double get calculatedCommission => amount * (commissionPercent / 100);

  PaymentStatus get paymentStatus {
    if (paid >= amount) return PaymentStatus.paid;
    if (paid > 0) return PaymentStatus.partiallyPaid;
    if (paymentDate != null && paymentDate!.isBefore(DateTime.now())) {
      return PaymentStatus.overdue;
    }
    return PaymentStatus.unpaid;
  }
}

// =============================================================================
// FEE RECORD
// =============================================================================
class FeeRecord {
  final String id;
  final String projectId;
  final DateTime date;
  final CommercialRecordType feeType;
  final String receivedBy;
  final double amount;
  final double paid;
  final double due;
  final String notes;
  final double commissionPercent;

  const FeeRecord({
    required this.id,
    required this.projectId,
    required this.date,
    this.feeType = CommercialRecordType.consultingFee,
    this.receivedBy = '',
    this.amount = 0,
    this.paid = 0,
    this.due = 0,
    this.notes = '',
    this.commissionPercent = 0,
  });

  double get calculatedCommission => amount * (commissionPercent / 100);
}

// =============================================================================
// COMMISSION RECORD
// =============================================================================
class CommissionRecord {
  final String id;
  final String type;
  final String beneficiary;
  final double baseAmount;
  final double percentage;
  final double fixedAmount;
  final double calculatedCommission;
  final DateTime date;
  final String notes;

  const CommissionRecord({
    required this.id,
    this.type = '',
    this.beneficiary = '',
    this.baseAmount = 0,
    this.percentage = 0,
    this.fixedAmount = 0,
    this.calculatedCommission = 0,
    required this.date,
    this.notes = '',
  });

  /// Computed commission from base + percentage + fixed
  double get totalCommission =>
      fixedAmount > 0 ? fixedAmount : baseAmount * (percentage / 100);
}

// =============================================================================
// PROJECT PAYMENT
// =============================================================================
class ProjectPayment {
  final String id;
  final String projectId;
  final DateTime date;
  final double amount;
  final String mode;
  final String reference;
  final String notes;

  const ProjectPayment({
    required this.id,
    required this.projectId,
    required this.date,
    this.amount = 0,
    this.mode = '',
    this.reference = '',
    this.notes = '',
  });
}

// =============================================================================
// PROJECT COMMERCIAL SUMMARY — Computed aggregate
// =============================================================================
class ProjectCommercialSummary {
  final double contractAmount;
  final double additionalWork;
  final double discount;
  final double materialCost;
  final double labourCost;
  final double supervisionFees;
  final double consultingFees;
  final double totalReceived;
  final double totalCommission;

  const ProjectCommercialSummary({
    this.contractAmount = 0,
    this.additionalWork = 0,
    this.discount = 0,
    this.materialCost = 0,
    this.labourCost = 0,
    this.supervisionFees = 0,
    this.consultingFees = 0,
    this.totalReceived = 0,
    this.totalCommission = 0,
  });

  double get revisedContract => contractAmount + additionalWork - discount;
  double get totalExpenses =>
      materialCost + labourCost + supervisionFees + consultingFees;
  double get totalOutstanding => revisedContract - totalReceived;
  double get overdue => totalOutstanding > 0 ? totalOutstanding * 0.3 : 0;
  double get grossMargin => revisedContract > 0
      ? ((revisedContract - totalExpenses) / revisedContract) * 100
      : 0;
}

// =============================================================================
// PROJECT TIMELINE EVENT
// =============================================================================
class ProjectTimelineEvent {
  final String id;
  final String projectId;
  final DateTime date;
  final String user;
  final String action;
  final String description;
  final IconData icon;
  final Color iconColor;
  final List<String> attachments;

  const ProjectTimelineEvent({
    required this.id,
    required this.projectId,
    required this.date,
    this.user = '',
    required this.action,
    this.description = '',
    this.icon = Icons.circle,
    this.iconColor = const Color(0xFF64748B),
    this.attachments = const [],
  });
}

// =============================================================================
// PROJECT ALERT
// =============================================================================
class ProjectAlert {
  final String id;
  final String projectId;
  final String type;
  final String message;
  final String severity;
  final String actionRoute;
  final IconData icon;
  final Color color;

  const ProjectAlert({
    required this.id,
    required this.projectId,
    required this.type,
    required this.message,
    this.severity = 'warning',
    this.actionRoute = '',
    this.icon = Icons.warning_amber_rounded,
    this.color = const Color(0xFFF59E0B),
  });
}

// =============================================================================
// PROJECT RATING
// =============================================================================
class ProjectRating {
  final String category;
  final double score;

  const ProjectRating({
    required this.category,
    required this.score,
  });

  /// Clamps score to 1–10 range
  double get normalizedScore => score.clamp(1.0, 10.0);
}

// =============================================================================
// PROJECT KPI SUMMARY — Computed dashboard aggregate
// =============================================================================
class ProjectKpiSummary {
  final int totalProjects;
  final int ongoingProjects;
  final int completedProjects;
  final int onTimeProjects;
  final int delayedProjects;
  final int startingSoon;
  final int pendingApprovals;
  final int openComplaints;
  final int pendingTasks;
  final double outstandingAmountLakhs;
  final int designPending;
  final int executionPending;
  final int procurementPending;
  final int paymentPending;

  const ProjectKpiSummary({
    this.totalProjects = 0,
    this.ongoingProjects = 0,
    this.completedProjects = 0,
    this.onTimeProjects = 0,
    this.delayedProjects = 0,
    this.startingSoon = 0,
    this.pendingApprovals = 0,
    this.openComplaints = 0,
    this.pendingTasks = 0,
    this.outstandingAmountLakhs = 0,
    this.designPending = 0,
    this.executionPending = 0,
    this.procurementPending = 0,
    this.paymentPending = 0,
  });
}

// =============================================================================
// GANTT TASK ITEM — Flat item for Gantt chart rendering
// =============================================================================
class GanttTaskItem {
  final String id;
  final String title;
  final String projectName;
  final DateTime startDate;
  final DateTime endDate;
  final double progress;
  final String assignee;
  final ProjectTaskStatus status;
  final List<String> dependencyIds;
  final bool isRescheduled;
  final DateTime? originalEndDate;
  final String? rescheduleReason;
  final bool isMilestone;

  const GanttTaskItem({
    required this.id,
    required this.title,
    this.projectName = '',
    required this.startDate,
    required this.endDate,
    this.progress = 0,
    this.assignee = '',
    this.status = ProjectTaskStatus.toDo,
    this.dependencyIds = const [],
    this.isRescheduled = false,
    this.originalEndDate,
    this.rescheduleReason,
    this.isMilestone = false,
  });

  int get durationDays => endDate.difference(startDate).inDays;

  bool get isDelayed =>
      status != ProjectTaskStatus.completed &&
      endDate.isBefore(DateTime.now());

  int get delayDays {
    if (!isDelayed) return 0;
    return DateTime.now().difference(endDate).inDays;
  }
}

// =============================================================================
// PROJECT — Master model connecting entire project lifecycle
// =============================================================================
class Project {
  final String id;
  final String name;
  final String code;
  final ProjectType type;
  final ProjectStatus status;
  final ProjectHealth health;
  final ProjectStage currentStage;
  final String description;
  final String category;
  final String? coverImage;

  // Client
  final String clientId;
  final String clientName;
  final String clientPhone;
  final String clientEmail;

  // Site
  final String siteName;
  final String siteAddress;
  final String siteCity;
  final String siteState;
  final String sitePincode;
  final double? siteLat;
  final double? siteLng;
  final String siteContactPerson;
  final String siteContactNumber;

  // Areas
  final List<ProjectArea> areas;
  final double totalAreaSqFt;

  // Team
  final List<ProjectTeamMember> team;
  final String projectManager;
  final String designer;
  final String siteSupervisor;
  final String salesOwner;

  // Dates
  final DateTime createdDate;
  final DateTime plannedStartDate;
  final DateTime expectedCompletion;
  final DateTime? actualCompletion;
  final DateTime lastUpdated;

  // Progress
  final double progressPercent;
  final double designProgress;
  final double executionProgress;
  final double procurementProgress;
  final double paymentProgress;

  // Commercials
  final double contractAmountLakhs;
  final double totalReceivedLakhs;
  final double totalOutstandingLakhs;

  // Counts
  final int totalMilestones;
  final int completedMilestones;
  final int totalTasks;
  final int completedTasks;
  final int pendingTasks;
  final int overdueTasks;
  final int pendingApprovals;
  final int openComplaints;

  // Ratings
  final List<ProjectRating> ratings;

  const Project({
    required this.id,
    required this.name,
    this.code = '',
    this.type = ProjectType.turnkey,
    this.status = ProjectStatus.draft,
    this.health = ProjectHealth.healthy,
    this.currentStage = ProjectStage.planning,
    this.description = '',
    this.category = '',
    this.coverImage,
    this.clientId = '',
    this.clientName = '',
    this.clientPhone = '',
    this.clientEmail = '',
    this.siteName = '',
    this.siteAddress = '',
    this.siteCity = '',
    this.siteState = '',
    this.sitePincode = '',
    this.siteLat,
    this.siteLng,
    this.siteContactPerson = '',
    this.siteContactNumber = '',
    this.areas = const [],
    this.totalAreaSqFt = 0,
    this.team = const [],
    this.projectManager = '',
    this.designer = '',
    this.siteSupervisor = '',
    this.salesOwner = '',
    required this.createdDate,
    required this.plannedStartDate,
    required this.expectedCompletion,
    this.actualCompletion,
    required this.lastUpdated,
    this.progressPercent = 0,
    this.designProgress = 0,
    this.executionProgress = 0,
    this.procurementProgress = 0,
    this.paymentProgress = 0,
    this.contractAmountLakhs = 0,
    this.totalReceivedLakhs = 0,
    this.totalOutstandingLakhs = 0,
    this.totalMilestones = 0,
    this.completedMilestones = 0,
    this.totalTasks = 0,
    this.completedTasks = 0,
    this.pendingTasks = 0,
    this.overdueTasks = 0,
    this.pendingApprovals = 0,
    this.openComplaints = 0,
    this.ratings = const [],
  });

  // Computed getters
  int get daysElapsed => DateTime.now().difference(plannedStartDate).inDays;
  int get daysRemaining => expectedCompletion.difference(DateTime.now()).inDays;
  bool get isOverdue =>
      status != ProjectStatus.completed &&
      status != ProjectStatus.closed &&
      status != ProjectStatus.cancelled &&
      expectedCompletion.isBefore(DateTime.now());

  int get delayDays {
    if (!isOverdue) return 0;
    return DateTime.now().difference(expectedCompletion).inDays;
  }

  PaymentStatus get paymentStatus {
    if (totalOutstandingLakhs <= 0) return PaymentStatus.paid;
    if (totalReceivedLakhs > 0) return PaymentStatus.partiallyPaid;
    return PaymentStatus.unpaid;
  }

  double get overallRating {
    if (ratings.isEmpty) return 0;
    final total = ratings.fold<double>(0, (sum, r) => sum + r.score);
    return total / ratings.length;
  }

  String get formattedContract => '₹${contractAmountLakhs.toStringAsFixed(1)}L';
  String get formattedReceived => '₹${totalReceivedLakhs.toStringAsFixed(1)}L';
  String get formattedOutstanding =>
      '₹${totalOutstandingLakhs.toStringAsFixed(1)}L';

  Project copyWith({
    String? id,
    String? name,
    String? code,
    ProjectType? type,
    ProjectStatus? status,
    ProjectHealth? health,
    ProjectStage? currentStage,
    String? description,
    String? category,
    String? coverImage,
    String? clientId,
    String? clientName,
    String? clientPhone,
    String? clientEmail,
    String? siteName,
    String? siteAddress,
    String? siteCity,
    String? siteState,
    String? sitePincode,
    double? siteLat,
    double? siteLng,
    String? siteContactPerson,
    String? siteContactNumber,
    List<ProjectArea>? areas,
    double? totalAreaSqFt,
    List<ProjectTeamMember>? team,
    String? projectManager,
    String? designer,
    String? siteSupervisor,
    String? salesOwner,
    DateTime? createdDate,
    DateTime? plannedStartDate,
    DateTime? expectedCompletion,
    DateTime? actualCompletion,
    DateTime? lastUpdated,
    double? progressPercent,
    double? designProgress,
    double? executionProgress,
    double? procurementProgress,
    double? paymentProgress,
    double? contractAmountLakhs,
    double? totalReceivedLakhs,
    double? totalOutstandingLakhs,
    int? totalMilestones,
    int? completedMilestones,
    int? totalTasks,
    int? completedTasks,
    int? pendingTasks,
    int? overdueTasks,
    int? pendingApprovals,
    int? openComplaints,
    List<ProjectRating>? ratings,
  }) {
    return Project(
      id: id ?? this.id,
      name: name ?? this.name,
      code: code ?? this.code,
      type: type ?? this.type,
      status: status ?? this.status,
      health: health ?? this.health,
      currentStage: currentStage ?? this.currentStage,
      description: description ?? this.description,
      category: category ?? this.category,
      coverImage: coverImage ?? this.coverImage,
      clientId: clientId ?? this.clientId,
      clientName: clientName ?? this.clientName,
      clientPhone: clientPhone ?? this.clientPhone,
      clientEmail: clientEmail ?? this.clientEmail,
      siteName: siteName ?? this.siteName,
      siteAddress: siteAddress ?? this.siteAddress,
      siteCity: siteCity ?? this.siteCity,
      siteState: siteState ?? this.siteState,
      sitePincode: sitePincode ?? this.sitePincode,
      siteLat: siteLat ?? this.siteLat,
      siteLng: siteLng ?? this.siteLng,
      siteContactPerson: siteContactPerson ?? this.siteContactPerson,
      siteContactNumber: siteContactNumber ?? this.siteContactNumber,
      areas: areas ?? this.areas,
      totalAreaSqFt: totalAreaSqFt ?? this.totalAreaSqFt,
      team: team ?? this.team,
      projectManager: projectManager ?? this.projectManager,
      designer: designer ?? this.designer,
      siteSupervisor: siteSupervisor ?? this.siteSupervisor,
      salesOwner: salesOwner ?? this.salesOwner,
      createdDate: createdDate ?? this.createdDate,
      plannedStartDate: plannedStartDate ?? this.plannedStartDate,
      expectedCompletion: expectedCompletion ?? this.expectedCompletion,
      actualCompletion: actualCompletion ?? this.actualCompletion,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      progressPercent: progressPercent ?? this.progressPercent,
      designProgress: designProgress ?? this.designProgress,
      executionProgress: executionProgress ?? this.executionProgress,
      procurementProgress: procurementProgress ?? this.procurementProgress,
      paymentProgress: paymentProgress ?? this.paymentProgress,
      contractAmountLakhs: contractAmountLakhs ?? this.contractAmountLakhs,
      totalReceivedLakhs: totalReceivedLakhs ?? this.totalReceivedLakhs,
      totalOutstandingLakhs:
          totalOutstandingLakhs ?? this.totalOutstandingLakhs,
      totalMilestones: totalMilestones ?? this.totalMilestones,
      completedMilestones: completedMilestones ?? this.completedMilestones,
      totalTasks: totalTasks ?? this.totalTasks,
      completedTasks: completedTasks ?? this.completedTasks,
      pendingTasks: pendingTasks ?? this.pendingTasks,
      overdueTasks: overdueTasks ?? this.overdueTasks,
      pendingApprovals: pendingApprovals ?? this.pendingApprovals,
      openComplaints: openComplaints ?? this.openComplaints,
      ratings: ratings ?? this.ratings,
    );
  }
}
