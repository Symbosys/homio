import 'package:flutter/material.dart';
import 'dashboard_models.dart';

/// Seed Generator producing rich enterprise data for Homio Dashboard & Submenus.
abstract class DashboardMockData {
  // 1. Overview KPIs
  static const List<DashboardKpiMetric> overviewKpis = [
    DashboardKpiMetric(
      id: 'kpi_productivity',
      title: 'Productivity Score',
      value: '94.2%',
      changeText: '+6.4% vs last week',
      isPositive: true,
      icon: Icons.speed_rounded,
      color: Color(0xFF10B981),
      subtitle: 'Target: 90.0% • Grade A+',
      sparklinePoints: [78, 82, 85, 84, 89, 91, 94.2],
    ),
    DashboardKpiMetric(
      id: 'kpi_tasks',
      title: "Today's Tasks",
      value: '18 Tasks',
      changeText: '12 Done • 6 Pending',
      isPositive: true,
      icon: Icons.checklist_rtl_rounded,
      color: Color(0xFF6366F1),
      subtitle: '3 High Priority Sites',
      sparklinePoints: [10, 12, 14, 11, 15, 13, 18],
    ),
    DashboardKpiMetric(
      id: 'kpi_followups',
      title: 'Active Followups',
      value: '8 Leads',
      changeText: '4 Hot • 2 Booked',
      isPositive: true,
      icon: Icons.phone_forwarded_rounded,
      color: Color(0xFFF59E0B),
      subtitle: 'Avg response: 4.2m',
      sparklinePoints: [12, 11, 9, 10, 8, 9, 8],
    ),
    DashboardKpiMetric(
      id: 'kpi_wallet',
      title: 'Monthly Earnings',
      value: '₹88,500',
      changeText: '+₹18,500 Incentive',
      isPositive: true,
      icon: Icons.account_balance_wallet_rounded,
      color: Color(0xFF0EA5E9),
      subtitle: 'Wallet: ₹42,500',
      sparklinePoints: [60000, 65000, 71000, 78000, 82000, 85000, 88500],
    ),
  ];

  // 2. Tasks KPIs
  static const List<DashboardKpiMetric> taskKpis = [
    DashboardKpiMetric(
      id: 't_assigned',
      title: 'Assigned Tasks',
      value: '18',
      changeText: 'Today total',
      isPositive: true,
      icon: Icons.assignment_outlined,
      color: Color(0xFF6366F1),
    ),
    DashboardKpiMetric(
      id: 't_done',
      title: 'Completed Today',
      value: '12',
      changeText: '66.7% Velocity',
      isPositive: true,
      icon: Icons.check_circle_outline,
      color: Color(0xFF10B981),
    ),
    DashboardKpiMetric(
      id: 't_fup',
      title: 'Pending Followups',
      value: '6',
      changeText: '3 High urgency',
      isPositive: true,
      icon: Icons.phone_callback_outlined,
      color: Color(0xFFF59E0B),
    ),
    DashboardKpiMetric(
      id: 't_overdue',
      title: 'Overdue Reminders',
      value: '1',
      changeText: 'Needs attention',
      isPositive: false,
      icon: Icons.warning_amber_rounded,
      color: Color(0xFFEF4444),
    ),
  ];

  // 3. Attendance KPIs
  static const List<DashboardKpiMetric> attendanceKpis = [
    DashboardKpiMetric(
      id: 'att_present',
      title: 'Days Present',
      value: '22 / 24',
      changeText: '91.6% Attendance',
      isPositive: true,
      icon: Icons.calendar_month_outlined,
      color: Color(0xFF10B981),
    ),
    DashboardKpiMetric(
      id: 'att_late',
      title: 'Late Marks',
      value: '1',
      changeText: 'Within grace limit',
      isPositive: true,
      icon: Icons.alarm,
      color: Color(0xFFF59E0B),
    ),
    DashboardKpiMetric(
      id: 'att_ot',
      title: 'Overtime Hours',
      value: '+6.5 hrs',
      changeText: 'Approved credit',
      isPositive: true,
      icon: Icons.more_time,
      color: Color(0xFF6366F1),
    ),
    DashboardKpiMetric(
      id: 'att_avg',
      title: 'Avg Work Hours',
      value: '8.6 h/d',
      changeText: 'Target: 8.0 hrs',
      isPositive: true,
      icon: Icons.timelapse,
      color: Color(0xFF0EA5E9),
    ),
  ];

  // 4. Travel KPIs
  static const List<DashboardKpiMetric> travelKpis = [
    DashboardKpiMetric(
      id: 'trv_visits',
      title: 'Total Site Visits',
      value: '32',
      changeText: '+8 vs last month',
      isPositive: true,
      icon: Icons.location_city_outlined,
      color: Color(0xFF0EA5E9),
    ),
    DashboardKpiMetric(
      id: 'trv_distance',
      title: 'Distance Logged',
      value: '486 km',
      changeText: 'Verified GPS routes',
      isPositive: true,
      icon: Icons.route_outlined,
      color: Color(0xFF6366F1),
    ),
    DashboardKpiMetric(
      id: 'trv_claim',
      title: 'Fuel Reimbursement',
      value: '₹4,860',
      changeText: '₹10 / km policy',
      isPositive: true,
      icon: Icons.local_gas_station_outlined,
      color: Color(0xFF10B981),
    ),
    DashboardKpiMetric(
      id: 'trv_accuracy',
      title: 'Route Accuracy',
      value: '99.2%',
      changeText: 'Geofence validated',
      isPositive: true,
      icon: Icons.verified_outlined,
      color: Color(0xFF8B5CF6),
    ),
  ];

  // 5. Wallet KPIs
  static const List<DashboardKpiMetric> walletKpis = [
    DashboardKpiMetric(
      id: 'w_salary',
      title: 'Base Fixed Salary',
      value: '₹65,000',
      changeText: 'Credited 1st of month',
      isPositive: true,
      icon: Icons.payments_outlined,
      color: Color(0xFF0EA5E9),
    ),
    DashboardKpiMetric(
      id: 'w_incentives',
      title: 'Earned Commission',
      value: '₹28,500',
      changeText: '+34% vs last cycle',
      isPositive: true,
      icon: Icons.trending_up,
      color: Color(0xFF10B981),
    ),
    DashboardKpiMetric(
      id: 'w_travel',
      title: 'Reimbursements',
      value: '₹4,860',
      changeText: 'Approved & Settled',
      isPositive: true,
      icon: Icons.receipt_long_outlined,
      color: Color(0xFF6366F1),
    ),
    DashboardKpiMetric(
      id: 'w_deductions',
      title: 'Total Deductions',
      value: '₹0.00',
      changeText: 'Zero penalty recorded',
      isPositive: true,
      icon: Icons.verified_user_outlined,
      color: Color(0xFF10B981),
    ),
  ];

  // Productivity Score Detail
  static const ProductivityScoreData productivityScore = ProductivityScoreData(
    score: 94.2,
    grade: 'A+ High Efficiency',
    tasksCompleted: 12,
    totalTasks: 18,
    followupsCompleted: 6,
    totalFollowups: 8,
    siteMeetingsDone: 3,
    scoreChange: 6.4,
  );

  // Today's Tasks
  static const List<DashboardTaskItem> tasks = [
    DashboardTaskItem(
      id: 'task_1',
      title: 'Inspect BWP Marine Carcass Leveling & RO Drain Seal',
      clientName: 'Sunita & Vikram Reddy (Villa 402)',
      siteAddress: 'Palm Heights, Whitefield, Bangalore',
      category: 'Site Inspection',
      priority: 'urgent',
      dueTime: '11:30 AM',
      isCompleted: false,
      checklistCompleted: 2,
      checklistTotal: 4,
      assignedTo: 'You',
    ),
    DashboardTaskItem(
      id: 'task_2',
      title: 'Approve 3D Render Options for Master Bedroom Louvered Wardrobe',
      clientName: 'Dr. Anand Deshmukh (Penthouse 1204)',
      siteAddress: 'Prestige Lakeside, Varthur',
      category: 'Design Review',
      priority: 'high',
      dueTime: '01:00 PM',
      isCompleted: true,
      checklistCompleted: 3,
      checklistTotal: 3,
      assignedTo: 'You',
    ),
    DashboardTaskItem(
      id: 'task_3',
      title: 'Verify 20-Amp Dedicated Circuit Wiring for Open Island Chimney',
      clientName: 'Mehta Luxury Residence (Villa 18)',
      siteAddress: 'Adarsh Palm Retreat, Bellandur',
      category: 'Electrical Audit',
      priority: 'high',
      dueTime: '03:30 PM',
      isCompleted: false,
      checklistCompleted: 1,
      checklistTotal: 3,
      assignedTo: 'You',
    ),
    DashboardTaskItem(
      id: 'task_4',
      title: 'Client BOQ Cost Sign-Off Meeting (Veneer vs Acrylic Upgrade)',
      clientName: 'Amitav & Shweta Sen (Flat 602)',
      siteAddress: 'Sobha Dream Acres, Panathur',
      category: 'Client Meeting',
      priority: 'medium',
      dueTime: '05:00 PM',
      isCompleted: false,
      checklistCompleted: 0,
      checklistTotal: 2,
      assignedTo: 'You',
    ),
    DashboardTaskItem(
      id: 'task_5',
      title: 'Dispatch Batch 2 Saint-Gobain 12.5mm MR Gypsum Boards & GI Channels',
      clientName: 'Godrej Air Tower 4 (Apt 801)',
      siteAddress: 'Hoodi Circle, ITPL Main Road',
      category: 'Procurement',
      priority: 'medium',
      dueTime: '06:00 PM',
      isCompleted: true,
      checklistCompleted: 2,
      checklistTotal: 2,
      assignedTo: 'You',
    ),
    DashboardTaskItem(
      id: 'task_6',
      title: 'Issue Stage 2 Carpentry Progress Certificate for Client Invoicing',
      clientName: 'Sunita & Vikram Reddy (Villa 402)',
      siteAddress: 'Palm Heights, Whitefield, Bangalore',
      category: 'Billing',
      priority: 'low',
      dueTime: '07:00 PM',
      isCompleted: false,
      checklistCompleted: 1,
      checklistTotal: 2,
      assignedTo: 'You',
    ),
  ];

  // Followups
  static const List<DashboardFollowupItem> followups = [
    DashboardFollowupItem(
      id: 'fup_1',
      clientName: 'Kunal Singhal',
      phone: '+91 98450 11223',
      projectName: '4BHK Duplex Villa Turnkey Interior',
      budgetRange: '₹35 – ₹42 Lakhs',
      lastContact: 'Yesterday • WhatsApp Demo Render Sent',
      scheduledTime: 'Today • 11:45 AM',
      sentiment: 'hot',
      notes: 'Wants to finalize German hardware package (Blum vs Hettich) & confirm 50-day delivery guarantee.',
    ),
    DashboardFollowupItem(
      id: 'fup_2',
      clientName: 'Ananya & Rohan Iyer',
      phone: '+91 98860 33445',
      projectName: '3BHK Modular Kitchen & Master Suite',
      budgetRange: '₹16 – ₹20 Lakhs',
      lastContact: '2 days ago • Vastu Diagnostic Report Shared',
      scheduledTime: 'Today • 02:30 PM',
      sentiment: 'hot',
      notes: 'Reviewed South-East kitchen layout. Ready to pay booking token of ₹50,000 upon contract signing.',
    ),
    DashboardFollowupItem(
      id: 'fup_3',
      clientName: 'Col. Ravinder Bakshi',
      phone: '+91 99001 77889',
      projectName: 'Living Room Acoustic Paneling & Bar Console',
      budgetRange: '₹8 – ₹11 Lakhs',
      lastContact: 'Aug 30 • On-Site Measurement Taken',
      scheduledTime: 'Today • 04:15 PM',
      sentiment: 'warm',
      notes: 'Requested value-engineering recommendation on PU Polish vs High-Gloss Acrylic louvers.',
    ),
    DashboardFollowupItem(
      id: 'fup_4',
      clientName: 'Priya & Deepankar Ray',
      phone: '+91 97412 55667',
      projectName: 'Complete 3BHK Woodwork & False Ceiling',
      budgetRange: '₹22 – ₹26 Lakhs',
      lastContact: 'Aug 28 • Meta Ad Lead Capture',
      scheduledTime: 'Tomorrow • 10:30 AM',
      sentiment: 'scheduled',
      notes: 'Site visit scheduled at Sobha Windsor. Physical CAD floor plan printouts to be carried.',
    ),
  ];

  // Attendance Records
  static const List<AttendanceRecord> attendanceRecords = [
    AttendanceRecord(
      id: 'att_1',
      date: 'Sep 6, 2026',
      inTime: '09:30 AM',
      outTime: 'Active Session',
      hoursWorked: 5.8,
      status: 'present',
      location: 'Homio HQ (Indiranagar)',
      isGeofenceVerified: true,
    ),
    AttendanceRecord(
      id: 'att_2',
      date: 'Sep 5, 2026',
      inTime: '09:15 AM',
      outTime: '06:45 PM',
      hoursWorked: 8.5,
      status: 'present',
      location: 'Homio HQ (Indiranagar)',
      isGeofenceVerified: true,
    ),
    AttendanceRecord(
      id: 'att_3',
      date: 'Sep 4, 2026',
      inTime: '08:50 AM',
      outTime: '07:15 PM',
      hoursWorked: 9.4,
      status: 'on_duty',
      location: 'Prestige Lakeside (Site)',
      isGeofenceVerified: true,
    ),
    AttendanceRecord(
      id: 'att_4',
      date: 'Sep 3, 2026',
      inTime: '09:42 AM',
      outTime: '06:30 PM',
      hoursWorked: 7.8,
      status: 'late',
      location: 'Homio HQ (Indiranagar)',
      isGeofenceVerified: true,
    ),
    AttendanceRecord(
      id: 'att_5',
      date: 'Sep 2, 2026',
      inTime: '09:02 AM',
      outTime: '06:40 PM',
      hoursWorked: 8.6,
      status: 'present',
      location: 'Sobha Dream Acres (Site)',
      isGeofenceVerified: true,
    ),
    AttendanceRecord(
      id: 'att_6',
      date: 'Sep 1, 2026',
      inTime: '09:10 AM',
      outTime: '06:50 PM',
      hoursWorked: 8.7,
      status: 'present',
      location: 'Homio HQ (Indiranagar)',
      isGeofenceVerified: true,
    ),
  ];

  // Field Visits
  static const List<FieldVisitItem> fieldVisits = [
    FieldVisitItem(
      id: 'visit_1',
      clientName: 'Vikram Reddy (Villa 402)',
      siteLocation: 'Palm Heights, Whitefield',
      purpose: 'Structural Inspection',
      distanceKm: 14.5,
      visitDate: 'Today 10:30 AM',
      reimbursementAmount: 145.0,
      status: 'completed',
    ),
    FieldVisitItem(
      id: 'visit_2',
      clientName: 'Dr. Anand Deshmukh (1204)',
      siteLocation: 'Prestige Lakeside, Varthur',
      purpose: 'Client Walkthrough',
      distanceKm: 18.2,
      visitDate: 'Today 01:00 PM',
      reimbursementAmount: 182.0,
      status: 'completed',
    ),
    FieldVisitItem(
      id: 'visit_3',
      clientName: 'Mehta Residence (Villa 18)',
      siteLocation: 'Adarsh Palm Retreat, Bellandur',
      purpose: 'Material Audit',
      distanceKm: 9.8,
      visitDate: 'Today 03:30 PM',
      reimbursementAmount: 98.0,
      status: 'in transit',
    ),
    FieldVisitItem(
      id: 'visit_4',
      clientName: 'Amitav Sen (Flat 602)',
      siteLocation: 'Sobha Dream Acres, Panathur',
      purpose: 'Site Measurement',
      distanceKm: 12.0,
      visitDate: 'Tomorrow 10:00 AM',
      reimbursementAmount: 120.0,
      status: 'pending',
    ),
  ];

  // Wallet Transactions
  static const List<WalletTransaction> walletTransactions = [
    WalletTransaction(
      id: 'TXN-9802',
      title: 'Booking Incentive: Kunal Singhal (Villa)',
      category: 'Sales Commission',
      amount: 5000.0,
      isCredit: true,
      date: 'Sep 4, 2026',
      status: 'settled',
      referenceId: 'HOM-INC-8902',
    ),
    WalletTransaction(
      id: 'TXN-4410',
      title: 'Site Visit Mileage Reimbursement (Aug 25 - 31)',
      category: 'Travel Allowance',
      amount: 1640.0,
      isCredit: true,
      date: 'Sep 2, 2026',
      status: 'settled',
      referenceId: 'HOM-TRV-4410',
    ),
    WalletTransaction(
      id: 'TXN-1109',
      title: 'Weekly Wallet Withdrawal to HDFC Bank (A/C **4892)',
      category: 'Bank Transfer',
      amount: 8000.0,
      isCredit: false,
      date: 'Aug 30, 2026',
      status: 'settled',
      referenceId: 'HOM-WDR-1109',
    ),
    WalletTransaction(
      id: 'TXN-7781',
      title: 'Stage 2 Quality Delivery Bonus (Villa 402)',
      category: 'Milestone Bonus',
      amount: 3500.0,
      isCredit: true,
      date: 'Aug 28, 2026',
      status: 'settled',
      referenceId: 'HOM-BON-7781',
    ),
  ];

  // Department Workloads
  static const List<DepartmentWorkload> departmentWorkloads = [
    DepartmentWorkload(departmentName: 'Site Execution', activeCount: 18, percentage: 36.0, color: Color(0xFF10B981)),
    DepartmentWorkload(departmentName: 'Sales & Leads', activeCount: 12, percentage: 24.0, color: Color(0xFF6366F1)),
    DepartmentWorkload(departmentName: '3D & CAD Design', activeCount: 10, percentage: 20.0, color: Color(0xFF0EA5E9)),
    DepartmentWorkload(departmentName: 'Procurement', activeCount: 6, percentage: 12.0, color: Color(0xFFF59E0B)),
    DepartmentWorkload(departmentName: 'Client Billing', activeCount: 4, percentage: 8.0, color: Color(0xFF8B5CF6)),
  ];

  // 30-Day Velocity Trend
  static const List<({int day, double score})> velocityTrend30Days = [
    (day: 1, score: 82.0),
    (day: 5, score: 85.5),
    (day: 10, score: 88.0),
    (day: 15, score: 86.2),
    (day: 20, score: 91.0),
    (day: 25, score: 92.4),
    (day: 30, score: 94.2),
  ];

  // Weekly Task Stats
  static const List<({String day, int completed, int target})> weeklyTaskStats = [
    (day: 'Mon', completed: 8, target: 10),
    (day: 'Tue', completed: 11, target: 10),
    (day: 'Wed', completed: 9, target: 10),
    (day: 'Thu', completed: 13, target: 10),
    (day: 'Fri', completed: 12, target: 10),
    (day: 'Sat', completed: 9, target: 10),
  ];

  // Followup Conversion Trend
  static const List<({int week, double rate})> followupConversionTrend = [
    (week: 1, rate: 42.0),
    (week: 2, rate: 55.0),
    (week: 3, rate: 68.0),
    (week: 4, rate: 75.5),
  ];

  // Attendance Hours Past 30 Days
  static const List<({int day, double hours})> attendanceHoursPast30Days = [
    (day: 1, hours: 8.5),
    (day: 3, hours: 9.0),
    (day: 5, hours: 8.2),
    (day: 8, hours: 8.7),
    (day: 10, hours: 9.2),
    (day: 12, hours: 8.0),
    (day: 15, hours: 8.8),
    (day: 18, hours: 9.5),
    (day: 20, hours: 8.4),
    (day: 22, hours: 8.6),
    (day: 25, hours: 9.1),
    (day: 28, hours: 8.3),
    (day: 30, hours: 8.6),
  ];

  // Travel Mileage Trend
  static const List<({int day, double km})> travelMileageTrend = [
    (day: 1, km: 12.0),
    (day: 5, km: 18.5),
    (day: 10, km: 24.0),
    (day: 15, km: 15.2),
    (day: 20, km: 28.0),
    (day: 25, km: 22.4),
    (day: 30, km: 32.5),
  ];

  // 6-Month Incentive Progression
  static const List<({String month, double amount})> sixMonthIncentiveProgression = [
    (month: 'Apr', amount: 14000),
    (month: 'May', amount: 18500),
    (month: 'Jun', amount: 21000),
    (month: 'Jul', amount: 24500),
    (month: 'Aug', amount: 26000),
    (month: 'Sep', amount: 28500),
  ];
}
