import 'package:flutter/material.dart';

/// Common date filtering enum across all reports
enum ReportDateFilter {
  today,
  yesterday,
  thisWeek,
  lastWeek,
  thisMonth,
  lastMonth,
  thisQuarter,
  lastQuarter,
  thisYear,
  lastYear,
  custom,
}

extension ReportDateFilterExt on ReportDateFilter {
  String get label {
    switch (this) {
      case ReportDateFilter.today:
        return 'Today';
      case ReportDateFilter.yesterday:
        return 'Yesterday';
      case ReportDateFilter.thisWeek:
        return 'This Week';
      case ReportDateFilter.lastWeek:
        return 'Last Week';
      case ReportDateFilter.thisMonth:
        return 'This Month';
      case ReportDateFilter.lastMonth:
        return 'Last Month';
      case ReportDateFilter.thisQuarter:
        return 'This Quarter';
      case ReportDateFilter.lastQuarter:
        return 'Last Quarter';
      case ReportDateFilter.thisYear:
        return 'This Year';
      case ReportDateFilter.lastYear:
        return 'Last Year';
      case ReportDateFilter.custom:
        return 'Custom Range';
    }
  }
}

/// Comparison period options for analytics
enum ReportComparisonPeriod {
  previousPeriod,
  previousYear,
  custom,
}

extension ReportComparisonPeriodExt on ReportComparisonPeriod {
  String get label {
    switch (this) {
      case ReportComparisonPeriod.previousPeriod:
        return 'vs Previous Period';
      case ReportComparisonPeriod.previousYear:
        return 'vs Previous Year';
      case ReportComparisonPeriod.custom:
        return 'vs Custom Period';
    }
  }
}

/// Global reporting filter state
class ReportFilterState {
  final ReportDateFilter dateFilter;
  final DateTime? customStartDate;
  final DateTime? customEndDate;
  final ReportComparisonPeriod comparisonPeriod;
  final String branch;
  final String businessUnit;
  final String region;
  final String team;
  final String owner;
  final String project;
  final String status;
  final String priority;
  final String customerType;
  final String serviceType;
  final String searchQuery;

  const ReportFilterState({
    this.dateFilter = ReportDateFilter.thisMonth,
    this.customStartDate,
    this.customEndDate,
    this.comparisonPeriod = ReportComparisonPeriod.previousPeriod,
    this.branch = 'All Branches',
    this.businessUnit = 'All Business Units',
    this.region = 'All Regions',
    this.team = 'All Teams',
    this.owner = 'All Owners',
    this.project = 'All Projects',
    this.status = 'All Statuses',
    this.priority = 'All Priorities',
    this.customerType = 'All Types',
    this.serviceType = 'All Services',
    this.searchQuery = '',
  });

  ReportFilterState copyWith({
    ReportDateFilter? dateFilter,
    DateTime? customStartDate,
    DateTime? customEndDate,
    ReportComparisonPeriod? comparisonPeriod,
    String? branch,
    String? businessUnit,
    String? region,
    String? team,
    String? owner,
    String? project,
    String? status,
    String? priority,
    String? customerType,
    String? serviceType,
    String? searchQuery,
  }) {
    return ReportFilterState(
      dateFilter: dateFilter ?? this.dateFilter,
      customStartDate: customStartDate ?? this.customStartDate,
      customEndDate: customEndDate ?? this.customEndDate,
      comparisonPeriod: comparisonPeriod ?? this.comparisonPeriod,
      branch: branch ?? this.branch,
      businessUnit: businessUnit ?? this.businessUnit,
      region: region ?? this.region,
      team: team ?? this.team,
      owner: owner ?? this.owner,
      project: project ?? this.project,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      customerType: customerType ?? this.customerType,
      serviceType: serviceType ?? this.serviceType,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  int get activeFiltersCount {
    int count = 0;
    if (branch != 'All Branches') count++;
    if (businessUnit != 'All Business Units') count++;
    if (region != 'All Regions') count++;
    if (team != 'All Teams') count++;
    if (owner != 'All Owners') count++;
    if (project != 'All Projects') count++;
    if (status != 'All Statuses') count++;
    if (priority != 'All Priorities') count++;
    if (customerType != 'All Types') count++;
    if (serviceType != 'All Services') count++;
    if (searchQuery.isNotEmpty) count++;
    if (dateFilter == ReportDateFilter.custom) count++;
    return count;
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
  final double? targetProgress; // 0.0 to 1.0

  const ReportKpiMetric({
    required this.id,
    required this.title,
    required this.value,
    required this.changeText,
    required this.isPositive,
    required this.icon,
    required this.color,
    this.subtitle,
    this.targetProgress,
  });
}

// ============================================================================
// 1. EXECUTIVE OVERVIEW MODELS
// ============================================================================

class ExecutiveKpiCardData {
  final String id;
  final String title;
  final String value;
  final String previousValue;
  final double growthPercent;
  final bool isPositive;
  final String target;
  final double targetAchievementPercent;
  final IconData icon;
  final Color color;
  final String category; // 'Revenue', 'Sales', 'Projects', 'Collections', 'Marketing', 'Customer'
  final List<double>? sparklinePoints;

  const ExecutiveKpiCardData({
    required this.id,
    required this.title,
    required this.value,
    required this.previousValue,
    required this.growthPercent,
    required this.isPositive,
    required this.target,
    required this.targetAchievementPercent,
    required this.icon,
    required this.color,
    required this.category,
    this.sparklinePoints,
  });
}

class RevenueSalesTrendPoint {
  final String dateLabel;
  final double revenue; // in Lakhs
  final double sales;
  final double target;
  final double previousRevenue;
  final double variance;

  const RevenueSalesTrendPoint({
    required this.dateLabel,
    required this.revenue,
    required this.sales,
    required this.target,
    required this.previousRevenue,
    required this.variance,
  });
}

class ExecutivePipelineStage {
  final String stageName;
  final int opportunityCount;
  final double pipelineValueLakhs;
  final double conversionRate;
  final double stageToStageConversion;
  final double avgDealValueLakhs;
  final Color color;

  const ExecutivePipelineStage({
    required this.stageName,
    required this.opportunityCount,
    required this.pipelineValueLakhs,
    required this.conversionRate,
    required this.stageToStageConversion,
    required this.avgDealValueLakhs,
    required this.color,
  });
}

class ExecutiveProjectHealthItem {
  final String projectName;
  final String projectId;
  final String projectManager;
  final double progressPercent;
  final String plannedCompletion;
  final String expectedCompletion;
  final String budgetStatus; // 'Within Budget', 'Near Budget', 'Over Budget'
  final String scheduleStatus; // 'On Track', 'At Risk', 'Delayed'
  final String riskStatus; // 'Low', 'Medium', 'High', 'Critical'
  final Color statusColor;

  const ExecutiveProjectHealthItem({
    required this.projectName,
    required this.projectId,
    required this.projectManager,
    required this.progressPercent,
    required this.plannedCompletion,
    required this.expectedCompletion,
    required this.budgetStatus,
    required this.scheduleStatus,
    required this.riskStatus,
    required this.statusColor,
  });
}

class FinancialSnapshotItem {
  final String category;
  final double currentLakhs;
  final double previousLakhs;
  final double changePercent;
  final bool isPositive;
  final String note;

  const FinancialSnapshotItem({
    required this.category,
    required this.currentLakhs,
    required this.previousLakhs,
    required this.changePercent,
    required this.isPositive,
    required this.note,
  });
}

class ManagementAlertItem {
  final String id;
  final String severity; // 'Critical', 'Warning', 'Info'
  final String title;
  final String description;
  final String relatedEntity;
  final String entityId;
  final String owner;
  final String date;
  final String recommendedAction;
  final String actionRoute;

  const ManagementAlertItem({
    required this.id,
    required this.severity,
    required this.title,
    required this.description,
    required this.relatedEntity,
    required this.entityId,
    required this.owner,
    required this.date,
    required this.recommendedAction,
    required this.actionRoute,
  });
}

// ============================================================================
// 2. MARKETING MODELS
// ============================================================================

class MarketingLeadSourceItem {
  final String source;
  final int leadVolume;
  final int qualifiedLeads;
  final double conversionRate;
  final double costPerLead;
  final double revenueGeneratedLakhs;
  final Color color;

  const MarketingLeadSourceItem({
    required this.source,
    required this.leadVolume,
    required this.qualifiedLeads,
    required this.conversionRate,
    required this.costPerLead,
    required this.revenueGeneratedLakhs,
    required this.color,
  });
}

class MarketingCampaignItem {
  final String id;
  final String campaignName;
  final String campaignType;
  final String channel;
  final String startDate;
  final String endDate;
  final String campaignOwner;
  final double budgetLakhs;
  final double actualSpendLakhs;
  final int leads;
  final int qualifiedLeads;
  final int opportunities;
  final int wonDeals;
  final double revenueLakhs;
  final double cpl;
  final double cpa;
  final double conversionRate;
  final double roi;
  final String status; // 'Active', 'Completed', 'Paused'

  const MarketingCampaignItem({
    required this.id,
    required this.campaignName,
    required this.campaignType,
    required this.channel,
    required this.startDate,
    required this.endDate,
    required this.campaignOwner,
    required this.budgetLakhs,
    required this.actualSpendLakhs,
    required this.leads,
    required this.qualifiedLeads,
    required this.opportunities,
    required this.wonDeals,
    required this.revenueLakhs,
    required this.cpl,
    required this.cpa,
    required this.conversionRate,
    required this.roi,
    required this.status,
  });
}

class MarketingFunnelStep {
  final String stageName;
  final int count;
  final double conversionPercent;
  final double dropOffPercent;
  final int previousPeriodCount;
  final Color color;

  const MarketingFunnelStep({
    required this.stageName,
    required this.count,
    required this.conversionPercent,
    required this.dropOffPercent,
    required this.previousPeriodCount,
    required this.color,
  });
}

class MarketingChannelMetric {
  final String channel;
  final int leads;
  final int qualifiedLeads;
  final double conversionRate;
  final double spendLakhs;
  final double revenueLakhs;
  final double roi;
  final IconData icon;
  final Color color;

  const MarketingChannelMetric({
    required this.channel,
    required this.leads,
    required this.qualifiedLeads,
    required this.conversionRate,
    required this.spendLakhs,
    required this.revenueLakhs,
    required this.roi,
    required this.icon,
    required this.color,
  });
}

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
// 3. SALES MODELS
// ============================================================================

class SalesTrendPoint {
  final String period;
  final int leads;
  final int opportunities;
  final int wonDeals;
  final double revenueLakhs;
  final double previousRevenueLakhs;

  const SalesTrendPoint({
    required this.period,
    required this.leads,
    required this.opportunities,
    required this.wonDeals,
    required this.revenueLakhs,
    required this.previousRevenueLakhs,
  });
}

class SalesPipelineStageDetail {
  final String stageName;
  final int opportunityCount;
  final double totalValueLakhs;
  final double avgValueLakhs;
  final double conversionRate;
  final int avgAgeDays;
  final Color color;

  const SalesPipelineStageDetail({
    required this.stageName,
    required this.opportunityCount,
    required this.totalValueLakhs,
    required this.avgValueLakhs,
    required this.conversionRate,
    required this.avgAgeDays,
    required this.color,
  });
}

class SalesAgingBucket {
  final String ageRange; // '0–7 days', '8–14 days', etc.
  final int dealCount;
  final double pipelineValueLakhs;
  final bool isStale;
  final Color color;

  const SalesAgingBucket({
    required this.ageRange,
    required this.dealCount,
    required this.pipelineValueLakhs,
    required this.isStale,
    required this.color,
  });
}

class SalesTeamMemberMetric {
  final int rank;
  final String salesperson;
  final String team;
  final String avatarUrl;
  final int leadsAssigned;
  final int leadsContacted;
  final int qualifiedLeads;
  final int opportunities;
  final int proposals;
  final int wonDeals;
  final int lostDeals;
  final double revenueLakhs;
  final double winRate;
  final double avgDealSizeLakhs;
  final int avgSalesCycleDays;
  final double targetLakhs;
  final double achievementPercent;
  final double pipelineValueLakhs;

  const SalesTeamMemberMetric({
    required this.rank,
    required this.salesperson,
    required this.team,
    required this.avatarUrl,
    required this.leadsAssigned,
    required this.leadsContacted,
    required this.qualifiedLeads,
    required this.opportunities,
    required this.proposals,
    required this.wonDeals,
    required this.lostDeals,
    required this.revenueLakhs,
    required this.winRate,
    required this.avgDealSizeLakhs,
    required this.avgSalesCycleDays,
    required this.targetLakhs,
    required this.achievementPercent,
    required this.pipelineValueLakhs,
  });
}

class SalesForecastData {
  final double bestCaseLakhs;
  final double commitLakhs;
  final double pipelineLakhs;
  final double closedWonLakhs;
  final double targetLakhs;
  final double forecastGapLakhs;

  const SalesForecastData({
    required this.bestCaseLakhs,
    required this.commitLakhs,
    required this.pipelineLakhs,
    required this.closedWonLakhs,
    required this.targetLakhs,
    required this.forecastGapLakhs,
  });
}

class TopDealItem {
  final String customer;
  final String opportunity;
  final String owner;
  final String stage;
  final double dealValueLakhs;
  final int probabilityPercent;
  final String expectedCloseDate;
  final int daysOpen;
  final String forecastCategory; // 'Commit', 'Best Case', 'Pipeline'
  final String lastActivity;
  final String nextActivity;
  final Color stageColor;

  const TopDealItem({
    required this.customer,
    required this.opportunity,
    required this.owner,
    required this.stage,
    required this.dealValueLakhs,
    required this.probabilityPercent,
    required this.expectedCloseDate,
    required this.daysOpen,
    required this.forecastCategory,
    required this.lastActivity,
    required this.nextActivity,
    required this.stageColor,
  });
}

class LostDealReasonItem {
  final String reason;
  final int dealCount;
  final double lostValueLakhs;
  final double percentage;
  final Color color;

  const LostDealReasonItem({
    required this.reason,
    required this.dealCount,
    required this.lostValueLakhs,
    required this.percentage,
    required this.color,
  });
}

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
// 4. PROJECTS / EXECUTION MODELS
// ============================================================================

class ProjectPerformanceItem {
  final String projectName;
  final String projectId;
  final String customer;
  final String projectManager;
  final String startDate;
  final String plannedCompletion;
  final String actualCompletion;
  final String status; // 'On Track', 'At Risk', 'Delayed', 'Critical', 'Completed'
  final String priority; // 'High', 'Medium', 'Low'
  final double progressPercent;
  final double plannedProgressPercent;
  final int scheduleVarianceDays;
  final double budgetLakhs;
  final double actualCostLakhs;
  final double costVarianceLakhs;
  final int tasksTotal;
  final int tasksCompleted;
  final int tasksOverdue;
  final String riskLevel; // 'Low', 'Medium', 'High', 'Critical'
  final String lastUpdated;
  final Color statusColor;

  const ProjectPerformanceItem({
    required this.projectName,
    required this.projectId,
    required this.customer,
    required this.projectManager,
    required this.startDate,
    required this.plannedCompletion,
    required this.actualCompletion,
    required this.status,
    required this.priority,
    required this.progressPercent,
    required this.plannedProgressPercent,
    required this.scheduleVarianceDays,
    required this.budgetLakhs,
    required this.actualCostLakhs,
    required this.costVarianceLakhs,
    required this.tasksTotal,
    required this.tasksCompleted,
    required this.tasksOverdue,
    required this.riskLevel,
    required this.lastUpdated,
    required this.statusColor,
  });
}

class ProjectHealthDistribution {
  final int onTrack;
  final int atRisk;
  final int delayed;
  final int critical;
  final int completed;

  const ProjectHealthDistribution({
    required this.onTrack,
    required this.atRisk,
    required this.delayed,
    required this.critical,
    required this.completed,
  });

  int get total => onTrack + atRisk + delayed + critical + completed;
}

class TaskExecutionSummary {
  final int totalTasks;
  final int completed;
  final int inProgress;
  final int pending;
  final int blocked;
  final int overdue;

  const TaskExecutionSummary({
    required this.totalTasks,
    required this.completed,
    required this.inProgress,
    required this.pending,
    required this.blocked,
    required this.overdue,
  });
}

class ProjectManagerPerformanceItem {
  final String projectManager;
  final String avatarUrl;
  final int activeProjects;
  final int completedProjects;
  final double onTimePercent;
  final double avgProgressPercent;
  final int delayedProjects;
  final int atRiskProjects;
  final double budgetVariancePercent;
  final double taskCompletionPercent;
  final int overdueTasks;

  const ProjectManagerPerformanceItem({
    required this.projectManager,
    required this.avatarUrl,
    required this.activeProjects,
    required this.completedProjects,
    required this.onTimePercent,
    required this.avgProgressPercent,
    required this.delayedProjects,
    required this.atRiskProjects,
    required this.budgetVariancePercent,
    required this.taskCompletionPercent,
    required this.overdueTasks,
  });
}

class ProjectRiskItem {
  final String id;
  final String projectName;
  final String riskTitle;
  String get riskIssue => riskTitle;
  final String severity; // 'Critical', 'High', 'Medium', 'Low'
  final String category; // 'Schedule', 'Budget', 'Quality', 'Labour', 'Material'
  final String owner;
  final String identifiedDate;
  final String dueDate;
  final String status; // 'Open', 'Mitigating', 'Resolved'
  final String impact;
  final String mitigation;
  final String resolution;
  final Color severityColor;

  const ProjectRiskItem({
    required this.id,
    required this.projectName,
    required this.riskTitle,
    required this.severity,
    required this.category,
    required this.owner,
    required this.identifiedDate,
    required this.dueDate,
    required this.status,
    required this.impact,
    required this.mitigation,
    required this.resolution,
    required this.severityColor,
  });
}

class ExecutionProjectProgressItem {
  final String projectId;
  final String projectName;
  final String clientName;
  final String stage;
  final double progressPercent;
  final bool isDelayed;
  final int delayDays;
  final String siteEngineer;
  final String lastPhysicalVisitDate;
  final bool isVisitOverdue;
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
  final String category;
  final String issueDescription;
  final String registeredDate;
  final String status;
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
// 5. DESIGN MODELS
// ============================================================================

class DesignWorkflowFunnelStep {
  final String stageName;
  final int count;
  final double percentage;
  final double avgTimeHours;
  final double dropOffPercent;
  final Color color;

  const DesignWorkflowFunnelStep({
    required this.stageName,
    required this.count,
    required this.percentage,
    required this.avgTimeHours,
    required this.dropOffPercent,
    required this.color,
  });
}

class DesignWorkloadItem {
  final String entityName;
  final String entityType; // 'Designer', 'Team', 'Design Type', 'Project'
  final int assigned;
  final int inProgress;
  final int completed;
  final int pending;
  final int overdue;
  final double avgCompletionHours;

  const DesignWorkloadItem({
    required this.entityName,
    required this.entityType,
    required this.assigned,
    required this.inProgress,
    required this.completed,
    required this.pending,
    required this.overdue,
    required this.avgCompletionHours,
  });
}

class DesignerPerformanceDetailItem {
  final int rank;
  final String designerName;
  final String team;
  final String avatarUrl;
  final int assignedDesigns;
  final int completedDesigns;
  final int inProgressDesigns;
  final int pendingDesigns;
  final int overdueDesigns;
  final double avgTurnaroundDays;
  final double avgRevisionCount;
  final double approvalRate;
  final double rejectionRate;
  final double onTimeDeliveryPercent;
  final double utilizationPercent;
  final double qualityScore;

  const DesignerPerformanceDetailItem({
    required this.rank,
    required this.designerName,
    required this.team,
    required this.avatarUrl,
    required this.assignedDesigns,
    required this.completedDesigns,
    required this.inProgressDesigns,
    required this.pendingDesigns,
    required this.overdueDesigns,
    required this.avgTurnaroundDays,
    required this.avgRevisionCount,
    required this.approvalRate,
    required this.rejectionRate,
    required this.onTimeDeliveryPercent,
    required this.utilizationPercent,
    required this.qualityScore,
  });
}

class DesignTurnaroundMetric {
  final String category; // 'Modular Kitchen', 'Wardrobe', '3D Walkthrough', 'False Ceiling'
  final double avgDays;
  final double medianDays;
  final double fastestDays;
  final double slowestDays;
  final double slaCompliancePercent;

  const DesignTurnaroundMetric({
    required this.category,
    required this.avgDays,
    required this.medianDays,
    required this.fastestDays,
    required this.slowestDays,
    required this.slaCompliancePercent,
  });
}

class DesignRevisionBucket {
  final String revisionRange; // '0 Revisions', '1–2 Revisions', '3–5 Revisions', '5+ Revisions'
  final int designCount;
  final double percentage;
  final Color color;

  const DesignRevisionBucket({
    required this.revisionRange,
    required this.designCount,
    required this.percentage,
    required this.color,
  });
}

class DesignApprovalMetric {
  final String segment; // 'Homeowner Final', 'Internal Lead', 'Civil Signoff'
  final int pendingApprovals;
  final int approved;
  final int rejected;
  final double approvalRate;
  final double avgApprovalHours;

  const DesignApprovalMetric({
    required this.segment,
    required this.pendingApprovals,
    required this.approved,
    required this.rejected,
    required this.approvalRate,
    required this.avgApprovalHours,
  });
}

class DesignRecordItem {
  final String designId;
  final String designName;
  final String projectName;
  final String customer;
  final String designer;
  final String designType; // '3D Photorealistic Render', 'Joinery Drawings', 'Electrical/Plumbing'
  final String priority; // 'Urgent', 'High', 'Standard'
  final String createdDate;
  final String assignedDate;
  final String dueDate;
  final String? completedDate;
  final String status; // 'Approved', 'In Progress', 'Revision Needed', 'Pending Review'
  final String approvalStatus; // 'Approved', 'Pending', 'Rejected'
  final int revisionCount;
  final double turnaroundDays;
  final String slaStatus; // 'Within SLA', 'At Risk', 'Breached SLA'
  final String lastUpdated;
  final Color statusColor;

  const DesignRecordItem({
    required this.designId,
    required this.designName,
    required this.projectName,
    required this.customer,
    required this.designer,
    required this.designType,
    required this.priority,
    required this.createdDate,
    required this.assignedDate,
    required this.dueDate,
    this.completedDate,
    required this.status,
    required this.approvalStatus,
    required this.revisionCount,
    required this.turnaroundDays,
    required this.slaStatus,
    required this.lastUpdated,
    required this.statusColor,
  });
}

class DesignerProductivityItem {
  final int rank;
  final String designerName;
  final String avatarUrl;
  final double hoursWorked;
  final int filesCompleted;
  final int meetingsTaken;
  final int siteVisits;
  final double productivityScore;
  final int bookingsClosed;
  final double incentiveEarned;
  final double csatRating;

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
  final String fileType;
  final String status;
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
// 6. VENDOR & FINANCIAL MODELS (PRESERVED)
// ============================================================================

class VendorScorecardItem {
  final String vendorId;
  final String vendorName;
  final String tradeCategory;
  final double overallRating;
  final double qualityScore;
  final double punctualityScore;
  final double wastageControlScore;
  final int activeSitesCount;
  final int completedSitesCount;
  final bool isWinnerOfMonth;
  final bool isCriticalAlert;
  final String auditStatus;

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

class FinancialOutflowLedgerItem {
  final String txnId;
  final String projectId;
  final String clientName;
  final String category;
  final String recipientName;
  final double amount;
  final String date;
  final String paymentMethod;
  final String status;
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

// ============================================================================
// 7. FINANCE ANALYTICS MODELS (SCREEN 06)
// ============================================================================

class FinanceRevenueExpenseTrendPoint {
  final String periodLabel;
  final double revenue; // in Lakhs
  final double expenses;
  final double netProfit;
  final double grossMarginPercent;

  const FinanceRevenueExpenseTrendPoint({
    required this.periodLabel,
    required this.revenue,
    required this.expenses,
    required this.netProfit,
    required this.grossMarginPercent,
  });
}

class FinanceRevenueBreakdownItem {
  final String id;
  final String dimension; // 'Project', 'Customer', 'Branch', 'Category'
  final String title;
  final String customerOrClient;
  final double revenue;
  final double cost;
  final double grossProfit;
  final double marginPercent;
  final String projectStatus;

  const FinanceRevenueBreakdownItem({
    required this.id,
    required this.dimension,
    required this.title,
    required this.customerOrClient,
    required this.revenue,
    required this.cost,
    required this.grossProfit,
    required this.marginPercent,
    required this.projectStatus,
  });
}

class FinanceExpenseCategoryItem {
  final String id;
  final String category;
  final double budget;
  final double actual;
  final double variance;
  final double percentageOfTotal;
  final bool isOverBudget;
  final IconData icon;
  final Color color;

  const FinanceExpenseCategoryItem({
    required this.id,
    required this.category,
    required this.budget,
    required this.actual,
    required this.variance,
    required this.percentageOfTotal,
    required this.isOverBudget,
    required this.icon,
    required this.color,
  });
}

class FinanceAgingBucket {
  final String bucketId;
  final String label; // '< 30 Days', '31-60 Days', etc.
  final double amount;
  final int invoiceCount;
  final double percentage;
  final Color color;

  const FinanceAgingBucket({
    required this.bucketId,
    required this.label,
    required this.amount,
    required this.invoiceCount,
    required this.percentage,
    required this.color,
  });
}

class FinanceCustomerCollectionItem {
  final String customerId;
  final String customerName;
  final int invoiceCount;
  final double invoicedAmount;
  final double paidAmount;
  final double outstandingAmount;
  final double overdueAmount;
  final double collectionRate;
  final String oldestDueDate;
  final int daysOverdue;
  final String lastPaymentDate;
  final String riskLevel; // 'Low', 'Medium', 'Critical'

  const FinanceCustomerCollectionItem({
    required this.customerId,
    required this.customerName,
    required this.invoiceCount,
    required this.invoicedAmount,
    required this.paidAmount,
    required this.outstandingAmount,
    required this.overdueAmount,
    required this.collectionRate,
    required this.oldestDueDate,
    required this.daysOverdue,
    required this.lastPaymentDate,
    required this.riskLevel,
  });
}

class FinancePayableItem {
  final String payableId;
  final String recipientName;
  final String category; // 'Vendor Supply', 'Contractor Labour'
  final String invoiceRef;
  final String dueDate;
  final double amount;
  final double paidAmount;
  final double outstandingAmount;
  final String status;
  final Color statusColor;

  const FinancePayableItem({
    required this.payableId,
    required this.recipientName,
    required this.category,
    required this.invoiceRef,
    required this.dueDate,
    required this.amount,
    required this.paidAmount,
    required this.outstandingAmount,
    required this.status,
    required this.statusColor,
  });
}

class FinancePerformancePeriodItem {
  final String period;
  final double revenue;
  final double expenses;
  final double grossProfit;
  final double grossMargin;
  final double receivables;
  final double collections;
  final double payables;
  final double netPosition;
  final double variance;

  const FinancePerformancePeriodItem({
    required this.period,
    required this.revenue,
    required this.expenses,
    required this.grossProfit,
    required this.grossMargin,
    required this.receivables,
    required this.collections,
    required this.payables,
    required this.netPosition,
    required this.variance,
  });
}

// ============================================================================
// 8. HR ANALYTICS MODELS (SCREEN 07)
// ============================================================================

class HrCompositionItem {
  final String category;
  final int count;
  final double percentage;
  final Color color;
  final double avgTenure;

  const HrCompositionItem({
    required this.category,
    required this.count,
    required this.percentage,
    required this.color,
    required this.avgTenure,
  });
}

class HrHeadcountTrendPoint {
  final String monthLabel;
  final int openingHeadcount;
  final int newJoiners;
  final int exits;
  final int closingHeadcount;

  const HrHeadcountTrendPoint({
    required this.monthLabel,
    required this.openingHeadcount,
    required this.newJoiners,
    required this.exits,
    required this.closingHeadcount,
  });
}

class HrAttendanceDepartmentItem {
  final String department;
  final int totalEmployees;
  final int workingDays;
  final int presentDays;
  final int absentDays;
  final int lateDays;
  final double attendancePercent;

  const HrAttendanceDepartmentItem({
    required this.department,
    required this.totalEmployees,
    required this.workingDays,
    required this.presentDays,
    required this.absentDays,
    required this.lateDays,
    required this.attendancePercent,
  });
}

class HrLeaveAnalyticsItem {
  final String leaveType;
  final int totalRequests;
  final int approved;
  final int pending;
  final int rejected;
  final int daysTaken;
  final double utilizationPercent;
  final Color color;

  const HrLeaveAnalyticsItem({
    required this.leaveType,
    required this.totalRequests,
    required this.approved,
    required this.pending,
    required this.rejected,
    required this.daysTaken,
    required this.utilizationPercent,
    required this.color,
  });
}

class HrRecruitmentFunnelStage {
  final String stageName;
  final int candidateCount;
  final double conversionRate;
  final double avgDaysInStage;
  final Color color;

  const HrRecruitmentFunnelStage({
    required this.stageName,
    required this.candidateCount,
    required this.conversionRate,
    required this.avgDaysInStage,
    required this.color,
  });
}

class HrOpenPositionItem {
  final String positionId;
  final String title;
  final String department;
  final String openDate;
  final int targetHires;
  final int candidatesCount;
  final int interviewsHeld;
  final String status;
  final int daysOpen;
  final String hiringManager;

  const HrOpenPositionItem({
    required this.positionId,
    required this.title,
    required this.department,
    required this.openDate,
    required this.targetHires,
    required this.candidatesCount,
    required this.interviewsHeld,
    required this.status,
    required this.daysOpen,
    required this.hiringManager,
  });
}

class HrAttritionBreakdown {
  final String dimension;
  final int exitCount;
  final double attritionPercent;
  final int voluntaryCount;
  final int involuntaryCount;

  const HrAttritionBreakdown({
    required this.dimension,
    required this.exitCount,
    required this.attritionPercent,
    required this.voluntaryCount,
    required this.involuntaryCount,
  });
}

class HrDepartmentSummaryItem {
  final String department;
  final int headcount;
  final int newJoiners;
  final int exits;
  final double attendancePercent;
  final int leaveDays;
  final int openPositions;
  final int pipelineCount;
  final double attritionPercent;
  final double avgTenureYears;

  const HrDepartmentSummaryItem({
    required this.department,
    required this.headcount,
    required this.newJoiners,
    required this.exits,
    required this.attendancePercent,
    required this.leaveDays,
    required this.openPositions,
    required this.pipelineCount,
    required this.attritionPercent,
    required this.avgTenureYears,
  });
}

// ============================================================================
// 9. SERVICE / LABOUR ANALYTICS MODELS (SCREEN 08)
// ============================================================================

class ServiceWorkloadTrendPoint {
  final String periodLabel;
  final int requests;
  final int assigned;
  final int inProgress;
  final int completed;
  final int overdue;

  const ServiceWorkloadTrendPoint({
    required this.periodLabel,
    required this.requests,
    required this.assigned,
    required this.inProgress,
    required this.completed,
    required this.overdue,
  });
}

class ServiceWorkflowStage {
  final String stageName;
  final int count;
  final double conversionPercent;
  final double avgDwellHours;
  final int overdueCount;
  final Color color;

  const ServiceWorkflowStage({
    required this.stageName,
    required this.count,
    required this.conversionPercent,
    required this.avgDwellHours,
    required this.overdueCount,
    required this.color,
  });
}

class ServicePerformanceRecordItem {
  final String serviceId;
  final String customerName;
  final String projectName;
  final String serviceType;
  final String assignedWorker;
  final String supervisor;
  final String priority;
  final Color priorityColor;
  final String scheduledDate;
  final String completionDate;
  final String status;
  final Color statusColor;
  final String slaStatus; // 'Met', 'Breached', 'Approaching'
  final double responseTimeHours;
  final double resolutionTimeHours;
  final double labourHours;
  final double labourCost;

  const ServicePerformanceRecordItem({
    required this.serviceId,
    required this.customerName,
    required this.projectName,
    required this.serviceType,
    required this.assignedWorker,
    required this.supervisor,
    required this.priority,
    required this.priorityColor,
    required this.scheduledDate,
    required this.completionDate,
    required this.status,
    required this.statusColor,
    required this.slaStatus,
    required this.responseTimeHours,
    required this.resolutionTimeHours,
    required this.labourHours,
    required this.labourCost,
  });
}

class LabourProductivityItem {
  final String workerId;
  final String workerName;
  final String trade;
  final String team;
  final String supervisor;
  final int assignedJobs;
  final int completedJobs;
  final double productiveHours;
  final double idleHours;
  final double utilizationPercent;
  final double avgCompletionHours;
  final double labourCost;
  final double rating;

  const LabourProductivityItem({
    required this.workerId,
    required this.workerName,
    required this.trade,
    required this.team,
    required this.supervisor,
    required this.assignedJobs,
    required this.completedJobs,
    required this.productiveHours,
    required this.idleHours,
    required this.utilizationPercent,
    required this.avgCompletionHours,
    required this.labourCost,
    required this.rating,
  });
}

class LabourCostAnalysisItem {
  final String dimension;
  final String title;
  final double budgetCost;
  final double actualCost;
  final double variance;
  final double costPerJob;
  final double costPerHour;
  final bool isOverBudget;

  const LabourCostAnalysisItem({
    required this.dimension,
    required this.title,
    required this.budgetCost,
    required this.actualCost,
    required this.variance,
    required this.costPerJob,
    required this.costPerHour,
    required this.isOverBudget,
  });
}

class ServiceSlaBreakdownItem {
  final String category;
  final int totalJobs;
  final int slaMet;
  final int slaBreached;
  final double compliancePercent;
  final double avgResponseHours;
  final double avgResolutionHours;

  const ServiceSlaBreakdownItem({
    required this.category,
    required this.totalJobs,
    required this.slaMet,
    required this.slaBreached,
    required this.compliancePercent,
    required this.avgResponseHours,
    required this.avgResolutionHours,
  });
}

// ============================================================================
// 10. CUSTOMER FEEDBACK ANALYTICS MODELS (SCREEN 09)
// ============================================================================

class FeedbackTrendPoint {
  final String periodLabel;
  final double avgRating;
  final int positiveCount;
  final int negativeCount;
  final int complaintsCount;
  final int totalFeedback;

  const FeedbackTrendPoint({
    required this.periodLabel,
    required this.avgRating,
    required this.positiveCount,
    required this.negativeCount,
    required this.complaintsCount,
    required this.totalFeedback,
  });
}

class FeedbackRatingBreakdown {
  final int stars;
  final int count;
  final double percentage;
  final Color color;

  const FeedbackRatingBreakdown({
    required this.stars,
    required this.count,
    required this.percentage,
    required this.color,
  });
}

class FeedbackSentimentBreakdown {
  final String sentiment; // 'Positive', 'Neutral', 'Negative'
  final int count;
  final double percentage;
  final Color color;
  final String trendText;

  const FeedbackSentimentBreakdown({
    required this.sentiment,
    required this.count,
    required this.percentage,
    required this.color,
    required this.trendText,
  });
}

class FeedbackComplaintItem {
  final String complaintId;
  final String customerName;
  final String category;
  final String description;
  final String projectName;
  final String priority;
  final Color priorityColor;
  final String assignedTo;
  final String createdDate;
  final String resolutionDate;
  final String status;
  final Color statusColor;
  final int resolutionDays;
  final bool isSlaBreached;

  const FeedbackComplaintItem({
    required this.complaintId,
    required this.customerName,
    required this.category,
    required this.description,
    required this.projectName,
    required this.priority,
    required this.priorityColor,
    required this.assignedTo,
    required this.createdDate,
    required this.resolutionDate,
    required this.status,
    required this.statusColor,
    required this.resolutionDays,
    required this.isSlaBreached,
  });
}

class CustomerFeedbackRecordItem {
  final String feedbackId;
  final String customerName;
  final String projectName;
  final String serviceType;
  final String feedbackType;
  final double rating;
  final String sentiment;
  final String feedbackDate;
  final String submittedBy;
  final String assignedTeam;
  final String assignedEmployee;
  final String status;
  final String comments;
  final double responseTimeHours;
  final double resolutionTimeHours;

  const CustomerFeedbackRecordItem({
    required this.feedbackId,
    required this.customerName,
    required this.projectName,
    required this.serviceType,
    required this.feedbackType,
    required this.rating,
    required this.sentiment,
    required this.feedbackDate,
    required this.submittedBy,
    required this.assignedTeam,
    required this.assignedEmployee,
    required this.status,
    required this.comments,
    required this.responseTimeHours,
    required this.resolutionTimeHours,
  });
}

class CustomerExperienceAlertItem {
  final String alertId;
  final String customerName;
  final String projectName;
  final String issueType;
  final String severity; // 'Critical', 'Warning', 'Info'
  final Color severityColor;
  final double rating;
  final String details;
  final int daysOpen;
  final String actionRequired;

  const CustomerExperienceAlertItem({
    required this.alertId,
    required this.customerName,
    required this.projectName,
    required this.issueType,
    required this.severity,
    required this.severityColor,
    required this.rating,
    required this.details,
    required this.daysOpen,
    required this.actionRequired,
  });
}

// ============================================================================
// 11. GOALS / PRODUCTIVITY ANALYTICS MODELS (SCREEN 10)
// ============================================================================

class GoalAchievementSummaryItem {
  final String id;
  final String grouping; // 'Organization', 'Department', 'Team', 'Employee'
  final String title;
  final double targetValue;
  final double actualValue;
  final String unit;
  final double achievementPercent;
  final double variancePercent;
  final String status;
  final Color statusColor;

  const GoalAchievementSummaryItem({
    required this.id,
    required this.grouping,
    required this.title,
    required this.targetValue,
    required this.actualValue,
    required this.unit,
    required this.achievementPercent,
    required this.variancePercent,
    required this.status,
    required this.statusColor,
  });
}

class GoalStatusDistributionItem {
  final String status;
  final int count;
  final double percentage;
  final Color color;

  const GoalStatusDistributionItem({
    required this.status,
    required this.count,
    required this.percentage,
    required this.color,
  });
}

class ProductivityTrendPoint {
  final String periodLabel;
  final int tasksCompleted;
  final int projectsDelivered;
  final double salesAchievedLakhs;
  final int serviceJobsDone;
  final int designsFinalized;
  final double overallProductivityIndex;

  const ProductivityTrendPoint({
    required this.periodLabel,
    required this.tasksCompleted,
    required this.projectsDelivered,
    required this.salesAchievedLakhs,
    required this.serviceJobsDone,
    required this.designsFinalized,
    required this.overallProductivityIndex,
  });
}

class DepartmentProductivitySummaryItem {
  final String department;
  final int teamSize;
  final int goalsAssigned;
  final int goalsCompleted;
  final double achievementPercent;
  final double productivityPercent;
  final int tasksCompleted;
  final int projectsCompleted;
  final double revenueContributionLakhs;
  final int overdueWorkCount;
  final int atRiskGoalsCount;

  const DepartmentProductivitySummaryItem({
    required this.department,
    required this.teamSize,
    required this.goalsAssigned,
    required this.goalsCompleted,
    required this.achievementPercent,
    required this.productivityPercent,
    required this.tasksCompleted,
    required this.projectsCompleted,
    required this.revenueContributionLakhs,
    required this.overdueWorkCount,
    required this.atRiskGoalsCount,
  });
}

class TeamProductivitySummaryItem {
  final String teamName;
  final String managerName;
  final int memberCount;
  final int goalsAssigned;
  final int goalsCompleted;
  final double achievementPercent;
  final double productivityPercent;
  final int completedWorkCount;
  final int pendingWorkCount;
  final int overdueWorkCount;
  final int atRiskGoalsCount;

  const TeamProductivitySummaryItem({
    required this.teamName,
    required this.managerName,
    required this.memberCount,
    required this.goalsAssigned,
    required this.goalsCompleted,
    required this.achievementPercent,
    required this.productivityPercent,
    required this.completedWorkCount,
    required this.pendingWorkCount,
    required this.overdueWorkCount,
    required this.atRiskGoalsCount,
  });
}

class IndividualProductivityItem {
  final String employeeId;
  final String employeeName;
  final String role;
  final String department;
  final String team;
  final int goalsAssigned;
  final int goalsCompleted;
  final double achievementPercent;
  final int tasksCompleted;
  final int projectsCompleted;
  final int serviceJobsCompleted;
  final int designsCompleted;
  final double workHours;
  final double productiveHours;
  final double productivityPercent;
  final int overdueWorkCount;

  const IndividualProductivityItem({
    required this.employeeId,
    required this.employeeName,
    required this.role,
    required this.department,
    required this.team,
    required this.goalsAssigned,
    required this.goalsCompleted,
    required this.achievementPercent,
    required this.tasksCompleted,
    required this.projectsCompleted,
    required this.serviceJobsCompleted,
    required this.designsCompleted,
    required this.workHours,
    required this.productiveHours,
    required this.productivityPercent,
    required this.overdueWorkCount,
  });
}

class GoalDetailRecordItem {
  final String goalId;
  final String goalName;
  final String goalType; // 'Revenue', 'Projects', 'Service', 'Design', 'Hiring'
  final String ownerName;
  final String department;
  final String team;
  final String startDate;
  final String dueDate;
  final double targetValue;
  final double actualValue;
  final String unit;
  final double achievementPercent;
  final String variance;
  final String status;
  final Color statusColor;
  final String priority;
  final Color priorityColor;
  final String lastUpdated;

  const GoalDetailRecordItem({
    required this.goalId,
    required this.goalName,
    required this.goalType,
    required this.ownerName,
    required this.department,
    required this.team,
    required this.startDate,
    required this.dueDate,
    required this.targetValue,
    required this.actualValue,
    required this.unit,
    required this.achievementPercent,
    required this.variance,
    required this.status,
    required this.statusColor,
    required this.priority,
    required this.priorityColor,
    required this.lastUpdated,
  });
}

class AtRiskGoalItem {
  final String goalId;
  final String goalName;
  final String ownerName;
  final String department;
  final String targetValue;
  final String currentAchievement;
  final String remainingValue;
  final String dueDate;
  final int daysRemaining;
  final String riskStatus;
  final Color riskColor;
  final String blockerNotes;

  const AtRiskGoalItem({
    required this.goalId,
    required this.goalName,
    required this.ownerName,
    required this.department,
    required this.targetValue,
    required this.currentAchievement,
    required this.remainingValue,
    required this.dueDate,
    required this.daysRemaining,
    required this.riskStatus,
    required this.riskColor,
    required this.blockerNotes,
  });
}
