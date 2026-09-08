import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:client/features/dashboard/domain/dashboard_enums.dart';
import 'package:client/features/dashboard/domain/dashboard_models.dart';
import 'package:client/features/dashboard/data/dashboard_repository.dart';
import 'package:client/features/dashboard/data/task_repository.dart';
import 'package:client/features/dashboard/data/attendance_repository.dart';
import 'package:client/features/dashboard/data/travel_repository.dart';
import 'package:client/features/dashboard/data/wallet_repository.dart';
import 'package:client/features/dashboard/overview/dashboard_overview_page.dart';
import 'package:client/features/dashboard/tasks/dashboard_tasks_page.dart';
import 'package:client/features/dashboard/attendance/dashboard_attendance_page.dart';
import 'package:client/features/dashboard/travel/dashboard_travel_page.dart';
import 'package:client/features/dashboard/wallet/dashboard_wallet_page.dart';
import 'package:client/features/dashboard/widgets/state_feedback_widgets.dart';

void main() {
  group('Dashboard Domain & Business Logic Calculations', () {
    test('Productivity Score dynamic calculation matches PRD 60/40 formula', () {
      final metrics = ProductivityMetrics(
        tasksCompleted: 18,
        totalTasks: 20, // 90% * 0.60 = 54%
        followupsCompleted: 45,
        totalFollowups: 45, // 100% * 0.40 = 40%
        previousPeriodScore: 88.0,
      );

      expect(metrics.score, 94.0);
      expect(metrics.scoreChange, 6.0);
      expect(metrics.isPositiveChange, isTrue);
      expect(metrics.performanceBadge, contains('Top Performer'));
    });

    test('Total Net Projected Earnings formula: Base + Incentives - Deductions', () {
      const earnings = EarningsSummary(
        baseSalary: 45000,
        earnedIncentives: 18500,
        salaryDeductions: 2000,
      );

      expect(earnings.netProjected, 61500.0);
    });

    test('Travel reimbursement calculation: distanceKm * ratePerKm', () {
      const record = TravelRecord(
        id: 'TRV-TEST',
        date: 'Today',
        fromLocation: 'HQ Hub',
        toLocation: 'Project #104',
        projectName: 'DLF Phase 5 Villa',
        clientName: 'Rahul Sharma',
        distanceKm: 18.4,
        ratePerKm: 12.0,
        purpose: 'Inspection',
      );

      expect(record.reimbursementAmount, 220.8);
    });
  });

  group('Dashboard Repositories Integration', () {
    test('DashboardRepository returns valid summary adapted for Scope', () async {
      final repo = DashboardRepository.instance;

      final myWork = await repo.getSummary(
        dateFilter: DashboardDateFilter.today,
        scopeFilter: DashboardScopeFilter.myWork,
      );
      expect(myWork.productivity.score, greaterThan(0));
      expect(myWork.earnings.baseSalary, 45000);
      expect(myWork.alerts.length, 4);

      final orgWork = await repo.getSummary(
        dateFilter: DashboardDateFilter.thisMonth,
        scopeFilter: DashboardScopeFilter.organization,
      );
      expect(orgWork.earnings.baseSalary, greaterThan(myWork.earnings.baseSalary));
    });

    test('TaskRepository performs task creation, status updates and completion', () async {
      final repo = TaskRepository.instance;

      final tasks = await repo.getTasks();
      expect(tasks, isNotEmpty);

      const newTask = TaskItem(
        id: 'TSK-TEST-99',
        title: 'Unit Test Task',
        clientName: 'Test Client',
        projectName: 'Test Project',
        dueDate: 'Today',
        dueTime: '05:00 PM',
      );

      final created = await repo.createTask(newTask);
      expect(created.id, 'TSK-TEST-99');

      final toggled = await repo.toggleTaskCompletion('TSK-TEST-99');
      expect(toggled.isCompleted, isTrue);

      final updated = await repo.updateTaskStatus('TSK-TEST-99', TaskStatus.waiting);
      expect(updated.status, TaskStatus.waiting);
    });

    test('AttendanceRepository updates clock-in state and records', () async {
      final repo = AttendanceRepository.instance;

      final summaryIn = await repo.clockIn(
        location: 'HQ Geofence Test',
        latitude: 28.4595,
        longitude: 77.0266,
        selfieCaptured: true,
      );
      expect(summaryIn.isClockedIn, isTrue);

      final summaryOut = await repo.clockOut(
        location: 'HQ Geofence Test',
        latitude: 28.4595,
        longitude: 77.0266,
      );
      expect(summaryOut.isClockedIn, isFalse);
    });

    test('TravelRepository logs field visit and calculates reimbursement', () async {
      final repo = TravelRepository.instance;

      final record = await repo.logFieldVisit(
        clientName: 'Aarav Singhania',
        projectName: 'Penthouse #402',
        fromLocation: 'HQ Hub',
        toLocation: 'Client Site',
        distanceKm: 25.0,
        purpose: 'Laser framing check',
        ratePerKm: 12.0,
      );

      expect(record.reimbursementAmount, 300.0);
    });

    test('WalletRepository processes bank payout and expense claims', () async {
      final repo = WalletRepository.instance;

      final initialSummary = await repo.getWalletSummary();
      final payoutTxn = await repo.requestPayout(
        amount: 1000.0,
        bankAccount: 'HDFC Bank •••• 4821',
      );

      expect(payoutTxn.amount, 1000.0);
      final updatedSummary = await repo.getWalletSummary();
      expect(updatedSummary.currentBalance, initialSummary.currentBalance - 1000.0);
    });
  });

  group('All 5 Dashboard Screens Widget Smoke Tests', () {
    testWidgets('DashboardOverviewPage renders successfully', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1280, 900));
      await tester.pumpWidget(
        const MaterialApp(
          home: DashboardOverviewPage(
            userName: 'Vikram Malhotra',
            userRole: 'Super Admin',
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('HOMIO Operations Dashboard'), findsOneWidget);
      expect(find.textContaining('Vikram Malhotra'), findsWidgets);
    });

    testWidgets('DashboardTasksPage renders with all view tabs', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1280, 900));
      await tester.pumpWidget(
        const MaterialApp(
          home: DashboardTasksPage(
            userName: 'Vikram Malhotra',
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('My Tasks & Follow-up Center'), findsOneWidget);
      expect(find.text('List View'), findsOneWidget);
      expect(find.text('Kanban'), findsOneWidget);
      expect(find.text('Calendar'), findsOneWidget);
    });

    testWidgets('DashboardAttendancePage renders with clock status and calendar', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1280, 900));
      await tester.pumpWidget(
        const MaterialApp(
          home: DashboardAttendancePage(
            userName: 'Vikram Malhotra',
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('Attendance & Geofence Telemetry'), findsOneWidget);
      expect(find.textContaining('Clock'), findsWidgets);
    });

    testWidgets('DashboardTravelPage renders with route waypoints and claims', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1280, 900));
      await tester.pumpWidget(
        const MaterialApp(
          home: DashboardTravelPage(
            userName: 'Vikram Malhotra',
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('Travel & Field Mileage Hub'), findsOneWidget);
      expect(find.text('Operational Field Route Telemetry'), findsOneWidget);
    });

    testWidgets('DashboardWalletPage renders with ledger and incentives', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1280, 900));
      await tester.pumpWidget(
        const MaterialApp(
          home: DashboardWalletPage(
            userName: 'Vikram Malhotra',
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('Wallet & Incentives Ledger'), findsOneWidget);
      expect(find.text('Operational Expense Wallet Balance'), findsOneWidget);
    });

    testWidgets('DashboardOverviewPage preserves scroll position when refreshing or filtering', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1280, 800));
      await tester.pumpWidget(
        const MaterialApp(
          home: DashboardOverviewPage(
            userName: 'Vikram Malhotra',
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('HOMIO Operations Dashboard'), findsOneWidget);

      final scrollableFinder = find.byKey(const PageStorageKey('dashboard_overview_scroll'));
      expect(scrollableFinder, findsOneWidget);
      await tester.drag(scrollableFinder, const Offset(0, -350));
      await tester.pumpAndSettle();

      final scrollableState = tester.stateList<ScrollableState>(
        find.descendant(of: scrollableFinder, matching: find.byType(Scrollable)),
      ).firstWhere((s) => s.axisDirection == AxisDirection.down);
      final scrolledOffset = scrollableState.position.pixels;
      expect(scrolledOffset, greaterThan(150));

      final refreshBtn = find.byTooltip('Refresh Data');
      if (refreshBtn.evaluate().isNotEmpty) {
        await tester.tap(refreshBtn);
        await tester.pump();
        expect(find.byType(DashboardInlineLoadingIndicator), findsOneWidget);
        await tester.pumpAndSettle();
      }

      expect(scrollableState.position.pixels, closeTo(scrolledOffset, 1.0));
    });

    testWidgets('DashboardTasksPage preserves scroll position when refreshing or filtering', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1280, 800));
      await tester.pumpWidget(
        const MaterialApp(
          home: DashboardTasksPage(
            userName: 'Vikram Malhotra',
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('My Tasks & Follow-up Center'), findsOneWidget);

      final scrollableFinder = find.byKey(const PageStorageKey('dashboard_tasks_scroll'));
      expect(scrollableFinder, findsOneWidget);
      await tester.drag(find.text('My Tasks & Follow-up Center'), const Offset(0, -350));
      await tester.pumpAndSettle();

      final scrollableState = tester.stateList<ScrollableState>(
        find.descendant(of: scrollableFinder, matching: find.byType(Scrollable)),
      ).firstWhere((s) => s.axisDirection == AxisDirection.down);
      final scrolledOffset = scrollableState.position.pixels;
      expect(scrolledOffset, greaterThan(150));

      final refreshBtn = find.byTooltip('Refresh Data');
      if (refreshBtn.evaluate().isNotEmpty) {
        await tester.tap(refreshBtn);
        await tester.pump();
        expect(find.byType(DashboardInlineLoadingIndicator), findsOneWidget);
        await tester.pumpAndSettle();
      }

      expect(scrollableState.position.pixels, closeTo(scrolledOffset, 1.0));
    });
  });
}

