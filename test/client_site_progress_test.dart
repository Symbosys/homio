import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:client/features/client/site_progress/index.dart';

void main() {
  group('Live Site Progress Domain Models & Data Integrity Tests', () {
    test('SiteMilestone model stores stage progression and status', () {
      const milestone = SiteMilestone(
        stageNumber: 5,
        title: 'Bespoke Joinery & Modular Kitchen',
        category: 'Carpentry (Active)',
        progressPercent: 75,
        status: MilestoneStatus.inProgress,
        completionDate: 'Est. Sep 18 (On Time)',
        checklistCompleted: 7,
        checklistTotal: 9,
      );

      expect(milestone.stageNumber, 5);
      expect(milestone.isInProgress, isTrue);
      expect(milestone.isCompleted, isFalse);
      expect(milestone.progressPercent, 75);
    });

    test('SiteCadenceInfo model calculates health cadence accurately', () {
      const cadence = SiteCadenceInfo(
        lastVisitDate: 'Sep 01, 2026',
        lastVisitAuthor: 'Ar. Sameer Mehta (Sr. PM) & Client',
        daysSinceLastVisit: 4,
        maxAllowedCadenceDays: 10,
        activeSprintCompletedTasks: 18,
        activeSprintTotalTasks: 21,
      );

      expect(cadence.daysSinceLastVisit, 4);
      expect(cadence.isCadenceHealthy, isTrue);
      expect(cadence.activeSprintCompletedTasks, 18);
    });

    test('SiteFeedMedia model stores inspection photo/video attributes', () {
      const media = SiteFeedMedia(
        id: 'feed_1',
        title: 'German Tandem Box & Carcase Laser Level Check',
        zone: 'Kitchen',
        timestamp: 'Today, 11:30 AM',
        mediaType: MediaType.video,
        duration: '0:48 min',
        authorName: 'Rajesh Verma',
        authorRole: 'Site Execution Supervisor',
        caption: 'Installed Häfele soft-close undermount sliders.',
        tags: ['#ModularKitchen', '#HafeleHardware'],
        placeholderGradientStart: Color(0xFF1E3A8A),
        placeholderGradientEnd: Color(0xFF0F172A),
      );

      expect(media.zone, 'Kitchen');
      expect(media.mediaType, MediaType.video);
      expect(media.tags, contains('#ModularKitchen'));
    });
  });

  group('Live Site Progress Widget & Layout Tests', () {
    Widget createWidgetUnderTest() {
      return const MaterialApp(
        home: ClientSiteProgressPage(),
      );
    }

    testWidgets('ClientSiteProgressPage renders all core sections on desktop (1440x900)',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Section 1: Executive Overview Header
      expect(find.text('Live Site Progress'), findsOneWidget);
      expect(find.text('Skyline Villa Penthouse 402, Worli • 4 BHK Luxury'), findsOneWidget);
      expect(find.text('74% Completed'), findsOneWidget);
      expect(find.text('On Schedule • 0 Days Delay'), findsOneWidget);

      // Section 2: Physical Site Inspection & Sprint Cadence Card
      expect(find.text('Physical Site Inspection & Sprint Cadence'), findsOneWidget);
      expect(find.text('10-Day Policy Compliant'), findsOneWidget);
      expect(find.text('Last Physical Inspection'), findsOneWidget);
      expect(find.text('4 Days Ago'), findsOneWidget);
      expect(find.text('Audit Cadence Status'), findsOneWidget);
      expect(find.text('Healthy (< 10 Days)'), findsOneWidget);
      expect(find.text('Stage 5 Sprint Tasks'), findsOneWidget);
      expect(find.text('18 of 21 Done'), findsOneWidget);
      expect(find.text('Log Site Observation / Snag'), findsOneWidget);

      // Section 3: Milestone Pipeline Section
      expect(find.text('Stage Progression & Timeline Tracker'), findsOneWidget);
      expect(find.text('Stage 5 of 8 Active'), findsOneWidget);
      expect(find.text('Stage 1: Civil Demolition & Core Masonry'), findsOneWidget);
      expect(find.text('Stage 5: Bespoke Joinery & Modular Kitchen'), findsOneWidget);

      // Section 4: Daily Inspection Feed Section
      expect(find.text('Daily Supervisor Inspection Feed'), findsOneWidget);
      expect(find.text('German Tandem Box & Carcase Laser Level Check'), findsOneWidget);

      // Section 5: Stage 5 Quality Checklist & Milestone Approval
      expect(find.text('Stage 5 Quality Assurance & Sign-Off Checklist'), findsOneWidget);
      expect(find.text('4 of 4 Verified'), findsOneWidget);
      expect(find.text('HDHMR Board Moisture Level < 10.5%'), findsOneWidget);
      expect(find.text('Approve & Sign Stage 5'), findsOneWidget);
    });

    testWidgets('ClientSiteProgressPage renders smoothly on mobile viewport (390x844)',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('Live Site Progress'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('ClientSiteProgressPage opens Digital Milestone Sign-off dialog and approves',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1200, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      final approveBtn = find.text('Approve & Sign Stage 5');
      expect(approveBtn, findsOneWidget);
      await tester.ensureVisible(approveBtn);
      await tester.tap(approveBtn);
      await tester.pumpAndSettle();

      expect(find.text('Approve Stage 5 Milestone'), findsOneWidget);
      expect(find.text('Bespoke Joinery & Modular Kitchen Sign-Off'), findsOneWidget);

      final confirmBtn = find.text('Confirm & Sign Digitally');
      expect(confirmBtn, findsOneWidget);
      await tester.tap(confirmBtn);
      await tester.pumpAndSettle();

      expect(find.text('DIGITALLY SIGNED'), findsOneWidget);
    });

    testWidgets('ClientSiteProgressPage opens Report Snag dialog and submits ticket',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1200, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      final snagBtn = find.text('Log Site Observation / Snag');
      expect(snagBtn, findsOneWidget);
      await tester.ensureVisible(snagBtn);
      await tester.tap(snagBtn);
      await tester.pumpAndSettle();

      expect(find.text('Report Site Snag / Observation'), findsOneWidget);
      expect(find.text('Joinery / Alignment'), findsWidgets);

      final submitBtn = find.text('Submit Snag Ticket');
      expect(submitBtn, findsOneWidget);
      await tester.tap(submitBtn);
      await tester.pumpAndSettle();

      expect(find.text('Report Site Snag / Observation'), findsNothing);
    });

    testWidgets('ClientSiteProgressPage filters daily inspection feed by zone',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1200, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Tap "Balcony" zone filter tab
      final balconyFilter = find.text('Balcony').first;
      expect(balconyFilter, findsOneWidget);
      await tester.ensureVisible(balconyFilter);
      await tester.pumpAndSettle();
      await tester.tap(balconyFilter);
      await tester.pumpAndSettle();

      // Balcony item should be visible
      expect(find.text('Balcony Deck Ipe Hardwood Sub-Frame Prep'), findsOneWidget);

      // Switch back to "All Zones"
      final allFilter = find.text('All Zones');
      expect(allFilter, findsOneWidget);
      await tester.ensureVisible(allFilter);
      await tester.pumpAndSettle();
      await tester.tap(allFilter);
      await tester.pumpAndSettle();

      expect(find.text('German Tandem Box & Carcase Laser Level Check'), findsOneWidget);
    });

    testWidgets('ClientSiteProgressPage opens full-screen Media Viewer modal on card tap',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1200, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Find first feed item card
      final firstCard = find.text('German Tandem Box & Carcase Laser Level Check');
      expect(firstCard, findsOneWidget);
      await tester.ensureVisible(firstCard);
      await tester.pumpAndSettle();
      await tester.tap(firstCard);
      await tester.pumpAndSettle();

      // Modal dialog opened with zone tag
      expect(find.text('Zone: Kitchen'), findsOneWidget);
      expect(find.text('#HafeleHardware'), findsOneWidget);

      // Close modal
      final closeBtn = find.byIcon(Icons.close_rounded);
      expect(closeBtn, findsOneWidget);
      await tester.tap(closeBtn);
      await tester.pumpAndSettle();

      expect(find.text('Zone: Kitchen'), findsNothing);
    });

    testWidgets('ClientSiteProgressPage opens Request Site Visit dialog and submits request',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1200, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Tap "Request Site Visit" button in header
      final requestBtn = find.widgetWithText(ElevatedButton, 'Request Site Visit');
      expect(requestBtn, findsOneWidget);
      await tester.tap(requestBtn);
      await tester.pumpAndSettle();

      // Modal opened
      expect(find.text('Select Preferred Time Slot'), findsOneWidget);

      // Submit visit
      final confirmBtn = find.widgetWithText(ElevatedButton, 'Confirm Visit Request');
      expect(confirmBtn, findsOneWidget);
      await tester.tap(confirmBtn);
      await tester.pumpAndSettle();

      // Modal closed and SnackBar shown
      expect(find.text('Select Preferred Time Slot'), findsNothing);
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.textContaining('Site visit requested'), findsOneWidget);
    });
  });
}
