import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:client/core/constants/app_constants.dart';
import 'package:client/core/theme/theme_controller.dart';
import 'package:client/features/auth/presentation/pages/login_page.dart';
import 'package:client/features/auth/presentation/view_models/auth_view_model.dart';
import 'package:client/features/landing/presentation/pages/landing_page.dart';
import 'package:client/main.dart';

void main() {
  group('Homio App & Routing Tests', () {
    testWidgets('HomioApp boots and renders LandingPage hero title', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(const HomioApp());
      await tester.pumpAndSettle();

      expect(find.byType(LandingPage), findsOneWidget);
      expect(find.textContaining('Run Your Business'), findsWidgets);
      expect(find.textContaining('Deliver Every Project'), findsWidgets);
    });

    testWidgets('LandingPage displays all core sections', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(const MaterialApp(home: LandingPage()));
      await tester.pumpAndSettle();

      expect(find.text('Start Free Trial'), findsWidgets);
      expect(find.text('Sign In'), findsWidgets);
      expect(
        find.textContaining('EVERYTHING YOUR BUSINESS NEEDS'),
        findsOneWidget,
      );
      expect(
        find.textContaining('What is the Homio Platform?'),
        findsOneWidget,
      );
    });
  });

  group('AuthViewModel & Login Page Tests', () {
    test('AuthViewModel validates empty and invalid credentials properly', () {
      final vm = AuthViewModel();

      expect(vm.validateEmail(''), isNotNull);
      expect(vm.validateEmail('invalid-email'), isNotNull);
      expect(vm.validateEmail('alex@homioworkspace.com'), isNull);

      expect(vm.validatePassword(''), isNotNull);
      expect(vm.validatePassword('short'), isNotNull);
      expect(vm.validatePassword('password123'), isNull);

      vm.fillDemoCredentials();
      expect(vm.emailController.text, AppConstants.demoEmail);
      expect(vm.passwordController.text, AppConstants.demoPassword);

      // Test Client Portal Mode toggle
      vm.setPortalMode(AuthPortalMode.clientPortal);
      expect(vm.isClientPortal, isTrue);
      vm.fillDemoCredentials();
      expect(vm.emailController.text, 'sarah.homeowner@gmail.com');
      expect(vm.passwordController.text, 'Client@2026');

      vm.dispose();
    });

    testWidgets(
      'LoginPage renders properly and fills demo credentials for both CRM and Client Portal',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1280, 800);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() => tester.view.resetPhysicalSize());

        await tester.pumpWidget(const MaterialApp(home: LoginPage()));
        await tester.pumpAndSettle();

        expect(find.text('Welcome back'), findsOneWidget);
        expect(find.text('Sign in to Workspace'), findsOneWidget);

        // Find and tap the magic link demo autofill
        final demoChip = find.textContaining('Use magic link');
        expect(demoChip, findsOneWidget);
        await tester.tap(demoChip);
        await tester.pumpAndSettle();

        // Verify email and password text fields are populated
        expect(find.text(AppConstants.demoEmail), findsNWidgets(2));

        // Switch to Client Portal tab
        final clientTab = find.text('Client Portal');
        expect(clientTab, findsOneWidget);
        await tester.tap(clientTab);
        await tester.pumpAndSettle();

        // Verify Client Portal mode UI changes
        expect(
          find.text('Sign in to track your home interior & turnkey project'),
          findsOneWidget,
        );
        expect(find.text('Access Client Portal'), findsOneWidget);

        // Tap magic link in Client mode
        await tester.tap(find.textContaining('Demo Homeowner'));
        await tester.pumpAndSettle();
        expect(find.text('sarah.homeowner@gmail.com'), findsNWidgets(2));
      },
    );

    testWidgets('LoginPage responds to mobile screen constraints', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(const MaterialApp(home: LoginPage()));
      await tester.pumpAndSettle();

      expect(find.byType(LoginPage), findsOneWidget);
      expect(find.text('Welcome back'), findsOneWidget);
    });
  });

  group('Theme System Tests', () {
    testWidgets('Theme responds to system platform brightness', (
      WidgetTester tester,
    ) async {
      tester.platformDispatcher.platformBrightnessTestValue = Brightness.light;
      await tester.pumpWidget(const HomioApp());
      await tester.pumpAndSettle();

      expect(ThemeController.instance.themeMode, ThemeMode.system);

      tester.platformDispatcher.platformBrightnessTestValue = Brightness.dark;
      await tester.pumpAndSettle();

      expect(ThemeController.instance.themeMode, ThemeMode.system);
    });
  });
}
