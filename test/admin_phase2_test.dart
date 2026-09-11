import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:client/features/system_admin/index.dart';

void main() {
  group('Administration Module Phase 2 - Model & Smoke Tests', () {
    test('Phase 2 models and mock data initialize correctly', () {
      expect(AdminPhase2MockData.notifications.length, greaterThanOrEqualTo(5));
      expect(AdminPhase2MockData.notificationRules.length, greaterThanOrEqualTo(5));
      expect(AdminPhase2MockData.defaultPreferences.length, greaterThanOrEqualTo(2));
      expect(AdminPhase2MockData.automations.length, greaterThanOrEqualTo(6));
      expect(AdminPhase2MockData.executionLogs.length, greaterThanOrEqualTo(4));
      expect(AdminPhase2MockData.auditLogs.length, greaterThanOrEqualTo(5));
      expect(AdminPhase2MockData.backups.length, greaterThanOrEqualTo(4));
      expect(AdminPhase2MockData.restoreTests.length, greaterThanOrEqualTo(2));
      expect(AdminPhase2MockData.defaultOrgSettings.orgName, isNotEmpty);
      expect(AdminPhase2MockData.defaultOrgSettings.contactEmail, contains('@'));
    });

    testWidgets('Notifications Page renders without throwing', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(1280, 900));
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: NotificationsPage()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Notification Center & Rules'), findsOneWidget);
      expect(find.text('Dispatched Today'), findsOneWidget);
      expect(find.text('Activity & Delivery Logs'), findsOneWidget);
      expect(find.text('Configured Notification Rules'), findsOneWidget);
      expect(find.text('Channel Preferences & Policies'), findsOneWidget);
    });

    testWidgets('Automations Page renders without throwing', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(1280, 900));
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: AutomationsPage()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Workflow Automations Engine'), findsOneWidget);
      expect(find.text('Active Automations'), findsOneWidget);
      expect(find.text('Workflow Automation Library'), findsOneWidget);
      expect(find.text('Execution History & Step Trace'), findsOneWidget);
      expect(find.text('Create Automation'), findsOneWidget);
    });

    testWidgets('Audit Logs Page renders without throwing', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(1280, 900));
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: AuditLogsPage()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('System Activity & Audit Ledgers'), findsOneWidget);
      expect(find.text('Total Audit Events'), findsOneWidget);
      expect(find.text('Critical / Sensitive Actions'), findsOneWidget);
    });

    testWidgets('Backup & Recovery Page renders without throwing', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(1280, 900));
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: BackupRecoveryPage()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Disaster Backup & Safe Recovery'), findsOneWidget);
      expect(find.text('Disaster System Health'), findsOneWidget);
      expect(find.text('Snapshot Archives & History'), findsOneWidget);
    });

    testWidgets('System Settings Page renders without throwing', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(1280, 900));
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: SystemSettingsPage()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Global System Settings'), findsOneWidget);
      expect(find.text('Configured Setting Domains'), findsOneWidget);
      expect(find.text('Organization Profile'), findsOneWidget);
      expect(find.text('Platform Security & Auth'), findsOneWidget);
    });

    testWidgets('Notifications Page tab switching works smoothly', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(1280, 900));
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: NotificationsPage()),
        ),
      );
      await tester.pumpAndSettle();

      // Tap on Configured Notification Rules tab
      await tester.tap(find.text('Configured Notification Rules'));
      await tester.pumpAndSettle();

      expect(find.text('New Notification Rule'), findsOneWidget);

      // Tap on Channel Preferences & Policies tab
      await tester.tap(find.text('Channel Preferences & Policies'));
      await tester.pumpAndSettle();

      expect(find.text('Global Channel Dispatch Policies'), findsOneWidget);
      expect(find.text('Payment Confirmations & Security Codes'), findsOneWidget);
    });
  });
}
