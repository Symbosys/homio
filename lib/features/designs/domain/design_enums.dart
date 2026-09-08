import 'package:flutter/material.dart';

/// Design Deliverable Lifecycle Stage (PRD Section 15.1)
enum DesignStage {
  concept('Concept & Moodboard', Icons.lightbulb_outline_rounded, Color(0xFFEC4899)),
  twoDLayout('2D Working Drawings', Icons.architecture_rounded, Color(0xFF3B82F6)),
  threeDDesign('3D Models & Renders', Icons.view_in_ar_rounded, Color(0xFF8B5CF6)),
  materialSelection('Material & Finishes Selection', Icons.palette_rounded, Color(0xFF10B981)),
  boqSpecification('BOQ & Cost Estimation', Icons.inventory_2_rounded, Color(0xFFF59E0B)),
  clientReview('Client Review & Feedback', Icons.hourglass_top_rounded, Color(0xFF06B6D4)),
  finalApproval('Final Client Sign-off', Icons.verified_rounded, Color(0xFF059669)),
  executionHandover('Execution Handover', Icons.handshake_outlined, Color(0xFF2563EB));

  final String label;
  final IconData icon;
  final Color color;
  const DesignStage(this.label, this.icon, this.color);
}

/// Design Deliverable Category
enum DesignCategory {
  twoDCad('2D CAD Drawings', Icons.architecture_rounded, Color(0xFF3B82F6)),
  threeDRender('3D Photorealistic Renders', Icons.view_in_ar_rounded, Color(0xFF8B5CF6)),
  floorPlans('Floor Plans & Layouts', Icons.map_outlined, Color(0xFF0EA5E9)),
  threeDModels('3D Models (SketchUp/3ds)', Icons.layers_rounded, Color(0xFF6366F1)),
  moodboard('Mood Boards & Concepts', Icons.palette_rounded, Color(0xFFEC4899)),
  materialBoards('Material Boards & Samples', Icons.grid_view_rounded, Color(0xFF10B981)),
  boqSpecification('BOQ & Specifications', Icons.inventory_2_rounded, Color(0xFFF59E0B)),
  mepEngineering('MEP & Services Blueprints', Icons.plumbing_rounded, Color(0xFF14B8A6)),
  detailJoinery('Joinery & Carpentry Details', Icons.carpenter_rounded, Color(0xFF06B6D4)),
  workingDrawings('Working Drawings', Icons.design_services_rounded, Color(0xFF84CC16)),
  executionDrawings('Execution Drawings', Icons.construction_rounded, Color(0xFFEAB308)),
  referenceImages('Reference & Site Photos', Icons.photo_library_outlined, Color(0xFF64748B)),
  documents('Design Documents & Notes', Icons.description_outlined, Color(0xFF6B7280)),
  videos('Walkthrough Videos', Icons.videocam_outlined, Color(0xFFF43F5E)),
  other('General Assets', Icons.folder_open_outlined, Color(0xFF94A3B8));

  final String label;
  final IconData icon;
  final Color color;
  const DesignCategory(this.label, this.icon, this.color);
}

/// Lifecycle review status for design deliverables (PRD Section 15.1)
enum DesignReviewStatus {
  draft('Draft / In Progress', Color(0xFF64748B), Icons.edit_note_rounded),
  internalReview('Internal Review (Design Head)', Color(0xFF8B5CF6), Icons.rate_review_outlined),
  sentToClient('Sent to Client', Color(0xFF0EA5E9), Icons.send_rounded),
  submitted('Submitted', Color(0xFF0EA5E9), Icons.send_rounded),
  underClientReview('Under Client Review', Color(0xFFF59E0B), Icons.hourglass_top_rounded),
  revisionRequested('Revision Requested', Color(0xFFEF4444), Icons.published_with_changes_rounded),
  changesRequested('Changes Requested', Color(0xFFEF4444), Icons.published_with_changes_rounded),
  revised('Revised (New Version)', Color(0xFF3B82F6), Icons.autorenew_rounded),
  approved('Approved (Client Sign-off)', Color(0xFF10B981), Icons.check_circle_rounded),
  rejected('Rejected', Color(0xFFDC2626), Icons.cancel_outlined),
  sentToExecution('Sent to Execution', Color(0xFF059669), Icons.arrow_forward_rounded);

  final String label;
  final Color color;
  final IconData icon;
  const DesignReviewStatus(this.label, this.color, this.icon);

  bool get isApproved => this == DesignReviewStatus.approved || this == DesignReviewStatus.sentToExecution;
  bool get isPendingReview => this == DesignReviewStatus.internalReview || this == DesignReviewStatus.sentToClient || this == DesignReviewStatus.submitted || this == DesignReviewStatus.underClientReview;
  bool get isRevisionNeeded => this == DesignReviewStatus.revisionRequested || this == DesignReviewStatus.changesRequested;
}

/// CAD & Design File Types
enum DesignFileType {
  dwg('AutoCAD Drawing', '.dwg', Icons.architecture_rounded, Color(0xFFDC2626), false),
  dxf('AutoCAD Interchange', '.dxf', Icons.architecture_rounded, Color(0xFFDC2626), false),
  skp('SketchUp 3D Model', '.skp', Icons.view_in_ar_rounded, Color(0xFF2563EB), false),
  max('3ds Max Render Scene', '.max', Icons.apartment_rounded, Color(0xFF7C3AED), false),
  max3ds('3ds Max Render Scene', '.max', Icons.apartment_rounded, Color(0xFF7C3AED), false),
  threeDs('3D Studio File', '.3ds', Icons.view_in_ar_rounded, Color(0xFF7C3AED), false),
  rvt('Autodesk Revit BIM', '.rvt', Icons.layers_rounded, Color(0xFF0891B2), false),
  pdf('Architectural PDF', '.pdf', Icons.picture_as_pdf_rounded, Color(0xFFE11D48), true),
  jpg('Render Image (JPG)', '.jpg', Icons.image_rounded, Color(0xFF059669), true),
  jpeg('Render Image (JPEG)', '.jpeg', Icons.image_rounded, Color(0xFF059669), true),
  png('Render Image (PNG)', '.png', Icons.image_rounded, Color(0xFF059669), true),
  webp('Render Image (WEBP)', '.webp', Icons.image_rounded, Color(0xFF059669), true),
  mp4('Walkthrough Video (MP4)', '.mp4', Icons.movie_outlined, Color(0xFF9333EA), true),
  mov('QuickTime Video (MOV)', '.mov', Icons.movie_outlined, Color(0xFF9333EA), true),
  docx('Word Document', '.docx', Icons.description_rounded, Color(0xFF2563EB), false),
  xlsx('Excel Spreadsheet / BOQ', '.xlsx', Icons.table_view_rounded, Color(0xFF16A34A), false),
  zip('Archive Archive (ZIP)', '.zip', Icons.folder_zip_outlined, Color(0xFFEA580C), false);

  final String label;
  final String extension;
  final IconData icon;
  final Color color;
  final bool isBrowserPreviewable;
  const DesignFileType(this.label, this.extension, this.icon, this.color, this.isBrowserPreviewable);
}

/// File Visibility & Access Scoping (PRD Section 15.2)
enum FileVisibility {
  internalOnly('Internal Team Only', Icons.lock_outline_rounded, Color(0xFF64748B)),
  clientVisible('Client Visible', Icons.visibility_outlined, Color(0xFF3B82F6)),
  executionTeam('Execution Team Only', Icons.engineering_outlined, Color(0xFFF59E0B)),
  restricted('Restricted / Confidential', Icons.admin_panel_settings_outlined, Color(0xFFEF4444));

  final String label;
  final IconData icon;
  final Color color;
  const FileVisibility(this.label, this.icon, this.color);
}

/// Design Roles for RBAC
enum DesignRole {
  designHead('Design Head', Icons.shield_rounded),
  designProjectManager('Design ProjectManager', Icons.manage_accounts_rounded),
  seniorArchitect('Senior Project Architect', Icons.architecture_rounded),
  threeDArtist('3D Artist / Renderer', Icons.view_in_ar_rounded),
  juniorDesigner('Junior Designer / CAD', Icons.draw_outlined),
  siteMeasurementCoordinator('Site Measurement Coordinator', Icons.straighten_rounded),
  superAdmin('Super Admin', Icons.security_rounded);

  final String label;
  final IconData icon;
  const DesignRole(this.label, this.icon);
}

/// Cloud Drive Folder Hierarchy Type (PRD Section 15.2)
enum CloudFolderType {
  surveys('01_Project_Information', 'Project Brief, Surveys & Scope', Icons.folder_shared_outlined, Color(0xFF6366F1)),
  siteMeasurements('02_Site_Measurements', 'Laser Surveys & As-Built Dimensions', Icons.straighten_rounded, Color(0xFF0EA5E9)),
  floorPlans('03_Floor_Plans', 'Space Planning & Furniture Layouts', Icons.map_outlined, Color(0xFF3B82F6)),
  cadDrawings('04_2D_Drawings', '2D Layouts, Electrical & Plumbing', Icons.architecture_rounded, Color(0xFF2563EB)),
  models3D('05_3D_Models', 'SketchUp, 3ds Max & BIM Scenes', Icons.layers_rounded, Color(0xFF8B5CF6)),
  renders3D('06_3D_Renders', 'Photorealistic 4K Renders & Panoramas', Icons.view_in_ar_rounded, Color(0xFFEC4899)),
  moodboards('07_Mood_Boards', 'Design Concepts & Colour Palettes', Icons.palette_rounded, Color(0xFFF43F5E)),
  materialSelection('08_Material_Selection', 'Veneer, Fabric, Hardware & Specs', Icons.grid_view_rounded, Color(0xFF10B981)),
  boq('09_BOQ', 'Bill of Quantities & Cost Estimates', Icons.inventory_2_rounded, Color(0xFFF59E0B)),
  clientApprovals('10_Client_Approvals', 'Approved Submissions & Client Signoffs', Icons.verified_rounded, Color(0xFF059669)),
  revisions('11_Revisions', 'Archived Version Iterations & Markups', Icons.history_edu_outlined, Color(0xFFEF4444)),
  executionDrawings('12_Execution_Drawings', 'Working Cutlists & Site Good-for-Construction', Icons.construction_rounded, Color(0xFFD97706)),
  handover('13_Handover', 'Final Handover Dossier to Site PM', Icons.handshake_outlined, Color(0xFF0D9488)),
  clientSubmissions('14_Client_Submissions', 'Direct Client Portal Submissions', Icons.send_rounded, Color(0xFF0284C7)),
  boqSpecs('09_BOQ', 'Bill of Quantities & Specifications', Icons.inventory_2_rounded, Color(0xFFF59E0B)),
  siteMedia('02_Site_Measurements', 'Site Photos & Video Documentation', Icons.photo_library_rounded, Color(0xFF0EA5E9)),
  contractsSignoffs('10_Client_Approvals', 'Client Contracts & Signoffs', Icons.verified_rounded, Color(0xFF059669));

  final String folderCode;
  final String description;
  final IconData icon;
  final Color color;
  const CloudFolderType(this.folderCode, this.description, this.icon, this.color);

  String get label => description;
}

/// Revision Workflow Status (PRD Section 15.1)
enum RevisionStatus {
  requested('Revision Requested', Color(0xFFEF4444), Icons.published_with_changes_rounded),
  assigned('Designer Assigned', Color(0xFFF59E0B), Icons.person_outline_rounded),
  inProgress('Changes In Progress', Color(0xFF3B82F6), Icons.autorenew_rounded),
  submitted('Revised & Submitted', Color(0xFF0EA5E9), Icons.send_rounded),
  underInternalReview('Under Internal Review', Color(0xFF8B5CF6), Icons.rate_review_outlined),
  sentToClient('Sent to Client', Color(0xFF06B6D4), Icons.hourglass_top_rounded),
  resolved('Resolved & Implemented', Color(0xFF10B981), Icons.check_circle_rounded),
  approved('Approved by Client', Color(0xFF10B981), Icons.check_circle_rounded),
  rejected('Rejected', Color(0xFFDC2626), Icons.cancel_outlined),
  closed('Closed', Color(0xFF64748B), Icons.done_all_rounded);

  final String label;
  final Color color;
  final IconData icon;
  const RevisionStatus(this.label, this.color, this.icon);
}

/// Execution Handover Status (PRD Section 15.3)
enum HandoverStatus {
  draft('Draft Handover', Color(0xFF64748B), Icons.edit_note_rounded),
  readyForHandover('Ready for Handover', Color(0xFF0EA5E9), Icons.pending_actions_rounded),
  pendingReview('Pending Execution Review', Color(0xFFF59E0B), Icons.hourglass_bottom_rounded),
  partiallyHandedOver('Partially Handed Over', Color(0xFF8B5CF6), Icons.pie_chart_outline_rounded),
  accepted('Accepted by Execution PM', Color(0xFF10B981), Icons.verified_rounded),
  changesRequested('Changes Requested by Site', Color(0xFFEF4444), Icons.feedback_outlined),
  rejected('Rejected', Color(0xFFDC2626), Icons.cancel_outlined),
  completed('Handover Completed', Color(0xFF059669), Icons.check_circle_rounded);

  final String label;
  final Color color;
  final IconData icon;
  const HandoverStatus(this.label, this.color, this.icon);
}

/// Visual Annotation Type on Previews
enum AnnotationType {
  pin('Pin Comment', Icons.push_pin_rounded, Color(0xFFEF4444)),
  comment('Comment Box', Icons.chat_bubble_outline_rounded, Color(0xFF3B82F6)),
  rectangle('Area Highlight', Icons.crop_square_rounded, Color(0xFFF59E0B)),
  arrow('Pointing Arrow', Icons.arrow_outward_rounded, Color(0xFF8B5CF6)),
  freehand('Freehand Markup', Icons.draw_outlined, Color(0xFFEC4899)),
  highlight('Color Highlight', Icons.brush_outlined, Color(0xFF10B981));

  final String label;
  final IconData icon;
  final Color color;
  const AnnotationType(this.label, this.icon, this.color);
}

/// Design Priority
enum DesignPriority {
  low('Low', Color(0xFF64748B), Icons.arrow_downward_rounded),
  medium('Medium', Color(0xFF0EA5E9), Icons.drag_handle_rounded),
  high('High', Color(0xFFF59E0B), Icons.arrow_upward_rounded),
  urgent('Urgent', Color(0xFFEF4444), Icons.priority_high_rounded);

  final String label;
  final Color color;
  final IconData icon;
  const DesignPriority(this.label, this.color, this.icon);
}

/// View Mode Toggle
enum DesignViewMode {
  grid('Grid View', Icons.grid_view_rounded),
  list('List View', Icons.view_list_rounded),
  table('Table View', Icons.table_chart_outlined);

  final String label;
  final IconData icon;
  const DesignViewMode(this.label, this.icon);
}
