import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:client/features/client/stage_work_approvals/index.dart';

void main() {
  group('Stage Work Approvals Domain Models & Data Integrity Tests', () {
    test('StageApprovalPackage computes status helper booleans correctly', () {
      final packagePending = StageApprovalPackage(
        stageNumber: 5,
        title: 'Stage 5: Bespoke Joinery',
        subtitle: 'Lower carcase and quartz installation',
        category: 'Carpentry & Joinery',
        status: ApprovalStatus.pendingClientAction,
        trancheAmount: '₹7,50,000',
        dueDate: 'Due Today (Sep 05)',
        supervisorName: 'Rajesh Verma',
        supervisorRole: 'Sr. Site Execution Supervisor',
        passedCheckpoints: 4,
        totalCheckpoints: 4,
        inspectionHighlights: ['HDHMR board moisture content verified at 8.2%'],
        evidenceImages: ['Modular Lower Carcase'],
        engineeringNote: 'All technical criteria verified by internal QA.',
      );

      expect(packagePending.isPendingAction, isTrue);
      expect(packagePending.isApproved, isFalse);
      expect(packagePending.isRevisionRequested, isFalse);

      packagePending.status = ApprovalStatus.approvedCertified;
      expect(packagePending.isPendingAction, isFalse);
      expect(packagePending.isApproved, isTrue);

      packagePending.status = ApprovalStatus.revisionRequested;
      expect(packagePending.isRevisionRequested, isTrue);
    });

    test('StageApprovalPackage holds supervisor and financial tranche data', () {
      final pkg = StageApprovalPackage(
        stageNumber: 4,
        title: 'Stage 4 Variation: Italian Statuario Polish',
        subtitle: 'Mirror diamond silicate polish enhancement',
        category: 'Flooring Variation',
        status: ApprovalStatus.pendingClientAction,
        trancheAmount: '₹1,20,000',
        dueDate: 'Action Required',
        supervisorName: 'Ar. Sameer Mehta',
        supervisorRole: 'Project Director',
        passedCheckpoints: 3,
        totalCheckpoints: 3,
        inspectionHighlights: ['3000-grit gloss specular reflectivity verified'],
        evidenceImages: ['Specular Gloss Reflection'],
        engineeringNote: 'Full living lounge polished with zero scratch traces.',
      );

      expect(pkg.stageNumber, 4);
      expect(pkg.trancheAmount, '₹1,20,000');
      expect(pkg.supervisorName, 'Ar. Sameer Mehta');
      expect(pkg.passedCheckpoints, 3);
      expect(pkg.totalCheckpoints, 3);
    });
  });

  group('ClientStageWorkApprovalsPage Widget & Responsiveness Tests', () {
    Widget createWidgetUnderTest() {
      return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: ClientStageWorkApprovalsPage(),
      );
    }

    testWidgets('Renders all sections with zero overflows on desktop viewport (1440x900)',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Header & Project Pill
      expect(find.text('Stage Work Approvals'), findsOneWidget);
      expect(find.text('Skyline Villa Penthouse 402, Worli • 4 BHK Luxury'), findsOneWidget);
      expect(find.text('2 Stages Awaiting Client Action'), findsOneWidget);

      // Metric Strip
      expect(find.text('Action Required'), findsWidgets);
      expect(find.text('2 Stages'), findsOneWidget);
      expect(find.text('Approved & Certified'), findsOneWidget);
      expect(find.text('4 Milestones'), findsOneWidget);
      expect(find.text('Pending Milestone Value'), findsOneWidget);
      expect(find.text('₹8,70,000'), findsOneWidget);
      expect(find.text('Audit Compliance'), findsOneWidget);
      expect(find.text('100% Passed'), findsOneWidget);

      // Filter Tabs
      expect(find.textContaining('All Packages'), findsOneWidget);
      expect(find.textContaining('Action Required'), findsWidgets);
      expect(find.textContaining('Approved & Certified'), findsWidgets);

      // Pending Stages
      expect(find.text('Stage 5: Bespoke Joinery & Modular Kitchen Fabrication'), findsOneWidget);
      expect(find.text('Stage 4 Variation: Italian Statuario Polish Grade-A Upgrade'), findsOneWidget);

      // Legal compliance banner
      expect(find.text('Legal Digital Certification Guarantee'), findsOneWidget);

      expect(tester.takeException(), isNull);
    });

    testWidgets('Renders cleanly without overflow on mobile viewport (390x844)',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('Stage Work Approvals'), findsOneWidget);
      expect(find.text('Action Required'), findsWidgets);
      expect(find.textContaining('All Packages'), findsOneWidget);

      expect(tester.takeException(), isNull);
    });

    testWidgets('Filters work packages by status filter tabs',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Initially All Packages shows Stage 5 and Stage 4 Variation
      expect(find.text('Stage 5: Bespoke Joinery & Modular Kitchen Fabrication'), findsOneWidget);
      expect(find.text('Stage 4 Variation: Italian Statuario Polish Grade-A Upgrade'), findsOneWidget);

      // Switch to Approved & Certified tab (which displays count in tab title)
      final approvedTab = find.textContaining('Approved & Certified (');
      expect(approvedTab, findsOneWidget);
      await tester.tap(approvedTab);
      await tester.pumpAndSettle();

      // Pending Stage 5 should not be in the approved list
      expect(find.text('Stage 5: Bespoke Joinery & Modular Kitchen Fabrication'), findsNothing);
      // Stage 4 approved milestone should be visible
      expect(find.text('Stage 4: Italian Marble Flooring & Wall Cladding'), findsOneWidget);

      // Switch to Action Required tab
      final actionRequiredTab = find.textContaining('Action Required (');
      expect(actionRequiredTab, findsOneWidget);
      await tester.tap(actionRequiredTab);
      await tester.pumpAndSettle();

      // Pending stages visible again
      expect(find.text('Stage 5: Bespoke Joinery & Modular Kitchen Fabrication'), findsOneWidget);
      expect(find.text('Stage 4: Italian Marble Flooring & Wall Cladding'), findsNothing);
    });

    testWidgets('Expands and collapses stage criteria checklist',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      final expandBtn = find.textContaining('View All 4 Engineering Checkpoints');
      expect(expandBtn, findsOneWidget);

      await tester.tap(expandBtn);
      await tester.pumpAndSettle();

      // Checklist items now shown
      expect(find.text('HDHMR board moisture content verified at 8.2% (Standard < 10.5%)'), findsOneWidget);
      expect(find.textContaining('Show Fewer Technical Checkpoints'), findsOneWidget);

      // Collapse back
      await tester.tap(find.textContaining('Show Fewer Technical Checkpoints'));
      await tester.pumpAndSettle();

      expect(find.textContaining('View All 4 Engineering Checkpoints'), findsOneWidget);
    });

    testWidgets('Opens Digital Sign-Off modal, checks compliance, and completes sign-off',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      final signOffButtons = find.text('Approve & Sign Digitally');
      expect(signOffButtons, findsWidgets);

      // Tap first sign off button (Stage 5)
      await tester.tap(signOffButtons.first);
      await tester.pumpAndSettle();

      // Check modal content
      expect(find.text('Digital Sign-Off Confirmation'), findsOneWidget);
      expect(find.text('AUTHORIZATION SUMMARY'), findsOneWidget);

      // Checkbox should be unselected initially
      final checkboxFinder = find.byType(Checkbox);
      expect(checkboxFinder, findsOneWidget);
      await tester.tap(checkboxFinder);
      await tester.pumpAndSettle();

      // Confirm sign off button should be active now
      final confirmBtn = find.text('Sign & Approve Stage');
      expect(confirmBtn, findsOneWidget);
      await tester.tap(confirmBtn);
      await tester.pumpAndSettle();

      // Dialog is dismissed and confirmation SnackBar is triggered
      expect(find.text('Digital Sign-Off Confirmation'), findsNothing);
      expect(find.textContaining('approved and digitally certified!'), findsOneWidget);
    });

    testWidgets('Opens Modification Request modal and submits feedback remarks',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      final revisionButtons = find.text('Request Modification');
      expect(revisionButtons, findsWidgets);

      await tester.tap(revisionButtons.first);
      await tester.pumpAndSettle();

      // Modal is presented
      expect(find.text('Request Stage Modification'), findsOneWidget);
      expect(find.text('Notes & Snag Details'), findsOneWidget);

      // Type remarks
      await tester.enterText(
        find.byType(TextField),
        'Please re-verify the soft close tension on the pantry cabinet.',
      );
      await tester.pumpAndSettle();

      // Submit
      final submitBtn = find.text('Submit Request');
      expect(submitBtn, findsOneWidget);
      await tester.tap(submitBtn);
      await tester.pumpAndSettle();

      // Modal dismissed and confirmation SnackBar shown
      expect(find.text('Request Stage Modification'), findsNothing);
      expect(find.text('Modification request dispatched to supervisor!'), findsOneWidget);
    });

    testWidgets('Opens Certificate Viewer dialog for approved milestones',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Switch to Approved tab so an approved card is directly in view
      final approvedTab = find.textContaining('Approved & Certified (');
      await tester.tap(approvedTab);
      await tester.pumpAndSettle();

      final certificateButtons = find.text('View Certificate');
      expect(certificateButtons, findsWidgets);

      await tester.ensureVisible(certificateButtons.first);
      await tester.tap(certificateButtons.first);
      await tester.pumpAndSettle();

      // Certificate modal visible
      expect(find.text('Stage Completion Certificate'), findsOneWidget);
      expect(find.text('Download PDF'), findsOneWidget);

      await tester.tap(find.text('Download PDF'));
      await tester.pumpAndSettle();

      expect(find.text('Stage Completion Certificate'), findsNothing);
      expect(find.text('Certificate PDF downloaded successfully!'), findsOneWidget);
    });
  });
}
