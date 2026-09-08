import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:client/features/sales/domain/sales_enums.dart';
import 'package:client/features/sales/data/sales_repository.dart';
import 'package:client/features/sales/overview/sales_overview_page.dart';
import 'package:client/features/sales/leads/sales_leads_page.dart';
import 'package:client/features/sales/customers/sales_customers_page.dart';
import 'package:client/features/sales/funnels/sales_funnels_page.dart';
import 'package:client/features/sales/followups/sales_followups_page.dart';
import 'package:client/features/sales/calls/sales_calls_page.dart';
import 'package:client/features/sales/calendar/sales_calendar_page.dart';
import 'package:client/features/sales/tasks/sales_tasks_page.dart';
import 'package:client/features/sales/automation/sales_automation_page.dart';

void main() {
  group('CRM & Sales Domain Logic & Repository Tests', () {
    final repo = SalesRepository.instance;

    test('Repository seeds realistic production CRM datasets', () async {
      final leads = await repo.getLeads();
      final customers = await repo.getCustomers();
      final funnels = await repo.getFunnels();
      final followups = await repo.getFollowUps();
      final calls = await repo.getCallLogs();
      final meetings = await repo.getMeetings();
      final tasks = await repo.getTasks();
      final automations = await repo.getAutomations();

      expect(leads.isNotEmpty, isTrue);
      expect(customers.isNotEmpty, isTrue);
      expect(funnels.isNotEmpty, isTrue);
      expect(followups.isNotEmpty, isTrue);
      expect(calls.isNotEmpty, isTrue);
      expect(meetings.isNotEmpty, isTrue);
      expect(tasks.isNotEmpty, isTrue);
      expect(automations.isNotEmpty, isTrue);
    });

    test('Lead Duplicate Engine detects existing phones & emails accurately', () {
      final dupByPhone = repo.checkDuplicateLead(phone: '9818844332', email: '', name: '');
      expect(dupByPhone, isNotNull);
      expect(dupByPhone?.phone, contains('98188'));

      final dupByEmail = repo.checkDuplicateLead(phone: '', email: 'sanjay.singhal@hdfcbank.com', name: '');
      expect(dupByEmail, isNotNull);

      final freshLead = repo.checkDuplicateLead(phone: '9999900000', email: 'unique.person@test.com', name: 'Non Existent');
      expect(freshLead, isNull);
    });

    test('Lead stage transition updates stage and appends activity timeline', () async {
      final leads = await repo.getLeads();
      final testLead = leads.first;

      final updated = await repo.updateLeadStage(testLead.id, CrmStage.meetingDone);
      expect(updated.stage, CrmStage.meetingDone);

      final fetched = repo.getLeadById(testLead.id);
      expect(fetched?.stage, CrmStage.meetingDone);
      expect(fetched?.activities.any((a) => a.action.contains('Stage Changed')), isTrue);
    });

    test('Follow-up toggle toggles completed status reactively', () async {
      final followups = await repo.getFollowUps();
      final item = followups.first;
      final originalStatus = item.isDone;

      final toggled = await repo.toggleFollowUpComplete(item.id);
      expect(toggled.isDone, !originalStatus);
    });

    test('Automation toggle changes workflow active state', () async {
      final automations = await repo.getAutomations();
      final item = automations.first;
      final originalActive = item.isActive;

      final toggled = await repo.toggleAutomation(item.id);
      expect(toggled.isActive, !originalActive);
    });

    test('Task status updates seamlessly', () async {
      final tasks = await repo.getTasks();
      final task = tasks.first;

      final updated = await repo.updateTaskStatus(task.id, CrmTaskStatus.inProgress);
      expect(updated.status, CrmTaskStatus.inProgress);
    });

    test('Customer model contract and outstanding balances compute properly', () async {
      final customers = await repo.getCustomers();
      final customer = customers.first;

      expect(customer.totalContractValue, greaterThan(0));
      expect(customer.totalOutstanding, equals(customer.totalContractValue - customer.totalPaid));
    });
  });

  group('CRM & Sales Production Screen Widget Tests', () {
    Widget buildTestHarness(Widget child) {
      return MaterialApp(
        theme: ThemeData.light(useMaterial3: true),
        darkTheme: ThemeData.dark(useMaterial3: true),
        home: Scaffold(body: child),
      );
    }

    testWidgets('SalesOverviewPage renders without crashing', (tester) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(buildTestHarness(const SalesOverviewPage()));
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.byType(SalesOverviewPage), findsOneWidget);
    });

    testWidgets('SalesLeadsPage renders without crashing', (tester) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(buildTestHarness(const SalesLeadsPage()));
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.byType(SalesLeadsPage), findsOneWidget);
    });

    testWidgets('SalesCustomersPage renders without crashing', (tester) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(buildTestHarness(const SalesCustomersPage()));
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.byType(SalesCustomersPage), findsOneWidget);
    });

    testWidgets('SalesFunnelsPage renders without crashing', (tester) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(buildTestHarness(const SalesFunnelsPage()));
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.byType(SalesFunnelsPage), findsOneWidget);
    });

    testWidgets('SalesFollowupsPage renders without crashing', (tester) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(buildTestHarness(const SalesFollowupsPage()));
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.byType(SalesFollowupsPage), findsOneWidget);
    });

    testWidgets('SalesCallsPage renders without crashing', (tester) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(buildTestHarness(const SalesCallsPage()));
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.byType(SalesCallsPage), findsOneWidget);
    });

    testWidgets('SalesCalendarPage renders without crashing', (tester) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(buildTestHarness(const SalesCalendarPage()));
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.byType(SalesCalendarPage), findsOneWidget);
    });

    testWidgets('SalesTasksPage renders without crashing', (tester) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(buildTestHarness(const SalesTasksPage()));
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.byType(SalesTasksPage), findsOneWidget);
    });

    testWidgets('SalesAutomationPage renders without crashing', (tester) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(buildTestHarness(const SalesAutomationPage()));
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.byType(SalesAutomationPage), findsOneWidget);
    });
  });
}
