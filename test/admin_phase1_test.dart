import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:client/features/system_admin/index.dart';

void main() {
  group('Administration Module Phase 1 - Model & Smoke Tests', () {
    test('Admin models and mock data initialize correctly', () {
      expect(AdminMockData.users.length, greaterThanOrEqualTo(5));
      expect(AdminMockData.roles.length, greaterThanOrEqualTo(5));
      expect(AdminMockData.masterCategories.length, greaterThanOrEqualTo(8));
      expect(AdminMockData.masterRecords.length, greaterThanOrEqualTo(5));
      expect(AdminMockData.rateItems.length, greaterThanOrEqualTo(4));
      expect(AdminMockData.messageTemplates.length, greaterThanOrEqualTo(4));
      expect(AdminMockData.pricingGuardrails.length, greaterThanOrEqualTo(2));
      expect(AdminMockData.integrations.length, greaterThanOrEqualTo(5));
    });

    testWidgets('Users & RBAC Page renders without throwing', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(1280, 900));
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: UsersRbacPage()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Users & RBAC'), findsAtLeastNWidgets(1));
      expect(find.text('Total Users'), findsOneWidget);
      expect(find.text('Users Directory'), findsOneWidget);
    });

    testWidgets('Master Data Page renders without throwing', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(1280, 900));
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: MasterDataPage()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Master Data Configuration'), findsOneWidget);
      expect(find.text('Configured Categories'), findsOneWidget);
    });

    testWidgets('Item & Rate Masters Page renders without throwing', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(1280, 900));
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: ItemRateMastersPage()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Item & Rate Masters'), findsOneWidget);
      expect(find.text('Master Catalog Items'), findsOneWidget);
    });

    testWidgets('Message Templates Page renders without throwing', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(1280, 900));
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: MessageTemplatesPage()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Message Templates Hub'), findsOneWidget);
      expect(find.text('Total Templates'), findsOneWidget);
    });

    testWidgets('AI Training Page renders without throwing', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(1280, 900));
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: AiTrainingPage()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('AI Training & Guardrails Workspace'), findsOneWidget);
      expect(find.text('AI Testing Playground'), findsOneWidget);
    });

    testWidgets('Integrations Page renders without throwing', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(1280, 900));
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: IntegrationsPage()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('External Integrations Hub'), findsOneWidget);
      expect(find.text('Connected Providers'), findsOneWidget);
    });
  });
}
