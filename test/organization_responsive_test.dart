import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:client/features/organization/index.dart';

class _TestHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return _MockHttpClient();
  }
}

class _MockHttpClient implements HttpClient {
  @override
  dynamic noSuchMethod(Invocation invocation) {
    if (invocation.memberName == #getUrl || invocation.memberName == #openUrl) {
      return Future.value(_MockHttpClientRequest());
    }
    return null;
  }
}

class _MockHttpClientRequest implements HttpClientRequest {
  @override
  dynamic noSuchMethod(Invocation invocation) {
    if (invocation.memberName == #close) {
      return Future.value(_MockHttpClientResponse());
    }
    return null;
  }
}

class _MockHttpClientResponse implements HttpClientResponse {
  static final _transparentImage = <int>[
    0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A,
    0x00, 0x00, 0x00, 0x0D, 0x49, 0x48, 0x44, 0x52,
    0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01,
    0x08, 0x06, 0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4,
    0x89, 0x00, 0x00, 0x00, 0x0A, 0x49, 0x44, 0x41,
    0x54, 0x78, 0x9C, 0x63, 0x00, 0x01, 0x00, 0x00,
    0x05, 0x00, 0x01, 0x0D, 0x0A, 0x2D, 0xB4, 0x00,
    0x00, 0x00, 0x00, 0x49, 0x45, 0x4E, 0x44, 0xAE,
    0x42, 0x60, 0x82,
  ];

  @override
  int get statusCode => 200;

  @override
  int get contentLength => _transparentImage.length;

  @override
  HttpClientResponseCompressionState get compressionState =>
      HttpClientResponseCompressionState.notCompressed;

  @override
  HttpHeaders get headers => _MockHttpHeaders();

  @override
  StreamSubscription<List<int>> listen(
    void Function(List<int> event)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    return Stream<List<int>>.fromIterable([_transparentImage]).listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

class _MockHttpHeaders implements HttpHeaders {
  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = _TestHttpOverrides();

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

  group('Organization Module Responsive Layout Tests - All 6 Screens', () {
    // 1. Departments Page
    for (final entry in viewports.entries) {
      testWidgets('Screen 1: Departments Page is responsive on ${entry.key}', (tester) async {
        tester.view.physicalSize = entry.value;
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() => tester.view.resetPhysicalSize());

        await tester.pumpWidget(buildTestApp(const OrgDepartmentsPage()));
        await tester.pumpAndSettle();

        expect(find.byType(OrgDepartmentsPage), findsOneWidget);
        final exception = tester.takeException();
        if (exception != null) {
          debugPrint('=== EXCEPTION FOUND in OrgDepartmentsPage (${entry.key}) ===');
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

    // 2. Teams Page
    for (final entry in viewports.entries) {
      testWidgets('Screen 2: Teams Page is responsive on ${entry.key}', (tester) async {
        tester.view.physicalSize = entry.value;
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() => tester.view.resetPhysicalSize());

        await tester.pumpWidget(buildTestApp(const OrgTeamsPage()));
        await tester.pumpAndSettle();

        expect(find.byType(OrgTeamsPage), findsOneWidget);
        final exception = tester.takeException();
        if (exception != null) {
          debugPrint('=== EXCEPTION FOUND in OrgTeamsPage (${entry.key}) ===');
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

    // 3. Employees Page
    for (final entry in viewports.entries) {
      testWidgets('Screen 3: Employees Page is responsive on ${entry.key}', (tester) async {
        tester.view.physicalSize = entry.value;
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() => tester.view.resetPhysicalSize());

        await tester.pumpWidget(buildTestApp(const OrgEmployeesPage()));
        await tester.pumpAndSettle();

        expect(find.byType(OrgEmployeesPage), findsOneWidget);
        final exception = tester.takeException();
        if (exception != null) {
          debugPrint('=== EXCEPTION FOUND in OrgEmployeesPage (${entry.key}) ===');
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

    // 4. Roles Page
    for (final entry in viewports.entries) {
      testWidgets('Screen 4: Roles Page is responsive on ${entry.key}', (tester) async {
        tester.view.physicalSize = entry.value;
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() => tester.view.resetPhysicalSize());

        await tester.pumpWidget(buildTestApp(const OrgRolesPage()));
        await tester.pumpAndSettle();

        expect(find.byType(OrgRolesPage), findsOneWidget);
        final exception = tester.takeException();
        if (exception != null) {
          debugPrint('=== EXCEPTION FOUND in OrgRolesPage (${entry.key}) ===');
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

    // 5. Permissions Page
    for (final entry in viewports.entries) {
      testWidgets('Screen 5: Permissions Page is responsive on ${entry.key}', (tester) async {
        tester.view.physicalSize = entry.value;
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() => tester.view.resetPhysicalSize());

        await tester.pumpWidget(buildTestApp(const OrgPermissionsPage()));
        await tester.pumpAndSettle();

        expect(find.byType(OrgPermissionsPage), findsOneWidget);
        final exception = tester.takeException();
        if (exception != null) {
          debugPrint('=== EXCEPTION FOUND in OrgPermissionsPage (${entry.key}) ===');
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

    // 6. Access Scope Page
    for (final entry in viewports.entries) {
      testWidgets('Screen 6: Access Scope Page is responsive on ${entry.key}', (tester) async {
        tester.view.physicalSize = entry.value;
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() => tester.view.resetPhysicalSize());

        await tester.pumpWidget(buildTestApp(const OrgAccessScopePage()));
        await tester.pumpAndSettle();

        expect(find.byType(OrgAccessScopePage), findsOneWidget);
        final exception = tester.takeException();
        if (exception != null) {
          debugPrint('=== EXCEPTION FOUND in OrgAccessScopePage (${entry.key}) ===');
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
  });
}
