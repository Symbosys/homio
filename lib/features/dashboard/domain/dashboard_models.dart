import 'package:flutter/material.dart';
import 'dashboard_enums.dart';

/// Calculation & metrics for Productivity Score.
class ProductivityMetrics {
  final int tasksCompleted;
  final int totalTasks;
  final int followupsCompleted;
  final int totalFollowups;
  final double previousPeriodScore;
  final String calculationMethod;

  const ProductivityMetrics({
    required this.tasksCompleted,
    required this.totalTasks,
    required this.followupsCompleted,
    required this.totalFollowups,
    required this.previousPeriodScore,
    this.calculationMethod = '60% Task Execution + 40% Follow-up Velocity',
  });

  /// Dynamic calculation of productivity score based on PRD formula.
  double get score {
    final taskRatio = totalTasks > 0 ? (tasksCompleted / totalTasks).clamp(0.0, 1.0) : 1.0;
    final followupRatio = totalFollowups > 0 ? (followupsCompleted / totalFollowups).clamp(0.0, 1.0) : 1.0;
    final calculated = ((taskRatio * 0.60) + (followupRatio * 0.40)) * 100.0;
    return double.parse(calculated.toStringAsFixed(1));
  }

  /// Score variance compared to prior period.
  double get scoreChange {
    return double.parse((score - previousPeriodScore).toStringAsFixed(1));
  }

  bool get isPositiveChange => scoreChange >= 0;

  String get performanceBadge {
    if (score >= 90) return 'Top Performer (A+)';
    if (score >= 75) return 'Strong Execution (A)';
    if (score >= 60) return 'Meets Target (B)';
    return 'Attention Required';
  }
}

/// Productivity Score Data used for radial gauge and breakdown.
class ProductivityScoreData {
  final double score;
  final String grade;
  final int tasksCompleted;
  final int totalTasks;
  final int followupsCompleted;
  final int totalFollowups;
  final int siteMeetingsDone;
  final double scoreChange;

  const ProductivityScoreData({
    required this.score,
    required this.grade,
    required this.tasksCompleted,
    required this.totalTasks,
    required this.followupsCompleted,
    required this.totalFollowups,
    required this.siteMeetingsDone,
    required this.scoreChange,
  });
}

/// Earnings & salary projections for employee.
class EarningsSummary {
  final double baseSalary;
  final double earnedIncentives;
  final double salaryDeductions;
  final List<double> monthlyProgression;

  const EarningsSummary({
    required this.baseSalary,
    required this.earnedIncentives,
    required this.salaryDeductions,
    this.monthlyProgression = const [45000, 48000, 52000, 56000, 59000, 61500],
  });

  /// Total Net Projected = Base + Incentives - Deductions
  double get netProjected => baseSalary + earnedIncentives - salaryDeductions;
}

/// Operational expense wallet and reimbursement totals.
class WalletSummary {
  final double currentBalance;
  final double totalSpent;
  final double pendingReimbursement;
  final double approvedReimbursement;
  final String linkedAccount;

  const WalletSummary({
    required this.currentBalance,
    required this.totalSpent,
    required this.pendingReimbursement,
    required this.approvedReimbursement,
    this.linkedAccount = 'HDFC Bank •••• 4821',
  });
}

/// Attendance and time tracking summary.
class AttendanceSummary {
  final int presentDays;
  final int absentDays;
  final int leaveDays;
  final double totalWorkingHours;
  final double avgDailyHours;
  final bool isClockedIn;
  final DateTime? clockInTime;
  final DateTime? clockOutTime;
  final String clockInLocation;
  final bool isGeofenceVerified;

  const AttendanceSummary({
    required this.presentDays,
    required this.absentDays,
    required this.leaveDays,
    required this.totalWorkingHours,
    required this.avgDailyHours,
    required this.isClockedIn,
    this.clockInTime,
    this.clockOutTime,
    this.clockInLocation = 'HQ — DLF Phase 5 Hub',
    this.isGeofenceVerified = true,
  });
}

/// Lead conversion and sales pipeline counts.
class LeadPulse {
  final int newLeadsAssigned;
  final int followupsPending;
  final int meetingsScheduled;
  final int bookingsClosed;

  const LeadPulse({
    required this.newLeadsAssigned,
    required this.followupsPending,
    required this.meetingsScheduled,
    required this.bookingsClosed,
  });

  int get totalOpportunities =>
      newLeadsAssigned + followupsPending + meetingsScheduled + bookingsClosed;
}

/// High priority operational alert item.
class AlertItem {
  final String id;
  final String title;
  final String subtitle;
  final AlertSeverity severity;
  final String timestampAgo;
  final String actionLabel;
  final String targetRoute;

  const AlertItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.severity,
    required this.timestampAgo,
    required this.actionLabel,
    required this.targetRoute,
  });
}

/// Checklist item under a task.
class TaskChecklistItem {
  final String id;
  final String title;
  final bool isDone;

  const TaskChecklistItem({
    required this.id,
    required this.title,
    this.isDone = false,
  });

  TaskChecklistItem copyWith({String? id, String? title, bool? isDone}) {
    return TaskChecklistItem(
      id: id ?? this.id,
      title: title ?? this.title,
      isDone: isDone ?? this.isDone,
    );
  }
}

/// Activity log/comment under a task.
class TaskComment {
  final String id;
  final String authorName;
  final String authorRole;
  final String text;
  final String timeAgo;

  const TaskComment({
    required this.id,
    required this.authorName,
    required this.authorRole,
    required this.text,
    required this.timeAgo,
  });
}

/// Production Task Item model.
class TaskItem {
  final String id;
  final String title;
  final String description;
  final String clientName;
  final String projectName;
  final TaskPriority priority;
  final TaskStatus status;
  final String dueDate;
  final String dueTime;
  final String assignedTo;
  final String category;
  final List<TaskChecklistItem> checklist;
  final List<TaskComment> comments;
  final List<String> attachments;
  final DateTime? completedAt;

  const TaskItem({
    required this.id,
    required this.title,
    this.description = '',
    required this.clientName,
    required this.projectName,
    this.priority = TaskPriority.high,
    this.status = TaskStatus.inProgress,
    required this.dueDate,
    required this.dueTime,
    this.assignedTo = 'You',
    this.category = 'Execution',
    this.checklist = const [],
    this.comments = const [],
    this.attachments = const [],
    this.completedAt,
  });

  bool get isCompleted => status == TaskStatus.completed;

  int get checklistCompletedCount => checklist.where((c) => c.isDone).length;

  TaskItem copyWith({
    String? id,
    String? title,
    String? description,
    String? clientName,
    String? projectName,
    TaskPriority? priority,
    TaskStatus? status,
    String? dueDate,
    String? dueTime,
    String? assignedTo,
    String? category,
    List<TaskChecklistItem>? checklist,
    List<TaskComment>? comments,
    List<String>? attachments,
    DateTime? completedAt,
  }) {
    return TaskItem(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      clientName: clientName ?? this.clientName,
      projectName: projectName ?? this.projectName,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      dueDate: dueDate ?? this.dueDate,
      dueTime: dueTime ?? this.dueTime,
      assignedTo: assignedTo ?? this.assignedTo,
      category: category ?? this.category,
      checklist: checklist ?? this.checklist,
      comments: comments ?? this.comments,
      attachments: attachments ?? this.attachments,
      completedAt: completedAt ?? this.completedAt,
    );
  }
}

/// Follow-up item for sales / client queue.
class FollowUpItem {
  final String id;
  final String clientName;
  final String phone;
  final String projectName;
  final String budgetRange;
  final String lastContact;
  final String scheduledTime;
  final String sentiment; // "hot", "warm", "nurturing"
  final String notes;
  final bool isDone;
  final String assignedTo;

  const FollowUpItem({
    required this.id,
    required this.clientName,
    required this.phone,
    required this.projectName,
    required this.budgetRange,
    required this.lastContact,
    required this.scheduledTime,
    this.sentiment = 'hot',
    required this.notes,
    this.isDone = false,
    this.assignedTo = 'You',
  });

  FollowUpItem copyWith({
    String? id,
    String? clientName,
    String? phone,
    String? projectName,
    String? budgetRange,
    String? lastContact,
    String? scheduledTime,
    String? sentiment,
    String? notes,
    bool? isDone,
    String? assignedTo,
  }) {
    return FollowUpItem(
      id: id ?? this.id,
      clientName: clientName ?? this.clientName,
      phone: phone ?? this.phone,
      projectName: projectName ?? this.projectName,
      budgetRange: budgetRange ?? this.budgetRange,
      lastContact: lastContact ?? this.lastContact,
      scheduledTime: scheduledTime ?? this.scheduledTime,
      sentiment: sentiment ?? this.sentiment,
      notes: notes ?? this.notes,
      isDone: isDone ?? this.isDone,
      assignedTo: assignedTo ?? this.assignedTo,
    );
  }
}

/// Historical or daily attendance record.
class AttendanceRecord {
  final String id;
  final String date;
  final String inTime;
  final String outTime;
  final double hoursWorked;
  final AttendanceStatus status;
  final String location;
  final bool isGeofenceVerified;

  const AttendanceRecord({
    required this.id,
    required this.date,
    required this.inTime,
    required this.outTime,
    required this.hoursWorked,
    this.status = AttendanceStatus.present,
    required this.location,
    this.isGeofenceVerified = true,
  });
}

/// Field travel and visit record.
class TravelRecord {
  final String id;
  final String date;
  final String fromLocation;
  final String toLocation;
  final String projectName;
  final String clientName;
  final double distanceKm;
  final double ratePerKm;
  final TravelStatus status;
  final String purpose;
  final String departureTime;
  final String arrivalTime;

  const TravelRecord({
    required this.id,
    required this.date,
    required this.fromLocation,
    required this.toLocation,
    required this.projectName,
    required this.clientName,
    required this.distanceKm,
    this.ratePerKm = 12.0,
    this.status = TravelStatus.approved,
    required this.purpose,
    this.departureTime = '10:00 AM',
    this.arrivalTime = '11:15 AM',
  });

  /// Dynamic reimbursement calculation: distanceKm * ratePerKm (rounded to 2 decimals)
  double get reimbursementAmount => double.parse((distanceKm * ratePerKm).toStringAsFixed(2));
}

/// Travel totals and summaries.
class TravelSummary {
  final double totalDistanceKm;
  final int totalVisits;
  final double approvedReimbursement;
  final double pendingReimbursement;
  final double mileageRatePerKm;
  final double thisMonthTotal;

  const TravelSummary({
    required this.totalDistanceKm,
    required this.totalVisits,
    required this.approvedReimbursement,
    required this.pendingReimbursement,
    this.mileageRatePerKm = 12.0,
    required this.thisMonthTotal,
  });
}

/// Operational Wallet Transaction ledger entry.
class WalletTransaction {
  final String id;
  final String title;
  final TransactionCategory category;
  final double amount;
  final bool isCredit;
  final String date;
  final String status; // "settled", "pending", "processing", "rejected"
  final String referenceId;
  final String projectName;
  final String clientName;
  final String approvedBy;
  final String? receiptUrl;

  const WalletTransaction({
    required this.id,
    required this.title,
    required this.category,
    required this.amount,
    required this.isCredit,
    required this.date,
    this.status = 'settled',
    required this.referenceId,
    this.projectName = 'DLF Phase 5 Villa',
    this.clientName = 'Vikram Malhotra',
    this.approvedBy = 'Finance Controller',
    this.receiptUrl,
  });
}

/// Incentive category item.
class IncentiveBreakdownItem {
  final String id;
  final String title;
  final double amount;
  final String rule;
  final String status;
  final IconData icon;

  const IncentiveBreakdownItem({
    required this.id,
    required this.title,
    required this.amount,
    required this.rule,
    this.status = 'Approved',
    this.icon = Icons.star_rounded,
  });
}

/// Aggregated telemetry payload for Overview.
class DashboardSummary {
  final ProductivityMetrics productivity;
  final EarningsSummary earnings;
  final WalletSummary wallet;
  final AttendanceSummary attendance;
  final TravelSummary travel;
  final LeadPulse leadPulse;
  final List<AlertItem> alerts;
  final List<TaskItem> topTasks;
  final List<FollowUpItem> highPriorityFollowups;

  const DashboardSummary({
    required this.productivity,
    required this.earnings,
    required this.wallet,
    required this.attendance,
    required this.travel,
    required this.leadPulse,
    required this.alerts,
    required this.topTasks,
    required this.highPriorityFollowups,
  });
}
