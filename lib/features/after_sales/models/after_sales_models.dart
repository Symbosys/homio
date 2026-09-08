// Domain models for Module: After-Sales Service (Snags, Warranty, CSAT & Retention)

enum SnagCategory {
  civil,
  carpentry,
  electricalMep,
  paintPolish,
  glassHardware;

  String get displayName {
    switch (this) {
      case SnagCategory.civil:
        return 'Civil & Masonry';
      case SnagCategory.carpentry:
        return 'Carpentry & Modular Fitments';
      case SnagCategory.electricalMep:
        return 'Electrical & MEP';
      case SnagCategory.paintPolish:
        return 'Painting & PU Polishing';
      case SnagCategory.glassHardware:
        return 'Glass & Hardware Fittings';
    }
  }
}

enum SnagPriority {
  critical,
  high,
  medium,
  low;

  String get displayName {
    switch (this) {
      case SnagPriority.critical:
        return 'Critical (4h SLA)';
      case SnagPriority.high:
        return 'High (24h SLA)';
      case SnagPriority.medium:
        return 'Medium (48h SLA)';
      case SnagPriority.low:
        return 'Low (7d SLA)';
    }
  }
}

enum WarrantyStatus {
  active10YrStructural,
  active1YrComprehensive,
  outOfWarranty,
  billable;

  String get displayName {
    switch (this) {
      case WarrantyStatus.active10YrStructural:
        return '10-Yr Structural Warranty';
      case WarrantyStatus.active1YrComprehensive:
        return '1-Yr Comprehensive Warranty';
      case WarrantyStatus.outOfWarranty:
        return 'Warranty Expired';
      case WarrantyStatus.billable:
        return 'Billable Repair';
    }
  }

  bool get isCovered =>
      this == WarrantyStatus.active10YrStructural ||
      this == WarrantyStatus.active1YrComprehensive;
}

enum SnagStatus {
  open,
  dispatched,
  inProgress,
  resolved,
  warrantyDenied;

  String get displayName {
    switch (this) {
      case SnagStatus.open:
        return 'Reported / Open';
      case SnagStatus.dispatched:
        return 'Technician Dispatched';
      case SnagStatus.inProgress:
        return 'Work In-Progress';
      case SnagStatus.resolved:
        return 'Resolved & Signed-Off';
      case SnagStatus.warrantyDenied:
        return 'Warranty Denied';
    }
  }
}

enum CallStatus {
  scheduled,
  completed,
  noAnswer,
  rescheduled;

  String get displayName {
    switch (this) {
      case CallStatus.scheduled:
        return 'Scheduled';
      case CallStatus.completed:
        return 'Completed';
      case CallStatus.noAnswer:
        return 'No Answer';
      case CallStatus.rescheduled:
        return 'Rescheduled';
    }
  }
}

enum ReferralRewardStatus {
  eligible,
  credited,
  claimed;

  String get displayName {
    switch (this) {
      case ReferralRewardStatus.eligible:
        return 'Eligible for Voucher';
      case ReferralRewardStatus.credited:
        return '₹10,000 Credit Applied';
      case ReferralRewardStatus.claimed:
        return 'Reward Claimed';
    }
  }
}

class SnagTicket {
  final String id;
  final String ticketNumber;
  final String projectId;
  final String projectName;
  final String clientName;
  final String clientPhone;
  final DateTime handoverDate;
  final SnagCategory category;
  final SnagPriority priority;
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

  bool get isOverdue =>
      status != SnagStatus.resolved && DateTime.now().isAfter(slaDeadline);

  SnagTicket copyWith({
    String? id,
    String? ticketNumber,
    String? projectId,
    String? projectName,
    String? clientName,
    String? clientPhone,
    DateTime? handoverDate,
    SnagCategory? category,
    SnagPriority? priority,
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
  final double? csatScore; // Overall score 1-10
  final double? designQualityRating; // 1-10 (40% weight)
  final double? timelineRating; // 1-10 (30% weight)
  final double? behaviourRating; // 1-10 (30% weight)
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

  bool get isHighSatisfaction => (csatScore ?? 0) >= 8.0;

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
