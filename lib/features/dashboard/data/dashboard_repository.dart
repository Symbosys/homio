import 'dart:async';
import '../domain/dashboard_enums.dart';
import '../domain/dashboard_models.dart';

/// Clean repository interface for Dashboard aggregated summary.
abstract class IDashboardRepository {
  Future<DashboardSummary> getSummary({
    required DashboardDateFilter dateFilter,
    required DashboardScopeFilter scopeFilter,
  });
}

/// Production-ready mock implementation of DashboardRepository.
/// Dynamically shifts metrics according to selected date range and RBAC scope.
class DashboardRepository implements IDashboardRepository {
  static final DashboardRepository instance = DashboardRepository._internal();
  DashboardRepository._internal();
  factory DashboardRepository() => instance;

  @override
  Future<DashboardSummary> getSummary({
    required DashboardDateFilter dateFilter,
    required DashboardScopeFilter scopeFilter,
  }) async {
    // Simulate brief network latency for reactive UI feel
    await Future.delayed(const Duration(milliseconds: 150));

    // Scope and date multipliers
    final isTeam = scopeFilter == DashboardScopeFilter.myTeam;
    final isOrg = scopeFilter == DashboardScopeFilter.organization;
    final multiplier = isOrg ? 4.5 : (isTeam ? 2.2 : 1.0);

    // Dynamic metrics matching PRD requirements
    final productivity = ProductivityMetrics(
      tasksCompleted: (18 * multiplier).round(),
      totalTasks: (20 * multiplier).round(),
      followupsCompleted: (42 * multiplier).round(),
      totalFollowups: (45 * multiplier).round(),
      previousPeriodScore: 87.8,
    );

    final earnings = EarningsSummary(
      baseSalary: isOrg ? 45000 * 8 : (isTeam ? 45000 * 3 : 45000),
      earnedIncentives: isOrg ? 18500 * 8 : (isTeam ? 18500 * 3 : 18500),
      salaryDeductions: isOrg ? 2000 * 4 : (isTeam ? 2000 * 2 : 2000),
      monthlyProgression: [
        42000 * multiplier,
        45000 * multiplier,
        49000 * multiplier,
        53000 * multiplier,
        58000 * multiplier,
        61500 * multiplier,
      ],
    );

    final wallet = WalletSummary(
      currentBalance: isOrg ? 12450 * 5 : 12450,
      totalSpent: isOrg ? 38200 * 5 : 38200,
      pendingReimbursement: isOrg ? 4850 * 5 : 4850,
      approvedReimbursement: isOrg ? 8400 * 5 : 8400,
    );

    final attendance = AttendanceSummary(
      presentDays: 22,
      absentDays: 1,
      leaveDays: 2,
      totalWorkingHours: isOrg ? 186.5 * 8 : 186.5,
      avgDailyHours: 8.47,
      isClockedIn: true,
      clockInTime: DateTime(2026, 9, 8, 9, 14),
      clockInLocation: 'HQ — DLF Phase 5 Hub',
      isGeofenceVerified: true,
    );

    final leadPulse = LeadPulse(
      newLeadsAssigned: (14 * multiplier).round(),
      followupsPending: (9 * multiplier).round(),
      meetingsScheduled: (5 * multiplier).round(),
      bookingsClosed: (3 * multiplier).round(),
    );

    final alerts = [
      const AlertItem(
        id: 'ALT-101',
        title: 'Customer complaint unresolved (>24h)',
        subtitle: 'Project #104 — Master bedroom Italian marble tint mismatch reported.',
        severity: AlertSeverity.critical,
        timestampAgo: '26 hours ago',
        actionLabel: 'Resolve Ticket',
        targetRoute: '/operations/complaints',
      ),
      const AlertItem(
        id: 'ALT-102',
        title: 'Physical site visit pending (>10d)',
        subtitle: 'Project #109 (Sobha City) — Structural framing milestone inspection delayed.',
        severity: AlertSeverity.high,
        timestampAgo: '11 days overdue',
        actionLabel: 'Schedule Visit',
        targetRoute: '/dashboard/travel',
      ),
      const AlertItem(
        id: 'ALT-103',
        title: 'Quotation discount expiring in <24 hours',
        subtitle: 'Quote #QT-1024 — 8% festival discount for DLF Magnolias 4BHK villa.',
        severity: AlertSeverity.medium,
        timestampAgo: 'Expires in 18 hours',
        actionLabel: 'Lock Pricing',
        targetRoute: '/quotation/builder',
      ),
      const AlertItem(
        id: 'ALT-104',
        title: 'Denied leave penalty action required',
        subtitle: 'Unauthorized absence detected on Aug 28. Submit regularisation doc.',
        severity: AlertSeverity.critical,
        timestampAgo: 'Action required',
        actionLabel: 'Regularise',
        targetRoute: '/dashboard/attendance',
      ),
    ];

    final topTasks = [
      const TaskItem(
        id: 'TSK-104',
        title: 'Physical Site Inspection — Project #104',
        description: 'Verify false ceiling wiring and AC trunking clearance with site engineer.',
        clientName: 'Rahul Sharma',
        projectName: 'DLF Phase 5 Villa #104',
        priority: TaskPriority.urgent,
        status: TaskStatus.inProgress,
        dueDate: 'Today',
        dueTime: '10:30 AM',
        category: 'Field Visit',
      ),
      const TaskItem(
        id: 'TSK-105',
        title: 'Follow-up Client Call — Rahul Sharma',
        description: 'Review updated modular kitchen material finish samples and quartz countertop.',
        clientName: 'Rahul Sharma',
        projectName: 'DLF Phase 5 Villa #104',
        priority: TaskPriority.high,
        status: TaskStatus.todo,
        dueDate: 'Today',
        dueTime: '11:00 AM',
        category: 'Sales Follow-up',
      ),
      const TaskItem(
        id: 'TSK-106',
        title: 'Quotation Approval & Signoff',
        description: 'Get internal pricing committee approval for bespoke teak panelling discount.',
        clientName: 'Pooja Verma',
        projectName: 'Sobha City Penthouse #402',
        priority: TaskPriority.high,
        status: TaskStatus.todo,
        dueDate: 'Today',
        dueTime: '02:00 PM',
        category: 'Billing & Commercials',
      ),
      const TaskItem(
        id: 'TSK-107',
        title: '3D VR Render Revision Approval',
        description: 'Render double height living room chandelier lighting simulations.',
        clientName: 'Vikramaditya Singhania',
        projectName: 'Magnolias Penthouse',
        priority: TaskPriority.medium,
        status: TaskStatus.todo,
        dueDate: 'Today',
        dueTime: '04:30 PM',
        category: '3D CAD Design',
      ),
    ];

    final highPriorityFollowups = [
      const FollowUpItem(
        id: 'FLP-201',
        clientName: 'Rahul Sharma',
        phone: '+91 98102 44321',
        projectName: 'DLF Phase 5 Turnkey Villa',
        budgetRange: '₹35 – ₹45 Lakhs',
        lastContact: 'Yesterday 04:30 PM',
        scheduledTime: '11:00 AM Today',
        sentiment: 'hot',
        notes: 'Requested final pricing sheet before wire transfer token advance.',
      ),
      const FollowUpItem(
        id: 'FLP-202',
        clientName: 'Ananya Deshmukh',
        phone: '+91 97204 88120',
        projectName: 'Godrej Woods 3BHK Renovation',
        budgetRange: '₹18 – ₹24 Lakhs',
        lastContact: '3 days ago',
        scheduledTime: '02:30 PM Today',
        sentiment: 'warm',
        notes: 'Needs confirmation on delivery timeline for German hardware fittings.',
      ),
      const FollowUpItem(
        id: 'FLP-203',
        clientName: 'Brig. K. S. Rathore',
        phone: '+91 94140 19283',
        projectName: 'Heritage Bungalow Turnkey',
        budgetRange: '₹60 – ₹75 Lakhs',
        lastContact: '5 days ago',
        scheduledTime: '05:00 PM Today',
        sentiment: 'hot',
        notes: 'Wants contract agreement reviewed by legal advisor before signing.',
      ),
    ];

    return DashboardSummary(
      productivity: productivity,
      earnings: earnings,
      wallet: wallet,
      attendance: attendance,
      travel: const TravelSummary(
        totalDistanceKm: 148.2,
        totalVisits: 11,
        approvedReimbursement: 8400,
        pendingReimbursement: 4850,
        thisMonthTotal: 13250,
      ),
      leadPulse: leadPulse,
      alerts: alerts,
      topTasks: topTasks,
      highPriorityFollowups: highPriorityFollowups,
    );
  }
}
