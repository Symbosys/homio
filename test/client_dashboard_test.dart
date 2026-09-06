import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:client/features/client/dashboard/index.dart';

void main() {
  group('Client Analytics Dashboard Domain Models & Mock Data Tests', () {
    test('ClientDashboardProject computes financial and progress metrics correctly', () {
      final project = ClientDashboardMockData.project;

      expect(project.title, 'Villa 402 - 3BHK Turnkey Interior');
      expect(project.progressPercent, 72.4);
      expect(project.totalBudget, 38.00);
      expect(project.spentAmount, 28.40);
      expect(project.balanceAmount, 9.60);
      expect(project.healthStatus, ProjectHealthStatus.onSchedule);
      expect(project.daysRemaining, 71);
    });

    test('Spend Timeline data points contain accurate milestone references', () {
      final timeline = ClientDashboardMockData.spendTimeline;
      expect(timeline.length, 6);

      final sep = timeline[3];
      expect(sep.label, 'Sep');
      expect(sep.actualSpend, 28.4);
      expect(sep.plannedSpend, 26.0);
    });

    test('Expense Breakdown allocates 100% of the project budget across 5 categories', () {
      final categories = ClientDashboardMockData.expenseBreakdown;
      expect(categories.length, 5);

      final totalPercentage = categories.fold<double>(0, (sum, cat) => sum + cat.percentage);
      expect(totalPercentage, 100.0);

      final totalAmount = categories.fold<double>(0, (sum, cat) => sum + cat.amount);
      expect(totalAmount, closeTo(38.00, 0.01));
    });

    test('Milestone Velocities items track planned vs actual days per phase', () {
      final items = ClientDashboardMockData.milestoneVelocities;
      expect(items.length, 6);

      final stage1 = items[0];
      expect(stage1.plannedDays, 18);
      expect(stage1.actualDays, 15);
      expect(stage1.progressPercent, 100.0);
    });

    test('Quality Scores evaluate 4 dimensions with high pass rate', () {
      final scores = ClientDashboardMockData.qualityScores;
      expect(scores.length, 4);

      for (final s in scores) {
        expect(s.score, greaterThan(90.0));
      }
    });

    test('Payment Schedule contains 6 milestones with invoice references', () {
      final schedule = ClientDashboardMockData.paymentSchedule;
      expect(schedule.length, 6);

      final paidItems = schedule.where((s) => s.status == PaymentStageStatus.paid);
      expect(paidItems.length, 4);

      final dueItems = schedule.where((s) => s.status == PaymentStageStatus.dueNow);
      expect(dueItems.length, 1);
      expect(dueItems.first.amount, 6.00);
    });
  });

  group('ClientDashboardPage Widget & Chart Rendering Tests', () {
    testWidgets('ClientDashboardPage renders all charts, graphs, pie charts and KPIs on desktop', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(
        const MaterialApp(
          home: ClientDashboardPage(),
        ),
      );
      await tester.pumpAndSettle();

      // Verify Hero Banner
      expect(find.text('Villa 402 - 3BHK Turnkey Interior'), findsOneWidget);
      expect(find.text('ON SCHEDULE'), findsOneWidget);
      expect(find.text('71d to Handover'), findsOneWidget);
      expect(find.text('Call PM: Arjun Verma'), findsOneWidget);

      // Verify Executive KPI Metrics
      expect(find.text('OVERALL COMPLETION'), findsOneWidget);
      expect(find.text('72.4%'), findsOneWidget);
      expect(find.text('EXECUTION VELOCITY'), findsOneWidget);
      expect(find.text('94.8%'), findsOneWidget);
      expect(find.text('CUMULATIVE SPENT'), findsOneWidget);
      expect(find.text('₹28.4L'), findsOneWidget);
      expect(find.text('QUALITY AUDIT SCORE'), findsOneWidget);
      expect(find.text('99.2%'), findsOneWidget);

      // Verify Chart Headers & Titles
      expect(find.text('BUDGET BURN-DOWN & CUMULATIVE SPEND'), findsOneWidget);
      expect(find.text('BUDGET ALLOCATION BY TRADE'), findsOneWidget);
      expect(find.text('MILESTONE EXECUTION VELOCITY'), findsOneWidget);
      expect(find.text('QUALITY & COMPLIANCE INDEX'), findsOneWidget);
      expect(find.text('FINANCIAL MILESTONE LEDGER & INVOICES'), findsOneWidget);
      expect(find.text('PENDING DIGITAL APPROVALS'), findsOneWidget);
      expect(find.text('LIVE SITE AUDIT STREAM'), findsOneWidget);

      // Verify Donut/Pie Chart categories
      expect(find.text('Custom Carpentry & Woodwork'), findsOneWidget);
      expect(find.text('Civil & Masonry Works'), findsOneWidget);
      expect(find.text('Electrical & Smart Automation'), findsOneWidget);
      expect(find.text('Premium Paints & Textures'), findsOneWidget);
      expect(find.text('Fixtures, Hardware & Decor'), findsOneWidget);

      // Verify Custom Painters are active
      expect(find.byType(CustomPaint), findsWidgets);
    });

    testWidgets('ClientDashboardPage renders smoothly on mobile viewport (390x844)', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(
        const MaterialApp(
          home: ClientDashboardPage(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Villa 402 - 3BHK Turnkey Interior'), findsOneWidget);
      expect(find.text('BUDGET BURN-DOWN & CUMULATIVE SPEND'), findsOneWidget);
      expect(find.text('BUDGET ALLOCATION BY TRADE'), findsOneWidget);
      expect(find.text('PENDING DIGITAL APPROVALS'), findsOneWidget);
    });

    testWidgets('ClientDashboardPage handles Approve & Sign digital certification interaction', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(
        const MaterialApp(
          home: ClientDashboardPage(),
        ),
      );
      await tester.pumpAndSettle();

      final approveButtons = find.text('Approve & Sign');
      expect(approveButtons, findsWidgets);

      // Scroll and tap first approve button
      await tester.ensureVisible(approveButtons.first);
      await tester.pumpAndSettle();
      await tester.tap(approveButtons.first);
      await tester.pumpAndSettle();

      expect(find.text('Digitally Signed by Rohit Sharma • Certified'), findsOneWidget);
    });

    testWidgets('ClientDashboardPage opens Payment Modal when Pay button is clicked', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(
        const MaterialApp(
          home: ClientDashboardPage(),
        ),
      );
      await tester.pumpAndSettle();

      final payButton = find.text('Pay ₹6.00L via UPI / NetBanking');
      expect(payButton, findsOneWidget);

      await tester.ensureVisible(payButton);
      await tester.pumpAndSettle();
      await tester.tap(payButton);
      await tester.pumpAndSettle();

      expect(find.text('Milestone 5 Payment'), findsOneWidget);
      expect(find.text('₹6,00,000.00'), findsOneWidget);
      expect(find.text('Proceed to Secure Payment Gateway'), findsOneWidget);
    });
  });
}
