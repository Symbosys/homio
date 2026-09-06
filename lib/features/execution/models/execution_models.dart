import 'package:flutter/material.dart';

/// Interior Contract Commercial Models (PRD Section 8.5 & requirmenet.md)
enum ContractModel {
  fixedConsulting(
    'Fixed Consulting Model',
    'Material & Labour billed at actuals + Fixed professional fee split across milestones',
    Icons.receipt_long_rounded,
  ),
  percentageModel(
    'Percentage-of-Cost Model',
    'Agreed percentage fee applied dynamically to verified material + labour spend',
    Icons.percent_rounded,
  ),
  turnkeyContract(
    'Turnkey Contract Model',
    'Fixed lump sum contract with 5-stage milestone payment schedule (10%-20%-25%-35%-10%)',
    Icons.villa_rounded,
  );

  final String title;
  final String description;
  final IconData icon;
  const ContractModel(this.title, this.description, this.icon);

  String get label => title;
}

/// Project lifecycle status
enum ProjectStatus {
  planning('Planning & Permits', Color(0xFF64748B), Icons.assignment_outlined),
  inDesign('2D / 3D Design Freeze', Color(0xFF3B82F6), Icons.draw_rounded),
  inExecution('Site Execution Active', Color(0xFF10B981), Icons.engineering_rounded),
  snagging('QC & Snag Resolution', Color(0xFFF59E0B), Icons.fact_check_rounded),
  completed('Handover Completed', Color(0xFF8B5CF6), Icons.verified_rounded),
  onHold('Work Suspended / Dues Pending', Color(0xFFEF4444), Icons.pause_circle_rounded);

  final String label;
  final Color color;
  final IconData icon;
  const ProjectStatus(this.label, this.color, this.icon);

  static const ProjectStatus inProgress = ProjectStatus.inExecution;
}

/// Task execution priorities
enum TaskPriority {
  low('Low', Color(0xFF64748B)),
  medium('Medium', Color(0xFF3B82F6)),
  high('High', Color(0xFFF59E0B)),
  urgent('Urgent / Critical', Color(0xFFEF4444));

  final String label;
  final Color color;
  const TaskPriority(this.label, this.color);

  static const TaskPriority critical = TaskPriority.urgent;
}

/// Schedule health states
enum TimelineHealth {
  onTime('On-Time', Color(0xFF10B981), Icons.check_circle_rounded),
  atRisk('At Risk (< 1 Wk Delay)', Color(0xFFF59E0B), Icons.warning_amber_rounded),
  delayed('Delayed (> 1 Wk)', Color(0xFFEF4444), Icons.error_outline_rounded);

  final String label;
  final Color color;
  final IconData icon;
  const TimelineHealth(this.label, this.color, this.icon);

  static const TimelineHealth onTrack = TimelineHealth.onTime;
}

/// Snag / Client complaint categories (PRD Section 8.3)
enum SnagCategory {
  qualityDefect('Quality Defect & Finishing', Icons.construction_rounded),
  timelineDelay('Milestone Timeline Delay', Icons.hourglass_bottom_rounded),
  workerBehaviour('Worker / Contractor Conduct', Icons.sentiment_dissatisfied_rounded),
  siteCleanliness('Site Cleanliness & Debris', Icons.cleaning_services_rounded),
  materialDeviation('Material Brand / Spec Deviation', Icons.sync_problem_rounded),
  measurementError('Measurement & Alignment Error', Icons.straighten_rounded);

  final String label;
  final IconData icon;
  const SnagCategory(this.label, this.icon);
}

/// Snag ticket resolution status
enum SnagStatus {
  open('Open Ticket', Color(0xFFEF4444)),
  inProgress('Under Rectification', Color(0xFFF59E0B)),
  underReview('Client Inspection Review', Color(0xFF3B82F6)),
  resolvedOnTime('Resolved On-Time', Color(0xFF10B981)),
  resolvedDelayed('Resolved Delayed', Color(0xFFEA580C));

  final String label;
  final Color color;
  const SnagStatus(this.label, this.color);

  static const SnagStatus resolved = SnagStatus.resolvedOnTime;
  static const SnagStatus clientVerified = SnagStatus.resolvedOnTime;
}

/// Multi-stakeholder rating targets (PRD Section 8.6)
enum StakeholderType {
  supervisor('Site Supervisor', Icons.badge_rounded),
  labour('Labour & Tradesmen', Icons.hardware_rounded),
  materialVendor('Material Supplier / Vendor', Icons.store_rounded),
  designer('Interior Architect / Designer', Icons.design_services_rounded);

  final String label;
  final IconData icon;
  const StakeholderType(this.label, this.icon);

  static const StakeholderType siteSupervisor = StakeholderType.supervisor;
  static const StakeholderType labourContractor = StakeholderType.labour;
  static const StakeholderType interiorDesigner = StakeholderType.designer;
}

enum WbsTaskStatus {
  notStarted('Not Started', Color(0xFF64748B)),
  inProgress('In Progress', Color(0xFF3B82F6)),
  completed('Completed', Color(0xFF10B981)),
  delayed('Delayed', Color(0xFFEF4444));

  final String label;
  final Color color;
  const WbsTaskStatus(this.label, this.color);
}

class RescheduleAuditRecord {
  final DateTime originalDate;
  final DateTime revisedDate;
  final String reason;
  final String rescheduledBy;
  final DateTime timestamp;

  const RescheduleAuditRecord({
    required this.originalDate,
    required this.revisedDate,
    required this.reason,
    required this.rescheduledBy,
    required this.timestamp,
  });
}

class WbsChecklistItem {
  final String id;
  final String label;
  final bool isDone;

  const WbsChecklistItem({
    required this.id,
    required this.label,
    this.isDone = false,
  });

  WbsChecklistItem copyWith({String? id, String? label, bool? isDone}) {
    return WbsChecklistItem(
      id: id ?? this.id,
      label: label ?? this.label,
      isDone: isDone ?? this.isDone,
    );
  }
}

/// Granular WBS Task (PRD Section 8.1 & requirmenet.md)
class WbsTask {
  final String id;
  final String milestoneId;
  final String title;
  final String scopeDescription;
  final DateTime originalTargetDate; // Preserved for delay auditing
  final DateTime currentDueDate;
  final String assigneeName;
  final String assigneeRole;
  final TaskPriority priority;
  final bool isCompleted;
  final bool isRescheduled;
  final String? rescheduleReason;
  final DateTime? rescheduledAt;
  final List<String> checklistItems;
  final List<bool> checklistChecked;
  final List<String> attachmentFileUrls;

  WbsTask({
    required this.id,
    String? milestoneId,
    String? streamId,
    required this.title,
    String? scopeDescription,
    String? description,
    DateTime? originalTargetDate,
    DateTime? startDate,
    DateTime? plannedEndDate,
    DateTime? currentDueDate,
    DateTime? endDate,
    String? assigneeName,
    String? assignedTo,
    String? assigneeRole,
    this.priority = TaskPriority.medium,
    bool isCompleted = false,
    WbsTaskStatus? status,
    this.isRescheduled = false,
    this.rescheduleReason,
    this.rescheduledAt,
    List<String> checklistItems = const [],
    List<bool> checklistChecked = const [],
    List<WbsChecklistItem>? checklist,
    this.attachmentFileUrls = const [],
    double? progress,
  })  : milestoneId = milestoneId ?? streamId ?? 'MS-01',
        scopeDescription = scopeDescription ?? description ?? title,
        originalTargetDate = originalTargetDate ?? plannedEndDate ?? DateTime.now(),
        currentDueDate = currentDueDate ?? endDate ?? plannedEndDate ?? DateTime.now(),
        assigneeName = assigneeName ?? assignedTo ?? 'Assigned Trade',
        assigneeRole = assigneeRole ?? 'Contractor',
        isCompleted = isCompleted || (status == WbsTaskStatus.completed || (progress != null && progress >= 1.0)),
        checklistItems = checklist != null ? checklist.map((c) => c.label).toList() : checklistItems,
        checklistChecked = checklist != null ? checklist.map((c) => c.isDone).toList() : checklistChecked;

  /// Days slipped from original creation target date
  int get daysDelayed => currentDueDate.difference(originalTargetDate).inDays;

  String get description => scopeDescription;
  String get assignedTo => assigneeName;
  DateTime get startDate => originalTargetDate.subtract(const Duration(days: 7));
  DateTime get plannedEndDate => originalTargetDate;
  DateTime get endDate => currentDueDate;
  DateTime get revisedEndDate => currentDueDate;
  double get progress => isCompleted
      ? 1.0
      : (checklistItems.isEmpty
          ? 0.0
          : checklistChecked.where((b) => b).length / checklistItems.length);
  WbsTaskStatus get status => isCompleted
      ? WbsTaskStatus.completed
      : (daysDelayed > 0 ? WbsTaskStatus.delayed : WbsTaskStatus.inProgress);
  String? get delayReason => rescheduleReason;
  bool get isDelayed => daysDelayed > 0;
  List<RescheduleAuditRecord> get rescheduleHistory => [
        if (isRescheduled && rescheduledAt != null)
          RescheduleAuditRecord(
            originalDate: originalTargetDate,
            revisedDate: currentDueDate,
            reason: rescheduleReason ?? 'Site delay',
            rescheduledBy: 'Site Supervisor',
            timestamp: rescheduledAt!,
          ),
      ];
  List<WbsChecklistItem> get checklist => [
        for (int i = 0; i < checklistItems.length; i++)
          WbsChecklistItem(
            id: 'ck-$i',
            label: checklistItems[i],
            isDone: i < checklistChecked.length ? checklistChecked[i] : false,
          ),
      ];

  WbsTask copyWith({
    String? id,
    String? milestoneId,
    String? title,
    String? scopeDescription,
    DateTime? originalTargetDate,
    DateTime? currentDueDate,
    DateTime? revisedEndDate,
    String? assigneeName,
    String? assigneeRole,
    TaskPriority? priority,
    bool? isCompleted,
    bool? isRescheduled,
    String? rescheduleReason,
    String? delayReason,
    DateTime? rescheduledAt,
    List<String>? checklistItems,
    List<bool>? checklistChecked,
    List<String>? attachmentFileUrls,
    double? progress,
    WbsTaskStatus? status,
    List<RescheduleAuditRecord>? rescheduleHistory,
    List<WbsChecklistItem>? checklist,
  }) {
    final updatedChecklist = checklist;
    final updatedItems = updatedChecklist != null
        ? updatedChecklist.map((c) => c.label).toList()
        : (checklistItems ?? this.checklistItems);
    final updatedChecked = updatedChecklist != null
        ? updatedChecklist.map((c) => c.isDone).toList()
        : (checklistChecked ?? this.checklistChecked);

    return WbsTask(
      id: id ?? this.id,
      milestoneId: milestoneId ?? this.milestoneId,
      title: title ?? this.title,
      scopeDescription: scopeDescription ?? this.scopeDescription,
      originalTargetDate: originalTargetDate ?? this.originalTargetDate,
      currentDueDate: revisedEndDate ?? (currentDueDate ?? this.currentDueDate),
      assigneeName: assigneeName ?? this.assigneeName,
      assigneeRole: assigneeRole ?? this.assigneeRole,
      priority: priority ?? this.priority,
      isCompleted: isCompleted ?? (progress != null ? progress >= 1.0 : this.isCompleted),
      isRescheduled: isRescheduled ?? (revisedEndDate != null || delayReason != null || this.isRescheduled),
      rescheduleReason: delayReason ?? (rescheduleReason ?? this.rescheduleReason),
      rescheduledAt: rescheduledAt ?? (revisedEndDate != null ? DateTime.now() : this.rescheduledAt),
      checklistItems: updatedItems,
      checklistChecked: updatedChecked,
      attachmentFileUrls: attachmentFileUrls ?? this.attachmentFileUrls,
    );
  }
}

/// Work Stream / Milestone Hierarchy (PRD Section 8.1)
class MilestoneWorkStream {
  final String id;
  final String projectId;
  final String name; // e.g. "False Ceiling & POP", "Carpentry & Modular Woodwork"
  final DateTime startDate;
  final DateTime endDate;
  final double completionPercentage; // 0.0 to 1.0
  final List<WbsTask> tasks;
  final bool isApprovalRequired;
  final bool isApprovedByClient;
  final String? clientOtpSignoffDate;

  MilestoneWorkStream({
    required this.id,
    required this.projectId,
    required this.name,
    required this.startDate,
    required this.endDate,
    required this.completionPercentage,
    List<WbsTask>? tasks,
    this.isApprovalRequired = true,
    this.isApprovedByClient = false,
    this.clientOtpSignoffDate,
  }) : tasks = tasks != null ? List.from(tasks) : [];

  double get streamProgress => completionPercentage;
  double get weightagePercentage => 25.0;
  String get contractorName => 'Lead Trade Contractor';
  bool get isCompleted => completionPercentage >= 1.0;

  MilestoneWorkStream copyWith({
    String? id,
    String? projectId,
    String? name,
    DateTime? startDate,
    DateTime? endDate,
    double? completionPercentage,
    List<WbsTask>? tasks,
    bool? isApprovalRequired,
    bool? isApprovedByClient,
    String? clientOtpSignoffDate,
  }) {
    return MilestoneWorkStream(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      name: name ?? this.name,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      completionPercentage: completionPercentage ?? this.completionPercentage,
      tasks: tasks != null ? List.from(tasks) : List.from(this.tasks),
      isApprovalRequired: isApprovalRequired ?? this.isApprovalRequired,
      isApprovedByClient: isApprovedByClient ?? this.isApprovedByClient,
      clientOtpSignoffDate: clientOtpSignoffDate ?? this.clientOtpSignoffDate,
    );
  }
}

/// Project Master Profile Entity
class ProjectMaster {
  final String id;
  final String projectCode; // e.g., "PRJ-2026-0104"
  final String projectTitle;
  final String clientName;
  final String clientPhone;
  final String clientEmail;
  final String siteAddress;
  final String city;
  final double floorAreaSqft;
  final String projectManagerName;
  final String siteSupervisorName;
  final DateTime startDate;
  final DateTime targetHandoverDate;
  final ProjectStatus status;
  final TimelineHealth timelineHealth;
  final ContractModel contractModel;
  final double totalContractValue;
  final double totalBilled;
  final double totalPaid;
  final int totalDesignFiles;
  final int completedDesignFiles;
  final double averageCsatRating;
  final List<MilestoneWorkStream> milestones;
  final List<SiteMediaLog> mediaLogs;
  final List<SnagTicket> snags;
  final List<StageApprovalRequest> stageApprovals;
  final List<StakeholderRating> ratings;
  final List<FinancialLedgerEntry> ledgerEntries;

  ProjectMaster({
    required this.id,
    required this.projectCode,
    required this.projectTitle,
    required this.clientName,
    required this.clientPhone,
    required this.clientEmail,
    required this.siteAddress,
    required this.city,
    required this.floorAreaSqft,
    required this.projectManagerName,
    required this.siteSupervisorName,
    required this.startDate,
    required this.targetHandoverDate,
    this.status = ProjectStatus.inExecution,
    this.timelineHealth = TimelineHealth.onTime,
    this.contractModel = ContractModel.turnkeyContract,
    required this.totalContractValue,
    required this.totalBilled,
    required this.totalPaid,
    this.totalDesignFiles = 18,
    this.completedDesignFiles = 18,
    this.averageCsatRating = 4.8,
    List<MilestoneWorkStream>? milestones,
    List<SiteMediaLog>? mediaLogs,
    List<SnagTicket>? snags,
    List<StageApprovalRequest>? stageApprovals,
    List<StakeholderRating>? ratings,
    List<FinancialLedgerEntry>? ledgerEntries,
  })  : milestones = milestones != null ? List.from(milestones) : [],
        mediaLogs = mediaLogs != null ? List.from(mediaLogs) : [],
        snags = snags != null ? List.from(snags) : [],
        stageApprovals = stageApprovals != null ? List.from(stageApprovals) : [],
        ratings = ratings != null ? List.from(ratings) : [],
        ledgerEntries = ledgerEntries != null ? List.from(ledgerEntries) : [];

  /// Pending dues in INR
  double get pendingDues => totalBilled - totalPaid;

  /// Overall completion percentage across milestones
  double get overallProgress {
    if (milestones.isEmpty) return 0.0;
    final total = milestones.fold(0.0, (sum, m) => sum + m.completionPercentage);
    return total / milestones.length;
  }

  String get projectName => projectTitle;
  List<MilestoneWorkStream> get workStreams => milestones;
  TimelineHealth get health => timelineHealth;
  String get siteLocation => siteAddress;
  double get billedAmount => totalBilled;
  double get receivedAmount => totalPaid;
  DateTime get expectedEndDate => targetHandoverDate;
  String get interiorDesignerName => 'Ananya Roy (Lead Architect)';

  ProjectMaster copyWith({
    String? id,
    String? projectCode,
    String? projectTitle,
    String? projectName,
    String? clientName,
    String? clientPhone,
    String? clientEmail,
    String? siteAddress,
    String? siteLocation,
    String? city,
    double? floorAreaSqft,
    String? projectManagerName,
    String? siteSupervisorName,
    DateTime? startDate,
    DateTime? targetHandoverDate,
    DateTime? expectedEndDate,
    ProjectStatus? status,
    TimelineHealth? timelineHealth,
    TimelineHealth? health,
    ContractModel? contractModel,
    double? totalContractValue,
    double? totalBilled,
    double? totalPaid,
    int? totalDesignFiles,
    int? completedDesignFiles,
    double? averageCsatRating,
    List<MilestoneWorkStream>? milestones,
    List<MilestoneWorkStream>? workStreams,
    List<SiteMediaLog>? mediaLogs,
    List<SnagTicket>? snags,
    List<StageApprovalRequest>? stageApprovals,
    List<StakeholderRating>? ratings,
    List<FinancialLedgerEntry>? ledgerEntries,
  }) {
    return ProjectMaster(
      id: id ?? this.id,
      projectCode: projectCode ?? this.projectCode,
      projectTitle: projectTitle ?? (projectName ?? this.projectTitle),
      clientName: clientName ?? this.clientName,
      clientPhone: clientPhone ?? this.clientPhone,
      clientEmail: clientEmail ?? this.clientEmail,
      siteAddress: siteAddress ?? (siteLocation ?? this.siteAddress),
      city: city ?? this.city,
      floorAreaSqft: floorAreaSqft ?? this.floorAreaSqft,
      projectManagerName: projectManagerName ?? this.projectManagerName,
      siteSupervisorName: siteSupervisorName ?? this.siteSupervisorName,
      startDate: startDate ?? this.startDate,
      targetHandoverDate: targetHandoverDate ?? (expectedEndDate ?? this.targetHandoverDate),
      status: status ?? this.status,
      timelineHealth: timelineHealth ?? (health ?? this.timelineHealth),
      contractModel: contractModel ?? this.contractModel,
      totalContractValue: totalContractValue ?? this.totalContractValue,
      totalBilled: totalBilled ?? this.totalBilled,
      totalPaid: totalPaid ?? this.totalPaid,
      totalDesignFiles: totalDesignFiles ?? this.totalDesignFiles,
      completedDesignFiles: completedDesignFiles ?? this.completedDesignFiles,
      averageCsatRating: averageCsatRating ?? this.averageCsatRating,
      milestones: milestones ?? (workStreams ?? this.milestones),
      mediaLogs: mediaLogs ?? this.mediaLogs,
      snags: snags ?? this.snags,
      stageApprovals: stageApprovals ?? this.stageApprovals,
      ratings: ratings ?? this.ratings,
      ledgerEntries: ledgerEntries ?? this.ledgerEntries,
    );
  }
}

/// Daily Site Progress Media (PRD Section 8.2)
class SiteMediaLog {
  final String id;
  final String projectId;
  final String projectTitle;
  final String milestoneName;
  final String title;
  final String description;
  final String mediaUrl;
  final String? thumbnailUrl;
  final bool isVideo;
  final String durationText;
  final DateTime recordedAt;
  final String supervisorName;
  final int workerCountOnSite;
  final String weatherCondition;
  final String gpsCoordinates; // e.g., "28.5355° N, 77.3910° E"
  final bool isGpsVerified;
  final bool isClientVisible;

  const SiteMediaLog({
    required this.id,
    required this.projectId,
    required this.projectTitle,
    required this.milestoneName,
    required this.title,
    required this.description,
    required this.mediaUrl,
    this.thumbnailUrl,
    this.isVideo = true,
    this.durationText = '01:45',
    required this.recordedAt,
    required this.supervisorName,
    this.workerCountOnSite = 8,
    this.weatherCondition = 'Sunny 28°C',
    required this.gpsCoordinates,
    this.isGpsVerified = true,
    this.isClientVisible = true,
  });

  String get workStream => milestoneName;
  String get workDoneSummary => description;
  int get labourCountOnSite => workerCountOnSite;
  String get uploadedBy => supervisorName;
  DateTime get capturedAt => recordedAt;
  bool get clientVisible => isClientVisible;
  String get resolution => '4K Ultra-HD';
  String? get duration => durationText;

  SiteMediaLog copyWith({
    String? id,
    String? projectId,
    String? projectTitle,
    String? milestoneName,
    String? title,
    String? description,
    String? mediaUrl,
    String? thumbnailUrl,
    bool? isVideo,
    String? durationText,
    DateTime? recordedAt,
    String? supervisorName,
    int? workerCountOnSite,
    String? weatherCondition,
    String? gpsCoordinates,
    bool? isGpsVerified,
    bool? clientVisible,
  }) {
    return SiteMediaLog(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      projectTitle: projectTitle ?? this.projectTitle,
      milestoneName: milestoneName ?? this.milestoneName,
      title: title ?? this.title,
      description: description ?? this.description,
      mediaUrl: mediaUrl ?? this.mediaUrl,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      isVideo: isVideo ?? this.isVideo,
      durationText: durationText ?? this.durationText,
      recordedAt: recordedAt ?? this.recordedAt,
      supervisorName: supervisorName ?? this.supervisorName,
      workerCountOnSite: workerCountOnSite ?? this.workerCountOnSite,
      weatherCondition: weatherCondition ?? this.weatherCondition,
      gpsCoordinates: gpsCoordinates ?? this.gpsCoordinates,
      isGpsVerified: isGpsVerified ?? this.isGpsVerified,
      isClientVisible: clientVisible ?? isClientVisible,
    );
  }
}

/// Client Snag Ticket (PRD Section 8.3)
class SnagTicket {
  final String id;
  final String ticketNumber; // e.g., "SNG-104-02"
  final String projectId;
  final String projectTitle;
  final String roomArea;
  final SnagCategory category;
  final String description;
  final TaskPriority priority;
  final SnagStatus status;
  final DateTime raisedAt;
  final DateTime slaDeadline;
  final String raisedBy;
  final String assignedTo;
  final List<String> photoUrls;
  final List<String> correctiveChecklist;
  final List<bool> checklistDone;
  final String? resolutionNotes;
  final String? resolutionPhotoUrl;
  final DateTime? resolvedAt;

  const SnagTicket({
    required this.id,
    required this.ticketNumber,
    required this.projectId,
    required this.projectTitle,
    required this.roomArea,
    required this.category,
    required this.description,
    this.priority = TaskPriority.high,
    this.status = SnagStatus.open,
    required this.raisedAt,
    required this.slaDeadline,
    required this.raisedBy,
    required this.assignedTo,
    this.photoUrls = const [],
    this.correctiveChecklist = const [],
    this.checklistDone = const [],
    this.resolutionNotes,
    this.resolutionPhotoUrl,
    this.resolvedAt,
  });

  bool get isSlaBreached =>
      DateTime.now().isAfter(slaDeadline) && status != SnagStatus.resolvedOnTime;
  String get title => description;
  String get roomOrArea => roomArea;
  String get assignedContractor => assignedTo;
  TaskPriority get severity => priority;
  bool get isOverdue => isSlaBreached;

  SnagTicket copyWith({
    String? id,
    String? ticketNumber,
    String? projectId,
    String? projectTitle,
    String? roomArea,
    SnagCategory? category,
    String? description,
    TaskPriority? priority,
    SnagStatus? status,
    DateTime? raisedAt,
    DateTime? slaDeadline,
    String? raisedBy,
    String? assignedTo,
    List<String>? photoUrls,
    List<String>? correctiveChecklist,
    List<bool>? checklistDone,
    String? resolutionNotes,
    String? resolutionPhotoUrl,
    DateTime? resolvedAt,
  }) {
    return SnagTicket(
      id: id ?? this.id,
      ticketNumber: ticketNumber ?? this.ticketNumber,
      projectId: projectId ?? this.projectId,
      projectTitle: projectTitle ?? this.projectTitle,
      roomArea: roomArea ?? this.roomArea,
      category: category ?? this.category,
      description: description ?? this.description,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      raisedAt: raisedAt ?? this.raisedAt,
      slaDeadline: slaDeadline ?? this.slaDeadline,
      raisedBy: raisedBy ?? this.raisedBy,
      assignedTo: assignedTo ?? this.assignedTo,
      photoUrls: photoUrls ?? this.photoUrls,
      correctiveChecklist: correctiveChecklist ?? this.correctiveChecklist,
      checklistDone: checklistDone ?? this.checklistDone,
      resolutionNotes: resolutionNotes ?? this.resolutionNotes,
      resolutionPhotoUrl: resolutionPhotoUrl ?? this.resolutionPhotoUrl,
      resolvedAt: resolvedAt ?? this.resolvedAt,
    );
  }
}

/// Stage Approval Sign-off (PRD Section 8.4)
class StageApprovalRequest {
  final String id;
  final String projectId;
  final String projectCode;
  final String projectTitle;
  final String clientName;
  final String clientPhone;
  final String milestoneName;
  final double stageContractShareAmount; // e.g. 25% = ₹8,75,000
  final DateTime requestedAt;
  final bool isApproved;
  final bool isStageLocked;
  final String? approvedAt;
  final String? otpSignoffAudit;
  final List<String> inspectionChecklist;
  final List<String> completionPhotoUrls;

  const StageApprovalRequest({
    required this.id,
    required this.projectId,
    required this.projectCode,
    required this.projectTitle,
    required this.clientName,
    required this.clientPhone,
    required this.milestoneName,
    required this.stageContractShareAmount,
    required this.requestedAt,
    this.isApproved = false,
    this.isStageLocked = false,
    this.approvedAt,
    this.otpSignoffAudit,
    this.inspectionChecklist = const [],
    this.completionPhotoUrls = const [],
  });

  String get stageName => milestoneName;
  String get description =>
      'Formal client sign-off and quality certification gate for $milestoneName';
  bool get isLocked => isStageLocked;
  Map<String, bool> get qcChecklist =>
      {for (var i in inspectionChecklist) i: true};
  String? get signedOffBy => isApproved
      ? (otpSignoffAudit != null ? 'Client ($clientName)' : 'Site Supervisor')
      : null;
  String? get approvalMethod => otpSignoffAudit != null
      ? 'WhatsApp OTP ($otpSignoffAudit)'
      : 'Digital Touch Signature';
  DateTime? get signedOffAt => isApproved ? requestedAt : null;
  String get status =>
      isApproved ? 'Approved & Certified' : (isLocked ? 'Locked Gate' : 'Awaiting Client Sign-Off');

  StageApprovalRequest copyWith({
    String? id,
    String? projectId,
    String? projectCode,
    String? projectTitle,
    String? clientName,
    String? clientPhone,
    String? milestoneName,
    double? stageContractShareAmount,
    DateTime? requestedAt,
    bool? isApproved,
    bool? isLocked,
    String? approvedAt,
    String? otpSignoffAudit,
    String? status,
    List<String>? inspectionChecklist,
    List<String>? completionPhotoUrls,
  }) {
    return StageApprovalRequest(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      projectCode: projectCode ?? this.projectCode,
      projectTitle: projectTitle ?? this.projectTitle,
      clientName: clientName ?? this.clientName,
      clientPhone: clientPhone ?? this.clientPhone,
      milestoneName: milestoneName ?? this.milestoneName,
      stageContractShareAmount: stageContractShareAmount ?? this.stageContractShareAmount,
      requestedAt: requestedAt ?? this.requestedAt,
      isApproved: isApproved ?? this.isApproved,
      isStageLocked: isLocked ?? isStageLocked,
      approvedAt: approvedAt ?? this.approvedAt,
      otpSignoffAudit: otpSignoffAudit ?? this.otpSignoffAudit,
      inspectionChecklist: inspectionChecklist ?? this.inspectionChecklist,
      completionPhotoUrls: completionPhotoUrls ?? this.completionPhotoUrls,
    );
  }
}

/// 360-Degree Feedback & Rating (PRD Section 8.6)
class StakeholderRating {
  final String id;
  final String projectId;
  final String projectTitle;
  final StakeholderType stakeholderType;
  final String targetName; // e.g. "Mohan Lal (Civil Mason)"
  final double score1; // Specific criteria 1 (1.0 to 5.0)
  final String label1;
  final double score2; // Specific criteria 2 (1.0 to 5.0)
  final String label2;
  final double score3; // Specific criteria 3 (1.0 to 5.0)
  final String label3;
  final String reviewNote;
  final DateTime ratedAt;
  final String ratedBy;

  StakeholderRating({
    required this.id,
    required this.projectId,
    this.projectTitle = 'Execution Project',
    StakeholderType? stakeholderType,
    StakeholderType? type,
    String? targetName,
    String? stakeholderName,
    String? roleTitle,
    double? overallScore,
    Map<String, double>? criteriaScores,
    String? feedback,
    String? reviewNote,
    double? score1,
    String? label1,
    double? score2,
    String? label2,
    double? score3,
    String? label3,
    required this.ratedAt,
    required this.ratedBy,
  })  : stakeholderType = stakeholderType ?? type ?? StakeholderType.labour,
        targetName = targetName ?? stakeholderName ?? 'Contractor',
        score1 = score1 ?? (criteriaScores != null && criteriaScores.isNotEmpty ? criteriaScores.values.first : 4.0),
        label1 = label1 ?? (criteriaScores != null && criteriaScores.isNotEmpty ? criteriaScores.keys.first : 'Quality of Work'),
        score2 = score2 ?? (criteriaScores != null && criteriaScores.length > 1 ? criteriaScores.values.elementAt(1) : 4.0),
        label2 = label2 ?? (criteriaScores != null && criteriaScores.length > 1 ? criteriaScores.keys.elementAt(1) : 'Timeliness & Speed'),
        score3 = score3 ?? (criteriaScores != null && criteriaScores.length > 2 ? criteriaScores.values.elementAt(2) : 4.0),
        label3 = label3 ?? (criteriaScores != null && criteriaScores.length > 2 ? criteriaScores.keys.elementAt(2) : 'Communication & Safety'),
        reviewNote = reviewNote ?? feedback ?? 'Good execution performance.';

  double get averageScore => (score1 + score2 + score3) / 3.0;
  String get stakeholderName => targetName;
  String get roleTitle => stakeholderType.label;
  StakeholderType get type => stakeholderType;
  double get overallScore => averageScore;
  Map<String, double> get criteriaScores => {
        label1: score1,
        label2: score2,
        label3: score3,
        'Site Coordination & Safety': 4.5,
      };
  String get feedback => reviewNote;
}

/// Granular Financial Ledger Entry for Material, Labour, and Supervision (PRD Section 8.7 & requirmenet.md)
enum LedgerType {
  material,
  labour,
  supervision;

  String get label {
    switch (this) {
      case LedgerType.material:
        return 'Material Ledger';
      case LedgerType.labour:
        return 'Labour Ledger';
      case LedgerType.supervision:
        return 'Supervision & Commission';
    }
  }
}

class FinancialLedgerEntry {
  final String id;
  final String projectId;
  final String projectTitle;
  final LedgerType type;
  final DateTime date;
  final String payeeOrVendor;
  final String description;
  final double amount;
  final bool isPaid;
  final double? commissionPercent; // e.g. 5% commission
  final double? commissionAmount;
  final String? note;

  FinancialLedgerEntry({
    required this.id,
    required this.projectId,
    this.projectTitle = 'Execution Project',
    required this.type,
    DateTime? date,
    DateTime? entryDate,
    String? payeeOrVendor,
    String? vendorOrContractor,
    String? referenceCode,
    double? quantity,
    double? unitPrice,
    double? taxGstPercentage,
    double? totalAmount,
    double? paidAmount,
    double? balanceDue,
    String? paymentStatus,
    required this.description,
    double? amount,
    bool? isPaid,
    this.commissionPercent,
    this.commissionAmount,
    this.note,
  })  : date = date ?? entryDate ?? DateTime.now(),
        payeeOrVendor = payeeOrVendor ?? vendorOrContractor ?? 'Vendor / Supplier',
        amount = amount ?? totalAmount ?? 0.0,
        isPaid = isPaid ?? (paymentStatus == 'Paid');

  String get referenceCode => id;
  String get vendorOrContractor => payeeOrVendor;
  double get quantity => 1.0;
  double get unitPrice => amount;
  double get taxGstPercentage => 18.0;
  double get totalAmount => amount;
  double get paidAmount => isPaid ? amount : 0.0;
  double get balanceDue => isPaid ? 0.0 : amount;
  String get paymentStatus => isPaid ? 'Paid' : 'Pending';
  DateTime get entryDate => date;
}
