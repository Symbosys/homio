import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:client/features/client/feedback_ratings/index.dart';

void main() {
  group('Feedback & Ratings Domain Models Tests', () {
    test('MilestoneRating and SpecialistScorecard models store correct parameters', () {
      const rev = MilestoneRating(
        id: 'test_rev_1',
        stageName: 'Stage 4: Flooring',
        completedDate: 'Aug 28, 2026',
        overallScore: 4.9,
        designScore: 5.0,
        executionScore: 4.8,
        supervisorScore: 5.0,
        materialScore: 4.9,
        clientReview: 'Exceptional finish.',
        praiseTags: ['#ImpeccableFinish'],
        supervisorName: 'Rajesh Verma',
        designerName: 'Pooja Hegde',
      );

      expect(rev.overallScore, 4.9);
      expect(rev.status, 'Verified Sign-off');
      expect(rev.praiseTags.first, '#ImpeccableFinish');

      final spec = SpecialistScorecard(
        id: 'spec_test',
        name: 'Pooja Hegde',
        role: 'Lead Interior Designer',
        avatarColor: const Color(0xFF8B5CF6),
        initials: 'PH',
        score: 5.0,
        reviewsCount: 18,
        topPraise: 'Flawless designs',
        parameters: {'Aesthetics': 5.0},
      );

      expect(spec.score, 5.0);
      spec.score = 4.9;
      spec.reviewsCount += 1;
      expect(spec.score, 4.9);
      expect(spec.reviewsCount, 19);
    });

    test('WeeklyCsatLog model stores Friday automated check-in details', () {
      const log = WeeklyCsatLog(
        weekLabel: 'Week 8',
        date: 'Aug 29, 2026',
        score: 5.0,
        mood: 'Delighted',
        moodColor: Color(0xFF10B981),
        comment: 'Great work',
      );

      expect(log.score, 5.0);
      expect(log.mood, 'Delighted');
      expect(log.channel, contains('WhatsApp'));
    });
  });

  group('Feedback & 360° Ratings Widget & UI Tests', () {
    Widget createWidgetUnderTest() {
      return const MaterialApp(
        home: ClientFeedbackRatingsPage(),
      );
    }

    testWidgets('Renders desktop layout with header, 360 scorecard, 4 pillars, and reviews',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1600, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Header
      expect(find.text('Feedback & 360° Ratings'), findsOneWidget);
      expect(find.text('AUDITED & VERIFIED'), findsOneWidget);
      expect(find.text('Submit Stage Feedback'), findsOneWidget);
      expect(find.text('Request Director Review'), findsOneWidget);

      // 360° Scorecard Hero
      expect(find.text('Overall Project Execution Index'), findsOneWidget);
      expect(find.text('4.9'), findsWidgets);
      expect(find.text('Design & Architecture'), findsOneWidget);
      expect(find.text('Site Workmanship'), findsOneWidget);
      expect(find.text('Supervisor & Crew'), findsOneWidget);
      expect(find.text('Material Quality'), findsOneWidget);

      // Sub-Tabs
      expect(find.text('Milestone Reviews'), findsOneWidget);
      expect(find.text('Specialists 360°'), findsOneWidget);
      expect(find.text('Weekly CSAT Pulse'), findsOneWidget);

      // Initial Milestone Review Cards
      expect(find.text('Stage 4: Italian Marble Flooring & Wall Cladding'), findsOneWidget);
      expect(find.text('Stage 3: Gypsum False Ceiling & Cove Lighting'), findsOneWidget);

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

      expect(find.text('Feedback & 360° Ratings'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('Opens Submit Stage Feedback dialog, rates dimensions, and submits',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1600, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Tap 'Submit Stage Feedback' button
      final submitBtn = find.widgetWithText(FilledButton, 'Submit Stage Feedback');
      expect(submitBtn, findsOneWidget);
      await tester.tap(submitBtn);
      await tester.pumpAndSettle();

      expect(find.text('Submit Milestone Feedback'), findsOneWidget);
      expect(find.text('Rate the 4 Quality Dimensions'), findsOneWidget);

      // Select praise tag
      final tag = find.widgetWithText(FilterChip, '#PunctualDelivery');
      expect(tag, findsOneWidget);
      await tester.tap(tag);
      await tester.pumpAndSettle();

      // Submit review
      final confirmBtn = find.widgetWithText(FilledButton, 'Submit Review');
      expect(confirmBtn, findsOneWidget);
      await tester.tap(confirmBtn);
      await tester.pumpAndSettle();

      // Newly submitted review should appear
      expect(find.text('Stage 5: Modular Kitchen Joinery Sign-off'), findsOneWidget);
      expect(find.textContaining('Feedback submitted successfully'), findsOneWidget);
    });

    testWidgets('Switching to Specialists 360° displays scorecards and opens rating dialog',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1600, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Tap Specialists 360° tab
      final specTab = find.text('Specialists 360°');
      expect(specTab, findsOneWidget);
      await tester.tap(specTab);
      await tester.pumpAndSettle();

      // Check all 4 specialists are rendered
      expect(find.text('Pooja Hegde'), findsOneWidget);
      expect(find.text('Rajesh Verma'), findsOneWidget);
      expect(find.text('Vikram Malhotra'), findsOneWidget);
      expect(find.text('Ar. Sameer Mehta'), findsOneWidget);

      // Tap 'Rate Pooja'
      final rateBtn = find.text('Rate Pooja');
      expect(rateBtn, findsOneWidget);
      await tester.tap(rateBtn);
      await tester.pumpAndSettle();

      expect(find.text('Rate Pooja Hegde'), findsOneWidget);
      expect(find.text('Submit Rating'), findsOneWidget);

      await tester.tap(find.text('Submit Rating'));
      await tester.pumpAndSettle();

      expect(find.textContaining('Your rating for Pooja Hegde has been updated'), findsOneWidget);
    });

    testWidgets('Switching to Weekly CSAT Pulse displays Friday logs',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1600, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Tap Weekly CSAT Pulse tab
      final csatTab = find.text('Weekly CSAT Pulse');
      expect(csatTab, findsOneWidget);
      await tester.tap(csatTab);
      await tester.pumpAndSettle();

      expect(find.text('Week 8 (Aug 25 - Aug 31)'), findsOneWidget);
      expect(find.text('Week 7 (Aug 18 - Aug 24)'), findsOneWidget);
      expect(find.textContaining('Automated Friday WhatsApp Pulse'), findsOneWidget);
    });

    testWidgets('Opens Director Priority Escalation dialog and requests priority callback',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1600, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      final directorBtn = find.widgetWithText(OutlinedButton, 'Request Director Review');
      expect(directorBtn, findsOneWidget);
      await tester.tap(directorBtn);
      await tester.pumpAndSettle();

      expect(find.text('Director Priority Escalation'), findsOneWidget);
      expect(find.text('Request Priority Callback'), findsOneWidget);

      await tester.tap(find.text('Request Priority Callback'));
      await tester.pumpAndSettle();

      expect(find.textContaining('Priority escalation dispatched to Ar. Sameer Mehta'), findsOneWidget);
    });
  });
}
