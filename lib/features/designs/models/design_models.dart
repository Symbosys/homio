import 'package:flutter/material.dart';

/// Design Deliverable Category
enum DesignCategory {
  twoDCad('2D CAD & Blueprints', Icons.architecture_rounded, Color(0xFF3B82F6)),
  threeDRender('3D Photorealistic Renders', Icons.view_in_ar_rounded, Color(0xFF8B5CF6)),
  moodboard('Material Moodboards', Icons.palette_rounded, Color(0xFFEC4899)),
  mepEngineering('MEP & Services Blueprints', Icons.plumbing_rounded, Color(0xFF10B981)),
  boqSpecification('BOQ & Specifications', Icons.inventory_2_rounded, Color(0xFFF59E0B)),
  detailJoinery('Joinery & Carpentry Details', Icons.carpenter_rounded, Color(0xFF06B6D4));

  final String label;
  final IconData icon;
  final Color color;
  const DesignCategory(this.label, this.icon, this.color);
}

/// Lifecycle review status for design deliverables (PRD Section 15.1)
enum DesignReviewStatus {
  draft('Draft / In Progress', Color(0xFF64748B), Icons.edit_note_rounded),
  submitted('Under Client Review', Color(0xFFF59E0B), Icons.hourglass_top_rounded),
  approved('Approved (Sent to Execution)', Color(0xFF10B981), Icons.check_circle_rounded),
  changesRequested('Changes Requested (Revision)', Color(0xFFEF4444), Icons.published_with_changes_rounded);

  final String label;
  final Color color;
  final IconData icon;
  const DesignReviewStatus(this.label, this.color, this.icon);
}

/// Common CAD & Design File Types
enum DesignFileType {
  dwg('AutoCAD Drawing', '.dwg', Icons.architecture_rounded, Color(0xFFDC2626)),
  dxf('AutoCAD Interchange', '.dxf', Icons.architecture_rounded, Color(0xFFDC2626)),
  skp('SketchUp 3D Model', '.skp', Icons.view_in_ar_rounded, Color(0xFF2563EB)),
  max('3ds Max Render Scene', '.max', Icons.apartment_rounded, Color(0xFF7C3AED)),
  threeDs('3D Studio File', '.3ds', Icons.view_in_ar_rounded, Color(0xFF7C3AED)),
  pdf('Architectural PDF', '.pdf', Icons.picture_as_pdf_rounded, Color(0xFFE11D48)),
  jpg('Render Image (JPG)', '.jpg', Icons.image_rounded, Color(0xFF059669)),
  png('Render Image (PNG)', '.png', Icons.image_rounded, Color(0xFF059669)),
  rvt('Autodesk Revit BIM', '.rvt', Icons.layers_rounded, Color(0xFF0891B2));

  final String label;
  final String extension;
  final IconData icon;
  final Color color;
  const DesignFileType(this.label, this.extension, this.icon, this.color);
}

/// Cloud Drive Folder Hierarchy Type (PRD Section 15.2)
enum CloudFolderType {
  surveys('01_Laser_Surveys_AsBuilt', 'Surveys & As-Built Verification', Icons.straighten_rounded),
  cadDrawings('02_2D_CAD_Working_Drawings', '2D Layouts, Electrical & Plumbing', Icons.architecture_rounded),
  renders3D('03_3D_Photorealistic_Renders', '4K Renders & Walkthroughs', Icons.view_in_ar_rounded),
  boqSpecs('04_Material_Specifications_BOQ', 'BOQ Catalogs & Finish Schedules', Icons.inventory_2_rounded),
  siteMedia('05_Site_Progress_Surveillance_4K', 'Daily 4K CCTV & Video Feeds', Icons.videocam_rounded),
  contractsSignoffs('06_Client_Signoffs_Contracts', 'Agreements, OTP Logs & Handover', Icons.verified_rounded);

  final String folderCode;
  final String description;
  final IconData icon;
  const CloudFolderType(this.folderCode, this.description, this.icon);
}

/// Version Record of a Deliverable (PRD Section 15.1)
class DesignVersionRecord {
  final String versionTag; // e.g. "v1.0", "v2.0"
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
    this.reviewStatus = DesignReviewStatus.submitted,
    this.clientFeedback,
    this.turnaroundHours = 24,
  });

  String get fileSizeFormatted {
    if (fileSizeBytes < 1024 * 1024) {
      return '${(fileSizeBytes / 1024).toStringAsFixed(1)} KB';
    }
    return '${(fileSizeBytes / (1024 * 1024)).toStringAsFixed(1)} MB';
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
  final String currentVersion; // e.g. "v2.0"
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
  final String? executionWebhookTriggeredAt;

  DesignDeliverable({
    required this.id,
    required this.projectCode,
    required this.projectName,
    required this.title,
    required this.roomArea,
    required this.category,
    required this.fileType,
    required this.currentVersion,
    this.status = DesignReviewStatus.submitted,
    required this.designerName,
    required this.designerAvatar,
    required this.clientName,
    required this.createdAt,
    this.clientReviewSlaDeadline,
    this.revisionCount = 1,
    List<DesignVersionRecord>? versionHistory,
    required this.thumbnailUrl,
    required this.fileUrl,
    required this.fileSizeBytes,
    this.tags = const [],
    this.executionWebhookTriggeredAt,
  }) : versionHistory = versionHistory != null ? List.from(versionHistory) : [];

  bool get isApproved => status == DesignReviewStatus.approved;
  bool get isUnderReview => status == DesignReviewStatus.submitted;
  bool get isChangesRequested => status == DesignReviewStatus.changesRequested;

  String get fileSizeFormatted {
    if (fileSizeBytes < 1024 * 1024) {
      return '${(fileSizeBytes / 1024).toStringAsFixed(1)} KB';
    }
    return '${(fileSizeBytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

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
    String? executionWebhookTriggeredAt,
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
      versionHistory: versionHistory != null ? List.from(versionHistory) : List.from(this.versionHistory),
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      fileUrl: fileUrl ?? this.fileUrl,
      fileSizeBytes: fileSizeBytes ?? this.fileSizeBytes,
      tags: tags ?? this.tags,
      executionWebhookTriggeredAt: executionWebhookTriggeredAt ?? this.executionWebhookTriggeredAt,
    );
  }
}

/// Cloud Drive Folder Entity (PRD Section 15.2)
class CloudDriveFolder {
  final String id;
  final String projectCode;
  final String name;
  final CloudFolderType folderType;
  final int itemCount;
  final int totalSizeBytes;
  final DateTime lastModified;
  final bool isLockedForDelete;

  const CloudDriveFolder({
    required this.id,
    required this.projectCode,
    required this.name,
    required this.folderType,
    required this.itemCount,
    required this.totalSizeBytes,
    required this.lastModified,
    this.isLockedForDelete = true,
  });

  String get totalSizeFormatted {
    if (totalSizeBytes < 1024 * 1024) {
      return '${(totalSizeBytes / 1024).toStringAsFixed(1)} KB';
    }
    return '${(totalSizeBytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}

/// Cloud Drive File Entity (PRD Section 15.2)
class CloudDriveFile {
  final String id;
  final String projectCode;
  final String folderId;
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

  const CloudDriveFile({
    required this.id,
    required this.projectCode,
    required this.folderId,
    required this.fileName,
    required this.fileType,
    required this.fileSizeBytes,
    required this.uploadedAt,
    required this.uploadedBy,
    required this.downloadUrl,
    required this.thumbnailUrl,
    this.versionTag = 'v1.0',
    this.isLockedForDelete = true,
    this.tags = const [],
  });

  String get fileSizeFormatted {
    if (fileSizeBytes < 1024 * 1024) {
      return '${(fileSizeBytes / 1024).toStringAsFixed(1)} KB';
    }
    return '${(fileSizeBytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}

/// Security Deletion Audit Trail (PRD Section 15.2)
class DeletionAuditLog {
  final String id;
  final String itemName;
  final String attemptedBy;
  final String superAdminApprover;
  final String twoFactorOtpCode;
  final String reason;
  final DateTime timestamp;
  final bool isAuthorized;

  const DeletionAuditLog({
    required this.id,
    required this.itemName,
    required this.attemptedBy,
    required this.superAdminApprover,
    required this.twoFactorOtpCode,
    required this.reason,
    required this.timestamp,
    required this.isAuthorized,
  });
}
