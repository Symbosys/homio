import 'package:flutter/material.dart';
import 'design_enums.dart';

/// Design Project overview entity in Design Workspace
class DesignProject {
  final String id;
  final String code; // e.g. "PRJ-104"
  final String name;
  final String clientName;
  final String clientAvatar;
  final String projectManager;
  final String designer;
  final DesignStage stage;
  final double progressPercent;
  final int activeDeliverablesCount;
  final int pendingApprovalsCount;
  final int revisionsCount;
  final DateTime startDate;
  final DateTime targetCompletionDate;
  final DateTime lastUpdated;
  final double totalAreaSqFt;
  final String category;

  const DesignProject({
    required this.id,
    required this.code,
    required this.name,
    required this.clientName,
    this.clientAvatar = '',
    required this.projectManager,
    required this.designer,
    required this.stage,
    this.progressPercent = 0.0,
    this.activeDeliverablesCount = 0,
    this.pendingApprovalsCount = 0,
    this.revisionsCount = 0,
    required this.startDate,
    required this.targetCompletionDate,
    required this.lastUpdated,
    this.totalAreaSqFt = 0,
    this.category = 'Turnkey Interior',
  });

  bool get isOverdue => progressPercent < 100 && targetCompletionDate.isBefore(DateTime.now());
  DesignStage get designStage => stage;
  String get leadDesigner => designer;

  DesignProject copyWith({
    String? id,
    String? code,
    String? name,
    String? clientName,
    String? clientAvatar,
    String? projectManager,
    String? designer,
    DesignStage? stage,
    double? progressPercent,
    int? activeDeliverablesCount,
    int? pendingApprovalsCount,
    int? revisionsCount,
    DateTime? startDate,
    DateTime? targetCompletionDate,
    DateTime? lastUpdated,
    double? totalAreaSqFt,
    String? category,
  }) {
    return DesignProject(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      clientName: clientName ?? this.clientName,
      clientAvatar: clientAvatar ?? this.clientAvatar,
      projectManager: projectManager ?? this.projectManager,
      designer: designer ?? this.designer,
      stage: stage ?? this.stage,
      progressPercent: progressPercent ?? this.progressPercent,
      activeDeliverablesCount: activeDeliverablesCount ?? this.activeDeliverablesCount,
      pendingApprovalsCount: pendingApprovalsCount ?? this.pendingApprovalsCount,
      revisionsCount: revisionsCount ?? this.revisionsCount,
      startDate: startDate ?? this.startDate,
      targetCompletionDate: targetCompletionDate ?? this.targetCompletionDate,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      totalAreaSqFt: totalAreaSqFt ?? this.totalAreaSqFt,
      category: category ?? this.category,
    );
  }
}

/// Version Record of a Deliverable (PRD Section 15.1)
class DesignVersionRecord {
  final String versionTag; // e.g. "v1.0", "v2.0", "v3.0"
  final String fileName;
  final String fileUrl;
  final int fileSizeBytes;
  final DateTime uploadedAt;
  final String uploadedByName;
  final String changelogNote;
  final DesignReviewStatus reviewStatus;
  final String? clientFeedback;
  final int turnaroundHours;

  const DesignVersionRecord({
    required this.versionTag,
    required this.fileName,
    required this.fileUrl,
    required this.fileSizeBytes,
    required this.uploadedAt,
    required this.uploadedByName,
    required this.changelogNote,
    this.reviewStatus = DesignReviewStatus.underClientReview,
    this.clientFeedback,
    this.turnaroundHours = 24,
  });

  String get fileSizeFormatted {
    if (fileSizeBytes < 1024 * 1024) {
      return '${(fileSizeBytes / 1024).toStringAsFixed(1)} KB';
    }
    return '${(fileSizeBytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  String get fileSizeBytesFormatted => fileSizeFormatted;
}

/// Visual Annotation on design preview (Pins, Comments, Highlights)
class DesignAnnotation {
  final String id;
  final String author;
  final DateTime timestamp;
  final double xPercent; // 0.0 to 1.0 relative coords on image
  final double yPercent;
  final String comment;
  final AnnotationType type;
  final bool isResolved;

  DesignAnnotation({
    required this.id,
    String? author,
    String? authorName,
    DateTime? timestamp,
    DateTime? createdAt,
    double? xPercent,
    double? normalizedX,
    double? yPercent,
    double? normalizedY,
    required this.comment,
    this.type = AnnotationType.pin,
    this.isResolved = false,
    DesignRole? authorRole,
  })  : author = author ?? authorName ?? 'Designer',
        timestamp = timestamp ?? createdAt ?? DateTime.now(),
        xPercent = xPercent ?? normalizedX ?? 0.5,
        yPercent = yPercent ?? normalizedY ?? 0.5;

  String get authorName => author;
  double get normalizedX => xPercent;
  double get normalizedY => yPercent;

  DesignAnnotation copyWith({
    String? id,
    String? author,
    DateTime? timestamp,
    double? xPercent,
    double? yPercent,
    String? comment,
    AnnotationType? type,
    bool? isResolved,
  }) {
    return DesignAnnotation(
      id: id ?? this.id,
      author: author ?? this.author,
      timestamp: timestamp ?? this.timestamp,
      xPercent: xPercent ?? this.xPercent,
      yPercent: yPercent ?? this.yPercent,
      comment: comment ?? this.comment,
      type: type ?? this.type,
      isResolved: isResolved ?? this.isResolved,
    );
  }
}

/// Full Design Deliverable Unit
class DesignDeliverable {
  final String id;
  final String projectCode;
  final String projectName;
  final String title;
  final String roomArea; // e.g. "Master Bedroom", "Living Pavilion", "Double Height Foyer"
  final DesignCategory category;
  final DesignFileType fileType;
  final String currentVersion; // e.g. "v3.0"
  final DesignReviewStatus status;
  final String designerName;
  final String designerAvatar;
  final String clientName;
  final DateTime createdAt;
  final DateTime? clientReviewSlaDeadline;
  final int revisionCount;
  final List<DesignVersionRecord> versionHistory;
  final String thumbnailUrl;
  final String fileUrl;
  final int fileSizeBytes;
  final List<String> tags;
  final FileVisibility visibility;
  final String folderCode;
  final String? executionWebhookTriggeredAt;
  final List<DesignAnnotation> annotations;

  const DesignDeliverable({
    required this.id,
    required this.projectCode,
    required this.projectName,
    required this.title,
    required this.roomArea,
    required this.category,
    required this.fileType,
    required this.currentVersion,
    this.status = DesignReviewStatus.underClientReview,
    required this.designerName,
    this.designerAvatar = '',
    required this.clientName,
    required this.createdAt,
    this.clientReviewSlaDeadline,
    this.revisionCount = 1,
    this.versionHistory = const [],
    required this.thumbnailUrl,
    required this.fileUrl,
    required this.fileSizeBytes,
    this.tags = const [],
    this.visibility = FileVisibility.clientVisible,
    this.folderCode = '04_2D_Drawings',
    this.executionWebhookTriggeredAt,
    this.annotations = const [],
  });

  bool get isApproved => status == DesignReviewStatus.approved || status == DesignReviewStatus.sentToExecution;
  bool get isUnderReview => status == DesignReviewStatus.underClientReview || status == DesignReviewStatus.sentToClient || status == DesignReviewStatus.internalReview;
  bool get isChangesRequested => status == DesignReviewStatus.revisionRequested || status == DesignReviewStatus.changesRequested;
  bool get isOverdue => clientReviewSlaDeadline != null && !isApproved && clientReviewSlaDeadline!.isBefore(DateTime.now());

  DesignStage get stage => DesignStage.clientReview;
  DesignRole get designerRole => DesignRole.seniorArchitect;

  String get fileSizeFormatted {
    if (fileSizeBytes < 1024 * 1024) {
      return '${(fileSizeBytes / 1024).toStringAsFixed(1)} KB';
    }
    return '${(fileSizeBytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  String get fileSizeBytesFormatted => fileSizeFormatted;

  DesignDeliverable copyWith({
    String? id,
    String? projectCode,
    String? projectName,
    String? title,
    String? roomArea,
    DesignCategory? category,
    DesignFileType? fileType,
    String? currentVersion,
    DesignReviewStatus? status,
    String? designerName,
    String? designerAvatar,
    String? clientName,
    DateTime? createdAt,
    DateTime? clientReviewSlaDeadline,
    int? revisionCount,
    List<DesignVersionRecord>? versionHistory,
    String? thumbnailUrl,
    String? fileUrl,
    int? fileSizeBytes,
    List<String>? tags,
    FileVisibility? visibility,
    String? folderCode,
    String? executionWebhookTriggeredAt,
    List<DesignAnnotation>? annotations,
  }) {
    return DesignDeliverable(
      id: id ?? this.id,
      projectCode: projectCode ?? this.projectCode,
      projectName: projectName ?? this.projectName,
      title: title ?? this.title,
      roomArea: roomArea ?? this.roomArea,
      category: category ?? this.category,
      fileType: fileType ?? this.fileType,
      currentVersion: currentVersion ?? this.currentVersion,
      status: status ?? this.status,
      designerName: designerName ?? this.designerName,
      designerAvatar: designerAvatar ?? this.designerAvatar,
      clientName: clientName ?? this.clientName,
      createdAt: createdAt ?? this.createdAt,
      clientReviewSlaDeadline: clientReviewSlaDeadline ?? this.clientReviewSlaDeadline,
      revisionCount: revisionCount ?? this.revisionCount,
      versionHistory: versionHistory ?? this.versionHistory,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      fileUrl: fileUrl ?? this.fileUrl,
      fileSizeBytes: fileSizeBytes ?? this.fileSizeBytes,
      tags: tags ?? this.tags,
      visibility: visibility ?? this.visibility,
      folderCode: folderCode ?? this.folderCode,
      executionWebhookTriggeredAt: executionWebhookTriggeredAt ?? this.executionWebhookTriggeredAt,
      annotations: annotations ?? this.annotations,
    );
  }
}

/// Design Revision Entity
class DesignRevision {
  final String id;
  final String deliverableId;
  final String projectCode;
  final String deliverableTitle;
  final String currentVersion;
  final int revisionNumber;
  final String requestedBy;
  final DateTime requestedAt;
  final String reason;
  final String description;
  final String specificArea;
  final String assignedDesigner;
  final DateTime dueDate;
  final RevisionStatus status;
  final DesignPriority priority;
  final List<DesignAnnotation> annotations;

  const DesignRevision({
    required this.id,
    required this.deliverableId,
    required this.projectCode,
    required this.deliverableTitle,
    required this.currentVersion,
    required this.revisionNumber,
    required this.requestedBy,
    required this.requestedAt,
    required this.reason,
    required this.description,
    this.specificArea = '',
    required this.assignedDesigner,
    required this.dueDate,
    this.status = RevisionStatus.requested,
    this.priority = DesignPriority.high,
    this.annotations = const [],
  });

  bool get isOverdue => status != RevisionStatus.approved && status != RevisionStatus.closed && dueDate.isBefore(DateTime.now());

  DesignRevision copyWith({
    String? id,
    String? deliverableId,
    String? projectCode,
    String? deliverableTitle,
    String? currentVersion,
    int? revisionNumber,
    String? requestedBy,
    DateTime? requestedAt,
    String? reason,
    String? description,
    String? specificArea,
    String? assignedDesigner,
    DateTime? dueDate,
    RevisionStatus? status,
    DesignPriority? priority,
    List<DesignAnnotation>? annotations,
  }) {
    return DesignRevision(
      id: id ?? this.id,
      deliverableId: deliverableId ?? this.deliverableId,
      projectCode: projectCode ?? this.projectCode,
      deliverableTitle: deliverableTitle ?? this.deliverableTitle,
      currentVersion: currentVersion ?? this.currentVersion,
      revisionNumber: revisionNumber ?? this.revisionNumber,
      requestedBy: requestedBy ?? this.requestedBy,
      requestedAt: requestedAt ?? this.requestedAt,
      reason: reason ?? this.reason,
      description: description ?? this.description,
      specificArea: specificArea ?? this.specificArea,
      assignedDesigner: assignedDesigner ?? this.assignedDesigner,
      dueDate: dueDate ?? this.dueDate,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      annotations: annotations ?? this.annotations,
    );
  }
}

/// Client Approval Queue Item
class DesignApproval {
  final String id;
  final String projectCode;
  final String projectName;
  final String deliverableId;
  final String deliverableTitle;
  final String clientName;
  final String versionTag;
  final DesignStage stage;
  final String submittedBy;
  final DateTime submittedDate;
  final DateTime reviewDeadline;
  final DateTime? viewedAt;
  final DesignReviewStatus status;
  final String? clientComment;
  final String? approvedBy;
  final DateTime? approvedAt;
  final bool downloadAllowed;

  const DesignApproval({
    required this.id,
    required this.projectCode,
    required this.projectName,
    required this.deliverableId,
    required this.deliverableTitle,
    required this.clientName,
    required this.versionTag,
    required this.stage,
    required this.submittedBy,
    required this.submittedDate,
    required this.reviewDeadline,
    this.viewedAt,
    this.status = DesignReviewStatus.underClientReview,
    this.clientComment,
    this.approvedBy,
    this.approvedAt,
    this.downloadAllowed = true,
  });

  bool get isOverdue => !status.isApproved && reviewDeadline.isBefore(DateTime.now());

  DesignApproval copyWith({
    String? id,
    String? projectCode,
    String? projectName,
    String? deliverableId,
    String? deliverableTitle,
    String? clientName,
    String? versionTag,
    DesignStage? stage,
    String? submittedBy,
    DateTime? submittedDate,
    DateTime? reviewDeadline,
    DateTime? viewedAt,
    DesignReviewStatus? status,
    String? clientComment,
    String? approvedBy,
    DateTime? approvedAt,
    bool? downloadAllowed,
  }) {
    return DesignApproval(
      id: id ?? this.id,
      projectCode: projectCode ?? this.projectCode,
      projectName: projectName ?? this.projectName,
      deliverableId: deliverableId ?? this.deliverableId,
      deliverableTitle: deliverableTitle ?? this.deliverableTitle,
      clientName: clientName ?? this.clientName,
      versionTag: versionTag ?? this.versionTag,
      stage: stage ?? this.stage,
      submittedBy: submittedBy ?? this.submittedBy,
      submittedDate: submittedDate ?? this.submittedDate,
      reviewDeadline: reviewDeadline ?? this.reviewDeadline,
      viewedAt: viewedAt ?? this.viewedAt,
      status: status ?? this.status,
      clientComment: clientComment ?? this.clientComment,
      approvedBy: approvedBy ?? this.approvedBy,
      approvedAt: approvedAt ?? this.approvedAt,
      downloadAllowed: downloadAllowed ?? this.downloadAllowed,
    );
  }
}

/// Handover Checklist Item
class HandoverChecklistItem {
  final String id;
  final String title;
  final bool isRequired;
  final bool isSatisfied;
  final String? deliverableId;
  final String? deliverableTitle;
  final String? statusNotes;
  final String category;
  final String description;

  const HandoverChecklistItem({
    required this.id,
    required this.title,
    this.isRequired = true,
    this.isSatisfied = false,
    this.deliverableId,
    this.deliverableTitle,
    this.statusNotes,
    this.category = 'General',
    this.description = '',
  });

  HandoverChecklistItem copyWith({
    String? id,
    String? title,
    bool? isRequired,
    bool? isSatisfied,
    String? deliverableId,
    String? deliverableTitle,
    String? statusNotes,
    String? category,
    String? description,
  }) {
    return HandoverChecklistItem(
      id: id ?? this.id,
      title: title ?? this.title,
      isRequired: isRequired ?? this.isRequired,
      isSatisfied: isSatisfied ?? this.isSatisfied,
      deliverableId: deliverableId ?? this.deliverableId,
      deliverableTitle: deliverableTitle ?? this.deliverableTitle,
      statusNotes: statusNotes ?? this.statusNotes,
      category: category ?? this.category,
      description: description ?? this.description,
    );
  }
}

/// Execution Handover Package
class DesignHandover {
  final String id;
  final String projectCode;
  final String projectName;
  final String packageVersion; // e.g. "PKG-104-v1.0"
  final String handoverName;
  final String createdBy;
  final DateTime createdDate;
  final String designManager;
  final String executionManager;
  final String siteSupervisor;
  final String description;
  final String instructions;
  final DesignPriority priority;
  final HandoverStatus status;
  final List<String> includedDeliverableIds;
  final List<HandoverChecklistItem> checklist;
  final String notes;
  final DateTime? approvedDate;
  final String? rejectedReason;
  final DateTime submittedDate;

  DesignHandover({
    required this.id,
    required this.projectCode,
    required this.projectName,
    required this.packageVersion,
    required this.handoverName,
    this.createdBy = 'Lead Architect',
    DateTime? createdDate,
    this.designManager = 'Design Head',
    required this.executionManager,
    this.siteSupervisor = '',
    this.description = '',
    this.instructions = '',
    this.priority = DesignPriority.medium,
    this.status = HandoverStatus.readyForHandover,
    this.includedDeliverableIds = const [],
    this.checklist = const [],
    this.notes = '',
    DateTime? submittedDate,
    this.approvedDate,
    this.rejectedReason,
  })  : createdDate = createdDate ?? submittedDate ?? DateTime.now(),
        submittedDate = submittedDate ?? createdDate ?? DateTime.now();

  bool get isReady => checklist.every((item) => !item.isRequired || item.isSatisfied);

  bool get isAllChecklistSatisfied => checklist.isEmpty || checklist.every((item) => item.isSatisfied);

  int get satisfiedChecklistCount => checklist.where((item) => item.isSatisfied).length;

  DesignHandover copyWith({
    String? id,
    String? projectCode,
    String? projectName,
    String? packageVersion,
    String? handoverName,
    String? createdBy,
    DateTime? createdDate,
    String? designManager,
    String? executionManager,
    String? siteSupervisor,
    String? description,
    String? instructions,
    DesignPriority? priority,
    HandoverStatus? status,
    List<String>? includedDeliverableIds,
    List<HandoverChecklistItem>? checklist,
    String? notes,
    DateTime? submittedDate,
    DateTime? approvedDate,
    String? rejectedReason,
  }) {
    return DesignHandover(
      id: id ?? this.id,
      projectCode: projectCode ?? this.projectCode,
      projectName: projectName ?? this.projectName,
      packageVersion: packageVersion ?? this.packageVersion,
      handoverName: handoverName ?? this.handoverName,
      createdBy: createdBy ?? this.createdBy,
      createdDate: createdDate ?? this.createdDate,
      designManager: designManager ?? this.designManager,
      executionManager: executionManager ?? this.executionManager,
      siteSupervisor: siteSupervisor ?? this.siteSupervisor,
      description: description ?? this.description,
      instructions: instructions ?? this.instructions,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      includedDeliverableIds: includedDeliverableIds ?? this.includedDeliverableIds,
      checklist: checklist ?? this.checklist,
      notes: notes ?? this.notes,
      submittedDate: submittedDate ?? this.submittedDate,
      approvedDate: approvedDate ?? this.approvedDate,
      rejectedReason: rejectedReason ?? this.rejectedReason,
    );
  }
}

/// Cloud Drive Folder Entity (PRD Section 15.2)
class CloudDriveFolder {
  final String id;
  final String projectCode;
  final String name;
  final CloudFolderType folderType;
  final String path;
  final int itemCount;
  final int totalSizeBytes;
  final DateTime lastModified;
  final bool isLockedForDelete;

  const CloudDriveFolder({
    required this.id,
    required this.projectCode,
    String? name,
    String? folderName,
    required this.folderType,
    this.path = '',
    int? itemCount,
    int? fileCount,
    this.totalSizeBytes = 0,
    required this.lastModified,
    this.isLockedForDelete = true,
  })  : name = name ?? folderName ?? 'Folder',
        itemCount = itemCount ?? fileCount ?? 0;

  String get totalSizeFormatted {
    if (totalSizeBytes < 1024 * 1024) {
      return '${(totalSizeBytes / 1024).toStringAsFixed(1)} KB';
    }
    return '${(totalSizeBytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  String get folderName => name;
  int get fileCount => itemCount;
  String get totalSizeBytesFormatted => totalSizeFormatted;

  CloudDriveFolder copyWith({
    String? id,
    String? projectCode,
    String? name,
    CloudFolderType? folderType,
    String? path,
    int? itemCount,
    int? totalSizeBytes,
    DateTime? lastModified,
    bool? isLockedForDelete,
  }) {
    return CloudDriveFolder(
      id: id ?? this.id,
      projectCode: projectCode ?? this.projectCode,
      name: name ?? this.name,
      folderType: folderType ?? this.folderType,
      path: path ?? this.path,
      itemCount: itemCount ?? this.itemCount,
      totalSizeBytes: totalSizeBytes ?? this.totalSizeBytes,
      lastModified: lastModified ?? this.lastModified,
      isLockedForDelete: isLockedForDelete ?? this.isLockedForDelete,
    );
  }
}

/// Cloud Drive File Entity (PRD Section 15.2)
class CloudDriveFile {
  final String id;
  final String projectCode;
  final String folderId;
  final String folderPath;
  final String fileName;
  final DesignFileType fileType;
  final int fileSizeBytes;
  final DateTime uploadedAt;
  final String uploadedBy;
  final String downloadUrl;
  final String thumbnailUrl;
  final String versionTag;
  final bool isLockedForDelete;
  final List<String> tags;
  final FileVisibility visibility;

  const CloudDriveFile({
    required this.id,
    required this.projectCode,
    required this.folderId,
    this.folderPath = '',
    required this.fileName,
    required this.fileType,
    required this.fileSizeBytes,
    required this.uploadedAt,
    String? uploadedBy,
    String? uploadedByName,
    this.downloadUrl = '',
    this.thumbnailUrl = '',
    String? versionTag,
    String? currentVersionTag,
    this.isLockedForDelete = true,
    this.tags = const [],
    this.visibility = FileVisibility.clientVisible,
  })  : uploadedBy = uploadedBy ?? uploadedByName ?? 'Senior Designer',
        versionTag = versionTag ?? currentVersionTag ?? 'v1.0';

  String get fileSizeFormatted {
    if (fileSizeBytes < 1024 * 1024) {
      return '${(fileSizeBytes / 1024).toStringAsFixed(1)} KB';
    }
    return '${(fileSizeBytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  String get currentVersionTag => versionTag;
  String get uploadedByName => uploadedBy;
  String get fileSizeBytesFormatted => fileSizeFormatted;

  CloudDriveFile copyWith({
    String? id,
    String? projectCode,
    String? folderId,
    String? folderPath,
    String? fileName,
    DesignFileType? fileType,
    int? fileSizeBytes,
    DateTime? uploadedAt,
    String? uploadedBy,
    String? downloadUrl,
    String? thumbnailUrl,
    String? versionTag,
    bool? isLockedForDelete,
    List<String>? tags,
    FileVisibility? visibility,
  }) {
    return CloudDriveFile(
      id: id ?? this.id,
      projectCode: projectCode ?? this.projectCode,
      folderId: folderId ?? this.folderId,
      folderPath: folderPath ?? this.folderPath,
      fileName: fileName ?? this.fileName,
      fileType: fileType ?? this.fileType,
      fileSizeBytes: fileSizeBytes ?? this.fileSizeBytes,
      uploadedAt: uploadedAt ?? this.uploadedAt,
      uploadedBy: uploadedBy ?? this.uploadedBy,
      downloadUrl: downloadUrl ?? this.downloadUrl,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      versionTag: versionTag ?? this.versionTag,
      isLockedForDelete: isLockedForDelete ?? this.isLockedForDelete,
      tags: tags ?? this.tags,
      visibility: visibility ?? this.visibility,
    );
  }
}

/// Security Deletion Audit Trail (PRD Section 15.2)
class DeletionAuditLog {
  final String id;
  final String itemName;
  final String itemType;
  final String attemptedBy;
  final String superAdminApprover;
  final String twoFactorOtpCode;
  final String reason;
  final DateTime timestamp;
  final bool isAuthorized;

  const DeletionAuditLog({
    required this.id,
    required this.itemName,
    this.itemType = 'File',
    required this.attemptedBy,
    required this.superAdminApprover,
    required this.twoFactorOtpCode,
    required this.reason,
    required this.timestamp,
    required this.isAuthorized,
  });
}

/// Design Activity Timeline Entry
class DesignActivity {
  final String id;
  final String projectCode;
  final String action;
  final String description;
  final String performedBy;
  final DateTime timestamp;
  final IconData icon;
  final Color iconColor;

  const DesignActivity({
    required this.id,
    required this.projectCode,
    required this.action,
    required this.description,
    required this.performedBy,
    required this.timestamp,
    this.icon = Icons.design_services_rounded,
    this.iconColor = const Color(0xFF3B82F6),
  });

  String get title => action;
  String get subtitle => description;
  Color get color => iconColor;
  String get timeAgo => '2h ago';
}

/// Designer Workload Profile
class DesignerWorkload {
  final String designerName;
  final String designerAvatar;
  final String role;
  final int assignedProjectsCount;
  final int activeDeliverablesCount;
  final int pendingRevisionsCount;
  final int completedDeliverablesCount;
  final double approvalRatePercent;

  const DesignerWorkload({
    required this.designerName,
    this.designerAvatar = '',
    this.role = 'Interior Designer',
    this.assignedProjectsCount = 0,
    this.activeDeliverablesCount = 0,
    this.pendingRevisionsCount = 0,
    this.completedDeliverablesCount = 0,
    this.approvalRatePercent = 90.0,
  });

  int get assignedDeliverables => activeDeliverablesCount;
  int get revisionsInProgress => pendingRevisionsCount;
}

/// Workspace KPI Summary
class DesignWorkspaceKpis {
  final int activeDesignProjects;
  final int filesSubmitted;
  final int internalReview;
  final int clientReview;
  final int revisionRequested;
  final int approved;
  final int sentToExecution;
  final int overdueReviews;
  final int totalDesignFiles;
  final double averageRevisionCount;
  final double averageApprovalTurnaroundHours;

  const DesignWorkspaceKpis({
    this.activeDesignProjects = 0,
    this.filesSubmitted = 0,
    this.internalReview = 0,
    this.clientReview = 0,
    this.revisionRequested = 0,
    this.approved = 0,
    this.sentToExecution = 0,
    this.overdueReviews = 0,
    this.totalDesignFiles = 0,
    this.averageRevisionCount = 0,
    this.averageApprovalTurnaroundHours = 0,
  });
}
