import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:client/features/reports/index.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // Define 4 standard viewport sizes
  const desktopSize = Size(1920, 1080);
  const laptopSize = Size(1280, 800);
  const tabletSize = Size(768, 1024);
  const mobileSize = Size(375, 812);

  final viewports = <String, Size>{
    'Desktop (1920x1080)': desktopSize,
    'Laptop (1280x800)': laptopSize,
    'Tablet (768x1024)': tabletSize,
    'Mobile (375x812)': mobileSize,
  };

  Widget buildTestApp(Widget child) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      home: Scaffold(
        body: child,
      ),
    );
  }

  group('Reports & Analytics Responsive Layout Tests - All 10 Screens', () {
    // 1. Executive Overview
    for (final entry in viewports.entries) {
      testWidgets('Screen 1: Executive Overview is responsive on ${entry.key}', (tester) async {
        tester.view.physicalSize = entry.value;
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() => tester.view.resetPhysicalSize());

        await tester.pumpWidget(buildTestApp(const ReportsExecutiveOverviewPage()));
        await tester.pumpAndSettle();

        expect(find.byType(ReportsExecutiveOverviewPage), findsOneWidget);
        final exception = tester.takeException();
        if (exception != null) {
          debugPrint('=== EXCEPTION FOUND ===');
          debugPrint(exception.toString());
          if (exception is FlutterError) {
            for (final node in exception.diagnostics) {
              debugPrint(node.toStringDeep());
            }
          }
        }
        expect(exception, isNull);
      });
    }

    // 2. Marketing Analytics
    for (final entry in viewports.entries) {
      testWidgets('Screen 2: Marketing Analytics is responsive on ${entry.key}', (tester) async {
        tester.view.physicalSize = entry.value;
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() => tester.view.resetPhysicalSize());

        await tester.pumpWidget(buildTestApp(const ReportsMarketingPage()));
        await tester.pumpAndSettle();

        expect(find.byType(ReportsMarketingPage), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    }

    // 3. Sales Analytics
    for (final entry in viewports.entries) {
      testWidgets('Screen 3: Sales Analytics is responsive on ${entry.key}', (tester) async {
        tester.view.physicalSize = entry.value;
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() => tester.view.resetPhysicalSize());

        await tester.pumpWidget(buildTestApp(const ReportsSalesPage()));
        await tester.pumpAndSettle();

        expect(find.byType(ReportsSalesPage), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    }

    // 4. Projects / Execution Analytics
    for (final entry in viewports.entries) {
      testWidgets('Screen 4: Projects / Execution Analytics is responsive on ${entry.key}', (tester) async {
        tester.view.physicalSize = entry.value;
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() => tester.view.resetPhysicalSize());

        await tester.pumpWidget(buildTestApp(const ReportsExecutionPage()));
        await tester.pumpAndSettle();

        expect(find.byType(ReportsExecutionPage), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    }

    // 5. Design Analytics
    for (final entry in viewports.entries) {
      testWidgets('Screen 5: Design Analytics is responsive on ${entry.key}', (tester) async {
        tester.view.physicalSize = entry.value;
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() => tester.view.resetPhysicalSize());

        await tester.pumpWidget(buildTestApp(const ReportsDesignPage()));
        await tester.pumpAndSettle();

        expect(find.byType(ReportsDesignPage), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    }

    // 6. Finance Analytics
    for (final entry in viewports.entries) {
      testWidgets('Screen 6: Finance Analytics is responsive on ${entry.key}', (tester) async {
        tester.view.physicalSize = entry.value;
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() => tester.view.resetPhysicalSize());

        await tester.pumpWidget(buildTestApp(const ReportsFinancesPage()));
        await tester.pumpAndSettle();

        expect(find.byType(ReportsFinancesPage), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    }

    // 7. HR Analytics
    for (final entry in viewports.entries) {
      testWidgets('Screen 7: HR Analytics is responsive on ${entry.key}', (tester) async {
        tester.view.physicalSize = entry.value;
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() => tester.view.resetPhysicalSize());

        await tester.pumpWidget(buildTestApp(const ReportsHrPage()));
        await tester.pumpAndSettle();

        expect(find.byType(ReportsHrPage), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    }

    // 8. Service / Labour Analytics
    for (final entry in viewports.entries) {
      testWidgets('Screen 8: Service / Labour Analytics is responsive on ${entry.key}', (tester) async {
        tester.view.physicalSize = entry.value;
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() => tester.view.resetPhysicalSize());

        await tester.pumpWidget(buildTestApp(const ReportsServicePage()));
        await tester.pumpAndSettle();

        expect(find.byType(ReportsServicePage), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    }

    // 9. Customer Feedback Analytics
    for (final entry in viewports.entries) {
      testWidgets('Screen 9: Customer Feedback Analytics is responsive on ${entry.key}', (tester) async {
        tester.view.physicalSize = entry.value;
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() => tester.view.resetPhysicalSize());

        await tester.pumpWidget(buildTestApp(const ReportsFeedbackPage()));
        await tester.pumpAndSettle();

        expect(find.byType(ReportsFeedbackPage), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    }

    // 10. Goals / Productivity Analytics
    for (final entry in viewports.entries) {
      testWidgets('Screen 10: Goals / Productivity Analytics is responsive on ${entry.key}', (tester) async {
        tester.view.physicalSize = entry.value;
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() => tester.view.resetPhysicalSize());

        await tester.pumpWidget(buildTestApp(const ReportsGoalsPage()));
        await tester.pumpAndSettle();

        expect(find.byType(ReportsGoalsPage), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    }
  });
}
