enum BlueprintCategory {
  all,
  cad2d,
  render3d,
  contract,
  invoice,
  siteReport,
  specSheet,
}

enum DocApprovalStatus {
  approved,
  pendingReview,
  revisionRequested,
}

class BlueprintDocument {
  final String id;
  final String title;
  final String projectTitle;
  final String clientName;
  final String clientPhone;
  final BlueprintCategory category;
  final String fileFormat;
  final int fileSizeBytes;
  final String version;
  DocApprovalStatus approvalStatus;
  final String uploadedBy;
  final DateTime uploadedAt;
  final String? previewThumbnailUrl;
  int whatsappShareCount;

  BlueprintDocument({
    required this.id,
    required this.title,
    required this.projectTitle,
    required this.clientName,
    required this.clientPhone,
    required this.category,
    required this.fileFormat,
    required this.fileSizeBytes,
    required this.version,
    required this.approvalStatus,
    required this.uploadedBy,
    required this.uploadedAt,
    this.previewThumbnailUrl,
    this.whatsappShareCount = 0,
  });

  String get fileSizeFormatted {
    if (fileSizeBytes < 1024 * 1024) {
      return '${(fileSizeBytes / 1024).toStringAsFixed(1)} KB';
    }
    return '${(fileSizeBytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}

class BlueprintMockData {
  static final List<BlueprintDocument> documents = [
    BlueprintDocument(
      id: 'doc_001',
      title: 'Architectural Electrical Layout & Track Lights Rev-2.1',
      projectTitle: 'Villa #42 - Palm Meadows',
      clientName: 'Vikram Malhotra',
      clientPhone: '+91 98201 44521',
      category: BlueprintCategory.cad2d,
      fileFormat: 'DWG',
      fileSizeBytes: 14 * 1024 * 1024,
      version: 'v2.1',
      approvalStatus: DocApprovalStatus.approved,
      uploadedBy: 'Ar. Rohan Sen (Lead Architect)',
      uploadedAt: DateTime.now().subtract(const Duration(days: 2)),
      previewThumbnailUrl: 'https://images.unsplash.com/photo-1503387762-592deb58ef4e?auto=format&fit=crop&w=600&q=80',
      whatsappShareCount: 4,
    ),
    BlueprintDocument(
      id: 'doc_002',
      title: 'Ultra-HD Photorealistic 3D Renders - Master Suite & Walk-in Wardrobe',
      projectTitle: 'Villa #42 - Palm Meadows',
      clientName: 'Vikram Malhotra',
      clientPhone: '+91 98201 44521',
      category: BlueprintCategory.render3d,
      fileFormat: 'JPG',
      fileSizeBytes: 28 * 1024 * 1024,
      version: 'v3.0',
      approvalStatus: DocApprovalStatus.approved,
      uploadedBy: 'Neha Kulkarni (3D Visualizer)',
      uploadedAt: DateTime.now().subtract(const Duration(days: 4)),
      previewThumbnailUrl: 'https://images.unsplash.com/photo-1618221195710-dd6b41faaea6?auto=format&fit=crop&w=600&q=80',
      whatsappShareCount: 8,
    ),
    BlueprintDocument(
      id: 'doc_003',
      title: 'Turnkey Interior Execution Contract & Warranty Bond (Rs. 45 Lakhs)',
      projectTitle: 'Skyline Towers #14B',
      clientName: 'Ananya Deshmukh',
      clientPhone: '+91 97654 32190',
      category: BlueprintCategory.contract,
      fileFormat: 'PDF',
      fileSizeBytes: 3 * 1024 * 1024,
      version: 'v1.0 (Signed)',
      approvalStatus: DocApprovalStatus.approved,
      uploadedBy: 'Homio Legal Compliance',
      uploadedAt: DateTime.now().subtract(const Duration(days: 18)),
      previewThumbnailUrl: null,
      whatsappShareCount: 2,
    ),
    BlueprintDocument(
      id: 'doc_004',
      title: 'Milestone-3 Structural & Civil Stage Invoice #INV-2026-9081',
      projectTitle: 'Greenwood Penthouse 901',
      clientName: 'Rajesh Gupta',
      clientPhone: '+91 94480 12345',
      category: BlueprintCategory.invoice,
      fileFormat: 'PDF',
      fileSizeBytes: 850 * 1024,
      version: 'v1.0',
      approvalStatus: DocApprovalStatus.approved,
      uploadedBy: 'Billing Department',
      uploadedAt: DateTime.now().subtract(const Duration(days: 1)),
      previewThumbnailUrl: null,
      whatsappShareCount: 3,
    ),
    BlueprintDocument(
      id: 'doc_005',
      title: 'Modular Kitchen Island & Blum Hardware Elevation Detail',
      projectTitle: 'Greenwood Penthouse 901',
      clientName: 'Rajesh Gupta',
      clientPhone: '+91 94480 12345',
      category: BlueprintCategory.cad2d,
      fileFormat: 'PDF',
      fileSizeBytes: 6 * 1024 * 1024,
      version: 'v1.3',
      approvalStatus: DocApprovalStatus.pendingReview,
      uploadedBy: 'Deepak Rao (Kitchen Designer)',
      uploadedAt: DateTime.now().subtract(const Duration(hours: 6)),
      previewThumbnailUrl: 'https://images.unsplash.com/photo-1556911220-e15b29be8c8f?auto=format&fit=crop&w=600&q=80',
      whatsappShareCount: 1,
    ),
    BlueprintDocument(
      id: 'doc_006',
      title: 'Italian Botticino Beige vs Carrara White Spec Sheet & Quarry Certificate',
      projectTitle: 'Villa #42 - Palm Meadows',
      clientName: 'Vikram Malhotra',
      clientPhone: '+91 98201 44521',
      category: BlueprintCategory.specSheet,
      fileFormat: 'PDF',
      fileSizeBytes: 4 * 1024 * 1024,
      version: 'v1.0',
      approvalStatus: DocApprovalStatus.approved,
      uploadedBy: 'Procurement Cell',
      uploadedAt: DateTime.now().subtract(const Duration(days: 3)),
      previewThumbnailUrl: null,
      whatsappShareCount: 5,
    ),
    BlueprintDocument(
      id: 'doc_007',
      title: 'Weekly Site Quality & Tolerance Audit Report #AUD-44',
      projectTitle: 'Prestige Lakeside #304',
      clientName: 'Sameer Joshi',
      clientPhone: '+91 98112 76543',
      category: BlueprintCategory.siteReport,
      fileFormat: 'PDF',
      fileSizeBytes: 5 * 1024 * 1024,
      version: 'v1.0',
      approvalStatus: DocApprovalStatus.revisionRequested,
      uploadedBy: 'Amit Verma (QA Lead)',
      uploadedAt: DateTime.now().subtract(const Duration(days: 1)),
      previewThumbnailUrl: null,
      whatsappShareCount: 1,
    ),
  ];
}
