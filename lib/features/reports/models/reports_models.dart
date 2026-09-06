import 'package:flutter/material.dart';

/// Common date filtering enum across all reports
enum ReportDateFilter {
  today,
  thisWeek,
  thisMonth,
  thisQuarter,
  thisYear,
  custom,
}

extension ReportDateFilterExt on ReportDateFilter {
  String get label {
    switch (this) {
      case ReportDateFilter.today:
        return 'Today';
      case ReportDateFilter.thisWeek:
        return 'This Week';
      case ReportDateFilter.thisMonth:
        return 'This Month';
      case ReportDateFilter.thisQuarter:
        return 'This Quarter';
      case ReportDateFilter.thisYear:
        return 'This Year';
      case ReportDateFilter.custom:
        return 'Custom';
    }
  }
}

/// Generic KPI metric model for reports
class ReportKpiMetric {
  final String id;
  final String title;
  final String value;
  final String changeText;
  final bool isPositive;
  final IconData icon;
  final Color color;
  final String? subtitle;

  const ReportKpiMetric({
    required this.id,
    required this.title,
    required this.value,
    required this.changeText,
    required this.isPositive,
    required this.icon,
    required this.color,
    this.subtitle,
  });
}

// ============================================================================
// 1. MARKETING MODELS
// ============================================================================

class FunnelStageItem {
  final String stageId;
  final String stageName;
  final int count;
  final double percentage;
  final Color color;
  final String? subtext;

  const FunnelStageItem({
    required this.stageId,
    required this.stageName,
    required this.count,
    required this.percentage,
    required this.color,
    this.subtext,
  });
}

class DecliningReasonItem {
  final String reason;
  final int count;
  final double percentage;
  final Color color;

  const DecliningReasonItem({
    required this.reason,
    required this.count,
    required this.percentage,
    required this.color,
  });
}

class SocialCommentItem {
  final String id;
  final String author;
  final String platform; // 'Instagram', 'YouTube', 'Pinterest'
  final String commentText;
  final String postTitle;
  final String timeAgo;
  final bool isAiReplied;
  final String? replyText;

  const SocialCommentItem({
    required this.id,
    required this.author,
    required this.platform,
    required this.commentText,
    required this.postTitle,
    required this.timeAgo,
    required this.isAiReplied,
    this.replyText,
  });
}

// ============================================================================
// 2. SALES MODELS
// ============================================================================

class SalesObjectionItem {
  final String objectionName;
  final int count;
  final double percentage;
  final Color color;

  const SalesObjectionItem({
    required this.objectionName,
    required this.count,
    required this.percentage,
    required this.color,
  });
}

class SalesTopRankerItem {
  final int rank;
  final String consultantName;
  final String avatarUrl;
  final int callsCount;
  final int callMinutes;
  final int meetingsDone;
  final int bookingsCount;
  final double revenueGenerated; // in Lakhs
  final double conversionRate;

  const SalesTopRankerItem({
    required this.rank,
    required this.consultantName,
    required this.avatarUrl,
    required this.callsCount,
    required this.callMinutes,
    required this.meetingsDone,
    required this.bookingsCount,
    required this.revenueGenerated,
    required this.conversionRate,
  });
}

// ============================================================================
// 3. DESIGN MODELS
// ============================================================================

class DesignerProductivityItem {
  final int rank;
  final String designerName;
  final String avatarUrl;
  final double hoursWorked;
  final int filesCompleted;
  final int meetingsTaken;
  final int siteVisits;
  final double productivityScore; // 0 - 100
  final int bookingsClosed;
  final double incentiveEarned;
  final double csatRating; // 0 - 10

  const DesignerProductivityItem({
    required this.rank,
    required this.designerName,
    required this.avatarUrl,
    required this.hoursWorked,
    required this.filesCompleted,
    required this.meetingsTaken,
    required this.siteVisits,
    required this.productivityScore,
    required this.bookingsClosed,
    required this.incentiveEarned,
    required this.csatRating,
  });
}

class DesignFileApprovalItem {
  final String projectId;
  final String projectName;
  final String clientName;
  final String designerName;
  final String fileType; // 3D Render, Working Drawing, Moodboard
  final String status; // 'Approved', 'Pending Review', 'Revision Needed'
  final Color statusColor;
  final String submittedDate;
  final String reviewNotes;

  const DesignFileApprovalItem({
    required this.projectId,
    required this.projectName,
    required this.clientName,
    required this.designerName,
    required this.fileType,
    required this.status,
    required this.statusColor,
    required this.submittedDate,
    required this.reviewNotes,
  });
}

// ============================================================================
// 4. EXECUTION MODELS
// ============================================================================

class ExecutionProjectProgressItem {
  final String projectId;
  final String projectName;
  final String clientName;
  final String stage; // 'Civil', 'Electrical', 'Woodwork', 'Finishing', 'Handover'
  final double progressPercent;
  final bool isDelayed;
  final int delayDays;
  final String siteEngineer;
  final String lastPhysicalVisitDate;
  final bool isVisitOverdue; // true if > 10 days
  final int pendingTasks;

  const ExecutionProjectProgressItem({
    required this.projectId,
    required this.projectName,
    required this.clientName,
    required this.stage,
    required this.progressPercent,
    required this.isDelayed,
    required this.delayDays,
    required this.siteEngineer,
    required this.lastPhysicalVisitDate,
    required this.isVisitOverdue,
    required this.pendingTasks,
  });
}

class ExecutionComplaintItem {
  final String ticketId;
  final String clientName;
  final String projectName;
  final String category; // 'Quality', 'Timeline', 'Site Behaviour'
  final String issueDescription;
  final String registeredDate;
  final String status; // 'Solved On-Time', 'Solved Delayed', 'Unsolved'
  final Color statusColor;
  final int resolutionDays;

  const ExecutionComplaintItem({
    required this.ticketId,
    required this.clientName,
    required this.projectName,
    required this.category,
    required this.issueDescription,
    required this.registeredDate,
    required this.status,
    required this.statusColor,
    required this.resolutionDays,
  });
}

class SiteMediaFeedItem {
  final String id;
  final String clientName;
  final String siteLocation;
  final String stage;
  final String uploadedBy;
  final String timeAgo;
  final String mediaUrl;
  final bool isVideo;
  final String note;

  const SiteMediaFeedItem({
    required this.id,
    required this.clientName,
    required this.siteLocation,
    required this.stage,
    required this.uploadedBy,
    required this.timeAgo,
    required this.mediaUrl,
    required this.isVideo,
    required this.note,
  });
}

// ============================================================================
// 5. VENDOR RATINGS MODELS
// ============================================================================

class VendorScorecardItem {
  final String vendorId;
  final String vendorName;
  final String tradeCategory; // 'Carpentry', 'Civil & Masonry', 'Electrical', 'Plumbing', 'Painting', 'Glass & Alu'
  final double overallRating; // 0.0 - 10.0
  final double qualityScore; // 0 - 100%
  final double punctualityScore; // 0 - 100%
  final double wastageControlScore; // 0 - 100%
  final int activeSitesCount;
  final int completedSitesCount;
  final bool isWinnerOfMonth;
  final bool isCriticalAlert; // true if rating < 5.0
  final String auditStatus; // 'Certified', 'Audit Pending', 'Under Watch'

  const VendorScorecardItem({
    required this.vendorId,
    required this.vendorName,
    required this.tradeCategory,
    required this.overallRating,
    required this.qualityScore,
    required this.punctualityScore,
    required this.wastageControlScore,
    required this.activeSitesCount,
    required this.completedSitesCount,
    required this.isWinnerOfMonth,
    required this.isCriticalAlert,
    required this.auditStatus,
  });
}

// ============================================================================
// 6. FINANCIAL MODELS
// ============================================================================

class FinancialOutflowLedgerItem {
  final String txnId;
  final String projectId;
  final String clientName;
  final String category; // 'Material Procurement', 'Labour Disbursement', 'Design Fees', 'Consulting Fees'
  final String recipientName;
  final double amount;
  final String date;
  final String paymentMethod; // 'Bank RTGS', 'UPI / IMPS', 'Escrow Release', 'Cheque'
  final String status; // 'Settled', 'Scheduled', 'Processing'
  final Color statusColor;
  final String invoiceRef;

  const FinancialOutflowLedgerItem({
    required this.txnId,
    required this.projectId,
    required this.clientName,
    required this.category,
    required this.recipientName,
    required this.amount,
    required this.date,
    required this.paymentMethod,
    required this.status,
    required this.statusColor,
    required this.invoiceRef,
  });
}
