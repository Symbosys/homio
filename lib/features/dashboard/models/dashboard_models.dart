import 'package:flutter/material.dart';

/// Enum for Date Range Filtering on Dashboard Screens
enum DashboardDateFilter {
  today('Today', 'Sep 6, 2026'),
  thisWeek('This Week', 'Aug 31 – Sep 6, 2026'),
  thisMonth('This Month', 'September 2026'),
  month('This Month', 'September 2026'),
  custom('Custom Range', 'Select Dates');

  final String label;
  final String dateRangeDisplay;
  const DashboardDateFilter(this.label, this.dateRangeDisplay);
}

/// KPI Metric Card Model
class DashboardKpiMetric {
  final String id;
  final String title;
  final String value;
  final String changeText;
  final bool isPositive;
  final IconData icon;
  final Color color;
  final String? subtitle;
  final List<double>? sparklinePoints;

  const DashboardKpiMetric({
    required this.id,
    required this.title,
    required this.value,
    required this.changeText,
    required this.isPositive,
    required this.icon,
    required this.color,
    this.subtitle,
    this.sparklinePoints,
  });
}

/// Productivity Score Details
class ProductivityScoreData {
  final double score; // 0.0 to 100.0
  final String grade; // e.g. "A+ Auspicious"
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

/// Task Priority Level
enum TaskPriority {
  urgent('Urgent', Color(0xFFEF4444), Icons.priority_high_rounded),
  high('High', Color(0xFFF97316), Icons.arrow_upward_rounded),
  medium('Medium', Color(0xFF3B82F6), Icons.remove_rounded),
  low('Low', Color(0xFF10B981), Icons.arrow_downward_rounded);

  final String label;
  final Color color;
  final IconData icon;
  const TaskPriority(this.label, this.color, this.icon);
}

/// Task Department
enum TaskDepartment {
  sales('Sales & Leads', Color(0xFF6366F1)),
  design('3D / CAD Design', Color(0xFF0EA5E9)),
  execution('Site Execution', Color(0xFF10B981)),
  procurement('Material & Vendor', Color(0xFFF59E0B)),
  billing('Client Accounts', Color(0xFF8B5CF6));

  final String label;
  final Color color;
  const TaskDepartment(this.label, this.color);
}

/// Dashboard Task Item
class DashboardTaskItem {
  final String id;
  final String title;
  final String clientName;
  final String siteAddress;
  final String category;
  final String priority;
  final String dueTime;
  final bool isCompleted;
  final int checklistCompleted;
  final int checklistTotal;
  final String assignedTo;

  const DashboardTaskItem({
    required this.id,
    required this.title,
    required this.clientName,
    this.siteAddress = 'Bangalore',
    this.category = 'Execution',
    this.priority = 'high',
    required this.dueTime,
    this.isCompleted = false,
    this.checklistCompleted = 0,
    this.checklistTotal = 0,
    this.assignedTo = 'You',
  });

  Color get priorityColor {
    switch (priority.toLowerCase()) {
      case 'urgent':
        return const Color(0xFFEF4444);
      case 'high':
        return const Color(0xFFF97316);
      case 'medium':
        return const Color(0xFF3B82F6);
      case 'low':
      default:
        return const Color(0xFF10B981);
    }
  }

  DashboardTaskItem copyWith({
    String? id,
    String? title,
    String? clientName,
    String? siteAddress,
    String? category,
    String? priority,
    String? dueTime,
    bool? isCompleted,
    int? checklistCompleted,
    int? checklistTotal,
    String? assignedTo,
  }) {
    return DashboardTaskItem(
      id: id ?? this.id,
      title: title ?? this.title,
      clientName: clientName ?? this.clientName,
      siteAddress: siteAddress ?? this.siteAddress,
      category: category ?? this.category,
      priority: priority ?? this.priority,
      dueTime: dueTime ?? this.dueTime,
      isCompleted: isCompleted ?? this.isCompleted,
      checklistCompleted: checklistCompleted ?? this.checklistCompleted,
      checklistTotal: checklistTotal ?? this.checklistTotal,
      assignedTo: assignedTo ?? this.assignedTo,
    );
  }
}

/// Followup Urgency Status
enum FollowupUrgency {
  hot('Hot Lead', Color(0xFFEF4444)),
  warm('Warm Lead', Color(0xFFF59E0B)),
  nurturing('Nurturing', Color(0xFF0EA5E9)),
  scheduled('Meeting Booked', Color(0xFF10B981));

  final String label;
  final Color color;
  const FollowupUrgency(this.label, this.color);
}

/// Dashboard Followup Queue Item
class DashboardFollowupItem {
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

  const DashboardFollowupItem({
    required this.id,
    required this.clientName,
    required this.phone,
    this.projectName = 'Turnkey Interior',
    this.budgetRange = '₹18 – ₹25 Lakhs',
    this.lastContact = 'Yesterday',
    required this.scheduledTime,
    this.sentiment = 'hot',
    required this.notes,
    this.isDone = false,
  });

  Color get sentimentColor {
    switch (sentiment.toLowerCase()) {
      case 'hot':
        return const Color(0xFFEF4444);
      case 'warm':
        return const Color(0xFFF59E0B);
      case 'scheduled':
        return const Color(0xFF10B981);
      default:
        return const Color(0xFF0EA5E9);
    }
  }

  DashboardFollowupItem copyWith({
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
  }) {
    return DashboardFollowupItem(
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
    );
  }
}

/// Daily Attendance Record
class AttendanceRecord {
  final String id;
  final String date;
  final String inTime;
  final String outTime;
  final double hoursWorked;
  final String status; // "present", "late", "leave", "on_duty"
  final String location;
  final bool isGeofenceVerified;

  const AttendanceRecord({
    required this.id,
    required this.date,
    required this.inTime,
    required this.outTime,
    required this.hoursWorked,
    this.status = 'present',
    required this.location,
    this.isGeofenceVerified = true,
  });

  Color get statusColor {
    switch (status.toLowerCase()) {
      case 'present':
        return const Color(0xFF10B981);
      case 'on_duty':
        return const Color(0xFF0EA5E9);
      case 'late':
      case 'late arrival':
        return const Color(0xFFF59E0B);
      case 'leave':
        return const Color(0xFF8B5CF6);
      case 'absent':
      default:
        return const Color(0xFFEF4444);
    }
  }
}

/// Field Visit Item
class FieldVisitItem {
  final String id;
  final String clientName;
  final String siteLocation;
  final String purpose;
  final double distanceKm;
  final String visitDate;
  final double reimbursementAmount;
  final String status; // "completed", "in transit", "approved", "pending"

  const FieldVisitItem({
    required this.id,
    required this.clientName,
    required this.siteLocation,
    required this.purpose,
    required this.distanceKm,
    this.visitDate = 'Today',
    required this.reimbursementAmount,
    this.status = 'approved',
  });

  Color get statusColor {
    switch (status.toLowerCase()) {
      case 'approved':
      case 'completed':
        return const Color(0xFF10B981);
      case 'in transit':
      case 'in_transit':
        return const Color(0xFF2563EB);
      case 'pending':
        return const Color(0xFFF59E0B);
      default:
        return const Color(0xFF64748B);
    }
  }
}

/// Wallet Transaction Model
class WalletTransaction {
  final String id;
  final String title;
  final String category;
  final double amount;
  final bool isCredit;
  final String date;
  final String status; // "settled", "processing", "in review"
  final String referenceId;

  const WalletTransaction({
    required this.id,
    required this.title,
    required this.category,
    required this.amount,
    required this.isCredit,
    this.date = 'Today',
    this.status = 'settled',
    this.referenceId = 'REF-001',
  });

  Color get statusColor {
    switch (status.toLowerCase()) {
      case 'settled':
        return const Color(0xFF10B981);
      case 'processing':
        return const Color(0xFF2563EB);
      case 'in review':
      case 'pending':
        return const Color(0xFFF59E0B);
      default:
        return const Color(0xFFEF4444);
    }
  }
}

/// Department Workload Distribution for Donut Chart
class DepartmentWorkload {
  final String departmentName;
  final int activeCount;
  final double percentage;
  final Color color;

  const DepartmentWorkload({
    required this.departmentName,
    required this.activeCount,
    required this.percentage,
    required this.color,
  });
}
