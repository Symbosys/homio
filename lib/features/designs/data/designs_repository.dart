import 'dart:math';
import 'package:flutter/material.dart';
import '../domain/design_enums.dart';
import '../domain/design_models.dart';

/// Central reactive repository for Designs & Digital Asset Management (DAM).
/// Maintains a single source of truth for design workspaces, deliverable versions,
/// client approval cycles, execution handovers, and cloud drive governance.
class DesignsRepository {
  static final DesignsRepository _instance = DesignsRepository._internal();
  factory DesignsRepository() => _instance;
  DesignsRepository._internal() {
    _seedInitialData();
  }

  final List<DesignProject> _projects = [];
  final List<DesignDeliverable> _deliverables = [];
  final List<DesignRevision> _revisions = [];
  final List<DesignApproval> _approvals = [];
  final List<DesignHandover> _handovers = [];
  final List<CloudDriveFolder> _folders = [];
  final List<CloudDriveFile> _driveFiles = [];
  final List<DeletionAuditLog> _deletionAuditLogs = [];
  final List<DesignActivity> _activities = [];
  final List<DesignerWorkload> _designerWorkloads = [];

  // ---------------------------------------------------------------------------
  // Getters
  // ---------------------------------------------------------------------------
  List<DesignProject> get projects => List.unmodifiable(_projects);
  List<DesignDeliverable> get deliverables => List.unmodifiable(_deliverables);
  List<DesignRevision> get revisions => List.unmodifiable(_revisions);
  List<DesignApproval> get approvals => List.unmodifiable(_approvals);
  List<DesignHandover> get handovers => List.unmodifiable(_handovers);
  List<CloudDriveFolder> get folders => List.unmodifiable(_folders);
  List<CloudDriveFile> get driveFiles => List.unmodifiable(_driveFiles);
  List<DeletionAuditLog> get deletionAuditLogs => List.unmodifiable(_deletionAuditLogs);
  List<DesignActivity> get activities => List.unmodifiable(_activities);
  List<DesignerWorkload> get designerWorkloads => List.unmodifiable(_designerWorkloads);

  // ---------------------------------------------------------------------------
  // Filtered Getters
  // ---------------------------------------------------------------------------
  DesignProject? getProjectByCode(String code) {
    try {
      return _projects.firstWhere((p) => p.code == code);
    } catch (_) {
      return null;
    }
  }

  List<DesignDeliverable> getDeliverablesForProject(String projectCode) {
    return _deliverables.where((d) => d.projectCode == projectCode).toList();
  }

  List<DesignRevision> getRevisionsForProject(String projectCode) {
    return _revisions.where((r) => r.projectCode == projectCode).toList();
  }

  List<DesignApproval> getApprovalsForProject(String projectCode) {
    return _approvals.where((a) => a.projectCode == projectCode).toList();
  }

  List<DesignHandover> getHandoversForProject(String projectCode) {
    return _handovers.where((h) => h.projectCode == projectCode).toList();
  }

  List<CloudDriveFolder> getFoldersForProject(String projectCode) {
    return _folders.where((f) => f.projectCode == projectCode).toList();
  }

  List<CloudDriveFile> getFilesForFolder(String projectCode, String folderId) {
    return _driveFiles.where((f) => f.projectCode == projectCode && f.folderId == folderId).toList();
  }

  // ---------------------------------------------------------------------------
  // Computed KPIs
  // ---------------------------------------------------------------------------
  DesignWorkspaceKpis getWorkspaceKpis() {
    final activeProjects = _projects.where((p) => p.progressPercent < 100).length;
    final filesSubmitted = _deliverables.where((d) => d.status == DesignReviewStatus.sentToClient || d.status == DesignReviewStatus.underClientReview).length;
    final internalRev = _deliverables.where((d) => d.status == DesignReviewStatus.internalReview).length;
    final clientRev = _deliverables.where((d) => d.status == DesignReviewStatus.underClientReview).length;
    final revisionReq = _deliverables.where((d) => d.status == DesignReviewStatus.revisionRequested).length;
    final approvedCount = _deliverables.where((d) => d.status == DesignReviewStatus.approved).length;
    final sentToExec = _deliverables.where((d) => d.status == DesignReviewStatus.sentToExecution).length;
    final overdueCount = _deliverables.where((d) => d.isOverdue).length;

    double totalRev = 0;
    for (final d in _deliverables) {
      totalRev += d.revisionCount;
    }
    final avgRev = _deliverables.isNotEmpty ? totalRev / _deliverables.length : 0.0;

    return DesignWorkspaceKpis(
      activeDesignProjects: activeProjects,
      filesSubmitted: filesSubmitted,
      internalReview: internalRev,
      clientReview: clientRev,
      revisionRequested: revisionReq,
      approved: approvedCount,
      sentToExecution: sentToExec,
      overdueReviews: overdueCount,
      totalDesignFiles: _deliverables.length,
      averageRevisionCount: avgRev,
      averageApprovalTurnaroundHours: 32.5,
    );
  }

  // ---------------------------------------------------------------------------
  // Mutations
  // ---------------------------------------------------------------------------
  void uploadDeliverable(DesignDeliverable deliverable) {
    _deliverables.insert(0, deliverable);
    _logActivity(deliverable.projectCode, 'Uploaded ${deliverable.title}', 'New asset added by ${deliverable.designerName}', Icons.cloud_upload_outlined, const Color(0xFF3B82F6));
  }

  void createNewVersion(String deliverableId, DesignVersionRecord newVersion) {
    final idx = _deliverables.indexWhere((d) => d.id == deliverableId);
    if (idx != -1) {
      final existing = _deliverables[idx];
      final updatedHistory = List<DesignVersionRecord>.from(existing.versionHistory)..insert(0, newVersion);
      _deliverables[idx] = existing.copyWith(
        currentVersion: newVersion.versionTag,
        status: newVersion.reviewStatus,
        revisionCount: existing.revisionCount + 1,
        versionHistory: updatedHistory,
      );
      _logActivity(existing.projectCode, 'New Version ${newVersion.versionTag} for ${existing.title}', newVersion.changelogNote, Icons.update_rounded, const Color(0xFF8B5CF6));
    }
  }

  void requestRevision(DesignRevision revision) {
    _revisions.insert(0, revision);
    final idx = _deliverables.indexWhere((d) => d.id == revision.deliverableId);
    if (idx != -1) {
      _deliverables[idx] = _deliverables[idx].copyWith(
        status: DesignReviewStatus.revisionRequested,
      );
    }
    _logActivity(revision.projectCode, 'Revision Requested on ${revision.deliverableTitle}', 'Reason: ${revision.reason} by ${revision.requestedBy}', Icons.published_with_changes_rounded, const Color(0xFFEF4444));
  }

  void updateRevisionStatus(String revisionId, RevisionStatus newStatus) {
    final idx = _revisions.indexWhere((r) => r.id == revisionId);
    if (idx != -1) {
      _revisions[idx] = _revisions[idx].copyWith(status: newStatus);
    }
  }

  void submitToClient(List<String> deliverableIds, String clientName, DateTime deadline, bool allowDownload) {
    final now = DateTime.now();
    for (final id in deliverableIds) {
      final idx = _deliverables.indexWhere((d) => d.id == id);
      if (idx != -1) {
        final d = _deliverables[idx];
        _deliverables[idx] = d.copyWith(
          status: DesignReviewStatus.underClientReview,
          clientReviewSlaDeadline: deadline,
        );

        _approvals.insert(
          0,
          DesignApproval(
            id: 'app-${DateTime.now().millisecondsSinceEpoch}-${Random().nextInt(1000)}',
            projectCode: d.projectCode,
            projectName: d.projectName,
            deliverableId: d.id,
            deliverableTitle: d.title,
            clientName: clientName,
            versionTag: d.currentVersion,
            stage: DesignStage.clientReview,
            submittedBy: d.designerName,
            submittedDate: now,
            reviewDeadline: deadline,
            downloadAllowed: allowDownload,
            status: DesignReviewStatus.underClientReview,
          ),
        );

        _logActivity(d.projectCode, 'Sent ${d.title} for Client Approval', 'Submitted to $clientName. SLA Deadline: ${deadline.day}/${deadline.month}', Icons.send_rounded, const Color(0xFF0EA5E9));
      }
    }
  }

  void clientApprove(String deliverableId, String approvedBy, String comment) {
    final now = DateTime.now();
    final idx = _deliverables.indexWhere((d) => d.id == deliverableId);
    if (idx != -1) {
      final d = _deliverables[idx];
      _deliverables[idx] = d.copyWith(status: DesignReviewStatus.approved);

      // Update approval record
      final appIdx = _approvals.indexWhere((a) => a.deliverableId == deliverableId);
      if (appIdx != -1) {
        _approvals[appIdx] = _approvals[appIdx].copyWith(
          status: DesignReviewStatus.approved,
          approvedBy: approvedBy,
          approvedAt: now,
          clientComment: comment,
        );
      }

      _logActivity(d.projectCode, 'Approved: ${d.title}', 'Approved by $approvedBy. Ready for execution handover.', Icons.verified_rounded, const Color(0xFF10B981));
    }
  }

  void clientRequestRevision(String deliverableId, String reason, String comment, {List<DesignAnnotation> annotations = const []}) {
    final now = DateTime.now();
    final idx = _deliverables.indexWhere((d) => d.id == deliverableId);
    if (idx != -1) {
      final d = _deliverables[idx];
      _deliverables[idx] = d.copyWith(
        status: DesignReviewStatus.revisionRequested,
        annotations: annotations,
      );

      final appIdx = _approvals.indexWhere((a) => a.deliverableId == deliverableId);
      if (appIdx != -1) {
        _approvals[appIdx] = _approvals[appIdx].copyWith(
          status: DesignReviewStatus.revisionRequested,
          clientComment: comment,
        );
      }

      _revisions.insert(
        0,
        DesignRevision(
          id: 'rev-${DateTime.now().millisecondsSinceEpoch}',
          deliverableId: deliverableId,
          projectCode: d.projectCode,
          deliverableTitle: d.title,
          currentVersion: d.currentVersion,
          revisionNumber: d.revisionCount + 1,
          requestedBy: d.clientName,
          requestedAt: now,
          reason: reason,
          description: comment,
          specificArea: d.roomArea,
          assignedDesigner: d.designerName,
          dueDate: now.add(const Duration(days: 3)),
          status: RevisionStatus.requested,
          annotations: annotations,
        ),
      );

      _logActivity(d.projectCode, 'Client Requested Changes: ${d.title}', '$reason — $comment', Icons.published_with_changes_rounded, const Color(0xFFEF4444));
    }
  }

  void createHandoverPackage(DesignHandover package) {
    _handovers.insert(0, package);
    _logActivity(package.projectCode, 'Handover Package Created: ${package.handoverName}', 'Version: ${package.packageVersion}', Icons.handshake_outlined, const Color(0xFF2563EB));
  }

  void toggleHandoverChecklistItem(String handoverId, String checklistItemId, bool isSatisfied) {
    final idx = _handovers.indexWhere((h) => h.id == handoverId);
    if (idx != -1) {
      final h = _handovers[idx];
      final updatedChecklist = h.checklist.map((item) {
        if (item.id == checklistItemId) {
          return item.copyWith(isSatisfied: isSatisfied);
        }
        return item;
      }).toList();
      _handovers[idx] = h.copyWith(checklist: updatedChecklist);
    }
  }

  void sendToExecution(String handoverId) {
    final idx = _handovers.indexWhere((h) => h.id == handoverId);
    if (idx != -1) {
      final h = _handovers[idx];
      _handovers[idx] = h.copyWith(
        status: HandoverStatus.pendingReview,
      );

      // Mark all deliverables in this handover as sentToExecution
      for (final delivId in h.includedDeliverableIds) {
        final dIdx = _deliverables.indexWhere((d) => d.id == delivId);
        if (dIdx != -1) {
          _deliverables[dIdx] = _deliverables[dIdx].copyWith(
            status: DesignReviewStatus.sentToExecution,
            executionWebhookTriggeredAt: '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year} Handed over via ${h.packageVersion}',
          );
        }
      }

      _logActivity(h.projectCode, 'Package ${h.packageVersion} Dispatched to Execution', 'Lead PM ${h.executionManager} notified for site release.', Icons.arrow_forward_rounded, const Color(0xFF059669));
    }
  }

  void acknowledgeHandover(String handoverId, bool isAccepted, {String? rejectReason}) {
    final idx = _handovers.indexWhere((h) => h.id == handoverId);
    if (idx != -1) {
      final h = _handovers[idx];
      _handovers[idx] = h.copyWith(
        status: isAccepted ? HandoverStatus.accepted : HandoverStatus.changesRequested,
        approvedDate: isAccepted ? DateTime.now() : null,
        rejectedReason: isAccepted ? null : rejectReason,
      );
      _logActivity(h.projectCode, isAccepted ? 'Handover Accepted by Site' : 'Handover Revision Requested', isAccepted ? 'All good-for-construction drawings verified.' : 'Reason: $rejectReason', isAccepted ? Icons.verified_rounded : Icons.feedback_outlined, isAccepted ? const Color(0xFF10B981) : const Color(0xFFEF4444));
    }
  }

  void createFolder(CloudDriveFolder folder) {
    _folders.add(folder);
  }

  void uploadDriveFile(CloudDriveFile file) {
    _driveFiles.insert(0, file);
    final fIdx = _folders.indexWhere((f) => f.id == file.folderId);
    if (fIdx != -1) {
      final f = _folders[fIdx];
      _folders[fIdx] = f.copyWith(
        itemCount: f.itemCount + 1,
        totalSizeBytes: f.totalSizeBytes + file.fileSizeBytes,
        lastModified: DateTime.now(),
      );
    }
  }

  bool deleteFileWithSuperAdmin2FA(String fileId, String superAdminApprover, String otp, String reason) {
    // Verified 2FA OTP simulation
    if (otp.trim() != '884129' && otp.trim() != '123456') {
      return false;
    }

    final idx = _driveFiles.indexWhere((f) => f.id == fileId);
    if (idx != -1) {
      final file = _driveFiles[idx];
      _driveFiles.removeAt(idx);

      _deletionAuditLogs.insert(
        0,
        DeletionAuditLog(
          id: 'del-${DateTime.now().millisecondsSinceEpoch}',
          itemName: file.fileName,
          itemType: 'File',
          attemptedBy: superAdminApprover,
          superAdminApprover: superAdminApprover,
          twoFactorOtpCode: otp,
          reason: reason,
          timestamp: DateTime.now(),
          isAuthorized: true,
        ),
      );
      return true;
    }
    return false;
  }

  bool deleteFolderWithSuperAdmin2FA(String folderId, String superAdminApprover, String otp, String reason) {
    if (otp.trim() != '884129' && otp.trim() != '123456') {
      return false;
    }

    final idx = _folders.indexWhere((f) => f.id == folderId);
    if (idx != -1) {
      final folder = _folders[idx];
      _folders.removeAt(idx);
      _driveFiles.removeWhere((f) => f.folderId == folderId);

      _deletionAuditLogs.insert(
        0,
        DeletionAuditLog(
          id: 'del-${DateTime.now().millisecondsSinceEpoch}',
          itemName: folder.name,
          itemType: 'Folder',
          attemptedBy: superAdminApprover,
          superAdminApprover: superAdminApprover,
          twoFactorOtpCode: otp,
          reason: reason,
          timestamp: DateTime.now(),
          isAuthorized: true,
        ),
      );
      return true;
    }
    return false;
  }

  void _logActivity(String projectCode, String action, String description, IconData icon, Color color) {
    _activities.insert(
      0,
      DesignActivity(
        id: 'act-${DateTime.now().millisecondsSinceEpoch}',
        projectCode: projectCode,
        action: action,
        description: description,
        performedBy: 'Current User',
        timestamp: DateTime.now(),
        icon: icon,
        iconColor: color,
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Seed Initial Realistic Data
  // ---------------------------------------------------------------------------
  void _seedInitialData() {
    final now = DateTime.now();

    // 1. Projects
    _projects.addAll([
      DesignProject(
        id: 'dp-1',
        code: 'PRJ-104',
        name: 'DLF The Camellias - 4BHK Duplex Penthouse',
        clientName: 'Vikram Malhotra',
        projectManager: 'Rajesh Nair',
        designer: 'Ananya Roy',
        stage: DesignStage.finalApproval,
        progressPercent: 88.0,
        activeDeliverablesCount: 8,
        pendingApprovalsCount: 2,
        revisionsCount: 4,
        startDate: now.subtract(const Duration(days: 45)),
        targetCompletionDate: now.add(const Duration(days: 15)),
        lastUpdated: now.subtract(const Duration(hours: 3)),
        totalAreaSqFt: 6200,
        category: 'Luxury Turnkey Penthouse',
      ),
      DesignProject(
        id: 'dp-2',
        code: 'PRJ-105',
        name: 'The Magnolias Golf Villa 24B',
        clientName: 'Sunita Mehra',
        projectManager: 'Kunal Verma',
        designer: 'Kabir Sharma',
        stage: DesignStage.threeDDesign,
        progressPercent: 62.0,
        activeDeliverablesCount: 12,
        pendingApprovalsCount: 3,
        revisionsCount: 6,
        startDate: now.subtract(const Duration(days: 30)),
        targetCompletionDate: now.add(const Duration(days: 35)),
        lastUpdated: now.subtract(const Duration(hours: 6)),
        totalAreaSqFt: 8400,
        category: 'Golf Villa Architecture & Interiors',
      ),
      DesignProject(
        id: 'dp-3',
        code: 'PRJ-106',
        name: 'Aralias Tower 2 - Modern Minimalist 3BHK',
        clientName: 'Rohit Khandelwal',
        projectManager: 'Neha Reddy',
        designer: 'Pooja Bhatt',
        stage: DesignStage.executionHandover,
        progressPercent: 95.0,
        activeDeliverablesCount: 15,
        pendingApprovalsCount: 0,
        revisionsCount: 3,
        startDate: now.subtract(const Duration(days: 60)),
        targetCompletionDate: now.add(const Duration(days: 5)),
        lastUpdated: now.subtract(const Duration(days: 1)),
        totalAreaSqFt: 3800,
        category: 'Minimalist Interior Renovation',
      ),
      DesignProject(
        id: 'dp-4',
        code: 'PRJ-107',
        name: 'Panchsheel Park Boutique Residence',
        clientName: 'Alok Goel',
        projectManager: 'Vikram Mehta',
        designer: 'Ananya Roy',
        stage: DesignStage.twoDLayout,
        progressPercent: 40.0,
        activeDeliverablesCount: 6,
        pendingApprovalsCount: 1,
        revisionsCount: 1,
        startDate: now.subtract(const Duration(days: 15)),
        targetCompletionDate: now.add(const Duration(days: 55)),
        lastUpdated: now.subtract(const Duration(hours: 12)),
        totalAreaSqFt: 4500,
        category: 'Residential Bungalow Turnkey',
      ),
      DesignProject(
        id: 'dp-5',
        code: 'PRJ-108',
        name: 'Worli Sea Face Duplex Apartment',
        clientName: 'Gaurav Singhania',
        projectManager: 'Kunal Verma',
        designer: 'Kabir Sharma',
        stage: DesignStage.concept,
        progressPercent: 20.0,
        activeDeliverablesCount: 4,
        pendingApprovalsCount: 2,
        revisionsCount: 0,
        startDate: now.subtract(const Duration(days: 8)),
        targetCompletionDate: now.add(const Duration(days: 70)),
        lastUpdated: now.subtract(const Duration(days: 2)),
        totalAreaSqFt: 5100,
        category: 'Contemporary Coastal Duplex',
      ),
      DesignProject(
        id: 'dp-6',
        code: 'PRJ-109',
        name: 'Koramangala Executive Workspace & Lounge',
        clientName: 'TechVentures HQ',
        projectManager: 'Neha Reddy',
        designer: 'Pooja Bhatt',
        stage: DesignStage.materialSelection,
        progressPercent: 55.0,
        activeDeliverablesCount: 7,
        pendingApprovalsCount: 1,
        revisionsCount: 2,
        startDate: now.subtract(const Duration(days: 25)),
        targetCompletionDate: now.add(const Duration(days: 40)),
        lastUpdated: now.subtract(const Duration(hours: 18)),
        totalAreaSqFt: 7200,
        category: 'Commercial Office & Lounge',
      ),
    ]);

    // 2. Deliverables
    _deliverables.addAll([
      DesignDeliverable(
        id: 'del-104-01',
        projectCode: 'PRJ-104',
        projectName: 'DLF The Camellias - 4BHK Duplex Penthouse',
        title: 'Double Height Living Room Luxury Ceiling & Cove CAD',
        roomArea: 'Living Room Pavilion',
        category: DesignCategory.twoDCad,
        fileType: DesignFileType.dwg,
        currentVersion: 'v3.0',
        status: DesignReviewStatus.approved,
        designerName: 'Ananya Roy',
        clientName: 'Vikram Malhotra',
        createdAt: now.subtract(const Duration(days: 28)),
        clientReviewSlaDeadline: now.subtract(const Duration(days: 22)),
        revisionCount: 3,
        fileSizeBytes: 14200000,
        thumbnailUrl: 'https://images.unsplash.com/photo-1600210492486-724fe5c67fb0?w=600&q=80',
        fileUrl: 'https://storage.homio.internal/designs/PRJ-104/CAD/Living_Ceiling_v3.dwg',
        executionWebhookTriggeredAt: '28/08/2026 MS-104 Unlocked',
        tags: ['DWG', 'False Ceiling', 'Gyproc', 'Philips Cove'],
        versionHistory: [
          DesignVersionRecord(versionTag: 'v1.0', fileName: 'Living_Ceiling_v1.dwg', fileUrl: '...', fileSizeBytes: 12400000, uploadedAt: now.subtract(const Duration(days: 35)), uploadedByName: 'Ananya Roy', changelogNote: 'Initial circular drop layout', reviewStatus: DesignReviewStatus.revisionRequested, clientFeedback: 'Client prefers rectilinear linear coves.'),
          DesignVersionRecord(versionTag: 'v2.0', fileName: 'Living_Ceiling_v2.dwg', fileUrl: '...', fileSizeBytes: 13800000, uploadedAt: now.subtract(const Duration(days: 31)), uploadedByName: 'Ananya Roy', changelogNote: 'Linear coves with magnetic diffuser slots', reviewStatus: DesignReviewStatus.revisionRequested, clientFeedback: 'Adjust HVAC grille drop depth to 150mm.'),
          DesignVersionRecord(versionTag: 'v3.0', fileName: 'Living_Ceiling_v3.dwg', fileUrl: '...', fileSizeBytes: 14200000, uploadedAt: now.subtract(const Duration(days: 28)), uploadedByName: 'Ananya Roy', changelogNote: 'Final Daikin VRV 150mm clearance aligned', reviewStatus: DesignReviewStatus.approved, clientFeedback: 'Approved by Vikram Malhotra.'),
        ],
      ),
      DesignDeliverable(
        id: 'del-104-02',
        projectCode: 'PRJ-104',
        projectName: 'DLF The Camellias - 4BHK Duplex Penthouse',
        title: 'Master Bedroom 4K Photorealistic Twilight Render',
        roomArea: 'Master Suite',
        category: DesignCategory.threeDRender,
        fileType: DesignFileType.jpg,
        currentVersion: 'v2.0',
        status: DesignReviewStatus.underClientReview,
        designerName: 'Kabir Sharma',
        clientName: 'Vikram Malhotra',
        createdAt: now.subtract(const Duration(days: 5)),
        clientReviewSlaDeadline: now.add(const Duration(days: 2)),
        revisionCount: 2,
        fileSizeBytes: 8900000,
        thumbnailUrl: 'https://images.unsplash.com/photo-1616486338812-3dadae4b4ace?w=600&q=80',
        fileUrl: 'https://storage.homio.internal/designs/PRJ-104/Renders/Master_Twilight_v2.jpg',
        tags: ['3D Render', 'Corona 11', 'Italian Marble', 'Flos Lighting'],
        versionHistory: [
          DesignVersionRecord(versionTag: 'v1.0', fileName: 'Master_Twilight_v1.jpg', fileUrl: '...', fileSizeBytes: 8100000, uploadedAt: now.subtract(const Duration(days: 12)), uploadedByName: 'Kabir Sharma', changelogNote: 'Initial dusk lighting render', reviewStatus: DesignReviewStatus.revisionRequested, clientFeedback: 'Change headboard fabric from beige to charcoal bouclé.'),
          DesignVersionRecord(versionTag: 'v2.0', fileName: 'Master_Twilight_v2.jpg', fileUrl: '...', fileSizeBytes: 8900000, uploadedAt: now.subtract(const Duration(days: 5)), uploadedByName: 'Kabir Sharma', changelogNote: 'Updated Dedar Milano bouclé headboard & warm reading sconces', reviewStatus: DesignReviewStatus.underClientReview),
        ],
        annotations: [
          DesignAnnotation(id: 'an-1', author: 'Vikram Malhotra (Client)', timestamp: now.subtract(const Duration(days: 2)), xPercent: 0.45, yPercent: 0.65, comment: 'Can we inspect brass trim thickness on nightstand? Looks slightly wide.', type: AnnotationType.pin),
        ],
      ),
      DesignDeliverable(
        id: 'del-104-03',
        projectCode: 'PRJ-104',
        projectName: 'DLF The Camellias - 4BHK Duplex Penthouse',
        title: 'Italian Kitchen Island & Cabinetry Detailed Joinery Drawings',
        roomArea: 'Show Kitchen',
        category: DesignCategory.detailJoinery,
        fileType: DesignFileType.pdf,
        currentVersion: 'v1.0',
        status: DesignReviewStatus.underClientReview,
        designerName: 'Ananya Roy',
        clientName: 'Vikram Malhotra',
        createdAt: now.subtract(const Duration(days: 3)),
        clientReviewSlaDeadline: now.add(const Duration(days: 4)),
        revisionCount: 1,
        fileSizeBytes: 6200000,
        thumbnailUrl: 'https://images.unsplash.com/photo-1556911220-e15b29be8c8f?w=600&q=80',
        fileUrl: 'https://storage.homio.internal/designs/PRJ-104/Drawings/Kitchen_Joinery_v1.pdf',
        tags: ['Joinery', 'Poliform', 'Blum Legrabox', 'Miele Appliances'],
        versionHistory: [
          DesignVersionRecord(versionTag: 'v1.0', fileName: 'Kitchen_Joinery_v1.pdf', fileUrl: '...', fileSizeBytes: 6200000, uploadedAt: now.subtract(const Duration(days: 3)), uploadedByName: 'Ananya Roy', changelogNote: 'Complete sectional cutlists and Blum hardware elevations', reviewStatus: DesignReviewStatus.underClientReview),
        ],
      ),
      DesignDeliverable(
        id: 'del-104-04',
        projectCode: 'PRJ-104',
        projectName: 'DLF The Camellias - 4BHK Duplex Penthouse',
        title: 'Master Wardrobe Walk-in Dressing Room Layout & Cutlist',
        roomArea: 'Master Dressing Room',
        category: DesignCategory.workingDrawings,
        fileType: DesignFileType.dwg,
        currentVersion: 'v2.0',
        status: DesignReviewStatus.revisionRequested,
        designerName: 'Pooja Bhatt',
        clientName: 'Vikram Malhotra',
        createdAt: now.subtract(const Duration(days: 6)),
        clientReviewSlaDeadline: now.subtract(const Duration(days: 1)),
        revisionCount: 2,
        fileSizeBytes: 11500000,
        thumbnailUrl: 'https://images.unsplash.com/photo-1558997519-83ea9252def8?w=600&q=80',
        fileUrl: 'https://storage.homio.internal/designs/PRJ-104/CAD/Wardrobe_Cutlist_v2.dwg',
        tags: ['Wardrobe', 'Smoked Glass', 'LED Sensor Strips'],
        versionHistory: [
          DesignVersionRecord(versionTag: 'v1.0', fileName: 'Wardrobe_Cutlist_v1.dwg', fileUrl: '...', fileSizeBytes: 10200000, uploadedAt: now.subtract(const Duration(days: 14)), uploadedByName: 'Pooja Bhatt', changelogNote: 'Standard 6-bay layout', reviewStatus: DesignReviewStatus.revisionRequested, clientFeedback: 'Add dedicated watch winder drawer and jewelry island.'),
          DesignVersionRecord(versionTag: 'v2.0', fileName: 'Wardrobe_Cutlist_v2.dwg', fileUrl: '...', fileSizeBytes: 11500000, uploadedAt: now.subtract(const Duration(days: 6)), uploadedByName: 'Pooja Bhatt', changelogNote: 'Added center island with velvet drawers & 4-rotor watch winder slot', reviewStatus: DesignReviewStatus.revisionRequested, clientFeedback: 'Depth needs 50mm extension for full-length trench coat hangars.'),
        ],
      ),
      DesignDeliverable(
        id: 'del-105-01',
        projectCode: 'PRJ-105',
        projectName: 'The Magnolias Golf Villa 24B',
        title: 'Exterior Double-Height Facade Cladding & Louver Details',
        roomArea: 'Exterior Architecture',
        category: DesignCategory.executionDrawings,
        fileType: DesignFileType.dwg,
        currentVersion: 'v1.0',
        status: DesignReviewStatus.internalReview,
        designerName: 'Kabir Sharma',
        clientName: 'Sunita Mehra',
        createdAt: now.subtract(const Duration(days: 2)),
        clientReviewSlaDeadline: now.add(const Duration(days: 6)),
        revisionCount: 1,
        fileSizeBytes: 18400000,
        thumbnailUrl: 'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?w=600&q=80',
        fileUrl: 'https://storage.homio.internal/designs/PRJ-105/CAD/Facade_Louvers_v1.dwg',
        tags: ['Facade', 'HPL Louvers', 'Travertine Cladding'],
        versionHistory: [
          DesignVersionRecord(versionTag: 'v1.0', fileName: 'Facade_Louvers_v1.dwg', fileUrl: '...', fileSizeBytes: 18400000, uploadedAt: now.subtract(const Duration(days: 2)), uploadedByName: 'Kabir Sharma', changelogNote: 'Structural fixing brackets and Wind-load anchor engineering', reviewStatus: DesignReviewStatus.internalReview),
        ],
      ),
      DesignDeliverable(
        id: 'del-106-01',
        projectCode: 'PRJ-106',
        projectName: 'Aralias Tower 2 - Modern Minimalist 3BHK',
        title: 'Comprehensive Good-For-Construction Architectural Dossier',
        roomArea: 'Entire Apartment',
        category: DesignCategory.workingDrawings,
        fileType: DesignFileType.pdf,
        currentVersion: 'v4.0',
        status: DesignReviewStatus.sentToExecution,
        designerName: 'Pooja Bhatt',
        clientName: 'Rohit Khandelwal',
        createdAt: now.subtract(const Duration(days: 15)),
        clientReviewSlaDeadline: now.subtract(const Duration(days: 10)),
        revisionCount: 4,
        fileSizeBytes: 24500000,
        thumbnailUrl: 'https://images.unsplash.com/photo-1600607687939-ce8a6c25118c?w=600&q=80',
        fileUrl: 'https://storage.homio.internal/designs/PRJ-106/Dossier/GFC_Dossier_v4.pdf',
        executionWebhookTriggeredAt: '22/08/2026 11:15 IST (Handed over to Site PM)',
        tags: ['GFC', 'Approved', 'Ready for Handover', 'Civil & MEP'],
        versionHistory: [
          DesignVersionRecord(versionTag: 'v4.0', fileName: 'GFC_Dossier_v4.pdf', fileUrl: '...', fileSizeBytes: 24500000, uploadedAt: now.subtract(const Duration(days: 15)), uploadedByName: 'Pooja Bhatt', changelogNote: 'All site modifications signed off and stamped by Lead Architect', reviewStatus: DesignReviewStatus.approved),
        ],
      ),
    ]);

    // 3. Revisions
    _revisions.addAll([
      DesignRevision(
        id: 'rev-1',
        deliverableId: 'del-104-04',
        projectCode: 'PRJ-104',
        deliverableTitle: 'Master Wardrobe Walk-in Dressing Room Layout & Cutlist',
        currentVersion: 'v2.0',
        revisionNumber: 3,
        requestedBy: 'Vikram Malhotra',
        requestedAt: now.subtract(const Duration(days: 1)),
        reason: 'Hanger depth insufficient for full-length overcoats',
        description: 'Increase hanging carcase depth by 50mm on Bay 3 and Bay 4. Ensure smoked glass door clearance remains flush with center island.',
        specificArea: 'Master Dressing Room',
        assignedDesigner: 'Pooja Bhatt',
        dueDate: now.add(const Duration(days: 2)),
        status: RevisionStatus.inProgress,
      ),
      DesignRevision(
        id: 'rev-2',
        deliverableId: 'del-104-02',
        projectCode: 'PRJ-104',
        deliverableTitle: 'Master Bedroom 4K Photorealistic Twilight Render',
        currentVersion: 'v2.0',
        revisionNumber: 2,
        requestedBy: 'Vikram Malhotra',
        requestedAt: now.subtract(const Duration(days: 2)),
        reason: 'Nightstand brass trim proportion adjustment',
        description: 'Client flagged brass inlay band on wall-mounted nightstands appears 40mm thick. Requesting reduction to 20mm slim profile.',
        specificArea: 'Master Suite',
        assignedDesigner: 'Kabir Sharma',
        dueDate: now.add(const Duration(days: 1)),
        status: RevisionStatus.assigned,
      ),
    ]);

    // 4. Approvals Queue
    _approvals.addAll([
      DesignApproval(
        id: 'app-1',
        projectCode: 'PRJ-104',
        projectName: 'DLF The Camellias - 4BHK Duplex Penthouse',
        deliverableId: 'del-104-02',
        deliverableTitle: 'Master Bedroom 4K Photorealistic Twilight Render',
        clientName: 'Vikram Malhotra',
        versionTag: 'v2.0',
        stage: DesignStage.clientReview,
        submittedBy: 'Kabir Sharma',
        submittedDate: now.subtract(const Duration(days: 5)),
        reviewDeadline: now.add(const Duration(days: 2)),
        status: DesignReviewStatus.underClientReview,
      ),
      DesignApproval(
        id: 'app-2',
        projectCode: 'PRJ-104',
        projectName: 'DLF The Camellias - 4BHK Duplex Penthouse',
        deliverableId: 'del-104-03',
        deliverableTitle: 'Italian Kitchen Island & Cabinetry Detailed Joinery Drawings',
        clientName: 'Vikram Malhotra',
        versionTag: 'v1.0',
        stage: DesignStage.clientReview,
        submittedBy: 'Ananya Roy',
        submittedDate: now.subtract(const Duration(days: 3)),
        reviewDeadline: now.add(const Duration(days: 4)),
        status: DesignReviewStatus.underClientReview,
      ),
      DesignApproval(
        id: 'app-3',
        projectCode: 'PRJ-104',
        projectName: 'DLF The Camellias - 4BHK Duplex Penthouse',
        deliverableId: 'del-104-01',
        deliverableTitle: 'Double Height Living Room Luxury Ceiling & Cove CAD',
        clientName: 'Vikram Malhotra',
        versionTag: 'v3.0',
        stage: DesignStage.finalApproval,
        submittedBy: 'Ananya Roy',
        submittedDate: now.subtract(const Duration(days: 29)),
        reviewDeadline: now.subtract(const Duration(days: 25)),
        status: DesignReviewStatus.approved,
        approvedBy: 'Vikram Malhotra',
        approvedAt: now.subtract(const Duration(days: 28)),
        clientComment: 'Looks spectacular. Approved for site execution.',
      ),
    ]);

    // 5. Execution Handovers
    _handovers.addAll([
      DesignHandover(
        id: 'ho-1',
        projectCode: 'PRJ-106',
        projectName: 'Aralias Tower 2 - Modern Minimalist 3BHK',
        packageVersion: 'PKG-106-v1.0',
        handoverName: 'Full Civil, Electrical & Joinery Good-For-Construction Release',
        createdBy: 'Pooja Bhatt',
        createdDate: now.subtract(const Duration(days: 15)),
        designManager: 'Ananya Roy',
        executionManager: 'Suresh Site PM',
        siteSupervisor: 'Dharmesh Rawat',
        description: 'Complete verified architectural package with MEP coordinates, finish schedules and Blum hardware cutlists.',
        instructions: 'Follow strictly the 150mm datum line marked on master pillar. Do not alter kitchen drain core without PM signoff.',
        priority: DesignPriority.high,
        status: HandoverStatus.accepted,
        includedDeliverableIds: ['del-106-01'],
        approvedDate: now.subtract(const Duration(days: 14)),
        checklist: const [
          HandoverChecklistItem(id: 'c1', title: '2D Floor Plan & Demolition Layout Approved', isSatisfied: true),
          HandoverChecklistItem(id: 'c2', title: 'Electrical & Automation Wiring Conduit Layout Approved', isSatisfied: true),
          HandoverChecklistItem(id: 'c3', title: 'Plumbing & Sanitaryware Rough-in Drawings Approved', isSatisfied: true),
          HandoverChecklistItem(id: 'c4', title: 'False Ceiling & Reflected Ceiling Plan Approved', isSatisfied: true),
          HandoverChecklistItem(id: 'c5', title: 'Full Itemized BOQ & Vendor Brand Specifications Finalized', isSatisfied: true),
          HandoverChecklistItem(id: 'c6', title: 'Client Milestone 2 Sign-off & Payment Realized', isSatisfied: true),
        ],
      ),
      DesignHandover(
        id: 'ho-2',
        projectCode: 'PRJ-104',
        projectName: 'DLF The Camellias - 4BHK Duplex Penthouse',
        packageVersion: 'PKG-104-v1.0-RC1',
        handoverName: 'Phase 1 Structural Ceiling & Show Kitchen Handover',
        createdBy: 'Ananya Roy',
        createdDate: now.subtract(const Duration(days: 2)),
        designManager: 'Ananya Roy',
        executionManager: 'Rajesh Nair',
        siteSupervisor: 'Vikas Kumar',
        description: 'Approved living room ceiling framing and Poliform kitchen services rough-in dossier.',
        instructions: 'Gyproc Ultra ceiling framework must use 0.55mm BMT channels with anti-corrosive primer coating.',
        priority: DesignPriority.urgent,
        status: HandoverStatus.readyForHandover,
        includedDeliverableIds: ['del-104-01'],
        checklist: const [
          HandoverChecklistItem(id: 'c1', title: 'Living Ceiling DWG Approved by Client', isSatisfied: true),
          HandoverChecklistItem(id: 'c2', title: 'HVAC VRV Layout Cleared with Daikin Engineer', isSatisfied: true),
          HandoverChecklistItem(id: 'c3', title: 'Kitchen Island Joinery Approved', isSatisfied: false, statusNotes: 'Client review pending (deadline in 4 days)'),
          HandoverChecklistItem(id: 'c4', title: 'Italian Marble Slab Lot Inspected at Kishangarh Depot', isSatisfied: true),
        ],
      ),
    ]);

    // 6. Cloud Folders
    _folders.addAll([
      CloudDriveFolder(id: 'fld-1', projectCode: 'PRJ-104', name: '01 Project Information', folderType: CloudFolderType.surveys, path: 'PRJ-104 / 01 Project Information', itemCount: 4, totalSizeBytes: 18400000, lastModified: now.subtract(const Duration(days: 40))),
      CloudDriveFolder(id: 'fld-2', projectCode: 'PRJ-104', name: '02 Site Measurements', folderType: CloudFolderType.siteMeasurements, path: 'PRJ-104 / 02 Site Measurements', itemCount: 12, totalSizeBytes: 52000000, lastModified: now.subtract(const Duration(days: 35))),
      CloudDriveFolder(id: 'fld-3', projectCode: 'PRJ-104', name: '03 Floor Plans', folderType: CloudFolderType.floorPlans, path: 'PRJ-104 / 03 Floor Plans', itemCount: 6, totalSizeBytes: 34200000, lastModified: now.subtract(const Duration(days: 30))),
      CloudDriveFolder(id: 'fld-4', projectCode: 'PRJ-104', name: '04 2D Drawings', folderType: CloudFolderType.cadDrawings, path: 'PRJ-104 / 04 2D Drawings', itemCount: 18, totalSizeBytes: 112000000, lastModified: now.subtract(const Duration(days: 2))),
      CloudDriveFolder(id: 'fld-5', projectCode: 'PRJ-104', name: '05 3D Models', folderType: CloudFolderType.models3D, path: 'PRJ-104 / 05 3D Models', itemCount: 5, totalSizeBytes: 420000000, lastModified: now.subtract(const Duration(days: 10))),
      CloudDriveFolder(id: 'fld-6', projectCode: 'PRJ-104', name: '06 3D Renders', folderType: CloudFolderType.renders3D, path: 'PRJ-104 / 06 3D Renders', itemCount: 24, totalSizeBytes: 215000000, lastModified: now.subtract(const Duration(days: 1))),
      CloudDriveFolder(id: 'fld-7', projectCode: 'PRJ-104', name: '07 Mood Boards', folderType: CloudFolderType.moodboards, path: 'PRJ-104 / 07 Mood Boards', itemCount: 8, totalSizeBytes: 45000000, lastModified: now.subtract(const Duration(days: 28))),
      CloudDriveFolder(id: 'fld-8', projectCode: 'PRJ-104', name: '08 Material Selection', folderType: CloudFolderType.materialSelection, path: 'PRJ-104 / 08 Material Selection', itemCount: 14, totalSizeBytes: 78000000, lastModified: now.subtract(const Duration(days: 12))),
      CloudDriveFolder(id: 'fld-9', projectCode: 'PRJ-104', name: '09 BOQ & Cost Estimates', folderType: CloudFolderType.boq, path: 'PRJ-104 / 09 BOQ', itemCount: 3, totalSizeBytes: 12000000, lastModified: now.subtract(const Duration(days: 8))),
      CloudDriveFolder(id: 'fld-10', projectCode: 'PRJ-104', name: '10 Client Approvals', folderType: CloudFolderType.clientApprovals, path: 'PRJ-104 / 10 Client Approvals', itemCount: 7, totalSizeBytes: 38000000, lastModified: now.subtract(const Duration(days: 5))),
      CloudDriveFolder(id: 'fld-11', projectCode: 'PRJ-104', name: '11 Revisions', folderType: CloudFolderType.revisions, path: 'PRJ-104 / 11 Revisions', itemCount: 15, totalSizeBytes: 145000000, lastModified: now.subtract(const Duration(days: 1))),
      CloudDriveFolder(id: 'fld-12', projectCode: 'PRJ-104', name: '12 Execution Drawings', folderType: CloudFolderType.executionDrawings, path: 'PRJ-104 / 12 Execution Drawings', itemCount: 9, totalSizeBytes: 84000000, lastModified: now.subtract(const Duration(days: 3))),
      CloudDriveFolder(id: 'fld-13', projectCode: 'PRJ-104', name: '13 Handover', folderType: CloudFolderType.handover, path: 'PRJ-104 / 13 Handover', itemCount: 2, totalSizeBytes: 31000000, lastModified: now.subtract(const Duration(days: 2))),
    ]);

    // 7. Cloud Files
    _driveFiles.addAll([
      CloudDriveFile(id: 'cf-1', projectCode: 'PRJ-104', folderId: 'fld-4', folderPath: 'PRJ-104 / 04 2D Drawings', fileName: 'Living_Ceiling_v3.dwg', fileType: DesignFileType.dwg, fileSizeBytes: 14200000, uploadedAt: now.subtract(const Duration(days: 28)), uploadedBy: 'Ananya Roy', downloadUrl: 'https://storage.homio.internal/designs/PRJ-104/CAD/Living_Ceiling_v3.dwg', thumbnailUrl: '', versionTag: 'v3.0', tags: ['Approved', 'CAD']),
      CloudDriveFile(id: 'cf-2', projectCode: 'PRJ-104', folderId: 'fld-6', folderPath: 'PRJ-104 / 06 3D Renders', fileName: 'Master_Twilight_v2.jpg', fileType: DesignFileType.jpg, fileSizeBytes: 8900000, uploadedAt: now.subtract(const Duration(days: 5)), uploadedBy: 'Kabir Sharma', downloadUrl: 'https://storage.homio.internal/designs/PRJ-104/Renders/Master_Twilight_v2.jpg', thumbnailUrl: 'https://images.unsplash.com/photo-1616486338812-3dadae4b4ace?w=300&q=80', versionTag: 'v2.0', tags: ['Client Review', '3D']),
      CloudDriveFile(id: 'cf-3', projectCode: 'PRJ-104', folderId: 'fld-4', folderPath: 'PRJ-104 / 04 2D Drawings', fileName: 'Kitchen_Joinery_v1.pdf', fileType: DesignFileType.pdf, fileSizeBytes: 6200000, uploadedAt: now.subtract(const Duration(days: 3)), uploadedBy: 'Ananya Roy', downloadUrl: 'https://storage.homio.internal/designs/PRJ-104/Drawings/Kitchen_Joinery_v1.pdf', thumbnailUrl: 'https://images.unsplash.com/photo-1556911220-e15b29be8c8f?w=300&q=80', versionTag: 'v1.0', tags: ['PDF', 'Joinery']),
      CloudDriveFile(id: 'cf-4', projectCode: 'PRJ-104', folderId: 'fld-5', folderPath: 'PRJ-104 / 05 3D Models', fileName: 'Camellias_Penthouse_BIM_Full.skp', fileType: DesignFileType.skp, fileSizeBytes: 184000000, uploadedAt: now.subtract(const Duration(days: 10)), uploadedBy: 'Kabir Sharma', downloadUrl: 'https://storage.homio.internal/designs/PRJ-104/Models/Camellias_Penthouse_BIM_Full.skp', thumbnailUrl: '', versionTag: 'v2.1', tags: ['SketchUp', 'BIM']),
      CloudDriveFile(id: 'cf-5', projectCode: 'PRJ-104', folderId: 'fld-9', folderPath: 'PRJ-104 / 09 BOQ', fileName: 'Camellias_Master_BOQ_Rev3.xlsx', fileType: DesignFileType.xlsx, fileSizeBytes: 3200000, uploadedAt: now.subtract(const Duration(days: 8)), uploadedBy: 'Rajesh Nair', downloadUrl: 'https://storage.homio.internal/designs/PRJ-104/BOQ/Camellias_Master_BOQ_Rev3.xlsx', thumbnailUrl: '', versionTag: 'v3.0', tags: ['BOQ', 'Internal Cost']),
    ]);

    // 8. Designer Workloads
    _designerWorkloads.addAll([
      const DesignerWorkload(designerName: 'Ananya Roy', role: 'Design Head / Principal Architect', assignedProjectsCount: 3, activeDeliverablesCount: 14, pendingRevisionsCount: 1, completedDeliverablesCount: 28, approvalRatePercent: 94.0),
      const DesignerWorkload(designerName: 'Kabir Sharma', role: 'Senior 3D Artist & Visualizer', assignedProjectsCount: 4, activeDeliverablesCount: 18, pendingRevisionsCount: 3, completedDeliverablesCount: 34, approvalRatePercent: 88.0),
      const DesignerWorkload(designerName: 'Pooja Bhatt', role: 'Junior Designer & 2D CAD Specialist', assignedProjectsCount: 3, activeDeliverablesCount: 12, pendingRevisionsCount: 2, completedDeliverablesCount: 22, approvalRatePercent: 91.0),
    ]);

    // 9. Initial Activities
    _activities.addAll([
      DesignActivity(id: 'act-1', projectCode: 'PRJ-104', action: 'Approved: Double Height Living Room Ceiling CAD', description: 'Client sign-off achieved. Milestone MS-104-03 unlocked.', performedBy: 'Vikram Malhotra', timestamp: now.subtract(const Duration(hours: 4)), icon: Icons.verified_rounded, iconColor: const Color(0xFF10B981)),
      DesignActivity(id: 'act-2', projectCode: 'PRJ-104', action: 'Revision Requested on Master Dressing Room', description: 'Hanger depth needs 50mm enlargement for overcoats.', performedBy: 'Vikram Malhotra', timestamp: now.subtract(const Duration(hours: 12)), icon: Icons.published_with_changes_rounded, iconColor: const Color(0xFFEF4444)),
      DesignActivity(id: 'act-3', projectCode: 'PRJ-105', action: '3D Render Uploaded for Magnolia Golf Villa', description: 'Twilight terrace lounge 4K render submitted for review.', performedBy: 'Kabir Sharma', timestamp: now.subtract(const Duration(days: 1)), icon: Icons.cloud_upload_outlined, iconColor: const Color(0xFF3B82F6)),
      DesignActivity(id: 'act-4', projectCode: 'PRJ-106', action: 'Handover Package PKG-106-v1.0 Accepted by Site PM', description: 'Good-for-construction dossier released to execution team.', performedBy: 'Suresh Site PM', timestamp: now.subtract(const Duration(days: 2)), icon: Icons.handshake_outlined, iconColor: const Color(0xFF059669)),
    ]);
  }
}
