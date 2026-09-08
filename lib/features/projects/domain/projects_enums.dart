import 'package:flutter/material.dart';

// =============================================================================
// PROJECT TYPE — Configurable project workflow categories
// =============================================================================
enum ProjectType {
  consulting,
  turnkey,
  formBased,
}

extension ProjectTypeExt on ProjectType {
  String get label {
    switch (this) {
      case ProjectType.consulting:
        return 'Consulting';
      case ProjectType.turnkey:
        return 'Turnkey';
      case ProjectType.formBased:
        return 'Simple / Form Based';
    }
  }

  String get displayName => label;

  IconData get icon {
    switch (this) {
      case ProjectType.consulting:
        return Icons.design_services_outlined;
      case ProjectType.turnkey:
        return Icons.villa_outlined;
      case ProjectType.formBased:
        return Icons.description_outlined;
    }
  }

  Color get color {
    switch (this) {
      case ProjectType.consulting:
        return const Color(0xFF8B5CF6);
      case ProjectType.turnkey:
        return const Color(0xFF3B82F6);
      case ProjectType.formBased:
        return const Color(0xFF10B981);
    }
  }
}

// =============================================================================
// PROJECT STATUS — Professional lifecycle states
// =============================================================================
enum ProjectStatus {
  draft,
  planned,
  design,
  approvalPending,
  execution,
  onHold,
  delayed,
  completed,
  handover,
  closed,
  cancelled,
}

extension ProjectStatusExt on ProjectStatus {
  String get label {
    switch (this) {
      case ProjectStatus.draft:
        return 'Draft';
      case ProjectStatus.planned:
        return 'Planned';
      case ProjectStatus.design:
        return 'Design';
      case ProjectStatus.approvalPending:
        return 'Approval Pending';
      case ProjectStatus.execution:
        return 'Execution';
      case ProjectStatus.onHold:
        return 'On Hold';
      case ProjectStatus.delayed:
        return 'Delayed';
      case ProjectStatus.completed:
        return 'Completed';
      case ProjectStatus.handover:
        return 'Handover';
      case ProjectStatus.closed:
        return 'Closed';
      case ProjectStatus.cancelled:
        return 'Cancelled';
    }
  }

  String get displayName => label;

  Color get color {
    switch (this) {
      case ProjectStatus.draft:
        return const Color(0xFF94A3B8);
      case ProjectStatus.planned:
        return const Color(0xFF64748B);
      case ProjectStatus.design:
        return const Color(0xFF8B5CF6);
      case ProjectStatus.approvalPending:
        return const Color(0xFFF59E0B);
      case ProjectStatus.execution:
        return const Color(0xFF3B82F6);
      case ProjectStatus.onHold:
        return const Color(0xFFEA580C);
      case ProjectStatus.delayed:
        return const Color(0xFFEF4444);
      case ProjectStatus.completed:
        return const Color(0xFF10B981);
      case ProjectStatus.handover:
        return const Color(0xFF0EA5E9);
      case ProjectStatus.closed:
        return const Color(0xFF6B7280);
      case ProjectStatus.cancelled:
        return const Color(0xFF991B1B);
    }
  }

  IconData get icon {
    switch (this) {
      case ProjectStatus.draft:
        return Icons.edit_note_outlined;
      case ProjectStatus.planned:
        return Icons.event_note_outlined;
      case ProjectStatus.design:
        return Icons.design_services_outlined;
      case ProjectStatus.approvalPending:
        return Icons.pending_actions_outlined;
      case ProjectStatus.execution:
        return Icons.engineering_outlined;
      case ProjectStatus.onHold:
        return Icons.pause_circle_outline;
      case ProjectStatus.delayed:
        return Icons.warning_amber_outlined;
      case ProjectStatus.completed:
        return Icons.check_circle_outline;
      case ProjectStatus.handover:
        return Icons.handshake_outlined;
      case ProjectStatus.closed:
        return Icons.lock_outline;
      case ProjectStatus.cancelled:
        return Icons.cancel_outlined;
    }
  }

  bool get isActive =>
      this == ProjectStatus.design ||
      this == ProjectStatus.approvalPending ||
      this == ProjectStatus.execution;
}

// =============================================================================
// PROJECT HEALTH — Composite health indicator
// =============================================================================
enum ProjectHealth {
  healthy,
  atRisk,
  delayed,
  critical,
  completed,
}

extension ProjectHealthExt on ProjectHealth {
  String get label {
    switch (this) {
      case ProjectHealth.healthy:
        return 'Healthy';
      case ProjectHealth.atRisk:
        return 'At Risk';
      case ProjectHealth.delayed:
        return 'Delayed';
      case ProjectHealth.critical:
        return 'Critical';
      case ProjectHealth.completed:
        return 'Completed';
    }
  }

  String get displayName => label;

  Color get color {
    switch (this) {
      case ProjectHealth.healthy:
        return const Color(0xFF10B981);
      case ProjectHealth.atRisk:
        return const Color(0xFFF59E0B);
      case ProjectHealth.delayed:
        return const Color(0xFFEF4444);
      case ProjectHealth.critical:
        return const Color(0xFF991B1B);
      case ProjectHealth.completed:
        return const Color(0xFF8B5CF6);
    }
  }

  IconData get icon {
    switch (this) {
      case ProjectHealth.healthy:
        return Icons.check_circle_rounded;
      case ProjectHealth.atRisk:
        return Icons.warning_amber_rounded;
      case ProjectHealth.delayed:
        return Icons.error_outline_rounded;
      case ProjectHealth.critical:
        return Icons.dangerous_rounded;
      case ProjectHealth.completed:
        return Icons.verified_rounded;
    }
  }

  String get accessibleLabel {
    switch (this) {
      case ProjectHealth.healthy:
        return '✓ Healthy';
      case ProjectHealth.atRisk:
        return '⚠ At Risk';
      case ProjectHealth.delayed:
        return '! Delayed';
      case ProjectHealth.critical:
        return '✕ Critical';
      case ProjectHealth.completed:
        return '✓ Completed';
    }
  }
}

// =============================================================================
// PROJECT STAGE — Visual stage tracker steps
// =============================================================================
enum ProjectStage {
  planning,
  design,
  approval,
  execution,
  procurement,
  handover,
  afterSales,
}

extension ProjectStageExt on ProjectStage {
  String get label {
    switch (this) {
      case ProjectStage.planning:
        return 'Planning';
      case ProjectStage.design:
        return 'Design';
      case ProjectStage.approval:
        return 'Approval';
      case ProjectStage.execution:
        return 'Execution';
      case ProjectStage.procurement:
        return 'Procurement';
      case ProjectStage.handover:
        return 'Handover';
      case ProjectStage.afterSales:
        return 'After-Sales';
    }
  }

  String get displayName => label;

  IconData get icon {
    switch (this) {
      case ProjectStage.planning:
        return Icons.event_note_outlined;
      case ProjectStage.design:
        return Icons.design_services_outlined;
      case ProjectStage.approval:
        return Icons.fact_check_outlined;
      case ProjectStage.execution:
        return Icons.engineering_outlined;
      case ProjectStage.procurement:
        return Icons.local_shipping_outlined;
      case ProjectStage.handover:
        return Icons.handshake_outlined;
      case ProjectStage.afterSales:
        return Icons.support_agent_outlined;
    }
  }

  Color get color {
    switch (this) {
      case ProjectStage.planning:
        return const Color(0xFF64748B);
      case ProjectStage.design:
        return const Color(0xFF8B5CF6);
      case ProjectStage.approval:
        return const Color(0xFFF59E0B);
      case ProjectStage.execution:
        return const Color(0xFF3B82F6);
      case ProjectStage.procurement:
        return const Color(0xFF0EA5E9);
      case ProjectStage.handover:
        return const Color(0xFF10B981);
      case ProjectStage.afterSales:
        return const Color(0xFF06B6D4);
    }
  }
}

// =============================================================================
// MILESTONE STATUS
// =============================================================================
enum MilestoneStatus {
  notStarted,
  inProgress,
  pendingApproval,
  completed,
  delayed,
  blocked,
  cancelled,
}

extension MilestoneStatusExt on MilestoneStatus {
  String get label {
    switch (this) {
      case MilestoneStatus.notStarted:
        return 'Not Started';
      case MilestoneStatus.inProgress:
        return 'In Progress';
      case MilestoneStatus.pendingApproval:
        return 'Pending Approval';
      case MilestoneStatus.completed:
        return 'Completed';
      case MilestoneStatus.delayed:
        return 'Delayed';
      case MilestoneStatus.blocked:
        return 'Blocked';
      case MilestoneStatus.cancelled:
        return 'Cancelled';
    }
  }

  String get displayName => label;

  Color get color {
    switch (this) {
      case MilestoneStatus.notStarted:
        return const Color(0xFF94A3B8);
      case MilestoneStatus.inProgress:
        return const Color(0xFF3B82F6);
      case MilestoneStatus.pendingApproval:
        return const Color(0xFFF59E0B);
      case MilestoneStatus.completed:
        return const Color(0xFF10B981);
      case MilestoneStatus.delayed:
        return const Color(0xFFEF4444);
      case MilestoneStatus.blocked:
        return const Color(0xFFEA580C);
      case MilestoneStatus.cancelled:
        return const Color(0xFF6B7280);
    }
  }

  IconData get icon {
    switch (this) {
      case MilestoneStatus.notStarted:
        return Icons.radio_button_unchecked;
      case MilestoneStatus.inProgress:
        return Icons.timelapse_rounded;
      case MilestoneStatus.pendingApproval:
        return Icons.pending_actions_outlined;
      case MilestoneStatus.completed:
        return Icons.check_circle_rounded;
      case MilestoneStatus.delayed:
        return Icons.warning_amber_rounded;
      case MilestoneStatus.blocked:
        return Icons.block_rounded;
      case MilestoneStatus.cancelled:
        return Icons.cancel_outlined;
    }
  }
}

// =============================================================================
// PROJECT TASK STATUS
// =============================================================================
enum ProjectTaskStatus {
  toDo,
  inProgress,
  waiting,
  blocked,
  completed,
  cancelled,
}

extension ProjectTaskStatusExt on ProjectTaskStatus {
  String get label {
    switch (this) {
      case ProjectTaskStatus.toDo:
        return 'To Do';
      case ProjectTaskStatus.inProgress:
        return 'In Progress';
      case ProjectTaskStatus.waiting:
        return 'Waiting';
      case ProjectTaskStatus.blocked:
        return 'Blocked';
      case ProjectTaskStatus.completed:
        return 'Completed';
      case ProjectTaskStatus.cancelled:
        return 'Cancelled';
    }
  }

  String get displayName => label;

  Color get color {
    switch (this) {
      case ProjectTaskStatus.toDo:
        return const Color(0xFF64748B);
      case ProjectTaskStatus.inProgress:
        return const Color(0xFF3B82F6);
      case ProjectTaskStatus.waiting:
        return const Color(0xFFF59E0B);
      case ProjectTaskStatus.blocked:
        return const Color(0xFFEF4444);
      case ProjectTaskStatus.completed:
        return const Color(0xFF10B981);
      case ProjectTaskStatus.cancelled:
        return const Color(0xFF6B7280);
    }
  }

  IconData get icon {
    switch (this) {
      case ProjectTaskStatus.toDo:
        return Icons.radio_button_unchecked_rounded;
      case ProjectTaskStatus.inProgress:
        return Icons.timelapse_rounded;
      case ProjectTaskStatus.waiting:
        return Icons.hourglass_top_rounded;
      case ProjectTaskStatus.blocked:
        return Icons.block_rounded;
      case ProjectTaskStatus.completed:
        return Icons.check_circle_rounded;
      case ProjectTaskStatus.cancelled:
        return Icons.cancel_outlined;
    }
  }
}

// =============================================================================
// PROJECT TASK PRIORITY
// =============================================================================
enum ProjectTaskPriority {
  low,
  medium,
  high,
  urgent,
}

extension ProjectTaskPriorityExt on ProjectTaskPriority {
  String get label {
    switch (this) {
      case ProjectTaskPriority.low:
        return 'Low';
      case ProjectTaskPriority.medium:
        return 'Medium';
      case ProjectTaskPriority.high:
        return 'High';
      case ProjectTaskPriority.urgent:
        return 'Urgent';
    }
  }

  String get displayName => label;

  Color get color {
    switch (this) {
      case ProjectTaskPriority.low:
        return const Color(0xFF64748B);
      case ProjectTaskPriority.medium:
        return const Color(0xFF3B82F6);
      case ProjectTaskPriority.high:
        return const Color(0xFFF59E0B);
      case ProjectTaskPriority.urgent:
        return const Color(0xFFEF4444);
    }
  }

  IconData get icon {
    switch (this) {
      case ProjectTaskPriority.low:
        return Icons.arrow_downward_rounded;
      case ProjectTaskPriority.medium:
        return Icons.remove_rounded;
      case ProjectTaskPriority.high:
        return Icons.arrow_upward_rounded;
      case ProjectTaskPriority.urgent:
        return Icons.priority_high_rounded;
    }
  }
}

// =============================================================================
// SITE VISIT TYPE
// =============================================================================
enum SiteVisitType {
  measurement,
  design,
  execution,
  inspection,
  supervisor,
  client,
  materialInspection,
  finalInspection,
}

extension SiteVisitTypeExt on SiteVisitType {
  String get label {
    switch (this) {
      case SiteVisitType.measurement:
        return 'Measurement Visit';
      case SiteVisitType.design:
        return 'Design Visit';
      case SiteVisitType.execution:
        return 'Execution Visit';
      case SiteVisitType.inspection:
        return 'Inspection';
      case SiteVisitType.supervisor:
        return 'Supervisor Visit';
      case SiteVisitType.client:
        return 'Client Visit';
      case SiteVisitType.materialInspection:
        return 'Material Inspection';
      case SiteVisitType.finalInspection:
        return 'Final Inspection';
    }
  }

  String get displayName => label;

  IconData get icon {
    switch (this) {
      case SiteVisitType.measurement:
        return Icons.straighten_outlined;
      case SiteVisitType.design:
        return Icons.design_services_outlined;
      case SiteVisitType.execution:
        return Icons.engineering_outlined;
      case SiteVisitType.inspection:
        return Icons.fact_check_outlined;
      case SiteVisitType.supervisor:
        return Icons.badge_outlined;
      case SiteVisitType.client:
        return Icons.person_outlined;
      case SiteVisitType.materialInspection:
        return Icons.inventory_2_outlined;
      case SiteVisitType.finalInspection:
        return Icons.verified_outlined;
    }
  }

  Color get color {
    switch (this) {
      case SiteVisitType.measurement:
        return const Color(0xFF3B82F6);
      case SiteVisitType.design:
        return const Color(0xFF8B5CF6);
      case SiteVisitType.execution:
        return const Color(0xFF10B981);
      case SiteVisitType.inspection:
        return const Color(0xFFF59E0B);
      case SiteVisitType.supervisor:
        return const Color(0xFF0EA5E9);
      case SiteVisitType.client:
        return const Color(0xFFEC4899);
      case SiteVisitType.materialInspection:
        return const Color(0xFFEA580C);
      case SiteVisitType.finalInspection:
        return const Color(0xFF059669);
    }
  }
}

// =============================================================================
// SITE VISIT OUTCOME
// =============================================================================
enum SiteVisitOutcome {
  completed,
  pending,
  issuesFound,
  followUpRequired,
}

extension SiteVisitOutcomeExt on SiteVisitOutcome {
  String get label {
    switch (this) {
      case SiteVisitOutcome.completed:
        return 'Completed';
      case SiteVisitOutcome.pending:
        return 'Pending';
      case SiteVisitOutcome.issuesFound:
        return 'Issues Found';
      case SiteVisitOutcome.followUpRequired:
        return 'Follow-up Required';
    }
  }

  String get displayName => label;

  Color get color {
    switch (this) {
      case SiteVisitOutcome.completed:
        return const Color(0xFF10B981);
      case SiteVisitOutcome.pending:
        return const Color(0xFF64748B);
      case SiteVisitOutcome.issuesFound:
        return const Color(0xFFEF4444);
      case SiteVisitOutcome.followUpRequired:
        return const Color(0xFFF59E0B);
    }
  }
}

// =============================================================================
// APPROVAL TYPE
// =============================================================================
enum ApprovalType {
  design,
  material,
  executionStage,
  workCompletion,
  payment,
  finalHandover,
}

extension ApprovalTypeExt on ApprovalType {
  String get label {
    switch (this) {
      case ApprovalType.design:
        return 'Design Approval';
      case ApprovalType.material:
        return 'Material Approval';
      case ApprovalType.executionStage:
        return 'Execution Stage Approval';
      case ApprovalType.workCompletion:
        return 'Work Completion Approval';
      case ApprovalType.payment:
        return 'Payment Approval';
      case ApprovalType.finalHandover:
        return 'Final Handover Approval';
    }
  }

  String get displayName => label;

  IconData get icon {
    switch (this) {
      case ApprovalType.design:
        return Icons.design_services_outlined;
      case ApprovalType.material:
        return Icons.inventory_2_outlined;
      case ApprovalType.executionStage:
        return Icons.engineering_outlined;
      case ApprovalType.workCompletion:
        return Icons.task_alt_outlined;
      case ApprovalType.payment:
        return Icons.payments_outlined;
      case ApprovalType.finalHandover:
        return Icons.handshake_outlined;
    }
  }

  Color get color {
    switch (this) {
      case ApprovalType.design:
        return const Color(0xFF8B5CF6);
      case ApprovalType.material:
        return const Color(0xFFEA580C);
      case ApprovalType.executionStage:
        return const Color(0xFF3B82F6);
      case ApprovalType.workCompletion:
        return const Color(0xFF10B981);
      case ApprovalType.payment:
        return const Color(0xFFEC4899);
      case ApprovalType.finalHandover:
        return const Color(0xFF0EA5E9);
    }
  }
}

// =============================================================================
// APPROVAL STATUS
// =============================================================================
enum ApprovalStatus {
  pending,
  approved,
  rejected,
  revisionRequested,
  resubmitted,
}

extension ApprovalStatusExt on ApprovalStatus {
  String get label {
    switch (this) {
      case ApprovalStatus.pending:
        return 'Pending';
      case ApprovalStatus.approved:
        return 'Approved';
      case ApprovalStatus.rejected:
        return 'Rejected';
      case ApprovalStatus.revisionRequested:
        return 'Revision Requested';
      case ApprovalStatus.resubmitted:
        return 'Resubmitted';
    }
  }

  String get displayName => label;

  Color get color {
    switch (this) {
      case ApprovalStatus.pending:
        return const Color(0xFFF59E0B);
      case ApprovalStatus.approved:
        return const Color(0xFF10B981);
      case ApprovalStatus.rejected:
        return const Color(0xFFEF4444);
      case ApprovalStatus.revisionRequested:
        return const Color(0xFFEA580C);
      case ApprovalStatus.resubmitted:
        return const Color(0xFF3B82F6);
    }
  }

  IconData get icon {
    switch (this) {
      case ApprovalStatus.pending:
        return Icons.hourglass_top_rounded;
      case ApprovalStatus.approved:
        return Icons.check_circle_rounded;
      case ApprovalStatus.rejected:
        return Icons.cancel_rounded;
      case ApprovalStatus.revisionRequested:
        return Icons.rate_review_rounded;
      case ApprovalStatus.resubmitted:
        return Icons.replay_rounded;
    }
  }
}

// =============================================================================
// COMPLAINT TYPE
// =============================================================================
enum ComplaintType {
  design,
  quality,
  material,
  execution,
  timeline,
  behaviour,
  payment,
  communication,
  warranty,
  other,
}

extension ComplaintTypeExt on ComplaintType {
  String get label {
    switch (this) {
      case ComplaintType.design:
        return 'Design';
      case ComplaintType.quality:
        return 'Quality';
      case ComplaintType.material:
        return 'Material';
      case ComplaintType.execution:
        return 'Execution';
      case ComplaintType.timeline:
        return 'Timeline';
      case ComplaintType.behaviour:
        return 'Behaviour';
      case ComplaintType.payment:
        return 'Payment';
      case ComplaintType.communication:
        return 'Communication';
      case ComplaintType.warranty:
        return 'Warranty';
      case ComplaintType.other:
        return 'Other';
    }
  }

  String get displayName => label;

  IconData get icon {
    switch (this) {
      case ComplaintType.design:
        return Icons.design_services_outlined;
      case ComplaintType.quality:
        return Icons.high_quality_outlined;
      case ComplaintType.material:
        return Icons.inventory_2_outlined;
      case ComplaintType.execution:
        return Icons.engineering_outlined;
      case ComplaintType.timeline:
        return Icons.schedule_outlined;
      case ComplaintType.behaviour:
        return Icons.sentiment_dissatisfied_outlined;
      case ComplaintType.payment:
        return Icons.payments_outlined;
      case ComplaintType.communication:
        return Icons.forum_outlined;
      case ComplaintType.warranty:
        return Icons.security_outlined;
      case ComplaintType.other:
        return Icons.more_horiz_outlined;
    }
  }

  Color get color {
    switch (this) {
      case ComplaintType.design:
        return const Color(0xFF8B5CF6);
      case ComplaintType.quality:
        return const Color(0xFFEF4444);
      case ComplaintType.material:
        return const Color(0xFFEA580C);
      case ComplaintType.execution:
        return const Color(0xFF3B82F6);
      case ComplaintType.timeline:
        return const Color(0xFFF59E0B);
      case ComplaintType.behaviour:
        return const Color(0xFFEC4899);
      case ComplaintType.payment:
        return const Color(0xFF10B981);
      case ComplaintType.communication:
        return const Color(0xFF0EA5E9);
      case ComplaintType.warranty:
        return const Color(0xFF6366F1);
      case ComplaintType.other:
        return const Color(0xFF64748B);
    }
  }
}

// =============================================================================
// COMPLAINT STATUS
// =============================================================================
enum ComplaintStatus {
  open,
  acknowledged,
  assigned,
  inProgress,
  waiting,
  resolved,
  closed,
  rejected,
}

extension ComplaintStatusExt on ComplaintStatus {
  String get label {
    switch (this) {
      case ComplaintStatus.open:
        return 'Open';
      case ComplaintStatus.acknowledged:
        return 'Acknowledged';
      case ComplaintStatus.assigned:
        return 'Assigned';
      case ComplaintStatus.inProgress:
        return 'In Progress';
      case ComplaintStatus.waiting:
        return 'Waiting';
      case ComplaintStatus.resolved:
        return 'Resolved';
      case ComplaintStatus.closed:
        return 'Closed';
      case ComplaintStatus.rejected:
        return 'Rejected';
    }
  }

  String get displayName => label;

  Color get color {
    switch (this) {
      case ComplaintStatus.open:
        return const Color(0xFFEF4444);
      case ComplaintStatus.acknowledged:
        return const Color(0xFFF59E0B);
      case ComplaintStatus.assigned:
        return const Color(0xFF3B82F6);
      case ComplaintStatus.inProgress:
        return const Color(0xFF0EA5E9);
      case ComplaintStatus.waiting:
        return const Color(0xFFEA580C);
      case ComplaintStatus.resolved:
        return const Color(0xFF10B981);
      case ComplaintStatus.closed:
        return const Color(0xFF6B7280);
      case ComplaintStatus.rejected:
        return const Color(0xFF991B1B);
    }
  }

  IconData get icon {
    switch (this) {
      case ComplaintStatus.open:
        return Icons.error_outline_rounded;
      case ComplaintStatus.acknowledged:
        return Icons.visibility_outlined;
      case ComplaintStatus.assigned:
        return Icons.person_add_outlined;
      case ComplaintStatus.inProgress:
        return Icons.timelapse_rounded;
      case ComplaintStatus.waiting:
        return Icons.hourglass_top_rounded;
      case ComplaintStatus.resolved:
        return Icons.check_circle_outline;
      case ComplaintStatus.closed:
        return Icons.lock_outline;
      case ComplaintStatus.rejected:
        return Icons.cancel_outlined;
    }
  }
}

// =============================================================================
// COMPLAINT PRIORITY
// =============================================================================
enum ComplaintPriority {
  low,
  medium,
  high,
  critical,
}

extension ComplaintPriorityExt on ComplaintPriority {
  String get label {
    switch (this) {
      case ComplaintPriority.low:
        return 'Low';
      case ComplaintPriority.medium:
        return 'Medium';
      case ComplaintPriority.high:
        return 'High';
      case ComplaintPriority.critical:
        return 'Critical';
    }
  }

  String get displayName => label;

  Color get color {
    switch (this) {
      case ComplaintPriority.low:
        return const Color(0xFF64748B);
      case ComplaintPriority.medium:
        return const Color(0xFF3B82F6);
      case ComplaintPriority.high:
        return const Color(0xFFF59E0B);
      case ComplaintPriority.critical:
        return const Color(0xFFEF4444);
    }
  }
}

// =============================================================================
// PAYMENT STATUS
// =============================================================================
enum PaymentStatus {
  paid,
  partiallyPaid,
  unpaid,
  overdue,
}

extension PaymentStatusExt on PaymentStatus {
  String get label {
    switch (this) {
      case PaymentStatus.paid:
        return 'Paid';
      case PaymentStatus.partiallyPaid:
        return 'Partially Paid';
      case PaymentStatus.unpaid:
        return 'Unpaid';
      case PaymentStatus.overdue:
        return 'Overdue';
    }
  }

  String get displayName => label;

  Color get color {
    switch (this) {
      case PaymentStatus.paid:
        return const Color(0xFF10B981);
      case PaymentStatus.partiallyPaid:
        return const Color(0xFFF59E0B);
      case PaymentStatus.unpaid:
        return const Color(0xFF64748B);
      case PaymentStatus.overdue:
        return const Color(0xFFEF4444);
    }
  }

  IconData get icon {
    switch (this) {
      case PaymentStatus.paid:
        return Icons.check_circle_rounded;
      case PaymentStatus.partiallyPaid:
        return Icons.timelapse_rounded;
      case PaymentStatus.unpaid:
        return Icons.radio_button_unchecked;
      case PaymentStatus.overdue:
        return Icons.warning_amber_rounded;
    }
  }
}

// =============================================================================
// FILE VISIBILITY
// =============================================================================
enum FileVisibility {
  internal,
  clientVisible,
  restricted,
}

extension FileVisibilityExt on FileVisibility {
  String get label {
    switch (this) {
      case FileVisibility.internal:
        return 'Internal';
      case FileVisibility.clientVisible:
        return 'Client Visible';
      case FileVisibility.restricted:
        return 'Restricted';
    }
  }

  String get displayName => label;

  Color get color {
    switch (this) {
      case FileVisibility.internal:
        return const Color(0xFF64748B);
      case FileVisibility.clientVisible:
        return const Color(0xFF10B981);
      case FileVisibility.restricted:
        return const Color(0xFFEF4444);
    }
  }

  IconData get icon {
    switch (this) {
      case FileVisibility.internal:
        return Icons.lock_outline;
      case FileVisibility.clientVisible:
        return Icons.visibility_outlined;
      case FileVisibility.restricted:
        return Icons.shield_outlined;
    }
  }
}

// =============================================================================
// COMMERCIAL RECORD TYPE
// =============================================================================
enum CommercialRecordType {
  material,
  labour,
  supervisionFee,
  consultingFee,
  designFee,
  otherFee,
}

extension CommercialRecordTypeExt on CommercialRecordType {
  String get label {
    switch (this) {
      case CommercialRecordType.material:
        return 'Material';
      case CommercialRecordType.labour:
        return 'Labour';
      case CommercialRecordType.supervisionFee:
        return 'Supervision Fee';
      case CommercialRecordType.consultingFee:
        return 'Consulting Fee';
      case CommercialRecordType.designFee:
        return 'Design Fee';
      case CommercialRecordType.otherFee:
        return 'Other Fee';
    }
  }

  String get displayName => label;

  IconData get icon {
    switch (this) {
      case CommercialRecordType.material:
        return Icons.inventory_2_outlined;
      case CommercialRecordType.labour:
        return Icons.handyman_outlined;
      case CommercialRecordType.supervisionFee:
        return Icons.badge_outlined;
      case CommercialRecordType.consultingFee:
        return Icons.design_services_outlined;
      case CommercialRecordType.designFee:
        return Icons.architecture_outlined;
      case CommercialRecordType.otherFee:
        return Icons.receipt_long_outlined;
    }
  }

  Color get color {
    switch (this) {
      case CommercialRecordType.material:
        return const Color(0xFF3B82F6);
      case CommercialRecordType.labour:
        return const Color(0xFFF59E0B);
      case CommercialRecordType.supervisionFee:
        return const Color(0xFF8B5CF6);
      case CommercialRecordType.consultingFee:
        return const Color(0xFF10B981);
      case CommercialRecordType.designFee:
        return const Color(0xFFEC4899);
      case CommercialRecordType.otherFee:
        return const Color(0xFF64748B);
    }
  }

  bool get isFee =>
      this == CommercialRecordType.supervisionFee ||
      this == CommercialRecordType.consultingFee ||
      this == CommercialRecordType.designFee ||
      this == CommercialRecordType.otherFee;
}

// =============================================================================
// SITE PROGRESS APPROVAL STATUS
// =============================================================================
enum SiteProgressApprovalStatus {
  draft,
  submitted,
  supervisorVerified,
  clientVisible,
  rejected,
}

extension SiteProgressApprovalStatusExt on SiteProgressApprovalStatus {
  String get label {
    switch (this) {
      case SiteProgressApprovalStatus.draft:
        return 'Draft';
      case SiteProgressApprovalStatus.submitted:
        return 'Submitted';
      case SiteProgressApprovalStatus.supervisorVerified:
        return 'Supervisor Verified';
      case SiteProgressApprovalStatus.clientVisible:
        return 'Client Visible';
      case SiteProgressApprovalStatus.rejected:
        return 'Rejected';
    }
  }

  String get displayName => label;

  Color get color {
    switch (this) {
      case SiteProgressApprovalStatus.draft:
        return const Color(0xFF94A3B8);
      case SiteProgressApprovalStatus.submitted:
        return const Color(0xFF3B82F6);
      case SiteProgressApprovalStatus.supervisorVerified:
        return const Color(0xFF10B981);
      case SiteProgressApprovalStatus.clientVisible:
        return const Color(0xFF8B5CF6);
      case SiteProgressApprovalStatus.rejected:
        return const Color(0xFFEF4444);
    }
  }
}

// =============================================================================
// PROJECT VIEW MODE
// =============================================================================
enum ProjectViewMode {
  table,
  cards,
  kanban,
}

extension ProjectViewModeExt on ProjectViewMode {
  String get label {
    switch (this) {
      case ProjectViewMode.table:
        return 'Table';
      case ProjectViewMode.cards:
        return 'Cards';
      case ProjectViewMode.kanban:
        return 'Kanban';
    }
  }

  IconData get icon {
    switch (this) {
      case ProjectViewMode.table:
        return Icons.table_rows_outlined;
      case ProjectViewMode.cards:
        return Icons.grid_view_outlined;
      case ProjectViewMode.kanban:
        return Icons.view_kanban_outlined;
    }
  }
}

// =============================================================================
// TASK VIEW MODE
// =============================================================================
enum TaskViewMode {
  list,
  kanban,
  calendar,
  gantt,
  table,
}

extension TaskViewModeExt on TaskViewMode {
  String get label {
    switch (this) {
      case TaskViewMode.list:
        return 'List';
      case TaskViewMode.kanban:
        return 'Kanban';
      case TaskViewMode.calendar:
        return 'Calendar';
      case TaskViewMode.gantt:
        return 'Gantt';
      case TaskViewMode.table:
        return 'Table';
    }
  }

  IconData get icon {
    switch (this) {
      case TaskViewMode.list:
        return Icons.list_outlined;
      case TaskViewMode.kanban:
        return Icons.view_kanban_outlined;
      case TaskViewMode.calendar:
        return Icons.calendar_month_outlined;
      case TaskViewMode.gantt:
        return Icons.waterfall_chart_outlined;
      case TaskViewMode.table:
        return Icons.table_chart_outlined;
    }
  }
}

// =============================================================================
// GANTT ZOOM LEVEL
// =============================================================================
enum GanttZoomLevel {
  day,
  week,
  month,
  quarter,
}

extension GanttZoomLevelExt on GanttZoomLevel {
  String get label {
    switch (this) {
      case GanttZoomLevel.day:
        return 'Day';
      case GanttZoomLevel.week:
        return 'Week';
      case GanttZoomLevel.month:
        return 'Month';
      case GanttZoomLevel.quarter:
        return 'Quarter';
    }
  }
}

// =============================================================================
// AREA UNIT
// =============================================================================
enum AreaUnit {
  sqFt,
  sqM,
  runFt,
}

extension AreaUnitExt on AreaUnit {
  String get label {
    switch (this) {
      case AreaUnit.sqFt:
        return 'Sq.Ft.';
      case AreaUnit.sqM:
        return 'Sq.M.';
      case AreaUnit.runFt:
        return 'Running Ft.';
    }
  }

  String get displayName => label;
}
