import 'package:flutter/material.dart';

/// Supported Date Range Filter options for Dashboard.
enum DashboardDateFilter {
  today('Today', 'Today, Sep 8'),
  thisWeek('This Week', 'Aug 31 – Sep 8'),
  thisMonth('This Month', 'September 2026'),
  custom('Custom Range', 'Select Range');

  final String label;
  final String dateRangeDisplay;
  const DashboardDateFilter(this.label, this.dateRangeDisplay);
}

/// Seniority/RBAC based Scope Filter for Dashboard telemetry.
enum DashboardScopeFilter {
  myWork('My Work', 'Personal performance & tasks'),
  myTeam('My Team', 'Direct team & department metrics'),
  organization('Organization', 'Company-wide enterprise stats');

  final String label;
  final String description;
  const DashboardScopeFilter(this.label, this.description);
}

/// Operational Alert Severity levels.
enum AlertSeverity {
  critical('Critical', Color(0xFFEF4444), Icons.error_outline_rounded),
  high('High', Color(0xFFF97316), Icons.warning_amber_rounded),
  medium('Medium', Color(0xFFF59E0B), Icons.info_outline_rounded),
  low('Low', Color(0xFF3B82F6), Icons.notifications_none_rounded);

  final String label;
  final Color color;
  final IconData icon;
  const AlertSeverity(this.label, this.color, this.icon);
}

/// Task Priority Level.
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

/// Task Workflow Status for Kanban and Lists.
enum TaskStatus {
  todo('To Do', Color(0xFF64748B), Icons.circle_outlined),
  inProgress('In Progress', Color(0xFF3B82F6), Icons.timelapse_rounded),
  waiting('Waiting', Color(0xFFF59E0B), Icons.pause_circle_outline_rounded),
  completed('Completed', Color(0xFF10B981), Icons.check_circle_rounded);

  final String label;
  final Color color;
  final IconData icon;
  const TaskStatus(this.label, this.color, this.icon);
}

/// Daily Attendance Punch Status.
enum AttendanceStatus {
  present('Present', Color(0xFF10B981)),
  late('Late Arrival', Color(0xFFF59E0B)),
  halfDay('Half Day', Color(0xFF8B5CF6)),
  onDuty('On Duty (Site)', Color(0xFF0EA5E9)),
  leave('On Leave', Color(0xFFEC4899)),
  absent('Absent', Color(0xFFEF4444)),
  holiday('Holiday', Color(0xFF64748B));

  final String label;
  final Color color;
  const AttendanceStatus(this.label, this.color);
}

/// Travel & Mileage Status.
enum TravelStatus {
  completed('Completed', Color(0xFF10B981)),
  inTransit('In Transit', Color(0xFF2563EB)),
  approved('Claim Approved', Color(0xFF10B981)),
  pending('Claim Pending', Color(0xFFF59E0B)),
  rejected('Rejected', Color(0xFFEF4444));

  final String label;
  final Color color;
  const TravelStatus(this.label, this.color);
}

/// Operational Wallet & Reimbursement Transaction Categories.
enum TransactionCategory {
  travel('Travel Reimbursement', Color(0xFF2563EB), Icons.commute_rounded),
  pettyCash('Petty Cash', Color(0xFF10B981), Icons.local_atm_rounded),
  siteExpense('Site Expense', Color(0xFFF59E0B), Icons.handyman_rounded),
  reimbursement('Reimbursement Payout', Color(0xFF8B5CF6), Icons.receipt_long_rounded),
  incentive('Earned Incentive', Color(0xFF059669), Icons.military_tech_rounded),
  adjustment('Adjustment', Color(0xFF64748B), Icons.tune_rounded),
  deduction('Deduction', Color(0xFFEF4444), Icons.remove_circle_outline_rounded);

  final String label;
  final Color color;
  final IconData icon;
  const TransactionCategory(this.label, this.color, this.icon);
}
