import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:client/features/client/snags_complaints/index.dart';

void main() {
  group('Snags & Complaints Domain Models Tests', () {
    test('SnagTicket model computes status flags and formatting correctly', () {
      final ticket = SnagTicket(
        id: 'SNG-TEST-001',
        title: 'Wardrobe Hinge Issue',
        roomLocation: 'Master Bedroom',
        category: SnagCategory.qualityDefect,
        severity: SnagSeverity.moderate,
        status: SnagStatus.inProgress,
        reportedDate: 'Sep 04, 2026',
        slaTargetTime: 'Sep 06, 2026 • 02:00 PM',
        slaRemainingHours: 24,
        isSlaMet: true,
        assignedTechnician: 'Rajesh Verma',
        technicianRole: 'Site Execution Supervisor',
        technicianPhone: '+91 98201 44521',
        description: 'Hinge is misaligned',
        attachments: ['photo1.jpg'],
        timeline: const [
          SnagTimelineEvent(
            title: 'Logged',
            timestamp: 'Sep 04',
            actor: 'Client',
          )
        ],
      );

      expect(ticket.isOpen, false);
      expect(ticket.isInProgress, true);
      expect(ticket.isResolved, false);

      ticket.status = SnagStatus.resolved;
      expect(ticket.isResolved, true);
    });

    test('Snag Enums provide correct labels and colors', () {
      expect(SnagCategory.qualityDefect.label, 'Quality Defect');
      expect(SnagCategory.timelineDelay.label, 'Timeline Delay');
      expect(SnagCategory.workerBehaviour.label, 'Worker Behaviour');
      expect(SnagCategory.siteCleanliness.label, 'Site Cleanliness');
      expect(SnagCategory.materialDeviation.label, 'Material Deviation');

      expect(SnagSeverity.critical.label, contains('Critical'));
      expect(SnagSeverity.moderate.label, contains('Moderate'));
      expect(SnagSeverity.minor.label, contains('Minor'));

      expect(SnagStatus.open.label, 'Open');
      expect(SnagStatus.inProgress.label, 'In Progress');
      expect(SnagStatus.resolved.label, 'Resolved');
    });

    test('WarrantyCoverage and MaintenanceVisit models hold valid warranty data', () {
      const war = WarrantyCoverage(
        id: 'test_war_1',
        title: '10-Year Core Structural',
        duration: '10 Years',
        validUntil: '2036',
        icon: Icons.shield_rounded,
        color: Color(0xFF10B981),
        coveredItems: ['PU waterproofing', 'RCC modification'],
        certificateNumber: 'HOMIO-WAR-10Y-STR-9821',
      );

      final visit = MaintenanceVisit(
        id: 'maint_test',
        title: 'Routine 30-Day Checkup',
        milestone: 'Month 1',
        scheduledDate: 'Sep 28, 2026',
        timeWindow: '10:00 AM - 01:00 PM',
        leadEngineer: 'Rajesh Verma',
        engineerContact: '+91 98201 44521',
      );

      expect(war.maxClaims, 5);
      expect(war.coveredItems.length, 2);
      expect(visit.isConfirmed, true);
      expect(visit.isCompleted, false);
    });
  });

  group('Snags & Complaints Widget & UI Tests', () {
    Widget createWidgetUnderTest() {
      return const MaterialApp(
        home: ClientSnagsComplaintsPage(),
      );
    }

    testWidgets('Renders desktop layout with header, metrics, sub-tabs, and tickets',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1600, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Executive Header
      expect(find.text('Snags & Complaints Hub'), findsOneWidget);
      expect(find.text('48-HR SLA ACTIVE'), findsOneWidget);
      expect(find.text('Raise Snag Ticket'), findsOneWidget);
      expect(find.text('Warranty Certificate'), findsOneWidget);

      // KPI Metrics Strip
      expect(find.text('Active Snags'), findsOneWidget);
      expect(find.text('Resolved Tickets'), findsOneWidget);
      expect(find.text('Average Resolution'), findsOneWidget);
      expect(find.text('Warranty Protection'), findsOneWidget);

      // Sub-Tabs
      expect(find.text('Snag Tickets'), findsOneWidget);
      expect(find.text('10-Year Warranty Hub'), findsOneWidget);
      expect(find.text('Maintenance Dispatch'), findsOneWidget);

      // Initial Tickets List
      expect(find.text('Master Bedroom Wardrobe Soft-Close Hinge Misalignment'), findsOneWidget);
      expect(find.text('Balcony Corner Tile Grout Washout After Monsoons'), findsOneWidget);

      expect(tester.takeException(), isNull);
    });

    testWidgets('Renders cleanly on mobile viewport (390x844) with zero exceptions',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('Snags & Complaints Hub'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('Filters snag tickets by status chip (Open, In Progress, Resolved)',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1600, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Tap 'Open' filter
      final openChip = find.widgetWithText(ChoiceChip, 'Open');
      expect(openChip, findsOneWidget);
      await tester.tap(openChip);
      await tester.pumpAndSettle();

      expect(find.text('Balcony Corner Tile Grout Washout After Monsoons'), findsOneWidget);
      expect(find.text('Dining Area False Ceiling Paint Touch-up'), findsNothing);

      // Tap 'Resolved' filter
      final resolvedChip = find.widgetWithText(ChoiceChip, 'Resolved');
      expect(resolvedChip, findsOneWidget);
      await tester.tap(resolvedChip);
      await tester.pumpAndSettle();

      expect(find.text('Dining Area False Ceiling Paint Touch-up'), findsOneWidget);
      expect(find.text('Modular Kitchen Chimney Duct Vibration'), findsOneWidget);
      expect(find.text('Balcony Corner Tile Grout Washout After Monsoons'), findsNothing);
    });

    testWidgets('Opens Snag Details dialog and marks ticket as resolved',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1600, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Tap on the in-progress wardrobe hinge card
      final ticketCard = find.text('Master Bedroom Wardrobe Soft-Close Hinge Misalignment');
      expect(ticketCard, findsOneWidget);
      await tester.tap(ticketCard);
      await tester.pumpAndSettle();

      // Dialog should be open
      expect(find.text('RESOLUTION TIMELINE'), findsOneWidget);
      expect(find.text('Mark Satisfactorily Resolved'), findsOneWidget);

      // Tap 'Mark Satisfactorily Resolved'
      await tester.tap(find.text('Mark Satisfactorily Resolved'));
      await tester.pumpAndSettle();

      // Verify SnackBar confirmation
      expect(find.textContaining('marked as satisfactorily resolved'), findsOneWidget);
    });

    testWidgets('Opens Raise Snag Ticket dialog, enters data and logs new ticket',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1600, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Tap 'Raise Snag Ticket' button
      final raiseBtn = find.widgetWithText(FilledButton, 'Raise Snag Ticket');
      expect(raiseBtn, findsOneWidget);
      await tester.tap(raiseBtn);
      await tester.pumpAndSettle();

      // Fill in headline
      final headlineField = find.widgetWithText(TextField, 'e.g. Wardrobe drawer hinge is loose');
      expect(headlineField, findsOneWidget);
      await tester.enterText(headlineField, 'Balcony Sliding Door Latch Loose');

      // Submit
      final submitBtn = find.widgetWithText(FilledButton, 'Submit Ticket');
      expect(submitBtn, findsOneWidget);
      await tester.tap(submitBtn);
      await tester.pumpAndSettle();

      // Verify newly created ticket appears
      expect(find.text('Balcony Sliding Door Latch Loose'), findsOneWidget);
      expect(find.textContaining('logged! Assigned to Rajesh Verma'), findsOneWidget);
    });

    testWidgets('Switching to 10-Year Warranty Hub displays certificate and warranty pillars',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1600, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Tap Warranty Hub tab
      final warTab = find.text('10-Year Warranty Hub');
      expect(warTab, findsOneWidget);
      await tester.tap(warTab);
      await tester.pumpAndSettle();

      expect(find.text('Homio 10-Year Turnkey Warranty Guarantee'), findsOneWidget);
      expect(find.text('CERT ID: HOMIO-2026-WAR-8819'), findsOneWidget);
      expect(find.text('Download Certificate (PDF)'), findsOneWidget);
      expect(find.text('10-Year Core Structural & Waterproofing'), findsOneWidget);
      expect(find.text('10-Year Anti-Termite & Modular Woodwork'), findsOneWidget);
      expect(find.text('5-Year European Architectural Hardware'), findsOneWidget);
      expect(find.text('2-Year Electrical & Concealed Plumbing'), findsOneWidget);

      // Tap download certificate
      await tester.tap(find.text('Download Certificate (PDF)'));
      await tester.pumpAndSettle();
      expect(find.textContaining('Downloading Official 10-Year Digital Warranty Certificate'), findsOneWidget);
    });

    testWidgets('Switching to Maintenance Dispatch displays scheduled visits and allows booking',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1600, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Tap Maintenance Dispatch tab
      final maintTab = find.text('Maintenance Dispatch');
      expect(maintTab, findsOneWidget);
      await tester.tap(maintTab);
      await tester.pumpAndSettle();

      expect(find.text('Post-Handover Maintenance Schedule'), findsOneWidget);
      expect(find.text('Post-Handover 30-Day Checkup'), findsOneWidget);
      expect(find.text('Book Visit'), findsOneWidget);

      // Tap Book Visit
      await tester.tap(find.widgetWithText(FilledButton, 'Book Visit'));
      await tester.pumpAndSettle();

      expect(find.text('Request Maintenance Dispatch'), findsOneWidget);
      expect(find.text('Confirm Dispatch'), findsOneWidget);

      await tester.tap(find.text('Confirm Dispatch'));
      await tester.pumpAndSettle();

      expect(find.textContaining('Technician dispatch confirmed'), findsOneWidget);
    });
  });
}
